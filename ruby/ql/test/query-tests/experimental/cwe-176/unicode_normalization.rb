require "erb"
include ERB::Util
require 'cgi'

class UnicodeNormalizationOKController < ActionController::Base
  def unicodeNormalize
    unicode_input = params[:unicode_input]
    normalized_nfkc = unicode_input.unicode_normalize(:nfkc)      # $MISSING:result=OK
    normalized_nfc = unicode_input.unicode_normalize(:nfc)        # $MISSING:result=OK
  end
end

class UnicodeNormalizationStrManipulationController < ActionController::Base
  def unicodeNormalize
    unicode_input = params[:unicode_input]
    unicode_input_manip = unicode_input.sub(/[aeiou]/, "*")
    normalized_nfkc = unicode_input_manip.unicode_normalize(:nfkc)  # $result=BAD
    normalized_nfc = unicode_input_manip.unicode_normalize(:nfc)    # $result=BAD
  end
end

class UnicodeNormalizationHtMLEscapeController < ActionController::Base
  def unicodeNormalize
    unicode_input = params[:unicode_input]
    unicode_html_safe = html_escape(unicode_input)
    normalized_nfkc = unicode_html_safe.unicode_normalize(:nfkc)    # $result=BAD
    normalized_nfc = unicode_html_safe.unicode_normalize(:nfc)      # $result=BAD
  end
end

class UnicodeNormalizationCGIHtMLEscapeController < ActionController::Base
  def unicodeNormalize
    unicode_input = params[:unicode_input]
    unicode_html_safe = CGI.escapeHTML(unicode_input).html_safe
    normalized_nfkc = unicode_html_safe.unicode_normalize(:nfkd)    # $result=BAD
    normalized_nfc = unicode_html_safe.unicode_normalize(:nfd)      # $result=BAD
  end
end
