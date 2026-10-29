interface Invalid extends (foo.bar) {}
interface Invalid extends (foo).bar {}
interface Invalid extends foo[bar] {}
interface Invalid extends foo?.bar {}
interface Invalid extends foo!.bar {}
interface Invalid extends foo() {}
