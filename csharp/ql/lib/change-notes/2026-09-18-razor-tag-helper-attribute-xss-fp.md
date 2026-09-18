---
category: majorAnalysis
---
* The `cs/web/xss` query no longer flags `WriteLiteral` calls that the Razor source generator emits for the value of an HTML attribute on an element that also has a tag helper (for example, an attribute populated via `asp-for`). Such values are captured into a string buffer by matching `BeginWriteTagHelperAttribute`/`EndWriteTagHelperAttribute` calls and are HTML-attribute-encoded before being rendered, so they are not a real cross-site scripting sink. This fixes a false positive that could previously be reported for any tainted value bound to an HTML attribute on a tag-helper-enabled element.
