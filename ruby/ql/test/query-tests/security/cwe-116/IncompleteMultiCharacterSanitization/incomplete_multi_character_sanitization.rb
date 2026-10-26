# CVE-2019-10756
def m1(content)
  content = content.gsub(/<.*cript.*\/scrip.*>/i, "") # $ hasResult=html
  content = content.gsub(/ on\w+=".*"/, "") # $ hasResult=attr
  content = content.gsub(/ on\w+=\'.*\'/, "") # $ hasResult=attr
  content
end

def m2(content)
  content = content.gsub(/<.*cript.*/i, "") # $ hasResult=html
  content = content.gsub(/.on\w+=.*".*"/, "") # $ hasResult=attr
  content = content.gsub(/.on\w+=.*\'.*\'/, "") # $ hasResult=attr

  content
end

# CVE-2020-7656
def m3(text)
  rscript = /<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/i
  text.gsub(rscript, "") # $ hasResult=html
  text
end

# CVE-2019-1010091
def m4(text)
  text.gsub(/<!--|--!?>/, "") # $ hasResult=html
end

def m5(text)
  while /<!--|--!?>/.match?(text)
    text = text.gsub(/<!--|--!?>/, "") # OK
  end

  text
end

# CVE-2019-10767
def m6(id)
  id.gsub(/\.\./, "") # OK (can not contain '..' afterwards)
end

def m7(id)
  id.gsub(/[\]\[*,'"`<>\\?\/]/, "") # OK (or is it?)
end

# CVE-2019-8903
REG_TRAVEL = /(\/)?\.\.\//
def m8(req)
  req.url = req.url.gsub(REG_TRAVEL, "") # $ hasResult=path
end

# New cases

def m9(x)
  x = x.gsub(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/, "") # $ hasResult=html

  x = x.gsub(/(\/|\s)on\w+=(\'|")?[^"]*(\'|")?/, "") # $ hasResult=attr

  x = x.gsub(/<\/script>/, "") # OK

  x = x.gsub(/<(.)?br(.)?>/, "") # OK
  x = x.gsub(/<\/?b>/, "") # OK
  x = x.gsub(/<(ul|ol)><\/(ul|ol)>/i, "") # OK
  x = x.gsub(/<li><\/li>/i, "") # OK

  x = x.gsub(/<!--(.*?)-->/m, "") # $ hasResult=html
  x = x.gsub(/\sng-[a-z-]+/, "") # $ hasResult=attr
  x = x.gsub(/\sng-[a-z-]+/, "") # $ hasResult=attr

  x = x.gsub(/(<!--\[CDATA\[|\]\]-->)/, "\n") # OK: not a sanitizer

  x = x.gsub(/<script.+desktop\-only.+<\/script>/, "") # $ SPURIOUS: hasResult=html SPURIOUS: hasResult=attr
  x = x.gsub(/<script async.+?<\/script>/, "") # OK
  x = x.gsub(/<!--[\s\S]*?-->|<\?(?:php)?[\s\S]*?\?>/i, "") # $ hasResult=html

  x = x.gsub(/\x2E\x2E\x2F\x2E\x2E\x2F/, "") # NOT OK (matches "../../") $ hasResult=path

  x = x.gsub(/<script.*>.*<\/script>/i, "") # $ hasResult=html

  x = x.gsub(/^(\.\.\/?)+/, "") # OK

  # NOT OK
  x = x.gsub(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/) do |match|
      if unknown then match else "" end
  end # $ hasResult=html

  x = x.gsub(/<\/?([a-z][a-z0-9]*)\b[^>]*>/i, "") # NOT OK [INCONSISTENCY] $ hasResult=html

  x = x.gsub(/\.\./, "") # OK
  x = x.gsub(/\.\.\//, "") # $ hasResult=path
  x = x.gsub(/\/\.\./, "") # $ hasResult=path

  x = x.gsub(/<script(.*?)>([\s\S]*?)<\/script>/i, "") # $ hasResult=html

  x = x.gsub(/<(script|del)(?=[\s>])[\w\W]*?<\/\1\s*>/i, "") # $ hasResult=html
  x = x.gsub(/\<script[\s\S]*?\>[\s\S]*?\<\/script\>/, "") # $ hasResult=html
  x = x.gsub(/<(script|style|title)[^<]+<\/(script|style|title)>/m, "") # $ hasResult=html
  x = x.gsub(/<script[^>]*>([\s\S]*?)<\/script>/i, "") # $ hasResult=html
  x = x.gsub(/<script[\s\S]*?<\/script>/i, "") # $ hasResult=html
  x = x.gsub(/ ?<!-- ?/, "") # $ hasResult=html
  x = x.gsub(/require\('\.\.\/common'\)/, "") # OK
  x = x.gsub(/\.\.\/\.\.\/lib\//, "") # OK

  # TODO: make Rubyish
  while x.include? "."
    x = x
      .gsub(/^\.\//, "")
      .gsub(/\/\.\//, "/")
      .gsub(/[^\/]*\/\.\.\//, "") # OK
  end

  x = x.gsub(/([^.\s]+\.)+/, "") # OK

  x = x.gsub(/<!\-\-DEVEL[\d\D]*?DEVEL\-\->/, "") # OK

  x = x
    .gsub(/^\.\//, "")
    .gsub(/\/\.\//, "/")
    .gsub(/[^\/]*\/\.\.\//, "") # $ hasResult=path

  x
end

def m10(content) 
	content.gsub(/<script.*\/script>/i, "") # $ hasResult=html
	content.gsub(/<(script).*\/script>/i, "") # $ hasResult=html
	content.gsub(/.+<(script).*\/script>/i, "") # $ hasResult=html
	content.gsub(/.*<(script).*\/script>/i, "") # $ hasResult=html
end

def m11(content)
  content = content.gsub(/<script[\s\S]*?<\/script>/i, "") # $ hasResult=html
  content = content.gsub(/<[a-zA-Z\/](.|\n)*?>/, '') || ' ' # $ hasResult=html
  content = content.gsub(/<(script|iframe|video)[\s\S]*?<\/(script|iframe|video)>/, '') # $ hasResult=html
  content = content.gsub(/<(script|iframe|video)(.|\s)*?\/(script|iframe|video)>/, '') # $ hasResult=html
  content = content.gsub(/<[^<]*>/, "") # OK
end