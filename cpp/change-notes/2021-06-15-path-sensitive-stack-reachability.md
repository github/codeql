lgtm,codescanning
* The `StackVariableReachability` library now ignores some paths that contain an infeasible combination
  of conditionals. These improvements primarily affect the queries `cpp/uninitialized-local` and
  `cpp/use-after-free`.