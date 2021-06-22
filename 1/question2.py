import numpy as np 
import cv2 as cv

#RGB to Grayscale
def im_monochromatic(img):
    rows, cols, colors = img.shape
    img_gray = np.zeros((rows,cols))

    #Intesity = (R+G+B)/3
    for i in range(0,rows):
        for j in range(0,cols):
            img_gray[i][j] = (int(img[i][j][0])+int(img[i][j][1])+int(img[i][j][2]))/3

    img_gray = np.round(img_gray,0)
    return img_gray.astype(np.uint8)

#Calculates the euclidean distance between two points
def euclidean_distance(neighbours,xf,yf):
    distances = np.zeros((8,2))
    for i in range(0,8):
        distances[i][0] = np.sqrt((neighbours[i][0]-xf)**2 + (neighbours[i][1]-yf)**2)
        distances[i][1] = i
    return distances
        

def select_candidates(img,x,y,xf,yf):
    candidates = np.zeros((8,2))

    #Selects the candidates and if the point 
    #is out of the image it sets to a high value
    try:
        candidates[0] = (x+1,y)
    except IndexError:
        candidates[0] = (9999,9999)
    try:
        candidates[1] = (x-1,y)
    except IndexError:
        candidates[1] = (9999,9999)
    try:
        candidates[2] = (x,y+1)
    except IndexError:
        candidates[2] = (9999,9999)
    try:
        candidates[3] = (x,y-1)
    except IndexError:
        candidates[3] = (9999,9999)
    try:
        candidates[4] = (x-1,y-1)
    except IndexError:
        candidates[4] = (9999,9999)
    try:
        candidates[5] = (x-1,y+1)
    except IndexError:
        candidates[5] = (9999,9999)
    try:
        candidates[6] = (x+1,y+1)
    except IndexError:
        candidates[6] = (9999,9999)
    try:
        candidates[7] = (x+1,y-1)
    except IndexError:
        candidates[7] = (9999,9999)

    distances = euclidean_distance(candidates,xf,yf)
    #Sort the array by the distances, second collum is the index
    distances = distances[distances[:,0].argsort()]

    #By the three selected candidates, choose the smaller one
    smaller = 256
    for i in range(0,3):
        k = int(distances[i][1])
        if img[int(candidates[k][0]),int(candidates[k][1])] < smaller:
            smaller = img[int(candidates[k][0]),int(candidates[k][1])]
            smaller_index = k

    best_candidate = candidates[smaller_index]
    
    #Returns the best points to continue in the path
    return best_candidate

#Program Start    
Mrgb = cv.imread("Mars.bmp",-1)
Path = Mrgb
Mgray = im_monochromatic(Mrgb)
Mheq = cv.equalizeHist(Mgray)

#Initial point coordinates
originx = 260 
originy = 415
#Final point coordinates
destinationx = 815
destinationy = 1000
#Variable that indicate the currently point of the path the algorithm is
nextPoints = np.array([0,0])
nextPoints[0] = originx #First points is the origin
nextPoints[1] = originy

#Loop that calculates the path
while((nextPoints[0] != destinationx) and (nextPoints[1] != destinationy)):
    nextPoints = select_candidates(Mheq,originx, originy, destinationx, destinationy)
    Path[int(nextPoints[0]),int(nextPoints[1])] = (0,0,0)#paint the pixels of the path with black
    originx = nextPoints[0] #redefines the point
    originy = nextPoints[1]

cv.imshow("Path",Path)
cv.waitKey(0)
cv.destroyAllWindows()  