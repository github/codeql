---
category: minorAnalysis
---
The modeling of `request.files` in Flask has been fixed, so we now properly handle
assignments to local variables (such as `files = request.files; files['key'].filename`).
