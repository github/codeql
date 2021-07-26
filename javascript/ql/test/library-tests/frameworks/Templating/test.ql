import javascript
import semmle.javascript.security.dataflow.Xss

query Templating::TemplateSyntax getTemplateInstantiationSyntax(Templating::TemplateInstantiaton inst) {
  result = inst.getTemplateSyntax()
}

query Templating::TemplateSyntax getLikelyTemplateSyntax(Templating::TemplateFile file) {
  result = Templating::getLikelyTemplateSyntax(file)
}

query DomBasedXss::Sink xssSink() {
  any()
}
