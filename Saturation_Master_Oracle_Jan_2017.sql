
/***** THESE ARE ALL OF THE FILES CREATED DURING THIS PROCESS - DROP THEM BEFORE RERUNNING 
drop table cpalmieri.css_active_gas1                  ;
drop table cpalmieri.css_inactive_gas1                ;
drop table cpalmieri.GAS_FORECAST_css_gas1            ;
drop table cpalmieri.gas_forecast_TRW_Extras          ;
drop table cpalmieri.GAS_FORECAST_CRIS_BF_TO_TRW      ;
drop table GAS_FORECAST_CRIS_BF_TO_TRW6               ;
drop table cpalmieri.GAS_FORECAST_CRIS_gas1           ;
drop table cpalmieri.GAS_FORECAST_CRIS_330non_ht      ;
drop table cpalmieri.GAS_FORECAST_all_custs           ;
drop table cpalmieri.GAS_FORECAST_all_cust_units      ;

drop table cpalmieri.GAS_FORECAST_cust_acct_sum       ;
drop table cpalmieri.GAS_FORECAST_COMM_TC1            ;
drop table cpalmieri.GAS_FORECAST_COMM_TC             ;
drop table cpalmieri.GAS_FORECAST_MF_HEAT1            ;
drop table cpalmieri.GAS_FORECAST_MF_HEAT             ;
drop table cpalmieri.GAS_FORECAST_RESID_HEAT1         ;
drop table cpalmieri.GAS_FORECAST_RESID_HEAT          ;
drop table cpalmieri.GAS_FORECAST_COML_HEAT1          ;
drop table cpalmieri.GAS_FORECAST_COML_HEAT           ;
drop table cpalmieri.GAS_FORECAST_ALL_HEAT_STRUCT     ;
drop table cpalmieri.GAS_FORECAST_MF_NONHEAT1         ;
drop table cpalmieri.GAS_FORECAST_MF_NONHEAT          ;
drop table cpalmieri.GAS_FORECAST_RESID_NONHEAT1      ;
drop table cpalmieri.GAS_FORECAST_RESID_NONHEAT       ;
drop table cpalmieri.GAS_FORECAST_COML_NONHEAT1       ;
drop table cpalmieri.GAS_FORECAST_COML_NONHEAT        ;
drop table cpalmieri.GAS_FORECAST_ALL_NONHEAT_STRUC   ;
drop table cpalmieri.GAS_FORECAST_ALL_CUST_STRUCT     ;

drop table cpalmieri.gas_forecast_TRW_Master          ;
drop table cpalmieri.gas_forecast_cnty_use_resi1      ;
drop table cpalmieri.gas_forecast_Resi_TRW_Strct      ;
drop table cpalmieri.gas_forecast_Resi_TRW_Strcta     ;
drop table cpalmieri.gas_forecast_EXEMPT_CONDO1       ;
drop table cpalmieri.gas_forecast_cnty_use_comm1      ;
drop table cpalmieri.gas_forecast_Comm_TRW_Strct      ;
drop table cpalmieri.gas_forecast_Comm_TRW_Strcta     ;
drop table cpalmieri.gas_forecast_cnty_use_MFAM1      ;
drop table cpalmieri.gas_forecast_MFAM_TRW_Strct      ;
drop table cpalmieri.gas_forecast_MFAM_TRW_Strcta     ;
drop table cpalmieri.gas_forecast_cnty_use_CONDO1     ;
drop table cpalmieri.gas_forecast_CONDO_TRW_Strct     ;
drop table cpalmieri.gas_forecast_CONDO_TRW_Strcta    ;
drop table cpalmieri.gas_forecast_cnty_use_UNKNOWN1   ;
drop table cpalmieri.gas_forecast_UNKNOWN_TRW_Strct   ;
drop table cpalmieri.gas_forecast_UNKNWN_TRW_Strcta   ;
drop table cpalmieri.GAS_FORECAST_abi_structs         ;
drop table cpalmieri.GAS_FORECAST_abi_structsa        ;
drop table cpalmieri.GAS_FORECAST_Dnnlly_structs      ;
drop table cpalmieri.GAS_FORECAST_Dnnlly_structsa     ;
drop table cpalmieri.gas_forecast_TRW_Strct_final     ;
drop table cpalmieri.gas_forecast_TRW_sqrft           ;

drop table cpalmieri.GAS_FORECAST_cust6               ;
drop table cpalmieri.GAS_FORECAST_trw6                ;
drop table cpalmieri.GAS_FORECAST_test_both6          ;
drop table cpalmieri.GAS_FORECAST_test_update6        ;
drop table cpalmieri.GAS_FORECAST_test_update6b       ;
drop table cpalmieri.GAS_FORECAST_TRW_HT_Rate_Match   ;
drop table cpalmieri.GAS_FORECAST_CUST_HT_Rate_Mtch   ;

drop table cpalmieri.GAS_FORECAST_TRW_Rt_Mtch_cnty    ;
drop table cpalmieri.GAS_FORECAST_CUST_Rt_Mtch_cnty   ;
drop table cpalmieri.GAS_FORECAST_CUST_Rt_Mtch2       ;
drop table cpalmieri.GAS_FORECAST_TRW_Rt_Mtch_cnty2   ;
drop table cpalmieri.GAS_FORECAST_TRW_Rt_Mtch_cnty3   ;
drop table cpalmieri.GAS_FORECAST_TRW_Rt_Mtch_rgn     ;
drop table cpalmieri.GAS_FORECAST_TRW_Rt_sub_rgn      ;
drop table cpalmieri.GAS_FORECAST_TRW_Rt_mkt_rgn      ;
drop table cpalmieri.GAS_FORECAST_Dnnlly_structs2     ;
*/

/***** Let the Saturation Begin! *****/

/*** Check that the mains data has been updated:
As of April, 2014 The following people are the contacts for mains data:
Linus Vebeliunas takes care of the Brooklyn, Queens, Staten Island, and Long Island data
Abdelilah Elouafa takes care of the RI Mapping, Dharmendra Sonawane - IBM Support Team (offshore)
The RI data will be automated in about 4 months from April, 2014
Brian Miller is the UNY Mapping Manager, Dharmendra Sonawane - IBM Support Team (offshore)
*/

/**** Check the constrained zips for any updates - Peter Metzdorff - 2015 ****/

/* check for blank county use codes */
select z.region, 
t.cde_state_trw,
t.cde_county_trw,
sum(case
  when substr(t.txt_county_use1_trw,1,1) = ' ' or t.txt_county_use1_trw is null then 1
  else 0
end) as blank_use,
count(*) as tot_count
from mi_edr_prod.edr_trw t
join cpalmieri.zips_franchise_gas_forecast z
on t.adr_situs_zip_trw = z.zip5
where z.region <> 'NH'
group by z.region, 
t.cde_state_trw,
t.cde_county_trw;

/* test for missing county use codes */
select z.region, 
t.cde_county_trw,
z.county_name,
t.cde_state_trw,
t.txt_county_use1_trw , 
count(*)
from mi_edr_prod.edr_trw t
join cpalmieri.zips_franchise_gas_forecast z
on t.adr_situs_zip_trw = z.zip5
left join gas_forecast_cntyuse_market f
on t.txt_county_use1_trw = f.county_use_code
and z.region = f.region
where f.county_use_code is null
and t.txt_county_use1_trw <> ' '
and z.region <> 'NH'
group by z.region, 
t.cde_county_trw,
z.county_name,
t.cde_state_trw,
t.txt_county_use1_trw;
/* these are exceptions:
REGION	CDE_COUNTY_TRW	CDE_STATE_TRW	TXT_COUNTY_USE1_TRW	COUNT(*)
LI	059	36	4601	1
LI	059	36	5450	1
LI	059	36	7290	1
LI	059	36	8101	1
LI	059	36	9320	2
LI	059	36	5900	1
LI	059	36	5830	5
MA	001	25	953	51
MA	001	25	990	2765
MA	001	25	950	341
MA	001	25	940	98
MA	001	25	970	215
MA	001	25	930	6062
MA	003	25	970	75
MA	003	25	953	26
MA	003	25	940	274
MA	003	25	990	301
MA	003	25	930	1871
MA	003	25	950	754
MA	003	25	815	1
MA	005	25	940	148
MA	005	25	950	497
MA	005	25	930	6034
MA	005	25	970	450
MA	005	25	953	159
MA	005	25	990	1556
MA	005	25	451	12
MA	007	25	451	1
MA	007	25	930	744
MA	007	25	953	5
MA	007	25	940	10
MA	007	25	970	1
MA	007	25	950	149
MA	007	25	990	613
MA	009	25	950	1318
MA	009	25	953	158
MA	009	25	970	298
MA	009	25	990	1248
MA	009	25	930	7687
MA	009	25	940	438
MA	009	25	002	1
MA	011	25	940	148
MA	011	25	950	261
MA	011	25	990	353
MA	011	25	970	45
MA	011	25	930	1544
MA	011	25	953	68
MA	011	25	451	1
MA	013	25	930	4516
MA	013	25	451	4
MA	013	25	940	313
MA	013	25	953	58
MA	013	25	950	605
MA	013	25	990	483
MA	013	25	970	269
MA	015	25	950	247
MA	015	25	815	3
MA	015	25	940	545
MA	015	25	930	1753
MA	015	25	990	354
MA	015	25	970	71
MA	015	25	953	27
MA	017	25	953	125
MA	017	25	815	3
MA	017	25	970	847
MA	017	25	930	14296
MA	017	25	451	2
MA	017	25	990	1738
MA	017	25	940	1272
MA	017	25	950	1764
MA	019	25	930	682
MA	019	25	940	33
MA	019	25	950	727
MA	019	25	953	2
MA	019	25	970	14
MA	019	25	451	1
MA	019	25	990	761
MA	021	25	930	7003
MA	021	25	953	95
MA	021	25	970	318
MA	021	25	990	1051
MA	021	25	950	488
MA	021	25	940	361
MA	023	25	950	703
MA	023	25	930	8546
MA	023	25	940	91
MA	023	25	953	109
MA	023	25	970	173
MA	023	25	990	959
MA	023	25	499	3
MA	025	25	990	11185
MA	025	25	930	3530
MA	025	25	940	742
MA	025	25	953	126
MA	025	25	970	783
MA	025	25	950	334
MA	027	25	950	1217
MA	027	25	451	2
MA	027	25	990	1737
MA	027	25	930	7848
MA	027	25	815	7
MA	027	25	940	652
MA	027	25	970	344
MA	027	25	604	4
MA	027	25	953	109
NYC	047	36	E2	20
NYC	047	36	HB	4
NYC	047	36	HH	1
NYC	047	36	K8	21
NYC	047	36	GU	27
NYC	047	36	HR	6
NYC	047	36	GW	29
NYC	061	36	HB	29
NYC	061	36	HR	27
NYC	061	36	HH	13
NYC	061	36	HS	29
RI	005	25	930	2
UNY	119	36	571	3
*/


/*
insert into gas_forecast_cntyuse_market
select 'MA','002','COML','MULTIPLE USE CODES','' from dual
union
select 'MA','451','COML','ELECTRIC GENERATION PLANTS, RENEWABLE','' from dual
union 
select 'MA','499','COML','HANGAR','' from dual
union 
select 'MA','604','PUBLIC LAND','OPEN SPACE','' from dual
union 
select 'MA','815','VACANT-COMM','RECREATIONAL - PRODUCTIVE WOODLAND - WOODLOTS','' from dual
union 
select 'MA','930','VACANT-COMM','VACANT-SELECTMEN OR CITY COUNCIL','' from dual
union 
select 'MA','940','COML','ELEMENTARY LEVEL SCHOOL','' from dual
union 
select 'MA','950','VACANT-UNDVLPBL','VACANT, CONSERVATION ORGANIZATIONS','' from dual
union 
select 'MA','953','COML','CEMETERIES','' from dual
union 
select 'MA','970','COML','HOUSING AUTHORITY','' from dual
union 
select 'MA','990','CONDO','EXEMPT CONDO-OTHER','' from dual
union
select 'LI','571','VACANT-COMM','VACANT LAND-BULK HEAD','' from dual
union
select 'NYC','GW','COML','CAR WASH','' from dual
union
select 'NYC','GU','COML','AUTOMOBILE DEALER','' from dual
union
select 'NYC','E2','COML','FIREPROOF WAREHOUSE','' from dual
union
select 'NYC','HB','COML','HOTEL','' from dual
union
select 'NYC','K8','COML','HOTEL','' from dual
;

select * from gas_forecast_cntyuse_market
where region = 'RI';

insert into gas_forecast_cntyuse_market
select 'RI','930','VACANT-COMM','VACANT-SELECTMEN OR CITY COUNCIL','RI and MA are basically the same' from dual
;

insert into gas_forecast_cntyuse_market
select 'UNY','571','VACANT-COMM','VACANT LAND-BULK HEAD','' from dual
;

*/

/* Create active account file from CSS Gas view */
create table css_active_gas1 tablespace large_data as
select 
ky_ba, 
ky_cust_no, 
ky_prem_no, 
case
  when cd_co = 12 then 'UNY'
  when cd_co = 37 then 'LI'
  when cd_co = 49 then 'RI'
end as region,
gas_rate_schedule, 
gasratetype, 
sitehsenumb, 
Sitehsealph,
sitestrprfx, 
sitestrname, 
sitestrsfx1, 
sitestrsfx2, 
sitezip5, 
sitecity, 
sitestate, 
sitescr, 
service_type_code
from mi_css_prod.css_active_gas_view a;
/* approx 3 minutes to run */


select count(*), count(distinct Sitehsenumb||Sitestrprfx||Sitestrname||Sitestrsfx1||Sitestrsfx2||SiteZip5),
count(distinct Sitehsenumb||Sitehsealph||Sitestrprfx||Sitestrname||Sitestrsfx1||Sitestrsfx2||SiteZip5)
from css_active_gas1;
/* 
COUNT(*)	COUNT(DISTINCTSITEHSENUMB||SIT	COUNT(DISTINCTSITEHSENUMB||SIT
Feb 2017:
1474324	1231339	1237960
Mar 2016:
1460554	1221755	1227936
Apr 2015:
1445799	1211992	1218116
Apr 2014 :
1429933	1208824	1214770
*/


select * from css_active_gas1;

select region, gas_rate_schedule, count(distinct gasratetype) 
from css_active_gas1
group by region, gas_rate_schedule;

select region, gas_rate_schedule, gasratetype, count(*)
from css_active_gas1
group by region, gas_rate_schedule, gasratetype;


/* Select the accounts and addresses of inactive accounts */
create table css_inactive_gas1 as
/*select count(distinct Sitehsenumb||Sitestrprfx||Sitestrname||Sitestrsfx1||Sitestrsfx2||SiteZip5) from(*/
select
b.ky_ba,
b.ky_cust_no,
b.ky_prem_no,
case
  when cd_co = 12 then 'UNY'
  when cd_co = 37 then 'LI'
  when cd_co = 49 then 'RI'
end as region,
/*
case
  when a2.adr_std_st = 'NY' then 'UNY'
  when a2.adr_std_st = 'RI' then 'RI'
end as region,*/
c.CD_TAR_SCH as Gas_Rate_Schedule,
a2.adr_std_hse_nbr   AS Sitehsenumb,
a2.adr_std_hse_alpha as Sitehsealph,
a2.adr_std_pre_dir   AS Sitestrprfx,
a2.adr_std_str_nm    AS Sitestrname,
a2.adr_std_str_sfx   AS Sitestrsfx1,
a2.adr_std_sfx_dir   AS Sitestrsfx2,
a2.adr_std_zip       AS SiteZip5,   
a2.adr_std_city      AS SiteCity,   
a2.adr_std_st        AS SiteState,  
a2.adr_std_score     AS SiteScr,
c.cd_spt_stat
from MI_CSS_PROD.CU02TB01_BILL_ACCT b
JOIN MI_CSS_PROD.CU02TB02_ADDRESSES A2
ON B.KY_PREM_NO = A2.KY_AD
AND A2.CD_AD_TYPE = 'P' 
join MI_CSS_PROD.CU04TB03_SERVC_PT C
ON b.KY_PREM_NO = C.KY_PREM_NO
where b.CD_BA_STAT <> '02' /* Inactive account */
and c.cd_spt_type = '0100' /* Gas Customer */
/*and c.cd_spt_stat <> '02' /* inactive */
/*and B.KY_PREM_NO != any(select q.ky_prem_no from MI_CSS_PROD.CU02TB01_BILL_ACCT q
JOIN MI_CSS_PROD.CU02TB02_ADDRESSES z
ON q.KY_PREM_NO = z.KY_AD
AND z.CD_AD_TYPE = 'P' 
where q.CD_BA_STAT = '02'
and a2.adr_std_hse_nbr   = z.adr_std_hse_nbr  
and a2.adr_std_pre_dir   = z.adr_std_pre_dir  
and a2.adr_std_str_nm    = z.adr_std_str_nm   
and a2.adr_std_str_sfx   = z.adr_std_str_sfx  
and a2.adr_std_sfx_dir   = z.adr_std_sfx_dir  
and a2.adr_std_zip       = z.adr_std_zip      
))*/;
/* 1 minute to run */

select count(*), count(distinct Sitehsenumb||Sitestrprfx||Sitestrname||Sitestrsfx1||Sitestrsfx2||SiteZip5),
count(distinct Sitehsenumb||Sitehsealph||Sitestrprfx||Sitestrname||Sitestrsfx1||Sitestrsfx2||SiteZip5)
from css_inactive_gas1;
/* Feb 2017 - 3744326	676906	681407
   Mar 2016 - 3482762	640792	644844
   Apr 2015 - 3201766	592961	596531
   Apr 2014 - 2921112	553753	556973
   May 2013 - 2572624	440103	442656
*/

/* remove any overlaping Addresses with active accounts - DID NOT RUN THIS
delete from css_inactive_gas1 a
WHERE exists(select * from css_active_gas1 b
where a.Sitehsenumb   = b.Sitehsenumb  
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5      
);*/

/* remove any overlaping ky_prem with active accounts */
delete from css_inactive_gas1 a
WHERE exists(select * from css_active_gas1 b
where a.ky_prem_no   = b.ky_prem_no  
);
/* 
Feb 2017 - 3,248,722 deleted
Mar 2016 - 3,000,351 deleted
Apr 2015 - 2,747,876 deleted
Apr 2014 - 2,494,744 deleted 
May 2013 - 2,191,125 deleted 
Jan 2013 - 2,131,821 deleted */

select count(*), count(distinct Sitehsenumb||Sitestrprfx||Sitestrname||Sitestrsfx1||Sitestrsfx2||SiteZip5),
count(distinct Sitehsenumb||Sitehsealph||Sitestrprfx||Sitestrname||Sitestrsfx1||Sitestrsfx2||SiteZip5)
from css_inactive_gas1;
/* 
Feb 2017 - 495604	106698	107338
Mar 2016 - 482411	106873	107499
Apr 2015 - 453890	94557	  95016
Apr 2014 - 426368	92048	  92484
May 2013 - 381499	73014	  73351
Dec 2012 - 376480	72308
May 2012 - 353889 */

/*
select * from MI_CSS_PROD.CU04TB03_SERVC_PT C
where c.cd_spt_type = '0100'
and ky_prem_no in(select ky_prem_no from css_inactive_gas1 group by ky_prem_no having count(*)>5);
*/

select region, 
count(*), 
count(distinct Sitehsenumb||Sitestrprfx||Sitestrname||Sitestrsfx1||Sitestrsfx2||SiteZip5),
count(distinct Sitehsenumb||Sitehsealph||Sitestrprfx||Sitestrname||Sitestrsfx1||Sitestrsfx2||SiteZip5)
from css_active_gas1
group by region;
/*
Feb 2017:
REGION	COUNT(*)	COUNT(DISTINCTSITEHSENUMB||SIT	COUNT(DISTINCTSITEHSENUMB||SIT
LI	592630	523228	526249
RI	267277	204381	205848
UNY	614417	503730	505863

Mar 2016:
REGION	COUNT(*)	COUNT(DISTINCTSITEHSENUMB||SIT	COUNT(DISTINCTSITEHSENUMB||SIT
LI	586609	518239	520973
RI	264674	202736	204089
UNY	609271	500780	502874

Apr 2015:
REGION	COUNT(*)	COUNT(DISTINCTSITEHSENUMB||SIT	COUNT(DISTINCTSITEHSENUMB||SIT
LI	579268	512359	515055
RI	262534	201510	202851
UNY	603997	498124	500211

Apr 2014:
REGION	COUNT(*)	COUNT(DISTINCTSITEHSENUMB||SIT	COUNT(DISTINCTSITEHSENUMB||SIT
LI	570225	509041	511661
RI	260316	199960	201283
UNY	599392	499823	501826
*/

select region, count(*), 
count(distinct Sitehsenumb||Sitestrprfx||Sitestrname||Sitestrsfx1||Sitestrsfx2||SiteZip5),
count(distinct Sitehsenumb||Sitehsealph||Sitestrprfx||Sitestrname||Sitestrsfx1||Sitestrsfx2||SiteZip5)
from css_inactive_gas1
group by region;
/*
Feb 2017:
REGION	COUNT(*)	COUNT(DISTINCTSITEHSENUMB||SIT	COUNT(DISTINCTSITEHSENUMB||SIT
LI	53132	31287	31558
RI	56006	15401	15477
UNY	386466	60010	60303

Mar 2016:
REGION	COUNT(*)	COUNT(DISTINCTSITEHSENUMB||SIT	COUNT(DISTINCTSITEHSENUMB||SIT
LI	50448	31694	31948
RI	55694	15670	15752
UNY	376269	59509	59799

Apr 2015:
REGION	COUNT(*)	COUNT(DISTINCTSITEHSENUMB||SIT	COUNT(DISTINCTSITEHSENUMB||SIT
LI	33989	20325	20428
RI	51828	15437	15514
UNY	368073	58795	59074

Apr 2014:
REGION	COUNT(*)	COUNT(DISTINCTSITEHSENUMB||SIT	COUNT(DISTINCTSITEHSENUMB||SIT
LI	28496	18163	18265
RI	45966	14717	14778
UNY	351906	59168	59441
*/

delete from css_inactive_gas1 where region is null;
/* 0 rows deleted */

/* I imported the Rates from the Rates tab in \Chris\Dale_Kruchten\gas_forecast_saturation\Rate_Code_Master.xls */
select * from GAS_FORECAST_RATE_MARKET_SRVC
order by region, rate, market;

grant select on GAS_FORECAST_RATE_MARKET_SRVC to mihnevas, superuser;

/* take old LI rates from CAS keep them, but make them unusable for LI 
update GAS_FORECAST_RATE_MARKET_SRVC
set region = 'LIOLD'
where region = 'LI';


insert into GAS_FORECAST_RATE_MARKET_SRVC
select * from GAS_FORECAST_LI_CSS_RATE_UPDT;

select * from GAS_FORECAST_RATE_MARKET_SRVC
where region = 'LI';
*/

/* import the County_Use_Codes tab from Rate_Code_Master.xls in the \Chris\Dale_Kruchten\gas_forecast_saturation directory */
select * from GAS_FORECAST_CNTYUSE_MARKET;

/* add the market and service fields to break them out individually */
alter table css_active_gas1
add(MARKET VARCHAR2(15), SERVICE VARCHAR2(10));

alter table css_inactive_gas1
add(MARKET VARCHAR2(15), SERVICE VARCHAR2(10));

/* set the market and service based on the rate_service table */
update css_active_gas1 a
set (a.market,
a.service) =
(select b.market,
b.service
from GAS_FORECAST_RATE_MARKET_SRVC b
where a.region = b.region
and a.gas_rate_schedule = b.rate)
;


/* set the market and service based on the rate_service table */
update css_inactive_gas1 a
set (a.market,
a.service) =
(select b.market,
b.service
from GAS_FORECAST_RATE_MARKET_SRVC b
where a.region = b.region
and a.gas_rate_schedule = b.rate)
;

select region, gasratetype, market, service, count(*)
from css_active_gas1
group by region, gasratetype, market, service;

/* This selects CSS gas rates missing from the GAS_FORECAST_RATE_MARKET_SRVC table */
select region, gasratetype, gas_rate_schedule,a. market, service, count(*)
from css_active_gas1 a
where market is null
group by region, gasratetype, gas_rate_schedule, market, service;
/* 
Feb 2017: No new rates
Mar 2016: No new rates
Apr 2015:
REGION	GASRATETYPE	GAS_RATE_SCHEDULE	MARKET	SERVICE	COUNT(*)
UNY	6 - Other Non Heat	483			1
RI	4 - Comm Non Heat	426			1

Apr 2014:
REGION	GASRATETYPE	GAS_RATE_SCHEDULE	MARKET	SERVICE	COUNT(*)
UNY	6 - Other Non Heat	491			1
RI	4 - Comm Non Heat	427			1
*/

/*

select * from MI_CSS_PROD.CU04TB05_TAR_SCH
where cd_tar_sch in('483','426');

select * from MI_CSS_PROD.CU04TB05_TAR_SCH
where cd_tar_sch in('491','427');

select * from MI_CSS_PROD.CU04TB05_TAR_SCH
where cd_tar_sch in('409','410','411','412','413','414','415','416','425','439','440')
;

select * from GAS_FORECAST_RATE_MARKET_SRVC
where rate in ('491','427')
;
insert into GAS_FORECAST_RATE_MARKET_SRVC
select 'RI','426','COML','NONHEAT',' ',' ' from dual;	 	 
insert into GAS_FORECAST_RATE_MARKET_SRVC
select 'UNY','483','COML','NONHEAT',' ',' ' from dual;	 	 

update css_active_gas1 a
set (a.market,
a.service) =
(select b.market,
b.service
from GAS_FORECAST_RATE_MARKET_SRVC b
where a.region = b.region
and a.gas_rate_schedule = b.rate)
where market is null
;
update css_inactive_gas1 a
set (a.market,
a.service) =
(select b.market,
b.service
from GAS_FORECAST_RATE_MARKET_SRVC b
where a.region = b.region
and a.gas_rate_schedule = b.rate)
where market is null
;
*/

select * from css_inactive_gas1
where market is null;

select * from css_inactive_gas1;

/* This selects CSS gas rates missing from the GAS_FORECAST_RATE_MARKET_SRVC table */
select region, gas_rate_schedule,a. market, service, count(*)
from css_inactive_gas1 a
where market is null
group by region, gas_rate_schedule, market, service;
/*
Feb 2017:
REGION	GAS_RATE_SCHEDULE	MARKET	SERVICE	COUNT(*)
LI	???			541
LI	 			12

Mar 2016:
REGION	GAS_RATE_SCHEDULE	MARKET	SERVICE	COUNT(*)
LI	???			543
LI	465			6
LI	 			13

REGION	GAS_RATE_SCHEDULE	MARKET	SERVICE	COUNT(*)
LI	???			543
LI	 			12
*/


/* Run the \analysts\chris\oracle_sql\CSS_GAS_HEAT_FLAG_UPDATE.SQL code signed on under the MIUSER ID
to update any commercial accounts that could now be heating.  It takes at least 1 hour to run this code */

/* update the RI commercial based on usage patterns */
update css_active_gas1 a
set service = 'HEATING'
where a.ky_prem_no in(select prem_no from miuser.CSS_gas_heat_flag)
and region = 'RI';
/* 
21,073 updated Feb 2017
20,497 updated Mar 2016
18,416 updated Apr 2015
18,704 updated Apr 2014
18,321 updated May 2013
17462 updated Jan 2013 */

update css_inactive_gas1 a
set service = 'HEATING'
where a.ky_prem_no in(select prem_no from miuser.CSS_gas_heat_flag)
and region = 'RI';
/* 
2665 updated Feb 2017
2328 updated Mar 2016
1694 updated Apr 2015
961 updated Apr 2014
699 updated May 2013
435 updated Jan 2013 */

/* check for duplicate ky_prem_no with multiple service types */
select ky_prem_no, count(*)
from css_inactive_gas1
group by ky_prem_no
having count(distinct service)>1;

/* remove any non heating premise where the ky_prem_no has both heating and non heating rates keeping only the heating*/
delete from css_inactive_gas1
where ky_ba in(
select distinct ky_ba from css_inactive_gas1 
where ky_prem_no in(select ky_prem_no
                 from css_inactive_gas1
                 group by ky_prem_no
                 having count(distinct service)>1)
and service = 'NONHEAT')
and service = 'NONHEAT';
/* 
1224 deleted Feb 2017
1066 deleted Mar 2016
938 deleted Apr 2015 
965 deleted Apr 2014
775 deleted */

select count(*), count(distinct ky_prem_no) from css_inactive_gas1;
/* 
Feb 2017: 494380	146127
Mar 2016: 481345	146538
Apr 2015: 452952	129785
Apr 2014: 425403	123486
May 2013: 380724  101283
Dec 2012: 375625	 99980
Oct 2012: 403597	106747
May 2012: 353158	97862
*/

/* remove duplicate ky_prem_no */
delete from css_inactive_gas1 a
where rowid < any(select rowid from css_inactive_gas1 b where a.ky_prem_no = b.ky_prem_no)
;
/* 
Feb 2017 - 348,253 deleted
Mar 2016 - 334,807 deleted
Apr 2014 - 323,167 deleted
Apr 2014 - 301,917 deleted
May 2013 - 279,441 deleted 
Dec 2012 - 275,645 deleted */

select count(*), count(distinct ky_prem_no) from css_inactive_gas1;
/* 
Feb 2017 - 146127	146127
Mar 2016 - 146538	146538
Apr 2015 - 129785	129785
Apr 2014 - 123486	 123486
May 2013 - 101283  101283
Dec 2012 -  99980	  99980
Oct 2012 - 106747	 106747
May 2012 -  97862	  97862
*/

select count(*), 
count(distinct Sitehsenumb||Sitestrprfx||Sitestrname||Sitestrsfx1||Sitestrsfx2||SiteZip5),
count(distinct Sitehsenumb||Sitehsealph||Sitestrprfx||Sitestrname||Sitestrsfx1||Sitestrsfx2||SiteZip5)
from css_inactive_gas1;

/* 
Feb 2017: 146127	106698 107338
Mar 2016: 146538  106873 107499
Apr 2015: 129785	94557	 95016
Apr 2014: 123486	92048	 92484
*/


/* combine active and inactive tables into 1 table */
create table GAS_FORECAST_css_gas1 tablespace large_data as
select 
to_char(ky_ba) as ACCTNUM, 
/*ky_cust_no, 
ky_prem_no, */
region, 
gas_rate_schedule as cde_rte, 
sitehsenumb, 
Sitehsealph,
sitestrprfx, 
sitestrname, 
sitestrsfx1, 
sitestrsfx2, 
sitezip5, 
sitecity, 
sitestate, 
sitescr, 
market, 
service,
'Y' as active_status
from css_active_gas1
union
select 
to_char(ky_ba) as ACCTNUM, 
/*ky_cust_no, 
ky_prem_no, */
region, 
gas_rate_schedule as cde_rte,
sitehsenumb,
Sitehsealph, 
sitestrprfx, 
sitestrname, 
sitestrsfx1, 
sitestrsfx2, 
sitezip5, 
sitecity, 
sitestate, 
sitescr, 
market, 
service,
'N' as active_status
from css_inactive_gas1;

select count(*) from GAS_FORECAST_css_gas1;
/* 
Feb 2017: 1,620,426
Mar 2016: 1,607,066
Apr 2015: 1,575,554
Apr 2014: 1,553,392 (LI data now in CSS)
May 2013: 952,385
*/

select region, cde_rte, market, service, count(*)
from GAS_FORECAST_css_gas1 a
where market is null
group by region, cde_rte, market, service;

select * from GAS_FORECAST_css_gas1 where cde_rte = '465'
/*
Feb 2017:
REGION	CDE_RTE	MARKET	SERVICE	COUNT(*)
LI	???			505
LI	 			12

Mar 2016:
REGION	GAS_RATE_SCHEDULE	MARKET	SERVICE	COUNT(*)
LI	???			543
LI	465			6 - inactive accts that look like company accts
LI	 			13

According to Dawn Herrity, Rate 465 is the tariff requirements for an ESCO - they don't necessarily 
have an account but these are their requirements to be an ESCO in our service territory - there 
are no customers under this service class.  The null market records will be deleted later in the code. 
*/

/**************************************************************/
/********* Begin CRIS Pull ************************************/
/**************************************************************/

/* Create a file that gets the CRIS Address that best matches TRW */
/* See how many that join to trw are what code type */
create table GAS_FORECAST_CRIS_BF_TO_TRW as
select distinct a.key_bld_face, 
key_prem, 
cde_type_adr,
t.id_apn_trw,
t.cde_county_trw,
t.cde_state_trw,
a.adr_std_score,
t.cde_situs_code1_score_trw,
case
  when t.adr_situs_zip_trw is not null then 1
  else 0
end as TRW_MATCH,
case
  when t.adr_situs_zip_trw is not null then 7
  else 0
end as TRW_MATCH_TYPE
from mi_cris_prod.BUILDING_FACE a
left join mi_edr_prod.edr_trw t
on a.adr_std_hse_nbr    = t.adr_situs_hse_num_trw  
and a.adr_std_hse_alpha = t.adr_situs_hse_alpha_trw
and a.adr_std_pre_dir   = t.adr_situs_str_prfx_trw  
and a.adr_std_str_nm    = t.adr_situs_str_nme_trw  
and a.adr_std_str_sfx   = t.adr_situs_str_sufx1_trw  
and a.adr_std_sfx_dir   = t.adr_situs_str_sufx2_trw
and a.adr_std_zip       = t.adr_situs_zip_trw
;

select count(*) from GAS_FORECAST_CRIS_BF_TO_TRW;
/* Feb 2017 - 1706793
Mar 2016 - 1694509
Apr 2015 - 1682110
*/

/* Create a match on 6 address pieces to make up for any non matches on the seven address pieces */
create table GAS_FORECAST_CRIS_BF_TO_TRW6 as
select distinct a.key_bld_face, 
key_prem, 
cde_type_adr,
t.id_apn_trw,
t.cde_county_trw,
t.cde_state_trw,
a.adr_std_score,
t.cde_situs_code1_score_trw,
1 as TRW_MATCH,
6 as TRW_MATCH_TYPE
from mi_cris_prod.BUILDING_FACE a
join mi_edr_prod.edr_trw t
on a.adr_std_hse_nbr    = t.adr_situs_hse_num_trw  
and a.adr_std_pre_dir   = t.adr_situs_str_prfx_trw  
and a.adr_std_str_nm    = t.adr_situs_str_nme_trw  
and a.adr_std_str_sfx   = t.adr_situs_str_sufx1_trw  
and a.adr_std_sfx_dir   = t.adr_situs_str_sufx2_trw
and a.adr_std_zip       = t.adr_situs_zip_trw
;

/* Remove any overlaps between the 7 address piece match and the 6 address piece match */
delete from GAS_FORECAST_CRIS_BF_TO_TRW6 a
where key_prem in(select key_prem from GAS_FORECAST_CRIS_BF_TO_TRW where TRW_MATCH = 1);
/* Feb 2017 - 1,476,121 deleted
Mar 2016 - 1,460,377 deleted
2015 - 1,448,220 deleted
1,381,565 deleted */

select count(*), count(distinct key_prem) from GAS_FORECAST_CRIS_BF_TO_TRW6;
/* Feb 2017: 1232	820
Mar 2016: 1244	845
Apr 2015: 1219	832
1,538  935 */


/* remove the records matched by the 6 address match from the 7 piece address match */
delete from GAS_FORECAST_CRIS_BF_TO_TRW a
where key_prem in (select key_prem from GAS_FORECAST_CRIS_BF_TO_TRW6);
/* Feb 2017 - 836 deleted
Mar 2016 - 862 deleted 
846 deleted
3195 deleted */

/* add back the records matched by 6 address pieces */
insert into GAS_FORECAST_CRIS_BF_TO_TRW
select * from GAS_FORECAST_CRIS_BF_TO_TRW6;
/* Feb 2017 - 1232 inserted
Mar 2016 - 1244 inserted 
1219 inserted
3995 */


select TRW_MATCH_TYPE, count(*)
from GAS_FORECAST_CRIS_BF_TO_TRW
group by TRW_MATCH_TYPE;
/* 
Feb 2017:
7	1471704
6	1232
0	234253

Mar 2016:
7	1455977
6	1244
0	237670

Apr 2015:
TRW_MATCH_TYPE	COUNT(*)
7	1443958
6	1219
0	237306
*/


select count(*) from GAS_FORECAST_CRIS_BF_TO_TRW;
/* 
Feb 2017 - 1,707,189
Mar 2016 - 1,694,891
Apr 2015 - 1,682,483
Apr 2014 - 1,662,612
May 2013 - 1,617,263
Dec 2012 - 1,623,274
Oct 2012 - 1,622,249
May 2012 - 1,402,277 */

/*
select adr_std_score, count(*) from GAS_FORECAST_CRIS_BF_TO_TRW
group by adr_std_score;

select cde_situs_code1_score_trw, count(*) from GAS_FORECAST_CRIS_BF_TO_TRW
group by cde_situs_code1_score_trw;

select cde_situs_code1_score_trw, count(*) from mi_edr_prod.edr_trw
group by cde_situs_code1_score_trw;
*/

/* remove those records that did not match TRW on address but have the same KEY_PREM 
as a record that does match TRW - We do not want to double count these customer records */
delete from GAS_FORECAST_CRIS_BF_TO_TRW a
where exists(select * from GAS_FORECAST_CRIS_BF_TO_TRW b 
where a.key_prem = b.key_prem
and b.trw_match = 1)
and a.trw_match = 0;
/* 
Feb 2017 - 21,436 deleted
Mar 2016 - 21,130 deleted
Apr 2015 - 20,984 deleted
Apr 2014 - 20,812 deleted
May 2013 - 20,529 deleted
Dec 2012 - 20,442 deleted
Oct 2012 - 20,402 deleted
May 2012 - 20,344 deleted */


select TRW_MATCH, count(*) from GAS_FORECAST_CRIS_BF_TO_TRW group by TRW_MATCH;
/* 
Feb 2017:
TRW_MATCH	COUNT(*)
1	1472936
0	212817

Mar 2016:
TRW_MATCH	COUNT(*)
1	1457221
0	216540

Apr 2015:
TRW_MATCH	COUNT(*)
1	1445177
0	216322

Apr 2014:
TRW_MATCH	COUNT(*)
1	1424442
0	217358
*/

select * from GAS_FORECAST_CRIS_BF_TO_TRW
where key_prem in(
select key_prem
from GAS_FORECAST_CRIS_BF_TO_TRW
group by key_prem
having count(*)>1);


/**************************************************************************************************/
/**************************************************************************************************/
/*************************************  NOTE  *****************************************************/
/* The following records should be maintained somewhere because they will become prospects
** when they should not be.  these need to be joined back to TRW to eliminate
** them as prospects - this was not done prior to the December, 2012 run    ************/
/**************************************************************************************************/
/**************************************************************************************************/

/* Put duplicates in another file - Delete TRW matches from TRW only file later on so that we do not 
   count them as pure prospects */
create table gas_forecast_TRW_Extras as
select * from GAS_FORECAST_CRIS_BF_TO_TRW a
where exists(select * from GAS_FORECAST_CRIS_BF_TO_TRW b 
where a.key_prem = b.key_prem
and b.cde_type_adr = 'PS')
and a.cde_type_adr <> 'PS';

select * from gas_forecast_TRW_Extras
where trw_match = 0;

select TRW_MATCH, count(*) from gas_forecast_TRW_Extras group by TRW_MATCH;
/* 
Feb 2017:
TRW_MATCH	COUNT(*)
1	4199
0	6227

Mar 2016:
TRW_MATCH	COUNT(*)
1	4121
0	6371

Apr 2015:
TRW_MATCH	COUNT(*)
1	4021
0	6356

Apr 2014:
TRW_MATCH	COUNT(*)
1	4004
0	6345
*/

/* Remove some duplicates, keeping the Premise and Service over the other addresses */
delete from GAS_FORECAST_CRIS_BF_TO_TRW a
where exists(select * from GAS_FORECAST_CRIS_BF_TO_TRW b 
where a.key_prem = b.key_prem
and b.cde_type_adr = 'PS')
and a.cde_type_adr <> 'PS';
/* 
Feb 2017 - 10,426 deleted
Mar 2016 - 10,492 deleted
Apr 2015 - 10,377 deleted
Apr 2014 - 10,349 deleted
9,644 deleted */

select * from GAS_FORECAST_CRIS_BF_TO_TRW
where key_prem in(
select key_prem
from GAS_FORECAST_CRIS_BF_TO_TRW
group by key_prem
having count(*)>1);

/* Put duplicates in another file - Delete TRW matches from TRW only file later on so that we do not 
   count them as pure prospects */
insert into gas_forecast_TRW_Extras
select * from GAS_FORECAST_CRIS_BF_TO_TRW a
where exists(select * from GAS_FORECAST_CRIS_BF_TO_TRW b 
where a.key_prem = b.key_prem
and b.cde_type_adr = 'PR')
and a.cde_type_adr <> 'PR';
/* 
Feb 2017 - 1798 inserted
Mar 2016 - 1722 inserted
Apr 2015 - 1689 inserted
apr 2014 - 1640 inserted
1293 inserted */

select TRW_MATCH, count(*) from gas_forecast_TRW_Extras group by TRW_MATCH;
/* 
Feb 2017:
TRW_MATCH	COUNT(*)
1	5579
0	6645

Mar 2016:
TRW_MATCH	COUNT(*)
1	5428
0	6786

Apr 2015:
TRW_MATCH	COUNT(*)
1	5299
0	6767

Apr 2014:
TRW_MATCH	COUNT(*)
1	5234
0	6755
*/

delete from GAS_FORECAST_CRIS_BF_TO_TRW a
where exists(select * from GAS_FORECAST_CRIS_BF_TO_TRW b 
where a.key_prem = b.key_prem
and b.cde_type_adr = 'PR')
and a.cde_type_adr <> 'PR';
/* 
1798 deleted
1722 deleted
1689 deleted
1640 deleted
1293 deleted */

/* remove the remaining duplicates */
insert into gas_forecast_TRW_Extras
select * from GAS_FORECAST_CRIS_BF_TO_TRW a
where rowid < any(select rowid from GAS_FORECAST_CRIS_BF_TO_TRW b 
where a.key_prem = b.key_prem);
/* 
Feb 2017 - 263,695 inserted
Mar 2016 - 256,601 inserted
Apr 2015 - 249,864 inserted
Apr 2014 - 238,616 inserted
May 2013 - 203,530 inserted
Dec 2012 - 212,330 inserted - many of these are condos */

/*
select adr_std_score, count(*) from gas_forecast_TRW_Extras
group by adr_std_score;

select cde_situs_code1_score_trw, count(*) from gas_forecast_TRW_Extras
group by cde_situs_code1_score_trw;
*/

delete from GAS_FORECAST_CRIS_BF_TO_TRW a
where rowid < any(select rowid from GAS_FORECAST_CRIS_BF_TO_TRW b 
where a.key_prem = b.key_prem);
/* 
Feb 2017 - 263,695 deleted
Mar 2016 - 256,601 deleted
Apr 2015 - 249,864 deleted
Apr 2014 - 238,616 deleted
*/

create index idx_GAS_FCST_CRIS_BF_TO_TRW on GAS_FORECAST_CRIS_BF_TO_TRW(KEY_BLD_FACE);

select KEY_BLD_FACE, count(*)
from GAS_FORECAST_CRIS_BF_TO_TRW
group by KEY_BLD_FACE
having count(*)>1;
/* 0 */

select trw_match, count(distinct key_prem) from gas_forecast_TRW_Extras
group by trw_match;
/*
Feb 2017:
TRW_MATCH	COUNT(DISTINCTKEY_PREM)
0	5178
1	40389

Mar 2016:
TRW_MATCH	COUNT(DISTINCTKEY_PREM)
0	5310
1	39537

Apr 2015:
TRW_MATCH	COUNT(DISTINCTKEY_PREM)
0	5294
1	39008

Apr 2014:
TRW_MATCH	COUNT(DISTINCTKEY_PREM)
0	5287
1	36156
*/
select trw_match, count(*) from gas_forecast_TRW_Extras
group by trw_match;

/********* END OF CREATE FILE for best TRW match ******/


/******* Create CRIS table ******/
create table cpalmieri.GAS_FORECAST_CRIS_gas1 tablespace xlarge_data as
select 
BA.ID_ACCT as ACCTNUM, 
case 
  when B.ID_BRANCH between 'A' and 'J' then 'NYC' 
  when B.ID_BRANCH BETWEEN 'K' AND 'T' and adr_std_st = 'MA' then 'MA' 
  when B.ID_BRANCH BETWEEN 'K' AND 'T' and adr_std_st = 'NH' then 'NH' 
  else 'UNK' 
end as region,
S.CDE_RTE,
B.adr_std_hse_nbr       sitehsenumb, 
b.adr_std_hse_alpha     sitehsealph,
B.adr_std_pre_dir       sitestrprfx, 
B.adr_std_str_nm        sitestrname, 
B.adr_std_str_sfx       sitestrsfx1, 
B.adr_std_sfx_dir       sitestrsfx2, 
B.adr_std_zip           sitezip5, 
B.adr_std_city          sitecity, 
B.adr_std_st            sitestate, 
B.adr_std_score         sitescr,
' ' as market,
' ' as service,
case
	when BA.CDE_STAT_ACCT = '00' then 'Y' /* Active */
	else 'N'
end as active_status
FROM mi_cris_prod.SERVICE_POINT S 
join mi_cris_prod.BUILDING_FACE B 
on S.KEY_PREM = B.KEY_PREM 
/* Limit to only the best TRW match records - This will return only 1 address for a building */
join cpalmieri.GAS_FORECAST_CRIS_BF_TO_TRW bft 
on b.key_bld_face = bft.key_bld_face
join mi_cris_prod.BILLING_ACCOUNT BA 
on S.KEY_BILL_ACCT=BA.KEY_BILL_ACCT 
WHERE S.FLG_PRI_SERV_ACCT='Y' 
/*AND   B.CDE_TYPE_ADR IN ('PS','PR') /* PREMISE & SERVICE, PREMISE */ 
;


select sitestate, count(*) from cpalmieri.GAS_FORECAST_CRIS_gas1
where region = 'UNK'
group by sitestate;
/* 
Feb 2017:
SITESTATE	COUNT(*)
MA	29789
NH	105602

Mar 2016:
SITESTATE	COUNT(*)
MA	29190
NH	105602

SITESTATE	COUNT(*)
MA	28392
NH	105602
*/

/* delete NH records as of 2015 */
delete from GAS_FORECAST_CRIS_gas1 where sitestate = 'NH';
/* 105615 deleted */

/* I found incorrect region settings for some MA records */
update GAS_FORECAST_CRIS_gas1 a
set region = sitestate
where region <> sitestate
and sitestate in('MA');
/* 
32,992 updated
137,136 updated
33,661 updated */


alter table cpalmieri.GAS_FORECAST_CRIS_gas1
modify(MARKET VARCHAR2(15), SERVICE VARCHAR2(10));

update GAS_FORECAST_CRIS_gas1 a
set (a.market,
a.service) =
(select b.market,
b.service
from GAS_FORECAST_RATE_MARKET_SRVC b
where a.region = b.region
and a.CDE_RTE = b.rate)
;

select count(*) from GAS_FORECAST_CRIS_gas1;
/* 
Feb 2017: 2,550,980
Mar 2016: 2,528,768
Apr 2015: 2,506,074 - no more NH
*/


/* Check for any missing rates from the GAS_FORECAST_RATE_MARKET_SRVC table */
select region, CDE_RTE, market, service, count(*)
from GAS_FORECAST_CRIS_gas1 a
where market is null
group by region, CDE_RTE, market, service;
/* 
None Missing Feb 2017
None Missing Mar 2016
These were missing in April 2015:
REGION	CDE_RTE	MARKET	SERVICE	COUNT(*)
MA	864			1
NYC	574			19
NYC	163			1
NYC	573			18

select * from mi_cris_prod.cde_rte t
where cde_rte in('864','574','163','573')

CDE_RTE	DTE_EFFECT	DCS_RTE	DCD_RTE	                       DCD_RTE_PLB
163	    1/1/0001	  6C3	    TC COMMERCIAL RS 3	           TC Commercial
573	    1/1/0001	  T6M3A	  TRAN TC MULTFAM LEFRAK A	     TRAN TC M-FAM
574	    1/1/0001	  T6M3B	  TRAN TC MULTFAM LEFRAK B	     TRAN TC M-FAM
864	    1/1/0001	  G-63	  SUMMER LOAD - EXTRA-LARGE	     Summer

select * from GAS_FORECAST_RATE_MARKET_SRVC

insert into GAS_FORECAST_RATE_MARKET_SRVC select 'MA','864','COML','NONHEAT','','' from dual;	 	 
insert into GAS_FORECAST_RATE_MARKET_SRVC select 'NYC','163','COML','HEATING','TC','' from dual;	 	 
insert into GAS_FORECAST_RATE_MARKET_SRVC select 'NYC','573','MFAM','HEATING','','' from dual;	 	 
insert into GAS_FORECAST_RATE_MARKET_SRVC select 'NYC','574','MFAM','HEATING','','' from dual;	 	 


these were missing in April 2014:

REGION	CDE_RTE	MARKET	SERVICE	COUNT(*)
NYC	166			1
NYC	426			1

select * from mi_cris_prod.cde_rte t
where cde_rte in('166','426')

CDE_RTE  DTE_EFFECT  DCS_RTE  DCD_RTE  DCD_RTE_PLB
166  11/01/1996  6C1EA  ADR TC COMM RS1 NO PBT  TC Commercial
426	10/01/1997	T2-2A	TRAN GENERAL HEATING ADR	Tran General


insert into GAS_FORECAST_RATE_MARKET_SRVC
select 'NYC','166','COML','NONHEAT','TC',' ' from dual;	 	 
insert into GAS_FORECAST_RATE_MARKET_SRVC
select 'NYC','426','COML','HEATING',' ',' ' from dual;	 	 


update GAS_FORECAST_CRIS_gas1 a
set (a.market,
a.service) =
(select b.market,
b.service
from GAS_FORECAST_RATE_MARKET_SRVC b
where a.region = b.region
and a.CDE_RTE = b.rate)
;
*/


select count(distinct Sitehsenumb||Sitestrprfx||Sitestrname||Sitestrsfx1||Sitestrsfx2||SiteZip5), 
count(distinct Sitehsenumb||Sitehsealph||Sitestrprfx||Sitestrname||Sitestrsfx1||Sitestrsfx2||SiteZip5)
from GAS_FORECAST_CRIS_gas1
where region = 'NYC';
/* 
Feb 2017: 614842	616060
Mar 2016: 614046	615263
Apr 2015: 613070	614287
Apr 2014: 611,774	612,984
May 2013: 610,935	612,140 */
/* 611,906 */
/* 633,201 - This is the count without removing the duplicate buildings because of multiple CDE_TYPE_ADR for the same building */
/* 611,770 - This is the count after removing the duplicate buildings because of multiple CDE_TYPE_ADR for the same building */
/* 612,517 - this is the count with the original code that only pulled PS and PR */
select count(*) from GAS_FORECAST_CRIS_gas1 
where sitescr = '9'
and region = 'NYC';
/* 
Feb 2017: 19,661
Mar 2016: 19,535
Apr 2015: 19,565
Apr 2014: 19,891
*/


/* Combine all regions together into 1 big happy customer file */
select count(*) from GAS_FORECAST_CRIS_gas1;
/* 
Feb 2017: 2,550,980
Mar 2016: 2,528,768
Apr 2015: 2,506,074
Apr 2014: 2,585,854
*/

/* Delete bad data - rate is a NE rate and should not show up for NYC */
delete from GAS_FORECAST_CRIS_gas1
where cde_rte = '801' and region = 'NYC';
/* 2 deleted */

select region, market, service, active_status, count(*) 
from GAS_FORECAST_CRIS_gas1
group by region, market, service, active_status
order by region, market, service, active_status;

select * from GAS_FORECAST_CRIS_gas1
where market is null;

select * from GAS_FORECAST_CRIS_gas1
where cde_RTE in('030','330');

/* According to Kevin Lantry, rate 030 and 330 are non-heating if the last digit of the SA code = '0' 
I must update these to non-heat from heating to conform with his GLF extract */
create table GAS_FORECAST_CRIS_330non_ht as
select s.id_acct
FROM mi_cris_prod.SERVICE_POINT S 
where s.id_acct in(select acctnum from GAS_FORECAST_CRIS_gas1
where cde_RTE in('030','330'))
and substr(s.cde_sa,4,1)='0' /* 0 = non-heat */
; 

select count(*) from GAS_FORECAST_CRIS_330non_ht;
/* 
Feb 2017 - 1421
Mar 2016 - 1378 
*/

select * from GAS_FORECAST_CRIS_gas1
where acctnum in(select id_acct from GAS_FORECAST_CRIS_330non_ht);

update GAS_FORECAST_CRIS_gas1
set service = 'NONHEAT'
where acctnum in(select id_acct from GAS_FORECAST_CRIS_330non_ht);
/*
Feb 2017 - 1383 updated
Mar 2016 - 1342 updated 
*/


select count(*) from GAS_FORECAST_css_gas1;
/* 
Feb 2017 - 1620426
Mar 2016 - 1607066
Apr 2015 - 1575554
Apr 2014 - 1553392 (Includes LI Now)
*/

select region, market, service, active_status, count(*) 
from GAS_FORECAST_css_gas1
group by region, market, service, active_status
order by region, market, service, active_status;


/* There were some inactive LI accounts with no cde_rte or cde_rte = '???' 
According to Dawn Herrity, Rate 465 is the tariff requirements for an ESCO - they don't necessarily 
have an account but these are their requirements to be an ESCO in our service territory - there 
are no customers under this service class. 
*/
delete from GAS_FORECAST_css_gas1
where market is null;
/* 
Feb 2017: 517 deleted
Mar 2016: 526 deleted */


select * from GAS_FORECAST_RATE_MARKET_SRVC;

/*insert into GAS_FORECAST_RATE_MARKET_SRVC
select 'NYC','012','RESID','HEAT',' ', ' '
from dual;

insert into GAS_FORECAST_RATE_MARKET_SRVC
select 'NYC','766','MFAM','HEATING',' ', ' '
from dual;

update GAS_FORECAST_RATE_MARKET_SRVC
set service = 'HEATING'
where service = 'HEAT'
*/

create table cpalmieri.GAS_FORECAST_all_custs as
select * from GAS_FORECAST_css_gas1
union
select * from GAS_FORECAST_cris_gas1
;

select region, market, service, active_status, count(*) 
from GAS_FORECAST_all_custs
group by region, market, service, active_status
order by region, market, service, active_status;

select * from GAS_FORECAST_all_custs
where region = 'LI';

select count(*) from GAS_FORECAST_all_custs
/* 
Feb 2017 - 4170887
Mar 2016 - 4135306
Apr 2015 - 4081107 - NH is excluded
Apr 2014 - 4138725
*/
where SITESTRNAME = ' ';
/* 
Feb 2017 - 10
Mar 2016 - 10
Apr 2015 - 11
Apr 2014 - 461
*/

/* get counts of accounts by structure create file based on structure - use this to
   determine multi family */
create table GAS_FORECAST_all_cust_units tablespace xlarge_data as
select 
region,
sitehsenumb,
sitehsealph,
sitestrprfx,
sitestrname,
sitestrsfx1,
sitestrsfx2,
sitezip5,
count(*) as numaccts
from GAS_FORECAST_all_custs a
where SITESTRNAME <> ' ' /* bad addresses should not be included in the counts */
and market in('RESID', 'MFAM') /* only use resi and multi fam to determine multi family structs */
group by 
region,
sitehsenumb,
sitehsealph,
sitestrprfx,
sitestrname,
sitestrsfx1,
sitestrsfx2,
sitezip5;

/* Summarize the number of type of accts per structure */
create table GAS_FORECAST_cust_acct_sum tablespace xlarge_data as
select 
region,
sitehsenumb,
sitehsealph,
sitestrprfx,
sitestrname,
sitestrsfx1,
sitestrsfx2,
sitezip5,
sum(case
       when market = 'RESID' and service = 'HEATING' then 1
       else 0
end) as RESI_HEAT_ACCTS,
sum(case
       when market = 'MFAM' and service = 'HEATING' then 1
       else 0
end) as MFAM_HEAT_ACCTS,
sum(case
       when market = 'COML' and service = 'HEATING' then 1
       else 0
end) as COML_HEAT_ACCTS,
sum(case
       when market = 'RESID' and service = 'NONHEAT' then 1
       else 0
end) as RESI_NONHEAT_ACCTS,
sum(case
       when market = 'MFAM' and service = 'NONHEAT' then 1
       else 0
end) as MFAM_NONHEAT_ACCTS,
sum(case
       when market = 'COML' and service = 'NONHEAT' then 1
       else 0
end) as COML_NONHEAT_ACCTS,
count(*) as total_accts
from GAS_FORECAST_all_custs a
where SITESTRNAME <> ' ' /* bad addresses should not be included in the counts */
and market in('RESID', 'MFAM', 'COML') /* only use resi and multi fam to determine multi family structs */
and service in('HEATING', 'NONHEAT')
group by 
region,
sitehsenumb,
sitehsealph,
sitestrprfx,
sitestrname,
sitestrsfx1,
sitestrsfx2,
sitezip5;


select count(*) from GAS_FORECAST_all_cust_units;
/* 
Feb 2017: 2,434,996
Mar 2016: 2,421,839
Apr 2015: 2,402,882 - no NH
Apr 2014: 2,447,432
*/

alter table GAS_FORECAST_all_cust_units
add(MARKET VARCHAR2(15));

/* modify the market based on resi and multi fam acct counts */
update GAS_FORECAST_all_cust_units 
set market = 
case
  when region = 'UNY' and numaccts between 1 and 3 then 'RESID'
  when region = 'UNY' and numaccts > 3 then 'MFAM'
  when region <> 'UNY' and numaccts between 1 and 5 then 'RESID'
  when region <> 'UNY' and numaccts > 5 then 'MFAM'
end;

select region, market, count(*) from GAS_FORECAST_all_cust_units group by region, market order by region, market;
/* 
Feb 2017:
REGION	MARKET	COUNT(*)
LI	MFAM	1279
LI	RESID	498301
MA	MFAM	9762
MA	RESID	642660
NYC	MFAM	29704
NYC	RESID	549915
RI	MFAM	1597
RI	RESID	195869
UNY	MFAM	10387
UNY	RESID	495522

Mar 2016:
REGION	MARKET	COUNT(*)
LI	MFAM	1251
LI	RESID	494010
MA	MFAM	9458
MA	RESID	639228
NYC	MFAM	29341
NYC	RESID	549522
RI	MFAM	1573
RI	RESID	194473
UNY	MFAM	10256
UNY	RESID	492727

Apr 2015:
REGION	MARKET	COUNT(*)
LI	MFAM	1187
LI	RESID	484936
MA	MFAM	9119
MA	RESID	635231
NYC	MFAM	28917
NYC	RESID	549067
RI	MFAM	1546
RI	RESID	193206
UNY	MFAM	10072
UNY	RESID	489601

Apr 2014:
REGION	MARKET	COUNT(*)
LI	MFAM	1126
LI	RESID	478498
MA	MFAM	8774
MA	RESID	628291
NH	MFAM	1120
NH	RESID	60948
NYC	MFAM	28608
NYC	RESID	548185
RI	MFAM	1528
RI	RESID	191405
UNY	MFAM	9468
UNY	RESID	489481
*/

select market, service, count(*) from GAS_FORECAST_all_custs group by market, service;

select * from GAS_FORECAST_all_custs a
where exists(select * from GAS_FORECAST_all_custs b
where market = 'RESID'
and service = 'CONNECT'
and a.Sitehsenumb   = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5 );

select cde_rte, market, service, active_status, count(*) 
from GAS_FORECAST_all_custs 
where service = 'CONNECT'
group by cde_rte, market, service, active_status
order by cde_rte, market, service, active_status;


alter table GAS_FORECAST_all_custs
add(TC VARCHAR2(5));

/* Include TC in the file - When there are residential and commercial TC at the same location, make that location MF */
update GAS_FORECAST_all_custs a
set a.tc =
(select b.tc
from GAS_FORECAST_RATE_MARKET_SRVC b
where a.region = b.region
and a.cde_rte = b.rate)
;
/* Create a TC file */
/* this creates a file that puts the most occurances of rate first within each structure */
create table GAS_FORECAST_COMM_TC1 as
select 
sitehsenumb,
sitehsealph,
sitestrprfx,
sitestrname,
sitestrsfx1,
sitestrsfx2,
sitezip5,
cde_rte,
count(*) as rate_cnt
from GAS_FORECAST_all_custs a
where TC = 'TC'
and market = 'COML'
and sitestrname <> ' ' /* these will be added in later and remain full records */
group by sitehsenumb,
sitehsealph,
sitestrprfx,
sitestrname,
sitestrsfx1,
sitestrsfx2,
sitezip5,
cde_rte
order by sitehsenumb,
sitehsealph,
sitestrprfx,
sitestrname,
sitestrsfx1,
sitestrsfx2,
sitezip5,
count(*) desc;

/* delete the duplicates, keeping the heating rate with the highest number of occurances */
delete from GAS_FORECAST_COMM_TC1 a
where rowid > any(select rowid from GAS_FORECAST_COMM_TC1 b
where a.Sitehsenumb   = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5      
);
/* 
Feb 2017 - 8 deleted
Mar 2016 - 7 deleted */

select count(*) from GAS_FORECAST_COMM_TC1 ;
/* 
Feb 2017 - 779
Mar 2016 - 794
795 */

create table GAS_FORECAST_COMM_TC tablespace small_data as
select 
region,
a.Sitehsenumb,
a.sitehsealph,
a.Sitestrprfx,
a.Sitestrname,
a.Sitestrsfx1,
a.Sitestrsfx2,
a.SiteZip5   ,
max(b.cde_rte) as cde_rte,  /* the max here will be the same as the min - there is only one rate in file b for the structure */
count(*) as numaccts
from GAS_FORECAST_all_custs a
join GAS_FORECAST_COMM_TC1 b
on  a.Sitehsenumb   = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5
where a.TC = 'TC'
and a.market = 'COML'
group by 
a.region,
a.Sitehsenumb,
a.sitehsealph,
a.Sitestrprfx,
a.Sitestrname,
a.Sitestrsfx1,
a.Sitestrsfx2,
a.SiteZip5;

select count(*) from GAS_FORECAST_COMM_TC;
/* 
Feb 2017 - 779
Mar 2016 - 794
795 */


/* Create a heating file for MFAM, RESID, COMML - I want to try to get the best heating rate MF 1st */
/* First create a table that determines the txt_county_use that has the greatest number of occurances per
structure */
/* this creates a file that puts the most occurances of rate first within each structure */
create table GAS_FORECAST_MF_HEAT1 as
select 
sitehsenumb,
sitehsealph,
sitestrprfx,
sitestrname,
sitestrsfx1,
sitestrsfx2,
sitezip5,
cde_rte,
count(*) as rate_cnt
from GAS_FORECAST_all_custs a
where market = 'MFAM'
and SERVICE = 'HEATING'
and sitestrname <> ' ' /* these will be added in later and remain full records */
group by sitehsenumb,
sitehsealph,
sitestrprfx,
sitestrname,
sitestrsfx1,
sitestrsfx2,
sitezip5,
cde_rte
order by sitehsenumb,
sitehsealph,
sitestrprfx,
sitestrname,
sitestrsfx1,
sitestrsfx2,
sitezip5,
count(*) desc;

select count(*) from GAS_FORECAST_MF_HEAT1 ;
/* 
Feb 2017: 22,709
Mar 2016: 22,574 - with update to 030 and 330 to re-do as nonheat
Apr 2015: 23,358
Apr 2014: 23,043
*/

/* delete the duplicates, keeping the heating rate with the highest number of occurances */
delete from GAS_FORECAST_MF_HEAT1 a
where rowid > any(select rowid from GAS_FORECAST_MF_HEAT1 b
where  a.Sitehsenumb   = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5      
);
/* 
Feb 2017: 356 deleted
Mar 2016: 348 deleted
Apr 2015: 506 deleted
Apr 2014: 488 deleted
May 2013: 487 deleted
484 deleted */

create table GAS_FORECAST_MF_HEAT tablespace xlarge_data as
select 
region,
max(b.cde_rte) as cde_rte, /* the max here will be the same as the min - there is only one rate in file b for the structure */
a.sitehsenumb,
a.sitehsealph,
a.sitestrprfx,
a.sitestrname,
a.sitestrsfx1,
a.sitestrsfx2,
a.sitezip5,
max(sitecity) as sitecity, 
max(sitestate) as sitestate, 
max(sitescr) as sitescr,
max(market) as market, 
max(service) as service, 
max(active_status) as active_status, 
max(tc) as tc,
count(*) as numaccts
from GAS_FORECAST_all_custs a
join GAS_FORECAST_MF_HEAT1 b
  on  a.Sitehsenumb   = b.Sitehsenumb  
  and a.sitehsealph   = b.sitehsealph
  and a.Sitestrprfx   = b.Sitestrprfx  
  and a.Sitestrname   = b.Sitestrname  
  and a.Sitestrsfx1   = b.Sitestrsfx1  
  and a.Sitestrsfx2   = b.Sitestrsfx2  
  and a.SiteZip5      = b.SiteZip5
where market = 'MFAM'
and SERVICE = 'HEATING'
group by 
region,
a.sitehsenumb,
a.sitehsealph,
a.sitestrprfx,
a.sitestrname,
a.sitestrsfx1,
a.sitestrsfx2,
a.sitezip5;


/* Resi file creation */
/* this creates a file that puts the most occurances of rate first within each structure */
create table GAS_FORECAST_RESID_HEAT1 as
select 
sitehsenumb,
sitehsealph,
sitestrprfx,
sitestrname,
sitestrsfx1,
sitestrsfx2,
sitezip5,
cde_rte,
count(*) as rate_cnt
from GAS_FORECAST_all_custs a
where market = 'RESID'
and SERVICE = 'HEATING'
and sitestrname <> ' ' /* these will be added in later and remain full records */
group by sitehsenumb,
sitehsealph,
sitestrprfx,
sitestrname,
sitestrsfx1,
sitestrsfx2,
sitezip5,
cde_rte
order by sitehsenumb,
sitehsealph,
sitestrprfx,
sitestrname,
sitestrsfx1,
sitestrsfx2,
sitezip5,
count(*) desc;

select count(*) from GAS_FORECAST_RESID_HEAT1 ;
/* 
Feb 2017: 2,260,014
Mar 2016: 2,219,955
Apr 2015: 2,179,922
*/

/* delete the duplicates, keeping the heating rate with the highest number of occurances */
delete from GAS_FORECAST_RESID_HEAT1 a
where rowid > any(select rowid from GAS_FORECAST_RESID_HEAT1 b
where  a.Sitehsenumb   = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5      
);
/* 
Feb 2017: 80,196 
Mar 2016: 78,149 deleted
Apr 2015: 74,317 deleted
Apr 2014: 74,839 deleted 
*/

create table GAS_FORECAST_RESID_HEAT tablespace xlarge_data as
select 
region,
max(b.cde_rte) as cde_rte, /* the max here will be the same as the min - there is only one rate in file b for the structure */
a.sitehsenumb,
a.sitehsealph,
a.sitestrprfx,
a.sitestrname,
a.sitestrsfx1,
a.sitestrsfx2,
a.sitezip5,
max(sitecity) as sitecity, 
max(sitestate) as sitestate, 
max(sitescr) as sitescr,
max(market) as market, 
max(service) as service, 
max(active_status) as active_status, 
max(tc) as tc,
count(*) as numaccts
from GAS_FORECAST_all_custs a
join GAS_FORECAST_RESID_HEAT1 b
on  a.Sitehsenumb   = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5
where market = 'RESID'
and SERVICE = 'HEATING'
group by 
region,
a.sitehsenumb,
a.sitehsealph,
a.sitestrprfx,
a.sitestrname,
a.sitestrsfx1,
a.sitestrsfx2,
a.sitezip5;

select count(*) from GAS_FORECAST_RESID_HEAT;
/* 
Feb 2017: 2,179,818
Mar 2016: 2,141,806
Apr 2015: 2,105,606 - NH removed
Apr 2014: 2,134,964
May 2013: 2,104,589
2,089,851 */

/* remove any MF from the RESID - already MF */
delete from GAS_FORECAST_RESID_HEAT a
where exists(select * from GAS_FORECAST_MF_HEAT b
where a.Sitehsenumb   = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5 );
/* 
Feb 2017: 1430
Mar 2016: 1367 deleted - changed some 030 and 330 rates to nonheat
Apr 2015: 1559 deleted
Apr 2014: 1466 deleted
*/

select a.* from GAS_FORECAST_RESID_HEAT a
where exists(select * from GAS_FORECAST_COMM_TC b
where a.Sitehsenumb   = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5);
/* 
Feb 2017: 34
Mar 2016: 38
Apr 2015: 40
Apr 2014: 38
May 2013: 41
40 */

/* Make any resi structures MF if they match a TC structure.  Also replace the resi rate
   with the TC rate */
update GAS_FORECAST_RESID_HEAT a
set market = 'MFAM',
a.cde_rte = (select cde_rte from GAS_FORECAST_COMM_TC b
where a.Sitehsenumb   = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5)
where exists(select * from GAS_FORECAST_COMM_TC b
where a.Sitehsenumb   = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5);
/* Feb 2017: 34
Mar 2016: 38 updated */

select count(*) from GAS_FORECAST_RESID_HEAT;
/* 
Feb 2017: 2,178,388
Mar 2016: 2,140,439
Apr 2015: 2,104,047
Apr 2014: 2,133,498
May 2013: 2,103,174
2,088,477 */

select region, market,
cde_rte, 
count(*)
from GAS_FORECAST_RESID_HEAT
group by region,market,
cde_rte;

insert into GAS_FORECAST_MF_HEAT
select a.* from GAS_FORECAST_RESID_HEAT a
where market = 'MFAM';

/* remove any MF from the RESID - already MF */
delete from GAS_FORECAST_RESID_HEAT a
where exists(select * from GAS_FORECAST_MF_HEAT b
where a.Sitehsenumb   = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5 );

/* Create Coml heating structure table */
/* this creates a file that puts the most occurances of rate first within each structure */
create table GAS_FORECAST_COML_HEAT1 as
select 
sitehsenumb,
sitehsealph,
sitestrprfx,
sitestrname,
sitestrsfx1,
sitestrsfx2,
sitezip5,
cde_rte,
count(*) as rate_cnt
from GAS_FORECAST_all_custs a
where market = 'COML'
and SERVICE = 'HEATING'
and sitestrname <> ' ' /* these will be added in later and remain full records */
group by sitehsenumb,
sitehsealph,
sitestrprfx,
sitestrname,
sitestrsfx1,
sitestrsfx2,
sitezip5,
cde_rte
order by sitehsenumb,
sitehsealph,
sitestrprfx,
sitestrname,
sitestrsfx1,
sitestrsfx2,
sitezip5,
count(*) desc;

select count(*) from GAS_FORECAST_COML_HEAT1 ;
/* 
Feb 2017: 198,517
Mar 2016: 197,224
Apr 2015: 190,131
May 2013: 196,581
194,605 */

/* delete the duplicates, keeping the heating rate with the highest number of occurances */
delete from GAS_FORECAST_COML_HEAT1 a
where rowid > any(select rowid from GAS_FORECAST_COML_HEAT1 b
where  a.Sitehsenumb   = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5      
);
/* 
Feb 2017: 13,497 deleted
Mar 2016: 13,459 deleted
Apr 2015: 12,719 deleted
Apr 2014: 12,686 deleted
*/

create table GAS_FORECAST_COML_HEAT tablespace xlarge_data as
select 
region,
max(b.cde_rte) as cde_rte, /* the max here will be the same as the min - there is only one rate in file b for the structure */
a.sitehsenumb,
a.sitehsealph,
a.sitestrprfx,
a.sitestrname,
a.sitestrsfx1,
a.sitestrsfx2,
a.sitezip5,
max(sitecity) as sitecity, 
max(sitestate) as sitestate, 
max(sitescr) as sitescr,
max(market) as market, 
max(service) as service, 
max(active_status) as active_status, 
max(tc) as tc,
count(*) as numaccts
from GAS_FORECAST_all_custs a
join GAS_FORECAST_COML_HEAT1 b
on  a.Sitehsenumb   = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5
where market = 'COML'
and SERVICE = 'HEATING'
group by 
region,
a.sitehsenumb,
a.sitehsealph,
a.sitestrprfx,
a.sitestrname,
a.sitestrsfx1,
a.sitestrsfx2,
a.sitezip5;


/* remove any MF from the COML - already MF */
delete from GAS_FORECAST_COML_HEAT a
where exists(select * from GAS_FORECAST_MF_HEAT b
where a.Sitehsenumb   = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5 );
/* 
Feb 2017: 1153
Mar 2016: 1119 deleted
Apr 2015: 1147 deleted
Apr 2014: 1035 deleted
May 2013: 1010 deleted
1,019 deleted */

/* remove any RESID from the COML already resi */
delete from GAS_FORECAST_COML_HEAT a
where exists(select * from GAS_FORECAST_RESID_HEAT b
where a.Sitehsenumb   = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5 );
/* 
Feb 2017: 23495
Mar 2016: 22911 deleted
Apr 2015: 21620 deleted
Apr 2014: 19956 deleted
*/

select count(*) from GAS_FORECAST_COML_HEAT;
/* 
Feb 2017: 160,372
Mar 2016: 159,735
Apr 2015: 154,645
Apr 2014: 162,891
*/

/* create heating structure file */
create table GAS_FORECAST_ALL_HEAT_STRUCT as
select * from GAS_FORECAST_MF_HEAT
union select * from GAS_FORECAST_RESID_HEAT
union select * from GAS_FORECAST_COML_HEAT;

select count(*) from GAS_FORECAST_ALL_HEAT_STRUCT;
/* 
Feb 2017: 2,361,113
Mar 2016: 2,322,400
Apr 2015: 2,281,544
Apr 2014: 2,318,944
*/

select region,
market, 
service,
count(*)
from GAS_FORECAST_ALL_HEAT_STRUCT
group by region, market, service
order by region, market, service;
/*
Feb 2017:
REGION	MARKET	SERVICE	COUNT(*)
LI	COML	HEATING	38774
LI	MFAM	HEATING	1233
LI	RESID	HEATING	417375
MA	COML	HEATING	45840
MA	RESID	HEATING	591631
NYC	COML	HEATING	28127
NYC	MFAM	HEATING	21154
NYC	RESID	HEATING	494324
RI	COML	HEATING	14052
RI	RESID	HEATING	182905
UNY	COML	HEATING	33579
UNY	RESID	HEATING	492119

Mar 2016:
REGION	MARKET	SERVICE	COUNT(*)
LI	COML	HEATING	38470
LI	MFAM	HEATING	1225
LI	RESID	HEATING	403158
MA	COML	HEATING	45916
MA	RESID	HEATING	585997
NYC	COML	HEATING	28190
NYC	MFAM	HEATING	21039
NYC	RESID	HEATING	483465
RI	COML	HEATING	13777
RI	RESID	HEATING	179192
UNY	COML	HEATING	33382
UNY	RESID	HEATING	488589

Apr 2015:
REGION	MARKET	SERVICE	COUNT(*)
LI	    COML    HEATING  35459
LI      MFAM    HEATING   1196
LI      RESID   HEATING 395818
MA      COML    HEATING  45351
MA      RESID   HEATING 573711
NYC     COML    HEATING  27814
NYC     MFAM    HEATING  21696
NYC     RESID   HEATING 480732
RI      COML    HEATING  12659
RI      RESID   HEATING 177124
UNY     COML    HEATING  33362
UNY     RESID   HEATING	476622
*/


/*************************************************************************************/
/*************************************************************************************/
/*************** END OF HEATING Structure File Creation ******************************/
/*************************************************************************************/
/*************************************************************************************/


/******************************************************************************************/
/******************************************************************************************/
/*********** Run the same for LOW USE as was done for the heating structures **************/
/******************************************************************************************/
/******************************************************************************************/

/* Create a Low Use file for MFAM, RESID, COMML - I want to try to get the best Low Use rate MF 1st */

/* this creates a file that puts the most occurances of rate first within each structure */
create table GAS_FORECAST_MF_NONHEAT1 as
select 
sitehsenumb,
sitehsealph,
sitestrprfx,
sitestrname,
sitestrsfx1,
sitestrsfx2,
sitezip5,
cde_rte,
count(*) as rate_cnt
from GAS_FORECAST_all_custs a
where market = 'MFAM'
and SERVICE = 'NONHEAT'
and sitestrname <> ' ' /* these will be added in later and remain full records */
group by sitehsenumb,
sitehsealph,
sitestrprfx,
sitestrname,
sitestrsfx1,
sitestrsfx2,
sitezip5,
cde_rte
order by sitehsenumb,
sitehsealph,
sitestrprfx,
sitestrname,
sitestrsfx1,
sitestrsfx2,
sitezip5,
count(*) desc;

select count(*) from GAS_FORECAST_MF_NONHEAT1 ;
/* 
Feb 2017: 1386
Mar 2016: 1343 - reflects changes to nonheat for some 030 and 330 rates
Apr 2014: 76
*/

/* delete the duplicates, keeping the heating rate with the highest number of occurances */
delete from GAS_FORECAST_MF_NONHEAT1 a
where rowid > any(select rowid from GAS_FORECAST_MF_NONHEAT1 b
where  a.Sitehsenumb   = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5      
);
/* 
Feb 2017: 13
Mar 2016: 14 deleted
Apr 2014: 0 deleted
*/

create table GAS_FORECAST_MF_NONHEAT tablespace small_data as
select 
region,
max(b.cde_rte) as cde_rte, /* the max here will be the same as the min - there is only one rate in file b for the structure */
a.sitehsenumb,
a.sitehsealph,
a.sitestrprfx,
a.sitestrname,
a.sitestrsfx1,
a.sitestrsfx2,
a.sitezip5,
max(sitecity) as sitecity, 
max(sitestate) as sitestate, 
max(sitescr) as sitescr,
max(market) as market, 
max(service) as service, 
max(active_status) as active_status, 
max(tc) as tc,
count(*) as numaccts
from GAS_FORECAST_all_custs a
join GAS_FORECAST_MF_NONHEAT1 b
on  a.Sitehsenumb   = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5
where market = 'MFAM'
and SERVICE = 'NONHEAT'
/* do not include heating structures */
and not exists(select * from GAS_FORECAST_ALL_HEAT_STRUCT b
where a.Sitehsenumb   = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5 )
group by 
region,
a.sitehsenumb,
a.sitehsealph,
a.sitestrprfx,
a.sitestrname,
a.sitestrsfx1,
a.sitestrsfx2,
a.sitezip5;


select count(*) from GAS_FORECAST_MF_NONHEAT ;
/* 
Feb 2017: 593
Mar 2016: 595 - reflects changes to nonheat for some 030 and 330 rates
Apr 2015: 37
Apr 2014: 61
May 2013: 54
55 */

/* Residential Low use file creation */
/* this creates a file that puts the most occurances of rate first within each structure */
create table GAS_FORECAST_RESID_NONHEAT1 as
select 
sitehsenumb,
sitehsealph,
sitestrprfx,
sitestrname,
sitestrsfx1,
sitestrsfx2,
sitezip5,
cde_rte,
count(*) as rate_cnt
from GAS_FORECAST_all_custs a
where market = 'RESID'
and SERVICE = 'NONHEAT'
and sitestrname <> ' ' /* these will be added in later and remain full records */
group by sitehsenumb,
sitehsealph,
sitestrprfx,
sitestrname,
sitestrsfx1,
sitestrsfx2,
sitezip5,
cde_rte
order by sitehsenumb,
sitehsealph,
sitestrprfx,
sitestrname,
sitestrsfx1,
sitestrsfx2,
sitezip5,
count(*) desc;

select count(*) from GAS_FORECAST_RESID_NONHEAT1 ;
/* 
Feb 2017: 530,864
Mar 2016: 557,097
Apr 2015: 576,323
Apr 2014: 591,397
*/

/* delete the duplicates, keeping the heating rate with the highest number of occurances */
delete from GAS_FORECAST_RESID_NONHEAT1 a
where rowid > any(select rowid from GAS_FORECAST_RESID_NONHEAT1 b
where  a.Sitehsenumb   = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5      
);
/* 
Feb 2017: 50,070
Mar 2016: 51,863 deleted
Apr 2015: 52,259 deleted
Apr 2014: 53,532 deleted
May 2013: 54,402 deleted
54,308 deleted */

create table GAS_FORECAST_RESID_NONHEAT tablespace xlarge_data as
select 
region,
max(b.cde_rte) as cde_rte, /* the max here will be the same as the min - there is only one rate in file b for the structure */
a.sitehsenumb,
a.sitehsealph,
a.sitestrprfx,
a.sitestrname,
a.sitestrsfx1,
a.sitestrsfx2,
a.sitezip5,
max(sitecity) as sitecity, 
max(sitestate) as sitestate, 
max(sitescr) as sitescr,
max(market) as market, 
max(service) as service, 
max(active_status) as active_status, 
max(tc) as tc,
count(*) as numaccts
from GAS_FORECAST_all_custs a
join GAS_FORECAST_RESID_NONHEAT1 b
on  a.Sitehsenumb   = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5
where market = 'RESID'
and SERVICE = 'NONHEAT'
/* do not include heating structures */
and not exists(select * from GAS_FORECAST_ALL_HEAT_STRUCT b
where a.Sitehsenumb   = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5 )
group by 
region,
a.sitehsenumb,
a.sitehsealph,
a.sitestrprfx,
a.sitestrname,
a.sitestrsfx1,
a.sitestrsfx2,
a.sitezip5;


select count(*) from GAS_FORECAST_RESID_NONHEAT ;
/* 
Feb 2017: 225,995
Mar 2016: 250,810
Apr 2015: 267,734
Apr 2014: 283,901
May 2013: 293,589
297,194 */


/* remove any MF from the RESID - already MF */
delete from GAS_FORECAST_RESID_NONHEAT a
where exists(select * from GAS_FORECAST_MF_NONHEAT b
where a.Sitehsenumb   = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5 );
/* 
Feb 2017: 530
Mar 2016: 537 deleted - reflects changes to nonheat for some 030 and 330 rates
Apr 2015: 7 deleted
Apr 2014: 6 deleted 
May 2013: 6 deleted 
8 deleted */

select a.* from GAS_FORECAST_RESID_NONHEAT a
where exists(select * from GAS_FORECAST_COMM_TC b
where a.Sitehsenumb   = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5);
/* 0 */

/* put TC with resi in MF file */
update GAS_FORECAST_RESID_NONHEAT a
set market = 'MFAM',
a.cde_rte = (select cde_rte from GAS_FORECAST_COMM_TC b
where a.Sitehsenumb = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5)
where exists(select * from GAS_FORECAST_COMM_TC b
where a.Sitehsenumb   = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5);
/* 0 */

select count(*) from GAS_FORECAST_RESID_NONHEAT;
/* 
Feb 2017: 225,465
Mar 2016: 250,273
Apr 2015: 267,727
Apr 2014: 283,895
May 2013: 293,583
297,186 */

select region,market,
cde_rte, 
count(*)
from GAS_FORECAST_RESID_NONHEAT
group by region,market,
cde_rte;

insert into GAS_FORECAST_MF_NONHEAT
select a.* from GAS_FORECAST_RESID_NONHEAT a
where market = 'MFAM';
/* 0 */

/* remove any MF from the RESID - already MF */
delete from GAS_FORECAST_RESID_NONHEAT a
where exists(select * from GAS_FORECAST_MF_NONHEAT b
where a.Sitehsenumb   = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5 );
/* 0 */

/* Create Coml NON Heat structure table */
/* this creates a file that puts the most occurances of rate first within each structure */
create table GAS_FORECAST_COML_NONHEAT1 as
select 
sitehsenumb,
sitehsealph,
sitestrprfx,
sitestrname,
sitestrsfx1,
sitestrsfx2,
sitezip5,
cde_rte,
count(*) as rate_cnt
from GAS_FORECAST_all_custs a
where market = 'COML'
and SERVICE = 'NONHEAT'
and sitestrname <> ' ' /* these will be added in later and remain full records */
group by sitehsenumb,
sitehsealph,
sitestrprfx,
sitestrname,
sitestrsfx1,
sitestrsfx2,
sitezip5,
cde_rte
order by sitehsenumb,
sitehsealph,
sitestrprfx,
sitestrname,
sitestrsfx1,
sitestrsfx2,
sitezip5,
count(*) desc;

select count(*) from GAS_FORECAST_COML_NONHEAT1 ;
/* 
Feb 2017: 80,387
Mar 2016: 79,495
Apr 2015: 80,110
Apr 2014: 83,439
*/

/* delete the duplicates, keeping the heating rate with the highest number of occurances */
delete from GAS_FORECAST_COML_NONHEAT1 a
where rowid > any(select rowid from GAS_FORECAST_COML_NONHEAT1 b
where  a.Sitehsenumb   = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5      
);
/* 
Feb 2017: 4641
Mar 2016: 4554 deleted
Apr 2015: 4610 deleted
Apr 2014: 4683 deleted
*/

create table GAS_FORECAST_COML_NONHEAT tablespace medium_data as
select 
region,
max(b.cde_rte) as cde_rte, /* the max here will be the same as the min - there is only one rate in file b for the structure */
a.sitehsenumb,
a.sitehsealph,
a.sitestrprfx,
a.sitestrname,
a.sitestrsfx1,
a.sitestrsfx2,
a.sitezip5,
max(sitecity) as sitecity, 
max(sitestate) as sitestate, 
max(sitescr) as sitescr,
max(market) as market, 
max(service) as service, 
max(active_status) as active_status, 
max(tc) as tc,
count(*) as numaccts
from GAS_FORECAST_all_custs a
join GAS_FORECAST_COML_NONHEAT1 b
on  a.Sitehsenumb   = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5
where market = 'COML'
and SERVICE = 'NONHEAT'
/* do not include heating structures */
and not exists(select * from GAS_FORECAST_ALL_HEAT_STRUCT b
where a.Sitehsenumb   = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5 )
group by 
region,
a.sitehsenumb,
a.sitehsealph,
a.sitestrprfx,
a.sitestrname,
a.sitestrsfx1,
a.sitestrsfx2,
a.sitezip5;


select count(*) from GAS_FORECAST_COML_NONHEAT ;
/* 
Feb 2017: 38,244
Mar 2016: 38,257
Apr 2015: 39,735
Apr 2014: 43,727
*/

/* remove any MF from the COML - already MF */
delete from GAS_FORECAST_COML_NONHEAT a
where exists(select * from GAS_FORECAST_MF_NONHEAT b
where a.Sitehsenumb   = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5 );
/* 
Feb 2017: 57
Mar 2016: 58 deleted - reflects changes to nonheat for some 030 and 330 rates
Apr 2015: 5 deleted
Apr 2014: 4 deleted
May 2013: 5 deleted
6 deleted */

/* remove any RESID from the COML already resi */
delete from GAS_FORECAST_COML_NONHEAT a
where exists(select * from GAS_FORECAST_RESID_NONHEAT b
where a.Sitehsenumb   = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5 );
/* 
Feb 2017: 3319
Mar 2016: 3490 deleted
Apr 2015: 3583 deleted
Apr 2014: 3702 deleted
May 2013: 4042 deleted
4106 deleted */

select count(*) from GAS_FORECAST_COML_NONHEAT;
/* 
Feb 2017: 34,868
Mar 2016: 34,709
Apr 2015: 36,147
Apr 2014: 40,021
*/

/* create NON Heat structure file */
create table GAS_FORECAST_ALL_NONHEAT_STRUC as
select * from GAS_FORECAST_MF_NONHEAT
union select * from GAS_FORECAST_RESID_NONHEAT
union select * from GAS_FORECAST_COML_NONHEAT;

select count(*) from GAS_FORECAST_ALL_NONHEAT_STRUC;
/* 
Feb 2017: 260,926
Mar 2016: 285,577
Apr 2015: 303,911 - No NH
Apr 2014: 323,977
May 2013: 332,548
336,378 */

select region,
market, 
service,
count(*)
from GAS_FORECAST_ALL_NONHEAT_STRUC
group by region,
market, 
service;

/* check that there is no overlap between heat and nonheat */
select count(*) from GAS_FORECAST_ALL_NONHEAT_STRUC a
where exists(select * from GAS_FORECAST_ALL_HEAT_STRUCT b
where a.Sitehsenumb   = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5 );
/* 0 */


/*************************************************************************************/
/*************************************************************************************/
/*************** END OF LOW USE Structure File Creation ******************************/
/*************************************************************************************/
/*************************************************************************************/

/************* Create Total Customer Structure File ****************************/

create table GAS_FORECAST_ALL_CUST_STRUCT tablespace xlarge_data as
select * from GAS_FORECAST_ALL_HEAT_STRUCT
union select * from GAS_FORECAST_ALL_NONHEAT_STRUC;

select count(*) from GAS_FORECAST_ALL_CUST_STRUCT;
/* 
Feb 2017 - 2,622,039
Mar 2016 - 2,607,977
Apr 2015 - 2,585,455 - no NH
Apr 2014 - 2,642,921
May 2013 - 2,620,455
Dec 2012 - 2,607,320
2,591,973 */

/* Check for duplicate structures that may have more than one region associated with them */
select Sitehsenumb,
       sitehsealph,
       Sitestrprfx,
       Sitestrname,
       Sitestrsfx1,
       Sitestrsfx2,
       SiteZip5,
       count(*)
from GAS_FORECAST_ALL_CUST_STRUCT b
group by Sitehsenumb,
       sitehsealph,
       Sitestrprfx,
       Sitestrname,
       Sitestrsfx1,
       Sitestrsfx2,
       SiteZip5
having count(*)>1;
/* 0 */

/* Check for duplicate structures that may have more than one region associated with them */
select Sitehsenumb,
       sitehsealph,
       Sitestrprfx,
       Sitestrname,
       Sitestrsfx1,
       Sitestrsfx2,
       SiteZip5
from GAS_FORECAST_all_cust_units b
group by Sitehsenumb,
       sitehsealph,
       Sitestrprfx,
       Sitestrname,
       Sitestrsfx1,
       Sitestrsfx2,
       SiteZip5
having count(*)>1;
/* 0 */


select count(*) from GAS_FORECAST_all_cust_units where market = 'MFAM';
/* 
Feb 2017 - 52,729
Mar 2016 - 51,879
Apr 2015 - 50,841
Apr 2014 - 50,624
May 2013 - 50,376
Dec 2012 - 50,692
49,876 */

select * from GAS_FORECAST_all_cust_units;

select market,count(*) from GAS_FORECAST_all_cust_units group by market;
/* 
Feb 2017:
MARKET	COUNT(*)
RESID	2382267
MFAM	52729

Mar 2016:
MARKET	COUNT(*)
RESID	2369960
MFAM	51879

Apr 2015:
MARKET	COUNT(*)
RESID	2352041
MFAM	50841

Apr 2014:
MARKET	COUNT(*)
RESID	2396808
MFAM	50624
*/

/* Check commercial heating accounts where the only residential accounts 
   in the same building are non heat */
select a.region, a.cde_rte, count(*) from GAS_FORECAST_ALL_CUST_STRUCT a
where a.market = 'COML'
and exists
(select b.market from GAS_FORECAST_all_cust_units b
where /*a.region = b.region
and */ a.Sitehsenumb   = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5      
/*and b.market <> 'MFAM'*/
)
group by a.region, a.cde_rte;

select a.region, a.cde_rte, b.market,count(*) from GAS_FORECAST_ALL_CUST_STRUCT a
join GAS_FORECAST_all_cust_units b
on  a.Sitehsenumb   = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5 
where a.market = 'COML'
group by a.region, a.cde_rte, b.market;

/*** question for MIKE:
When I created the nonheat files, all of the heating structures including the commercial ones were deleted from 
the nonheat files.  I have about 7K commercial HEATING records where I can redesignate them as MF or RESI:
2 questions:
1. do I keep them as commercial or update them to resi or MF? I think I make it MF or RESI
2. If I update them, should I keep the commercial rate or update it to one of the low use rates? I think I should keep
the commercial heating rate even if I designate it as resi/mf.

***** The final decision was to keep these as commercial after discussing with Dawn Herrity *****
*/

/*
select * from GAS_FORECAST_ALL_CUST_STRUCT a
where a.market = 'RESID'
and exists(select * from GAS_FORECAST_COMM_TC b
where a.Sitehsenumb = b.Sitehsenumb  
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5);
/* 0 */


select count(*) from GAS_FORECAST_ALL_CUST_STRUCT a
where a.market = 'MFAM'
and exists
(select b.market from GAS_FORECAST_all_cust_units b
where a.region = b.region
and a.Sitehsenumb   = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5      
and b.market = 'MFAM'
);
/* 
Feb 2017 - 17,241
Mar 2016 - 17,174
Apr 2015 - 17,278
Apr 2014 - 16,927
*/


select count(*) from GAS_FORECAST_ALL_CUST_STRUCT a
where a.market = 'RESID'
and exists
(select b.market from GAS_FORECAST_all_cust_units b
where a.region = b.region
and a.Sitehsenumb   = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5      
and b.market = 'MFAM'
);
/* 
Feb 2017 - 33,787
Mar 2016 - 33,012
Apr 2015 - 31,889
Apr 2014 - 32,457
*/


select count(*) from GAS_FORECAST_ALL_CUST_STRUCT a
where a.market = 'MFAM'
and exists
(select b.market from GAS_FORECAST_all_cust_units b
where a.region = b.region
and a.Sitehsenumb   = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5      
and b.market = 'RESID'
);
/* 
Feb 2017 - 5,739
Mar 2016 - 5,685
Apr 2015 - 5,651
Apr 2014 - 5,727
*/

select * from GAS_FORECAST_all_cust_units ;

/* update main structure file to include MFAM structs for Resi accts based on acct counts */
update GAS_FORECAST_ALL_CUST_STRUCT a
set a.market = 'MFAM'
where a.market = 'RESID'
and exists
(select b.market from GAS_FORECAST_all_cust_units b
where a.region = b.region
and a.Sitehsenumb   = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5      
and b.market = 'MFAM'
);
/* 
Feb 2017 - 33,787
Mar 2016 - 33,012 updated
Apr 2015 - 31,889 updated
Apr 2014 - 32,457 updated
May 2013 - 32,723 updated
Dec 2012 - 33,171 updated
32,849 updated */

/* delete these ? */
  select a.market,
  a.numaccts,
  b.market,
  b.numaccts
  from GAS_FORECAST_ALL_CUST_STRUCT a
  join GAS_FORECAST_all_cust_units b
  on a.Sitehsenumb   = b.Sitehsenumb  
  and a.sitehsealph   = b.sitehsealph
  and a.Sitestrprfx   = b.Sitestrprfx  
  and a.Sitestrname   = b.Sitestrname  
  and a.Sitestrsfx1   = b.Sitestrsfx1  
  and a.Sitestrsfx2   = b.Sitestrsfx2  
  and a.SiteZip5      = b.SiteZip5  
  where a.market <> b.market
  ;

select a.market,
a.numaccts,
b.market,
b.numaccts
from GAS_FORECAST_ALL_CUST_STRUCT a
join GAS_FORECAST_all_cust_units b
on a.Sitehsenumb   = b.Sitehsenumb  
and a.sitehsealph   = b.sitehsealph
and a.Sitestrprfx   = b.Sitestrprfx  
and a.Sitestrname   = b.Sitestrname  
and a.Sitestrsfx1   = b.Sitestrsfx1  
and a.Sitestrsfx2   = b.Sitestrsfx2  
and a.SiteZip5      = b.SiteZip5  
where a.numaccts > b.numaccts
;

/* END delete these */

/* Run a summary to see if the numbers look reasonable */
select region,
market,
service, 
count(*)
from GAS_FORECAST_ALL_CUST_STRUCT
group by region,
market,
service;

select * from GAS_FORECAST_ALL_CUST_STRUCT
where Sitestrname = ' ';
/* 0 */

select * from GAS_FORECAST_all_custs
where Sitestrname = ' ';
/* 
Feb 2017 - 10
Mar 2016 - 10
Apr 2015 - 11
Apr 2014 - 461
*/

select market, count(*) from GAS_FORECAST_all_custs
where Sitestrname = ' '
group by market;
/* 
Feb 2017:
RESID	5
COML	5

Mar 2016:
RESID	5
COML	5

Apr 2015:
RESID	6
COML	5

Apr 2014:
MARKET	COUNT(*)
RESID	151
COML	301
MFAM	9
*/


/* remove the records from the structure file with no street name - these should not have been grouped */
delete from GAS_FORECAST_ALL_CUST_STRUCT
where Sitestrname = ' ';
/* 0 deleted */

/* add the blank street records back in keeping the accounts whole */
insert into GAS_FORECAST_ALL_CUST_STRUCT
select REGION, 
CDE_RTE, 
SITEHSENUMB, 
sitehsealph,
SITESTRPRFX, 
SITESTRNAME, 
SITESTRSFX1, 
SITESTRSFX2, 
SITEZIP5, 
SITECITY, 
SITESTATE, 
SITESCR, 
MARKET, 
SERVICE, 
ACTIVE_STATUS, 
TC, 
1 as NUMACCTS
from GAS_FORECAST_all_custs
where Sitestrname = ' ';
/* 
Feb 2017 - 10
Mar 2016 - 10 inserted
Apr 2015 - 11 inserted
Apr 2014 - 461 inserted
*/

/* add the number and tpye of accounts at each structure */
alter table GAS_FORECAST_ALL_CUST_STRUCT
add(RESI_HEAT_ACCTS    number(10),
MFAM_HEAT_ACCTS    number(10),
COML_HEAT_ACCTS    number(10),
RESI_NONHEAT_ACCTS number(10),
MFAM_NONHEAT_ACCTS number(10),
COML_NONHEAT_ACCTS number(10),
total_accts        number(10));

alter table GAS_FORECAST_ALL_CUST_STRUCT
drop(numaccts);

create index idx_GAS_FCST_ALL_CUST_STRUCT 
on GAS_FORECAST_ALL_CUST_STRUCT(SITEHSENUMB,SITESTRPRFX,SITESTRNAME,SITESTRSFX1,SITESTRSFX2,SITEZIP5);

create index idx_GAS_FCST_cust_acct_sum 
on GAS_FORECAST_cust_acct_sum(SITEHSENUMB,SITESTRPRFX,SITESTRNAME,SITESTRSFX1,SITESTRSFX2,SITEZIP5);

select Sitehsenumb,
       sitehsealph,
       Sitestrprfx,
       Sitestrname,
       Sitestrsfx1,
       Sitestrsfx2,
       SiteZip5,
       count(*)
from GAS_FORECAST_cust_acct_sum b
group by Sitehsenumb,
       sitehsealph,
       Sitestrprfx,
       Sitestrname,
       Sitestrsfx1,
       Sitestrsfx2,
       SiteZip5
having count(*)>1;
/* 0 */


update GAS_FORECAST_ALL_CUST_STRUCT a
set (RESI_HEAT_ACCTS,   
MFAM_HEAT_ACCTS,   
COML_HEAT_ACCTS,   
RESI_NONHEAT_ACCTS,
MFAM_NONHEAT_ACCTS,
COML_NONHEAT_ACCTS,
total_accts        ) = ( select RESI_HEAT_ACCTS,   
MFAM_HEAT_ACCTS,   
COML_HEAT_ACCTS,   
RESI_NONHEAT_ACCTS,
MFAM_NONHEAT_ACCTS,
COML_NONHEAT_ACCTS,
total_accts   
from GAS_FORECAST_cust_acct_sum b
where a.SITEHSENUMB = b.SITEHSENUMB 
and a.sitehsealph   = b.sitehsealph
and a.SITESTRPRFX = b.SITESTRPRFX 
and a.SITESTRNAME = b.SITESTRNAME 
and a.SITESTRSFX1 = b.SITESTRSFX1 
and a.SITESTRSFX2 = b.SITESTRSFX2 
and a.SITEZIP5    = b.SITEZIP5)
where exists( select * from GAS_FORECAST_cust_acct_sum b
where a.SITEHSENUMB = b.SITEHSENUMB 
and a.sitehsealph   = b.sitehsealph
and a.SITESTRPRFX = b.SITESTRPRFX 
and a.SITESTRNAME = b.SITESTRNAME 
and a.SITESTRSFX1 = b.SITESTRSFX1 
and a.SITESTRSFX2 = b.SITESTRSFX2 
and a.SITEZIP5    = b.SITEZIP5);
/* 2 minutes to run */
commit;

/*************************************************************/
/*************************************************************/
/*********** BEGIN THE TRW MATCH PROCESS *********************/
/*************************************************************/
/*************************************************************/
select count(*) from mi_edr_prod.edr_trw t
/* 
Feb 2017 - 9,332,557
Mar 2016 - 9,300,572
Apr 2015 - 9,269,385
Apr 2014 - 9,177,823
May 2013 - 7,965,724
Dec 2012 - 7,965,724
7,739,040 */
where t.cde_situs_code1_score_trw <> '9'
/* 
Feb 2017 - 8,119,134
Mar 2016 - 8,070,769
Apr 2015 - 8,023,920
Apr 2014 - 7,954,374
May 2013 - 6,977,260
Dec 2012 - 6,977,260
6,886,910 */
;

/* Create a TRW units file */

/* useful fields in Zip file */
select 
region,
zip5, 
city_name, 
state_abbrev, 
county_name, 
state_fips, 
county_fips, 
dcd_zip_code_type, 
constrained_zip_commercial, 
constrained_zip_residential, 
constrained_comments,
constrained_rule,
gas_cust_found, 
franchise_zip, 
gas_main_only, 
gasserv_munipwr, 
total_border_utilities, 
municipal_electric
from zips_franchise_gas_forecast z;

select count(*) from zips_franchise_gas_forecast
/* 3328 */
where gas_cust_found = 'Y' or franchise_zip = 'Y' or gas_main_only = 'Y'
or total_border_utilities > 0;
/* 1973 */

select * from zips_franchise_gas_forecast
where not(gas_cust_found = 'Y' or franchise_zip = 'Y' or gas_main_only = 'Y');
/* 2260 */

select * from zips_franchise_gas_forecast
where gas_main_only = 'Y';

/* Create interim table to append county use for MA counties with missing data for now */
drop table temp_trw;
create table temp_trw as
select a.cde_state_trw,             
a.cde_county_trw,            
a.id_apn_trw,                
a.adr_situs_hse_num_trw,   
a.adr_situs_hse_alpha_trw,  
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_city_trw,        
a.adr_situs_state_trw,       
a.adr_situs_zip_trw,         
a.cde_situs_code1_score_trw, 
a.num_yr_built_actl_trw,     
a.num_yr_built_eff_trw,      
a.qty_area_univ_bldg_trw,    
a.qty_area_bldg_trw,         
a.qty_area_living_trw,       
a.qty_area_ground_fl_trw,    
a.qty_area_bldg_gross_trw,   
a.qty_area_bldg_adj_trw,     
a.qty_area_basement_trw,     
a.qty_stories_trw,           
a.qty_unit_trw,              
a.txt_county_use1_trw,       
a.dte_last_update
from mi_edr_prod.edr_trw a
join zips_franchise_gas_forecast z
on a.adr_situs_zip_trw = z.zip5;

select
cde_state_trw,             
cde_county_trw,
count(*)
from temp_trw
where txt_county_use1_trw = ' '
and cde_state_trw <> '33'
group by cde_state_trw,             
cde_county_trw
order by cde_state_trw,             
cde_county_trw
;
/* 
Feb 2017:
CDE_STATE_TRW	CDE_COUNTY_TRW	COUNT(*)
25	001	22
25	003	5
25	005	1
25	007	2
25	009	13
25	011	38
25	013	19
25	015	3
25	017	27
25	021	9
25	023	11
25	025	2
25	027	24
36	005	396
36	059	1
36	065	21
36	071	2
36	073	7
36	075	1
36	077	1
36	081	26
36	085	1
36	103	595
44	009	1

Mar 2016:
CDE_STATE_TRW	CDE_COUNTY_TRW	COUNT(*)
25	001	9308
25	003	3316
25	005	8287
25	007	1498
25	009	10722
25	011	2321
25	013	6291
25	015	2977
25	017	19602
25	019	2208
25	021	9142
25	023	10590
25	025	16625
25	027	11552
36	005	326
36	019	2
36	025	1
36	033	1
36	039	1
36	047	29
36	053	1
36	063	1
36	065	21
36	069	1
36	071	2
36	073	7
36	075	1
36	077	1
36	081	25
36	085	1
36	089	1
36	097	1
36	103	595
36	117	2
44	009	1

Apr 2015:
CDE_STATE_TRW	CDE_COUNTY_TRW	COUNT(*)
25	001	1
25	003	5
25	013	1
25	015	1
25	017	1
25	023	42
25	027	1
36	005	326
36	017	1
36	019	1
36	025	1
36	029	3
36	039	1
36	059	6
36	061	1
36	065	21
36	069	1
36	071	2
36	073	7
36	075	2
36	077	1
36	081	90
36	089	1
36	091	1
36	097	1
36	101	1
36	103	1488
36	111	1
44	009	1
*/

create index idx_temp_trw on temp_trw(adr_situs_zip_trw, adr_situs_hse_num_trw, adr_situs_str_nme_trw,
 adr_situs_str_prfx_trw, adr_situs_str_sufx1_trw, adr_situs_str_sufx2_trw);

/* update the missing county use codes as best we can with last year's saturation data */
update temp_trw a
set txt_county_use1_trw = (select txt_county_use1_trw from gas_forecast_saturation_final b
where a.adr_situs_hse_num_trw   = b.Sitehsenumb        
and   a.adr_situs_hse_alpha_trw = b.sitehsealph
and   a.adr_situs_str_prfx_trw  = b.Sitestrprfx
and   a.adr_situs_str_nme_trw   = b.Sitestrname
and   a.adr_situs_str_sufx1_trw = b.Sitestrsfx1
and   a.adr_situs_str_sufx2_trw = b.Sitestrsfx2
and   a.adr_situs_zip_trw       = b.SiteZip5
and b.Sitestrname<>' '
and b.match <> 'CUST')
where a.txt_county_use1_trw = ' '
and exists(select * from gas_forecast_saturation_final b
where a.adr_situs_hse_num_trw   = b.Sitehsenumb        
and   a.adr_situs_hse_alpha_trw = b.sitehsealph
and   a.adr_situs_str_prfx_trw  = b.Sitestrprfx
and   a.adr_situs_str_nme_trw   = b.Sitestrname
and   a.adr_situs_str_sufx1_trw = b.Sitestrsfx1
and   a.adr_situs_str_sufx2_trw = b.Sitestrsfx2
and   a.adr_situs_zip_trw       = b.SiteZip5
and b.Sitestrname<>' '
and b.match <> 'CUST')
;
/* 
Feb 2017 - 1203 updated
Mar 2016 - 111,841 updated */

commit;

select
cde_state_trw,             
cde_county_trw,
count(*)
from temp_trw
where txt_county_use1_trw = ' '
and cde_state_trw <> '33'
group by cde_state_trw,             
cde_county_trw
order by cde_state_trw,             
cde_county_trw
;
/* 
Feb 2017:
CDE_STATE_TRW	CDE_COUNTY_TRW	COUNT(*)
25	001	3
25	005	1
25	007	1
25	009	3
25	013	2
25	015	2
25	017	6
25	021	1
25	023	7
25	027	6
36	005	307
36	065	11
36	071	2
36	073	2
36	077	1
36	081	2
36	103	595
44	009	1

Mar 2016:
CDE_STATE_TRW	CDE_COUNTY_TRW	COUNT(*)
25	001	765
25	003	83
25	005	163
25	007	48
25	009	544
25	011	80
25	013	135
25	015	93
25	017	350
25	019	70
25	021	318
25	023	417
25	025	139
25	027	398
36	005	310
36	019	1
36	025	1
36	039	1
36	047	2
36	063	1
36	065	11
36	069	1
36	071	2
36	073	2
36	077	1
36	081	2
36	089	1
36	097	1
36	103	595
36	117	1
44	009	1


/* create a master TRW file based off of the zip table */
create table gas_forecast_TRW_Master tablespace xlarge_data as
select a.cde_state_trw,             
a.cde_county_trw,            
a.id_apn_trw,                
a.adr_situs_hse_num_trw,
a.adr_situs_hse_alpha_trw,     
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_city_trw,        
a.adr_situs_state_trw,       
a.adr_situs_zip_trw,         
a.cde_situs_code1_score_trw, 
a.num_yr_built_actl_trw,     
a.num_yr_built_eff_trw,      
a.qty_area_univ_bldg_trw,    
a.qty_area_bldg_trw,         
a.qty_area_living_trw,       
a.qty_area_ground_fl_trw,    
a.qty_area_bldg_gross_trw,   
a.qty_area_bldg_adj_trw,     
a.qty_area_basement_trw,     
a.qty_stories_trw,           
a.qty_unit_trw,              
a.txt_county_use1_trw,       
a.dte_last_update,           
case 
  when e1.adr_std_zip is null then 99999
  else e1.num_lp_dist 
end as num_situs_lp_dist_trw,     
case 
  when e1.adr_std_zip is null then 99999
  else e1.num_hp_dist 
end as num_situs_hp_dist_trw,     
case 
  when e2.adr_std_zip is null then 99999
  else e2.num_main_dist 
end as num_situs_main_dist_trw,   
case 
  when e2.adr_std_zip is null then 99999
  else e2.cde_on_main 
end as cde_situs_on_main_trw,
z.region,
z.gas_cust_found,
z.franchise_zip,
z.surrounding_town,
z.constrained_zip_commercial, 
z.constrained_zip_residential,
z.constrained_comments,
z.constrained_rule,
z.dcd_zip_code_type, 
m.description,
m.market
/*from mi_edr_prod.edr_trw a */
from temp_trw a
join zips_franchise_gas_forecast z
on a.adr_situs_zip_trw = z.zip5
left join gas_forecast_cntyuse_market m /* This does not contain NH data */
on a.txt_county_use1_trw = m.county_use_code
and z.region = m.region
left join
(select 
adr_std_zip, 
adr_std_hse_nbr, 
adr_std_str_nm, 
adr_std_pre_dir, 
adr_std_str_sfx, 
adr_std_sfx_dir,
min(case
  when num_lp_dist = -1 then 99999
  else num_lp_dist
end) as num_lp_dist,
min(case
  when num_hp_dist = -1 then 99999
  else num_hp_dist
end) as num_hp_dist
from mi_edr_prod.edr_gis_addr_lctn
group by adr_std_zip, 
adr_std_hse_nbr, 
adr_std_str_nm, 
adr_std_pre_dir, 
adr_std_str_sfx, 
adr_std_sfx_dir) e1
on  e1.adr_std_zip     = a.adr_situs_zip_trw      
and e1.adr_std_hse_nbr = a.adr_situs_hse_num_trw  
and e1.adr_std_str_nm  = a.adr_situs_str_nme_trw  
and e1.adr_std_pre_dir = a.adr_situs_str_prfx_trw 
and e1.adr_std_str_sfx = a.adr_situs_str_sufx1_trw
and e1.adr_std_sfx_dir = a.adr_situs_str_sufx2_trw
left join 
(select 
adr_std_zip, 
adr_std_hse_nbr, 
adr_std_str_nm, 
adr_std_pre_dir, 
adr_std_str_sfx, 
adr_std_sfx_dir,
min(case
  when num_main_dist = -1 then 99999
  else num_main_dist
end) as num_main_dist, 
min(case
  when cde_on_main = 0 then 0
  else 99999
end) as cde_on_main
from mi_edr_prod.edr_eec_gis_addr_lctn t
group by adr_std_zip, 
adr_std_hse_nbr, 
adr_std_str_nm, 
adr_std_pre_dir, 
adr_std_str_sfx, 
adr_std_sfx_dir) e2
on  e2.adr_std_zip     = a.adr_situs_zip_trw      
and e2.adr_std_hse_nbr = a.adr_situs_hse_num_trw  
and e2.adr_std_str_nm  = a.adr_situs_str_nme_trw  
and e2.adr_std_pre_dir = a.adr_situs_str_prfx_trw 
and e2.adr_std_str_sfx = a.adr_situs_str_sufx1_trw
and e2.adr_std_sfx_dir = a.adr_situs_str_sufx2_trw
/*where z.gas_cust_found = 'Y' or z.franchise_zip = 'Y' or z.surrounding_town = 'Y'*/
;

create index idx_gas_fcst_TRW_Master on gas_forecast_TRW_Master(
adr_situs_hse_num_trw  ,
adr_situs_hse_alpha_trw,
adr_situs_str_prfx_trw ,
adr_situs_str_nme_trw  ,
adr_situs_str_sufx1_trw,
adr_situs_str_sufx2_trw,
adr_situs_zip_trw  );

create index idx_gas_fcst_TRW_Master2 on gas_forecast_TRW_Master(
adr_situs_hse_num_trw  ,
adr_situs_str_prfx_trw ,
adr_situs_str_nme_trw  ,
adr_situs_str_sufx1_trw,
adr_situs_str_sufx2_trw,
adr_situs_zip_trw  );

select count(*) from gas_forecast_TRW_Master;
/* 
Feb 2017 - 9,332,553
Mar 2016 - 9,300,563
Apr 2015 - 9,269,380
Apr 2014 - 9,177,781
*/


select region, market, count(*)
from gas_forecast_TRW_Master
group by region, market;

select * from gas_forecast_TRW_Master
where market is null
and adr_situs_state_trw <> 'NH';

select 
z.region,
z.gas_cust_found,
z.franchise_zip,
z.surrounding_town,
count(*)
from gas_forecast_TRW_Master z
where txt_county_use1_trw = ' '
and adr_situs_state_trw <> 'NH'
group by z.region,
z.gas_cust_found,
z.franchise_zip,
z.surrounding_town
order by z.region,
z.gas_cust_found,
z.franchise_zip,
z.surrounding_town;

select market, count(*)
from gas_forecast_TRW_Master
where adr_situs_state_trw <> 'NH'
group by market;
/* 
Feb 2017:
MARKET	COUNT(*)
	1042
COML	641656
CONDO	805374
MFAM	147288
PUBLIC LAND	55967
PUBLIC SVCS	12554
RESID	6078856
VACANT-COMM	186420
VACANT-RESI	569430
VACANT-UNDVLPBL	130344
VACANT-UNKNOWN	152000

Mar 2016:
MARKET	COUNT(*)
	556175
COML	717555
CONDO	771403
MFAM	146389
PUBLIC LAND	55601
PUBLIC SVCS	12462
RESID	6080804
VACANT-COMM	114204
VACANT-RESI	571842
VACANT-UNDVLPBL	121869
VACANT-UNKNOWN	152259


Apr 2015:
MARKET	COUNT(*)
	553641
COML	740306
CONDO	748374
MFAM	142454
PUBLIC LAND	54977
PUBLIC SVCS	12305
RESID	6053376
VACANT-COMM	114590
VACANT-RESI	574383
VACANT-UNDVLPBL	123083
VACANT-UNKNOWN	151891

Apr 2014:
MARKET	COUNT(*)
	525952
COML	734479
CONDO	559768
MFAM	300604
PUBLIC LAND	52910
PUBLIC SVCS	11685
RESID	6040141
VACANT-COMM	110150
VACANT-RESI	567903
VACANT-UNDVLPBL	119328
VACANT-UNKNOWN	154861
*/

/* Create residential file */
/* First create a table that determines the txt_county_use that has the greatest number of occurances per
structure */
/* this creates a file that puts the most occurances first within each structure */
create table gas_forecast_cnty_use_resi1 as
select a.adr_situs_hse_num_trw,    
a.adr_situs_hse_alpha_trw, 
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw,
txt_county_use1_trw,
count(*) as cntyuse_cnt
from gas_forecast_TRW_Master a
where market = 'RESID'
and adr_situs_str_nme_trw <> ' ' /* these will be added in later and remain full records */
group by a.adr_situs_hse_num_trw,     
a.adr_situs_hse_alpha_trw,
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw,
txt_county_use1_trw
order by a.adr_situs_hse_num_trw,     
a.adr_situs_hse_alpha_trw,
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw,
count(*) desc;

select count(*) from gas_forecast_cnty_use_resi1 ;
/* 
Feb 2017 - 6,016,758
Mar 2016 - 5,999,571
Apr 2015 - 5,974,175
Apr 2014 - 5,969,249
May 2013 - 5,422,385 - 7 address pieces
Dec 2012 - 5,273,362 - includes all of TRW
May 2012 - 3,163,834 - Only the franchise areas */


/* delete the duplicates, keeping the county use with the highest number of occurances */
delete from gas_forecast_cnty_use_resi1 a
where rowid > any(select rowid from gas_forecast_cnty_use_resi1 b
where a.adr_situs_hse_num_trw   = b.adr_situs_hse_num_trw  
and a.adr_situs_hse_alpha_trw = b.adr_situs_hse_alpha_trw
and a.adr_situs_str_prfx_trw  = b.adr_situs_str_prfx_trw 
and a.adr_situs_str_nme_trw   = b.adr_situs_str_nme_trw  
and a.adr_situs_str_sufx1_trw = b.adr_situs_str_sufx1_trw
and a.adr_situs_str_sufx2_trw = b.adr_situs_str_sufx2_trw
and a.adr_situs_zip_trw       = b.adr_situs_zip_trw      
);
/*
Feb 2017 - 13156 
Mar 2016 - 15327 deleted
Apr 2015 - 16610 deleted
Apr 2014 - 15230 deleted
May 2013 - 14940 deleted
Dec 2012 - 16549 deleted
May 2012 - 6993 deleted */

select count(*) from gas_forecast_cnty_use_resi1;
/* 
Feb 2017 - 6,003,602
Mar 2016 - 5,984,244
Apr 2015 - 5,957,565
Apr 2014 - 5,954,019
May 2013 - 5,407,445
Dec 2012 - 5,256,813
May 2012 - 3,156,841 */


create table gas_forecast_Resi_TRW_Strct tablespace xlarge_data as
select a.adr_situs_hse_num_trw,     
a.adr_situs_hse_alpha_trw,
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw,
min(case
  when region in('MA','NH') and a.num_situs_main_dist_trw = -1 then 99999
  when region in('MA','NH') and a.num_situs_main_dist_trw > -1 then a.num_situs_main_dist_trw
  when region not in('MA','NH') and a.num_situs_lp_dist_trw >= 0 and a.num_situs_lp_dist_trw < num_situs_hp_dist_trw then a.num_situs_lp_dist_trw
  when region not in('MA','NH') and a.num_situs_hp_dist_trw >= 0 and a.num_situs_hp_dist_trw <= num_situs_lp_dist_trw then a.num_situs_hp_dist_trw
  else 99999
end) as dist_to_main,
min(case
  when cde_situs_on_main_trw = 0 then 0
  else 99999
end) as cde_on_main,
min(a.region                     ) as region                     ,
min(a.gas_cust_found             ) as gas_cust_found             ,
min(a.franchise_zip              ) as franchise_zip              ,
min(a.constrained_zip_commercial ) as constrained_zip_commercial ,
min(a.constrained_zip_residential) as constrained_zip_residential,
min(a.constrained_comments) as constrained_comments,
min(a.constrained_rule) as constrained_rule,
min(a.dcd_zip_code_type          ) as dcd_zip_code_type          ,
min(a.market                     ) as market                     ,
greatest(count(*), sum(nvl(qty_unit_trw,0))) as trwunits,
max(b.txt_county_use1_trw) as txt_county_use1_trw, /* this will be the same for all records so a group by is unnecessary */
max(a.id_apn_trw) as id_apn_trw, 
max(b.cntyuse_cnt) as cntyuse_cnt
from gas_forecast_TRW_Master a
join gas_forecast_cnty_use_resi1 b
on  a.adr_situs_hse_num_trw   = b.adr_situs_hse_num_trw  
and a.adr_situs_hse_alpha_trw = b.adr_situs_hse_alpha_trw
and a.adr_situs_str_prfx_trw  = b.adr_situs_str_prfx_trw    
and a.adr_situs_str_nme_trw   = b.adr_situs_str_nme_trw     
and a.adr_situs_str_sufx1_trw = b.adr_situs_str_sufx1_trw   
and a.adr_situs_str_sufx2_trw = b.adr_situs_str_sufx2_trw   
and a.adr_situs_zip_trw       = b.adr_situs_zip_trw          
where a.market = 'RESID'
and a.adr_situs_str_nme_trw <> ' ' /* these will be added in later and remain full records */
group by a.adr_situs_hse_num_trw,     
a.adr_situs_hse_alpha_trw,
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw;

/* test for dupes - there shouldn't be any */
select a.adr_situs_hse_num_trw,     
a.adr_situs_hse_alpha_trw,
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw
from gas_forecast_Resi_TRW_Strct a
group by a.adr_situs_hse_num_trw,     
a.adr_situs_hse_alpha_trw,
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw
having count(*)>1;
/* 0 */

select * from gas_forecast_Resi_TRW_Strct;

/* Create the 6 address piece version */
create table gas_forecast_Resi_TRW_Strcta tablespace xlarge_data as
select a.adr_situs_hse_num_trw,     
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw,
min(dist_to_main) as dist_to_main,
min(cde_on_main) as cde_on_main,
min(a.region                     ) as region                     ,
min(a.gas_cust_found             ) as gas_cust_found             ,
min(a.franchise_zip              ) as franchise_zip              ,
min(a.constrained_zip_commercial ) as constrained_zip_commercial ,
min(a.constrained_zip_residential) as constrained_zip_residential,
min(a.constrained_comments) as constrained_comments,
min(a.constrained_rule) as constrained_rule,
min(a.dcd_zip_code_type          ) as dcd_zip_code_type          ,
min(a.market                     ) as market                     ,
max(trwunits) as trwunits,
max(txt_county_use1_trw) as txt_county_use1_trw, /* this will be the same for all records so a group by is unnecessary */
max(a.id_apn_trw) as id_apn_trw, 
max(cntyuse_cnt) as cntyuse_cnt
from gas_forecast_Resi_TRW_Strct a
group by a.adr_situs_hse_num_trw,     
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw;

/* test for dupes - there shouldn't be any */
select a.adr_situs_hse_num_trw,     
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw
from gas_forecast_Resi_TRW_Strcta a
group by a.adr_situs_hse_num_trw,     
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw
having count(*)>1;
/* 0 */

select count(*) from gas_forecast_Resi_TRW_Strcta;
/* 
Feb 2017 - 5995006
Mar 2016 - 5975766
Apr 2015 - 5948911
Apr 2014 - 5936849
May 2013 - 5399253 */

/* END Create residential file */


/* do the 'EXEMPT CONDO-OTHER' as a separate entity.  For multiple addresses in 'EXEMPT CONDO-OTHER' 
if they match to other condo, make them condo if they match to commercial, make them commercial */
create table gas_forecast_EXEMPT_CONDO1 as
select a.adr_situs_hse_num_trw,    
a.adr_situs_hse_alpha_trw, 
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw,
count(*) as exempt_cnt,
sum(
case
  when market = 'COML' then 1
  else 0
end) as COML_CNT,
sum(
case
  when market = 'CONDO' and description <> 'EXEMPT CONDO-OTHER' then 1
  else 0
end) as CONDO_CNT
from (
select * from gas_forecast_TRW_Master a
where exists(select * from gas_forecast_TRW_Master b
where description = 'EXEMPT CONDO-OTHER'
and a.adr_situs_hse_num_trw   = b.adr_situs_hse_num_trw
and a.adr_situs_hse_alpha_trw = b.adr_situs_hse_alpha_trw
and a.adr_situs_str_prfx_trw  = b.adr_situs_str_prfx_trw
and a.adr_situs_str_nme_trw   = b.adr_situs_str_nme_trw
and a.adr_situs_str_sufx1_trw = b.adr_situs_str_sufx1_trw
and a.adr_situs_str_sufx2_trw = b.adr_situs_str_sufx2_trw
and a.adr_situs_zip_trw       = b.adr_situs_zip_trw)
) a
group by a.adr_situs_hse_num_trw,     
a.adr_situs_hse_alpha_trw,
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw;

select * from gas_forecast_EXEMPT_CONDO1
where coml_cnt>0 and condo_cnt=0;

/* update exempt condo records from CONDO to Commercial where there are no other CONDO records at that address */
update gas_forecast_TRW_Master a
set market = 'COML'
where description = 'EXEMPT CONDO-OTHER'
and exists(select * from gas_forecast_EXEMPT_CONDO1 b
where coml_cnt>0 and condo_cnt=0
and a.adr_situs_hse_num_trw   = b.adr_situs_hse_num_trw
and a.adr_situs_hse_alpha_trw = b.adr_situs_hse_alpha_trw
and a.adr_situs_str_prfx_trw  = b.adr_situs_str_prfx_trw
and a.adr_situs_str_nme_trw   = b.adr_situs_str_nme_trw
and a.adr_situs_str_sufx1_trw = b.adr_situs_str_sufx1_trw
and a.adr_situs_str_sufx2_trw = b.adr_situs_str_sufx2_trw
and a.adr_situs_zip_trw       = b.adr_situs_zip_trw);
/* 
Feb 2017 - 3218 updated - County Use Code 990 for MA was the big change for this year
Mar 2016 - 133 updated
Apr 2015 - 342 updated
Apr 2014 - 213 rows updated
May 2013 - 167 records updated 
149 records updated */


/* Create Commercial file */
/* First create a table that determines the txt_county_use that has the greatest number of occurances per
structure */
/* this creates a file that puts the most occurances first within each structure */
create table gas_forecast_cnty_use_comm1 as
select a.adr_situs_hse_num_trw,     
a.adr_situs_hse_alpha_trw,
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw,
txt_county_use1_trw,
count(*) as cntyuse_cnt
from gas_forecast_TRW_Master a
where market = 'COML'
and adr_situs_str_nme_trw <> ' ' /* these will be added in later and remain full records */
group by a.adr_situs_hse_num_trw,   
a.adr_situs_hse_alpha_trw,  
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw,
txt_county_use1_trw
order by a.adr_situs_hse_num_trw,     
a.adr_situs_hse_alpha_trw,  
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw,
count(*) desc;

select count(*) from gas_forecast_cnty_use_comm1 ;
/* 
Feb 2017 - 523807
Mar 2016 - 569939
Apr 2015 - 588316
Apr 2014 - 585392
May 2013 - 501919
491808 */

/* delete the duplicates, keeping the county use with the highest number of occurances */
delete from gas_forecast_cnty_use_comm1 a
where rowid > any(select rowid from gas_forecast_cnty_use_comm1 b
where a.adr_situs_hse_num_trw   = b.adr_situs_hse_num_trw  
and a.adr_situs_hse_alpha_trw = b.adr_situs_hse_alpha_trw
and a.adr_situs_str_prfx_trw  = b.adr_situs_str_prfx_trw 
and a.adr_situs_str_nme_trw   = b.adr_situs_str_nme_trw  
and a.adr_situs_str_sufx1_trw = b.adr_situs_str_sufx1_trw
and a.adr_situs_str_sufx2_trw = b.adr_situs_str_sufx2_trw
and a.adr_situs_zip_trw       = b.adr_situs_zip_trw      
);
/* 
Feb 2017 - 30940
Mar 2016 - 32249 deleted
Apr 2015 - 38678 deleted
Apr 2014 - 36801 deleted
May 2013 - 30351 deleted
30515 deleted */

select count(*) from gas_forecast_cnty_use_comm1;
/* 
Feb 2017 - 492867
Mar 2016 - 537690
Apr 2015 - 549638
Apr 2014 - 548591
May 2013 - 471568
461293 */

select * from gas_forecast_cnty_use_comm1;

create table gas_forecast_Comm_TRW_Strct tablespace xlarge_data as
select a.adr_situs_hse_num_trw,
a.adr_situs_hse_alpha_trw,
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw,
min(case
  when region in('MA','NH') and num_situs_main_dist_trw = -1 then 99999
  when region in('MA','NH') and num_situs_main_dist_trw > -1 then num_situs_main_dist_trw
  when region not in('MA','NH') and num_situs_lp_dist_trw >= 0 and num_situs_lp_dist_trw < num_situs_hp_dist_trw then num_situs_lp_dist_trw
  when region not in('MA','NH') and num_situs_hp_dist_trw >= 0 and num_situs_hp_dist_trw <= num_situs_lp_dist_trw then num_situs_hp_dist_trw
  else 99999
end) as dist_to_main,
min(case
  when cde_situs_on_main_trw = 0 then 0
  else 99999
end) as cde_on_main,
min(a.region                     ) as region                     ,
min(a.gas_cust_found             ) as gas_cust_found             ,
min(a.franchise_zip              ) as franchise_zip              ,
min(a.constrained_zip_commercial ) as constrained_zip_commercial ,
min(a.constrained_zip_residential) as constrained_zip_residential,
min(a.constrained_comments) as constrained_comments,
min(a.constrained_rule) as constrained_rule,
min(a.dcd_zip_code_type          ) as dcd_zip_code_type          ,
min(a.market                     ) as market                     ,
greatest(count(*), sum(nvl(qty_unit_trw,0))) as trwunits,
max(b.txt_county_use1_trw) as txt_county_use1_trw, /* this will be the same for all records so a group by is unnecessary */
max(a.id_apn_trw) as id_apn_trw, 
max(b.cntyuse_cnt) as cntyuse_cnt
from gas_forecast_TRW_Master a
join gas_forecast_cnty_use_comm1 b
on  a.adr_situs_hse_num_trw   = b.adr_situs_hse_num_trw  
and a.adr_situs_hse_alpha_trw = b.adr_situs_hse_alpha_trw
and a.adr_situs_str_prfx_trw  = b.adr_situs_str_prfx_trw    
and a.adr_situs_str_nme_trw   = b.adr_situs_str_nme_trw     
and a.adr_situs_str_sufx1_trw = b.adr_situs_str_sufx1_trw   
and a.adr_situs_str_sufx2_trw = b.adr_situs_str_sufx2_trw   
and a.adr_situs_zip_trw       = b.adr_situs_zip_trw          
where a.market = 'COML'
and a.adr_situs_str_nme_trw <> ' ' /* these will be added in later and remain full records */
group by a.adr_situs_hse_num_trw,   
a.adr_situs_hse_alpha_trw,
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw;

/* test for dupes - there shouldn't be any */
select a.adr_situs_hse_num_trw,     
a.adr_situs_hse_alpha_trw,
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw
from gas_forecast_Comm_TRW_Strct a
group by a.adr_situs_hse_num_trw,     
a.adr_situs_hse_alpha_trw,
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw
having count(*)>1;
/* 0 */

select * from gas_forecast_Comm_TRW_Strct;

/* Create the 6 address piece version of the Commercial File */
create table gas_forecast_Comm_TRW_Strcta tablespace xlarge_data as
select a.adr_situs_hse_num_trw,     
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw,
min(dist_to_main) as dist_to_main,
min(cde_on_main) as cde_on_main,
min(a.region                     ) as region                     ,
min(a.gas_cust_found             ) as gas_cust_found             ,
min(a.franchise_zip              ) as franchise_zip              ,
min(a.constrained_zip_commercial ) as constrained_zip_commercial ,
min(a.constrained_zip_residential) as constrained_zip_residential,
min(a.constrained_comments) as constrained_comments,
min(a.constrained_rule) as constrained_rule,
min(a.dcd_zip_code_type          ) as dcd_zip_code_type          ,
min(a.market                     ) as market                     ,
max(trwunits) as trwunits,
max(txt_county_use1_trw) as txt_county_use1_trw, /* this will be the same for all records so a group by is unnecessary */
max(a.id_apn_trw) as id_apn_trw, 
max(cntyuse_cnt) as cntyuse_cnt
from gas_forecast_Comm_TRW_Strct a
group by a.adr_situs_hse_num_trw,     
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw;

/* test for dupes - there shouldn't be any */
select a.adr_situs_hse_num_trw,     
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw
from gas_forecast_Comm_TRW_Strcta a
group by a.adr_situs_hse_num_trw,     
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw
having count(*)>1;
/* 0 */

select count(*) from gas_forecast_Comm_TRW_Strcta;
/* 
Feb 2017 - 492476
Mar 2016 - 537235
Apr 2015 - 549144
Apr 2014 - 546352
471,087 */


/* END Create Commercial file */


/* Create Multi Family file */
/* First create a table that determines the txt_county_use that has the greatest number of occurances per
structure */
/* this creates a file that puts the most occurances first within each structure */
create table gas_forecast_cnty_use_MFAM1 as
select a.adr_situs_hse_num_trw,     
a.adr_situs_hse_alpha_trw,
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw,
txt_county_use1_trw,
count(*) as cntyuse_cnt
from gas_forecast_TRW_Master a
where market = 'MFAM'
and adr_situs_str_nme_trw <> ' ' /* these will be added in later and remain full records */
group by a.adr_situs_hse_num_trw,     
a.adr_situs_hse_alpha_trw,
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw,
txt_county_use1_trw
order by a.adr_situs_hse_num_trw,     
a.adr_situs_hse_alpha_trw,
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw,
count(*) desc;

select count(*) from gas_forecast_cnty_use_MFAM1 ;
/* 
Feb 2017 - 120792
Mar 2016 - 120183
Apr 2015 - 117511
Apr 2014 - 132599
May 2013 - 94796
83918 */

/* delete the duplicates, keeping the county use with the highest number of occurances */
delete from gas_forecast_cnty_use_MFAM1 a
where rowid > any(select rowid from gas_forecast_cnty_use_MFAM1 b
where a.adr_situs_hse_num_trw   = b.adr_situs_hse_num_trw  
and a.adr_situs_hse_alpha_trw = b.adr_situs_hse_alpha_trw
and a.adr_situs_str_prfx_trw  = b.adr_situs_str_prfx_trw 
and a.adr_situs_str_nme_trw   = b.adr_situs_str_nme_trw  
and a.adr_situs_str_sufx1_trw = b.adr_situs_str_sufx1_trw
and a.adr_situs_str_sufx2_trw = b.adr_situs_str_sufx2_trw
and a.adr_situs_zip_trw       = b.adr_situs_zip_trw      
);
/* 
Feb 2017 - 68 deleted
Mar 2016 - 116 deleted
Apr 2015 - 117 deleted
Apr 2014 - 5283 deleted
May 2013 - 2494 deleted
24 deleted */

select count(*) from gas_forecast_cnty_use_MFAM1;
/* 
Feb 2017 - 120724
Mar 2016 - 120067
Apr 2015 - 117394
Apr 2014 - 127316
May 2013 - 92302
83894 */

select * from gas_forecast_cnty_use_MFAM1;

create table gas_forecast_MFAM_TRW_Strct tablespace xlarge_data as
select a.adr_situs_hse_num_trw,   
a.adr_situs_hse_alpha_trw,  
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw,
min(case
  when region in('MA','NH') and num_situs_main_dist_trw = -1 then 99999
  when region in('MA','NH') and num_situs_main_dist_trw > -1 then num_situs_main_dist_trw
  when region not in('MA','NH') and num_situs_lp_dist_trw >= 0 and num_situs_lp_dist_trw < num_situs_hp_dist_trw then num_situs_lp_dist_trw
  when region not in('MA','NH') and num_situs_hp_dist_trw >= 0 and num_situs_hp_dist_trw <= num_situs_lp_dist_trw then num_situs_hp_dist_trw
  else 99999
end) as dist_to_main,
min(case
  when cde_situs_on_main_trw = 0 then 0
  else 99999
end) as cde_on_main,
min(a.region                     ) as region                     ,
min(a.gas_cust_found             ) as gas_cust_found             ,
min(a.franchise_zip              ) as franchise_zip              ,
min(a.constrained_zip_commercial ) as constrained_zip_commercial ,
min(a.constrained_zip_residential) as constrained_zip_residential,
min(a.constrained_comments) as constrained_comments,
min(a.constrained_rule) as constrained_rule,
min(a.dcd_zip_code_type          ) as dcd_zip_code_type          ,
min(a.market                     ) as market                     ,
greatest(count(*), sum(nvl(qty_unit_trw,0))) as trwunits,
max(b.txt_county_use1_trw) as txt_county_use1_trw, /* this will be the same for all records so a group by is unnecessary */
max(a.id_apn_trw) as id_apn_trw, 
max(b.cntyuse_cnt) as cntyuse_cnt
from gas_forecast_TRW_Master a
join gas_forecast_cnty_use_MFAM1 b
on  a.adr_situs_hse_num_trw   = b.adr_situs_hse_num_trw  
and a.adr_situs_hse_alpha_trw = b.adr_situs_hse_alpha_trw
and a.adr_situs_str_prfx_trw  = b.adr_situs_str_prfx_trw    
and a.adr_situs_str_nme_trw   = b.adr_situs_str_nme_trw     
and a.adr_situs_str_sufx1_trw = b.adr_situs_str_sufx1_trw   
and a.adr_situs_str_sufx2_trw = b.adr_situs_str_sufx2_trw   
and a.adr_situs_zip_trw       = b.adr_situs_zip_trw          
where a.market = 'MFAM'
and a.adr_situs_str_nme_trw <> ' ' /* these will be added in later and remain full records */
group by a.adr_situs_hse_num_trw,     
a.adr_situs_hse_alpha_trw,
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw;

/* test for dupes - there shouldn't be any */
select a.adr_situs_hse_num_trw,     
a.adr_situs_hse_alpha_trw,
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw
from gas_forecast_MFAM_TRW_Strct a
group by a.adr_situs_hse_num_trw,     
a.adr_situs_hse_alpha_trw,
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw
having count(*)>1;
/* 0 */

select * from gas_forecast_MFAM_TRW_Strct;

/* Create the 6 address piece version of the Multi Family File */
create table gas_forecast_MFAM_TRW_Strcta tablespace xlarge_data as
select a.adr_situs_hse_num_trw,     
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw,
min(dist_to_main) as dist_to_main,
min(cde_on_main) as cde_on_main,
min(a.region                     ) as region                     ,
min(a.gas_cust_found             ) as gas_cust_found             ,
min(a.franchise_zip              ) as franchise_zip              ,
min(a.constrained_zip_commercial ) as constrained_zip_commercial ,
min(a.constrained_zip_residential) as constrained_zip_residential,
min(a.constrained_comments) as constrained_comments,
min(a.constrained_rule) as constrained_rule,
min(a.dcd_zip_code_type          ) as dcd_zip_code_type          ,
min(a.market                     ) as market                     ,
max(trwunits) as trwunits,
max(txt_county_use1_trw) as txt_county_use1_trw, /* this will be the same for all records so a group by is unnecessary */
max(a.id_apn_trw) as id_apn_trw, 
max(cntyuse_cnt) as cntyuse_cnt
from gas_forecast_MFAM_TRW_Strct a
group by a.adr_situs_hse_num_trw,     
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw;

/* test for dupes - there shouldn't be any */
select a.adr_situs_hse_num_trw,     
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw
from gas_forecast_MFAM_TRW_Strcta a
group by a.adr_situs_hse_num_trw,     
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw
having count(*)>1;
/* 0 */

select count(*) from gas_forecast_MFAM_TRW_Strcta;
/* 
Feb 2017 - 119834
Mar 2016 - 119178
Apr 2015 - 116559
Apr 2014 - 125885
91237 */


/* END Create Multi Family file */

/* Create CONDO file */
/* First create a table that determines the txt_county_use that has the greatest number of occurances per
structure */
/* this creates a file that puts the most occurances first within each structure */
create table gas_forecast_cnty_use_CONDO1 as
select a.adr_situs_hse_num_trw,     
a.adr_situs_hse_alpha_trw,
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw,
txt_county_use1_trw,
count(*) as cntyuse_cnt
from gas_forecast_TRW_Master a
where market = 'CONDO'
and adr_situs_str_nme_trw <> ' ' /* these will be added in later and remain full records */
group by a.adr_situs_hse_num_trw,     
a.adr_situs_hse_alpha_trw,
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw,
txt_county_use1_trw
order by a.adr_situs_hse_num_trw,     
a.adr_situs_hse_alpha_trw,
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw,
count(*) desc;

select count(*) from gas_forecast_cnty_use_CONDO1 ;
/* 
Feb 2017 - 212663
Mar 2016 - 190059
Apr 2015 - 191258
Apr 2014 - 169819
*/

/* delete the duplicates, keeping the county use with the highest number of occurances */
delete from gas_forecast_cnty_use_CONDO1 a
where rowid > any(select rowid from gas_forecast_cnty_use_CONDO1 b
where a.adr_situs_hse_num_trw   = b.adr_situs_hse_num_trw  
and a.adr_situs_hse_alpha_trw = b.adr_situs_hse_alpha_trw
and a.adr_situs_str_prfx_trw  = b.adr_situs_str_prfx_trw 
and a.adr_situs_str_nme_trw   = b.adr_situs_str_nme_trw  
and a.adr_situs_str_sufx1_trw = b.adr_situs_str_sufx1_trw
and a.adr_situs_str_sufx2_trw = b.adr_situs_str_sufx2_trw
and a.adr_situs_zip_trw       = b.adr_situs_zip_trw      
);
/* 
Feb 2017 - 17109
Mar 2016 - 6969 deleted
Apr 2015 - 6895 deleted
Apr 2014 - 5587 deleted
May 2013 - 3226 deleted
3,239 deleted */

select count(*) from gas_forecast_cnty_use_CONDO1;
/* 
Feb 2017 - 195554
Mar 2016 - 183090
Apr 2015 - 184363
Apr 2014 - 164232
May 2013 - 153755
148952 */

select * from gas_forecast_cnty_use_CONDO1;

create table gas_forecast_CONDO_TRW_Strct tablespace xlarge_data as
select a.adr_situs_hse_num_trw,     
a.adr_situs_hse_alpha_trw,
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw,
min(case
  when region in('MA','NH') and num_situs_main_dist_trw = -1 then 99999
  when region in('MA','NH') and num_situs_main_dist_trw > -1 then num_situs_main_dist_trw
  when region not in('MA','NH') and num_situs_lp_dist_trw >= 0 and num_situs_lp_dist_trw < num_situs_hp_dist_trw then num_situs_lp_dist_trw
  when region not in('MA','NH') and num_situs_hp_dist_trw >= 0 and num_situs_hp_dist_trw <= num_situs_lp_dist_trw then num_situs_hp_dist_trw
  else 99999
end) as dist_to_main,
min(case
  when cde_situs_on_main_trw = 0 then 0
  else 99999
end) as cde_on_main,
min(a.region                     ) as region                     ,
min(a.gas_cust_found             ) as gas_cust_found             ,
min(a.franchise_zip              ) as franchise_zip              ,
min(a.constrained_zip_commercial ) as constrained_zip_commercial ,
min(a.constrained_zip_residential) as constrained_zip_residential,
min(a.constrained_comments) as constrained_comments,
min(a.constrained_rule) as constrained_rule,
min(a.dcd_zip_code_type          ) as dcd_zip_code_type          ,
min(a.market                     ) as market                     ,
count(*) as trwunits, /* Condo is the only piece that just gets counts - If it is a condo, each unit gets its own record */
max(b.txt_county_use1_trw) as txt_county_use1_trw, /* this will be the same for all records so a group by is unnecessary */
max(a.id_apn_trw) as id_apn_trw, 
max(b.cntyuse_cnt) as cntyuse_cnt
from gas_forecast_TRW_Master a
join gas_forecast_cnty_use_CONDO1 b
on  a.adr_situs_hse_num_trw   = b.adr_situs_hse_num_trw  
and a.adr_situs_hse_alpha_trw = b.adr_situs_hse_alpha_trw
and a.adr_situs_str_prfx_trw  = b.adr_situs_str_prfx_trw    
and a.adr_situs_str_nme_trw   = b.adr_situs_str_nme_trw     
and a.adr_situs_str_sufx1_trw = b.adr_situs_str_sufx1_trw   
and a.adr_situs_str_sufx2_trw = b.adr_situs_str_sufx2_trw   
and a.adr_situs_zip_trw       = b.adr_situs_zip_trw          
where a.market = 'CONDO'
and a.adr_situs_str_nme_trw <> ' ' /* these will be added in later and remain full records */
group by a.adr_situs_hse_num_trw,     
a.adr_situs_hse_alpha_trw,
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw;

/* test for dupes - there shouldn't be any */
select a.adr_situs_hse_num_trw,    
a.adr_situs_hse_alpha_trw, 
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw
from gas_forecast_CONDO_TRW_Strct a
group by a.adr_situs_hse_num_trw,     
a.adr_situs_hse_alpha_trw,
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw
having count(*)>1;
/* 0 */

select * from gas_forecast_CONDO_TRW_Strct;

/* Create the 6 address piece version of the Condo File */
create table gas_forecast_CONDO_TRW_Strcta tablespace xlarge_data as
select a.adr_situs_hse_num_trw,     
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw,
min(dist_to_main) as dist_to_main,
min(cde_on_main) as cde_on_main,
min(a.region                     ) as region                     ,
min(a.gas_cust_found             ) as gas_cust_found             ,
min(a.franchise_zip              ) as franchise_zip              ,
min(a.constrained_zip_commercial ) as constrained_zip_commercial ,
min(a.constrained_zip_residential) as constrained_zip_residential,
min(a.constrained_comments) as constrained_comments,
min(a.constrained_rule) as constrained_rule,
min(a.dcd_zip_code_type          ) as dcd_zip_code_type          ,
min(a.market                     ) as market                     ,
max(trwunits) as trwunits,
max(txt_county_use1_trw) as txt_county_use1_trw, /* this will be the same for all records so a group by is unnecessary */
max(a.id_apn_trw) as id_apn_trw, 
max(cntyuse_cnt) as cntyuse_cnt
from gas_forecast_CONDO_TRW_Strct a
group by a.adr_situs_hse_num_trw,     
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw;

/* test for dupes - there shouldn't be any */
select a.adr_situs_hse_num_trw,     
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw
from gas_forecast_CONDO_TRW_Strcta a
group by a.adr_situs_hse_num_trw,     
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw
having count(*)>1;
/* 0 */

select count(*) from gas_forecast_CONDO_TRW_Strcta;
/* 
Feb 2017 - 192779
Mar 2016 - 180692
Apr 2015 - 181190
Apr 2014 - 161364
151425 */


/* END Create CONDO file */

/* Create UNKNOWN file */
/* First create a table that determines the txt_county_use that has the greatest number of occurances per
structure */
/* this creates a file that puts the most occurances first within each structure */
create table gas_forecast_cnty_use_UNKNOWN1 as
select a.adr_situs_hse_num_trw,   
a.adr_situs_hse_alpha_trw,  
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw,
txt_county_use1_trw,
count(*) as cntyuse_cnt
from gas_forecast_TRW_Master a
where market is null
and adr_situs_str_nme_trw <> ' ' /* these will be added in later and remain full records */
group by a.adr_situs_hse_num_trw,     
a.adr_situs_hse_alpha_trw,
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw,
txt_county_use1_trw
order by a.adr_situs_hse_num_trw,    
a.adr_situs_hse_alpha_trw ,
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw,
count(*) desc;

select count(*) from gas_forecast_cnty_use_UNKNOWN1 ;
/* 
Feb 2017 - 460865
Mar 2016 - 462514
Apr 2015 - 461460
Apr 2014 - 441550
May 2013 - 353779
372562 */

/* delete the duplicates, keeping the county use with the highest number of occurances */
delete from gas_forecast_cnty_use_UNKNOWN1 a
where rowid > any(select rowid from gas_forecast_cnty_use_UNKNOWN1 b
where a.adr_situs_hse_num_trw   = b.adr_situs_hse_num_trw  
and a.adr_situs_hse_alpha_trw = b.adr_situs_hse_alpha_trw
and a.adr_situs_str_prfx_trw  = b.adr_situs_str_prfx_trw 
and a.adr_situs_str_nme_trw   = b.adr_situs_str_nme_trw  
and a.adr_situs_str_sufx1_trw = b.adr_situs_str_sufx1_trw
and a.adr_situs_str_sufx2_trw = b.adr_situs_str_sufx2_trw
and a.adr_situs_zip_trw       = b.adr_situs_zip_trw      
);
/* 
Feb 2017 - 16853 deleted
Mar 2016 - 16853 deleted
Apr 2015 - 16853 deleted
Apr 2014 - 9673 deleted
May 2013 - 8637 deleted
8799 deleted */

select count(*) from gas_forecast_cnty_use_UNKNOWN1;
/* 
Feb 2017 - 444012
Mar 2016 - 445661
Apr 2015 - 444607
Apr 2014 - 431877
May 2013 - 345142
363763 */

select * from gas_forecast_cnty_use_UNKNOWN1;

create table gas_forecast_UNKNOWN_TRW_Strct tablespace xlarge_data as
select a.adr_situs_hse_num_trw,     
a.adr_situs_hse_alpha_trw,
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw,
min(case
  when region in('MA','NH') and num_situs_main_dist_trw = -1 then 99999
  when region in('MA','NH') and num_situs_main_dist_trw > -1 then num_situs_main_dist_trw
  when region not in('MA','NH') and num_situs_lp_dist_trw >= 0 and num_situs_lp_dist_trw < num_situs_hp_dist_trw then num_situs_lp_dist_trw
  when region not in('MA','NH') and num_situs_hp_dist_trw >= 0 and num_situs_hp_dist_trw <= num_situs_lp_dist_trw then num_situs_hp_dist_trw
  else 99999
end) as dist_to_main,
min(case
  when cde_situs_on_main_trw = 0 then 0
  else 99999
end) as cde_on_main,
min(a.region                     ) as region                     ,
min(a.gas_cust_found             ) as gas_cust_found             ,
min(a.franchise_zip              ) as franchise_zip              ,
min(a.constrained_zip_commercial ) as constrained_zip_commercial ,
min(a.constrained_zip_residential) as constrained_zip_residential,
min(a.constrained_comments) as constrained_comments,
min(a.constrained_rule) as constrained_rule,
min(a.dcd_zip_code_type          ) as dcd_zip_code_type          ,
min(a.market                     ) as market                     ,
count(*) as trwunits, /* Condo is the only piece that just gets counts - If it is a condo, each unit gets its own record */
max(b.txt_county_use1_trw) as txt_county_use1_trw, /* this will be the same for all records so a group by is unnecessary */
max(a.id_apn_trw) as id_apn_trw, 
max(b.cntyuse_cnt) as cntyuse_cnt
from gas_forecast_TRW_Master a
join gas_forecast_cnty_use_UNKNOWN1 b
on  a.adr_situs_hse_num_trw   = b.adr_situs_hse_num_trw  
and a.adr_situs_hse_alpha_trw = b.adr_situs_hse_alpha_trw
and a.adr_situs_str_prfx_trw  = b.adr_situs_str_prfx_trw    
and a.adr_situs_str_nme_trw   = b.adr_situs_str_nme_trw     
and a.adr_situs_str_sufx1_trw = b.adr_situs_str_sufx1_trw   
and a.adr_situs_str_sufx2_trw = b.adr_situs_str_sufx2_trw   
and a.adr_situs_zip_trw       = b.adr_situs_zip_trw          
where a.market is null
and a.adr_situs_str_nme_trw <> ' ' /* these will be added in later and remain full records */
group by a.adr_situs_hse_num_trw,  
a.adr_situs_hse_alpha_trw,   
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw;

/* test for dupes - there shouldn't be any */
select a.adr_situs_hse_num_trw,     
a.adr_situs_hse_alpha_trw,
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw
from gas_forecast_UNKNOWN_TRW_Strct a
group by a.adr_situs_hse_num_trw,     
a.adr_situs_hse_alpha_trw,
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw
having count(*)>1;
/* 0 */

select * from gas_forecast_UNKNOWN_TRW_Strct
where region <> 'NH';

/* Create the 6 address piece version of the UNKNOWN File */
create table gas_forecast_UNKNWN_TRW_Strcta tablespace xlarge_data as
select a.adr_situs_hse_num_trw,     
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw,
min(dist_to_main) as dist_to_main,
min(cde_on_main) as cde_on_main,
min(a.region                     ) as region                     ,
min(a.gas_cust_found             ) as gas_cust_found             ,
min(a.franchise_zip              ) as franchise_zip              ,
min(a.constrained_zip_commercial ) as constrained_zip_commercial ,
min(a.constrained_zip_residential) as constrained_zip_residential,
min(a.constrained_comments) as constrained_comments,
min(a.constrained_rule) as constrained_rule,
min(a.dcd_zip_code_type          ) as dcd_zip_code_type          ,
min(a.market                     ) as market                     ,
max(trwunits) as trwunits,
max(txt_county_use1_trw) as txt_county_use1_trw, /* this will be the same for all records so a group by is unnecessary */
max(a.id_apn_trw) as id_apn_trw, 
max(cntyuse_cnt) as cntyuse_cnt
from gas_forecast_UNKNOWN_TRW_Strct a
group by a.adr_situs_hse_num_trw,     
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw;

/* test for dupes - there shouldn't be any */
select a.adr_situs_hse_num_trw,     
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw
from gas_forecast_UNKNWN_TRW_Strcta a
group by a.adr_situs_hse_num_trw,     
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw
having count(*)>1;
/* 0 */

select count(*) from gas_forecast_UNKNWN_TRW_Strcta;
/* 
Feb 2017 - 443293
Mar 2016 - 444921
Apr 2015 - 443890
Apr 2014 - 428948
*/

/* END Create UNKNOWN file */


/* create structure file from ABI with counts of businesses */
create table GAS_FORECAST_abi_structs as
select a.adr_phys_hse_num_abi as Sitehsenumb,
a.adr_phys_hse_alpha_abi as Sitehsealph,
a.adr_phys_str_prfx_abi as Sitestrprfx,
a.adr_phys_str_nme_abi as Sitestrname,
a.adr_phys_str_sufx1_abi as Sitestrsfx1,
a.adr_phys_str_sufx2_abi as Sitestrsfx2,
a.adr_phys_zip_abi as SiteZip5,
count(*) as ABI_Cnt
from mi_edr_prod.edr_dnnlly_std_bsnss_all a
where adr_phys_str_nme_abi <> ' '
group by a.adr_phys_hse_num_abi,
a.adr_phys_hse_alpha_abi,
a.adr_phys_str_prfx_abi,
a.adr_phys_str_nme_abi,
a.adr_phys_str_sufx1_abi,
a.adr_phys_str_sufx2_abi,
a.adr_phys_zip_abi
order by
a.adr_phys_hse_num_abi,
a.adr_phys_hse_alpha_abi,
a.adr_phys_str_prfx_abi,
a.adr_phys_str_nme_abi,
a.adr_phys_str_sufx1_abi,
a.adr_phys_str_sufx2_abi,
a.adr_phys_zip_abi;

select count(*) from GAS_FORECAST_abi_structs;
/* 
Feb 2017 - 484722
Mar 2016 - 494440
Apr 2015 - 503834
Apr 2014 - 499851
494849 */

/* create structure file from donnelley with counts of residences */
create table GAS_FORECAST_Dnnlly_structs as
select 
a.MDS_ADR_HSE_NUM   as Sitehsenumb,
a.mds_adr_hse_alpha as Sitehsealph,
a.MDS_ADR_STR_PRFX  as Sitestrprfx,
a.MDS_ADR_STR_NME   as Sitestrname,
a.MDS_ADR_STR_SUFX1 as Sitestrsfx1,
a.MDS_ADR_STR_SUFX2 as Sitestrsfx2,
a.MDS_ADR_ZIP       as SiteZip5,
count(*) as Dnnlly_Cnt
from mi_edr_prod.edr_dnnlly a
where MDS_ADR_STR_NME <> ' '
group by 
a.MDS_ADR_HSE_NUM  ,
a.mds_adr_hse_alpha,
a.MDS_ADR_STR_PRFX ,
a.MDS_ADR_STR_NME  ,
a.MDS_ADR_STR_SUFX1,
a.MDS_ADR_STR_SUFX2,
a.MDS_ADR_ZIP      
order by
a.MDS_ADR_HSE_NUM  ,
a.mds_adr_hse_alpha,
a.MDS_ADR_STR_PRFX ,
a.MDS_ADR_STR_NME  ,
a.MDS_ADR_STR_SUFX1,
a.MDS_ADR_STR_SUFX2,
a.MDS_ADR_ZIP;

select count(*) from GAS_FORECAST_Dnnlly_structs;
/* 
Feb 2017 - 4935955
Mar 2016 - 4893371
Apr 2015 - 4914458
Apr 2014 - 5177439 
*/

alter table gas_forecast_Resi_TRW_Strct  add(abiunits number(10), dnnllyunits number(10));
alter table gas_forecast_Comm_TRW_Strct  add(abiunits number(10), dnnllyunits number(10));
alter table gas_forecast_MFAM_TRW_Strct  add(abiunits number(10), dnnllyunits number(10));
alter table gas_forecast_CONDO_TRW_Strct add(abiunits number(10), dnnllyunits number(10));
alter table gas_forecast_UNKNOWN_TRW_Strct add(abiunits number(10), dnnllyunits number(10));

alter table gas_forecast_Resi_TRW_Strcta  add(abiunits number(10), dnnllyunits number(10));
alter table gas_forecast_Comm_TRW_Strcta  add(abiunits number(10), dnnllyunits number(10));
alter table gas_forecast_MFAM_TRW_Strcta  add(abiunits number(10), dnnllyunits number(10));
alter table gas_forecast_CONDO_TRW_Strcta add(abiunits number(10), dnnllyunits number(10));
alter table gas_forecast_UNKNWN_TRW_Strcta add(abiunits number(10), dnnllyunits number(10));


/* create structure file based on 6 address pieces from ABI with counts of businesses */
create table GAS_FORECAST_abi_structsa as
select a.adr_phys_hse_num_abi as Sitehsenumb,
a.adr_phys_str_prfx_abi as Sitestrprfx,
a.adr_phys_str_nme_abi as Sitestrname,
a.adr_phys_str_sufx1_abi as Sitestrsfx1,
a.adr_phys_str_sufx2_abi as Sitestrsfx2,
a.adr_phys_zip_abi as SiteZip5,
count(*) as ABI_Cnt
from mi_edr_prod.edr_dnnlly_std_bsnss_all a
where adr_phys_str_nme_abi <> ' '
group by a.adr_phys_hse_num_abi,
a.adr_phys_str_prfx_abi,
a.adr_phys_str_nme_abi,
a.adr_phys_str_sufx1_abi,
a.adr_phys_str_sufx2_abi,
a.adr_phys_zip_abi
order by
a.adr_phys_hse_num_abi,
a.adr_phys_str_prfx_abi,
a.adr_phys_str_nme_abi,
a.adr_phys_str_sufx1_abi,
a.adr_phys_str_sufx2_abi,
a.adr_phys_zip_abi;

select count(*) from GAS_FORECAST_abi_structsa;
/* 
Feb 2017 - 482332
Mar 2016 - 492039
Apr 2015 - 501563
Apr 2014 - 497903
493509 */

/* create structure file from donnelley with counts of residences */
create table GAS_FORECAST_Dnnlly_structsa as
select 
a.MDS_ADR_HSE_NUM   as Sitehsenumb,
a.MDS_ADR_STR_PRFX  as Sitestrprfx,
a.MDS_ADR_STR_NME   as Sitestrname,
a.MDS_ADR_STR_SUFX1 as Sitestrsfx1,
a.MDS_ADR_STR_SUFX2 as Sitestrsfx2,
a.MDS_ADR_ZIP       as SiteZip5,
count(*) as Dnnlly_Cnt
from mi_edr_prod.edr_dnnlly a
where MDS_ADR_STR_NME <> ' '
group by 
a.MDS_ADR_HSE_NUM  ,
a.MDS_ADR_STR_PRFX ,
a.MDS_ADR_STR_NME  ,
a.MDS_ADR_STR_SUFX1,
a.MDS_ADR_STR_SUFX2,
a.MDS_ADR_ZIP      
order by
a.MDS_ADR_HSE_NUM  ,
a.MDS_ADR_STR_PRFX ,
a.MDS_ADR_STR_NME  ,
a.MDS_ADR_STR_SUFX1,
a.MDS_ADR_STR_SUFX2,
a.MDS_ADR_ZIP;

select count(*) from GAS_FORECAST_Dnnlly_structsa;
/* 
Feb 2017 - 4893227
Mar 2016 - 4853308
Apr 2015 - 4873276
Apr 2014 - 5127340
5177688 */


/* set the Donnelley and ABI units to zero */
update gas_forecast_Resi_TRW_Strct  set abiunits = 0, dnnllyunits = 0;
update gas_forecast_Comm_TRW_Strct  set abiunits = 0, dnnllyunits = 0;
update gas_forecast_MFAM_TRW_Strct  set abiunits = 0, dnnllyunits = 0;
update gas_forecast_CONDO_TRW_Strct set abiunits = 0, dnnllyunits = 0;
update gas_forecast_UNKNOWN_TRW_Strct set abiunits = 0, dnnllyunits = 0;

update gas_forecast_Resi_TRW_Strcta  set abiunits = 0, dnnllyunits = 0;
update gas_forecast_Comm_TRW_Strcta  set abiunits = 0, dnnllyunits = 0;
update gas_forecast_MFAM_TRW_Strcta  set abiunits = 0, dnnllyunits = 0;
update gas_forecast_CONDO_TRW_Strcta set abiunits = 0, dnnllyunits = 0;
update gas_forecast_UNKNWN_TRW_Strcta set abiunits = 0, dnnllyunits = 0;


create index idx_GAS_FORECAST_abi on GAS_FORECAST_abi_structs(Sitehsenumb,
Sitehsealph, Sitestrprfx, Sitestrname, Sitestrsfx1, Sitestrsfx2, SiteZip5);

create index idx_GAS_FORECAST_dnnlly on GAS_FORECAST_dnnlly_structs(Sitehsenumb, 
Sitehsealph, Sitestrprfx, Sitestrname, Sitestrsfx1, Sitestrsfx2, SiteZip5);

create index idx_GAS_FORECAST_abia on GAS_FORECAST_abi_structsa(Sitehsenumb,
Sitestrprfx, Sitestrname, Sitestrsfx1, Sitestrsfx2, SiteZip5);

create index idx_GAS_FORECAST_dnnllya on GAS_FORECAST_dnnlly_structsa(Sitehsenumb,
Sitestrprfx, Sitestrname, Sitestrsfx1, Sitestrsfx2, SiteZip5);


/* update the Donnelley and ABI units to the actual counts from Donnelley and ABI 
  based on 7 address piece match */
update gas_forecast_mfam_TRW_Strct a
set a.abiunits = 
(select b.abi_cnt
from GAS_FORECAST_abi_structs b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_hse_alpha_trw = b.sitehsealph
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx   
and a.adr_situs_str_nme_trw   = b.Sitestrname   
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1   
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2   
and a.adr_situs_zip_trw       = b.SiteZip5)
where exists(select *
from GAS_FORECAST_abi_structs b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_hse_alpha_trw = b.sitehsealph
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx   
and a.adr_situs_str_nme_trw   = b.Sitestrname   
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1   
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2   
and a.adr_situs_zip_trw       = b.SiteZip5);

update gas_forecast_mfam_TRW_Strct a
set a.dnnllyunits = 
(select b.dnnlly_cnt
from GAS_FORECAST_Dnnlly_structs b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_hse_alpha_trw = b.sitehsealph
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx
and a.adr_situs_str_nme_trw   = b.Sitestrname
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2
and a.adr_situs_zip_trw       = b.SiteZip5)
where exists(select *
from GAS_FORECAST_Dnnlly_structs b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_hse_alpha_trw = b.sitehsealph
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx   
and a.adr_situs_str_nme_trw   = b.Sitestrname   
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1   
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2   
and a.adr_situs_zip_trw       = b.SiteZip5);


update gas_forecast_Comm_TRW_Strct a
set a.abiunits = 
(select b.abi_cnt
from GAS_FORECAST_abi_structs b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_hse_alpha_trw = b.sitehsealph
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx   
and a.adr_situs_str_nme_trw   = b.Sitestrname   
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1   
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2   
and a.adr_situs_zip_trw       = b.SiteZip5)
where exists(select *
from GAS_FORECAST_abi_structs b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_hse_alpha_trw = b.sitehsealph
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx   
and a.adr_situs_str_nme_trw   = b.Sitestrname   
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1   
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2   
and a.adr_situs_zip_trw       = b.SiteZip5);

update gas_forecast_Comm_TRW_Strct a
set a.dnnllyunits = 
(select b.dnnlly_cnt
from GAS_FORECAST_Dnnlly_structs b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_hse_alpha_trw = b.sitehsealph
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx
and a.adr_situs_str_nme_trw   = b.Sitestrname
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2
and a.adr_situs_zip_trw       = b.SiteZip5)
where exists(select *
from GAS_FORECAST_Dnnlly_structs b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_hse_alpha_trw = b.sitehsealph
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx   
and a.adr_situs_str_nme_trw   = b.Sitestrname   
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1   
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2   
and a.adr_situs_zip_trw       = b.SiteZip5);

update gas_forecast_Condo_TRW_Strct a
set a.abiunits = 
(select b.abi_cnt
from GAS_FORECAST_abi_structs b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_hse_alpha_trw = b.sitehsealph
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx   
and a.adr_situs_str_nme_trw   = b.Sitestrname   
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1   
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2   
and a.adr_situs_zip_trw       = b.SiteZip5)
where exists(select *
from GAS_FORECAST_abi_structs b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_hse_alpha_trw = b.sitehsealph
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx   
and a.adr_situs_str_nme_trw   = b.Sitestrname   
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1   
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2   
and a.adr_situs_zip_trw       = b.SiteZip5);

update gas_forecast_Condo_TRW_Strct a
set a.dnnllyunits = 
(select b.dnnlly_cnt
from GAS_FORECAST_Dnnlly_structs b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_hse_alpha_trw = b.sitehsealph
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx
and a.adr_situs_str_nme_trw   = b.Sitestrname
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2
and a.adr_situs_zip_trw       = b.SiteZip5)
where exists(select *
from GAS_FORECAST_Dnnlly_structs b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_hse_alpha_trw = b.sitehsealph
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx   
and a.adr_situs_str_nme_trw   = b.Sitestrname   
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1   
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2   
and a.adr_situs_zip_trw       = b.SiteZip5);


update gas_forecast_Resi_TRW_Strct a
set a.abiunits = 
(select b.abi_cnt
from GAS_FORECAST_abi_structs b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_hse_alpha_trw = b.sitehsealph
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx   
and a.adr_situs_str_nme_trw   = b.Sitestrname   
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1   
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2   
and a.adr_situs_zip_trw       = b.SiteZip5)
where exists(select *
from GAS_FORECAST_abi_structs b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_hse_alpha_trw = b.sitehsealph
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx   
and a.adr_situs_str_nme_trw   = b.Sitestrname   
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1   
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2   
and a.adr_situs_zip_trw       = b.SiteZip5);

update gas_forecast_Resi_TRW_Strct a
set a.dnnllyunits = 
(select b.dnnlly_cnt
from GAS_FORECAST_Dnnlly_structs b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_hse_alpha_trw = b.sitehsealph
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx
and a.adr_situs_str_nme_trw   = b.Sitestrname
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2
and a.adr_situs_zip_trw       = b.SiteZip5)
where exists(select *
from GAS_FORECAST_Dnnlly_structs b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_hse_alpha_trw = b.sitehsealph
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx   
and a.adr_situs_str_nme_trw   = b.Sitestrname   
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1   
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2   
and a.adr_situs_zip_trw       = b.SiteZip5);

update gas_forecast_UNKNOWN_TRW_Strct a
set a.abiunits = 
(select b.abi_cnt
from GAS_FORECAST_abi_structs b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_hse_alpha_trw = b.sitehsealph
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx   
and a.adr_situs_str_nme_trw   = b.Sitestrname   
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1   
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2   
and a.adr_situs_zip_trw       = b.SiteZip5)
where exists(select *
from GAS_FORECAST_abi_structs b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_hse_alpha_trw = b.sitehsealph
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx   
and a.adr_situs_str_nme_trw   = b.Sitestrname   
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1   
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2   
and a.adr_situs_zip_trw       = b.SiteZip5);

update gas_forecast_UNKNOWN_TRW_Strct a
set a.dnnllyunits = 
(select b.dnnlly_cnt
from GAS_FORECAST_Dnnlly_structs b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_hse_alpha_trw = b.sitehsealph
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx
and a.adr_situs_str_nme_trw   = b.Sitestrname
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2
and a.adr_situs_zip_trw       = b.SiteZip5)
where exists(select *
from GAS_FORECAST_Dnnlly_structs b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_hse_alpha_trw = b.sitehsealph
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx   
and a.adr_situs_str_nme_trw   = b.Sitestrname   
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1   
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2   
and a.adr_situs_zip_trw       = b.SiteZip5);



/* update the Donnelley and ABI units to the actual counts from Donnelley and ABI 
  based on 6 address piece match */
update gas_forecast_mfam_TRW_Strct a
set a.abiunits = 
(select b.abi_cnt
from GAS_FORECAST_abi_structsa b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx   
and a.adr_situs_str_nme_trw   = b.Sitestrname   
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1   
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2   
and a.adr_situs_zip_trw       = b.SiteZip5)
where a.abiunits = 0
and exists(select *
from GAS_FORECAST_abi_structsa b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx   
and a.adr_situs_str_nme_trw   = b.Sitestrname   
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1   
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2   
and a.adr_situs_zip_trw       = b.SiteZip5);

update gas_forecast_mfam_TRW_Strct a
set a.dnnllyunits = 
(select b.dnnlly_cnt
from GAS_FORECAST_Dnnlly_structsa b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx
and a.adr_situs_str_nme_trw   = b.Sitestrname
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2
and a.adr_situs_zip_trw       = b.SiteZip5)
where a.dnnllyunits = 0
and exists(select *
from GAS_FORECAST_Dnnlly_structsa b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx   
and a.adr_situs_str_nme_trw   = b.Sitestrname   
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1   
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2   
and a.adr_situs_zip_trw       = b.SiteZip5);


update gas_forecast_Comm_TRW_Strct a
set a.abiunits = 
(select b.abi_cnt
from GAS_FORECAST_abi_structsa b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx   
and a.adr_situs_str_nme_trw   = b.Sitestrname   
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1   
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2   
and a.adr_situs_zip_trw       = b.SiteZip5)
where a.abiunits = 0
and exists(select *
from GAS_FORECAST_abi_structsa b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx   
and a.adr_situs_str_nme_trw   = b.Sitestrname   
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1   
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2   
and a.adr_situs_zip_trw       = b.SiteZip5);

update gas_forecast_Comm_TRW_Strct a
set a.dnnllyunits = 
(select b.dnnlly_cnt
from GAS_FORECAST_Dnnlly_structsa b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx
and a.adr_situs_str_nme_trw   = b.Sitestrname
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2
and a.adr_situs_zip_trw       = b.SiteZip5)
where a.dnnllyunits = 0
and exists(select *
from GAS_FORECAST_Dnnlly_structsa b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx   
and a.adr_situs_str_nme_trw   = b.Sitestrname   
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1   
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2   
and a.adr_situs_zip_trw       = b.SiteZip5);

update gas_forecast_Condo_TRW_Strct a
set a.abiunits = 
(select b.abi_cnt
from GAS_FORECAST_abi_structsa b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx   
and a.adr_situs_str_nme_trw   = b.Sitestrname   
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1   
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2   
and a.adr_situs_zip_trw       = b.SiteZip5)
where a.abiunits = 0
and exists(select *
from GAS_FORECAST_abi_structsa b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx   
and a.adr_situs_str_nme_trw   = b.Sitestrname   
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1   
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2   
and a.adr_situs_zip_trw       = b.SiteZip5);

update gas_forecast_Condo_TRW_Strct a
set a.dnnllyunits = 
(select b.dnnlly_cnt
from GAS_FORECAST_Dnnlly_structsa b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx
and a.adr_situs_str_nme_trw   = b.Sitestrname
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2
and a.adr_situs_zip_trw       = b.SiteZip5)
where a.dnnllyunits = 0
and exists(select *
from GAS_FORECAST_Dnnlly_structsa b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx   
and a.adr_situs_str_nme_trw   = b.Sitestrname   
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1   
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2   
and a.adr_situs_zip_trw       = b.SiteZip5);


update gas_forecast_Resi_TRW_Strct a
set a.abiunits = 
(select b.abi_cnt
from GAS_FORECAST_abi_structsa b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx   
and a.adr_situs_str_nme_trw   = b.Sitestrname   
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1   
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2   
and a.adr_situs_zip_trw       = b.SiteZip5)
where a.abiunits = 0
and exists(select *
from GAS_FORECAST_abi_structsa b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx   
and a.adr_situs_str_nme_trw   = b.Sitestrname   
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1   
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2   
and a.adr_situs_zip_trw       = b.SiteZip5);

update gas_forecast_Resi_TRW_Strct a
set a.dnnllyunits = 
(select b.dnnlly_cnt
from GAS_FORECAST_Dnnlly_structsa b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx
and a.adr_situs_str_nme_trw   = b.Sitestrname
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2
and a.adr_situs_zip_trw       = b.SiteZip5)
where a.dnnllyunits = 0
and exists(select *
from GAS_FORECAST_Dnnlly_structsa b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx   
and a.adr_situs_str_nme_trw   = b.Sitestrname   
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1   
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2   
and a.adr_situs_zip_trw       = b.SiteZip5);

update gas_forecast_UNKNOWN_TRW_Strct a
set a.abiunits = 
(select b.abi_cnt
from GAS_FORECAST_abi_structsa b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx   
and a.adr_situs_str_nme_trw   = b.Sitestrname   
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1   
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2   
and a.adr_situs_zip_trw       = b.SiteZip5)
where a.abiunits = 0
and exists(select *
from GAS_FORECAST_abi_structsa b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx   
and a.adr_situs_str_nme_trw   = b.Sitestrname   
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1   
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2   
and a.adr_situs_zip_trw       = b.SiteZip5);

update gas_forecast_UNKNOWN_TRW_Strct a
set a.dnnllyunits = 
(select b.dnnlly_cnt
from GAS_FORECAST_Dnnlly_structsa b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx
and a.adr_situs_str_nme_trw   = b.Sitestrname
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2
and a.adr_situs_zip_trw       = b.SiteZip5)
where a.dnnllyunits = 0
and exists(select *
from GAS_FORECAST_Dnnlly_structsa b
where a.adr_situs_hse_num_trw = b.Sitehsenumb
and a.adr_situs_str_prfx_trw  = b.Sitestrprfx   
and a.adr_situs_str_nme_trw   = b.Sitestrname   
and a.adr_situs_str_sufx1_trw = b.Sitestrsfx1   
and a.adr_situs_str_sufx2_trw = b.Sitestrsfx2   
and a.adr_situs_zip_trw       = b.SiteZip5);



select * from gas_forecast_Resi_TRW_Strct  ;
select * from gas_forecast_Comm_TRW_Strct  ;
select * from gas_forecast_MFAM_TRW_Strct  ;
select * from gas_forecast_CONDO_TRW_Strct ;
select * from gas_forecast_UNKNOWN_TRW_Strct ;

/* 
select * from gas_forecast_Resi_TRW_Strcta  ;
select * from gas_forecast_Comm_TRW_Strcta  ;
select * from gas_forecast_MFAM_TRW_Strcta  ;
select * from gas_forecast_CONDO_TRW_Strcta ;
select * from gas_forecast_UNKNWN_TRW_Strcta ;
*/


/* update the multifamily file based on unit counts and county use */
update gas_forecast_MFAM_TRW_Strct a
set market = 
(case
       when region in('MA', 'RI') then 'MFAM' /* If the countyuse in MA, RI says multi fam keep it multi fam */
       when region = 'NYC' and a.txt_county_use1_trw in('C1', 'C7') /* 6 + apartments */
            or substr(a.txt_county_use1_trw,1,1) = 'D' /* elevator apartments */ then 'MFAM'
       when region = 'NYC' 
            and not(a.txt_county_use1_trw in('C1', 'C7') or substr(a.txt_county_use1_trw,1,1) = 'D')
            and greatest(nvl(trwunits,0), nvl(dnnllyunits,0)) >5 then 'MFAM'
       when region = 'NYC' 
            and not(a.txt_county_use1_trw in('C1', 'C7') or substr(a.txt_county_use1_trw,1,1) = 'D')
            and greatest(nvl(trwunits,0), nvl(dnnllyunits,0)) <=5 then 'RESID'
       when region = 'LI' and greatest(nvl(trwunits,0), nvl(dnnllyunits,0)) >5 then 'MFAM'
       when region = 'LI' and greatest(nvl(trwunits,0), nvl(dnnllyunits,0)) <=5 then 'RESID'
       when region = 'UNY' and greatest(nvl(trwunits,0), nvl(dnnllyunits,0)) >3 then 'MFAM'
       when region = 'UNY' and greatest(nvl(trwunits,0), nvl(dnnllyunits,0)) <=3 then 'RESID'
       else 'UNKNOWN'
end);
commit;


select market, count(*) 
from  gas_forecast_MFAM_TRW_Strct a
group by market;
/* 
Feb 2017:
MARKET	COUNT(*)
RESID	29824
MFAM	90900

Mar 2016:
MARKET	COUNT(*)
RESID	30034
MFAM	90033

Apr 2015:
MARKET	COUNT(*)
RESID	28067
MFAM	89327

Apr 2014:
MARKET	COUNT(*)
RESID	35471
MFAM	91845
*/

/* update the multifamily file based on unit counts and county use */
update gas_forecast_MFAM_TRW_Strcta a
set market = 
(case
       when region in('MA', 'RI') then 'MFAM' /* If the countyuse in MA, RI says multi fam keep it multi fam */
       when region = 'NYC' and a.txt_county_use1_trw in('C1', 'C7') /* 6 + apartments */
            or substr(a.txt_county_use1_trw,1,1) = 'D' /* elevator apartments */ then 'MFAM'
       when region = 'NYC' 
            and not(a.txt_county_use1_trw in('C1', 'C7') or substr(a.txt_county_use1_trw,1,1) = 'D')
            and greatest(nvl(trwunits,0), nvl(dnnllyunits,0)) >5 then 'MFAM'
       when region = 'NYC' 
            and not(a.txt_county_use1_trw in('C1', 'C7') or substr(a.txt_county_use1_trw,1,1) = 'D')
            and greatest(nvl(trwunits,0), nvl(dnnllyunits,0)) <=5 then 'RESID'
       when region = 'LI' and greatest(nvl(trwunits,0), nvl(dnnllyunits,0)) >5 then 'MFAM'
       when region = 'LI' and greatest(nvl(trwunits,0), nvl(dnnllyunits,0)) <=5 then 'RESID'
       when region = 'UNY' and greatest(nvl(trwunits,0), nvl(dnnllyunits,0)) >3 then 'MFAM'
       when region = 'UNY' and greatest(nvl(trwunits,0), nvl(dnnllyunits,0)) <=3 then 'RESID'
       else 'UNKNOWN'
end);
commit;

select market, count(*) 
from  gas_forecast_MFAM_TRW_Strcta a
group by market;
/*
Feb 2017:
MARKET	COUNT(*)
RESID	29845
MFAM	89989

Mar 2016:
MARKET	COUNT(*)
RESID	30077
MFAM	89101

Apr 2015:
MARKET	COUNT(*)
RESID	28072
MFAM	88487

Apr 2014:
MARKET	COUNT(*)
RESID	35504
MFAM	90381
*/


/*
take the highest of the trw and the donnelley counts for resi vs multi fam

take the highest of the trw and the abi counts for the commercial counts
*/
/* Create final TRW structure file for appending all structure data */
/* Start with the multi family file */
create table gas_forecast_TRW_Strct_final as
select * from gas_forecast_MFAM_TRW_Strct;

select * from gas_forecast_TRW_Strct_final;

/* insert from the condo file, any elevator condos.  Anything with an elevator should be > 5 family */
update gas_forecast_CONDO_TRW_Strct a
set market = 'MFAM'
where region = 'NYC' and a.txt_county_use1_trw = 'R4' /* elevator condo */
; /* 
Feb 2017 - 3136 
Mar 2016 - 3046 updated
Apr 2015 - 2998 updated
Apr 2014 - 2901 updated
May 2013 - 1309 updated
1301 updated */

insert into gas_forecast_TRW_Strct_final
select a.* from gas_forecast_CONDO_TRW_Strct a
where not exists(select * from gas_forecast_TRW_Strct_final b
where a.adr_situs_hse_num_trw   = b.adr_situs_hse_num_trw  
and a.adr_situs_hse_alpha_trw = b.adr_situs_hse_alpha_trw
and a.adr_situs_str_prfx_trw  = b.adr_situs_str_prfx_trw 
and a.adr_situs_str_nme_trw   = b.adr_situs_str_nme_trw  
and a.adr_situs_str_sufx1_trw = b.adr_situs_str_sufx1_trw
and a.adr_situs_str_sufx2_trw = b.adr_situs_str_sufx2_trw
and a.adr_situs_zip_trw       = b.adr_situs_zip_trw      
)
and a.market = 'MFAM'; 
/*
Feb 2017 - 3050
Mar 2016 - 2994 inserted
Apr 2015 - 2934 inserted
Apr 2014 - 2659 inserted
*/


/* Compare the Condo and the resi files.  Match the 2 files, and add the TRW units together to see if they 
should be categorized as multi family adding the trwunits from condo to resi. */
/* Insert the overlaps into the final file with the new market designations and summed trwunits */
insert into gas_forecast_TRW_Strct_final
select
a.adr_situs_hse_num_trw, 
a.adr_situs_hse_alpha_trw,
a.adr_situs_str_prfx_trw, 
a.adr_situs_str_nme_trw, 
a.adr_situs_str_sufx1_trw, 
a.adr_situs_str_sufx2_trw, 
a.adr_situs_zip_trw, 
a.dist_to_main, 
a.cde_on_main, 
a.region, 
a.gas_cust_found, 
a.franchise_zip, 
a.constrained_zip_commercial, 
a.constrained_zip_residential, 
a.constrained_comments,
a.constrained_rule,
a.dcd_zip_code_type, 
(case
       when a.region = 'UNY' and greatest(nvl(a.trwunits,0)+nvl(b.trwunits,0), nvl(a.dnnllyunits,0)) >3 then 'MFAM'
       when a.region = 'UNY' and greatest(nvl(a.trwunits,0)+nvl(b.trwunits,0), nvl(a.dnnllyunits,0)) <=3 then 'RESID'
       when a.region = 'NYC' and a.txt_county_use1_trw = 'R4' /* elevator condo */ then 'MFAM'
       when a.region <> 'UNY' and greatest(nvl(a.trwunits,0)+nvl(b.trwunits,0), nvl(a.dnnllyunits,0)) >5 then 'MFAM'
       when a.region <> 'UNY' and greatest(nvl(a.trwunits,0)+nvl(b.trwunits,0), nvl(a.dnnllyunits,0)) <=5 then 'RESID'
       else 'UNKNOWN'
end) as market,
nvl(a.trwunits,0)+nvl(b.trwunits,0) as trwunits, 
b.txt_county_use1_trw, /* take the resi county use code */
b.id_apn_trw,
b.cntyuse_cnt, /* take the resi county use count */
a.abiunits, /* this will be the same # in the resi file */
a.dnnllyunits /* this will be the same # in the resi file */
from gas_forecast_CONDO_TRW_Strct a
join gas_forecast_RESI_TRW_Strct b
on  a.adr_situs_hse_num_trw   = b.adr_situs_hse_num_trw  
and a.adr_situs_hse_alpha_trw = b.adr_situs_hse_alpha_trw
and a.adr_situs_str_prfx_trw  = b.adr_situs_str_prfx_trw 
and a.adr_situs_str_nme_trw   = b.adr_situs_str_nme_trw  
and a.adr_situs_str_sufx1_trw = b.adr_situs_str_sufx1_trw
and a.adr_situs_str_sufx2_trw = b.adr_situs_str_sufx2_trw
and a.adr_situs_zip_trw       = b.adr_situs_zip_trw 
where not exists(select * from gas_forecast_TRW_Strct_final f
where a.adr_situs_hse_num_trw   = f.adr_situs_hse_num_trw  
and a.adr_situs_hse_alpha_trw = f.adr_situs_hse_alpha_trw
and a.adr_situs_str_prfx_trw  = f.adr_situs_str_prfx_trw 
and a.adr_situs_str_nme_trw   = f.adr_situs_str_nme_trw  
and a.adr_situs_str_sufx1_trw = f.adr_situs_str_sufx1_trw
and a.adr_situs_str_sufx2_trw = f.adr_situs_str_sufx2_trw
and a.adr_situs_zip_trw       = f.adr_situs_zip_trw      
); 
/* 
Feb 2017 - 2042
Mar 2016 - 1704 inserted
Apr 2015 - 1564 inserted
Apr 2014 - 1168 inserted
*/


/* insert the remaining CONDO structures designating them as resi or multi fam */
insert into gas_forecast_TRW_Strct_final
select 
a.adr_situs_hse_num_trw, 
a.adr_situs_hse_alpha_trw,
a.adr_situs_str_prfx_trw, 
a.adr_situs_str_nme_trw, 
a.adr_situs_str_sufx1_trw, 
a.adr_situs_str_sufx2_trw, 
a.adr_situs_zip_trw, 
a.dist_to_main, 
a.cde_on_main, 
a.region, 
a.gas_cust_found, 
a.franchise_zip, 
a.constrained_zip_commercial, 
a.constrained_zip_residential, 
a.constrained_comments,
a.constrained_rule,
a.dcd_zip_code_type, 
(case
       when a.region = 'UNY' and greatest(nvl(a.trwunits,0), nvl(a.dnnllyunits,0)) >3 then 'MFAM'
       when a.region = 'UNY' and greatest(nvl(a.trwunits,0), nvl(a.dnnllyunits,0)) <=3 then 'RESID'
       when a.region = 'NYC' and a.txt_county_use1_trw = 'R4' /* elevator condo */ then 'MFAM'
       when a.region <> 'UNY' and greatest(nvl(a.trwunits,0), nvl(a.dnnllyunits,0)) >5 then 'MFAM'
       when a.region <> 'UNY' and greatest(nvl(a.trwunits,0), nvl(a.dnnllyunits,0)) <=5 then 'RESID'
       else 'UNKNOWN'
end) as market,
a.trwunits, 
a.txt_county_use1_trw, 
a.id_apn_trw,
a.cntyuse_cnt, 
a.abiunits, 
a.dnnllyunits 
from gas_forecast_CONDO_TRW_Strct a
where not exists(select * from gas_forecast_TRW_Strct_final f
where a.adr_situs_hse_num_trw   = f.adr_situs_hse_num_trw  
and a.adr_situs_hse_alpha_trw = f.adr_situs_hse_alpha_trw
and a.adr_situs_str_prfx_trw  = f.adr_situs_str_prfx_trw 
and a.adr_situs_str_nme_trw   = f.adr_situs_str_nme_trw  
and a.adr_situs_str_sufx1_trw = f.adr_situs_str_sufx1_trw
and a.adr_situs_str_sufx2_trw = f.adr_situs_str_sufx2_trw
and a.adr_situs_zip_trw       = f.adr_situs_zip_trw      
); 
/* 
Feb 2017 184,191
Mar 2016 172,336 inserted
Apr 2015 173,879 inserted
Apr 2014 159,625 inserted
May 2013 151,047 inserted
Dec 2012 148,584 inserted */

/* insert the remaining RESI structures designating them as resi or multi fam */
insert into gas_forecast_TRW_Strct_final
select 
a.adr_situs_hse_num_trw, 
a.adr_situs_hse_alpha_trw,
a.adr_situs_str_prfx_trw, 
a.adr_situs_str_nme_trw, 
a.adr_situs_str_sufx1_trw, 
a.adr_situs_str_sufx2_trw, 
a.adr_situs_zip_trw, 
a.dist_to_main, 
a.cde_on_main, 
a.region, 
a.gas_cust_found, 
a.franchise_zip, 
a.constrained_zip_commercial, 
a.constrained_zip_residential, 
a.constrained_comments,
a.constrained_rule,
a.dcd_zip_code_type, 
(case
       when a.region = 'UNY' and greatest(nvl(a.trwunits,0), nvl(a.dnnllyunits,0)) >3 then 'MFAM'
       when a.region = 'UNY' and greatest(nvl(a.trwunits,0), nvl(a.dnnllyunits,0)) <=3 then 'RESID'
       when a.region <> 'UNY' and greatest(nvl(a.trwunits,0), nvl(a.dnnllyunits,0)) >5 then 'MFAM'
       when a.region <> 'UNY' and greatest(nvl(a.trwunits,0), nvl(a.dnnllyunits,0)) <=5 then 'RESID'
       else 'UNKNOWN'
end) as market,
a.trwunits, 
a.txt_county_use1_trw, 
a.id_apn_trw,
a.cntyuse_cnt, 
a.abiunits, 
a.dnnllyunits 
from gas_forecast_RESI_TRW_Strct a
where not exists(select * from gas_forecast_TRW_Strct_final f
where a.adr_situs_hse_num_trw   = f.adr_situs_hse_num_trw  
and a.adr_situs_hse_alpha_trw = f.adr_situs_hse_alpha_trw
and a.adr_situs_str_prfx_trw  = f.adr_situs_str_prfx_trw 
and a.adr_situs_str_nme_trw   = f.adr_situs_str_nme_trw  
and a.adr_situs_str_sufx1_trw = f.adr_situs_str_sufx1_trw
and a.adr_situs_str_sufx2_trw = f.adr_situs_str_sufx2_trw
and a.adr_situs_zip_trw       = f.adr_situs_zip_trw      
); 
/* 
Feb 2017 - 6,000,786
Mar 2016 - 5,981,641 inserted
Apr 2015 - 5,955,032 inserted
Apr 2014 - 5,951,632 inserted
/

/* Update the multi family records in the final file with a combination of multi plus resi */
update gas_forecast_TRW_Strct_final f
set (market, trwunits) = 
(select
(case
       when a.region = 'UNY' and greatest(nvl(a.trwunits,0)+nvl(b.trwunits,0), nvl(a.dnnllyunits,0)) >3 then 'MFAM'
       when a.region = 'UNY' and greatest(nvl(a.trwunits,0)+nvl(b.trwunits,0), nvl(a.dnnllyunits,0)) <=3 then 'RESID'
       when a.region = 'NYC' and a.txt_county_use1_trw = 'R4' /* elevator condo */ then 'MFAM'
       when a.region <> 'UNY' and greatest(nvl(a.trwunits,0)+nvl(b.trwunits,0), nvl(a.dnnllyunits,0)) >5 then 'MFAM'
       when a.region <> 'UNY' and greatest(nvl(a.trwunits,0)+nvl(b.trwunits,0), nvl(a.dnnllyunits,0)) <=5 then 'RESID'
       else 'UNKNOWN'
end) as market,
nvl(a.trwunits,0)+nvl(b.trwunits,0) as trwunits
from gas_forecast_mfam_TRW_Strct a
join gas_forecast_RESI_TRW_Strct b
on  a.adr_situs_hse_num_trw   = b.adr_situs_hse_num_trw  
and a.adr_situs_hse_alpha_trw = b.adr_situs_hse_alpha_trw
and a.adr_situs_str_prfx_trw  = b.adr_situs_str_prfx_trw 
and a.adr_situs_str_nme_trw   = b.adr_situs_str_nme_trw  
and a.adr_situs_str_sufx1_trw = b.adr_situs_str_sufx1_trw
and a.adr_situs_str_sufx2_trw = b.adr_situs_str_sufx2_trw
and a.adr_situs_zip_trw       = b.adr_situs_zip_trw 
where a.adr_situs_hse_num_trw = f.adr_situs_hse_num_trw  
and a.adr_situs_hse_alpha_trw = f.adr_situs_hse_alpha_trw
and a.adr_situs_str_prfx_trw  = f.adr_situs_str_prfx_trw 
and a.adr_situs_str_nme_trw   = f.adr_situs_str_nme_trw  
and a.adr_situs_str_sufx1_trw = f.adr_situs_str_sufx1_trw
and a.adr_situs_str_sufx2_trw = f.adr_situs_str_sufx2_trw
and a.adr_situs_zip_trw       = f.adr_situs_zip_trw )
where exists(select * from gas_forecast_mfam_TRW_Strct a
join gas_forecast_RESI_TRW_Strct b
on  a.adr_situs_hse_num_trw   = b.adr_situs_hse_num_trw  
and a.adr_situs_hse_alpha_trw = b.adr_situs_hse_alpha_trw
and a.adr_situs_str_prfx_trw  = b.adr_situs_str_prfx_trw 
and a.adr_situs_str_nme_trw   = b.adr_situs_str_nme_trw  
and a.adr_situs_str_sufx1_trw = b.adr_situs_str_sufx1_trw
and a.adr_situs_str_sufx2_trw = b.adr_situs_str_sufx2_trw
and a.adr_situs_zip_trw       = b.adr_situs_zip_trw 
where a.adr_situs_hse_num_trw = f.adr_situs_hse_num_trw  
and a.adr_situs_hse_alpha_trw = f.adr_situs_hse_alpha_trw
and a.adr_situs_str_prfx_trw  = f.adr_situs_str_prfx_trw 
and a.adr_situs_str_nme_trw   = f.adr_situs_str_nme_trw  
and a.adr_situs_str_sufx1_trw = f.adr_situs_str_sufx1_trw
and a.adr_situs_str_sufx2_trw = f.adr_situs_str_sufx2_trw
and a.adr_situs_zip_trw       = f.adr_situs_zip_trw )
; 
/* approx 40 min to run this
Feb 2017 - 762 updated
Mar 2016 - 888 updated
Apr 2015 - 958 updated
Apr 2014 - 1206 updated
*/



select count(*) from gas_forecast_TRW_Strct_final;
/* 
Feb 2017 - 6310793
Mar 2016 - 6278742
6,250,803 */

/* insert the UNKNOWN structures designating them as COML, resi, or multi fam */
insert into gas_forecast_TRW_Strct_final
select 
a.adr_situs_hse_num_trw, 
a.adr_situs_hse_alpha_trw,
a.adr_situs_str_prfx_trw, 
a.adr_situs_str_nme_trw, 
a.adr_situs_str_sufx1_trw, 
a.adr_situs_str_sufx2_trw, 
a.adr_situs_zip_trw, 
a.dist_to_main, 
a.cde_on_main, 
a.region, 
a.gas_cust_found, 
a.franchise_zip, 
a.constrained_zip_commercial, 
a.constrained_zip_residential, 
a.constrained_comments,
a.constrained_rule,
a.dcd_zip_code_type, 
(case
       when abiunits >= a.dnnllyunits then 'COML'
       when a.region = 'UNY' and nvl(abiunits,0) = 0 and greatest(nvl(a.trwunits,0), nvl(a.dnnllyunits,0)) >3 then 'MFAM'
       when a.region = 'UNY' and nvl(abiunits,0) = 0 and greatest(nvl(a.trwunits,0), nvl(a.dnnllyunits,0)) <=3 then 'RESID'
       when a.region = 'UNY' and nvl(abiunits,0) > 0 and nvl(abiunits,0) < nvl(a.dnnllyunits,0) and greatest(nvl(a.trwunits,0), nvl(a.dnnllyunits,0)) <=3 then 'RESID'
       when a.region = 'UNY' and nvl(abiunits,0) > 0 and nvl(abiunits,0) < nvl(a.dnnllyunits,0) and greatest(nvl(a.trwunits,0), nvl(a.dnnllyunits,0)) >3 then 'MFAM'
       when a.region <> 'UNY' and nvl(abiunits,0) = 0 and greatest(nvl(a.trwunits,0), nvl(a.dnnllyunits,0)) >5 then 'MFAM'
       when a.region <> 'UNY' and nvl(abiunits,0) = 0 and greatest(nvl(a.trwunits,0), nvl(a.dnnllyunits,0)) <=5 then 'RESID'
       when a.region <> 'UNY' and nvl(abiunits,0) > 0 and nvl(abiunits,0) < nvl(a.dnnllyunits,0) and greatest(nvl(a.trwunits,0), nvl(a.dnnllyunits,0)) <=5 then 'RESID'
       when a.region <> 'UNY' and nvl(abiunits,0) > 0 and nvl(abiunits,0) < nvl(a.dnnllyunits,0) and greatest(nvl(a.trwunits,0), nvl(a.dnnllyunits,0)) >5 then 'MFAM'
       else 'UNKNOWN'
end) as market,
a.trwunits, 
a.txt_county_use1_trw, 
a.id_apn_trw,
a.cntyuse_cnt, 
a.abiunits, 
a.dnnllyunits 
from gas_forecast_UNKNOWN_TRW_Strct a
where not exists(select * from gas_forecast_TRW_Strct_final f
where a.adr_situs_hse_num_trw   = f.adr_situs_hse_num_trw  
and a.adr_situs_hse_alpha_trw = f.adr_situs_hse_alpha_trw
and a.adr_situs_str_prfx_trw  = f.adr_situs_str_prfx_trw 
and a.adr_situs_str_nme_trw   = f.adr_situs_str_nme_trw  
and a.adr_situs_str_sufx1_trw = f.adr_situs_str_sufx1_trw
and a.adr_situs_str_sufx2_trw = f.adr_situs_str_sufx2_trw
and a.adr_situs_zip_trw       = f.adr_situs_zip_trw      
); 
/* 
Feb 2017 - 444,011
Mar 2016 - 445,589 inserted
Apr 2015 - 444,478 inserted
Apr 2014 - 431,722 inserted
May 2013 - 345,086 inserted
363,621 inserted */




/* Insert the commercial records into the final file - eliminating any commercial record that overlaps
a residential or Multi Family record */
insert into gas_forecast_TRW_Strct_final
select 
a.adr_situs_hse_num_trw, 
a.adr_situs_hse_alpha_trw,
a.adr_situs_str_prfx_trw, 
a.adr_situs_str_nme_trw, 
a.adr_situs_str_sufx1_trw, 
a.adr_situs_str_sufx2_trw, 
a.adr_situs_zip_trw, 
a.dist_to_main, 
a.cde_on_main, 
a.region, 
a.gas_cust_found, 
a.franchise_zip, 
a.constrained_zip_commercial, 
a.constrained_zip_residential, 
a.constrained_comments,
a.constrained_rule,
a.dcd_zip_code_type, 
a.market,
a.trwunits, 
a.txt_county_use1_trw, 
a.id_apn_trw,
a.cntyuse_cnt, 
a.abiunits, 
a.dnnllyunits 
from gas_forecast_COMM_TRW_Strct a
where not exists(select * from gas_forecast_TRW_Strct_final f
where a.adr_situs_hse_num_trw   = f.adr_situs_hse_num_trw  
and a.adr_situs_hse_alpha_trw = f.adr_situs_hse_alpha_trw
and a.adr_situs_str_prfx_trw  = f.adr_situs_str_prfx_trw 
and a.adr_situs_str_nme_trw   = f.adr_situs_str_nme_trw  
and a.adr_situs_str_sufx1_trw = f.adr_situs_str_sufx1_trw
and a.adr_situs_str_sufx2_trw = f.adr_situs_str_sufx2_trw
and a.adr_situs_zip_trw       = f.adr_situs_zip_trw      
); 
/* 
Feb 2017 472,634
Mar 2016 517,308 inserted
Apr 2015 517,545 inserted
Apr 2014 518,300 inserted
May 2013 445,050 inserted
434,396 inserted  ? was original comm count - approx 10K comm removed */


select * from gas_forecast_TRW_Strct_final
where adr_situs_str_nme_trw = ' ';
/* 0 */


select market, count(*)
from gas_forecast_TRW_Master a
where a.adr_situs_str_nme_trw = ' '
group by market;

/* Add some fields in that will be updated later */
alter table gas_forecast_TRW_Strct_final
add(numunits number(10), 
trw_sqrft number(10),
ADR_SITUS_CITY_TRW	VARCHAR2(25), 
ADR_SITUS_STATE_TRW	VARCHAR2(2), 
CDE_SITUS_CODE1_SCORE_TRW	CHAR(1));


/* Add back the records with blank street names keeping them whole.  I did not want to group by these 
records because it would give false multi family counts */
insert into gas_forecast_TRW_Strct_final
select a.adr_situs_hse_num_trw,     
a.adr_situs_hse_alpha_trw,
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw,
case
  when region in('MA','NH') and num_situs_main_dist_trw = -1 then 99999
  when region in('MA','NH') and num_situs_main_dist_trw > -1 then num_situs_main_dist_trw
  when region not in('MA','NH') and num_situs_lp_dist_trw >= 0 and num_situs_lp_dist_trw < num_situs_hp_dist_trw then num_situs_lp_dist_trw
  when region not in('MA','NH') and num_situs_hp_dist_trw >= 0 and num_situs_hp_dist_trw <= num_situs_lp_dist_trw then num_situs_hp_dist_trw
  else 99999
end as dist_to_main,
case
  when cde_situs_on_main_trw = 0 then 0
  else 99999
end as cde_on_main,
a.region                     ,
a.gas_cust_found             ,
a.franchise_zip              ,
a.constrained_zip_commercial ,
a.constrained_zip_residential,
a.constrained_comments,
a.constrained_rule,
a.dcd_zip_code_type          ,
case
  when region =  'UNY' and market in('RESID', 'CONDO') and qty_unit_trw > 3 then 'MFAM'
  when region =  'UNY' and market in('RESID', 'CONDO') and qty_unit_trw <= 3 then 'RESID'
  when region <> 'UNY' and market in('RESID', 'CONDO') and qty_unit_trw > 5 then 'MFAM'
  when region <> 'UNY' and market in('RESID', 'CONDO') and qty_unit_trw <= 5 then 'RESID'
  else market
end as market,
qty_unit_trw as trwunits,
txt_county_use1_trw, /* this will be the same for all records so a group by is unnecessary */
a.id_apn_trw,
1 as cntyuse_cnt,
0 as abiunits,
0 as dnnllyunits,
nvl(qty_unit_trw,0) as numunits,
greatest(nvl(qty_area_univ_bldg_trw,0), nvl(qty_area_bldg_trw,0), nvl(qty_area_living_trw,0), 
nvl(qty_area_ground_fl_trw,0), nvl(qty_area_bldg_gross_trw,0), nvl(qty_area_bldg_adj_trw,0), nvl(qty_area_basement_trw,0)) as trw_sqrft,
a.adr_situs_city_trw, 
a.adr_situs_state_trw, 
a.cde_situs_code1_score_trw
from gas_forecast_TRW_Master a
where a.adr_situs_str_nme_trw = ' '
and market in('RESID', 'COML', 'CONDO', 'MFAM')
; 
/* 
Feb 2017 - 9718
Mar 2016 - 9504 inserted
Apr 2015 - 12434 inserted
Apr 2014 - 12904 inserted
May 2013 6883 inserted
6879 records inserted */

/******************************************************/
/******************************************************/
/******************************************************/
/**********  END OF TRW STRUCTURE CREATION  ***********/
/******************************************************/
/******************************************************/
/******************************************************/


/* Final Customer Structure Table */
select * from GAS_FORECAST_ALL_CUST_STRUCT;
/* Final TRW Structure Table */
select * from gas_forecast_TRW_Strct_final;

/* Create a table that shows the building square footage for each structure */
create table gas_forecast_TRW_sqrft tablespace xlarge_data as
select adr_situs_hse_num_trw,     
adr_situs_hse_alpha_trw,
adr_situs_str_prfx_trw,    
adr_situs_str_nme_trw,     
adr_situs_str_sufx1_trw,   
adr_situs_str_sufx2_trw,   
adr_situs_zip_trw,
max(adr_situs_city_trw) as adr_situs_city_trw, 
max(adr_situs_state_trw) as adr_situs_state_trw, 
max(cde_situs_code1_score_trw) as cde_situs_code1_score_trw,
sum(trw_sqrft)as trw_sqrft
from(
select a.adr_situs_hse_num_trw,     
a.adr_situs_hse_alpha_trw,
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw,
max(a.adr_situs_city_trw) as adr_situs_city_trw, 
max(a.adr_situs_state_trw) as adr_situs_state_trw, 
max(a.cde_situs_code1_score_trw) as cde_situs_code1_score_trw,
max(greatest(nvl(qty_area_univ_bldg_trw,0), nvl(qty_area_bldg_trw,0), nvl(qty_area_living_trw,0), 
nvl(qty_area_ground_fl_trw,0), nvl(qty_area_bldg_gross_trw,0), nvl(qty_area_bldg_adj_trw,0), nvl(qty_area_basement_trw,0))
)as trw_sqrft
from gas_forecast_TRW_Master a
where adr_situs_str_nme_trw <> ' '
and market in('RESID', 'COML', 'MFAM')
group by a.adr_situs_hse_num_trw,     
a.adr_situs_hse_alpha_trw,
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw
union all 
/* insert condos where we sum up the square footage - table that shows the building square footage for each structure */
select a.adr_situs_hse_num_trw,     
a.adr_situs_hse_alpha_trw,
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw,
max(a.adr_situs_city_trw) as adr_situs_city_trw, 
max(a.adr_situs_state_trw) as adr_situs_state_trw, 
max(a.cde_situs_code1_score_trw) as cde_situs_code1_score_trw,
sum(greatest(nvl(qty_area_univ_bldg_trw,0), nvl(qty_area_bldg_trw,0), nvl(qty_area_living_trw,0), 
nvl(qty_area_ground_fl_trw,0), nvl(qty_area_bldg_gross_trw,0), nvl(qty_area_bldg_adj_trw,0), nvl(qty_area_basement_trw,0))
)as trw_sqrft
from gas_forecast_TRW_Master a
where adr_situs_str_nme_trw <> ' '
and market in('CONDO')
group by a.adr_situs_hse_num_trw,     
a.adr_situs_hse_alpha_trw,
a.adr_situs_str_prfx_trw,    
a.adr_situs_str_nme_trw,     
a.adr_situs_str_sufx1_trw,   
a.adr_situs_str_sufx2_trw,   
a.adr_situs_zip_trw
)
group by adr_situs_hse_num_trw,     
adr_situs_hse_alpha_trw,
adr_situs_str_prfx_trw,    
adr_situs_str_nme_trw,     
adr_situs_str_sufx1_trw,   
adr_situs_str_sufx2_trw,   
adr_situs_zip_trw
;

select count(*) from gas_forecast_TRW_sqrft;
/* 
Feb 2017 - 6,783,512
Mar 2016 - 6,796,169
Apr 2015 - 6,768,485
Apr 2014 - 6,760,721
*/


select count(*) from gas_forecast_TRW_Strct_final;
/* 
Feb 2017 - 7237156
Mar 2016 - 7251143
Apr 2015 - 7225260
Apr 2014 - 7205326
*/

select count(*) from gas_forecast_TRW_Strct_final a
join gas_forecast_TRW_sqrft f
on  a.adr_situs_hse_num_trw   = f.adr_situs_hse_num_trw  
and a.adr_situs_hse_alpha_trw = f.adr_situs_hse_alpha_trw
and a.adr_situs_str_prfx_trw  = f.adr_situs_str_prfx_trw 
and a.adr_situs_str_nme_trw   = f.adr_situs_str_nme_trw  
and a.adr_situs_str_sufx1_trw = f.adr_situs_str_sufx1_trw
and a.adr_situs_str_sufx2_trw = f.adr_situs_str_sufx2_trw
and a.adr_situs_zip_trw       = f.adr_situs_zip_trw ;
/* 
Feb 2017 - 6783512
Mar 2016 - 6796169
Apr 2015 - 6768485
Apr 2014 - 6760721
6096273
6,426,075 - a difference of 6879 = the blank street name records */ 

create index idx_gas_forecast_TRW_sqrft on gas_forecast_TRW_sqrft(
adr_situs_hse_num_trw  ,
adr_situs_hse_alpha_trw,
adr_situs_str_prfx_trw ,
adr_situs_str_nme_trw  ,
adr_situs_str_sufx1_trw,
adr_situs_str_sufx2_trw,
adr_situs_zip_trw  );

create index idx_gas_fcst_TRW_Strct_final on gas_forecast_TRW_Strct_final(
adr_situs_hse_num_trw  ,
adr_situs_hse_alpha_trw,
adr_situs_str_prfx_trw ,
adr_situs_str_nme_trw  ,
adr_situs_str_sufx1_trw,
adr_situs_str_sufx2_trw,
adr_situs_zip_trw  );


update gas_forecast_TRW_Strct_final a
set a.numunits = greatest(nvl(a.trwunits,0), nvl(a.abiunits,0)+nvl(a.dnnllyunits,0))
where adr_situs_str_nme_trw <> ' ';

update gas_forecast_TRW_Strct_final a
set (a.trw_sqrft,
a.ADR_SITUS_CITY_TRW, 
a.ADR_SITUS_STATE_TRW, 
a.CDE_SITUS_CODE1_SCORE_TRW) = (select f.trw_sqrft, f.ADR_SITUS_CITY_TRW, f.ADR_SITUS_STATE_TRW, 
f.CDE_SITUS_CODE1_SCORE_TRW from gas_forecast_TRW_sqrft f
where a.adr_situs_hse_num_trw   = f.adr_situs_hse_num_trw  
and a.adr_situs_hse_alpha_trw = f.adr_situs_hse_alpha_trw
and a.adr_situs_str_prfx_trw  = f.adr_situs_str_prfx_trw 
and a.adr_situs_str_nme_trw   = f.adr_situs_str_nme_trw  
and a.adr_situs_str_sufx1_trw = f.adr_situs_str_sufx1_trw
and a.adr_situs_str_sufx2_trw = f.adr_situs_str_sufx2_trw
and a.adr_situs_zip_trw       = f.adr_situs_zip_trw      
)
where adr_situs_str_nme_trw <> ' ';


/* Structure of gas_forecast_TRW_Strct_final:
dist_to_main, 
cde_on_main, 
region, 
gas_cust_found, 
franchise_zip, 
constrained_zip_commercial, 
constrained_zip_residential, 
constrained_comments,
constrained_rule,
dcd_zip_code_type, 
market, 
trwunits, 
txt_county_use1_trw, 
cntyuse_cnt, 
abiunits, 
dnnllyunits, 
numunits, 
trw_sqrft
*/

/* Structure of GAS_FORECAST_ALL_CUST_STRUCT:
market, 
service, 
active_status, 
tc, 
resi_heat_accts, 
mfam_heat_accts, 
coml_heat_accts, 
resi_nonheat_accts, 
mfam_nonheat_accts, 
coml_nonheat_accts, 
total_accts
*/

/**** Add ABI and Donnelley counts to the customer file ****/
alter table GAS_FORECAST_ALL_CUST_STRUCT  add(abiunits number(10), dnnllyunits number(10));

/* set the Donnelley and ABI units to zero */
update GAS_FORECAST_ALL_CUST_STRUCT  set abiunits = 0, dnnllyunits = 0;

/* update the Donnelley and ABI units to the actual counts from Donnelley and ABI */
update GAS_FORECAST_ALL_CUST_STRUCT a
set a.abiunits = 
(select b.abi_cnt
from GAS_FORECAST_abi_structs b
where a.Sitehsenumb = b.Sitehsenumb
and a.sitehsealph = b.sitehsealph
and a.Sitestrprfx = b.Sitestrprfx   
and a.Sitestrname = b.Sitestrname   
and a.Sitestrsfx1 = b.Sitestrsfx1   
and a.Sitestrsfx2 = b.Sitestrsfx2   
and a.SiteZip5    = b.SiteZip5)
where exists(select *
from GAS_FORECAST_abi_structs b
where a.Sitehsenumb = b.Sitehsenumb
and a.sitehsealph = b.sitehsealph
and a.Sitestrprfx = b.Sitestrprfx   
and a.Sitestrname = b.Sitestrname   
and a.Sitestrsfx1 = b.Sitestrsfx1   
and a.Sitestrsfx2 = b.Sitestrsfx2   
and a.SiteZip5    = b.SiteZip5);

update GAS_FORECAST_ALL_CUST_STRUCT a
set a.dnnllyunits = 
(select b.dnnlly_cnt
from GAS_FORECAST_Dnnlly_structs b
where a.Sitehsenumb = b.Sitehsenumb
and a.sitehsealph = b.sitehsealph
and a.Sitestrprfx = b.Sitestrprfx   
and a.Sitestrname = b.Sitestrname   
and a.Sitestrsfx1 = b.Sitestrsfx1   
and a.Sitestrsfx2 = b.Sitestrsfx2   
and a.SiteZip5    = b.SiteZip5)
where exists(select *
from GAS_FORECAST_Dnnlly_structs b
where a.Sitehsenumb = b.Sitehsenumb
and a.sitehsealph = b.sitehsealph
and a.Sitestrprfx = b.Sitestrprfx   
and a.Sitestrname = b.Sitestrname   
and a.Sitestrsfx1 = b.Sitestrsfx1   
and a.Sitestrsfx2 = b.Sitestrsfx2   
and a.SiteZip5    = b.SiteZip5);

/* update the Donnelley and ABI units to the actual counts from Donnelley and ABI using 6 address pieces*/
update GAS_FORECAST_ALL_CUST_STRUCT a
set a.abiunits = 
(select b.abi_cnt
from GAS_FORECAST_abi_structsa b
where a.Sitehsenumb = b.Sitehsenumb
and a.Sitestrprfx = b.Sitestrprfx   
and a.Sitestrname = b.Sitestrname   
and a.Sitestrsfx1 = b.Sitestrsfx1   
and a.Sitestrsfx2 = b.Sitestrsfx2   
and a.SiteZip5    = b.SiteZip5)
where exists(select *
from GAS_FORECAST_abi_structsa b
where a.Sitehsenumb = b.Sitehsenumb
and a.Sitestrprfx = b.Sitestrprfx   
and a.Sitestrname = b.Sitestrname   
and a.Sitestrsfx1 = b.Sitestrsfx1   
and a.Sitestrsfx2 = b.Sitestrsfx2   
and a.SiteZip5    = b.SiteZip5)
and a.abiunits = 0;
/* 
Feb 2017 2712
Mar 2016 2601 updated
Apr 2015 2454 updated 
Apr 2014 2411 updated
May 2013 2467 updated */

update GAS_FORECAST_ALL_CUST_STRUCT a
set a.dnnllyunits = 
(select b.dnnlly_cnt
from GAS_FORECAST_Dnnlly_structsa b
where a.Sitehsenumb = b.Sitehsenumb
and a.Sitestrprfx = b.Sitestrprfx   
and a.Sitestrname = b.Sitestrname   
and a.Sitestrsfx1 = b.Sitestrsfx1   
and a.Sitestrsfx2 = b.Sitestrsfx2   
and a.SiteZip5    = b.SiteZip5)
where exists(select *
from GAS_FORECAST_Dnnlly_structsa b
where a.Sitehsenumb = b.Sitehsenumb
and a.Sitestrprfx = b.Sitestrprfx   
and a.Sitestrname = b.Sitestrname   
and a.Sitestrsfx1 = b.Sitestrsfx1   
and a.Sitestrsfx2 = b.Sitestrsfx2   
and a.SiteZip5    = b.SiteZip5)
and a.dnnllyunits = 0;
/* 
Feb 2017 7670 
Mar 2016 7092 updated
Apr 2015 6904 updated
Apr 2014 6958 updated
May 2013 7050 updated */

/**** END Adding ABI and Donnelley counts to the customer file ****/

/* update customer records to multi family where the donnelley counts are at or above the multi family cutoff 
and market is residential */
update GAS_FORECAST_ALL_CUST_STRUCT
set market = 'MFAM' where (region = 'UNY' and dnnllyunits > 3 and market = 'RESID')
or (region <> 'UNY' and dnnllyunits > 5 and market = 'RESID');
/* 
Feb 2017 17242
Mar 2016 16495 updated
Apr 2015 19013 updated
Apr 2014 22542 updated
May 2013 22256 updated
11,385 updated */

/* TRW units are the max number of units found at that structure.  
Numunits takes the maximum of the trwunits vs. ABIUNITS+DNNLLYUNITS.  
Multi family is determined by county use or the max of TRWUNITS vs. DNNLLYUNITS only, 
since multi family is considered residential */


/* Before dropping, save previous version of gas saturation table */
/*select * from cpalmieri.GAS_FCST_SAT_FINAL_MAY_2012;*/

alter table cpalmieri.GAS_FORECAST_SATURATION_FINAL rename to GAS_FCST_SAT_FINAL_Mar_2016;
alter index cpalmieri.idx_gas_fcst_saturation_final rename to idx_gas_fcst_sat_fin_Mar_2016;
alter index cpalmieri.idx_gas_fcst_saturation_finala rename to idx_gas_fcst_sat_fina_Mar_2016;
alter index cpalmieri.idx_gas_forecast_sat_final rename to idx_gas_fcst_sat_finb_Mar_2016;


drop view miuser.gas_fcst_sat_final_w_gpm_view;

create or replace view miuser.gas_fcst_sat_fin_apr15_gpm_vw as
select 
/* remove triple and double spaces from the siteline1 */
REPLACE(
REPLACE(
trim(trim(a.sitehsenumb)||' '||
trim(a.sitehsealph)||' '||
trim(a.sitestrprfx)||' '||
trim(a.sitestrname)||' '||trim(a.Sitestrsfx1)||' '||trim(a.sitestrsfx2))
,'   ',' '),'  ',' ')  as siteline1,
a.*,
r.region_desc,
g.css_codes,
g.rate_code,
g.title,
g.annual_dollar_per_dth,
g.annual_dollar_per_cus,
g.annual_dth_per_cus,
g.peak_day_dth_per_cus
from cpalmieri.GAS_FCST_SAT_FINAL_APR_2015 a
left join cpalmieri.GAS_FORECAST_NOT_MA_GPM_FILE g
on a.pros_heat_rate = g.css_codes
and a.region = g.region
left join cpalmieri.gas_fcst_region_zip r
on a.sitezip5 = r.zip
where a.region not in('MA','NH')
union all 
select
/* remove triple and double spaces from the siteline1 */
REPLACE(
REPLACE(
trim(trim(a.sitehsenumb)||' '||
trim(a.sitehsealph)||' '||
trim(a.sitestrprfx)||' '||
trim(a.sitestrname)||' '||trim(a.Sitestrsfx1)||' '||trim(a.sitestrsfx2))
,'   ',' '),'  ',' ')  as siteline1,
a.*,
r.region_desc,
g.css_codes,
g.rate_code,
g.title,
g.annual_dollar_per_dth,
g.annual_dollar_per_cus,
g.annual_dth_per_cus,
g.peak_day_dth_per_cus
from cpalmieri.GAS_FCST_SAT_FINAL_APR_2015 a
join miuser.zip_master_table z
on a.sitezip5 = z.zip5
left join cpalmieri.GAS_FORECAST_MA_GPM_FILE g
on a.pros_heat_rate = substr(g.css_codes,2,3)
and z.kyspn_cmpny_dc = g.gas_co
left join cpalmieri.gas_fcst_region_zip r
on a.sitezip5 = r.zip
where a.region = 'MA';

grant select on miuser.gas_fcst_sat_fin_apr15_gpm_vw to superuser;

/***** Create final file that joins Customer to TRW  on 7 address pieces *****/
create table GAS_FORECAST_SATURATION_FINAL tablespace xlarge_data as
select a.*,
z.gas_cust_found, 
z.franchise_zip, 
z.surrounding_town,
z.constrained_zip_commercial, 
z.constrained_zip_residential, 
z.constrained_comments,
z.constrained_rule,
z.dcd_zip_code_type
from (
select 
case when a.sitezip5 is not null then a.region      else b.region                    end as region,
a.cde_rte, 
case when a.sitezip5 is not null then a.sitehsenumb else b.adr_situs_hse_num_trw     end as sitehsenumb,
case when a.sitezip5 is not null then a.sitehsealph else b.adr_situs_hse_alpha_trw   end as sitehsealph,
case when a.sitezip5 is not null then a.sitestrprfx else b.adr_situs_str_prfx_trw    end as sitestrprfx,
case when a.sitezip5 is not null then a.sitestrname else b.adr_situs_str_nme_trw     end as sitestrname,
case when a.sitezip5 is not null then a.sitestrsfx1 else b.adr_situs_str_sufx1_trw   end as sitestrsfx1,
case when a.sitezip5 is not null then a.sitestrsfx2 else b.adr_situs_str_sufx2_trw   end as sitestrsfx2,
case when a.sitezip5 is not null then a.sitezip5    else b.adr_situs_zip_trw         end as sitezip5   ,
case when a.sitezip5 is not null then a.sitecity    else b.ADR_SITUS_CITY_TRW        end as sitecity   ,
case when a.sitezip5 is not null then a.sitestate   else b.ADR_SITUS_STATE_TRW       end as sitestate  ,
case when a.sitezip5 is not null then a.sitescr     else b.CDE_SITUS_CODE1_SCORE_TRW end as sitescr    ,
a.service,
a.active_status,
a.tc,
a.resi_heat_accts, 
a.mfam_heat_accts, 
a.coml_heat_accts, 
a.resi_nonheat_accts, 
a.mfam_nonheat_accts, 
a.coml_nonheat_accts, 
a.total_accts,
a.market as cust_market,
b.id_apn_trw,
b.market as trw_market,
case when a.sitezip5 is not null then a.market      else b.market                    end as market    ,
b.dist_to_main, 
b.cde_on_main, 
b.trwunits, 
b.txt_county_use1_trw, 
b.cntyuse_cnt, 
case when a.sitezip5 is not null then a.abiunits    else b.abiunits                  end as abiunits  ,
case when a.sitezip5 is not null then a.dnnllyunits else b.dnnllyunits               end as dnnllyunits ,
b.numunits, 
b.trw_sqrft,
case 
  when a.sitezip5 is not null and b.adr_situs_zip_trw is not null then 'BOTH'
  when a.sitezip5 is not null and b.adr_situs_zip_trw is null then 'CUST'
  when a.sitezip5 is null and b.adr_situs_zip_trw is not null then 'TRW '
  else 'UNKN'
end as match
from GAS_FORECAST_ALL_CUST_STRUCT a
full outer join gas_forecast_TRW_Strct_final b
on  a.Sitehsenumb = b.adr_situs_hse_num_trw  
and nvl(a.sitehsealph,' ') = nvl(b.adr_situs_hse_alpha_trw,' ')
and nvl(a.Sitestrprfx,' ') = nvl(b.adr_situs_str_prfx_trw ,' ')
and nvl(a.Sitestrname,' ') = nvl(b.adr_situs_str_nme_trw  ,' ')
and nvl(a.Sitestrsfx1,' ') = nvl(b.adr_situs_str_sufx1_trw,' ')
and nvl(a.Sitestrsfx2,' ') = nvl(b.adr_situs_str_sufx2_trw,' ')
and a.SiteZip5    = b.adr_situs_zip_trw      
) a
join zips_franchise_gas_forecast z
on a.sitezip5 = z.zip5;

select count(*) from GAS_FORECAST_SATURATION_FINAL;
/* 
Feb 2017 7,615,415
Mar 2016 7,628,937
Apr 2015 7,602,667
Apr 2014 7,618,368
May 2013 6,850,839
6,826,636 */

select z.state_abbrev, count(*)
from GAS_FORECAST_SATURATION_FINAL a
left join miuser.zip_master_table z
on a.sitezip5 = z.zip5
where a.sitestate is null
group by z.state_abbrev;
/* 
Feb 2017:
STATE_ABBREV	COUNT(*)
MA	28
NY	426
NH	443140

Mar 2016:
STATE_ABBREV	COUNT(*)
MA	1577
NY	359
NH	443135

Apr 2015:
STATE_ABBREV	COUNT(*)
MA	13
NY	666
NH	443140
*/

/* remove NH records */
delete from GAS_FORECAST_SATURATION_FINAL g
where exists(select k.* from
(select a.*
from GAS_FORECAST_SATURATION_FINAL a
join miuser.zip_master_table z
on a.sitezip5 = z.zip5
where a.sitestate is null
and z.state_abbrev ='NH') k
where g.sitezip5 = k.sitezip5
);
/* 10 seconds to run 
Feb 2017 - 443141
Mar 2016 - 443136 deleted
Apr 2015 - 443141 deleted */

/* Create table to add state and city back to saturation table where they are null */
drop table GAS_FORECAST_SATURATION_Adback;

create table GAS_FORECAST_SATURATION_Adback as
select distinct a.id_apn_trw, 
a.adr_situs_zip_trw,
a.adr_situs_city_trw, 
a.adr_situs_state_trw,
a.cde_situs_code1_score_trw
from mi_edr_prod.edr_trw a 
join (
select distinct a.id_apn_trw, a.sitezip5
from GAS_FORECAST_SATURATION_FINAL a
join miuser.zip_master_table z
on a.sitezip5 = z.zip5
where a.sitestate is null
and z.state_abbrev in('MA','NY')) b
on a.id_apn_trw = b.id_apn_trw
and a.adr_situs_zip_trw = b.sitezip5;

select a.* from GAS_FORECAST_SATURATION_FINAL a
join GAS_FORECAST_SATURATION_Adback b
on a.sitezip5 = b.adr_situs_zip_trw
and a.id_apn_trw = b.id_apn_trw;
/* 
Feb 2017 - 454
Mar 2016 - 1936
679 */

/* Add ciy, state, and score back to those records missing data */
update GAS_FORECAST_SATURATION_FINAL a
set (a.sitecity, a.sitestate, a.sitescr) = (select b.adr_situs_city_trw, 
b.adr_situs_state_trw,
b.cde_situs_code1_score_trw
from GAS_FORECAST_SATURATION_Adback b
where a.sitezip5 = b.adr_situs_zip_trw
and a.id_apn_trw = b.id_apn_trw)
where a.sitestate is null
and exists(select * from GAS_FORECAST_SATURATION_Adback b
where a.sitezip5 = b.adr_situs_zip_trw
and a.id_apn_trw = b.id_apn_trw);
/* 
Feb 2017 - 454 
Mar 2016 - 1936 updated - 5 seconds
Apr 2015 - 679 updated - 2 seconds */

select z.state_abbrev, count(*)
from GAS_FORECAST_SATURATION_FINAL a
left join miuser.zip_master_table z
on a.sitezip5 = z.zip5
where a.sitestate is null
group by z.state_abbrev;
/* 0 */

select match, count(*)
from GAS_FORECAST_SATURATION_FINAL
group by match;
/*
Feb 2017:
MATCH	COUNT(*)
CUST	378231
BOTH	2243930
TRW 	4550113

Mar 2016:
MATCH	COUNT(*)
CUST	377766
BOTH	2230337
TRW 	4577698

Apr 2015: No NH
MATCH	COUNT(*)
CUST	377378
BOTH	2208204
TRW 	4573944

Apr 2014:
MATCH	COUNT(*)
CUST	405290
BOTH	2247839
TRW 	4965239
*/

/* Test for the match of TRW to customer on the 6 address pieces to see what the impact would be if I don't do the
6 address match */

create table GAS_FORECAST_cust6 as
select 
sitehsenumb,
sitestrprfx,
sitestrname,
sitestrsfx1,
sitestrsfx2,
sitezip5   ,
count(*) as custcount
from GAS_FORECAST_SATURATION_FINAL
where match = 'CUST'
group by
sitehsenumb,
sitestrprfx,
sitestrname,
sitestrsfx1,
sitestrsfx2,
sitezip5   
;

create index idx_GAS_FORECAST_cust6 on GAS_FORECAST_cust6(sitehsenumb,sitestrprfx,sitestrname,sitestrsfx1,sitestrsfx2,sitezip5);

create table GAS_FORECAST_trw6 as
select 
sitehsenumb,
sitestrprfx,
sitestrname,
sitestrsfx1,
sitestrsfx2,
sitezip5   ,
count(*) as trwcount
from GAS_FORECAST_SATURATION_FINAL
where match = 'TRW'
group by
sitehsenumb,
sitestrprfx,
sitestrname,
sitestrsfx1,
sitestrsfx2,
sitezip5   
;

create index idx_test1_trw on GAS_FORECAST_trw6(sitehsenumb,sitestrprfx,sitestrname,sitestrsfx1,sitestrsfx2,sitezip5);


create table GAS_FORECAST_test_both6 as
select a.*,
b.trwcount
from GAS_FORECAST_cust6 a
join GAS_FORECAST_trw6 b
on  a.sitehsenumb  = b.sitehsenumb
and a.sitestrprfx  = b.sitestrprfx
and a.sitestrname  = b.sitestrname
and a.sitestrsfx1  = b.sitestrsfx1
and a.sitestrsfx2  = b.sitestrsfx2
and a.sitezip5     = b.sitezip5 ;

select * from GAS_FORECAST_test_both6
order by trwcount, custcount;

select count(*) from GAS_FORECAST_test_both6
where custcount = 1
and trwcount = 1;
/* 
Feb 2017 - 1276
Mar 2016 - 1276
1296 */

select a.* from GAS_FORECAST_SATURATION_FINAL a
join GAS_FORECAST_test_both6 b
on  a.sitehsenumb  = b.sitehsenumb
and a.sitestrprfx  = b.sitestrprfx
and a.sitestrname  = b.sitestrname
and a.sitestrsfx1  = b.sitestrsfx1
and a.sitestrsfx2  = b.sitestrsfx2
and a.sitezip5     = b.sitezip5 
where b.trwcount < b.custcount;

/* Create a base table to update the TRW records for those Customer addresses only matched by the 6 address pieces */
create table GAS_FORECAST_test_update6 as
select               
a.sitehsenumb       ,
a.sitestrprfx       ,
a.sitestrname       ,
a.sitestrsfx1       ,
a.sitestrsfx2       ,
a.sitezip5          ,
a.CDE_RTE           ,
a.SERVICE           ,
a.ACTIVE_STATUS     ,
a.TC                ,
a.RESI_HEAT_ACCTS   ,
a.MFAM_HEAT_ACCTS   ,
a.COML_HEAT_ACCTS   ,
a.RESI_NONHEAT_ACCTS,
a.MFAM_NONHEAT_ACCTS,
a.COML_NONHEAT_ACCTS,
a.TOTAL_ACCTS       ,
a.CUST_MARKET       ,
a.MARKET            ,
a.MATCH             ,
case
	when market = 'MFAM' then 1
	when market = 'RESID' then 2
	when market = 'COML' then 3
end as priority
from GAS_FORECAST_SATURATION_FINAL a
join GAS_FORECAST_test_both6 b
on  a.sitehsenumb  = b.sitehsenumb
and a.sitestrprfx  = b.sitestrprfx
and a.sitestrname  = b.sitestrname
and a.sitestrsfx1  = b.sitestrsfx1
and a.sitestrsfx2  = b.sitestrsfx2
and a.sitezip5     = b.sitezip5 
where a.MATCH = 'CUST'
order by
a.sitehsenumb       ,
a.sitestrprfx       ,
a.sitestrname       ,
a.sitestrsfx1       ,
a.sitestrsfx2       ,
a.sitezip5          ,
a.SERVICE, 
case
	when market = 'MFAM' then 1
	when market = 'RESID' then 2
	when market = 'COML' then 3
end,
total_accts desc
;

select * from GAS_FORECAST_test_update6
order by rowid;

/** Keep the most significant customer record to update the saturation file **/
delete from GAS_FORECAST_test_update6 a
where rowid > any(select rowid from GAS_FORECAST_test_update6 b
where a.sitehsenumb  = b.sitehsenumb
and a.sitestrprfx  = b.sitestrprfx
and a.sitestrname  = b.sitestrname
and a.sitestrsfx1  = b.sitestrsfx1
and a.sitestrsfx2  = b.sitestrsfx2
and a.sitezip5     = b.sitezip5 )
;
/* 
Feb 2017 - 829 deleted
Mar 2016 - 675 deleted
Apr 2015 - 648 deleted
apr 2014 - 620 deleted 
628 deleted */


/* update the TRW records for those Customer addresses only matched by the 6 address pieces */
update GAS_FORECAST_SATURATION_FINAL a
set (a.CDE_RTE, a.SERVICE, a.ACTIVE_STATUS, a.TC, a.CUST_MARKET, a.MARKET) = 
(select b.CDE_RTE, b.SERVICE, b.ACTIVE_STATUS, b.TC, b.CUST_MARKET, b.MARKET
from GAS_FORECAST_test_update6 b
where a.sitehsenumb  = b.sitehsenumb
and a.sitestrprfx  = b.sitestrprfx
and a.sitestrname  = b.sitestrname
and a.sitestrsfx1  = b.sitestrsfx1
and a.sitestrsfx2  = b.sitestrsfx2
and a.sitezip5     = b.sitezip5 )
where exists(select * from GAS_FORECAST_test_update6 b
where a.sitehsenumb  = b.sitehsenumb
and a.sitestrprfx  = b.sitestrprfx
and a.sitestrname  = b.sitestrname
and a.sitestrsfx1  = b.sitestrsfx1
and a.sitestrsfx2  = b.sitestrsfx2
and a.sitezip5     = b.sitezip5 )
and a.match = 'TRW';
/* 
Feb 2017 - 2827
Mar 2016 - 2597 updated
Apr 2015 - 2613 updated
Apr 2014 - 5718 rows updated
3098 rows updated */

/* Create a table to update the TRW records with the customer account counts for those Customer 
addresses only matched by the 6 address pieces */
create table GAS_FORECAST_test_update6b as
select               
a.sitehsenumb       ,
a.sitestrprfx       ,
a.sitestrname       ,
a.sitestrsfx1       ,
a.sitestrsfx2       ,
a.sitezip5          ,
sum(a.RESI_HEAT_ACCTS)/max(b.trwcount) as RESI_HEAT_ACCTS  ,
sum(a.MFAM_HEAT_ACCTS)/max(b.trwcount) as MFAM_HEAT_ACCTS ,
sum(a.COML_HEAT_ACCTS)/max(b.trwcount) as COML_HEAT_ACCTS ,
sum(a.RESI_NONHEAT_ACCTS)/max(b.trwcount) as RESI_NONHEAT_ACCTS,
sum(a.MFAM_NONHEAT_ACCTS)/max(b.trwcount) as MFAM_NONHEAT_ACCTS,
sum(a.COML_NONHEAT_ACCTS)/max(b.trwcount) as COML_NONHEAT_ACCTS,
sum(a.TOTAL_ACCTS)/max(b.trwcount) as TOTAL_ACCTS
from GAS_FORECAST_SATURATION_FINAL a
join GAS_FORECAST_test_both6 b
on  a.sitehsenumb  = b.sitehsenumb
and a.sitestrprfx  = b.sitestrprfx
and a.sitestrname  = b.sitestrname
and a.sitestrsfx1  = b.sitestrsfx1
and a.sitestrsfx2  = b.sitestrsfx2
and a.sitezip5     = b.sitezip5 
where a.MATCH = 'CUST'
group by
a.sitehsenumb       ,
a.sitestrprfx       ,
a.sitestrname       ,
a.sitestrsfx1       ,
a.sitestrsfx2       ,
a.sitezip5          
;

select * from GAS_FORECAST_test_update6b;
/* 
Feb 2017 - 2265
Mar 2016 - 2107
Apr 2015 - 2112
Apr 2014 - 4787 
2401 */

/* update the TRW records for those Customer addresses only matched by the 6 address pieces */
update GAS_FORECAST_SATURATION_FINAL a
set (a.RESI_HEAT_ACCTS, a.MFAM_HEAT_ACCTS, a.COML_HEAT_ACCTS, a.RESI_NONHEAT_ACCTS, a.MFAM_NONHEAT_ACCTS, a.COML_NONHEAT_ACCTS, a.TOTAL_ACCTS, a.MATCH) = 
(select b.RESI_HEAT_ACCTS, b.MFAM_HEAT_ACCTS, b.COML_HEAT_ACCTS, b.RESI_NONHEAT_ACCTS, b.MFAM_NONHEAT_ACCTS, b.COML_NONHEAT_ACCTS, b.TOTAL_ACCTS, 'BOTH'
from GAS_FORECAST_test_update6b b
where a.sitehsenumb  = b.sitehsenumb
and a.sitestrprfx  = b.sitestrprfx
and a.sitestrname  = b.sitestrname
and a.sitestrsfx1  = b.sitestrsfx1
and a.sitestrsfx2  = b.sitestrsfx2
and a.sitezip5     = b.sitezip5 )
where exists(select * from GAS_FORECAST_test_update6b b
where a.sitehsenumb  = b.sitehsenumb
and a.sitestrprfx  = b.sitestrprfx
and a.sitestrname  = b.sitestrname
and a.sitestrsfx1  = b.sitestrsfx1
and a.sitestrsfx2  = b.sitestrsfx2
and a.sitezip5     = b.sitezip5 )
and a.match = 'TRW';
/* 
Feb 2017 - 2827 
Mar 2016 - 2597
Apr 2015 - 2613 updated
Apr 2014 - 5718 updated
3098 rows updated */

/* Remove the customer records from saturation because we do not want to duplicate structures */
delete from GAS_FORECAST_SATURATION_FINAL a
where exists(select * from GAS_FORECAST_test_update6b b
where a.sitehsenumb  = b.sitehsenumb
and a.sitestrprfx  = b.sitestrprfx
and a.sitestrname  = b.sitestrname
and a.sitestrsfx1  = b.sitestrsfx1
and a.sitestrsfx2  = b.sitestrsfx2
and a.sitezip5     = b.sitezip5 )
and a.match = 'CUST'
/* 
Feb 2017 - 3094
Mar 2016 - 2782 deleted
2750 deleted
5,407 rows deleted
3,029 rows deleted */


select * from GAS_FORECAST_SATURATION_FINAL a
where exists(select * from GAS_FORECAST_test_update6b b
where a.sitehsenumb  = b.sitehsenumb
and a.sitestrprfx  = b.sitestrprfx
and a.sitestrname  = b.sitestrname
and a.sitestrsfx1  = b.sitestrsfx1
and a.sitestrsfx2  = b.sitestrsfx2
and a.sitezip5     = b.sitezip5 );
/* 
Mar 2016 - 2653 - there were 129 records where TRW and CUST were already matched
Apr 2015 - 2672 - there were 78 records where TRW and CUST were already matched
Apr 2014 - 5798 - there were 80 records where TRW and CUST were already matched
3148 - there were 50 records where TRW and CUST were already matched  */

select * from GAS_FORECAST_SATURATION_FINAL
where match = 'CUST';

/* Remove the blank street names - these should not have been joined above - duplicates */
delete from GAS_FORECAST_SATURATION_FINAL
where Sitestrname = ' ';
/* 
9,747 Feb 2017
9,533 deleted Mar 2016
12,464 deleted Apr 2015
20,704 deleted Apr 2014
*/

/*** re-insert those records back into the final file, taking the one occurance of each bad address ***/

insert into GAS_FORECAST_SATURATION_FINAL
select 
a.region      ,
a.cde_rte, 
a.sitehsenumb ,
a.sitehsealph ,
a.sitestrprfx ,
a.sitestrname ,
a.sitestrsfx1 ,
a.sitestrsfx2 ,
a.sitezip5    ,
a.sitecity    ,
a.sitestate   ,
a.sitescr     ,
a.service,
a.active_status,
a.tc,
a.resi_heat_accts, 
a.mfam_heat_accts, 
a.coml_heat_accts, 
a.resi_nonheat_accts, 
a.mfam_nonheat_accts, 
a.coml_nonheat_accts, 
a.total_accts,
a.market as cust_market,
'' as id_apn_trw,
'' as trw_market,
a.market as market    ,
null as dist_to_main, 
null as cde_on_main, 
null as trwunits, 
null as txt_county_use1_trw, 
null as cntyuse_cnt, 
a.abiunits,
a.dnnllyunits ,
null as numunits, 
null as trw_sqrft,
'CUST' as match,
z.gas_cust_found, 
z.franchise_zip, 
z.surrounding_town,
z.constrained_zip_commercial, 
z.constrained_zip_residential, 
z.constrained_comments,
z.constrained_rule,
z.dcd_zip_code_type
from GAS_FORECAST_ALL_CUST_STRUCT a
join zips_franchise_gas_forecast z
on a.sitezip5 = z.zip5
where a.Sitestrname = ' ';
/* 
10 - Feb 2017
10 - Mar 2016
11 - Apr 2015
461 - Apr 2014
*/

insert into GAS_FORECAST_SATURATION_FINAL
select 
b.region,
'' as cde_rte, 
b.adr_situs_hse_num_trw     as sitehsenumb,
b.adr_situs_hse_alpha_trw   as sitehsealph,
b.adr_situs_str_prfx_trw    as sitestrprfx,
b.adr_situs_str_nme_trw     as sitestrname,
b.adr_situs_str_sufx1_trw   as sitestrsfx1,
b.adr_situs_str_sufx2_trw   as sitestrsfx2,
b.adr_situs_zip_trw         as sitezip5   ,
b.ADR_SITUS_CITY_TRW        as sitecity   ,
b.ADR_SITUS_STATE_TRW       as sitestate  ,
b.CDE_SITUS_CODE1_SCORE_TRW as sitescr    ,
'' as service,
'' as active_status,
'' as tc,
null as resi_heat_accts, 
null as mfam_heat_accts, 
null as coml_heat_accts, 
null as resi_nonheat_accts, 
null as mfam_nonheat_accts, 
null as coml_nonheat_accts, 
null as total_accts,
'' as cust_market,
b.id_apn_trw,
b.market as trw_market,
b.market   ,
b.dist_to_main, 
b.cde_on_main, 
b.trwunits, 
b.txt_county_use1_trw, 
b.cntyuse_cnt, 
b.abiunits  ,
b.dnnllyunits ,
b.numunits, 
b.trw_sqrft,
'TRW ' as match,
z.gas_cust_found, 
z.franchise_zip, 
z.surrounding_town,
z.constrained_zip_commercial, 
z.constrained_zip_residential, 
z.constrained_comments,
z.constrained_rule,
z.dcd_zip_code_type
from gas_forecast_TRW_Strct_final b
join zips_franchise_gas_forecast z
on b.adr_situs_zip_trw = z.zip5
where b.adr_situs_str_nme_trw = ' ';
/* 
9,718 Feb 2017
9,504 Mar 2016
12,434 Apr 2015
12,904 Apr 2014
*/

create index idx_GAS_FCST_SATURATION_FINAL 
on GAS_FORECAST_SATURATION_FINAL(SITEHSENUMB,SITESTRPRFX,SITESTRNAME,SITESTRSFX1,SITESTRSFX2,SITEZIP5);

create index idx_GAS_FCST_SATURATION_FINALA
on GAS_FORECAST_SATURATION_FINAL(SITEHSENUMB,sitehsealph, SITESTRPRFX,SITESTRNAME,SITESTRSFX1,SITESTRSFX2,SITEZIP5);

/* Set the LI on main code where there is a match to the cde_on_main table and the address is on main */
update GAS_FORECAST_SATURATION_FINAL a
set a.CDE_ON_MAIN = 0 
where exists(select *
from miuser.li_pure_cde_on_main b
where a.Sitehsenumb = b.situhsnm 
and a.Sitestrprfx = nvl(b.situprfx,' ')   
and a.Sitestrname = nvl(b.situstnm,' ')   
and a.Sitestrsfx1 = nvl(b.situsfx1,' ')   
and a.Sitestrsfx2 = nvl(b.situsfx2,' ')   
and a.SiteZip5    = b.situzip5
and b.CDE_ON_MAIN = 2);
/* 
40,029 Feb 2017
40,031 Mar 2016
39,603 Apr 2015
39,954 Apr 2014 
40,202 May 2013
39,876 updated */

/* Set the UNY on main code where there is a match to the cde_on_main table and the address is on main */
update GAS_FORECAST_SATURATION_FINAL a
set a.CDE_ON_MAIN = 0 
where exists(select *
from miuser.ny_pure_cde_on_main b
where a.Sitehsenumb = b.situhsnm 
and a.Sitestrprfx = nvl(b.situprfx,' ')   
and a.Sitestrname = nvl(b.situstnm,' ')   
and a.Sitestrsfx1 = nvl(b.situsfx1,' ')   
and a.Sitestrsfx2 = nvl(b.situsfx2,' ')   
and a.SiteZip5    = b.situzip5
and b.CDE_ON_MAIN = 2);
/* 
10,729 Feb 2017
10,725 Mar 2016
10,712 Apr 2015
10,679 Apr 2014
10,701 May 2013
9,654 updated */

/* Set the RI on main code where there is a match to the cde_on_main table and the address is on main */
update GAS_FORECAST_SATURATION_FINAL a
set a.CDE_ON_MAIN = 0 
where exists(select *
from miuser.ri_pure_cde_on_main b
where a.Sitehsenumb = b.situhsnm 
and a.Sitestrprfx = nvl(b.situprfx,' ')   
and a.Sitestrname = nvl(b.situstnm,' ')   
and a.Sitestrsfx1 = nvl(b.situsfx1,' ')   
and a.Sitestrsfx2 = nvl(b.situsfx2,' ')   
and a.SiteZip5    = b.situzip5
and b.CDE_ON_MAIN = 2);
/* 
24,074 Feb 2017
24,049 Mar 2016
23,994 Apr 2015
24,013 Apr 2014
*/

select match, count(*) from GAS_FORECAST_SATURATION_FINAL group by match;
/*
Feb 2017:
MATCH	COUNT(*)
CUST	375145
BOTH	2246602
TRW 	4547414

Mar 2016:
MATCH	COUNT(*)
CUST	374992
BOTH	2232772
TRW 	4575236

Apr 2015: No NH
MATCH	COUNT(*)
CUST	374626
BOTH	2210654
TRW 	4571467
*/

select region, sitezip5, dcd_zip_code_type, count(*) as totrecords,
sum(case when match = 'CUST' then 1 else 0 end) as custonlyrecs,
sum(case when match = 'TRW' then 1 else 0 end) as TRWonlyrecs
from GAS_FORECAST_SATURATION_FINAL 
group by region, sitezip5, dcd_zip_code_type
order by region, sitezip5, dcd_zip_code_type
;

select * from GAS_FORECAST_SATURATION_FINAL
where match = 'CUST';

alter table GAS_FORECAST_SATURATION_FINAL
add(sqr_ft_group varchar2(20), TRW_numunits_group varchar2(20), Cust_numunits_group varchar2(20));

update GAS_FORECAST_SATURATION_FINAL
set sqr_ft_group =
case 
  when trw_sqrft = 0 or trw_sqrft is null then 'UNKNOWN'
  when trw_sqrft between 1 and 2000 then '  1 to 2000'
  when trw_sqrft between 2001 and 3000 then ' 2001 to 3000'  
  when trw_sqrft between 3001 and 5000 then ' 3001 to 5000'
  when trw_sqrft between 5001 and 10000 then ' 5001 to 10000'
  when trw_sqrft between 10001 and 25000 then '10001 to 25000'
  when trw_sqrft between 25001 and 50000 then '25001 to 50000'
  else 'Over 50000'
end;

update GAS_FORECAST_SATURATION_FINAL
set TRW_numunits_group =  
case
  when trwunits = 0 or trwunits is null then 'UNKNOWN'
  when region = 'UNY' and trwunits between 1 and 3 then ' 1 to 3 units'
  when region = 'UNY' and trwunits between 4 and 20 then ' 4 to 20 units'
  when region = 'UNY' and trwunits > 20 then 'Over 20 units'
  when region <> 'UNY' and trwunits between 1 and 5 then ' 1 to 5 units'
  when region <> 'UNY' and trwunits between 6 and 20 then ' 6 to 20 units'
  when region <> 'UNY' and trwunits > 20 then 'Over 20 units'
end,
Cust_numunits_group =
case
  when total_accts is null then 'UNKNOWN'
  when greatest(nvl(total_accts,0), nvl(abiunits,0)+nvl(dnnllyunits,0)) = 0 then 'UNKNOWN'
  when region = 'UNY' and greatest(nvl(total_accts,0), nvl(abiunits,0)+nvl(dnnllyunits,0)) between 1 and 3 then ' 1 to 3 units'
  when region = 'UNY' and greatest(nvl(total_accts,0), nvl(abiunits,0)+nvl(dnnllyunits,0)) between 4 and 20 then ' 4 to 20 units'
  when region = 'UNY' and greatest(nvl(total_accts,0), nvl(abiunits,0)+nvl(dnnllyunits,0)) > 20 then 'Over 20 units'
  when region <> 'UNY' and greatest(nvl(total_accts,0), nvl(abiunits,0)+nvl(dnnllyunits,0)) between 1 and 5 then ' 1 to 5 units'
  when region <> 'UNY' and greatest(nvl(total_accts,0), nvl(abiunits,0)+nvl(dnnllyunits,0)) between 6 and 20 then ' 6 to 20 units'
  when region <> 'UNY' and greatest(nvl(total_accts,0), nvl(abiunits,0)+nvl(dnnllyunits,0)) > 20 then 'Over 20 units'
end
;
/* 
Feb 2017 - 7,169,161
Mar 2016 - 7,183,000 updated
Apr 2015 - 7,156,747 updated
Apr 2014 - 7,605,622 updated
*/

select cust_market, 
trw_market, 
market, count(*) from GAS_FORECAST_SATURATION_FINAL
group by cust_market, 
trw_market, 
market ;
/*
Feb 2017:
CUST_MARKET	TRW_MARKET	MARKET	COUNT(*)
	          MFAM	      MFAM	  95684
RESID		                RESID	  266212
RESID	      RESID	      RESID	  2050555
MFAM	      RESID	      MFAM	  8419
	          COML	      COML	  366927
COML		                COML	  95715
	          RESID	      RESID	  4084803
MFAM	      MFAM	      MFAM	  50331
COML	      COML	      COML	  84531
COML	      MFAM	      COML	  6565
COML	      RESID	      COML	  8311
MFAM	      COML	      MFAM	  2190
MFAM		                MFAM	  13218
RESID	      MFAM	      RESID	  7671
RESID	      COML	      RESID	  28029

Mar 2016:
CUST_MARKET	TRW_MARKET	MARKET	COUNT(*)
	          MFAM	      MFAM	  93838
RESID		                RESID	  268424
RESID	      RESID	      RESID	  2036391
MFAM	      RESID	      MFAM	  8132
	          COML	      COML	  410589
COML	                  COML	  93568
	          RESID	      RESID	  4070809
MFAM	      MFAM	      MFAM	  49159
COML	      COML	      COML	  86468
COML	      MFAM	      COML	  6375
COML	      RESID	      COML	  7925
MFAM	      COML	      MFAM	  2184
MFAM		                MFAM	  13000
RESID	      MFAM	      RESID	  7521
RESID	      COML	      RESID	  28617

Apr 2015:
CUST_MARKET	TRW_MARKET	MARKET	COUNT(*)
	          MFAM	      MFAM	  94269
RESID		                RESID	  270137
RESID	      RESID	      RESID	  2013974
MFAM	      RESID	      MFAM	  7710
	          COML	      COML	  412290
COML		                COML	  91517
	          RESID	      RESID	  4064908
MFAM	      MFAM	      MFAM	  51098
COML	      COML	      COML	  84954
COML	      MFAM	      COML	  6279
COML	      RESID	      COML	  7955
MFAM	      COML	      MFAM	  2177
MFAM		                MFAM	  12972
RESID	      MFAM	      RESID	  7242
RESID	      COML	      RESID	  29265

Apr 2014:
CUST_MARKET	TRW_MARKET	MARKET	COUNT(*)
	          RESID	      RESID	  4321152
MFAM		                MFAM	    13713
COML	      COML	      COML	    85751
COML		                COML	   102677
RESID		                RESID	   283906
MFAM	      MFAM	      MFAM	    54551
COML	      MFAM	      COML	     5889
RESID	      RESID       RESID	  2038776
RESID	      COML	      RESID	    33142
RESID	      MFAM	      RESID	     6808
MFAM	      RESID	      MFAM	     7585
COML	      RESID	      COML	     8829
	          COML	      COML	   542245
	          MFAM	      MFAM	    98563
MFAM	      COML	      MFAM	     2035
*/


/* Eliminate any TRW only records that are in the gas_forecast_trw_extras file. 
These records should not be considered pure prospects because they matched to CRIS
under a secondary address on the CRIS system */
delete from GAS_FORECAST_SATURATION_FINAL t
where exists(select *
from mi_cris_prod.BUILDING_FACE a
join gas_forecast_trw_extras b
on a.key_bld_face = b.key_bld_face
and a.key_prem = b.key_prem
where a.adr_std_hse_nbr    = t.sitehsenumb
and a.adr_std_hse_alpha = t.sitehsealph
and a.adr_std_pre_dir   = t.sitestrprfx 
and a.adr_std_str_nm    = t.sitestrname
and a.adr_std_str_sfx   = t.sitestrsfx1  
and a.adr_std_sfx_dir   = t.sitestrsfx2
and a.adr_std_zip       = t.sitezip5
and b.trw_match = 1
)
and t.match = 'TRW';
/* 
636 deleted Feb 2017
631 deleted Mar 2016
627 deleted Apr 2015
630 deleted Apr 2014
605 deleted May 2013
642 deleted */


/* Update the market - set it to MFAM if TRW_MARKET = MFAM and CUST_MARKET = RESID */
update GAS_FORECAST_SATURATION_FINAL 
set market = 'MFAM'
where CUST_MARKET = 'RESID'
and TRW_MARKET = 'MFAM';
/* 
7671 updated Feb 2017
7521 updated Mar 2016
7242 updated Apr 2015
6808 updated Apr 2014
6371 updated May 2013
6829 updated */

/* create 2 summary files to join to prospects to determine rate */
/* 1 for the TRW only, and the Customer/TRW matched Low use records and pure prospects 
use the TRW_numunits_group and the sqr_ft_group with the county use number */
create table GAS_FORECAST_TRW_HT_Rate_Match as
select sitezip5,
txt_county_use1_trw,
sqr_ft_group, 
TRW_numunits_group,
cde_rte,
count(*) as rte_cnt
from GAS_FORECAST_SATURATION_FINAL
where match = 'BOTH'
and service = 'HEATING'
group by sitezip5,
txt_county_use1_trw,
sqr_ft_group, 
TRW_numunits_group,
cde_rte
order by sitezip5,
txt_county_use1_trw,
sqr_ft_group, 
TRW_numunits_group,
count(*) desc;

select count(*) from GAS_FORECAST_TRW_HT_Rate_Match;
/* 
104044 Feb 2017
105343 Mar 2016
104045 Apr 2015
103601 Apr 2014
94936 May 2013
95749 */

select * from GAS_FORECAST_TRW_HT_Rate_Match
where txt_county_use1_trw = '903';

create index idx_GAS_FCST_TRW_HT_Rate_Match on GAS_FORECAST_TRW_HT_Rate_Match(sitezip5,
txt_county_use1_trw,
sqr_ft_group, 
TRW_numunits_group);


/* remove duplicates keeping the largest rate quantity as the rate to go with */
delete from GAS_FORECAST_TRW_HT_Rate_Match a
where rowid > any(select rowid from GAS_FORECAST_TRW_HT_Rate_Match b
where a.sitezip5 = b.sitezip5
and a.txt_county_use1_trw = b.txt_county_use1_trw
and a.sqr_ft_group = b.sqr_ft_group
and a.trw_numunits_group = b.TRW_numunits_group)
;
/* 
36,881 Feb 2017
37,497 deleted Mar 2016
36,942 deleted Apr 2015
37,275 deleted Apr 2014
35,346 deleted */

select count(*) from GAS_FORECAST_TRW_HT_Rate_Match;
/* 
67163 Feb 2017
67846 Mar 2016
67103 Apr 2015
66326 Apr 2014
*/


/* 2 for the Customer only matched Low use records use the Cust_numunits_group and the market
with the county use number */
create table GAS_FORECAST_CUST_HT_Rate_Mtch as
select sitezip5,
market,
Cust_numunits_group,
cde_rte,
count(*) as rte_cnt
from GAS_FORECAST_SATURATION_FINAL
where match = 'CUST'
and service = 'HEATING'
group by sitezip5,
market,
Cust_numunits_group,
cde_rte
order by sitezip5,
market,
Cust_numunits_group,
count(*) desc;

select count(*) from GAS_FORECAST_CUST_HT_Rate_Mtch;
/* 
Feb 2017 - 8917
Mar 2016 - 8692
Apr 2015 - 5830
Apr 2014 - 9145
8,774 */

select * from GAS_FORECAST_CUST_HT_Rate_Mtch;

create index idx_GAS_FCST_CUST_HT_Rate_Mtch 
on GAS_FORECAST_CUST_HT_Rate_Mtch(sitezip5, market, Cust_numunits_group);


/* remove duplicates keeping the largest rate quantity as the rate to go with */
delete from GAS_FORECAST_CUST_HT_Rate_Mtch a
where rowid > any(select rowid from GAS_FORECAST_CUST_HT_Rate_Mtch b
where a.sitezip5 = b.sitezip5
and a.market = b.market
and a.Cust_numunits_group = b.Cust_numunits_group)
;
/* 
5006 Feb 2017
4819 deleted Mar 2016
3694 deleted Apr 2015
5025 deleted Apr 2014
4679 deleted May 2013
4,541 deleted */

select count(*) from GAS_FORECAST_CUST_HT_Rate_Mtch;
/* 
3911 Feb 2017
3873 Mar 2016
2136 Apr 2015
4120 Apr 2014
4095 May 2013
4,060 */



/* join both the low use prospects and the TRW prospects to the above 2 files to determine rate for each prospect */

select count(*) from GAS_FORECAST_SATURATION_FINAL
where (service is null or service not in ('HEATING'));
/* 
4807644 Feb 2017
4860132 Mar 2016
4874706 Apr 2015
4906559 Apr 2014
*/

/* Add a column for the potential heating rate for prospects */
alter table GAS_FORECAST_SATURATION_FINAL
add(Pros_Heat_Rate VARCHAR2(40));

/* initialize the field to a blank */
update GAS_FORECAST_SATURATION_FINAL a
set Pros_Heat_Rate = ' ';

/* Update for all customer records that are Non-Heat matched to TRW and any Pure Prospects */
update GAS_FORECAST_SATURATION_FINAL a
set Pros_Heat_Rate = (select cde_rte
from gas_forecast_trw_ht_rate_match b
where a.sitezip5 = b.sitezip5
and a.txt_county_use1_trw = b.txt_county_use1_trw
and a.sqr_ft_group = b.sqr_ft_group
and a.trw_numunits_group = b.trw_numunits_group)
where match in('BOTH', 'TRW')
and (service is null or service = 'NONHEAT')
and exists(select *
from gas_forecast_trw_ht_rate_match b
where a.sitezip5 = b.sitezip5
and a.txt_county_use1_trw = b.txt_county_use1_trw
and a.sqr_ft_group = b.sqr_ft_group
and a.trw_numunits_group = b.trw_numunits_group);
/* 
1,254,600 Feb 2017
1,287,375 Mar 2016
1,308,489 Apr 2015
1,445,631 Apr 2014
1,460,206 May 2013
1,462,786 records updated */

/* Update for all customer records that are Non-Heat not matched to TRW */
update GAS_FORECAST_SATURATION_FINAL a
set Pros_Heat_Rate = (select cde_rte
from gas_forecast_cust_ht_rate_mtch b
where a.sitezip5 = b.sitezip5
and a.market = b.market
and a.cust_numunits_group = b.cust_numunits_group)
where match = 'CUST'
and service = 'NONHEAT'
and exists(select *
from gas_forecast_cust_ht_rate_mtch b
where a.sitezip5 = b.sitezip5
and a.market = b.market
and a.cust_numunits_group = b.cust_numunits_group);
/* 
60,683 Feb 2017
62,093 Mar 2016
63,883 Apr 2015
70,291 Apr 2014
*/

select count(*) from GAS_FORECAST_SATURATION_FINAL
where (service is null or service = 'NONHEAT')
and (Pros_Heat_Rate = ' ' or Pros_Heat_Rate is null);
/* 
3,492,361 Feb 2017
3,510,664 Mar 2016
3,502,334 Apr 2015
3,769,408 Apr 2014
*/


/* Go down to a less stringent match - county  */

/* Add columns for county and state fips */
alter table GAS_FORECAST_SATURATION_FINAL
add(county_name varchar2(14), state_fips varchar2(2), county_fips VARCHAR2(5));

update GAS_FORECAST_SATURATION_FINAL a
set (county_name, state_fips, county_fips) = 
(select county_name, state_fips, county_fips 
from zips_franchise_gas_forecast z
where a.sitezip5 = z.zip5);

select * from GAS_FORECAST_SATURATION_FINAL;


/* create 2 summary files on county/region to join to prospects to determine rate */
/* 1 for the TRW only, and the Customer/TRW matched Low use records and pure prospects 
use the TRW_numunits_group and the sqr_ft_group with the county use number */
create table GAS_FORECAST_TRW_Rt_Mtch_cnty as
select region,
county_fips,
txt_county_use1_trw,
sqr_ft_group, 
TRW_numunits_group,
cde_rte,
count(*) as rte_cnt
from GAS_FORECAST_SATURATION_FINAL
where match = 'BOTH'
and service = 'HEATING'
group by region,
county_fips,
txt_county_use1_trw,
sqr_ft_group, 
TRW_numunits_group,
cde_rte
order by region,
county_fips,
txt_county_use1_trw,
sqr_ft_group, 
TRW_numunits_group,
count(*) desc;

select count(*) from GAS_FORECAST_TRW_Rt_Mtch_cnty;
/* 
31,578 Feb 2017
32,138 Mar 2016
31,731 Apr 2015
31,949 Apr 2014
28,685 May 2013
29,642 */

create index idx_GAS_FCST_TRW_Rt_Mtch_cnty on GAS_FORECAST_TRW_Rt_Mtch_cnty(region,
county_fips, txt_county_use1_trw, sqr_ft_group, TRW_numunits_group);

/* remove duplicates keeping the largest rate quantity as the rate to go with */
delete from GAS_FORECAST_TRW_Rt_Mtch_cnty a
where rowid > any(select rowid from GAS_FORECAST_TRW_Rt_Mtch_cnty b
where a.region              = b.region             
and   a.county_fips         = b.county_fips        
and   a.txt_county_use1_trw = b.txt_county_use1_trw
and   a.sqr_ft_group        = b.sqr_ft_group       
and   a.TRW_numunits_group  = b.TRW_numunits_group);
/* 
15,905 Feb 2017
16,234 Mar 2016
16,128 Apr 2015
16,339 Apr 2014
*/

select count(*) from GAS_FORECAST_TRW_Rt_Mtch_cnty;
/* 
15,673 Feb 2017
15,904 Mar 2016
15,603 Apr 2015
15,610 Apr 2014
*/


/* 2 for the Customer only matched Low use records use the Cust_numunits_group and the market
with the county use number */
create table GAS_FORECAST_CUST_Rt_Mtch_cnty as
select region,
county_fips,
market,
Cust_numunits_group,
cde_rte,
count(*) as rte_cnt
from GAS_FORECAST_SATURATION_FINAL
where match = 'CUST'
and service = 'HEATING'
group by region,
county_fips,
market,
Cust_numunits_group,
cde_rte
order by region,
county_fips,
market,
Cust_numunits_group,
count(*) desc;

select count(*) from GAS_FORECAST_CUST_Rt_Mtch_cnty;
/* 
971 Feb 2017
965 Mar 2016
512 Apr 2015
1,087 Apr 2014
1,054 May 2013
1,042 */

create index idx_GAS_FCST_CUST_Rt_Mtch_cnty
on GAS_FORECAST_CUST_Rt_Mtch_cnty(region, county_fips, market, Cust_numunits_group);


/* remove duplicates keeping the largest rate quantity as the rate to go with */
delete from GAS_FORECAST_CUST_Rt_Mtch_cnty a
where rowid > any(select rowid from GAS_FORECAST_CUST_Rt_Mtch_cnty b
where a.region              = b.region
and   a.county_fips         = b.county_fips
and   a.market              = b.market
and   a.Cust_numunits_group = b.Cust_numunits_group);
/* 
673 Feb 2017
670 Mar 2016
382 Apr 2015
743 Apr 2014
*/

select count(*) from GAS_FORECAST_CUST_Rt_Mtch_cnty;
/* 
298 Feb 2017
295 Mar 2016
130 Apr 2015
344 Apr 2014
*/


/* Update for all customer records that are Non-Heat matched to TRW and any Pure Prospects */
update GAS_FORECAST_SATURATION_FINAL a
set Pros_Heat_Rate = (select cde_rte
from GAS_FORECAST_TRW_Rt_Mtch_cnty b
where a.region = b.region
and a.county_fips = b.county_fips
and a.txt_county_use1_trw = b.txt_county_use1_trw
and a.sqr_ft_group = b.sqr_ft_group
and a.trw_numunits_group = b.trw_numunits_group)
where match in('BOTH', 'TRW')
and (service is null or service = 'NONHEAT')
and (Pros_Heat_Rate = ' ' or Pros_Heat_Rate is null)
and exists(select *
from GAS_FORECAST_TRW_Rt_Mtch_cnty b
where a.region = b.region
and a.county_fips = b.county_fips
and a.txt_county_use1_trw = b.txt_county_use1_trw
and a.sqr_ft_group = b.sqr_ft_group
and a.trw_numunits_group = b.trw_numunits_group);
/* 
890,939 Feb 2017
1,084,597 Mar 2016
  905,186 Apr 2015
1,052,475 Apr 2014
1,035,868 May 2013
1,009,499  records updated */

/* Update for all customer records that are Non-Heat not matched to TRW */
update GAS_FORECAST_SATURATION_FINAL a
set Pros_Heat_Rate = (select cde_rte
from GAS_FORECAST_CUST_Rt_Mtch_cnty b
where a.region = b.region
and a.county_fips = b.county_fips
and a.market = b.market
and a.cust_numunits_group = b.cust_numunits_group)
where match = 'CUST'
and service = 'NONHEAT'
and (Pros_Heat_Rate = ' ' or Pros_Heat_Rate is null)
and exists(select *
from GAS_FORECAST_CUST_Rt_Mtch_cnty b
where a.region = b.region
and a.county_fips = b.county_fips
and a.market = b.market
and a.cust_numunits_group = b.cust_numunits_group);
/* 
116 Feb 2017
108 Mar 2016
36 Apr 2015
149 Apr 2014
142 May 2013
165 updated */

select count(*) from GAS_FORECAST_SATURATION_FINAL
where (service is null or service = 'NONHEAT')
and (Pros_Heat_Rate = ' ' or Pros_Heat_Rate is null);
/* 
2,601,306 Feb 2017
2,425,959 Mar 2016
2,597,112 Apr 2015
2,716,784 Apr 2014
*/

select * from GAS_FORECAST_SATURATION_FINAL
where (service is null or service = 'NONHEAT')
and (Pros_Heat_Rate = ' ' or Pros_Heat_Rate is null);


select * from GAS_FORECAST_SATURATION_FINAL
where match = 'CUST'
and service = 'NONHEAT'
and (Pros_Heat_Rate = ' ' or Pros_Heat_Rate is null);
/* 
7 Feb 2017
7 Mar 2016
6 Apr 2015
8 Apr 2014
6 May 2013
5 records */


/* Update the few remaining low use customer only records with the rates that were most often used */
create table GAS_FORECAST_CUST_Rt_Mtch2 as
select a.region, a.cde_rte, a.Pros_Heat_Rate, count(*) as rte_cnt from GAS_FORECAST_SATURATION_FINAL a
where exists(select * from GAS_FORECAST_SATURATION_FINAL b
where a.region = b.region
and a.cde_rte = b.cde_rte
and b.match = 'CUST'
and b.service = 'NONHEAT')
and match = 'CUST'
and service = 'NONHEAT'
and not(Pros_Heat_Rate = ' ' or Pros_Heat_Rate is null)
group by a.region, a.cde_rte, a.Pros_Heat_Rate
order by a.region, a.cde_rte, count(*) desc;

select * from GAS_FORECAST_CUST_Rt_Mtch2;

delete from GAS_FORECAST_CUST_Rt_Mtch2 a
where rowid > any(select rowid from GAS_FORECAST_CUST_Rt_Mtch2 b
where a.region = b.region
and a.cde_rte = b.cde_rte);
/* 
86 Feb 2017
92 Mar 2016
59 Apr 2015
102 Apr 2014
98 May 2013
92 deleted */

select * from GAS_FORECAST_CUST_Rt_Mtch2;


update GAS_FORECAST_SATURATION_FINAL a
set Pros_Heat_Rate = (select Pros_Heat_Rate
from GAS_FORECAST_CUST_Rt_Mtch2 b
where a.region = b.region
and a.cde_rte = b.cde_rte)
where match = 'CUST'
and service = 'NONHEAT'
and (Pros_Heat_Rate = ' ' or Pros_Heat_Rate is null)
and exists(select *
from GAS_FORECAST_CUST_Rt_Mtch2 b
where a.region = b.region
and a.cde_rte = b.cde_rte);
/* 
7 updated Feb 2017
7 updated Mar 2016
6 updated Apr 2015
8 updated Apr 2014
*/

select * from GAS_FORECAST_SATURATION_FINAL
where match = 'CUST'
and service = 'NONHEAT'
and (Pros_Heat_Rate = ' ' or Pros_Heat_Rate is null);
/* 0 records */

/* create a summary file on county/region to join to prospects to determine rate */
/* 1 for the TRW only, and the Customer/TRW matched Low use records and pure prospects 
use the sqr_ft_group with the county use number */
create table GAS_FORECAST_TRW_Rt_Mtch_cnty2 as
select region,
county_fips,
txt_county_use1_trw,
sqr_ft_group, 
cde_rte,
count(*) as rte_cnt
from GAS_FORECAST_SATURATION_FINAL
where match = 'BOTH'
and service = 'HEATING'
group by region,
county_fips,
txt_county_use1_trw,
sqr_ft_group,
cde_rte
order by region,
county_fips,
txt_county_use1_trw,
sqr_ft_group,
count(*) desc;

select count(*) from GAS_FORECAST_TRW_Rt_Mtch_cnty2;
/* 
26,372 Feb 2017
26,867 Mar 2016
26,510 Apr 2015
26,812 Apr 2014
25,379 May 2013
26,164   23,891 */

create index idx_GAS_FCST_TRW_Rt_Mtch_cnty2 on GAS_FORECAST_TRW_Rt_Mtch_cnty2(region,
county_fips, txt_county_use1_trw, sqr_ft_group);


/* remove duplicates keeping the largest rate quantity as the rate to go with */
delete from GAS_FORECAST_TRW_Rt_Mtch_cnty2 a
where rowid > any(select rowid from GAS_FORECAST_TRW_Rt_Mtch_cnty2 b
where a.region              = b.region             
and   a.county_fips         = b.county_fips        
and   a.txt_county_use1_trw = b.txt_county_use1_trw
and   a.sqr_ft_group        = b.sqr_ft_group);
/* 
14,333 Feb 2017
14,653 Mar 2016
14,533 Apr 2015
14,744 Apr 2014
13,916 May 2013
14,024  13,042 deleted */

select count(*) from GAS_FORECAST_TRW_Rt_Mtch_cnty2;
/* 
12,039 Feb 2017
12,214 Mar 2016
11,977 Apr 2015
12,068 Apr 2014
11,463 May 2013
12140  10,849 */


/* Update for all customer records that are Non-Heat matched to TRW and any Pure Prospects */
update GAS_FORECAST_SATURATION_FINAL a
set Pros_Heat_Rate = (select cde_rte
from GAS_FORECAST_TRW_Rt_Mtch_cnty2 b
where a.region = b.region
and a.county_fips = b.county_fips
and a.txt_county_use1_trw = b.txt_county_use1_trw
and a.sqr_ft_group = b.sqr_ft_group)
where match in('BOTH', 'TRW')
and (service is null or service = 'NONHEAT')
and (Pros_Heat_Rate = ' ' or Pros_Heat_Rate is null)
and exists(select *
from GAS_FORECAST_TRW_Rt_Mtch_cnty2 b
where a.region = b.region
and a.county_fips = b.county_fips
and a.txt_county_use1_trw = b.txt_county_use1_trw
and a.sqr_ft_group = b.sqr_ft_group);
/* 
7,113 Feb 2017
7,886 Mar 2016
9,773 Apr 2015
11,261 Apr 2014
9,700 May 2013
9,260  6,287 records updated */


/* create a summary file on county/region to join to prospects to determine rate */
/* 1 for the TRW only, and the Customer/TRW matched Low use records and pure prospects 
use only the county use number */
create table GAS_FORECAST_TRW_Rt_Mtch_cnty3 as
select region,
county_fips,
txt_county_use1_trw,
cde_rte,
count(*) as rte_cnt
from GAS_FORECAST_SATURATION_FINAL
where match = 'BOTH'
and service = 'HEATING'
group by region,
county_fips,
txt_county_use1_trw,
cde_rte
order by region,
county_fips,
txt_county_use1_trw,
count(*) desc;

select count(*) from GAS_FORECAST_TRW_Rt_Mtch_cnty3;
/* 
10,529 Feb 2017
10,763 Mar 2016
10,612 Apr 2015
11,323 Apr 2014
10,923 May 2013
10,901   9,684 */

create index idx_GAS_FCST_TRW_Rt_Mtch_cnty3 on GAS_FORECAST_TRW_Rt_Mtch_cnty3(region,
county_fips, txt_county_use1_trw);


/* remove duplicates keeping the largest rate quantity as the rate to go with */
delete from GAS_FORECAST_TRW_Rt_Mtch_cnty3 a
where rowid > any(select rowid from GAS_FORECAST_TRW_Rt_Mtch_cnty3 b
where a.region              = b.region             
and   a.county_fips         = b.county_fips        
and   a.txt_county_use1_trw = b.txt_county_use1_trw);
/* 
7,098 Feb 2017
7,255 Mar 2016
7,156 Apr 2015
7,523 Apr 2014
7,212 May 2013
7,172   6,507 deleted */

select count(*) from GAS_FORECAST_TRW_Rt_Mtch_cnty3;
/* 
3,431 Feb 2017
3,508 Mar 2016
3,456 Apr 2015
3,800 Apr 2014
3,711 May 2013
3,729  3,177 */


/* Update for all customer records that are Non-Heat matched to TRW and any Pure Prospects */
update GAS_FORECAST_SATURATION_FINAL a
set Pros_Heat_Rate = (select cde_rte
from GAS_FORECAST_TRW_Rt_Mtch_cnty3 b
where a.region = b.region
and a.county_fips = b.county_fips
and a.txt_county_use1_trw = b.txt_county_use1_trw)
where match in('BOTH', 'TRW')
and (service is null or service = 'NONHEAT')
and (Pros_Heat_Rate = ' ' or Pros_Heat_Rate is null)
and exists(select *
from GAS_FORECAST_TRW_Rt_Mtch_cnty3 b
where a.region = b.region
and a.county_fips = b.county_fips
and a.txt_county_use1_trw = b.txt_county_use1_trw);
/* 
33,622 Feb 2017
88,918 Mar 2016
33,302 Apr 2015
25,180 Apr 2014
*/

select count(*) from GAS_FORECAST_SATURATION_FINAL a
where (service is null or service = 'NONHEAT')
and (Pros_Heat_Rate = ' ' or Pros_Heat_Rate is null);
/* 
2,560,564 Feb 2017
2,329,148 Mar 2016
2,554,031 Apr 2015
2,680,335 Apr 2014
1,949,879 May 2013
1,946,518   58,164 */

select * from GAS_FORECAST_SATURATION_FINAL a
where service = 'NONHEAT'
and (Pros_Heat_Rate = ' ' or Pros_Heat_Rate is null);
/* 
104 Feb 2017
99 Mar 2016
119 Apr 2015
147 Apr 2014
remaining */


/* update the last remaining unmatched nonheat records using the file based only on 
   other low use structures and heating rates assigned to them */
update GAS_FORECAST_SATURATION_FINAL a
set Pros_Heat_Rate = (select Pros_Heat_Rate
from GAS_FORECAST_CUST_Rt_Mtch2 b
where a.region = b.region
and a.cde_rte = b.cde_rte)
where service = 'NONHEAT'
and (Pros_Heat_Rate = ' ' or Pros_Heat_Rate is null)
and exists(select *
from GAS_FORECAST_CUST_Rt_Mtch2 b
where a.region = b.region
and a.cde_rte = b.cde_rte);
/* 
100 Feb 2017
96 Mar 2016
118 Apr 2015
147 Apr 2014
136 May 2013
133  100 updated */


select count(*) from GAS_FORECAST_SATURATION_FINAL a
where (service is null or service = 'NONHEAT')
and (Pros_Heat_Rate = ' ' or Pros_Heat_Rate is null);
/* 
2,560,464 Feb 2017
2,329,052 Mar 2016
2,553,913 Apr 2015
2,680,188 Apr 2014
58,164 */

/* Last ditch effort will be by region and county use code only */
create table GAS_FORECAST_TRW_Rt_Mtch_rgn as
select region, TXT_COUNTY_USE1_TRW, PROS_HEAT_RATE, count(*) as rt_cnt
from GAS_FORECAST_SATURATION_FINAL a
where (service is null or service = 'NONHEAT')
and not(Pros_Heat_Rate = ' ' or Pros_Heat_Rate is null)
group by region, TXT_COUNTY_USE1_TRW, PROS_HEAT_RATE
order by region, TXT_COUNTY_USE1_TRW, count(*) desc;

select * from GAS_FORECAST_TRW_Rt_Mtch_rgn;

delete from GAS_FORECAST_TRW_Rt_Mtch_rgn a
where rowid > any(select rowid from GAS_FORECAST_TRW_Rt_Mtch_rgn b
where a.region = b.region
and a.txt_county_use1_trw = b.txt_county_use1_trw);
/* 
1868 Feb 2017
1970 Mar 2016
1942 Apr 2015
2069 Apr 2014
1871 May 2013
1845 */

select * from GAS_FORECAST_TRW_Rt_Mtch_rgn;
/* 
1059 Feb 2017
1077 Mar 2016
1074 Apr 2015
1319 Apr 2014
1164 May 2013
871 */

/* Update for all TRW records that do not have a rate assigned */
update GAS_FORECAST_SATURATION_FINAL a
set Pros_Heat_Rate = (select Pros_Heat_Rate
from GAS_FORECAST_TRW_Rt_Mtch_rgn b
where a.region = b.region
and a.txt_county_use1_trw = b.txt_county_use1_trw)
where match in('BOTH', 'TRW')
and (service is null or service = 'NONHEAT')
and (Pros_Heat_Rate = ' ' or Pros_Heat_Rate is null)
and exists(select *
from GAS_FORECAST_TRW_Rt_Mtch_rgn b
where a.region = b.region
and a.txt_county_use1_trw = b.txt_county_use1_trw);
/* 
2,546,673 Feb 2017
2,315,486 Mar 2016
2,540,467 Apr 2015
2,654,381 Apr 2014 records updated */


select * from GAS_FORECAST_SATURATION_FINAL a
where (service is null or service = 'NONHEAT')
and (Pros_Heat_Rate = ' ' or Pros_Heat_Rate is null);
/* 
?Feb 2017
Mar 2016 - 13,566
Apr 2015 - 13,446
Apr 2014 - 25,807 */

select a.region, 
a.txt_county_use1_trw,
b.description as cnty_use_desc, 
b.market,
count(*) as numrecs
from GAS_FORECAST_SATURATION_FINAL a
join cpalmieri.gas_forecast_cntyuse_market b
on a.region = b.region
and a.txt_county_use1_trw = b.county_use_code
where (service is null or service = 'NONHEAT')
and (Pros_Heat_Rate = ' ' or Pros_Heat_Rate is null)
group by a.region, 
a.txt_county_use1_trw,
b.description,
b.market;

/** Start Update HERE ******************************************************/

/* Last Last ditch effort will be by region and substring of county use code only */
create table GAS_FORECAST_TRW_Rt_sub_rgn as
select region, 
case
  when length(TXT_COUNTY_USE1_TRW) >= 3 then substr(TXT_COUNTY_USE1_TRW,1,2)
  when length(TXT_COUNTY_USE1_TRW) = 2 then substr(TXT_COUNTY_USE1_TRW,1,1)
end as cnty_use_sub, 
PROS_HEAT_RATE, 
count(*) as rt_cnt
from GAS_FORECAST_SATURATION_FINAL a
where (service is null or service = 'NONHEAT')
and not(Pros_Heat_Rate = ' ' or Pros_Heat_Rate is null)
group by region, 
case
  when length(TXT_COUNTY_USE1_TRW) >= 3 then substr(TXT_COUNTY_USE1_TRW,1,2)
  when length(TXT_COUNTY_USE1_TRW) = 2 then substr(TXT_COUNTY_USE1_TRW,1,1)
end, PROS_HEAT_RATE
order by region, 
case
  when length(TXT_COUNTY_USE1_TRW) >= 3 then substr(TXT_COUNTY_USE1_TRW,1,2)
  when length(TXT_COUNTY_USE1_TRW) = 2 then substr(TXT_COUNTY_USE1_TRW,1,1)
end, count(*) desc;

select * from GAS_FORECAST_TRW_Rt_sub_rgn;

delete from GAS_FORECAST_TRW_Rt_sub_rgn a
where rowid > any(select rowid from GAS_FORECAST_TRW_Rt_sub_rgn b
where a.region = b.region
and a.cnty_use_sub = b.cnty_use_sub);
/* 
814 Feb 2017
805 Mar 2016
781 Apr 2015
870 Apr 2014
*/


select * from GAS_FORECAST_TRW_Rt_sub_rgn;
/* 
Feb 2017 - 251
Mar 2016 - 251
Apr 2015 - 246
Apr 2014 - 323 */


/* Update for all TRW records that do not have a rate assigned */
update GAS_FORECAST_SATURATION_FINAL a
set Pros_Heat_Rate = (select Pros_Heat_Rate
from GAS_FORECAST_TRW_Rt_sub_rgn b
where a.region = b.region
and (case
  when length(TXT_COUNTY_USE1_TRW) >= 3 then substr(TXT_COUNTY_USE1_TRW,1,2)
  when length(TXT_COUNTY_USE1_TRW) = 2 then substr(TXT_COUNTY_USE1_TRW,1,1)
end) = b.cnty_use_sub)
where match in('BOTH', 'TRW')
and (service is null or service = 'NONHEAT')
and (Pros_Heat_Rate = ' ' or Pros_Heat_Rate is null)
and exists(select *
from GAS_FORECAST_TRW_Rt_sub_rgn b
where a.region = b.region
and (case
  when length(TXT_COUNTY_USE1_TRW) >= 3 then substr(TXT_COUNTY_USE1_TRW,1,2)
  when length(TXT_COUNTY_USE1_TRW) = 2 then substr(TXT_COUNTY_USE1_TRW,1,1)
end) = b.cnty_use_sub);
/* 
9,269 Feb 2017
5,531 Mar 2016
8,728 Apr 2015
16,884 Apr 2014 updated */

select * from GAS_FORECAST_SATURATION_FINAL a
where (service is null or service = 'NONHEAT')
and (Pros_Heat_Rate = ' ' or Pros_Heat_Rate is null);
/* 
?Feb 2017
8,035 Mar 2016
4,718 Apr 2015
8,923 Apr 2014
6,523 May 2013
2,956 remaining */

/* LAST Last Last ditch effort will be by region and Market only */
create table GAS_FORECAST_TRW_Rt_mkt_rgn as
select region, 
market, 
PROS_HEAT_RATE, 
count(*) as rt_cnt
from GAS_FORECAST_SATURATION_FINAL a
where (service is null or service = 'NONHEAT')
and not(Pros_Heat_Rate = ' ' or Pros_Heat_Rate is null)
group by region, market, PROS_HEAT_RATE
order by region, market, count(*) desc;

select * from GAS_FORECAST_TRW_Rt_mkt_rgn;

delete from GAS_FORECAST_TRW_Rt_mkt_rgn a
where rowid > any(select rowid from GAS_FORECAST_TRW_Rt_mkt_rgn b
where a.region = b.region
and a.market = b.market);
/* 
169 Feb 2017
168 Mar 2016
162 Apr 2015
183 Apr 2014
184 May 2013
175 */

select * from GAS_FORECAST_TRW_Rt_mkt_rgn;
/* 
15 Feb 2017
15 Mar 2016
15 Apr 2015
18 Apr 2014
18 May 2013
18 */

/* Update for all TRW records that do not have a rate assigned */
update GAS_FORECAST_SATURATION_FINAL a
set Pros_Heat_Rate = (select Pros_Heat_Rate
from GAS_FORECAST_TRW_Rt_mkt_rgn b
where a.region = b.region
and a.market = b.market)
where match in('BOTH', 'TRW')
and (service is null or service = 'NONHEAT')
and (Pros_Heat_Rate = ' ' or Pros_Heat_Rate is null)
and exists(select *
from GAS_FORECAST_TRW_Rt_mkt_rgn b
where a.region = b.region
and a.market = b.market);
/* 
4,522 Feb 2017
8,035 Mar 2016
4,718 Apr 2015
8,923 Apr 2014 records updated */

select * from GAS_FORECAST_SATURATION_FINAL a
where (service is null or service = 'NONHEAT')
and (Pros_Heat_Rate = ' ' or Pros_Heat_Rate is null);
/* 
0 Mar 2016
0 Apr 2015
0 Apr 2014
0 May 2013
0 remaining */

/** Start Update of record IDs HERE ******************************************************/

alter table GAS_FORECAST_SATURATION_FINAL
add(record_id numeric(10));

select
sum(count(*))
 from GAS_FORECAST_SATURATION_FINAL b
group by b.sitehsenumb,
b.sitehsealph,
b.sitestrprfx,
b.sitestrname,
b.sitestrsfx1,
b.sitestrsfx2,
b.sitezip5
having count(*)>1;
/* 9551 Feb 2017 
9328 */

drop table temp_fcst_record_id;

/* remove all of the addresses with no street names - these end up as duplicates, and cannot 
be updated with last year's record IDs.  I will give them new record_id for this year's saturation */
create table temp_fcst_record_id as
select * from GAS_FORECAST_SATURATION_FINAL
where sitehsenumb = 0
and sitestrname = ' ';
/* 9513 */

update temp_fcst_record_id set record_id = '';

delete from GAS_FORECAST_SATURATION_FINAL
where sitehsenumb = 0
and sitestrname = ' ';
/* 9728 Feb 2017
9513 deleted */


update GAS_FORECAST_SATURATION_FINAL a
set record_id = (select record_id from GAS_FCST_SAT_FINAL_MAR_2016 b
where a.sitehsenumb = b.sitehsenumb
and a.sitehsealph = b.sitehsealph
and a.sitestrprfx = b.sitestrprfx
and a.sitestrname = b.sitestrname
and a.sitestrsfx1 = b.sitestrsfx1
and a.sitestrsfx2 = b.sitestrsfx2
and a.sitezip5    = b.sitezip5
and b.sitehsenumb <> 0
and b.sitestrname <> ' ');
/* 7,158,797 Feb 2017 - 33 min to run
7,172,856 updated - Mar 2016  about 48 min to run */
commit;

select max(record_id) from GAS_FCST_SAT_FINAL_MAR_2016;
/* 7,337,158 */

select count(*) from GAS_FORECAST_SATURATION_FINAL where record_id is null;
/* 
Feb 2017 - 137,167 - 7,337,158 + 137,167 + 9,728 = 7,484,053 should be the next max
Mar 2016 - 171,525 - 7,156,120 + 171,525 + 9,513 = 7,337,158 should be the next max  */

/* add the records that didn't match a record_id from last saturation to the temporary table to get an ID */
insert into temp_fcst_record_id 
select * from GAS_FORECAST_SATURATION_FINAL 
where record_id is null;

select count(*) from temp_fcst_record_id;
/* 146895 Feb 2017
181038 */

delete from GAS_FORECAST_SATURATION_FINAL 
where record_id is null;
/* 137,167 Feb 2017
171,525 deleted */

/* add record_ids to the records that did not match last year's saturation or have no street name */
DECLARE
   maxid numeric(10); 
BEGIN
  select max(record_id) into maxid from GAS_FCST_SAT_FINAL_MAR_2016;
   update temp_fcst_record_id
   set record_id = rownum+maxid;
   COMMIT;
END;

select max(record_id) from temp_fcst_record_id;
/* 7484053 */


/* insert those records back into saturation now that they have a record_id */

insert into GAS_FORECAST_SATURATION_FINAL
select * from temp_fcst_record_id;

create index idx_GAS_FORECAST_SAT_FINAL on GAS_FORECAST_SATURATION_FINAL(record_id);

select record_id, count(*)
from GAS_FORECAST_SATURATION_FINAL
group by record_id
having count(*)>1;
/* 0 */

select min(record_id), max(record_id) from GAS_FORECAST_SATURATION_FINAL;
/* 
Feb 2017:
MIN(RECORD_ID)	MAX(RECORD_ID)
1	7484053

MIN(RECORD_ID)	MAX(RECORD_ID)
1	7337158
*/

/* End Update of record IDs HERE ******************************************************/


/* Update the saturation table to reflect any zips that do have customers found, where no customers 
were found previously */
update zips_franchise_gas_forecast
set gas_cust_found = 'Y'
where gas_cust_found = 'N'
and zip5 in(select 
sitezip5
from GAS_FORECAST_SATURATION_FINAL
where gas_cust_found = 'N'
and service is not null);
/* 
Feb 2017 - 5
Mar 2016 - 6
Apr 2015 - 7 */

drop table temp ;

create table temp as
select 
sitezip5, count(*) as struct_count
from GAS_FORECAST_SATURATION_FINAL
where gas_cust_found = 'N'
and service is not null
group by sitezip5;

update GAS_FORECAST_SATURATION_FINAL
set gas_cust_found = 'Y'
where sitezip5 in(select sitezip5 from temp)
and gas_cust_found = 'N';
/* 
Feb 2017 - 4249
Mar 2016 - 16800
Apr 2015 - 30679 */

/*
select * from zips_franchise_gas_forecast
where state_abbrev <> 'NH';
/* 2973 */

/* reset contrained zips before update - From Peter Metzdorff - NY, Stephen Caliri - NE  - May, 2015
update zips_franchise_gas_forecast
set (constrained_zip_commercial, constrained_zip_residential ) = (select 'N', 'N' from dual);


alter table zips_franchise_gas_forecast add(CONSTRAINED_COMMENTS varchar2(40), CONSTRAINED_RULE varchar2(150));

commit;

update zips_franchise_gas_forecast a
set (CONSTRAINED_ZIP_RESIDENTIAL,
CONSTRAINED_ZIP_COMMERCIAL,
CONSTRAINED_COMMENTS,
CONSTRAINED_rule) = (
select 
CONSTRAINED_ZIP_RESIDENTIAL,
CONSTRAINED_ZIP_COMMERCIAL,
COMMENTS,
rule from
(select 
a.zip5,
a.CONSTRAINED_ZIP_RESIDENTIAL,
a.CONSTRAINED_ZIP_COMMERCIAL,
a.COMMENTS,
b.rule
from cpalmieri.NY_Constrained_zips_2016 a
 join cpalmieri.Constrained_Zips_Rules_2016 b
on a.constrained_zip_residential = b.constrained_zip_residential
and a.constrained_zip_commercial = b.constrained_zip_commercial
and a.comments = b.comments
union
select 
a.zip5,
a.CONSTRAINED_ZIP_RESIDENTIAL,
a.CONSTRAINED_ZIP_COMMERCIAL,
a.COMMENTS,
b.rule
from cpalmieri.NE_Constrained_zips_2016 a
 join cpalmieri.Constrained_Zips_Rules_2016 b
on a.constrained_zip_residential = b.constrained_zip_residential
and a.constrained_zip_commercial = b.constrained_zip_commercial
and a.comments = b.comments) b2
where a.zip5 = b2.zip5)
where exists(select * from 
(select 
a.zip5,
a.CONSTRAINED_ZIP_RESIDENTIAL,
a.CONSTRAINED_ZIP_COMMERCIAL,
a.COMMENTS,
b.rule
from cpalmieri.NY_Constrained_zips_2016 a
 join cpalmieri.Constrained_Zips_Rules_2016 b
on a.constrained_zip_residential = b.constrained_zip_residential
and a.constrained_zip_commercial = b.constrained_zip_commercial
and a.comments = b.comments
union
select 
a.zip5,
a.CONSTRAINED_ZIP_RESIDENTIAL,
a.CONSTRAINED_ZIP_COMMERCIAL,
a.COMMENTS,
b.rule
from cpalmieri.NE_Constrained_zips_2016 a
 join cpalmieri.Constrained_Zips_Rules_2016 b
on a.constrained_zip_residential = b.constrained_zip_residential
and a.constrained_zip_commercial = b.constrained_zip_commercial
and a.comments = b.comments) b3
where a.zip5 = b3.zip5)
;


*/



/** Add 5 fields that will depict mixed use:
Resi_flag
Comm_flag
Multi_flag
Condo_flag
Mixed_use_Flag
*/

alter table GAS_FORECAST_SATURATION_FINAL
add(Resi_flag numeric(4), Comm_flag numeric(4), Multi_flag numeric(4), Condo_flag numeric(4), Mixed_use_Flag numeric(4));

/** Initialize the fields to zero **/
update GAS_FORECAST_SATURATION_FINAL
set 
Resi_flag      = 0,
Comm_flag      = 0,
Multi_flag     = 0,
Condo_flag     = 0,
Mixed_use_Flag = 0
;


create index idx_FORECAST_COMM_TC1       on cpalmieri.GAS_FORECAST_COMM_TC1      (sitehsenumb, sitehsealph, sitestrprfx, sitestrname, sitestrsfx1, sitestrsfx2, sitezip5);
create index idx_FORECAST_MF_HEAT1       on cpalmieri.GAS_FORECAST_MF_HEAT1      (sitehsenumb, sitehsealph, sitestrprfx, sitestrname, sitestrsfx1, sitestrsfx2, sitezip5);
create index idx_FORECAST_RESID_HEAT1    on cpalmieri.GAS_FORECAST_RESID_HEAT1   (sitehsenumb, sitehsealph, sitestrprfx, sitestrname, sitestrsfx1, sitestrsfx2, sitezip5);
create index idx_FORECAST_COML_HEAT1     on cpalmieri.GAS_FORECAST_COML_HEAT1    (sitehsenumb, sitehsealph, sitestrprfx, sitestrname, sitestrsfx1, sitestrsfx2, sitezip5);
create index idx_FORECAST_MF_NONHEAT1    on cpalmieri.GAS_FORECAST_MF_NONHEAT1   (sitehsenumb, sitehsealph, sitestrprfx, sitestrname, sitestrsfx1, sitestrsfx2, sitezip5);
create index idx_FORECAST_RESID_NONHEAT1 on cpalmieri.GAS_FORECAST_RESID_NONHEAT1(sitehsenumb, sitehsealph, sitestrprfx, sitestrname, sitestrsfx1, sitestrsfx2, sitezip5);
create index idx_FORECAST_COML_NONHEAT1  on cpalmieri.GAS_FORECAST_COML_NONHEAT1 (sitehsenumb, sitehsealph, sitestrprfx, sitestrname, sitestrsfx1, sitestrsfx2, sitezip5);

create index idx_gas_fcst_Resi_TRW_Strct  on cpalmieri.gas_forecast_Resi_TRW_Strct (adr_situs_hse_num_trw, adr_situs_hse_alpha_trw, adr_situs_str_prfx_trw, adr_situs_str_nme_trw, adr_situs_str_sufx1_trw, adr_situs_str_sufx2_trw, adr_situs_zip_trw);
create index idx_gas_fcst_Comm_TRW_Strct  on cpalmieri.gas_forecast_Comm_TRW_Strct (adr_situs_hse_num_trw, adr_situs_hse_alpha_trw, adr_situs_str_prfx_trw, adr_situs_str_nme_trw, adr_situs_str_sufx1_trw, adr_situs_str_sufx2_trw, adr_situs_zip_trw);
create index idx_gas_fcst_MFAM_TRW_Strct  on cpalmieri.gas_forecast_MFAM_TRW_Strct (adr_situs_hse_num_trw, adr_situs_hse_alpha_trw, adr_situs_str_prfx_trw, adr_situs_str_nme_trw, adr_situs_str_sufx1_trw, adr_situs_str_sufx2_trw, adr_situs_zip_trw);
create index idx_gas_fcst_CONDO_TRW_Strct on cpalmieri.gas_forecast_CONDO_TRW_Strct(adr_situs_hse_num_trw, adr_situs_hse_alpha_trw, adr_situs_str_prfx_trw, adr_situs_str_nme_trw, adr_situs_str_sufx1_trw, adr_situs_str_sufx2_trw, adr_situs_zip_trw);

/* Set the flags based on matches to the files broken down by market */
update GAS_FORECAST_SATURATION_FINAL a
set 
Resi_flag = case
                   when exists(select * from cpalmieri.GAS_FORECAST_RESID_HEAT1 c
																where a.sitehsenumb = c.sitehsenumb
																	and a.sitehsealph = c.sitehsealph
																	and a.sitestrprfx = c.sitestrprfx
																	and a.sitestrname = c.sitestrname
																	and a.sitestrsfx1 = c.sitestrsfx1
																	and a.sitestrsfx2 = c.sitestrsfx2
																	and a.sitezip5    = c.sitezip5) then 1
                   when exists(select * from cpalmieri.GAS_FORECAST_RESID_NONHEAT1 d
																where a.sitehsenumb = d.sitehsenumb
																	and a.sitehsealph = d.sitehsealph
																	and a.sitestrprfx = d.sitestrprfx
																	and a.sitestrname = d.sitestrname
																	and a.sitestrsfx1 = d.sitestrsfx1
																	and a.sitestrsfx2 = d.sitestrsfx2
																	and a.sitezip5    = d.sitezip5) then 1
                   when exists(select * from cpalmieri.gas_forecast_Resi_TRW_Strct e
																where a.sitehsenumb = e.adr_situs_hse_num_trw     
																	and a.sitehsealph = e.adr_situs_hse_alpha_trw
																	and a.sitestrprfx = e.adr_situs_str_prfx_trw    
																	and a.sitestrname = e.adr_situs_str_nme_trw     
																	and a.sitestrsfx1 = e.adr_situs_str_sufx1_trw
																	and a.sitestrsfx2 = e.adr_situs_str_sufx2_trw
																	and a.sitezip5    = e.adr_situs_zip_trw) then 1
                   else 0
            end,
Comm_flag = case
                   when exists(select * from cpalmieri.GAS_FORECAST_COMM_TC1 f
																where a.sitehsenumb = f.sitehsenumb
																	and a.sitehsealph = f.sitehsealph
																	and a.sitestrprfx = f.sitestrprfx
																	and a.sitestrname = f.sitestrname
																	and a.sitestrsfx1 = f.sitestrsfx1
																	and a.sitestrsfx2 = f.sitestrsfx2
																	and a.sitezip5    = f.sitezip5) then 1
                   when exists(select * from cpalmieri.GAS_FORECAST_COML_HEAT1 g
																where a.sitehsenumb = g.sitehsenumb
																	and a.sitehsealph = g.sitehsealph
																	and a.sitestrprfx = g.sitestrprfx
																	and a.sitestrname = g.sitestrname
																	and a.sitestrsfx1 = g.sitestrsfx1
																	and a.sitestrsfx2 = g.sitestrsfx2
																	and a.sitezip5    = g.sitezip5) then 1
                   when exists(select * from cpalmieri.GAS_FORECAST_COML_NONHEAT1 h
																where a.sitehsenumb = h.sitehsenumb
																	and a.sitehsealph = h.sitehsealph
																	and a.sitestrprfx = h.sitestrprfx
																	and a.sitestrname = h.sitestrname
																	and a.sitestrsfx1 = h.sitestrsfx1
																	and a.sitestrsfx2 = h.sitestrsfx2
																	and a.sitezip5    = h.sitezip5) then 1
                   when exists(select * from cpalmieri.gas_forecast_Comm_TRW_Strct i
																where a.sitehsenumb = i.adr_situs_hse_num_trw     
																	and a.sitehsealph = i.adr_situs_hse_alpha_trw
																	and a.sitestrprfx = i.adr_situs_str_prfx_trw    
																	and a.sitestrname = i.adr_situs_str_nme_trw     
																	and a.sitestrsfx1 = i.adr_situs_str_sufx1_trw
																	and a.sitestrsfx2 = i.adr_situs_str_sufx2_trw
																	and a.sitezip5    = i.adr_situs_zip_trw) then 1
                   else 0
            end,
Multi_flag = case
                   when exists(select * from cpalmieri.GAS_FORECAST_MF_HEAT1 j
																where a.sitehsenumb = j.sitehsenumb
																	and a.sitehsealph = j.sitehsealph
																	and a.sitestrprfx = j.sitestrprfx
																	and a.sitestrname = j.sitestrname
																	and a.sitestrsfx1 = j.sitestrsfx1
																	and a.sitestrsfx2 = j.sitestrsfx2
																	and a.sitezip5    = j.sitezip5) then 1
                   when exists(select * from cpalmieri.GAS_FORECAST_MF_NONHEAT1 k
																where a.sitehsenumb = k.sitehsenumb
																	and a.sitehsealph = k.sitehsealph
																	and a.sitestrprfx = k.sitestrprfx
																	and a.sitestrname = k.sitestrname
																	and a.sitestrsfx1 = k.sitestrsfx1
																	and a.sitestrsfx2 = k.sitestrsfx2
																	and a.sitezip5    = k.sitezip5) then 1
                   when exists(select * from cpalmieri.gas_forecast_MFAM_TRW_Strct l
																where a.sitehsenumb = l.adr_situs_hse_num_trw     
																	and a.sitehsealph = l.adr_situs_hse_alpha_trw
																	and a.sitestrprfx = l.adr_situs_str_prfx_trw    
																	and a.sitestrname = l.adr_situs_str_nme_trw     
																	and a.sitestrsfx1 = l.adr_situs_str_sufx1_trw
																	and a.sitestrsfx2 = l.adr_situs_str_sufx2_trw
																	and a.sitezip5    = l.adr_situs_zip_trw) then 1
                   else 0
            end,
Condo_flag = case
                   when exists(select * from cpalmieri.gas_forecast_CONDO_TRW_Strct m
																where a.sitehsenumb = m.adr_situs_hse_num_trw     
																	and a.sitehsealph = m.adr_situs_hse_alpha_trw
																	and a.sitestrprfx = m.adr_situs_str_prfx_trw    
																	and a.sitestrname = m.adr_situs_str_nme_trw     
																	and a.sitestrsfx1 = m.adr_situs_str_sufx1_trw
																	and a.sitestrsfx2 = m.adr_situs_str_sufx2_trw
																	and a.sitezip5    = m.adr_situs_zip_trw) then 1
                   else 0
            end
;
/* about 27 minutes */

/* Do a final update on the Mixed use depending on the other 4 flags */
update GAS_FORECAST_SATURATION_FINAL
set Mixed_use_Flag = 1
where (Market = 'RESID' and Comm_flag = 1)
or (market = 'MFAM' and Comm_flag = 1)
or (market = 'COML' and (Multi_flag = 1 or Resi_flag = 1 or Condo_flag = 1));
/* 
100,655 Feb 2017
100,222 Mar 2016
110,660 Apr 2015
105,392 Apr 2014
*/


select /*region, sitescr,*/ count(*) from GAS_FORECAST_SATURATION_FINAL
where Resi_flag = 0
and Comm_flag = 0
and Multi_flag = 0
and condo_flag =0
and match = 'TRW'
/*group by region, sitescr*/;
/* 
10172 Feb 2017
11428 Mar 2016
13113 Apr 2015
388397 Apr 2014
*/

select match, market, count(*) from GAS_FORECAST_SATURATION_FINAL
where Resi_flag = 0
and Comm_flag = 0
and Multi_flag = 0
and condo_flag =0
group by match, market;
/* 
10182 Feb 2017
11438 Mar 2016
13124 Apr 2015
389227 Apr 2014
293610 */

select count(*) from GAS_FORECAST_SATURATION_FINAL where match = 'TRW';

select match, market, count(*) from GAS_FORECAST_SATURATION_FINAL
where (Resi_flag = 1
or Comm_flag = 1
or Multi_flag = 1
or condo_flag =1)
and match = 'TRW'
group by match, market;


select region, count(*) from GAS_FORECAST_SATURATION_FINAL where sitescr is null
group by region;

select count(*) from mi_edr_prod.edr_trw t where t.CDE_SITUS_CODE1_SCORE_TRW = ' ';
/* 0 */

grant select on cpalmieri.GAS_FORECAST_SATURATION_FINAL to rbruney, CIAPWRITE, mihnevas, superuser;

/********************************************************************************************************/
/********************************************************************************************************/
/********************************************************************************************************/
/* At this point Saturation is missing Donnelley and Acxiom IDs, Propensities, HEAP flag, and Geocoding */
/********************************************************************************************************/
/********************************************************************************************************/
/********************************************************************************************************/

/* Add Donnelley and Acxiom IDs to the Saturation data */
alter table GAS_FORECAST_SATURATION_FINAL add(DONN_location_id varchar2(12));

create table GAS_FORECAST_Dnnlly_structs2 as
select a.d414_location_id_num as location_id, 
a.d318_own_or_rent_indicator,
cln_hsenumb, 
cln_hsealph, 
cln_strprfx, 
cln_strname, 
cln_strsfx1, 
cln_strsfx2,
cln_adrzip5
from miuser.donnelley_all a
where a.cln_cdescr in('0','1','2','3','4','5','6','7','8')
order by cln_hsenumb, 
cln_hsealph, 
cln_strprfx, 
cln_strname, 
cln_strsfx1, 
cln_strsfx2,
cln_adrzip5,
a.d318_own_or_rent_indicator desc
;

select count(*) from GAS_FORECAST_Dnnlly_structs2;
/* 
Feb 2017 - 6,990,151
Mar 2016 - 6,928,450
Apr 2015 - 7,029,607
7,423,036 */

/* remove duplicate addresses keeping the best match */
delete from GAS_FORECAST_Dnnlly_structs2 a
where rowid > any(select rowid from GAS_FORECAST_Dnnlly_structs2 b
where a.cln_hsenumb = b.cln_hsenumb
and a.cln_hsealph = b.cln_hsealph
and a.cln_strprfx = b.cln_strprfx   
and a.cln_strname = b.cln_strname  
and a.cln_strsfx1 = b.cln_strsfx1   
and a.cln_strsfx2 = b.cln_strsfx2   
and a.cln_adrzip5 = b.cln_adrzip5);
/* 
Feb 2017 - 2,054,107
Mar 2016 - 2,035,001
Apr 2015 - 2,115,071
2,243,325 deleted */

select count(*) from GAS_FORECAST_Dnnlly_structs2;
/* 
Feb 2017 - 4,936,044
Mar 2016 - 4,893,449
Apr 2014 - 4,914,536
5,179,711 */

create index idx_GAS_FORECAST_Dnnlly_strcs2 on GAS_FORECAST_Dnnlly_structs2(cln_hsenumb, 
cln_hsealph, 
cln_strprfx, 
cln_strname, 
cln_strsfx1, 
cln_strsfx2,
cln_adrzip5);

update GAS_FORECAST_SATURATION_FINAL a
set DONN_location_id = (select location_id from GAS_FORECAST_Dnnlly_structs2 b
where a.Sitehsenumb = b.cln_hsenumb
and a.sitehsealph = b.cln_hsealph
and a.Sitestrprfx = b.cln_strprfx   
and a.Sitestrname = b.cln_strname  
and a.Sitestrsfx1 = b.cln_strsfx1   
and a.Sitestrsfx2 = b.cln_strsfx2   
and a.SiteZip5    = b.cln_adrzip5);

select * from GAS_FORECAST_SATURATION_FINAL;

/* Run from here to update Acxiom fields */

/* December 2016 Acxiom Data */
alter table GAS_FORECAST_SATURATION_FINAL add(ACXIOM_zip_dec2016 varchar2(5),
ACXIOM_company_id_dec2016 varchar2(5), ACXIOM_individual_id_dec2016 varchar2(5));

--/*
create table GAS_FORECAST_Acxiom_dec2016 as                                                
select a.company_id as company_id_dec2016, 
a.individual_id as individual_id_dec2016,
b.KEY_ZIP as KEY_ZIP_dec2016,
a.v7606_1, -- owner/renter                                                               
a.v7606_2, -- owner/renter precision level                                            
b.adr_std_hse_num,                                                                         
b.adr_std_hse_alpha,                                                                       
b.adr_std_str_prfx,                                                                        
b.adr_std_str_nme,                                                                         
b.adr_std_str_sfx1,                                                                        
b.adr_std_str_sfx2,                                                                        
b.adr_std_zip                                                                              
from miuser.acxiom_2_dec2016 a                                                             
join miuser.acxiom_adr_dec2016 b                                                           
on a.ZIP = b.KEY_ZIP                                                                       
and a.COMPANY_ID = b.KEY_COMPANY_ID                                                        
and a.INDIVIDUAL_ID = b.KEY_INDIVIDUAL_ID                                                  
where b.cde_code1_score in('0','1','2','3','4','5','6','7','8')                            
order by b.adr_std_hse_num,                                                                
b.adr_std_hse_alpha,                                                                       
b.adr_std_str_prfx,                                                                        
b.adr_std_str_nme,                                                                         
b.adr_std_str_sfx1,                                                                        
b.adr_std_str_sfx2,                                                                        
b.adr_std_zip,                                                                             
a.v7606_1,                                                                                 
a.v7606_2                                                                                  
;

-- remove duplicate addresses keeping the best match 
delete from GAS_FORECAST_Acxiom_dec2016 a                                                  
where rowid > any(select rowid from GAS_FORECAST_Acxiom_dec2016 b                          
where a.adr_std_hse_num   = b.adr_std_hse_num                                              
and a.adr_std_hse_alpha = b.adr_std_hse_alpha                                              
and a.adr_std_str_prfx  = b.adr_std_str_prfx                                               
and a.adr_std_str_nme   = b.adr_std_str_nme                                                
and a.adr_std_str_sfx1  = b.adr_std_str_sfx1                                               
and a.adr_std_str_sfx2  = b.adr_std_str_sfx2                                               
and a.adr_std_zip       = b.adr_std_zip);                                                  

commit;
-- 10,633,053 deleted */                                                                   

select count(*) from GAS_FORECAST_Acxiom_dec2016;                                          
/* 5,132,492 - Feb 2017
5,142,717 */                                                                            

--/*                                                                                           
create index idx_GAS_FORECAST_Acx_dec2016 on GAS_FORECAST_Acxiom_dec2016(adr_std_hse_num,  
adr_std_hse_alpha,                                                                         
adr_std_str_prfx,                                                                          
adr_std_str_nme,                                                                           
adr_std_str_sfx1,                                                                          
adr_std_str_sfx2,                                                                          
adr_std_zip);
*/

update GAS_FORECAST_SATURATION_FINAL a                                                     
set (a.ACXIOM_zip_dec2016, a.ACXIOM_company_id_dec2016, a.ACXIOM_individual_id_dec2016) = (
select b.KEY_ZIP_dec2016, b.company_id_dec2016, b.individual_id_dec2016                    
from GAS_FORECAST_Acxiom_dec2016 b                                                         
where a.Sitehsenumb = b.adr_std_hse_num                                                    
and a.sitehsealph = b.adr_std_hse_alpha                                                    
and a.Sitestrprfx = b.adr_std_str_prfx                                                     
and a.Sitestrname = b.adr_std_str_nme                                                      
and a.Sitestrsfx1 = b.adr_std_str_sfx1                                                     
and a.Sitestrsfx2 = b.adr_std_str_sfx2                                                     
and a.SiteZip5    = b.adr_std_zip);                                                        

commit;

/**** Add HEAP flag to Saturation ****/
alter table GAS_FORECAST_SATURATION_FINAL add(HEAP_Eligible_Flag number(1));

select min(D263_household_member_count), max(D263_household_member_count)
from miuser.donnelley_all;
/* 1   8 */

select min(d274_find_income_in_1000s), max(d274_find_income_in_1000s)
from miuser.donnelley_all;
/* 5000   500000 */

create index idx_GAS_FORECAST_SAT_Donn_id on GAS_FORECAST_SATURATION_FINAL(Donn_Location_Id);
commit;

/* HEAP Eligibility guide lines were found in the PRO system - http://cssweb/Pro3/NYindex.html
Type in  - HEAP eligibility - in the search box
then click on Low Income Eligibility Charts (MA / RI / NY) */
update GAS_FORECAST_SATURATION_FINAL a
set HEAP_Eligible_Flag =
(select 
case
  when a.region = 'MA' and (d.d274_find_income_in_1000s between 1 and 34001) and d.D263_household_member_count = 1 then 1
  when a.region = 'MA' and (d.d274_find_income_in_1000s between 1 and 44463) and d.D263_household_member_count = 2 then 1
  when a.region = 'MA' and (d.d274_find_income_in_1000s between 1 and 54925) and d.D263_household_member_count = 3 then 1
  when a.region = 'MA' and (d.d274_find_income_in_1000s between 1 and 65387) and d.D263_household_member_count = 4 then 1
  when a.region = 'MA' and (d.d274_find_income_in_1000s between 1 and 75849) and d.D263_household_member_count = 5 then 1
  when a.region = 'MA' and (d.d274_find_income_in_1000s between 1 and 86311) and d.D263_household_member_count = 6 then 1
  when a.region = 'MA' and (d.d274_find_income_in_1000s between 1 and 88272) and d.D263_household_member_count = 7 then 1
  when a.region = 'MA' and (d.d274_find_income_in_1000s between 1 and 90234) and d.D263_household_member_count = 8 then 1
  when a.region = 'RI' and (d.d274_find_income_in_1000s between 1 and 28533) and d.D263_household_member_count = 1 then 1
  when a.region = 'RI' and (d.d274_find_income_in_1000s between 1 and 37312) and d.D263_household_member_count = 2 then 1
  when a.region = 'RI' and (d.d274_find_income_in_1000s between 1 and 46082) and d.D263_household_member_count = 3 then 1
  when a.region = 'RI' and (d.d274_find_income_in_1000s between 1 and 54871) and d.D263_household_member_count = 4 then 1
  when a.region = 'RI' and (d.d274_find_income_in_1000s between 1 and 63650) and d.D263_household_member_count = 5 then 1
  when a.region = 'RI' and (d.d274_find_income_in_1000s between 1 and 72430) and d.D263_household_member_count = 6 then 1
  when a.region = 'RI' and (d.d274_find_income_in_1000s between 1 and 74076) and d.D263_household_member_count = 7 then 1
  when a.region = 'RI' and (d.d274_find_income_in_1000s between 1 and 75722) and d.D263_household_member_count = 8 then 1
  when a.region in('LI','NYC','UNY') and (d.d274_find_income_in_1000s between 1 and 27597) and d.D263_household_member_count = 1 then 1
  when a.region in('LI','NYC','UNY') and (d.d274_find_income_in_1000s between 1 and 36088) and d.D263_household_member_count = 2 then 1
  when a.region in('LI','NYC','UNY') and (d.d274_find_income_in_1000s between 1 and 44580) and d.D263_household_member_count = 3 then 1
  when a.region in('LI','NYC','UNY') and (d.d274_find_income_in_1000s between 1 and 53071) and d.D263_household_member_count = 4 then 1
  when a.region in('LI','NYC','UNY') and (d.d274_find_income_in_1000s between 1 and 61562) and d.D263_household_member_count = 5 then 1
  when a.region in('LI','NYC','UNY') and (d.d274_find_income_in_1000s between 1 and 70054) and d.D263_household_member_count = 6 then 1
  when a.region in('LI','NYC','UNY') and (d.d274_find_income_in_1000s between 1 and 71646) and d.D263_household_member_count = 7 then 1
  when a.region in('LI','NYC','UNY') and (d.d274_find_income_in_1000s between 1 and 73238) and d.D263_household_member_count = 8 then 1
else 0
end as HEAP_Eligible_Flag
from miuser.donnelley_all d
where a.donn_location_id = d.d414_location_id_num
and a.sitezip5 = d.cln_adrzip5
)
where exists(select * from miuser.donnelley_all e
where a.donn_location_id = e.d414_location_id_num
and a.sitezip5 = e.cln_adrzip5);
/* 32 min Feb 2017
3 hours 45 min to run */
commit;

select * from GAS_FORECAST_SATURATION_FINAL;

grant select on GAS_FORECAST_SATURATION_FINAL to superuser, CIAPWRITE, mihnevas, mdematteo, zhangyi, miuser;


/********************************************/
/*** Add resi and commercial propensities ***/
/* the propensity tables were created in \analysts\Chris\Mike_D\Commercial_Model_ABI_TRW_Join.sql */
/********************************************/
alter table GAS_FORECAST_SATURATION_FINAL add(comm_max_propensity NUMBER(32,16), 
comm_avg_propensity NUMBER(32,16), resi_propensity NUMBER(32,16));

commit;


/******** NYC UPDATE *****/

/* update the pure prospect records */
update GAS_FORECAST_SATURATION_FINAL a
set (a.comm_max_propensity, a.comm_avg_propensity) = (
select b.comm_max_propensity, b.comm_avg_propensity
from predict_NY_cv_com_all2 b
where a.Sitehsenumb = b.adr_situs_hse_num_trw  
and a.sitehsealph = b.adr_situs_hse_alpha_trw
and a.Sitestrprfx = b.adr_situs_str_prfx_trw   
and a.Sitestrname = b.adr_situs_str_nme_trw  
and a.Sitestrsfx1 = b.adr_situs_str_sufx1_trw  
and a.Sitestrsfx2 = b.adr_situs_str_sufx2_trw  
and a.SiteZip5    = b.adr_situs_zip_trw      
)
where exists (select *
from predict_NY_cv_com_all2 b
where a.Sitehsenumb = b.adr_situs_hse_num_trw  
and a.sitehsealph = b.adr_situs_hse_alpha_trw
and a.Sitestrprfx = b.adr_situs_str_prfx_trw   
and a.Sitestrname = b.adr_situs_str_nme_trw  
and a.Sitestrsfx1 = b.adr_situs_str_sufx1_trw  
and a.Sitestrsfx2 = b.adr_situs_str_sufx2_trw  
and a.SiteZip5    = b.adr_situs_zip_trw )
and region = 'NYC'
and service is null;
/* 
37,341 - Apr 2015 - only update pure propects
92,963 updated - apr 2014 - updated all matches regardless of service type
92,421 updated 
1,218,912 rows updated */

commit;

select count(*) from predict_NY_cv_com_all2;


update GAS_FORECAST_SATURATION_FINAL a
set (a.comm_max_propensity, a.comm_avg_propensity) = (
select b.comm_max_propensity, b.comm_avg_propensity
from predict_ny_lu_com_all2 b
where a.Sitehsenumb = b.adr_situs_hse_num_trw  
and a.sitehsealph = b.adr_situs_hse_alpha_trw
and a.Sitestrprfx = b.adr_situs_str_prfx_trw   
and a.Sitestrname = b.adr_situs_str_nme_trw  
and a.Sitestrsfx1 = b.adr_situs_str_sufx1_trw  
and a.Sitestrsfx2 = b.adr_situs_str_sufx2_trw  
and a.SiteZip5    = b.adr_situs_zip_trw      
)
where exists (select *
from predict_ny_lu_com_all2 b
where a.Sitehsenumb = b.adr_situs_hse_num_trw  
and a.sitehsealph = b.adr_situs_hse_alpha_trw
and a.Sitestrprfx = b.adr_situs_str_prfx_trw   
and a.Sitestrname = b.adr_situs_str_nme_trw  
and a.Sitestrsfx1 = b.adr_situs_str_sufx1_trw  
and a.Sitestrsfx2 = b.adr_situs_str_sufx2_trw  
and a.SiteZip5    = b.adr_situs_zip_trw )
and region = 'NYC'
and service = 'NONHEAT' /* Low Use Prospects */;
/* 9718 updated */



/**** NYC RESI updates ***/
/*create table Predict_NY_CV_RES_Satur as
select * from mihnevas.Predict_NY_CV_RES_Satur_apr16;

create index idx_Predct_NY_CV_RES_Sat on Predict_NY_CV_RES_Satur(Record_Id);
*/

/*** NYC Resi Propensity Updates ****/
update GAS_FORECAST_SATURATION_FINAL a
set (a.resi_propensity) = (
select b.propensity
from mihnevas.predict_ny_cv_res_satur_apr17 b /* Resi Conversion File */
where a.record_id = b.record_id)
where exists (select *
from mihnevas.predict_ny_cv_res_satur_apr17 b /* Resi Conversion File */
where a.record_id = b.record_id)
and (a.resi_flag<>0 or a.multi_flag<>0 or a.mixed_use_flag<>0)
and a.region = 'NYC'
and service is null /* Pure Prospects */;
/* 208,760 updated */


update GAS_FORECAST_SATURATION_FINAL a
set (a.resi_propensity) = (
select b.propensity
from mihnevas.predict_ny_lu_res_satur_apr17 b /* Resi Low Use File */
where a.record_id = b.record_id)
where exists (select *
from mihnevas.predict_ny_lu_res_satur_apr17 b /* Resi Low Use File */
where a.record_id = b.record_id)
and (a.resi_flag<>0 or a.multi_flag<>0 or a.mixed_use_flag<>0)
and a.region = 'NYC'
and service = 'NONHEAT' /* Low Use Prospects */;
/* 60,347 updated */


/******* LI UPDATE *****/

/* update the pure prospect records */
update GAS_FORECAST_SATURATION_FINAL a
set (a.comm_max_propensity, a.comm_avg_propensity) = (
select b.comm_max_propensity, b.comm_avg_propensity
from predict_li_cv_com_all2 b
where a.Sitehsenumb = b.adr_situs_hse_num_trw  
and a.sitehsealph = b.adr_situs_hse_alpha_trw
and a.Sitestrprfx = b.adr_situs_str_prfx_trw   
and a.Sitestrname = b.adr_situs_str_nme_trw  
and a.Sitestrsfx1 = b.adr_situs_str_sufx1_trw  
and a.Sitestrsfx2 = b.adr_situs_str_sufx2_trw  
and a.SiteZip5    = b.adr_situs_zip_trw      
)
where exists (select *
from predict_li_cv_com_all2 b
where a.Sitehsenumb = b.adr_situs_hse_num_trw  
and a.sitehsealph = b.adr_situs_hse_alpha_trw
and a.Sitestrprfx = b.adr_situs_str_prfx_trw   
and a.Sitestrname = b.adr_situs_str_nme_trw  
and a.Sitestrsfx1 = b.adr_situs_str_sufx1_trw  
and a.Sitestrsfx2 = b.adr_situs_str_sufx2_trw  
and a.SiteZip5    = b.adr_situs_zip_trw )
and region = 'LI'
and service is null;
/* 
35,660 - Apr 2017
36,320 - Apr 2016
37,341 - Apr 2015 - only update pure propects
92,963 updated - apr 2014 - updated all matches regardless of service type
92,421 updated 
1,218,912 rows updated */

commit;

select count(*) from predict_li_cv_com_all2;
/* 
257219 - Apr 2017
108079 - Apr 2016
157,583 - Apr 2015
155,772 - Apr 2014
281,930
1,385,427 */

/* Update the non-heat records of saturation */
update GAS_FORECAST_SATURATION_FINAL a
set (a.comm_max_propensity, a.comm_avg_propensity) = (
select b.comm_max_propensity, b.comm_avg_propensity
from predict_LI_lu_com_all2 b
where a.Sitehsenumb = b.adr_situs_hse_num_trw  
and a.sitehsealph = b.adr_situs_hse_alpha_trw
and a.Sitestrprfx = b.adr_situs_str_prfx_trw   
and a.Sitestrname = b.adr_situs_str_nme_trw  
and a.Sitestrsfx1 = b.adr_situs_str_sufx1_trw  
and a.Sitestrsfx2 = b.adr_situs_str_sufx2_trw  
and a.SiteZip5    = b.adr_situs_zip_trw      
)
where exists (select *
from predict_LI_lu_com_all2 b
where a.Sitehsenumb = b.adr_situs_hse_num_trw  
and a.sitehsealph = b.adr_situs_hse_alpha_trw
and a.Sitestrprfx = b.adr_situs_str_prfx_trw   
and a.Sitestrname = b.adr_situs_str_nme_trw  
and a.Sitestrsfx1 = b.adr_situs_str_sufx1_trw  
and a.Sitestrsfx2 = b.adr_situs_str_sufx2_trw  
and a.SiteZip5    = b.adr_situs_zip_trw )
and region = 'LI'
and service = 'NONHEAT';
/* 
9,103 - Apr 2016
9,320 - apr 2015
*/

commit;

select count(*) from predict_LI_lu_com_all2;
/*
153157 - Apr 2017
108079 - apr 2016
157583
*/


update GAS_FORECAST_SATURATION_FINAL a
set (a.resi_propensity) = (
select b.propensity
from mihnevas.predict_li_cv_res_satur_apr17 b
where a.record_id = b.record_id)
where exists (select *
from mihnevas.predict_li_cv_res_satur_apr17 b
where a.record_id = b.record_id)
and (a.resi_flag<>0 or a.multi_flag<>0 or a.mixed_use_flag<>0)
and region = 'LI'
and service is null;
/* 
387,670 Apr 2017
297,167 Apr 2016
388,020 Apr 2015
395,707 updated - Apr 2014
404,096 rows updated */



update GAS_FORECAST_SATURATION_FINAL a
set (a.resi_propensity) = (
select b.propensity
from mihnevas.predict_li_lu_res_satur_apr17 b
where a.record_id = b.record_id)
where exists (select *
from mihnevas.predict_li_lu_res_satur_apr17 b
where a.record_id = b.record_id)
and (a.resi_flag<>0 or a.multi_flag<>0 or a.mixed_use_flag<>0)
and region = 'LI'
and service = 'NONHEAT';
/* 79,776 Apr 2017
73,490 Apr 2016
88,094 Apr 2015
395,707 updated - Apr 2014
404,096 rows updated */

commit;

 
grant select on GAS_FORECAST_SATURATION_FINAL to westrich, zhaowe;

select count(*) from Predict_LI_LU_RES_Satur;
/* 
702,606 - Apr 2016
406,478 - Apr 2014
436,465 */


/* Run the RI Resi update - Imported RESI RI file using SAS program - analysts\Chris\Ying\Import_RI_Propensities.sas */
select * from predict_ri_resi_all;
create index idx_predict_ri_resi_all on predict_ri_resi_all(record_id);


update GAS_FORECAST_SATURATION_FINAL a
set (a.resi_propensity) = (
select b.propensity
from mihnevas.predict_ri_cv_res_satur_apr17 b
where a.record_id = b.record_id)
where exists (select *
from mihnevas.predict_ri_cv_res_satur_apr17 b
where a.record_id = b.record_id)
and (a.resi_flag<>0 or a.multi_flag<>0 or a.mixed_use_flag<>0)
and region = 'RI'
and service is null;
/* 139,447 updated */


update GAS_FORECAST_SATURATION_FINAL a
set (a.resi_propensity) = (
select b.propensity
from mihnevas.predict_ri_lu_res_satur_apr17 b
where a.record_id = b.record_id)
where exists (select *
from mihnevas.predict_ri_lu_res_satur_apr17 b
where a.record_id = b.record_id)
and (a.resi_flag<>0 or a.multi_flag<>0 or a.mixed_use_flag<>0)
and region = 'RI'
and service = 'NONHEAT';
/* 14,403 unpdated */

commit;


select * from ABI_TRW_Model_File;

/* update RI Commercial pure prospect records */
update GAS_FORECAST_SATURATION_FINAL a
set (a.comm_max_propensity, a.comm_avg_propensity) = (
select b.comm_max_propensity, b.comm_avg_propensity
from predict_RI_cv_com_all2 b
where a.Sitehsenumb = b.adr_situs_hse_num_trw  
and a.sitehsealph = b.adr_situs_hse_alpha_trw
and a.Sitestrprfx = b.adr_situs_str_prfx_trw   
and a.Sitestrname = b.adr_situs_str_nme_trw  
and a.Sitestrsfx1 = b.adr_situs_str_sufx1_trw  
and a.Sitestrsfx2 = b.adr_situs_str_sufx2_trw  
and a.SiteZip5    = b.adr_situs_zip_trw      
)
where exists (select *
from predict_RI_cv_com_all2 b
where a.Sitehsenumb = b.adr_situs_hse_num_trw  
and a.sitehsealph = b.adr_situs_hse_alpha_trw
and a.Sitestrprfx = b.adr_situs_str_prfx_trw   
and a.Sitestrname = b.adr_situs_str_nme_trw  
and a.Sitestrsfx1 = b.adr_situs_str_sufx1_trw  
and a.Sitestrsfx2 = b.adr_situs_str_sufx2_trw  
and a.SiteZip5    = b.adr_situs_zip_trw )
and region = 'RI'
and service is null;
/* 20292 - Apr 2017
20581 rows updated */
commit;

select count(*) from predict_RI_cv_com_all2;
/* 37826 - Apr 2017
37928 */

/* Update the non-heat records of saturation */
update GAS_FORECAST_SATURATION_FINAL a
set (a.comm_max_propensity, a.comm_avg_propensity) = (
select b.comm_max_propensity, b.comm_avg_propensity
from predict_RI_lu_com_all2 b
where a.Sitehsenumb = b.adr_situs_hse_num_trw  
and a.sitehsealph = b.adr_situs_hse_alpha_trw
and a.Sitestrprfx = b.adr_situs_str_prfx_trw   
and a.Sitestrname = b.adr_situs_str_nme_trw  
and a.Sitestrsfx1 = b.adr_situs_str_sufx1_trw  
and a.Sitestrsfx2 = b.adr_situs_str_sufx2_trw  
and a.SiteZip5    = b.adr_situs_zip_trw      
)
where exists (select *
from predict_RI_lu_com_all2 b
where a.Sitehsenumb = b.adr_situs_hse_num_trw  
and a.sitehsealph = b.adr_situs_hse_alpha_trw
and a.Sitestrprfx = b.adr_situs_str_prfx_trw   
and a.Sitestrname = b.adr_situs_str_nme_trw  
and a.Sitestrsfx1 = b.adr_situs_str_sufx1_trw  
and a.Sitestrsfx2 = b.adr_situs_str_sufx2_trw  
and a.SiteZip5    = b.adr_situs_zip_trw )
and region = 'RI'
and service = 'NONHEAT';
/* 
1915 - Apr 2017
2684 updated
*/



/**** Run the update for MA ****/

update GAS_FORECAST_SATURATION_FINAL a
set (a.resi_propensity) = (
select b.propensity
from mihnevas.predict_ma_cv_res_satur_apr17 b
where a.record_id = b.record_id)
where exists (select *
from mihnevas.predict_ma_cv_res_satur_apr17 b
where a.record_id = b.record_id)
and (a.resi_flag<>0 or a.multi_flag<>0 or a.mixed_use_flag<>0)
and region = 'MA'
and service is null;
/* 1192447 rows updated */


update GAS_FORECAST_SATURATION_FINAL a
set (a.resi_propensity) = (
select b.propensity
from mihnevas.predict_ma_lu_res_satur_apr17 b
where a.record_id = b.record_id)
where exists (select *
from mihnevas.predict_ma_lu_res_satur_apr17 b
where a.record_id = b.record_id)
and (a.resi_flag<>0 or a.multi_flag<>0 or a.mixed_use_flag<>0)
and region = 'MA'
and service = 'NONHEAT';
/* 53190 rows updated */

commit;

select * from GAS_FORECAST_SATURATION_FINAL a
where a.resi_propensity is not null;

/* update MA Commercial pure prospect records */
update GAS_FORECAST_SATURATION_FINAL a
set (a.comm_max_propensity, a.comm_avg_propensity) = (
select b.comm_max_propensity, b.comm_avg_propensity
from predict_MA_cv_com_all2 b
where a.Sitehsenumb = b.adr_situs_hse_num_trw  
and a.sitehsealph = b.adr_situs_hse_alpha_trw
and a.Sitestrprfx = b.adr_situs_str_prfx_trw   
and a.Sitestrname = b.adr_situs_str_nme_trw  
and a.Sitestrsfx1 = b.adr_situs_str_sufx1_trw  
and a.Sitestrsfx2 = b.adr_situs_str_sufx2_trw  
and a.SiteZip5    = b.adr_situs_zip_trw      
)
where exists (select *
from predict_MA_cv_com_all2 b
where a.Sitehsenumb = b.adr_situs_hse_num_trw  
and a.sitehsealph = b.adr_situs_hse_alpha_trw
and a.Sitestrprfx = b.adr_situs_str_prfx_trw   
and a.Sitestrname = b.adr_situs_str_nme_trw  
and a.Sitestrsfx1 = b.adr_situs_str_sufx1_trw  
and a.Sitestrsfx2 = b.adr_situs_str_sufx2_trw  
and a.SiteZip5    = b.adr_situs_zip_trw )
and region = 'MA'
and service is null;
/* 121039 - Apr 2017
166742 rows updated */
commit;

select count(*) from predict_MA_cv_com_all2;
/* 228989 - Apr 2017
276384 */


/* Update UNY Resi Non-Heat ***/
update GAS_FORECAST_SATURATION_FINAL a
set (a.resi_propensity) = (
select min(b.propensity)
from mihnevas.predict_uny_lu_res_satur_apr17 b
where a.record_id = b.record_id
group by b.record_id)
where exists (select *
from mihnevas.predict_uny_lu_res_satur_apr17 b
where a.record_id = b.record_id
group by b.record_id)
and (a.resi_flag<>0 or a.multi_flag<>0 or a.mixed_use_flag<>0)
and region = 'UNY'
and service = 'NONHEAT';
/* 12301 rows updated */
commit;

/* Update UNY Resi Pure Prospects ***/
update GAS_FORECAST_SATURATION_FINAL a
set (a.resi_propensity) = (
select min(b.propensity)
from mihnevas.predict_uny_cv_res_satur_apr17 b
where a.record_id = b.record_id
group by b.record_id)
where exists (select *
from mihnevas.predict_uny_cv_res_satur_apr17 b
where a.record_id = b.record_id
group by b.record_id)
and (a.resi_flag<>0 or a.multi_flag<>0 or a.mixed_use_flag<>0)
and region = 'UNY'
and service is null;
/* 2145761 rows updated */
commit;


/* Test to see what pieces have been updated */
select region,
case
  when a.service is null then 'PROSPECT'
  else a.service
end as service,
sum(case
       when comm_max_propensity is not null then 1
       else 0
    end) as comm_max_propensity,
sum(case
       when comm_avg_propensity is not null then 1
       else 0
    end) as comm_avg_propensity,
sum(case
       when resi_propensity is not null then 1
       else 0
    end) as resi_propensity
from GAS_FORECAST_SATURATION_FINAL a
where service = 'NONHEAT' or service is null
group by region,
case
  when a.service is null then 'PROSPECT'
  else a.service
end
order by region, service;

select * from cpalmieri.GAS_FORECAST_SATURATION_FINAL;


/* See how many records do not have a resi propensity */
select region, count(*) from GAS_FORECAST_SATURATION_FINAL a
where resi_propensity is null
and (a.resi_flag<>0 or a.multi_flag<>0 or a.mixed_use_flag<>0)
group by region;

/*** Create an average by zip code to fill in the NULL propensities  ****/
drop table GAS_FCST_NYC_LI_AVG_COMM_PROP;

create table GAS_FCST_NYC_LI_AVG_COMM_PROP as
select g.sitezip5, avg(g.comm_max_propensity) as avg_comm_prop
from GAS_FORECAST_SATURATION_FINAL g
where comm_max_propensity is not null
--and region in ('LI','NYC')
group by g.sitezip5;

create index idx_GAS_FCST_NYCLIAVGCOMMPROP on GAS_FCST_NYC_LI_AVG_COMM_PROP(SITEZIP5);

drop table GAS_FCST_NYC_LI_AVG_RESI_PROP;

create table GAS_FCST_NYC_LI_AVG_RESI_PROP as
select g.sitezip5, avg(g.resi_propensity) as avg_resi_prop
from GAS_FORECAST_SATURATION_FINAL g
where resi_propensity is not null
--and region in ('LI','NYC')
group by g.sitezip5;

create index idx_GAS_FCST_NYCLIAVGRESIPROP on GAS_FCST_NYC_LI_AVG_RESI_PROP(SITEZIP5);

select * from GAS_FCST_NYC_LI_AVG_COMM_PROP;
select * from GAS_FCST_NYC_LI_AVG_RESI_PROP;

/* see how many records match the average for the zip */
select * from GAS_FORECAST_SATURATION_FINAL a
join GAS_FCST_NYC_LI_AVG_COMM_PROP b
on a.sitezip5 = b.sitezip5
and a.comm_max_propensity = b.avg_comm_prop;
/* 6 records on LI, 21 in MA, and 2 on RI just in case we need to know:
REGION	RECORD_ID
LI	5477437
LI	7353600
LI	5500597
LI	5458008
LI	7473838
LI	1401511
MA	3817214
MA	3177308
MA	7464881
MA	5616153
MA	5597545
MA	5439105
MA	5392242
MA	5547485
MA	5553085
MA	5575842
MA	5562350
MA	5440114
MA	5381380
MA	5423745
MA	5387510
MA	5399045
MA	5538055
MA	5370666
MA	5339358
MA	5348971
MA	5477871
RI	5573975
RI	7057915
 */

select * from GAS_FORECAST_SATURATION_FINAL a
join GAS_FCST_NYC_LI_AVG_RESI_PROP b
on a.sitezip5 = b.sitezip5
and a.resi_propensity = b.avg_resi_prop;
/* 168 records */


/* Update the commercial records with the average per zip */
update GAS_FORECAST_SATURATION_FINAL a
set comm_max_propensity = (select avg_comm_prop from GAS_FCST_NYC_LI_AVG_COMM_PROP b
where a.sitezip5 = b.sitezip5)
where a.comm_max_propensity is null
and (service ='NONHEAT' or service is null)
and exists(select * from GAS_FCST_NYC_LI_AVG_COMM_PROP b
where a.sitezip5 = b.sitezip5)
;
/* 1,997,455 updated */

/* Update the residential records with the average per zip */
update GAS_FORECAST_SATURATION_FINAL a
set resi_propensity = (select avg_resi_prop from GAS_FCST_NYC_LI_AVG_RESI_PROP b
where a.sitezip5 = b.sitezip5)
where a.resi_propensity is null
and (service ='NONHEAT' or service is null)
and exists(select * from GAS_FCST_NYC_LI_AVG_RESI_PROP b
where a.sitezip5 = b.sitezip5)
;
/* 506,156 updated */



/****************************************************************************************************/
/****************************************************************************************************/
/********************* END OF PROPENSITY UPDATES ****************************************************/
/****************************************************************************************************/
/****************************************************************************************************/

/* Moratorium zips for 2017 */
select * from cpalmieri.gas_forecast_saturation_final

/* reset constrained zips */
update cpalmieri.gas_forecast_saturation_final
set constrained_zip_commercial = 'N',
constrained_zip_residential = 'N'
;

update cpalmieri.gas_forecast_saturation_final
set constrained_zip_commercial = 'Y',
constrained_zip_residential = 'Y'
where zip_code_updated in('02631','02633','02638','02639','02641','02642',
'02643','02645','02646','02650','02651','02653','02659','02660','02662','02670','02671')
;
/* 53,036 */
commit;

/****************************************************************************************************/
/************************* Start of Geocoding Update to Saturation **********************************/
/****************************************************************************************************/

select max(length(geographiccoordinatesystem)), max(length(Loc_name)) from Gas_fcst_Sat_geocded_2017;
/* 12  14 */
/* 7,168,525 */


/*truncate table GAS_FCST_SATURATION_GEOCODE;
commit;
*/

drop table cpalmieri.GAS_FCST_SATURATION_GEOCODE;

create table cpalmieri.GAS_FCST_SATURATION_GEOCODE(
OBJECTID number(10),Join_Count number(10),TARGET_FID number(10),REGION varchar2(20),SERVICE varchar2(20),MARKET varchar2(20),
RECORD_ID number(10), 
Loc_name varchar2(50),
POINT_X NUMBER(32,16),
POINT_Y NUMBER(32,16),
GeographicCoordinateSystem varchar2(50),
Datum varchar2(50),
PrimeMeridian varchar2(50),
AngularUnit varchar2(50),
ZIP_CODE_UPDATED varchar2(5)) tablespace xlarge_data;

/* Import the 6 geocoded CSV files using SQL Loader the /users/home/66735a/Saturation_Geocode.ctl file
   on SASAL01P */
  
alter table GAS_FCST_SATURATION_GEOCODE
drop(OBJECTID,Join_Count,TARGET_FID,REGION,SERVICE,MARKET);
commit;


select record_id, count(*) from GAS_FCST_SATURATION_GEOCODE
group by record_id
having count(*)>1;
/* 0 */

select max(length(geographiccoordinatesystem)), 
max(length(Loc_name)),
count(*)
from GAS_FCST_SATURATION_GEOCODE;
/*
MAX(LENGTH(GEOGRAPHICCOORDINAT	MAX(LENGTH(LOC_NAME))	COUNT(*)
12	14	7168525
*/

create index idx_GAS_FCST_SAT_GEOCODE on GAS_FCST_SATURATION_GEOCODE(Record_Id);

alter table gas_forecast_saturation_final add( 
Loc_name varchar2(50),
POINT_X NUMBER(32,16),
POINT_Y NUMBER(32,16),
GeographicCoordinateSystem varchar2(50),
Datum varchar2(50),
PrimeMeridian varchar2(50),
AngularUnit varchar2(50),
ZIP_CODE_GEO varchar2(5));

/* insert the Geocoded data into saturation */
update gas_forecast_saturation_final a
set (a.Loc_name,
a.POINT_X,
a.POINT_Y,
a.GeographicCoordinateSystem,
a.Datum,
a.PrimeMeridian,
a.AngularUnit,
a.ZIP_CODE_GEO) = (select b.Loc_name,
b.POINT_X,
b.POINT_Y,
b.GeographicCoordinateSystem,
b.Datum,
b.PrimeMeridian,
b.AngularUnit,
b.ZIP_CODE_UPDATED
from GAS_FCST_SATURATION_GEOCODE b
where a.record_id = b.record_id)
where exists(select * from GAS_FCST_SATURATION_GEOCODE b
where a.record_id = b.record_id);
/* 7,168,525 updated - 20 minutes */


select record_id, count(*) from GAS_FCST_SATURATION_GEOCODE
group by record_id
having count(*)>1;
/* 0 */

/****************************************************************************************************/
/*************************** End of Geocoding Update to Saturation **********************************/
/****************************************************************************************************/

/*alter table gas_forecast_saturation_final rename column ZIP_CODE_UPDATED to ZIP_CODE_GEO;*/

alter table gas_forecast_saturation_final add(ZIP_CODE_UPDATED varchar2(5));


grant all on GAS_FORECAST_SATURATION_FINAL to miuser WITH GRANT OPTION;
grant select on GAS_FORECAST_SATURATION_FINAL to superuser, CIAPWRITE, breed, mdematteo, mihnevas, qifei1, mtsui, afill, lantryk, arcana, maugustine, zhoul, rbruney, sziksa, poet;

select * from GAS_FORECAST_SATURATION_FINAL;

select distinct cde_on_main from GAS_FORECAST_SATURATION_FINAL;

drop table GAS_FORECAST_valid_zips;

create table GAS_FORECAST_valid_zips as
select distinct zip_code_geo
from GAS_FORECAST_SATURATION_FINAL
where zip_code_geo is not null
--and service is not null
;

/* update the zip_code_updated field to the original zip where those zips are valid
Engineering zips */
update gas_forecast_saturation_final a
set a.zip_code_updated = a.sitezip5
where a.sitezip5 in(select zip_code_geo from GAS_FORECAST_valid_zips);
/* 7,137,439 - 12 minutes */

update gas_forecast_saturation_final a
set a.zip_code_updated = a.zip_code_geo
where a.zip_code_geo is not null
and a.zip_code_updated is null;
/* 28,205 - 1 minute */

select count(*) from gas_forecast_saturation_final;
/* 7,168,525 */

select * from GAS_FORECAST_valid_zips;

grant select on cpalmieri.GAS_FORECAST_valid_zips to lantryk, superuser;

select count(*) from GAS_FORECAST_SATURATION_FINAL;
/* 7,168,525 */

select count(*) from GAS_FORECAST_SATURATION_FINAL a
where zip_code_updated is null;
/* 2,881 */

update GAS_FORECAST_SATURATION_FINAL a
set a.zip_code_updated = 'UNKWN'
where zip_code_updated is null;
/* 2881 updated */
commit;


/* test to see if the situation with switching regions has improved 
create table GAS_FORECAST_valid_zips2 as
select region, zip_code_updated, count(*) as struct_count
from GAS_FORECAST_SATURATION_FINAL
group by region, zip_code_updated
--and service is not null
;

select * from GAS_FORECAST_valid_zips2
where zip_code_updated in(select zip_code_updated from GAS_FORECAST_valid_zips2
group by zip_code_updated having count(*)>1);

REGION	ZIP_CODE_UPDATED	STRUCT_COUNT
RI	02302	1
MA	02302	9366
LI	10024	1
NYC	10024	1830
LI	11693	1992
NYC	11693	1
NYC	UNKWN	1
LI	UNKWN	1
MA	UNKWN	2841
RI	UNKWN	14
UNY	UNKWN	24
*/



select count(*), count(distinct Sitehsenumb||Sitehsealph||Sitestrprfx||
Sitestrname||Sitestrsfx1||Sitestrsfx2||SiteZip5)
from GAS_FORECAST_css_gas1;
/* 1,619,909	1,299,716 */

select count(*) from GAS_FORECAST_SATURATION_FINAL a
where service is not null and region in('LI','UNY','RI');
/* 1,299,323 */


select count(*), count(distinct Sitehsenumb||Sitehsealph||Sitestrprfx||
Sitestrname||Sitestrsfx1||Sitestrsfx2||SiteZip5)
from GAS_FORECAST_cris_gas1;
/* 2,550,978	1,322,433 */

select count(*) from GAS_FORECAST_SATURATION_FINAL a
where service is not null and region in('NYC','MA');
/* 1,322,424 */


select * from GAS_FORECAST_cris_gas1;
select * from GAS_FORECAST_css_gas1;


/**** CRIS ZIP CODE UPDATE *****/

drop table GAS_FORECAST_cris_update_zip;

create table GAS_FORECAST_cris_update_zip as 
select a.acctnum as id_acct, 
substr(a.acctnum,1,10) as id_acct10,
a.sitezip5 as old_zip,
k.zip_code_updated
from GAS_FORECAST_cris_gas1 a
join gas_forecast_saturation_final k
on  a.sitehsenumb = k.sitehsenumb
and a.sitehsealph = k.sitehsealph
and a.sitestrprfx = k.sitestrprfx
and a.sitestrname = k.sitestrname
and a.sitestrsfx1 = k.sitestrsfx1
and a.sitestrsfx2 = k.sitestrsfx2
and a.sitezip5    = k.sitezip5
;


select count(*), count(distinct acctnum) from GAS_FORECAST_cris_gas1;
/* 2550978   2550978 */

select count(*), count(distinct id_acct), count(distinct id_acct10) from GAS_FORECAST_cris_update_zip;
/* 2549906   2549906   2549906*/

create index idx_GAS_FORECAST_cris_updt_zip on GAS_FORECAST_cris_update_zip(Id_Acct);

drop table GAS_FORECAST_cris_update_zip2;

/* update any that I didn't get a match on the 7 address pieces to match on the 6 pieces */
create table GAS_FORECAST_cris_update_zip2 as 
select distinct a.acctnum as id_acct, 
substr(a.acctnum,1,10) as id_acct10,
a.sitezip5 as old_zip,
k.zip_code_updated
from GAS_FORECAST_cris_gas1 a
join gas_forecast_saturation_final k
on  a.sitehsenumb = k.sitehsenumb
--and a.sitehsealph = k.sitehsealph
and a.sitestrprfx = k.sitestrprfx
and a.sitestrname = k.sitestrname
and a.sitestrsfx1 = k.sitestrsfx1
and a.sitestrsfx2 = k.sitestrsfx2
and a.sitezip5    = k.sitezip5
left join GAS_FORECAST_cris_update_zip b
on a.acctnum = b.id_acct
where b.id_acct is null 
;

select count(*), count(distinct id_acct) from GAS_FORECAST_cris_update_zip;
select count(*), count(distinct id_acct) from GAS_FORECAST_cris_update_zip2;
where id_acct in(select id_acct from GAS_FORECAST_cris_update_zip)

insert into GAS_FORECAST_cris_update_zip
select * from GAS_FORECAST_cris_update_zip2;

select count(*) from GAS_FORECAST_cris_update_zip;
/* 2550802 */

select a.* 
from GAS_FORECAST_cris_gas1 a
left join GAS_FORECAST_cris_update_zip b
on a.acctnum = b.id_acct
where b.id_acct is null
/* 176 */
and a.sitezip5 not in(select zip_code_geo from GAS_FORECAST_valid_zips)
/* 31 */


/* Insert records that I was not able to match, but have zips in the updated zip list */
insert into GAS_FORECAST_cris_update_zip
select distinct a.acctnum as id_acct, 
substr(a.acctnum,1,10) as id_acct10,
a.sitezip5 as old_zip,
a.sitezip5 as zip_code_updated
from GAS_FORECAST_cris_gas1 a
left join GAS_FORECAST_cris_update_zip b
on a.acctnum = b.id_acct
where b.id_acct is null
and a.sitezip5 in(select zip_code_geo from cpalmieri.GAS_FORECAST_valid_zips)
;
/* 145 inserted - 31 were not included */

select count(*), count(distinct id_acct) from GAS_FORECAST_cris_update_zip;
/* 2550947	2550947 */

select * from GAS_FORECAST_cris_update_zip
where id_acct10 in(select id_acct10 from GAS_FORECAST_cris_update_zip
group by id_acct10
having count(*)>1)
/* 0 */

/**** END OF CRIS ZIP CODE UPDATE *****/


/****** CSS ZIP CODE UPDATE ******/
select * from GAS_FORECAST_css_gas1;

drop table GAS_FORECAST_css_update_zip;

create table GAS_FORECAST_css_update_zip as 
select distinct
b.ky_ba, 
b.ky_prem_no,
a.sitezip5 as old_zip,
k.zip_code_updated
from GAS_FORECAST_css_gas1 a
join mi_css_prod.cu02tb01_bill_acct b
on to_number(a.acctnum) = b.ky_ba
join gas_forecast_saturation_final k
on  a.sitehsenumb = k.sitehsenumb
and a.sitehsealph = k.sitehsealph
and a.sitestrprfx = k.sitestrprfx
and a.sitestrname = k.sitestrname
and a.sitestrsfx1 = k.sitestrsfx1
and a.sitestrsfx2 = k.sitestrsfx2
and a.sitezip5    = k.sitezip5
;

select count(*), count(distinct acctnum) from GAS_FORECAST_css_gas1;
/* 1619909	1619900 */

select count(*), count(distinct ky_ba), count(distinct ky_prem_no) from GAS_FORECAST_css_update_zip;
/* 1616233	1616233	 1616219 */

create index idx_GAS_FORECAST_css_updt_zip on GAS_FORECAST_css_update_zip(ky_ba);

drop table GAS_FORECAST_css_update_zip2;

create table GAS_FORECAST_css_update_zip2 as 
select distinct
b.ky_ba, 
b.ky_prem_no,
a.sitezip5 as old_zip,
k.zip_code_updated
from GAS_FORECAST_css_gas1 a
join mi_css_prod.cu02tb01_bill_acct b
on to_number(a.acctnum) = b.ky_ba
join gas_forecast_saturation_final k
on  a.sitehsenumb = k.sitehsenumb
--and a.sitehsealph = k.sitehsealph
and a.sitestrprfx = k.sitestrprfx
and a.sitestrname = k.sitestrname
and a.sitestrsfx1 = k.sitestrsfx1
and a.sitestrsfx2 = k.sitestrsfx2
and a.sitezip5    = k.sitezip5
left join GAS_FORECAST_css_update_zip c
on b.ky_prem_no = c.ky_prem_no
where c.ky_prem_no is null 
;


select count(*), count(distinct ky_prem_no) from GAS_FORECAST_css_update_zip;
/* 1616233	1616219 */
select count(*), count(distinct ky_prem_no) from GAS_FORECAST_css_update_zip2
/* 3419	3419 */
where ky_prem_no in(select ky_prem_no from GAS_FORECAST_css_update_zip)
/* 0  0 */

insert into GAS_FORECAST_css_update_zip
select * from GAS_FORECAST_css_update_zip2;

select count(*), count(distinct ky_prem_no) from GAS_FORECAST_css_update_zip;
/* 1619652	1619638  */

select count(*), count(distinct b.ky_prem_no) 
from GAS_FORECAST_css_gas1 a
join mi_css_prod.cu02tb01_bill_acct b
on to_number(a.acctnum) = b.ky_ba
/* 1619680	1619657 */

select a.* 
from GAS_FORECAST_css_gas1 a
left join mi_css_prod.cu02tb01_bill_acct b
on to_number(a.acctnum) = b.ky_ba
where b.ky_ba is null
/* 229 */


select a.* 
from GAS_FORECAST_css_gas1 a
join mi_css_prod.cu02tb01_bill_acct b
on to_number(a.acctnum) = b.ky_ba
left join GAS_FORECAST_css_update_zip z
on b.ky_prem_no = z.ky_prem_no
where z.ky_prem_no is null
/* 19 */
and a.sitezip5 not in(select zip_code_geo from GAS_FORECAST_valid_zips)
/* 13 */


/* Insert records that I was not able to match, but have zips in the updated zip list */
insert into GAS_FORECAST_css_update_zip
select distinct b.ky_ba, 
b.ky_prem_no,
a.sitezip5 as old_zip,
a.sitezip5 as zip_code_updated
from GAS_FORECAST_css_gas1 a
join mi_css_prod.cu02tb01_bill_acct b
on to_number(a.acctnum) = b.ky_ba
left join GAS_FORECAST_css_update_zip z
on z.ky_ba = b.ky_ba
where z.ky_prem_no is null
and a.sitezip5 in(select zip_code_geo from cpalmieri.GAS_FORECAST_valid_zips)
;
/* 6 inserted - 13 were not included */

select count(*), count(distinct ky_prem_no) from GAS_FORECAST_css_update_zip;
/* 1619658	1619644 */

select * from GAS_FORECAST_css_update_zip
where ky_prem_no in(select ky_prem_no from GAS_FORECAST_css_update_zip
group by ky_prem_no
having count(*)>1);

/* remove the duplicate ky_prem_no where both have the same zip_code_updated */
delete from GAS_FORECAST_css_update_zip a
where rowid < any(select rowid from GAS_FORECAST_css_update_zip b
where a.ky_prem_no = b.ky_prem_no
and a.zip_code_updated = b.zip_code_updated)
/* 14 deleted */

/* remove the remaining duplicate ky_prem_no where the updated zip is different from the old zip */
delete from GAS_FORECAST_css_update_zip a
where zip_code_updated <> old_zip
and ky_prem_no in(select ky_prem_no from GAS_FORECAST_css_update_zip
group by ky_prem_no
having count(*)>1);
/* 0 deleted */

select count(*) from GAS_FORECAST_cris_update_zip;
/* 2550947 */
select count(*) from GAS_FORECAST_css_update_zip;
/* 1619644 */

select * from cpalmieri.GAS_FORECAST_cris_update_zip;
ID_ACCT	ID_ACCT10	OLD_ZIP	ZIP_CODE_UPDATED

select count(*) from cpalmieri.GAS_FORECAST_cris_update_zip
where old_zip <> zip_code_updated;
/* 6389 */

select * from cpalmieri.GAS_FORECAST_css_update_zip;
KY_BA	KY_PREM_NO	OLD_ZIP	ZIP_CODE_UPDATED


select count(*) from cpalmieri.GAS_FORECAST_css_update_zip
where old_zip <> zip_code_updated;
/* 5099 */



/**** CAS ZIP CODE UPDATE for Kevin *****/

drop table GAS_FORECAST_cas_update_zip;

create table GAS_FORECAST_cas_update_zip as 
select a.id_acct_ega as id_acct_ega, 
substr(a.id_acct_ega,1,9) as id_acct_ega9,
a.adr_prem_zip_ega as old_zip,
k.zip_code_updated
from mi_cas_prod.east_gas_account a
join gas_forecast_saturation_final k
on  a.adr_prem_hse_num_ega   = k.sitehsenumb
and nvl(a.adr_prem_hse_alpha_ega,' ') = k.sitehsealph
and nvl(a.adr_prem_str_prfx_ega ,' ') = k.sitestrprfx
and nvl(a.adr_prem_str_nme_ega  ,' ') = k.sitestrname
and nvl(a.adr_prem_str_sufx1_ega,' ') = k.sitestrsfx1
and nvl(a.adr_prem_str_sufx2_ega,' ') = k.sitestrsfx2
and a.adr_prem_zip_ega       = k.sitezip5
;


select count(*), count(distinct id_acct_ega), count(distinct substr(id_acct_ega,1,9)) from mi_cas_prod.east_gas_account;
/* 1115299	1115299	606237 */

select count(*), count(distinct id_acct_ega), count(distinct id_acct_ega9) from GAS_FORECAST_cas_update_zip;
/* 1094435	1089335	596418 */

create index idx_GAS_FORECAST_cas_updt_zip on GAS_FORECAST_cas_update_zip(Id_Acct_ega);

drop table GAS_FORECAST_cas_update_zip2;

/* update any that I didn't get a match on the 7 address pieces to match on the 6 pieces */
create table GAS_FORECAST_cas_update_zip2 as 
select a.id_acct_ega as id_acct_ega, 
substr(a.id_acct_ega,1,9) as id_acct_ega9,
a.adr_prem_zip_ega as old_zip,
k.zip_code_updated
from mi_cas_prod.east_gas_account a
join gas_forecast_saturation_final k
on  a.adr_prem_hse_num_ega   = k.sitehsenumb
--and nvl(a.adr_prem_hse_alpha_ega,' ') = k.sitehsealph
and nvl(a.adr_prem_str_prfx_ega ,' ') = k.sitestrprfx
and nvl(a.adr_prem_str_nme_ega  ,' ') = k.sitestrname
and nvl(a.adr_prem_str_sufx1_ega,' ') = k.sitestrsfx1
and nvl(a.adr_prem_str_sufx2_ega,' ') = k.sitestrsfx2
and a.adr_prem_zip_ega       = k.sitezip5
left join GAS_FORECAST_cas_update_zip b
on a.id_acct_ega = b.id_acct_ega
where b.id_acct_ega is null 
;

select count(*), count(distinct id_acct_ega), count(distinct id_acct_ega9) from GAS_FORECAST_cas_update_zip;
/* 1094435	1089335	596418 */
select count(*), count(distinct id_acct_ega), count(distinct id_acct_ega9) from GAS_FORECAST_cas_update_zip2
/* 5928	4994	2174 */
where id_acct_ega9 in(select id_acct_ega9 from GAS_FORECAST_cas_update_zip);
/* 1472	1311	713 */

select * from GAS_FORECAST_cas_update_zip

/* remove duplicates */
delete from GAS_FORECAST_cas_update_zip a
where rowid < any(select rowid from GAS_FORECAST_cas_update_zip b
where a.id_acct_ega9 = b.id_acct_ega9);
/* 498017 deleted */

/* remove duplicates */
delete from GAS_FORECAST_cas_update_zip2 a
where rowid < any(select rowid from GAS_FORECAST_cas_update_zip2 b
where a.id_acct_ega9 = b.id_acct_ega9);
/* 3754 deleted */

/* delete overlaps */
delete from GAS_FORECAST_cas_update_zip2 a
where exists(select * from GAS_FORECAST_cas_update_zip b
where a.id_acct_ega9 = b.id_acct_ega9);
/* 713 */


insert into GAS_FORECAST_cas_update_zip
select * from GAS_FORECAST_cas_update_zip2;
/* 1461 inserted */

select count(*), count(distinct id_acct_ega), count(distinct id_acct_ega9) from GAS_FORECAST_cas_update_zip;
/* 597879	597879	597879 */

select a.* 
from mi_cas_prod.east_gas_account a
left join GAS_FORECAST_cas_update_zip b
on substr(a.id_acct_ega,1,9) = b.id_acct_ega9
where b.id_acct_ega9 is null
/* 15,180 */
and a.adr_prem_zip_ega not in(select zip_code_geo from GAS_FORECAST_valid_zips)
/* 232 */

create table GAS_FORECAST_cas_update_zip3 as
select max(a.id_acct_ega) as id_acct_ega, 
substr(a.id_acct_ega,1,9) as id_acct_ega9,
a.adr_prem_zip_ega as old_zip,
a.adr_prem_zip_ega as zip_code_updated
from mi_cas_prod.east_gas_account a
left join GAS_FORECAST_cas_update_zip b
on substr(a.id_acct_ega,1,9) = b.id_acct_ega9
where b.id_acct_ega9 is null
and a.adr_prem_zip_ega in(select zip_code_geo from cpalmieri.GAS_FORECAST_valid_zips)
group by substr(a.id_acct_ega,1,9),
a.adr_prem_zip_ega;

select count(*), count(distinct id_acct_ega), count(distinct id_acct_ega9) from GAS_FORECAST_cas_update_zip3;
/* 8256	8256	8224 */

select * from GAS_FORECAST_cas_update_zip3
where id_acct_ega9 in(select id_acct_ega9 
from GAS_FORECAST_cas_update_zip3 group by id_acct_ega9 having count(*)>1);

/* delete duplicate id_acct_ega9's */
delete from GAS_FORECAST_cas_update_zip3 a
where rowid < any(select rowid from GAS_FORECAST_cas_update_zip3 b
where a.id_acct_ega9 = b.id_acct_ega9)
;
/* 32 deleted */
commit;

/* Insert records that I was not able to match, but have zips in the updated zip list */
insert into GAS_FORECAST_cas_update_zip
select * from GAS_FORECAST_cas_update_zip3;
/* 8224 rows inserted */


select count(*), count(distinct id_acct_ega9) from GAS_FORECAST_cas_update_zip;
/* 606103	606103 */

select * from cpalmieri.GAS_FORECAST_cas_update_zip
where id_acct_ega9 in(select id_acct_ega9 from GAS_FORECAST_cas_update_zip
group by id_acct_ega9
having count(*)>1)
/* 0 */

/**** END OF CAS ZIP CODE UPDATE *****/



grant select on GAS_FORECAST_cris_update_zip to superuser, lantryk;
grant select on GAS_FORECAST_css_update_zip to superuser, lantryk;
grant select on GAS_FORECAST_cas_update_zip to superuser, lantryk;


/***** Update Saturation with Liming's LI On Main and Distance to Main *****/
drop table gas_fcst_sat_li_dist_to_main;

create table gas_fcst_sat_li_dist_to_main(record_id number(10), shortestdisttomain_meter NUMBER(32,16));

/* Import the CSV files using SQL Loader the /users/home/66735a/shortestdisttomain_meter.ctl file
   on SASAL01P */

select max(shortestdisttomain_meter) from gas_fcst_sat_li_dist_to_main;

select * from gas_fcst_sat_li_dist_to_main
where shortestdisttomain_meter is null;
/* 12,549 */


select count(*), count(distinct record_id) from gas_fcst_sat_li_dist_to_main;
/* 309736	309736 */

create table gas_fcst_sat_li_on_main(record_id number(10));
/* Import the CSV files using SQL Loader the /users/home/66735a/Saturation_LI_OnMain.ctl file
   on SASAL01P */

select count(*), count(distinct record_id) from gas_fcst_sat_li_on_main;
/* 106452	87689 */

alter table GAS_FORECAST_SATURATION_FINAL 
add(CDE_ON_MAIN_LIMING number, DIST_TO_MAIN_LIMING number);

update GAS_FORECAST_SATURATION_FINAL a
set a.CDE_ON_MAIN_LIMING = null ;
commit;

update GAS_FORECAST_SATURATION_FINAL a
set a.CDE_ON_MAIN_LIMING = 0 
where record_id in(select distinct record_id from gas_fcst_sat_li_on_main)
and (CDE_ON_MAIN_LIMING <> 0
or CDE_ON_MAIN_LIMING is null)
and region = 'LI' ;
/* 84635 updated */

create index idx_gas_fcst_li_dist_to_main on gas_fcst_sat_li_dist_to_main(record_id);
commit;

update GAS_FORECAST_SATURATION_FINAL a
set DIST_TO_MAIN_LIMING = (select shortestdisttomain_meter*3.28084 
from gas_fcst_sat_li_dist_to_main b
where a.record_id = b.record_id)
where region = 'LI';

select count(*) from gas_fcst_sat_li_dist_to_main
where shortestdisttomain_meter is not null;
/* 297187 */

select count(*) from GAS_FORECAST_SATURATION_FINAL
where DIST_TO_MAIN_LIMING is not null;
/* 290674 */

/***** END Update Saturation with Liming's LI On Main and Distance to Main *****/

/***** Update Saturation with Liming's UNY On Main and Distance to Main *****/

/* Give Liming the needed fields for him to get the distance to main */
select record_id, point_x as longitude, point_y as latitude, datum from GAS_FORECAST_SATURATION_FINAL 
where region = 'UNY'
and service is null
and franchise_zip = 'Y';

select * from mi_edr_prod.edr_trw t where t.adr_situs_zip_trw = '13601'

grant select on cpalmieri.gas_fcst_sat_uny_base to zhoul;

select count(*) from cpalmieri.gas_fcst_sat_uny_base
/* 2351173 */
where franchise_zip = 'Y'
/* 197431 */
;

/***** Update Saturation with Liming's NYC On Main and Distance to Main *****/

/* Give Liming the needed fields for him to get the distance to main - Export to a CSV file */
select record_id, point_x as longitude, point_y as latitude, datum from GAS_FORECAST_SATURATION_FINAL 
where region = 'NYC'
and service is null
and franchise_zip = 'Y';
/* 33,573 */

--grant select on cpalmieri.gas_fcst_sat_NYC_base to zhoul;


/***** Update Saturation with Liming's NYC and UNY On Main and Distance to Main *****/
drop table gas_fcst_sat_NYC_dist_to_main;

create table gas_fcst_sat_NYC_dist_to_main(record_id number(10), shortestdisttomain_meter NUMBER(32,16), distance NUMBER(32,16));

/* Import the CSV files using SQL Loader the /users/home/66735a/shortestdisttomain_meter_NYC.ctl file
   on SASAL01P */

select * from gas_fcst_sat_NYC_dist_to_main

select max(shortestdisttomain_meter) from gas_fcst_sat_nyc_dist_to_main;

select * from gas_fcst_sat_nyc_dist_to_main
where shortestdisttomain_meter is null;
/* 41 */


select count(*), count(distinct record_id) from gas_fcst_sat_nyc_dist_to_main;
/* 7516	7516 */

drop table gas_fcst_sat_nyc_on_main;
commit;

create table gas_fcst_sat_nyc_on_main(id number(10),region varchar2(5),sitezip5 varchar2(5),market varchar2(5),trwunits number(10),numunits number(10),resi_flag number(10),comm_flag number(10),multi_flag number(10),record_id number(10));
/* Import the CSV files using SQL Loader the /users/home/66735a/Saturation_NYC_OnMain.ctl file
   on SASAL01P */

select * from gas_fcst_sat_nyc_on_main;

select count(*), count(distinct record_id) from gas_fcst_sat_nyc_on_main;
/* 24304	24304 */


update GAS_FORECAST_SATURATION_FINAL a
set a.CDE_ON_MAIN_LIMING = 0 
where record_id in(select distinct record_id from gas_fcst_sat_nyc_on_main)
and (CDE_ON_MAIN_LIMING <> 0
or CDE_ON_MAIN_LIMING is null) 
and region = 'NYC';
/* 24304 updated */

create index idx_gas_fcst_NYC_dist_to_main on gas_fcst_sat_NYC_dist_to_main(record_id);
commit;

update GAS_FORECAST_SATURATION_FINAL a
set DIST_TO_MAIN_LIMING = (select shortestdisttomain_meter*3.28084 
from gas_fcst_sat_NYC_dist_to_main b
where a.record_id = b.record_id)
where region = 'NYC';

select count(*) from GAS_FORECAST_SATURATION_FINAL
where DIST_TO_MAIN_LIMING is not null;
/* 298149 - 290674 = 7475 */


drop table gas_fcst_sat_unye_dist_to_main;

create table gas_fcst_sat_unye_dist_to_main(record_id number(10), shortestdisttomain_meter NUMBER(32,16), distance NUMBER(32,16));

/* Import the CSV files using SQL Loader the /users/home/66735a/shortestdisttomain_meter_UNYE.ctl file
   on SASAL01P */

select * from gas_fcst_sat_UNYE_dist_to_main

select max(shortestdisttomain_meter) from gas_fcst_sat_UNYE_dist_to_main;

select count(*) from gas_fcst_sat_unye_dist_to_main
where shortestdisttomain_meter is null;
/* 28263 */

select count(*), count(distinct record_id) from gas_fcst_sat_unye_dist_to_main;
/* 53957	53957 */

drop table gas_fcst_sat_unye_on_main;
commit;

create table gas_fcst_sat_unye_on_main(id number(10),region varchar2(5),sitezip5 varchar2(5),market varchar2(5),trwunits number(10),numunits number(10),resi_flag number(10),comm_flag number(10),multi_flag number(10),record_id number(10));
/* Import the CSV files using SQL Loader the /users/home/66735a/Saturation_unye_OnMain.ctl file
   on SASAL01P */

select * from gas_fcst_sat_unye_on_main;

select count(*), count(distinct record_id) from gas_fcst_sat_unye_on_main;
/* 18510	18510 */


update GAS_FORECAST_SATURATION_FINAL a
set a.CDE_ON_MAIN_LIMING = 0 
where record_id in(select distinct record_id from gas_fcst_sat_unye_on_main)
and (CDE_ON_MAIN_LIMING <> 0
or CDE_ON_MAIN_LIMING is null) 
and region = 'UNY';
/* 18494 updated */

create index idx_gas_fcst_UNYE_dist_to_main on gas_fcst_sat_UNYE_dist_to_main(record_id);
commit;

update GAS_FORECAST_SATURATION_FINAL a
set DIST_TO_MAIN_LIMING = (select shortestdisttomain_meter*3.28084 
from gas_fcst_sat_UNYE_dist_to_main b
where a.record_id = b.record_id)
where region = 'UNY';

/* ran up to here */

select count(*) from GAS_FORECAST_SATURATION_FINAL
where DIST_TO_MAIN_LIMING is not null;
/* 323811 - 298149  = 25662 */

commit;

/***** END Update Saturation with Liming's NYC and UNY On Main and Distance to Main *****/




/********** Update geocoded information with Moon's information from Core Logic ***************/
select count(*) from mi_saturation.corelogic_parcels_201611;-- (8027146 records)
select count(*) from mi_saturation.corelogic_points_201611;-- (13117136 records)


select * from mi_saturation.corelogic_parcels_201611;-- (8027146 records)
select * from mi_saturation.corelogic_points_201611;-- (13117136 records)


create index mi_saturation.idx_corelogic_points_201611 
on mi_saturation.corelogic_points_201611(translate(apn3,'&&#-/$,. ',' '),
trim(to_char(state_code,'00'))||trim(to_char(cnty_code,'000')));


alter table GAS_FORECAST_SATURATION_FINAL add(latitude_corelogic_points NUMBER(32,16),
longitude_corelogic_points NUMBER(32,16),
type_code_corelogic_points varchar2(5));

commit;

create table corelogic_points_201611 as
select a.*,
translate(a.apn3,'&&#-/$,. ',' ') as apn4,
trim(to_char(a.state_code,'00'))||trim(to_char(a.cnty_code,'000')) as state_county
from mi_saturation.corelogic_points_201611 a
;

create index idx_corelogic_pts_201611
on corelogic_points_201611(apn4, situzip5, state_county);
commit;

/* where there are duplicates, and one is a better address than the other, keep the better 
address, and drop the other */
delete from corelogic_points_201611 a
where a.situscr > any(select b.situscr from corelogic_points_201611 b
where a.apn4 = b.apn4
and a.situzip5 = b.situzip5
and a.state_county = b.state_county);
/* 190,893 deleted */
commit;

create table corelogic_points_201611_dupe2 as
select apn4,
state_county,
a.situzip5,
min(a.objectid) as objectid
from corelogic_points_201611 a
where a.apn3 is not null
group by apn4,
state_county,
a.situzip5
having count(*)>1;

create index idx_corelogic_pts_201611_dupe2
on corelogic_points_201611_dupe2(apn4, situzip5, state_county, objectid);
commit;

select count(*) from corelogic_points_201611_dupe2;
/* 197,094 */

/* see what the duplicates look like - are they mostly geocoded centroid from Stela already */
select a.franchise_zip, a.region, c.geo_description, count(*)
from GAS_FORECAST_SATURATION_FINAL a
join (select distinct apn4, situzip5 from corelogic_points_201611_dupe2) b
on a.id_apn_trw = b.apn4
and a.sitezip5 = b.situzip5
left join GAS_FCST_SAT_GEOCODE_MAP_STELA c
on a.sitestate = c.state
and a.loc_name = c.geo_result
group by a.franchise_zip, a.region, c.geo_description;

select a.* from corelogic_points_201611 a
join corelogic_points_201611_dupe b
on a.apn4 = b.apn4
and a.state_county = b.state_county
where a.apn4 in(select b.apn4
from GAS_FORECAST_SATURATION_FINAL a
join (select distinct apn4, situzip5 from corelogic_points_201611_dupe2) b
on a.id_apn_trw = b.apn4
and a.sitezip5 = b.situzip5
left join GAS_FCST_SAT_GEOCODE_MAP_STELA c
on a.sitestate = c.state
and a.loc_name = c.geo_result
where franchise_zip ='Y'
and (c.geo_description is null or  c.geo_description = 'interpolated'));


/**** According to Liming, pick one record from the duplicates randomly ****/
create table corelogic_points_201611_dedup1 as
select a.* 
from corelogic_points_201611 a
join corelogic_points_201611_dupe2 b
on a.apn4 = b.apn4
and a.situzip5 = b.situzip5
and a.state_county = b.state_county
and a.objectid = b.objectid
;

select count(*), count(distinct apn4), count(distinct apn4||situzip5), count(distinct objectid) from corelogic_points_201611_dedup1;
/* 197094 	196365	197094  197094 */

create index corelogic_points_201611_dedup1
on corelogic_points_201611_dedup1(apn4, situzip5, state_county);
commit;


/*** remove duplicate records from the base file ***/
delete from corelogic_points_201611 a
where exists(select * from corelogic_points_201611_dedup1 b
where a.apn4 = b.apn4
and a.situzip5 = b.situzip5
and a.state_county = b.state_county);
/* 611,614 deleted */

/**** Insert the duplicate records back into the base file after de-duping ****/
insert into corelogic_points_201611
select * from corelogic_points_201611_dedup1;

commit;


/*** Finally update the saturation table with the Core Logic geocoded data ***/
update GAS_FORECAST_SATURATION_FINAL b
set (latitude_corelogic_points, longitude_corelogic_points, type_code_corelogic_points) = (select
a.latitude, 
a.longitude,
a.type_code
from corelogic_points_201611 a
where a.apn4 is not null 
and b.county_fips is not null
and a.apn4 = b.id_apn_trw
and a.situzip5 = b.sitezip5
and a.state_county = b.county_fips);
/* 37 minutes */


/*** Stella needed tables to join customer to saturation */
create table Stela_cris_saturation as 
select distinct substr(a.acctnum,1,10) as id_acct10,
k.record_id
from GAS_FORECAST_cris_gas1 a
join gas_forecast_saturation_final k
on  a.sitehsenumb = k.sitehsenumb
and a.sitehsealph = k.sitehsealph
and a.sitestrprfx = k.sitestrprfx
and a.sitestrname = k.sitestrname
and a.sitestrsfx1 = k.sitestrsfx1
and a.sitestrsfx2 = k.sitestrsfx2
and a.sitezip5    = k.sitezip5
;

select count(*), count(distinct id_acct10) from Stela_cris_saturation;
/* 2549906	2549906 */

create table Stela_cris_saturation2 as 
select distinct substr(a.acctnum,1,10) as id_acct10,
k.record_id
from GAS_FORECAST_cris_gas1 a
join gas_forecast_saturation_final k
on  a.sitehsenumb = k.sitehsenumb
--and a.sitehsealph = k.sitehsealph
and a.sitestrprfx = k.sitestrprfx
and a.sitestrname = k.sitestrname
and a.sitestrsfx1 = k.sitestrsfx1
and a.sitestrsfx2 = k.sitestrsfx2
and a.sitezip5    = k.sitezip5
;

delete from Stela_cris_saturation2
where id_acct10 in(select id_acct10 from Stela_cris_saturation);

select count(*), count(distinct id_acct10) from Stela_cris_saturation2;
/* 1124	896 */

delete from Stela_cris_saturation2 a
where rowid < any(select rowid from Stela_cris_saturation2 b
where a.id_acct10 = b.id_acct10);
/* 228 deleted */

insert into Stela_cris_saturation
select * from Stela_cris_saturation2;

select count(*), count(distinct id_acct10) from Stela_cris_saturation;
/* 2550802	2550802 */


create table Stela_css_saturation as 
select distinct
b.ky_prem_no,
k.record_id
from GAS_FORECAST_css_gas1 a
join mi_css_prod.cu02tb01_bill_acct b
on to_number(a.acctnum) = b.ky_ba
join gas_forecast_saturation_final k
on  a.sitehsenumb = k.sitehsenumb
and a.sitehsealph = k.sitehsealph
and a.sitestrprfx = k.sitestrprfx
and a.sitestrname = k.sitestrname
and a.sitestrsfx1 = k.sitestrsfx1
and a.sitestrsfx2 = k.sitestrsfx2
and a.sitezip5    = k.sitezip5
;

select count(*), count(distinct ky_prem_no) from Stela_css_saturation;
/* 1616360	1616201 */

delete from Stela_css_saturation a
where rowid < any(select rowid from Stela_css_saturation b
where a.ky_prem_no = b.ky_prem_no)
;

select count(*), count(distinct ky_prem_no) from Stela_css_saturation;
/* 1616201	1616201 */

create table Stela_css_saturation2 as 
select distinct
b.ky_prem_no,
k.record_id
from GAS_FORECAST_css_gas1 a
join mi_css_prod.cu02tb01_bill_acct b
on to_number(a.acctnum) = b.ky_ba
join gas_forecast_saturation_final k
on  a.sitehsenumb = k.sitehsenumb
--and a.sitehsealph = k.sitehsealph
and a.sitestrprfx = k.sitestrprfx
and a.sitestrname = k.sitestrname
and a.sitestrsfx1 = k.sitestrsfx1
and a.sitestrsfx2 = k.sitestrsfx2
and a.sitezip5    = k.sitezip5
;

delete from Stela_css_saturation2 a
where ky_prem_no in(select ky_prem_no from Stela_css_saturation b)
;

delete from Stela_css_saturation2 a
where rowid < any(select rowid from Stela_css_saturation2 b
where a.ky_prem_no = b.ky_prem_no)
;

insert into Stela_css_saturation
select * from Stela_css_saturation2;

drop table Stela_css_saturation2;
drop table Stela_cris_saturation2;

select count(*), count(distinct ky_prem_no) from Stela_css_saturation;
/* 1619620	1619620 */
grant select on Stela_css_saturation to mihnevas, WESTRICH, superuser;
grant select on Stela_cris_saturation to mihnevas, WESTRICH, superuser;

/***** END OF STELA Needed tables to join customer to saturation *****/



select * from mi_css_prod.vs_cd_tar_rt_cl

select t.cd_tar_sch, 
tx_tar_sch_desc,
t.tx_tar_sch_bp_desc
from mi_css_prod.cu04tb05_tar_sch t
where cd_co = 12
and tx_tar_sch_desc like '%Gas%'

select t.cd_tar_sch, 
tx_tar_sch_desc,
t.tx_tar_sch_bp_desc
from mi_css_prod.cu04tb05_tar_sch t
where cd_co = 37
and tx_tar_sch_desc like '%Gas%'


/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/
/********************************** END OF SATURATION FINAL FILE CREATION *************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/

/* Run the Vacant Saturation code - Saturation_Vacant_Master.sql */


/**** Summary of Saturation ****/
select 
region, 
sitezip5, 
--gas_cust_found, 
franchise_zip, 
--surrounding_town,
constrained_zip_commercial, 
constrained_zip_residential, 
market, 
case
  when service is null then 'PROSPECT'
  else service
end as service,
case
  when a.cde_on_main_liming = 0 
       or (cde_on_main = 0 and a.cde_on_main_liming is null and a.dist_to_main_liming is null) 
       or service is not null then '  ON MAIN'
--  when region = 'NYC' then '  ON MAIN'
  when a.dist_to_main_liming between 0 and 100 then '  0 to 100 FT'
  when a.dist_to_main_liming is null and dist_to_main between 0 and 100 then '  0 to 100 FT'
  when a.dist_to_main_liming between 101 and 200 then '101 to 200 FT'
  when a.dist_to_main_liming is null and dist_to_main between 101 and 200 then '101 to 200 FT'
  when a.dist_to_main_liming between 201 and 300 then '201 to 300 FT'
  when a.dist_to_main_liming is null and dist_to_main between 201 and 300 then '201 to 300 FT'
  when a.dist_to_main_liming between 301 and 400 then '301 to 400 FT'
  when a.dist_to_main_liming is null and dist_to_main between 301 and 400 then '301 to 400 FT'
  when a.dist_to_main_liming between 401 and 500 then '401 to 500 FT'
  when a.dist_to_main_liming is null and dist_to_main between 401 and 500 then '401 to 500 FT'
  when a.dist_to_main_liming between 501 and 1000 then '501 to 1000 FT'
  when a.dist_to_main_liming is null and dist_to_main between 501 and 1000 then '501 to 1000 FT'
  else 'OVER 1000 FT'
end as Main_Distance,
--pros_heat_rate,
count(*) as Structure_Count
from GAS_FORECAST_SATURATION_FINAL a
group by
region, 
sitezip5, 
--gas_cust_found, 
franchise_zip, 
--surrounding_town,
constrained_zip_commercial, 
constrained_zip_residential, 
market, 
case
  when service is null then 'PROSPECT'
  else service
end,
case
  when a.cde_on_main_liming = 0 
       or (cde_on_main = 0 and a.cde_on_main_liming is null and a.dist_to_main_liming is null) 
       or service is not null then '  ON MAIN'
--  when region = 'NYC' then '  ON MAIN'
  when a.dist_to_main_liming between 0 and 100 then '  0 to 100 FT'
  when a.dist_to_main_liming is null and dist_to_main between 0 and 100 then '  0 to 100 FT'
  when a.dist_to_main_liming between 101 and 200 then '101 to 200 FT'
  when a.dist_to_main_liming is null and dist_to_main between 101 and 200 then '101 to 200 FT'
  when a.dist_to_main_liming between 201 and 300 then '201 to 300 FT'
  when a.dist_to_main_liming is null and dist_to_main between 201 and 300 then '201 to 300 FT'
  when a.dist_to_main_liming between 301 and 400 then '301 to 400 FT'
  when a.dist_to_main_liming is null and dist_to_main between 301 and 400 then '301 to 400 FT'
  when a.dist_to_main_liming between 401 and 500 then '401 to 500 FT'
  when a.dist_to_main_liming is null and dist_to_main between 401 and 500 then '401 to 500 FT'
  when a.dist_to_main_liming between 501 and 1000 then '501 to 1000 FT'
  when a.dist_to_main_liming is null and dist_to_main between 501 and 1000 then '501 to 1000 FT'
  else 'OVER 1000 FT'
end/*,
pros_heat_rate*/;


/************* Compare Last Saturation to current saturation *****************/


create table temp_Gas_Sat_Apr_2015 as
select 
a.region, 
a.market, 
case
  when a.service is null then 'PROSPECT'
  else a.service
end as service,
case
  when a.cde_on_main = 0 or service is not null then '  ON MAIN'
  when a.dist_to_main between 0 and 100 then '  0 to 100 FT'
  when a.dist_to_main between 101 and 200 then '101 to 200 FT'
  when a.dist_to_main between 201 and 300 then '201 to 300 FT'
  when a.dist_to_main between 301 and 400 then '301 to 400 FT'
  when a.dist_to_main between 401 and 500 then '401 to 500 FT'
  when a.dist_to_main between 501 and 1000 then '501 to 1000 FT'
  else 'OVER 1000 FT'
end as Main_Distance,
count(*) as Structure_Count
from GAS_FORECAST_SATURATION_FINAL a
where a.franchise_zip = 'Y' 
group by
a.region, 
a.market, 
case
  when a.service is null then 'PROSPECT'
  else a.service
end,
case
  when a.cde_on_main = 0 or service is not null then '  ON MAIN'
  when a.dist_to_main between 0 and 100 then '  0 to 100 FT'
  when a.dist_to_main between 101 and 200 then '101 to 200 FT'
  when a.dist_to_main between 201 and 300 then '201 to 300 FT'
  when a.dist_to_main between 301 and 400 then '301 to 400 FT'
  when a.dist_to_main between 401 and 500 then '401 to 500 FT'
  when a.dist_to_main between 501 and 1000 then '501 to 1000 FT'
  else 'OVER 1000 FT'
end;


create table temp_Gas_Sat_Jun_2014 as
select 
a.region, 
a.market, 
case
  when a.service is null then 'PROSPECT'
  else a.service
end as service,
case
  when a.cde_on_main = 0 or service is not null then '  ON MAIN'
  when a.dist_to_main between 0 and 100 then '  0 to 100 FT'
  when a.dist_to_main between 101 and 200 then '101 to 200 FT'
  when a.dist_to_main between 201 and 300 then '201 to 300 FT'
  when a.dist_to_main between 301 and 400 then '301 to 400 FT'
  when a.dist_to_main between 401 and 500 then '401 to 500 FT'
  when a.dist_to_main between 501 and 1000 then '501 to 1000 FT'
  else 'OVER 1000 FT'
end as Main_Distance,
count(*) as Structure_Count
from GAS_FCST_SAT_FINAL_MAY_2014 a
where a.franchise_zip = 'Y' 
group by
a.region, 
a.market, 
case
  when a.service is null then 'PROSPECT'
  else a.service
end,
case
  when a.cde_on_main = 0 or service is not null then '  ON MAIN'
  when a.dist_to_main between 0 and 100 then '  0 to 100 FT'
  when a.dist_to_main between 101 and 200 then '101 to 200 FT'
  when a.dist_to_main between 201 and 300 then '201 to 300 FT'
  when a.dist_to_main between 301 and 400 then '301 to 400 FT'
  when a.dist_to_main between 401 and 500 then '401 to 500 FT'
  when a.dist_to_main between 501 and 1000 then '501 to 1000 FT'
  else 'OVER 1000 FT'
end;

select * from temp_Gas_Sat_Jun_2014;
select * from temp_Gas_Sat_Apr_2015;

select a.*,
b.structure_count as struct_count_2014
from temp_Gas_Sat_Apr_2015 a
join temp_Gas_Sat_Jun_2014 b
on a.region = b.region
and a.market = b.market
and a.service = b.service
and a.main_distance = b.main_distance
order by a.region,
a.market,
a.service,
a.main_distance

/* can use this as a check
create index idx_GAS_FORECAST_SAT_FINAL_apn on GAS_FORECAST_SATURATION_FINAL(Id_Apn_Trw, Region, dist_to_main) tablespace large_index;
create index idx_GAS_FCST_SAT_JUN_2013_apn on GAS_FCST_SAT_FINAL_JUN_2013(Id_Apn_Trw, Region, dist_to_main) tablespace large_index;

select
a.id_apn_trw,
a.dist_to_main as dist_to_main_2014,
b.dist_to_main as dist_to_main_2013,
a.sitehsenumb as sitehsenumb_2014, 
a.sitehsealph as sitehsealph_2014, 
a.sitestrprfx as sitestrprfx_2014, 
a.sitestrname as sitestrname_2014, 
a.sitestrsfx1 as sitestrsfx1_2014, 
a.sitestrsfx2 as sitestrsfx2_2014, 
a.sitezip5    as sitezip5_2014, 
a.sitecity    as sitecity_2014, 
a.sitestate   as sitestate_2014, 
a.sitescr     as sitescr_2014,
b.sitehsenumb as sitehsenumb_2013,
b.sitehsealph as sitehsealph_2013,
b.sitestrprfx as sitestrprfx_2013,
b.sitestrname as sitestrname_2013,
b.sitestrsfx1 as sitestrsfx1_2013,
b.sitestrsfx2 as sitestrsfx2_2013,
b.sitezip5    as sitezip5_2013,   
b.sitecity    as sitecity_2013,   
b.sitestate   as sitestate_2013,  
b.sitescr     as sitescr_2013     
from GAS_FORECAST_SATURATION_FINAL a
join GAS_FCST_SAT_FINAL_JUN_2013 b
on a.id_apn_trw = b.id_apn_trw
where a.region = 'LI'
and a.service is null
and a.dist_to_main between 0 and 100
and b.dist_to_main > 1000;
*/


/**********************************************************************
**********************************************************************
Create a list joining Ted's file of use per customer 
GAS_FCST_NYC_LI_USAGE_BY_RATE imported from EXCEL file - 
Analysts\Chris\Dale_Kruchten\Gas_Forecast_Saturation\NY_UPC_Apr_2017.xlsx 
Sheet = ALL_NY_UPC 
**********************************************************************
**********************************************************************/
select * from GAS_FCST_USAGE_BY_RATE_2017;

create index idx_GAS_FCST_USG_BY_RATE_2017 on GAS_FCST_USAGE_BY_RATE_2017(REGION, Rate);

create or replace view GAS_FORECAST_SAT_view_2017 as
select a.*,
b.Annual_Consumption,
b.Peak_Day
from gas_forecast_saturation_final a
left join GAS_FCST_USAGE_BY_RATE_2017 b
on a.pros_heat_rate = b.rate
and a.region = b.region
;

select * from cpalmieri.GAS_FORECAST_SAT_view_2017;

grant all on GAS_FCST_USAGE_BY_RATE_2017 to miuser WITH GRANT OPTION;
grant select on GAS_FCST_USAGE_BY_RATE_2017 to superuser, CIAPWRITE, zhaowe, westrich, breed, mdematteo, mihnevas, mtsui, afill, lantryk, maugustine, zhoul, rbruney, sziksa, poet;
grant select on GAS_FORECAST_SAT_view_2017 to superuser, CIAPWRITE, breed, mdematteo, mihnevas, mtsui, afill, lantryk, maugustine, zhoul, rbruney, sziksa, poet;


select * from cpalmieri.GAS_FORECAST_SAT_view_2016  v
where region in('NYC','LI')
and (service is null or service = 'NONHEAT')
and comm_max_propensity is null and resi_propensity is null
and v.franchise_zip = 'Y'
;

select * from cpalmieri.GAS_FORECAST_SAT_view_2016;
select * from cpalmieri.gas_forecast_saturation_final;

select a.sitezip5, 
avg(a.mfam_heat_accts+a.coml_heat_accts), 
avg(a.mfam_nonheat_accts+a.coml_nonheat_accts),
avg(a.resi_heat_accts), 
avg(a.resi_nonheat_accts)
from cpalmieri.gas_forecast_saturation_final a
where a.service = 'HEATING'
and market = 'MFAM'
group by a.sitezip5

/******** Create Summary *******/
create table temp as
select 
region, 
sitezip5, 
--gas_cust_found, 
franchise_zip, 
--surrounding_town,
constrained_zip_commercial, 
constrained_zip_residential, 
market, 
case
  when service is null then 'PROSPECT'
  else service
end as service,
case
  when cde_on_main = 0 or service is not null then '  ON MAIN'
  when region = 'NYC' then '  ON MAIN'
  when dist_to_main between 0 and 100 then '  0 to 100 FT'
  when dist_to_main between 101 and 200 then '101 to 200 FT'
  when dist_to_main between 201 and 300 then '201 to 300 FT'
  when dist_to_main between 301 and 400 then '301 to 400 FT'
  when dist_to_main between 401 and 500 then '401 to 500 FT'
  when dist_to_main between 501 and 1000 then '501 to 1000 FT'
  else 'OVER 1000 FT'
end as Main_Distance,
--pros_heat_rate,
count(*) as Structure_Count
from GAS_FORECAST_SATURATION_FINAL
group by
region, 
sitezip5, 
--gas_cust_found, 
franchise_zip, 
--surrounding_town,
constrained_zip_commercial, 
constrained_zip_residential, 
market, 
case
  when service is null then 'PROSPECT'
  else service
end,
case
  when cde_on_main = 0 or service is not null then '  ON MAIN'
  when region = 'NYC' then '  ON MAIN'
  when dist_to_main between 0 and 100 then '  0 to 100 FT'
  when dist_to_main between 101 and 200 then '101 to 200 FT'
  when dist_to_main between 201 and 300 then '201 to 300 FT'
  when dist_to_main between 301 and 400 then '301 to 400 FT'
  when dist_to_main between 401 and 500 then '401 to 500 FT'
  when dist_to_main between 501 and 1000 then '501 to 1000 FT'
  else 'OVER 1000 FT'
end/*,
pros_heat_rate*/;

/* I had to break out the GROUP BY separately because the case statements proved too complicated
   for Oracle to be able to do the order by in the above SQL statement */
select * from temp
order by
region,
sitezip5, 
gas_cust_found, 
franchise_zip, 
surrounding_town,
constrained_zip_commercial, 
constrained_zip_residential, 
market, 
service,
Main_Distance,
pros_heat_rate




/* Test for unmatched TRW data */
select sitescr, count(*) from GAS_FORECAST_SATURATION_FINAL
where region = 'NYC'
and service is null
and franchise_zip = 'Y'
and market = 'RESID'
group by sitescr;

select txt_county_use1_trw, count(*) from GAS_FORECAST_SATURATION_FINAL
where region = 'NYC'
and service is null
and franchise_zip = 'Y'
and market = 'RESID'
group by txt_county_use1_trw;

select a.sitezip5, a.sitecity, count(*) from GAS_FORECAST_SATURATION_FINAL a
where region = 'NYC'
and service is null
and franchise_zip = 'Y'
and market = 'RESID'
group by a.sitezip5, a.sitecity;

select * from GAS_FORECAST_SATURATION_FINAL a
where region = 'NYC'
and service is null
and franchise_zip = 'Y'
and market = 'RESID'
and sitezip5 = '11214'
;

select * from mi_cris_prod.cris_active_acct_view a
where a.SITUSTNM = 'BAY 38'
where a.ACCTNUM = '02044339404';

select * from GAS_FORECAST_SATURATION_FINAL a
where region = 'NYC'
and service is null
and franchise_zip = 'Y'
and market = 'RESID'
and sitezip5 = '11214'
and a.sitestrname = 'CROPSEY';

select * from mi_cris_prod.cris_active_acct_view a
where a.SITUSTNM = 'CROPSEY';


select a.sitestrname, 
substr(sitestrname, 1,length(sitestrname)-2) as strtnm2,
case
  when substr(sitestrname,length(sitestrname)-1,2) in('ST', 'ND', 'RD', 'TH') then substr(sitestrname, 1,length(sitestrname)-2)
  else sitestrname
end as sitestrname2
from GAS_FORECAST_SATURATION_FINAL a
where region = 'NYC'
and service is null
and franchise_zip = 'Y'
and market = 'RESID'
and sitezip5 = '11214'
;

select count(*)
from GAS_FORECAST_SATURATION_FINAL a
where region = 'RI'
and service is null
and franchise_zip = 'Y'
and market = 'RESID'
and sitezip5 = '11214'
;

--create index idx_gas_fcst_sat_rec_id on GAS_FORECAST_SATURATION_FINAL(record_id);

select * from GAS_FORECAST_SATURATION_FINAL where record_id = 101203

select * from miuser.zip_master_table
where state_abbrev = 'MA';

select * from GAS_FORECAST_RI_GEOCODED

/* Add Core Logic piece to Saturation */
select * from mi_saturation.corelogic_parcels_201611;
select distinct type_code from mi_saturation.corelogic_points_201611
where apn3 is not null;

MA is all address
mi_saturation.corelogic_parcels_201611



/********************************************************************************/
/********************************************************************************/
/******************** Just some notes from here down ****************************/
/********************************************************************************/
/********************************************************************************/

/* File that Stela created for pinning Rates to TRW records - Did Not Use These */
select * from mihnevas.saturation_1_adrs_bucket_high;
select * from mihnevas.saturation_2_bckt_rte_casli_h;
select * from mihnevas.saturation_2_bckt_rte_crsma_h; 
select * from mihnevas.saturation_2_bckt_rte_crsnh_h; 
select * from mihnevas.saturation_2_bckt_rte_crsny_h; 
select * from mihnevas.saturation_2_bckt_rte_cssnyv_h;
select * from mihnevas.saturation_2_bckt_rte_cssri_h;



/**** Tables to use to create final customer table ****/
GAS_FORECAST_all_cust_units /* contains the designation of MF and RESID by structure - only counts resi and MF accounts */
GAS_FORECAST_COMM_TC /* contains the TC structures - if we have a residential account where a TC account exists, make it MF */

gas_forecast_cntyuse_market /* contains the TRW county use codes, decodes, and market designations for all regions except for NH */
gas_forecast_rate_market_srvc /* Contains the gas rates and descriptions and their market and type of service designations */

/******** Create Summary for Iroquois Pipeline into LI - Join to Leo's file *******/
select 
region, 
sitezip5, 
gas_cust_found, 
franchise_zip, 
surrounding_town,
constrained_zip_commercial, 
constrained_zip_residential, 
market, 
case
  when service is null then 'PROSPECT'
  else service
end as service,
case
  when cde_on_main = 0 then '  ON MAIN'
  when dist_to_main between 0 and 100 then '  0 to 100 FT'
  when dist_to_main between 101 and 200 then '101 to 200 FT'
  when dist_to_main between 201 and 300 then '201 to 300 FT'
  when dist_to_main between 301 and 400 then '301 to 400 FT'
  when dist_to_main between 401 and 500 then '401 to 500 FT'
  when dist_to_main between 501 and 1000 then '501 to 1000 FT'
  else 'OVER 1000 FT'
end as Main_Distance,
pros_heat_rate,
count(*) as Structure_Count
from GAS_FORECAST_SATURATION_FINAL
where sitezip5 in('11764','11789','11778','11766','11786','117HH','11776','11961','11780','11780',
'11727','11953','11720','11784','11755','11725','11763','11980','11967','11767','11738','11779','11788',
'11742','11950','11741','11722','11717','11713','11719','11772','11716','11706','11752','11705','11782',
'11715','11751','11769','11730','11796','11718','11933','117HH','11777','11777','11733','11792','11768',
'11961','11790','117HH','11949','117HH','11754','11787','11955','119HH','11951')
group by
region, 
sitezip5, 
gas_cust_found, 
franchise_zip, 
surrounding_town,
constrained_zip_commercial, 
constrained_zip_residential, 
market, 
case
  when service is null then 'PROSPECT'
  else service
end,
case
  when cde_on_main = 0 then '  ON MAIN'
  when dist_to_main between 0 and 100 then '  0 to 100 FT'
  when dist_to_main between 101 and 200 then '101 to 200 FT'
  when dist_to_main between 201 and 300 then '201 to 300 FT'
  when dist_to_main between 301 and 400 then '301 to 400 FT'
  when dist_to_main between 401 and 500 then '401 to 500 FT'
  when dist_to_main between 501 and 1000 then '501 to 1000 FT'
  else 'OVER 1000 FT'
end,
pros_heat_rate
order by
region, 
sitezip5, 
gas_cust_found, 
franchise_zip, 
surrounding_town,
constrained_zip_commercial, 
constrained_zip_residential, 
market, 
case
  when service is null then 'PROSPECT'
  else service
end,
case
  when cde_on_main = 0 then '  ON MAIN'
  when dist_to_main between 0 and 100 then '  0 to 100 FT'
  when dist_to_main between 101 and 200 then '101 to 200 FT'
  when dist_to_main between 201 and 300 then '201 to 300 FT'
  when dist_to_main between 301 and 400 then '301 to 400 FT'
  when dist_to_main between 401 and 500 then '401 to 500 FT'
  when dist_to_main between 501 and 1000 then '501 to 1000 FT'
  else 'OVER 1000 FT'
end,
pros_heat_rate
;

select * from GAS_FORECAST_RI_GPM_FILE;

select service, count(*)
from gas_forecast_saturation_final a
where a.region = 'RI'
group by service;


select market, sqr_ft_group, count(*) from gas_forecast_saturation_final
group by market, sqr_ft_group

create index idx_GAS_FCST2_SAT_FINAL on GAS_FCST2_SATURATION_FINAL(Record_Id);

/* Update the original gas saturation file with the updated prospective rates 
update GAS_FORECAST_SATURATION_FINAL a
set a.Pros_Heat_Rate = (select b.Pros_Heat_Rate from GAS_FCST2_SATURATION_FINAL b
where a.record_id = b.record_id)
where exists(select * from GAS_FCST2_SATURATION_FINAL b
where a.record_id = b.record_id)


drop table GAS_FORECAST_TRW_HT_Rate_Match;
drop table GAS_FORECAST_CUST_HT_Rate_Mtch;
drop table GAS_FORECAST_TRW_Rt_Mtch_cnty ;
drop table GAS_FORECAST_CUST_Rt_Mtch_cnty;
drop table GAS_FORECAST_CUST_Rt_Mtch2    ;
drop table GAS_FORECAST_TRW_Rt_Mtch_cnty2;
drop table GAS_FORECAST_TRW_Rt_Mtch_cnty3;
drop table GAS_FORECAST_TRW_Rt_Mtch_rgn  ;
drop table GAS_FORECAST_TRW_Rt_sub_rgn   ;
drop table GAS_FORECAST_TRW_Rt_mkt_rgn   ;

create table GAS_FORECAST_TRW_HT_Rate_Match as select * from GAS_FCST2_TRW_HT_Rate_Match ;
create table GAS_FORECAST_CUST_HT_Rate_Mtch as select * from GAS_FCST2_CUST_HT_Rate_Mtch ;
create table GAS_FORECAST_TRW_Rt_Mtch_cnty  as select * from GAS_FCST2_TRW_Rt_Mtch_cnty  ;
create table GAS_FORECAST_CUST_Rt_Mtch_cnty as select * from GAS_FCST2_CUST_Rt_Mtch_cnty ;
create table GAS_FORECAST_CUST_Rt_Mtch2     as select * from GAS_FCST2_CUST_Rt_Mtch2     ;
create table GAS_FORECAST_TRW_Rt_Mtch_cnty2 as select * from GAS_FCST2_TRW_Rt_Mtch_cnty2 ;
create table GAS_FORECAST_TRW_Rt_Mtch_cnty3 as select * from GAS_FCST2_TRW_Rt_Mtch_cnty3 ;
create table GAS_FORECAST_TRW_Rt_Mtch_rgn   as select * from GAS_FCST2_TRW_Rt_Mtch_rgn   ;
create table GAS_FORECAST_TRW_Rt_sub_rgn    as select * from GAS_FCST2_TRW_Rt_sub_rgn    ;
create table GAS_FORECAST_TRW_Rt_mkt_rgn    as select * from GAS_FCST2_TRW_Rt_mkt_rgn    ;
*/

select 
a.record_id,
a.Pros_Heat_Rate as Revised_rate,
a.dist_to_main, 
a.cde_on_main,
b.Pros_Heat_Rate as Original_rate
from GAS_FCST2_SATURATION_FINAL a
join gas_forecast_saturation_final b
on  a.record_id = b.record_id   
where a.Pros_Heat_Rate <> b.Pros_Heat_Rate
and (a.service is null or a.service = 'NONHEAT')


/****************************************************************************************************************/
/****************************************************************************************************************/
/************** FINAL SUMMARY FILES GIVEN TO MIKE D   ***********************************************************/
/****************************************************************************************************************/
/****************************************************************************************************************/

/* MA summary joined to Leo's file */
/******** Create MA Summary *******/
drop table temp_ma;

create table temp_ma as
select 
a.region, 
a.sitezip5, 
a.gas_cust_found, 
a.franchise_zip, 
a.surrounding_town,
a.constrained_zip_commercial, 
a.constrained_zip_residential, 
a.market, 
case
  when a.service is null then 'PROSPECT'
  else a.service
end as service,
case
  when a.cde_on_main = 0 or service is not null then '  ON MAIN'
  when a.dist_to_main between 0 and 100 then '  0 to 100 FT'
  when a.dist_to_main between 101 and 200 then '101 to 200 FT'
  when a.dist_to_main between 201 and 300 then '201 to 300 FT'
  when a.dist_to_main between 301 and 400 then '301 to 400 FT'
  when a.dist_to_main between 401 and 500 then '401 to 500 FT'
  when a.dist_to_main between 501 and 1000 then '501 to 1000 FT'
  else 'OVER 1000 FT'
end as Main_Distance,
/* a.pros_heat_rate, */
count(*) as Structure_Count,
sum(ANNUAL_DOLLAR_PER_DTH) as ANNUAL_DOLLAR_PER_DTH,
sum(ANNUAL_DOLLAR_PER_CUS) as ANNUAL_DOLLAR_PER_CUS,
sum(ANNUAL_DTH_PER_CUS   ) as ANNUAL_DTH_PER_CUS   ,
avg(PEAK_DAY_DTH_PER_CUS ) as PEAK_DAY_DTH_PER_CUS
from GAS_FORECAST_SATURATION_FINAL a
join miuser.zip_master_table z
on a.sitezip5 = z.zip5
left join cpalmieri.GAS_FORECAST_MA_GPM_FILE g
on a.pros_heat_rate = substr(g.css_codes,2,3)
and z.kyspn_cmpny_dc = g.gas_co
where a.region = 'MA'
/*and (a.franchise_zip = 'Y' or a.gas_cust_found = 'Y')*/
group by
a.region, 
a.sitezip5, 
a.gas_cust_found, 
a.franchise_zip, 
a.surrounding_town,
a.constrained_zip_commercial, 
a.constrained_zip_residential, 
a.market, 
case
  when a.service is null then 'PROSPECT'
  else a.service
end,
case
  when a.cde_on_main = 0 or service is not null then '  ON MAIN'
  when a.dist_to_main between 0 and 100 then '  0 to 100 FT'
  when a.dist_to_main between 101 and 200 then '101 to 200 FT'
  when a.dist_to_main between 201 and 300 then '201 to 300 FT'
  when a.dist_to_main between 301 and 400 then '301 to 400 FT'
  when a.dist_to_main between 401 and 500 then '401 to 500 FT'
  when a.dist_to_main between 501 and 1000 then '501 to 1000 FT'
  else 'OVER 1000 FT'
end/*,
a.pros_heat_rate*/;




/* I had to break out the GROUP BY separately because the case statements proved too complicated
   for Oracle to be able to do the order by in the above SQL statement */
select * from temp_ma
order by
region,
sitezip5, 
gas_cust_found, 
franchise_zip, 
surrounding_town,
constrained_zip_commercial, 
constrained_zip_residential, 
market, 
service,
Main_Distance,
pros_heat_rate;


/* Create a combined table for the other regions */

select count(*), sum(resi_nonheat_accts) from GAS_FORECAST_SATURATION_FINAL a
where region = 'UNY'
and service = 'NONHEAT';


select * from GAS_FORECAST_NOT_MA_GPM_FILE

/******** Create all other regions outside of MA Summary *******/
drop table temp_not_ma;

create table temp_not_ma as
select 
a.region, 
a.sitezip5, 
a.gas_cust_found, 
a.franchise_zip, 
a.surrounding_town,
a.constrained_zip_commercial, 
a.constrained_zip_residential, 
a.market, 
case
  when a.service is null then 'PROSPECT'
  else a.service
end as service,
case
  when a.cde_on_main = 0 or service is not null then '  ON MAIN'
  when a.dist_to_main between 0 and 100 then '  0 to 100 FT'
  when a.dist_to_main between 101 and 200 then '101 to 200 FT'
  when a.dist_to_main between 201 and 300 then '201 to 300 FT'
  when a.dist_to_main between 301 and 400 then '301 to 400 FT'
  when a.dist_to_main between 401 and 500 then '401 to 500 FT'
  when a.dist_to_main between 501 and 1000 then '501 to 1000 FT'
  else 'OVER 1000 FT'
end as Main_Distance,
/*a.pros_heat_rate, */
count(*) as Structure_Count,
sum(ANNUAL_DOLLAR_PER_DTH) as ANNUAL_DOLLAR_PER_DTH,
sum(ANNUAL_DOLLAR_PER_CUS) as ANNUAL_DOLLAR_PER_CUS,
sum(ANNUAL_DTH_PER_CUS   ) as ANNUAL_DTH_PER_CUS   ,
avg(PEAK_DAY_DTH_PER_CUS ) as PEAK_DAY_DTH_PER_CUS
from GAS_FORECAST_SATURATION_FINAL a
left join cpalmieri.GAS_FORECAST_NOT_MA_GPM_FILE g
on a.pros_heat_rate = g.css_codes
and a.region = g.region
where a.region not in('MA','NH')
/*and (a.franchise_zip = 'Y' or a.gas_cust_found = 'Y')*/
group by
a.region, 
a.sitezip5, 
a.gas_cust_found, 
a.franchise_zip, 
a.surrounding_town,
a.constrained_zip_commercial, 
a.constrained_zip_residential, 
a.market, 
case
  when a.service is null then 'PROSPECT'
  else a.service
end,
case
  when a.cde_on_main = 0 or service is not null then '  ON MAIN'
  when a.dist_to_main between 0 and 100 then '  0 to 100 FT'
  when a.dist_to_main between 101 and 200 then '101 to 200 FT'
  when a.dist_to_main between 201 and 300 then '201 to 300 FT'
  when a.dist_to_main between 301 and 400 then '301 to 400 FT'
  when a.dist_to_main between 401 and 500 then '401 to 500 FT'
  when a.dist_to_main between 501 and 1000 then '501 to 1000 FT'
  else 'OVER 1000 FT'
end/*,
a.pros_heat_rate*/;


select * from GAS_FORECAST_NOT_MA_GPM_FILE
where css_codes in(
select css_codes from GAS_FORECAST_NOT_MA_GPM_FILE
group by css_codes
having count(*)>1);


select css_codes, g.region, count(*) from GAS_FORECAST_NOT_MA_GPM_FILE g
group by css_codes, g.region
having count(*)>1;

/* I had to break out the GROUP BY separately because the case statements proved too complicated
   for Oracle to be able to do the order by in the above SQL statement */

select * from(
select * from temp_not_ma
union select * from temp_ma)
order by
region,
sitezip5, 
gas_cust_found, 
franchise_zip, 
surrounding_town,
constrained_zip_commercial, 
constrained_zip_residential, 
market, 
service,
Main_Distance/*,
pros_heat_rate*/;


grant all on GAS_FORECAST_SATURATION_FINAL to miuser WITH GRANT OPTION;
grant all on GAS_FORECAST_NOT_MA_GPM_FILE to miuser WITH GRANT OPTION;
grant all on GAS_FORECAST_MA_GPM_FILE to miuser WITH GRANT OPTION;

/* Create a file that distributes the region descriptions such as Western, Northeast, etc... */
select * from mi_css_prod.cu01tb01_sad a
where a.ad_serv_zip = 13166


create table region_zip as
select 
to_char(s.ad_serv_zip,'00000') as zip,
s.CD_REGION,
CASE s.CD_REGION
  WHEN '001' THEN 'BAY STATE WEST '
  WHEN '002' THEN 'BAY STATE SOUTH'
  WHEN '003' THEN 'BAY STATE NORTH'
  WHEN '004' THEN 'OCEAN STATE    '
  WHEN '005' THEN 'GRANITE STATE  '
  WHEN '006' THEN 'NANTUCKET      '
  WHEN '048' THEN 'FRONTIER       '
  WHEN '050' THEN 'WESTERN        '
  WHEN '054' THEN 'CENTRAL        '
  WHEN '056' THEN 'MOHAWK VALLEY  '
  WHEN '057' THEN 'NORTHERN       '
  WHEN '060' THEN 'CAPITAL        '
  WHEN '062' THEN 'NORTHEAST      '
  WHEN '300' THEN 'ESCO           '
  ELSE 'UNKNOWN        '
END AS REGION_DESC,
count(*) as numrecs
from mi_css_prod.cu01tb01_sad s
where cd_sad_stat = '03'
group by s.ad_serv_zip,
s.CD_REGION,
CASE s.CD_REGION
  WHEN '001' THEN 'BAY STATE WEST '
  WHEN '002' THEN 'BAY STATE SOUTH'
  WHEN '003' THEN 'BAY STATE NORTH'
  WHEN '004' THEN 'OCEAN STATE    '
  WHEN '005' THEN 'GRANITE STATE  '
  WHEN '006' THEN 'NANTUCKET      '
  WHEN '048' THEN 'FRONTIER       '
  WHEN '050' THEN 'WESTERN        '
  WHEN '054' THEN 'CENTRAL        '
  WHEN '056' THEN 'MOHAWK VALLEY  '
  WHEN '057' THEN 'NORTHERN       '
  WHEN '060' THEN 'CAPITAL        '
  WHEN '062' THEN 'NORTHEAST      '
  WHEN '300' THEN 'ESCO           '
  ELSE 'UNKNOWN        '
END
order by s.ad_serv_zip,
count(*) desc ;

delete from region_zip where region_desc = 'UNKNOWN';

delete from region_zip a
where rowid > any(select rowid from region_zip b where a.zip = b.zip);

create table gas_fcst_region_zip as
select trim(zip) as zip, region_desc 
from region_zip;

grant all on gas_fcst_region_zip to miuser with grant option;

grant select on gas_fcst_region_zip to mdematteo;

grant select on GAS_FORECAST_CNTYUSE_MARKET to superuser, mihnevas, mdematteo, mtsui, afill, lantryk, arcana, maugustine, CIAPWRITE;

grant select on cpalmieri.GAS_FCST_SAT_FINAL_JAN_2013 to mihnevas, mdematteo, mtsui, afill, lantryk, arcana, maugustine;

select * from gas_fcst_region_zip

select count(*) from gas_fcst_region_zip;
/* 1447 */

/**** SUMMARY for SUE Tucker *****/
create table temp_Sue_T as
select 
a.region, 
a.sitezip5, 
a.gas_cust_found, 
a.franchise_zip, 
a.surrounding_town,
a.constrained_zip_commercial, 
a.constrained_zip_residential, 
a.market, 
case
  when a.service is null then 'PROSPECT'
  else a.service
end as service,
case
  when a.cde_on_main = 0 or service is not null then '  ON MAIN'
  when a.dist_to_main between 0 and 100 then '  0 to 100 FT'
  when a.dist_to_main between 101 and 200 then '101 to 200 FT'
  when a.dist_to_main between 201 and 300 then '201 to 300 FT'
  when a.dist_to_main between 301 and 400 then '301 to 400 FT'
  when a.dist_to_main between 401 and 500 then '401 to 500 FT'
  when a.dist_to_main between 501 and 1000 then '501 to 1000 FT'
  else 'OVER 1000 FT'
end as Main_Distance,
count(*) as Structure_Count,
sum(ANNUAL_DOLLAR_PER_DTH) as ANNUAL_DOLLAR_PER_DTH,
sum(ANNUAL_DOLLAR_PER_CUS) as ANNUAL_DOLLAR_PER_CUS,
sum(ANNUAL_DTH_PER_CUS   ) as ANNUAL_DTH_PER_CUS   ,
avg(PEAK_DAY_DTH_PER_CUS ) as PEAK_DAY_DTH_PER_CUS
from GAS_FORECAST_SATURATION_FINAL a
left join cpalmieri.GAS_FORECAST_NOT_MA_GPM_FILE g
on a.pros_heat_rate = g.css_codes
and a.region = g.region
where a.region not in('MA','NH')
/*and (a.franchise_zip = 'Y' or a.gas_cust_found = 'Y')*/
group by
a.region, 
a.sitezip5, 
a.gas_cust_found, 
a.franchise_zip, 
a.surrounding_town,
a.constrained_zip_commercial, 
a.constrained_zip_residential, 
a.market, 
case
  when a.service is null then 'PROSPECT'
  else a.service
end,
case
  when a.cde_on_main = 0 or service is not null then '  ON MAIN'
  when a.dist_to_main between 0 and 100 then '  0 to 100 FT'
  when a.dist_to_main between 101 and 200 then '101 to 200 FT'
  when a.dist_to_main between 201 and 300 then '201 to 300 FT'
  when a.dist_to_main between 301 and 400 then '301 to 400 FT'
  when a.dist_to_main between 401 and 500 then '401 to 500 FT'
  when a.dist_to_main between 501 and 1000 then '501 to 1000 FT'
  else 'OVER 1000 FT'
end;


/** Put this view on MIUSER */
create or replace view miuser.gas_fcst_sat_final_w_gpm_view as
select 
/* remove triple and double spaces from the siteline1 */
REPLACE(
REPLACE(
trim(trim(a.sitehsenumb)||' '||
trim(a.sitehsealph)||' '||
trim(a.sitestrprfx)||' '||
trim(a.sitestrname)||' '||trim(a.Sitestrsfx1)||' '||trim(a.sitestrsfx2))
,'   ',' '),'  ',' ')  as siteline1,
a.*,
r.region_desc,
g.css_codes,
g.rate_code,
g.title,
g.annual_dollar_per_dth,
g.annual_dollar_per_cus,
g.annual_dth_per_cus,
g.peak_day_dth_per_cus
from cpalmieri.GAS_FORECAST_SATURATION_FINAL a
left join cpalmieri.GAS_FORECAST_NOT_MA_GPM_FILE g
on a.pros_heat_rate = g.css_codes
and a.region = g.region
left join cpalmieri.gas_fcst_region_zip r
on a.sitezip5 = r.zip
where a.region not in('MA','NH')
union all 
select
/* remove triple and double spaces from the siteline1 */
REPLACE(
REPLACE(
trim(trim(a.sitehsenumb)||' '||
trim(a.sitehsealph)||' '||
trim(a.sitestrprfx)||' '||
trim(a.sitestrname)||' '||trim(a.Sitestrsfx1)||' '||trim(a.sitestrsfx2))
,'   ',' '),'  ',' ')  as siteline1,
a.*,
r.region_desc,
g.css_codes,
g.rate_code,
g.title,
g.annual_dollar_per_dth,
g.annual_dollar_per_cus,
g.annual_dth_per_cus,
g.peak_day_dth_per_cus
from cpalmieri.GAS_FORECAST_SATURATION_FINAL a
join miuser.zip_master_table z
on a.sitezip5 = z.zip5
left join cpalmieri.GAS_FORECAST_MA_GPM_FILE g
on a.pros_heat_rate = substr(g.css_codes,2,3)
and z.kyspn_cmpny_dc = g.gas_co
left join cpalmieri.gas_fcst_region_zip r
on a.sitezip5 = r.zip;
where a.region = 'MA';

select * from miuser.gas_fcst_sat_final_w_gpm_view a
where a.sitezip5 = '13166';

select * from cpalmieri.GAS_FORECAST_SATURATION_FINAL
where surrounding_town = 'Y';

