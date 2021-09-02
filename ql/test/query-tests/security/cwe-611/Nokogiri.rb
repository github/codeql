class NokogiriXXE < ApplicationController

    content = params[:xml]

    Nokogiri::XML::parse(content, nil, nil, 2)
    Nokogiri::XML::parse(content, nil, nil, 1 | 2)
    Nokogiri::XML::parse(content, nil, nil, Nokogiri::XML::ParseOptions::NOENT)
    Nokogiri::XML::parse(content, nil, nil, Nokogiri::XML::ParseOptions.new 2)
    options = Nokogiri::XML::ParseOptions.new 0
    options.noent
    Nokogiri::XML::parse(content, nil, nil, options)
    Nokogiri::XML::parse(content, nil, nil, (Nokogiri::XML::ParseOptions.new 0).noent)

    Nokogiri::XML::parse(content) { |x| x.noent }

    Nokogiri::XML::parse(content) { |x| x.nonet.noent.dtdload }

    Nokogiri::XML::parse(content, nil, nil, 1) # OK
    Nokogiri::XML::parse(content, nil, nil, 3)
    Nokogiri::XML::parse(content) { |x| x.nonet.dtdload } # OK

end
