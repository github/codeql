import java

/*
 * javax.annotation annotations
 */

class GeneratedAnnotation extends Annotation {
  GeneratedAnnotation() { this.getType().hasQualifiedName("javax.annotation", "Generated") }
}

class PostConstructAnnotation extends Annotation {
  PostConstructAnnotation() { this.getType().hasQualifiedName("javax.annotation", "PostConstruct") }
}

class PreDestroyAnnotation extends Annotation {
  PreDestroyAnnotation() { this.getType().hasQualifiedName("javax.annotation", "PreDestroy") }
}

class ResourceAnnotation extends Annotation {
  ResourceAnnotation() { this.getType().hasQualifiedName("javax.annotation", "Resource") }
}

class ResourcesAnnotation extends Annotation {
  ResourcesAnnotation() { this.getType().hasQualifiedName("javax.annotation", "Resources") }
}

/**
 * A javax.annotation.ManagedBean annotation.
 */
class JavaxManagedBeanAnnotation extends Annotation {
  JavaxManagedBeanAnnotation() {
    this.getType().hasQualifiedName("javax.annotation", "ManagedBean")
  }
}

/*
 * javax.annotation.security annotations
 */

class DeclareRolesAnnotation extends Annotation {
  DeclareRolesAnnotation() {
    this.getType().hasQualifiedName("javax.annotation.security", "DeclareRoles")
  }
}

class DenyAllAnnotation extends Annotation {
  DenyAllAnnotation() { this.getType().hasQualifiedName("javax.annotation.security", "DenyAll") }
}

class PermitAllAnnotation extends Annotation {
  PermitAllAnnotation() {
    this.getType().hasQualifiedName("javax.annotation.security", "PermitAll")
  }
}

class RolesAllowedAnnotation extends Annotation {
  RolesAllowedAnnotation() {
    this.getType().hasQualifiedName("javax.annotation.security", "RolesAllowed")
  }
}

class RunAsAnnotation extends Annotation {
  RunAsAnnotation() { this.getType().hasQualifiedName("javax.annotation.security", "RunAs") }
}

/*
 * javax.interceptor annotations
 */

class AroundInvokeAnnotation extends Annotation {
  AroundInvokeAnnotation() { this.getType().hasQualifiedName("javax.interceptor", "AroundInvoke") }
}

class ExcludeClassInterceptorsAnnotation extends Annotation {
  ExcludeClassInterceptorsAnnotation() {
    this.getType().hasQualifiedName("javax.interceptor", "ExcludeClassInterceptors")
  }
}

class ExcludeDefaultInterceptorsAnnotation extends Annotation {
  ExcludeDefaultInterceptorsAnnotation() {
    this.getType().hasQualifiedName("javax.interceptor", "ExcludeDefaultInterceptors")
  }
}

class InterceptorsAnnotation extends Annotation {
  InterceptorsAnnotation() { this.getType().hasQualifiedName("javax.interceptor", "Interceptors") }
}

/*
 * javax.jws annotations
 */

class WebServiceAnnotation extends Annotation {
  WebServiceAnnotation() { this.getType().hasQualifiedName("javax.jws", "WebService") }
}

/*
 * javax.xml.ws annotations
 */

class WebServiceRefAnnotation extends Annotation {
  WebServiceRefAnnotation() { this.getType().hasQualifiedName("javax.xml.ws", "WebServiceRef") }
}
