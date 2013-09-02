options nodate formdlim='-' pageno=1;
*Suponga que en el experimento de empaque de carne, se tomaron 3 mediciones del numero de 
bacterias en cada UE. Entonces este diseño es un CRD con submuestreo;
data empaque; 
 input empaque1 $ corte logcount @@; 
 datalines;
Plastico 1 7.46 Plastico 1 7.59 Plastico 1 7.93 
Plastico 2 7.10 Plastico 2 6.88 Plastico 2 6.96 
Plastico 3 8.01 Plastico 3 7.89 Plastico 3 7.50
Vacio 1 5.06 Vacio 1 5.26 Vacio 1 5.46 
Vacio 2 5.41 Vacio 2 5.40 Vacio 2 5.51 
Vacio 3 5.89 Vacio 3 5.88 Vacio 3 5.63 
mezcla 1 7.52 mezcla 1 7.31 mezcla 1 7.40 
mezcla 2 7.39 mezcla 2 7.34 mezcla 2 7.26 
mezcla 3 7.22 mezcla 3 6.94 mezcla 3 6.96 
co2 1 3.55 co2 1 3.58 co2 1 3.40 
co2 2 2.81 co2 2 2.95 co2 2 2.97 
co2 3 3.60 co2 3 3.72 co2 3 3.66
;
proc sort; data=empaque; by empaque1 corte ;run;
proc print data=empaque;run;
proc means;
 var logcount;
 by empaque1 corte;
 title "Promedio de las observaciones de cada UE son los datos de los ejemplos anteriores";

proc glm data=empaque order=data; 
 class empaque1 corte; 
 model logcount=empaque1 corte(empaque1); 
 test h=empaque1 e=corte(empaque1); 
 lsmeans empaque1/pdiff cl adjust=tukey e=corte(empaque1);
 means empaque1/tukey e=corte(empaque1);
 title1 'El empaque de carne con submuestreo'; 
 title2 'Analisis de un CRD con v=4 t=3 y n*= 3';
 * nota: la opcion E= no funciona con ESTIMATE pero si con CONTRAST;
 run;

proc glm data=empaque order=data; 
 class empaque1 corte; 
 model logcount=empaque1 corte(empaque1); 
 random corte(empaque1)/test; 
 * nota: RANDOM no hace que LSMEANS use el termino correcto de error;
 title3 'Una forma alternativa de analisis del CRD para probar la H0 general'; 
 run;

proc mixed data=empaque order=data; 
 class empaque1 corte; 
 model logcount=empaque1; 
 random corte(empaque1); 
 lsmeans empaque1/pdiff cl adjust=tukey;
 estimate 'Vacio vs gases' empaque1 0 2 -1 -1/divisor=2 cl; 
 * nota: la opcion CL tambien funciona con CONTRAST en PROC MIXED;
 title2 'Analisis de un CRD con v=4 t=3 y n*= 3';
 title3 'Usando PROC MIXED';
 run;

 proc glimmix data=empaque order=data;
 class empaque1 corte;
 model logcount=empaque1;
 random  corte*empaque1;
 lsmeans empaque1/plot=meanplot(join cl);
 title2 'Analisis de un CRD con v=4 t=3 y n*= 3';
 title3 'Usando PROC GLIMMIX';
 run;
