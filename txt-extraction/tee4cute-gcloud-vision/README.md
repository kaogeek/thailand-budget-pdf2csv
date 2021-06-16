# thailand-budget-pdf2csv
## Let's create a tool to convert Thailand Government Budgeting from PDF to CSV!

[![N|Solid](https://avatars.githubusercontent.com/u/76727483?s=200&v=4)](https://github.com/kaogeek)

รวมพลัง Dev แปลงงบ
จาก PDF สู่ Machine-readable

เพื่อการตรวจสอบงบประมาณแผ่นดินที่ง่ายมากขึ้น

## PDF to TXT (Google Cloud Vision API)

This is an approach for **PDF to TXT** file extraction using `Google Cloud Vision API`

## Usage

Please see the output files in `./output` folder.

- **budget_pdf2txt.json:** A combined result output file written in `json` format.
```json
{
    "<ref-doc-1>": [
      "<page1-txt>",
      "<page2-txt>",
      ...
    ],
    "<ref-doc-2>": [
      "<page1-txt>",
      "<page2-txt>",
      ...
    ],
    ...
}
```

## Download

Since all output files including `jpg` and `txt` for each individual page are too large to push on **Github**. You can download all of those files in `zip` from the following link below:

**Download:** https://drive.google.com/file/d/14rI6x--MmuVNsn1HT8LnV2Z28jnFUPoI/view?usp=sharing

**File Structure:** The zip will contain files generated during PDF -> TXT conversion kept in the following structure.
```
  ./image/
    - <ref-doc-1>/
      - <page1>.jpg
      - <page2>.jpg
      - *.jpg
    - <ref-doc-*>/
      - *.jpg

  ./pdf/
    - <ref-doc-1>.pdf
    - <ref-doc-2>.pdf
    - *.pdf

  ./text/
    - <ref-doc-1>/
      - <page1>.txt
      - <page2>.txt
      - *.txt
    - <ref-doc-*>/
      - *.txt
```

## Source

You can see `.ipynb` source code in `./source` folder.

## Talk

**"ก้าวGeek Community"**, Line Group: http://line.me/ti/g/STUxfMX87U
