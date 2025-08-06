/* Thanks to my colleague Elliot Inman for the structure of this code  */


/*  Identify the locations of the R environments, given by the admin */

%LET R0 = default_r;
%LET R1 =r423;

/* Use the DEFAULT R BASE 4.3.3 (note:  Any version can be set to DEFAULT */
options set=R_HOME="/opt/sas/viya/home/sas-pyconfig/&R0./lib64/R";
options nocenter;

/*Get information about the packages */
proc iml;
    submit / R;
      ver = R.version.string
      vdf = data.frame(version = ver)
      pkg = installed.packages()[,c(1,3)]
    endsubmit;
call ImportDataSetFromR("R0_pkg", "pkg");
call ImportDataSetFromR("R0_ver", "vdf");
quit;

data _null_;
set R0_ver;
CALL SYMPUTX("V0",version);
RUN;

TITLE "&r0 Environment R Version ";
PROC SQL;
  SELECT * FROM R0_ver;
QUIT;
TITLE;


title "Linear Model Using &R0 Environment: &V0";
proc iml;
  * Uses a built-in IML function to read SAS data set into R data frame;	
  call ExportDataSetToR("Sashelp.heart", "dframe" );
  submit / R;
		model423=lm(Systolic ~ Height + Weight, data=dframe)
		summary(model423)
  endsubmit;
quit;
TITLE;


/* Use a second R profile BASE 4.3.3 */
options set=R_HOME="/opt/sas/viya/home/sas-pyconfig/&R1./lib64/R";


/*Get information about the packages */
proc iml;
    submit / R;
      ver = R.version.string
      vdf = data.frame(version = ver)
      pkg = installed.packages()[,c(1,3)]
      
    endsubmit;
call ImportDataSetFromR("R1_pkg", "pkg");
call ImportDataSetFromR("R1_ver", "vdf");
quit;

data _null_;
set R1_ver;
CALL SYMPUTX("V1",version);
RUN;

TITLE "&r1 Environment R Version ";
PROC SQL;
  SELECT * FROM R1_ver;
QUIT;
TITLE;
/* Run a linear model */

title "Linear Model Using &R1 Environment: &V1";
proc iml;
  call ExportDataSetToR("Sashelp.Heart", "dframe" );
  submit / R;
		model433=lm(Systolic ~ Height + Weight, data=dframe)
		summary(model433)
  endsubmit;
quit;
TITLE;


/* Run the model in SAS */


title 'Linear Model Using SAS9.4';

ods select ParameterEstimates;  * print only the parameter estimates;
proc glm data = sashelp.heart;
	model Systolic = Height Weight;
run;
quit;
TITLE;

PROC SQL;
CREATE TABLE PKGS AS
SELECT COALESCE(R0.package, R1.package) AS Package "R Package"
       , R0.VERSION AS R0_VERSION "&R0 Environment"
       , R1.VERSION AS R1_VERSION "&R1 Environment"
       
FROM R0_PKG as R0 FULL JOIN R1_PKG as R1
ON R0.Package = R1.Package;
QUIT;

/* Compare the Versions */
data packages;
set PKGS;
  IF R0_VERSION = "" or R1_VERSION  = "" then Status = "Singular ";
   ELSE IF R0_VERSION = R1_VERSION then Status = "Same     ";
    ELSE IF R0_VERSION NE R1_VERSION then Status = "Different";
RUN;

TITLE "Package Comparison of Environments";
TITLE2 "&R0 on &V0";
TITLE3 "&R1 on &V1";

PROC SQL;
SELECT Status, Count(*) as N 
FROM PACKAGES
GROUP BY STATUS;

SELECT * FROM PACKAGES
ORDER BY UPCASE(Package);
QUIT;

TITLE;
TITLE2;
TITLE3;







