sample/pdf2html:
	./parse-pdf

run/parser:
	docker run -it --rm --name budget-html-parser -v $(shell pwd):/script -w /script/lib ruby:3.0.1 bundle --quiet && ruby lib/parser.rb
