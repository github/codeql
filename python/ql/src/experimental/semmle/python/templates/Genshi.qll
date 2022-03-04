/** Provides classes which model the `Genshi` package. */

import python
import semmle.python.web.HttpRequest
import experimental.semmle.python.templates.SSTISink

/** returns the ClassValue representing `Genshi.template.TextTemplate` */
deprecated ClassValue theGenshiTextTemplateClass() {
  result = Value::named("genshi.template.TextTemplate")
}

/** returns the ClassValue representing `Genshi.template.MarkupTemplate` */
deprecated ClassValue theGenshiMarkupTemplateClass() {
  result = Value::named("genshi.template.MarkupTemplate")
}

/**
 * A sink representing the `genshi.template.TextTemplate` class instantiation argument.
 *
 *  from genshi.template import TextTemplate
 *  tmpl = TextTemplate('sink')
 */
deprecated class GenshiTextTemplateSink extends SSTISink {
  override string toString() { result = "argument to genshi.template.TextTemplate()" }

  GenshiTextTemplateSink() {
    exists(CallNode call |
      call.getFunction().pointsTo(theGenshiTextTemplateClass()) and
      call.getArg(0) = this
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }
}

/**
 * A sink representing the `genshi.template.MarkupTemplate` class instantiation argument.
 *
 *  from genshi.template import MarkupTemplate
 *  tmpl = MarkupTemplate('sink')
 */
deprecated class GenshiMarkupTemplateSink extends SSTISink {
  override string toString() { result = "argument to genshi.template.MarkupTemplate()" }

  GenshiMarkupTemplateSink() {
    exists(CallNode call |
      call.getFunction().pointsTo(theGenshiMarkupTemplateClass()) and
      call.getArg(0) = this
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }
}
