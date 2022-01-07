lgtm,codescanning
* A new class `DataFlow::MethodCallNode` extends `DataFlow::CallCfgNode` with convenient methods for
  accessing the receiver and method name of a method call.
* The `LocalSourceNode` class now has a `getAMethodCall` method, with which one can easily access
  method calls with the given node as a receiver.
