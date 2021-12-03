import csharp

from Field f, int pos
where f.hasName("sbcs")
select pos, f.getInitializer().getValue().charAt(pos)
