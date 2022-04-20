/**
 * Provides default sources for reasoning about
 * cross-site scripting vulnerabilities through the DOM.
 */

import javascript

/**
 * Sources for cross-site scripting vulnerabilities through the DOM.
 */
module XssThroughDom {
  import Xss::XssThroughDom
  private import semmle.javascript.dataflow.InferredTypes
  private import semmle.javascript.security.dataflow.Xss::DomBasedXss as DomBasedXss

  /**
   * Gets an attribute name that could store user-controlled data.
   *
   * Attributes such as "id", "href", and "src" are often used as input to HTML.
   * However, they are either rarely controlable by a user, or already a sink for other XSS vulnerabilities.
   * Such attributes are therefore ignored.
   */
  bindingset[result]
  string unsafeAttributeName() {
    result.matches("data-%") or
    result.matches("aria-%") or
    result = ["name", "value", "title", "alt"]
  }

  /**
   * Gets a DOM property name that could store user-controlled data.
   */
  string unsafeDomPropertyName() { result = ["innerText", "textContent", "value", "name", "src"] }

  /** A read of a DOM property seen as a source for cross-site scripting vulnerabilities through the DOM. */
  abstract class DomPropertySource extends Source {
    /**
     * Gets the name of the DOM property that the source originated from.
     */
    abstract string getPropertyName();
  }

  /* Gets a jQuery method where the receiver looks like `$("<p>" + ... )`, which is benign for this query. */
  private JQuery::MethodCall benignJQueryMethod() {
    exists(DataFlow::Node prefix |
      DomBasedXss::isPrefixOfJQueryHtmlString(result
            .getReceiver()
            .(DataFlow::CallNode)
            .getAnArgument(), prefix)
    |
      prefix.getStringValue().regexpMatch("\\s*<.*")
    )
  }

  /** A source for text from the DOM from a JQuery method call. */
  class JQueryTextSource extends Source instanceof JQuery::MethodCall {
    JQueryTextSource() {
      this.getMethodName() = ["text", "val"] and
      this.getNumArgument() = 0 and
      not this = benignJQueryMethod()
    }
  }

  /**
   * A source for text from a DOM property read by jQuery.
   */
  class JQueryDOMPropertySource extends DomPropertySource instanceof JQuery::MethodCall {
    string prop;

    JQueryDOMPropertySource() {
      exists(string methodName |
        this.getMethodName() = methodName and
        this.getNumArgument() = 1 and
        forex(InferredType t | t = this.getArgument(0).analyze().getAType() | t = TTString()) and
        this.getArgument(0).mayHaveStringValue(prop)
      |
        methodName = "attr" and prop = unsafeAttributeName()
        or
        methodName = "prop" and prop = unsafeDomPropertyName()
      ) and
      not this = benignJQueryMethod()
    }

    override string getPropertyName() { result = prop }
  }

  /**
   * A source for text from the DOM from a `d3` method call.
   */
  class D3TextSource extends Source {
    D3TextSource() {
      exists(DataFlow::MethodCallNode call, string methodName |
        this = call and
        call = D3::d3Selection().getMember(methodName).getACall()
      |
        methodName = "attr" and
        call.getNumArgument() = 1 and
        call.getArgument(0).mayHaveStringValue(unsafeAttributeName())
        or
        methodName = "property" and
        call.getNumArgument() = 1 and
        call.getArgument(0).mayHaveStringValue(unsafeDomPropertyName())
        or
        methodName = "text" and
        call.getNumArgument() = 0
      )
    }
  }

  /**
   * A source for text from the DOM from a DOM property read or call to `getAttribute()`.
   */
  class DomTextSource extends DomPropertySource {
    string prop;

    DomTextSource() {
      exists(DataFlow::PropRead read | read = this |
        read.getBase().getALocalSource() = DOM::domValueRef() and
        prop = unsafeDomPropertyName() and
        read.mayHavePropertyName(prop)
      )
      or
      exists(DataFlow::MethodCallNode mcn | mcn = this |
        mcn.getReceiver().getALocalSource() = DOM::domValueRef() and
        mcn.getMethodName() = "getAttribute" and
        prop = unsafeAttributeName() and
        mcn.getArgument(0).mayHaveStringValue(prop)
      )
    }

    override string getPropertyName() { result = prop }
  }

  /** DEPRECATED: Alias for DomTextSource */
  deprecated class DOMTextSource = DomTextSource;

  /**
   * A test of form `typeof x === "something"`, preventing `x` from being a string in some cases.
   *
   * This sanitizer helps prune infeasible paths in type-overloaded functions.
   */
  class TypeTestGuard extends TaintTracking::SanitizerGuardNode, DataFlow::ValueNode {
    override EqualityTest astNode;
    Expr operand;
    boolean polarity;

    TypeTestGuard() {
      exists(TypeofTag tag | TaintTracking::isTypeofGuard(astNode, operand, tag) |
        // typeof x === "string" sanitizes `x` when it evaluates to false
        tag = "string" and
        polarity = astNode.getPolarity().booleanNot()
        or
        // typeof x === "object" sanitizes `x` when it evaluates to true
        tag != "string" and
        polarity = astNode.getPolarity()
      )
    }

    override predicate sanitizes(boolean outcome, Expr e) {
      polarity = outcome and
      e = operand
    }
  }

  /** The `files` property of an `<input />` element */
  class FilesSource extends Source {
    FilesSource() { this = DOM::domValueRef().getAPropertyRead("files") }
  }

  /**
   * A module for form inputs seen as sources for xss-through-dom.
   */
  module Forms {
    /**
     * Gets a reference to an import of `Formik`.
     */
    private DataFlow::SourceNode formik() {
      result = DataFlow::moduleImport("formik")
      or
      result = DataFlow::globalVarRef("Formik")
    }

    /**
     * An object containing input values from a form build with `Formik`.
     */
    class FormikSource extends Source {
      FormikSource() {
        exists(JsxElement elem |
          formik().getAPropertyRead("Formik").flowsToExpr(elem.getNameExpr())
        |
          this =
            elem.getAttributeByName(["validate", "onSubmit"])
                .getValue()
                .flow()
                .getAFunctionValue()
                .getParameter(0)
        )
        or
        this =
          formik()
              .getAMemberCall("withFormik")
              .getOptionArgument(0, ["validate", "handleSubmit"])
              .getAFunctionValue()
              .getParameter(0)
        or
        this = formik().getAMemberCall("useFormikContext").getAPropertyRead("values")
      }
    }

    /**
     * An object containing input values from a form build with `react-final-form`.
     */
    class ReactFinalFormSource extends Source {
      ReactFinalFormSource() {
        exists(JsxElement elem |
          DataFlow::moduleMember("react-final-form", "Form").flowsToExpr(elem.getNameExpr())
        |
          this =
            elem.getAttributeByName("onSubmit")
                .getValue()
                .flow()
                .getAFunctionValue()
                .getParameter(0)
        )
      }
    }

    /**
     * An object containing input values from a form build with `react-hook-form`.
     */
    class ReactHookFormSource extends Source {
      ReactHookFormSource() {
        exists(API::Node useForm |
          useForm = API::moduleImport("react-hook-form").getMember("useForm").getReturn()
        |
          this =
            useForm.getMember("handleSubmit").getParameter(0).getParameter(0).getAnImmediateUse()
          or
          this = useForm.getMember("getValues").getACall()
        )
      }
    }
  }
}
