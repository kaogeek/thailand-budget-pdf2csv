require 'combine_pdf'

class PDFPageExtractor
  def extract
    pdf = CombinePDF.new
    page = CombinePDF.load('../budget_pdf/8.pdf').pages[295]
    pdf << page
    pdf.save "extracted.pdf"
  end
end

PDFPageExtractor.new.extract
