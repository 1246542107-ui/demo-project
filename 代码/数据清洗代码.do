
log using DataCleaning.log, replace
******************************************************************                                  
*         《极端天气、贸易信贷传导与供应链稳定》           *                              
******************************************************************

*--------------------------------------------------------------------------------*
*----------------------------极端天气冲击指标构建------------------------------------*
*--------------------------------------------------------------------------------*
**计算极端降水阈值**
clear all
use "D:\Desktop\city_daily_precip.dta"
tostring date,replace
gen year1=substr( date,1,4 )
gen month=substr( date,5,2 )
tab month
destring month,replace
gen quarter=int( (month+2)/3 )
tab quarter
destring year1 quarter,replace
format yq %tq
tostring 市代码,replace
destring City,replace
des
*保留日降水量大于0的降水资料
drop if precip==0
*计算城市极端降水阈值
rename 市代码 City
bys City:egen p90 = pctile(precip), p(90)
bys City:egen p99 = pctile(precip), p(99)
bys City:egen p95 = pctile(precip), p(95)
bys City:egen p999 = pctile(precip), p(99.9)
gsort -p99
duplicates drop City,force
keep City p999 p95 p99 p90
destring City,replace
save "D:\Desktop\极端降水阈值.dta"
clear
**计算季度极端降水天数**
import delimited "D:\Desktop\1981-2023年逐日降水量.csv", varnames(1) encoding(GBK)
*保留11-23年数据
keep 序号 省 省代码 市 市代码 a20110101-a20231231
reshape long a,i( 市代码 ) j(year)
rename a precip
*导入城市极端降水阈值
tostring 市代码,replace
gen City=substr( 市代码 ,1,4)
destring City,replace
merge m:1 City using "D:\Desktop\极端降水阈值.dta"
*设置季度面板
tostring year,replace
gen year1=substr( year,1,4 )
gen month=substr( year,5,2 )
tab month
destring month,replace
gen quarter=int( (month+2)/3 )
tab quarter
destring year1 quarter,replace
gen yq=yq( year1 , quarter )
format yq %tq
gen 是否超过P95=( precip> p95 )
gen 是否超过P90=( precip> p90 )
gen 是否超过P99=( precip> p99 )
gen 是否超过P999=( precip> p999 )
count if missing( 是否超过P95 )
count if missing( 是否超过P90 )
count if missing( 是否超过P99 )
gsort -precip
rename year day
duplicates drop City day,force
bys City yq:egen JP90=sum( 是否超过P90 )
bys City yq:egen JP99=sum( 是否超过P99 )
bys City yq:egen JP95=sum( 是否超过P95 )
bys City yq:egen JP999=sum( 是否超过P999 )
duplicates drop City yq,force
keep 市 City yq JP90 JP99 JP95 JP999
save "D:\Desktop\阈值法计算极端降水季度次数320.dta"
clear
*--------------------------------------------------------------------------------
*-----------------------------焦点公司数据处理-----------------------------------
*--------------------------------------------------------------------------------
use "C:\Users\LENOVO\Desktop\附件X：复现材料\资产负债表.dta" 
**设置年度和yq**
split Accper ,parse(-) destring ignor("-")
rename Accper1 year
tab year
drop Accper3
drop if Accper2==1
gen quarter=int( (Accper2+2)/3 )
tab quarter
drop Accper2
gen yq=yq(year,quarter)
format yq %tq
*保留报表类型为"合并报表"的数据
tab Typrep
keep if Typrep=="A"
merge 1:1 Stkcd yq using "C:\Users\LENOVO\Desktop\附件X：复现材料\利润表.dta"
drop if _merge==2
gen ID=Stkcd
destring ID,replace
drop _merge
merge m:1 ID year using "C:\Users\LENOVO\Desktop\附件X：复现材料\管理层治理能力.dta"
drop if _merge==2
drop _merge
merge m:1 Stkcd year using "C:\Users\LENOVO\Desktop\附件X：复现材料\上市公司基本信息.dta"
drop if _merge==2
drop _merge
save "C:\Users\LENOVO\Desktop\CSMAR原始财务数据.dta"
*计算解释变量
gen City =substr( CITYCODE ,1,4 )
*删除城市代码缺失数据
drop if City=="None"
destring City,replace
merge m:1 City yq using "D:\Desktop\阈值法计算极端降水季度次数320.dta"
drop if _merge==2
gen Climate=ln( JP99+1 )
**保留指定年份
drop if year<=2010
**匹配被解释变量
drop _merge
merge 1:1 ID yq using "D:\Desktop\被解释变量.dta"
drop if _merge==2
**计算控制变量
gen Size=ln(A001000000)
gen Lev=A002000000/A001000000
gen Inv=A001123000/A001000000
gen Ppe= A001212000/ A001000000
gen firmage =substr( EstablishDate ,1,4)
destring firmage,replace
gen Firmage=ln( year -firmage+1)
gen Board=ln( 董事会规模+1 )
gen Occupy=A001121000/A001000000
rename 独立董事占比 Indep
rename ISIN SOURCE_isin
drop _merge
*删除ISIN代码缺失数据
drop if missing(SOURCE_isin)
drop if SOURCE_isin=="None"
merge 1:1 SOURCE_isin yq using "D:\Desktop\控制变量供应商受冲击情况.dta"
drop if _merge==2
drop _merge
merge 1:1 SOURCE_isin yq using "D:\Desktop\控制变量客户受冲击情况.dta"
drop if _merge==2
drop _merge
*设置固定效应
egen indu=group(IndustryCodeC)
egen Indu_Year=group( indu year )
gen Prov=substr( PROVINCECODE,1,2 )
egen Prov_Year=group( Prov year )
egen City_Year=group(City year)
egen Indu_yq=group(indu yq)
egen City_yq=group(City yq)
gen Industry=substr( IndustryCodeC,1,1 )
*保留2011-2023年数据
keep if year>=2011 & year<=2023 
*剔除 ST、ST* 及 PT 等特殊处理公司样本
gen mis = strmatch(ShortName, "*ST*") | strmatch(ShortName, "*PT*") 
drop if mis == 1
*剔除异常值,剔除应收账款净额(A001111000)、营业收入(B001101000)、应付账款(A002108000)、负债合计小于0(A002000000)的数据
drop if A001111000<0
drop if  B001101000<0
drop if A002108000<0
drop if A002000000<0

 *剔除核心财务指标异常的样本
foreach i in Pay∆ Rec∆ Climate S_Climate C_Climate Size Lev Inv Ppe Firmage Board Occupy Indep{
  drop if `i'==.
  }

*缩尾
winsor2  Pay∆ Rec∆  Climate S_Climate C_Climate Size Lev Inv Ppe Firmage Board Occupy Indep,cut(1 99)
keep  yq ID Firmage Prov_Year Indu_Year Size Lev Inv Climate Pay∆ Rec∆ Industry S_Shock C_Shock S_ClimateDay C_ClimateDay Board Indep Occupy S_Climate C_Climate Prepay∆ Ppe Prerec∆
save "附件X：复现材料\数据\基准回归\焦点公司基准回归.dta"


*--------------------------------------------------------------------------------*
*-----------------------------供应商数据处理-----------------------------------*
*--------------------------------------------------------------------------------*
clear
import delimited "C:\Users\LENOVO\Desktop\gga5paxtycqgrnxo.csv", varnames(1) 
**保留关系类型中属于"SUPPLIER"关系的企业
keep if rel_type=="SUPPLIER"

**改成面板数据
gen start_year=substr( start_,1,4 )
tab start_year
gen end_year=substr(end_,1,4 )
tab end_year
drop if end_year=="4000"

*把日期不明确的交易删除掉
gen start_month=substr( start_,6,2 )
gen end_month=substr( end_,6,2 )
tab start_month
destring start_month,replace
gen start_quarter=int( ( start_month +2)/3 )
tab start_quarter
destring start_year,replace
gen start_yq=yq(start_year,start_quarter)
format start_yq %tq
destring end_month,replace
gen end_quarter=int( ( end_month +2)/3 )
destring end_year,replace
gen end_yq=yq(end_year,end_quarter)
format end_yq %tq
duplicates drop source_company_id target_company_id end_yq start_yq,force
gen 时间段= end_yq- start_yq
replace 时间段=. if 时间段==0
gen 时间段_1=时间段+1
expand 时间段_1
bys source_company_id target_company_id start_yq end_yq:gen 顺序=_n
replace 顺序=. if 时间段==.
gen 新的yq= start_yq+ 顺序-1
format 新的yq %tq
replace 新的yq= start_yq if 新的yq==.
rename 新的yq yq
**保留ISIN前两位字母代码为"CN"样本
gen source_isin2=substr( source_isin,1,2 )
keep if source_isin2=="CN"
drop source_isin2
gen target_isin2=substr( target_isin,1,2 ) 
keep if target_isin2=="CN"
drop target_isin2

*计算交易时长S_Duration
bys source_company_id target_company_id: egen first_trade = min(yq)
format first_trade %tq
gen Duration=yq-first_trade+1
bys target_company_id yq:egen S_Duration=mean(Duration) if Duration!=.

*计算交易次数S_Frequency
duplicates drop target_company_id source_company_id id yq,force
bysort target_company_id source_company_id yq: egen Frequency=count(id)
bys target_company_id yq:egen S_Frequency=mean(Frequency)

**删除相同公司对和季度的重复记录
duplicates drop source_company_id target_company_id yq,force
save "D:\Desktop\供应商和焦点公司的面板数据.dta"
clear

****匹配供应商数据
use "D:\Desktop\供应商和焦点公司的面板数据.dta"
rename target_isin S_isin
merge m:1 S_isin yq using "C:\Users\LENOVO\Desktop\CSMAR原始财务数据.dta"
drop if _merge==2
drop _merge
rename S_isin TARGET_isin
gen City=substr( CITYCODE,1,4 )
drop if City=="None"//删除城市代码缺失数据
destring City,replace
merge m:1 City yq using "D:\Desktop\阈值法计算极端降水季度次数320.dta"
drop if _merge==2
renvars  City JP90 JP99 JP95,prefix(S_)
drop _merge
label variable S_JP99 "供应商99阈值极端降水"
label variable S_City "供应商所在城市"
gen Climate_CityS=ln(S_JP99+1 )
*匹配焦点公司极端天气数据
rename source_isin ISIN
merge m:1 ISIN year using "C:\Users\LENOVO\Desktop\焦点公司基本信息.dta"
rename ISIN SOURCE_ISIN
drop if _merge==2
drop _merge
gen City=substr( CITYCODE,1,4 )//这里是焦点公司所在的城市
destring City,replace
label variable City "焦点公司所在城市"
merge m:1 City yq using "D:\Desktop\阈值法计算极端降水季度次数320.dta"
drop if _merge==2
drop _merge
label variable JP90 "焦点公司JP90"
label variable JP99 "焦点公司99阈值"
label variable JP95 "焦点公司95阈值"
bys target_company_id yq:egen Climate=sum(JP99)
**保留指定年份
drop if year<=2010
**匹配被解释变量
drop _merge
drop if missing(ID)
merge 1:1 ID yq using "D:\Desktop\被解释变量.dta"
drop if _merge==2
**计算控制变量
gen S_Size=ln(A001000000)
gen S_Lev=A002000000/A001000000
gen S_Inv=A001123000/A001000000
gen S_Ppe= A001212000/ A001000000
gen S_firmage =substr( EstablishDate ,1,4)
destring S_firmage,replace
gen S_Firmage=ln( year -S_firmage+1)
gen S_Board=ln( 董事会规模+1 )
gen S_Occupy=A001121000/A001000000
rename 独立董事占比 S_Indep
*设置固定效应
egen S_indu=group(IndustryCodeC)
egen S_Indu_Year=group( S_indu year )
gen S_Prov=substr( PROVINCECODE,1,2 )
egen S_Prov_Year=group( S_Prov year )
egen S_City_Year=group(S_City year)
egen S_Indu_yq=group(S_indu yq)
egen S_City_yq=group(S_City yq)
*保留2011-2023年数据
keep if year>=2011 & year<=2023 
*剔除 ST、ST* 及 PT 等特殊处理公司样本
gen mis = strmatch(ShortName, "*ST*") | strmatch(ShortName, "*PT*") 
drop if mis == 1
*剔除异常值,剔除应收账款净额(A001111000)、营业收入(B001101000)、应付账款(A002108000)、负债合计小于0(A002000000)的数据
drop if A001111000<0
drop if  B001101000<0
drop if A002108000<0
drop if A002000000<0

 *剔除核心财务指标异常的样本
foreach i in S_∆Rec S_Size S_Lev S_Inv S_Ppe S_Firmage S_Board S_Occupy S_Indep{
  drop if `i'==.
  }

*缩尾
winsor2  S_∆Rec Climate Climate_CityS S_Size S_Lev S_Inv S_Ppe S_Firmage S_Board S_Occupy S_Indep,cut(1 99)replace
keep TARGET_isin yq S_ID S_Frequency S_Ppe S_Firmage S_Indu_Year S_Prov_Year S_∆Rec Climate Climate_CityS S_Size S_Lev S_Inv S_Occupy S_Duration S_Indep S_Board
save "附件X：复现材料\数据\基准回归\供应商基准回归.dta"
clear

*--------------------------------------------------------------------------------
*-----------------------------客户数据处理-----------------------------------
*--------------------------------------------------------------------------------

import delimited "C:\Users\LENOVO\Desktop\gga5paxtycqgrnxo.csv", varnames(1) 

**保留关系类型中属于"CUSTOMER"关系的企业
keep if rel_type=="CUSTOMER"

**改成面板数据
gen start_year=substr( start_,1,4 )
tab start_year
gen end_year=substr(end_,1,4 )
tab end_year


*把日期不明确的交易删除掉
drop if end_year=="4000"
gen start_month=substr( start_,6,2 )
gen end_month=substr( end_,6,2 )
tab start_month
destring start_month,replace
gen start_quarter=int( ( start_month +2)/3 )
tab start_quarter
destring start_year,replace
gen start_yq=yq(start_year,start_quarter)
format start_yq %tq
destring end_month,replace
gen end_quarter=int( ( end_month +2)/3 )
destring end_year,replace

gen end_yq=yq(end_year,end_quarter)

format end_yq %tq

duplicates drop source_company_id target_company_id end_yq start_yq,force
gen 时间段= end_yq- start_yq
replace 时间段=. if 时间段==0
gen 时间段_1=时间段+1
expand 时间段_1
bys source_company_id target_company_id start_yq end_yq:gen 顺序=_n
replace 顺序=. if 时间段==.
gen 新的yq= start_yq+ 顺序-1
format 新的yq %tq
replace 新的yq= start_yq if 新的yq==.
rename 新的yq yq

**保留ISIN前两位字母代码为"CN"样本
gen source_isin2=substr( source_isin,1,2 )
keep if source_isin2=="CN"
drop source_isin2
gen target_isin2=substr( target_isin,1,2 ) 
keep if target_isin2=="CN"
drop target_isin2
 
*计算交易时长C_Duration
bys source_company_id target_company_id: egen first_trade = min(yq)
format first_trade %tq
gen Duration=yq-first_trade+1
bys target_company_id yq:egen C_Duration=mean(Duration) if Duration!=.

*计算交易次数C_Frequency
duplicates drop target_company_id source_company_id id yq,force
rename 新的yq yq
bysort target_company_id source_company_id yq: egen Frequency=count(id)
bys target_company_id yq:egen C_Frequency=mean(Frequency)


**删除相同公司对和相同季度的重复记录
duplicates drop source_company_id target_company_id yq,force
save "D:\Desktop\客户和焦点公司的面板数据.dta"

**匹配客户财务数据
use "D:\Desktop\客户和焦点公司的面板数据.dta"
rename target_isin C_isin
merge m:1 C_isin yq using "C:\Users\LENOVO\Desktop\CSMAR原始财务数据.dta"
drop if _merge==2
drop _merge

**匹配客户极端天气数据
rename C_isin TARGET_isin
gen City=substr( CITYCODE,1,4 )
drop if City=="None"//删除城市代码缺失数据
destring City,replace
merge m:1 City yq using "D:\Desktop\阈值法计算极端降水季度次数320.dta"
drop if _merge==2
renvars  City JP90 JP99 JP95,prefix(C_)
drop _merge
label variable C_JP99 "客户99阈值极端降水"
label variable C_City "客户所在城市"
gen Climate_CityC=ln(C_JP99+1 )

*匹配焦点公司极端天气数据
rename source_isin ISIN
merge m:1 ISIN year using "焦点公司基本信息.dta"
rename ISIN SOURCE_ISIN
drop if _merge==2
drop _merge
gen City=substr( CITYCODE,1,4 )//这里是焦点公司所在的城市
replace City="" if City=="None"
destring City,replace
label variable City "焦点公司所在城市"
merge m:1 City yq using "D:\Desktop\阈值法计算极端降水季度次数320.dta"
drop if _merge==2
drop _merge
label variable JP90 "焦点公司JP90"
label variable JP99 "焦点公司99阈值"
label variable JP95 "焦点公司95阈值"
bys target_company_id yq:egen Climate=sum(JP99)

**保留指定年份
drop if year<=2010
**匹配被解释变量
drop _merge
merge 1:1 ID yq using "D:\Desktop\被解释变量.dta"
drop if _merge==2
**计算控制变量
gen C_Size=ln(A001000000)
gen C_Lev=A002000000/A001000000
gen C_Inv=A001123000/A001000000
gen C_Ppe= A001212000/ A001000000
gen C_firmage =substr( EstablishDate ,1,4)
destring C_firmage,replace
gen C_Firmage=ln( year -C_firmage+1)
gen C_Board=ln( 董事会规模+1 )
gen C_Occupy=A001121000/A001000000
rename 独立董事占比 C_Indep
*设置固定效应
egen C_indu=group(IndustryCodeC)
egen C_Indu_Year=group( C_indu year )
gen C_Prov=substr( PROVINCECODE,1,2 )
egen C_Prov_Year=group( C_Prov year )
egen C_City_Year=group(C_City year)
egen C_Indu_yq=group(C_indu yq)
egen C_City_yq=group(C_City yq)
*保留2011-2023年数据
keep if year>=2011 & year<=2023 
*剔除 ST、ST* 及 PT 等特殊处理公司样本
gen mis = strmatch(ShortName, "*ST*") | strmatch(ShortName, "*PT*") 
drop if mis == 1
*剔除异常值,剔除应收账款净额(A001111000)、营业收入(B001101000)、应付账款(A002108000)、负债合计小于0(A002000000)的数据
drop if A001111000<0
drop if  B001101000<0
drop if A002108000<0
drop if A002000000<0

 *剔除核心财务指标异常的样本
foreach i in C_∆Pay Climate Climate_CityC C_Frequency C_Duration C_Size C_Lev C_Inv C_Ppe C_Firmage C_Board C_Occupy C_Indep{
  drop if `i'==.
  }

*缩尾
winsor2  C_∆Pay Climate Climate_CityC C_Frequency C_Duration C_Size C_Lev C_Inv C_Ppe C_Firmage C_Board C_Occupy C_Indep,cut(1 99) replace
keep TARGET_isin yq C_ID C_Ppe C_Size Climate_CityC C_Indu_Year C_Prov_Year C_Inv C_∆Pay C_Duration Climate C_Frequency C_Firmage C_Occupy C_Board C_Indep C_Lev
save "附件X：复现材料\数据\基准回归\客户基准回归.dta" 

log close
