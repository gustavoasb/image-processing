function [Icrop] = corta_sign(Ibin)
% corta a imagem e deixa somente a assinatura
% util caso a pessoa tenha desenhado a assinatura um pouco deslocada

% usa bwareaopen pra remover noise
% deve-se utilizar o negativo da imagem
Ibinclean = bwareaopen(~Ibin, 6);
Ibinclean = ~Ibinclean;

% projeções horizontal e vertical
% soma de todos os valores brancos na coordenada x, formando uma coluna
YProj = sum(Ibinclean, 1);

% soma de todos os valores brancos na coordenada y, formando uma linha
XProj = sum(Ibinclean, 2);

% mostrando as projecoes
%figure(4), plot(sum(Ibinclean, 2),1:size(Ibin,1));
%figure(5), plot(1:size(Ibin, 2),sum(Ibinclean, 1));

% usando as projecoes para encontrar as coordenadas

% pontos (xi, yi) que simbolizam o inicio da assinatura
xi = find(XProj ~= size(Ibinclean, 2), 1);
xf = find(XProj ~= size(Ibinclean,2), 1,'last');

% pontos (xf, yf) que simbolizam o final da assinatura
yi = find(YProj ~= size(Ibinclean,1), 1);
yf = find(YProj ~= size(Ibinclean,1), 1,'last');

% cortando a imagem
Icrop = Ibin(xi-1 + 1:xf, yi-1 + 1:yf);

end

