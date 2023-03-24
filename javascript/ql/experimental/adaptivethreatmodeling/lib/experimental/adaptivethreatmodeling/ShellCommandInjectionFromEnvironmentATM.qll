/**
 * For internal use only.
 *
 * A taint-tracking configuration for reasoning about command-injection
 * vulnerabilities.
 * Defines shared code used by the ShellCommandInjectionFromEnvironment boosted query.
 */

private import semmle.javascript.heuristics.SyntacticHeuristics
private import semmle.javascript.security.dataflow.ShellCommandInjectionFromEnvironmentCustomizations::ShellCommandInjectionFromEnvironment as ShellCommandInjectionFromEnvironment
import AdaptiveThreatModeling

class ShellCommandInjectionFromEnvironmentAtmConfig extends AtmConfig {
  ShellCommandInjectionFromEnvironmentAtmConfig() {
    this = "ShellCommandInjectionFromEnvironmentAtmConfig"
  }

  override predicate isKnownSource(DataFlow::Node source) {
    source instanceof ShellCommandInjectionFromEnvironment::Source
  }

  override EndpointType getASinkEndpointType() {
    result instanceof ShellCommandInjectionFromEnvironmentSinkType
  }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof ShellCommandInjectionFromEnvironment::Sanitizer
  }
}
