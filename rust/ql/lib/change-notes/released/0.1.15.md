## 0.1.15

### Major Analysis Improvements

* Path resolution has been removed from the Rust extractor. For the majority of purposes CodeQL computed paths have been in use for several previous releases, this completes the transition. Extraction is now faster and more reliable.

### Minor Analysis Improvements

* Attribute macros are now taken into account when identifying macro-expanded code. This affects the queries `rust/unused-variable` and `rust/unused-value`, which exclude results in macro-expanded code.
* Improved modelling of the `std::fs`, `async_std::fs` and `tokio::fs` libraries. This may cause more alerts to be found by Rust injection queries, particularly `rust/path-injection`.
