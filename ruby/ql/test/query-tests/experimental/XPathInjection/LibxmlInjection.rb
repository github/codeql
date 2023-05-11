require 'libxml'

class FooController < ActionController::Base
  def libxml_handler(event:, context:)
    name = params[:user_name]

    xml = <<-XML
      <root>
        <foo>bar</foo>
        <password>THIS IS SECRET</password>
      </root>
    XML

    # Parse the XML
    doc = LibXML::XML::Document.string(xml)

    # GOOD: XPath query is not constructed from user input
    results1 = doc.find_first('//foo')

    # BAD: XPath query is constructed from user input
    results2 = doc.find_first("//#{name}")

    # GOOD: XPath query is not constructed from user input
    results3 = doc.find('//foo')

    # BAD: XPath query is constructed from user input
    results4 = doc.find("//#{name}")
  end
end

class BarController < ActionController::Base
  def libxml_safe_handler(event:, context:)
    safe_name = params[:user_name]

    xml = <<-XML
      <root>
        <foo>bar</foo>
        <password>THIS IS SECRET</password>
      </root>
    XML

    # Parse the XML
    doc = REXML::Document.new(xml)

    # GOOD: barrier guard prevents taint flow
    safe_name = if ["foo", "foo2"].include? safe_name
      safe_name
    else 
      safe_name = "foo"
    end

    # GOOD: XPath query is not constructed from unsanitized user input
    results5 = doc.find_first("//#{safe_name}")

    # GOOD: XPath query is not constructed from unsanitized user input
    results6 = doc.find("//#{safe_name}")

  end
end
