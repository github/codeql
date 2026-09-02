---
category: minorAnalysis
---
* Added a new experimental query, `cpp/experimental/mmio-unsanitized-memcpy`, to detect memory copy operations whose size argument is derived from allowlisted MMIO/DMA register-read macros without sufficient bounds validation.
