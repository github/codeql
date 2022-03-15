/** Provides definitions related to the namespace `System`. */

import csharp
private import system.Reflection
private import semmle.code.csharp.dataflow.ExternalFlow

/** The `System` namespace. */
class SystemNamespace extends Namespace {
  SystemNamespace() {
    this.getParentNamespace() instanceof GlobalNamespace and
    this.hasUndecoratedName("System")
  }
}

/** A class in the `System` namespace. */
class SystemClass extends Class {
  SystemClass() { this.getNamespace() instanceof SystemNamespace }
}

/** An unbound generic class in the `System` namespace. */
class SystemUnboundGenericClass extends UnboundGenericClass {
  SystemUnboundGenericClass() { this.getNamespace() instanceof SystemNamespace }
}

/** An unbound generic struct in the `System` namespace. */
class SystemUnboundGenericStruct extends UnboundGenericStruct {
  SystemUnboundGenericStruct() { this.getNamespace() instanceof SystemNamespace }
}

/** An interface in the `System` namespace. */
class SystemInterface extends Interface {
  SystemInterface() { this.getNamespace() instanceof SystemNamespace }
}

/** An unbound generic interface in the `System` namespace. */
class SystemUnboundGenericInterface extends UnboundGenericInterface {
  SystemUnboundGenericInterface() { this.getNamespace() instanceof SystemNamespace }
}

/** A delegate type in the `System` namespace. */
class SystemDelegateType extends DelegateType {
  SystemDelegateType() { this.getNamespace() instanceof SystemNamespace }
}

/** An unbound generic delegate type in the `System` namespace. */
class SystemUnboundGenericDelegateType extends UnboundGenericDelegateType {
  SystemUnboundGenericDelegateType() { this.getNamespace() instanceof SystemNamespace }
}

/** The `System.Action` delegate type. */
class SystemActionDelegateType extends SystemDelegateType {
  SystemActionDelegateType() { this.getName() = "Action" }
}

/** The `System.Action<T1, ..., Tn>` delegate type. */
class SystemActionTDelegateType extends SystemUnboundGenericDelegateType {
  SystemActionTDelegateType() { this.getName().regexpMatch("Action<,*>") }
}

/** `System.Array` class. */
class SystemArrayClass extends SystemClass {
  SystemArrayClass() { this.hasName("Array") }

  /** Gets the `Length` property. */
  Property getLengthProperty() { result = this.getProperty("Length") }
}

/** Data flow for `System.Array`. */
private class SystemArrayFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System;Array;false;AsReadOnly<>;(T[]);;Argument[0].Element;ReturnValue.Element;value",
        "System;Array;false;Clone;();;Argument[0].Element;ReturnValue.Element;value",
        "System;Array;false;CopyTo;(System.Array,System.Int64);;Argument[Qualifier].Element;Argument[0].Element;value",
        "System;Array;false;Find<>;(T[],System.Predicate<T>);;Argument[0].Element;Argument[1].Parameter[0];value",
        "System;Array;false;Find<>;(T[],System.Predicate<T>);;Argument[0].Element;ReturnValue;value",
        "System;Array;false;FindAll<>;(T[],System.Predicate<T>);;Argument[0].Element;Argument[1].Parameter[0];value",
        "System;Array;false;FindAll<>;(T[],System.Predicate<T>);;Argument[0].Element;ReturnValue;value",
        "System;Array;false;FindLast<>;(T[],System.Predicate<T>);;Argument[0].Element;Argument[1].Parameter[0];value",
        "System;Array;false;FindLast<>;(T[],System.Predicate<T>);;Argument[0].Element;ReturnValue;value",
        "System;Array;false;Reverse;(System.Array);;Argument[0].Element;ReturnValue.Element;value",
        "System;Array;false;Reverse;(System.Array,System.Int32,System.Int32);;Argument[0].Element;ReturnValue.Element;value",
        "System;Array;false;Reverse<>;(T[]);;Argument[0].Element;ReturnValue.Element;value",
        "System;Array;false;Reverse<>;(T[],System.Int32,System.Int32);;Argument[0].Element;ReturnValue.Element;value",
      ]
  }
}

/** `System.Attribute` class. */
class SystemAttributeClass extends SystemClass {
  SystemAttributeClass() { this.hasName("Attribute") }
}

/** The `System.Boolean` structure. */
class SystemBooleanStruct extends BoolType {
  /** Gets the `Parse(string)` method. */
  Method getParseMethod() {
    result.getDeclaringType() = this and
    result.hasName("Parse") and
    result.getNumberOfParameters() = 1 and
    result.getParameter(0).getType() instanceof StringType and
    result.getReturnType() instanceof BoolType
  }

  /** Gets the `TryParse(string, out bool)` method. */
  Method getTryParseMethod() {
    result.getDeclaringType() = this and
    result.hasName("TryParse") and
    result.getNumberOfParameters() = 2 and
    result.getParameter(0).getType() instanceof StringType and
    result.getParameter(1).getType() instanceof BoolType and
    result.getReturnType() instanceof BoolType
  }

  override string getAPrimaryQlClass() { result = "SystemBooleanStruct" }
}

/** Data flow for `System.Boolean`. */
private class SystemBooleanFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System;Boolean;false;Parse;(System.String);;Argument[0];ReturnValue;taint",
        "System;Boolean;false;TryParse;(System.String,System.Boolean);;Argument[0];Argument[1];taint",
        "System;Boolean;false;TryParse;(System.String,System.Boolean);;Argument[0];ReturnValue;taint",
        "System;Boolean;false;TryParse;(System.ReadOnlySpan<System.Char>,System.Boolean);;Argument[0].Element;Argument[1];taint",
        "System;Boolean;false;TryParse;(System.ReadOnlySpan<System.Char>,System.Boolean);;Argument[0].Element;ReturnValue;taint",
      ]
  }
}

/** The `System.Convert` class. */
class SystemConvertClass extends SystemClass {
  SystemConvertClass() { this.hasName("Convert") }
}

/** Data flow for `System.Convert`. */
private class SystemConvertFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System;Convert;false;ChangeType;(System.Object,System.Type);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ChangeType;(System.Object,System.Type,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ChangeType;(System.Object,System.TypeCode);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ChangeType;(System.Object,System.TypeCode,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;FromBase64CharArray;(System.Char[],System.Int32,System.Int32);;Argument[0].Element;ReturnValue.Element;taint",
        "System;Convert;false;FromBase64String;(System.String);;Argument[0];ReturnValue.Element;taint",
        "System;Convert;false;FromHexString;(System.ReadOnlySpan<System.Char>);;Argument[0].Element;ReturnValue.Element;taint",
        "System;Convert;false;FromHexString;(System.String);;Argument[0];ReturnValue.Element;taint",
        "System;Convert;false;GetTypeCode;(System.Object);;Argument[0];ReturnValue;taint",
        "System;Convert;false;IsDBNull;(System.Object);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBase64CharArray;(System.Byte[],System.Int32,System.Int32,System.Char[],System.Int32,System.Base64FormattingOptions);;Argument[0].Element;ReturnValue;taint",
        "System;Convert;false;ToBase64CharArray;(System.Byte[],System.Int32,System.Int32,System.Char[],System.Int32,System.Base64FormattingOptions);;Argument[0].Element;Argument[3].Element;taint",
        "System;Convert;false;ToBase64CharArray;(System.Byte[],System.Int32,System.Int32,System.Char[],System.Int32);;Argument[0].Element;ReturnValue;taint",
        "System;Convert;false;ToBase64CharArray;(System.Byte[],System.Int32,System.Int32,System.Char[],System.Int32);;Argument[0].Element;Argument[3].Element;taint",
        "System;Convert;false;ToBase64String;(System.Byte[]);;Argument[0].Element;ReturnValue;taint",
        "System;Convert;false;ToBase64String;(System.Byte[],System.Base64FormattingOptions);;Argument[0].Element;ReturnValue;taint",
        "System;Convert;false;ToBase64String;(System.Byte[],System.Int32,System.Int32);;Argument[0].Element;ReturnValue;taint",
        "System;Convert;false;ToBase64String;(System.Byte[],System.Int32,System.Int32,System.Base64FormattingOptions);;Argument[0].Element;ReturnValue;taint",
        "System;Convert;false;ToBase64String;(System.ReadOnlySpan<System.Byte>,System.Base64FormattingOptions);;Argument[0].Element;ReturnValue;taint",
        "System;Convert;false;ToBoolean;(System.Boolean);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBoolean;(System.Byte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBoolean;(System.Char);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBoolean;(System.DateTime);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBoolean;(System.Decimal);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBoolean;(System.Double);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBoolean;(System.Int16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBoolean;(System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBoolean;(System.Int64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBoolean;(System.Object);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBoolean;(System.Object,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBoolean;(System.SByte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBoolean;(System.Single);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBoolean;(System.String);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBoolean;(System.String,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBoolean;(System.UInt16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBoolean;(System.UInt32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToBoolean;(System.UInt64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToByte;(System.Boolean);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToByte;(System.Byte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToByte;(System.Char);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToByte;(System.DateTime);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToByte;(System.Decimal);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToByte;(System.Double);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToByte;(System.Int16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToByte;(System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToByte;(System.Int64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToByte;(System.Object);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToByte;(System.Object,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToByte;(System.SByte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToByte;(System.Single);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToByte;(System.String);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToByte;(System.String,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToByte;(System.String,System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToByte;(System.UInt16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToByte;(System.UInt32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToByte;(System.UInt64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToChar;(System.Boolean);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToChar;(System.Byte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToChar;(System.Char);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToChar;(System.DateTime);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToChar;(System.Decimal);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToChar;(System.Double);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToChar;(System.Int16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToChar;(System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToChar;(System.Int64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToChar;(System.Object);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToChar;(System.Object,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToChar;(System.SByte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToChar;(System.Single);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToChar;(System.String);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToChar;(System.String,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToChar;(System.UInt16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToChar;(System.UInt32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToChar;(System.UInt64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDateTime;(System.Boolean);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDateTime;(System.Byte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDateTime;(System.Char);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDateTime;(System.DateTime);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDateTime;(System.Decimal);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDateTime;(System.Double);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDateTime;(System.Int16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDateTime;(System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDateTime;(System.Int64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDateTime;(System.Object);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDateTime;(System.Object,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDateTime;(System.SByte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDateTime;(System.Single);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDateTime;(System.String);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDateTime;(System.String,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDateTime;(System.UInt16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDateTime;(System.UInt32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDateTime;(System.UInt64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDecimal;(System.Boolean);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDecimal;(System.Byte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDecimal;(System.Char);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDecimal;(System.DateTime);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDecimal;(System.Decimal);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDecimal;(System.Double);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDecimal;(System.Int16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDecimal;(System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDecimal;(System.Int64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDecimal;(System.Object);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDecimal;(System.Object,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDecimal;(System.SByte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDecimal;(System.Single);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDecimal;(System.String);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDecimal;(System.String,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDecimal;(System.UInt16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDecimal;(System.UInt32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDecimal;(System.UInt64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDouble;(System.Boolean);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDouble;(System.Byte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDouble;(System.Char);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDouble;(System.DateTime);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDouble;(System.Decimal);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDouble;(System.Double);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDouble;(System.Int16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDouble;(System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDouble;(System.Int64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDouble;(System.Object);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDouble;(System.Object,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDouble;(System.SByte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDouble;(System.Single);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDouble;(System.String);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDouble;(System.String,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDouble;(System.UInt16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDouble;(System.UInt32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToDouble;(System.UInt64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToHexString;(System.Byte[]);;Argument[0].Element;ReturnValue;taint",
        "System;Convert;false;ToHexString;(System.Byte[],System.Int32,System.Int32);;Argument[0].Element;ReturnValue;taint",
        "System;Convert;false;ToHexString;(System.ReadOnlySpan<System.Byte>);;Argument[0].Element;ReturnValue;taint",
        "System;Convert;false;ToInt16;(System.Boolean);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt16;(System.Byte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt16;(System.Char);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt16;(System.DateTime);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt16;(System.Decimal);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt16;(System.Double);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt16;(System.Int16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt16;(System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt16;(System.Int64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt16;(System.Object);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt16;(System.Object,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt16;(System.SByte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt16;(System.Single);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt16;(System.String);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt16;(System.String,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt16;(System.String,System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt16;(System.UInt16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt16;(System.UInt32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt16;(System.UInt64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt32;(System.Boolean);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt32;(System.Byte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt32;(System.Char);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt32;(System.DateTime);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt32;(System.Decimal);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt32;(System.Double);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt32;(System.Int16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt32;(System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt32;(System.Int64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt32;(System.Object);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt32;(System.Object,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt32;(System.SByte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt32;(System.Single);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt32;(System.String);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt32;(System.String,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt32;(System.String,System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt32;(System.UInt16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt32;(System.UInt32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt32;(System.UInt64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt64;(System.Boolean);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt64;(System.Byte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt64;(System.Char);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt64;(System.DateTime);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt64;(System.Decimal);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt64;(System.Double);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt64;(System.Int16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt64;(System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt64;(System.Int64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt64;(System.Object);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt64;(System.Object,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt64;(System.SByte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt64;(System.Single);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt64;(System.String);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt64;(System.String,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt64;(System.String,System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt64;(System.UInt16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt64;(System.UInt32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToInt64;(System.UInt64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSByte;(System.Boolean);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSByte;(System.Byte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSByte;(System.Char);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSByte;(System.DateTime);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSByte;(System.Decimal);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSByte;(System.Double);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSByte;(System.Int16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSByte;(System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSByte;(System.Int64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSByte;(System.Object);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSByte;(System.Object,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSByte;(System.SByte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSByte;(System.Single);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSByte;(System.String);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSByte;(System.String,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSByte;(System.String,System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSByte;(System.UInt16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSByte;(System.UInt32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSByte;(System.UInt64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSingle;(System.Boolean);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSingle;(System.Byte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSingle;(System.Char);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSingle;(System.DateTime);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSingle;(System.Decimal);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSingle;(System.Double);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSingle;(System.Int16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSingle;(System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSingle;(System.Int64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSingle;(System.Object);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSingle;(System.Object,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSingle;(System.SByte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSingle;(System.Single);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSingle;(System.String);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSingle;(System.String,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSingle;(System.UInt16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSingle;(System.UInt32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToSingle;(System.UInt64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Boolean);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Boolean,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Byte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Byte,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Byte,System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Char);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Char,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.DateTime);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.DateTime,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Decimal);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Decimal,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Double);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Double,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Int16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Int16,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Int16,System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Int32,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Int32,System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Int64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Int64,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Int64,System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Object);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Object,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.SByte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.SByte,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Single);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.Single,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.String);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.String,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.UInt16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.UInt16,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.UInt32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.UInt32,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.UInt64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToString;(System.UInt64,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt16;(System.Boolean);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt16;(System.Byte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt16;(System.Char);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt16;(System.DateTime);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt16;(System.Decimal);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt16;(System.Double);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt16;(System.Int16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt16;(System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt16;(System.Int64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt16;(System.Object);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt16;(System.Object,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt16;(System.SByte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt16;(System.Single);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt16;(System.String);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt16;(System.String,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt16;(System.String,System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt16;(System.UInt16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt16;(System.UInt32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt16;(System.UInt64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt32;(System.Boolean);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt32;(System.Byte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt32;(System.Char);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt32;(System.DateTime);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt32;(System.Decimal);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt32;(System.Double);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt32;(System.Int16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt32;(System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt32;(System.Int64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt32;(System.Object);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt32;(System.Object,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt32;(System.SByte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt32;(System.Single);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt32;(System.String);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt32;(System.String,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt32;(System.String,System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt32;(System.UInt16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt32;(System.UInt32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt32;(System.UInt64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt64;(System.Boolean);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt64;(System.Byte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt64;(System.Char);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt64;(System.DateTime);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt64;(System.Decimal);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt64;(System.Double);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt64;(System.Int16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt64;(System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt64;(System.Int64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt64;(System.Object);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt64;(System.Object,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt64;(System.SByte);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt64;(System.Single);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt64;(System.String);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt64;(System.String,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt64;(System.String,System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt64;(System.UInt16);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt64;(System.UInt32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;ToUInt64;(System.UInt64);;Argument[0];ReturnValue;taint",
        "System;Convert;false;TryFromBase64Chars;(System.ReadOnlySpan<System.Char>,System.Span<System.Byte>,System.Int32);;Argument[0].Element;ReturnValue;taint",
        "System;Convert;false;TryFromBase64Chars;(System.ReadOnlySpan<System.Char>,System.Span<System.Byte>,System.Int32);;Argument[0].Element;Argument[1].Element;taint",
        "System;Convert;false;TryFromBase64Chars;(System.ReadOnlySpan<System.Char>,System.Span<System.Byte>,System.Int32);;Argument[0].Element;Argument[2];taint",
        "System;Convert;false;TryFromBase64String;(System.String,System.Span<System.Byte>,System.Int32);;Argument[0];ReturnValue;taint",
        "System;Convert;false;TryFromBase64String;(System.String,System.Span<System.Byte>,System.Int32);;Argument[0];Argument[1].Element;taint",
        "System;Convert;false;TryFromBase64String;(System.String,System.Span<System.Byte>,System.Int32);;Argument[0];Argument[2];taint",
        "System;Convert;false;TryToBase64Chars;(System.ReadOnlySpan<System.Byte>,System.Span<System.Char>,System.Int32,System.Base64FormattingOptions);;Argument[0].Element;ReturnValue;taint",
        "System;Convert;false;TryToBase64Chars;(System.ReadOnlySpan<System.Byte>,System.Span<System.Char>,System.Int32,System.Base64FormattingOptions);;Argument[0].Element;Argument[1].Element;taint",
        "System;Convert;false;TryToBase64Chars;(System.ReadOnlySpan<System.Byte>,System.Span<System.Char>,System.Int32,System.Base64FormattingOptions);;Argument[0].Element;Argument[2];taint",
      ]
  }
}

/** `System.Delegate` class. */
class SystemDelegateClass extends SystemClass {
  SystemDelegateClass() { this.hasName("Delegate") }
}

/** The `System.DivideByZeroException` class. */
class SystemDivideByZeroExceptionClass extends SystemClass {
  SystemDivideByZeroExceptionClass() { this.hasName("DivideByZeroException") }
}

/** The `System.Enum` class. */
class SystemEnumClass extends SystemClass {
  SystemEnumClass() { this.hasName("Enum") }
}

/** The `System.Exception` class. */
class SystemExceptionClass extends SystemClass {
  SystemExceptionClass() { this.hasName("Exception") }
}

/** The `System.Func<T1, ..., Tn, TResult>` delegate type. */
class SystemFuncDelegateType extends SystemUnboundGenericDelegateType {
  SystemFuncDelegateType() { this.getName().regexpMatch("Func<,*>") }

  /** Gets one of the `Ti` input type parameters. */
  TypeParameter getAnInputTypeParameter() {
    exists(int i | i in [0 .. this.getNumberOfTypeParameters() - 2] |
      result = this.getTypeParameter(i)
    )
  }

  /** Gets the `TResult` output type parameter. */
  TypeParameter getReturnTypeParameter() {
    result = this.getTypeParameter(this.getNumberOfTypeParameters() - 1)
  }
}

/** The `System.IComparable` interface. */
class SystemIComparableInterface extends SystemInterface {
  SystemIComparableInterface() { this.hasName("IComparable") }

  /** Gets the `CompareTo(object)` method. */
  Method getCompareToMethod() {
    result.getDeclaringType() = this and
    result.hasName("CompareTo") and
    result.getNumberOfParameters() = 1 and
    result.getParameter(0).getType() instanceof ObjectType and
    result.getReturnType() instanceof IntType
  }
}

/** The `System.IComparable<T>` interface. */
class SystemIComparableTInterface extends SystemUnboundGenericInterface {
  SystemIComparableTInterface() { this.hasName("IComparable<>") }

  /** Gets the `CompareTo(T)` method. */
  Method getCompareToMethod() {
    result.getDeclaringType() = this and
    result.hasName("CompareTo") and
    result.getNumberOfParameters() = 1 and
    result.getParameter(0).getType() = this.getTypeParameter(0) and
    result.getReturnType() instanceof IntType
  }
}

/** The `System.IEquatable<T>` interface. */
class SystemIEquatableTInterface extends SystemUnboundGenericInterface {
  SystemIEquatableTInterface() { this.hasName("IEquatable<>") }

  /** Gets the `Equals(T)` method. */
  Method getEqualsMethod() {
    result.getDeclaringType() = this and
    result.hasName("Equals") and
    result.getNumberOfParameters() = 1 and
    result.getParameter(0).getType() = this.getTypeParameter(0) and
    result.getReturnType() instanceof BoolType
  }
}

/** The `System.IFormatProvider` interface. */
class SystemIFormatProviderInterface extends SystemInterface {
  SystemIFormatProviderInterface() { this.hasName("IFormatProvider") }
}

/** The `System.Int32` structure. */
class SystemInt32Struct extends IntType {
  /** Gets the `Parse(string, ...)` method. */
  Method getParseMethod() {
    result.getDeclaringType() = this and
    result.hasName("Parse") and
    result.getParameter(0).getType() instanceof StringType and
    result.getReturnType() instanceof IntType
  }

  /** Gets the `TryParse(string, ..., out int)` method. */
  Method getTryParseMethod() {
    result.getDeclaringType() = this and
    result.hasName("TryParse") and
    result.getParameter(0).getType() instanceof StringType and
    result.getParameter(result.getNumberOfParameters() - 1).getType() instanceof IntType and
    result.getReturnType() instanceof BoolType
  }
}

/** Data flow for `System.Int32`. */
private class SystemInt32FlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System;Int32;false;Parse;(System.String);;Argument[0];ReturnValue;taint",
        "System;Int32;false;Parse;(System.String,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Int32;false;Parse;(System.String,System.Globalization.NumberStyles);;Argument[0];ReturnValue;taint",
        "System;Int32;false;Parse;(System.String,System.Globalization.NumberStyles,System.IFormatProvider);;Argument[0];ReturnValue;taint",
        "System;Int32;false;Parse;(System.ReadOnlySpan<System.Char>,System.Globalization.NumberStyles,System.IFormatProvider);;Argument[0].Element;ReturnValue;taint",
        "System;Int32;false;TryParse;(System.String,System.Int32);;Argument[0];ReturnValue;taint",
        "System;Int32;false;TryParse;(System.String,System.Int32);;Argument[0];Argument[1];taint",
        "System;Int32;false;TryParse;(System.ReadOnlySpan<System.Char>,System.Int32);;Argument[0].Element;ReturnValue;taint",
        "System;Int32;false;TryParse;(System.ReadOnlySpan<System.Char>,System.Int32);;Argument[0].Element;Argument[1];taint",
        "System;Int32;false;TryParse;(System.String,System.Globalization.NumberStyles,System.IFormatProvider,System.Int32);;Argument[0];ReturnValue;taint",
        "System;Int32;false;TryParse;(System.String,System.Globalization.NumberStyles,System.IFormatProvider,System.Int32);;Argument[0];Argument[3];taint",
        "System;Int32;false;TryParse;(System.ReadOnlySpan<System.Char>,System.Globalization.NumberStyles,System.IFormatProvider,System.Int32);;Argument[0].Element;ReturnValue;taint",
        "System;Int32;false;TryParse;(System.ReadOnlySpan<System.Char>,System.Globalization.NumberStyles,System.IFormatProvider,System.Int32);;Argument[0].Element;Argument[3];taint"
      ]
  }
}

/** The `System.InvalidCastException` class. */
class SystemInvalidCastExceptionClass extends SystemClass {
  SystemInvalidCastExceptionClass() { this.hasName("InvalidCastException") }
}

/** The `System.Lazy<T>` class. */
class SystemLazyClass extends SystemUnboundGenericClass {
  SystemLazyClass() {
    this.hasName("Lazy<>") and
    this.getNumberOfTypeParameters() = 1
  }

  /** Gets the `Value` property. */
  Property getValueProperty() {
    result.getDeclaringType() = this and
    result.hasName("Value") and
    result.getType() = this.getTypeParameter(0)
  }
}

/** Data flow for `System.Lazy<>`. */
private class SystemLazyFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System;Lazy<>;false;Lazy;(System.Func<T>);;Argument[0].ReturnValue;ReturnValue.Property[System.Lazy<>.Value];value",
        "System;Lazy<>;false;Lazy;(System.Func<T>,System.Boolean);;Argument[0].ReturnValue;ReturnValue.Property[System.Lazy<>.Value];value",
        "System;Lazy<>;false;Lazy;(System.Func<T>,System.Threading.LazyThreadSafetyMode);;Argument[0].ReturnValue;ReturnValue.Property[System.Lazy<>.Value];value",
        "System;Lazy<>;false;get_Value;();;Argument[Qualifier];ReturnValue;taint",
      ]
  }
}

/** The `System.Nullable<T>` struct. */
class SystemNullableStruct extends SystemUnboundGenericStruct {
  SystemNullableStruct() {
    this.hasName("Nullable<>") and
    this.getNumberOfTypeParameters() = 1
  }

  /** Gets the `Value` property. */
  Property getValueProperty() {
    result.getDeclaringType() = this and
    result.hasName("Value") and
    result.getType() = this.getTypeParameter(0)
  }

  /** Gets the `HasValue` property. */
  Property getHasValueProperty() {
    result.getDeclaringType() = this and
    result.hasName("HasValue") and
    result.getType() instanceof BoolType
  }

  /** Gets a `GetValueOrDefault()` method. */
  Method getAGetValueOrDefaultMethod() {
    result.getDeclaringType() = this and
    result.hasName("GetValueOrDefault") and
    result.getReturnType() = this.getTypeParameter(0)
  }
}

/** Data flow for `System.Nullable<>`. */
private class SystemNullableFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System;Nullable<>;false;GetValueOrDefault;();;Argument[Qualifier].Property[System.Nullable<>.Value];ReturnValue;value",
        "System;Nullable<>;false;GetValueOrDefault;(T);;Argument[0];ReturnValue;value",
        "System;Nullable<>;false;GetValueOrDefault;(T);;Argument[Qualifier].Property[System.Nullable<>.Value];ReturnValue;value",
        "System;Nullable<>;false;Nullable;(T);;Argument[0];ReturnValue.Property[System.Nullable<>.Value];value",
        "System;Nullable<>;false;get_HasValue;();;Argument[Qualifier].Property[System.Nullable<>.Value];ReturnValue;taint",
        "System;Nullable<>;false;get_Value;();;Argument[Qualifier];ReturnValue;taint",
      ]
  }
}

/** The `System.NullReferenceException` class. */
class SystemNullReferenceExceptionClass extends SystemClass {
  SystemNullReferenceExceptionClass() { this.hasName("NullReferenceException") }
}

/** The `System.Object` class. */
class SystemObjectClass extends SystemClass {
  SystemObjectClass() { this instanceof ObjectType }

  /** Gets the `Equals(object)` method. */
  Method getEqualsMethod() {
    result.getDeclaringType() = this and
    result.hasName("Equals") and
    result.getNumberOfParameters() = 1 and
    result.getParameter(0).getType() instanceof ObjectType and
    result.getReturnType() instanceof BoolType
  }

  /** Gets the `Equals(object, object)` method. */
  Method getStaticEqualsMethod() {
    result.isStatic() and
    result.getDeclaringType() = this and
    result.hasName("Equals") and
    result.getNumberOfParameters() = 2 and
    result.getParameter(0).getType() instanceof ObjectType and
    result.getParameter(1).getType() instanceof ObjectType and
    result.getReturnType() instanceof BoolType
  }

  /** Gets the `ReferenceEquals(object, object)` method. */
  Method getReferenceEqualsMethod() {
    result.isStatic() and
    result.getDeclaringType() = this and
    result.hasName("ReferenceEquals") and
    result.getNumberOfParameters() = 2 and
    result.getParameter(0).getType() instanceof ObjectType and
    result.getParameter(1).getType() instanceof ObjectType and
    result.getReturnType() instanceof BoolType
  }

  /** Gets the `GetHashCode()` method. */
  Method getGetHashCodeMethod() {
    result.getDeclaringType() = this and
    result.hasName("GetHashCode") and
    result.hasNoParameters() and
    result.getReturnType() instanceof IntType
  }

  /** Gets the `GetType()` method. */
  Method getGetTypeMethod() {
    result.getDeclaringType() = this and
    result.hasName("GetType") and
    result.hasNoParameters() and
    result.getReturnType() instanceof SystemTypeClass
  }

  /** Gets the `ToString()` method. */
  Method getToStringMethod() {
    result.getDeclaringType() = this and
    result.hasName("ToString") and
    result.getNumberOfParameters() = 0 and
    result.getReturnType() instanceof StringType
  }
}

/** The `System.OutOfMemoryException` class. */
class SystemOutOfMemoryExceptionClass extends SystemClass {
  SystemOutOfMemoryExceptionClass() { this.hasName("OutOfMemoryException") }
}

/** The `System.OverflowException` class. */
class SystemOverflowExceptionClass extends SystemClass {
  SystemOverflowExceptionClass() { this.hasName("OverflowException") }
}

/** The `System.Predicate<T>` delegate type. */
class SystemPredicateDelegateType extends SystemUnboundGenericDelegateType {
  SystemPredicateDelegateType() {
    this.hasName("Predicate<>") and
    this.getNumberOfTypeParameters() = 1
  }
}

/** The `System.String` class. */
class SystemStringClass extends StringType {
  /** Gets the `Equals(object)` method. */
  Method getEqualsMethod() {
    result.getDeclaringType() = this and
    result.hasName("Equals")
  }

  /** Gets the `==` operator. */
  Operator getEqualsOperator() {
    result.getDeclaringType() = this and
    result.hasName("==")
  }

  /** Gets the `Replace(string/char, string/char)` method. */
  Method getReplaceMethod() {
    result.getDeclaringType() = this and
    result.hasName("Replace") and
    result.getNumberOfParameters() = 2 and
    result.getReturnType() instanceof StringType
  }

  /** Gets a `Format(...)` method. */
  Method getFormatMethod() {
    result.getDeclaringType() = this and
    result.hasName("Format") and
    result.getNumberOfParameters() in [2 .. 5] and
    result.getReturnType() instanceof StringType
  }

  /** Gets a `Split(...)` method. */
  Method getSplitMethod() {
    result.getDeclaringType() = this and
    result.hasName("Split") and
    result.getNumberOfParameters() in [1 .. 3] and
    result.getReturnType().(ArrayType).getElementType() instanceof StringType
  }

  /** Gets a `Substring(...)` method. */
  Method getSubstringMethod() {
    result.getDeclaringType() = this and
    result.hasName("Substring") and
    result.getNumberOfParameters() in [1 .. 2] and
    result.getReturnType() instanceof StringType
  }

  /** Gets a `Concat(...)` method. */
  Method getConcatMethod() {
    result.getDeclaringType() = this and
    result.hasUndecoratedName("Concat") and
    result.getReturnType() instanceof StringType
  }

  /** Gets the `Copy()` method. */
  Method getCopyMethod() {
    result.getDeclaringType() = this and
    result.hasName("Copy") and
    result.getNumberOfParameters() = 1 and
    result.getParameter(0).getType() instanceof StringType and
    result.getReturnType() instanceof StringType
  }

  /** Gets a `Join(...)` method. */
  Method getJoinMethod() {
    result.getDeclaringType() = this and
    result.hasUndecoratedName("Join") and
    result.getNumberOfParameters() > 1 and
    result.getReturnType() instanceof StringType
  }

  /** Gets the `Clone()` method. */
  Method getCloneMethod() {
    result.getDeclaringType() = this and
    result.hasName("Clone") and
    result.getNumberOfParameters() = 0 and
    result.getReturnType() instanceof ObjectType
  }

  /** Gets the `Insert(int, string)` method. */
  Method getInsertMethod() {
    result.getDeclaringType() = this and
    result.hasName("Insert") and
    result.getNumberOfParameters() = 2 and
    result.getParameter(0).getType() instanceof IntType and
    result.getParameter(1).getType() instanceof StringType and
    result.getReturnType() instanceof StringType
  }

  /** Gets the `Normalize(...)` method. */
  Method getNormalizeMethod() {
    result.getDeclaringType() = this and
    result.hasName("Normalize") and
    result.getNumberOfParameters() in [0 .. 1] and
    result.getReturnType() instanceof StringType
  }

  /** Gets a `Remove(...)` method. */
  Method getRemoveMethod() {
    result.getDeclaringType() = this and
    result.hasName("Remove") and
    result.getNumberOfParameters() in [1 .. 2] and
    result.getReturnType() instanceof StringType
  }

  /** Gets the `IsNullOrEmpty(string)` method. */
  Method getIsNullOrEmptyMethod() {
    result.getDeclaringType() = this and
    result.hasName("IsNullOrEmpty") and
    result.isStatic() and
    result.getNumberOfParameters() = 1 and
    result.getReturnType() instanceof BoolType
  }

  /** Gets the `IsNullOrWhiteSpace(string)` method. */
  Method getIsNullOrWhiteSpaceMethod() {
    result.getDeclaringType() = this and
    result.hasName("IsNullOrWhiteSpace") and
    result.isStatic() and
    result.getNumberOfParameters() = 1 and
    result.getReturnType() instanceof BoolType
  }
}

/** Data flow for `System.String`. */
private class SystemStringFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System;String;false;Clone;();;Argument[Qualifier];ReturnValue;value",
        "System;String;false;Concat;(System.Collections.Generic.IEnumerable<System.String>);;Argument[0].Element;ReturnValue;taint",
        "System;String;false;Concat;(System.Object);;Argument[0];ReturnValue;taint",
        "System;String;false;Concat;(System.Object,System.Object);;Argument[0];ReturnValue;taint",
        "System;String;false;Concat;(System.Object,System.Object);;Argument[1];ReturnValue;taint",
        "System;String;false;Concat;(System.Object,System.Object,System.Object);;Argument[0];ReturnValue;taint",
        "System;String;false;Concat;(System.Object,System.Object,System.Object);;Argument[1];ReturnValue;taint",
        "System;String;false;Concat;(System.Object,System.Object,System.Object);;Argument[2];ReturnValue;taint",
        "System;String;false;Concat;(System.Object[]);;Argument[0].Element;ReturnValue;taint",
        "System;String;false;Concat;(System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>);;Argument[0].Element;ReturnValue;taint",
        "System;String;false;Concat;(System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>);;Argument[1].Element;ReturnValue;taint",
        "System;String;false;Concat;(System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>);;Argument[0].Element;ReturnValue;taint",
        "System;String;false;Concat;(System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>);;Argument[1].Element;ReturnValue;taint",
        "System;String;false;Concat;(System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>);;Argument[2].Element;ReturnValue;taint",
        "System;String;false;Concat;(System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>);;Argument[0].Element;ReturnValue;taint",
        "System;String;false;Concat;(System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>);;Argument[1].Element;ReturnValue;taint",
        "System;String;false;Concat;(System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>);;Argument[2].Element;ReturnValue;taint",
        "System;String;false;Concat;(System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>,System.ReadOnlySpan<System.Char>);;Argument[3].Element;ReturnValue;taint",
        "System;String;false;Concat;(System.String,System.String);;Argument[0];ReturnValue;taint",
        "System;String;false;Concat;(System.String,System.String);;Argument[1];ReturnValue;taint",
        "System;String;false;Concat;(System.String,System.String,System.String);;Argument[0];ReturnValue;taint",
        "System;String;false;Concat;(System.String,System.String,System.String);;Argument[1];ReturnValue;taint",
        "System;String;false;Concat;(System.String,System.String,System.String);;Argument[2];ReturnValue;taint",
        "System;String;false;Concat;(System.String,System.String,System.String,System.String);;Argument[0];ReturnValue;taint",
        "System;String;false;Concat;(System.String,System.String,System.String,System.String);;Argument[1];ReturnValue;taint",
        "System;String;false;Concat;(System.String,System.String,System.String,System.String);;Argument[2];ReturnValue;taint",
        "System;String;false;Concat;(System.String,System.String,System.String,System.String);;Argument[3];ReturnValue;taint",
        "System;String;false;Concat;(System.String[]);;Argument[0].Element;ReturnValue;taint",
        "System;String;false;Concat<>;(System.Collections.Generic.IEnumerable<T>);;Argument[0].Element;ReturnValue;taint",
        "System;String;false;Copy;(System.String);;Argument[0];ReturnValue;value",
        "System;String;false;Format;(System.IFormatProvider,System.String,System.Object);;Argument[1];ReturnValue;taint",
        "System;String;false;Format;(System.IFormatProvider,System.String,System.Object);;Argument[2];ReturnValue;taint",
        "System;String;false;Format;(System.IFormatProvider,System.String,System.Object,System.Object);;Argument[1];ReturnValue;taint",
        "System;String;false;Format;(System.IFormatProvider,System.String,System.Object,System.Object);;Argument[2];ReturnValue;taint",
        "System;String;false;Format;(System.IFormatProvider,System.String,System.Object,System.Object);;Argument[3];ReturnValue;taint",
        "System;String;false;Format;(System.IFormatProvider,System.String,System.Object,System.Object,System.Object);;Argument[1];ReturnValue;taint",
        "System;String;false;Format;(System.IFormatProvider,System.String,System.Object,System.Object,System.Object);;Argument[2];ReturnValue;taint",
        "System;String;false;Format;(System.IFormatProvider,System.String,System.Object,System.Object,System.Object);;Argument[3];ReturnValue;taint",
        "System;String;false;Format;(System.IFormatProvider,System.String,System.Object,System.Object,System.Object);;Argument[4];ReturnValue;taint",
        "System;String;false;Format;(System.IFormatProvider,System.String,System.Object[]);;Argument[1];ReturnValue;taint",
        "System;String;false;Format;(System.IFormatProvider,System.String,System.Object[]);;Argument[2].Element;ReturnValue;taint",
        "System;String;false;Format;(System.String,System.Object);;Argument[0];ReturnValue;taint",
        "System;String;false;Format;(System.String,System.Object);;Argument[1];ReturnValue;taint",
        "System;String;false;Format;(System.String,System.Object,System.Object);;Argument[0];ReturnValue;taint",
        "System;String;false;Format;(System.String,System.Object,System.Object);;Argument[1];ReturnValue;taint",
        "System;String;false;Format;(System.String,System.Object,System.Object);;Argument[2];ReturnValue;taint",
        "System;String;false;Format;(System.String,System.Object,System.Object,System.Object);;Argument[0];ReturnValue;taint",
        "System;String;false;Format;(System.String,System.Object,System.Object,System.Object);;Argument[1];ReturnValue;taint",
        "System;String;false;Format;(System.String,System.Object,System.Object,System.Object);;Argument[2];ReturnValue;taint",
        "System;String;false;Format;(System.String,System.Object,System.Object,System.Object);;Argument[3];ReturnValue;taint",
        "System;String;false;Format;(System.String,System.Object[]);;Argument[0];ReturnValue;taint",
        "System;String;false;Format;(System.String,System.Object[]);;Argument[1].Element;ReturnValue;taint",
        "System;String;false;GetEnumerator;();;Argument[Qualifier].Element;ReturnValue.Property[System.CharEnumerator.Current];value",
        "System;String;false;GetEnumerator;();;Argument[Qualifier].Element;ReturnValue.Property[System.Collections.Generic.IEnumerator<>.Current];value",
        "System;String;false;Insert;(System.Int32,System.String);;Argument[1];ReturnValue;taint",
        "System;String;false;Insert;(System.Int32,System.String);;Argument[Qualifier];ReturnValue;taint",
        "System;String;false;Join;(System.Char,System.Object[]);;Argument[0];ReturnValue;taint",
        "System;String;false;Join;(System.Char,System.Object[]);;Argument[1].Element;ReturnValue;taint",
        "System;String;false;Join;(System.Char,System.String[]);;Argument[0];ReturnValue;taint",
        "System;String;false;Join;(System.Char,System.String[]);;Argument[1].Element;ReturnValue;taint",
        "System;String;false;Join;(System.Char,System.String[],System.Int32,System.Int32);;Argument[0];ReturnValue;taint",
        "System;String;false;Join;(System.Char,System.String[],System.Int32,System.Int32);;Argument[1].Element;ReturnValue;taint",
        "System;String;false;Join;(System.String,System.Collections.Generic.IEnumerable<System.String>);;Argument[0];ReturnValue;taint",
        "System;String;false;Join;(System.String,System.Collections.Generic.IEnumerable<System.String>);;Argument[1].Element;ReturnValue;taint",
        "System;String;false;Join;(System.String,System.Object[]);;Argument[0];ReturnValue;taint",
        "System;String;false;Join;(System.String,System.Object[]);;Argument[1].Element;ReturnValue;taint",
        "System;String;false;Join;(System.String,System.String[]);;Argument[0];ReturnValue;taint",
        "System;String;false;Join;(System.String,System.String[]);;Argument[1].Element;ReturnValue;taint",
        "System;String;false;Join;(System.String,System.String[],System.Int32,System.Int32);;Argument[0];ReturnValue;taint",
        "System;String;false;Join;(System.String,System.String[],System.Int32,System.Int32);;Argument[1].Element;ReturnValue;taint",
        "System;String;false;Join<>;(System.Char,System.Collections.Generic.IEnumerable<T>);;Argument[0];ReturnValue;taint",
        "System;String;false;Join<>;(System.Char,System.Collections.Generic.IEnumerable<T>);;Argument[1].Element;ReturnValue;taint",
        "System;String;false;Join<>;(System.String,System.Collections.Generic.IEnumerable<T>);;Argument[0];ReturnValue;taint",
        "System;String;false;Join<>;(System.String,System.Collections.Generic.IEnumerable<T>);;Argument[1].Element;ReturnValue;taint",
        "System;String;false;Normalize;();;Argument[Qualifier];ReturnValue;taint",
        "System;String;false;Normalize;(System.Text.NormalizationForm);;Argument[Qualifier];ReturnValue;taint",
        "System;String;false;PadLeft;(System.Int32);;Argument[Qualifier];ReturnValue;taint",
        "System;String;false;PadLeft;(System.Int32,System.Char);;Argument[Qualifier];ReturnValue;taint",
        "System;String;false;PadRight;(System.Int32);;Argument[Qualifier];ReturnValue;taint",
        "System;String;false;PadRight;(System.Int32,System.Char);;Argument[Qualifier];ReturnValue;taint",
        "System;String;false;Remove;(System.Int32);;Argument[Qualifier];ReturnValue;taint",
        "System;String;false;Remove;(System.Int32,System.Int32);;Argument[Qualifier];ReturnValue;taint",
        "System;String;false;Replace;(System.Char,System.Char);;Argument[1];ReturnValue;taint",
        "System;String;false;Replace;(System.Char,System.Char);;Argument[Qualifier];ReturnValue;taint",
        "System;String;false;Replace;(System.String,System.String);;Argument[1];ReturnValue;taint",
        "System;String;false;Replace;(System.String,System.String);;Argument[Qualifier];ReturnValue;taint",
        "System;String;false;Split;(System.Char,System.Int32,System.StringSplitOptions);;Argument[Qualifier];ReturnValue.Element;taint",
        "System;String;false;Split;(System.Char,System.StringSplitOptions);;Argument[Qualifier];ReturnValue.Element;taint",
        "System;String;false;Split;(System.Char[]);;Argument[Qualifier];ReturnValue.Element;taint",
        "System;String;false;Split;(System.Char[],System.Int32);;Argument[Qualifier];ReturnValue.Element;taint",
        "System;String;false;Split;(System.Char[],System.Int32,System.StringSplitOptions);;Argument[Qualifier];ReturnValue.Element;taint",
        "System;String;false;Split;(System.Char[],System.StringSplitOptions);;Argument[Qualifier];ReturnValue.Element;taint",
        "System;String;false;Split;(System.String,System.Int32,System.StringSplitOptions);;Argument[Qualifier];ReturnValue.Element;taint",
        "System;String;false;Split;(System.String,System.StringSplitOptions);;Argument[Qualifier];ReturnValue.Element;taint",
        "System;String;false;Split;(System.String[],System.Int32,System.StringSplitOptions);;Argument[Qualifier];ReturnValue.Element;taint",
        "System;String;false;Split;(System.String[],System.StringSplitOptions);;Argument[Qualifier];ReturnValue.Element;taint",
        "System;String;false;String;(System.Char[]);;Argument[0].Element;ReturnValue;taint",
        "System;String;false;String;(System.Char[],System.Int32,System.Int32);;Argument[0].Element;ReturnValue;taint",
        "System;String;false;Substring;(System.Int32);;Argument[Qualifier];ReturnValue;taint",
        "System;String;false;Substring;(System.Int32,System.Int32);;Argument[Qualifier];ReturnValue;taint",
        "System;String;false;ToLower;();;Argument[Qualifier];ReturnValue;taint",
        "System;String;false;ToLower;(System.Globalization.CultureInfo);;Argument[Qualifier];ReturnValue;taint",
        "System;String;false;ToLowerInvariant;();;Argument[Qualifier];ReturnValue;taint",
        "System;String;false;ToString;();;Argument[Qualifier];ReturnValue;value",
        "System;String;false;ToString;(System.IFormatProvider);;Argument[Qualifier];ReturnValue;value",
        "System;String;false;ToUpper;();;Argument[Qualifier];ReturnValue;taint",
        "System;String;false;ToUpper;(System.Globalization.CultureInfo);;Argument[Qualifier];ReturnValue;taint",
        "System;String;false;ToUpperInvariant;();;Argument[Qualifier];ReturnValue;taint",
        "System;String;false;Trim;();;Argument[Qualifier];ReturnValue;taint",
        "System;String;false;Trim;(System.Char);;Argument[Qualifier];ReturnValue;taint",
        "System;String;false;Trim;(System.Char[]);;Argument[Qualifier];ReturnValue;taint",
        "System;String;false;TrimEnd;();;Argument[Qualifier];ReturnValue;taint",
        "System;String;false;TrimEnd;(System.Char);;Argument[Qualifier];ReturnValue;taint",
        "System;String;false;TrimEnd;(System.Char[]);;Argument[Qualifier];ReturnValue;taint",
        "System;String;false;TrimStart;();;Argument[Qualifier];ReturnValue;taint",
        "System;String;false;TrimStart;(System.Char);;Argument[Qualifier];ReturnValue;taint",
        "System;String;false;TrimStart;(System.Char[]);;Argument[Qualifier];ReturnValue;taint",
      ]
  }
}

/** A `ToString()` method. */
class ToStringMethod extends Method {
  ToStringMethod() { this = any(SystemObjectClass c).getToStringMethod().getAnOverrider*() }
}

/** The `System.Type` class */
class SystemTypeClass extends SystemClass {
  SystemTypeClass() { this.hasName("Type") }

  /** Gets the `FullName` property. */
  Property getFullNameProperty() {
    result.getDeclaringType() = this and
    result.hasName("FullName") and
    result.getType() instanceof StringType
  }

  /** Gets the `InvokeMember(string, ...)` method. */
  Method getInvokeMemberMethod() {
    result.getDeclaringType() = this and
    result.hasName("InvokeMember") and
    result.getParameter(0).getType() instanceof StringType and
    result.getParameter(3).getType() instanceof ObjectType and
    result.getParameter(4).getType().(ArrayType).getElementType() instanceof ObjectType and
    result.getReturnType() instanceof ObjectType
  }

  /** Gets the `GetMethod(string, ...)` method. */
  Method getGetMethodMethod() {
    result.getDeclaringType() = this and
    result.hasName("GetMethod") and
    result.getParameter(0).getType() instanceof StringType and
    result.getReturnType() instanceof SystemReflectionMethodInfoClass
  }
}

/** The `System.Uri` class. */
class SystemUriClass extends SystemClass {
  SystemUriClass() { this.hasName("Uri") }

  /** Gets the `PathAndQuery` property. */
  Property getPathAndQueryProperty() {
    result.getDeclaringType() = this and
    result.hasName("PathAndQuery") and
    result.getType() instanceof StringType
  }

  /** Gets the `Query` property. */
  Property getQueryProperty() {
    result.getDeclaringType() = this and
    result.hasName("Query") and
    result.getType() instanceof StringType
  }

  /** Gets the `OriginalString` property. */
  Property getOriginalStringProperty() {
    result.getDeclaringType() = this and
    result.hasName("OriginalString") and
    result.getType() instanceof StringType
  }
}

/** Data flow for `System.Uri`. */
private class SystemUriFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System;Uri;false;ToString;();;Argument[Qualifier];ReturnValue;taint",
        "System;Uri;false;Uri;(System.String);;Argument[0];ReturnValue;taint",
        "System;Uri;false;Uri;(System.String,System.Boolean);;Argument[0];ReturnValue;taint",
        "System;Uri;false;Uri;(System.String,System.UriKind);;Argument[0];ReturnValue;taint",
        "System;Uri;false;get_OriginalString;();;Argument[Qualifier];ReturnValue;taint",
        "System;Uri;false;get_PathAndQuery;();;Argument[Qualifier];ReturnValue;taint",
        "System;Uri;false;get_Query;();;Argument[Qualifier];ReturnValue;taint",
      ]
  }
}

/** The `System.ValueType` class. */
class SystemValueTypeClass extends SystemClass {
  SystemValueTypeClass() { this.hasName("ValueType") }
}

/** The `System.IntPtr` type. */
class SystemIntPtrType extends ValueType {
  SystemIntPtrType() {
    this = any(SystemNamespace n).getATypeDeclaration() and
    this.hasName("IntPtr")
  }

  override string getAPrimaryQlClass() { result = "SystemIntPtrType" }
}

/** The `System.IDisposable` interface. */
class SystemIDisposableInterface extends SystemInterface {
  SystemIDisposableInterface() { this.hasName("IDisposable") }

  /** Gets the `Dispose()` method. */
  Method getDisposeMethod() {
    result.getDeclaringType() = this and
    result.hasName("Dispose") and
    result.getNumberOfParameters() = 0 and
    result.getReturnType() instanceof VoidType
  }
}

/** A method that overrides `int object.GetHashCode()`. */
class GetHashCodeMethod extends Method {
  GetHashCodeMethod() {
    exists(Method m | m = any(SystemObjectClass c).getGetHashCodeMethod() |
      this = m.getAnOverrider*()
    )
  }
}

/** A method that overrides `bool object.Equals(object)`. */
class EqualsMethod extends Method {
  EqualsMethod() {
    exists(Method m | m = any(SystemObjectClass c).getEqualsMethod() | this = m.getAnOverrider*())
  }
}

/** A method that implements `bool IEquatable<T>.Equals(T)`. */
class IEquatableEqualsMethod extends Method {
  IEquatableEqualsMethod() {
    exists(Method m |
      m = any(SystemIEquatableTInterface i).getAConstructedGeneric().getAMethod() and
      m.getUnboundDeclaration() = any(SystemIEquatableTInterface i).getEqualsMethod()
    |
      this = m or this.getAnUltimateImplementee() = m
    )
  }
}

/**
 * Whether the type `t` defines an equals method.
 *
 * Either the equals method is (an override of) `object.Equals(object)`,
 * or an implementation of `IEquatable<T>.Equals(T)` which is called
 * from the `object.Equals(object)` method inherited by `t`.
 */
predicate implementsEquals(ValueOrRefType t) { getInvokedEqualsMethod(t).getDeclaringType() = t }

/**
 * Gets the equals method that will be invoked on a value `x`
 * of type `t` when `x.Equals(object)` is called.
 *
 * Either the equals method is (an override of) `object.Equals(object)`,
 * or an implementation of `IEquatable<T>.Equals(T)` which is called
 * from the `object.Equals(object)` method inherited by `t`.
 */
Method getInvokedEqualsMethod(ValueOrRefType t) {
  result = getInheritedEqualsMethod(t, _) and
  not exists(getInvokedIEquatableEqualsMethod(t, result))
  or
  exists(EqualsMethod eq |
    result = getInvokedIEquatableEqualsMethod(t, eq) and
    getInheritedEqualsMethod(t, _) = eq
  )
}

pragma[noinline]
private EqualsMethod getInheritedEqualsMethod(ValueOrRefType t, ValueOrRefType decl) {
  t.hasMethod(result) and decl = result.getDeclaringType()
}

/**
 * Equals method `eq` is inherited by `t`, `t` overrides `IEquatable<T>.Equals(T)`
 * from the declaring type of `eq`, and `eq` calls the overridden method (provided
 * that `eq` is from source code).
 *
 * Example:
 *
 * ```csharp
 * abstract class A<T> : IEquatable<T> {
 *   public abstract bool Equals(T other);
 *   public override bool Equals(object other) { return other != null && GetType() == other.GetType() && Equals((T)other); }
 * }
 *
 * class B : A<B> {
 *   public override bool Equals(B other) { ... }
 * }
 * ```
 *
 * In the example, `t = B`, `eq = A<B>.Equals(object)`, and `result = B.Equals(B)`.
 */
private IEquatableEqualsMethod getInvokedIEquatableEqualsMethod(ValueOrRefType t, EqualsMethod eq) {
  t.hasMethod(result) and
  exists(IEquatableEqualsMethod ieem |
    result = ieem.getAnOverrider*() and
    eq = getInheritedEqualsMethod(t.getBaseClass(), ieem.getDeclaringType())
  |
    not ieem.fromSource()
    or
    callsEqualsMethod(eq, ieem)
  )
}

/** Whether `eq` calls `ieem` */
private predicate callsEqualsMethod(EqualsMethod eq, IEquatableEqualsMethod ieem) {
  exists(MethodCall callToDerivedEquals |
    callToDerivedEquals.getEnclosingCallable() = eq.getUnboundDeclaration() and
    callToDerivedEquals.getTarget() = ieem.getUnboundDeclaration()
  )
}

/** A method that implements `void IDisposable.Dispose()`. */
class DisposeMethod extends Method {
  DisposeMethod() {
    exists(Method m | m = any(SystemIDisposableInterface i).getDisposeMethod() |
      this = m or this.getAnUltimateImplementee() = m
    )
  }
}

/** A method with the signature `void Dispose(bool)`. */
library class DisposeBoolMethod extends Method {
  DisposeBoolMethod() {
    this.hasName("Dispose") and
    this.getReturnType() instanceof VoidType and
    this.getNumberOfParameters() = 1 and
    this.getParameter(0).getType() instanceof BoolType
  }
}

/**
 * Whether the type `t` defines a dispose method.
 *
 * Either the dispose method is (an override of) `IDisposable.Dispose()`,
 * or an implementation of a method `Dispose(bool)` which is called
 * from the `IDisposable.Dispose()` method inherited by `t`.
 */
predicate implementsDispose(ValueOrRefType t) { getInvokedDisposeMethod(t).getDeclaringType() = t }

/**
 * Gets the dispose method that will be invoked on a value `x`
 * of type `t` when `x.Dipsose()` is called.
 *
 * Either the dispose method is (an override of) `IDisposable.Dispose()`,
 * or an implementation of a method `Dispose(bool)` which is called
 * from the `IDisposable.Dispose()` method inherited by `t`.
 */
Method getInvokedDisposeMethod(ValueOrRefType t) {
  result = getInheritedDisposeMethod(t) and
  not exists(getInvokedDiposeBoolMethod(t, result))
  or
  exists(DisposeMethod eq |
    result = getInvokedDiposeBoolMethod(t, eq) and
    getInheritedDisposeMethod(t) = eq
  )
}

private DisposeMethod getInheritedDisposeMethod(ValueOrRefType t) { t.hasMethod(result) }

/**
 * Dispose method `disp` is inherited by `t`, `t` overrides a `void Dispose(bool)`
 * method from the declaring type of `disp`, and `disp` calls the overridden method
 * (provided that `disp` is from source code).
 *
 * Example:
 *
 * ```csharp
 * class A : IDisposable {
 *   public void Dispose() { Dispose(true); }
 *   public virtual void Dispose(bool disposing) { ... }
 * }
 *
 * class B : A {
 *   public override bool Dispose(bool disposing) { base.Dispose(disposing); ... }
 * }
 * ```
 *
 * In the example, `t = B`, `disp = A.Dispose()`, and `result = B.Dispose(bool)`.
 */
private DisposeBoolMethod getInvokedDiposeBoolMethod(ValueOrRefType t, DisposeMethod disp) {
  t.hasMethod(result) and
  disp = getInheritedDisposeMethod(t.getBaseClass()) and
  exists(DisposeBoolMethod dbm |
    result = dbm.getAnOverrider*() and
    disp.getDeclaringType() = dbm.getDeclaringType()
  |
    not disp.fromSource()
    or
    exists(MethodCall callToDerivedDispose |
      callToDerivedDispose.getEnclosingCallable() = disp.getUnboundDeclaration() and
      callToDerivedDispose.getTarget() = dbm.getUnboundDeclaration()
    )
  )
}

/** A struct in the `System` namespace. */
class SystemStruct extends Struct {
  SystemStruct() { this.getNamespace() instanceof SystemNamespace }
}

/** `System.Guid` struct. */
class SystemGuid extends SystemStruct {
  SystemGuid() { this.hasName("Guid") }
}

/** The `System.NotImplementedException` class. */
class SystemNotImplementedExceptionClass extends SystemClass {
  SystemNotImplementedExceptionClass() { this.hasName("NotImplementedException") }
}

/** The `System.DateTime` struct. */
class SystemDateTimeStruct extends SystemStruct {
  SystemDateTimeStruct() { this.hasName("DateTime") }
}

/** Data flow for `System.Tuple`. */
private class SystemTupleFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System;Tuple;false;Create<,,,,,,,>;(T1,T2,T3,T4,T5,T6,T7,T8);;Argument[0];ReturnValue.Property[System.Tuple<,,,,,,,>.Item1];value",
        "System;Tuple;false;Create<,,,,,,,>;(T1,T2,T3,T4,T5,T6,T7,T8);;Argument[1];ReturnValue.Property[System.Tuple<,,,,,,,>.Item2];value",
        "System;Tuple;false;Create<,,,,,,,>;(T1,T2,T3,T4,T5,T6,T7,T8);;Argument[2];ReturnValue.Property[System.Tuple<,,,,,,,>.Item3];value",
        "System;Tuple;false;Create<,,,,,,,>;(T1,T2,T3,T4,T5,T6,T7,T8);;Argument[3];ReturnValue.Property[System.Tuple<,,,,,,,>.Item4];value",
        "System;Tuple;false;Create<,,,,,,,>;(T1,T2,T3,T4,T5,T6,T7,T8);;Argument[4];ReturnValue.Property[System.Tuple<,,,,,,,>.Item5];value",
        "System;Tuple;false;Create<,,,,,,,>;(T1,T2,T3,T4,T5,T6,T7,T8);;Argument[5];ReturnValue.Property[System.Tuple<,,,,,,,>.Item6];value",
        "System;Tuple;false;Create<,,,,,,,>;(T1,T2,T3,T4,T5,T6,T7,T8);;Argument[6];ReturnValue.Property[System.Tuple<,,,,,,,>.Item7];value",
        "System;Tuple;false;Create<,,,,,,>;(T1,T2,T3,T4,T5,T6,T7);;Argument[0];ReturnValue.Property[System.Tuple<,,,,,,>.Item1];value",
        "System;Tuple;false;Create<,,,,,,>;(T1,T2,T3,T4,T5,T6,T7);;Argument[1];ReturnValue.Property[System.Tuple<,,,,,,>.Item2];value",
        "System;Tuple;false;Create<,,,,,,>;(T1,T2,T3,T4,T5,T6,T7);;Argument[2];ReturnValue.Property[System.Tuple<,,,,,,>.Item3];value",
        "System;Tuple;false;Create<,,,,,,>;(T1,T2,T3,T4,T5,T6,T7);;Argument[3];ReturnValue.Property[System.Tuple<,,,,,,>.Item4];value",
        "System;Tuple;false;Create<,,,,,,>;(T1,T2,T3,T4,T5,T6,T7);;Argument[4];ReturnValue.Property[System.Tuple<,,,,,,>.Item5];value",
        "System;Tuple;false;Create<,,,,,,>;(T1,T2,T3,T4,T5,T6,T7);;Argument[5];ReturnValue.Property[System.Tuple<,,,,,,>.Item6];value",
        "System;Tuple;false;Create<,,,,,,>;(T1,T2,T3,T4,T5,T6,T7);;Argument[6];ReturnValue.Property[System.Tuple<,,,,,,>.Item7];value",
        "System;Tuple;false;Create<,,,,,>;(T1,T2,T3,T4,T5,T6);;Argument[0];ReturnValue.Property[System.Tuple<,,,,,>.Item1];value",
        "System;Tuple;false;Create<,,,,,>;(T1,T2,T3,T4,T5,T6);;Argument[1];ReturnValue.Property[System.Tuple<,,,,,>.Item2];value",
        "System;Tuple;false;Create<,,,,,>;(T1,T2,T3,T4,T5,T6);;Argument[2];ReturnValue.Property[System.Tuple<,,,,,>.Item3];value",
        "System;Tuple;false;Create<,,,,,>;(T1,T2,T3,T4,T5,T6);;Argument[3];ReturnValue.Property[System.Tuple<,,,,,>.Item4];value",
        "System;Tuple;false;Create<,,,,,>;(T1,T2,T3,T4,T5,T6);;Argument[4];ReturnValue.Property[System.Tuple<,,,,,>.Item5];value",
        "System;Tuple;false;Create<,,,,,>;(T1,T2,T3,T4,T5,T6);;Argument[5];ReturnValue.Property[System.Tuple<,,,,,>.Item6];value",
        "System;Tuple;false;Create<,,,,>;(T1,T2,T3,T4,T5);;Argument[0];ReturnValue.Property[System.Tuple<,,,,>.Item1];value",
        "System;Tuple;false;Create<,,,,>;(T1,T2,T3,T4,T5);;Argument[1];ReturnValue.Property[System.Tuple<,,,,>.Item2];value",
        "System;Tuple;false;Create<,,,,>;(T1,T2,T3,T4,T5);;Argument[2];ReturnValue.Property[System.Tuple<,,,,>.Item3];value",
        "System;Tuple;false;Create<,,,,>;(T1,T2,T3,T4,T5);;Argument[3];ReturnValue.Property[System.Tuple<,,,,>.Item4];value",
        "System;Tuple;false;Create<,,,,>;(T1,T2,T3,T4,T5);;Argument[4];ReturnValue.Property[System.Tuple<,,,,>.Item5];value",
        "System;Tuple;false;Create<,,,>;(T1,T2,T3,T4);;Argument[0];ReturnValue.Property[System.Tuple<,,,>.Item1];value",
        "System;Tuple;false;Create<,,,>;(T1,T2,T3,T4);;Argument[1];ReturnValue.Property[System.Tuple<,,,>.Item2];value",
        "System;Tuple;false;Create<,,,>;(T1,T2,T3,T4);;Argument[2];ReturnValue.Property[System.Tuple<,,,>.Item3];value",
        "System;Tuple;false;Create<,,,>;(T1,T2,T3,T4);;Argument[3];ReturnValue.Property[System.Tuple<,,,>.Item4];value",
        "System;Tuple;false;Create<,,>;(T1,T2,T3);;Argument[0];ReturnValue.Property[System.Tuple<,,>.Item1];value",
        "System;Tuple;false;Create<,,>;(T1,T2,T3);;Argument[1];ReturnValue.Property[System.Tuple<,,>.Item2];value",
        "System;Tuple;false;Create<,,>;(T1,T2,T3);;Argument[2];ReturnValue.Property[System.Tuple<,,>.Item3];value",
        "System;Tuple;false;Create<,>;(T1,T2);;Argument[0];ReturnValue.Property[System.Tuple<,>.Item1];value",
        "System;Tuple;false;Create<,>;(T1,T2);;Argument[1];ReturnValue.Property[System.Tuple<,>.Item2];value",
        "System;Tuple;false;Create<>;(T1);;Argument[0];ReturnValue.Property[System.Tuple<>.Item1];value"
      ]
  }
}

/** Data flow for `System.Tuple<,*>`. */
private class SystemTupleTFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System;Tuple<,,,,,,,>;false;Tuple;(T1,T2,T3,T4,T5,T6,T7,TRest);;Argument[0];ReturnValue.Property[System.Tuple<,,,,,,,>.Item1];value",
        "System;Tuple<,,,,,,,>;false;Tuple;(T1,T2,T3,T4,T5,T6,T7,TRest);;Argument[1];ReturnValue.Property[System.Tuple<,,,,,,,>.Item2];value",
        "System;Tuple<,,,,,,,>;false;Tuple;(T1,T2,T3,T4,T5,T6,T7,TRest);;Argument[2];ReturnValue.Property[System.Tuple<,,,,,,,>.Item3];value",
        "System;Tuple<,,,,,,,>;false;Tuple;(T1,T2,T3,T4,T5,T6,T7,TRest);;Argument[3];ReturnValue.Property[System.Tuple<,,,,,,,>.Item4];value",
        "System;Tuple<,,,,,,,>;false;Tuple;(T1,T2,T3,T4,T5,T6,T7,TRest);;Argument[4];ReturnValue.Property[System.Tuple<,,,,,,,>.Item5];value",
        "System;Tuple<,,,,,,,>;false;Tuple;(T1,T2,T3,T4,T5,T6,T7,TRest);;Argument[5];ReturnValue.Property[System.Tuple<,,,,,,,>.Item6];value",
        "System;Tuple<,,,,,,,>;false;Tuple;(T1,T2,T3,T4,T5,T6,T7,TRest);;Argument[6];ReturnValue.Property[System.Tuple<,,,,,,,>.Item7];value",
        "System;Tuple<,,,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Property[System.Tuple<,,,,,,,>.Item1];ReturnValue;value",
        "System;Tuple<,,,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Property[System.Tuple<,,,,,,,>.Item2];ReturnValue;value",
        "System;Tuple<,,,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Property[System.Tuple<,,,,,,,>.Item3];ReturnValue;value",
        "System;Tuple<,,,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Property[System.Tuple<,,,,,,,>.Item4];ReturnValue;value",
        "System;Tuple<,,,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Property[System.Tuple<,,,,,,,>.Item5];ReturnValue;value",
        "System;Tuple<,,,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Property[System.Tuple<,,,,,,,>.Item6];ReturnValue;value",
        "System;Tuple<,,,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Property[System.Tuple<,,,,,,,>.Item7];ReturnValue;value",
        "System;Tuple<,,,,,,>;false;Tuple;(T1,T2,T3,T4,T5,T6,T7);;Argument[0];ReturnValue.Property[System.Tuple<,,,,,,>.Item1];value",
        "System;Tuple<,,,,,,>;false;Tuple;(T1,T2,T3,T4,T5,T6,T7);;Argument[1];ReturnValue.Property[System.Tuple<,,,,,,>.Item2];value",
        "System;Tuple<,,,,,,>;false;Tuple;(T1,T2,T3,T4,T5,T6,T7);;Argument[2];ReturnValue.Property[System.Tuple<,,,,,,>.Item3];value",
        "System;Tuple<,,,,,,>;false;Tuple;(T1,T2,T3,T4,T5,T6,T7);;Argument[3];ReturnValue.Property[System.Tuple<,,,,,,>.Item4];value",
        "System;Tuple<,,,,,,>;false;Tuple;(T1,T2,T3,T4,T5,T6,T7);;Argument[4];ReturnValue.Property[System.Tuple<,,,,,,>.Item5];value",
        "System;Tuple<,,,,,,>;false;Tuple;(T1,T2,T3,T4,T5,T6,T7);;Argument[5];ReturnValue.Property[System.Tuple<,,,,,,>.Item6];value",
        "System;Tuple<,,,,,,>;false;Tuple;(T1,T2,T3,T4,T5,T6,T7);;Argument[6];ReturnValue.Property[System.Tuple<,,,,,,>.Item7];value",
        "System;Tuple<,,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Property[System.Tuple<,,,,,,>.Item1];ReturnValue;value",
        "System;Tuple<,,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Property[System.Tuple<,,,,,,>.Item2];ReturnValue;value",
        "System;Tuple<,,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Property[System.Tuple<,,,,,,>.Item3];ReturnValue;value",
        "System;Tuple<,,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Property[System.Tuple<,,,,,,>.Item4];ReturnValue;value",
        "System;Tuple<,,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Property[System.Tuple<,,,,,,>.Item5];ReturnValue;value",
        "System;Tuple<,,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Property[System.Tuple<,,,,,,>.Item6];ReturnValue;value",
        "System;Tuple<,,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Property[System.Tuple<,,,,,,>.Item7];ReturnValue;value",
        "System;Tuple<,,,,,>;false;Tuple;(T1,T2,T3,T4,T5,T6);;Argument[0];ReturnValue.Property[System.Tuple<,,,,,>.Item1];value",
        "System;Tuple<,,,,,>;false;Tuple;(T1,T2,T3,T4,T5,T6);;Argument[1];ReturnValue.Property[System.Tuple<,,,,,>.Item2];value",
        "System;Tuple<,,,,,>;false;Tuple;(T1,T2,T3,T4,T5,T6);;Argument[2];ReturnValue.Property[System.Tuple<,,,,,>.Item3];value",
        "System;Tuple<,,,,,>;false;Tuple;(T1,T2,T3,T4,T5,T6);;Argument[3];ReturnValue.Property[System.Tuple<,,,,,>.Item4];value",
        "System;Tuple<,,,,,>;false;Tuple;(T1,T2,T3,T4,T5,T6);;Argument[4];ReturnValue.Property[System.Tuple<,,,,,>.Item5];value",
        "System;Tuple<,,,,,>;false;Tuple;(T1,T2,T3,T4,T5,T6);;Argument[5];ReturnValue.Property[System.Tuple<,,,,,>.Item6];value",
        "System;Tuple<,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Property[System.Tuple<,,,,,>.Item1];ReturnValue;value",
        "System;Tuple<,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Property[System.Tuple<,,,,,>.Item2];ReturnValue;value",
        "System;Tuple<,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Property[System.Tuple<,,,,,>.Item3];ReturnValue;value",
        "System;Tuple<,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Property[System.Tuple<,,,,,>.Item4];ReturnValue;value",
        "System;Tuple<,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Property[System.Tuple<,,,,,>.Item5];ReturnValue;value",
        "System;Tuple<,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Property[System.Tuple<,,,,,>.Item6];ReturnValue;value",
        "System;Tuple<,,,,>;false;Tuple;(T1,T2,T3,T4,T5);;Argument[0];ReturnValue.Property[System.Tuple<,,,,>.Item1];value",
        "System;Tuple<,,,,>;false;Tuple;(T1,T2,T3,T4,T5);;Argument[1];ReturnValue.Property[System.Tuple<,,,,>.Item2];value",
        "System;Tuple<,,,,>;false;Tuple;(T1,T2,T3,T4,T5);;Argument[2];ReturnValue.Property[System.Tuple<,,,,>.Item3];value",
        "System;Tuple<,,,,>;false;Tuple;(T1,T2,T3,T4,T5);;Argument[3];ReturnValue.Property[System.Tuple<,,,,>.Item4];value",
        "System;Tuple<,,,,>;false;Tuple;(T1,T2,T3,T4,T5);;Argument[4];ReturnValue.Property[System.Tuple<,,,,>.Item5];value",
        "System;Tuple<,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Property[System.Tuple<,,,,>.Item1];ReturnValue;value",
        "System;Tuple<,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Property[System.Tuple<,,,,>.Item2];ReturnValue;value",
        "System;Tuple<,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Property[System.Tuple<,,,,>.Item3];ReturnValue;value",
        "System;Tuple<,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Property[System.Tuple<,,,,>.Item4];ReturnValue;value",
        "System;Tuple<,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Property[System.Tuple<,,,,>.Item5];ReturnValue;value",
        "System;Tuple<,,,>;false;Tuple;(T1,T2,T3,T4);;Argument[0];ReturnValue.Property[System.Tuple<,,,>.Item1];value",
        "System;Tuple<,,,>;false;Tuple;(T1,T2,T3,T4);;Argument[1];ReturnValue.Property[System.Tuple<,,,>.Item2];value",
        "System;Tuple<,,,>;false;Tuple;(T1,T2,T3,T4);;Argument[2];ReturnValue.Property[System.Tuple<,,,>.Item3];value",
        "System;Tuple<,,,>;false;Tuple;(T1,T2,T3,T4);;Argument[3];ReturnValue.Property[System.Tuple<,,,>.Item4];value",
        "System;Tuple<,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Property[System.Tuple<,,,>.Item1];ReturnValue;value",
        "System;Tuple<,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Property[System.Tuple<,,,>.Item2];ReturnValue;value",
        "System;Tuple<,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Property[System.Tuple<,,,>.Item3];ReturnValue;value",
        "System;Tuple<,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Property[System.Tuple<,,,>.Item4];ReturnValue;value",
        "System;Tuple<,,>;false;Tuple;(T1,T2,T3);;Argument[0];ReturnValue.Property[System.Tuple<,,>.Item1];value",
        "System;Tuple<,,>;false;Tuple;(T1,T2,T3);;Argument[1];ReturnValue.Property[System.Tuple<,,>.Item2];value",
        "System;Tuple<,,>;false;Tuple;(T1,T2,T3);;Argument[2];ReturnValue.Property[System.Tuple<,,>.Item3];value",
        "System;Tuple<,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Property[System.Tuple<,,>.Item1];ReturnValue;value",
        "System;Tuple<,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Property[System.Tuple<,,>.Item2];ReturnValue;value",
        "System;Tuple<,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Property[System.Tuple<,,>.Item3];ReturnValue;value",
        "System;Tuple<,>;false;Tuple;(T1,T2);;Argument[0];ReturnValue.Property[System.Tuple<,>.Item1];value",
        "System;Tuple<,>;false;Tuple;(T1,T2);;Argument[1];ReturnValue.Property[System.Tuple<,>.Item2];value",
        "System;Tuple<,>;false;get_Item;(System.Int32);;Argument[Qualifier].Property[System.Tuple<,>.Item1];ReturnValue;value",
        "System;Tuple<,>;false;get_Item;(System.Int32);;Argument[Qualifier].Property[System.Tuple<,>.Item2];ReturnValue;value",
        "System;Tuple<>;false;Tuple;(T1);;Argument[0];ReturnValue.Property[System.Tuple<>.Item1];value",
        "System;Tuple<>;false;get_Item;(System.Int32);;Argument[Qualifier].Property[System.Tuple<>.Item1];ReturnValue;value",
      ]
  }
}

/** Data flow for `System.TupleExtensions`. */
private class SystemTupleExtensionsFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16,T17,T18,T19,T20,T21>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16,T17,T18,T19,T20,T21);;Argument[0].Property[System.Tuple<,,,,,,,>.Item1];Argument[1];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16,T17,T18,T19,T20,T21>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16,T17,T18,T19,T20,T21);;Argument[0].Property[System.Tuple<,,,,,,,>.Item2];Argument[2];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16,T17,T18,T19,T20,T21>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16,T17,T18,T19,T20,T21);;Argument[0].Property[System.Tuple<,,,,,,,>.Item3];Argument[3];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16,T17,T18,T19,T20,T21>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16,T17,T18,T19,T20,T21);;Argument[0].Property[System.Tuple<,,,,,,,>.Item4];Argument[4];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16,T17,T18,T19,T20,T21>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16,T17,T18,T19,T20,T21);;Argument[0].Property[System.Tuple<,,,,,,,>.Item5];Argument[5];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16,T17,T18,T19,T20,T21>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16,T17,T18,T19,T20,T21);;Argument[0].Property[System.Tuple<,,,,,,,>.Item6];Argument[6];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16,T17,T18,T19,T20,T21>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16,T17,T18,T19,T20,T21);;Argument[0].Property[System.Tuple<,,,,,,,>.Item7];Argument[7];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16,T17,T18,T19,T20>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16,T17,T18,T19,T20);;Argument[0].Property[System.Tuple<,,,,,,,>.Item1];Argument[1];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16,T17,T18,T19,T20>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16,T17,T18,T19,T20);;Argument[0].Property[System.Tuple<,,,,,,,>.Item2];Argument[2];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16,T17,T18,T19,T20>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16,T17,T18,T19,T20);;Argument[0].Property[System.Tuple<,,,,,,,>.Item3];Argument[3];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16,T17,T18,T19,T20>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16,T17,T18,T19,T20);;Argument[0].Property[System.Tuple<,,,,,,,>.Item4];Argument[4];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16,T17,T18,T19,T20>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16,T17,T18,T19,T20);;Argument[0].Property[System.Tuple<,,,,,,,>.Item5];Argument[5];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16,T17,T18,T19,T20>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16,T17,T18,T19,T20);;Argument[0].Property[System.Tuple<,,,,,,,>.Item6];Argument[6];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16,T17,T18,T19,T20>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16,T17,T18,T19,T20);;Argument[0].Property[System.Tuple<,,,,,,,>.Item7];Argument[7];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16,T17,T18,T19>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16,T17,T18,T19);;Argument[0].Property[System.Tuple<,,,,,,,>.Item1];Argument[1];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16,T17,T18,T19>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16,T17,T18,T19);;Argument[0].Property[System.Tuple<,,,,,,,>.Item2];Argument[2];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16,T17,T18,T19>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16,T17,T18,T19);;Argument[0].Property[System.Tuple<,,,,,,,>.Item3];Argument[3];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16,T17,T18,T19>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16,T17,T18,T19);;Argument[0].Property[System.Tuple<,,,,,,,>.Item4];Argument[4];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16,T17,T18,T19>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16,T17,T18,T19);;Argument[0].Property[System.Tuple<,,,,,,,>.Item5];Argument[5];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16,T17,T18,T19>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16,T17,T18,T19);;Argument[0].Property[System.Tuple<,,,,,,,>.Item6];Argument[6];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16,T17,T18,T19>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16,T17,T18,T19);;Argument[0].Property[System.Tuple<,,,,,,,>.Item7];Argument[7];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16,T17,T18>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16,T17,T18);;Argument[0].Property[System.Tuple<,,,,,,,>.Item1];Argument[1];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16,T17,T18>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16,T17,T18);;Argument[0].Property[System.Tuple<,,,,,,,>.Item2];Argument[2];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16,T17,T18>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16,T17,T18);;Argument[0].Property[System.Tuple<,,,,,,,>.Item3];Argument[3];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16,T17,T18>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16,T17,T18);;Argument[0].Property[System.Tuple<,,,,,,,>.Item4];Argument[4];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16,T17,T18>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16,T17,T18);;Argument[0].Property[System.Tuple<,,,,,,,>.Item5];Argument[5];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16,T17,T18>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16,T17,T18);;Argument[0].Property[System.Tuple<,,,,,,,>.Item6];Argument[6];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16,T17,T18>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16,T17,T18);;Argument[0].Property[System.Tuple<,,,,,,,>.Item7];Argument[7];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16,T17>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16,T17);;Argument[0].Property[System.Tuple<,,,,,,,>.Item1];Argument[1];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16,T17>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16,T17);;Argument[0].Property[System.Tuple<,,,,,,,>.Item2];Argument[2];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16,T17>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16,T17);;Argument[0].Property[System.Tuple<,,,,,,,>.Item3];Argument[3];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16,T17>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16,T17);;Argument[0].Property[System.Tuple<,,,,,,,>.Item4];Argument[4];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16,T17>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16,T17);;Argument[0].Property[System.Tuple<,,,,,,,>.Item5];Argument[5];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16,T17>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16,T17);;Argument[0].Property[System.Tuple<,,,,,,,>.Item6];Argument[6];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16,T17>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16,T17);;Argument[0].Property[System.Tuple<,,,,,,,>.Item7];Argument[7];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16);;Argument[0].Property[System.Tuple<,,,,,,,>.Item1];Argument[1];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16);;Argument[0].Property[System.Tuple<,,,,,,,>.Item2];Argument[2];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16);;Argument[0].Property[System.Tuple<,,,,,,,>.Item3];Argument[3];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16);;Argument[0].Property[System.Tuple<,,,,,,,>.Item4];Argument[4];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16);;Argument[0].Property[System.Tuple<,,,,,,,>.Item5];Argument[5];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16);;Argument[0].Property[System.Tuple<,,,,,,,>.Item6];Argument[6];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15,T16>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16);;Argument[0].Property[System.Tuple<,,,,,,,>.Item7];Argument[7];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15);;Argument[0].Property[System.Tuple<,,,,,,,>.Item1];Argument[1];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15);;Argument[0].Property[System.Tuple<,,,,,,,>.Item2];Argument[2];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15);;Argument[0].Property[System.Tuple<,,,,,,,>.Item3];Argument[3];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15);;Argument[0].Property[System.Tuple<,,,,,,,>.Item4];Argument[4];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15);;Argument[0].Property[System.Tuple<,,,,,,,>.Item5];Argument[5];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15);;Argument[0].Property[System.Tuple<,,,,,,,>.Item6];Argument[6];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14,System.Tuple<T15>>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15);;Argument[0].Property[System.Tuple<,,,,,,,>.Item7];Argument[7];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14);;Argument[0].Property[System.Tuple<,,,,,,,>.Item1];Argument[1];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14);;Argument[0].Property[System.Tuple<,,,,,,,>.Item2];Argument[2];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14);;Argument[0].Property[System.Tuple<,,,,,,,>.Item3];Argument[3];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14);;Argument[0].Property[System.Tuple<,,,,,,,>.Item4];Argument[4];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14);;Argument[0].Property[System.Tuple<,,,,,,,>.Item5];Argument[5];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14);;Argument[0].Property[System.Tuple<,,,,,,,>.Item6];Argument[6];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13,T14>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14);;Argument[0].Property[System.Tuple<,,,,,,,>.Item7];Argument[7];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13);;Argument[0].Property[System.Tuple<,,,,,,,>.Item1];Argument[1];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13);;Argument[0].Property[System.Tuple<,,,,,,,>.Item2];Argument[2];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13);;Argument[0].Property[System.Tuple<,,,,,,,>.Item3];Argument[3];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13);;Argument[0].Property[System.Tuple<,,,,,,,>.Item4];Argument[4];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13);;Argument[0].Property[System.Tuple<,,,,,,,>.Item5];Argument[5];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13);;Argument[0].Property[System.Tuple<,,,,,,,>.Item6];Argument[6];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12,T13>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13);;Argument[0].Property[System.Tuple<,,,,,,,>.Item7];Argument[7];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12);;Argument[0].Property[System.Tuple<,,,,,,,>.Item1];Argument[1];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12);;Argument[0].Property[System.Tuple<,,,,,,,>.Item2];Argument[2];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12);;Argument[0].Property[System.Tuple<,,,,,,,>.Item3];Argument[3];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12);;Argument[0].Property[System.Tuple<,,,,,,,>.Item4];Argument[4];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12);;Argument[0].Property[System.Tuple<,,,,,,,>.Item5];Argument[5];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12);;Argument[0].Property[System.Tuple<,,,,,,,>.Item6];Argument[6];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11,T12>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12);;Argument[0].Property[System.Tuple<,,,,,,,>.Item7];Argument[7];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11);;Argument[0].Property[System.Tuple<,,,,,,,>.Item1];Argument[1];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11);;Argument[0].Property[System.Tuple<,,,,,,,>.Item2];Argument[2];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11);;Argument[0].Property[System.Tuple<,,,,,,,>.Item3];Argument[3];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11);;Argument[0].Property[System.Tuple<,,,,,,,>.Item4];Argument[4];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11);;Argument[0].Property[System.Tuple<,,,,,,,>.Item5];Argument[5];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11);;Argument[0].Property[System.Tuple<,,,,,,,>.Item6];Argument[6];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10,T11>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11);;Argument[0].Property[System.Tuple<,,,,,,,>.Item7];Argument[7];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10);;Argument[0].Property[System.Tuple<,,,,,,,>.Item1];Argument[1];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10);;Argument[0].Property[System.Tuple<,,,,,,,>.Item2];Argument[2];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10);;Argument[0].Property[System.Tuple<,,,,,,,>.Item3];Argument[3];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10);;Argument[0].Property[System.Tuple<,,,,,,,>.Item4];Argument[4];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10);;Argument[0].Property[System.Tuple<,,,,,,,>.Item5];Argument[5];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10);;Argument[0].Property[System.Tuple<,,,,,,,>.Item6];Argument[6];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9,T10>>,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10);;Argument[0].Property[System.Tuple<,,,,,,,>.Item7];Argument[7];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9>>,T1,T2,T3,T4,T5,T6,T7,T8,T9);;Argument[0].Property[System.Tuple<,,,,,,,>.Item1];Argument[1];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9>>,T1,T2,T3,T4,T5,T6,T7,T8,T9);;Argument[0].Property[System.Tuple<,,,,,,,>.Item2];Argument[2];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9>>,T1,T2,T3,T4,T5,T6,T7,T8,T9);;Argument[0].Property[System.Tuple<,,,,,,,>.Item3];Argument[3];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9>>,T1,T2,T3,T4,T5,T6,T7,T8,T9);;Argument[0].Property[System.Tuple<,,,,,,,>.Item4];Argument[4];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9>>,T1,T2,T3,T4,T5,T6,T7,T8,T9);;Argument[0].Property[System.Tuple<,,,,,,,>.Item5];Argument[5];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9>>,T1,T2,T3,T4,T5,T6,T7,T8,T9);;Argument[0].Property[System.Tuple<,,,,,,,>.Item6];Argument[6];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8,T9>>,T1,T2,T3,T4,T5,T6,T7,T8,T9);;Argument[0].Property[System.Tuple<,,,,,,,>.Item7];Argument[7];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8>>,T1,T2,T3,T4,T5,T6,T7,T8);;Argument[0].Property[System.Tuple<,,,,,,,>.Item1];Argument[1];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8>>,T1,T2,T3,T4,T5,T6,T7,T8);;Argument[0].Property[System.Tuple<,,,,,,,>.Item2];Argument[2];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8>>,T1,T2,T3,T4,T5,T6,T7,T8);;Argument[0].Property[System.Tuple<,,,,,,,>.Item3];Argument[3];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8>>,T1,T2,T3,T4,T5,T6,T7,T8);;Argument[0].Property[System.Tuple<,,,,,,,>.Item4];Argument[4];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8>>,T1,T2,T3,T4,T5,T6,T7,T8);;Argument[0].Property[System.Tuple<,,,,,,,>.Item5];Argument[5];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8>>,T1,T2,T3,T4,T5,T6,T7,T8);;Argument[0].Property[System.Tuple<,,,,,,,>.Item6];Argument[6];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7,System.Tuple<T8>>,T1,T2,T3,T4,T5,T6,T7,T8);;Argument[0].Property[System.Tuple<,,,,,,,>.Item7];Argument[7];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7>,T1,T2,T3,T4,T5,T6,T7);;Argument[0].Property[System.Tuple<,,,,,,>.Item1];Argument[1];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7>,T1,T2,T3,T4,T5,T6,T7);;Argument[0].Property[System.Tuple<,,,,,,>.Item2];Argument[2];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7>,T1,T2,T3,T4,T5,T6,T7);;Argument[0].Property[System.Tuple<,,,,,,>.Item3];Argument[3];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7>,T1,T2,T3,T4,T5,T6,T7);;Argument[0].Property[System.Tuple<,,,,,,>.Item4];Argument[4];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7>,T1,T2,T3,T4,T5,T6,T7);;Argument[0].Property[System.Tuple<,,,,,,>.Item5];Argument[5];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7>,T1,T2,T3,T4,T5,T6,T7);;Argument[0].Property[System.Tuple<,,,,,,>.Item6];Argument[6];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6,T7>,T1,T2,T3,T4,T5,T6,T7);;Argument[0].Property[System.Tuple<,,,,,,>.Item7];Argument[7];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6>,T1,T2,T3,T4,T5,T6);;Argument[0].Property[System.Tuple<,,,,,>.Item1];Argument[1];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6>,T1,T2,T3,T4,T5,T6);;Argument[0].Property[System.Tuple<,,,,,>.Item2];Argument[2];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6>,T1,T2,T3,T4,T5,T6);;Argument[0].Property[System.Tuple<,,,,,>.Item3];Argument[3];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6>,T1,T2,T3,T4,T5,T6);;Argument[0].Property[System.Tuple<,,,,,>.Item4];Argument[4];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6>,T1,T2,T3,T4,T5,T6);;Argument[0].Property[System.Tuple<,,,,,>.Item5];Argument[5];value",
        "System;TupleExtensions;false;Deconstruct<,,,,,>;(System.Tuple<T1,T2,T3,T4,T5,T6>,T1,T2,T3,T4,T5,T6);;Argument[0].Property[System.Tuple<,,,,,>.Item6];Argument[6];value",
        "System;TupleExtensions;false;Deconstruct<,,,,>;(System.Tuple<T1,T2,T3,T4,T5>,T1,T2,T3,T4,T5);;Argument[0].Property[System.Tuple<,,,,>.Item1];Argument[1];value",
        "System;TupleExtensions;false;Deconstruct<,,,,>;(System.Tuple<T1,T2,T3,T4,T5>,T1,T2,T3,T4,T5);;Argument[0].Property[System.Tuple<,,,,>.Item2];Argument[2];value",
        "System;TupleExtensions;false;Deconstruct<,,,,>;(System.Tuple<T1,T2,T3,T4,T5>,T1,T2,T3,T4,T5);;Argument[0].Property[System.Tuple<,,,,>.Item3];Argument[3];value",
        "System;TupleExtensions;false;Deconstruct<,,,,>;(System.Tuple<T1,T2,T3,T4,T5>,T1,T2,T3,T4,T5);;Argument[0].Property[System.Tuple<,,,,>.Item4];Argument[4];value",
        "System;TupleExtensions;false;Deconstruct<,,,,>;(System.Tuple<T1,T2,T3,T4,T5>,T1,T2,T3,T4,T5);;Argument[0].Property[System.Tuple<,,,,>.Item5];Argument[5];value",
        "System;TupleExtensions;false;Deconstruct<,,,>;(System.Tuple<T1,T2,T3,T4>,T1,T2,T3,T4);;Argument[0].Property[System.Tuple<,,,>.Item1];Argument[1];value",
        "System;TupleExtensions;false;Deconstruct<,,,>;(System.Tuple<T1,T2,T3,T4>,T1,T2,T3,T4);;Argument[0].Property[System.Tuple<,,,>.Item2];Argument[2];value",
        "System;TupleExtensions;false;Deconstruct<,,,>;(System.Tuple<T1,T2,T3,T4>,T1,T2,T3,T4);;Argument[0].Property[System.Tuple<,,,>.Item3];Argument[3];value",
        "System;TupleExtensions;false;Deconstruct<,,,>;(System.Tuple<T1,T2,T3,T4>,T1,T2,T3,T4);;Argument[0].Property[System.Tuple<,,,>.Item4];Argument[4];value",
        "System;TupleExtensions;false;Deconstruct<,,>;(System.Tuple<T1,T2,T3>,T1,T2,T3);;Argument[0].Property[System.Tuple<,,>.Item1];Argument[1];value",
        "System;TupleExtensions;false;Deconstruct<,,>;(System.Tuple<T1,T2,T3>,T1,T2,T3);;Argument[0].Property[System.Tuple<,,>.Item2];Argument[2];value",
        "System;TupleExtensions;false;Deconstruct<,,>;(System.Tuple<T1,T2,T3>,T1,T2,T3);;Argument[0].Property[System.Tuple<,,>.Item3];Argument[3];value",
        "System;TupleExtensions;false;Deconstruct<,>;(System.Tuple<T1,T2>,T1,T2);;Argument[0].Property[System.Tuple<,>.Item1];Argument[1];value",
        "System;TupleExtensions;false;Deconstruct<,>;(System.Tuple<T1,T2>,T1,T2);;Argument[0].Property[System.Tuple<,>.Item2];Argument[2];value",
        "System;TupleExtensions;false;Deconstruct<>;(System.Tuple<T1>,T1);;Argument[0].Property[System.Tuple<>.Item1];Argument[1];value",
      ]
  }
}

/** Data flow for `System.ValueTuple`. */
private class SystemValueTupleFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System;ValueTuple;false;Create<,,,,,,,>;(T1,T2,T3,T4,T5,T6,T7,T8);;Argument[0];ReturnValue.Field[System.ValueTuple<,,,,,,,>.Item1];value",
        "System;ValueTuple;false;Create<,,,,,,,>;(T1,T2,T3,T4,T5,T6,T7,T8);;Argument[1];ReturnValue.Field[System.ValueTuple<,,,,,,,>.Item2];value",
        "System;ValueTuple;false;Create<,,,,,,,>;(T1,T2,T3,T4,T5,T6,T7,T8);;Argument[2];ReturnValue.Field[System.ValueTuple<,,,,,,,>.Item3];value",
        "System;ValueTuple;false;Create<,,,,,,,>;(T1,T2,T3,T4,T5,T6,T7,T8);;Argument[3];ReturnValue.Field[System.ValueTuple<,,,,,,,>.Item4];value",
        "System;ValueTuple;false;Create<,,,,,,,>;(T1,T2,T3,T4,T5,T6,T7,T8);;Argument[4];ReturnValue.Field[System.ValueTuple<,,,,,,,>.Item5];value",
        "System;ValueTuple;false;Create<,,,,,,,>;(T1,T2,T3,T4,T5,T6,T7,T8);;Argument[5];ReturnValue.Field[System.ValueTuple<,,,,,,,>.Item6];value",
        "System;ValueTuple;false;Create<,,,,,,,>;(T1,T2,T3,T4,T5,T6,T7,T8);;Argument[6];ReturnValue.Field[System.ValueTuple<,,,,,,,>.Item7];value",
        "System;ValueTuple;false;Create<,,,,,,>;(T1,T2,T3,T4,T5,T6,T7);;Argument[0];ReturnValue.Field[System.ValueTuple<,,,,,,>.Item1];value",
        "System;ValueTuple;false;Create<,,,,,,>;(T1,T2,T3,T4,T5,T6,T7);;Argument[1];ReturnValue.Field[System.ValueTuple<,,,,,,>.Item2];value",
        "System;ValueTuple;false;Create<,,,,,,>;(T1,T2,T3,T4,T5,T6,T7);;Argument[2];ReturnValue.Field[System.ValueTuple<,,,,,,>.Item3];value",
        "System;ValueTuple;false;Create<,,,,,,>;(T1,T2,T3,T4,T5,T6,T7);;Argument[3];ReturnValue.Field[System.ValueTuple<,,,,,,>.Item4];value",
        "System;ValueTuple;false;Create<,,,,,,>;(T1,T2,T3,T4,T5,T6,T7);;Argument[4];ReturnValue.Field[System.ValueTuple<,,,,,,>.Item5];value",
        "System;ValueTuple;false;Create<,,,,,,>;(T1,T2,T3,T4,T5,T6,T7);;Argument[5];ReturnValue.Field[System.ValueTuple<,,,,,,>.Item6];value",
        "System;ValueTuple;false;Create<,,,,,,>;(T1,T2,T3,T4,T5,T6,T7);;Argument[6];ReturnValue.Field[System.ValueTuple<,,,,,,>.Item7];value",
        "System;ValueTuple;false;Create<,,,,,>;(T1,T2,T3,T4,T5,T6);;Argument[0];ReturnValue.Field[System.ValueTuple<,,,,,>.Item1];value",
        "System;ValueTuple;false;Create<,,,,,>;(T1,T2,T3,T4,T5,T6);;Argument[1];ReturnValue.Field[System.ValueTuple<,,,,,>.Item2];value",
        "System;ValueTuple;false;Create<,,,,,>;(T1,T2,T3,T4,T5,T6);;Argument[2];ReturnValue.Field[System.ValueTuple<,,,,,>.Item3];value",
        "System;ValueTuple;false;Create<,,,,,>;(T1,T2,T3,T4,T5,T6);;Argument[3];ReturnValue.Field[System.ValueTuple<,,,,,>.Item4];value",
        "System;ValueTuple;false;Create<,,,,,>;(T1,T2,T3,T4,T5,T6);;Argument[4];ReturnValue.Field[System.ValueTuple<,,,,,>.Item5];value",
        "System;ValueTuple;false;Create<,,,,,>;(T1,T2,T3,T4,T5,T6);;Argument[5];ReturnValue.Field[System.ValueTuple<,,,,,>.Item6];value",
        "System;ValueTuple;false;Create<,,,,>;(T1,T2,T3,T4,T5);;Argument[0];ReturnValue.Field[System.ValueTuple<,,,,>.Item1];value",
        "System;ValueTuple;false;Create<,,,,>;(T1,T2,T3,T4,T5);;Argument[1];ReturnValue.Field[System.ValueTuple<,,,,>.Item2];value",
        "System;ValueTuple;false;Create<,,,,>;(T1,T2,T3,T4,T5);;Argument[2];ReturnValue.Field[System.ValueTuple<,,,,>.Item3];value",
        "System;ValueTuple;false;Create<,,,,>;(T1,T2,T3,T4,T5);;Argument[3];ReturnValue.Field[System.ValueTuple<,,,,>.Item4];value",
        "System;ValueTuple;false;Create<,,,,>;(T1,T2,T3,T4,T5);;Argument[4];ReturnValue.Field[System.ValueTuple<,,,,>.Item5];value",
        "System;ValueTuple;false;Create<,,,>;(T1,T2,T3,T4);;Argument[0];ReturnValue.Field[System.ValueTuple<,,,>.Item1];value",
        "System;ValueTuple;false;Create<,,,>;(T1,T2,T3,T4);;Argument[1];ReturnValue.Field[System.ValueTuple<,,,>.Item2];value",
        "System;ValueTuple;false;Create<,,,>;(T1,T2,T3,T4);;Argument[2];ReturnValue.Field[System.ValueTuple<,,,>.Item3];value",
        "System;ValueTuple;false;Create<,,,>;(T1,T2,T3,T4);;Argument[3];ReturnValue.Field[System.ValueTuple<,,,>.Item4];value",
        "System;ValueTuple;false;Create<,,>;(T1,T2,T3);;Argument[0];ReturnValue.Field[System.ValueTuple<,,>.Item1];value",
        "System;ValueTuple;false;Create<,,>;(T1,T2,T3);;Argument[1];ReturnValue.Field[System.ValueTuple<,,>.Item2];value",
        "System;ValueTuple;false;Create<,,>;(T1,T2,T3);;Argument[2];ReturnValue.Field[System.ValueTuple<,,>.Item3];value",
        "System;ValueTuple;false;Create<,>;(T1,T2);;Argument[0];ReturnValue.Field[System.ValueTuple<,>.Item1];value",
        "System;ValueTuple;false;Create<,>;(T1,T2);;Argument[1];ReturnValue.Field[System.ValueTuple<,>.Item2];value",
        "System;ValueTuple;false;Create<>;(T1);;Argument[0];ReturnValue.Field[System.ValueTuple<>.Item1];value",
      ]
  }
}

/** Data flow for System.ValueTuple<,*>. */
private class SystemValueTupleTFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System;ValueTuple<,,,,,,,>;false;ValueTuple;(T1,T2,T3,T4,T5,T6,T7,TRest);;Argument[0];ReturnValue.Field[System.ValueTuple<,,,,,,,>.Item1];value",
        "System;ValueTuple<,,,,,,,>;false;ValueTuple;(T1,T2,T3,T4,T5,T6,T7,TRest);;Argument[1];ReturnValue.Field[System.ValueTuple<,,,,,,,>.Item2];value",
        "System;ValueTuple<,,,,,,,>;false;ValueTuple;(T1,T2,T3,T4,T5,T6,T7,TRest);;Argument[2];ReturnValue.Field[System.ValueTuple<,,,,,,,>.Item3];value",
        "System;ValueTuple<,,,,,,,>;false;ValueTuple;(T1,T2,T3,T4,T5,T6,T7,TRest);;Argument[3];ReturnValue.Field[System.ValueTuple<,,,,,,,>.Item4];value",
        "System;ValueTuple<,,,,,,,>;false;ValueTuple;(T1,T2,T3,T4,T5,T6,T7,TRest);;Argument[4];ReturnValue.Field[System.ValueTuple<,,,,,,,>.Item5];value",
        "System;ValueTuple<,,,,,,,>;false;ValueTuple;(T1,T2,T3,T4,T5,T6,T7,TRest);;Argument[5];ReturnValue.Field[System.ValueTuple<,,,,,,,>.Item6];value",
        "System;ValueTuple<,,,,,,,>;false;ValueTuple;(T1,T2,T3,T4,T5,T6,T7,TRest);;Argument[6];ReturnValue.Field[System.ValueTuple<,,,,,,,>.Item7];value",
        "System;ValueTuple<,,,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Field[System.ValueTuple<,,,,,,,>.Item1];ReturnValue;value",
        "System;ValueTuple<,,,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Field[System.ValueTuple<,,,,,,,>.Item2];ReturnValue;value",
        "System;ValueTuple<,,,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Field[System.ValueTuple<,,,,,,,>.Item3];ReturnValue;value",
        "System;ValueTuple<,,,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Field[System.ValueTuple<,,,,,,,>.Item4];ReturnValue;value",
        "System;ValueTuple<,,,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Field[System.ValueTuple<,,,,,,,>.Item5];ReturnValue;value",
        "System;ValueTuple<,,,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Field[System.ValueTuple<,,,,,,,>.Item6];ReturnValue;value",
        "System;ValueTuple<,,,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Field[System.ValueTuple<,,,,,,,>.Item7];ReturnValue;value",
        "System;ValueTuple<,,,,,,>;false;ValueTuple;(T1,T2,T3,T4,T5,T6,T7);;Argument[0];ReturnValue.Field[System.ValueTuple<,,,,,,>.Item1];value",
        "System;ValueTuple<,,,,,,>;false;ValueTuple;(T1,T2,T3,T4,T5,T6,T7);;Argument[1];ReturnValue.Field[System.ValueTuple<,,,,,,>.Item2];value",
        "System;ValueTuple<,,,,,,>;false;ValueTuple;(T1,T2,T3,T4,T5,T6,T7);;Argument[2];ReturnValue.Field[System.ValueTuple<,,,,,,>.Item3];value",
        "System;ValueTuple<,,,,,,>;false;ValueTuple;(T1,T2,T3,T4,T5,T6,T7);;Argument[3];ReturnValue.Field[System.ValueTuple<,,,,,,>.Item4];value",
        "System;ValueTuple<,,,,,,>;false;ValueTuple;(T1,T2,T3,T4,T5,T6,T7);;Argument[4];ReturnValue.Field[System.ValueTuple<,,,,,,>.Item5];value",
        "System;ValueTuple<,,,,,,>;false;ValueTuple;(T1,T2,T3,T4,T5,T6,T7);;Argument[5];ReturnValue.Field[System.ValueTuple<,,,,,,>.Item6];value",
        "System;ValueTuple<,,,,,,>;false;ValueTuple;(T1,T2,T3,T4,T5,T6,T7);;Argument[6];ReturnValue.Field[System.ValueTuple<,,,,,,>.Item7];value",
        "System;ValueTuple<,,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Field[System.ValueTuple<,,,,,,>.Item1];ReturnValue;value",
        "System;ValueTuple<,,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Field[System.ValueTuple<,,,,,,>.Item2];ReturnValue;value",
        "System;ValueTuple<,,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Field[System.ValueTuple<,,,,,,>.Item3];ReturnValue;value",
        "System;ValueTuple<,,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Field[System.ValueTuple<,,,,,,>.Item4];ReturnValue;value",
        "System;ValueTuple<,,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Field[System.ValueTuple<,,,,,,>.Item5];ReturnValue;value",
        "System;ValueTuple<,,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Field[System.ValueTuple<,,,,,,>.Item6];ReturnValue;value",
        "System;ValueTuple<,,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Field[System.ValueTuple<,,,,,,>.Item7];ReturnValue;value",
        "System;ValueTuple<,,,,,>;false;ValueTuple;(T1,T2,T3,T4,T5,T6);;Argument[0];ReturnValue.Field[System.ValueTuple<,,,,,>.Item1];value",
        "System;ValueTuple<,,,,,>;false;ValueTuple;(T1,T2,T3,T4,T5,T6);;Argument[1];ReturnValue.Field[System.ValueTuple<,,,,,>.Item2];value",
        "System;ValueTuple<,,,,,>;false;ValueTuple;(T1,T2,T3,T4,T5,T6);;Argument[2];ReturnValue.Field[System.ValueTuple<,,,,,>.Item3];value",
        "System;ValueTuple<,,,,,>;false;ValueTuple;(T1,T2,T3,T4,T5,T6);;Argument[3];ReturnValue.Field[System.ValueTuple<,,,,,>.Item4];value",
        "System;ValueTuple<,,,,,>;false;ValueTuple;(T1,T2,T3,T4,T5,T6);;Argument[4];ReturnValue.Field[System.ValueTuple<,,,,,>.Item5];value",
        "System;ValueTuple<,,,,,>;false;ValueTuple;(T1,T2,T3,T4,T5,T6);;Argument[5];ReturnValue.Field[System.ValueTuple<,,,,,>.Item6];value",
        "System;ValueTuple<,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Field[System.ValueTuple<,,,,,>.Item1];ReturnValue;value",
        "System;ValueTuple<,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Field[System.ValueTuple<,,,,,>.Item2];ReturnValue;value",
        "System;ValueTuple<,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Field[System.ValueTuple<,,,,,>.Item3];ReturnValue;value",
        "System;ValueTuple<,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Field[System.ValueTuple<,,,,,>.Item4];ReturnValue;value",
        "System;ValueTuple<,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Field[System.ValueTuple<,,,,,>.Item5];ReturnValue;value",
        "System;ValueTuple<,,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Field[System.ValueTuple<,,,,,>.Item6];ReturnValue;value",
        "System;ValueTuple<,,,,>;false;ValueTuple;(T1,T2,T3,T4,T5);;Argument[0];ReturnValue.Field[System.ValueTuple<,,,,>.Item1];value",
        "System;ValueTuple<,,,,>;false;ValueTuple;(T1,T2,T3,T4,T5);;Argument[1];ReturnValue.Field[System.ValueTuple<,,,,>.Item2];value",
        "System;ValueTuple<,,,,>;false;ValueTuple;(T1,T2,T3,T4,T5);;Argument[2];ReturnValue.Field[System.ValueTuple<,,,,>.Item3];value",
        "System;ValueTuple<,,,,>;false;ValueTuple;(T1,T2,T3,T4,T5);;Argument[3];ReturnValue.Field[System.ValueTuple<,,,,>.Item4];value",
        "System;ValueTuple<,,,,>;false;ValueTuple;(T1,T2,T3,T4,T5);;Argument[4];ReturnValue.Field[System.ValueTuple<,,,,>.Item5];value",
        "System;ValueTuple<,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Field[System.ValueTuple<,,,,>.Item1];ReturnValue;value",
        "System;ValueTuple<,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Field[System.ValueTuple<,,,,>.Item2];ReturnValue;value",
        "System;ValueTuple<,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Field[System.ValueTuple<,,,,>.Item3];ReturnValue;value",
        "System;ValueTuple<,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Field[System.ValueTuple<,,,,>.Item4];ReturnValue;value",
        "System;ValueTuple<,,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Field[System.ValueTuple<,,,,>.Item5];ReturnValue;value",
        "System;ValueTuple<,,,>;false;ValueTuple;(T1,T2,T3,T4);;Argument[0];ReturnValue.Field[System.ValueTuple<,,,>.Item1];value",
        "System;ValueTuple<,,,>;false;ValueTuple;(T1,T2,T3,T4);;Argument[1];ReturnValue.Field[System.ValueTuple<,,,>.Item2];value",
        "System;ValueTuple<,,,>;false;ValueTuple;(T1,T2,T3,T4);;Argument[2];ReturnValue.Field[System.ValueTuple<,,,>.Item3];value",
        "System;ValueTuple<,,,>;false;ValueTuple;(T1,T2,T3,T4);;Argument[3];ReturnValue.Field[System.ValueTuple<,,,>.Item4];value",
        "System;ValueTuple<,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Field[System.ValueTuple<,,,>.Item1];ReturnValue;value",
        "System;ValueTuple<,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Field[System.ValueTuple<,,,>.Item2];ReturnValue;value",
        "System;ValueTuple<,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Field[System.ValueTuple<,,,>.Item3];ReturnValue;value",
        "System;ValueTuple<,,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Field[System.ValueTuple<,,,>.Item4];ReturnValue;value",
        "System;ValueTuple<,,>;false;ValueTuple;(T1,T2,T3);;Argument[0];ReturnValue.Field[System.ValueTuple<,,>.Item1];value",
        "System;ValueTuple<,,>;false;ValueTuple;(T1,T2,T3);;Argument[1];ReturnValue.Field[System.ValueTuple<,,>.Item2];value",
        "System;ValueTuple<,,>;false;ValueTuple;(T1,T2,T3);;Argument[2];ReturnValue.Field[System.ValueTuple<,,>.Item3];value",
        "System;ValueTuple<,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Field[System.ValueTuple<,,>.Item1];ReturnValue;value",
        "System;ValueTuple<,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Field[System.ValueTuple<,,>.Item2];ReturnValue;value",
        "System;ValueTuple<,,>;false;get_Item;(System.Int32);;Argument[Qualifier].Field[System.ValueTuple<,,>.Item3];ReturnValue;value",
        "System;ValueTuple<,>;false;ValueTuple;(T1,T2);;Argument[0];ReturnValue.Field[System.ValueTuple<,>.Item1];value",
        "System;ValueTuple<,>;false;ValueTuple;(T1,T2);;Argument[1];ReturnValue.Field[System.ValueTuple<,>.Item2];value",
        "System;ValueTuple<,>;false;get_Item;(System.Int32);;Argument[Qualifier].Field[System.ValueTuple<,>.Item1];ReturnValue;value",
        "System;ValueTuple<,>;false;get_Item;(System.Int32);;Argument[Qualifier].Field[System.ValueTuple<,>.Item2];ReturnValue;value",
        "System;ValueTuple<>;false;ValueTuple;(T1);;Argument[0];ReturnValue.Field[System.ValueTuple<>.Item1];value",
        "System;ValueTuple<>;false;get_Item;(System.Int32);;Argument[Qualifier].Field[System.ValueTuple<>.Item1];ReturnValue;value",
      ]
  }
}
