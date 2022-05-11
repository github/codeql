def filter_script_tags(html)
  old_html = ""
  while (html != old_html)
    old_html = html
    html = html.gsub(/<script[^>]*>.*<\/script>/m, "")
  end
  html
end
