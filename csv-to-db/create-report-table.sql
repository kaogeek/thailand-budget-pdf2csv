-- ,ITEM_ID,REF_DOC,REF_PAGE_NO,MINISTRY,BUDGETARY_UNIT,CROSS_FUNC?,BUDGET_PLAN,OUTPUT,PROJECT,CATEGORY_LV1,CATEGORY_LV2,CATEGORY_LV3,CATEGORY_LV4,CATEGORY_LV5,CATEGORY_LV6,ITEM_DESCRIPTION,FISCAL_YEAR,AMOUNT,OBLIGED?
create table if not exists budget (
   item_id varchar(32) primary key,
   ref_doc varchar(32),
   ref_page_no smallint,
   ministry varchar(255),
   budgetary_unit varchar(255),
   is_cross_func boolean,
   budget_plan text,
   output text,
   project text,
   category_lv1 text,
   category_lv2 text,
   category_lv3 text,
   category_lv4 text,
   category_lv5 text,
   category_lv6 text,
   item_description text,
   fiscal_year smallint,
   amount numeric(15, 2),
   is_obliged boolean
);
