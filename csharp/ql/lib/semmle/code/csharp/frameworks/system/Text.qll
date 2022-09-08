/** Provides definitions related to the namespace `System.Text`. */

import csharp
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.dataflow.ExternalFlow
private import semmle.code.csharp.dataflow.FlowSummary

/** The `System.Text` namespace. */
class SystemTextNamespace extends Namespace {
  SystemTextNamespace() {
    this.getParentNamespace() instanceof SystemNamespace and
    this.hasName("Text")
  }
}

/** A class in the `System.Text` namespace. */
class SystemTextClass extends Class {
  SystemTextClass() { this.getNamespace() instanceof SystemTextNamespace }
}

/** The `System.Text.StringBuilder` class. */
class SystemTextStringBuilderClass extends SystemTextClass {
  SystemTextStringBuilderClass() { this.hasName("StringBuilder") }

  /** Gets the `AppendFormat` method. */
  Method getAppendFormatMethod() { result = this.getAMethod("AppendFormat") }
}

/** Data flow for `System.Text.StringBuilder`. */
private class SystemTextStringBuilderFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Text;StringBuilder;false;Append;(System.Boolean);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;Append;(System.Byte);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;Append;(System.Char);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;Append;(System.Char*,System.Int32);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;Append;(System.Char,System.Int32);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;Append;(System.Char[]);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;Append;(System.Char[]);;Argument[0].Element;Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;Append;(System.Char[],System.Int32,System.Int32);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;Append;(System.Char[],System.Int32,System.Int32);;Argument[0].Element;Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;Append;(System.Decimal);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;Append;(System.Double);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;Append;(System.Int16);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;Append;(System.Int32);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;Append;(System.Int64);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;Append;(System.Object);;Argument[0];Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;Append;(System.Object);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;Append;(System.ReadOnlyMemory<System.Char>);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;Append;(System.ReadOnlySpan<System.Char>);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;Append;(System.SByte);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;Append;(System.Single);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;Append;(System.String);;Argument[0];Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;Append;(System.String);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;Append;(System.String,System.Int32,System.Int32);;Argument[0];Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;Append;(System.String,System.Int32,System.Int32);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;Append;(System.Text.StringBuilder);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;Append;(System.Text.StringBuilder,System.Int32,System.Int32);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;Append;(System.UInt16);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;Append;(System.UInt32);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;Append;(System.UInt64);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;AppendFormat;(System.IFormatProvider,System.String,System.Object);;Argument[1];Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;AppendFormat;(System.IFormatProvider,System.String,System.Object);;Argument[2];Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;AppendFormat;(System.IFormatProvider,System.String,System.Object);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;AppendFormat;(System.IFormatProvider,System.String,System.Object,System.Object);;Argument[1];Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;AppendFormat;(System.IFormatProvider,System.String,System.Object,System.Object);;Argument[2];Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;AppendFormat;(System.IFormatProvider,System.String,System.Object,System.Object);;Argument[3];Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;AppendFormat;(System.IFormatProvider,System.String,System.Object,System.Object);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;AppendFormat;(System.IFormatProvider,System.String,System.Object,System.Object,System.Object);;Argument[1];Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;AppendFormat;(System.IFormatProvider,System.String,System.Object,System.Object,System.Object);;Argument[2];Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;AppendFormat;(System.IFormatProvider,System.String,System.Object,System.Object,System.Object);;Argument[3];Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;AppendFormat;(System.IFormatProvider,System.String,System.Object,System.Object,System.Object);;Argument[4];Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;AppendFormat;(System.IFormatProvider,System.String,System.Object,System.Object,System.Object);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;AppendFormat;(System.IFormatProvider,System.String,System.Object[]);;Argument[1];Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;AppendFormat;(System.IFormatProvider,System.String,System.Object[]);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;AppendFormat;(System.IFormatProvider,System.String,System.Object[]);;Argument[2].Element;Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;AppendFormat;(System.String,System.Object);;Argument[0];Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;AppendFormat;(System.String,System.Object);;Argument[1];Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;AppendFormat;(System.String,System.Object);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;AppendFormat;(System.String,System.Object,System.Object);;Argument[0];Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;AppendFormat;(System.String,System.Object,System.Object);;Argument[1];Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;AppendFormat;(System.String,System.Object,System.Object);;Argument[2];Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;AppendFormat;(System.String,System.Object,System.Object);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;AppendFormat;(System.String,System.Object,System.Object,System.Object);;Argument[0];Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;AppendFormat;(System.String,System.Object,System.Object,System.Object);;Argument[1];Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;AppendFormat;(System.String,System.Object,System.Object,System.Object);;Argument[2];Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;AppendFormat;(System.String,System.Object,System.Object,System.Object);;Argument[3];Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;AppendFormat;(System.String,System.Object,System.Object,System.Object);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;AppendFormat;(System.String,System.Object[]);;Argument[0];Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;AppendFormat;(System.String,System.Object[]);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;AppendFormat;(System.String,System.Object[]);;Argument[1].Element;Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;AppendJoin;(System.Char,System.Object[]);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;AppendJoin;(System.Char,System.Object[]);;Argument[1].Element;Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;AppendJoin;(System.Char,System.String[]);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;AppendJoin;(System.Char,System.String[]);;Argument[1].Element;Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;AppendJoin;(System.String,System.Object[]);;Argument[0];Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;AppendJoin;(System.String,System.Object[]);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;AppendJoin;(System.String,System.Object[]);;Argument[1].Element;Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;AppendJoin;(System.String,System.String[]);;Argument[0];Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;AppendJoin;(System.String,System.String[]);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;AppendJoin;(System.String,System.String[]);;Argument[1].Element;Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;AppendJoin<>;(System.Char,System.Collections.Generic.IEnumerable<T>);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;AppendJoin<>;(System.Char,System.Collections.Generic.IEnumerable<T>);;Argument[1].Element;Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;AppendJoin<>;(System.String,System.Collections.Generic.IEnumerable<T>);;Argument[0];Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;AppendJoin<>;(System.String,System.Collections.Generic.IEnumerable<T>);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;AppendJoin<>;(System.String,System.Collections.Generic.IEnumerable<T>);;Argument[1].Element;Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;AppendLine;();;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;AppendLine;(System.String);;Argument[0];Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;AppendLine;(System.String);;Argument[this];ReturnValue;value;manual",
        "System.Text;StringBuilder;false;Clear;();;Argument[this].WithoutElement;Argument[this];value;manual",
        "System.Text;StringBuilder;false;StringBuilder;(System.String);;Argument[0];Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;StringBuilder;(System.String,System.Int32);;Argument[0];Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;StringBuilder;(System.String,System.Int32,System.Int32,System.Int32);;Argument[0];Argument[this].Element;value;manual",
        "System.Text;StringBuilder;false;ToString;();;Argument[this].Element;ReturnValue;taint;manual",
        "System.Text;StringBuilder;false;ToString;(System.Int32,System.Int32);;Argument[this].Element;ReturnValue;taint;manual",
      ]
  }
}

/** The `System.Text.Encoding` class. */
class SystemTextEncodingClass extends SystemTextClass {
  SystemTextEncodingClass() { this.hasName("Encoding") }

  /** Gets the `GetBytes` method. */
  Method getGetBytesMethod() { result = this.getAMethod("GetBytes") }

  /** Gets the `GetString` method. */
  Method getGetStringMethod() { result = this.getAMethod("GetString") }

  /** Gets the `GetChars` method. */
  Method getGetCharsMethod() { result = this.getAMethod("GetChars") }
}

/** Data flow for `System.Text.Encoding`. */
private class SystemTextEncodingFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Text;Encoding;false;GetBytes;(System.String,System.Int32,System.Int32);;Argument[0];ReturnValue;taint;manual",
        "System.Text;Encoding;false;GetString;(System.Byte*,System.Int32);;Argument[0].Element;ReturnValue;taint;manual",
        "System.Text;Encoding;false;GetString;(System.ReadOnlySpan<System.Byte>);;Argument[0].Element;ReturnValue;taint;manual",
        "System.Text;Encoding;true;GetBytes;(System.Char*,System.Int32,System.Byte*,System.Int32);;Argument[0];ReturnValue;taint;manual",
        "System.Text;Encoding;true;GetBytes;(System.Char[]);;Argument[0].Element;ReturnValue;taint;manual",
        "System.Text;Encoding;true;GetBytes;(System.Char[],System.Int32,System.Int32);;Argument[0].Element;ReturnValue;taint;manual",
        "System.Text;Encoding;true;GetBytes;(System.Char[],System.Int32,System.Int32,System.Byte[],System.Int32);;Argument[0].Element;ReturnValue;taint;manual",
        "System.Text;Encoding;true;GetBytes;(System.ReadOnlySpan<System.Char>,System.Span<System.Byte>);;Argument[0];ReturnValue;taint;manual",
        "System.Text;Encoding;true;GetBytes;(System.String);;Argument[0];ReturnValue;taint;manual",
        "System.Text;Encoding;true;GetBytes;(System.String,System.Int32,System.Int32,System.Byte[],System.Int32);;Argument[0];ReturnValue;taint;manual",
        "System.Text;Encoding;true;GetChars;(System.Byte*,System.Int32,System.Char*,System.Int32);;Argument[0].Element;ReturnValue;taint;manual",
        "System.Text;Encoding;true;GetChars;(System.Byte[]);;Argument[0].Element;ReturnValue;taint;manual",
        "System.Text;Encoding;true;GetChars;(System.Byte[],System.Int32,System.Int32);;Argument[0].Element;ReturnValue;taint;manual",
        "System.Text;Encoding;true;GetChars;(System.Byte[],System.Int32,System.Int32,System.Char[],System.Int32);;Argument[0].Element;ReturnValue;taint;manual",
        "System.Text;Encoding;true;GetChars;(System.ReadOnlySpan<System.Byte>,System.Span<System.Char>);;Argument[0].Element;ReturnValue;taint;manual",
        "System.Text;Encoding;true;GetString;(System.Byte[]);;Argument[0].Element;ReturnValue;taint;manual",
        "System.Text;Encoding;true;GetString;(System.Byte[],System.Int32,System.Int32);;Argument[0].Element;ReturnValue;taint;manual",
      ]
  }
}
