build:
	docker build . -t vtno-report-extractor
extract/report: build
	docker run -it -w /script -v $(shell pwd):/script vtno-report-extractor