import cv2 as cv
import numpy as np
import matplotlib.pyplot as plt

def run():
    #Acha o filtro para determinado ponto
    def filterPoint(d0,d1,x,y,nx,ny):
        filter1 = np.ones((nx,ny))
        filter2 = np.ones((nx,ny))
        filter3 = np.ones((nx,ny))
        butterworth = np.ones((nx,ny))

        #Butterworth
        for i in range(0,nx):
            for j in range(0,ny):
                dist = ((i-x)**2 + (j-y)**2)**(1/2)
                filter1[i,j] = 1/(1+(d0/(dist+0.00001))**(2*4))
                filter2[i,j] = 1/(1+(d1/(dist+0.00001))**(2*4))
                butterworth[i,j] = filter1[i,j]*filter2[i,j]

        return butterworth

    img = cv.imread("data/moire.tif",0)

    #Aplica a transformada de fourier e acha o aspectro de magnitude
    f = np.fft.fft2(img)
    nx,ny = f.shape
    fshift = np.fft.fftshift(f)
    magnitude_spectrum = 20*np.log(np.abs(fshift))

    #Butterworth para pontos da esquerda
    butterworth1 = filterPoint(4,4,43,53,nx,ny)
    butterworth2 = filterPoint(10,6,84,54,nx,ny)
    butterworth3 = filterPoint(12,7,164,57,nx,ny)
    butterworth4 = filterPoint(4,4,205,57,nx,ny)

    #Butterworth para pontos da direita
    butterworth5 = filterPoint(4,4,39,110,nx,ny)
    butterworth6 = filterPoint(11,5,80,110,nx,ny)
    butterworth7 = filterPoint(8,5,160,113,nx,ny)
    butterworth8 = filterPoint(4,4,201,113,nx,ny)

    #Soma todos as posições encontradas
    butterworth = (1-butterworth1)+(1-butterworth2)+(1-butterworth3)+(1-butterworth4)+(1-butterworth5)+(1-butterworth6)+(1-butterworth7)+(1-butterworth8)
    butterworth = 1-butterworth

    #Padding
    padded_butterworth = np.pad(butterworth, ((16,16),(16,16)), 'constant')
    padded_fshift = np.pad(fshift, ((16,16),(16,16)), 'constant',)

    #Aplica o filtro e faz a transformada inversa para recuperar imagem
    filtered_image = padded_butterworth*padded_fshift
    filtered_image = np.fft.ifftshift(filtered_image)
    filtered_image = np.fft.ifft2(filtered_image)
    filtered_image = np.real(filtered_image)
    filtered_image = np.float32(filtered_image)

    #Mostra resultados
    titles = ['Imagem Original','Fourier','Filtro','Imagem Filtrada']
    images = [img, magnitude_spectrum,padded_butterworth,filtered_image]
    for i in range(4):
        plt.subplot(2,2,i+1),plt.imshow(images[i],cmap='gray')
        plt.title(titles[i])
        plt.xticks([]),plt.yticks([])
    plt.show()
