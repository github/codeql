class NokogiriXXE < ApplicationController

    content = params[:xml] # $ Source

    Nokogiri::XML::parse(content, nil, nil, 2) # $ Alert
    Nokogiri::XML::parse(content, nil, nil, 1 | 2) # $ Alert
    Nokogiri::XML::parse(content, nil, nil, 1 & ~Nokogiri::XML::ParseOptions::NONET) # $ Alert
    Nokogiri::XML::parse(content, nil, nil, Nokogiri::XML::ParseOptions::NOENT) # $ Alert
    Nokogiri::XML::parse(content, nil, nil, Nokogiri::XML::ParseOptions::DTDLOAD) # $ Alert
    Nokogiri::XML::parse(content, nil, nil, ~Nokogiri::XML::ParseOptions::NOENT) #OK
    Nokogiri::XML::parse(content, nil, nil, ~Nokogiri::XML::ParseOptions::NONET) # $ Alert
    Nokogiri::XML::parse(content, nil, nil, Nokogiri::XML::ParseOptions.new 2) # $ Alert
    options = Nokogiri::XML::ParseOptions.new 2048
    options.noent
    Nokogiri::XML::parse(content, nil, nil, options) # $ Alert
    Nokogiri::XML::parse(content, nil, nil, (Nokogiri::XML::ParseOptions.new 0).noent) # $ Alert

    Nokogiri::XML::parse(content) { |x| x.noent } # $ Alert
    Nokogiri::XML::parse(content) { |x| x.nononet } # $ Alert // FAIL
    Nokogiri::XML::parse(content) { |x| x.nodtdload } # OK

    Nokogiri::XML::parse(content) { |x| x.nonet.noent.nodtdload } # $ Alert

    Nokogiri::XML::parse(content, nil, nil, 2048) # OK
    Nokogiri::XML::parse(content, nil, nil, 3) # $ Alert
    Nokogiri::XML::parse(content) { |x| x.nonet.nodtdload } # OK
    Nokogiri::XML::parse(content, nil, nil, Nokogiri::XML::ParseOptions::NOENT & ~Nokogiri::XML::ParseOptions::NOBLANKS) # $ Alert
    Nokogiri::XML::parse(content, nil, nil, ~Nokogiri::XML::ParseOptions::NONET | Nokogiri::XML::ParseOptions::NOBLANKS) # $ Alert

end
