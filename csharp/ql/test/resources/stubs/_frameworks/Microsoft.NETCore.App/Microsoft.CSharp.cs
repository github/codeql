// This file contains auto-generated code.
// Generated from `Microsoft.CSharp, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace Microsoft
{
    namespace CSharp
    {
        namespace RuntimeBinder
        {
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
            public sealed class CSharpArgumentInfo
            {
                public static Microsoft.CSharp.RuntimeBinder.CSharpArgumentInfo Create(Microsoft.CSharp.RuntimeBinder.CSharpArgumentInfoFlags flags, string name) => throw null;
            }
            [System.Flags]
            public enum CSharpArgumentInfoFlags
            {
                None = 0,
                UseCompileTimeType = 1,
                Constant = 2,
                NamedArgument = 4,
                IsRef = 8,
                IsOut = 16,
                IsStaticType = 32,
            }
            [System.Flags]
            public enum CSharpBinderFlags
            {
                None = 0,
                CheckedContext = 1,
                InvokeSimpleName = 2,
                InvokeSpecialName = 4,
                BinaryOperationLogical = 8,
                ConvertExplicit = 16,
                ConvertArrayIndex = 32,
                ResultIndexed = 64,
                ValueFromCompoundAssignment = 128,
                ResultDiscarded = 256,
            }
            public class RuntimeBinderException : System.Exception
            {
                public RuntimeBinderException() => throw null;
                protected RuntimeBinderException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public RuntimeBinderException(string message) => throw null;
                public RuntimeBinderException(string message, System.Exception innerException) => throw null;
            }
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
