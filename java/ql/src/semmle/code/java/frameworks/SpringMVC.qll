import java

class SpringMvcAnnotation extends Annotation {
    SpringMvcAnnotation() {
        exists(AnnotationType a |
        a = this.getType() and
        a.getPackage().getName() = "org.springframework.web.bind.annotation"
        |
        a.hasName("GetMapping") or
        a.hasName("DeleteMapping") or
        a.hasName("PatchMapping") or
        a.hasName("PostMapping") or
        a.hasName("PutMapping") or
        a.hasName("RequestMapping")
        )
    }
}