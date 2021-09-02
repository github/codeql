class LibXmlRubyXXE < ApplicationController

    content = params[:xml]
    LibXML::XML::Document.string(content, { options: 2, encoding: 'utf-8' })
    LibXML::XML::Document.file(content, { options: LibXML::XML::Options::NOENT })
    LibXML::XML::Document.io(content, { options: XML::Options::NOENT })
    LibXML::XML::Parser.string(content, { options: 2 })
    LibXML::XML::Parser.file(content, { options: 3 })
    LibXML::XML::Parser.io(content, { options: 2 })

    XML::Document.string(content, { options: 2 })
    XML::Parser.string(content, { options: 2 })

    LibXML::XML::Parser.file(content, { options: 1 }) # OK

end
