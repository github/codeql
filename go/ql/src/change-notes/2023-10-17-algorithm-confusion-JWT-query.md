---
category: newQuery
---
* Added JWT Confusion query `go/jwt-alg-confusion`, a vulnerability where the application trusts the JWT token's header algorithm, allowing an application expecting to use asymmetric signature validation use symmetric signature, and thus bypassing JWT signature verification in cases where the public key is exposed.