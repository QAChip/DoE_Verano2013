*Un ingeniero en nutricion realizo un experimento para evaluar los efectos de cuatro complementos 
vitaminicos en la ganancia de peso en animales, en laboratorio. El diseño experimental utilizado fue
un CRD con 5 animales en cautiverio por cada tratamiento. El numero de calorias digeridas es diferente 
entre los animales y se espera que influya en la ganancia de peso, asi que el ingeniero 
cuantifico las calorias ingeridas por cada animal. Los datos de abajo contienen la ganancia de peso y 
las calorias ingeridas dividas por 10;
options formdlim='-' pageno=1 nodate linesize=120;

data rok585;
 input diet grams calories;
 datalines;
  1  48  35
  1  57  40
  1  68  44
  1  69  51
  1  53  47
  2  65  40
  2  49  45
  2  37  37
  2  73  53
  2  63  42
  3  79  51
  3  52  41
  3  63  47
  3  65  47
  3  67  48
  4  59  53
  4  50  52
  4  59  52
  4  42  51
  4  34  43
;
proc print data=rok585; run;

data rok585_covcentered; set rok585;
calories_cen=calories-45.9500000;
run;

proc print data=rok585_covcentered; run;

 title1 'Diagrama de dispersion y ajuste de un regresion simple por dieta';
proc sgplot data=rok585_covcentered;
scatter x=calories_cen y=grams/group=diet;
reg x=calories_cen y=grams/group=diet;
run;

proc glm data=rok585_covcentered;
 class diet;
 model grams = diet calories_cen/solution;
 lsmeans diet/pdiff cl adjust=tukey;
 title1 'Analisis de covarianza ';run;
 
*Ajuste del modelo de covarianza mas completo;

proc glm data=rok585_covcentered;
 class diet;
 model grams = diet  diet*calories_cen;
 lsmeans diet/pdiff  cl adjust=tukey ;
 title2 'Analisis de covarianza usando model general';


run; 


proc glm data=rok585_covcentered;
 class diet;
 model grams = diet calories_cen diet*calories_cen;
 title2 'Verificancion de igualdad de pendientes';


run; 



*Analisis equivalente sin centrar la covariable;

proc glm data=rok585;
 class diet;
 model grams = diet calories ;
 lsmeans diet/pdiff  cl adjust=tukey at calories=50;
 title2 'Verificancion de igualdad de pendientes';


run; 
