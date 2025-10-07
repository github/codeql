---
category: minorAnalysis
---
* The extraction of the location for bound generic entities (methods, accessors, indexers, properties, and events) has been optimized. Previously, location information was extracted multiple times for each bound generic. Now, only the location of the unbound generic declaration is extracted during the extraction phase, and the QL library explicitly reuses this location for all bound instances of the same generic.
