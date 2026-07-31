---
category: minorAnalysis
---
* The route object returned by Vue Router's `useRoute()` Composition API is now recognized as a client-side remote flow source, covering its `query`, `params`, `path`, `fullPath`, and `hash` members. These members are additionally reported under the corresponding `browser-url-query`, `browser-url-path`, and `browser-url-fragment` threat models.
* Added flow models for Vue's `ref`, `shallowRef`, `toRef`, `reactive`, and `computed` Composition API helpers.
