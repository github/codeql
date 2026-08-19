---
category: breaking
---
* Checks on actor fields read from the event payload (e.g. `github.event.pull_request.user.login`) were split out of `ActorIfCheck` into a new class `EventActorIfCheck`. The `ActorIfCheck` class now only covers `github.actor` and `github.triggering_actor`.
