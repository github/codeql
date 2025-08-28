---
category: minorAnalysis
---

- The modelling of Flask requests (as sources of user-controlled data) has been improved. Rather than treating `from flask import request` as a source of remote flow, the modelling now behaves as if the first occurrence (inside a request handler) of a reference to that `request` object is a source of remote flow. This makes it much easier to understand alert messages that refer to the source of remote flow.
