* A continuacion se presentan dos analisis de un diseño Carryover. Este
ejemplo procede del texto de Keuhl (1994, pagina 530). Tres dietas rica
en fibras son comparadas utilizando 12 novillos. Cada uno de los novillos
se les da las tres dietas. Un diseño Williams de 12*3 fue usado. 
La respuesta es el coeficiente de digestion conocido como 'Neutral
Detergent Fiber (NDF)';

option formdlim='-' nodate pageno=1;
data kuehl_p530;
 retain diet 'O';
 carry=diet; 
 input steer period diet $ NDF @@;
 if period=1 then carry="O";
 output;
datalines;
 1 1 A 50  1 2 B 61  1 3 C 53
 2 1 A 55  2 2 B 63  2 3 C 57
 3 1 B 44  3 2 C 42  3 3 A 57 
 4 1 B 51  4 2 C 46  4 3 A 59
 5 1 C 35  5 2 A 55  5 3 B 47
 6 1 C 41  6 2 A 56  6 3 B 50
 7 1 A 54  7 2 C 48  7 3 B 51
 8 1 A 58  8 2 C 51  8 3 B 54
 9 1 B 55  9 2 A 57  9 3 C 51
10 1 B 55 10 2 A 59 10 3 C 55
11 1 C 41 11 2 B 56 11 3 A 58
12 1 C 46 12 2 B 58 12 3 A 61 
;
proc print data=kuehl_p530;run;

proc glm;
 class steer period diet carry;
 model NDF = steer period diet carry;
 title "Analisis asumiendo un modelo con efectos fijos";
run;

proc mixed data=kuehl_p530; 
  class  steer period diet carry;
  model NDF = period diet carry;
  repeated / type=ar(1) subject=steer rcorr;
  title "El modelo tiene una correlacion AR(1) entre observaciones 
del mismo novillo"; 

 /* Precaucion: Cuando se usa el comando REPEATED en proc mixed,
				1) los datos deben ser ordenados por peridos para cada
					unidad experimental (como se hizo en el ejemplo), o
				2) el period debe ser especificado como un factor, e.g.					

					repeated period / type=ar(1) subject=steer rcorr;
 */

lsmeans diet/adjust=tukey;
run;
