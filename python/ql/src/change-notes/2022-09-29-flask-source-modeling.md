---
category: fix
---
* Fixed how `flask.request` is modeled as a RemoteFlowSource, such that we show fewer duplicated alert messages for Code Scanning alerts. The import, such as `from flask import request`, will now be shown as the first step in a path explanation.
