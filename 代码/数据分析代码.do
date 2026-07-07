
cd "C:\Users\LENOVO\Desktop\附件X：复现材料\日志"
log using regress.log, replace

cd "C:\Users\LENOVO\Desktop\附件X：复现材料\结果"
********************************************************************************************************
***标题：极端天气、贸易信贷传导与供应链稳定
***作者：史青（上海大学）；孟恩恩（南开大学）；陈梦婷（杭州汉骑信息技术有限公司）
***期刊：《世界经济》
***Stata/MP17版本运行
***outreg2命令导出
********************************************************************************************************

**【表1 描述性统计】
  ****************Panel A焦点公司端****************
use "C:\Users\LENOVO\Desktop\附件X：复现材料\数据\基准回归\焦点公司基准回归.dta" 
logout,save(表1_PanelA焦点公司描述性统计)word replace:tabstat Pay∆ Rec∆  Climate S_Climate C_Climate Size Lev Inv Ppe Firmage Board Occupy Indep ,s(N mean sd min p25 p50 p75 max) f(%12.4f) c(s)

  ****************Panel B供应商端****************
clear all
use "C:\Users\LENOVO\Desktop\附件X：复现材料\数据\基准回归\供应商基准回归.dta"
logout,save(表1_PanelB供应商描述性统计)word replace:tabstat S_∆Rec Climate Climate_CityS S_Size S_Lev S_Inv S_Ppe S_Firmage S_Board S_Occupy S_Indep S_Frequency S_Duration,s(N mean sd min p25 p50 p75 max) f(%12.4f) c(s)

  ****************Panel C客户端****************
clear all
use "C:\Users\LENOVO\Desktop\附件X：复现材料\数据\基准回归\客户基准回归.dta"
logout,save(表1_PanelC客户描述性统计)word replace:tabstat C_∆Pay Climate Climate_CityC C_Size C_Lev C_Inv C_Ppe C_Firmage C_Board C_Occupy C_Indep C_Frequency C_Duration ,s(N mean sd min p25 p50 p75 max) f(%12.4f) c(s)




**【表2 基准回归】
clear all
use "C:\Users\LENOVO\Desktop\附件X：复现材料\数据\基准回归\焦点公司基准回归.dta" 
xtset ID yq
*line1#
reghdfe Pay∆ Climate, abs( ID yq ) vce(cl ID)
outreg2 using "表2_基准回归结果.xls", se cttop("∆Pay") addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,NO,Prov_Year FE,NO) bdec(4) sdec(4) adjr2 rdec(4) replace
*line2#
reghdfe Rec∆ Climate, abs( ID yq ) vce(cl ID)
outreg2 using "表2_基准回归结果.xls", se cttop("∆Rec") addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,NO,Prov_Year FE,NO) bdec(4) sdec(4) adjr2 rdec(4) append
*line3#
global controls Size Lev Inv Ppe Firmage Board Occupy Indep 
reghdfe Pay∆ Climate S_Climate C_Climate $controls, abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表2_基准回归结果.xls", se cttop("∆Pay") addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append
*line4#
reghdfe Rec∆ Climate S_Climate C_Climate $controls  , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表2_基准回归结果.xls", se cttop("∆Rec") addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append
*line5#
reghdfe Prepay∆ Climate S_Climate C_Climate $controls  , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表2_基准回归结果.xls", se cttop("∆Prepay") addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append
*line6#
reghdfe Prerec∆ Climate S_Climate C_Climate $controls , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表2_基准回归结果.xls", se cttop("∆Prerec") addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append


**【表B2 考虑上下游影响的基准结果】
clear all
use "C:\Users\LENOVO\Desktop\附件X：复现材料\数据\基准回归\焦点公司基准回归.dta" 
xtset ID yq
*line1#
reghdfe Pay∆ Climate S_Shock C_Shock $controls   , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表B2_考虑上下游影响的基准结果.xls", se cttop("∆Pay") addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) replace
*line2#
reghdfe Rec∆ Climate S_Shock C_Shock $controls   , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表B2_考虑上下游影响的基准结果.xls", se cttop("∆Rec") addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append
*line3#
reghdfe Pay∆ Climate S_ClimateDay C_ClimateDay $controls  , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表B2_考虑上下游影响的基准结果.xls", se cttop("∆Pay") addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append
*line4#
reghdfe Rec∆ Climate S_ClimateDay C_ClimateDay $controls  , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表B2_考虑上下游影响的基准结果.xls", se cttop("∆Rec") addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append


**【表3 供应商端和客户端回归结果】
   ****************供应商端****************
clear all
use "C:\Users\LENOVO\Desktop\附件X：复现材料\数据\基准回归\供应商基准回归.dta"
global controls S_Size S_Lev S_Inv S_Ppe S_Firmage S_Board S_Occupy S_Indep
*line1#
reghdfe S_∆Rec Climate $controls , abs( S_ID yq) vce(cl S_ID)
outreg2 using "表3_供应商端和客户端回归结果.xls", se cttop() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,NO,Prov_Year FE,NO) bdec(4) sdec(4) adjr2 rdec(4) replace

*line2#
reghdfe S_∆Rec Climate $controls , abs( S_ID yq S_Indu_Year S_Prov_Year) vce(cl S_ID)
outreg2 using "表3_供应商端和客户端回归结果.xls", se cttop() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line3#
reghdfe S_∆Rec Climate Climate_CityS $controls , abs(S_ID yq S_Indu_Year S_Prov_Year) vce(cl S_ID)
outreg2 using "表3_供应商端和客户端回归结果.xls", se cttop() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line4#
reghdfe S_∆Rec Climate Climate_CityS S_Frequency S_Duration $controls , abs(S_ID yq S_Indu_Year S_Prov_Year) vce(cl S_ID)
outreg2 using "表3_供应商端和客户端回归结果.xls", se cttop() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

  ****************客户端****************
clear all
use "C:\Users\LENOVO\Desktop\附件X：复现材料\数据\基准回归\客户基准回归.dta"
global controls C_Size C_Lev C_Inv C_Ppe C_Firmage C_Board C_Occupy C_Indep
*line5#
reghdfe C_∆Pay Climate $controls  , abs( C_ID yq  ) vce(cl C_ID)
outreg2 using "表3_供应商端和客户端回归结果.xls", se cttop() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,NO,Prov_Year FE,NO) bdec(4) sdec(4) adjr2 rdec(4) append

*line6#
reghdfe C_∆Pay Climate $controls , abs( C_ID yq C_Indu_Year C_Prov_Year) vce(cl C_ID)
outreg2 using "表3_供应商端和客户端回归结果.xls", se cttop() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line7#
reghdfe C_∆Pay Climate Climate_CityC $controls  , abs(C_ID yq C_Indu_Year C_Prov_Year) vce(cl C_ID)
outreg2 using "表3_供应商端和客户端回归结果.xls", se cttop() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line8#
reghdfe C_∆Pay Climate Climate_CityC C_Frequency C_Duration $controls, abs(C_ID yq C_Indu_Year C_Prov_Year) vce(cl C_ID)
outreg2 using "表3_供应商端和客户端回归结果.xls", se cttop() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append



**************************************************************
                     * 稳健性检验结果 *
**************************************************************

**【表4 工具变量回归结果】
clear all
use "C:\Users\LENOVO\Desktop\附件X：复现材料\数据\稳健性检验\内生性分析.dta"
xtset ID yq
global controls Size Lev Inv Ppe Firmage Board Occupy Indep S_Climate C_Climate
*应付
eststo clear
reghdfe Climate IV1 IV2 $controls, abs(ID yq Indu_Year Prov_Year) cluster(ID)
estimates store A1
ivreghdfe Pay∆ $controls (Climate=IV1 IV2) , first savefirst abs(ID yq Indu_Year Prov_Year) cluster(ID)
estimates store A2

*应收
ivreghdfe Rec∆ $controls (Climate=IV1 IV2), first savefirst abs(ID yq Indu_Year Prov_Year) cluster(ID)
estimates store A3
esttab A1 A2 A3 using iv.doc, ar2(4) b(%6.4f) se(%6.4f) star(* 0.1 ** 0.05 *** 0.01) replace



**【表C1 替换极端降水指标与检验非线性影响】
clear all
use "C:\Users\LENOVO\Desktop\附件X：复现材料\数据\稳健性检验\其他稳健性分析.dta" 
xtset ID yq
global controls Size Lev Inv Ppe Firmage Board Occupy Indep S_Climate C_Climate 

*line1# 应付端：更换极端降水虚拟变量 Climate0_1
reghdfe Pay∆ Climate0_1 $controls , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表C1_替换极端降水指标与检验非线性影响.xls", se cttop("∆Pay") addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) replace

*line2# 应收端：更换极端降水虚拟变量 Climate0_1
reghdfe Rec∆ Climate0_1 $controls , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表C1_替换极端降水指标与检验非线性影响.xls", se cttop("∆Rec") addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line3# 应付端：极端降水阈值改为95%分位数 Climate95
reghdfe Pay∆ Climate95 $controls , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表C1_替换极端降水指标与检验非线性影响.xls", se cttop("∆Pay") addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line4# 应收端：极端降水阈值改为95%分位数 Climate95
reghdfe Rec∆ Climate95 $controls, abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表C1_替换极端降水指标与检验非线性影响.xls", se cttop("∆Rec") addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line5# 应付端：季度平均降水是否超过100毫米 Downpour
reghdfe Pay∆ Downpour $controls , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表C1_替换极端降水指标与检验非线性影响.xls", se cttop("∆Pay") addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line6# 应收端：季度平均降水是否超过100毫米 Downpour
reghdfe Rec∆ Downpour $controls , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表C1_替换极端降水指标与检验非线性影响.xls", se cttop("∆Rec") addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line7#  应付端：降水二次项
reghdfe Pay∆ Climate_2 Climate $controls, abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表C1_替换极端降水指标与检验非线性影响.xls", se cttop("∆Pay") addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line8# 应收端：降水二次项
reghdfe Rec∆ Climate_2 Climate $controls, abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表C1_替换极端降水指标与检验非线性影响.xls", se cttop("∆Rec") addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append


**【表C2 稳健性检验】

clear all
use "C:\Users\LENOVO\Desktop\附件X：复现材料\数据\稳健性检验\其他稳健性分析.dta" 
xtset ID yq
global controls Size Lev Inv Ppe Firmage Board Occupy Indep S_Climate C_Climate 
  ****************稳健性--替换贸易信贷指标****************
*line1# 应付账款与期末总资产比值变化 ∆Pay2
reghdfe Pay2∆ Climate $controls, abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表C2_稳健性检验.xls", se cttop("∆Pay2") addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) replace

*line2#应收账款与期末总资产比值变化 ∆Rec2
reghdfe Rec2∆ Climate $controls , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表C2_稳健性检验.xls", se cttop("∆Rec2") addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line3#应付账款与应付票据之和与期末总资产的比值变化∆Pay3
reghdfe Pay3∆ Climate $controls , abs( ID yq Indu_Year  Prov_Year) vce(cl ID)
outreg2 using "表C2_稳健性检验.xls", se cttop("∆Pay3") addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line4#应收账款与应收票据之和与期末总资产的比值变化∆Rec3
reghdfe Rec3∆ Climate $controls , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表C2_稳健性检验.xls", se cttop("∆Rec3") addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

  ****************稳健性--剔除受冲击供应商****************
*line5#
reghdfe Pay∆ Climate $controls if  焦与供非同时受冲击==1, abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表C2_稳健性检验.xls", se cttop("∆Pay")  addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

  ****************稳健性--剔除受冲击客户****************
*line6#
reghdfe Rec∆ Climate $controls if  焦与客非同时受冲击==1, abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表C2_稳健性检验.xls", se cttop("∆Rec") addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

  ****************稳健性--只保留制造业样本**************** 
*line7#
reghdfe Pay∆ Climate  $controls if Industry=="C" , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表C2_稳健性检验.xls", se cttop("∆Pay") keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append
*line8#
reghdfe Rec∆ Climate $controls if Industry=="C" , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表C2_稳健性检验.xls", se cttop("∆Rec") keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append


**【表C3	考虑省份层面极端降水覆盖范围】
*line1# Dummy×Climate

reghdfe Pay∆ Dummy×Climate Climate Dummy $controls, abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表C3_考虑省份层面极端降水覆盖范围.xls", se cttop("∆Pay") keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) replace

*line2# Dummy×Climate
reghdfe Rec∆ Dummy×Climate Climate Dummy $controls, abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表C3_考虑省份层面极端降水覆盖范围.xls", se cttop("∆Rec") keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line3# Ratio×Climate
reghdfe Pay∆ Ratio×Climate Climate Ratio $controls , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表C3_考虑省份层面极端降水覆盖范围.xls", se cttop("∆Pay") keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line4# Ratio×Climate
reghdfe Rec∆ Ratio×Climate Climate Ratio $controls , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表C3_考虑省份层面极端降水覆盖范围.xls", se cttop("∆Rec") keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append


**【表C4	考虑异地投资的作用】
*line1# Climate×subcity
reghdfe Pay∆ Climate×subcity Climate $controls , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表C4_考虑异地投资的作用.xls", se cttop("∆Pay") addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) replace

*line2# Climate×subcity
reghdfe Rec∆ Climate×subcity Climate $controls , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表C4_考虑异地投资的作用.xls", se cttop("∆Rec") addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line3# Climate×subfirm
reghdfe Pay∆ Climate×subfirm Climate $controls, abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表C4_考虑异地投资的作用.xls", se cttop("∆Pay") addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line4# Climate×subfirm
reghdfe Rec∆ Climate×subfirm Climate $controls, abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表C4_考虑异地投资的作用.xls", se cttop("∆Rec") addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append





**************************************************************
                      * 进一步分析 *
**************************************************************

**【表5 焦点公司盈利波动】
clear all
use "C:\Users\LENOVO\Desktop\附件X：复现材料\数据\进一步检验\1.贸易信贷的风险分担效应\表5_焦点公司盈利波动.dta"

global controls Size Lev Inv Ppe Firmage Board Occupy Indep S_Climate C_Climate
*line1# 应付端：息税前利润/总资产的标准差 RiskT1
reghdfe  RiskT1 Climate×∆Pay Climate Pay∆ $controls, abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表5_焦点公司盈利波动.xls", se cttop() keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) replace

*line2# 应付端：营业收入/总资产的标准差 RiskT2
reghdfe  RiskT2 Climate×∆Pay Climate Pay∆ $controls , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表5_焦点公司盈利波动.xls", se cttop() keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line3# 应付端：营业收入/总资产最大值与最小值之差 RiskT3
reghdfe  RiskT3 Climate×∆Pay Climate Pay∆ $controls , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表5_焦点公司盈利波动.xls", se cttop() keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line4# 应收端：息税前利润/总资产的标准差 RiskT1
reghdfe  RiskT1 Climate×∆Rec Climate Rec∆ $controls, abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表5_焦点公司盈利波动.xls", se cttop() keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line5# 应收端：营业收入/总资产的标准差 RiskT2
reghdfe  RiskT2 Climate×∆Rec Climate Rec∆ $controls , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表5_焦点公司盈利波动.xls", se cttop() keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line6# 应收端：营业收入/总资产最大值与最小值之差 RiskT3
reghdfe  RiskT3 Climate×∆Rec Climate Rec∆ $controls , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表5_焦点公司盈利波动.xls", se cttop() keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append


**【表B3 供应商端和客户端盈利波动】
  ****************供应商端****************
clear all
use "C:\Users\LENOVO\Desktop\附件X：复现材料\数据\进一步检验\1.贸易信贷的风险分担效应\表B3_供应商端盈利波动.dta"
global controls S_Size S_Lev S_Inv S_Ppe S_Firmage S_Board S_Occupy S_Indep S_Frequency S_Duration Climate_CityS

*line1# 供应商息税前利润/总资产的标准差 S_RiskT1
reghdfe S_RiskT1 Climate×S_∆Rec S_∆Rec Climate $controls , abs( S_ID yq S_Indu_Year S_Prov_Year) vce(cl S_ID)
outreg2 using "表B3_供应商端和客户端盈利波动.xls", se cttop() keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) replace

*line2# 供应商营业收入/总资产的标准差 S_RiskT2
reghdfe S_RiskT2 Climate×S_∆Rec S_∆Rec Climate $controls , abs(S_ID yq S_Indu_Year S_Prov_Year) vce(cl S_ID)
outreg2 using "表B3_供应商端和客户端盈利波动.xls", se cttop() keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line3# 供应商营业收入/总资产最大值与最小值之差 S_RiskT3
reghdfe S_RiskT3 Climate×S_∆Rec S_∆Rec Climate $controls, abs(S_ID yq S_Indu_Year S_Prov_Year) vce(cl S_ID)
outreg2 using "表B3_供应商端和客户端盈利波动.xls", se cttop() keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

  ****************客户端****************
clear all
use "C:\Users\LENOVO\Desktop\附件X：复现材料\数据\进一步检验\1.贸易信贷的风险分担效应\表B3_客户端盈利波动.dta"
global controls C_Size C_Lev C_Inv C_Ppe C_Firmage C_Board C_Occupy C_Indep C_Frequency C_Duration Climate_CityC

*line4# 客户息税前利润/总资产的标准差 C_RiskT1
reghdfe C_RiskT1 Climate×C_∆Pay Climate C_∆Pay $controls, abs( C_ID yq C_Indu_Year C_Prov_Year) vce(cl C_ID)
outreg2 using "表B3_供应商端和客户端盈利波动.xls", se cttop() keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line5# 客户营业收入/总资产的标准差 C_RiskT2
reghdfe C_RiskT2 Climate×C_∆Pay Climate C_∆Pay $controls, abs(C_ID yq C_Indu_Year C_Prov_Year) vce(cl C_ID)
outreg2 using "表B3_供应商端和客户端盈利波动.xls", se cttop() keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line6# 客户营业收入/总资产最大值与最小值之差 C_RiskT3
reghdfe C_RiskT3 Climate×C_∆Pay Climate C_∆Pay $controls, abs(C_ID yq C_Indu_Year C_Prov_Year) vce(cl C_ID)
outreg2 using "表B3_供应商端和客户端盈利波动.xls", se cttop() keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append



**【表6 贸易信贷的传递方向】
use "C:\Users\LENOVO\Desktop\附件X：复现材料\数据\进一步检验\2.贸易信贷的传递方向\表6_贸易信贷的传递方向.dta"
global controls Size Lev Inv Ppe Firmage Board Occupy Indep S_Climate C_Climate
*line1# （应付账款－预付账款）/总资产 CreditfS∆
reghdfe CreditfS∆ Climate  $controls  , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表6_贸易信贷的传递方向.xls", se cttop() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) replace

*line2# （预收账款－应收账款）/总资产 CreditfC∆
reghdfe CreditfC∆ Climate $controls , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表6_贸易信贷的传递方向.xls", se cttop() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line3# （应付账款+应付票据-应收账款-应收票据）/期末总资产 NetCredit1∆
reghdfe NetCredit1∆ Climate $controls  , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表6_贸易信贷的传递方向.xls", se cttop() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append 

*line4# （应付账款+应付票据+预收账款-应收账款-应收票据-预付账款）/期末总资产 NetCredit2∆
reghdfe NetCredit2∆ Climate $controls  , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表6_贸易信贷的传递方向.xls", se cttop() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append 




**【表7	贸易信贷的动态变化】
clear all
use "C:\Users\LENOVO\Desktop\附件X：复现材料\数据\进一步检验\3.贸易信贷的动态变化\表7_贸易信贷的动态变化.dta"

global controls Size Lev Inv Ppe Firmage Board Occupy Indep S_Climate C_Climate
*line1# 第一季度应付
reghdfe F1∆Pay Climate $controls , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表7_贸易信贷的动态变化.xls", se cttop("") keep( ) addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) replace

*line2# 第三季度应付
reghdfe F3∆Pay Climate $controls, abs( ID yq Indu_Year  Prov_Year) vce(cl ID)
outreg2 using "表7_贸易信贷的动态变化.xls", se cttop("") keep( ) addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line3# 第四季度应付
reghdfe F4∆Pay Climate $controls, abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表7_贸易信贷的动态变化.xls", se cttop("") keep( ) addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line4# 第一季度应收
reghdfe F1∆Rec Climate $controls , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表7_贸易信贷的动态变化.xls", se cttop("") keep( ) addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line5# 第三季度应收
reghdfe F3∆Rec Climate $controls , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表7_贸易信贷的动态变化.xls", se cttop("") keep( ) addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line6# 第四季度应收
reghdfe F4∆Rec Climate $controls , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表7_贸易信贷的动态变化.xls", se cttop("") keep( ) addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append





**【表8 公司间交易的证据】
  ****************供应商-焦点公司****************
clear all
use "C:\Users\LENOVO\Desktop\附件X：复现材料\数据\进一步检验\4.公司间交易的证据\焦点公司应付账款明细数据.dta"
xtset ID sup_year
*line1# 期末余额与营业成本的比值 Credit/Cost
reghdfe Credit_Cost Climate_y , abs(sup_year) vce(cl susid )
outreg2 using "表8_公司间交易的证据.xls", se cttop() addtext(Sus_year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) replace

*line2# 期末余额与期末总资产的比值 Credit/Asset
reghdfe Credit_Asset Climate_y , abs(sup_year) vce(cl susid )
outreg2 using "表8_公司间交易的证据.xls", se cttop() addtext(Sus_year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

  ****************焦点公司-客户****************
clear all
use "C:\Users\LENOVO\Desktop\附件X：复现材料\数据\进一步检验\4.公司间交易的证据\焦点公司应收账款明细数据.dta"
xtset ID cus_year

*line3# 期末余额与营业收入的比值 Credit/Sales
reghdfe Credit_Sales Climate_y , abs(cus_year) vce(cl cusid )
outreg2 using "表8_公司间交易的证据.xls", se cttop() addtext(cus_year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line4# 期末余额与期末总资产的比值 Credit/Asset
reghdfe CCredit_Asset Climate_y, abs(cus_year) vce(cl cusid )
outreg2 using "表8_公司间交易的证据.xls", se cttop() addtext(cus_year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append







**************************************************************
                      * 贸易信贷调整的作用机制 *
**************************************************************
clear
use "C:\Users\LENOVO\Desktop\附件X：复现材料\数据\作用机制分析\作用机制.dta"

  ****************供应链联结价值【表9 供应链联结价值对贸易信贷调整的影响】****************
global controls Size Lev Inv Ppe Firmage Board Occupy Indep S_Climate C_Climate
xtset ID yq
*line1# 应付端：产品差异化程度 Climate×Diff
reghdfe Pay∆ Climate Climate×Diff $controls , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表9_供应链联结价值对贸易信贷调整的影响.xls", se cttop("∆Pay") keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) replace

*line2# 应收端：产品差异化程度 Climate×Diff
reghdfe Rec∆ Climate Climate×Diff $controls , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表9_供应链联结价值对贸易信贷调整的影响.xls", se cttop("∆Rec") keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line3# 应付端：合同强度指数 Climate×Contract
reghdfe Pay∆ Climate Climate×Contract $controls , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表9_供应链联结价值对贸易信贷调整的影响.xls", se cttop("∆Pay") keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line4# 应收端：合同强度指数 Climate×Contract
reghdfe Rec∆ Climate Climate×Contract $controls, abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表9_供应链联结价值对贸易信贷调整的影响.xls", se cttop("∆Rec") keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append



  ****************企业议价能力【表10 企业议价能力对贸易信贷调整的影响】****************
*line1# 应付端：供应链集中度 Climate×S_concen
reghdfe Pay∆ Climate Climate×S_concen $controls , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表10_企业议价能力对贸易信贷调整的影响.xls", se cttop("∆Pay") keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) replace

*line2# 应收端：供应链集中度 Climate×C_concen
reghdfe Rec∆ Climate Climate×C_concen $controls , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表10_企业议价能力对贸易信贷调整的影响.xls", se cttop("∆Rec") keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line3# 应付端：相对规模 Climate×S_Rsize
reghdfe Pay∆ Climate Climate×S_Rsize $controls , abs( ID yq Indu_Year Prov_Year) vce(cl yq)
outreg2 using "表10_企业议价能力对贸易信贷调整的影响.xls", se cttop("∆Pay") keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line4# 应收端：相对规模 Climate×C_Rsize
reghdfe Rec∆ Climate Climate×C_Rsize $controls , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表10_企业议价能力对贸易信贷调整的影响.xls", se cttop("∆Rec") keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append



  ****************企业内部缓冲能力 【表11 企业内部缓冲能力对贸易信贷调整的影响】****************
*line1# 应付端：库存规模 Climate×Inv
reghdfe Pay∆ Climate Climate×Inv $controls , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表11_内部缓冲能力对贸易信贷调整的影响.xls", se cttop("∆Pay") keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) replace

*line2# 应收端：库存规模 Climate×Inv
reghdfe Rec∆ Climate Climate×Inv $controls , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表11_内部缓冲能力对贸易信贷调整的影响.xls", se cttop("∆Rec") keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line3# 应付端：借款占比 Climate×Bank
reghdfe Pay∆ Climate Climate×Bank $controls , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表11_内部缓冲能力对贸易信贷调整的影响.xls", se cttop("∆Pay") addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line4# 应收端：借款占比 Climate×Bank
reghdfe Rec∆ Climate Climate×Bank $controls , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表11_内部缓冲能力对贸易信贷调整的影响.xls", se cttop("∆Rec") addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line5# 应付端：利息支出占比 Climate×Interest
reghdfe Pay∆ Climate Climate×Interest  $controls , abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表11_内部缓冲能力对贸易信贷调整的影响.xls", se cttop("∆Pay") addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line6# 应收端：利息支出占比 Climate×Interest
reghdfe Rec∆ Climate Climate×Interest $controls, abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表11_内部缓冲能力对贸易信贷调整的影响.xls", se cttop("∆Rec") addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append




**************************************************************
           * 融资约束、贸易信贷与供应链重组 *
**************************************************************

  ****************（一）融资约束与贸易信贷****************
**【表12 不同融资约束条件下的贸易信贷调整】
clear
use "C:\Users\LENOVO\Desktop\附件X：复现材料\数据\融资约束、贸易信贷与供应链重组\表12_表13_融资约束、贸易信贷与供应链传导.dta"
global controls Size Lev Inv Ppe Firmage Board Occupy Indep S_Climate C_Climate

*line1# 应付不受融资约束
reghdfe Pay∆ Climate $controls if meanKZ ==0, abs( ID yq Indu_Year Prov_Year)  vce(cl ID)
outreg2 using "表12_不同融资约束条件下的贸易信贷调整.xls", se cttop("不受融资约束") keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) replace

*line2# 应付受融资约束
reghdfe Pay∆ Climate  $controls if meanKZ ==1 , abs( ID yq Indu_Year Prov_Year)  vce(cl ID)
outreg2 using "表12_不同融资约束条件下的贸易信贷调整.xls", se cttop("受融资约束") keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append
*line3# 应收不受融资约束
reghdfe Rec∆ Climate  $controls if meanKZ ==0  , abs( ID yq Indu_Year Prov_Year)  vce(cl ID)
outreg2 using "表12_不同融资约束条件下的贸易信贷调整.xls", se cttop("不受融资约束") keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line4# 应收受融资约束
reghdfe Rec∆ Climate  $controls if meanKZ ==1 , abs( ID yq Indu_Year Prov_Year)  vce(cl ID)
outreg2 using "表12_不同融资约束条件下的贸易信贷调整.xls", se cttop("受融资约束") keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append


  ****************（二）融资约束与贸易信贷传导****************
**【表13 融资约束对供应链贸易信贷传导的影响】
*line1#  应付受融资约束
reghdfe Pay∆ Climate Climate×S_FC S_FC $controls  if meanKZ ==1, abs( ID yq Indu_Year Prov_Year)  vce(cl ID)
outreg2 using "表13_融资约束对供应链贸易信贷传导的影响.xls", se cttop("受融资约束") keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) replace

*line2# 应付不受融资约束
reghdfe Pay∆ Climate Climate×S_FC S_FC $controls  if meanKZ ==0  , abs( ID yq Indu_Year Prov_Year)  vce(cl ID)
outreg2 using "表13_融资约束对供应链贸易信贷传导的影响.xls", se cttop("不受融资约束") keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line3# 应收受融资约束
reghdfe Rec∆ Climate Climate×S_FC S_FC $controls  if meanKZ ==1 , abs( ID yq Indu_Year Prov_Year)  vce(cl ID)
outreg2 using "表13_融资约束对供应链贸易信贷传导的影响.xls", se cttop("受融资约束") keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line4# 应收不受融资约束
reghdfe Rec∆ Climate Climate×S_FC S_FC $controls  if meanKZ ==0 , abs( ID yq Indu_Year Prov_Year)  vce(cl ID)
outreg2 using "表13_融资约束对供应链贸易信贷传导的影响.xls", se cttop("不受融资约束") keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append


  ****************（三）贸易信贷与断链重组****************
**【表14 融资约束与断链风险】
clear
use "C:\Users\LENOVO\Desktop\附件X：复现材料\数据\融资约束、贸易信贷与供应链重组\表14_表15_贸易信贷与断链重组.dta"
global controls C_Size C_Lev C_Inv C_Ppe C_Firmage C_Board C_Occupy C_Indep C_Frequency C_Duration Climate_CityC
*line1# 客户c在第q+1季度与焦点公司终止合作 Ter_q_q1
reghdfe Ter_q_q1 Affected×S_FC Affected S_FC $controls , abs(C_ID yq C_Indu_Year C_Prov_Year) vce(cl C_ID)
outreg2 using "表14_融资约束与断链风险.xls", se cttop("") keep( ) addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) replace

*line2# 客户c在第q+2季度与焦点公司终止合作 Ter_q_q2
reghdfe Ter_q_q2 Affected×S_FC Affected S_FC $controls , abs(C_ID yq C_Indu_Year C_Prov_Year) vce(cl C_ID)
outreg2 using "表14_融资约束与断链风险.xls", se cttop("") keep( ) addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line3# 客户c在第q+3季度与焦点公司终止合作 Ter_q_q3
reghdfe Ter_q_q3 Affected×S_FC Affected S_FC $controls , abs(C_ID yq C_Indu_Year C_Prov_Year) vce(cl C_ID)
outreg2 using "表14_融资约束与断链风险.xls", se cttop("") keep( ) addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line4# 客户c在第q+4季度与焦点公司终止合作 Ter_q_q4
reghdfe Ter_q_q4 Affected×S_FC Affected S_FC $controls , abs(C_ID yq C_Indu_Year C_Prov_Year) vce(cl C_ID)
outreg2 using "表14_融资约束与断链风险.xls", se cttop("") keep( ) addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append


**【表15 融资约束与新供应商选择】
*line1# 客户c在第q+1季度与新公司建立联系 New_q_q1
reghdfe New_q_q1 Affected×S_FC Affected S_FC $controls , abs(C_ID yq C_Indu_Year C_Prov_Year) vce(cl C_ID)
outreg2 using "表15_融资约束与新供应商选择.xls", se cttop("") keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) replace

*line2# 客户c在第q+2季度与新公司建立联系 New_q_q2
reghdfe New_q_q2 Affected×S_FC Affected S_FC $controls , abs(C_ID yq C_Indu_Year C_Prov_Year) vce(cl C_ID)
outreg2 using "表15_融资约束与新供应商选择.xls", se cttop("") keep( ) addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line3# 客户c在第q+3季度与新公司建立联系 New_q_q3
reghdfe New_q_q3 Affected×S_FC Affected S_FC $controls , abs(C_ID yq C_Indu_Year C_Prov_Year) vce(cl C_ID)
outreg2 using "表15_融资约束与新供应商选择.xls", se cttop("") keep( ) addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append

*line4# 客户c在第q+4季度与新公司建立联系 New_q_q4
reghdfe New_q_q4 Affected×S_FC Affected S_FC $controls , abs(C_ID yq C_Indu_Year C_Prov_Year) vce(cl C_ID)
outreg2 using "表15_融资约束与新供应商选择.xls", se cttop("") keep( ) addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append


  ****************（四）供应链重组的选择标准【表16 新供应商的选择标准】****************
clear
use "C:\Users\LENOVO\Desktop\附件X：复现材料\数据\融资约束、贸易信贷与供应链重组\表16_选择新供应商的标准.dta"
global controls C_Size C_Lev C_Inv C_Ppe C_Firmage C_Board C_Occupy C_Indep C_Frequency C_Duration Climate_CityC
*line1# 客户和新供应商在同一省份比例 CoProv
reghdfe CoProv Affected×S_FC Affected S_FC  $controls, abs(C_ID yq C_Indu_Year C_Prov_Year) vce(cl C_ID)
outreg2 using "表16_新供应商的选择标准.xls", se cttop("") keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) tdec(4) adjr2 rdec(4) replace

*line2# 客户新供应商平均规模 NewSize
reghdfe NewSize Affected×S_FC Affected S_FC  $controls, abs(C_ID yq C_Indu_Year C_Prov_Year) vce(cl C_ID)
outreg2 using "表16_新供应商的选择标准.xls", se cttop("") keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) tdec(4) adjr2 rdec(4) append

*line3# 客户新供应商存货情况 NewInv
reghdfe NewInv Affected×S_FC Affected S_FC  $controls, abs(C_ID yq C_Indu_Year C_Prov_Year) vce(cl C_ID)
outreg2 using "表16_新供应商的选择标准.xls", se cttop("") keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) tdec(4) adjr2 rdec(4) append

*line4# 客户新供应商融资约束 NewFin
reghdfe NewFin Affected×S_FC Affected S_FC $controls  , abs(C_ID yq C_Indu_Year C_Prov_Year) vce(cl C_ID)
outreg2 using "表16_新供应商的选择标准.xls", se cttop("") keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) tdec(4) adjr2 rdec(4) append



  ****************（五）贸易信贷与企业经营业绩【表D5 融资约束与企业经营业绩】****************
clear
use "C:\Users\LENOVO\Desktop\附件X：复现材料\数据\融资约束、贸易信贷与供应链重组\表D5_融资约束与企业经营业绩.dta"
global controls Size Lev Inv Ppe Firmage Board Occupy Indep S_Climate C_Climate
*line1# 托宾Q值 
reghdfe TobinQ Climate  $controls if meanKZ ==1, abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表D5_融资约束与企业经营业绩.xls", se cttop("受融资约束") keep( ) addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) replace
*line2# 托宾Q值
reghdfe TobinQ Climate  $controls if meanKZ ==0, abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表D5_融资约束与企业经营业绩.xls", se cttop("不受融资约束") keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append
*line3# 息税前利润
reghdfe EBIT Climate  $controls if meanKZ==1, abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表D5_融资约束与企业经营业绩.xls", se cttop("受融资约束") keep( ) addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append
*line4# 息税前利润
reghdfe EBIT Climate  $controls if meanKZ==0, abs( ID yq Indu_Year Prov_Year) vce(cl ID)
outreg2 using "表D5_融资约束与企业经营业绩.xls", se cttop("不受融资约束") keep() addtext(Firm FE,YES,Yq FE, YES,Indu_Year FE,YES,Prov_Year FE,YES) bdec(4) sdec(4) adjr2 rdec(4) append






  *************************************END***********************************************
  
  