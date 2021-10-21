import java
import semmle.code.java.frameworks.spring.SpringComponentScan

/**
 * An expression used as a profile description somewhere in the program, i.e. in a Spring beans
 * XML configuration file, or as an argument to a `@Profile` annotation.
 *
 * There are two valid forms of profile expression `<profile>` and `!<profile>`, where `<profile>`
 * is a string defining a profile name. The former is active if the profile is active, and the
 * latter is active if the profile is not active.
 */
class SpringProfileExpr extends string {
  SpringProfileExpr() {
    exists(SpringBeanFile beanFile | this = beanFile.getAProfileExpr()) or
    exists(SpringComponent springComponent | this = springComponent.getAProfileExpr())
  }

  /**
   * Gets the profile described in this profile expression.
   */
  string getProfile() { result = this }

  /**
   * This profile expression is active if it can ever be evaluated to true, according to our
   * knowledge of which profiles are sometimes/never/always enabled.
   */
  predicate isActive() {
    (
      this.getProfile() instanceof AlwaysEnabledSpringProfile or
      this.getProfile() instanceof SometimesEnabledSpringProfile
    ) and
    not this.getProfile() instanceof NeverEnabledSpringProfile
  }
}

/**
 * A Spring profile expression that begins with "!", indicating a negated expression.
 */
class NotSpringProfileExpr extends SpringProfileExpr {
  NotSpringProfileExpr() { this.matches("!%") }

  /**
   * Gets the profile described in this profile expression.
   */
  override string getProfile() { result = this.substring(1, this.length()) }

  /**
   * This profile expression is active if it can ever be evaluated to true, according to our
   * knowledge of which profiles are sometimes/never/always enabled.
   */
  override predicate isActive() { not this.getProfile() instanceof AlwaysEnabledSpringProfile }
}

/**
 * A Spring profile observed somewhere in the program.
 */
class SpringProfile extends string {
  SpringProfile() {
    exists(SpringProfileExpr springProfileExpr | this = springProfileExpr.getProfile())
  }
}

/**
 * A Spring profile that is always enabled.
 */
abstract class AlwaysEnabledSpringProfile extends string {
  bindingset[this]
  AlwaysEnabledSpringProfile() { this.length() < 100 }
}

/**
 * A Spring profile that is sometimes enabled.
 *
 * Includes all `SpringProfile`s that are not specified as always enabled or never enabled.
 */
class SometimesEnabledSpringProfile extends string {
  SometimesEnabledSpringProfile() {
    this instanceof SpringProfile and
    not (
      this instanceof AlwaysEnabledSpringProfile or
      this instanceof NeverEnabledSpringProfile
    )
  }
}

/**
 * A Spring profile that is never enabled.
 */
abstract class NeverEnabledSpringProfile extends string {
  bindingset[this]
  NeverEnabledSpringProfile() { this.length() < 100 }
}
