import random as rm
import math
##### Distribuicao Uniforme #####


size  = 32 # tamanho do pacote
banda = 32 # tamanho da banda
taxa  =  1 # taxa de 
qtd = 1   # quantidade de pacotes
x_total = 8 # tamanho da rede em x
y_total = 8 # tamanho da rede em y
#router = '00' # roteador escolhido

def xy():
    while True:
        x = math.floor(rm.uniform( 0 , x_total ))
        y = math.floor(rm.uniform( 0 , y_total ))
        if str(x)+str(y) != router:
            break

    return(x,y)

for i in range(math.floor(x_total)):
    for j in range(math.floor(y_total)):

        router = str(i) + str(j)
        t = 0 
        with open(str(router)+".txt", "w") as output:
            for k in range(qtd):
                x, y = xy()
                output.write(str(t) + '\t' + str(x) + '\t' +  str(y) + '\t' + str(size))
                t += int((banda * size)/ taxa)

        
