import cv2 as cv
import numpy as np
import matplotlib.pyplot as plt

def run():
    img = cv.imread("data/morf_test.png")

    #Aplica filtro pra diminuir ruido
    img_filtered = cv.bilateralFilter(img,9,75,75)

    #Aplica bottom hat
    kernel = cv.getStructuringElement(cv.MORPH_RECT, (5, 5))
    bottomhat = cv.morphologyEx(img_filtered, cv.MORPH_BLACKHAT, kernel)

    #Binariza imagem, limiar = 30
    ret,thresh1 = cv.threshold(bottomhat,30,255,cv.THRESH_BINARY)

    #Fechamento para diminuir defeitos nas letras
    kernel = cv.getStructuringElement(cv.MORPH_RECT, (2, 2))
    thresh1 = cv.morphologyEx(thresh1, cv.MORPH_CLOSE, kernel)
    thresh_show = cv.bitwise_not(thresh1)

    #Acha somente o fundo
    kernel = cv.getStructuringElement(cv.MORPH_RECT, (7, 7))
    background = cv.morphologyEx(img, cv.MORPH_CLOSE, kernel)

    #Fundo - imagem
    newimg = background - img

    #Melhora resultado fundo - imagem
    kernel = cv.getStructuringElement(cv.MORPH_RECT, (2, 2))
    sla = cv.morphologyEx(newimg, cv.MORPH_OPEN, kernel)
    
    #Mostra resultados
    titles = ['Imagem Original','Bottom-hat aplicado','Binarização','Fundo','Fundo menos original','Fundo menos original melhorada']
    images = [img, bottomhat, thresh_show,background,newimg,sla]
    for i in range(6):
        plt.subplot(2,3,i+1),plt.imshow(images[i])
        plt.title(titles[i])
        plt.xticks([]),plt.yticks([])
    plt.show()
