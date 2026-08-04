require "erb"
include ERB::Util
require 'cgi'

class UnicodeNormalizationOKController < ActionController::Base
  def unicodeNormalize
    unicode_input = params[:unicode_input] # $ Source
    normalized_nfkc = unicode_input.unicode_normalize(:nfkc) # $ Alert // $ MISSING:result=OK
    normalized_nfc = unicode_input.unicode_normalize(:nfc) # $ Alert // $ MISSING:result=OK
  end
end

class UnicodeNormalizationStrManipulationController < ActionController::Base
  def unicodeNormalize
    unicode_input = params[:unicode_input] # $ Source
    unicode_input_manip = unicode_input.sub(/[aeiou]/, "*") # $ Source
    normalized_nfkc = unicode_input_manip.unicode_normalize(:nfkc) # $ Alert // $ result=BAD
    normalized_nfc = unicode_input_manip.unicode_normalize(:nfc) # $ Alert // $ result=BAD
  end
end

class UnicodeNormalizationHtMLEscapeController < ActionController::Base
  def unicodeNormalize
    unicode_input = params[:unicode_input] # $ Source
    unicode_html_safe = html_escape(unicode_input) # $ Source
    normalized_nfkc = unicode_html_safe.unicode_normalize(:nfkc) # $ Alert // $ result=BAD
    normalized_nfc = unicode_html_safe.unicode_normalize(:nfc) # $ Alert // $ result=BAD
  end
end

class UnicodeNormalizationCGIHtMLEscapeController < ActionController::Base
  def unicodeNormalize
    unicode_input = params[:unicode_input] # $ Source
    unicode_html_safe = CGI.escapeHTML(unicode_input).html_safe # $ Source
    normalized_nfkc = unicode_html_safe.unicode_normalize(:nfkd) # $ Alert // $ result=BAD
    normalized_nfc = unicode_html_safe.unicode_normalize(:nfd) # $ Alert // $ result=BAD
  end
end
