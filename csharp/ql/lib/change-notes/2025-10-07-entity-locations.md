---
category: minorAnalysis
---
* The extraction of location information for named types (classes, structs, etc.) has been optimized. Previously, location information was extracted multiple times for each type when it was declared across multiple files. Now, the extraction context is respected during the extraction phase, ensuring locations are only extracted within the appropriate context. This change should be transparent to end-users but may improve extraction performance in some cases.
