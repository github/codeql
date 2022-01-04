---
category: newQuery
---
* Two new queries have been added for detecting Server-side request forgery (SSRF). _Full server-side request forgery_ (`py/full-ssrf`) will only alert when the URL is fully user-controlled, and _Partial server-side request forgery_ (`py/partial-ssrf`) will alert when any part of the URL is user-controlled. Only `py/full-ssrf` will be run by default.
