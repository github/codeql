---
category: minorAnalysis
---
* Added the ability to refer to subscript operations in the API graph. It is now possible to write `response().getMember("cookies").getASubscript()` to find code like `resp.cookies["key"]` (assuming `response` returns an API node for reponse objects).
