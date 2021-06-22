function verificacao()
%% Verificacao de assinaturas

% Tem como entrada uma assinatura e a identificacao do suposto autor.
% O programa vererifica se a assinatura realmente pertence ao autor
% comparando-a com as assinaturas ja cadastradas no programa para essa
% pessoa.

% Utiliza as HOG features e distancias euclidianas como base 
% para as comparacoes.


%% Input

% abre o explorer para escolha da assinatura
uiwait(msgbox('Escolha uma assinatura para verificar'));
directory = fullfile(pwd,'signatures','full_org');
file = uigetfile('*.png','Escolha a imagem',directory);

% caso nenhum arquivo seja escolhido.
if file == 0
    return
end

% pede o ID da pessoa que se deseja verificar.
prompt = 'Digite o ID da pessoa para verificacao(1-54):';
IDpessoa = str2double(inputdlg(prompt));
if IDpessoa == 0
    return
end

msgbox('Aguarde...');


%% Verificacao
% Verifica utilizando a comparacao pelas features do HOG.
resultado = hog_compare(IDpessoa,file);


%% Resultado

if resultado == 1
    msg = ('Assinatura validada!');
elseif resultado == 0
    msg = ('Assinatura incompativel!');
end

uiwait(msgbox(msg, 'replace'))
end