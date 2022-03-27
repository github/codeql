/www.example.com/ # BAD
/^www.example.com$/ # BAD: uses end-of-line anchors rather than end-of-string anchors
/\Awww.example.com\z/ # GOOD

/foo.bar/ # GOOD

/https?:\/\/good.com/ # BAD
/^https?:\/\/good.com/ # BAD: missing end-of-string anchor
/(^https?:\/\/good1.com)|(^https?://good2.com)/ # BAD: missing end-of-string anchor

/bar/ # GOOD

foo.gsub(/www.example.com/, "bar") # GOOD
foo.sub(/www.example.com/, "bar") # GOOD
foo.gsub!(/www.example.com/, "bar") # GOOD
foo.sub!(/www.example.com/, "bar") # GOOD


