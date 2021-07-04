# Wordbag

This approach has 2 steps:

1. Extracting the report from the whole book
2. Use keywords with a smart lookback to extract the line item from the report

## Report Extraction

This step extracts all budget report from the book by looking at the table of content (toc). It loops through each ministry and budget unit and extract the reports (`แผนงานบุคลากร`, `ผลผลิต` and `โครงการ`).

The result is saved with this name `<ref-doc>-reports.json` in this format:

```json
[
  [{":ministry": "งบกลาง", ":budget_unit": "งบกลาง", ":report": ["<JSON BLOB WITH COORDINATE FROM OCR>"] }],
  [{":ministry": "สำนักนายกรัฐมนตรี", ":budget_unit": "สำนักงานปลัดสำนักนายกรัฐมนตรี", ":report": ["<JSON BLOB WITH COORDINATE FROM OCR>"] }]
]
```

### Prerequisite
- [Docker](https://www.docker.com/)
- [make](https://www.gnu.org/software/make/)

### How to run?
```shell
make extract/report
```

## CSV Extraction

WIP

# Contributing

- You need [Ruby 3.0.0](https://www.ruby-lang.org/en/downloads/) install to start development
