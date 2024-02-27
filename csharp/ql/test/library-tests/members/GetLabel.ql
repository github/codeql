import csharp

from NamedElement ne
where ne.fromSource()
select ne, ne.getLabel()
