function features = radon_features(baseFileName)
%% Extracao de Radon features

% Essa funcao recebe a imagem de uma assinatura onde sao realizados
% pre-processamentos e retorna um vetor features utilizando a transformada
% Radon. Essas features codificam a projecoes da imagem em diferentes
% angulos e sao interessantes para serem usadas na classificacao das
% assinaturas.

%% Pre-processamentos
folder = pwd; % entrega o arquivo da funcao 
% (pwd - variavel com o endereco do arquivo no computador atual)

fullFileName = fullfile(folder,'signatures','full_org',baseFileName);
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
% calculando a tranformada
theta = 0:45:179; % pegando 4 angulos
features = radon(Ifinal, theta);
% a transformada retorna uma matriz onde cada coluna corresponde a um
% angulo e cada elemento corresponde a um coeficiente da projecao.

% transformando a matriz features em um vetor features.
features = features(:);

end

