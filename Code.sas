%LET dataset_2018 = '/home/u60688986/Assignment 1/Ulaanbaatar_PM2.5_2018_YTD.csv';
%LET dataset_2019 = '/home/u60688986/Assignment 1/Ulaanbaatar_PM2.5_2019_YTD.csv';
%LET dataset_2020 = '/home/u60688986/Assignment 1/Ulaanbaatar_PM2.5_2020_YTD.csv';
%LET dataset_2021 = '/home/u60688986/Assignment 1/Ulaanbaatar_PM2.5_2021_YTD.csv';

proc import datafile=&dataset_2018
                dbms=csv out=work.data_2018 replace;
	guessingrows=max;
run;

proc import datafile=&dataset_2019
                dbms=csv out=work.data_2019 replace;
	guessingrows=max;
run;

proc import datafile=&dataset_2020
                dbms=csv out=work.data_2020 replace;
	guessingrows=max;
run;

proc import datafile=&dataset_2021
                dbms=csv out=work.data_2021 replace;
	guessingrows=max;
run;

data work.data_2018;
	infile &dataset_2018
                delimiter="," missover dsd firstobs=2;
	format Site $15.;
	format Parameter $18.;
	format 'Date LT'n DATETIME18.;
	format Year 5.;
	format Month 2.;
	format Day 2.;
	format Hour 2.;
	format 'NowCast Conc'n 5.1;
	format AQI 5.;
	format AQI_Category $29.;
	format 'Raw Conc'n 5.;
	format 'Conc Unit'n $7.;
	format Duration $5.;
	format 'QC Name'n $9.;
	input Site $
    Parameter $
                'Date LT'n:ANYDTDTM40.
                Year Month Day Hour 'NowCast Conc'n AQI 
		'AQI_Category'n $
                'Raw Conc'n 'Conc Unit'n $
                Duration $
                'QC Name'n $;
run;

data work.data_2019;
	infile &dataset_2019
                delimiter=',' missover dsd firstobs=2;
	format Site $15.;
	format Parameter $18.;
	format 'Date LT'n DATETIME18.;
	format Year 5.;
	format Month 2.;
	format Day 2.;
	format Hour 2.;
	format 'NowCast Conc'n 5.1;
	format AQI 5.;
	format AQI_Category $29.;
	format 'Raw Conc'n 5.;
	format 'Conc Unit'n $7.;
	format Duration $5.;
	format 'QC Name'n $9.;
	input Site $
    Parameter $
                'Date LT'n:ANYDTDTM40.
                Year Month Day Hour 'NowCast Conc'n AQI 
		'AQI_Category'n $
                'Raw Conc'n 'Conc Unit'n $
                Duration $
                'QC Name'n $;
run;

data work.data_2020;
	infile &dataset_2020
                delimiter=',' missover dsd firstobs=2;
	format Site $15.;
	format Parameter $18.;
	format 'Date LT'n DATETIME18.;
	format Year 5.;
	format Month 2.;
	format Day 2.;
	format Hour 2.;
	format 'NowCast Conc'n 5.1;
	format AQI 5.;
	format AQI_Category $29.;
	format 'Raw Conc'n 5.;
	format 'Conc Unit'n $7.;
	format Duration $5.;
	format 'QC Name'n $9.;
	input Site $
    Parameter $
                'Date LT'n:ANYDTDTM40.
                Year Month Day Hour 'NowCast Conc'n AQI 
		'AQI_Category'n $
                'Raw Conc'n 'Conc Unit'n $
                Duration $
                'QC Name'n $;
run;

data work.data_2021;
	infile &dataset_2021
                delimiter=',' missover dsd firstobs=2;
	format Site $15.;
	format Parameter $18.;
	format 'Date LT'n DATETIME18.;
	format Year 5.;
	format Month 2.;
	format Day 2.;
	format Hour 2.;
	format 'NowCast Conc'n 5.1;
	format AQI 5.;
	format AQI_Category $29.;
	format 'Raw Conc'n 5.;
	format 'Conc Unit'n $7.;
	format Duration $5.;
	format 'QC Name'n $9.;
	input Site $
    Parameter $
                'Date LT'n:ANYDTDTM40.
                Year Month Day Hour 'NowCast Conc'n AQI 
		'AQI_Category'n $
                'Raw Conc'n 'Conc Unit'n $
                Duration $
                'QC Name'n $;
run;

data work.masterdata;
	set work.data_2018 work.data_2019 work.data_2020 work.data_2021;
run;

proc means data=work.masterdata;
run;

proc univariate data=work.masterdata;
run;

proc sort data=work.masterdata nodupkey;
	by _all_;
run;

proc sort data=work.masterdata nodupkey;
	by 'Date LT'n;
run;

proc sort data=work.masterdata;
	by _all_;
run;

data work.no_duplicates work.duplicates;
	set work.masterdata;
	by 'Date LT'n;

	if first.product then
		output work.no_duplicates;
	else
		output work.duplicates;
run;



data masterdata1;
SET work.masterdata;
	If 'NowCast Conc'n < 0 or 'NowCast Conc'n > 500  THEN 'NowCast Conc'n = '';
run;


data masterdata2;
SET work.masterdata1;
	If AQI < 0 or AQI > 500  THEN AQI = '';
run;


data masterdata3;
SET work.masterdata2;
	If 'Raw Conc'n < 0 or 'Raw Conc'n > 500  THEN 'Raw Conc'n = '';
run;


data masterdata4;
 set masterdata3;
 if cmiss(of _all_) then delete;
run;

proc freq data=masterdata4;
tables Site Parameter AQI_Category 'Conc Unit'n Duration 'QC Name'n;
run;

proc univariate data=masterdata4;

run;

proc export data=masterdata4 outfile='/home/u60688986/Assignment D'
dbms=csv;
run;

proc export data=masterdata4
    outfile="/home/u60688986/Assignment 1/data.csv"
    dbms=csv
    replace;
run;


