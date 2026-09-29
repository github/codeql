---
category: majorAnalysis
---
* Fixed a false positive in `cs/web/xss` for ASP.NET Core Razor Pages/MVC views: `WriteLiteral` calls generated for tag helper attribute values (for example, `asp-for`) capture the value into an internal buffer instead of writing it directly to the response, so they are no longer treated as XSS sinks.
