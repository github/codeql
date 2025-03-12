---
category: fix
---
* Java build-mode `none` no longer fails when a required version of Maven cannot be downloaded, such as due to a firewall. It will now attempt to use the system version of Maven if present, or otherwise proceed without detailed dependency information.
* Java build-mode `none` now correctly uses Maven dependency information on Windows platforms.
