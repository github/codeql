---
category: majorAnalysis
---
* In the intermediate representation, handling of control flow after non-returning calls has been improved. This should remove false positives in queries that use the intermedite representation or libraries based on it, including the new data flow library.