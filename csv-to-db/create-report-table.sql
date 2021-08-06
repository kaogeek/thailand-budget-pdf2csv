-- ,ITEM_ID,REF_DOC,REF_PAGE_NO,MINISTRY,BUDGETARY_UNIT,CROSS_FUNC?,BUDGET_PLAN,OUTPUT,PROJECT,CATEGORY_LV1,CATEGORY_LV2,CATEGORY_LV3,CATEGORY_LV4,CATEGORY_LV5,CATEGORY_LV6,ITEM_DESCRIPTION,FISCAL_YEAR,AMOUNT,OBLIGED?
create table if not exists budget (
   item_id varchar(32) primary key,
   ref_doc varchar(32),
   ref_page_no varchar(32),
   ministry varchar(32),
   budgetary_unit varchar(32),
   is_cross_func boolean,
   budget_plan varchar(255),
   output varchar(255),
   project varchar(255),
   category_lv1 varchar(255),
   category_lv2 varchar(255),
   category_lv3 varchar(255),
   category_lv4 varchar(255),
   category_lv5 varchar(255),
   category_lv6 varchar(255),
   item_description varchar(255),
   fiscal_year smallint,
   amount money,
   is_obliged boolean
);
