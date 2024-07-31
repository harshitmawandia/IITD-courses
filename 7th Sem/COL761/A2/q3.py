import numpy as np
from scipy.cluster.hierarchy import linkage, dendrogram
from scipy.spatial.distance import pdist, squareform
import matplotlib.pyplot as plt

# Define a function to visualize the matrix
def plot_matrix(mat, labels):
    fig, ax = plt.subplots()
    ax.imshow(mat, cmap='viridis')
    
    # Draw lines to separate cells
    ax.vlines(np.arange(-0.5, len(labels), 1), -0.5, len(labels)-0.5, color='white', linewidth=1)
    ax.hlines(np.arange(-0.5, len(labels), 1), -0.5, len(labels)-0.5, color='white', linewidth=1)
    
    # Label cells with their values
    for i in range(len(labels)):
        for j in range(len(labels)):
            ax.text(j, i, '{:.2f}'.format(mat[i, j]), ha='center', va='center', color='white', fontsize=8)

    # Set the labels for the rows and columns
    ax.set_xticks(np.arange(len(labels)))
    ax.set_yticks(np.arange(len(labels)))
    ax.set_xticklabels(labels)
    ax.set_yticklabels(labels)
    plt.xticks(rotation=90)
    plt.show()

# Generate some sample data
data = [(0.40,0.53),(0.22,0.38),(0.35,0.32),(0.26,0.19),(0.08,0.41),(0.45,0.30)]

# Compute the initial distance matrix
initial_distances = pdist(data, metric='euclidean')
distance_matrix = squareform(initial_distances)

# Visualize the initial matrix
print("Initial Distance Matrix:")
plot_matrix(distance_matrix, labels=[f'P{i+1}' for i in range(len(data))])

# Perform single linkage clustering
linkage_matrix = linkage(data, method='single', metric='euclidean')
print("Linkage Matrix:")
print(linkage_matrix)

labels = [f'P{i+1}' for i in range(len(data))]

# This dictionary will maintain the mapping between the cluster indices (from linkage_matrix) 
# and the current indices in our distance_matrix.
index_map = {i: i for i in range(len(data))}
next_cluster_idx = len(data)

cluster_map = {i: [i] for i in range(len(data))}

for i, (idx1, idx2, dist, cluster_size) in enumerate(linkage_matrix):
    print(idx1, idx2, dist, cluster_size)
    print(index_map)

    idx1, idx2 = int(idx1), int(idx2)  # Explicitly cast to integers
    
    # Get the mapped indices
    mapped_idx1 = index_map[idx1]
    mapped_idx2 = index_map[idx2]

    current_shape = distance_matrix.shape[0]  # Save current shape before removing

    # Calculate new distances to the newly merged cluster
    new_distances = [min(distance_matrix[mapped_idx1, j], distance_matrix[mapped_idx2, j]) for j in range(current_shape) if j not in [mapped_idx1, mapped_idx2]]

    # Remove rows and columns corresponding to merged clusters
    distance_matrix = np.delete(distance_matrix, [mapped_idx1, mapped_idx2], axis=0)
    distance_matrix = np.delete(distance_matrix, [mapped_idx1, mapped_idx2], axis=1)

    # Add the new cluster distances to the matrix
    distance_matrix = np.vstack([distance_matrix, new_distances])
    new_distances.append(0)  # the distance to itself is 0
    distance_matrix = np.hstack([distance_matrix, np.array([new_distances]).T])

    # Update the labels list
    for idx in sorted([mapped_idx1, mapped_idx2], reverse=True):
        labels.pop(idx)
    new_label = f'C{next_cluster_idx}={[i+1 for i in cluster_map[idx1]+cluster_map[idx2]]}'
    labels.append(new_label)
    
    # Update the index_map to account for the new merged cluster
    del index_map[idx1]
    del index_map[idx2]
    for i, key in enumerate(index_map.keys()):
        index_map[key] = i
    index_map[next_cluster_idx] = current_shape - 2  # -2 because we removed two rows/columns
    cluster_map[next_cluster_idx] = cluster_map[idx1] + cluster_map[idx2]
    next_cluster_idx += 1
    
    # Display the updated distance matrix for this iteration
    print(f"\nDistance Matrix After Merging Cluster {idx1+1} and Cluster {idx2+1}:")
    plot_matrix(distance_matrix, labels)

# Create a dendrogram
plt.figure(figsize=(10, 6))
dendrogram_labels = [f"P{i+1}={datum}" for i, datum in enumerate(data)]
plt.yticks([])
dendrogram(linkage_matrix, labels=dendrogram_labels, orientation='top', leaf_font_size=10)
plt.show()
