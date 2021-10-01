class LibXmlRubyXXE < ApplicationController

    content = params[:xml]
    LibXML::XML::Document.string(content, { options: 2 | 2048, encoding: 'utf-8' })
    LibXML::XML::Document.file(content, { options: LibXML::XML::Parser::Options::NOENT | 2048})
    LibXML::XML::Document.io(content, { options: XML::Parser::Options::NOENT | 2048 })
    LibXML::XML::Parser.string(content, { options: 2 | 2048 })
    LibXML::XML::Parser.file(content, { options: 3 | 2048 })
    LibXML::XML::Parser.io(content, { options: 2 | 2048})

    XML::Document.string(content, { options: 2 | 2048 })
    XML::Parser.string(content, { options: 2 | 2048 })

    LibXML::XML::Parser.file(content, { options: 2048 }) # OK

end
