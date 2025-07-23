---
category: feature
---
* You can now add sinks for the query "Deserialization of user-controlled data" (`java/unsafe-deserialization`) using [data extensions](https://codeql.github.com/docs/codeql-language-guides/customizing-library-models-for-java-and-kotlin/#extensible-predicates-used-to-create-custom-models-in-java-and-kotlin) by extending `sinkModel` and using the kind "unsafe-deserialization". The existing sinks which do not require extra logic to determine if they are unsafe are now defined in this way.
