/**
 * Provides default sources for reasoning about
 * cross-site scripting vulnerabilities through the DOM.
 */

import javascript

/**
 * Sources for cross-site scripting vulnerabilities through the DOM.
 */
module XssThroughDom {
  private import Xss::Shared as Shared
  private import semmle.javascript.dataflow.InferredTypes
  private import semmle.javascript.security.dataflow.DomBasedXssCustomizations

  /** A data flow source for XSS through DOM vulnerabilities. */
  abstract class Source extends Shared::Source { }

  /**
   * A barrier guard for XSS through the DOM.
   */
  abstract class BarrierGuard extends DataFlow::Node {
    /**
     * Holds if this node acts as a barrier for data flow, blocking further flow from `e` if `this` evaluates to `outcome`.
     */
    predicate blocksExpr(boolean outcome, Expr e) { none() }

    /** DEPRECATED. Use `blocksExpr` instead. */
    deprecated predicate sanitizes(boolean outcome, Expr e) { this.blocksExpr(outcome, e) }
  }

  /** A subclass of `BarrierGuard` that is used for backward compatibility with the old data flow library. */
  deprecated final private class BarrierGuardLegacy extends TaintTracking::SanitizerGuardNode instanceof BarrierGuard
  {
    override predicate sanitizes(boolean outcome, Expr e) {
      BarrierGuard.super.sanitizes(outcome, e)
    }
  }

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
  class JQueryDomPropertySource extends DomPropertySource instanceof JQuery::MethodCall {
    string prop;

    JQueryDomPropertySource() {
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
          this = useForm.getMember("handleSubmit").getParameter(0).getParameter(0).asSource()
          or
          this = useForm.getMember("getValues").getACall()
        )
      }
    }

    /**
     * An object containing input values from an Angular form, accessed through an `NgForm` object.
     */
    class AngularFormSource extends Source {
      AngularFormSource() {
        this = API::Node::ofType("@angular/forms", "NgForm").getMember("value").asSource()
      }
    }
  }

  /**
   * Gets a reference to a value obtained by calling `window.getSelection()`.
   * https://developer.mozilla.org/en-US/docs/Web/API/Selection
   */
  DataFlow::SourceNode getSelectionCall(DataFlow::TypeTracker t) {
    t.start() and
    exists(DataFlow::CallNode call |
      call = DataFlow::globalVarRef("getSelection").getACall()
      or
      call = DOM::documentRef().getAMemberCall("getSelection")
    |
      result = call
    )
    or
    exists(DataFlow::TypeTracker t2 | result = getSelectionCall(t2).track(t2, t))
  }

  /**
   * A source for text from the DOM from calling `toString()` on a `Selection` object.
   * The `toString()` method returns the currently selected text in the DOM.
   * https://developer.mozilla.org/en-US/docs/Web/API/Selection
   */
  class SelectionSource extends Source {
    SelectionSource() {
      this = getSelectionCall(DataFlow::TypeTracker::end()).getAMethodCall("toString")
    }
  }

  /**
   * A source of DOM input originating from an Angular two-way data binding.
   */
  private class AngularNgModelSource extends Source {
    AngularNgModelSource() {
      exists(Angular2::ComponentClass component, string fieldName |
        fieldName = component.getATemplateElement().getAttributeByName("[(ngModel)]").getValue() and
        this = component.getFieldInputNode(fieldName)
      )
    }
  }
}
