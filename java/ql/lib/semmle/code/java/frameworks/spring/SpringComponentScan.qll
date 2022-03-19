import java
import semmle.code.java.frameworks.spring.SpringAutowire
import semmle.code.java.frameworks.spring.SpringXMLElement
import semmle.code.java.frameworks.spring.SpringProfile
import semmle.code.xml.WebXML

/**
 * An element in a Spring configuration file that configures which packages are considered to be
 * "base" packages when performing the Spring component scan.
 */
class SpringXmlComponentScan extends SpringXmlElement {
  SpringXmlComponentScan() {
    this.getName() = "component-scan" and
    this.getNamespace().getPrefix() = "context"
  }

  string getBasePackages() { result = this.getAttributeValue("base-package") }

  /**
   * Gets a profile expression for which this `component-scan` is enabled, or nothing if it is
   * applicable to any profile.
   */
  string getAProfileExpr() { result = this.getSpringBeanFile().getAProfileExpr() }
}

/** DEPRECATED: Alias for SpringXmlComponentScan */
deprecated class SpringXMLComponentScan = SpringXmlComponentScan;

/**
 * An annotation of a class that configures which packages are considered to be "base" packages
 * when performing the Spring component scan.
 */
class SpringComponentScan extends Annotation {
  SpringComponentScan() {
    this.getType().hasQualifiedName("org.springframework.context.annotation", "ComponentScan")
  }

  /**
   * Gets the base packages represented by this component scan.
   */
  string getBasePackages() {
    // "value" and "basePackages" are synonymous, and are simple strings
    result = this.getAValue("basePackages").(StringLiteral).getValue()
    or
    result = this.getAValue("value").(StringLiteral).getValue()
    or
    exists(TypeLiteral typeLiteral |
      // Base package classes are type literals whose package should be considered a base package.
      typeLiteral = this.getAValue("basePackageClasses")
    |
      result = typeLiteral.getReferencedType().(RefType).getPackage().getName()
    )
  }
}

/**
 * A string describing a Java package that should be considered a base package for the Spring
 * component scanning process.
 */
class SpringBasePackage extends string {
  SpringBasePackage() {
    exists(string basePackages |
      // Interpret the contexts of the `web.xml` "contextConfigLocation" parameter as a base package,
      // but only if the appropriate context class is chosen.
      exists(WebXmlFile webXml |
        webXml.getContextParamValue("contextClass") =
          "org.springframework.web.context.support.AnnotationConfigWebApplicationContext"
      |
        basePackages = webXml.getContextParamValue("contextConfigLocation")
      )
      or
      exists(SpringComponent c, Annotation componentScan |
        c.hasAnnotation("org.springframework.context.annotation", "Configuration") and
        componentScan = c.getAnAnnotation() and
        basePackages = componentScan.(SpringComponentScan).getBasePackages() and
        // For a `@ComponentScan` annotation to take effect, the configuration class must already be
        // picked up by the component scan.
        c.isLive()
      )
      or
      exists(SpringXmlComponentScan xmlComponentScan |
        basePackages = xmlComponentScan.getBasePackages() and
        // The component scan profile must be active, if one is specified.
        (
          not exists(xmlComponentScan.getAProfileExpr()) or
          xmlComponentScan.getAProfileExpr().(SpringProfileExpr).isActive()
        )
      )
    |
      // Simpler than the regex alternative
      this = basePackages.splitAt(" ").splitAt(":").splitAt(",") and
      not this.length() = 0
    )
  }
}

/**
 * An annotation type that identifies Spring components.
 */
class SpringComponentAnnotation extends AnnotationType {
  SpringComponentAnnotation() {
    // Component used directly as an annotation.
    this.hasQualifiedName("org.springframework.stereotype", "Component")
    or
    // Component can be used as a meta-annotation on other annotation types.
    this.getAnAnnotation().getType() instanceof SpringComponentAnnotation
  }
}

/**
 * Holds if we observe any Spring XML files in the snapshot.
 *
 * In order for Spring XML to be "enabled", XML must have been indexed into the snapshot, and that
 * XML must contain the appropriate Spring configuration files.
 */
private predicate isSpringXmlEnabled() { exists(SpringXmlElement springXmlElement) }

/**
 * A Spring component class, identified by the presence of a particular annotation.
 */
class SpringComponent extends RefType {
  SpringComponent() {
    this.getAnAnnotation().getType() instanceof SpringComponentAnnotation and
    not this instanceof AnnotationType
  }

  /**
   * Gets a qualifier used to distinguish when this class should be autowired into other classes.
   */
  SpringQualifierDefinitionAnnotation getQualifier() { result = this.getAnAnnotation() }

  /**
   * Gets the `@Component` or equivalent annotation.
   */
  Annotation getComponentAnnotation() {
    result = this.getAnAnnotation() and
    result.getType() instanceof SpringComponentAnnotation
  }

  /**
   * Gets the bean identifier for this component.
   */
  string getBeanIdentifier() {
    if exists(this.getComponentAnnotation().getValue("value"))
    then
      // If the name has been specified in the component annotation, use that.
      result =
        this.getComponentAnnotation().getValue("value").(CompileTimeConstantExpr).getStringValue()
    else
      // Otherwise use the name of the class, with the initial letter lower cased.
      exists(string name | name = this.getName() |
        result = name.charAt(0).toLowerCase() + name.suffix(1)
      )
  }

  /**
   * Gets the qualifier value for this class, used to distinguish when to use this class for
   * resolving autowiring on other classes.
   */
  string getQualifierValue() {
    if exists(this.getQualifier())
    then
      // If given a qualifier, use the value specified.
      result = this.getQualifier().getQualifierValue()
    else
      // Otherwise, default to the bean identifier.
      result = this.getBeanIdentifier()
  }

  /**
   * Holds if this component is ever identified by a component scan.
   *
   * If we have not identified any Spring XML files, then all components are assumed to be live, as
   * we need the XML files to accurately determine the component scan.
   */
  predicate isLive() {
    // Components all have to be registered with Spring. They are usually registered by being
    // identified during a component scan, which traverses the class path looking for components in
    // particular base packages. Base packages can be defined either using the `@ComponentScan`
    // annotation, on an `@Configuration` class, or in an XML configuration file. We can therefore
    // only validate whether this class is ever picked up if XML indexing is enabled. If it's
    // enabled, then the package of this class must belong in one of the packages defined as a base
    // package.
    not isSpringXmlEnabled()
    or
    exists(SpringBasePackage sbp |
      this.getPackage().getName().prefix(sbp.length() + 1) = sbp + "." or
      this.getPackage().getName() = sbp
    ) and
    (
      not exists(this.getAProfileExpr()) or
      this.getAProfileExpr().(SpringProfileExpr).isActive()
    )
  }

  /**
   * Gets a profile expression under which this component would be live, or nothing if there is
   * no profile expression associated with this component.
   */
  string getAProfileExpr() {
    exists(Annotation profileAnnotation |
      profileAnnotation = this.getAnAnnotation() and
      profileAnnotation
          .getType()
          .hasQualifiedName("org.springframework.context.annotation", "Profile")
    |
      result = profileAnnotation.getAValue("value").(StringLiteral).getValue()
    )
  }
}
