def filterScripTags(html)
  oldHtml = "";
  while (html != oldHtml)
    oldHtml = html;
    html = html.gsub(/<script[^>]*>.*<\/script>/m, "");
  end
  return html;
end
