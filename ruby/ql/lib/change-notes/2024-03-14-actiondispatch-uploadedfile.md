---
category: minorAnalysis
---
* Modeled instances of `ActionDispatch::Http::UploadedFile` that can be obtained from element reads of `ActionController::Parameters`, with calls to `original_filename`, `content_type`, and `read` now propagating taint from their receiver. 