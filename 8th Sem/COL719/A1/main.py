class Node:
    def __init__(self, value, children=None):
        self.value = value
        self.children = children if children is not None else []

    def add_child(self, child):
        self.children.append(child)

def parse_expression(expr):
    tokens = expr.split()
    # First pass: handle * and /   "a = b + c + d - 5" (= (a (b + c + d - 5)))
    stack = []
    current_node = None
    i = 0
    while i < len(tokens):
        token = tokens[i]
        if token in ['*', '/']:
            left = stack.pop() if stack else current_node
            i += 1
            right = Node(tokens[i])
            current_node = Node(token, [left, right])
            stack.append(current_node)
        else:
            stack.append(Node(token))
        i += 1


    # Second pass: handle + and -
    root = stack.pop(0)
    while stack:
        print([node.value for node in stack])
        token = stack.pop(0)
        if token.value in ['+', '-', '–']:
            if token.value == '–':
                token.value = '-'  # Normalize
            left = root
            right = stack.pop(0)
            root = Node(token.value, [left, right])
        else:
            root = token  # In case there's a single node left

    return root


def build_ast(lines):
    asts = []
    for line in lines:
        lhs, rhs = line.split('=')
        expr_tree = parse_expression(rhs.strip())
        assignment_tree = Node('=', [Node(lhs.strip()), expr_tree])
        asts.append(assignment_tree)
    return asts


def print_ast(ast, indent=0):
    print(' ' * indent + ast.value)
    for child in ast.children:
        print_ast(child, indent + 4)

# we now have to build Data flow Graphs

class DFGNode:
    def __init__(self, name):
        self.name = name
        self.children: list[DFGNode] = []
        self.parents: list[DFGNode] = []

    def add_child(self, child):
        self.children.append(child)

    def add_parent(self, parent):
        self.parents.append(parent)

class DataFlowGraph:
    def __init__(self):
        self.variable_versions = {}
        self.nodes = {}
        self.operational_nodes = []

    def is_operation(self, value):
        return value in ['+', '-', '*', '/']

    def ast_to_dfg(self, ast: Node) -> DFGNode:
        if ast.value == '=':
            operational_node = DFGNode(ast.children[1].value)
            self.operational_nodes.append(operational_node)
            node1 = self.ast_to_dfg(ast.children[1].children[0])
            node2 = self.ast_to_dfg(ast.children[1].children[1])
            operational_node.add_parent(node1)
            node1.add_child(operational_node)
            operational_node.add_parent(node2)
            node2.add_child(operational_node)
            if ast.children[0].value not in self.variable_versions:
                self.variable_versions[ast.children[0].value] = 1
                self.nodes[ast.children[0].value + '_1'] = DFGNode(ast.children[0].value + '_1')
                curr_node: DFGNode = self.nodes[ast.children[0].value + '_1']
            else:
                self.variable_versions[ast.children[0].value] += 1
                self.nodes[ast.children[0].value + '_' + str(self.variable_versions[ast.children[0].value])] = DFGNode(ast.children[0].value + '_' + str(self.variable_versions[ast.children[0].value]))
                curr_node: DFGNode = self.nodes[ast.children[0].value + '_' + str(self.variable_versions[ast.children[0].value])]
            print(curr_node.name)
            operational_node.add_child(curr_node)
            curr_node.add_parent(operational_node)
        elif self.is_operation(ast.value):
            operational_node = DFGNode(ast.value)
            self.operational_nodes.append(operational_node)
            for child in ast.children:
                child_node = self.ast_to_dfg(child)
                operational_node.add_parent(child_node)
                child_node.add_child(operational_node)
            return operational_node
        else:
            # Handle variables and constants
            if ast.value.isdigit():  # It's a constant
                node_key = f"const_{ast.value}"
                if node_key not in self.nodes:
                    self.nodes[node_key] = DFGNode(node_key)
                return self.nodes[node_key]
            else:  # It's a variable
                if ast.value not in self.variable_versions:
                    self.variable_versions[ast.value] = 1
                version = self.variable_versions[ast.value]
                node_key = f"{ast.value}_{version}"
                if node_key not in self.nodes:
                    self.nodes[node_key] = DFGNode(node_key)
                return self.nodes[node_key]

        # Fallback for unhandled cases
        return DFGNode("unhandled")

    def visualize_graph(self):
        from graphviz import Digraph
        import os
        os.environ["PATH"] += os.pathsep + 'C:\\Program Files\\Graphviz\\bin'
        dot = Digraph()
        edges = set()
        for index, node in enumerate(self.operational_nodes):
            dot.node(str(index), node.name)
            for child in node.children:
                # find the index of the child if it's an operational node
                if child in self.operational_nodes:
                    child_index = self.operational_nodes.index(child)
                    # check if the edge already exists
                    if (str(index), str(child_index)) not in edges:
                        dot.edge(str(index), str(child_index))
                        edges.add((str(index), str(child_index)))
                else:
                    if (str(index), child.name) not in edges:
                        dot.edge(str(index), child.name)
                        edges.add((str(index), child.name))
            for parent in node.parents:
                if parent in self.operational_nodes:
                    parent_index = self.operational_nodes.index(parent)
                    if (str(parent_index), str(index)) not in edges:
                        dot.edge(str(parent_index), str(index))
                        edges.add((str(parent_index), str(index)))
                else:
                    if (parent.name, str(index)) not in edges:
                        dot.edge(parent.name, str(index))
                        edges.add((parent.name, str(index)))

        dot.render('dfg.gv', view=True)

    def matplotlib_visualize(self):
        import networkx as nx
        import matplotlib.pyplot as plt
        G = nx.DiGraph()
        edges = set()
        nodes = set()
        for index, node in enumerate(self.operational_nodes):
            G.add_node(node, label=node.name)
            nodes.add(node)
            for child in node.children:
                if(child not in nodes):
                    G.add_node(child, label=child.name)
                    nodes.add(child)
                # find the index of the child if it's an operational node
                if child in self.operational_nodes:
                    child_index = self.operational_nodes.index(child)
                    # check if the edge already exists
                    if (node, child) not in edges:
                        G.add_edge(node, child)
                        edges.add((node, child))
                else:
                    if (node, child) not in edges:
                        G.add_edge(node, child)
                        edges.add((node, child))
            for parent in node.parents:
                if(parent not in nodes):
                    G.add_node(parent, label=parent.name)
                    nodes.add(parent)
                if parent in self.operational_nodes:
                    parent_index = self.operational_nodes.index(parent)
                    if (parent, node) not in edges: 
                        G.add_edge(parent, node)
                        edges.add((parent, node))
                else:
                    if (parent, node) not in edges:
                        G.add_edge(parent, node)
                        edges.add((parent, node))
        pos = nx.spring_layout(G)
        # display labels at nodes not the node objects
        labels = {node: node.name for node in G.nodes()}
        nx.draw(G, pos, with_labels=True, labels=labels, node_size=1000, node_color="skyblue", font_size=10, font_weight="bold", font_color="black")
        plt.show()
            
# read the input file from command line argument
import sys
file_name = sys.argv[1]
if not file_name:
    print("Please provide a file name")
    exit()
lines = []

with open(file_name, 'r', encoding='utf-8') as file:
    # read the file line by line
    lines = file.readlines()
    # remove the trailing newline character
    lines = [line.strip() for line in lines]
    # remove empty lines
    lines = [line for line in lines if line]

print(lines)
asts = build_ast(lines)
for ast in asts:
    print_ast(ast)
    print()

dfg = DataFlowGraph()
for ast in asts:
    dfg.ast_to_dfg(ast)

dfg.matplotlib_visualize()
dfg.visualize_graph()

