---
category: minorAnalysis
---
* URL redirection sanitizers based on `urllib.parse.urlparse` and `urllib.parse.urlsplit` now require checks of the scheme, leading slashes, and browser-ignored characters when the network location may be empty. Membership allowlists must resolve locally to collection literals, and arbitrary attributes are no longer assumed to exclude an empty network location.
