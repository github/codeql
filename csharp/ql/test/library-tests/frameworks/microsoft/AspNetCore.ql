import csharp
import semmle.code.csharp.frameworks.microsoft.AspNetCore

from MicrosoftAspNetCoreMvcController c
where c.fromSource()
select c
