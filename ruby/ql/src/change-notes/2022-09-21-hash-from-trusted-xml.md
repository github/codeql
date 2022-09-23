---
category: minorAnalysis
---
* The `rb/unsafe-deserialization` query now includes alerts for user-controlled data passed to `Hash.from_trusted_xml`, since that method can deserialize YAML embedded in the XML, which in turn can result in deserialization of arbitrary objects.