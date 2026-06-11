class Foobar
  def create_user_description(name) # $ Source[rb/html-constructed-from-input]
    "<h2>#{name}</h2>".html_safe # $ Alert[rb/html-constructed-from-input] // NOT OK - the parameter is not escaped

    # escape
    "<h2>#{ERB::Util.html_escape(name)}</h2>".html_safe # OK - the parameter is escaped
  end

  def string_like_literal name # $ Source[rb/html-constructed-from-input]
    h = <<-HTML
        <h2>#{name}</h2> # $ Alert[rb/html-constructed-from-input]
    HTML
    h.html_safe # NOT OK - the parameter is not escaped
  end

  def sprintf_use name # $ Source[rb/html-constructed-from-input]
    sprintf("<h2>%s</h2>", name).html_safe # $ Alert[rb/html-constructed-from-input] // NOT OK - the parameter is not escaped

    # escape
    sprintf("<h2>%s</h2>", ERB::Util.html_escape(name)).html_safe # OK - the parameter is escaped
  end

  def create_user_description2(name) # $ Source[rb/html-constructed-from-input]
    "<h2>#{name}</h2>".html_safe # $ Alert[rb/html-constructed-from-input] // NOT OK - the value is not necessarily HTML safe

    if name.html_safe?
      "<h2>#{name}</h2>".html_safe # OK - value is marked as being HTML safe
    end
  end
end
