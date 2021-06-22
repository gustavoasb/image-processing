import numpy as np 
import cv2 as cv

#The new image has some blank pixels, so we fill them
def im_fillBlankPixels(resized,img,rows,cols,grayscale,size):
    #Grayscale images
    if(grayscale):
        #Horizontal lines filling, repeating a row
        for i in range(0,int(rows*size)):
                for j in range(0,int(cols*size)):
                    if resized[i][j] != 256:
                        newi = i
                    else:
                        resized[i][j] = resized[newi][j]
        #Vertical lines filling, repeating a collum
        for i in range(0,int(rows*size)):
            for j in range(0,int(cols*size)):
                if resized[i][j] != 256:
                    newj = j
                else:
                    resized[i][j] = resized[i][newj]
    #Colored images
    else:
        #Horizontal lines filling, repeating a row
        for i in range(0,int(rows*size)):
            for j in range(0,int(cols*size)):
                if resized[i][j][0] != 256:
                    newi = i
                else:
                    resized[i][j] = resized[newi][j]
        #Vertical lines filling, repeating a collum
        for i in range(0,int(rows*size)):
            for j in range(0,int(cols*size)):
                if resized[i][j][0] != 256:
                    newj = j
                else:
                    resized[i][j] = resized[i][newj]
    #Returning filled image
    return resized

#Creates the new image
def im_createResized(resized,img,rows,cols,grayscale,size):
    #For smaller sizes we can just put off some pixels
    if size < 1:
        for i in range(0,rows):
            for j in range(0,cols):
                resized[int(i*size)][int(j*size)] = img[i][j]
    #For larger ones we can create a sketch and fill up them with repetitions
    else:
        for i in range(0,rows):
            for j in range(0,cols):
                resized[int(i*size)][int(j*size)] = img[i][j]
        resized = im_fillBlankPixels(resized,img,rows,cols,grayscale,size)
    return resized

#Change the intensity levels of a image and resizes it
def im_chscaledepth(img,x,size):

    img = img/(256/(2**x)) #Change the intensity by the input
    img = np.floor(img)
    img = img*(255/((2**x)-1)) #Adapt it to common values, with the changes
    img = np.floor(img)

    #Preparatives for resizing
    if(im_grayscale(img)): #Grayscale
        rows, cols = img.shape
        resized = np.zeros((int(rows*size),int(cols*size)))
        resized = resized + 256 #Sum a high value so we can detected failures
        grayscale = True
    else: #Colored
        rows, cols, colors = img.shape
        resized = np.zeros((int(rows*size),int(cols*size),3)) #Extra dim for colors
        resized = resized + (256,256,256)
        grayscale = False

    resized = im_createResized(resized,img,rows,cols,grayscale,size)
    return resized.astype(np.uint8)

def im_grayscale(img):
    #RGB iamges have a extra dimension for colors, resulting in 3
    if(len(img.shape) > 2): 
        return False
    else:
        return True


level = input("Quantidade de bits que imagem de saida terá:\n")
value = input("Valor de redimensionamento da imagem:\n")
level = int(level)
value = float(value)
img = cv.imread("im1.jpg", -1)
resized = im_chscaledepth(img,level,value)
cv.imshow("output",resized)

cv.waitKey(0)
cv.destroyAllWindows