---
category: majorAnalysis
---
* Fixed a false positive in `cs/web/xss` for ASP.NET Core Razor Pages/MVC views: `WriteLiteral` calls generated for tag helper attribute values (for example, `asp-for`) are HTML-attribute-encoded before being rendered, so they are no longer treated as XSS sinks.
