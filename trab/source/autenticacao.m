function autenticacao
%% Autenticacao de assinaturas

% O programa recebe uma assinatura e compara-a com as assinaturas de todas
% as pessoas cadastradas no programa, retornando qual o autor que tem a
% assinatura mais proxima a ela.
% Utiliza a transformada radon para obter features e o algoritmo k nearest
% neighbors para classificacao.


%% Features
% numero de features (depende da quantidade de angulos usados em
% radon_features).
% Igual a 1148 para 4 angulos (padrao).
Nfeatures = size(radon_features('original_1_1.png'),1);


%% Input

% abre o explorer para escolha da assinatura
directory = fullfile(pwd,'signatures','full_org');
file = uigetfile('*.png', 'Escolha a imagem', directory);

% caso nenhum arquivo seja escolhido.
if file == 0
    return
end

msgbox('Aguarde...');


%% Parametros (mude para testar configuracoes diferentes)

% numero de pessoas cadastradas. (1 a 54)
Np = 54;

% numero de assinaturas cadastradas. (1 a 24)
Npsign = 10;


%% Treino:
% carregando as assinaturas cadastradas para o classificador

% numero de assinaturas de treino
Ntreino = Np * Npsign;

% criando matriz com o numero de assinaturas pelas features, para armazenar
% as features de todas as assinaturas de treino.
Xtreino = zeros(Ntreino, Nfeatures);

% criando uma matriz com os nomes em cada linha (labels).
Ytreino = zeros(Ntreino, 1);

% carregando as primeiras NPsign assinaturas das primeiras Np pessoas.
for i = 1:Np
    for j = 1:Npsign
        % escreve uma string com o nome do arquivo da assinatura.
        % i sera o id da pessoa, enquanto j sera o id de uma
        % assinatura dessa pessoa.
        baseFileName = sprintf('original_%d_%d.png', i, j);
        
        % armazenando as informacoes da transformada em uma linha.
        % essas informacoes sao as features dadas pela transformada radon.
        Xtreino((i-1) * Npsign + j, :) = radon_features(baseFileName);
        
        % armazenando os IDs de cada pessoa.
        Ytreino((i-1) * Npsign + j) = i;
    end
end

% Mdl e um modelo que armazena o classificador knn treinado.
% os parametros da funcao foram obtidos utilizando-se otimizacao de
% hiperparametros.
Mdl = fitcknn(Xtreino, Ytreino, 'NumNeighbors', 1,'Standardize', 1,...
    'Distance', 'cityblock');


%% Teste
% obtendo a classificacao da assinatura fornecida com base nas ja
% cadastradas.

% criando o vetor para armazenar as features.
Xteste = zeros(1,Nfeatures);

% obtendo as features.
Xteste(1,:) = radon_features(file);

% classificacao.
Yteste = predict(Mdl, Xteste);


%% Resultado

msg = sprintf('Assinatura da pessoa de id: %d',Yteste);
% uiwait pausa a execucao do programa ate a msgbox ser fechada.
uiwait(msgbox(msg,'replace'));

end