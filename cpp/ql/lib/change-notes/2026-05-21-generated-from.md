---
category: feature
---
* Added a `getOriginalTemplate` predicate to `TemplateClass`, `TemplateFunction`, `TemplateVariable`, and `AliasTemplateType`, which yields the class member template the template was generated from. The predicates only have results for templates that are members of class template instantiations.
