---
category: minorAnalysis
---
* Checks on actor fields read from the event payload (e.g. `github.event.pull_request.user.login`) now only count as protection for events whose payload actually populates that field. These checks were split out of `ActorIfCheck` into a new class `EventActorIfCheck`, and `ActorIfCheck` now only covers `github.actor` and `github.triggering_actor`. Previously, a condition such as `github.event.pull_request.user.login != 'name'` on a workflow triggered by `issues` events was treated as a protective check even though `github.event.pull_request` is not populated for `issues` events, which makes the condition vacuous. This change will result in more results being found by the queries that rely on control checks, such as `actions/code-injection/critical`.
