from start.middle.end import foo #$ use=moduleImport("start").getMember("middle").getMember("end").getMember("foo")
from start.middle.end import bar #$ use=moduleImport("start").getMember("middle").getMember("end").getMember("bar")
print(foo) #$ use=moduleImport("start").getMember("middle").getMember("end").getMember("foo")
print(bar) #$ use=moduleImport("start").getMember("middle").getMember("end").getMember("bar")