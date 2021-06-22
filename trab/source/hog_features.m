function features = hog_features(baseFileName)
%% Estracao de HOG features

% Essa funcao recebe a imagem de uma assinatura onde sao realizados
% pre-processamentos e retorna um vetor features do Histogram of Oriented
% Gradients (HOG). Essas features codificam informacoes sobre formas locais
% de regioes da imagem e sao uteis para comparar propriedades.

%% Pre-processamentos
fullFileName = fullfile(pwd,'signatures','full_org',baseFileName);
I = imread(fullFileName);

% transformando em escala de cinza as imagens de 3 dimensoes
if ndims(I) == 3
    I = rgb2gray(I);
end

% binarizacao pelo metodo de otsu
Ibin = imbinarize(I);

% cortar os espaços brancos da imagem
Icrop = corta_sign(Ibin);

% redimensionalizando a imagem
Ifinal = imresize(Icrop, [200 200]);


%% Features
% obtendo um vetor de features
features = extractHOGFeatures(Ifinal,'CellSize', [20 20]);


end