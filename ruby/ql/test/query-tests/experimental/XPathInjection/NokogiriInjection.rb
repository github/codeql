require 'nokogiri'

class FooController < ActionController::Base
  def nokogiri_handler(event:, context:)
    name = params[:user_name]

    xml = <<-XML
      <root>
        <foo>bar</foo>
        <password>THIS IS SECRET</password>
      </root>
    XML

    # Parse the XML
    doc = Nokogiri::XML.parse(xml)

    # GOOD: XPath query is not constructed from user input
    results1 = doc.at('//foo')

    # BAD: XPath query is constructed from user input
    results2 = doc.at("//#{name}")

    # GOOD: XPath query is not constructed from user input
    results3 = doc.xpath('//foo')

    # BAD: XPath query is constructed from user input
    results4 = doc.xpath("//#{name}")

    # GOOD: XPath query is not constructed from user input
    results5 = doc.at_xpath('//foo')

    # BAD: XPath query is constructed from user input
    results6 = doc.at_xpath("//#{name}")

    # GOOD: XPath query is not constructed from user input
    doc.xpath('//foo').each do |element|
        puts element.text
    end

    # BAD: XPath query constructed from user input
    doc.xpath("//#{name}").each do |element|
        puts element.text
    end

    # GOOD: XPath query is not constructed from user input
    doc.search('//foo').each do |element|
        puts element.text
    end

    # BAD: XPath query constructed from user input
    doc.search("//#{name}").each do |element|
        puts element.text
    end
  end
end

class BarController < ActionController::Base
  def nokogiri_safe_handler(event:, context:)
    safe_name = params[:user_name]

    xml = <<-XML
      <root>
        <foo>bar</foo>
        <password>THIS IS SECRET</password>
      </root>
    XML

    # Parse the XML
    doc = Nokogiri::XML.parse(xml)

    # GOOD: barrier guard prevents taint flow
    safe_name = if ["foo", "foo2"].include? safe_name
      safe_name
    else 
      safe_name = "foo"
    end

    # GOOD: XPath query is not constructed from unsanitized user input
    results7 = doc.at("//#{safe_name}")

    # GOOD: XPath query is not constructed from unsanitized user input
    results8 = doc.xpath("//#{safe_name}")

    # GOOD: XPath query is not constructed from unsanitized user input
    results9 = doc.at_xpath("//#{safe_name}")

  end
end