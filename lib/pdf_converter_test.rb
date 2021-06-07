require "minitest/autorun"
require_relative "./pdf_converter"

class TestPDFConverter < Minitest::Test
  HTML_OUTPUT_PATH = 'budget-html'
  def test_extract_only_cover
    # cleanup the folder
    delete_all_budget_html_files

    output_path = File.join(File.dirname(__FILE__), HTML_OUTPUT_PATH)
    PDFConverter.new.extract 3, 3, output_suffix: 'cover'
    assert_equal 28, Dir[File.join(output_path, '**', '*-cover.html')].count { |file| File.file?(file) } 
  end

  def test_extract_all
    # output_path = File.join(File.dirname(__FILE__), '../budget-html')
    # PDFConverter.new.extract 3, 3
    # assert_equal 28, Dir[File.join(output_path, '**', '*-full.html')].count { |file| File.file?(file) } 
    assert_equal false, true
  end

  private def delete_all_budget_html_files
    Dir.foreach(HTML_OUTPUT_PATH) do |f|
      fn = File.join(HTML_OUTPUT_PATH, f)
      File.delete(fn) if f != '.' && f != '..'
    end
  end
end