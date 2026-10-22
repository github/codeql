---
category: minorAnalysis
---
* URL redirection sanitizers based on `urllib.parse.urlparse` and `urllib.parse.urlsplit` now require checks of the scheme, leading slashes, and browser-ignored characters when the network location may be empty. Membership allowlists are trusted only when immutable or used directly as literals, and hostname attributes are treated as non-empty only when all possible receivers originate from `urlparse` or `urlsplit`.
