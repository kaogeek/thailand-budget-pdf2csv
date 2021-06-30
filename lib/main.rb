require 'oj'
require 'csv'
require 'pry'

filename = '/Users/tino.thamjarat/Downloads/2022-3-1.json'

MINISTRY_PREFIX = [
  "กระทรวง", "สำนัก", "กรม" "ส่วนราชการ", "หน่วยงาน", "จังหวัดและกลุ่มจังหวัด",
  "รัฐวิสาหกิจ", "องค์กรปกครองส่วนท้องถิ่น", "งบกลาง", "ทุนหมุนเวียน"
]

file = File.read(filename)
# { filename => [TextNode] }
# TextNode => { text, Coordinate }
# Coordinate => { x: int, y: int }
ref_doc, data = Oj.load(file).first

# find toc
toc_pages = []
data.each.with_index do |i, index|
  if i.size > 0 && !i[0]['text'].nil?  && i[0]['text'].match?(/หน้า/) && i[0]['text'].match?(/\d+\sถึง\s\d+/)
    toc_pages << i
  end
end

# find budget unit
budget_units = []
toc_pages.each do |i|
  budget_units = [
    *budget_units,
    *i[0]['text'].split("\n").filter { |line| line.match?(/\(\d+\)/) }
  ]
end

# find ministry
ministries = []
toc_pages.each do |i|
  ministries = [
    *ministries,
    *i[0]['text'].split("\n").filter do |line|
      MINISTRY_PREFIX.any? {|prefix| line.start_with?("#{prefix}")}
    end
  ]
end

# merge ministry and budget_unit into on array in the same order as ToC
position_for_ministries = budget_units.map.with_index { |bu, i| i if bu.start_with?('(1)') }.compact
ministries_without_central_budget = ministries.reject { |m| m == 'งบกลาง'}
ministries_and_budget_units_in_order = budget_units.dup

raise StandardError.new("invalid position for ministry in budget unit list: check parsed data with the source #{budget_units}") if ministries_without_central_budget.size != position_for_ministries.size

# extracting "งบกลาง" report
found_budget_unit_start_page = false
start_collecting_reports = false
processed_page = 0
central_budget_reports = []
reports = []

data.each.with_index do |i, index|
  # next page if not found budget yet, break otherwise to stop processing.
  if i.size == 0 # empty page
    if found_budget_unit_start_page
      # set up processed_page to not loop through processed page to improve performance
      processed_page = processed_page + index
      break
    end

    next
  end

  if !found_budget_unit_start_page && i[0]['text'].match?(/งบกลาง/) && i[0]['text'].match?(/จำแนกดังนี้/)
    found_budget_unit_start_page = true
  end

  if found_budget_unit_start_page && i.size > 0 && i[0]['text'].match?(/รายละเอียดงบประมาณ/)
    start_collecting_reports = true
  end

  if start_collecting_reports
    central_budget_reports << { ministry: "งบกลาง", budget_unit: "งบกลาง", report: i, page_no: i[0]['text'].split("\n").first.to_i }
  end
end

reports << central_budget_reports

# extracting reports excluding "งบกลาง"
offset = 0
ministries_without_central_budget.zip(position_for_ministries).each do |m, pos|
  ministries_and_budget_units_in_order.insert(pos + offset, m)
  offset += 1
end

# clean up "1 ถึง 29" kinds of format
ministries_and_budget_units_in_order.each { |mnbu| mnbu.gsub(/\d+\sถึง\s\d+/, '').strip! }

curr_ministry = nil
ministries_and_budget_units_in_order.each.with_index do |mnbu, budget_unit_index|
  # if budget_unit, set budget unit and extract data from related pages
  if mnbu.match?(/\(\d+\)\s/)
    raise StandardError.new("curr_ministry is nil") if curr_ministry.nil?

    budget_unit = mnbu.gsub(/\(\d+\)\s/, '')
    found_budget_unit_start_page = false
    start_collecting_reports = false
    reports_for_budget_unit = []

    data.drop(processed_page).each.with_index do |i, index|
      # next page if not found budget yet, break otherwise to stop processing.
      if i.size == 0 || i[0]['text'].match?(/8\.\sรายงานสถานะและแผนการใช้จ่ายเงินนอกงบประมาณ/) # empty page or include next section "8. รายงานสถานะและแผนการใช้จ่ายเงินนอกงบประมาณ"
        if found_budget_unit_start_page
          # set up processed_page to not loop through processed page to improve performance
          # binding.pry
          processed_page = processed_page + index
          break
        end

        next
      end

      if !found_budget_unit_start_page && i[0]['text'].match?(/#{budget_unit}/) && i[0]['text'].match?(/หมายเหตุ\*/) && i[0]['text'].match?(/1\.\sวิสัยทัศน์/)
        found_budget_unit_start_page = true
      end
      if found_budget_unit_start_page && i.size > 0 && i[0]['text'].match?(/รายละเอียดงบประมาณจำแนกตามงบรายจ่าย/)
        start_collecting_reports = true
      end

      if start_collecting_reports && i[0]['text'].match?(/วัตถุประสงค์/)
        start_collecting_reports = false
      end

      if start_collecting_reports
        reports_for_budget_unit << { ministry: curr_ministry, budget_unit: budget_unit, report: i, page_no: i[0]['text'].split("\n").first.to_i }
      end
    end
    reports << reports_for_budget_unit
  else
    # if ministry, set ministry
    curr_ministry = mnbu
  end
end

# dump json into a file
report_json = Oj.dump reports
File.open('2022-3-1-reports.json', 'w') do |f|
  f << report_json
end

#### parse reports to CSV
### find ref doc
# build each row
def build_row(report, ref_doc, id)
  # CROSS_FUNC? = start_with? แผนบูรณาการ
  BULLET_REGEX = /\d\.[\d\.]+|\d\./
  binding.pry
  report.drop.each do |page|
    
  end
  report.map do |page|
    {
      "ITEM_ID" => "#{ref_doc}-#{id}",
      "REF_DOC" => ref_doc,
      "REF_PAGE_NO" => page[:page_no],
      "MINISTRY" => page[:ministry],
      "BUDGETARY_UNIT" => page[:budget_unit]
    }
  end
end

CSV_HEADERS = %w[ITEM_ID REF_DOC REF_PAGE_NO MINISTRY BUDGETARY_UNIT CROSS_FUNC? BUDGET_PLAN OUTPUT PROJECT CATEGORY_LV1 CATEGORY_LV2 CATEGORY_LV3 CATEGORY_LV4 CATEGORY_LV5 CATEGORY_LV6 ITEM_DESCRIPTION FISCAL_YEAR AMOUNT OBLIGED?]

CSV.open('2022-3-1.csv', 'w', headers: true) do |csv|
  csv << CSV_HEADERS

  reports.each.with_index do |r, i|
    build_row(r, ref_doc, i).each { |page| csv << page }
  end
end
 
puts 'done'