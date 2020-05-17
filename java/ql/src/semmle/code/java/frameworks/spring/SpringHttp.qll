import java

class SpringHttpEntity extends Class {
  SpringHttpEntity() {
    getSourceDeclaration()
        .getErasure()
        .(RefType)
        .hasQualifiedName("org.springframework.http", "HttpEntity")
  }
}

class SpringRequestEntity extends Class {
  SpringRequestEntity() {
    getSourceDeclaration()
        .getErasure()
        .(RefType)
        .hasQualifiedName("org.springframework.http", "RequestEntity")
  }
}

class SpringResponseEntity extends Class {
  SpringResponseEntity() {
    getSourceDeclaration()
        .getErasure()
        .(RefType)
        .hasQualifiedName("org.springframework.http", "ResponseEntity")
  }
}