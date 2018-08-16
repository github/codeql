/** 
 * Provides definitions for working with classes in Microsoft.Extensions.Primitives namespace
 */
import csharp

module ExtensionPrimitives {
private import semmle.code.csharp.dataflow.LibraryTypeDataFlow

/**
 * StringValues class used in many .Net Core libraries. Requreres special LibraryTypeDataFlow flow. 
 */
  class StringValues extends Struct {
    StringValues() {
      this.hasQualifiedName("Microsoft.Extensions.Primitives", "StringValues")
    }
  }

  /**
   * Custom flow through StringValues.StringValues library class 
   */
  class StringValuesFlow extends LibraryTypeDataFlow, StringValues {
    override predicate callableFlow(CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c, boolean preservesValue) {
       c = any(Callable ca | this = ca.getDeclaringType())
      and
      (source = any(CallableFlowSourceArg a) or 
       source = any(CallableFlowSourceQualifier q)) 
      and
       sink = any(CallableFlowSinkReturn r)
      and preservesValue = false
    }
  }
}