s = "﹤xss>"
puts s.delete("<").unicode_normalize(:nfkc).include?("<")
