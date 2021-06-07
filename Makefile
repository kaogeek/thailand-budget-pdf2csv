run/pdf2html/cover-page:
	cd lib && docker run -it --rm --name budget-html-parser -v $(shell pwd):/script -w /script/lib ruby:3.0.1 bundle --quiet && rake pdf2html:only_cover

run/parser:
	docker run -it --rm --name budget-html-parser -v $(shell pwd):/script -w /script/lib ruby:3.0.1 bundle --quiet && ruby lib/parser.rb
