* Experimento en Baterias;  ;

* Ilustracion de la estabilizacion de varianza (ver paginas 114-5);
options nodate formdlim='-' pagno=1; 

data batt;
 input typebat life ucost lpuc order;
 datalines;
1   602   0.985   611    1  
2   863   0.935   923    2   
1   529   0.985   537    3  
4   235   0.495   476    4  
1   534   0.985   542    5  
1   585   0.985   593    6  
2   743   0.935   794    7  
3   232   0.520   445    8  
4   282   0.495   569    9  
2   773   0.935   827   10  
2   840   0.935   898   11  
3   255   0.520   490   12  
4   238   0.495   480   13  
3   200   0.520   384   14  
4   228   0.495   460   15  
3   215   0.520   413   16  
;

*la prueba de levene para homogenidad de varianzas;
 proc glm;
 class typebat;
 model life=typebat;
 means typebat/hovtest;
 title1 'Analisis del tiempo de vida de baterias';run;

proc glm;
 class typebat;
 model life=typebat;
 output out=batresids r=residual;
 title1 'Analisis del tiempo de vida de baterias';run;




 proc print data=batresids; run;
proc sort data=batresids;
 by typebat;run;

proc boxplot data=batresids;
 plot residual*typebat / boxstyle=schematicidfar;
 id order;
 title1 'Boxplot de los residuales - note que el tamaño de las cajas es distinto';
 run;
proc means noprint;
 by typebat;
 var life;
 output out=batmeans mean=meanlife var=varlife;run;

proc print data=batmeans;
 title1 'Promedios y varianzas de la vida de las baterias';run;

data batlog;
 set batmeans;
 lnmean=log(meanlife);
 lnvar=log(varlife);run;

proc reg data=batlog;
 model lnvar=lnmean;
 title1 'Modelo de regression ajustando la varianza en funcion de la media de la vida de la bateria';run;
 
 
data battrans;
 set batt;
 newlife=sqrt(life);
 
proc sort data=battrans;
 by typebat;
 
proc means data=battrans noprint;
 var newlife;
 by typebat;
 output out=newmeans mean=mnewlife var=vnewlife;
 
proc print data=newmeans;
 title1 'Promedio y Varianzas despues de estabilizar la varianza';

proc glm data=battrans;
 class typebat;
 model newlife=typebat;
 output out=newresids r=residual;
 title1 'Analisis de la vida de las baterias con datos transformados';

 * prueba de homogenidad de varianza a los datos tranformados;
proc glm data=battrans;
 class typebat;
 model newlife=typebat;
means typebat/hovtest;
 title1 'Analisis de la vida de las baterias con datos transformados';run;

proc boxplot data=newresids;
 plot residual*typebat / boxstyle=schematicidfar;
 id order;
 title1 'Boxplots de los datos, despues de transformacion';

run;





*Aproximacion de Satterthwaithe para problemas de heterocedasticidad;

proc mixed data=batt;
 class typebat;
 model life=typebat/ddfm=satterth;
 repeated / group=typebat;
 estimate "alkaline vs hd" typebat 1 1 -1 -1 / divisor=2;
 lsmeans typebat / pdiff;
 * here showing t-tests so you can compare df to formula;  
 title1 "Analisis del experimento en la vida de las baterias usando el ajuste de Satterthwaite"; run;
