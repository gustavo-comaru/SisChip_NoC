#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TAM 400  // definição global para definir tamanho máximo de string

/**********************************************************************/
 // ROTINA PARA LER STRING
/**********************************************************************/
int separador(char car)
{
  switch(car)
   { case ':': case '=': case '*': case '(':  case ')' : 
     case ' ': case '.': case ',': case '\n': case '\t': case '\r': return 1;
     default: return 0;
   }
}

int search_word(char *word, int *counter, char *token)
{
    int k = 0;
    while (separador(word[*counter]))
        (*counter)++;
    while (!separador(word[*counter]) && word[*counter] != '\0')
        token[k++] = word[(*counter)++];
    token[k] = '\0';
    return k;
}

/**********************************************************************/
int main(int argc, char *argv[])
{  
    int N, y, x, k, sizeX=0, sizeY=0, packt_nb, adX, adY, i, j;
    char pp, line[TAM], tmp[TAM], port;
    FILE *fr;
    int ***NoC;

    // lê o arquivo uma primeira vez para encontrar o tamanho da NoC
    if ( !(fr = fopen( "tmp", "r")))     
    {  puts("Error to open file tmp"); exit(0);}


    while ( fgets(line, TAM, fr) )  {  
        if(strstr(line, "SIZE"))
        {  y = 0;
           search_word(line, &y, tmp);    //  SIZE
           search_word(line, &y, tmp);  
           sscanf(tmp, "%d", &sizeX );
           search_word(line, &y, tmp);  
           sscanf(tmp, "%d", &sizeY );
        }
        if(strstr(line, "PACKETS"))
        {  y = 0;
           search_word(line, &y, tmp);    //  PACKETS
           search_word(line, &y, tmp);  
           sscanf(tmp, "%d", &N );
        }
       } 
    fclose(fr);

    printf("(X:%2d Y:%2d) N:%d \n",  sizeX, sizeY, N);

    // alocação da matriz NoC[N][y][x]
    NoC = (int ***)malloc(N * sizeof(int **));
    if (NoC == NULL) { printf("Erro ao alocar memória.\n"); exit(0); }

    // For each position, allocate memory for sizeY rows
    for (i = 0; i < N; i++) {
        NoC[i] = (int **)malloc(sizeY * sizeof(int *));
        if (NoC[i] == NULL) { printf("Erro ao alocar memória.\n"); exit(0); }

        // For each row, allocate memory for sizeX columns
        for (j = 0; j < sizeY; j++) {
            NoC[i][j] = (int *)malloc(sizeX * sizeof(int));
            if (NoC[i][j] == NULL) { printf("Erro ao alocar memória.\n"); exit(0); }
        }
    }

    printf("Passou!\n");

    for (k = 0; k < N; k++)           //N
      for (y = 0; y < sizeY; y++)     //Y
        for (x = 0; x < sizeX; x++)   //X 
            NoC[k][y][x]=-1;

    printf("Passou! 2\n");

    fr = fopen( "tmp", "r");   

    // le os pacotes
    while ( fgets(line, TAM, fr) )
    {      
        if(strstr(line, "PKT"))
        { 
            y = 0;
            search_word(line, &y, tmp);     // PKT
            search_word(line, &y, tmp);     sscanf(tmp, "%d", &adX );
            search_word(line, &y, tmp);     sscanf(tmp, "%d", &adY );
            search_word(line, &y, tmp);     sscanf(tmp, "%d", &packt_nb ); 
            search_word(line, &y, tmp);     port = tmp[0]; 

            if(adX<sizeX && adY<sizeY)
                NoC[packt_nb][adY][adX] = port*10000 + packt_nb; 

            printf("(%2d %2d) N:%d %c\n",  adX, adY, packt_nb, port);
        }
    }

    printf("Passou! 3\n");

    for(k=0; k<N; k++)
    { printf("PRINTING PACKET %d\n", k);
      for (y=sizeY-1; y>-1; y--)  
      { 
        // top part of the router ///////////////
        for (x=0; x<sizeX; x++) 
          { pp = (char)(NoC[k][y][x]/10000);
            if( pp=='L' ) printf("X---+ ");
              else if( pp=='N' ) printf("+-X-+ ");
              else  printf("+---+ ");
          }
        puts("");

        // midlle part of the router ///////////////
        for (x=0; x<sizeX; x++) 
          { pp = (char)(NoC[k][y][x]/10000);
            if( NoC[k][y][x] > 0)
              {  if( pp=='W' )        printf("X%3d| ", NoC[k][y][x]%10000);
                 else if( pp=='E' )   printf("|%3dX ", NoC[k][y][x]%10000);
                 else printf("|%3d| ", NoC[k][y][x]%10000);
              }
            else printf("|   | ");
              
          }
         puts("");

        // bottom part of the router ///////////////
         for (x=0; x<sizeX; x++) 
           { pp = (char)(NoC[k][y][x]/10000);
             if( pp=='S' ) printf("+-X-+ ");
                else printf("+---+ ");
            }
         puts("");
      } 
    }
    fclose(fr);
    return 0;
}


