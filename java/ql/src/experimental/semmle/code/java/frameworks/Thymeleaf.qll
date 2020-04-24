/* Definitions related to the Thymeleaf Tempalting library. */
import semmle.code.java.Type

/** Models `TemplateEngine` class of Thymeleaf Templating Engine. */
class TypeThymeleafTemplateEngine extends Class {
  TypeThymeleafTemplateEngine() { hasQualifiedName("org.thymeleaf", "TemplateEngine") }
}

/** Models `IResourceResolver` class of Thymeleaf Templating Engine. */
class TypeThymeleafIResourceResolver extends Class {
  TypeThymeleafIResourceResolver() {
    hasQualifiedName("org.thymeleaf.resourceresolver", "IResourceResolver")
  }
}

/** Models `process` method of Thymeleaf Templating Engine. */
class MethodThymeleafProcess extends Method {
  MethodThymeleafProcess() {
    getDeclaringType() instanceof TypeThymeleafTemplateEngine and
    hasName("process")
  }
}

/** Models `getResourceAsStream` method of Thymeleaf Templating Engine. */
class MethodThymeleafGetResourceAsStream extends Method {
  MethodThymeleafGetResourceAsStream() {
    getDeclaringType() instanceof TypeThymeleafIResourceResolver and
    hasName("getResourceAsStream")
  }
}
