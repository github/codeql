let script_tag_regex = try Regex("<script[^>]*>.*</script>")

var old_html = ""
while (html != old_html) {
  old_html = html
  html.replace(script_tag_regex, with: "")
}

...
