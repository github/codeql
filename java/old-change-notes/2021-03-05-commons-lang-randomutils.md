lgtm,codescanning
* Added models for the Apache Commons Lang `RandomUtils` class. This may lead to extra results from queries that check for proper use of random-number generators or those which check the range of possible random values that could be returned, including `java/improper-validation-of-array-index-code-specified` and `java/uncontrolled-arithmetic`.
