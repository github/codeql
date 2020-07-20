import java

/** A Spring framework annotation indicating remote user input from servlets. */
class SpringServletInputAnnotation extends Annotation {
  SpringServletInputAnnotation() {
    exists(AnnotationType a |
      a = this.getType() and
      a.getPackage().getName() = "org.springframework.web.bind.annotation"
    |
      a.hasName("MatrixVariable") or
      a.hasName("RequestParam") or
      a.hasName("RequestHeader") or
      a.hasName("CookieValue") or
      a.hasName("RequestPart") or
      a.hasName("PathVariable") or
      a.hasName("RequestBody")
    )
  }
}
