lgtm,codescanning
* The query "Information exposure through a stack trace" (`java/stack-trace-exposure`) has been
  improved to report fewer false positives when `super.printStackTrace()` is called
  in an overridden method.
