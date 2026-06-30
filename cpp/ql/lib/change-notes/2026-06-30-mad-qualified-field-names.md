---
category: deprecated
---
* Models-as-data flow summaries now use fully qualified field names (for example, `MyNamespace::MyStruct::myField`) instead of unqualified field names such as `myField`. We recommend updating existing flow summaries to use fully qualified field names. Unqualified field names are still supported, but that support will be removed in a future release.