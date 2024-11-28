---
category: minorAnalysis
---
* Added `Microsoft.AspNetCore.Components.NagivationManager::Uri` as a remote flow source, since this value may contain user-specified values.
* Added the following URI-parsing methods as summaries, as they may be tainted with user-specified values:
  - `System.Web.HttpUtility::ParseQueryString`
  - `Microsoft.AspNetCore.WebUtilities.QueryHelpers::ParseQueryString`
  - `Microsoft.AspNetCore.WebUtilities.QueryHelpers::ParseNullableQuery`
