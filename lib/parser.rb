require 'nokogiri'

puts 'parsing data...'

raw_html_dir = File.join(File.dirname(__FILE__), '../budget-html/8-pm-office.html')
output_dir = File.join(File.dirname(__FILE__), 'sample_parsed_data.txt')

# parse html into Ruby obj
doc = File.open(raw_html_dir) { |f| Nokogiri::HTML(f) }

# simple cleanup
data = doc.css('.t').map(&:text).map(&:strip).map { |s| s.split("  ") }.each { |i| i.filter! { |ii| ii != ""} }

# write output file
File.open(output_dir, 'w') { |file| file.write(data.to_s) }

puts "output: #{output_dir}"
