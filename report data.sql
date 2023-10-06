create view powerbi_stage.membership as

-- ar, az, nd, nm, nz

select 
	cm.month_year as "Period",
	cm.year as "Year",
	cm.month as "Month",
	mds.patient_id as "User", 
	FLOOR(DATEDIFF(CURRENT_DATE(), mds.BIRTH_DATE_DIM_CK)/365) as "Age", 
	mds.SEX as "Gender", 
	mds.ADD_STATE_CODE as "Market", 
	mds.ADD_STD_COUNTY_NAME as "County",
	mds.ADD_POSTAL_CODE as "Zip Code",
	mds.SOURCE_DESC as "Line of Business",
	concat('AR-', mds.source_id) as source_id,
	rmd.classification as "Risk Type",
	pt.plan_type as "Plan Type",	
	mds.PLAN_DESC as "Contract",
	
	0 as "PMPM Revenue",
	0 as "PMPM Claims Paid",
	0 as "Cost"
from ar_carepointe_reports.tbl_membership_data_source mds
inner join ar_carepointe_reports.tbl_calendar_month cm 
	on mds.calendar_month_id = cm.calendar_id
inner join ar_carepointe_reports.tbl_plan_type_benefit_relationship ptbr
	on mds.plan_type_benefit_id = ptbr.id
inner join ar_carepointe_reports.tbl_plan_type pt
	on ptbr.plan_type_id = pt.plan_type_id 
left join ar_carepointe.tbl_riskgroup_member_data rmd 
	on mds.patient_id = rmd.patient_id 

union all
select 
	cm.month_year as "Period",
	cm.year as "Year",
	cm.month as "Month",
	mds.patient_id as "User", 
	FLOOR(DATEDIFF(CURRENT_DATE(), mds.BIRTH_DATE_DIM_CK)/365) as "Age", 
	mds.SEX as "Gender", 
	mds.ADD_STATE_CODE as "Market", 
	mds.ADD_STD_COUNTY_NAME as "County",
	mds.ADD_POSTAL_CODE as "Zip Code",
	mds.SOURCE_DESC as "Line of Business",
	concat('AZ-', mds.source_id) as source_id,
	rmd.classification as "Risk Type",
	pt.plan_type as "Plan Type",	
	mds.PLAN_DESC as "Contract",
	
	0 as "PMPM Revenue",
	0 as "PMPM Claims Paid",
	0 as "Cost"
from az_carepointe_reports.tbl_membership_data_source mds
inner join az_carepointe_reports.tbl_calendar_month cm 
	on mds.calendar_month_id = cm.calendar_id
inner join az_carepointe_reports.tbl_plan_type_benefit_relationship ptbr
	on mds.plan_type_benefit_id = ptbr.id
inner join az_carepointe_reports.tbl_plan_type pt
	on ptbr.plan_type_id = pt.plan_type_id 
left join az_carepointe.tbl_riskgroup_member_data rmd 
	on mds.patient_id = rmd.patient_id 