---
category: deprecated
---
* The class `UntrustedFlowSource` has been deprecated. Use the new class `RemoteFlowSource` instead, which has the same functionality. This makes the Go library consistent with other language libraries. Classes named `UntrustedFlowSource` in several different modules have been deprecated, and new classes with the same functionality called `RemoteFlowSource` have been created and should be used instead. Classes named `UntrustedFlowAsSource` in several different modules have been deprecated, and the class `Source` in the same module or the class `RemoteFlowSource` should be used instead.
