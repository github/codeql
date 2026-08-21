---
category: minorAnalysis
---
* Checks on actor fields read from the event payload (e.g. `github.event.pull_request.user.login`) now only count as protection for events whose payload actually populates that field. Previously, a condition such as `github.event.pull_request.user.login != 'name'` on a workflow triggered by `issues` events was treated as a protective check even though `github.event.pull_request` is not populated for `issues` events, which makes the condition vacuous. This change may result in more alerts for queries using the `ControlCheck` class.
