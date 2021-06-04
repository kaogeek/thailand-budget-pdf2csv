# thailand-budget-pdf2csv
## Let's create a tool to convert Thailand Government Budgeting from PDF to CSV!

[![N|Solid](https://avatars.githubusercontent.com/u/76727483?s=200&v=4)](https://github.com/kaogeek)

รวมพลัง Dev แปลงงบ
จาก PDF สู่ Machine-readable

เพื่อการตรวจสอบงบประมาณแผ่นดินที่ง่ายมากขึ้น

## Usage

- Download budget PDF file from `budget-pdf` (เล่มขาวคาดแดง)

## Result

We wait for your results : )

#### Expected Output Format (V1)

| Field Name        | Formal Thai Name              | Data Type / Format              | Description
| :---:             | :---                          | :---                            | :---
| `ITEM_ID`         | -                             | str / [`REF_DOC`].[RUNNING_NO]  | Unique Id ของแต่ละ row, สำหรับ `REF_DOC` = ดูที่ field `REF_DOC`, RUNNING_NO = เลข running no ของแต่ละ row ในเล่มงบ (pdf) ไฟล์นั้น ๆ
| `REF_DOC`         | -                             | str / [FY].[ฉบับ].[เล่ม]          | เลขที่เอกสารเล่มงบ (pdf), [FY]=ปีงบประมาณของเล่มงบ, [ฉบับ]=ฉบับที่, [เล่ม]=เล่มที่ (บางเล่มจะมีวงเล็บต่อท้ายด้วย)
| `REF_PAGE_NO`     | -                             | int                             | หน้าของเอกสารในเล่มงบที่แสดงอยู่บริเวณหัวกระดาษของ row นั้น (โปรดระวัง! เกือบทุกกรณี หน้าเอกสารจะไม่ใช่ pdf page)
| `MINISTRY`        | กระทรวง/หน่วยงานเทียบเท่ากระทรวง | str                             |
| `BUDGETARY_UNIT`  | หน่วยรับงบประมาณ                | str                             | ส่วนใหญ่เป็นกรม/หน่วยงานเทียบเท่ากรม
| `CROSS_FUNC?`     |                               | bool                            | เป็น row (งบประมาณ) ภายใต้แผนงานบูรณาการ ใช่หรือไม่?, **แผนงานบูรณาการ** หมายถึง แผนงานที่มีชื่อขึ้นต้นด้วยคำว่า "แผนงานบูรณาการ", **See:** `BUDGET_PLAN`
| `BUDGET_PLAN`     | แผนงาน                        | str                             | ชื่อแผนงานตาม [พ.ร.บ.วิธีการงบประมาณฯ](http://www.ratchakitcha.soc.go.th/DATA/PDF/2561/A/092/1.PDF)
| `OUTPUT`          | ผลผลิต                         | str                             | ภายใต้แผนงานจะมี `0-n` ผลผลิต/โครงการ, 1 row จะสามารถอยู่ภายใต้ 1 ผลผลิต `XOR` 1 โครงการ อย่างใดอย่างหนึ่ง
| `PROJECT`         | โครงการ                       | str                             | ภายใต้แผนงานจะมี `0-n` ผลผลิต/โครงการ, 1 row จะสามารถอยู่ภายใต้ 1 ผลผลิต `XOR` 1 โครงการ อย่างใดอย่างหนึ่ง
| `CATEGORY_LV1`    | งบรายจ่าย                      | str                             | หมวดงบรายจ่าย `level-1` จะประกอบไปด้วย **งบบุคลากร**, **งบดำเนินงาน**, **งบลงทุน**, **งบเงินอุดหนุน**, **งบรายจ่ายอื่น** เท่านั้น
| `CATEGORY_LV2`    | งบรายจ่าย                      | str                             | หมวดงบรายจ่าย `level-2`, ในเอกสาร pdf จะปรากฏอยู่ใน line item ที่มีเลข (ordered list) นำหน้าอยู่ใน format `x.y.z`
| `CATEGORY_LV3`    | งบรายจ่าย                      | str                             | หมวดงบรายจ่าย `level-3`, ในเอกสาร pdf จะปรากฏอยู่ใน line item ที่มีเลข (ordered list) นำหน้าอยู่ใน format `x.y.z`
| `CATEGORY_LV4`    | งบรายจ่าย                      | str                             | หมวดงบรายจ่าย `level-4`, ในเอกสาร pdf จะปรากฏอยู่ใน line item ที่มีเลข (ordered list) นำหน้าอยู่ใน format `x.y.z`
| `CATEGORY_LV5`    | งบรายจ่าย                      | str                             | หมวดงบรายจ่าย `level-5`, ในเอกสาร pdf จะปรากฏอยู่ใน line item ที่มีเลข (ordered list) นำหน้าอยู่ใน format `x.y.z`
| `CATEGORY_LV6`    | งบรายจ่าย                      | str                             | หมวดงบรายจ่าย `level-6`, ในเอกสาร pdf จะปรากฏอยู่ใน line item ที่มีเลข (ordered list) นำหน้าอยู่ใน format `x.y.z`
| `ITEM_DESCRIPTION`| -                             | str                             | ชื่อรายการ, ในเอกสาร pdf จะปรากฏอยู่ใน line item ที่มีเลข (ordered list) นำหน้าอยู่ใน format `(x)`, บาง row อาจไม่มี `ITEM_DESCRIPTION` ก็ได้
| `FISCAL_YEAR`     | ปีงบประมาณ                     | str / ปี ค.ศ.                    | มีโอกาสที่ 1 line item อาจมีหลาย row ได้หากรายการนั้นเป็นรายการ **งบผูกพัน**
| `AMOUNT`          | -                             | float                           | จำนวนเงินงบประมาณ
| `OBLIGED?`        | -                             | bool                            | มีค่าเป็น TRUE ก็ต่อเมื่อ เป็น line item ที่มีข้อมูลหลาย row `FISCAL_YEAR`

**Note:** Please see output example in `output_example_vx.xlsx` and `output_example_vx.csv` at repository root.

## Talk

**"ก้าวGeek Community"**, Line Group: http://line.me/ti/g/STUxfMX87U
