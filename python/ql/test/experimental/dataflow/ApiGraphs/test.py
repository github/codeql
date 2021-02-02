import a1 #$ use=moduleImport("a1")

x = a1.blah1 #$ use=moduleImport("a1").getMember("blah1")

import a2 as m2 #$ use=moduleImport("a2")

x2 = m2.blah2 #$ use=moduleImport("a2").getMember("blah2")

import a3.b3 as m3 #$ use=moduleImport("a3").getMember("b3")

x3 = m3.blah3 #$  use=moduleImport("a3").getMember("b3").getMember("blah3")

from a4.b4 import c4 as m4 #$ use=moduleImport("a4").getMember("b4").getMember("c4")

x4 = m4.blah4 #$ use=moduleImport("a4").getMember("b4").getMember("c4").getMember("blah4")

import a.b.c.d #$ use=moduleImport("a")

ab = a.b #$ use=moduleImport("a").getMember("b")

abc = ab.c #$ use=moduleImport("a").getMember("b").getMember("c")

abcd = abc.d #$ use=moduleImport("a").getMember("b").getMember("c").getMember("d")

x5 = abcd() #$ use=moduleImport("a").getMember("b").getMember("c").getMember("d").getReturn()

y5 = x5.method() #$ use=moduleImport("a").getMember("b").getMember("c").getMember("d").getReturn().getMember("method").getReturn()


# Relative imports. These are ignored

from .foo import bar

from ..foobar import baz