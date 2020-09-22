/**
 * Provides classes modeling security-relevant aspects of the `container/list` package.
 */

import go

/** Provides models of commonly used functions in the `container/list` package. */
module ContainerList {
  private class MethodModels extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    MethodModels() {
      // signature: func (*Element).Next() *Element
      this.hasQualifiedName("container/list", "Element", "Next") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (*Element).Prev() *Element
      this.hasQualifiedName("container/list", "Element", "Prev") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (*List).Back() *Element
      this.hasQualifiedName("container/list", "List", "Back") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (*List).Front() *Element
      this.hasQualifiedName("container/list", "List", "Front") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (*List).Init() *List
      this.hasQualifiedName("container/list", "List", "Init") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (*List).InsertAfter(v interface{}, mark *Element) *Element
      this.hasQualifiedName("container/list", "List", "InsertAfter") and
      (
        inp.isParameter(0) and
        (outp.isReceiver() or outp.isResult())
      )
      or
      // signature: func (*List).InsertBefore(v interface{}, mark *Element) *Element
      this.hasQualifiedName("container/list", "List", "InsertBefore") and
      (
        inp.isParameter(0) and
        (outp.isReceiver() or outp.isResult())
      )
      or
      // signature: func (*List).MoveAfter(e *Element, mark *Element)
      this.hasQualifiedName("container/list", "List", "MoveAfter") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*List).MoveBefore(e *Element, mark *Element)
      this.hasQualifiedName("container/list", "List", "MoveBefore") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*List).MoveToBack(e *Element)
      this.hasQualifiedName("container/list", "List", "MoveToBack") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*List).MoveToFront(e *Element)
      this.hasQualifiedName("container/list", "List", "MoveToFront") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*List).PushBack(v interface{}) *Element
      this.hasQualifiedName("container/list", "List", "PushBack") and
      (
        inp.isParameter(0) and
        (outp.isReceiver() or outp.isResult())
      )
      or
      // signature: func (*List).PushBackList(other *List)
      this.hasQualifiedName("container/list", "List", "PushBackList") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*List).PushFront(v interface{}) *Element
      this.hasQualifiedName("container/list", "List", "PushFront") and
      (
        inp.isParameter(0) and
        (outp.isReceiver() or outp.isResult())
      )
      or
      // signature: func (*List).PushFrontList(other *List)
      this.hasQualifiedName("container/list", "List", "PushFrontList") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*List).Remove(e *Element) interface{}
      this.hasQualifiedName("container/list", "List", "Remove") and
      (inp.isParameter(0) and outp.isResult())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
