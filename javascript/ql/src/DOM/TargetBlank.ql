/**
 * @name Potentially unsafe external link
 * @description External links that open in a new tab or window but do not specify
 *              link type 'noopener' or 'noreferrer' are a potential security risk.
 * @kind problem
 * @problem.severity warning
 * @security-severity 6.5
 * @id js/unsafe-external-link
 * @tags maintainability
 *       security
 *       external/cwe/cwe-200
 *       external/cwe/cwe-1022
 * @precision low
 */

import javascript
import semmle.javascript.frameworks.Templating
import semmle.javascript.RestrictedLocations

/**
 * Holds if the `rel` attribute may be injected by an Angular2 directive.
 */
predicate maybeInjectedByAngular() {
  DataFlow::moduleMember("@angular/core", "HostBinding")
      .getACall()
      .getArgument(0)
      .mayHaveStringValue("attr.rel")
}

/**
 * Holds if the href attribute contains a host that we cannot determine statically.
 */
predicate hasDynamicHrefHostAttributeValue(DOM::ElementDefinition elem) {
  exists(DOM::AttributeDefinition attr |
    attr = elem.getAnAttribute() and
    attr.getName().matches("%href%")
  |
    // unknown string
    not exists(attr.getStringValue())
    or
    exists(string url | url = attr.getStringValue() |
      // fixed string with templating
      url.regexpMatch(Templating::getDelimiterMatchingRegexpWithPrefix("[^?#]*")) and
      // ... that does not start with a fixed host or a relative path (common formats)
      not url.regexpMatch("(?i)((https?:)?//)?[-a-z0-9.]*/.*") and
      // .. that is not a call to `url_for` in a Flask / nunjucks application
      not url.regexpMatch("\\{\\{\\s*url(_for)?\\(.+\\).*") and
      // .. that is not a call to `url` in a Django application
      not url.regexpMatch("\\{%\\s*url.*")
    )
  )
}

from DOM::ElementDefinition e
where
  // `e` is a link that opens in a new browsing context (that is, it has `target="_blank"`)
  e.getName() = "a" and
  // and the host in the href is not hard-coded
  hasDynamicHrefHostAttributeValue(e) and
  // disable for Angular applications that dynamically inject the 'rel' attribute
  not maybeInjectedByAngular() and
  e.getAttributeByName("target").getStringValue() = "_blank" and
  // there is no `rel` attribute specifying link type `noopener`/`noreferrer`;
  // `rel` attributes with non-constant value are handled conservatively
  forall(DOM::AttributeDefinition relAttr | relAttr = e.getAttributeByName("rel") |
    exists(string rel | rel = relAttr.getStringValue() |
      not exists(string linkType | linkType = rel.splitAt(" ") |
        linkType = "noopener" or
        linkType = "noreferrer"
      )
    )
  ) and
  // exclude elements with spread attributes or dynamically computed attribute names
  not exists(DOM::AttributeDefinition attr | attr = e.getAnAttribute() | not exists(attr.getName()))
select e.(FirstLineOf), "External links without noopener/noreferrer are a potential security risk."
