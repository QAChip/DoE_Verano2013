*Aleatorizacion de un CRD con v=2 r=2 y n=4;

options nodate formdlim="@" pageno=1;
proc plan seed=1346;
 factors unit=4 random;
  treatments trt=4 cyclic (1 1  2 2) 0;
  output out=problema2tarea1;
  title1 'Aleatorizacion de un CRD';
  title2 'CRD con v=2, r=2, n=4';
run;
proc sort data=problem2HW1 out=problem2HW1;
 by unit;
proc print noobs;
run;
proc sort data=problem2HW1 out=problem2HW1;
 by trt;
proc print noobs;
run; 

