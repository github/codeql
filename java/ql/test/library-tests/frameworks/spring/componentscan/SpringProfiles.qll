import java
import semmle.code.java.frameworks.spring.Spring

/**
 * Mark the XML configuration profile as never enabled. This should allow us to deduce that the
 * com.semmle.g.ProfileComponent is dead, because com.semmle.g is only a base package in the
 * profile-config.xml file, which is only enabled if xmlConfigurationProfile is enabled.
 */
class XMLConfigurationProfile extends NeverEnabledSpringProfile {
  XMLConfigurationProfile() { this = "xmlConfigurationProfile" }
}

/**
 * Mark the annotation profile as always enabled. This should allow us to deduce that the
 * com.semmle.e.DeadProfileComponent is dead, because the profile is "!annotationProfile", and that
 * com.semmle.e.LiveProfileComponent is live, because the profile is "annotationProfile".
 */
class AnnotationProfile extends AlwaysEnabledSpringProfile {
  AnnotationProfile() { this = "annotationProfile" }
}
