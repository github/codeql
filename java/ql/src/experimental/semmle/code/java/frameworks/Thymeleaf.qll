/** Definitions related to the Thymeleaf Templating library. */

import java

/**
 * A class implementing the `ITemplateEngine` interface of the Thymeleaf
 * Templating Engine such as the `TemplateEngine` class.
 */
class TypeThymeleafTemplateEngine extends Class {
  TypeThymeleafTemplateEngine() {
    this.hasQualifiedName("org.thymeleaf", "TemplateEngine")
    or
    exists(Type t | this.getASupertype*().extendsOrImplements(t) |
      t.hasName("org.thymeleaf.ITemplateEngine")
    )
  }
}

/** The `process` or `processThrottled` method of the Thymeleaf Templating Engine. */
class MethodThymeleafProcess extends Method {
  MethodThymeleafProcess() {
    this.getDeclaringType() instanceof TypeThymeleafTemplateEngine and
    this.hasName(["process", "processThrottled"])
  }
}
