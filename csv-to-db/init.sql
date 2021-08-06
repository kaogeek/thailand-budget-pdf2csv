create table budget_items (
    ITEM_ID          text,
    REF_DOC          text,
    REF_PAGE_NO      text,
    MINISTRY         text,
    BUDGETARY_UNIT   text,
    "CROSS_FUNC?"    text,
    BUDGET_PLAN      text,
    OUTPUT           text,
    PROJECT          text,
    CATEGORY_LV1     text,
    CATEGORY_LV2     text,
    CATEGORY_LV3     text,
    CATEGORY_LV4     text,
    CATEGORY_LV5     text,
    CATEGORY_LV6     text,
    ITEM_DESCRIPTION text,
    FISCAL_YEAR      text,
    AMOUNT           text,
    "OBLIGED?"       text
);

copy budget_items (
    ITEM_ID,
    REF_DOC,
    REF_PAGE_NO,
    MINISTRY,
    BUDGETARY_UNIT,
    "CROSS_FUNC?",
    BUDGET_PLAN,
    OUTPUT,
    PROJECT,
    CATEGORY_LV1,
    CATEGORY_LV2,
    CATEGORY_LV3,
    CATEGORY_LV4,
    CATEGORY_LV5,
    CATEGORY_LV6,
    ITEM_DESCRIPTION,
    FISCAL_YEAR,
    AMOUNT,
    "OBLIGED?"
)
from '/usr/src/output_examples_v1.csv'
delimiter ','
csv header;
