import javascript

from Module m, string name, ASTNode export
where m.exports(name, export)
select m, name, export
