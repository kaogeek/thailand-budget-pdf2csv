require 'nokogiri'
require 'csv'
require 'pry'

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
  TH_ALPHABET_REGEX = /[\u0E00-\u0e5b]/
  # match every non-thai character excluding arabic number
  NOT_TH_ALPHABET_REGEX = /[^\u0E00-\u0e5b0-9]/
  NOT_TH_ALPHABET_NOT_ARABIC_NUMBER_REGEX = /[^\u0E00-\u0e5b]/
  # one or more number
  ONE_OR_MORE_NUMBER_REGEX = /[0-9+]/
  # match only 7.x format
  SEVEN_POINT_X_REGEX = /7\.\d*/

  # 1) or 2) etc.
  SUB_BULLET_WITH_BRACKET = /\d\)/
  # (1) or (2)
  SUB_BULLET_WITH_FULL_BRACKET = /\(\d+\)/

  TOC_PAGE_NO_REGEX = /\d+\s\d+/

  BUDGET_TYPE = { personnel: 'รายการบุคลากรภาครัฐ', output: 'ผลผลิต', project: 'โครงการ' }

  CURRENCY_REGEX = /[+-]?[0-9]{1,3}(?:,?[0-9]{3})*/

  # prefixes including mulformed version of them
  MINISTRY_PREFIX = [
    "กระทรวง", "สำนัก", "กรม" "ส่วนราชการ", "หน่วยงาน", "จังหวัดและกลุ่มจังหวัด",
    "รัฐวิสาหกิจ", "องค์กรปกครองส่วนท้องถิ่น", "งบกลาง", "ทุนหมุนเวียน", "กะทวง", "ำาัก", "กม"
  ]

  MULFORMED_MAP = {
    "กะทวง" => "กระทรวง",
    "ปะชาัมั์" => "ประชาสัมพันธ์",
    "่าวกอง" => "ข่าวกรอง",
    "ำาัก" => "สำนัก",
    "ส านัก" => "สำนัก",
    "ส  านัก" => "สำนัก",
    "งา" => "งาน",
    "กม" => "กรม",
    "ายก" => "นายก",
    "กมกา" => "กรรมการ",
    "ัฐมตี" => "รัฐมนตรี",
    "้า" => "ข้า",
    "าชกา" => "ราชการ",
    "ลเือ" => "พลเรือน",
    "คอง" => "ครอง",
    "ู้" => "ผู้",
    "บิโภค" => "บริโภค",
    "ปะมาณ" => "ประมาณ",
    "ับ" => "ขับ",
    "เคลื่อ" => "เคลื่อน",
    "กา" => "การ",
    "ปฏิูป" => "ปฏิรูป",
    "ปะเทศ" => "ประเทศ",
    "ยุทศาต์" => "ยุทธศาสตร์",
    "้าง" => "สร้าง",
    "ามัคคี" => "สามัคคี",
    "ปองดอง" => "ปรองดอง",
    "่าวกอง" => "ข่าวกรอง",
    "ึง" => "",
    "กฤษีกา" => "กฤษฎีกา",
    "ัฒา" => "พัฒนา",
    "ะบบ" => "ระบบ",
    "เลาิกา" => "เลขาธิการ",
    "กองทั" => "กองทัพ",
    "าบั" => "สถาบัน",
    "เทคโโลยี" => "เทคโนโลยี",
    "กั" => "กัน",
    "่งเิม" => "ส่งเสริม",
    "ลงทุ" => "ลงทุน",
    "ทัยาก" => "ทรัพยากร",
    "ำ�า" => "น้ำ",
    "ภา" => "สภา",
    "เศษฐกิจ" => "เศรษฐกิจ",
    "อำาวย" => "อำนวย",
    "ศูย์" => "ศูนย์",
    "ักษา" => "รักษา",
    "ลปะโยช์" => "ผลประโยชน์",
    "อง" => "ของ",
    "าช" => "ราช",
    "ภณ์" => "ภรณ์",
    "มั่" => "มั่น",
    "เือ" => "เรือ",
    "ค์" => "สรรค์",
    "บิหา" => "บริหาร",
    "ภายใ" => "ภายใน",
    "จัก" => "จักร",
    "ิงคค" => "องค์ความรู้",
    "ัฐบาล" => "รัฐบาล",
    "ิงคค" => "พิงคนคร",
    "มหาช" => "มหาชน",
    "ปะชุม" => "ประชุม",
    "ุภา" => "สุขภาพ",
    "วิชาชี" => "วิชาชีพ",
    "บิการ" => "บริหาร",
    "าคา"=> "ธนาคาร",
    "ที่ดิ" => "ที่ดิน",
    "ไซเบอ์" => "ไซเบอร์",
    "ความู้" => "ความรู้",
    "ิทศการ" => "นิทรรศการณ์",
    "ด าเนิน" => "ดำเนิน",
    "ประจ า" => "ประจำ",
    "จ าแนก" => "จำแนก",
    "รา ชการ" => "ราชการ",
    "ส ่ง" => "ส่ง",
    "ทรัพ ยากรน ้า" => "ทรัพยากรน้ำ",
    "ังคม" => "สังคม"
  }

  MULFORMED_NAME_REGEX = /กะทวง|ปะชาัมั์|ำาัก|สานัก|ส านัก|ส  านัก|งา|กม|ายก|ัฐมตี|กมกา|้า|าชกา|ลเือ|คอง|ู้|บิโภค|ปะมาณ|ับ|เคลื่อ|กา|ปฏิูป|ปะเทศ|ยุทศาต์|้าง|ามัคคี|ปองดอง|่าวกอง|ึง|กฤษีกา|ัฒา|ะบบ|เลาิกา|กองทั|าบั|เทคโโลยี|กั|่งเิม|ลงทุ|ทัยาก|ำ�า|ภา|เศษฐกิจ|ศูย์|ักษา|ลปะโยช์|อง|าช|ภณ์|มั่|เือ|ค์|บิหา|ภายใ|จัก|อำาวย|ิงคค|ัฐบาล|ิงคค|มหาช|ปะชุม|ุภา|วิชาชี|บิการ|าคา|ที่ดิ|ไซเบอ์|ความู้|ิทศการ|ด าเนิน|ประจ า|จ าแนก|รา ชการ|ส ่ง|ทรัพ ยากรน ้า|ังคม/

  CSV_HEADERS = %w[ITEM_ID REF_DOC REF_PAGE_NO MINISTRY BUDGETARY_UNIT CROSS_FUNC? BUDGET_PLAN OUTPUT PROJECT CATEGORY_LV1 CATEGORY_LV2 CATEGORY_LV3 CATEGORY_LV4 CATEGORY_LV5 CATEGORY_LV6 ITEM_DESCRIPTION FISCAL_YEAR AMOUNT OBLIGED?]

  # Parse REF_DOC from cover page of the report
  # Params:
  # +cover_file_name+:: a path to the html file of the cover page in relative to parser.rb (e.g. '../budget-html/8-pm-office-cover.html')
  def ref_doc(cover_file_path, is_cover: true)
    raw_html_dir = File.join(File.dirname(__FILE__), cover_file_path)    
    
    doc = load_file(raw_html_dir)

    page = cover_page_node(doc, is_cover: is_cover)

    if page.text == nil
      puts cover_file_path
      puts page
      return
    end
  
    chabub_th, fiscal_year_th, lem_th = page.text.strip.scan(TH_NUM_REGEX)

    fiscal_year_be = fiscal_year_th.split("").map { |th_num| th_num_to_arabic(th_num) }.join
    chabub = chabub_th.split("").map { |th_num| th_num_to_arabic(th_num) }.join
    lem = lem_th.split("").map { |th_num| th_num_to_arabic(th_num) }.join
    
    fiscal_year = be_to_ad(fiscal_year_be.to_i)

    "#{fiscal_year}.#{chabub}.#{lem}"
  end

  private def construct_ref_doc(cover_page)
    chabub_th, fiscal_year_th, lem_th = cover_page.text.strip.scan(TH_NUM_REGEX)

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

  private def cover_page_node(doc, is_cover: true)
    return doc.at('div:contains("เอกสารงบประมาณ")') if is_cover
    doc.at('body').at_css('[data-page-no=3]').at('div:contains("เอกสารงบประมาณ")')
  end

  private def cleanup_thai_text(text)
    text.gsub(MULFORMED_NAME_REGEX, MULFORMED_MAP).gsub(/\s+/, ' ')
  end

  def parse(filename)
    puts 'parsing data...'

    raw_html_dir = File.join(File.dirname(__FILE__), filename)
    filename_without_extension = filename.split('.').first
    output_dir = File.join(File.dirname(__FILE__), 'csv', "#{filename_without_extension}.csv")

    # parse html into Ruby obj
    doc = load_file(raw_html_dir)

    toc_start = doc.at('body').at('#page-container').at('div:contains("าบัญ")')
    tocs = find_all_pages(toc_start, -> (p) { p.text.match(/ห้า/) })
    ministry_and_budget_units = tocs
      .map { |t| t.children[0].children.map(&:text)
      .filter { |i| ministry?(i) || budget_unit?(i) } }
      .flatten
      .map do |i|
        text_with_page_no = cleanup_thai_text(i)
          .gsub('', ' ') # replace unknown char with space
          .gsub(/\s+/, ' ') # compact space bar
          .gsub(SUB_BULLET_WITH_FULL_BRACKET, '[budget_unit]')

        page_no = text_with_page_no.scan(TOC_PAGE_NO_REGEX)[0]
        text = text_with_page_no
          .gsub(page_no, "")
          .gsub(/[^\u0E00-\u0e5b|^\[budget_unit\]|^\s]/, "") # remove everything else other than TH char and [budget_unit]
          .strip
        # binding.pry if text.match?(/สำนักงานสภาพัฒนาการเศรษฐกิจและังคมแห่งชาติ/)
        [text, page_no]
      end

    # load cover page
    cover_page = cover_page_node(doc, is_cover: false)
    ref_doc = construct_ref_doc(cover_page)

    # load all pages
    pages = doc.at('body').at('#page-container').search('[data-page-no]')
    # parse all pages to string and clean up weird characters

    pdf_in_text = pages.to_a.map {|p| cleanup_thai_text(p.text) }

    curr_ministry = nil
    running_id = 1

    csv = CSV.generate(write_headers: true) do |csv|
      csv << CSV::Row.new(CSV_HEADERS, [], true)
      ministry_and_budget_units.each do |m|
        # if item is a budget unit, try parsing data else it is a ministry
        if m[0].start_with?('[budget_unit]')
          personnel_data = parse_by_budget_type(csv, pdf_in_text, BUDGET_TYPE[:personnel], curr_ministry, m[0].gsub('[budget_unit] ', ''), ref_doc, running_id, m[1])
          running_id += 1
        else
          curr_ministry = m[0]
        end
      end
    end

    binding.pry
  end

  private def parse_by_budget_type(csv, pdf_in_text, budget_type, ministry, budget_unit, ref_doc, running_id, page_range)
    budget_unit_start_page = nil
    pdf_in_text.each_with_index do |p, i|
      budget_unit_start_page = i if p.match?(/#{budget_unit}/) && p.match?(/หมายเหตุ/)
    end

    binding.pry if budget_unit_start_page.nil?
    raise StandardError.new("budget_unit_start_page not found: #{budget_unit}") if budget_unit_start_page.nil?

    # find personnel page
    personnel_start_page =  nil
    personnel_end_page = nil
    budget_plan = nil
    page_no = page_range.split(" ")[0].to_i
    pdf_in_text.drop(budget_unit_start_page).each_with_index do |p, i|
      if p.match?(/รายละเอียดงบประมาณจำแนกตามงบรายจ่าย/)
        personnel_start_page = i + budget_unit_start_page
        page_no += i
      elsif p.match?(/7\.1 /)
        budget_plan = p.split("7.1 ")[-1].gsub(NOT_TH_ALPHABET_NOT_ARABIC_NUMBER_REGEX, "") if budget_plan.nil?
      elsif p.match?(/7\.2 /)
        personnel_end_page = i + budget_unit_start_page
        break
      end
    end

    raise StandardError.new("personnel_page not found: #{budget_unit}") if personnel_start_page.nil? || personnel_end_page.nil?

    # grab all personnel pages for the budget_unit
    personnel_pages = pdf_in_text[personnel_start_page..personnel_end_page - 1]
    binding.pry
    # format each line into each item in array
    formatted_pages = personnel_pages.map { |p| p.gsub(/\s+/, ' ').gsub("บาท", "บาท\n").split("\n") }.flatten
    formatted_pages.each_with_index do |r, i|
      # add to item list of inner most bullet, else figure out which level is it.
      if inner_most_bullet?(r, formatted_pages[i + 1])
        # grep amount with regex and strip ','
        amount = r.scan(CURRENCY_REGEX)[-1].gsub(",", "")
        desc = r.gsub(NOT_TH_ALPHABET_NOT_ARABIC_NUMBER_REGEX, "").gsub("บาท", "")

        row = CSV::Row.new(CSV_HEADERS, [])
        row['ITEM_ID'] = "#{ref_doc}-#{running_id}"
        row['REF_DOC'] = ref_doc
        row['REF_PAGE_NO'] = page_no
        row['MINISTRY'] = ministry
        row['BUDGETARY_UNIT'] = budget_unit
        row['BUDGET_PLAN'] = budget_plan
        row['ITEM_DESCRIPTION'] = desc
        row['AMOUNT'] = amount
        csv << row
      end
    end
  end

  private def inner_most_bullet?(line, next_line)
    return false if next_line.nil?

    start_with_bullet?(line) && bullet_from(line).length >= bullet_from(next_line).length
  end
  # line includes 1. or (1) format
  private def start_with_bullet?(line)
    line.match?(/\d\./) || line.match?(/\(\d\)/)
  end

  private def bullet_from(line)
    return line.split(" ")[0] if line
    ""
  end

  private def find_output_plan_page(p)
    if p.next_element
      return p.next_element if p.next_element.text.match?(/7\.2 */)
      find_output_plan_page(p.next_element)
    end
  end

  private def find_all_pages(p, filter_fn)
    pages = []
    pages << p if filter_fn.call(p)
    if p.next_element
      pages = [*pages, *find_all_pages(p.next_element, filter_fn)]
    end
    pages
  end

  private def find_personnel_plan_page(p)
    return p if p.text.match(/7\.1 */)
  end

  private def ministry?(line)
    MINISTRY_PREFIX.filter { |prefix| line.start_with?(prefix) }.length > 0
  end

  private def budget_unit?(line)
    line.match?(SUB_BULLET_WITH_BRACKET)
  end

  # parse all report if there is more than one page
  private def gen_report_text(p)
    pages = []
  
    # if report continue on the next page, parse it
    if !p.next_element.text.match(SEVEN_POINT_X_REGEX)
      pages = [*gen_report_text(p.next_element)]
    end
    
    pages = [
      *p
        .children[0]
        .children
        .map(&:text)
        .filter { |i| i.length > 2 },
      *pages
    ]

    pages
  end

  private def load_file(filepath)
    File.open(filepath) do |f|
      Nokogiri::HTML(f) do |config|
        config.options = Nokogiri::XML::ParseOptions::HUGE
      end
    end
  end
end