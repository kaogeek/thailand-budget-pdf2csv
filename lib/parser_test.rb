require "minitest/autorun"
require_relative "./parser"

class TestParser < Minitest::Test
  def test_parse_ref_doc_returns_correct_ref_doc
    # REF_DOC format: fiscal-year.chabub.lem

    assert_equal '2022.3.1', Parser.new.ref_doc('budget-html/8-cover.html')
    assert_equal '2022.3.2', Parser.new.ref_doc('budget-html/9-cover.html')
    assert_equal '2022.3.3', Parser.new.ref_doc('budget-html/10-cover.html')
    assert_equal '2022.3.3', Parser.new.ref_doc('budget-html/11-cover.html')
    assert_equal '2022.3.3', Parser.new.ref_doc('budget-html/12-cover.html')
    assert_equal '2022.3.3', Parser.new.ref_doc('budget-html/13-cover.html')
    assert_equal '2022.3.3', Parser.new.ref_doc('budget-html/14-cover.html')
    assert_equal '2022.3.4', Parser.new.ref_doc('budget-html/15-cover.html')
    assert_equal '2022.3.5', Parser.new.ref_doc('budget-html/16-cover.html')
    assert_equal '2022.3.6', Parser.new.ref_doc('budget-html/17-cover.html')
    assert_equal '2022.3.7', Parser.new.ref_doc('budget-html/18-cover.html')
    assert_equal '2022.3.8', Parser.new.ref_doc('budget-html/19-cover.html')
    assert_equal '2022.3.9', Parser.new.ref_doc('budget-html/20-cover.html')
    assert_equal '2022.3.10', Parser.new.ref_doc('budget-html/21-cover.html')
    assert_equal '2022.3.11', Parser.new.ref_doc('budget-html/22-cover.html')
    # 3rd page is image
    # assert_equal '2022.3.12', Parser.new.ref_doc('budget-html/23-cover.html')
    assert_equal '2022.3.13', Parser.new.ref_doc('budget-html/24-cover.html')
    assert_equal '2022.3.13', Parser.new.ref_doc('budget-html/25-cover.html')
    assert_equal '2022.3.14', Parser.new.ref_doc('budget-html/26-cover.html')
    # 3rd page is image
    # assert_equal '2022.3.13', Parser.new.ref_doc('budget-html/27-cover.html')
    assert_equal '2022.3.16', Parser.new.ref_doc('budget-html/28-cover.html')
    assert_equal '2022.3.16', Parser.new.ref_doc('budget-html/29-cover.html')
    assert_equal '2022.3.16', Parser.new.ref_doc('budget-html/30-cover.html')
    assert_equal '2022.3.17', Parser.new.ref_doc('budget-html/31-cover.html')
    # 3rd page is image
    # assert_equal '2022.3.13', Parser.new.ref_doc('budget-html/32-cover.html')
    assert_equal '2022.3.18', Parser.new.ref_doc('budget-html/33-cover.html')
    assert_equal '2022.3.19', Parser.new.ref_doc('budget-html/34-cover.html')
    # 3rd page is image
    # assert_equal '2022.3.13', Parser.new.ref_doc('budget-html/35-cover.html')
  end

  def test_ref_doc_returns_correct_result_for_full_pdf
    assert_equal '2022.3.1', Parser.new.ref_doc('budget-html/8-full.html', is_cover: false)
  end

  def parse_returns_correct_csv
  end
end