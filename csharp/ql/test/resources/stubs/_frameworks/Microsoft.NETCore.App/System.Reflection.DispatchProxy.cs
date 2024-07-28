// This file contains auto-generated code.
// Generated from `System.Reflection.DispatchProxy, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace Reflection
    {
        public abstract class DispatchProxy
        {
            public static object Create(System.Type interfaceType, System.Type proxyType) => throw null;
            public static T Create<T, TProxy>() where TProxy : System.Reflection.DispatchProxy => throw null;
            protected DispatchProxy() => throw null;
            protected abstract object Invoke(System.Reflection.MethodInfo targetMethod, object[] args);
        }
    }
}
