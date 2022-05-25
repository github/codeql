lgtm,codescanning
* Added `git` as a potentially-exploitable command interpreter for the purposes of the `go/command-injection` query. Because some of its options can cause it to execute an arbitrary command, unsanitized user data can be dangerous to include in its argument list. Such cases will now be flagged as an alert.
