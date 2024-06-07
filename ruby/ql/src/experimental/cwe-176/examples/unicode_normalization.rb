require "erb"

class UnicodeNormalizationHtMLSafeController < ActionController::Base
  def unicodeNormalize
    unicode_input = params[:unicode_input]
    unicode_html_safe = ERB::Util.html_escape(unicode_input)
    normalized_nfkc = unicode_html_safe.unicode_normalize(:nfkc) # $result=BAD
    normalized_nfc = unicode_html_safe.unicode_normalize(:nfc) # $result=BAD
  end
end
