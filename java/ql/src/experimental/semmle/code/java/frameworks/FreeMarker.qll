/* Definitions related to the FreeMarker Templating library. */
import semmle.code.java.Type

/** Models FreeMarker Template Engine's `Template` class */
class TypeFreeMarkerTemplate extends Class {
  TypeFreeMarkerTemplate() { this.hasQualifiedName("freemarker.template", "Template") }
}

/** Models `process` method of FreeMarker Template Engine's `Template` class */
class MethodFreeMarkerTemplateProcess extends Method {
  MethodFreeMarkerTemplateProcess() {
    getDeclaringType() instanceof TypeFreeMarkerTemplate and
    hasName("process")
  }
}

/** Models FreeMarker Template Engine's `StringTemplateLoader` class */
class TypeFreeMarkerStringLoader extends Class {
  TypeFreeMarkerStringLoader() { this.hasQualifiedName("freemarker.cache", "StringTemplateLoader") }
}

/** Models `process` method of FreeMarker Template Engine's `StringTemplateLoader` class */
class MethodFreeMarkerStringTemplateLoaderPutTemplate extends Method {
  MethodFreeMarkerStringTemplateLoaderPutTemplate() {
    getDeclaringType() instanceof TypeFreeMarkerStringLoader and
    hasName("putTemplate")
  }
}
