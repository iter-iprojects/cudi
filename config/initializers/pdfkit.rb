PDFKit.configure do |config|
  config.wkhtmltopdf = Rails.root.to_s + '/vendor/plugins/wkhtmltopdf'

  config.default_options = {
    :encoding=>'UTF-8',
    :page_size=>'A4',
    :margin_top=>'0.9in',
    :margin_right=>'1in',
    :margin_bottom=>'0.55in',
    :margin_left=>'1in'   
      } 
end
# :header_spacing=>'20in'



