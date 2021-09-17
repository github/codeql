/**
 * Provides classes modeling security-relevant aspects of the `reflect` package.
 */

import go

/** Provides models of commonly used functions in the `reflect` package. */
module Reflect {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func Append(s Value, x ...Value) Value
      hasQualifiedName("reflect", "Append") and
      (inp.isParameter(_) and outp.isResult())
      or
      // signature: func AppendSlice(s Value, t Value) Value
      hasQualifiedName("reflect", "AppendSlice") and
      (inp.isParameter(_) and outp.isResult())
      or
      // signature: func Copy(dst Value, src Value) int
      hasQualifiedName("reflect", "Copy") and
      (inp.isParameter(1) and outp.isParameter(0))
      or
      // signature: func Indirect(v Value) Value
      hasQualifiedName("reflect", "Indirect") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func ValueOf(i interface{}) Value
      hasQualifiedName("reflect", "ValueOf") and
      (inp.isParameter(0) and outp.isResult())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }

  private class MethodModels extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    MethodModels() {
      // signature: func (*MapIter) Key() Value
      hasQualifiedName("reflect", "MapIter", "Key") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (*MapIter) Value() Value
      hasQualifiedName("reflect", "MapIter", "Value") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (StructTag) Get(key string) string
      hasQualifiedName("reflect", "StructTag", "Get") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (StructTag) Lookup(key string) (value string, ok bool)
      hasQualifiedName("reflect", "StructTag", "Lookup") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (Value) Addr() Value
      hasQualifiedName("reflect", "Value", "Addr") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (Value) Bytes() []byte
      hasQualifiedName("reflect", "Value", "Bytes") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (Value) Convert(t Type) Value
      hasQualifiedName("reflect", "Value", "Convert") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (Value) Elem() Value
      hasQualifiedName("reflect", "Value", "Elem") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (Value) Field(i int) Value
      hasQualifiedName("reflect", "Value", "Field") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (Value) FieldByIndex(index []int) Value
      hasQualifiedName("reflect", "Value", "FieldByIndex") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (Value) FieldByName(name string) Value
      hasQualifiedName("reflect", "Value", "FieldByName") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (Value) FieldByNameFunc(match func(string) bool) Value
      hasQualifiedName("reflect", "Value", "FieldByNameFunc") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (Value) Index(i int) Value
      hasQualifiedName("reflect", "Value", "Index") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (Value) Interface() (i interface{})
      hasQualifiedName("reflect", "Value", "Interface") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (Value) InterfaceData() [2]uintptr
      hasQualifiedName("reflect", "Value", "InterfaceData") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (Value) MapIndex(key Value) Value
      hasQualifiedName("reflect", "Value", "MapIndex") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (Value) MapKeys() []Value
      hasQualifiedName("reflect", "Value", "MapKeys") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (Value) MapRange() *MapIter
      hasQualifiedName("reflect", "Value", "MapRange") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (Value) Method(i int) Value
      hasQualifiedName("reflect", "Value", "Method") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (Value) MethodByName(name string) Value
      hasQualifiedName("reflect", "Value", "MethodByName") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (Value) Pointer() uintptr
      hasQualifiedName("reflect", "Value", "Pointer") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (Value) Recv() (x Value, ok bool)
      hasQualifiedName("reflect", "Value", "Recv") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (Value) Send(x Value)
      hasQualifiedName("reflect", "Value", "Send") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (Value) Set(x Value)
      hasQualifiedName("reflect", "Value", "Set") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (Value) SetBytes(x []byte)
      hasQualifiedName("reflect", "Value", "SetBytes") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (Value) SetMapIndex(key Value, elem Value)
      hasQualifiedName("reflect", "Value", "SetMapIndex") and
      (inp.isParameter(_) and outp.isReceiver())
      or
      // signature: func (Value) SetPointer(x unsafe.Pointer)
      hasQualifiedName("reflect", "Value", "SetPointer") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (Value) SetString(x string)
      hasQualifiedName("reflect", "Value", "SetString") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (Value) Slice(i int, j int) Value
      hasQualifiedName("reflect", "Value", "Slice") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (Value) Slice3(i int, j int, k int) Value
      hasQualifiedName("reflect", "Value", "Slice3") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (Value) String() string
      hasQualifiedName("reflect", "Value", "String") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (Value) TryRecv() (x Value, ok bool)
      hasQualifiedName("reflect", "Value", "TryRecv") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (Value) TrySend(x Value) bool
      hasQualifiedName("reflect", "Value", "TrySend") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (Value) UnsafeAddr() uintptr
      hasQualifiedName("reflect", "Value", "UnsafeAddr") and
      (inp.isReceiver() and outp.isResult())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
