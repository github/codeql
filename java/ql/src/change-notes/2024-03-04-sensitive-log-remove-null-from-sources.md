---
category: minorAnalysis
---
* To reduce the number of false positives in the query "Insertion of sensitive information into log files" (`java/sensitive-log`), variables with names that contain "null" (case-insensitively) are no longer considered sources of sensitive information.
