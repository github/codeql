---
category: fix
---
* Java build-mode `none` no longer fails when a required version of Gradle cannot be downloaded using the `gradle wrapper` command, such as due to a firewall. It will now attempt to use the system version of Gradle if present, or otherwise proceed without detailed dependency information.
