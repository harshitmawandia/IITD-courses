# Since the tasks involve a series of steps, let's first outline the functions needed to achieve Task 1, 2, and 3.
# We'll implement these functions step by step.

# Here's a high-level outline of the functions we'll need:

# For Task-1:
# 1. Preprocess the image (resize, contrast adjustment, noise reduction, thresholding)
# 2. Apply edge detection (Canny or other methods)
# 3. Filter and refine edges to identify sutures
# 4. Count sutures using connected components or corner detection

# For Task-2:
# 1. Use the output from Task-1 to find centroids of sutures
# 2. Calculate inter-suture spacing based on centroids

# For Task-3:
# 1. Use the centroids from Task-2 to calculate the angle of each suture relative to the x-axis

# We will also need to create a main function that will tie these tasks together and will be callable as specified in the assignment.

# Let's start with Task-1 and implement the preprocessing and edge detection steps.

import cv2
import numpy as np

def preprocess_image(image_path):
    # Load the image
    image = cv2.imread(image_path, cv2.IMREAD_COLOR)

    # crop the image slightly from all edges
    image = image[2:-2, 2:-2]

    
    # Resize the image
    # image = cv2.resize(image, (0, 0), fx=0.9, fy=0.9)
    
    # Adjust contrast if needed (using histogram equalization)
    # img_yuv = cv2.cvtColor(image, cv2.COLOR_BGR2YUV)
    # img_yuv[:,:,0] = cv2.equalizeHist(img_yuv[:,:,0])
    # image = cv2.cvtColor(img_yuv, cv2.COLOR_YUV2BGR)
    
    # Reduce noise
    image = cv2.medianBlur(image, 5)
    
    # Convert to grayscale
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    
    # Apply thresholding
    _, thresh = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY | cv2.THRESH_OTSU)
    
    return thresh

def edge_detection(thresh_image):
    # Apply edge detection
    edges = cv2.Canny(thresh_image, 100, 200)
    return edges

# Test the functions on a sample image
sample_image_path = 'data/img10.png'

preprocessed = preprocess_image(sample_image_path)
edges = edge_detection(preprocessed)

# Display the preprocessed image and the edges for verification
# For actual implementation, this would be saved to a file or passed to the next step
cv2.imwrite('results/preprocessed.png', preprocessed)
cv2.imwrite('results/edges.png', edges)

# Continuing with the implementation for Task-1, we will define functions to filter the edges and count the sutures.

def filter_edges(edges):
    # This function will implement filtering based on size, shape, or other characteristics specific to sutures.
    # For simplicity, we may assume that sutures are the larger connected components in the image.
    # Therefore, we can filter out small components that are likely to be noise.
    
    # Find all contours in the edge image
    contours, _ = cv2.findContours(edges, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    
    # Filter out small contours
    print([cv2.contourArea(cnt) for cnt in contours])
    print(f'total area = {sum([cv2.contourArea(cnt) for cnt in contours])}')
    total_area = sum([cv2.contourArea(cnt) for cnt in contours])

    suture_contours = [cnt for cnt in contours if cv2.contourArea(cnt) > total_area/20]
    print([cv2.contourArea(cnt) for cnt in suture_contours])
    print(f'num contours = {len(suture_contours)}')

    # filter by perimeter
    print([cv2.arcLength(cnt, True) for cnt in contours])
    print(f'total perimeter = {sum([cv2.arcLength(cnt, True) for cnt in contours])}')
    suture_contours = [cnt for cnt in contours if cv2.arcLength(cnt, True) > 100]
    print(f'num contours = {len(suture_contours)}')

    # # dilate the contours to fill the small gaps
    # kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (3, 3))
    # dilated_contours = cv2.dilate(suture_contours, kernel, iterations=1)
    # cv2.imwrite('results/dilated_contours.png', dilated_contours)

    
    # Create an empty mask to d
    # raw the filtered contours, fill them completely
    mask = np.zeros_like(edges)
    cv2.drawContours(mask, suture_contours, -1, (255), thickness=cv2.FILLED)

    # dilate the mask to fill the very small gaps
    kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (3, 3))
    mask = cv2.dilate(mask, kernel, iterations=1)
    
    return mask

def count_sutures(mask):

     # Apply erosion to separate close components
    # kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (3, 3))
    # eroded_mask = cv2.erode(mask, kernel, iterations=1)

    # #show the eroded mask
    # cv2.imwrite('results/eroded_mask.png', eroded_mask)

     # Use a horizontal structuring element to enhance horizontal features
    horizontal_kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (10, 1))
    isolated = cv2.morphologyEx(mask, cv2.MORPH_OPEN, horizontal_kernel, iterations=3)
    cv2.imwrite('results/isolated.png', isolated)
    
    # Skeletonize the mask to reduce all sutures to single pixel width lines
    skeleton = cv2.ximgproc.thinning(isolated, thinningType=cv2.ximgproc.THINNING_ZHANGSUEN)
    cv2.imwrite('results/skeleton.png', skeleton)

    # connect very close lines
    kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (1, 5))
    connected = cv2.morphologyEx(skeleton, cv2.MORPH_CLOSE, kernel, iterations=2)
    cv2.imwrite('results/connected.png', connected)
    
    # Find connected components in the mask
    num_labels, _, stats, _ = cv2.connectedComponentsWithStats(connected, 4, cv2.CV_32S)
    
    # return num_sutures_by_contours
    num_sutures = num_labels - 1
    print(f'num contours = {num_sutures}')

    contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    num_sutures_by_contours = len(contours)
    # show the contours
    cv2.drawContours(mask, contours, -1, (255), thickness=cv2.FILLED)
    cv2.imwrite('results/contours.png', mask)


    print(f'num contours = {num_sutures_by_contours}')

    #  # Optionally, if sutures are linear, detect them using Hough transform
    # edges = cv2.Canny(mask, 50, 150, apertureSize=3)
    # lines = cv2.HoughLinesP(edges, 1, np.pi/180, threshold=9, minLineLength=60, maxLineGap=13)
    # num_sutures_by_lines = 0 if lines is None else len(lines)
    # print(f'num sutures by lines = {num_sutures_by_lines}')
    # # Count the number of connected components which correspond to sutures.
    # We use cv2.connectedComponentsWithStats to get the number of components
    # num_labels, _, stats, _ = cv2.connectedComponentsWithStats(mask, 4, cv2.CV_32S)
    
    # # The first label is the background, so subtract one to get the count of sutures
    # num_sutures = num_labels - 1
    
    # # Alternatively, if sutures are well-separated, count the number of contours as well
    # contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    # num_sutures_by_contours = len(contours)
    
    # # We can also use Harris corner detection as mentioned in the assignment
    # corners = cv2.cornerHarris(mask, 2, 3, 0.2)
    # corners = cv2.dilate(corners, None)
    # num_sutures_by_corners = len(np.where(corners > 0.9 * corners.max())[0])
    # print(num_sutures_by_corners)

    # by number of horizontal lines
    # lines = cv2.HoughLinesP(mask, 1, np.pi/180, 100, minLineLength=100, maxLineGap=10)
    # num_sutures_by_lines = len(lines)
    # print(f'num sutures by lines = {num_sutures_by_lines}')


    
    return num_sutures_by_contours, num_sutures_by_contours

# We already have the edges from the previous steps, let's apply these new functions to the edges image
filtered_edges = filter_edges(edges)
num_sutures, num_sutures_by_contours = count_sutures(filtered_edges)

# Display the filtered edges for verification
# For actual implementation, this would be saved to a file or passed to the next step
cv2.imwrite('results/filtered_edges.png', filtered_edges)

# Return the number of sutures counted by connected components and by contours
print(num_sutures, num_sutures_by_contours)

