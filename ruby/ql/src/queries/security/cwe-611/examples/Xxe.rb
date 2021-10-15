require "nokogiri"

def process_data1
   xmlSrc = request.body
   doc = Nokogiri::XML.parse(xmlSrc, nil, nil, Nokogiri::XML::ParseOptions::NOENT) # BAD
end

def process_data2
   xmlSrc = request.body
   doc = Nokogiri::XML.parse(xmlSrc) { |config| config.noent } # BAD
end

