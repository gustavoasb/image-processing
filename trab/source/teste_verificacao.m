function teste_verificacao()
%% Teste da verificacao de assinaturas

% Possibilita realizar diversas verificacoes automaticamente, escolhendo
% assinaturas aleatorias do banco de assinaturas e entrega a porcentagem de
% acertos.

% Este teste leva em conta apenas assinaturas diferentes. Quando a
% verificacao e feita apenas com conjuntos de assinatura do tipo forgery,
% as porcentagens de acerto caem acentuadamente, chegando a metade das
% obtidas aqui.

%% Input

prompt1 = 'Digite quantas pessoas devem ser cadastradas no sistema (1-54):';
prompt2 = 'Digite quantas assinaturas devem ser verificadas aleatoriamente:';
definput = {'54', '100'};
resp = inputdlg({prompt1,prompt2},'verificacao',[1 35],definput);

% caso o usuario cancele.
if isempty(resp)
    return
end

msgbox('Aguarde...');

% numero de pessoas carregadas
Np = str2double(resp{1});

% numero de assinaturas para testar.
Nsign = str2double(resp{2});


%% Verificacao

% O programa escolhe uma assinatura aleatoria e a identificacao de uma
% pessoa para verificar se a assinatura realmente pertence a ela.
% O resultado entregue pelo algoritmo sera avaliado atribuindo um acerto
% ou erro.

erros = 0;
acertos = 0;

for i = 1:Nsign
    
    % escolhe uma pessoa aleatoria.
    j = randi(Np);
    % escolhe uma assinatura dessa pessoa.
    k = randi(24); % 24 - numero de assinaturas disponiveis no banco.
    
    % escolhe a identificacao de uma pessoa para a verificacao.
    %%%%%id = randi(Np);
    id = j;
    %%%%%baseFileName = sprintf('original_%d_%d.png', j, k);
    baseFileName = sprintf('original_%d_%d.png', j, k);
    % resultado sera a resposta que o programa deu para a verificacao.
    resultado = hog_compare(id,baseFileName);
    
    % esse resultado so vai estar correto caso tenha sido validado (1)
    % quando o autor corresponde ao id fornecido ou quando for
    % incompativel e o autor nao corresponder ao id fornecido.
    if resultado == 1 && id == j || resultado == 0 && id ~= j
        acertos = acertos + 1;
    else
        erros = erros + 1;
    end
end

%% Resultado

TaxaAcerto = acertos / (acertos + erros) * 100;
msg = sprintf('Taxa de acerto da verificacao = %.2f%%\n',TaxaAcerto);
uiwait(msgbox(msg, 'replace'));
end