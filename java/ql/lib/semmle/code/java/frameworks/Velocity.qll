/** Definitions related to the Apache Velocity Templating library. */

import java

/** The `org.apache.velocity.context.AbstractContext` class of the Velocity Templating Engine. */
class TypeVelocityAbstractContext extends Class {
  TypeVelocityAbstractContext() {
    this.hasQualifiedName("org.apache.velocity.context", "AbstractContext")
  }
}

/** The `org.apache.velocity.runtime.RuntimeServices` class of the Velocity Templating Engine. */
class TypeVelocityRuntimeRuntimeServices extends Class {
  TypeVelocityRuntimeRuntimeServices() {
    this.hasQualifiedName("org.apache.velocity.runtime", "RuntimeServices")
  }
}

/** The `org.apache.velocity.Template` class of the Velocity Templating Engine. */
class TypeVelocityTemplate extends Class {
  TypeVelocityTemplate() { this.hasQualifiedName("org.apache.velocity", "Template") }
}

/** The `org.apache.velocity.runtime.RuntimeSingleton` classTemplating Engine. */
class TypeVelocityRuntimeRuntimeSingleton extends Class {
  TypeVelocityRuntimeRuntimeSingleton() {
    this.hasQualifiedName("org.apache.velocity.runtime", "RuntimeSingleton")
  }
}

/** The `org.apache.velocity.VelocityEngine` class of the Velocity Templating Engine. */
class TypeVelocityVelocityEngine extends Class {
  TypeVelocityVelocityEngine() { this.hasQualifiedName("org.apache.velocity", "VelocityEngine") }
}

/** The `org.apache.velocity.app.VelocityEngine` class of the Velocity Templating Engine. */
class TypeVelocityAppVelocityEngine extends RefType {
  TypeVelocityAppVelocityEngine() {
    this.hasQualifiedName("org.apache.velocity.app", "VelocityEngine")
  }
}

/** The `org.apache.velocity.app.Velocity` class of the Velocity Templating Engine. */
class TypeVelocityAppVelocity extends RefType {
  TypeVelocityAppVelocity() { this.hasQualifiedName("org.apache.velocity.app", "Velocity") }
}

/**
 * The `org.apache.velocity.runtime.resource.util.StringResourceRepository` interface
 * of the Velocity Templating Engine.
 */
class TypeVelocityStringResourceRepo extends RefType {
  TypeVelocityStringResourceRepo() {
    this.hasQualifiedName("org.apache.velocity.runtime.resource.util", "StringResourceRepository")
  }
}

/** The `internalPut` and `put` methods of the Velocity Templating Engine. */
class MethodVelocityContextPut extends Method {
  MethodVelocityContextPut() {
    this.getDeclaringType().getASupertype*() instanceof TypeVelocityAbstractContext and
    this.hasName(["put", "internalPut"])
  }
}

/** The `evaluate` method of the Velocity Templating Engine. */
class MethodVelocityEvaluate extends Method {
  MethodVelocityEvaluate() {
    // static boolean evaluate(Context context, Writer out, String logTag, String instring)
    // static boolean evaluate(Context context, Writer writer, String logTag, Reader reader)
    (
      this.getDeclaringType() instanceof TypeVelocityAppVelocity or
      this.getDeclaringType() instanceof TypeVelocityAppVelocityEngine or
      this.getDeclaringType().getASupertype*() instanceof TypeVelocityRuntimeRuntimeServices
    ) and
    this.hasName("evaluate")
  }
}

/** The `mergeTemplate` method of the Velocity Templating Engine. */
class MethodVelocityMergeTemplate extends Method {
  MethodVelocityMergeTemplate() {
    // static boolean	mergeTemplate(String templateName, String encoding, Context context, Writer writer)
    (
      this.getDeclaringType() instanceof TypeVelocityAppVelocity or
      this.getDeclaringType() instanceof TypeVelocityAppVelocityEngine
    ) and
    this.hasName("mergeTemplate")
  }
}

/** The `merge` method of the Velocity Templating Engine. */
class MethodVelocityMerge extends Method {
  MethodVelocityMerge() {
    // void merge(Context context, Writer writer)
    // void merge(Context context, Writer writer, List<String> macroLibraries)
    this.getDeclaringType() instanceof TypeVelocityTemplate and
    this.hasName("merge")
  }
}

/** The `parse` method of the Velocity Templating Engine. */
class MethodVelocityParse extends Method {
  MethodVelocityParse() {
    (
      this.getDeclaringType().getASupertype*() instanceof TypeVelocityRuntimeRuntimeSingleton or
      this.getDeclaringType().getASupertype*() instanceof TypeVelocityRuntimeRuntimeServices
    ) and
    this.hasName("parse")
  }
}

/** The `putStringResource` method of the Velocity Templating Engine. */
class MethodVelocityPutStringResource extends Method {
  MethodVelocityPutStringResource() {
    this.getDeclaringType().getASupertype*() instanceof TypeVelocityStringResourceRepo and
    this.hasName("putStringResource")
  }
}
