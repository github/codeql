---
category: minorAnalysis
---
* URL redirection sanitizers based on `urllib.parse.urlparse` and `urllib.parse.urlsplit` now require checks of the scheme, leading slashes, and browser-ignored characters when the network location may be empty. Host allowlists must resolve locally to known values, and collection allowlists are trusted only when immutable or used directly as literals. Hostname attributes are trusted only when all possible receivers originate from `urlparse` or `urlsplit` calls on constant URLs.
