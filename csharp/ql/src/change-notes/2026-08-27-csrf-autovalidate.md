---
category: minorAnalysis
---
* The `cs/web/missing-token-validation` query now recognizes an ASP.NET Core `AutoValidateAntiforgeryTokenAttribute` registered as a global MVC filter through `AddControllersWithViews` (and friends), avoiding false-positive results for covered actions.
