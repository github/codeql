lgtm,codescanning
* Fixed a bug where data flow was not correctly computed through two-value index expressions (for example, `got, ok := myMap[someIndex]`). This may lead to extra results from any dataflow query when an index expression would form part of an important dataflow path.
