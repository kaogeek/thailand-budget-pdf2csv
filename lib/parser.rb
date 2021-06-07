require 'nokogiri'

class Parser
  TH_NUM = { 
    '๑' => '1',
    '๒' => '2',
    '๓' => '3',
    '๔' => '4',
    '๕' => '5',
    '๖' => '6',
    '๗' => '7',
    '๘' => '8',
    '๙' => '9',
    '๐' => '0'
  }
  # match one or more Thai number 0 - 9
  TH_NUM_REGEX = /[\u0E50-\u0e59]+/

  # Parse REF_DOC from cover page of the report
  # Params:
  # +cover_file_name+:: a path to the html file of the cover page in relative to parser.rb (e.g. '../budget-html/8-pm-office-cover.html')
  def ref_doc(cover_file_path)
    raw_html_dir = File.join(File.dirname(__FILE__), cover_file_path)    
    doc = File.open(raw_html_dir) { |f| Nokogiri::HTML(f) }

    if doc.at('div:contains("เอกสารงบประมาณ")') == nil
      puts cover_file_path
      puts doc.at('div:contains("เอกสารงบประมาณ")')
      return
    end
    # chabub_th, fiscal_year_th, lem_th = doc.at('div:contains("ประจำาปีงบประมาณ")').text.strip.scan(TH_NUM_REGEX)
    chabub_th, fiscal_year_th, lem_th = doc.at('div:contains("เอกสารงบประมาณ")').text.strip.scan(TH_NUM_REGEX)

    fiscal_year_be = fiscal_year_th.split("").map { |th_num| th_num_to_arabic(th_num) }.join
    chabub = chabub_th.split("").map { |th_num| th_num_to_arabic(th_num) }.join
    lem = lem_th.split("").map { |th_num| th_num_to_arabic(th_num) }.join
    
    fiscal_year = be_to_ad(fiscal_year_be.to_i)

    "#{fiscal_year}.#{chabub}.#{lem}"
  end

  private def th_num_to_arabic(num)
    TH_NUM[num]
  end

  private def be_to_ad(be_year) = be_year - 543

  def parse(filename)
    puts 'parsing data...'

    raw_html_dir = File.join(File.dirname(__FILE__), filename)
    filename_without_extension = filename.split('.').first
    output_dir = File.join(File.dirname(__FILE__), 'csv', "#{filename_without_extension}.csv")

    # parse html into Ruby obj
    doc = File.open(raw_html_dir) { |f| Nokogiri::HTML(f) }

    # simple cleanup
    data = doc.css('.t').map(&:text).map(&:strip).map { |s| s.split("  ") }.each { |i| i.filter! { |ii| ii != ""} }

    # write output file
    File.open(output_dir, 'w') { |file| file.write(data.to_s) }

    puts "output: #{output_dir}"
  end
end