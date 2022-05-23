
def bad1(s)
  s.sub  "'", "" # NOT OK
  s.sub! "'", "" # NOT OK
end

def bad2(s)
  s.sub  /'/, "" # NOT OK
  s.sub! /'/, "" # NOT OK
end

def bad3(s1, s2, s3)
  s1.gsub  /'/, "\\'"  # NOT OK
  s1.gsub  /'/, '\\\'' # NOT OK
  s2.gsub! /'/, "\\'"  # NOT OK
  s3.gsub! /'/, '\\\'' # NOT OK
end

def bad4(s1, s2, s3)
  s1.gsub  /'/, "\\\\\\&" # NOT OK
  s1.gsub  /'/, '\\\\\&'  # NOT OK
  s2.gsub! /'/, "\\\\\\&" # NOT OK
  s3.gsub! /'/, '\\\\\&'  # NOT OK
end

def bad5(s)
  s.gsub  /['"]/, '\\\\\&' # NOT OK
  s.gsub! /['"]/, '\\\\\&' # NOT OK
end

def bad6(s)
  s.gsub  /(['"])/, '\\\\\\1' # NOT OK
  s.gsub! /(['"])/, '\\\\\\1' # NOT OK
end

def bad7(s)
  s.gsub  /('|")/, '\\\\\1' # NOT OK
  s.gsub! /('|")/, '\\\\\1' # NOT OK
end

def bad8(s)
  s.sub  '|', '' # NOT OK
  s.sub! '|', '' # NOT OK
end

def bad9(s1, s2, s3, s4)
  s1.gsub  /"/, "\\\"" # NOT OK
  s1.gsub  /"/, '\\"'  # NOT OK
  s1.gsub  '"', '\\"'  # NOT OK
  s2.gsub! /"/, "\\\"" # NOT OK
  s3.gsub! /"/, '\\"'  # NOT OK
  s4.gsub! '"', '\\"'  # NOT OK
end

def bad10(s)
  s.sub  "/", "%2F" # NOT OK
  s.sub! "/", "%2F" # NOT OK
end

def bad11(s)
  s.sub  "%25", "%" # NOT OK
  s.sub! "%25", "%" # NOT OK
end

def bad12(s)
  s.sub  %q['], %q[] # NOT OK
  s.sub! %q['], %q[] # NOT OK
end

def bad13(s)
  s.sub  "'" + "", "" # NOT OK
  s.sub! "'" + "", "" # NOT OK
end

def bad14(s)
  s.sub  "'", "" + "" # NOT OK
  s.sub! "'", "" + "" # NOT OK
end

def bad15(s)
  s.sub  "'" + "", "" + "" # NOT OK
  s.sub! "'" + "", "" + "" # NOT OK
end

def bad16(s)
  indirect = /'/
  s.sub(indirect, "")  # NOT OK
  s.sub!(indirect, "") # NOT OK
end

def good1a(s)
  until s.index("'").nil?
    s = s.sub "'", "" # OK
  end
  s
end

def good1b(s)
  until s.index("'").nil?
    s.sub! "'", "" # OK
  end
  s
end

def good2a(s)
  while s.index("'") != nil
    s = s.sub /'/, "" # OK
  end
  s
end

def good2b(s)
  while s.index("'") != nil
    s.sub! /'/, "" # OK
  end
  s
end

def good3a(s)
  s.sub  "@user", "alice" # OK
end

def good3b(s)
  s.sub! "@user", "bob" # OK
end

def good4a(s)
  s.gsub  /#/, "\\d+" # OK
end

def good4b(s)
  s.gsub! /#/, "\\d+" # OK
end

def good5a(s)
  s.gsub(/\\/, "\\\\").gsub(/['"]/, '\\\\\&') # OK
end

def good5b(s)
  s.gsub!(/\\/, "\\\\")
  s.gsub!(/['"]/, '\\\\\&') # OK
end

def good6a(s)
  s.gsub(/[\\]/, '\\\\').gsub(/[\"]/, '\\"') # OK
end

def good6b(s)
  s.gsub!(/[\\]/, '\\\\')
  s.gsub!(/[\"]/, '\\"') # OK
end

def good7a(s)
  s = s.gsub /[\\]/, '\\\\'
  s.gsub /[\"]/, '\\"' # OK
end

def good7b(s)
  s.gsub! /[\\]/, '\\\\'
  s.gsub! /[\"]/, '\\"' # OK
end

def good8a(s)
  s.gsub /\W/, '\\\\\&' # OK
end

def good8b(s)
  s.gsub! /\W/, '\\\\\&' # OK
end

def good9a(s)
  s.gsub /[^\w\s]/, '\\\\\&' # OK
end

def good9b(s)
  s.gsub! /[^\w\s]/, '\\\\\&' # OK
end

def good10a(s)
  s = s.gsub '\\', '\\\\'
  s = s.slice 1..(-1)
  s = s.gsub /\\"/, '"'
  s = s.gsub /'/, "\\'" # OK
  "'" + s + "'"
end

def good10b(s)
  s.gsub! '\\', '\\\\'
  s.slice! 1..(-1)
  s.gsub! /\\"/, '"'
  s.gsub! /'/, "\\'" # OK
  "'" + s + "'"
end

def good11a(s)
  s.gsub '#', '💩' # OK
end

def good11b(s)
  s.gsub! '#', '💩' # OK
end

def good12a(s)
  s.sub "%d", "42" # OK
end

def good12b(s)
  s.sub! "%d", "42" # OK
end

def good13a(s)
  s.sub('[', '').sub(']', '') # OK
  s.sub('(', '').sub(')', '') # OK
  s.sub('{', '').sub('}', '') # OK
  s.sub('<', '').sub('>', '') # NOT OK: too common as a bad HTML sanitizer

  s.sub('[', '\\[').sub(']', '\\]') # NOT OK
  s.sub('{', '\\{').sub('}', '\\}') # NOT OK

  s = s.sub('[', '') # OK
  s = s.sub(']', '') # OK
  s.sub(/{/, '').sub(/}/, '') # OK
  s.sub(']', '').sub('[', '') # probably OK, but still flagged
end

def good13b(s1)
  s1.sub! '[', ''
  s1.sub! ']', '' # OK
end

def good14a(s)
  s.sub('"', '').sub('"', '') # OK
  s.sub("'", "").sub("'", "") # OK
end

def good14b(s1, s2)
  s1.sub!('"', '')
  s1.sub!('"', '') # OK

  s2.sub!("'", "")
  s2.sub!("'", "") # OK
end

def newlines_a(a, b, c)
  # motivation for whitelist
  `which emacs`.sub("\n", "") # OK

  a.sub("\n", "").sub(b, c) # NOT OK
  a.sub(b, c).sub("\n", "") # NOT OK
end

def newlines_b(a, b, c)
  # motivation for whitelist
  output = `which emacs`
  output.sub!("\n", "") # OK

  d = a.dup
  d.sub!("\n", "") # NOT OK
  d.sub!(b, c)

  e = a.dup
  d.sub!(b, c)
  d.sub!("\n", "") # NOT OK
end

def bad_path_sanitizer(p1, p2)
  # attempt at path sanitization
  p1.sub! "/../", "" # NOT OK
  p2.sub  "/../", "" # NOT OK
end
