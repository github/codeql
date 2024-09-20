a = b"a" "\xf0"
b = "b" b"\xf0"
c = "c" "c"
d = b"\xff" b"\xff"
e = u"e" u"\xff"
f = u"f" b"\xff"
g = b"\xff" u"g"

print(a,b,c,d,e,f,g,h)
