# thailand-budget-pdf2csv
## Let's create a tool to convert Thailand Government Budgeting from PDF to CSV!

[![N|Solid](https://avatars.githubusercontent.com/u/76727483?s=200&v=4)](https://github.com/kaogeek)

รวมพลัง Dev แปลงงบ
จาก PDF สู่ Machine-readable

เพื่อการตรวจสอบงบประมาณแผ่นดินที่ง่ายมากขึ้น

## Usage

#### PDF -> TXT

You can download the results and see the source code in each approach under `./txt-extraction` folder, or, just download output files from shortcut links below:

- **teecute-gcloud-vision:** [Google Drive](https://drive.google.com/drive/folders/10MaVM0jKW2oAAfHoRw6nvFY57071Qd2N?usp=sharing) folder.

#### TXT -> CSV

We're still waiting for your results .. : )

## Let's Code!

Download source budget PDF files from `budget-pdf` (เล่มขาวคาดแดง) and do some secret magics to generate output `csv` files with exepcted format below:

#### Expected Output Format (V2)

| Field Name        | Formal Thai Name              | Data Type / Format              | Description                             | Since Version
| :---:             | :---                          | :---                            | :---                                    | :---
| `ITEM_ID`         | -                             | str / [`REF_DOC`].[RUNNING_NO]  | Unique Id ของแต่ละ row, สำหรับ `REF_DOC` = ดูที่ field `REF_DOC`, RUNNING_NO = เลข running no ของแต่ละ row ในเล่มงบ (pdf) ไฟล์นั้น ๆ                                                        | v1
| `REF_DOC`         | -                             | str / [FY].[ฉบับ].[เล่ม]          | เลขที่เอกสารเล่มงบ (pdf), [FY]=ปีงบประมาณของเล่มงบ, [ฉบับ]=ฉบับที่, [เล่ม]=เล่มที่ (บางเล่มจะมีวงเล็บต่อท้ายด้วย)                                                                                 | v1
| `REF_PAGE_NO`     | -                             | int                             | หน้าของเอกสารในเล่มงบที่แสดงอยู่บริเวณหัวกระดาษของ row นั้น (โปรดระวัง! เกือบทุกกรณี หน้าเอกสารจะไม่ใช่ pdf page)                                                                               | v1
| `MINISTRY`        | กระทรวง/หน่วยงานเทียบเท่ากระทรวง | str                             |                                         | v1
| `BUDGETARY_UNIT`  | หน่วยรับงบประมาณ                | str                             | ส่วนใหญ่เป็นกรม/หน่วยงานเทียบเท่ากรม          | v1
| `CROSS_FUNC?`     |                               | bool                            | เป็น row (งบประมาณ) ภายใต้แผนงานบูรณาการ ใช่หรือไม่?, **แผนงานบูรณาการ** หมายถึง แผนงานที่มีชื่อขึ้นต้นด้วยคำว่า "แผนงานบูรณาการ", **See:** `BUDGET_PLAN`                                          | v1
| `BUDGET_PLAN`     | แผนงาน                        | str                             | ชื่อแผนงานตาม [พ.ร.บ.วิธีการงบประมาณฯ](http://www.ratchakitcha.soc.go.th/DATA/PDF/2561/A/092/1.PDF)                                                                          | v1
| `OUTPUT`          | ผลผลิต                         | str                             | ภายใต้แผนงานจะมี `0-n` ผลผลิต/โครงการ, 1 row จะสามารถอยู่ภายใต้ 1 ผลผลิต `XOR` 1 โครงการ อย่างใดอย่างหนึ่ง                                                                           | v1
| `PROJECT`         | โครงการ                       | str                             | ภายใต้แผนงานจะมี `0-n` ผลผลิต/โครงการ, 1 row จะสามารถอยู่ภายใต้ 1 ผลผลิต `XOR` 1 โครงการ อย่างใดอย่างหนึ่ง                                                                           | v1
| `CATEGORY_LV1`    | งบรายจ่าย                      | str                             | หมวดงบรายจ่าย `level-1` จะประกอบไปด้วย **งบบุคลากร**, **งบดำเนินงาน**, **งบลงทุน**, **งบเงินอุดหนุน**, **งบรายจ่ายอื่น** เท่านั้น                                                                | v1
| `CATEGORY_LV2`    | งบรายจ่าย                      | str                             | หมวดงบรายจ่าย `level-2`, ในเอกสาร pdf จะปรากฏอยู่ใน line item ที่มีเลข (ordered list) นำหน้าอยู่ใน format `x.y.z`                                                                              | v1
| `CATEGORY_LV3`    | งบรายจ่าย                      | str                             | หมวดงบรายจ่าย `level-3`, ในเอกสาร pdf จะปรากฏอยู่ใน line item ที่มีเลข (ordered list) นำหน้าอยู่ใน format `x.y.z`                                                                              | v1
| `CATEGORY_LV4`    | งบรายจ่าย                      | str                             | หมวดงบรายจ่าย `level-4`, ในเอกสาร pdf จะปรากฏอยู่ใน line item ที่มีเลข (ordered list) นำหน้าอยู่ใน format `x.y.z`                                                                              | v1
| `CATEGORY_LV5`    | งบรายจ่าย                      | str                             | หมวดงบรายจ่าย `level-5`, ในเอกสาร pdf จะปรากฏอยู่ใน line item ที่มีเลข (ordered list) นำหน้าอยู่ใน format `x.y.z`                                                                              | v1
| `CATEGORY_LV6`    | งบรายจ่าย                      | str                             | หมวดงบรายจ่าย `level-6`, ในเอกสาร pdf จะปรากฏอยู่ใน line item ที่มีเลข (ordered list) นำหน้าอยู่ใน format `x.y.z`                                                                              | v1
| `ITEM_DESCRIPTION`| -                             | str                             | ชื่อรายการ, ในเอกสาร pdf จะปรากฏอยู่ใน line item ที่มีเลข (ordered list) นำหน้าอยู่ใน format `(x)`, บาง row อาจไม่มี `ITEM_DESCRIPTION` ก็ได้                                                    | v1
| `FISCAL_YEAR`     | ปีงบประมาณ                     | str / ปี ค.ศ.                    | มีโอกาสที่ 1 line item อาจมีหลาย row ได้หากรายการนั้นเป็นรายการ **งบผูกพัน**                                                                                               | v1
| `AMOUNT`          | -                             | float                           | จำนวนเงินงบประมาณ                        | v1
| `OBLIGED?`        | -                             | bool                            | มีค่าเป็น TRUE ก็ต่อเมื่อ เป็น line item ที่มีข้อมูลหลาย row `FISCAL_YEAR`                                                                                                               | v1
| `DEBUG_LOG`       | -                             | str                             | Log message สำหรับแจ้ง error ที่เกิดขึ้นระหว่างการ extract row นั้น ๆ                                                                                                                | v2

**Note:** Please see output example in `output_example_vx.xlsx` and `output_example_vx.csv` at repository root.

## Talk

**"ก้าวGeek Community"**, Line Group: http://line.me/ti/g/STUxfMX87U
