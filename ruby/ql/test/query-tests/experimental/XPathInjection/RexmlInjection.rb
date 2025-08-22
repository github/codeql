require 'rexml'

class FooController < ActionController::Base
  def rexml_handler(event:, context:)
    name = params[:user_name]

    xml = <<-XML
        <root>
            <foo>bar</foo>
            <password>THIS IS SECRET</password>
        </root>
    XML

    # Parse the XML
    doc = REXML::Document.new(xml)

    # GOOD: XPath query is not constructed from user input
    results1 = REXML::XPath.first(doc, "//foo")

    # BAD: XPath query is constructed from user input
    results2 = REXML::XPath.first(doc, "//#{name}")

    # GOOD: XPath query is not constructed from user input
    results3 = REXML::XPath.match(doc, "//foo", nil)

    # BAD: XPath query is constructed from user input
    results4 = REXML::XPath.match(doc, "//#{name}", nil)

    # GOOD: XPath query is not constructed from user input
    REXML::XPath.each(doc, "//foo") do |element|
        puts element.text
    end

    # BAD: XPath query constructed from user input
    REXML::XPath.each(doc, "//#{name}") do |element|
        puts element.text
    end
  end
end

class BarController < ActionController::Base
  def rexml_safe_handler(event:, context:)
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
    results5 = REXML::XPath.first(doc, "//#{safe_name}")

    # GOOD: XPath query is not constructed from unsanitized user input
    results6 = REXML::XPath.match(doc, "//#{safe_name}", nil)

  end
end