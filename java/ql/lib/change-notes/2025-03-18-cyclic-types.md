---
category: fix
---
* Java extraction no longer freezes for a long time or times out when using libraries that feature expanding cyclic generic types. For example, this was known to occur when using some classes from the Blazebit Persistence library.
