/**
 * Provides classes and predicates for working with annotations in the `javax` package.
 */

import java

/*
 * Annotations in the package `javax.annotation`.
 */

/**
 * A `@javax.annotation.Generated` annotation.
 */
class GeneratedAnnotation extends Annotation {
  GeneratedAnnotation() { this.getType().hasQualifiedName("javax.annotation", "Generated") }
}

/**
 * A `@javax.annotation.PostConstruct` annotation.
 */
class PostConstructAnnotation extends Annotation {
  PostConstructAnnotation() { this.getType().hasQualifiedName("javax.annotation", "PostConstruct") }
}

/**
 * A `@javax.annotation.PreDestroy` annotation.
 */
class PreDestroyAnnotation extends Annotation {
  PreDestroyAnnotation() { this.getType().hasQualifiedName("javax.annotation", "PreDestroy") }
}

/**
 * A `@javax.annotation.Resource` annotation.
 */
class ResourceAnnotation extends Annotation {
  ResourceAnnotation() { this.getType().hasQualifiedName("javax.annotation", "Resource") }
}

/**
 * A `@javax.annotation.Resources` annotation.
 */
class ResourcesAnnotation extends Annotation {
  ResourcesAnnotation() { this.getType().hasQualifiedName("javax.annotation", "Resources") }
}

/**
 * A `@javax.annotation.ManagedBean` annotation.
 */
class JavaxManagedBeanAnnotation extends Annotation {
  JavaxManagedBeanAnnotation() {
    this.getType().hasQualifiedName("javax.annotation", "ManagedBean")
  }
}

/*
 * Annotations in the package `javax.annotation.security`.
 */

/**
 * A `@javax.annotation.security.DeclareRoles` annotation.
 */
class DeclareRolesAnnotation extends Annotation {
  DeclareRolesAnnotation() {
    this.getType().hasQualifiedName("javax.annotation.security", "DeclareRoles")
  }
}

/**
 * A `@javax.annotation.security.DenyAll` annotation.
 */
class DenyAllAnnotation extends Annotation {
  DenyAllAnnotation() { this.getType().hasQualifiedName("javax.annotation.security", "DenyAll") }
}

/**
 * A `@javax.annotation.security.PermitAll` annotation.
 */
class PermitAllAnnotation extends Annotation {
  PermitAllAnnotation() {
    this.getType().hasQualifiedName("javax.annotation.security", "PermitAll")
  }
}

/**
 * A `@javax.annotation.security.RolesAllowed` annotation.
 */
class RolesAllowedAnnotation extends Annotation {
  RolesAllowedAnnotation() {
    this.getType().hasQualifiedName("javax.annotation.security", "RolesAllowed")
  }
}

/**
 * A `@javax.annotation.security.RunAs` annotation.
 */
class RunAsAnnotation extends Annotation {
  RunAsAnnotation() { this.getType().hasQualifiedName("javax.annotation.security", "RunAs") }
}

/*
 * Annotations in the package `javax.interceptor`.
 */

/**
 * A `@javax.interceptor.AroundInvoke` annotation.
 */
class AroundInvokeAnnotation extends Annotation {
  AroundInvokeAnnotation() { this.getType().hasQualifiedName("javax.interceptor", "AroundInvoke") }
}

/**
 * A `@javax.interceptor.ExcludeClassInterceptors` annotation.
 */
class ExcludeClassInterceptorsAnnotation extends Annotation {
  ExcludeClassInterceptorsAnnotation() {
    this.getType().hasQualifiedName("javax.interceptor", "ExcludeClassInterceptors")
  }
}

/**
 * A `@javax.interceptor.ExcludeDefaultInterceptors` annotation.
 */
class ExcludeDefaultInterceptorsAnnotation extends Annotation {
  ExcludeDefaultInterceptorsAnnotation() {
    this.getType().hasQualifiedName("javax.interceptor", "ExcludeDefaultInterceptors")
  }
}

/**
 * A `@javax.interceptor.Interceptors` annotation.
 */
class InterceptorsAnnotation extends Annotation {
  InterceptorsAnnotation() { this.getType().hasQualifiedName("javax.interceptor", "Interceptors") }
}

/*
 * Annotations in the package `javax.jws`.
 */

/**
 * A `@javax.jws.WebService` annotation.
 */
class WebServiceAnnotation extends Annotation {
  WebServiceAnnotation() { this.getType().hasQualifiedName("javax.jws", "WebService") }
}

/*
 * Annotations in the package `javax.xml.ws`.
 */

/**
 * A `@javax.xml.ws.WebServiceRef` annotation.
 */
class WebServiceRefAnnotation extends Annotation {
  WebServiceRefAnnotation() { this.getType().hasQualifiedName("javax.xml.ws", "WebServiceRef") }
}
