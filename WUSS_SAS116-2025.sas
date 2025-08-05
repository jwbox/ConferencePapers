/*PROC Python General Example*/

%* Define a SAS macro variable in SAS code;
%let language = 'python';

proc python;
submit;

print("Python in the SAS Log:")

# %*use symget to read a SAS macro variable into a python variable;
lang = SAS.symget('language')
ver = 3.8

# %* Submit SAS code inside python, using python syntax.  This dataset will live in WORK library;
SAS.submit("data work.test; language={}; version={}; run;".format(lang,ver))

# %* Execute SAS functions with sasfnc;
var3 = SAS.sasfnc("upcase","hello world")
print( var3)

# %*Use symput to assign the value of a Python variable to a SAS macro;
py_var = 'Inside python'
SAS.symput('macrovar', py_var)

endsubmit;
run;

%* Show that the SAS macro variable persists and is populated;
%put &=macrovar;

%* Show that the test dataset created in the python code lives in SAS;
proc print data=test;
run;


/*PROC Python Graphics Example*/

%let inputTable = SASHELP.HEART;
%let histX = AgeAtStart;
%let histGroup = Sex;

title "Overlay Histograms with Python Seaborn";
proc python;
submit;

import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd

df = SAS.sd2df(SAS.symget('inputTable'))
Xvar=SAS.symget('histX')
groups=SAS.symget('histGroup')

plt.clf()
sns.histplot(data=df, x=Xvar, hue=groups,alpha=0.5,bins=15,kde=False,palette='Set2', multiple="stack")
SAS.pyplot(plt)

endsubmit;
run;



