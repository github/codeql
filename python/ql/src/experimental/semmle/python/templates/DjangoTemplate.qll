/** Provides classes which model the `DjangoTemplate` package. */

import python
import semmle.python.web.HttpRequest
import experimental.semmle.python.templates.SSTISink

deprecated ClassValue theDjangoTemplateClass() { result = Value::named("django.template.Template") }

/**
 * A sink representng `django.template.Template` class instantiation argument.
 *
 *  from django.template import Template
 *  template = Template(`sink`)
 */
deprecated class DjangoTemplateTemplateSink extends SSTISink {
  override string toString() { result = "argument to Django.template()" }

  DjangoTemplateTemplateSink() {
    exists(CallNode call |
      call.getFunction().pointsTo(theDjangoTemplateClass()) and
      call.getArg(0) = this
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }
}
// TODO (intentionally commented out QLDoc, since qlformat will delete those lines otherwise)
// /**
//  * Sinks representng the django.template.Template class instantiation.
//  *
//  *  from django.template import engines
//  *
//  *  django_engine = engines["django"]
//  *  template = django_engine.from_string(`sink`)
//  */
