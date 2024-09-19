/**
 * @name Cache Poisoning via caching of untrusted files
 * @description The cache can be poisoned by untrusted code, leading to a cache poisoning attack.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @security-severity 7.5
 * @id actions/cache-poisoning/direct-cache
 * @tags actions
 *       security
 *       external/cwe/cwe-349
 */

import actions
import codeql.actions.security.ArtifactPoisoningQuery
import codeql.actions.security.UntrustedCheckoutQuery
import codeql.actions.security.CachePoisoningQuery
import codeql.actions.security.PoisonableSteps
import codeql.actions.security.ControlChecks

/**
 * Holds if the path cache_path is a subpath of the path untrusted_path.
 */
bindingset[cache_path, untrusted_path]
predicate controlledCachePath(string cache_path, string untrusted_path) {
  exists(string normalized_cache_path, string normalized_untrusted_path |
    (
      cache_path.regexpMatch("^[a-zA-Z0-9_-].*") and
      normalized_cache_path = "./" + cache_path.regexpReplaceAll("/$", "")
      or
      normalized_cache_path = cache_path.regexpReplaceAll("/$", "")
    ) and
    (
      untrusted_path.regexpMatch("^[a-zA-Z0-9_-].*") and
      normalized_untrusted_path = "./" + untrusted_path.regexpReplaceAll("/$", "")
      or
      normalized_untrusted_path = untrusted_path.regexpReplaceAll("/$", "")
    ) and
    normalized_cache_path.substring(0, normalized_untrusted_path.length()) =
      normalized_untrusted_path
  )
}

query predicate edges(Step a, Step b) { a.getNextStep() = b }

from LocalJob j, Event e, Step source, Step s, string message, string path
where
  // the job checkouts untrusted code from a pull request or downloads an untrusted artifact
  j.getAStep() = source and
  (
    source instanceof PRHeadCheckoutStep and
    message = "due to privilege checkout of untrusted code." and
    path = source.(PRHeadCheckoutStep).getPath()
    or
    source instanceof UntrustedArtifactDownloadStep and
    message = "due to downloading an untrusted artifact." and
    path = source.(UntrustedArtifactDownloadStep).getPath()
  ) and
  // the checkout/download is not controlled by an access check
  not exists(ControlCheck check |
    check.protects(source, j.getATriggerEvent(), ["untrusted-checkout", "artifact-poisoning"])
  ) and
  j.getATriggerEvent() = e and
  // job can be triggered by an external user
  e.isExternallyTriggerable() and
  (
    // the workflow runs in the context of the default branch
    runsOnDefaultBranch(e)
    or
    // the workflow's caller runs in the context of the default branch
    e.getName() = "workflow_call" and
    exists(ExternalJob caller |
      caller.getCallee() = j.getLocation().getFile().getRelativePath() and
      runsOnDefaultBranch(caller.getATriggerEvent())
    )
  ) and
  // the job writes to the cache
  // (No need to follow the checkout/download step since the cache is normally write after the job completes)
  j.getAStep() = s and
  s instanceof CacheWritingStep and
  (
    // we dont know what code can be controlled by the attacker
    path = "?"
    or
    // we dont know what files are being cached
    s.(CacheWritingStep).getPath() = "?"
    or
    // the cache writing step reads from a path the attacker can control
    not path = "?" and controlledCachePath(s.(CacheWritingStep).getPath(), path)
  ) and
  not s instanceof PoisonableStep
select s, source, s, "Potential cache poisoning in the context of the default branch " + message
