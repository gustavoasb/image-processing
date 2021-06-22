%% Trabalho final de IPI
% Gianlucas dos Santos Lopes
% Gustavo - -
% Mayara Chew Marinho

% Programa testado no Matlab R2018b.
% Toolbox usadas (necessarias):
% Image Processing Toolbox - v10.3
% Computer Vision System Toolbox - v8.2
% Statistics and Machine Learning Toolbox - v11.4

%% Sistema de assinaturas escritas a mao

msg = sprintf(['O sistema possui duas funcoes principais:\n\n'...
    'Autenticacao: Uma assinatura sera comparada com as outras'...
    ' armazenadas no sistema. O programa vai retornar a identificacao'...
    ' da pessoa cadastrada com maior possibilidade de ser a autora.\n\n'...
    'Verificacao: Uma assinatura sera fornecida junto com a'...
    ' identificacao de uma pessoa. O programa vai comparar essa'...
    ' assinatura com as outras cadastradas para a pessoa e entao vai'...
    ' retornar se a assinatura foi considerada valida ou incompativel.'...
    '\n\nOs modos de teste sao feitos para testar as funcoes diversas'...
    ' vezes e obter porcentagens de acerto.']);
h = (msgbox(msg,'Sistema de Assinaturas'));
object_handles = findall(h);
set(h, 'position', [450 350 430 250]);
set(object_handles(3:4), 'FontSize', 12)
set(h,'Resize','on')
uiwait(h);


while 1
    [indx, tf] = listdlg('ListString', {'autenticacao', 'teste_autenticacao',...
        'verificacao', 'teste_verificacao'}, 'SelectionMode', 'Single',...
        'CancelString','Sair','ListSize',[280 100],...
        'PromptString','Escolha um modo:','Name','Sistema de assinaturas');

    if tf == 0
        break
    end
    switch indx
        case 1
            autenticacao();
        case 2
            teste_autenticacao()
        case 3
            verificacao()
        case 4
            teste_verificacao()
    end
end
