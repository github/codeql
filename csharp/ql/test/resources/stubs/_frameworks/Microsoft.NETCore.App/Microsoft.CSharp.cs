// This file contains auto-generated code.

namespace Microsoft
{
    namespace CSharp
    {
        namespace RuntimeBinder
        {
            // Generated from `Microsoft.CSharp.RuntimeBinder.Binder` in `Microsoft.CSharp, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class Binder
            {
                public static System.Runtime.CompilerServices.CallSiteBinder BinaryOperation(Microsoft.CSharp.RuntimeBinder.CSharpBinderFlags flags, System.Linq.Expressions.ExpressionType operation, System.Type context, System.Collections.Generic.IEnumerable<Microsoft.CSharp.RuntimeBinder.CSharpArgumentInfo> argumentInfo) => throw null;
                public static System.Runtime.CompilerServices.CallSiteBinder Convert(Microsoft.CSharp.RuntimeBinder.CSharpBinderFlags flags, System.Type type, System.Type context) => throw null;
                public static System.Runtime.CompilerServices.CallSiteBinder GetIndex(Microsoft.CSharp.RuntimeBinder.CSharpBinderFlags flags, System.Type context, System.Collections.Generic.IEnumerable<Microsoft.CSharp.RuntimeBinder.CSharpArgumentInfo> argumentInfo) => throw null;
                public static System.Runtime.CompilerServices.CallSiteBinder GetMember(Microsoft.CSharp.RuntimeBinder.CSharpBinderFlags flags, string name, System.Type context, System.Collections.Generic.IEnumerable<Microsoft.CSharp.RuntimeBinder.CSharpArgumentInfo> argumentInfo) => throw null;
                public static System.Runtime.CompilerServices.CallSiteBinder Invoke(Microsoft.CSharp.RuntimeBinder.CSharpBinderFlags flags, System.Type context, System.Collections.Generic.IEnumerable<Microsoft.CSharp.RuntimeBinder.CSharpArgumentInfo> argumentInfo) => throw null;
                public static System.Runtime.CompilerServices.CallSiteBinder InvokeConstructor(Microsoft.CSharp.RuntimeBinder.CSharpBinderFlags flags, System.Type context, System.Collections.Generic.IEnumerable<Microsoft.CSharp.RuntimeBinder.CSharpArgumentInfo> argumentInfo) => throw null;
                public static System.Runtime.CompilerServices.CallSiteBinder InvokeMember(Microsoft.CSharp.RuntimeBinder.CSharpBinderFlags flags, string name, System.Collections.Generic.IEnumerable<System.Type> typeArguments, System.Type context, System.Collections.Generic.IEnumerable<Microsoft.CSharp.RuntimeBinder.CSharpArgumentInfo> argumentInfo) => throw null;
                public static System.Runtime.CompilerServices.CallSiteBinder IsEvent(Microsoft.CSharp.RuntimeBinder.CSharpBinderFlags flags, string name, System.Type context) => throw null;
                public static System.Runtime.CompilerServices.CallSiteBinder SetIndex(Microsoft.CSharp.RuntimeBinder.CSharpBinderFlags flags, System.Type context, System.Collections.Generic.IEnumerable<Microsoft.CSharp.RuntimeBinder.CSharpArgumentInfo> argumentInfo) => throw null;
                public static System.Runtime.CompilerServices.CallSiteBinder SetMember(Microsoft.CSharp.RuntimeBinder.CSharpBinderFlags flags, string name, System.Type context, System.Collections.Generic.IEnumerable<Microsoft.CSharp.RuntimeBinder.CSharpArgumentInfo> argumentInfo) => throw null;
                public static System.Runtime.CompilerServices.CallSiteBinder UnaryOperation(Microsoft.CSharp.RuntimeBinder.CSharpBinderFlags flags, System.Linq.Expressions.ExpressionType operation, System.Type context, System.Collections.Generic.IEnumerable<Microsoft.CSharp.RuntimeBinder.CSharpArgumentInfo> argumentInfo) => throw null;
            }

            // Generated from `Microsoft.CSharp.RuntimeBinder.CSharpArgumentInfo` in `Microsoft.CSharp, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class CSharpArgumentInfo
            {
                public static Microsoft.CSharp.RuntimeBinder.CSharpArgumentInfo Create(Microsoft.CSharp.RuntimeBinder.CSharpArgumentInfoFlags flags, string name) => throw null;
            }

            // Generated from `Microsoft.CSharp.RuntimeBinder.CSharpArgumentInfoFlags` in `Microsoft.CSharp, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum CSharpArgumentInfoFlags
            {
                Constant,
                IsOut,
                IsRef,
                IsStaticType,
                NamedArgument,
                None,
                UseCompileTimeType,
            }

            // Generated from `Microsoft.CSharp.RuntimeBinder.CSharpBinderFlags` in `Microsoft.CSharp, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum CSharpBinderFlags
            {
                BinaryOperationLogical,
                CheckedContext,
                ConvertArrayIndex,
                ConvertExplicit,
                InvokeSimpleName,
                InvokeSpecialName,
                None,
                ResultDiscarded,
                ResultIndexed,
                ValueFromCompoundAssignment,
            }

            // Generated from `Microsoft.CSharp.RuntimeBinder.RuntimeBinderException` in `Microsoft.CSharp, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class RuntimeBinderException : System.Exception
            {
                public RuntimeBinderException() => throw null;
                protected RuntimeBinderException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public RuntimeBinderException(string message) => throw null;
                public RuntimeBinderException(string message, System.Exception innerException) => throw null;
            }

            // Generated from `Microsoft.CSharp.RuntimeBinder.RuntimeBinderInternalCompilerException` in `Microsoft.CSharp, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class RuntimeBinderInternalCompilerException : System.Exception
            {
                public RuntimeBinderInternalCompilerException() => throw null;
                protected RuntimeBinderInternalCompilerException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public RuntimeBinderInternalCompilerException(string message) => throw null;
                public RuntimeBinderInternalCompilerException(string message, System.Exception innerException) => throw null;
            }

        }
    }
}
