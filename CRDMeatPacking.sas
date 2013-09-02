*Ejemplo  empaque de carne;
options formdlim='-' nodate pageno=1;
data empaque;
input empaque1$ logcount ;
cards;
PlasComer 7.66
PlasComer 6.98
PlasComer 7.8
Vacio 5.26
Vacio 5.44
Vacio 5.8
Mezcla 7.41
Mezcla 7.33
Mezcla 7.04
CO 3.51
CO 2.91
CO 3.66
;
proc print data=empaque;run;

proc glm data=empaque;
class empaque1;
model logcount=empaque1;
run;

proc glm data=empaque;
class empaque1;
model logcount=empaque1/solution;
run;
