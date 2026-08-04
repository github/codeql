class LibXmlRubyXXE < ApplicationController

    content = params[:xml] # $ Source
    LibXML::XML::Document.string(content, { options: 2 | 2048, encoding: 'utf-8' }) # $ Alert
    LibXML::XML::Document.file(content, { options: LibXML::XML::Parser::Options::NOENT | 2048}) # $ Alert
    LibXML::XML::Document.io(content, { options: XML::Parser::Options::NOENT | 2048 }) # $ Alert
    LibXML::XML::Parser.string(content, { options: 2 | 2048 }) # $ Alert
    LibXML::XML::Parser.file(content, { options: 3 | 2048 }) # $ Alert
    LibXML::XML::Parser.io(content, { options: 2 | 2048}) # $ Alert

    XML::Document.string(content, { options: 2 | 2048 }) # $ Alert
    XML::Parser.string(content, { options: 2 | 2048 }) # $ Alert

    LibXML::XML::Parser.file(content, { options: 2048 }) # OK

    Hash.from_xml(content) # OK - entity substitution is disabled by default
    Hash.from_trusted_xml(content) # OK - entity substitution is disabled by default
    ActiveSupport::XmlMini.parse(content) # OK - entity substitution is disabled by default

end
