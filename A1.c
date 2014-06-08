#include <stdio.h>
#include <string.h>

//Function prototype
void check(const char rawData[ ],int a, int b,int *rv,char signal [ ],int freq,int len,int *counter);
void write(const char rawData[ ],int a, int b,char signal [ ],int counter,int len,int rv,int freq);

int analyze(const char rawData[ ], char signal [ ], int freq, int a, int b){//Main
   int rv = 0, len = strlen(rawData);
   char f = (char)((int)'0')+freq;
   int counter = 0;
   
   check(rawData,a,b, &rv,signal,f,len,&counter);
   if(rv != -1){
   	write(rawData,a,b,signal,counter,len,rv,freq);
   }
   return rv;
   }

void check(const char rawData[ ],int a, int b,int *rv,char signal [ ],int freq,int len,int *counter){//Check function
   int i = 0,ctr = 0,m = 0,space = 0,ETX = 0,NAK = 0,N = 0;
   *signal = '\0';//sets signal to nothing
   *counter = 0;

   for(i; i <= len; i++){
   	if(rawData[i] <= 57 && rawData[i] >= freq){
   	   if(rawData[i] == rawData[i+61] && rawData[i] == rawData[i+122]){///checks for tree same numbers
   	      ctr = 1;
   	      i = i+123;
   	  	   *counter = i;
   	   }
   	}

      if(rawData[i-1] != ' ' && rawData[i] == ' ' && rawData[i+1] == ' ' && ctr == 1 ){//checks for spaces
   		space++;
   	}
      if(rawData[i-1] != ' ' && rawData[i] == ' ' && rawData[i+1] != ' ' && ctr == 1 ){//checks for spaces
         space++;
      }
      if(rawData[i] >= a && rawData[i] <= b && ctr == 1 && rawData[i] != ' '){//counts rv
      	m++;
      }
      if(rawData[i-1] == 'E' && rawData[i] == 'T' && rawData[i+1] == 'X' && ctr == 1){//checks for etx
         ETX = 1;
      }
      if(rawData[i-1] == 'N' && rawData[i] == 'A' && rawData[i+1] == 'K' && ctr == 1){//checks for NAK
         NAK = 1;
      }
      if(rawData[i-1] == 'N' && rawData[i] == 'U' && rawData[i+1] == 'L' && rawData[i+2] == 'L' && ctr == 1){//checks for null
         N = 1;
      }
   }
	*rv = m + space;//final rv
   
   if(len == 0 || ctr == 0 || ETX == 1 || NAK == 1 || N == 1){///if string empty
   	strcpy(signal,"NON-SEQUITOR");
		*rv = -1;
   }

}

void write(const char rawData[ ],int a, int b,char signal [ ],int counter,int len,int rv,int freq){//Writes into signal
	int i = 0;
   *signal = '\0';//sets signal to nothing

   while(rawData[counter] != '\0'){

      if(rawData[counter-2] == '>' && rawData[counter-1] == '>' && rawData[counter] != '>'){//checks for >>
         if(rawData[counter] >= a && rawData[counter] <= b){
         signal[i]=rawData[counter]+freq;
         i++;
         counter++;
         }
      }

      if(rawData[counter-2] == '<' && rawData[counter-1] == '<' && rawData[counter] != '<'){//checks for <<
         if(rawData[counter] >= a && rawData[counter] <= b){
         signal[i]=rawData[counter]-freq;
         i++;
         counter++;
         }
      }

      if(rawData[counter-1] != ' ' && rawData[counter] == ' ' && rawData[counter+1] == ' '){//checks for spaces
            signal[i] = rawData[counter];
            i++;
      }

      if(rawData[counter-1] != ' ' && rawData[counter] == ' ' && rawData[counter+1] != ' '){//checks for spaces
            signal[i] = rawData[counter];
            i++;
      }

      if(rawData[counter] >= a && rawData[counter] <= b && rawData[counter] != '\0' && rawData[counter] != ' '){
         signal[i] = rawData[counter];
         i++;
      }

      if(i == rv){
         break;
      }else{
      counter++;
      }
   }
}
