---
category: majorAnalysis
---
* The alert locations for data flow queries have been improved. The new locations are more precise and are based on the actual source and sink nodes. Example:
```rust
let _ = conn.query(
//      ^^^^                 old alert location
    unsafe_query.as_str(),
//  ^^^^^^^^^^^^^^^^^^^^^    new alert location
)?;
```
This means that some alerts will have their locations changed, and hence appear as new alerts (while the old alerts will disappear).