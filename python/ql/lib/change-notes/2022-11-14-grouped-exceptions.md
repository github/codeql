---
category: fix
---
* `except*` is now supported.
* The result of `Try.getAHandler` and `Try.getHandler(<index>)` is no longer of type `ExceptStmt`, as handlers may also be `ExceptGroupStmt`s (After Python 3.11 introduced PEP 654). Instead, it is of the new type `ExceptionHandler` of which `ExceptStmt` and `ExceptGroupStmt` are subtypes. To support selecting only one type of handler, `Try.getANormalHandler` and `Try.getAGroupHandler` have been added. Existing uses of `Try.getAHandler` for which it is important to select only normal handlers, will need to be updated to `Try.getANormalHandler`.
