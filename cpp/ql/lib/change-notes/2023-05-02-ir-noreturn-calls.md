---
category: majorAnalysis
---
* In the intermediate representation, nonreturning calls now have the `Unreached` instruction for their containing function as their control flow successor. This should remove false positives involving such calls.