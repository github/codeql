---
category: fix
---
* The `actions/artifact-poisoning/critical` and `actions/artifact-poisoning/medium` queries  now exclude artifacts downloaded to `$[{ runner.temp }}` in addition to `/tmp`.
