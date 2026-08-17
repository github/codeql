---
category: minorAnalysis
---
* Altered the logic of `ActorIfCheck` so that checks on actor fields read from the event payload (e.g. `github.event.pull_request.user.login`) only count as protection for events whose payload actually populates that field. Previously, a condition such as `github.event.pull_request.user.login != 'name'` on a workflow triggered by `issues` events was treated as a protective check even though `github.event.pull_request` is not populated for `issues` events, which makes the condition vacuous. This change will result in more results being found by the queries that rely on control checks, such as `actions/code-injection/critical`.
