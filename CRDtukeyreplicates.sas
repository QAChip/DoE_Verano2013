*Ejemplo del calculo del numero de replicas para un CRD basado en el Margen de Error, MdE, 
usando Tukey. El valores de varianza, numero tratamientos, etc, son del experimento en el
empaque de carne. Cuantas replicas son necesarias para alcanzar un MdE<0.5 con un nivel de 0.05
y una varianza de 0.12?;


  
options nodate formdlim='-';

data margenerror;
 v=4;
 alpha=0.05;
 do r=2 to 15;
  q=probmc("RANGE",.,1-alpha,v*(r-1),v);
  MdE=q*sqrt(0.12/r);
  output;
 end;

proc print; run;
