import go

from Type t, string iface
where t.implements("github.com/Semmle/go/ql/test/library-tests/semmle/go/Scopes", iface)
select t.pp(), iface
