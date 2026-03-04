---
category: fix
---
* Fixed an issue where the body of a partial member could be extracted twice. When both a *defining* and an *implementing* declaration exist, only the *implementing* declaration is now extracted.
