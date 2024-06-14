---
category: minorAnalysis
---
* We previously considered reverse DNS resolutions (IP address -> domain name) as sources of untrusted data, since compromised/malicious DNS servers could potentially return malicious responses to arbitrary requests. We have now removed this source from the default set of untrusted sources and made a new threat model kind for them, called "reverse-dns".
