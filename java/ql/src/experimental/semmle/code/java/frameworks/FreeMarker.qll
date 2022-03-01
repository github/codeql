/** Definitions related to the FreeMarker Templating library. */

import java

/** The `Template` class of the FreeMarker Template Engine */
class TypeFreeMarkerTemplate extends Class {
  TypeFreeMarkerTemplate() { this.hasQualifiedName("freemarker.template", "Template") }
}

/** The `process` method of the FreeMarker Template Engine's `Template` class */
class MethodFreeMarkerTemplateProcess extends Method {
  MethodFreeMarkerTemplateProcess() {
    this.getDeclaringType() instanceof TypeFreeMarkerTemplate and
    this.hasName("process")
  }
}

/** The `StringTemplateLoader` class of the FreeMarker Template Engine */
class TypeFreeMarkerStringLoader extends Class {
  TypeFreeMarkerStringLoader() { this.hasQualifiedName("freemarker.cache", "StringTemplateLoader") }
}

/** The `process` method of the FreeMarker Template Engine's `StringTemplateLoader` class */
class MethodFreeMarkerStringTemplateLoaderPutTemplate extends Method {
  MethodFreeMarkerStringTemplateLoaderPutTemplate() {
    this.getDeclaringType() instanceof TypeFreeMarkerStringLoader and
    this.hasName("putTemplate")
  }
}
