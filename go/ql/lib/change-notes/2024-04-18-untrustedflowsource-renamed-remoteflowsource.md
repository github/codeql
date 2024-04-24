---
category: deprecated
---
* To make Go consistent with other language libraries, the `UntrustedFlowSource` name has been deprecated throughout. Use `RemoteFlowSource` instead, which replaces it. 
* Where modules have classes named `UntrustedFlowAsSource`, these are also deprecated and the `Source` class in the same module or the `RemoteFlowSource` class should be used instead.
