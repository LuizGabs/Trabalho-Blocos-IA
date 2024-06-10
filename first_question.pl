:- dynamic posicao/3.
:- dynamic vazio/2.
:- dynamic empilhar/2.

% Representação dos Blocos
bloco(b1, 2, (1, 1), 10).
bloco(b2, 2, (2, 1), 10).
bloco(b3, 2, (1, 2), 10).
bloco(b4, 2, (2, 2), 10).

% Representação das Posições na Mesa
posicao(1, 1, true).
posicao(2, 1, true).
posicao(1, 2, true).
posicao(2, 2, true).

% Representação das Condições de Vacância
vazio(Posicao, Bloco) :-
    posicao(PosicaoX, PosicaoY, true),
    bloco(Bloco, _, (PosicaoX, PosicaoY), _).

% Representação das Condições de Estabilidade
estavel(BlocoBase, BlocoTopo) :-
    bloco(BlocoBase, TamanhoBase, _, _),
    bloco(BlocoTopo, TamanhoTopo, _, _),
    TamanhoBase >= TamanhoTopo.

% Regra para empilhar um bloco sobre outro
empilhar(BlocoBase, BlocoTopo) :-
    vazio(Posicao, BlocoTopo),
    estavel(BlocoBase, BlocoTopo),
    retract(posicao(PosicaoX, PosicaoY, true)),
    assertz(posicao(PosicaoX, PosicaoY, false)),
    write('Empilhado bloco '), write(BlocoTopo), write(' sobre '), write(BlocoBase), nl.

% Consulta para encontrar uma configuração de blocos
consulta :-
    empilhar(b1, b2),
    empilhar(b2, b3),
    empilhar(b3, b4).