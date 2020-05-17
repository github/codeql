import java
import SpringHttp

class SpringRestTemplate extends Class {
  SpringRestTemplate() { hasQualifiedName("org.springframework.web.client", "RestTemplate") }
}

class SpringRestTemplateResponseEntityMethod extends Method {
  SpringRestTemplateResponseEntityMethod() {
    getDeclaringType() instanceof SpringRestTemplate and
    getReturnType() instanceof SpringResponseEntity
  }
}

class SpringWebClient extends Interface {
  SpringWebClient() { hasQualifiedName("org.springframework.web.reactive.function.client", "WebClient")}
}