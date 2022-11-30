class NokogiriXXE < ApplicationController

    content = params[:xml]

    Nokogiri::XML::parse(content, nil, nil, 2)
    Nokogiri::XML::parse(content, nil, nil, 1 | 2)
    Nokogiri::XML::parse(content, nil, nil, 1 & ~Nokogiri::XML::ParseOptions::NONET)
    Nokogiri::XML::parse(content, nil, nil, Nokogiri::XML::ParseOptions::NOENT)
    Nokogiri::XML::parse(content, nil, nil, Nokogiri::XML::ParseOptions::DTDLOAD)
    Nokogiri::XML::parse(content, nil, nil, ~Nokogiri::XML::ParseOptions::NOENT) #OK
    Nokogiri::XML::parse(content, nil, nil, ~Nokogiri::XML::ParseOptions::NONET)
    Nokogiri::XML::parse(content, nil, nil, Nokogiri::XML::ParseOptions.new 2)
    options = Nokogiri::XML::ParseOptions.new 2048
    options.noent
    Nokogiri::XML::parse(content, nil, nil, options)
    Nokogiri::XML::parse(content, nil, nil, (Nokogiri::XML::ParseOptions.new 0).noent)

    Nokogiri::XML::parse(content) { |x| x.noent }
    Nokogiri::XML::parse(content) { |x| x.nononet } #FAIL
    Nokogiri::XML::parse(content) { |x| x.nodtdload } # OK

    Nokogiri::XML::parse(content) { |x| x.nonet.noent.nodtdload }

    Nokogiri::XML::parse(content, nil, nil, 2048) # OK
    Nokogiri::XML::parse(content, nil, nil, 3)
    Nokogiri::XML::parse(content) { |x| x.nonet.nodtdload } # OK
    Nokogiri::XML::parse(content, nil, nil, Nokogiri::XML::ParseOptions::NOENT & ~Nokogiri::XML::ParseOptions::NOBLANKS)
    Nokogiri::XML::parse(content, nil, nil, ~Nokogiri::XML::ParseOptions::NONET | Nokogiri::XML::ParseOptions::NOBLANKS)

end
