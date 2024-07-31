# Report - COL719 - Assignment 1
### Harshit Mawandia - 2020CS10348

## Overview
This project provides a Python implementation for generating Data Flow Graphs (DFG) from a set of expressions. It includes parsing expressions into Abstract Syntax Trees (ASTs), building DFGs to visualize data dependencies, and supports variable versioning for acyclicity.


## Instructions to run the code

The code is written in Python 3.8.10. The code can be run using the following command:
```
sudo apt-get update && sudo apt-get upgrade
sudo apt-get install python3.8 python3.8-venv
sudo apt-get install graphviz 
sudo apt-get -y install xdg-utils
sudo apt-get install python3-tk
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python3 main.py <input_file>
```

## Design Specifications
<b>Variable Versioning</b>: Tracks updates to variables, ensuring each version is unique within the DFG to maintain acyclicity during WAW/WAR dependencies.

<b>Node Types</b>: Differentiates between variables, constants, and operations as distinct nodes.

<b>Visualization</b>: Offers two methods for visualization; Matplotlib for inline display and Graphviz for external, detailed graphs.