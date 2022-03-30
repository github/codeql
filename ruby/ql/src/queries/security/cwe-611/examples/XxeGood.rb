require "nokogiri"

def process_data1
   xmlSrc = request.body
   doc = Nokogiri::XML.parse(xmlSrc) # GOOD
end

def process_data2
   xmlSrc = request.body
   doc = Nokogiri::XML.parse(xmlSrc) { |config| config.nonoent } # GOOD
end

