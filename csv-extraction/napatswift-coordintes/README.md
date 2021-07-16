# thailand-budget-pdf2csv
## Let's create a tool to convert Thailand Government Budgeting from PDF to CSV!

[![N|Solid](https://avatars.githubusercontent.com/u/76727483?s=200&v=4)](https://github.com/kaogeek)

รวมพลัง Dev แปลงงบ
จาก PDF สู่ Machine-readable

เพื่อการตรวจสอบงบประมาณแผ่นดินที่ง่ายมากขึ้น

## ThaiBudget Class

`ThaiBudget(json_path)`

| Method | Description |
|--------|-------------|
|`.doc(ref_doc)`|Returns a `ref_doc` of the `Doc` class.|

| Property | Description |
|----------|-------------|
|`.docs`|Return list of `ref_doc` string|

## Doc Class

`Doc(raw_pages, ref_doc)`

| Method | Description |
|--------|-------------|
|`.page(num_page, true_numpage=False)`|Return `Page` class of int `num_page`. if `true_numpage`, this method will return a `Page` of pdf page (the number on the top cornor.)|
|`.get_ministry(budg_u)`|Return dictionary of ministry and range of budgetary unit if found, or None|
|`.get_budgetary_unit(ministry)`|Return list of dictionary of budgetary unit and range of given `ministry`|

| Property | Description |
|----------|-------------|
|`.fiscal_year`|Return fiscal year of `Doc`|
|`.chabab`|Return ฉบับ of `Doc`|
|`.lem`|Return เล่ม of `Doc`|
|`.ministry`|Return list of ministry that contains in the `Doc` and finds at cover of index 0 of the `Doc`|
|`.range`|Return list of ministry unit dictionary.|
|`.start`|Return index of 1st page of pdf|
|`.index_page`|Return list of index page|

## Page Class

`Page(index_page, page, pdfpage=None)`

| Method | Description |
|--------|-------------|
|`.get_blocks()`|Return list of dictionary|
|`.get_dict_index_level(level_tolerance=10)`|Return dictionary. Line that has x position differance less than `level_tolerance` will be considered as the same level|
|`.get_line_level(level_tolerance=10)`|Return list of int, a level of each line. Line that has x position differance less than `level_tolerance` will be considered as the same level|
|`.get_lines(line_tolerance=17, yPos=False)`|Return list of lines. Lines that has y position (y bottom position of the box) less than `line_tolerance` will be considered as the same line. `yPos=True` will return y position of each line|
|`.get_text_lines()`|Return list of string each line|
|`.get_text_list_lines()`|return list of list of string|
|`.xpos_text_lines()`|Return tuple of a list of least x position of line, and a list of list of text in boxes|

| Property | Description |
|----------|-------------|
|`xSigPos`|Return numpy arry of `x` postion of `บาท`. This can be used to determine position of the whole page|
|`dline_tolerance=23`|Return default line tolerance of the page|
|`index_page`|Return page index of the document|
|`pdfpage`|Return pdf page of page|
