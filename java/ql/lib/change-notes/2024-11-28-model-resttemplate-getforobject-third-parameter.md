---
category: minorAnalysis
---
* Added a sink for "Server-side request forgery" (`java/ssrf`) for the third parameter to org.springframework.web.client.RestTemplate.getForObject, when we cannot statically determine that it does not affect the host in the URL.
