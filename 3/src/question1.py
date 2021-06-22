import cv2 as cv
import numpy as np
import matplotlib.pyplot as plt

img_original = cv.imread('../data/img_cells.jpg')
img_gray = cv.cvtColor(img_original,cv.COLOR_BGR2GRAY)
cv.imshow('img',img_gray)
cv.waitKey(0)
cv.destroyAllWindows()

ret,img_binary = cv.threshold(img_original,127,255,cv.THRESH_BINARY)
plt.imshow(img_binary)
plt.show()

img_binary_neg = 255 - img_binary
plt.imshow(img_binary_neg)
plt.show()

im_floodfilled = img_binary.copy()
h, w = im_floodfilled.shape[:2]
mask = np.zeros((h+2, w+2), np.uint8)
cv.floodFill(im_floodfilled, mask, (0,0), 255)
plt.imshow(im_floodfilled)
plt.show()

im_floodfill_inv = cv.bitwise_not(im_floodfilled)
im_out = img_binary | im_floodfill_inv
plt.imshow(im_out)
plt.show()
