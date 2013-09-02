options nodate pageno=1 formdlim='-';


*Ejemplo para calcular el numero de replicas de un diseño completamente aleatorio
basado la potencia del pruebq de F. Se usa el ejemplo del empacado
de carne como referencia. Se asume que la varianza para el error
es igual a 0.12, cuàl es el nùmero de replicas necesarias para 
detectar una diferencia de 1 en unidades de logaritmo de la densidad, 
con una potencia de 0.90 y un alpha de 0.05?; 
 
 data pow;
   	v=4; 
   	array alpha{4} _temporary_ (0.01 0.025 0.05 0.1);
	input id r;
	array power {4} power0_01 power0_025 power0_05 power0_1;
	do i=1 to 9;
   		do j=1 to 4;
    		deltasq=r*((1.0)**2)/(2*.12);
			power{j}=1-probf(finv(1-alpha{j},v-1,v*(r-1)),v-1,v*(r-1),deltasq);
		end;
   	end;
	drop i j id;
	datalines;
	1 2
	2 3
	3 4
	4 5
	5 6
	6 7
	7 8
	8 9
	9 10	
	;
run;
quit;
ods graphics on;
proc sgplot data=pow;
	series x=deltasq y=power0_01;
	series x=deltasq y=power0_025;
	series x=deltasq y=power0_05/;
 	series x=deltasq y=power0_1;
run;
ods graphics off;
proc print data=pow noobs; run;
title1 'Potencia de la prueba de F para un CRD';


*Calculo del numero total de muestras;
proc power;
 onewayanova
 alpha=.05
 groupmeans= 1.5|1|1|.5
 stddev=.3464
 nperg=3
 power=.
 ;
run;
