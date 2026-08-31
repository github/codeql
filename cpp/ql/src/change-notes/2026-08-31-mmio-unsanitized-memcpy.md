---
category: minorAnalysis
---
* Added a new query, `cpp/mmio-unsanitized-memcpy`, to detect memory copy operations whose size argument is derived from memory-mapped I/O or DMA hardware state without sufficient bounds validation.
