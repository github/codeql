require 'nokogiri'
require 'rexml'
require 'libxml'

class BadNokogiriController < ActionController::Base
  def some_request_handler
    name = params["name"]
    xml = <<-XML
      <root>
        <foo>bar</foo>
        <password>THIS IS SECRET</password>
      </root>
    XML
    doc = Nokogiri::XML.parse(xml)
    name = if ["foo", "foo2"].include? name
      name
    else 
      name = "foo"
    end
    results = doc.xpath("//#{name}")
  end
end

class BadRexmlController < ActionController::Base
  def some_request_handler
    name = params["name"]
    xml = <<-XML
      <root>
        <foo>bar</foo>
        <password>THIS IS SECRET</password>
      </root>
    XML
    doc = REXML::Document.new(xml)
    name = if ["foo", "foo2"].include? name
      name
    else 
      name = "foo"
    end
    results = REXML::XPath.first(doc, "//#{name}")
  end
end

class BadLibxmlController < ActionController::Base
  def some_request_handler
    name = params["name"]
    xml = <<-XML
      <root>
        <foo>bar</foo>
        <password>THIS IS SECRET</password>
      </root>
    XML
    doc = LibXML::XML::Document.string(xml)
    name = if ["foo", "foo2"].include? name
      name
    else 
      name = "foo"
    end
    results = doc.find_first("//#{name}")
  end
end