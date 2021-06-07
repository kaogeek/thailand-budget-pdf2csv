## PDF to HTML to CSV
This approach parse data from PDF then parse structured data to CSV.

### Prerequisites
Requires `docker` to be installed.

### How to run ?
```shell
make run/pdf2html # convert all pages from every file into HTML (*-full.html)
make run/pdf2html/cover-page # convert all cover pages from every file into HTML (*-cover.html)
make parse # Parse HTML into data
```