/**
 * @name Spoofable actor check used as security control
 * @description Checking `github.actor` or `github.triggering_actor` against a bot name
 *              is spoofable and should not be used as a security control.
 * @kind problem
 * @precision high
 * @security-severity 7.0
 * @problem.severity warning
 * @id actions/spoofable-actor-check
 * @tags actions
 *       security
 *       experimental
 *       external/cwe/cwe-290
 */

import actions

/**
 * Holds if `ifNode` contains a spoofable bot actor check.
 *
 * Matches conditions like:
 *   `github.actor == 'dependabot[bot]'`
 *   `github.triggering_actor == 'renovate[bot]'`
 *   `'dependabot[bot]' == github.actor`
 *
 * These are spoofable because `github.actor` refers to the last actor
 * to act on the triggering context, not necessarily the actor that
 * caused the trigger.
 */
predicate isSpoofableBotCheck(If ifNode) {
  exists(string cond |
    cond = normalizeExpr(ifNode.getCondition()) and
    (
      // github.actor == 'something[bot]' or github.triggering_actor == 'something[bot]'
      cond.regexpMatch("(?s).*\\bgithub\\.(actor|triggering_actor)\\s*==\\s*'[^']*\\[bot\\][^']*'.*")
      or
      // reversed: 'something[bot]' == github.actor
      cond.regexpMatch("(?s).*'[^']*\\[bot\\][^']*'\\s*==\\s*github\\.(actor|triggering_actor)\\b.*")
    )
  )
}

from If ifNode, Event event
where
  isSpoofableBotCheck(ifNode) and
  event = ifNode.getATriggerEvent() and
  event.isExternallyTriggerable()
select ifNode,
  "This condition checks `github.actor` against a bot name, which is spoofable on $@ triggers. Use `github.event.pull_request.user.login` or similar non-spoofable context instead.",
  event, event.getName()
