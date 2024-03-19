---
category: majorAnalysis
---
* The `Stored` variants of some queries (`cs/stored-command-line-injection`, `cs/web/stored-xss`, `cs/stored-ldap-injection`, `cs/xml/stored-xpath-injection`, `cs/second-order-sql-injection`) have been removed. If you were using these queries, their results can be restored by enabling the `file` and `database` threat models in your threat model configuration.

