---
category: fix
---
* The "Low Rust analysis quality" query (`rust/diagnostic/database-quality`) has been tuned so that it won't trigger on databases that have extracted normally. This will remove spurious messages of "Low Rust analysis quality" on the CodeQL status page.
