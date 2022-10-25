m1 = Mime["text/html"] # not recognised due to MaD limitation (can't parse method name)
m2 = Mime.fetch("text/html")
m3 = Mime::Type.new("text/html")
m4 = Mime::Type.lookup("text/html")
m5 = Mime::Type.lookup_by_extension("jpeg")
m6 = Mime::Type.register("text/calendar", :ics)
m7 = Mime::Type.register_alias("application/xml", :opf, %w(opf))

s = "foo/bar"

m2.match? "foo/bar"
m3 =~ "foo/bar"
m4.match? s
m5 =~ s
