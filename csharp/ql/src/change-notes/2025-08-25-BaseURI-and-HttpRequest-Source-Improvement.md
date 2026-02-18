---
category: fix
---
* `NavigationManager.BaseUri` and certain fields in `Microsoft.AspNetCore.Http.HttpRequest` have been removed from `RemoteFlowSource`. This means query `cs/request-forgery` will have significantly less FPs.