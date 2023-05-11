Como rodar
* Script para gerar tráfego está em /inputs
* Tráfego dentro de /inputs (cada roteador tem o seu arquivo, cada linha do arquivo define o pacote a ser enviado {ti, target x, target y, size})
* Rodar o Modelsim usando o sim.do. Vai gerar as saídas dentro de /outputs
* Rodar o programa proccessPath, que vai ler o /outputs/Path.txt e gerar o arquivo tmp
* Rodar o programa printPath que vai ler o tmp e imprimir os caminhos tomados
* As duas versões do Switch Control (com XY e com odd-even) estão no diretório da NOC mas não são compilados. Para escolher a versão, renomear para "Hermes_switchcontrol"