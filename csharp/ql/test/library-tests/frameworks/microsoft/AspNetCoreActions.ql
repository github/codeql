import csharp
import semmle.code.csharp.frameworks.microsoft.AspNetCore

from MicrosoftAspNetCoreMvcController controller, Method action
where
  controller.fromSource() and
  action = controller.getAnActionMethod() and
  action.fromSource()
select controller, action
