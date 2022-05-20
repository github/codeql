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
      // signature: func (*Element) Next() *Element
      hasQualifiedName("container/list", "Element", "Next") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (*Element) Prev() *Element
      hasQualifiedName("container/list", "Element", "Prev") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (*List) Back() *Element
      hasQualifiedName("container/list", "List", "Back") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (*List) Front() *Element
      hasQualifiedName("container/list", "List", "Front") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (*List) Init() *List
      hasQualifiedName("container/list", "List", "Init") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (*List) InsertAfter(v interface{}, mark *Element) *Element
      hasQualifiedName("container/list", "List", "InsertAfter") and
      (
        inp.isParameter(0) and
        (outp.isReceiver() or outp.isResult())
      )
      or
      // signature: func (*List) InsertBefore(v interface{}, mark *Element) *Element
      hasQualifiedName("container/list", "List", "InsertBefore") and
      (
        inp.isParameter(0) and
        (outp.isReceiver() or outp.isResult())
      )
      or
      // signature: func (*List) MoveAfter(e *Element, mark *Element)
      hasQualifiedName("container/list", "List", "MoveAfter") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*List) MoveBefore(e *Element, mark *Element)
      hasQualifiedName("container/list", "List", "MoveBefore") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*List) MoveToBack(e *Element)
      hasQualifiedName("container/list", "List", "MoveToBack") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*List) MoveToFront(e *Element)
      hasQualifiedName("container/list", "List", "MoveToFront") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*List) PushBack(v interface{}) *Element
      hasQualifiedName("container/list", "List", "PushBack") and
      (
        inp.isParameter(0) and
        (outp.isReceiver() or outp.isResult())
      )
      or
      // signature: func (*List) PushBackList(other *List)
      hasQualifiedName("container/list", "List", "PushBackList") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*List) PushFront(v interface{}) *Element
      hasQualifiedName("container/list", "List", "PushFront") and
      (
        inp.isParameter(0) and
        (outp.isReceiver() or outp.isResult())
      )
      or
      // signature: func (*List) PushFrontList(other *List)
      hasQualifiedName("container/list", "List", "PushFrontList") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*List) Remove(e *Element) interface{}
      hasQualifiedName("container/list", "List", "Remove") and
      (inp.isParameter(0) and outp.isResult())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
