---
category: minorAnalysis
---
* Added neutral models to inhibit spurious generated sink models for `Vec` and `VecDeque` methods such as `insert`, `remove` and `push_back`. This fixes some false positive results from queries such as `rust/cleartext-logging`.
