---
category: minorAnalysis
---
* Taint flow through the `ActiveSupport` extensions `Hash#reverse_merge` and `Hash:reverse_merge!`, and their aliases, is now modeled more generally, where previously it was only modeled in the context of `ActionController` parameters.
