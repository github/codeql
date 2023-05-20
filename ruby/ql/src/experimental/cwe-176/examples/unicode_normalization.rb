class UnicodeNormalizationHtMLSafeController < ActionController::Base
  def unicodeNormalize
    unicode_input = params[:unicode_input]
    unicode_html_safe = CGI.escapeHTML(unicode_input).html_safe
    normalized_nfkc = unicode_html_safe.unicode_normalize(:nfkc) # $result=BAD
    normalized_nfc = unicode_html_safe.unicode_normalize(:nfc) # $result=BAD
  end
end
