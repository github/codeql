## 0.8.13

### Major Analysis Improvements

* The `Stored` variants of some queries (`cs/stored-command-line-injection`, `cs/web/stored-xss`, `cs/stored-ldap-injection`, `cs/xml/stored-xpath-injection`, `cs/second-order-sql-injection`) have been removed. If you were using these queries, their results can be restored by enabling the `file` and `database` threat models in your threat model configuration.

### Minor Analysis Improvements

* The alert message of `cs/wrong-compareto-signature` has been changed to remove unnecessary element references.
* Data flow queries that track flow from *local* flow sources now use the current *threat model* configuration instead. This may lead to changes in the produced alerts if the threat model configuration only uses *remote* flow sources. The changed queries are `cs/code-injection`, `cs/resource-injection`, `cs/sql-injection`, and `cs/uncontrolled-format-string`.
