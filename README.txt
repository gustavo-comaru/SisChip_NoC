GERAÇÃO DE TRÁFEGO

    >> O script para gerar tráfego está em '/inputs'

    >> Tráfego resultante é colocado em '/inputs' (cada roteador tem o seu arquivo, cada linha define o pacote a ser enviado {ti, target x, target y, size})


SIMULAÇÃO E IMPRESSÃO DOS RESULTADOS

    >> Rodar simulação no ModelSim:

        vsim -do sim.do

    >> As saídas da simulação são colocadas no diretório '/outputs'

    >> O programa 'process_path.c' lê os resultados de '/outputs/Path.txt' e os prepara para impressão. Esse processo resulta no arquivo 'tmp'

    >> O programa 'print_path.c' lê o conteúdo de 'tmp' e imprime os caminhos tomados pelos pacotes da simulação

    >> Rodar os seguintes comandos para imprimir os caminhos:
        
        make
        
        ./procPath
        
        ./printPath


ALTERAR ALGORITMO DE ROTEAMENTO

    >> Existem duas arquiteturas que implementam o módulo SwitchControl do roteador, uma implementando o roteamento XY e a outra odd-even

    >> Para alternar entre as diferentes arquiteturas, deve-se alterar o arquivo '/NOC/Router.cc'

    >> Neste arquivo, a arquitetura escolhida é definida na linha 103 -- "SwitchControl : Entity work.SwitchControl(AlgorithmOddEven)"

    >> Pode-se alterar o valor da arquitetura para 'AlgorithmXY' ou 'AlgorithmOddEven'
