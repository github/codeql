/www\.example\.com/ # BAD
/^www\.example\.com$/ # BAD: uses end-of-line anchors rather than end-of-string anchors
/\Awww\.example\.com\z/ # GOOD

/foo\.bar/ # GOOD

/https?:\/\/good\.com/ # BAD
/^https?:\/\/good\.com/ # BAD: missing end-of-string anchor
/(^https?:\/\/good1\.com)|(^https?:#good2\.com)/ # BAD: missing end-of-string anchor

/bar/ # GOOD

foo.gsub(/www\.example\.com/, "bar") # GOOD
foo.sub(/www\.example.com/, "bar") # GOOD
foo.gsub!(/www\.example\.com/, "bar") # GOOD
foo.sub!(/www\.example\.com/, "bar") # GOOD

/^a|/
/^a|b/ # BAD
/a|^b/
/^a|^b/
/^a|b|c/ # BAD
/a|^b|c/
/a|b|^c/
/^a|^b|c/

/(^a)|b/
/^a|(b)/ # BAD
/^a|(^b)/
/^(a)|(b)/ # BAD


/a|b$/ # BAD
/a$|b/
/a$|b$/
/a|b|c$/ # BAD
/a|b$|c/
/a$|b|c/
/a|b$|c$/

/a|(b$)/
/(a)|b$/ # BAD
/(a$)|b$/
/(a)|(b)$/ # BAD

/^good.com|better.com/ # BAD
/^good\.com|better\.com/ # BAD
/^good\\.com|better\\.com/ # BAD
/^good\\\.com|better\\\.com/ # BAD
/^good\\\\.com|better\\\\.com/ # BAD

/^foo|bar|baz$/ # BAD
/^foo|%/ # OK