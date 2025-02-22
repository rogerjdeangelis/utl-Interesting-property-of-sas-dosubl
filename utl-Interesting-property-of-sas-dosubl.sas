%let pgm=utl-Interesting-property-of-sas-dosubl;

Interesting property of sas dosubl

If you call &sysfunc dosubl inside a macro the
a dosubl datastep code will not
apprear in the resolved macro.

Consider the macro

%macro loadinfile(str)
  /des="load string into the infile buffer";
 %dosubl('
   data _null_;
     file "%sysfunc(getoption(WORK))/tmp.txt";
     put "*";
   run;quit;
   ');

  infile  "%sysfunc(getoption(WORK))/tmp.txt";
  input @;
  _infile_ = &str;

%mend loadinfile;

This code inside the macro will not appear in the resolved loadinfile macro

 %dosubl('
   data _null_;
     file "%sysfunc(getoption(WORK))/tmp.txt";
     put "*";
   run;quit;
   ');


EXAMPLE

INPUT

DATA  have;
  input A $4. B $8. C $4.;
cards4;
Name Address Age
John Carry   66
Andy NYC     32
;;;;
run;quit;

/**************************************************************************************************************************/
/*          STR                                                                                                           */
/*  Jhon Austin B 100kg                                                                                                   */
/*  Mick Gray C 110kg                                                                                                     */
/*  Tom Jef A30kg                                                                                                         */
/**************************************************************************************************************************/

PROCESS

roc datasets lib=work nolist nodetails;
 delete want;
run;quit;

data want; ;

  set sd1.have;

  informat first last $8.
          therest $24. grade $1.;

  * load _infile_ buffer with variable str;
  %loadinfile(str);

  input first last therest & @;

  grade=compress(therest);
  weight=substr(compress(therest),2);

  * restart the buffer;
  input @1 @@;

  keep first last grade weight;
run;quit;

GENERATED CODE (NO DATASTEP)


/**************************************************************************************************************************/
/* THIS CODE IS NOT IN THE GENERATED CODE                                                                                 */
/*  data _null_;                                                                                                          */
/*    file "%sysfunc(getoption(WORK))/tmp.txt";                                                                           */
/*    put "*";                                                                                                            */
/*  run;quit;                                                                                                             */
/**************************************************************************************************************************/

 data want;

 set sd1.have;

 informat first last $8. therest $24. grade $1.;

 * load _infile_ buffer with variable str;
 infile "f:\wrk\_TD18916_T7610_/tmp.txt";

 input @;
 _infile_ = str;

 input first last therest & @;

 grade=compress(therest);
 weight=substr(compress(therest),2);

 * restart the buffer;
 input @1 @@;

 keep first last grade weight;

 run;

 OUTPUT

 /**************************************************************************************************************************/
/* FIRST LAST   GRADE  WEIGHT                                                                                             */
/*                                                                                                                        */
/* Jhon  Austin   B     100kg                                                                                             */
/* Mick  Gray     C     110kg                                                                                             */
/* Tom   Jef      A      30kg                                                                                             */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
