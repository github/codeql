---
category: minorAnalysis
---
* Fixed modeling of `aiohttp.ClientSession` so we properly handle `async with` uses. This can impact results of server-side request forgery queries (`py/full-ssrf`, `py/partial-ssrf`).
