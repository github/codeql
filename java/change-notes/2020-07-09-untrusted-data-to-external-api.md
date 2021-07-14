lgtm,codescanning
* Two new queries, "Untrusted data passed to external API" (`java/untrusted-data-to-external-api`)
  and "Frequency counts for external APIs that are used with untrusted data"
  (`java/count-untrusted-data-external-api`), have been added. These queries
  should not be run by default as they are designed to have a low "true
  positive" rate. However, they allow you to review the use of untrusted data
  in an application to find new security vulnerabilities that are not found by
  the default security queries, as well as identifying opportunities to improve
  or add modeling of taint steps and sinks.
