## 1.0.13

### Minor Analysis Improvements

* `csharp/diagnostic/database-quality` has been changed to exclude various property access expressions from database quality evaluation. The excluded property access expressions are expected to have no target callables even in manual or autobuilt databases.
