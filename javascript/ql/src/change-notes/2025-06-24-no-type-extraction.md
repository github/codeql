---
category: majorAnalysis
---
* The TypeScript extractor no longer relies on the TypeScript compiler for extracting type information.
  Instead, the information we need from types is now derived by an algorithm written in QL.
  This results in more robust extraction with faster extraction times, in some cases significantly faster.
