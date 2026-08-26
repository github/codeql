import csharp
import semmle.code.csharp.frameworks.microsoft.AspNetCore

from MicrosoftAspNetCoreMvcController controller
where controller.fromSource()
select controller.getFile().getBaseName(), controller.getName()
