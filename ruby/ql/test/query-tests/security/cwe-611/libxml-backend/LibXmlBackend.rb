require 'xml'
require 'libxml'

# Change the ActiveSupport XML backend from REXML to LibXML
ActiveSupport::XmlMini.backend = 'LibXML'

# Allow entity replacement in LibXML parsing
LibXML::XML.class_eval do
  def self.default_substitute_entities
    XML.default_substitute_entities = true
  end
end

class LibXmlRubyXXE < ApplicationController
  def foo
    content = params[:xml]

    LibXML::XML::Parser.file(content, { options: 2048 })
    Hash.from_xml(content)
    Hash.from_trusted_xml(content)
    ActiveSupport::XmlMini.parse(content)
  end
end
