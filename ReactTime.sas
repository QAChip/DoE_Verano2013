*Experimento en la velocidad  de reaccion, problema 4.4, pagina 98;;
options nodate linesize=75 formdlim='-';
data table4_6;
 input order tc cue elaptm reactm;
 timealt=elaptm/5;
 datalines;
  1  6   2    15   0.256
  2  6   2    15   0.281
  3  2   1    10   0.167
  4  6   2    15   0.258
  5  2   1    10   0.182
  6  5   2    10   0.283
  7  4   2     5   0.257
  8  5   2    10   0.235
  9  1   1     5   0.204
 10  1   1     5   0.170
 11  5   2    10   0.260
 12  2   1    10   0.187
 13  3   1    15   0.202 
 14  4   2     5   0.279
 15  4   2     5   0.269
 16  3   1    15   0.198
 17  3   1    15   0.236
 18  1   1     5   0.181
;

proc sort data=table4_6;
 by cue elaptm timealt; run;
 
proc means data=table4_6 noprint;
 var reactm;
 by cue elaptm timealt;
 output out=reactavg mean=avgtime; run;

 proc print data=reactavg;run;

proc sort data=reactavg;
 by cue ; run;
proc sgplot data=reactavg;
 series x=timealt y=avgtime/group=cue;
 *series x=cue y=avgtime/group=timealt;
title1 'Graficas de medias';run;
proc sgplot data=reactavg;
 *series x=timealt y=avgtime/group=cue;
 series x=cue y=avgtime/group=timealt;
title1 'Graficas de medias';run;

proc glm data=table4_6;
 class tc;
 model reactm=tc;
 title1 'Analisis con 6 tratamientos (capitulo 4)';run;
 
 
 
 
proc glm data=table4_6;
 class cue elaptm;
 model reactm=cue elaptm cue*elaptm;
 estimate 'Efecto principal de cue ' cue 3 -3 elaptm 0 0 0 
                            cue*elaptm 1 1 1 -1 -1 -1/divisor=3; 

 contrast 'Efecto principal de cue ' cue 3 -3 elaptm 0 0 0 
                            cue*elaptm 1 1 1 -1 -1 -1; 
 contrast 'Efecto principal de elaptm ' cue 0 0 elaptm 2 0 -2 cue*elaptm 1 0 -1 1 0 -1, 
                                cue 0 0 elaptm 2 -4 2 cue*elaptm 1 -2 1 1 -2 1;
 contrast 'interactions' cue 0 0 elaptm 0 0 0 cue*elaptm 1 0 -1 -1 0 1,
                         cue 0 0 elaptm 0 0 0 cue*elaptm 1 -2 1 -1 2 -1;
 lsmeans elaptm/pdiff cl adjust=tukey;
 lsmeans cue*elaptm/pdiff cl adjust=tukey;
 title1 'Analisis de un factorial 3*2';
 title2 'Estimacion de contrastes usando estimate y contrast statements, la multiple comparacion';
 output out=reactres r=residual; run;
 
proc sort data=reactres;
 by cue elaptm;run;

proc boxplot data=reactres;
 plot residual*tc / boxstyle=schematicidfar;
 id order;
 title1 'Boxplots de los residuales';
 title2 'Problema con la varianza';
 title3 ' puede ser por el tamaño de muestra   ';
 * NOTA: tamaños de muestra pequeños para detectar anomalias;
run;
proc means data=reactres noprint;
 by cue elaptm;
 output out=resvarsall mean=trtmean var=trtvars;run;

proc print data=resvarsall; 
 title1 'Varianzas y promedios por trt';run;

proc means data=reactres noprint;
 by cue;
 output out=resvarscue mean=trtmean var=trtvars;
 run;

proc print data=resvarscue;run;

title1 'Varianzas y promedios por Cue';
proc sort data=reactres;
 by elaptm;run;

proc means data=reactres noprint;
 by elaptm;run;
 output out=resvarselaptm mean=trtmean var=trtvars;

proc print data=resvarselaptm;run;
 title1 'Varianza y promedios por Elapsed Time';

run;

*Ejemplo de datos no balanceados;


data table4_6temp;
 input order tc cue elaptm reactm;
 timealt=elaptm/5;
 *  1  6   2    15   0.256;
 * 2  6   2    15   0.281;

 datalines;
  3  2   1    10   0.167
  4  6   2    15   0.258
  5  2   1    10   0.182
  6  5   2    10   0.283
  7  4   2     5   0.257
  8  5   2    10   0.235
  9  1   1     5   0.204
 10  1   1     5   0.170
 11  5   2    10   0.260
 12  2   1    10   0.187
 13  3   1    15   0.202 
 14  4   2     5   0.279
 15  4   2     5   0.269
 16  3   1    15   0.198
 17  3   1    15   0.236
 18  1   1     5   0.181
;

proc glm data=table4_6temp;
class cue elaptm;
model reactm=cue|elaptm;
run;

proc glm data=table4_6temp;
class cue elaptm;
model reactm=elaptm|cue;
run;
