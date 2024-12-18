class Foobar
  def create_user_description(name)
    "<h2>#{name}</h2>".html_safe # NOT OK - the parameter is not escaped

    # escape
    "<h2>#{ERB::Util.html_escape(name)}</h2>".html_safe # OK - the parameter is escaped
  end

  def string_like_literal name
    h = <<-HTML
        <h2>#{name}</h2>
    HTML
    h.html_safe # NOT OK - the parameter is not escaped
  end

  def sprintf_use name
    sprintf("<h2>%s</h2>", name).html_safe # NOT OK - the parameter is not escaped

    # escape
    sprintf("<h2>%s</h2>", ERB::Util.html_escape(name)).html_safe # OK - the parameter is escaped
  end

  def create_user_description2(name)
    "<h2>#{name}</h2>".html_safe # NOT OK - the value is not necessarily HTML safe

    if name.html_safe?
      "<h2>#{name}</h2>".html_safe # OK - value is marked as being HTML safe
    end
  end
end
