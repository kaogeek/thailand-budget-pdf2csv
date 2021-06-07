require "minitest/autorun"
require_relative "./pdf_converter"

class TestPDFConverter < Minitest::Test
  HTML_OUTPUT_PATH = 'budget-html'
  def test_extract_only_cover
    # cleanup the folder
    delete_all_budget_html_cover_files

    PDFConverter.new.extract 3, 3, output_suffix: 'cover'

    output_path = File.join(File.dirname(__FILE__), HTML_OUTPUT_PATH)
    assert_equal 28, Dir[File.join(output_path, '**', '*-cover.html')].count { |file| File.file?(file) } 
  end

  def test_extract_all
    PDFConverter.new.extract_all(output_suffix: 'full')
    
    output_path = File.join(File.dirname(__FILE__), HTML_OUTPUT_PATH)
    assert_equal 28, Dir[File.join(output_path, '**', '*-full.html')].count { |file| File.file?(file) }
  end

  private def delete_all_budget_html_cover_files
    Dir.glob(File.join(HTML_OUTPUT_PATH, '**', '*-cover.html')).each do |f|
      File.delete(f) if f != '.' && f != '..'
    end
  end
end