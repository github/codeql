---
category: minorAnalysis
---
* The `py/url-redirection` query now reports redirects guarded only by incomplete `urllib.parse` checks, including checks that accept URLs beginning with three or more slashes. The query help no longer recommends an empty network location and scheme as sufficient validation.
