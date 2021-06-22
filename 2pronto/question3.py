import cv2 as cv
import numpy as np
import matplotlib.pyplot as plt
import random

def run():
    img = cv.imread("data/cookies.tif")

    #Transforma a imagem para binario
    ret,thresh1 = cv.threshold(img,60,255,cv.THRESH_BINARY) 
    kernel = cv.getStructuringElement(cv.MORPH_ELLIPSE, (8, 8))
    thresh1 = cv.morphologyEx(thresh1, cv.MORPH_OPEN, kernel) #remove ruidos

    #Faz a erosao do cookie mordido
    kernel = cv.getStructuringElement(cv.MORPH_ELLIPSE, (118, 120))
    erosion = cv.erode(thresh1,kernel,iterations = 1)

    #Dilata o cookie para deixar apenas o completo
    kernel = cv.getStructuringElement(cv.MORPH_ELLIPSE, (118, 120))
    dilation = cv.dilate(erosion,kernel,iterations = 1)

    #Dilata-se mais um pouco para segmentar na imagem original
    kernel = cv.getStructuringElement(cv.MORPH_ELLIPSE, (10, 10))
    details = cv.dilate(dilation, kernel, iterations = 1)

    #Ajustando o cookie para receber os detalhes recuperados
    adjusted = details*thresh1
    adjusted = adjusted*255

    #Cria uma imagem com um fundo novo baseado no original
    background = img.copy()
    for i in range(img.shape[0]):
        for j in range(img.shape[1]):
            x = random.randint(0,10)
            if x > 8:
                background[i,j] = (41,41,41)
            elif x < 8 and x > 3:
                background[i,j] = (31,31,31)
            else:
                background[i,j] = (23,23,23)
    background = cv.bilateralFilter(background,8,40,40)

    #Cookie completa e fundo preto
    newimg2 = (adjusted*cv.bitwise_not(img))

    #Junta cookie completa com fundo aleatorio gerado
    newimg = background * cv.bitwise_not(adjusted)
    newimg = cv.bitwise_not(newimg)
    newimg = (cv.bitwise_not(img)*adjusted) + newimg

    titles = ['Imagem Original','Binario','Elimina cookie mordida','Recupera forma inicial','Apenas cookie completa','Apenas cookie completa (fundo simulado)']
    images = [img, thresh1, erosion , adjusted, newimg2, newimg]
    for i in range(6):
        plt.subplot(2,3,i+1),plt.imshow(images[i])
        plt.title(titles[i])
        plt.xticks([]),plt.yticks([])
    plt.show()
