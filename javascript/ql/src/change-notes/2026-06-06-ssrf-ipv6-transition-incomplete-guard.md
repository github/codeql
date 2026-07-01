---
category: newQuery
---
* Added a new experimental query, `javascript/ssrf-ipv6-transition-incomplete-guard`, to detect SSRF host-validation guards that reject private IPv4 ranges but fail to unwrap IPv6-transition forms (IPv4-mapped `::ffff:`, NAT64 `64:ff9b::`, 6to4 `2002::`), allowing the guard to be bypassed by wrapping an internal IPv4 address in a transition literal.
