---
category: minorAnalysis
---
* The cache-poisoning queries now honor workflow and job `cache-mode` settings, including overrides and explicit limits in reusable-workflow call chains. Jobs with `read` or `none` access are excluded, while low-trust triggers that explicitly request `write` or `write-only` access can now be reported.
* Cache-poisoning analysis now recognizes unfiltered pushes to the default branch and `pull_request` runs for merged `closed` events with write-capable cache modes.
