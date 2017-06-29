select * from gas_forecast_cntyuse_market
where market like '%VAC%';

drop table gas_forecast_vacant_pros_rate ;
drop table gas_forecast_vacant_pros_rate2 ;

/* rename last year's table to keep it for historical purposes */
alter table cpalmieri.gas_forecast_vacant1 rename to GAS_FCST_SAT_VACANT_MAY_2016;
alter index idx_GAS_FORECAST_Vac_SAT_FINAL rename to idx_GAS_FORECAST_Vac_SAT_FIN16;

/************************************************/
/************************************************/
/****** Begin Code to Create Vacant file ********/
/***** Run this After Creating Main Saturation **/
/************************************************/
create table gas_forecast_vacant1 as
select b.cde_state_trw, 
b.cde_county_trw, 
b.id_apn_trw, 
b.adr_situs_hse_num_trw, 
b.adr_situs_hse_alpha_trw,
b.adr_situs_str_prfx_trw, 
b.adr_situs_str_nme_trw, 
b.adr_situs_str_sufx1_trw, 
b.adr_situs_str_sufx2_trw, 
b.adr_situs_city_trw, 
b.adr_situs_state_trw, 
b.adr_situs_zip_trw, 
t.adr_situs_zip4_trw,
b.cde_situs_code1_score_trw, 
b.num_yr_built_actl_trw, 
b.num_yr_built_eff_trw, 
b.qty_area_univ_bldg_trw, 
b.qty_area_bldg_trw, 
b.qty_area_living_trw, 
b.qty_area_ground_fl_trw, 
b.qty_area_bldg_gross_trw, 
b.qty_area_bldg_adj_trw, 
b.qty_area_basement_trw, 
b.qty_stories_trw, 
b.qty_unit_trw, 
b.txt_county_use1_trw, 
b.dte_last_update, 
b.num_situs_lp_dist_trw, 
b.num_situs_hp_dist_trw, 
b.num_situs_main_dist_trw, 
b.cde_situs_on_main_trw, 
b.region, 
b.gas_cust_found, 
b.franchise_zip, 
b.surrounding_town, 
b.constrained_zip_commercial, 
b.constrained_zip_residential, 
b.dcd_zip_code_type, 
b.description, 
b.market,
case
  when a.market is not null then a.market
  when b.market = 'VACANT-RESI' then 'RESID'
  when b.market = 'VACANT-COMM' then 'COML'
  when b.market in('PUBLIC LAND', 'PUBLIC SVCS', 'VACANT-UNDVLPBL') then 'UNDEVELOPABLE'
  else 'UNKNOWN'
end as vacant_market,
case
  when b.region in('MA','NH') and b.num_situs_main_dist_trw = -1 then 99999
  when b.region in('MA','NH') and b.num_situs_main_dist_trw > -1 then b.num_situs_main_dist_trw
  when b.region not in('MA','NH') and b.num_situs_lp_dist_trw >= 0 and b.num_situs_lp_dist_trw < b.num_situs_hp_dist_trw then b.num_situs_lp_dist_trw
  when b.region not in('MA','NH') and b.num_situs_hp_dist_trw >= 0 and b.num_situs_hp_dist_trw <= b.num_situs_lp_dist_trw then b.num_situs_hp_dist_trw
  else 99999
end as dist_to_main,
case
  when b.cde_situs_on_main_trw = 0 then 0
  else 99999
end as cde_on_main,
case 
  when a.service = 'HEATING' then a.cde_rte
  when a.SiteZip5 is not null then a.pros_heat_rate
  else 'UNKNOWN'
end as pros_heat_rate,
case 
  when a.SiteZip5 is not null then 1
  else 0
end as saturation_match
from gas_forecast_TRW_Master b
join mi_edr_prod.edr_trw t
on b.id_apn_trw = t.id_apn_trw
and b.cde_state_trw = t.cde_state_trw
and b.cde_county_trw = t.cde_county_trw
left join cpalmieri.gas_forecast_saturation_final a
on  a.Sitehsenumb = b.adr_situs_hse_num_trw  
and a.sitehsealph = b.adr_situs_hse_alpha_trw
and a.Sitestrprfx = b.adr_situs_str_prfx_trw 
and a.Sitestrname = b.adr_situs_str_nme_trw  
and a.Sitestrsfx1 = b.adr_situs_str_sufx1_trw
and a.Sitestrsfx2 = b.adr_situs_str_sufx2_trw
and a.SiteZip5    = b.adr_situs_zip_trw
and a.Sitestrname <> ' '
where b.market like '%VAC%' or b.market like '%PUB%'
and b.cde_state_trw <> '33'; /* New Hampshire */

select count(*) from gas_forecast_vacant1;
/* 
1,106,715 Apr 2017
1,028,237 Mar 2016
1,031,229 Apr 2015
1,016,837 Apr 2014
818,529 */


select region, market, count(*)
from gas_forecast_vacant1
group by region, market;

select region, vacant_market, count(*)
from gas_forecast_vacant1
group by region, vacant_market;

select region, pros_heat_rate, saturation_match, count(*)
from gas_forecast_vacant1
group by region, pros_heat_rate, saturation_match;

select region, vacant_market, pros_heat_rate, saturation_match, count(*)
from gas_forecast_vacant1
group by region, vacant_market, pros_heat_rate, saturation_match;

/* delete the duplicates by APN and city and state */
delete from gas_forecast_vacant1 a
where rowid > any(select rowid from gas_forecast_vacant1 b
where a.cde_state_trw  = b.cde_state_trw
and a.cde_county_trw   = b.cde_county_trw
and a.id_apn_trw       = b.id_apn_trw
);
/* 0 deleted */

select count(*) from gas_forecast_vacant1;
/* 
Apr 2017 1106715
Mar 2016 1028237
Apr 2015 1031229
Apr 2014 1016837
818,529 */

/* create a table by zip and market to get the most common heating rates for the unknown pros_heat_rate */
create table gas_forecast_vacant_pros_rate as
select sitezip5,
market,  
cde_rte, count(*) as rte_cnt
from cpalmieri.gas_forecast_saturation_final
where service = 'HEATING'
group by sitezip5,
market,  
cde_rte
order by
sitezip5,
market,  
count(*) desc;

select * from gas_forecast_vacant_pros_rate;

/* Remove the duplicate zip and market keeping the rate with the highest number of occurances */
delete from gas_forecast_vacant_pros_rate a
where rowid > any(select rowid from gas_forecast_vacant_pros_rate b
where a.sitezip5 = b.sitezip5
and a.market = b.market)
;
/* 
Apr 2017 - 5255 deleted
Mar 2016 - 5275 deleted
Apr 2015 - 5221 deleted
Apr 2014 - 5446 deleted */

select * from gas_forecast_vacant_pros_rate
order by
sitezip5,
market;
/* 
2287 Apr 2017
2285 Mar 2016
2270 Apr 2015
2354 */


select region, vacant_market, pros_heat_rate, count(*) from gas_forecast_vacant1 
group by region, vacant_market, pros_heat_rate
order by region, vacant_market, pros_heat_rate;

select distinct adr_situs_zip_trw 
from gas_forecast_vacant1
where pros_heat_rate = 'UNKNOWN';

/* update any unknown prospective rates */
update gas_forecast_vacant1 a
set a.pros_heat_rate = (select b.cde_rte
from gas_forecast_vacant_pros_rate b
where a.adr_situs_zip_trw = b.sitezip5
and a.vacant_market = b.market)
where a.pros_heat_rate = 'UNKNOWN'
and exists(select *
from gas_forecast_vacant_pros_rate b
where a.adr_situs_zip_trw = b.sitezip5
and a.vacant_market = b.market)
;
/* 
182649 Apr 2017
156403 updated Mar 2016
155807 updated Apr 2015 */

/* Update by Region and market for those that remain UNKNOWN */
/* create a table by zip and market to get the most common heating rates for the unknown pros_heat_rate */
create table gas_forecast_vacant_pros_rate2 as
select region,
market,  
cde_rte, count(*) as rte_cnt
from cpalmieri.gas_forecast_saturation_final
where service = 'HEATING'
group by region,
market,  
cde_rte
order by
region,
market,  
count(*) desc;

select * from gas_forecast_vacant_pros_rate2;

/* Remove the duplicate region and market keeping the rate with the highest number of occurances */
delete from gas_forecast_vacant_pros_rate2 a
where rowid > any(select rowid from gas_forecast_vacant_pros_rate2 b
where a.region = b.region
and a.market = b.market)
;
/* 
Apr 2017 - 126
Mar 2016 - 127 deleted
Apr 2015 - 126 deleted
Apr 2014 - 134 deleted */
select * from gas_forecast_vacant_pros_rate2
order by
region,
market;
/* 
15 - 2017
15 - no NH
18 */


select region, vacant_market, pros_heat_rate, count(*) from gas_forecast_vacant1 
group by region, vacant_market, pros_heat_rate
order by region, vacant_market, pros_heat_rate;

select distinct adr_situs_zip_trw 
from gas_forecast_vacant1
where pros_heat_rate = 'UNKNOWN';

/* update any unknown prospective rates */
update gas_forecast_vacant1 a
set a.pros_heat_rate = (select b.cde_rte
from gas_forecast_vacant_pros_rate2 b
where a.region = b.region
and a.vacant_market = b.market)
where a.pros_heat_rate = 'UNKNOWN'
and exists(select *
from gas_forecast_vacant_pros_rate2 b
where a.region = b.region
and a.vacant_market = b.market)
;
/* 
308172 - Apr 2017
277280 - Mar 2016
277302 - Apr 2015
278451 updated */

select region, vacant_market, pros_heat_rate, count(*) from gas_forecast_vacant1 
group by region, vacant_market, pros_heat_rate
order by region, vacant_market, pros_heat_rate;

select * from gas_forecast_vacant1;

select count(*), count(distinct id_apn_trw), count(distinct id_apn_trw||cde_state_trw||cde_county_trw)
from gas_forecast_vacant1;

alter table gas_forecast_vacant1
add(vacant_record_id numeric(10));

/* update this year's records_id with last year's record_id for the same apn number */
create index idx_vacant_apn_trw on gas_forecast_vacant1(id_apn_trw,cde_state_trw,cde_county_trw);
create index idx_vacant_apn_trw16 on GAS_FCST_SAT_VACANT_MAY_2016(id_apn_trw,cde_state_trw,cde_county_trw);

update gas_forecast_vacant1 a
set vacant_record_id = (select vacant_record_id from GAS_FCST_SAT_VACANT_MAY_2016 b
where a.id_apn_trw = b.id_apn_trw
and a.cde_state_trw = b.cde_state_trw
and a.cde_county_trw = b.cde_county_trw)
;
commit;

drop table temp_fcst_vacant_record_id;

create table temp_fcst_vacant_record_id as
select * from gas_forecast_vacant1
where vacant_record_id is null;

select count(*) from temp_fcst_vacant_record_id;
/* 105532 - Apr 2017
28,788 */

delete from gas_forecast_vacant1
where vacant_record_id is null;

/* add record_ids to the records that did not match last year's saturation or have no street name */
DECLARE
   vacmaxid numeric(10); 
BEGIN
  select max(vacant_record_id) into vacmaxid from GAS_FCST_SAT_VACANT_MAY_2016;
   update temp_fcst_vacant_record_id
   set vacant_record_id = rownum+vacmaxid;
   COMMIT;
END;

/* insert those records back into vacant saturation now that they have a record_id */

insert into gas_forecast_vacant1
select * from temp_fcst_vacant_record_id;

create index idx_GAS_FORECAST_Vac_SAT_FINAL on gas_forecast_vacant1(vacant_record_id);

select record_id, count(*)
from GAS_FORECAST_SATURATION_FINAL
group by record_id
having count(*)>1;
/* 0 */

select min(vacant_record_id), max(vacant_record_id) from gas_forecast_vacant1;
/* 
Apr 2017:
MIN(VACANT_RECORD_ID)	MAX(VACANT_RECORD_ID)
2	1165549

MIN(VACANT_RECORD_ID)	MAX(VACANT_RECORD_ID)
2	1060017
*/

grant select on gas_forecast_vacant1 to superuser;

/* Update the constrained zips */
update cpalmieri.gas_forecast_vacant1
set constrained_zip_commercial = 'N',
constrained_zip_residential = 'N'
;

update cpalmieri.gas_forecast_vacant1
set constrained_zip_commercial = 'Y',
constrained_zip_residential = 'Y'
where adr_situs_zip_trw in('02631','02633','02638','02639','02641','02642',
'02643','02645','02646','02650','02651','02653','02659','02660','02662','02670','02671')
/* 7166 updated - Apr 2017 */

alter table gas_forecast_vacant1 add(ZIP_CODE_UPDATED varchar2(5));

update gas_forecast_vacant1 a
set a.zip_code_updated = a.adr_situs_zip_trw
where a.adr_situs_zip_trw in(select zip_code_geo from GAS_FORECAST_valid_zips);

/* Create a table of zips not in the Engineering zips that have an updated zip code 
that puts them into an engineering zip */
create table gas_forecast_vac_bad_zips as
select a.sitezip5, a.zip_code_updated, count(*) as num_recs
from cpalmieri.gas_forecast_saturation_final a
join (select adr_situs_zip_trw, count(*) as number_of_recs from gas_forecast_vacant1 a
where adr_situs_zip_trw not in(select zip_code_geo from GAS_FORECAST_valid_zips)
and a.franchise_zip = 'Y'
group by adr_situs_zip_trw) b
on a.sitezip5 = b.adr_situs_zip_trw
group by a.sitezip5, a.zip_code_updated
;

select * from gas_forecast_vac_bad_zips;


select sitezip5 from gas_forecast_vac_bad_zips
group by sitezip5 having count(*)>1;
/* 1 */

/* remove duplicates, keeping the updated zip with the most records */
delete from gas_forecast_vac_bad_zips a
where a.num_recs < any(select num_recs from gas_forecast_vac_bad_zips b
where a.sitezip5 = b.sitezip5);
/* 1 */

/* Remove the duplicate record where the difference in the zip number is greater */
delete from gas_forecast_vac_bad_zips a
where abs(sitezip5-ZIP_CODE_UPDATED) > any(select abs(sitezip5-ZIP_CODE_UPDATED) 
from gas_forecast_vac_bad_zips b
where b.sitezip5 in(select sitezip5 from gas_forecast_vac_bad_zips
group by sitezip5 having count(*)>1)
and a.sitezip5 = b.sitezip5)
and ZIP_CODE_UPDATED<>'UNKWN';
/* 1 deleted */


update gas_forecast_vacant1 a
set a.zip_code_updated = (select zip_code_updated from gas_forecast_vac_bad_zips b
where a.adr_situs_zip_trw = b.sitezip5)
where a.zip_code_updated is null;
/* 23169 */

select count(*) from gas_forecast_vacant1
where zip_code_updated is null
/* 21206 */
and franchise_zip = 'Y';
/* 3 */

select * from gas_forecast_vacant1
where zip_code_updated is null
/* 21206 */
and franchise_zip = 'Y';

update gas_forecast_vacant1
set zip_code_updated = 'UNKWN'
where zip_code_updated is null
and franchise_zip = 'Y';
/* 3 updated */

/* Saturation counts - Liming's data */
select 
region,
case
  when region = 'LI' then t.sitezip5
  else t.zip_code_updated
end as sitezip5,
case
  when t.service is null then 'PROSPECT'
  else t.service
end as service,
t.market,
count(*) as structures
from cpalmieri.gas_forecast_saturation_final t
where franchise_zip = 'Y'
group by 
region,
case
  when region = 'LI' then t.sitezip5
  else t.zip_code_updated
end,
case
  when t.service is null then 'PROSPECT'
  else t.service
end,
t.market
/*order by t.sitezip5,
service,
t.market*/
union
/* Bring in Vacant Land */
select region,
case
  when region = 'LI' then t.adr_situs_zip_trw
  else t.zip_code_updated
end as sitezip5,
'PROSPECT' as service,
t.market,
count(*) as structures
from gas_forecast_vacant1 t
where franchise_zip = 'Y'
group by region,
case
  when region = 'LI' then t.adr_situs_zip_trw
  else t.zip_code_updated
end,
'PROSPECT',
t.market
/*order by t.adr_situs_zip_trw,
service,
t.market*/
;
