function teste_autenticacao()
%% Teste de autenticacao de assinaturas
% Possibilita calcular a porcentagem de acerto na autenticacao em
% diferentes configuracoes.

% Compara a assinatura com todas as outras no banco de dados e tenta prever
% o autor mais provavel utilizando o algoritmo k nearest neighbor e a
% tranformada radon para obter as features.

% Compara os resultados da classificacao com os esperados e da a
% porcentagem de acerto.


%% Features
% numero de features (depende da quantidade de angulos usados em
% radon_features).
% Igual a 1148, valor para 4 angulos (padrao).
Nfeatures = size(radon_features('original_1_1.png'),1);


%% Input
prompt1 = 'Digite o numero de pessoas cadastradas (2-54):';
prompt2 = 'Digite o numero de assinaturas por pessoa para serem testadas (2-24):';
prompt3 = ['Digite a proporcao das assinaturas carregadas que serao'... 
' usadas para treino:\n0.7 significa 70%% das assinaturas, por exemplo.'];
prompt3 = sprintf(prompt3);
definput = {'10', '10', '0.7'};
resp = inputdlg({prompt1,prompt2,prompt3},'autenticacao',[1 80],definput);

% caso o usuario cancele.
if isempty(resp)
    return
end
msgbox('Aguarde...');


%% Parametros

% numero de pessoas.
Np = str2double(resp{1});

% numero de assinaturas por pessoa usadas no programa (teste + treino).
Npsign = str2double(resp{2});

% proporcao das assinaturas carregadas que serao usadas para treino
% prop = 0.7 significa 70% das assinaturas, por exemplo
prop = str2double(resp{3});


%% Treino:

% numero de assinaturas de treino
Ntreino = floor(prop * Npsign);

% criando matriz com o numero de assinaturas pelas features, para armazenar
% as features de todas as assinaturas de treino.
Xtreino = zeros(Np * Ntreino, Nfeatures);

% criando uma matriz com os nomes em cada linha (labels).
Ytreino = zeros(Np * Ntreino,1);

% os ids das assinaturas de treino sao escolhidos aleatoriamente.
% explicacao: escolhe aleatoriamente Ntreino elementos de um array de
% Npsign elementos de 1 ate Npsign.
IDtreino = randperm(Npsign,Ntreino);


for i = 1:Np
    for j = 1:Ntreino
        % escreve uma string com o nome do arquivo da assinatura de uma
        % pessoa
        % i sera o id da pessoa, enquanto IDtreino(j) sera o id de uma
        % assinatura dessa pessoa.
        baseFileName = sprintf('original_%d_%d.png', i, IDtreino(j));
        % armazenando as informacoes da transformada em uma linha.
        Xtreino((i-1) * Ntreino + j, :) = radon_features(baseFileName);
        % armazenando os IDs de cada pessoa.
        Ytreino((i-1) * Ntreino + j) = i;
    end
end

% Mdl e um modelo que armazena o classificador knn treinado.
Mdl = fitcknn(Xtreino, Ytreino, 'NumNeighbors', 1,'Standardize', 1,...
    'Distance', 'cityblock');



%% Teste

% numero de assinaturas pra testar de cada pessoa.
Nteste = Npsign - Ntreino;

% os ids das assinaturas de teste serao os que sobraram.
% setdiff da a diferenca entre dois conjuntos.
IDteste = setdiff(1:Npsign,IDtreino);

% matriz para armazenar features de teste.
Xteste = zeros(Nteste * Np, Nfeatures);

% esse vetor sera para armazenar as respostas esperadas (corretas) sobre as
% assinaturas de teste.
Yesperado = zeros(Nteste * Np, 1);

for i = 1:Np
    for j = 1:Nteste
        baseFileName = sprintf('original_%d_%d.png', i, IDteste(j));
        Xteste((i-1) * Nteste + j, :) = radon_features(baseFileName);
        Yesperado((i-1) * Nteste + j) = i;
    end
end

% calculando o ID mais provavel de cada assinatura
Yteste = predict(Mdl, Xteste);


%% Resultado

% calculando a taxa de acertos
diffelements = sum(Yesperado ~= Yteste);
% numero de elementos diferentes / numero total de elementos
erro = diffelements / numel(Yesperado);
TaxaAcerto = (1 - erro) * 100;

msg = sprintf('Taxa de acerto da validacao = %.2f%%\n',TaxaAcerto);
uiwait(msgbox(msg, 'replace'));
end