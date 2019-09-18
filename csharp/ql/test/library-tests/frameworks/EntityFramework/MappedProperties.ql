import csharp
import semmle.code.csharp.frameworks.EntityFramework

from EntityFramework::MappedProperty property
select property
