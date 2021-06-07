class PDFConverter
  IMAGE_VERSION = "0.18.8.rc1-master-20200630-Ubuntu-focal-x86_64"
  
  # Extract cover page from raw pdf to html
  # Params:
  # +start_page+:: a page to start convert.
  # +end_page+:: a page to stop convert.
  # +input_path+:: a path string for pdf input from the root dir. Default: 'budget-pdf'
  # +output_path+:: a path string to save html output from the root dir. Default: 'budget-html'
  # +output_suffix+:: a string to add as suffix on the output filename. Default: ''
  def extract(start_page, end_page, output_suffix: '', input_path: 'budget-pdf', output_path: 'lib/budget-html')
    proj_root_path, pdf_dir = gen_dirs(input_path, output_path)

    Dir.foreach(pdf_dir) do |filename|
      next if filename == '.' or filename == '..'
      filename_without_extension = filename.split('.').first
      output_filename = gen_output_filename(filename_without_extension, output_suffix)

      puts "converting #{filename} to #{output_filename}"
      
      system extract_cmd(start_page, end_page, proj_root_path, File.join(input_path, filename), File.join(output_path, output_filename))
    end

    puts 'done'
  end

  def extract_all(input_path: 'budget-pdf', output_path: 'lib/budget-html', output_suffix: '')
    proj_root_path, pdf_dir = gen_dirs(input_path, output_path)
    output_filename = gen_output_filename('8', output_suffix)
    system extract_all_cmd(proj_root_path, File.join(input_path, '8.pdf'), File.join(output_path, output_filename))
  end

  # returns fully expanded [proj_root_path, input_path, output_path]
  private def gen_dirs(input_path, output_path)
    proj_root_path = File.join(File.dirname(__FILE__), '../')
    [
      File.expand_path(proj_root_path),
      File.expand_path(File.join(proj_root_path, input_path))
    ]
  end

  private def gen_output_filename(filename, suffix)
    return "#{filename}-#{suffix}.html" if suffix != ""
    "#{filename}.html"
  end

  private def extract_cmd(start_page, end_page, proj_path, input_path, output_filename)
    "docker run -ti --rm -v #{proj_path}:/pdf pdf2htmlex/pdf2htmlex:#{IMAGE_VERSION} -f #{start_page} -l #{end_page} --tounicode 1 --optimize-text 1 --space-as-offset 0 --process-outline 0 --process-nontext 0 #{input_path} #{output_filename}"
  end

  private def extract_all_cmd(proj_path, input_path, output_filename)
    "docker run -ti --rm -v #{proj_path}:/pdf pdf2htmlex/pdf2htmlex:#{IMAGE_VERSION} --tounicode 1 --optimize-text 1 --space-as-offset 0 --process-outline 0 --process-nontext 0 #{input_path} #{output_filename}"
  end
end