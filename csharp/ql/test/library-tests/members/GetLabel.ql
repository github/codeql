import dotnet::DotNet

from NamedElement ne
where ne.fromSource()
select ne, ne.getLabel()
