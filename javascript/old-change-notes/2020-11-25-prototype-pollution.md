lgtm,codescanning
* We've improved the detection of prototype pollution, and the queries involved have been reorganized:
  * A new query "Prototype-polluting assignment" (`js/prototype-polluting-assignment`) has been added. This query
  highlights direct modifications of an object obtained via a user-controlled property name, which may accidentally alter `Object.prototype`.
  * The query previously named "Prototype pollution" (`js/prototype-pollution`) has been renamed to "Prototype-polluting merge call".
  This highlights indirect modification of `Object.prototype` via an unsafe `merge` call taking a user-controlled object as argument.
  * The query previously named "Prototype pollution in utility function" (`js/prototype-pollution-utility`) has been renamed to "Prototype-polluting function".
  This query highlights the implementation of an unsafe `merge` function, to ensure a robust API is exposed downstream.
  * The above queries have been moved to the Security/CWE-915 folder, and assigned the following tags: CWE-078, CWE-079, CWE-094, CWE-400, and CWE-915.
  * The query "Type confusion through parameter tampering" (`js/type-confusion-through-parameter-tampering`) now highlights
  ineffective prototype pollution checks that can be bypassed by type confusion.
