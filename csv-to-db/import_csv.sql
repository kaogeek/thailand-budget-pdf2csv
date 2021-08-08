copy budget (
   item_id,
   ref_doc,
   ref_page_no,
   ministry,
   budgetary_unit,
   is_cross_func,
   budget_plan,
   output,
   project,
   category_lv1,
   category_lv2,
   category_lv3,
   category_lv4,
   category_lv5,
   category_lv6,
   item_description,
   fiscal_year,
   amount,
   is_obliged
)
from '/full_budget_db_ready.csv'
delimiter ','
csv header;
