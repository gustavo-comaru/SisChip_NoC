#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_PACKETS 200
#define TAM 400 

int repeated(int *array, int size, int val)
{
    for(int i = 0; i<size; i++)
        if(array[i]==val)
            return 1;
    return 0;
}

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

void main()
{

    int N, y, x, k, sizeX=0, sizeY=0, packt_nb, adX, adY, i, j;
    char pp, line[TAM], tmp[TAM], port;
    FILE *fr, *fw;
    int ***NoC;
    int packet_numbers[MAX_PACKETS];
    int packets = 0;

    fr = fopen("outputs/Path.txt", "r");
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

            //printf("(%2d %2d) N:%d %c\n",  adX, adY, packt_nb, port);

            if(repeated(packet_numbers, packets, packt_nb)==0)
            {
                printf("PKT %d -> %d\n", packets, packt_nb);
                packet_numbers[packets] = packt_nb;
                packets++;

            }
            

        }
    }
    fclose(fr);

    fw = fopen( "tmp", "w");

    fprintf(fw, "SIZE 8 8    //  X=8  y=8\nPACKETS %d   // PACOTES TRANSMITIDOS\n", packets);

    for(int i = 0; i < packets; i++)
    {

        fr = fopen("outputs/Path.txt", "r");
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

                if(packet_numbers[i]==packt_nb)
                    fprintf(fw, "PKT %d %d %d %c\n", adX, adY, i, port);


            }
        }
        fprintf(fw, "\n");
        fclose(fr);
    }
    

}