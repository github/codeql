// This file contains auto-generated code.

namespace Microsoft
{
    namespace Win32
    {
        namespace SafeHandles
        {
            // Generated from `Microsoft.Win32.SafeHandles.CriticalHandleMinusOneIsInvalid` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class CriticalHandleMinusOneIsInvalid : System.Runtime.InteropServices.CriticalHandle
            {
                protected CriticalHandleMinusOneIsInvalid() : base(default(System.IntPtr)) => throw null;
                public override bool IsInvalid { get => throw null; }
            }

            // Generated from `Microsoft.Win32.SafeHandles.CriticalHandleZeroOrMinusOneIsInvalid` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class CriticalHandleZeroOrMinusOneIsInvalid : System.Runtime.InteropServices.CriticalHandle
            {
                protected CriticalHandleZeroOrMinusOneIsInvalid() : base(default(System.IntPtr)) => throw null;
                public override bool IsInvalid { get => throw null; }
            }

            // Generated from `Microsoft.Win32.SafeHandles.SafeFileHandle` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SafeFileHandle : Microsoft.Win32.SafeHandles.SafeHandleZeroOrMinusOneIsInvalid
            {
                public override bool IsInvalid { get => throw null; }
                protected override bool ReleaseHandle() => throw null;
                public SafeFileHandle(System.IntPtr preexistingHandle, bool ownsHandle) : base(default(bool)) => throw null;
            }

            // Generated from `Microsoft.Win32.SafeHandles.SafeHandleMinusOneIsInvalid` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class SafeHandleMinusOneIsInvalid : System.Runtime.InteropServices.SafeHandle
            {
                public override bool IsInvalid { get => throw null; }
                protected SafeHandleMinusOneIsInvalid(bool ownsHandle) : base(default(System.IntPtr), default(bool)) => throw null;
            }

            // Generated from `Microsoft.Win32.SafeHandles.SafeHandleZeroOrMinusOneIsInvalid` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class SafeHandleZeroOrMinusOneIsInvalid : System.Runtime.InteropServices.SafeHandle
            {
                public override bool IsInvalid { get => throw null; }
                protected SafeHandleZeroOrMinusOneIsInvalid(bool ownsHandle) : base(default(System.IntPtr), default(bool)) => throw null;
            }

            // Generated from `Microsoft.Win32.SafeHandles.SafeWaitHandle` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SafeWaitHandle : Microsoft.Win32.SafeHandles.SafeHandleZeroOrMinusOneIsInvalid
            {
                protected override bool ReleaseHandle() => throw null;
                public SafeWaitHandle(System.IntPtr existingHandle, bool ownsHandle) : base(default(bool)) => throw null;
            }

        }
    }
}
namespace System
{
    // Generated from `System.AccessViolationException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class AccessViolationException : System.SystemException
    {
        public AccessViolationException() => throw null;
        protected AccessViolationException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public AccessViolationException(string message) => throw null;
        public AccessViolationException(string message, System.Exception innerException) => throw null;
    }

    // Generated from `System.Action` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate void Action();

    // Generated from `System.Action<,,,,,,,,,,,,,,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate void Action<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16>(T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8, T9 arg9, T10 arg10, T11 arg11, T12 arg12, T13 arg13, T14 arg14, T15 arg15, T16 arg16);

    // Generated from `System.Action<,,,,,,,,,,,,,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate void Action<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15>(T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8, T9 arg9, T10 arg10, T11 arg11, T12 arg12, T13 arg13, T14 arg14, T15 arg15);

    // Generated from `System.Action<,,,,,,,,,,,,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate void Action<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>(T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8, T9 arg9, T10 arg10, T11 arg11, T12 arg12, T13 arg13, T14 arg14);

    // Generated from `System.Action<,,,,,,,,,,,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate void Action<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>(T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8, T9 arg9, T10 arg10, T11 arg11, T12 arg12, T13 arg13);

    // Generated from `System.Action<,,,,,,,,,,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate void Action<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>(T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8, T9 arg9, T10 arg10, T11 arg11, T12 arg12);

    // Generated from `System.Action<,,,,,,,,,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate void Action<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>(T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8, T9 arg9, T10 arg10, T11 arg11);

    // Generated from `System.Action<,,,,,,,,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate void Action<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>(T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8, T9 arg9, T10 arg10);

    // Generated from `System.Action<,,,,,,,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate void Action<T1, T2, T3, T4, T5, T6, T7, T8, T9>(T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8, T9 arg9);

    // Generated from `System.Action<,,,,,,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate void Action<T1, T2, T3, T4, T5, T6, T7, T8>(T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8);

    // Generated from `System.Action<,,,,,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate void Action<T1, T2, T3, T4, T5, T6, T7>(T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7);

    // Generated from `System.Action<,,,,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate void Action<T1, T2, T3, T4, T5, T6>(T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6);

    // Generated from `System.Action<,,,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate void Action<T1, T2, T3, T4, T5>(T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5);

    // Generated from `System.Action<,,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate void Action<T1, T2, T3, T4>(T1 arg1, T2 arg2, T3 arg3, T4 arg4);

    // Generated from `System.Action<,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate void Action<T1, T2, T3>(T1 arg1, T2 arg2, T3 arg3);

    // Generated from `System.Action<,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate void Action<T1, T2>(T1 arg1, T2 arg2);

    // Generated from `System.Action<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate void Action<T>(T obj);

    // Generated from `System.Activator` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public static class Activator
    {
        public static object CreateInstance(System.Type type) => throw null;
        public static object CreateInstance(System.Type type, System.Reflection.BindingFlags bindingAttr, System.Reflection.Binder binder, object[] args, System.Globalization.CultureInfo culture) => throw null;
        public static object CreateInstance(System.Type type, System.Reflection.BindingFlags bindingAttr, System.Reflection.Binder binder, object[] args, System.Globalization.CultureInfo culture, object[] activationAttributes) => throw null;
        public static object CreateInstance(System.Type type, object[] args, object[] activationAttributes) => throw null;
        public static object CreateInstance(System.Type type, bool nonPublic) => throw null;
        public static object CreateInstance(System.Type type, params object[] args) => throw null;
        public static System.Runtime.Remoting.ObjectHandle CreateInstance(string assemblyName, string typeName) => throw null;
        public static System.Runtime.Remoting.ObjectHandle CreateInstance(string assemblyName, string typeName, object[] activationAttributes) => throw null;
        public static System.Runtime.Remoting.ObjectHandle CreateInstance(string assemblyName, string typeName, bool ignoreCase, System.Reflection.BindingFlags bindingAttr, System.Reflection.Binder binder, object[] args, System.Globalization.CultureInfo culture, object[] activationAttributes) => throw null;
        public static T CreateInstance<T>() => throw null;
        public static System.Runtime.Remoting.ObjectHandle CreateInstanceFrom(string assemblyFile, string typeName) => throw null;
        public static System.Runtime.Remoting.ObjectHandle CreateInstanceFrom(string assemblyFile, string typeName, object[] activationAttributes) => throw null;
        public static System.Runtime.Remoting.ObjectHandle CreateInstanceFrom(string assemblyFile, string typeName, bool ignoreCase, System.Reflection.BindingFlags bindingAttr, System.Reflection.Binder binder, object[] args, System.Globalization.CultureInfo culture, object[] activationAttributes) => throw null;
    }

    // Generated from `System.AggregateException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class AggregateException : System.Exception
    {
        public AggregateException() => throw null;
        public AggregateException(System.Collections.Generic.IEnumerable<System.Exception> innerExceptions) => throw null;
        protected AggregateException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public AggregateException(params System.Exception[] innerExceptions) => throw null;
        public AggregateException(string message) => throw null;
        public AggregateException(string message, System.Exception innerException) => throw null;
        public AggregateException(string message, System.Collections.Generic.IEnumerable<System.Exception> innerExceptions) => throw null;
        public AggregateException(string message, params System.Exception[] innerExceptions) => throw null;
        public System.AggregateException Flatten() => throw null;
        public override System.Exception GetBaseException() => throw null;
        public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public void Handle(System.Func<System.Exception, bool> predicate) => throw null;
        public System.Collections.ObjectModel.ReadOnlyCollection<System.Exception> InnerExceptions { get => throw null; }
        public override string Message { get => throw null; }
        public override string ToString() => throw null;
    }

    // Generated from `System.AppContext` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public static class AppContext
    {
        public static string BaseDirectory { get => throw null; }
        public static object GetData(string name) => throw null;
        public static void SetSwitch(string switchName, bool isEnabled) => throw null;
        public static string TargetFrameworkName { get => throw null; }
        public static bool TryGetSwitch(string switchName, out bool isEnabled) => throw null;
    }

    // Generated from `System.AppDomain` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class AppDomain : System.MarshalByRefObject
    {
        public void AppendPrivatePath(string path) => throw null;
        public string ApplyPolicy(string assemblyName) => throw null;
        public event System.AssemblyLoadEventHandler AssemblyLoad;
        public event System.ResolveEventHandler AssemblyResolve;
        public string BaseDirectory { get => throw null; }
        public void ClearPrivatePath() => throw null;
        public void ClearShadowCopyPath() => throw null;
        public static System.AppDomain CreateDomain(string friendlyName) => throw null;
        public System.Runtime.Remoting.ObjectHandle CreateInstance(string assemblyName, string typeName) => throw null;
        public System.Runtime.Remoting.ObjectHandle CreateInstance(string assemblyName, string typeName, object[] activationAttributes) => throw null;
        public System.Runtime.Remoting.ObjectHandle CreateInstance(string assemblyName, string typeName, bool ignoreCase, System.Reflection.BindingFlags bindingAttr, System.Reflection.Binder binder, object[] args, System.Globalization.CultureInfo culture, object[] activationAttributes) => throw null;
        public object CreateInstanceAndUnwrap(string assemblyName, string typeName) => throw null;
        public object CreateInstanceAndUnwrap(string assemblyName, string typeName, object[] activationAttributes) => throw null;
        public object CreateInstanceAndUnwrap(string assemblyName, string typeName, bool ignoreCase, System.Reflection.BindingFlags bindingAttr, System.Reflection.Binder binder, object[] args, System.Globalization.CultureInfo culture, object[] activationAttributes) => throw null;
        public System.Runtime.Remoting.ObjectHandle CreateInstanceFrom(string assemblyFile, string typeName) => throw null;
        public System.Runtime.Remoting.ObjectHandle CreateInstanceFrom(string assemblyFile, string typeName, object[] activationAttributes) => throw null;
        public System.Runtime.Remoting.ObjectHandle CreateInstanceFrom(string assemblyFile, string typeName, bool ignoreCase, System.Reflection.BindingFlags bindingAttr, System.Reflection.Binder binder, object[] args, System.Globalization.CultureInfo culture, object[] activationAttributes) => throw null;
        public object CreateInstanceFromAndUnwrap(string assemblyFile, string typeName) => throw null;
        public object CreateInstanceFromAndUnwrap(string assemblyFile, string typeName, object[] activationAttributes) => throw null;
        public object CreateInstanceFromAndUnwrap(string assemblyFile, string typeName, bool ignoreCase, System.Reflection.BindingFlags bindingAttr, System.Reflection.Binder binder, object[] args, System.Globalization.CultureInfo culture, object[] activationAttributes) => throw null;
        public static System.AppDomain CurrentDomain { get => throw null; }
        public event System.EventHandler DomainUnload;
        public string DynamicDirectory { get => throw null; }
        public int ExecuteAssembly(string assemblyFile) => throw null;
        public int ExecuteAssembly(string assemblyFile, string[] args) => throw null;
        public int ExecuteAssembly(string assemblyFile, string[] args, System.Byte[] hashValue, System.Configuration.Assemblies.AssemblyHashAlgorithm hashAlgorithm) => throw null;
        public int ExecuteAssemblyByName(System.Reflection.AssemblyName assemblyName, params string[] args) => throw null;
        public int ExecuteAssemblyByName(string assemblyName) => throw null;
        public int ExecuteAssemblyByName(string assemblyName, params string[] args) => throw null;
        public event System.EventHandler<System.Runtime.ExceptionServices.FirstChanceExceptionEventArgs> FirstChanceException;
        public string FriendlyName { get => throw null; }
        public System.Reflection.Assembly[] GetAssemblies() => throw null;
        public static int GetCurrentThreadId() => throw null;
        public object GetData(string name) => throw null;
        public int Id { get => throw null; }
        public bool? IsCompatibilitySwitchSet(string value) => throw null;
        public bool IsDefaultAppDomain() => throw null;
        public bool IsFinalizingForUnload() => throw null;
        public bool IsFullyTrusted { get => throw null; }
        public bool IsHomogenous { get => throw null; }
        public System.Reflection.Assembly Load(System.Reflection.AssemblyName assemblyRef) => throw null;
        public System.Reflection.Assembly Load(System.Byte[] rawAssembly) => throw null;
        public System.Reflection.Assembly Load(System.Byte[] rawAssembly, System.Byte[] rawSymbolStore) => throw null;
        public System.Reflection.Assembly Load(string assemblyString) => throw null;
        public static bool MonitoringIsEnabled { get => throw null; set => throw null; }
        public System.Int64 MonitoringSurvivedMemorySize { get => throw null; }
        public static System.Int64 MonitoringSurvivedProcessMemorySize { get => throw null; }
        public System.Int64 MonitoringTotalAllocatedMemorySize { get => throw null; }
        public System.TimeSpan MonitoringTotalProcessorTime { get => throw null; }
        public System.Security.PermissionSet PermissionSet { get => throw null; }
        public event System.EventHandler ProcessExit;
        public event System.ResolveEventHandler ReflectionOnlyAssemblyResolve;
        public System.Reflection.Assembly[] ReflectionOnlyGetAssemblies() => throw null;
        public string RelativeSearchPath { get => throw null; }
        public event System.ResolveEventHandler ResourceResolve;
        public void SetCachePath(string path) => throw null;
        public void SetData(string name, object data) => throw null;
        public void SetDynamicBase(string path) => throw null;
        public void SetPrincipalPolicy(System.Security.Principal.PrincipalPolicy policy) => throw null;
        public void SetShadowCopyFiles() => throw null;
        public void SetShadowCopyPath(string path) => throw null;
        public void SetThreadPrincipal(System.Security.Principal.IPrincipal principal) => throw null;
        public System.AppDomainSetup SetupInformation { get => throw null; }
        public bool ShadowCopyFiles { get => throw null; }
        public override string ToString() => throw null;
        public event System.ResolveEventHandler TypeResolve;
        public event System.UnhandledExceptionEventHandler UnhandledException;
        public static void Unload(System.AppDomain domain) => throw null;
    }

    // Generated from `System.AppDomainSetup` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class AppDomainSetup
    {
        public string ApplicationBase { get => throw null; }
        public string TargetFrameworkName { get => throw null; }
    }

    // Generated from `System.AppDomainUnloadedException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class AppDomainUnloadedException : System.SystemException
    {
        public AppDomainUnloadedException() => throw null;
        protected AppDomainUnloadedException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public AppDomainUnloadedException(string message) => throw null;
        public AppDomainUnloadedException(string message, System.Exception innerException) => throw null;
    }

    // Generated from `System.ApplicationException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class ApplicationException : System.Exception
    {
        public ApplicationException() => throw null;
        protected ApplicationException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public ApplicationException(string message) => throw null;
        public ApplicationException(string message, System.Exception innerException) => throw null;
    }

    // Generated from `System.ApplicationId` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class ApplicationId
    {
        public ApplicationId(System.Byte[] publicKeyToken, string name, System.Version version, string processorArchitecture, string culture) => throw null;
        public System.ApplicationId Copy() => throw null;
        public string Culture { get => throw null; }
        public override bool Equals(object o) => throw null;
        public override int GetHashCode() => throw null;
        public string Name { get => throw null; }
        public string ProcessorArchitecture { get => throw null; }
        public System.Byte[] PublicKeyToken { get => throw null; }
        public override string ToString() => throw null;
        public System.Version Version { get => throw null; }
    }

    // Generated from `System.ArgIterator` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct ArgIterator
    {
        // Stub generator skipped constructor 
        public ArgIterator(System.RuntimeArgumentHandle arglist) => throw null;
        unsafe public ArgIterator(System.RuntimeArgumentHandle arglist, void* ptr) => throw null;
        public void End() => throw null;
        public override bool Equals(object o) => throw null;
        public override int GetHashCode() => throw null;
        public System.TypedReference GetNextArg() => throw null;
        public System.TypedReference GetNextArg(System.RuntimeTypeHandle rth) => throw null;
        public System.RuntimeTypeHandle GetNextArgType() => throw null;
        public int GetRemainingCount() => throw null;
    }

    // Generated from `System.ArgumentException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class ArgumentException : System.SystemException
    {
        public ArgumentException() => throw null;
        protected ArgumentException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public ArgumentException(string message) => throw null;
        public ArgumentException(string message, System.Exception innerException) => throw null;
        public ArgumentException(string message, string paramName) => throw null;
        public ArgumentException(string message, string paramName, System.Exception innerException) => throw null;
        public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public override string Message { get => throw null; }
        public virtual string ParamName { get => throw null; }
    }

    // Generated from `System.ArgumentNullException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class ArgumentNullException : System.ArgumentException
    {
        public ArgumentNullException() => throw null;
        protected ArgumentNullException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public ArgumentNullException(string paramName) => throw null;
        public ArgumentNullException(string message, System.Exception innerException) => throw null;
        public ArgumentNullException(string paramName, string message) => throw null;
    }

    // Generated from `System.ArgumentOutOfRangeException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class ArgumentOutOfRangeException : System.ArgumentException
    {
        public virtual object ActualValue { get => throw null; }
        public ArgumentOutOfRangeException() => throw null;
        protected ArgumentOutOfRangeException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public ArgumentOutOfRangeException(string paramName) => throw null;
        public ArgumentOutOfRangeException(string message, System.Exception innerException) => throw null;
        public ArgumentOutOfRangeException(string paramName, object actualValue, string message) => throw null;
        public ArgumentOutOfRangeException(string paramName, string message) => throw null;
        public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public override string Message { get => throw null; }
    }

    // Generated from `System.ArithmeticException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class ArithmeticException : System.SystemException
    {
        public ArithmeticException() => throw null;
        protected ArithmeticException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public ArithmeticException(string message) => throw null;
        public ArithmeticException(string message, System.Exception innerException) => throw null;
    }

    // Generated from `System.Array` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public abstract class Array : System.Collections.ICollection, System.Collections.IEnumerable, System.Collections.IList, System.Collections.IStructuralComparable, System.Collections.IStructuralEquatable, System.ICloneable
    {
        int System.Collections.IList.Add(object value) => throw null;
        public static System.Collections.ObjectModel.ReadOnlyCollection<T> AsReadOnly<T>(T[] array) => throw null;
        public static int BinarySearch(System.Array array, int index, int length, object value) => throw null;
        public static int BinarySearch(System.Array array, int index, int length, object value, System.Collections.IComparer comparer) => throw null;
        public static int BinarySearch(System.Array array, object value) => throw null;
        public static int BinarySearch(System.Array array, object value, System.Collections.IComparer comparer) => throw null;
        public static int BinarySearch<T>(T[] array, T value) => throw null;
        public static int BinarySearch<T>(T[] array, T value, System.Collections.Generic.IComparer<T> comparer) => throw null;
        public static int BinarySearch<T>(T[] array, int index, int length, T value) => throw null;
        public static int BinarySearch<T>(T[] array, int index, int length, T value, System.Collections.Generic.IComparer<T> comparer) => throw null;
        void System.Collections.IList.Clear() => throw null;
        public static void Clear(System.Array array, int index, int length) => throw null;
        public object Clone() => throw null;
        int System.Collections.IStructuralComparable.CompareTo(object other, System.Collections.IComparer comparer) => throw null;
        public static void ConstrainedCopy(System.Array sourceArray, int sourceIndex, System.Array destinationArray, int destinationIndex, int length) => throw null;
        bool System.Collections.IList.Contains(object value) => throw null;
        public static TOutput[] ConvertAll<TInput, TOutput>(TInput[] array, System.Converter<TInput, TOutput> converter) => throw null;
        public static void Copy(System.Array sourceArray, System.Array destinationArray, int length) => throw null;
        public static void Copy(System.Array sourceArray, System.Array destinationArray, System.Int64 length) => throw null;
        public static void Copy(System.Array sourceArray, int sourceIndex, System.Array destinationArray, int destinationIndex, int length) => throw null;
        public static void Copy(System.Array sourceArray, System.Int64 sourceIndex, System.Array destinationArray, System.Int64 destinationIndex, System.Int64 length) => throw null;
        public void CopyTo(System.Array array, int index) => throw null;
        public void CopyTo(System.Array array, System.Int64 index) => throw null;
        int System.Collections.ICollection.Count { get => throw null; }
        public static System.Array CreateInstance(System.Type elementType, int[] lengths, int[] lowerBounds) => throw null;
        public static System.Array CreateInstance(System.Type elementType, int length) => throw null;
        public static System.Array CreateInstance(System.Type elementType, int length1, int length2) => throw null;
        public static System.Array CreateInstance(System.Type elementType, int length1, int length2, int length3) => throw null;
        public static System.Array CreateInstance(System.Type elementType, params int[] lengths) => throw null;
        public static System.Array CreateInstance(System.Type elementType, params System.Int64[] lengths) => throw null;
        public static T[] Empty<T>() => throw null;
        bool System.Collections.IStructuralEquatable.Equals(object other, System.Collections.IEqualityComparer comparer) => throw null;
        public static bool Exists<T>(T[] array, System.Predicate<T> match) => throw null;
        public static void Fill<T>(T[] array, T value) => throw null;
        public static void Fill<T>(T[] array, T value, int startIndex, int count) => throw null;
        public static T Find<T>(T[] array, System.Predicate<T> match) => throw null;
        public static T[] FindAll<T>(T[] array, System.Predicate<T> match) => throw null;
        public static int FindIndex<T>(T[] array, System.Predicate<T> match) => throw null;
        public static int FindIndex<T>(T[] array, int startIndex, System.Predicate<T> match) => throw null;
        public static int FindIndex<T>(T[] array, int startIndex, int count, System.Predicate<T> match) => throw null;
        public static T FindLast<T>(T[] array, System.Predicate<T> match) => throw null;
        public static int FindLastIndex<T>(T[] array, System.Predicate<T> match) => throw null;
        public static int FindLastIndex<T>(T[] array, int startIndex, System.Predicate<T> match) => throw null;
        public static int FindLastIndex<T>(T[] array, int startIndex, int count, System.Predicate<T> match) => throw null;
        public static void ForEach<T>(T[] array, System.Action<T> action) => throw null;
        public System.Collections.IEnumerator GetEnumerator() => throw null;
        int System.Collections.IStructuralEquatable.GetHashCode(System.Collections.IEqualityComparer comparer) => throw null;
        public int GetLength(int dimension) => throw null;
        public System.Int64 GetLongLength(int dimension) => throw null;
        public int GetLowerBound(int dimension) => throw null;
        public int GetUpperBound(int dimension) => throw null;
        public object GetValue(int index) => throw null;
        public object GetValue(int index1, int index2) => throw null;
        public object GetValue(int index1, int index2, int index3) => throw null;
        public object GetValue(System.Int64 index) => throw null;
        public object GetValue(System.Int64 index1, System.Int64 index2) => throw null;
        public object GetValue(System.Int64 index1, System.Int64 index2, System.Int64 index3) => throw null;
        public object GetValue(params int[] indices) => throw null;
        public object GetValue(params System.Int64[] indices) => throw null;
        public static int IndexOf(System.Array array, object value) => throw null;
        public static int IndexOf(System.Array array, object value, int startIndex) => throw null;
        public static int IndexOf(System.Array array, object value, int startIndex, int count) => throw null;
        int System.Collections.IList.IndexOf(object value) => throw null;
        public static int IndexOf<T>(T[] array, T value) => throw null;
        public static int IndexOf<T>(T[] array, T value, int startIndex) => throw null;
        public static int IndexOf<T>(T[] array, T value, int startIndex, int count) => throw null;
        public void Initialize() => throw null;
        void System.Collections.IList.Insert(int index, object value) => throw null;
        public bool IsFixedSize { get => throw null; }
        public bool IsReadOnly { get => throw null; }
        public bool IsSynchronized { get => throw null; }
        object System.Collections.IList.this[int index] { get => throw null; set => throw null; }
        public static int LastIndexOf(System.Array array, object value) => throw null;
        public static int LastIndexOf(System.Array array, object value, int startIndex) => throw null;
        public static int LastIndexOf(System.Array array, object value, int startIndex, int count) => throw null;
        public static int LastIndexOf<T>(T[] array, T value) => throw null;
        public static int LastIndexOf<T>(T[] array, T value, int startIndex) => throw null;
        public static int LastIndexOf<T>(T[] array, T value, int startIndex, int count) => throw null;
        public int Length { get => throw null; }
        public System.Int64 LongLength { get => throw null; }
        public int Rank { get => throw null; }
        void System.Collections.IList.Remove(object value) => throw null;
        void System.Collections.IList.RemoveAt(int index) => throw null;
        public static void Resize<T>(ref T[] array, int newSize) => throw null;
        public static void Reverse(System.Array array) => throw null;
        public static void Reverse(System.Array array, int index, int length) => throw null;
        public static void Reverse<T>(T[] array) => throw null;
        public static void Reverse<T>(T[] array, int index, int length) => throw null;
        public void SetValue(object value, int index) => throw null;
        public void SetValue(object value, int index1, int index2) => throw null;
        public void SetValue(object value, int index1, int index2, int index3) => throw null;
        public void SetValue(object value, System.Int64 index) => throw null;
        public void SetValue(object value, System.Int64 index1, System.Int64 index2) => throw null;
        public void SetValue(object value, System.Int64 index1, System.Int64 index2, System.Int64 index3) => throw null;
        public void SetValue(object value, params int[] indices) => throw null;
        public void SetValue(object value, params System.Int64[] indices) => throw null;
        public static void Sort(System.Array array) => throw null;
        public static void Sort(System.Array keys, System.Array items) => throw null;
        public static void Sort(System.Array keys, System.Array items, System.Collections.IComparer comparer) => throw null;
        public static void Sort(System.Array keys, System.Array items, int index, int length) => throw null;
        public static void Sort(System.Array keys, System.Array items, int index, int length, System.Collections.IComparer comparer) => throw null;
        public static void Sort(System.Array array, System.Collections.IComparer comparer) => throw null;
        public static void Sort(System.Array array, int index, int length) => throw null;
        public static void Sort(System.Array array, int index, int length, System.Collections.IComparer comparer) => throw null;
        public static void Sort<T>(T[] array) => throw null;
        public static void Sort<T>(T[] array, System.Comparison<T> comparison) => throw null;
        public static void Sort<T>(T[] array, System.Collections.Generic.IComparer<T> comparer) => throw null;
        public static void Sort<T>(T[] array, int index, int length) => throw null;
        public static void Sort<T>(T[] array, int index, int length, System.Collections.Generic.IComparer<T> comparer) => throw null;
        public static void Sort<TKey, TValue>(TKey[] keys, TValue[] items) => throw null;
        public static void Sort<TKey, TValue>(TKey[] keys, TValue[] items, System.Collections.Generic.IComparer<TKey> comparer) => throw null;
        public static void Sort<TKey, TValue>(TKey[] keys, TValue[] items, int index, int length) => throw null;
        public static void Sort<TKey, TValue>(TKey[] keys, TValue[] items, int index, int length, System.Collections.Generic.IComparer<TKey> comparer) => throw null;
        public object SyncRoot { get => throw null; }
        public static bool TrueForAll<T>(T[] array, System.Predicate<T> match) => throw null;
    }

    // Generated from `System.ArraySegment<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct ArraySegment<T> : System.Collections.Generic.ICollection<T>, System.Collections.Generic.IEnumerable<T>, System.Collections.Generic.IList<T>, System.Collections.Generic.IReadOnlyCollection<T>, System.Collections.Generic.IReadOnlyList<T>, System.Collections.IEnumerable
    {
        // Generated from `System.ArraySegment<>+Enumerator` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public struct Enumerator : System.Collections.Generic.IEnumerator<T>, System.Collections.IEnumerator, System.IDisposable
        {
            public T Current { get => throw null; }
            object System.Collections.IEnumerator.Current { get => throw null; }
            public void Dispose() => throw null;
            // Stub generator skipped constructor 
            public bool MoveNext() => throw null;
            void System.Collections.IEnumerator.Reset() => throw null;
        }


        public static bool operator !=(System.ArraySegment<T> a, System.ArraySegment<T> b) => throw null;
        public static bool operator ==(System.ArraySegment<T> a, System.ArraySegment<T> b) => throw null;
        void System.Collections.Generic.ICollection<T>.Add(T item) => throw null;
        public T[] Array { get => throw null; }
        // Stub generator skipped constructor 
        public ArraySegment(T[] array) => throw null;
        public ArraySegment(T[] array, int offset, int count) => throw null;
        void System.Collections.Generic.ICollection<T>.Clear() => throw null;
        bool System.Collections.Generic.ICollection<T>.Contains(T item) => throw null;
        public void CopyTo(System.ArraySegment<T> destination) => throw null;
        public void CopyTo(T[] destination) => throw null;
        public void CopyTo(T[] destination, int destinationIndex) => throw null;
        public int Count { get => throw null; }
        public static System.ArraySegment<T> Empty { get => throw null; }
        public bool Equals(System.ArraySegment<T> obj) => throw null;
        public override bool Equals(object obj) => throw null;
        public System.ArraySegment<T>.Enumerator GetEnumerator() => throw null;
        System.Collections.Generic.IEnumerator<T> System.Collections.Generic.IEnumerable<T>.GetEnumerator() => throw null;
        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
        public override int GetHashCode() => throw null;
        int System.Collections.Generic.IList<T>.IndexOf(T item) => throw null;
        void System.Collections.Generic.IList<T>.Insert(int index, T item) => throw null;
        bool System.Collections.Generic.ICollection<T>.IsReadOnly { get => throw null; }
        public T this[int index] { get => throw null; set => throw null; }
        T System.Collections.Generic.IList<T>.this[int index] { get => throw null; set => throw null; }
        T System.Collections.Generic.IReadOnlyList<T>.this[int index] { get => throw null; }
        public int Offset { get => throw null; }
        bool System.Collections.Generic.ICollection<T>.Remove(T item) => throw null;
        void System.Collections.Generic.IList<T>.RemoveAt(int index) => throw null;
        public System.ArraySegment<T> Slice(int index) => throw null;
        public System.ArraySegment<T> Slice(int index, int count) => throw null;
        public T[] ToArray() => throw null;
        public static implicit operator System.ArraySegment<T>(T[] array) => throw null;
    }

    // Generated from `System.ArrayTypeMismatchException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class ArrayTypeMismatchException : System.SystemException
    {
        public ArrayTypeMismatchException() => throw null;
        protected ArrayTypeMismatchException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public ArrayTypeMismatchException(string message) => throw null;
        public ArrayTypeMismatchException(string message, System.Exception innerException) => throw null;
    }

    // Generated from `System.AssemblyLoadEventArgs` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class AssemblyLoadEventArgs : System.EventArgs
    {
        public AssemblyLoadEventArgs(System.Reflection.Assembly loadedAssembly) => throw null;
        public System.Reflection.Assembly LoadedAssembly { get => throw null; }
    }

    // Generated from `System.AssemblyLoadEventHandler` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate void AssemblyLoadEventHandler(object sender, System.AssemblyLoadEventArgs args);

    // Generated from `System.AsyncCallback` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate void AsyncCallback(System.IAsyncResult ar);

    // Generated from `System.Attribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public abstract class Attribute
    {
        protected Attribute() => throw null;
        public override bool Equals(object obj) => throw null;
        public static System.Attribute GetCustomAttribute(System.Reflection.Assembly element, System.Type attributeType) => throw null;
        public static System.Attribute GetCustomAttribute(System.Reflection.Assembly element, System.Type attributeType, bool inherit) => throw null;
        public static System.Attribute GetCustomAttribute(System.Reflection.MemberInfo element, System.Type attributeType) => throw null;
        public static System.Attribute GetCustomAttribute(System.Reflection.MemberInfo element, System.Type attributeType, bool inherit) => throw null;
        public static System.Attribute GetCustomAttribute(System.Reflection.Module element, System.Type attributeType) => throw null;
        public static System.Attribute GetCustomAttribute(System.Reflection.Module element, System.Type attributeType, bool inherit) => throw null;
        public static System.Attribute GetCustomAttribute(System.Reflection.ParameterInfo element, System.Type attributeType) => throw null;
        public static System.Attribute GetCustomAttribute(System.Reflection.ParameterInfo element, System.Type attributeType, bool inherit) => throw null;
        public static System.Attribute[] GetCustomAttributes(System.Reflection.Assembly element) => throw null;
        public static System.Attribute[] GetCustomAttributes(System.Reflection.Assembly element, System.Type attributeType) => throw null;
        public static System.Attribute[] GetCustomAttributes(System.Reflection.Assembly element, System.Type attributeType, bool inherit) => throw null;
        public static System.Attribute[] GetCustomAttributes(System.Reflection.Assembly element, bool inherit) => throw null;
        public static System.Attribute[] GetCustomAttributes(System.Reflection.MemberInfo element) => throw null;
        public static System.Attribute[] GetCustomAttributes(System.Reflection.MemberInfo element, System.Type type) => throw null;
        public static System.Attribute[] GetCustomAttributes(System.Reflection.MemberInfo element, System.Type type, bool inherit) => throw null;
        public static System.Attribute[] GetCustomAttributes(System.Reflection.MemberInfo element, bool inherit) => throw null;
        public static System.Attribute[] GetCustomAttributes(System.Reflection.Module element) => throw null;
        public static System.Attribute[] GetCustomAttributes(System.Reflection.Module element, System.Type attributeType) => throw null;
        public static System.Attribute[] GetCustomAttributes(System.Reflection.Module element, System.Type attributeType, bool inherit) => throw null;
        public static System.Attribute[] GetCustomAttributes(System.Reflection.Module element, bool inherit) => throw null;
        public static System.Attribute[] GetCustomAttributes(System.Reflection.ParameterInfo element) => throw null;
        public static System.Attribute[] GetCustomAttributes(System.Reflection.ParameterInfo element, System.Type attributeType) => throw null;
        public static System.Attribute[] GetCustomAttributes(System.Reflection.ParameterInfo element, System.Type attributeType, bool inherit) => throw null;
        public static System.Attribute[] GetCustomAttributes(System.Reflection.ParameterInfo element, bool inherit) => throw null;
        public override int GetHashCode() => throw null;
        public virtual bool IsDefaultAttribute() => throw null;
        public static bool IsDefined(System.Reflection.Assembly element, System.Type attributeType) => throw null;
        public static bool IsDefined(System.Reflection.Assembly element, System.Type attributeType, bool inherit) => throw null;
        public static bool IsDefined(System.Reflection.MemberInfo element, System.Type attributeType) => throw null;
        public static bool IsDefined(System.Reflection.MemberInfo element, System.Type attributeType, bool inherit) => throw null;
        public static bool IsDefined(System.Reflection.Module element, System.Type attributeType) => throw null;
        public static bool IsDefined(System.Reflection.Module element, System.Type attributeType, bool inherit) => throw null;
        public static bool IsDefined(System.Reflection.ParameterInfo element, System.Type attributeType) => throw null;
        public static bool IsDefined(System.Reflection.ParameterInfo element, System.Type attributeType, bool inherit) => throw null;
        public virtual bool Match(object obj) => throw null;
        public virtual object TypeId { get => throw null; }
    }

    // Generated from `System.AttributeTargets` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    [System.Flags]
    public enum AttributeTargets
    {
        All,
        Assembly,
        Class,
        Constructor,
        Delegate,
        Enum,
        Event,
        Field,
        GenericParameter,
        Interface,
        Method,
        Module,
        Parameter,
        Property,
        ReturnValue,
        Struct,
    }

    // Generated from `System.AttributeUsageAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class AttributeUsageAttribute : System.Attribute
    {
        public bool AllowMultiple { get => throw null; set => throw null; }
        public AttributeUsageAttribute(System.AttributeTargets validOn) => throw null;
        public bool Inherited { get => throw null; set => throw null; }
        public System.AttributeTargets ValidOn { get => throw null; }
    }

    // Generated from `System.BadImageFormatException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class BadImageFormatException : System.SystemException
    {
        public BadImageFormatException() => throw null;
        protected BadImageFormatException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public BadImageFormatException(string message) => throw null;
        public BadImageFormatException(string message, System.Exception inner) => throw null;
        public BadImageFormatException(string message, string fileName) => throw null;
        public BadImageFormatException(string message, string fileName, System.Exception inner) => throw null;
        public string FileName { get => throw null; }
        public string FusionLog { get => throw null; }
        public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public override string Message { get => throw null; }
        public override string ToString() => throw null;
    }

    // Generated from `System.Base64FormattingOptions` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    [System.Flags]
    public enum Base64FormattingOptions
    {
        InsertLineBreaks,
        None,
    }

    // Generated from `System.BitConverter` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public static class BitConverter
    {
        public static System.Int64 DoubleToInt64Bits(double value) => throw null;
        public static System.Byte[] GetBytes(bool value) => throw null;
        public static System.Byte[] GetBytes(System.Char value) => throw null;
        public static System.Byte[] GetBytes(double value) => throw null;
        public static System.Byte[] GetBytes(float value) => throw null;
        public static System.Byte[] GetBytes(int value) => throw null;
        public static System.Byte[] GetBytes(System.Int64 value) => throw null;
        public static System.Byte[] GetBytes(System.Int16 value) => throw null;
        public static System.Byte[] GetBytes(System.UInt32 value) => throw null;
        public static System.Byte[] GetBytes(System.UInt64 value) => throw null;
        public static System.Byte[] GetBytes(System.UInt16 value) => throw null;
        public static float Int32BitsToSingle(int value) => throw null;
        public static double Int64BitsToDouble(System.Int64 value) => throw null;
        public static bool IsLittleEndian;
        public static int SingleToInt32Bits(float value) => throw null;
        public static bool ToBoolean(System.Byte[] value, int startIndex) => throw null;
        public static bool ToBoolean(System.ReadOnlySpan<System.Byte> value) => throw null;
        public static System.Char ToChar(System.Byte[] value, int startIndex) => throw null;
        public static System.Char ToChar(System.ReadOnlySpan<System.Byte> value) => throw null;
        public static double ToDouble(System.Byte[] value, int startIndex) => throw null;
        public static double ToDouble(System.ReadOnlySpan<System.Byte> value) => throw null;
        public static System.Int16 ToInt16(System.Byte[] value, int startIndex) => throw null;
        public static System.Int16 ToInt16(System.ReadOnlySpan<System.Byte> value) => throw null;
        public static int ToInt32(System.Byte[] value, int startIndex) => throw null;
        public static int ToInt32(System.ReadOnlySpan<System.Byte> value) => throw null;
        public static System.Int64 ToInt64(System.Byte[] value, int startIndex) => throw null;
        public static System.Int64 ToInt64(System.ReadOnlySpan<System.Byte> value) => throw null;
        public static float ToSingle(System.Byte[] value, int startIndex) => throw null;
        public static float ToSingle(System.ReadOnlySpan<System.Byte> value) => throw null;
        public static string ToString(System.Byte[] value) => throw null;
        public static string ToString(System.Byte[] value, int startIndex) => throw null;
        public static string ToString(System.Byte[] value, int startIndex, int length) => throw null;
        public static System.UInt16 ToUInt16(System.Byte[] value, int startIndex) => throw null;
        public static System.UInt16 ToUInt16(System.ReadOnlySpan<System.Byte> value) => throw null;
        public static System.UInt32 ToUInt32(System.Byte[] value, int startIndex) => throw null;
        public static System.UInt32 ToUInt32(System.ReadOnlySpan<System.Byte> value) => throw null;
        public static System.UInt64 ToUInt64(System.Byte[] value, int startIndex) => throw null;
        public static System.UInt64 ToUInt64(System.ReadOnlySpan<System.Byte> value) => throw null;
        public static bool TryWriteBytes(System.Span<System.Byte> destination, bool value) => throw null;
        public static bool TryWriteBytes(System.Span<System.Byte> destination, System.Char value) => throw null;
        public static bool TryWriteBytes(System.Span<System.Byte> destination, double value) => throw null;
        public static bool TryWriteBytes(System.Span<System.Byte> destination, float value) => throw null;
        public static bool TryWriteBytes(System.Span<System.Byte> destination, int value) => throw null;
        public static bool TryWriteBytes(System.Span<System.Byte> destination, System.Int64 value) => throw null;
        public static bool TryWriteBytes(System.Span<System.Byte> destination, System.Int16 value) => throw null;
        public static bool TryWriteBytes(System.Span<System.Byte> destination, System.UInt32 value) => throw null;
        public static bool TryWriteBytes(System.Span<System.Byte> destination, System.UInt64 value) => throw null;
        public static bool TryWriteBytes(System.Span<System.Byte> destination, System.UInt16 value) => throw null;
    }

    // Generated from `System.Boolean` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct Boolean : System.IComparable, System.IComparable<bool>, System.IConvertible, System.IEquatable<bool>
    {
        // Stub generator skipped constructor 
        public int CompareTo(bool value) => throw null;
        public int CompareTo(object obj) => throw null;
        public bool Equals(bool obj) => throw null;
        public override bool Equals(object obj) => throw null;
        public static string FalseString;
        public override int GetHashCode() => throw null;
        public System.TypeCode GetTypeCode() => throw null;
        public static bool Parse(System.ReadOnlySpan<System.Char> value) => throw null;
        public static bool Parse(string value) => throw null;
        bool System.IConvertible.ToBoolean(System.IFormatProvider provider) => throw null;
        System.Byte System.IConvertible.ToByte(System.IFormatProvider provider) => throw null;
        System.Char System.IConvertible.ToChar(System.IFormatProvider provider) => throw null;
        System.DateTime System.IConvertible.ToDateTime(System.IFormatProvider provider) => throw null;
        System.Decimal System.IConvertible.ToDecimal(System.IFormatProvider provider) => throw null;
        double System.IConvertible.ToDouble(System.IFormatProvider provider) => throw null;
        System.Int16 System.IConvertible.ToInt16(System.IFormatProvider provider) => throw null;
        int System.IConvertible.ToInt32(System.IFormatProvider provider) => throw null;
        System.Int64 System.IConvertible.ToInt64(System.IFormatProvider provider) => throw null;
        System.SByte System.IConvertible.ToSByte(System.IFormatProvider provider) => throw null;
        float System.IConvertible.ToSingle(System.IFormatProvider provider) => throw null;
        public override string ToString() => throw null;
        public string ToString(System.IFormatProvider provider) => throw null;
        object System.IConvertible.ToType(System.Type type, System.IFormatProvider provider) => throw null;
        System.UInt16 System.IConvertible.ToUInt16(System.IFormatProvider provider) => throw null;
        System.UInt32 System.IConvertible.ToUInt32(System.IFormatProvider provider) => throw null;
        System.UInt64 System.IConvertible.ToUInt64(System.IFormatProvider provider) => throw null;
        public static string TrueString;
        public bool TryFormat(System.Span<System.Char> destination, out int charsWritten) => throw null;
        public static bool TryParse(System.ReadOnlySpan<System.Char> value, out bool result) => throw null;
        public static bool TryParse(string value, out bool result) => throw null;
    }

    // Generated from `System.Buffer` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public static class Buffer
    {
        public static void BlockCopy(System.Array src, int srcOffset, System.Array dst, int dstOffset, int count) => throw null;
        public static int ByteLength(System.Array array) => throw null;
        public static System.Byte GetByte(System.Array array, int index) => throw null;
        unsafe public static void MemoryCopy(void* source, void* destination, System.Int64 destinationSizeInBytes, System.Int64 sourceBytesToCopy) => throw null;
        unsafe public static void MemoryCopy(void* source, void* destination, System.UInt64 destinationSizeInBytes, System.UInt64 sourceBytesToCopy) => throw null;
        public static void SetByte(System.Array array, int index, System.Byte value) => throw null;
    }

    // Generated from `System.Byte` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct Byte : System.IComparable, System.IComparable<System.Byte>, System.IConvertible, System.IEquatable<System.Byte>, System.IFormattable
    {
        // Stub generator skipped constructor 
        public int CompareTo(System.Byte value) => throw null;
        public int CompareTo(object value) => throw null;
        public bool Equals(System.Byte obj) => throw null;
        public override bool Equals(object obj) => throw null;
        public override int GetHashCode() => throw null;
        public System.TypeCode GetTypeCode() => throw null;
        public const System.Byte MaxValue = default;
        public const System.Byte MinValue = default;
        public static System.Byte Parse(System.ReadOnlySpan<System.Char> s, System.Globalization.NumberStyles style = default(System.Globalization.NumberStyles), System.IFormatProvider provider = default(System.IFormatProvider)) => throw null;
        public static System.Byte Parse(string s) => throw null;
        public static System.Byte Parse(string s, System.IFormatProvider provider) => throw null;
        public static System.Byte Parse(string s, System.Globalization.NumberStyles style) => throw null;
        public static System.Byte Parse(string s, System.Globalization.NumberStyles style, System.IFormatProvider provider) => throw null;
        bool System.IConvertible.ToBoolean(System.IFormatProvider provider) => throw null;
        System.Byte System.IConvertible.ToByte(System.IFormatProvider provider) => throw null;
        System.Char System.IConvertible.ToChar(System.IFormatProvider provider) => throw null;
        System.DateTime System.IConvertible.ToDateTime(System.IFormatProvider provider) => throw null;
        System.Decimal System.IConvertible.ToDecimal(System.IFormatProvider provider) => throw null;
        double System.IConvertible.ToDouble(System.IFormatProvider provider) => throw null;
        System.Int16 System.IConvertible.ToInt16(System.IFormatProvider provider) => throw null;
        int System.IConvertible.ToInt32(System.IFormatProvider provider) => throw null;
        System.Int64 System.IConvertible.ToInt64(System.IFormatProvider provider) => throw null;
        System.SByte System.IConvertible.ToSByte(System.IFormatProvider provider) => throw null;
        float System.IConvertible.ToSingle(System.IFormatProvider provider) => throw null;
        public override string ToString() => throw null;
        public string ToString(System.IFormatProvider provider) => throw null;
        public string ToString(string format) => throw null;
        public string ToString(string format, System.IFormatProvider provider) => throw null;
        object System.IConvertible.ToType(System.Type type, System.IFormatProvider provider) => throw null;
        System.UInt16 System.IConvertible.ToUInt16(System.IFormatProvider provider) => throw null;
        System.UInt32 System.IConvertible.ToUInt32(System.IFormatProvider provider) => throw null;
        System.UInt64 System.IConvertible.ToUInt64(System.IFormatProvider provider) => throw null;
        public bool TryFormat(System.Span<System.Char> destination, out int charsWritten, System.ReadOnlySpan<System.Char> format = default(System.ReadOnlySpan<System.Char>), System.IFormatProvider provider = default(System.IFormatProvider)) => throw null;
        public static bool TryParse(System.ReadOnlySpan<System.Char> s, System.Globalization.NumberStyles style, System.IFormatProvider provider, out System.Byte result) => throw null;
        public static bool TryParse(System.ReadOnlySpan<System.Char> s, out System.Byte result) => throw null;
        public static bool TryParse(string s, System.Globalization.NumberStyles style, System.IFormatProvider provider, out System.Byte result) => throw null;
        public static bool TryParse(string s, out System.Byte result) => throw null;
    }

    // Generated from `System.CLSCompliantAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class CLSCompliantAttribute : System.Attribute
    {
        public CLSCompliantAttribute(bool isCompliant) => throw null;
        public bool IsCompliant { get => throw null; }
    }

    // Generated from `System.CannotUnloadAppDomainException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class CannotUnloadAppDomainException : System.SystemException
    {
        public CannotUnloadAppDomainException() => throw null;
        protected CannotUnloadAppDomainException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public CannotUnloadAppDomainException(string message) => throw null;
        public CannotUnloadAppDomainException(string message, System.Exception innerException) => throw null;
    }

    // Generated from `System.Char` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct Char : System.IComparable, System.IComparable<System.Char>, System.IConvertible, System.IEquatable<System.Char>
    {
        // Stub generator skipped constructor 
        public int CompareTo(System.Char value) => throw null;
        public int CompareTo(object value) => throw null;
        public static string ConvertFromUtf32(int utf32) => throw null;
        public static int ConvertToUtf32(System.Char highSurrogate, System.Char lowSurrogate) => throw null;
        public static int ConvertToUtf32(string s, int index) => throw null;
        public bool Equals(System.Char obj) => throw null;
        public override bool Equals(object obj) => throw null;
        public override int GetHashCode() => throw null;
        public static double GetNumericValue(System.Char c) => throw null;
        public static double GetNumericValue(string s, int index) => throw null;
        public System.TypeCode GetTypeCode() => throw null;
        public static System.Globalization.UnicodeCategory GetUnicodeCategory(System.Char c) => throw null;
        public static System.Globalization.UnicodeCategory GetUnicodeCategory(string s, int index) => throw null;
        public static bool IsControl(System.Char c) => throw null;
        public static bool IsControl(string s, int index) => throw null;
        public static bool IsDigit(System.Char c) => throw null;
        public static bool IsDigit(string s, int index) => throw null;
        public static bool IsHighSurrogate(System.Char c) => throw null;
        public static bool IsHighSurrogate(string s, int index) => throw null;
        public static bool IsLetter(System.Char c) => throw null;
        public static bool IsLetter(string s, int index) => throw null;
        public static bool IsLetterOrDigit(System.Char c) => throw null;
        public static bool IsLetterOrDigit(string s, int index) => throw null;
        public static bool IsLowSurrogate(System.Char c) => throw null;
        public static bool IsLowSurrogate(string s, int index) => throw null;
        public static bool IsLower(System.Char c) => throw null;
        public static bool IsLower(string s, int index) => throw null;
        public static bool IsNumber(System.Char c) => throw null;
        public static bool IsNumber(string s, int index) => throw null;
        public static bool IsPunctuation(System.Char c) => throw null;
        public static bool IsPunctuation(string s, int index) => throw null;
        public static bool IsSeparator(System.Char c) => throw null;
        public static bool IsSeparator(string s, int index) => throw null;
        public static bool IsSurrogate(System.Char c) => throw null;
        public static bool IsSurrogate(string s, int index) => throw null;
        public static bool IsSurrogatePair(System.Char highSurrogate, System.Char lowSurrogate) => throw null;
        public static bool IsSurrogatePair(string s, int index) => throw null;
        public static bool IsSymbol(System.Char c) => throw null;
        public static bool IsSymbol(string s, int index) => throw null;
        public static bool IsUpper(System.Char c) => throw null;
        public static bool IsUpper(string s, int index) => throw null;
        public static bool IsWhiteSpace(System.Char c) => throw null;
        public static bool IsWhiteSpace(string s, int index) => throw null;
        public const System.Char MaxValue = default;
        public const System.Char MinValue = default;
        public static System.Char Parse(string s) => throw null;
        bool System.IConvertible.ToBoolean(System.IFormatProvider provider) => throw null;
        System.Byte System.IConvertible.ToByte(System.IFormatProvider provider) => throw null;
        System.Char System.IConvertible.ToChar(System.IFormatProvider provider) => throw null;
        System.DateTime System.IConvertible.ToDateTime(System.IFormatProvider provider) => throw null;
        System.Decimal System.IConvertible.ToDecimal(System.IFormatProvider provider) => throw null;
        double System.IConvertible.ToDouble(System.IFormatProvider provider) => throw null;
        System.Int16 System.IConvertible.ToInt16(System.IFormatProvider provider) => throw null;
        int System.IConvertible.ToInt32(System.IFormatProvider provider) => throw null;
        System.Int64 System.IConvertible.ToInt64(System.IFormatProvider provider) => throw null;
        public static System.Char ToLower(System.Char c) => throw null;
        public static System.Char ToLower(System.Char c, System.Globalization.CultureInfo culture) => throw null;
        public static System.Char ToLowerInvariant(System.Char c) => throw null;
        System.SByte System.IConvertible.ToSByte(System.IFormatProvider provider) => throw null;
        float System.IConvertible.ToSingle(System.IFormatProvider provider) => throw null;
        public override string ToString() => throw null;
        public string ToString(System.IFormatProvider provider) => throw null;
        public static string ToString(System.Char c) => throw null;
        object System.IConvertible.ToType(System.Type type, System.IFormatProvider provider) => throw null;
        System.UInt16 System.IConvertible.ToUInt16(System.IFormatProvider provider) => throw null;
        System.UInt32 System.IConvertible.ToUInt32(System.IFormatProvider provider) => throw null;
        System.UInt64 System.IConvertible.ToUInt64(System.IFormatProvider provider) => throw null;
        public static System.Char ToUpper(System.Char c) => throw null;
        public static System.Char ToUpper(System.Char c, System.Globalization.CultureInfo culture) => throw null;
        public static System.Char ToUpperInvariant(System.Char c) => throw null;
        public static bool TryParse(string s, out System.Char result) => throw null;
    }

    // Generated from `System.CharEnumerator` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class CharEnumerator : System.Collections.Generic.IEnumerator<System.Char>, System.Collections.IEnumerator, System.ICloneable, System.IDisposable
    {
        public object Clone() => throw null;
        public System.Char Current { get => throw null; }
        object System.Collections.IEnumerator.Current { get => throw null; }
        public void Dispose() => throw null;
        public bool MoveNext() => throw null;
        public void Reset() => throw null;
    }

    // Generated from `System.Comparison<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate int Comparison<T>(T x, T y);

    // Generated from `System.ContextBoundObject` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public abstract class ContextBoundObject : System.MarshalByRefObject
    {
        protected ContextBoundObject() => throw null;
    }

    // Generated from `System.ContextMarshalException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class ContextMarshalException : System.SystemException
    {
        public ContextMarshalException() => throw null;
        protected ContextMarshalException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public ContextMarshalException(string message) => throw null;
        public ContextMarshalException(string message, System.Exception inner) => throw null;
    }

    // Generated from `System.ContextStaticAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class ContextStaticAttribute : System.Attribute
    {
        public ContextStaticAttribute() => throw null;
    }

    // Generated from `System.Convert` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public static class Convert
    {
        public static object ChangeType(object value, System.Type conversionType) => throw null;
        public static object ChangeType(object value, System.Type conversionType, System.IFormatProvider provider) => throw null;
        public static object ChangeType(object value, System.TypeCode typeCode) => throw null;
        public static object ChangeType(object value, System.TypeCode typeCode, System.IFormatProvider provider) => throw null;
        public static object DBNull;
        public static System.Byte[] FromBase64CharArray(System.Char[] inArray, int offset, int length) => throw null;
        public static System.Byte[] FromBase64String(string s) => throw null;
        public static System.Byte[] FromHexString(System.ReadOnlySpan<System.Char> chars) => throw null;
        public static System.Byte[] FromHexString(string s) => throw null;
        public static System.TypeCode GetTypeCode(object value) => throw null;
        public static bool IsDBNull(object value) => throw null;
        public static int ToBase64CharArray(System.Byte[] inArray, int offsetIn, int length, System.Char[] outArray, int offsetOut) => throw null;
        public static int ToBase64CharArray(System.Byte[] inArray, int offsetIn, int length, System.Char[] outArray, int offsetOut, System.Base64FormattingOptions options) => throw null;
        public static string ToBase64String(System.Byte[] inArray) => throw null;
        public static string ToBase64String(System.Byte[] inArray, System.Base64FormattingOptions options) => throw null;
        public static string ToBase64String(System.Byte[] inArray, int offset, int length) => throw null;
        public static string ToBase64String(System.Byte[] inArray, int offset, int length, System.Base64FormattingOptions options) => throw null;
        public static string ToBase64String(System.ReadOnlySpan<System.Byte> bytes, System.Base64FormattingOptions options = default(System.Base64FormattingOptions)) => throw null;
        public static bool ToBoolean(System.DateTime value) => throw null;
        public static bool ToBoolean(bool value) => throw null;
        public static bool ToBoolean(System.Byte value) => throw null;
        public static bool ToBoolean(System.Char value) => throw null;
        public static bool ToBoolean(System.Decimal value) => throw null;
        public static bool ToBoolean(double value) => throw null;
        public static bool ToBoolean(float value) => throw null;
        public static bool ToBoolean(int value) => throw null;
        public static bool ToBoolean(System.Int64 value) => throw null;
        public static bool ToBoolean(object value) => throw null;
        public static bool ToBoolean(object value, System.IFormatProvider provider) => throw null;
        public static bool ToBoolean(System.SByte value) => throw null;
        public static bool ToBoolean(System.Int16 value) => throw null;
        public static bool ToBoolean(string value) => throw null;
        public static bool ToBoolean(string value, System.IFormatProvider provider) => throw null;
        public static bool ToBoolean(System.UInt32 value) => throw null;
        public static bool ToBoolean(System.UInt64 value) => throw null;
        public static bool ToBoolean(System.UInt16 value) => throw null;
        public static System.Byte ToByte(System.DateTime value) => throw null;
        public static System.Byte ToByte(bool value) => throw null;
        public static System.Byte ToByte(System.Byte value) => throw null;
        public static System.Byte ToByte(System.Char value) => throw null;
        public static System.Byte ToByte(System.Decimal value) => throw null;
        public static System.Byte ToByte(double value) => throw null;
        public static System.Byte ToByte(float value) => throw null;
        public static System.Byte ToByte(int value) => throw null;
        public static System.Byte ToByte(System.Int64 value) => throw null;
        public static System.Byte ToByte(object value) => throw null;
        public static System.Byte ToByte(object value, System.IFormatProvider provider) => throw null;
        public static System.Byte ToByte(System.SByte value) => throw null;
        public static System.Byte ToByte(System.Int16 value) => throw null;
        public static System.Byte ToByte(string value) => throw null;
        public static System.Byte ToByte(string value, System.IFormatProvider provider) => throw null;
        public static System.Byte ToByte(string value, int fromBase) => throw null;
        public static System.Byte ToByte(System.UInt32 value) => throw null;
        public static System.Byte ToByte(System.UInt64 value) => throw null;
        public static System.Byte ToByte(System.UInt16 value) => throw null;
        public static System.Char ToChar(System.DateTime value) => throw null;
        public static System.Char ToChar(bool value) => throw null;
        public static System.Char ToChar(System.Byte value) => throw null;
        public static System.Char ToChar(System.Char value) => throw null;
        public static System.Char ToChar(System.Decimal value) => throw null;
        public static System.Char ToChar(double value) => throw null;
        public static System.Char ToChar(float value) => throw null;
        public static System.Char ToChar(int value) => throw null;
        public static System.Char ToChar(System.Int64 value) => throw null;
        public static System.Char ToChar(object value) => throw null;
        public static System.Char ToChar(object value, System.IFormatProvider provider) => throw null;
        public static System.Char ToChar(System.SByte value) => throw null;
        public static System.Char ToChar(System.Int16 value) => throw null;
        public static System.Char ToChar(string value) => throw null;
        public static System.Char ToChar(string value, System.IFormatProvider provider) => throw null;
        public static System.Char ToChar(System.UInt32 value) => throw null;
        public static System.Char ToChar(System.UInt64 value) => throw null;
        public static System.Char ToChar(System.UInt16 value) => throw null;
        public static System.DateTime ToDateTime(System.DateTime value) => throw null;
        public static System.DateTime ToDateTime(bool value) => throw null;
        public static System.DateTime ToDateTime(System.Byte value) => throw null;
        public static System.DateTime ToDateTime(System.Char value) => throw null;
        public static System.DateTime ToDateTime(System.Decimal value) => throw null;
        public static System.DateTime ToDateTime(double value) => throw null;
        public static System.DateTime ToDateTime(float value) => throw null;
        public static System.DateTime ToDateTime(int value) => throw null;
        public static System.DateTime ToDateTime(System.Int64 value) => throw null;
        public static System.DateTime ToDateTime(object value) => throw null;
        public static System.DateTime ToDateTime(object value, System.IFormatProvider provider) => throw null;
        public static System.DateTime ToDateTime(System.SByte value) => throw null;
        public static System.DateTime ToDateTime(System.Int16 value) => throw null;
        public static System.DateTime ToDateTime(string value) => throw null;
        public static System.DateTime ToDateTime(string value, System.IFormatProvider provider) => throw null;
        public static System.DateTime ToDateTime(System.UInt32 value) => throw null;
        public static System.DateTime ToDateTime(System.UInt64 value) => throw null;
        public static System.DateTime ToDateTime(System.UInt16 value) => throw null;
        public static System.Decimal ToDecimal(System.DateTime value) => throw null;
        public static System.Decimal ToDecimal(bool value) => throw null;
        public static System.Decimal ToDecimal(System.Byte value) => throw null;
        public static System.Decimal ToDecimal(System.Char value) => throw null;
        public static System.Decimal ToDecimal(System.Decimal value) => throw null;
        public static System.Decimal ToDecimal(double value) => throw null;
        public static System.Decimal ToDecimal(float value) => throw null;
        public static System.Decimal ToDecimal(int value) => throw null;
        public static System.Decimal ToDecimal(System.Int64 value) => throw null;
        public static System.Decimal ToDecimal(object value) => throw null;
        public static System.Decimal ToDecimal(object value, System.IFormatProvider provider) => throw null;
        public static System.Decimal ToDecimal(System.SByte value) => throw null;
        public static System.Decimal ToDecimal(System.Int16 value) => throw null;
        public static System.Decimal ToDecimal(string value) => throw null;
        public static System.Decimal ToDecimal(string value, System.IFormatProvider provider) => throw null;
        public static System.Decimal ToDecimal(System.UInt32 value) => throw null;
        public static System.Decimal ToDecimal(System.UInt64 value) => throw null;
        public static System.Decimal ToDecimal(System.UInt16 value) => throw null;
        public static double ToDouble(System.DateTime value) => throw null;
        public static double ToDouble(bool value) => throw null;
        public static double ToDouble(System.Byte value) => throw null;
        public static double ToDouble(System.Char value) => throw null;
        public static double ToDouble(System.Decimal value) => throw null;
        public static double ToDouble(double value) => throw null;
        public static double ToDouble(float value) => throw null;
        public static double ToDouble(int value) => throw null;
        public static double ToDouble(System.Int64 value) => throw null;
        public static double ToDouble(object value) => throw null;
        public static double ToDouble(object value, System.IFormatProvider provider) => throw null;
        public static double ToDouble(System.SByte value) => throw null;
        public static double ToDouble(System.Int16 value) => throw null;
        public static double ToDouble(string value) => throw null;
        public static double ToDouble(string value, System.IFormatProvider provider) => throw null;
        public static double ToDouble(System.UInt32 value) => throw null;
        public static double ToDouble(System.UInt64 value) => throw null;
        public static double ToDouble(System.UInt16 value) => throw null;
        public static string ToHexString(System.Byte[] inArray) => throw null;
        public static string ToHexString(System.Byte[] inArray, int offset, int length) => throw null;
        public static string ToHexString(System.ReadOnlySpan<System.Byte> bytes) => throw null;
        public static System.Int16 ToInt16(System.DateTime value) => throw null;
        public static System.Int16 ToInt16(bool value) => throw null;
        public static System.Int16 ToInt16(System.Byte value) => throw null;
        public static System.Int16 ToInt16(System.Char value) => throw null;
        public static System.Int16 ToInt16(System.Decimal value) => throw null;
        public static System.Int16 ToInt16(double value) => throw null;
        public static System.Int16 ToInt16(float value) => throw null;
        public static System.Int16 ToInt16(int value) => throw null;
        public static System.Int16 ToInt16(System.Int64 value) => throw null;
        public static System.Int16 ToInt16(object value) => throw null;
        public static System.Int16 ToInt16(object value, System.IFormatProvider provider) => throw null;
        public static System.Int16 ToInt16(System.SByte value) => throw null;
        public static System.Int16 ToInt16(System.Int16 value) => throw null;
        public static System.Int16 ToInt16(string value) => throw null;
        public static System.Int16 ToInt16(string value, System.IFormatProvider provider) => throw null;
        public static System.Int16 ToInt16(string value, int fromBase) => throw null;
        public static System.Int16 ToInt16(System.UInt32 value) => throw null;
        public static System.Int16 ToInt16(System.UInt64 value) => throw null;
        public static System.Int16 ToInt16(System.UInt16 value) => throw null;
        public static int ToInt32(System.DateTime value) => throw null;
        public static int ToInt32(bool value) => throw null;
        public static int ToInt32(System.Byte value) => throw null;
        public static int ToInt32(System.Char value) => throw null;
        public static int ToInt32(System.Decimal value) => throw null;
        public static int ToInt32(double value) => throw null;
        public static int ToInt32(float value) => throw null;
        public static int ToInt32(int value) => throw null;
        public static int ToInt32(System.Int64 value) => throw null;
        public static int ToInt32(object value) => throw null;
        public static int ToInt32(object value, System.IFormatProvider provider) => throw null;
        public static int ToInt32(System.SByte value) => throw null;
        public static int ToInt32(System.Int16 value) => throw null;
        public static int ToInt32(string value) => throw null;
        public static int ToInt32(string value, System.IFormatProvider provider) => throw null;
        public static int ToInt32(string value, int fromBase) => throw null;
        public static int ToInt32(System.UInt32 value) => throw null;
        public static int ToInt32(System.UInt64 value) => throw null;
        public static int ToInt32(System.UInt16 value) => throw null;
        public static System.Int64 ToInt64(System.DateTime value) => throw null;
        public static System.Int64 ToInt64(bool value) => throw null;
        public static System.Int64 ToInt64(System.Byte value) => throw null;
        public static System.Int64 ToInt64(System.Char value) => throw null;
        public static System.Int64 ToInt64(System.Decimal value) => throw null;
        public static System.Int64 ToInt64(double value) => throw null;
        public static System.Int64 ToInt64(float value) => throw null;
        public static System.Int64 ToInt64(int value) => throw null;
        public static System.Int64 ToInt64(System.Int64 value) => throw null;
        public static System.Int64 ToInt64(object value) => throw null;
        public static System.Int64 ToInt64(object value, System.IFormatProvider provider) => throw null;
        public static System.Int64 ToInt64(System.SByte value) => throw null;
        public static System.Int64 ToInt64(System.Int16 value) => throw null;
        public static System.Int64 ToInt64(string value) => throw null;
        public static System.Int64 ToInt64(string value, System.IFormatProvider provider) => throw null;
        public static System.Int64 ToInt64(string value, int fromBase) => throw null;
        public static System.Int64 ToInt64(System.UInt32 value) => throw null;
        public static System.Int64 ToInt64(System.UInt64 value) => throw null;
        public static System.Int64 ToInt64(System.UInt16 value) => throw null;
        public static System.SByte ToSByte(System.DateTime value) => throw null;
        public static System.SByte ToSByte(bool value) => throw null;
        public static System.SByte ToSByte(System.Byte value) => throw null;
        public static System.SByte ToSByte(System.Char value) => throw null;
        public static System.SByte ToSByte(System.Decimal value) => throw null;
        public static System.SByte ToSByte(double value) => throw null;
        public static System.SByte ToSByte(float value) => throw null;
        public static System.SByte ToSByte(int value) => throw null;
        public static System.SByte ToSByte(System.Int64 value) => throw null;
        public static System.SByte ToSByte(object value) => throw null;
        public static System.SByte ToSByte(object value, System.IFormatProvider provider) => throw null;
        public static System.SByte ToSByte(System.SByte value) => throw null;
        public static System.SByte ToSByte(System.Int16 value) => throw null;
        public static System.SByte ToSByte(string value) => throw null;
        public static System.SByte ToSByte(string value, System.IFormatProvider provider) => throw null;
        public static System.SByte ToSByte(string value, int fromBase) => throw null;
        public static System.SByte ToSByte(System.UInt32 value) => throw null;
        public static System.SByte ToSByte(System.UInt64 value) => throw null;
        public static System.SByte ToSByte(System.UInt16 value) => throw null;
        public static float ToSingle(System.DateTime value) => throw null;
        public static float ToSingle(bool value) => throw null;
        public static float ToSingle(System.Byte value) => throw null;
        public static float ToSingle(System.Char value) => throw null;
        public static float ToSingle(System.Decimal value) => throw null;
        public static float ToSingle(double value) => throw null;
        public static float ToSingle(float value) => throw null;
        public static float ToSingle(int value) => throw null;
        public static float ToSingle(System.Int64 value) => throw null;
        public static float ToSingle(object value) => throw null;
        public static float ToSingle(object value, System.IFormatProvider provider) => throw null;
        public static float ToSingle(System.SByte value) => throw null;
        public static float ToSingle(System.Int16 value) => throw null;
        public static float ToSingle(string value) => throw null;
        public static float ToSingle(string value, System.IFormatProvider provider) => throw null;
        public static float ToSingle(System.UInt32 value) => throw null;
        public static float ToSingle(System.UInt64 value) => throw null;
        public static float ToSingle(System.UInt16 value) => throw null;
        public static string ToString(System.DateTime value) => throw null;
        public static string ToString(System.DateTime value, System.IFormatProvider provider) => throw null;
        public static string ToString(bool value) => throw null;
        public static string ToString(bool value, System.IFormatProvider provider) => throw null;
        public static string ToString(System.Byte value) => throw null;
        public static string ToString(System.Byte value, System.IFormatProvider provider) => throw null;
        public static string ToString(System.Byte value, int toBase) => throw null;
        public static string ToString(System.Char value) => throw null;
        public static string ToString(System.Char value, System.IFormatProvider provider) => throw null;
        public static string ToString(System.Decimal value) => throw null;
        public static string ToString(System.Decimal value, System.IFormatProvider provider) => throw null;
        public static string ToString(double value) => throw null;
        public static string ToString(double value, System.IFormatProvider provider) => throw null;
        public static string ToString(float value) => throw null;
        public static string ToString(float value, System.IFormatProvider provider) => throw null;
        public static string ToString(int value) => throw null;
        public static string ToString(int value, System.IFormatProvider provider) => throw null;
        public static string ToString(int value, int toBase) => throw null;
        public static string ToString(System.Int64 value) => throw null;
        public static string ToString(System.Int64 value, System.IFormatProvider provider) => throw null;
        public static string ToString(System.Int64 value, int toBase) => throw null;
        public static string ToString(object value) => throw null;
        public static string ToString(object value, System.IFormatProvider provider) => throw null;
        public static string ToString(System.SByte value) => throw null;
        public static string ToString(System.SByte value, System.IFormatProvider provider) => throw null;
        public static string ToString(System.Int16 value) => throw null;
        public static string ToString(System.Int16 value, System.IFormatProvider provider) => throw null;
        public static string ToString(System.Int16 value, int toBase) => throw null;
        public static string ToString(string value) => throw null;
        public static string ToString(string value, System.IFormatProvider provider) => throw null;
        public static string ToString(System.UInt32 value) => throw null;
        public static string ToString(System.UInt32 value, System.IFormatProvider provider) => throw null;
        public static string ToString(System.UInt64 value) => throw null;
        public static string ToString(System.UInt64 value, System.IFormatProvider provider) => throw null;
        public static string ToString(System.UInt16 value) => throw null;
        public static string ToString(System.UInt16 value, System.IFormatProvider provider) => throw null;
        public static System.UInt16 ToUInt16(System.DateTime value) => throw null;
        public static System.UInt16 ToUInt16(bool value) => throw null;
        public static System.UInt16 ToUInt16(System.Byte value) => throw null;
        public static System.UInt16 ToUInt16(System.Char value) => throw null;
        public static System.UInt16 ToUInt16(System.Decimal value) => throw null;
        public static System.UInt16 ToUInt16(double value) => throw null;
        public static System.UInt16 ToUInt16(float value) => throw null;
        public static System.UInt16 ToUInt16(int value) => throw null;
        public static System.UInt16 ToUInt16(System.Int64 value) => throw null;
        public static System.UInt16 ToUInt16(object value) => throw null;
        public static System.UInt16 ToUInt16(object value, System.IFormatProvider provider) => throw null;
        public static System.UInt16 ToUInt16(System.SByte value) => throw null;
        public static System.UInt16 ToUInt16(System.Int16 value) => throw null;
        public static System.UInt16 ToUInt16(string value) => throw null;
        public static System.UInt16 ToUInt16(string value, System.IFormatProvider provider) => throw null;
        public static System.UInt16 ToUInt16(string value, int fromBase) => throw null;
        public static System.UInt16 ToUInt16(System.UInt32 value) => throw null;
        public static System.UInt16 ToUInt16(System.UInt64 value) => throw null;
        public static System.UInt16 ToUInt16(System.UInt16 value) => throw null;
        public static System.UInt32 ToUInt32(System.DateTime value) => throw null;
        public static System.UInt32 ToUInt32(bool value) => throw null;
        public static System.UInt32 ToUInt32(System.Byte value) => throw null;
        public static System.UInt32 ToUInt32(System.Char value) => throw null;
        public static System.UInt32 ToUInt32(System.Decimal value) => throw null;
        public static System.UInt32 ToUInt32(double value) => throw null;
        public static System.UInt32 ToUInt32(float value) => throw null;
        public static System.UInt32 ToUInt32(int value) => throw null;
        public static System.UInt32 ToUInt32(System.Int64 value) => throw null;
        public static System.UInt32 ToUInt32(object value) => throw null;
        public static System.UInt32 ToUInt32(object value, System.IFormatProvider provider) => throw null;
        public static System.UInt32 ToUInt32(System.SByte value) => throw null;
        public static System.UInt32 ToUInt32(System.Int16 value) => throw null;
        public static System.UInt32 ToUInt32(string value) => throw null;
        public static System.UInt32 ToUInt32(string value, System.IFormatProvider provider) => throw null;
        public static System.UInt32 ToUInt32(string value, int fromBase) => throw null;
        public static System.UInt32 ToUInt32(System.UInt32 value) => throw null;
        public static System.UInt32 ToUInt32(System.UInt64 value) => throw null;
        public static System.UInt32 ToUInt32(System.UInt16 value) => throw null;
        public static System.UInt64 ToUInt64(System.DateTime value) => throw null;
        public static System.UInt64 ToUInt64(bool value) => throw null;
        public static System.UInt64 ToUInt64(System.Byte value) => throw null;
        public static System.UInt64 ToUInt64(System.Char value) => throw null;
        public static System.UInt64 ToUInt64(System.Decimal value) => throw null;
        public static System.UInt64 ToUInt64(double value) => throw null;
        public static System.UInt64 ToUInt64(float value) => throw null;
        public static System.UInt64 ToUInt64(int value) => throw null;
        public static System.UInt64 ToUInt64(System.Int64 value) => throw null;
        public static System.UInt64 ToUInt64(object value) => throw null;
        public static System.UInt64 ToUInt64(object value, System.IFormatProvider provider) => throw null;
        public static System.UInt64 ToUInt64(System.SByte value) => throw null;
        public static System.UInt64 ToUInt64(System.Int16 value) => throw null;
        public static System.UInt64 ToUInt64(string value) => throw null;
        public static System.UInt64 ToUInt64(string value, System.IFormatProvider provider) => throw null;
        public static System.UInt64 ToUInt64(string value, int fromBase) => throw null;
        public static System.UInt64 ToUInt64(System.UInt32 value) => throw null;
        public static System.UInt64 ToUInt64(System.UInt64 value) => throw null;
        public static System.UInt64 ToUInt64(System.UInt16 value) => throw null;
        public static bool TryFromBase64Chars(System.ReadOnlySpan<System.Char> chars, System.Span<System.Byte> bytes, out int bytesWritten) => throw null;
        public static bool TryFromBase64String(string s, System.Span<System.Byte> bytes, out int bytesWritten) => throw null;
        public static bool TryToBase64Chars(System.ReadOnlySpan<System.Byte> bytes, System.Span<System.Char> chars, out int charsWritten, System.Base64FormattingOptions options = default(System.Base64FormattingOptions)) => throw null;
    }

    // Generated from `System.Converter<,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate TOutput Converter<TInput, TOutput>(TInput input);

    // Generated from `System.DBNull` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class DBNull : System.IConvertible, System.Runtime.Serialization.ISerializable
    {
        public void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public System.TypeCode GetTypeCode() => throw null;
        bool System.IConvertible.ToBoolean(System.IFormatProvider provider) => throw null;
        System.Byte System.IConvertible.ToByte(System.IFormatProvider provider) => throw null;
        System.Char System.IConvertible.ToChar(System.IFormatProvider provider) => throw null;
        System.DateTime System.IConvertible.ToDateTime(System.IFormatProvider provider) => throw null;
        System.Decimal System.IConvertible.ToDecimal(System.IFormatProvider provider) => throw null;
        double System.IConvertible.ToDouble(System.IFormatProvider provider) => throw null;
        System.Int16 System.IConvertible.ToInt16(System.IFormatProvider provider) => throw null;
        int System.IConvertible.ToInt32(System.IFormatProvider provider) => throw null;
        System.Int64 System.IConvertible.ToInt64(System.IFormatProvider provider) => throw null;
        System.SByte System.IConvertible.ToSByte(System.IFormatProvider provider) => throw null;
        float System.IConvertible.ToSingle(System.IFormatProvider provider) => throw null;
        public override string ToString() => throw null;
        public string ToString(System.IFormatProvider provider) => throw null;
        object System.IConvertible.ToType(System.Type type, System.IFormatProvider provider) => throw null;
        System.UInt16 System.IConvertible.ToUInt16(System.IFormatProvider provider) => throw null;
        System.UInt32 System.IConvertible.ToUInt32(System.IFormatProvider provider) => throw null;
        System.UInt64 System.IConvertible.ToUInt64(System.IFormatProvider provider) => throw null;
        public static System.DBNull Value;
    }

    // Generated from `System.DateTime` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct DateTime : System.IComparable, System.IComparable<System.DateTime>, System.IConvertible, System.IEquatable<System.DateTime>, System.IFormattable, System.Runtime.Serialization.ISerializable
    {
        public static bool operator !=(System.DateTime d1, System.DateTime d2) => throw null;
        public static System.DateTime operator +(System.DateTime d, System.TimeSpan t) => throw null;
        public static System.TimeSpan operator -(System.DateTime d1, System.DateTime d2) => throw null;
        public static System.DateTime operator -(System.DateTime d, System.TimeSpan t) => throw null;
        public static bool operator <(System.DateTime t1, System.DateTime t2) => throw null;
        public static bool operator <=(System.DateTime t1, System.DateTime t2) => throw null;
        public static bool operator ==(System.DateTime d1, System.DateTime d2) => throw null;
        public static bool operator >(System.DateTime t1, System.DateTime t2) => throw null;
        public static bool operator >=(System.DateTime t1, System.DateTime t2) => throw null;
        public System.DateTime Add(System.TimeSpan value) => throw null;
        public System.DateTime AddDays(double value) => throw null;
        public System.DateTime AddHours(double value) => throw null;
        public System.DateTime AddMilliseconds(double value) => throw null;
        public System.DateTime AddMinutes(double value) => throw null;
        public System.DateTime AddMonths(int months) => throw null;
        public System.DateTime AddSeconds(double value) => throw null;
        public System.DateTime AddTicks(System.Int64 value) => throw null;
        public System.DateTime AddYears(int value) => throw null;
        public static int Compare(System.DateTime t1, System.DateTime t2) => throw null;
        public int CompareTo(System.DateTime value) => throw null;
        public int CompareTo(object value) => throw null;
        public System.DateTime Date { get => throw null; }
        // Stub generator skipped constructor 
        public DateTime(int year, int month, int day) => throw null;
        public DateTime(int year, int month, int day, System.Globalization.Calendar calendar) => throw null;
        public DateTime(int year, int month, int day, int hour, int minute, int second) => throw null;
        public DateTime(int year, int month, int day, int hour, int minute, int second, System.Globalization.Calendar calendar) => throw null;
        public DateTime(int year, int month, int day, int hour, int minute, int second, System.DateTimeKind kind) => throw null;
        public DateTime(int year, int month, int day, int hour, int minute, int second, int millisecond) => throw null;
        public DateTime(int year, int month, int day, int hour, int minute, int second, int millisecond, System.Globalization.Calendar calendar) => throw null;
        public DateTime(int year, int month, int day, int hour, int minute, int second, int millisecond, System.Globalization.Calendar calendar, System.DateTimeKind kind) => throw null;
        public DateTime(int year, int month, int day, int hour, int minute, int second, int millisecond, System.DateTimeKind kind) => throw null;
        public DateTime(System.Int64 ticks) => throw null;
        public DateTime(System.Int64 ticks, System.DateTimeKind kind) => throw null;
        public int Day { get => throw null; }
        public System.DayOfWeek DayOfWeek { get => throw null; }
        public int DayOfYear { get => throw null; }
        public static int DaysInMonth(int year, int month) => throw null;
        public bool Equals(System.DateTime value) => throw null;
        public static bool Equals(System.DateTime t1, System.DateTime t2) => throw null;
        public override bool Equals(object value) => throw null;
        public static System.DateTime FromBinary(System.Int64 dateData) => throw null;
        public static System.DateTime FromFileTime(System.Int64 fileTime) => throw null;
        public static System.DateTime FromFileTimeUtc(System.Int64 fileTime) => throw null;
        public static System.DateTime FromOADate(double d) => throw null;
        public string[] GetDateTimeFormats() => throw null;
        public string[] GetDateTimeFormats(System.IFormatProvider provider) => throw null;
        public string[] GetDateTimeFormats(System.Char format) => throw null;
        public string[] GetDateTimeFormats(System.Char format, System.IFormatProvider provider) => throw null;
        public override int GetHashCode() => throw null;
        void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public System.TypeCode GetTypeCode() => throw null;
        public int Hour { get => throw null; }
        public bool IsDaylightSavingTime() => throw null;
        public static bool IsLeapYear(int year) => throw null;
        public System.DateTimeKind Kind { get => throw null; }
        public static System.DateTime MaxValue;
        public int Millisecond { get => throw null; }
        public static System.DateTime MinValue;
        public int Minute { get => throw null; }
        public int Month { get => throw null; }
        public static System.DateTime Now { get => throw null; }
        public static System.DateTime Parse(System.ReadOnlySpan<System.Char> s, System.IFormatProvider provider = default(System.IFormatProvider), System.Globalization.DateTimeStyles styles = default(System.Globalization.DateTimeStyles)) => throw null;
        public static System.DateTime Parse(string s) => throw null;
        public static System.DateTime Parse(string s, System.IFormatProvider provider) => throw null;
        public static System.DateTime Parse(string s, System.IFormatProvider provider, System.Globalization.DateTimeStyles styles) => throw null;
        public static System.DateTime ParseExact(System.ReadOnlySpan<System.Char> s, System.ReadOnlySpan<System.Char> format, System.IFormatProvider provider, System.Globalization.DateTimeStyles style = default(System.Globalization.DateTimeStyles)) => throw null;
        public static System.DateTime ParseExact(System.ReadOnlySpan<System.Char> s, string[] formats, System.IFormatProvider provider, System.Globalization.DateTimeStyles style = default(System.Globalization.DateTimeStyles)) => throw null;
        public static System.DateTime ParseExact(string s, string[] formats, System.IFormatProvider provider, System.Globalization.DateTimeStyles style) => throw null;
        public static System.DateTime ParseExact(string s, string format, System.IFormatProvider provider) => throw null;
        public static System.DateTime ParseExact(string s, string format, System.IFormatProvider provider, System.Globalization.DateTimeStyles style) => throw null;
        public int Second { get => throw null; }
        public static System.DateTime SpecifyKind(System.DateTime value, System.DateTimeKind kind) => throw null;
        public System.TimeSpan Subtract(System.DateTime value) => throw null;
        public System.DateTime Subtract(System.TimeSpan value) => throw null;
        public System.Int64 Ticks { get => throw null; }
        public System.TimeSpan TimeOfDay { get => throw null; }
        public System.Int64 ToBinary() => throw null;
        bool System.IConvertible.ToBoolean(System.IFormatProvider provider) => throw null;
        System.Byte System.IConvertible.ToByte(System.IFormatProvider provider) => throw null;
        System.Char System.IConvertible.ToChar(System.IFormatProvider provider) => throw null;
        System.DateTime System.IConvertible.ToDateTime(System.IFormatProvider provider) => throw null;
        System.Decimal System.IConvertible.ToDecimal(System.IFormatProvider provider) => throw null;
        double System.IConvertible.ToDouble(System.IFormatProvider provider) => throw null;
        public System.Int64 ToFileTime() => throw null;
        public System.Int64 ToFileTimeUtc() => throw null;
        System.Int16 System.IConvertible.ToInt16(System.IFormatProvider provider) => throw null;
        int System.IConvertible.ToInt32(System.IFormatProvider provider) => throw null;
        System.Int64 System.IConvertible.ToInt64(System.IFormatProvider provider) => throw null;
        public System.DateTime ToLocalTime() => throw null;
        public string ToLongDateString() => throw null;
        public string ToLongTimeString() => throw null;
        public double ToOADate() => throw null;
        System.SByte System.IConvertible.ToSByte(System.IFormatProvider provider) => throw null;
        public string ToShortDateString() => throw null;
        public string ToShortTimeString() => throw null;
        float System.IConvertible.ToSingle(System.IFormatProvider provider) => throw null;
        public override string ToString() => throw null;
        public string ToString(System.IFormatProvider provider) => throw null;
        public string ToString(string format) => throw null;
        public string ToString(string format, System.IFormatProvider provider) => throw null;
        object System.IConvertible.ToType(System.Type type, System.IFormatProvider provider) => throw null;
        System.UInt16 System.IConvertible.ToUInt16(System.IFormatProvider provider) => throw null;
        System.UInt32 System.IConvertible.ToUInt32(System.IFormatProvider provider) => throw null;
        System.UInt64 System.IConvertible.ToUInt64(System.IFormatProvider provider) => throw null;
        public System.DateTime ToUniversalTime() => throw null;
        public static System.DateTime Today { get => throw null; }
        public bool TryFormat(System.Span<System.Char> destination, out int charsWritten, System.ReadOnlySpan<System.Char> format = default(System.ReadOnlySpan<System.Char>), System.IFormatProvider provider = default(System.IFormatProvider)) => throw null;
        public static bool TryParse(System.ReadOnlySpan<System.Char> s, System.IFormatProvider provider, System.Globalization.DateTimeStyles styles, out System.DateTime result) => throw null;
        public static bool TryParse(System.ReadOnlySpan<System.Char> s, out System.DateTime result) => throw null;
        public static bool TryParse(string s, System.IFormatProvider provider, System.Globalization.DateTimeStyles styles, out System.DateTime result) => throw null;
        public static bool TryParse(string s, out System.DateTime result) => throw null;
        public static bool TryParseExact(System.ReadOnlySpan<System.Char> s, System.ReadOnlySpan<System.Char> format, System.IFormatProvider provider, System.Globalization.DateTimeStyles style, out System.DateTime result) => throw null;
        public static bool TryParseExact(System.ReadOnlySpan<System.Char> s, string[] formats, System.IFormatProvider provider, System.Globalization.DateTimeStyles style, out System.DateTime result) => throw null;
        public static bool TryParseExact(string s, string[] formats, System.IFormatProvider provider, System.Globalization.DateTimeStyles style, out System.DateTime result) => throw null;
        public static bool TryParseExact(string s, string format, System.IFormatProvider provider, System.Globalization.DateTimeStyles style, out System.DateTime result) => throw null;
        public static System.DateTime UnixEpoch;
        public static System.DateTime UtcNow { get => throw null; }
        public int Year { get => throw null; }
    }

    // Generated from `System.DateTimeKind` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public enum DateTimeKind
    {
        Local,
        Unspecified,
        Utc,
    }

    // Generated from `System.DateTimeOffset` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct DateTimeOffset : System.IComparable, System.IComparable<System.DateTimeOffset>, System.IEquatable<System.DateTimeOffset>, System.IFormattable, System.Runtime.Serialization.IDeserializationCallback, System.Runtime.Serialization.ISerializable
    {
        public static bool operator !=(System.DateTimeOffset left, System.DateTimeOffset right) => throw null;
        public static System.DateTimeOffset operator +(System.DateTimeOffset dateTimeOffset, System.TimeSpan timeSpan) => throw null;
        public static System.TimeSpan operator -(System.DateTimeOffset left, System.DateTimeOffset right) => throw null;
        public static System.DateTimeOffset operator -(System.DateTimeOffset dateTimeOffset, System.TimeSpan timeSpan) => throw null;
        public static bool operator <(System.DateTimeOffset left, System.DateTimeOffset right) => throw null;
        public static bool operator <=(System.DateTimeOffset left, System.DateTimeOffset right) => throw null;
        public static bool operator ==(System.DateTimeOffset left, System.DateTimeOffset right) => throw null;
        public static bool operator >(System.DateTimeOffset left, System.DateTimeOffset right) => throw null;
        public static bool operator >=(System.DateTimeOffset left, System.DateTimeOffset right) => throw null;
        public System.DateTimeOffset Add(System.TimeSpan timeSpan) => throw null;
        public System.DateTimeOffset AddDays(double days) => throw null;
        public System.DateTimeOffset AddHours(double hours) => throw null;
        public System.DateTimeOffset AddMilliseconds(double milliseconds) => throw null;
        public System.DateTimeOffset AddMinutes(double minutes) => throw null;
        public System.DateTimeOffset AddMonths(int months) => throw null;
        public System.DateTimeOffset AddSeconds(double seconds) => throw null;
        public System.DateTimeOffset AddTicks(System.Int64 ticks) => throw null;
        public System.DateTimeOffset AddYears(int years) => throw null;
        public static int Compare(System.DateTimeOffset first, System.DateTimeOffset second) => throw null;
        public int CompareTo(System.DateTimeOffset other) => throw null;
        int System.IComparable.CompareTo(object obj) => throw null;
        public System.DateTime Date { get => throw null; }
        public System.DateTime DateTime { get => throw null; }
        // Stub generator skipped constructor 
        public DateTimeOffset(System.DateTime dateTime) => throw null;
        public DateTimeOffset(System.DateTime dateTime, System.TimeSpan offset) => throw null;
        public DateTimeOffset(int year, int month, int day, int hour, int minute, int second, System.TimeSpan offset) => throw null;
        public DateTimeOffset(int year, int month, int day, int hour, int minute, int second, int millisecond, System.Globalization.Calendar calendar, System.TimeSpan offset) => throw null;
        public DateTimeOffset(int year, int month, int day, int hour, int minute, int second, int millisecond, System.TimeSpan offset) => throw null;
        public DateTimeOffset(System.Int64 ticks, System.TimeSpan offset) => throw null;
        public int Day { get => throw null; }
        public System.DayOfWeek DayOfWeek { get => throw null; }
        public int DayOfYear { get => throw null; }
        public bool Equals(System.DateTimeOffset other) => throw null;
        public static bool Equals(System.DateTimeOffset first, System.DateTimeOffset second) => throw null;
        public override bool Equals(object obj) => throw null;
        public bool EqualsExact(System.DateTimeOffset other) => throw null;
        public static System.DateTimeOffset FromFileTime(System.Int64 fileTime) => throw null;
        public static System.DateTimeOffset FromUnixTimeMilliseconds(System.Int64 milliseconds) => throw null;
        public static System.DateTimeOffset FromUnixTimeSeconds(System.Int64 seconds) => throw null;
        public override int GetHashCode() => throw null;
        void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public int Hour { get => throw null; }
        public System.DateTime LocalDateTime { get => throw null; }
        public static System.DateTimeOffset MaxValue;
        public int Millisecond { get => throw null; }
        public static System.DateTimeOffset MinValue;
        public int Minute { get => throw null; }
        public int Month { get => throw null; }
        public static System.DateTimeOffset Now { get => throw null; }
        public System.TimeSpan Offset { get => throw null; }
        void System.Runtime.Serialization.IDeserializationCallback.OnDeserialization(object sender) => throw null;
        public static System.DateTimeOffset Parse(System.ReadOnlySpan<System.Char> input, System.IFormatProvider formatProvider = default(System.IFormatProvider), System.Globalization.DateTimeStyles styles = default(System.Globalization.DateTimeStyles)) => throw null;
        public static System.DateTimeOffset Parse(string input) => throw null;
        public static System.DateTimeOffset Parse(string input, System.IFormatProvider formatProvider) => throw null;
        public static System.DateTimeOffset Parse(string input, System.IFormatProvider formatProvider, System.Globalization.DateTimeStyles styles) => throw null;
        public static System.DateTimeOffset ParseExact(System.ReadOnlySpan<System.Char> input, System.ReadOnlySpan<System.Char> format, System.IFormatProvider formatProvider, System.Globalization.DateTimeStyles styles = default(System.Globalization.DateTimeStyles)) => throw null;
        public static System.DateTimeOffset ParseExact(System.ReadOnlySpan<System.Char> input, string[] formats, System.IFormatProvider formatProvider, System.Globalization.DateTimeStyles styles = default(System.Globalization.DateTimeStyles)) => throw null;
        public static System.DateTimeOffset ParseExact(string input, string[] formats, System.IFormatProvider formatProvider, System.Globalization.DateTimeStyles styles) => throw null;
        public static System.DateTimeOffset ParseExact(string input, string format, System.IFormatProvider formatProvider) => throw null;
        public static System.DateTimeOffset ParseExact(string input, string format, System.IFormatProvider formatProvider, System.Globalization.DateTimeStyles styles) => throw null;
        public int Second { get => throw null; }
        public System.TimeSpan Subtract(System.DateTimeOffset value) => throw null;
        public System.DateTimeOffset Subtract(System.TimeSpan value) => throw null;
        public System.Int64 Ticks { get => throw null; }
        public System.TimeSpan TimeOfDay { get => throw null; }
        public System.Int64 ToFileTime() => throw null;
        public System.DateTimeOffset ToLocalTime() => throw null;
        public System.DateTimeOffset ToOffset(System.TimeSpan offset) => throw null;
        public override string ToString() => throw null;
        public string ToString(System.IFormatProvider formatProvider) => throw null;
        public string ToString(string format) => throw null;
        public string ToString(string format, System.IFormatProvider formatProvider) => throw null;
        public System.DateTimeOffset ToUniversalTime() => throw null;
        public System.Int64 ToUnixTimeMilliseconds() => throw null;
        public System.Int64 ToUnixTimeSeconds() => throw null;
        public bool TryFormat(System.Span<System.Char> destination, out int charsWritten, System.ReadOnlySpan<System.Char> format = default(System.ReadOnlySpan<System.Char>), System.IFormatProvider formatProvider = default(System.IFormatProvider)) => throw null;
        public static bool TryParse(System.ReadOnlySpan<System.Char> input, System.IFormatProvider formatProvider, System.Globalization.DateTimeStyles styles, out System.DateTimeOffset result) => throw null;
        public static bool TryParse(System.ReadOnlySpan<System.Char> input, out System.DateTimeOffset result) => throw null;
        public static bool TryParse(string input, System.IFormatProvider formatProvider, System.Globalization.DateTimeStyles styles, out System.DateTimeOffset result) => throw null;
        public static bool TryParse(string input, out System.DateTimeOffset result) => throw null;
        public static bool TryParseExact(System.ReadOnlySpan<System.Char> input, System.ReadOnlySpan<System.Char> format, System.IFormatProvider formatProvider, System.Globalization.DateTimeStyles styles, out System.DateTimeOffset result) => throw null;
        public static bool TryParseExact(System.ReadOnlySpan<System.Char> input, string[] formats, System.IFormatProvider formatProvider, System.Globalization.DateTimeStyles styles, out System.DateTimeOffset result) => throw null;
        public static bool TryParseExact(string input, string[] formats, System.IFormatProvider formatProvider, System.Globalization.DateTimeStyles styles, out System.DateTimeOffset result) => throw null;
        public static bool TryParseExact(string input, string format, System.IFormatProvider formatProvider, System.Globalization.DateTimeStyles styles, out System.DateTimeOffset result) => throw null;
        public static System.DateTimeOffset UnixEpoch;
        public System.DateTime UtcDateTime { get => throw null; }
        public static System.DateTimeOffset UtcNow { get => throw null; }
        public System.Int64 UtcTicks { get => throw null; }
        public int Year { get => throw null; }
        public static implicit operator System.DateTimeOffset(System.DateTime dateTime) => throw null;
    }

    // Generated from `System.DayOfWeek` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public enum DayOfWeek
    {
        Friday,
        Monday,
        Saturday,
        Sunday,
        Thursday,
        Tuesday,
        Wednesday,
    }

    // Generated from `System.Decimal` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct Decimal : System.IComparable, System.IComparable<System.Decimal>, System.IConvertible, System.IEquatable<System.Decimal>, System.IFormattable, System.Runtime.Serialization.IDeserializationCallback, System.Runtime.Serialization.ISerializable
    {
        public static bool operator !=(System.Decimal d1, System.Decimal d2) => throw null;
        public static System.Decimal operator %(System.Decimal d1, System.Decimal d2) => throw null;
        public static System.Decimal operator *(System.Decimal d1, System.Decimal d2) => throw null;
        public static System.Decimal operator +(System.Decimal d) => throw null;
        public static System.Decimal operator +(System.Decimal d1, System.Decimal d2) => throw null;
        public static System.Decimal operator ++(System.Decimal d) => throw null;
        public static System.Decimal operator -(System.Decimal d) => throw null;
        public static System.Decimal operator -(System.Decimal d1, System.Decimal d2) => throw null;
        public static System.Decimal operator --(System.Decimal d) => throw null;
        public static System.Decimal operator /(System.Decimal d1, System.Decimal d2) => throw null;
        public static bool operator <(System.Decimal d1, System.Decimal d2) => throw null;
        public static bool operator <=(System.Decimal d1, System.Decimal d2) => throw null;
        public static bool operator ==(System.Decimal d1, System.Decimal d2) => throw null;
        public static bool operator >(System.Decimal d1, System.Decimal d2) => throw null;
        public static bool operator >=(System.Decimal d1, System.Decimal d2) => throw null;
        public static System.Decimal Add(System.Decimal d1, System.Decimal d2) => throw null;
        public static System.Decimal Ceiling(System.Decimal d) => throw null;
        public static int Compare(System.Decimal d1, System.Decimal d2) => throw null;
        public int CompareTo(System.Decimal value) => throw null;
        public int CompareTo(object value) => throw null;
        // Stub generator skipped constructor 
        public Decimal(int[] bits) => throw null;
        public Decimal(System.ReadOnlySpan<int> bits) => throw null;
        public Decimal(double value) => throw null;
        public Decimal(float value) => throw null;
        public Decimal(int value) => throw null;
        public Decimal(int lo, int mid, int hi, bool isNegative, System.Byte scale) => throw null;
        public Decimal(System.Int64 value) => throw null;
        public Decimal(System.UInt32 value) => throw null;
        public Decimal(System.UInt64 value) => throw null;
        public static System.Decimal Divide(System.Decimal d1, System.Decimal d2) => throw null;
        public bool Equals(System.Decimal value) => throw null;
        public static bool Equals(System.Decimal d1, System.Decimal d2) => throw null;
        public override bool Equals(object value) => throw null;
        public static System.Decimal Floor(System.Decimal d) => throw null;
        public static System.Decimal FromOACurrency(System.Int64 cy) => throw null;
        public static int[] GetBits(System.Decimal d) => throw null;
        public static int GetBits(System.Decimal d, System.Span<int> destination) => throw null;
        public override int GetHashCode() => throw null;
        void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public System.TypeCode GetTypeCode() => throw null;
        public const System.Decimal MaxValue = default;
        public const System.Decimal MinValue = default;
        public const System.Decimal MinusOne = default;
        public static System.Decimal Multiply(System.Decimal d1, System.Decimal d2) => throw null;
        public static System.Decimal Negate(System.Decimal d) => throw null;
        void System.Runtime.Serialization.IDeserializationCallback.OnDeserialization(object sender) => throw null;
        public const System.Decimal One = default;
        public static System.Decimal Parse(System.ReadOnlySpan<System.Char> s, System.Globalization.NumberStyles style = default(System.Globalization.NumberStyles), System.IFormatProvider provider = default(System.IFormatProvider)) => throw null;
        public static System.Decimal Parse(string s) => throw null;
        public static System.Decimal Parse(string s, System.IFormatProvider provider) => throw null;
        public static System.Decimal Parse(string s, System.Globalization.NumberStyles style) => throw null;
        public static System.Decimal Parse(string s, System.Globalization.NumberStyles style, System.IFormatProvider provider) => throw null;
        public static System.Decimal Remainder(System.Decimal d1, System.Decimal d2) => throw null;
        public static System.Decimal Round(System.Decimal d) => throw null;
        public static System.Decimal Round(System.Decimal d, System.MidpointRounding mode) => throw null;
        public static System.Decimal Round(System.Decimal d, int decimals) => throw null;
        public static System.Decimal Round(System.Decimal d, int decimals, System.MidpointRounding mode) => throw null;
        public static System.Decimal Subtract(System.Decimal d1, System.Decimal d2) => throw null;
        bool System.IConvertible.ToBoolean(System.IFormatProvider provider) => throw null;
        System.Byte System.IConvertible.ToByte(System.IFormatProvider provider) => throw null;
        public static System.Byte ToByte(System.Decimal value) => throw null;
        System.Char System.IConvertible.ToChar(System.IFormatProvider provider) => throw null;
        System.DateTime System.IConvertible.ToDateTime(System.IFormatProvider provider) => throw null;
        System.Decimal System.IConvertible.ToDecimal(System.IFormatProvider provider) => throw null;
        double System.IConvertible.ToDouble(System.IFormatProvider provider) => throw null;
        public static double ToDouble(System.Decimal d) => throw null;
        System.Int16 System.IConvertible.ToInt16(System.IFormatProvider provider) => throw null;
        public static System.Int16 ToInt16(System.Decimal value) => throw null;
        int System.IConvertible.ToInt32(System.IFormatProvider provider) => throw null;
        public static int ToInt32(System.Decimal d) => throw null;
        System.Int64 System.IConvertible.ToInt64(System.IFormatProvider provider) => throw null;
        public static System.Int64 ToInt64(System.Decimal d) => throw null;
        public static System.Int64 ToOACurrency(System.Decimal value) => throw null;
        System.SByte System.IConvertible.ToSByte(System.IFormatProvider provider) => throw null;
        public static System.SByte ToSByte(System.Decimal value) => throw null;
        float System.IConvertible.ToSingle(System.IFormatProvider provider) => throw null;
        public static float ToSingle(System.Decimal d) => throw null;
        public override string ToString() => throw null;
        public string ToString(System.IFormatProvider provider) => throw null;
        public string ToString(string format) => throw null;
        public string ToString(string format, System.IFormatProvider provider) => throw null;
        object System.IConvertible.ToType(System.Type type, System.IFormatProvider provider) => throw null;
        System.UInt16 System.IConvertible.ToUInt16(System.IFormatProvider provider) => throw null;
        public static System.UInt16 ToUInt16(System.Decimal value) => throw null;
        System.UInt32 System.IConvertible.ToUInt32(System.IFormatProvider provider) => throw null;
        public static System.UInt32 ToUInt32(System.Decimal d) => throw null;
        System.UInt64 System.IConvertible.ToUInt64(System.IFormatProvider provider) => throw null;
        public static System.UInt64 ToUInt64(System.Decimal d) => throw null;
        public static System.Decimal Truncate(System.Decimal d) => throw null;
        public bool TryFormat(System.Span<System.Char> destination, out int charsWritten, System.ReadOnlySpan<System.Char> format = default(System.ReadOnlySpan<System.Char>), System.IFormatProvider provider = default(System.IFormatProvider)) => throw null;
        public static bool TryGetBits(System.Decimal d, System.Span<int> destination, out int valuesWritten) => throw null;
        public static bool TryParse(System.ReadOnlySpan<System.Char> s, System.Globalization.NumberStyles style, System.IFormatProvider provider, out System.Decimal result) => throw null;
        public static bool TryParse(System.ReadOnlySpan<System.Char> s, out System.Decimal result) => throw null;
        public static bool TryParse(string s, System.Globalization.NumberStyles style, System.IFormatProvider provider, out System.Decimal result) => throw null;
        public static bool TryParse(string s, out System.Decimal result) => throw null;
        public const System.Decimal Zero = default;
        public static explicit operator System.Byte(System.Decimal value) => throw null;
        public static explicit operator System.Char(System.Decimal value) => throw null;
        public static explicit operator System.Int16(System.Decimal value) => throw null;
        public static explicit operator System.Int64(System.Decimal value) => throw null;
        public static explicit operator System.SByte(System.Decimal value) => throw null;
        public static explicit operator System.UInt16(System.Decimal value) => throw null;
        public static explicit operator System.UInt32(System.Decimal value) => throw null;
        public static explicit operator System.UInt64(System.Decimal value) => throw null;
        public static explicit operator double(System.Decimal value) => throw null;
        public static explicit operator float(System.Decimal value) => throw null;
        public static explicit operator int(System.Decimal value) => throw null;
        public static explicit operator System.Decimal(double value) => throw null;
        public static explicit operator System.Decimal(float value) => throw null;
        public static implicit operator System.Decimal(System.Byte value) => throw null;
        public static implicit operator System.Decimal(System.Char value) => throw null;
        public static implicit operator System.Decimal(int value) => throw null;
        public static implicit operator System.Decimal(System.Int64 value) => throw null;
        public static implicit operator System.Decimal(System.SByte value) => throw null;
        public static implicit operator System.Decimal(System.Int16 value) => throw null;
        public static implicit operator System.Decimal(System.UInt32 value) => throw null;
        public static implicit operator System.Decimal(System.UInt64 value) => throw null;
        public static implicit operator System.Decimal(System.UInt16 value) => throw null;
    }

    // Generated from `System.Delegate` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public abstract class Delegate : System.ICloneable, System.Runtime.Serialization.ISerializable
    {
        public static bool operator !=(System.Delegate d1, System.Delegate d2) => throw null;
        public static bool operator ==(System.Delegate d1, System.Delegate d2) => throw null;
        public virtual object Clone() => throw null;
        public static System.Delegate Combine(System.Delegate a, System.Delegate b) => throw null;
        public static System.Delegate Combine(params System.Delegate[] delegates) => throw null;
        protected virtual System.Delegate CombineImpl(System.Delegate d) => throw null;
        public static System.Delegate CreateDelegate(System.Type type, System.Reflection.MethodInfo method) => throw null;
        public static System.Delegate CreateDelegate(System.Type type, System.Reflection.MethodInfo method, bool throwOnBindFailure) => throw null;
        public static System.Delegate CreateDelegate(System.Type type, System.Type target, string method) => throw null;
        public static System.Delegate CreateDelegate(System.Type type, System.Type target, string method, bool ignoreCase) => throw null;
        public static System.Delegate CreateDelegate(System.Type type, System.Type target, string method, bool ignoreCase, bool throwOnBindFailure) => throw null;
        public static System.Delegate CreateDelegate(System.Type type, object firstArgument, System.Reflection.MethodInfo method) => throw null;
        public static System.Delegate CreateDelegate(System.Type type, object firstArgument, System.Reflection.MethodInfo method, bool throwOnBindFailure) => throw null;
        public static System.Delegate CreateDelegate(System.Type type, object target, string method) => throw null;
        public static System.Delegate CreateDelegate(System.Type type, object target, string method, bool ignoreCase) => throw null;
        public static System.Delegate CreateDelegate(System.Type type, object target, string method, bool ignoreCase, bool throwOnBindFailure) => throw null;
        protected Delegate(System.Type target, string method) => throw null;
        protected Delegate(object target, string method) => throw null;
        public object DynamicInvoke(params object[] args) => throw null;
        protected virtual object DynamicInvokeImpl(object[] args) => throw null;
        public override bool Equals(object obj) => throw null;
        public override int GetHashCode() => throw null;
        public virtual System.Delegate[] GetInvocationList() => throw null;
        protected virtual System.Reflection.MethodInfo GetMethodImpl() => throw null;
        public virtual void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public System.Reflection.MethodInfo Method { get => throw null; }
        public static System.Delegate Remove(System.Delegate source, System.Delegate value) => throw null;
        public static System.Delegate RemoveAll(System.Delegate source, System.Delegate value) => throw null;
        protected virtual System.Delegate RemoveImpl(System.Delegate d) => throw null;
        public object Target { get => throw null; }
    }

    // Generated from `System.DivideByZeroException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class DivideByZeroException : System.ArithmeticException
    {
        public DivideByZeroException() => throw null;
        protected DivideByZeroException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public DivideByZeroException(string message) => throw null;
        public DivideByZeroException(string message, System.Exception innerException) => throw null;
    }

    // Generated from `System.Double` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct Double : System.IComparable, System.IComparable<double>, System.IConvertible, System.IEquatable<double>, System.IFormattable
    {
        public static bool operator !=(double left, double right) => throw null;
        public static bool operator <(double left, double right) => throw null;
        public static bool operator <=(double left, double right) => throw null;
        public static bool operator ==(double left, double right) => throw null;
        public static bool operator >(double left, double right) => throw null;
        public static bool operator >=(double left, double right) => throw null;
        public int CompareTo(double value) => throw null;
        public int CompareTo(object value) => throw null;
        // Stub generator skipped constructor 
        public const double Epsilon = default;
        public bool Equals(double obj) => throw null;
        public override bool Equals(object obj) => throw null;
        public override int GetHashCode() => throw null;
        public System.TypeCode GetTypeCode() => throw null;
        public static bool IsFinite(double d) => throw null;
        public static bool IsInfinity(double d) => throw null;
        public static bool IsNaN(double d) => throw null;
        public static bool IsNegative(double d) => throw null;
        public static bool IsNegativeInfinity(double d) => throw null;
        public static bool IsNormal(double d) => throw null;
        public static bool IsPositiveInfinity(double d) => throw null;
        public static bool IsSubnormal(double d) => throw null;
        public const double MaxValue = default;
        public const double MinValue = default;
        public const double NaN = default;
        public const double NegativeInfinity = default;
        public static double Parse(System.ReadOnlySpan<System.Char> s, System.Globalization.NumberStyles style = default(System.Globalization.NumberStyles), System.IFormatProvider provider = default(System.IFormatProvider)) => throw null;
        public static double Parse(string s) => throw null;
        public static double Parse(string s, System.IFormatProvider provider) => throw null;
        public static double Parse(string s, System.Globalization.NumberStyles style) => throw null;
        public static double Parse(string s, System.Globalization.NumberStyles style, System.IFormatProvider provider) => throw null;
        public const double PositiveInfinity = default;
        bool System.IConvertible.ToBoolean(System.IFormatProvider provider) => throw null;
        System.Byte System.IConvertible.ToByte(System.IFormatProvider provider) => throw null;
        System.Char System.IConvertible.ToChar(System.IFormatProvider provider) => throw null;
        System.DateTime System.IConvertible.ToDateTime(System.IFormatProvider provider) => throw null;
        System.Decimal System.IConvertible.ToDecimal(System.IFormatProvider provider) => throw null;
        double System.IConvertible.ToDouble(System.IFormatProvider provider) => throw null;
        System.Int16 System.IConvertible.ToInt16(System.IFormatProvider provider) => throw null;
        int System.IConvertible.ToInt32(System.IFormatProvider provider) => throw null;
        System.Int64 System.IConvertible.ToInt64(System.IFormatProvider provider) => throw null;
        System.SByte System.IConvertible.ToSByte(System.IFormatProvider provider) => throw null;
        float System.IConvertible.ToSingle(System.IFormatProvider provider) => throw null;
        public override string ToString() => throw null;
        public string ToString(System.IFormatProvider provider) => throw null;
        public string ToString(string format) => throw null;
        public string ToString(string format, System.IFormatProvider provider) => throw null;
        object System.IConvertible.ToType(System.Type type, System.IFormatProvider provider) => throw null;
        System.UInt16 System.IConvertible.ToUInt16(System.IFormatProvider provider) => throw null;
        System.UInt32 System.IConvertible.ToUInt32(System.IFormatProvider provider) => throw null;
        System.UInt64 System.IConvertible.ToUInt64(System.IFormatProvider provider) => throw null;
        public bool TryFormat(System.Span<System.Char> destination, out int charsWritten, System.ReadOnlySpan<System.Char> format = default(System.ReadOnlySpan<System.Char>), System.IFormatProvider provider = default(System.IFormatProvider)) => throw null;
        public static bool TryParse(System.ReadOnlySpan<System.Char> s, System.Globalization.NumberStyles style, System.IFormatProvider provider, out double result) => throw null;
        public static bool TryParse(System.ReadOnlySpan<System.Char> s, out double result) => throw null;
        public static bool TryParse(string s, System.Globalization.NumberStyles style, System.IFormatProvider provider, out double result) => throw null;
        public static bool TryParse(string s, out double result) => throw null;
    }

    // Generated from `System.DuplicateWaitObjectException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class DuplicateWaitObjectException : System.ArgumentException
    {
        public DuplicateWaitObjectException() => throw null;
        protected DuplicateWaitObjectException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public DuplicateWaitObjectException(string parameterName) => throw null;
        public DuplicateWaitObjectException(string message, System.Exception innerException) => throw null;
        public DuplicateWaitObjectException(string parameterName, string message) => throw null;
    }

    // Generated from `System.EntryPointNotFoundException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class EntryPointNotFoundException : System.TypeLoadException
    {
        public EntryPointNotFoundException() => throw null;
        protected EntryPointNotFoundException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public EntryPointNotFoundException(string message) => throw null;
        public EntryPointNotFoundException(string message, System.Exception inner) => throw null;
    }

    // Generated from `System.Enum` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public abstract class Enum : System.IComparable, System.IConvertible, System.IFormattable
    {
        public int CompareTo(object target) => throw null;
        protected Enum() => throw null;
        public override bool Equals(object obj) => throw null;
        public static string Format(System.Type enumType, object value, string format) => throw null;
        public override int GetHashCode() => throw null;
        public static string GetName(System.Type enumType, object value) => throw null;
        public static string GetName<TEnum>(TEnum value) where TEnum : System.Enum => throw null;
        public static string[] GetNames(System.Type enumType) => throw null;
        public static string[] GetNames<TEnum>() where TEnum : System.Enum => throw null;
        public System.TypeCode GetTypeCode() => throw null;
        public static System.Type GetUnderlyingType(System.Type enumType) => throw null;
        public static System.Array GetValues(System.Type enumType) => throw null;
        public static TEnum[] GetValues<TEnum>() where TEnum : System.Enum => throw null;
        public bool HasFlag(System.Enum flag) => throw null;
        public static bool IsDefined(System.Type enumType, object value) => throw null;
        public static bool IsDefined<TEnum>(TEnum value) where TEnum : System.Enum => throw null;
        public static object Parse(System.Type enumType, string value) => throw null;
        public static object Parse(System.Type enumType, string value, bool ignoreCase) => throw null;
        public static TEnum Parse<TEnum>(string value) where TEnum : struct => throw null;
        public static TEnum Parse<TEnum>(string value, bool ignoreCase) where TEnum : struct => throw null;
        bool System.IConvertible.ToBoolean(System.IFormatProvider provider) => throw null;
        System.Byte System.IConvertible.ToByte(System.IFormatProvider provider) => throw null;
        System.Char System.IConvertible.ToChar(System.IFormatProvider provider) => throw null;
        System.DateTime System.IConvertible.ToDateTime(System.IFormatProvider provider) => throw null;
        System.Decimal System.IConvertible.ToDecimal(System.IFormatProvider provider) => throw null;
        double System.IConvertible.ToDouble(System.IFormatProvider provider) => throw null;
        System.Int16 System.IConvertible.ToInt16(System.IFormatProvider provider) => throw null;
        int System.IConvertible.ToInt32(System.IFormatProvider provider) => throw null;
        System.Int64 System.IConvertible.ToInt64(System.IFormatProvider provider) => throw null;
        public static object ToObject(System.Type enumType, System.Byte value) => throw null;
        public static object ToObject(System.Type enumType, int value) => throw null;
        public static object ToObject(System.Type enumType, System.Int64 value) => throw null;
        public static object ToObject(System.Type enumType, object value) => throw null;
        public static object ToObject(System.Type enumType, System.SByte value) => throw null;
        public static object ToObject(System.Type enumType, System.Int16 value) => throw null;
        public static object ToObject(System.Type enumType, System.UInt32 value) => throw null;
        public static object ToObject(System.Type enumType, System.UInt64 value) => throw null;
        public static object ToObject(System.Type enumType, System.UInt16 value) => throw null;
        System.SByte System.IConvertible.ToSByte(System.IFormatProvider provider) => throw null;
        float System.IConvertible.ToSingle(System.IFormatProvider provider) => throw null;
        public override string ToString() => throw null;
        public string ToString(System.IFormatProvider provider) => throw null;
        public string ToString(string format) => throw null;
        public string ToString(string format, System.IFormatProvider provider) => throw null;
        object System.IConvertible.ToType(System.Type type, System.IFormatProvider provider) => throw null;
        System.UInt16 System.IConvertible.ToUInt16(System.IFormatProvider provider) => throw null;
        System.UInt32 System.IConvertible.ToUInt32(System.IFormatProvider provider) => throw null;
        System.UInt64 System.IConvertible.ToUInt64(System.IFormatProvider provider) => throw null;
        public static bool TryParse(System.Type enumType, string value, bool ignoreCase, out object result) => throw null;
        public static bool TryParse(System.Type enumType, string value, out object result) => throw null;
        public static bool TryParse<TEnum>(string value, bool ignoreCase, out TEnum result) where TEnum : struct => throw null;
        public static bool TryParse<TEnum>(string value, out TEnum result) where TEnum : struct => throw null;
    }

    // Generated from `System.Environment` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public static class Environment
    {
        // Generated from `System.Environment+SpecialFolder` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum SpecialFolder
        {
            AdminTools,
            ApplicationData,
            CDBurning,
            CommonAdminTools,
            CommonApplicationData,
            CommonDesktopDirectory,
            CommonDocuments,
            CommonMusic,
            CommonOemLinks,
            CommonPictures,
            CommonProgramFiles,
            CommonProgramFilesX86,
            CommonPrograms,
            CommonStartMenu,
            CommonStartup,
            CommonTemplates,
            CommonVideos,
            Cookies,
            Desktop,
            DesktopDirectory,
            Favorites,
            Fonts,
            History,
            InternetCache,
            LocalApplicationData,
            LocalizedResources,
            MyComputer,
            MyDocuments,
            MyMusic,
            MyPictures,
            MyVideos,
            NetworkShortcuts,
            Personal,
            PrinterShortcuts,
            ProgramFiles,
            ProgramFilesX86,
            Programs,
            Recent,
            Resources,
            SendTo,
            StartMenu,
            Startup,
            System,
            SystemX86,
            Templates,
            UserProfile,
            Windows,
        }


        // Generated from `System.Environment+SpecialFolderOption` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum SpecialFolderOption
        {
            Create,
            DoNotVerify,
            None,
        }


        public static string CommandLine { get => throw null; }
        public static string CurrentDirectory { get => throw null; set => throw null; }
        public static int CurrentManagedThreadId { get => throw null; }
        public static void Exit(int exitCode) => throw null;
        public static int ExitCode { get => throw null; set => throw null; }
        public static string ExpandEnvironmentVariables(string name) => throw null;
        public static void FailFast(string message) => throw null;
        public static void FailFast(string message, System.Exception exception) => throw null;
        public static string[] GetCommandLineArgs() => throw null;
        public static string GetEnvironmentVariable(string variable) => throw null;
        public static string GetEnvironmentVariable(string variable, System.EnvironmentVariableTarget target) => throw null;
        public static System.Collections.IDictionary GetEnvironmentVariables() => throw null;
        public static System.Collections.IDictionary GetEnvironmentVariables(System.EnvironmentVariableTarget target) => throw null;
        public static string GetFolderPath(System.Environment.SpecialFolder folder) => throw null;
        public static string GetFolderPath(System.Environment.SpecialFolder folder, System.Environment.SpecialFolderOption option) => throw null;
        public static string[] GetLogicalDrives() => throw null;
        public static bool HasShutdownStarted { get => throw null; }
        public static bool Is64BitOperatingSystem { get => throw null; }
        public static bool Is64BitProcess { get => throw null; }
        public static string MachineName { get => throw null; }
        public static string NewLine { get => throw null; }
        public static System.OperatingSystem OSVersion { get => throw null; }
        public static int ProcessId { get => throw null; }
        public static int ProcessorCount { get => throw null; }
        public static void SetEnvironmentVariable(string variable, string value) => throw null;
        public static void SetEnvironmentVariable(string variable, string value, System.EnvironmentVariableTarget target) => throw null;
        public static string StackTrace { get => throw null; }
        public static string SystemDirectory { get => throw null; }
        public static int SystemPageSize { get => throw null; }
        public static int TickCount { get => throw null; }
        public static System.Int64 TickCount64 { get => throw null; }
        public static string UserDomainName { get => throw null; }
        public static bool UserInteractive { get => throw null; }
        public static string UserName { get => throw null; }
        public static System.Version Version { get => throw null; }
        public static System.Int64 WorkingSet { get => throw null; }
    }

    // Generated from `System.EnvironmentVariableTarget` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public enum EnvironmentVariableTarget
    {
        Machine,
        Process,
        User,
    }

    // Generated from `System.EventArgs` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class EventArgs
    {
        public static System.EventArgs Empty;
        public EventArgs() => throw null;
    }

    // Generated from `System.EventHandler` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate void EventHandler(object sender, System.EventArgs e);

    // Generated from `System.EventHandler<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate void EventHandler<TEventArgs>(object sender, TEventArgs e);

    // Generated from `System.Exception` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class Exception : System.Runtime.Serialization.ISerializable
    {
        public virtual System.Collections.IDictionary Data { get => throw null; }
        public Exception() => throw null;
        protected Exception(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public Exception(string message) => throw null;
        public Exception(string message, System.Exception innerException) => throw null;
        public virtual System.Exception GetBaseException() => throw null;
        public virtual void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public System.Type GetType() => throw null;
        public int HResult { get => throw null; set => throw null; }
        public virtual string HelpLink { get => throw null; set => throw null; }
        public System.Exception InnerException { get => throw null; }
        public virtual string Message { get => throw null; }
        protected event System.EventHandler<System.Runtime.Serialization.SafeSerializationEventArgs> SerializeObjectState;
        public virtual string Source { get => throw null; set => throw null; }
        public virtual string StackTrace { get => throw null; }
        public System.Reflection.MethodBase TargetSite { get => throw null; }
        public override string ToString() => throw null;
    }

    // Generated from `System.ExecutionEngineException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class ExecutionEngineException : System.SystemException
    {
        public ExecutionEngineException() => throw null;
        public ExecutionEngineException(string message) => throw null;
        public ExecutionEngineException(string message, System.Exception innerException) => throw null;
    }

    // Generated from `System.FieldAccessException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class FieldAccessException : System.MemberAccessException
    {
        public FieldAccessException() => throw null;
        protected FieldAccessException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public FieldAccessException(string message) => throw null;
        public FieldAccessException(string message, System.Exception inner) => throw null;
    }

    // Generated from `System.FileStyleUriParser` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class FileStyleUriParser : System.UriParser
    {
        public FileStyleUriParser() => throw null;
    }

    // Generated from `System.FlagsAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class FlagsAttribute : System.Attribute
    {
        public FlagsAttribute() => throw null;
    }

    // Generated from `System.FormatException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class FormatException : System.SystemException
    {
        public FormatException() => throw null;
        protected FormatException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public FormatException(string message) => throw null;
        public FormatException(string message, System.Exception innerException) => throw null;
    }

    // Generated from `System.FormattableString` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public abstract class FormattableString : System.IFormattable
    {
        public abstract int ArgumentCount { get; }
        public static string CurrentCulture(System.FormattableString formattable) => throw null;
        public abstract string Format { get; }
        protected FormattableString() => throw null;
        public abstract object GetArgument(int index);
        public abstract object[] GetArguments();
        public static string Invariant(System.FormattableString formattable) => throw null;
        public override string ToString() => throw null;
        public abstract string ToString(System.IFormatProvider formatProvider);
        string System.IFormattable.ToString(string ignored, System.IFormatProvider formatProvider) => throw null;
    }

    // Generated from `System.FtpStyleUriParser` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class FtpStyleUriParser : System.UriParser
    {
        public FtpStyleUriParser() => throw null;
    }

    // Generated from `System.Func<,,,,,,,,,,,,,,,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate TResult Func<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, TResult>(T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8, T9 arg9, T10 arg10, T11 arg11, T12 arg12, T13 arg13, T14 arg14, T15 arg15, T16 arg16);

    // Generated from `System.Func<,,,,,,,,,,,,,,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate TResult Func<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, TResult>(T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8, T9 arg9, T10 arg10, T11 arg11, T12 arg12, T13 arg13, T14 arg14, T15 arg15);

    // Generated from `System.Func<,,,,,,,,,,,,,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate TResult Func<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, TResult>(T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8, T9 arg9, T10 arg10, T11 arg11, T12 arg12, T13 arg13, T14 arg14);

    // Generated from `System.Func<,,,,,,,,,,,,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate TResult Func<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, TResult>(T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8, T9 arg9, T10 arg10, T11 arg11, T12 arg12, T13 arg13);

    // Generated from `System.Func<,,,,,,,,,,,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate TResult Func<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, TResult>(T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8, T9 arg9, T10 arg10, T11 arg11, T12 arg12);

    // Generated from `System.Func<,,,,,,,,,,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate TResult Func<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, TResult>(T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8, T9 arg9, T10 arg10, T11 arg11);

    // Generated from `System.Func<,,,,,,,,,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate TResult Func<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, TResult>(T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8, T9 arg9, T10 arg10);

    // Generated from `System.Func<,,,,,,,,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate TResult Func<T1, T2, T3, T4, T5, T6, T7, T8, T9, TResult>(T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8, T9 arg9);

    // Generated from `System.Func<,,,,,,,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate TResult Func<T1, T2, T3, T4, T5, T6, T7, T8, TResult>(T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8);

    // Generated from `System.Func<,,,,,,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate TResult Func<T1, T2, T3, T4, T5, T6, T7, TResult>(T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7);

    // Generated from `System.Func<,,,,,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate TResult Func<T1, T2, T3, T4, T5, T6, TResult>(T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6);

    // Generated from `System.Func<,,,,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate TResult Func<T1, T2, T3, T4, T5, TResult>(T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5);

    // Generated from `System.Func<,,,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate TResult Func<T1, T2, T3, T4, TResult>(T1 arg1, T2 arg2, T3 arg3, T4 arg4);

    // Generated from `System.Func<,,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate TResult Func<T1, T2, T3, TResult>(T1 arg1, T2 arg2, T3 arg3);

    // Generated from `System.Func<,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate TResult Func<T1, T2, TResult>(T1 arg1, T2 arg2);

    // Generated from `System.Func<,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate TResult Func<T, TResult>(T arg);

    // Generated from `System.Func<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate TResult Func<TResult>();

    // Generated from `System.GC` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public static class GC
    {
        public static void AddMemoryPressure(System.Int64 bytesAllocated) => throw null;
        public static T[] AllocateArray<T>(int length, bool pinned = default(bool)) => throw null;
        public static T[] AllocateUninitializedArray<T>(int length, bool pinned = default(bool)) => throw null;
        public static void CancelFullGCNotification() => throw null;
        public static void Collect() => throw null;
        public static void Collect(int generation) => throw null;
        public static void Collect(int generation, System.GCCollectionMode mode) => throw null;
        public static void Collect(int generation, System.GCCollectionMode mode, bool blocking) => throw null;
        public static void Collect(int generation, System.GCCollectionMode mode, bool blocking, bool compacting) => throw null;
        public static int CollectionCount(int generation) => throw null;
        public static void EndNoGCRegion() => throw null;
        public static System.Int64 GetAllocatedBytesForCurrentThread() => throw null;
        public static System.GCMemoryInfo GetGCMemoryInfo() => throw null;
        public static System.GCMemoryInfo GetGCMemoryInfo(System.GCKind kind) => throw null;
        public static int GetGeneration(System.WeakReference wo) => throw null;
        public static int GetGeneration(object obj) => throw null;
        public static System.Int64 GetTotalAllocatedBytes(bool precise = default(bool)) => throw null;
        public static System.Int64 GetTotalMemory(bool forceFullCollection) => throw null;
        public static void KeepAlive(object obj) => throw null;
        public static int MaxGeneration { get => throw null; }
        public static void ReRegisterForFinalize(object obj) => throw null;
        public static void RegisterForFullGCNotification(int maxGenerationThreshold, int largeObjectHeapThreshold) => throw null;
        public static void RemoveMemoryPressure(System.Int64 bytesAllocated) => throw null;
        public static void SuppressFinalize(object obj) => throw null;
        public static bool TryStartNoGCRegion(System.Int64 totalSize) => throw null;
        public static bool TryStartNoGCRegion(System.Int64 totalSize, bool disallowFullBlockingGC) => throw null;
        public static bool TryStartNoGCRegion(System.Int64 totalSize, System.Int64 lohSize) => throw null;
        public static bool TryStartNoGCRegion(System.Int64 totalSize, System.Int64 lohSize, bool disallowFullBlockingGC) => throw null;
        public static System.GCNotificationStatus WaitForFullGCApproach() => throw null;
        public static System.GCNotificationStatus WaitForFullGCApproach(int millisecondsTimeout) => throw null;
        public static System.GCNotificationStatus WaitForFullGCComplete() => throw null;
        public static System.GCNotificationStatus WaitForFullGCComplete(int millisecondsTimeout) => throw null;
        public static void WaitForPendingFinalizers() => throw null;
    }

    // Generated from `System.GCCollectionMode` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public enum GCCollectionMode
    {
        Default,
        Forced,
        Optimized,
    }

    // Generated from `System.GCGenerationInfo` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct GCGenerationInfo
    {
        public System.Int64 FragmentationAfterBytes { get => throw null; }
        public System.Int64 FragmentationBeforeBytes { get => throw null; }
        // Stub generator skipped constructor 
        public System.Int64 SizeAfterBytes { get => throw null; }
        public System.Int64 SizeBeforeBytes { get => throw null; }
    }

    // Generated from `System.GCKind` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public enum GCKind
    {
        Any,
        Background,
        Ephemeral,
        FullBlocking,
    }

    // Generated from `System.GCMemoryInfo` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct GCMemoryInfo
    {
        public bool Compacted { get => throw null; }
        public bool Concurrent { get => throw null; }
        public System.Int64 FinalizationPendingCount { get => throw null; }
        public System.Int64 FragmentedBytes { get => throw null; }
        // Stub generator skipped constructor 
        public int Generation { get => throw null; }
        public System.ReadOnlySpan<System.GCGenerationInfo> GenerationInfo { get => throw null; }
        public System.Int64 HeapSizeBytes { get => throw null; }
        public System.Int64 HighMemoryLoadThresholdBytes { get => throw null; }
        public System.Int64 Index { get => throw null; }
        public System.Int64 MemoryLoadBytes { get => throw null; }
        public System.ReadOnlySpan<System.TimeSpan> PauseDurations { get => throw null; }
        public double PauseTimePercentage { get => throw null; }
        public System.Int64 PinnedObjectsCount { get => throw null; }
        public System.Int64 PromotedBytes { get => throw null; }
        public System.Int64 TotalAvailableMemoryBytes { get => throw null; }
        public System.Int64 TotalCommittedBytes { get => throw null; }
    }

    // Generated from `System.GCNotificationStatus` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public enum GCNotificationStatus
    {
        Canceled,
        Failed,
        NotApplicable,
        Succeeded,
        Timeout,
    }

    // Generated from `System.GenericUriParser` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class GenericUriParser : System.UriParser
    {
        public GenericUriParser(System.GenericUriParserOptions options) => throw null;
    }

    // Generated from `System.GenericUriParserOptions` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    [System.Flags]
    public enum GenericUriParserOptions
    {
        AllowEmptyAuthority,
        Default,
        DontCompressPath,
        DontConvertPathBackslashes,
        DontUnescapePathDotsAndSlashes,
        GenericAuthority,
        Idn,
        IriParsing,
        NoFragment,
        NoPort,
        NoQuery,
        NoUserInfo,
    }

    // Generated from `System.GopherStyleUriParser` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class GopherStyleUriParser : System.UriParser
    {
        public GopherStyleUriParser() => throw null;
    }

    // Generated from `System.Guid` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct Guid : System.IComparable, System.IComparable<System.Guid>, System.IEquatable<System.Guid>, System.IFormattable
    {
        public static bool operator !=(System.Guid a, System.Guid b) => throw null;
        public static bool operator ==(System.Guid a, System.Guid b) => throw null;
        public int CompareTo(System.Guid value) => throw null;
        public int CompareTo(object value) => throw null;
        public static System.Guid Empty;
        public bool Equals(System.Guid g) => throw null;
        public override bool Equals(object o) => throw null;
        public override int GetHashCode() => throw null;
        // Stub generator skipped constructor 
        public Guid(System.Byte[] b) => throw null;
        public Guid(System.ReadOnlySpan<System.Byte> b) => throw null;
        public Guid(int a, System.Int16 b, System.Int16 c, System.Byte[] d) => throw null;
        public Guid(int a, System.Int16 b, System.Int16 c, System.Byte d, System.Byte e, System.Byte f, System.Byte g, System.Byte h, System.Byte i, System.Byte j, System.Byte k) => throw null;
        public Guid(string g) => throw null;
        public Guid(System.UInt32 a, System.UInt16 b, System.UInt16 c, System.Byte d, System.Byte e, System.Byte f, System.Byte g, System.Byte h, System.Byte i, System.Byte j, System.Byte k) => throw null;
        public static System.Guid NewGuid() => throw null;
        public static System.Guid Parse(System.ReadOnlySpan<System.Char> input) => throw null;
        public static System.Guid Parse(string input) => throw null;
        public static System.Guid ParseExact(System.ReadOnlySpan<System.Char> input, System.ReadOnlySpan<System.Char> format) => throw null;
        public static System.Guid ParseExact(string input, string format) => throw null;
        public System.Byte[] ToByteArray() => throw null;
        public override string ToString() => throw null;
        public string ToString(string format) => throw null;
        public string ToString(string format, System.IFormatProvider provider) => throw null;
        public bool TryFormat(System.Span<System.Char> destination, out int charsWritten, System.ReadOnlySpan<System.Char> format = default(System.ReadOnlySpan<System.Char>)) => throw null;
        public static bool TryParse(System.ReadOnlySpan<System.Char> input, out System.Guid result) => throw null;
        public static bool TryParse(string input, out System.Guid result) => throw null;
        public static bool TryParseExact(System.ReadOnlySpan<System.Char> input, System.ReadOnlySpan<System.Char> format, out System.Guid result) => throw null;
        public static bool TryParseExact(string input, string format, out System.Guid result) => throw null;
        public bool TryWriteBytes(System.Span<System.Byte> destination) => throw null;
    }

    // Generated from `System.Half` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct Half : System.IComparable, System.IComparable<System.Half>, System.IEquatable<System.Half>, System.IFormattable
    {
        public static bool operator !=(System.Half left, System.Half right) => throw null;
        public static bool operator <(System.Half left, System.Half right) => throw null;
        public static bool operator <=(System.Half left, System.Half right) => throw null;
        public static bool operator ==(System.Half left, System.Half right) => throw null;
        public static bool operator >(System.Half left, System.Half right) => throw null;
        public static bool operator >=(System.Half left, System.Half right) => throw null;
        public int CompareTo(System.Half other) => throw null;
        public int CompareTo(object obj) => throw null;
        public static System.Half Epsilon { get => throw null; }
        public bool Equals(System.Half other) => throw null;
        public override bool Equals(object obj) => throw null;
        public override int GetHashCode() => throw null;
        // Stub generator skipped constructor 
        public static bool IsFinite(System.Half value) => throw null;
        public static bool IsInfinity(System.Half value) => throw null;
        public static bool IsNaN(System.Half value) => throw null;
        public static bool IsNegative(System.Half value) => throw null;
        public static bool IsNegativeInfinity(System.Half value) => throw null;
        public static bool IsNormal(System.Half value) => throw null;
        public static bool IsPositiveInfinity(System.Half value) => throw null;
        public static bool IsSubnormal(System.Half value) => throw null;
        public static System.Half MaxValue { get => throw null; }
        public static System.Half MinValue { get => throw null; }
        public static System.Half NaN { get => throw null; }
        public static System.Half NegativeInfinity { get => throw null; }
        public static System.Half Parse(System.ReadOnlySpan<System.Char> s, System.Globalization.NumberStyles style = default(System.Globalization.NumberStyles), System.IFormatProvider provider = default(System.IFormatProvider)) => throw null;
        public static System.Half Parse(string s) => throw null;
        public static System.Half Parse(string s, System.IFormatProvider provider) => throw null;
        public static System.Half Parse(string s, System.Globalization.NumberStyles style) => throw null;
        public static System.Half Parse(string s, System.Globalization.NumberStyles style = default(System.Globalization.NumberStyles), System.IFormatProvider provider = default(System.IFormatProvider)) => throw null;
        public static System.Half PositiveInfinity { get => throw null; }
        public override string ToString() => throw null;
        public string ToString(System.IFormatProvider provider) => throw null;
        public string ToString(string format) => throw null;
        public string ToString(string format, System.IFormatProvider provider) => throw null;
        public bool TryFormat(System.Span<System.Char> destination, out int charsWritten, System.ReadOnlySpan<System.Char> format = default(System.ReadOnlySpan<System.Char>), System.IFormatProvider provider = default(System.IFormatProvider)) => throw null;
        public static bool TryParse(System.ReadOnlySpan<System.Char> s, System.Globalization.NumberStyles style, System.IFormatProvider provider, out System.Half result) => throw null;
        public static bool TryParse(System.ReadOnlySpan<System.Char> s, out System.Half result) => throw null;
        public static bool TryParse(string s, System.Globalization.NumberStyles style, System.IFormatProvider provider, out System.Half result) => throw null;
        public static bool TryParse(string s, out System.Half result) => throw null;
        public static explicit operator double(System.Half value) => throw null;
        public static explicit operator float(System.Half value) => throw null;
        public static explicit operator System.Half(double value) => throw null;
        public static explicit operator System.Half(float value) => throw null;
    }

    // Generated from `System.HashCode` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct HashCode
    {
        public void Add<T>(T value) => throw null;
        public void Add<T>(T value, System.Collections.Generic.IEqualityComparer<T> comparer) => throw null;
        public static int Combine<T1, T2, T3, T4, T5, T6, T7, T8>(T1 value1, T2 value2, T3 value3, T4 value4, T5 value5, T6 value6, T7 value7, T8 value8) => throw null;
        public static int Combine<T1, T2, T3, T4, T5, T6, T7>(T1 value1, T2 value2, T3 value3, T4 value4, T5 value5, T6 value6, T7 value7) => throw null;
        public static int Combine<T1, T2, T3, T4, T5, T6>(T1 value1, T2 value2, T3 value3, T4 value4, T5 value5, T6 value6) => throw null;
        public static int Combine<T1, T2, T3, T4, T5>(T1 value1, T2 value2, T3 value3, T4 value4, T5 value5) => throw null;
        public static int Combine<T1, T2, T3, T4>(T1 value1, T2 value2, T3 value3, T4 value4) => throw null;
        public static int Combine<T1, T2, T3>(T1 value1, T2 value2, T3 value3) => throw null;
        public static int Combine<T1, T2>(T1 value1, T2 value2) => throw null;
        public static int Combine<T1>(T1 value1) => throw null;
        public override bool Equals(object obj) => throw null;
        public override int GetHashCode() => throw null;
        // Stub generator skipped constructor 
        public int ToHashCode() => throw null;
    }

    // Generated from `System.HttpStyleUriParser` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class HttpStyleUriParser : System.UriParser
    {
        public HttpStyleUriParser() => throw null;
    }

    // Generated from `System.IAsyncDisposable` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public interface IAsyncDisposable
    {
        System.Threading.Tasks.ValueTask DisposeAsync();
    }

    // Generated from `System.IAsyncResult` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public interface IAsyncResult
    {
        object AsyncState { get; }
        System.Threading.WaitHandle AsyncWaitHandle { get; }
        bool CompletedSynchronously { get; }
        bool IsCompleted { get; }
    }

    // Generated from `System.ICloneable` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public interface ICloneable
    {
        object Clone();
    }

    // Generated from `System.IComparable` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public interface IComparable
    {
        int CompareTo(object obj);
    }

    // Generated from `System.IComparable<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public interface IComparable<T>
    {
        int CompareTo(T other);
    }

    // Generated from `System.IConvertible` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public interface IConvertible
    {
        System.TypeCode GetTypeCode();
        bool ToBoolean(System.IFormatProvider provider);
        System.Byte ToByte(System.IFormatProvider provider);
        System.Char ToChar(System.IFormatProvider provider);
        System.DateTime ToDateTime(System.IFormatProvider provider);
        System.Decimal ToDecimal(System.IFormatProvider provider);
        double ToDouble(System.IFormatProvider provider);
        System.Int16 ToInt16(System.IFormatProvider provider);
        int ToInt32(System.IFormatProvider provider);
        System.Int64 ToInt64(System.IFormatProvider provider);
        System.SByte ToSByte(System.IFormatProvider provider);
        float ToSingle(System.IFormatProvider provider);
        string ToString(System.IFormatProvider provider);
        object ToType(System.Type conversionType, System.IFormatProvider provider);
        System.UInt16 ToUInt16(System.IFormatProvider provider);
        System.UInt32 ToUInt32(System.IFormatProvider provider);
        System.UInt64 ToUInt64(System.IFormatProvider provider);
    }

    // Generated from `System.ICustomFormatter` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public interface ICustomFormatter
    {
        string Format(string format, object arg, System.IFormatProvider formatProvider);
    }

    // Generated from `System.IDisposable` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public interface IDisposable
    {
        void Dispose();
    }

    // Generated from `System.IEquatable<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public interface IEquatable<T>
    {
        bool Equals(T other);
    }

    // Generated from `System.IFormatProvider` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public interface IFormatProvider
    {
        object GetFormat(System.Type formatType);
    }

    // Generated from `System.IFormattable` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public interface IFormattable
    {
        string ToString(string format, System.IFormatProvider formatProvider);
    }

    // Generated from `System.IObservable<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public interface IObservable<T>
    {
        System.IDisposable Subscribe(System.IObserver<T> observer);
    }

    // Generated from `System.IObserver<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public interface IObserver<T>
    {
        void OnCompleted();
        void OnError(System.Exception error);
        void OnNext(T value);
    }

    // Generated from `System.IProgress<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public interface IProgress<T>
    {
        void Report(T value);
    }

    // Generated from `System.Index` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct Index : System.IEquatable<System.Index>
    {
        public static System.Index End { get => throw null; }
        public bool Equals(System.Index other) => throw null;
        public override bool Equals(object value) => throw null;
        public static System.Index FromEnd(int value) => throw null;
        public static System.Index FromStart(int value) => throw null;
        public override int GetHashCode() => throw null;
        public int GetOffset(int length) => throw null;
        // Stub generator skipped constructor 
        public Index(int value, bool fromEnd = default(bool)) => throw null;
        public bool IsFromEnd { get => throw null; }
        public static System.Index Start { get => throw null; }
        public override string ToString() => throw null;
        public int Value { get => throw null; }
        public static implicit operator System.Index(int value) => throw null;
    }

    // Generated from `System.IndexOutOfRangeException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class IndexOutOfRangeException : System.SystemException
    {
        public IndexOutOfRangeException() => throw null;
        public IndexOutOfRangeException(string message) => throw null;
        public IndexOutOfRangeException(string message, System.Exception innerException) => throw null;
    }

    // Generated from `System.InsufficientExecutionStackException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class InsufficientExecutionStackException : System.SystemException
    {
        public InsufficientExecutionStackException() => throw null;
        public InsufficientExecutionStackException(string message) => throw null;
        public InsufficientExecutionStackException(string message, System.Exception innerException) => throw null;
    }

    // Generated from `System.InsufficientMemoryException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class InsufficientMemoryException : System.OutOfMemoryException
    {
        public InsufficientMemoryException() => throw null;
        public InsufficientMemoryException(string message) => throw null;
        public InsufficientMemoryException(string message, System.Exception innerException) => throw null;
    }

    // Generated from `System.Int16` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct Int16 : System.IComparable, System.IComparable<System.Int16>, System.IConvertible, System.IEquatable<System.Int16>, System.IFormattable
    {
        public int CompareTo(object value) => throw null;
        public int CompareTo(System.Int16 value) => throw null;
        public override bool Equals(object obj) => throw null;
        public bool Equals(System.Int16 obj) => throw null;
        public override int GetHashCode() => throw null;
        public System.TypeCode GetTypeCode() => throw null;
        // Stub generator skipped constructor 
        public const System.Int16 MaxValue = default;
        public const System.Int16 MinValue = default;
        public static System.Int16 Parse(System.ReadOnlySpan<System.Char> s, System.Globalization.NumberStyles style = default(System.Globalization.NumberStyles), System.IFormatProvider provider = default(System.IFormatProvider)) => throw null;
        public static System.Int16 Parse(string s) => throw null;
        public static System.Int16 Parse(string s, System.IFormatProvider provider) => throw null;
        public static System.Int16 Parse(string s, System.Globalization.NumberStyles style) => throw null;
        public static System.Int16 Parse(string s, System.Globalization.NumberStyles style, System.IFormatProvider provider) => throw null;
        bool System.IConvertible.ToBoolean(System.IFormatProvider provider) => throw null;
        System.Byte System.IConvertible.ToByte(System.IFormatProvider provider) => throw null;
        System.Char System.IConvertible.ToChar(System.IFormatProvider provider) => throw null;
        System.DateTime System.IConvertible.ToDateTime(System.IFormatProvider provider) => throw null;
        System.Decimal System.IConvertible.ToDecimal(System.IFormatProvider provider) => throw null;
        double System.IConvertible.ToDouble(System.IFormatProvider provider) => throw null;
        System.Int16 System.IConvertible.ToInt16(System.IFormatProvider provider) => throw null;
        int System.IConvertible.ToInt32(System.IFormatProvider provider) => throw null;
        System.Int64 System.IConvertible.ToInt64(System.IFormatProvider provider) => throw null;
        System.SByte System.IConvertible.ToSByte(System.IFormatProvider provider) => throw null;
        float System.IConvertible.ToSingle(System.IFormatProvider provider) => throw null;
        public override string ToString() => throw null;
        public string ToString(System.IFormatProvider provider) => throw null;
        public string ToString(string format) => throw null;
        public string ToString(string format, System.IFormatProvider provider) => throw null;
        object System.IConvertible.ToType(System.Type type, System.IFormatProvider provider) => throw null;
        System.UInt16 System.IConvertible.ToUInt16(System.IFormatProvider provider) => throw null;
        System.UInt32 System.IConvertible.ToUInt32(System.IFormatProvider provider) => throw null;
        System.UInt64 System.IConvertible.ToUInt64(System.IFormatProvider provider) => throw null;
        public bool TryFormat(System.Span<System.Char> destination, out int charsWritten, System.ReadOnlySpan<System.Char> format = default(System.ReadOnlySpan<System.Char>), System.IFormatProvider provider = default(System.IFormatProvider)) => throw null;
        public static bool TryParse(System.ReadOnlySpan<System.Char> s, System.Globalization.NumberStyles style, System.IFormatProvider provider, out System.Int16 result) => throw null;
        public static bool TryParse(System.ReadOnlySpan<System.Char> s, out System.Int16 result) => throw null;
        public static bool TryParse(string s, System.Globalization.NumberStyles style, System.IFormatProvider provider, out System.Int16 result) => throw null;
        public static bool TryParse(string s, out System.Int16 result) => throw null;
    }

    // Generated from `System.Int32` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct Int32 : System.IComparable, System.IComparable<int>, System.IConvertible, System.IEquatable<int>, System.IFormattable
    {
        public int CompareTo(int value) => throw null;
        public int CompareTo(object value) => throw null;
        public bool Equals(int obj) => throw null;
        public override bool Equals(object obj) => throw null;
        public override int GetHashCode() => throw null;
        public System.TypeCode GetTypeCode() => throw null;
        // Stub generator skipped constructor 
        public const int MaxValue = default;
        public const int MinValue = default;
        public static int Parse(System.ReadOnlySpan<System.Char> s, System.Globalization.NumberStyles style = default(System.Globalization.NumberStyles), System.IFormatProvider provider = default(System.IFormatProvider)) => throw null;
        public static int Parse(string s) => throw null;
        public static int Parse(string s, System.IFormatProvider provider) => throw null;
        public static int Parse(string s, System.Globalization.NumberStyles style) => throw null;
        public static int Parse(string s, System.Globalization.NumberStyles style, System.IFormatProvider provider) => throw null;
        bool System.IConvertible.ToBoolean(System.IFormatProvider provider) => throw null;
        System.Byte System.IConvertible.ToByte(System.IFormatProvider provider) => throw null;
        System.Char System.IConvertible.ToChar(System.IFormatProvider provider) => throw null;
        System.DateTime System.IConvertible.ToDateTime(System.IFormatProvider provider) => throw null;
        System.Decimal System.IConvertible.ToDecimal(System.IFormatProvider provider) => throw null;
        double System.IConvertible.ToDouble(System.IFormatProvider provider) => throw null;
        System.Int16 System.IConvertible.ToInt16(System.IFormatProvider provider) => throw null;
        int System.IConvertible.ToInt32(System.IFormatProvider provider) => throw null;
        System.Int64 System.IConvertible.ToInt64(System.IFormatProvider provider) => throw null;
        System.SByte System.IConvertible.ToSByte(System.IFormatProvider provider) => throw null;
        float System.IConvertible.ToSingle(System.IFormatProvider provider) => throw null;
        public override string ToString() => throw null;
        public string ToString(System.IFormatProvider provider) => throw null;
        public string ToString(string format) => throw null;
        public string ToString(string format, System.IFormatProvider provider) => throw null;
        object System.IConvertible.ToType(System.Type type, System.IFormatProvider provider) => throw null;
        System.UInt16 System.IConvertible.ToUInt16(System.IFormatProvider provider) => throw null;
        System.UInt32 System.IConvertible.ToUInt32(System.IFormatProvider provider) => throw null;
        System.UInt64 System.IConvertible.ToUInt64(System.IFormatProvider provider) => throw null;
        public bool TryFormat(System.Span<System.Char> destination, out int charsWritten, System.ReadOnlySpan<System.Char> format = default(System.ReadOnlySpan<System.Char>), System.IFormatProvider provider = default(System.IFormatProvider)) => throw null;
        public static bool TryParse(System.ReadOnlySpan<System.Char> s, System.Globalization.NumberStyles style, System.IFormatProvider provider, out int result) => throw null;
        public static bool TryParse(System.ReadOnlySpan<System.Char> s, out int result) => throw null;
        public static bool TryParse(string s, System.Globalization.NumberStyles style, System.IFormatProvider provider, out int result) => throw null;
        public static bool TryParse(string s, out int result) => throw null;
    }

    // Generated from `System.Int64` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct Int64 : System.IComparable, System.IComparable<System.Int64>, System.IConvertible, System.IEquatable<System.Int64>, System.IFormattable
    {
        public int CompareTo(System.Int64 value) => throw null;
        public int CompareTo(object value) => throw null;
        public bool Equals(System.Int64 obj) => throw null;
        public override bool Equals(object obj) => throw null;
        public override int GetHashCode() => throw null;
        public System.TypeCode GetTypeCode() => throw null;
        // Stub generator skipped constructor 
        public const System.Int64 MaxValue = default;
        public const System.Int64 MinValue = default;
        public static System.Int64 Parse(System.ReadOnlySpan<System.Char> s, System.Globalization.NumberStyles style = default(System.Globalization.NumberStyles), System.IFormatProvider provider = default(System.IFormatProvider)) => throw null;
        public static System.Int64 Parse(string s) => throw null;
        public static System.Int64 Parse(string s, System.IFormatProvider provider) => throw null;
        public static System.Int64 Parse(string s, System.Globalization.NumberStyles style) => throw null;
        public static System.Int64 Parse(string s, System.Globalization.NumberStyles style, System.IFormatProvider provider) => throw null;
        bool System.IConvertible.ToBoolean(System.IFormatProvider provider) => throw null;
        System.Byte System.IConvertible.ToByte(System.IFormatProvider provider) => throw null;
        System.Char System.IConvertible.ToChar(System.IFormatProvider provider) => throw null;
        System.DateTime System.IConvertible.ToDateTime(System.IFormatProvider provider) => throw null;
        System.Decimal System.IConvertible.ToDecimal(System.IFormatProvider provider) => throw null;
        double System.IConvertible.ToDouble(System.IFormatProvider provider) => throw null;
        System.Int16 System.IConvertible.ToInt16(System.IFormatProvider provider) => throw null;
        int System.IConvertible.ToInt32(System.IFormatProvider provider) => throw null;
        System.Int64 System.IConvertible.ToInt64(System.IFormatProvider provider) => throw null;
        System.SByte System.IConvertible.ToSByte(System.IFormatProvider provider) => throw null;
        float System.IConvertible.ToSingle(System.IFormatProvider provider) => throw null;
        public override string ToString() => throw null;
        public string ToString(System.IFormatProvider provider) => throw null;
        public string ToString(string format) => throw null;
        public string ToString(string format, System.IFormatProvider provider) => throw null;
        object System.IConvertible.ToType(System.Type type, System.IFormatProvider provider) => throw null;
        System.UInt16 System.IConvertible.ToUInt16(System.IFormatProvider provider) => throw null;
        System.UInt32 System.IConvertible.ToUInt32(System.IFormatProvider provider) => throw null;
        System.UInt64 System.IConvertible.ToUInt64(System.IFormatProvider provider) => throw null;
        public bool TryFormat(System.Span<System.Char> destination, out int charsWritten, System.ReadOnlySpan<System.Char> format = default(System.ReadOnlySpan<System.Char>), System.IFormatProvider provider = default(System.IFormatProvider)) => throw null;
        public static bool TryParse(System.ReadOnlySpan<System.Char> s, System.Globalization.NumberStyles style, System.IFormatProvider provider, out System.Int64 result) => throw null;
        public static bool TryParse(System.ReadOnlySpan<System.Char> s, out System.Int64 result) => throw null;
        public static bool TryParse(string s, System.Globalization.NumberStyles style, System.IFormatProvider provider, out System.Int64 result) => throw null;
        public static bool TryParse(string s, out System.Int64 result) => throw null;
    }

    // Generated from `System.IntPtr` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct IntPtr : System.IComparable, System.IComparable<System.IntPtr>, System.IEquatable<System.IntPtr>, System.IFormattable, System.Runtime.Serialization.ISerializable
    {
        public static bool operator !=(System.IntPtr value1, System.IntPtr value2) => throw null;
        public static System.IntPtr operator +(System.IntPtr pointer, int offset) => throw null;
        public static System.IntPtr operator -(System.IntPtr pointer, int offset) => throw null;
        public static bool operator ==(System.IntPtr value1, System.IntPtr value2) => throw null;
        public static System.IntPtr Add(System.IntPtr pointer, int offset) => throw null;
        public int CompareTo(System.IntPtr value) => throw null;
        public int CompareTo(object value) => throw null;
        public bool Equals(System.IntPtr other) => throw null;
        public override bool Equals(object obj) => throw null;
        public override int GetHashCode() => throw null;
        void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        // Stub generator skipped constructor 
        unsafe public IntPtr(void* value) => throw null;
        public IntPtr(int value) => throw null;
        public IntPtr(System.Int64 value) => throw null;
        public static System.IntPtr MaxValue { get => throw null; }
        public static System.IntPtr MinValue { get => throw null; }
        public static System.IntPtr Parse(string s) => throw null;
        public static System.IntPtr Parse(string s, System.IFormatProvider provider) => throw null;
        public static System.IntPtr Parse(string s, System.Globalization.NumberStyles style) => throw null;
        public static System.IntPtr Parse(string s, System.Globalization.NumberStyles style, System.IFormatProvider provider) => throw null;
        public static int Size { get => throw null; }
        public static System.IntPtr Subtract(System.IntPtr pointer, int offset) => throw null;
        public int ToInt32() => throw null;
        public System.Int64 ToInt64() => throw null;
        unsafe public void* ToPointer() => throw null;
        public override string ToString() => throw null;
        public string ToString(System.IFormatProvider provider) => throw null;
        public string ToString(string format) => throw null;
        public string ToString(string format, System.IFormatProvider provider) => throw null;
        public static bool TryParse(string s, System.Globalization.NumberStyles style, System.IFormatProvider provider, out System.IntPtr result) => throw null;
        public static bool TryParse(string s, out System.IntPtr result) => throw null;
        public static System.IntPtr Zero;
        public static explicit operator System.Int64(System.IntPtr value) => throw null;
        public static explicit operator int(System.IntPtr value) => throw null;
        unsafe public static explicit operator void*(System.IntPtr value) => throw null;
        unsafe public static explicit operator System.IntPtr(void* value) => throw null;
        public static explicit operator System.IntPtr(int value) => throw null;
        public static explicit operator System.IntPtr(System.Int64 value) => throw null;
    }

    // Generated from `System.InvalidCastException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class InvalidCastException : System.SystemException
    {
        public InvalidCastException() => throw null;
        protected InvalidCastException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public InvalidCastException(string message) => throw null;
        public InvalidCastException(string message, System.Exception innerException) => throw null;
        public InvalidCastException(string message, int errorCode) => throw null;
    }

    // Generated from `System.InvalidOperationException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class InvalidOperationException : System.SystemException
    {
        public InvalidOperationException() => throw null;
        protected InvalidOperationException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public InvalidOperationException(string message) => throw null;
        public InvalidOperationException(string message, System.Exception innerException) => throw null;
    }

    // Generated from `System.InvalidProgramException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class InvalidProgramException : System.SystemException
    {
        public InvalidProgramException() => throw null;
        public InvalidProgramException(string message) => throw null;
        public InvalidProgramException(string message, System.Exception inner) => throw null;
    }

    // Generated from `System.InvalidTimeZoneException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class InvalidTimeZoneException : System.Exception
    {
        public InvalidTimeZoneException() => throw null;
        protected InvalidTimeZoneException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public InvalidTimeZoneException(string message) => throw null;
        public InvalidTimeZoneException(string message, System.Exception innerException) => throw null;
    }

    // Generated from `System.Lazy<,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class Lazy<T, TMetadata> : System.Lazy<T>
    {
        public Lazy(System.Func<T> valueFactory, TMetadata metadata) => throw null;
        public Lazy(System.Func<T> valueFactory, TMetadata metadata, System.Threading.LazyThreadSafetyMode mode) => throw null;
        public Lazy(System.Func<T> valueFactory, TMetadata metadata, bool isThreadSafe) => throw null;
        public Lazy(TMetadata metadata) => throw null;
        public Lazy(TMetadata metadata, System.Threading.LazyThreadSafetyMode mode) => throw null;
        public Lazy(TMetadata metadata, bool isThreadSafe) => throw null;
        public TMetadata Metadata { get => throw null; }
    }

    // Generated from `System.Lazy<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class Lazy<T>
    {
        public bool IsValueCreated { get => throw null; }
        public Lazy() => throw null;
        public Lazy(System.Func<T> valueFactory) => throw null;
        public Lazy(System.Func<T> valueFactory, System.Threading.LazyThreadSafetyMode mode) => throw null;
        public Lazy(System.Func<T> valueFactory, bool isThreadSafe) => throw null;
        public Lazy(System.Threading.LazyThreadSafetyMode mode) => throw null;
        public Lazy(T value) => throw null;
        public Lazy(bool isThreadSafe) => throw null;
        public override string ToString() => throw null;
        public T Value { get => throw null; }
    }

    // Generated from `System.LdapStyleUriParser` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class LdapStyleUriParser : System.UriParser
    {
        public LdapStyleUriParser() => throw null;
    }

    // Generated from `System.LoaderOptimization` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public enum LoaderOptimization
    {
        DisallowBindings,
        DomainMask,
        MultiDomain,
        MultiDomainHost,
        NotSpecified,
        SingleDomain,
    }

    // Generated from `System.LoaderOptimizationAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class LoaderOptimizationAttribute : System.Attribute
    {
        public LoaderOptimizationAttribute(System.LoaderOptimization value) => throw null;
        public LoaderOptimizationAttribute(System.Byte value) => throw null;
        public System.LoaderOptimization Value { get => throw null; }
    }

    // Generated from `System.MTAThreadAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class MTAThreadAttribute : System.Attribute
    {
        public MTAThreadAttribute() => throw null;
    }

    // Generated from `System.MarshalByRefObject` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public abstract class MarshalByRefObject
    {
        public object GetLifetimeService() => throw null;
        public virtual object InitializeLifetimeService() => throw null;
        protected MarshalByRefObject() => throw null;
        protected System.MarshalByRefObject MemberwiseClone(bool cloneIdentity) => throw null;
    }

    // Generated from `System.Math` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public static class Math
    {
        public static System.Decimal Abs(System.Decimal value) => throw null;
        public static double Abs(double value) => throw null;
        public static float Abs(float value) => throw null;
        public static int Abs(int value) => throw null;
        public static System.Int64 Abs(System.Int64 value) => throw null;
        public static System.SByte Abs(System.SByte value) => throw null;
        public static System.Int16 Abs(System.Int16 value) => throw null;
        public static double Acos(double d) => throw null;
        public static double Acosh(double d) => throw null;
        public static double Asin(double d) => throw null;
        public static double Asinh(double d) => throw null;
        public static double Atan(double d) => throw null;
        public static double Atan2(double y, double x) => throw null;
        public static double Atanh(double d) => throw null;
        public static System.Int64 BigMul(int a, int b) => throw null;
        public static System.Int64 BigMul(System.Int64 a, System.Int64 b, out System.Int64 low) => throw null;
        public static System.UInt64 BigMul(System.UInt64 a, System.UInt64 b, out System.UInt64 low) => throw null;
        public static double BitDecrement(double x) => throw null;
        public static double BitIncrement(double x) => throw null;
        public static double Cbrt(double d) => throw null;
        public static System.Decimal Ceiling(System.Decimal d) => throw null;
        public static double Ceiling(double a) => throw null;
        public static System.Byte Clamp(System.Byte value, System.Byte min, System.Byte max) => throw null;
        public static System.Decimal Clamp(System.Decimal value, System.Decimal min, System.Decimal max) => throw null;
        public static double Clamp(double value, double min, double max) => throw null;
        public static float Clamp(float value, float min, float max) => throw null;
        public static int Clamp(int value, int min, int max) => throw null;
        public static System.Int64 Clamp(System.Int64 value, System.Int64 min, System.Int64 max) => throw null;
        public static System.SByte Clamp(System.SByte value, System.SByte min, System.SByte max) => throw null;
        public static System.Int16 Clamp(System.Int16 value, System.Int16 min, System.Int16 max) => throw null;
        public static System.UInt32 Clamp(System.UInt32 value, System.UInt32 min, System.UInt32 max) => throw null;
        public static System.UInt64 Clamp(System.UInt64 value, System.UInt64 min, System.UInt64 max) => throw null;
        public static System.UInt16 Clamp(System.UInt16 value, System.UInt16 min, System.UInt16 max) => throw null;
        public static double CopySign(double x, double y) => throw null;
        public static double Cos(double d) => throw null;
        public static double Cosh(double value) => throw null;
        public static int DivRem(int a, int b, out int result) => throw null;
        public static System.Int64 DivRem(System.Int64 a, System.Int64 b, out System.Int64 result) => throw null;
        public const double E = default;
        public static double Exp(double d) => throw null;
        public static System.Decimal Floor(System.Decimal d) => throw null;
        public static double Floor(double d) => throw null;
        public static double FusedMultiplyAdd(double x, double y, double z) => throw null;
        public static double IEEERemainder(double x, double y) => throw null;
        public static int ILogB(double x) => throw null;
        public static double Log(double d) => throw null;
        public static double Log(double a, double newBase) => throw null;
        public static double Log10(double d) => throw null;
        public static double Log2(double x) => throw null;
        public static System.Byte Max(System.Byte val1, System.Byte val2) => throw null;
        public static System.Decimal Max(System.Decimal val1, System.Decimal val2) => throw null;
        public static double Max(double val1, double val2) => throw null;
        public static float Max(float val1, float val2) => throw null;
        public static int Max(int val1, int val2) => throw null;
        public static System.Int64 Max(System.Int64 val1, System.Int64 val2) => throw null;
        public static System.SByte Max(System.SByte val1, System.SByte val2) => throw null;
        public static System.Int16 Max(System.Int16 val1, System.Int16 val2) => throw null;
        public static System.UInt32 Max(System.UInt32 val1, System.UInt32 val2) => throw null;
        public static System.UInt64 Max(System.UInt64 val1, System.UInt64 val2) => throw null;
        public static System.UInt16 Max(System.UInt16 val1, System.UInt16 val2) => throw null;
        public static double MaxMagnitude(double x, double y) => throw null;
        public static System.Byte Min(System.Byte val1, System.Byte val2) => throw null;
        public static System.Decimal Min(System.Decimal val1, System.Decimal val2) => throw null;
        public static double Min(double val1, double val2) => throw null;
        public static float Min(float val1, float val2) => throw null;
        public static int Min(int val1, int val2) => throw null;
        public static System.Int64 Min(System.Int64 val1, System.Int64 val2) => throw null;
        public static System.SByte Min(System.SByte val1, System.SByte val2) => throw null;
        public static System.Int16 Min(System.Int16 val1, System.Int16 val2) => throw null;
        public static System.UInt32 Min(System.UInt32 val1, System.UInt32 val2) => throw null;
        public static System.UInt64 Min(System.UInt64 val1, System.UInt64 val2) => throw null;
        public static System.UInt16 Min(System.UInt16 val1, System.UInt16 val2) => throw null;
        public static double MinMagnitude(double x, double y) => throw null;
        public const double PI = default;
        public static double Pow(double x, double y) => throw null;
        public static System.Decimal Round(System.Decimal d) => throw null;
        public static System.Decimal Round(System.Decimal d, System.MidpointRounding mode) => throw null;
        public static System.Decimal Round(System.Decimal d, int decimals) => throw null;
        public static System.Decimal Round(System.Decimal d, int decimals, System.MidpointRounding mode) => throw null;
        public static double Round(double a) => throw null;
        public static double Round(double value, System.MidpointRounding mode) => throw null;
        public static double Round(double value, int digits) => throw null;
        public static double Round(double value, int digits, System.MidpointRounding mode) => throw null;
        public static double ScaleB(double x, int n) => throw null;
        public static int Sign(System.Decimal value) => throw null;
        public static int Sign(double value) => throw null;
        public static int Sign(float value) => throw null;
        public static int Sign(int value) => throw null;
        public static int Sign(System.Int64 value) => throw null;
        public static int Sign(System.SByte value) => throw null;
        public static int Sign(System.Int16 value) => throw null;
        public static double Sin(double a) => throw null;
        public static double Sinh(double value) => throw null;
        public static double Sqrt(double d) => throw null;
        public static double Tan(double a) => throw null;
        public static double Tanh(double value) => throw null;
        public const double Tau = default;
        public static System.Decimal Truncate(System.Decimal d) => throw null;
        public static double Truncate(double d) => throw null;
    }

    // Generated from `System.MathF` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public static class MathF
    {
        public static float Abs(float x) => throw null;
        public static float Acos(float x) => throw null;
        public static float Acosh(float x) => throw null;
        public static float Asin(float x) => throw null;
        public static float Asinh(float x) => throw null;
        public static float Atan(float x) => throw null;
        public static float Atan2(float y, float x) => throw null;
        public static float Atanh(float x) => throw null;
        public static float BitDecrement(float x) => throw null;
        public static float BitIncrement(float x) => throw null;
        public static float Cbrt(float x) => throw null;
        public static float Ceiling(float x) => throw null;
        public static float CopySign(float x, float y) => throw null;
        public static float Cos(float x) => throw null;
        public static float Cosh(float x) => throw null;
        public const float E = default;
        public static float Exp(float x) => throw null;
        public static float Floor(float x) => throw null;
        public static float FusedMultiplyAdd(float x, float y, float z) => throw null;
        public static float IEEERemainder(float x, float y) => throw null;
        public static int ILogB(float x) => throw null;
        public static float Log(float x) => throw null;
        public static float Log(float x, float y) => throw null;
        public static float Log10(float x) => throw null;
        public static float Log2(float x) => throw null;
        public static float Max(float x, float y) => throw null;
        public static float MaxMagnitude(float x, float y) => throw null;
        public static float Min(float x, float y) => throw null;
        public static float MinMagnitude(float x, float y) => throw null;
        public const float PI = default;
        public static float Pow(float x, float y) => throw null;
        public static float Round(float x) => throw null;
        public static float Round(float x, System.MidpointRounding mode) => throw null;
        public static float Round(float x, int digits) => throw null;
        public static float Round(float x, int digits, System.MidpointRounding mode) => throw null;
        public static float ScaleB(float x, int n) => throw null;
        public static int Sign(float x) => throw null;
        public static float Sin(float x) => throw null;
        public static float Sinh(float x) => throw null;
        public static float Sqrt(float x) => throw null;
        public static float Tan(float x) => throw null;
        public static float Tanh(float x) => throw null;
        public const float Tau = default;
        public static float Truncate(float x) => throw null;
    }

    // Generated from `System.MemberAccessException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class MemberAccessException : System.SystemException
    {
        public MemberAccessException() => throw null;
        protected MemberAccessException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public MemberAccessException(string message) => throw null;
        public MemberAccessException(string message, System.Exception inner) => throw null;
    }

    // Generated from `System.Memory<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct Memory<T> : System.IEquatable<System.Memory<T>>
    {
        public void CopyTo(System.Memory<T> destination) => throw null;
        public static System.Memory<T> Empty { get => throw null; }
        public bool Equals(System.Memory<T> other) => throw null;
        public override bool Equals(object obj) => throw null;
        public override int GetHashCode() => throw null;
        public bool IsEmpty { get => throw null; }
        public int Length { get => throw null; }
        // Stub generator skipped constructor 
        public Memory(T[] array) => throw null;
        public Memory(T[] array, int start, int length) => throw null;
        public System.Buffers.MemoryHandle Pin() => throw null;
        public System.Memory<T> Slice(int start) => throw null;
        public System.Memory<T> Slice(int start, int length) => throw null;
        public System.Span<T> Span { get => throw null; }
        public T[] ToArray() => throw null;
        public override string ToString() => throw null;
        public bool TryCopyTo(System.Memory<T> destination) => throw null;
        public static implicit operator System.Memory<T>(System.ArraySegment<T> segment) => throw null;
        public static implicit operator System.ReadOnlyMemory<T>(System.Memory<T> memory) => throw null;
        public static implicit operator System.Memory<T>(T[] array) => throw null;
    }

    // Generated from `System.MethodAccessException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class MethodAccessException : System.MemberAccessException
    {
        public MethodAccessException() => throw null;
        protected MethodAccessException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public MethodAccessException(string message) => throw null;
        public MethodAccessException(string message, System.Exception inner) => throw null;
    }

    // Generated from `System.MidpointRounding` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public enum MidpointRounding
    {
        AwayFromZero,
        ToEven,
        ToNegativeInfinity,
        ToPositiveInfinity,
        ToZero,
    }

    // Generated from `System.MissingFieldException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class MissingFieldException : System.MissingMemberException, System.Runtime.Serialization.ISerializable
    {
        public override string Message { get => throw null; }
        public MissingFieldException() => throw null;
        protected MissingFieldException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public MissingFieldException(string message) => throw null;
        public MissingFieldException(string message, System.Exception inner) => throw null;
        public MissingFieldException(string className, string fieldName) => throw null;
    }

    // Generated from `System.MissingMemberException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class MissingMemberException : System.MemberAccessException, System.Runtime.Serialization.ISerializable
    {
        protected string ClassName;
        public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        protected string MemberName;
        public override string Message { get => throw null; }
        public MissingMemberException() => throw null;
        protected MissingMemberException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public MissingMemberException(string message) => throw null;
        public MissingMemberException(string message, System.Exception inner) => throw null;
        public MissingMemberException(string className, string memberName) => throw null;
        protected System.Byte[] Signature;
    }

    // Generated from `System.MissingMethodException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class MissingMethodException : System.MissingMemberException
    {
        public override string Message { get => throw null; }
        public MissingMethodException() => throw null;
        protected MissingMethodException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public MissingMethodException(string message) => throw null;
        public MissingMethodException(string message, System.Exception inner) => throw null;
        public MissingMethodException(string className, string methodName) => throw null;
    }

    // Generated from `System.ModuleHandle` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct ModuleHandle
    {
        public static bool operator !=(System.ModuleHandle left, System.ModuleHandle right) => throw null;
        public static bool operator ==(System.ModuleHandle left, System.ModuleHandle right) => throw null;
        public static System.ModuleHandle EmptyHandle;
        public bool Equals(System.ModuleHandle handle) => throw null;
        public override bool Equals(object obj) => throw null;
        public override int GetHashCode() => throw null;
        public System.RuntimeFieldHandle GetRuntimeFieldHandleFromMetadataToken(int fieldToken) => throw null;
        public System.RuntimeMethodHandle GetRuntimeMethodHandleFromMetadataToken(int methodToken) => throw null;
        public System.RuntimeTypeHandle GetRuntimeTypeHandleFromMetadataToken(int typeToken) => throw null;
        public int MDStreamVersion { get => throw null; }
        // Stub generator skipped constructor 
        public System.RuntimeFieldHandle ResolveFieldHandle(int fieldToken) => throw null;
        public System.RuntimeFieldHandle ResolveFieldHandle(int fieldToken, System.RuntimeTypeHandle[] typeInstantiationContext, System.RuntimeTypeHandle[] methodInstantiationContext) => throw null;
        public System.RuntimeMethodHandle ResolveMethodHandle(int methodToken) => throw null;
        public System.RuntimeMethodHandle ResolveMethodHandle(int methodToken, System.RuntimeTypeHandle[] typeInstantiationContext, System.RuntimeTypeHandle[] methodInstantiationContext) => throw null;
        public System.RuntimeTypeHandle ResolveTypeHandle(int typeToken) => throw null;
        public System.RuntimeTypeHandle ResolveTypeHandle(int typeToken, System.RuntimeTypeHandle[] typeInstantiationContext, System.RuntimeTypeHandle[] methodInstantiationContext) => throw null;
    }

    // Generated from `System.MulticastDelegate` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public abstract class MulticastDelegate : System.Delegate
    {
        public static bool operator !=(System.MulticastDelegate d1, System.MulticastDelegate d2) => throw null;
        public static bool operator ==(System.MulticastDelegate d1, System.MulticastDelegate d2) => throw null;
        protected override System.Delegate CombineImpl(System.Delegate follow) => throw null;
        public override bool Equals(object obj) => throw null;
        public override int GetHashCode() => throw null;
        public override System.Delegate[] GetInvocationList() => throw null;
        protected override System.Reflection.MethodInfo GetMethodImpl() => throw null;
        public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        protected MulticastDelegate(System.Type target, string method) : base(default(System.Type), default(string)) => throw null;
        protected MulticastDelegate(object target, string method) : base(default(System.Type), default(string)) => throw null;
        protected override System.Delegate RemoveImpl(System.Delegate value) => throw null;
    }

    // Generated from `System.MulticastNotSupportedException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class MulticastNotSupportedException : System.SystemException
    {
        public MulticastNotSupportedException() => throw null;
        public MulticastNotSupportedException(string message) => throw null;
        public MulticastNotSupportedException(string message, System.Exception inner) => throw null;
    }

    // Generated from `System.NetPipeStyleUriParser` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class NetPipeStyleUriParser : System.UriParser
    {
        public NetPipeStyleUriParser() => throw null;
    }

    // Generated from `System.NetTcpStyleUriParser` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class NetTcpStyleUriParser : System.UriParser
    {
        public NetTcpStyleUriParser() => throw null;
    }

    // Generated from `System.NewsStyleUriParser` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class NewsStyleUriParser : System.UriParser
    {
        public NewsStyleUriParser() => throw null;
    }

    // Generated from `System.NonSerializedAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class NonSerializedAttribute : System.Attribute
    {
        public NonSerializedAttribute() => throw null;
    }

    // Generated from `System.NotFiniteNumberException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class NotFiniteNumberException : System.ArithmeticException
    {
        public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public NotFiniteNumberException() => throw null;
        protected NotFiniteNumberException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public NotFiniteNumberException(double offendingNumber) => throw null;
        public NotFiniteNumberException(string message) => throw null;
        public NotFiniteNumberException(string message, System.Exception innerException) => throw null;
        public NotFiniteNumberException(string message, double offendingNumber) => throw null;
        public NotFiniteNumberException(string message, double offendingNumber, System.Exception innerException) => throw null;
        public double OffendingNumber { get => throw null; }
    }

    // Generated from `System.NotImplementedException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class NotImplementedException : System.SystemException
    {
        public NotImplementedException() => throw null;
        protected NotImplementedException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public NotImplementedException(string message) => throw null;
        public NotImplementedException(string message, System.Exception inner) => throw null;
    }

    // Generated from `System.NotSupportedException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class NotSupportedException : System.SystemException
    {
        public NotSupportedException() => throw null;
        protected NotSupportedException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public NotSupportedException(string message) => throw null;
        public NotSupportedException(string message, System.Exception innerException) => throw null;
    }

    // Generated from `System.NullReferenceException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class NullReferenceException : System.SystemException
    {
        public NullReferenceException() => throw null;
        protected NullReferenceException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public NullReferenceException(string message) => throw null;
        public NullReferenceException(string message, System.Exception innerException) => throw null;
    }

    // Generated from `System.Nullable` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public static class Nullable
    {
        public static int Compare<T>(T? n1, T? n2) where T : struct => throw null;
        public static bool Equals<T>(T? n1, T? n2) where T : struct => throw null;
        public static System.Type GetUnderlyingType(System.Type nullableType) => throw null;
    }

    // Generated from `System.Nullable<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct Nullable<T> where T : struct
    {
        public override bool Equals(object other) => throw null;
        public override int GetHashCode() => throw null;
        public T GetValueOrDefault() => throw null;
        public T GetValueOrDefault(T defaultValue) => throw null;
        public bool HasValue { get => throw null; }
        // Stub generator skipped constructor 
        public Nullable(T value) => throw null;
        public override string ToString() => throw null;
        public T Value { get => throw null; }
        public static explicit operator T(System.Nullable<T> value) => throw null;
        public static implicit operator System.Nullable<T>(T value) => throw null;
    }

    // Generated from `System.Object` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class Object
    {
        public virtual bool Equals(object obj) => throw null;
        public static bool Equals(object objA, object objB) => throw null;
        public virtual int GetHashCode() => throw null;
        public System.Type GetType() => throw null;
        protected object MemberwiseClone() => throw null;
        public Object() => throw null;
        public static bool ReferenceEquals(object objA, object objB) => throw null;
        public virtual string ToString() => throw null;
        // ERR: Stub generator didn't handle member: ~Object
    }

    // Generated from `System.ObjectDisposedException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class ObjectDisposedException : System.InvalidOperationException
    {
        public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public override string Message { get => throw null; }
        protected ObjectDisposedException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public ObjectDisposedException(string objectName) => throw null;
        public ObjectDisposedException(string message, System.Exception innerException) => throw null;
        public ObjectDisposedException(string objectName, string message) => throw null;
        public string ObjectName { get => throw null; }
    }

    // Generated from `System.ObsoleteAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class ObsoleteAttribute : System.Attribute
    {
        public string DiagnosticId { get => throw null; set => throw null; }
        public bool IsError { get => throw null; }
        public string Message { get => throw null; }
        public ObsoleteAttribute() => throw null;
        public ObsoleteAttribute(string message) => throw null;
        public ObsoleteAttribute(string message, bool error) => throw null;
        public string UrlFormat { get => throw null; set => throw null; }
    }

    // Generated from `System.OperatingSystem` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class OperatingSystem : System.ICloneable, System.Runtime.Serialization.ISerializable
    {
        public object Clone() => throw null;
        public void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public static bool IsAndroid() => throw null;
        public static bool IsAndroidVersionAtLeast(int major, int minor = default(int), int build = default(int), int revision = default(int)) => throw null;
        public static bool IsBrowser() => throw null;
        public static bool IsFreeBSD() => throw null;
        public static bool IsFreeBSDVersionAtLeast(int major, int minor = default(int), int build = default(int), int revision = default(int)) => throw null;
        public static bool IsIOS() => throw null;
        public static bool IsIOSVersionAtLeast(int major, int minor = default(int), int build = default(int)) => throw null;
        public static bool IsLinux() => throw null;
        public static bool IsMacOS() => throw null;
        public static bool IsMacOSVersionAtLeast(int major, int minor = default(int), int build = default(int)) => throw null;
        public static bool IsOSPlatform(string platform) => throw null;
        public static bool IsOSPlatformVersionAtLeast(string platform, int major, int minor = default(int), int build = default(int), int revision = default(int)) => throw null;
        public static bool IsTvOS() => throw null;
        public static bool IsTvOSVersionAtLeast(int major, int minor = default(int), int build = default(int)) => throw null;
        public static bool IsWatchOS() => throw null;
        public static bool IsWatchOSVersionAtLeast(int major, int minor = default(int), int build = default(int)) => throw null;
        public static bool IsWindows() => throw null;
        public static bool IsWindowsVersionAtLeast(int major, int minor = default(int), int build = default(int), int revision = default(int)) => throw null;
        public OperatingSystem(System.PlatformID platform, System.Version version) => throw null;
        public System.PlatformID Platform { get => throw null; }
        public string ServicePack { get => throw null; }
        public override string ToString() => throw null;
        public System.Version Version { get => throw null; }
        public string VersionString { get => throw null; }
    }

    // Generated from `System.OperationCanceledException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class OperationCanceledException : System.SystemException
    {
        public System.Threading.CancellationToken CancellationToken { get => throw null; }
        public OperationCanceledException() => throw null;
        public OperationCanceledException(System.Threading.CancellationToken token) => throw null;
        protected OperationCanceledException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public OperationCanceledException(string message) => throw null;
        public OperationCanceledException(string message, System.Threading.CancellationToken token) => throw null;
        public OperationCanceledException(string message, System.Exception innerException) => throw null;
        public OperationCanceledException(string message, System.Exception innerException, System.Threading.CancellationToken token) => throw null;
    }

    // Generated from `System.OutOfMemoryException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class OutOfMemoryException : System.SystemException
    {
        public OutOfMemoryException() => throw null;
        protected OutOfMemoryException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public OutOfMemoryException(string message) => throw null;
        public OutOfMemoryException(string message, System.Exception innerException) => throw null;
    }

    // Generated from `System.OverflowException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class OverflowException : System.ArithmeticException
    {
        public OverflowException() => throw null;
        protected OverflowException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public OverflowException(string message) => throw null;
        public OverflowException(string message, System.Exception innerException) => throw null;
    }

    // Generated from `System.ParamArrayAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class ParamArrayAttribute : System.Attribute
    {
        public ParamArrayAttribute() => throw null;
    }

    // Generated from `System.PlatformID` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public enum PlatformID
    {
        MacOSX,
        Other,
        Unix,
        Win32NT,
        Win32S,
        Win32Windows,
        WinCE,
        Xbox,
    }

    // Generated from `System.PlatformNotSupportedException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class PlatformNotSupportedException : System.NotSupportedException
    {
        public PlatformNotSupportedException() => throw null;
        protected PlatformNotSupportedException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public PlatformNotSupportedException(string message) => throw null;
        public PlatformNotSupportedException(string message, System.Exception inner) => throw null;
    }

    // Generated from `System.Predicate<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate bool Predicate<T>(T obj);

    // Generated from `System.Progress<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class Progress<T> : System.IProgress<T>
    {
        protected virtual void OnReport(T value) => throw null;
        public Progress() => throw null;
        public Progress(System.Action<T> handler) => throw null;
        public event System.EventHandler<T> ProgressChanged;
        void System.IProgress<T>.Report(T value) => throw null;
    }

    // Generated from `System.Random` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class Random
    {
        public virtual int Next() => throw null;
        public virtual int Next(int maxValue) => throw null;
        public virtual int Next(int minValue, int maxValue) => throw null;
        public virtual void NextBytes(System.Byte[] buffer) => throw null;
        public virtual void NextBytes(System.Span<System.Byte> buffer) => throw null;
        public virtual double NextDouble() => throw null;
        public Random() => throw null;
        public Random(int Seed) => throw null;
        protected virtual double Sample() => throw null;
    }

    // Generated from `System.Range` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct Range : System.IEquatable<System.Range>
    {
        public static System.Range All { get => throw null; }
        public System.Index End { get => throw null; }
        public static System.Range EndAt(System.Index end) => throw null;
        public bool Equals(System.Range other) => throw null;
        public override bool Equals(object value) => throw null;
        public override int GetHashCode() => throw null;
        public (int, int) GetOffsetAndLength(int length) => throw null;
        // Stub generator skipped constructor 
        public Range(System.Index start, System.Index end) => throw null;
        public System.Index Start { get => throw null; }
        public static System.Range StartAt(System.Index start) => throw null;
        public override string ToString() => throw null;
    }

    // Generated from `System.RankException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class RankException : System.SystemException
    {
        public RankException() => throw null;
        protected RankException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public RankException(string message) => throw null;
        public RankException(string message, System.Exception innerException) => throw null;
    }

    // Generated from `System.ReadOnlyMemory<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct ReadOnlyMemory<T> : System.IEquatable<System.ReadOnlyMemory<T>>
    {
        public void CopyTo(System.Memory<T> destination) => throw null;
        public static System.ReadOnlyMemory<T> Empty { get => throw null; }
        public bool Equals(System.ReadOnlyMemory<T> other) => throw null;
        public override bool Equals(object obj) => throw null;
        public override int GetHashCode() => throw null;
        public bool IsEmpty { get => throw null; }
        public int Length { get => throw null; }
        public System.Buffers.MemoryHandle Pin() => throw null;
        // Stub generator skipped constructor 
        public ReadOnlyMemory(T[] array) => throw null;
        public ReadOnlyMemory(T[] array, int start, int length) => throw null;
        public System.ReadOnlyMemory<T> Slice(int start) => throw null;
        public System.ReadOnlyMemory<T> Slice(int start, int length) => throw null;
        public System.ReadOnlySpan<T> Span { get => throw null; }
        public T[] ToArray() => throw null;
        public override string ToString() => throw null;
        public bool TryCopyTo(System.Memory<T> destination) => throw null;
        public static implicit operator System.ReadOnlyMemory<T>(System.ArraySegment<T> segment) => throw null;
        public static implicit operator System.ReadOnlyMemory<T>(T[] array) => throw null;
    }

    // Generated from `System.ReadOnlySpan<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct ReadOnlySpan<T>
    {
        // Generated from `System.ReadOnlySpan<>+Enumerator` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public struct Enumerator
        {
            public T Current { get => throw null; }
            // Stub generator skipped constructor 
            public bool MoveNext() => throw null;
        }


        public static bool operator !=(System.ReadOnlySpan<T> left, System.ReadOnlySpan<T> right) => throw null;
        public static bool operator ==(System.ReadOnlySpan<T> left, System.ReadOnlySpan<T> right) => throw null;
        public void CopyTo(System.Span<T> destination) => throw null;
        public static System.ReadOnlySpan<T> Empty { get => throw null; }
        public override bool Equals(object obj) => throw null;
        public System.ReadOnlySpan<T>.Enumerator GetEnumerator() => throw null;
        public override int GetHashCode() => throw null;
        public T GetPinnableReference() => throw null;
        public bool IsEmpty { get => throw null; }
        public T this[int index] { get => throw null; }
        public int Length { get => throw null; }
        // Stub generator skipped constructor 
        public ReadOnlySpan(T[] array) => throw null;
        public ReadOnlySpan(T[] array, int start, int length) => throw null;
        unsafe public ReadOnlySpan(void* pointer, int length) => throw null;
        public System.ReadOnlySpan<T> Slice(int start) => throw null;
        public System.ReadOnlySpan<T> Slice(int start, int length) => throw null;
        public T[] ToArray() => throw null;
        public override string ToString() => throw null;
        public bool TryCopyTo(System.Span<T> destination) => throw null;
        public static implicit operator System.ReadOnlySpan<T>(System.ArraySegment<T> segment) => throw null;
        public static implicit operator System.ReadOnlySpan<T>(T[] array) => throw null;
    }

    // Generated from `System.ResolveEventArgs` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class ResolveEventArgs : System.EventArgs
    {
        public string Name { get => throw null; }
        public System.Reflection.Assembly RequestingAssembly { get => throw null; }
        public ResolveEventArgs(string name) => throw null;
        public ResolveEventArgs(string name, System.Reflection.Assembly requestingAssembly) => throw null;
    }

    // Generated from `System.ResolveEventHandler` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate System.Reflection.Assembly ResolveEventHandler(object sender, System.ResolveEventArgs args);

    // Generated from `System.RuntimeArgumentHandle` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct RuntimeArgumentHandle
    {
        // Stub generator skipped constructor 
    }

    // Generated from `System.RuntimeFieldHandle` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct RuntimeFieldHandle : System.Runtime.Serialization.ISerializable
    {
        public static bool operator !=(System.RuntimeFieldHandle left, System.RuntimeFieldHandle right) => throw null;
        public static bool operator ==(System.RuntimeFieldHandle left, System.RuntimeFieldHandle right) => throw null;
        public bool Equals(System.RuntimeFieldHandle handle) => throw null;
        public override bool Equals(object obj) => throw null;
        public override int GetHashCode() => throw null;
        public void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        // Stub generator skipped constructor 
        public System.IntPtr Value { get => throw null; }
    }

    // Generated from `System.RuntimeMethodHandle` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct RuntimeMethodHandle : System.Runtime.Serialization.ISerializable
    {
        public static bool operator !=(System.RuntimeMethodHandle left, System.RuntimeMethodHandle right) => throw null;
        public static bool operator ==(System.RuntimeMethodHandle left, System.RuntimeMethodHandle right) => throw null;
        public bool Equals(System.RuntimeMethodHandle handle) => throw null;
        public override bool Equals(object obj) => throw null;
        public System.IntPtr GetFunctionPointer() => throw null;
        public override int GetHashCode() => throw null;
        public void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        // Stub generator skipped constructor 
        public System.IntPtr Value { get => throw null; }
    }

    // Generated from `System.RuntimeTypeHandle` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct RuntimeTypeHandle : System.Runtime.Serialization.ISerializable
    {
        public static bool operator !=(System.RuntimeTypeHandle left, object right) => throw null;
        public static bool operator !=(object left, System.RuntimeTypeHandle right) => throw null;
        public static bool operator ==(System.RuntimeTypeHandle left, object right) => throw null;
        public static bool operator ==(object left, System.RuntimeTypeHandle right) => throw null;
        public bool Equals(System.RuntimeTypeHandle handle) => throw null;
        public override bool Equals(object obj) => throw null;
        public override int GetHashCode() => throw null;
        public System.ModuleHandle GetModuleHandle() => throw null;
        public void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        // Stub generator skipped constructor 
        public System.IntPtr Value { get => throw null; }
    }

    // Generated from `System.SByte` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct SByte : System.IComparable, System.IComparable<System.SByte>, System.IConvertible, System.IEquatable<System.SByte>, System.IFormattable
    {
        public int CompareTo(object obj) => throw null;
        public int CompareTo(System.SByte value) => throw null;
        public override bool Equals(object obj) => throw null;
        public bool Equals(System.SByte obj) => throw null;
        public override int GetHashCode() => throw null;
        public System.TypeCode GetTypeCode() => throw null;
        public const System.SByte MaxValue = default;
        public const System.SByte MinValue = default;
        public static System.SByte Parse(System.ReadOnlySpan<System.Char> s, System.Globalization.NumberStyles style = default(System.Globalization.NumberStyles), System.IFormatProvider provider = default(System.IFormatProvider)) => throw null;
        public static System.SByte Parse(string s) => throw null;
        public static System.SByte Parse(string s, System.IFormatProvider provider) => throw null;
        public static System.SByte Parse(string s, System.Globalization.NumberStyles style) => throw null;
        public static System.SByte Parse(string s, System.Globalization.NumberStyles style, System.IFormatProvider provider) => throw null;
        // Stub generator skipped constructor 
        bool System.IConvertible.ToBoolean(System.IFormatProvider provider) => throw null;
        System.Byte System.IConvertible.ToByte(System.IFormatProvider provider) => throw null;
        System.Char System.IConvertible.ToChar(System.IFormatProvider provider) => throw null;
        System.DateTime System.IConvertible.ToDateTime(System.IFormatProvider provider) => throw null;
        System.Decimal System.IConvertible.ToDecimal(System.IFormatProvider provider) => throw null;
        double System.IConvertible.ToDouble(System.IFormatProvider provider) => throw null;
        System.Int16 System.IConvertible.ToInt16(System.IFormatProvider provider) => throw null;
        int System.IConvertible.ToInt32(System.IFormatProvider provider) => throw null;
        System.Int64 System.IConvertible.ToInt64(System.IFormatProvider provider) => throw null;
        System.SByte System.IConvertible.ToSByte(System.IFormatProvider provider) => throw null;
        float System.IConvertible.ToSingle(System.IFormatProvider provider) => throw null;
        public override string ToString() => throw null;
        public string ToString(System.IFormatProvider provider) => throw null;
        public string ToString(string format) => throw null;
        public string ToString(string format, System.IFormatProvider provider) => throw null;
        object System.IConvertible.ToType(System.Type type, System.IFormatProvider provider) => throw null;
        System.UInt16 System.IConvertible.ToUInt16(System.IFormatProvider provider) => throw null;
        System.UInt32 System.IConvertible.ToUInt32(System.IFormatProvider provider) => throw null;
        System.UInt64 System.IConvertible.ToUInt64(System.IFormatProvider provider) => throw null;
        public bool TryFormat(System.Span<System.Char> destination, out int charsWritten, System.ReadOnlySpan<System.Char> format = default(System.ReadOnlySpan<System.Char>), System.IFormatProvider provider = default(System.IFormatProvider)) => throw null;
        public static bool TryParse(System.ReadOnlySpan<System.Char> s, System.Globalization.NumberStyles style, System.IFormatProvider provider, out System.SByte result) => throw null;
        public static bool TryParse(System.ReadOnlySpan<System.Char> s, out System.SByte result) => throw null;
        public static bool TryParse(string s, System.Globalization.NumberStyles style, System.IFormatProvider provider, out System.SByte result) => throw null;
        public static bool TryParse(string s, out System.SByte result) => throw null;
    }

    // Generated from `System.STAThreadAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class STAThreadAttribute : System.Attribute
    {
        public STAThreadAttribute() => throw null;
    }

    // Generated from `System.SerializableAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class SerializableAttribute : System.Attribute
    {
        public SerializableAttribute() => throw null;
    }

    // Generated from `System.Single` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct Single : System.IComparable, System.IComparable<float>, System.IConvertible, System.IEquatable<float>, System.IFormattable
    {
        public static bool operator !=(float left, float right) => throw null;
        public static bool operator <(float left, float right) => throw null;
        public static bool operator <=(float left, float right) => throw null;
        public static bool operator ==(float left, float right) => throw null;
        public static bool operator >(float left, float right) => throw null;
        public static bool operator >=(float left, float right) => throw null;
        public int CompareTo(float value) => throw null;
        public int CompareTo(object value) => throw null;
        public const float Epsilon = default;
        public bool Equals(float obj) => throw null;
        public override bool Equals(object obj) => throw null;
        public override int GetHashCode() => throw null;
        public System.TypeCode GetTypeCode() => throw null;
        public static bool IsFinite(float f) => throw null;
        public static bool IsInfinity(float f) => throw null;
        public static bool IsNaN(float f) => throw null;
        public static bool IsNegative(float f) => throw null;
        public static bool IsNegativeInfinity(float f) => throw null;
        public static bool IsNormal(float f) => throw null;
        public static bool IsPositiveInfinity(float f) => throw null;
        public static bool IsSubnormal(float f) => throw null;
        public const float MaxValue = default;
        public const float MinValue = default;
        public const float NaN = default;
        public const float NegativeInfinity = default;
        public static float Parse(System.ReadOnlySpan<System.Char> s, System.Globalization.NumberStyles style = default(System.Globalization.NumberStyles), System.IFormatProvider provider = default(System.IFormatProvider)) => throw null;
        public static float Parse(string s) => throw null;
        public static float Parse(string s, System.IFormatProvider provider) => throw null;
        public static float Parse(string s, System.Globalization.NumberStyles style) => throw null;
        public static float Parse(string s, System.Globalization.NumberStyles style, System.IFormatProvider provider) => throw null;
        public const float PositiveInfinity = default;
        // Stub generator skipped constructor 
        bool System.IConvertible.ToBoolean(System.IFormatProvider provider) => throw null;
        System.Byte System.IConvertible.ToByte(System.IFormatProvider provider) => throw null;
        System.Char System.IConvertible.ToChar(System.IFormatProvider provider) => throw null;
        System.DateTime System.IConvertible.ToDateTime(System.IFormatProvider provider) => throw null;
        System.Decimal System.IConvertible.ToDecimal(System.IFormatProvider provider) => throw null;
        double System.IConvertible.ToDouble(System.IFormatProvider provider) => throw null;
        System.Int16 System.IConvertible.ToInt16(System.IFormatProvider provider) => throw null;
        int System.IConvertible.ToInt32(System.IFormatProvider provider) => throw null;
        System.Int64 System.IConvertible.ToInt64(System.IFormatProvider provider) => throw null;
        System.SByte System.IConvertible.ToSByte(System.IFormatProvider provider) => throw null;
        float System.IConvertible.ToSingle(System.IFormatProvider provider) => throw null;
        public override string ToString() => throw null;
        public string ToString(System.IFormatProvider provider) => throw null;
        public string ToString(string format) => throw null;
        public string ToString(string format, System.IFormatProvider provider) => throw null;
        object System.IConvertible.ToType(System.Type type, System.IFormatProvider provider) => throw null;
        System.UInt16 System.IConvertible.ToUInt16(System.IFormatProvider provider) => throw null;
        System.UInt32 System.IConvertible.ToUInt32(System.IFormatProvider provider) => throw null;
        System.UInt64 System.IConvertible.ToUInt64(System.IFormatProvider provider) => throw null;
        public bool TryFormat(System.Span<System.Char> destination, out int charsWritten, System.ReadOnlySpan<System.Char> format = default(System.ReadOnlySpan<System.Char>), System.IFormatProvider provider = default(System.IFormatProvider)) => throw null;
        public static bool TryParse(System.ReadOnlySpan<System.Char> s, System.Globalization.NumberStyles style, System.IFormatProvider provider, out float result) => throw null;
        public static bool TryParse(System.ReadOnlySpan<System.Char> s, out float result) => throw null;
        public static bool TryParse(string s, System.Globalization.NumberStyles style, System.IFormatProvider provider, out float result) => throw null;
        public static bool TryParse(string s, out float result) => throw null;
    }

    // Generated from `System.Span<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct Span<T>
    {
        // Generated from `System.Span<>+Enumerator` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public struct Enumerator
        {
            public T Current { get => throw null; }
            // Stub generator skipped constructor 
            public bool MoveNext() => throw null;
        }


        public static bool operator !=(System.Span<T> left, System.Span<T> right) => throw null;
        public static bool operator ==(System.Span<T> left, System.Span<T> right) => throw null;
        public void Clear() => throw null;
        public void CopyTo(System.Span<T> destination) => throw null;
        public static System.Span<T> Empty { get => throw null; }
        public override bool Equals(object obj) => throw null;
        public void Fill(T value) => throw null;
        public System.Span<T>.Enumerator GetEnumerator() => throw null;
        public override int GetHashCode() => throw null;
        public T GetPinnableReference() => throw null;
        public bool IsEmpty { get => throw null; }
        public T this[int index] { get => throw null; }
        public int Length { get => throw null; }
        public System.Span<T> Slice(int start) => throw null;
        public System.Span<T> Slice(int start, int length) => throw null;
        // Stub generator skipped constructor 
        public Span(T[] array) => throw null;
        public Span(T[] array, int start, int length) => throw null;
        unsafe public Span(void* pointer, int length) => throw null;
        public T[] ToArray() => throw null;
        public override string ToString() => throw null;
        public bool TryCopyTo(System.Span<T> destination) => throw null;
        public static implicit operator System.Span<T>(System.ArraySegment<T> segment) => throw null;
        public static implicit operator System.ReadOnlySpan<T>(System.Span<T> span) => throw null;
        public static implicit operator System.Span<T>(T[] array) => throw null;
    }

    // Generated from `System.StackOverflowException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class StackOverflowException : System.SystemException
    {
        public StackOverflowException() => throw null;
        public StackOverflowException(string message) => throw null;
        public StackOverflowException(string message, System.Exception innerException) => throw null;
    }

    // Generated from `System.String` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class String : System.Collections.Generic.IEnumerable<System.Char>, System.Collections.IEnumerable, System.ICloneable, System.IComparable, System.IComparable<string>, System.IConvertible, System.IEquatable<string>
    {
        public static bool operator !=(string a, string b) => throw null;
        public static bool operator ==(string a, string b) => throw null;
        [System.Runtime.CompilerServices.IndexerName("Chars")]
        public System.Char this[int index] { get => throw null; }
        public object Clone() => throw null;
        public static int Compare(string strA, int indexA, string strB, int indexB, int length) => throw null;
        public static int Compare(string strA, int indexA, string strB, int indexB, int length, System.Globalization.CultureInfo culture, System.Globalization.CompareOptions options) => throw null;
        public static int Compare(string strA, int indexA, string strB, int indexB, int length, System.StringComparison comparisonType) => throw null;
        public static int Compare(string strA, int indexA, string strB, int indexB, int length, bool ignoreCase) => throw null;
        public static int Compare(string strA, int indexA, string strB, int indexB, int length, bool ignoreCase, System.Globalization.CultureInfo culture) => throw null;
        public static int Compare(string strA, string strB) => throw null;
        public static int Compare(string strA, string strB, System.Globalization.CultureInfo culture, System.Globalization.CompareOptions options) => throw null;
        public static int Compare(string strA, string strB, System.StringComparison comparisonType) => throw null;
        public static int Compare(string strA, string strB, bool ignoreCase) => throw null;
        public static int Compare(string strA, string strB, bool ignoreCase, System.Globalization.CultureInfo culture) => throw null;
        public static int CompareOrdinal(string strA, int indexA, string strB, int indexB, int length) => throw null;
        public static int CompareOrdinal(string strA, string strB) => throw null;
        public int CompareTo(object value) => throw null;
        public int CompareTo(string strB) => throw null;
        public static string Concat(System.Collections.Generic.IEnumerable<string> values) => throw null;
        public static string Concat(System.ReadOnlySpan<System.Char> str0, System.ReadOnlySpan<System.Char> str1) => throw null;
        public static string Concat(System.ReadOnlySpan<System.Char> str0, System.ReadOnlySpan<System.Char> str1, System.ReadOnlySpan<System.Char> str2) => throw null;
        public static string Concat(System.ReadOnlySpan<System.Char> str0, System.ReadOnlySpan<System.Char> str1, System.ReadOnlySpan<System.Char> str2, System.ReadOnlySpan<System.Char> str3) => throw null;
        public static string Concat(object arg0) => throw null;
        public static string Concat(object arg0, object arg1) => throw null;
        public static string Concat(object arg0, object arg1, object arg2) => throw null;
        public static string Concat(params object[] args) => throw null;
        public static string Concat(params string[] values) => throw null;
        public static string Concat(string str0, string str1) => throw null;
        public static string Concat(string str0, string str1, string str2) => throw null;
        public static string Concat(string str0, string str1, string str2, string str3) => throw null;
        public static string Concat<T>(System.Collections.Generic.IEnumerable<T> values) => throw null;
        public bool Contains(System.Char value) => throw null;
        public bool Contains(System.Char value, System.StringComparison comparisonType) => throw null;
        public bool Contains(string value) => throw null;
        public bool Contains(string value, System.StringComparison comparisonType) => throw null;
        public static string Copy(string str) => throw null;
        public void CopyTo(int sourceIndex, System.Char[] destination, int destinationIndex, int count) => throw null;
        public static string Create<TState>(int length, TState state, System.Buffers.SpanAction<System.Char, TState> action) => throw null;
        public static string Empty;
        public bool EndsWith(System.Char value) => throw null;
        public bool EndsWith(string value) => throw null;
        public bool EndsWith(string value, System.StringComparison comparisonType) => throw null;
        public bool EndsWith(string value, bool ignoreCase, System.Globalization.CultureInfo culture) => throw null;
        public System.Text.StringRuneEnumerator EnumerateRunes() => throw null;
        public override bool Equals(object obj) => throw null;
        public bool Equals(string value) => throw null;
        public bool Equals(string value, System.StringComparison comparisonType) => throw null;
        public static bool Equals(string a, string b) => throw null;
        public static bool Equals(string a, string b, System.StringComparison comparisonType) => throw null;
        public static string Format(System.IFormatProvider provider, string format, object arg0) => throw null;
        public static string Format(System.IFormatProvider provider, string format, object arg0, object arg1) => throw null;
        public static string Format(System.IFormatProvider provider, string format, object arg0, object arg1, object arg2) => throw null;
        public static string Format(System.IFormatProvider provider, string format, params object[] args) => throw null;
        public static string Format(string format, object arg0) => throw null;
        public static string Format(string format, object arg0, object arg1) => throw null;
        public static string Format(string format, object arg0, object arg1, object arg2) => throw null;
        public static string Format(string format, params object[] args) => throw null;
        public System.CharEnumerator GetEnumerator() => throw null;
        System.Collections.Generic.IEnumerator<System.Char> System.Collections.Generic.IEnumerable<System.Char>.GetEnumerator() => throw null;
        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
        public override int GetHashCode() => throw null;
        public static int GetHashCode(System.ReadOnlySpan<System.Char> value) => throw null;
        public static int GetHashCode(System.ReadOnlySpan<System.Char> value, System.StringComparison comparisonType) => throw null;
        public int GetHashCode(System.StringComparison comparisonType) => throw null;
        public System.Char GetPinnableReference() => throw null;
        public System.TypeCode GetTypeCode() => throw null;
        public int IndexOf(System.Char value) => throw null;
        public int IndexOf(System.Char value, System.StringComparison comparisonType) => throw null;
        public int IndexOf(System.Char value, int startIndex) => throw null;
        public int IndexOf(System.Char value, int startIndex, int count) => throw null;
        public int IndexOf(string value) => throw null;
        public int IndexOf(string value, System.StringComparison comparisonType) => throw null;
        public int IndexOf(string value, int startIndex) => throw null;
        public int IndexOf(string value, int startIndex, System.StringComparison comparisonType) => throw null;
        public int IndexOf(string value, int startIndex, int count) => throw null;
        public int IndexOf(string value, int startIndex, int count, System.StringComparison comparisonType) => throw null;
        public int IndexOfAny(System.Char[] anyOf) => throw null;
        public int IndexOfAny(System.Char[] anyOf, int startIndex) => throw null;
        public int IndexOfAny(System.Char[] anyOf, int startIndex, int count) => throw null;
        public string Insert(int startIndex, string value) => throw null;
        public static string Intern(string str) => throw null;
        public static string IsInterned(string str) => throw null;
        public bool IsNormalized() => throw null;
        public bool IsNormalized(System.Text.NormalizationForm normalizationForm) => throw null;
        public static bool IsNullOrEmpty(string value) => throw null;
        public static bool IsNullOrWhiteSpace(string value) => throw null;
        public static string Join(System.Char separator, string[] value, int startIndex, int count) => throw null;
        public static string Join(System.Char separator, params object[] values) => throw null;
        public static string Join(System.Char separator, params string[] value) => throw null;
        public static string Join(string separator, System.Collections.Generic.IEnumerable<string> values) => throw null;
        public static string Join(string separator, string[] value, int startIndex, int count) => throw null;
        public static string Join(string separator, params object[] values) => throw null;
        public static string Join(string separator, params string[] value) => throw null;
        public static string Join<T>(System.Char separator, System.Collections.Generic.IEnumerable<T> values) => throw null;
        public static string Join<T>(string separator, System.Collections.Generic.IEnumerable<T> values) => throw null;
        public int LastIndexOf(System.Char value) => throw null;
        public int LastIndexOf(System.Char value, int startIndex) => throw null;
        public int LastIndexOf(System.Char value, int startIndex, int count) => throw null;
        public int LastIndexOf(string value) => throw null;
        public int LastIndexOf(string value, System.StringComparison comparisonType) => throw null;
        public int LastIndexOf(string value, int startIndex) => throw null;
        public int LastIndexOf(string value, int startIndex, System.StringComparison comparisonType) => throw null;
        public int LastIndexOf(string value, int startIndex, int count) => throw null;
        public int LastIndexOf(string value, int startIndex, int count, System.StringComparison comparisonType) => throw null;
        public int LastIndexOfAny(System.Char[] anyOf) => throw null;
        public int LastIndexOfAny(System.Char[] anyOf, int startIndex) => throw null;
        public int LastIndexOfAny(System.Char[] anyOf, int startIndex, int count) => throw null;
        public int Length { get => throw null; }
        public string Normalize() => throw null;
        public string Normalize(System.Text.NormalizationForm normalizationForm) => throw null;
        public string PadLeft(int totalWidth) => throw null;
        public string PadLeft(int totalWidth, System.Char paddingChar) => throw null;
        public string PadRight(int totalWidth) => throw null;
        public string PadRight(int totalWidth, System.Char paddingChar) => throw null;
        public string Remove(int startIndex) => throw null;
        public string Remove(int startIndex, int count) => throw null;
        public string Replace(System.Char oldChar, System.Char newChar) => throw null;
        public string Replace(string oldValue, string newValue) => throw null;
        public string Replace(string oldValue, string newValue, System.StringComparison comparisonType) => throw null;
        public string Replace(string oldValue, string newValue, bool ignoreCase, System.Globalization.CultureInfo culture) => throw null;
        public string[] Split(System.Char[] separator, System.StringSplitOptions options) => throw null;
        public string[] Split(System.Char[] separator, int count) => throw null;
        public string[] Split(System.Char[] separator, int count, System.StringSplitOptions options) => throw null;
        public string[] Split(string[] separator, System.StringSplitOptions options) => throw null;
        public string[] Split(string[] separator, int count, System.StringSplitOptions options) => throw null;
        public string[] Split(System.Char separator, System.StringSplitOptions options = default(System.StringSplitOptions)) => throw null;
        public string[] Split(System.Char separator, int count, System.StringSplitOptions options = default(System.StringSplitOptions)) => throw null;
        public string[] Split(params System.Char[] separator) => throw null;
        public string[] Split(string separator, System.StringSplitOptions options = default(System.StringSplitOptions)) => throw null;
        public string[] Split(string separator, int count, System.StringSplitOptions options = default(System.StringSplitOptions)) => throw null;
        public bool StartsWith(System.Char value) => throw null;
        public bool StartsWith(string value) => throw null;
        public bool StartsWith(string value, System.StringComparison comparisonType) => throw null;
        public bool StartsWith(string value, bool ignoreCase, System.Globalization.CultureInfo culture) => throw null;
        public String(System.Char[] value) => throw null;
        public String(System.Char[] value, int startIndex, int length) => throw null;
        public String(System.ReadOnlySpan<System.Char> value) => throw null;
        unsafe public String(System.Char* value) => throw null;
        unsafe public String(System.Char* value, int startIndex, int length) => throw null;
        public String(System.Char c, int count) => throw null;
        unsafe public String(System.SByte* value) => throw null;
        unsafe public String(System.SByte* value, int startIndex, int length) => throw null;
        unsafe public String(System.SByte* value, int startIndex, int length, System.Text.Encoding enc) => throw null;
        public string Substring(int startIndex) => throw null;
        public string Substring(int startIndex, int length) => throw null;
        bool System.IConvertible.ToBoolean(System.IFormatProvider provider) => throw null;
        System.Byte System.IConvertible.ToByte(System.IFormatProvider provider) => throw null;
        System.Char System.IConvertible.ToChar(System.IFormatProvider provider) => throw null;
        public System.Char[] ToCharArray() => throw null;
        public System.Char[] ToCharArray(int startIndex, int length) => throw null;
        System.DateTime System.IConvertible.ToDateTime(System.IFormatProvider provider) => throw null;
        System.Decimal System.IConvertible.ToDecimal(System.IFormatProvider provider) => throw null;
        double System.IConvertible.ToDouble(System.IFormatProvider provider) => throw null;
        System.Int16 System.IConvertible.ToInt16(System.IFormatProvider provider) => throw null;
        int System.IConvertible.ToInt32(System.IFormatProvider provider) => throw null;
        System.Int64 System.IConvertible.ToInt64(System.IFormatProvider provider) => throw null;
        public string ToLower() => throw null;
        public string ToLower(System.Globalization.CultureInfo culture) => throw null;
        public string ToLowerInvariant() => throw null;
        System.SByte System.IConvertible.ToSByte(System.IFormatProvider provider) => throw null;
        float System.IConvertible.ToSingle(System.IFormatProvider provider) => throw null;
        public override string ToString() => throw null;
        public string ToString(System.IFormatProvider provider) => throw null;
        object System.IConvertible.ToType(System.Type type, System.IFormatProvider provider) => throw null;
        System.UInt16 System.IConvertible.ToUInt16(System.IFormatProvider provider) => throw null;
        System.UInt32 System.IConvertible.ToUInt32(System.IFormatProvider provider) => throw null;
        System.UInt64 System.IConvertible.ToUInt64(System.IFormatProvider provider) => throw null;
        public string ToUpper() => throw null;
        public string ToUpper(System.Globalization.CultureInfo culture) => throw null;
        public string ToUpperInvariant() => throw null;
        public string Trim() => throw null;
        public string Trim(System.Char trimChar) => throw null;
        public string Trim(params System.Char[] trimChars) => throw null;
        public string TrimEnd() => throw null;
        public string TrimEnd(System.Char trimChar) => throw null;
        public string TrimEnd(params System.Char[] trimChars) => throw null;
        public string TrimStart() => throw null;
        public string TrimStart(System.Char trimChar) => throw null;
        public string TrimStart(params System.Char[] trimChars) => throw null;
        public static implicit operator System.ReadOnlySpan<System.Char>(string value) => throw null;
    }

    // Generated from `System.StringComparer` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public abstract class StringComparer : System.Collections.Generic.IComparer<string>, System.Collections.Generic.IEqualityComparer<string>, System.Collections.IComparer, System.Collections.IEqualityComparer
    {
        public int Compare(object x, object y) => throw null;
        public abstract int Compare(string x, string y);
        public static System.StringComparer Create(System.Globalization.CultureInfo culture, System.Globalization.CompareOptions options) => throw null;
        public static System.StringComparer Create(System.Globalization.CultureInfo culture, bool ignoreCase) => throw null;
        public static System.StringComparer CurrentCulture { get => throw null; }
        public static System.StringComparer CurrentCultureIgnoreCase { get => throw null; }
        public bool Equals(object x, object y) => throw null;
        public abstract bool Equals(string x, string y);
        public static System.StringComparer FromComparison(System.StringComparison comparisonType) => throw null;
        public int GetHashCode(object obj) => throw null;
        public abstract int GetHashCode(string obj);
        public static System.StringComparer InvariantCulture { get => throw null; }
        public static System.StringComparer InvariantCultureIgnoreCase { get => throw null; }
        public static System.StringComparer Ordinal { get => throw null; }
        public static System.StringComparer OrdinalIgnoreCase { get => throw null; }
        protected StringComparer() => throw null;
    }

    // Generated from `System.StringComparison` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public enum StringComparison
    {
        CurrentCulture,
        CurrentCultureIgnoreCase,
        InvariantCulture,
        InvariantCultureIgnoreCase,
        Ordinal,
        OrdinalIgnoreCase,
    }

    // Generated from `System.StringNormalizationExtensions` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public static class StringNormalizationExtensions
    {
        public static bool IsNormalized(this string strInput) => throw null;
        public static bool IsNormalized(this string strInput, System.Text.NormalizationForm normalizationForm) => throw null;
        public static string Normalize(this string strInput) => throw null;
        public static string Normalize(this string strInput, System.Text.NormalizationForm normalizationForm) => throw null;
    }

    // Generated from `System.StringSplitOptions` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    [System.Flags]
    public enum StringSplitOptions
    {
        None,
        RemoveEmptyEntries,
        TrimEntries,
    }

    // Generated from `System.SystemException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class SystemException : System.Exception
    {
        public SystemException() => throw null;
        protected SystemException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public SystemException(string message) => throw null;
        public SystemException(string message, System.Exception innerException) => throw null;
    }

    // Generated from `System.ThreadStaticAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class ThreadStaticAttribute : System.Attribute
    {
        public ThreadStaticAttribute() => throw null;
    }

    // Generated from `System.TimeSpan` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct TimeSpan : System.IComparable, System.IComparable<System.TimeSpan>, System.IEquatable<System.TimeSpan>, System.IFormattable
    {
        public static bool operator !=(System.TimeSpan t1, System.TimeSpan t2) => throw null;
        public static System.TimeSpan operator *(System.TimeSpan timeSpan, double factor) => throw null;
        public static System.TimeSpan operator *(double factor, System.TimeSpan timeSpan) => throw null;
        public static System.TimeSpan operator +(System.TimeSpan t) => throw null;
        public static System.TimeSpan operator +(System.TimeSpan t1, System.TimeSpan t2) => throw null;
        public static System.TimeSpan operator -(System.TimeSpan t) => throw null;
        public static System.TimeSpan operator -(System.TimeSpan t1, System.TimeSpan t2) => throw null;
        public static double operator /(System.TimeSpan t1, System.TimeSpan t2) => throw null;
        public static System.TimeSpan operator /(System.TimeSpan timeSpan, double divisor) => throw null;
        public static bool operator <(System.TimeSpan t1, System.TimeSpan t2) => throw null;
        public static bool operator <=(System.TimeSpan t1, System.TimeSpan t2) => throw null;
        public static bool operator ==(System.TimeSpan t1, System.TimeSpan t2) => throw null;
        public static bool operator >(System.TimeSpan t1, System.TimeSpan t2) => throw null;
        public static bool operator >=(System.TimeSpan t1, System.TimeSpan t2) => throw null;
        public System.TimeSpan Add(System.TimeSpan ts) => throw null;
        public static int Compare(System.TimeSpan t1, System.TimeSpan t2) => throw null;
        public int CompareTo(System.TimeSpan value) => throw null;
        public int CompareTo(object value) => throw null;
        public int Days { get => throw null; }
        public double Divide(System.TimeSpan ts) => throw null;
        public System.TimeSpan Divide(double divisor) => throw null;
        public System.TimeSpan Duration() => throw null;
        public bool Equals(System.TimeSpan obj) => throw null;
        public static bool Equals(System.TimeSpan t1, System.TimeSpan t2) => throw null;
        public override bool Equals(object value) => throw null;
        public static System.TimeSpan FromDays(double value) => throw null;
        public static System.TimeSpan FromHours(double value) => throw null;
        public static System.TimeSpan FromMilliseconds(double value) => throw null;
        public static System.TimeSpan FromMinutes(double value) => throw null;
        public static System.TimeSpan FromSeconds(double value) => throw null;
        public static System.TimeSpan FromTicks(System.Int64 value) => throw null;
        public override int GetHashCode() => throw null;
        public int Hours { get => throw null; }
        public static System.TimeSpan MaxValue;
        public int Milliseconds { get => throw null; }
        public static System.TimeSpan MinValue;
        public int Minutes { get => throw null; }
        public System.TimeSpan Multiply(double factor) => throw null;
        public System.TimeSpan Negate() => throw null;
        public static System.TimeSpan Parse(System.ReadOnlySpan<System.Char> input, System.IFormatProvider formatProvider = default(System.IFormatProvider)) => throw null;
        public static System.TimeSpan Parse(string s) => throw null;
        public static System.TimeSpan Parse(string input, System.IFormatProvider formatProvider) => throw null;
        public static System.TimeSpan ParseExact(System.ReadOnlySpan<System.Char> input, System.ReadOnlySpan<System.Char> format, System.IFormatProvider formatProvider, System.Globalization.TimeSpanStyles styles = default(System.Globalization.TimeSpanStyles)) => throw null;
        public static System.TimeSpan ParseExact(System.ReadOnlySpan<System.Char> input, string[] formats, System.IFormatProvider formatProvider, System.Globalization.TimeSpanStyles styles = default(System.Globalization.TimeSpanStyles)) => throw null;
        public static System.TimeSpan ParseExact(string input, string[] formats, System.IFormatProvider formatProvider) => throw null;
        public static System.TimeSpan ParseExact(string input, string[] formats, System.IFormatProvider formatProvider, System.Globalization.TimeSpanStyles styles) => throw null;
        public static System.TimeSpan ParseExact(string input, string format, System.IFormatProvider formatProvider) => throw null;
        public static System.TimeSpan ParseExact(string input, string format, System.IFormatProvider formatProvider, System.Globalization.TimeSpanStyles styles) => throw null;
        public int Seconds { get => throw null; }
        public System.TimeSpan Subtract(System.TimeSpan ts) => throw null;
        public System.Int64 Ticks { get => throw null; }
        public const System.Int64 TicksPerDay = default;
        public const System.Int64 TicksPerHour = default;
        public const System.Int64 TicksPerMillisecond = default;
        public const System.Int64 TicksPerMinute = default;
        public const System.Int64 TicksPerSecond = default;
        // Stub generator skipped constructor 
        public TimeSpan(int hours, int minutes, int seconds) => throw null;
        public TimeSpan(int days, int hours, int minutes, int seconds) => throw null;
        public TimeSpan(int days, int hours, int minutes, int seconds, int milliseconds) => throw null;
        public TimeSpan(System.Int64 ticks) => throw null;
        public override string ToString() => throw null;
        public string ToString(string format) => throw null;
        public string ToString(string format, System.IFormatProvider formatProvider) => throw null;
        public double TotalDays { get => throw null; }
        public double TotalHours { get => throw null; }
        public double TotalMilliseconds { get => throw null; }
        public double TotalMinutes { get => throw null; }
        public double TotalSeconds { get => throw null; }
        public bool TryFormat(System.Span<System.Char> destination, out int charsWritten, System.ReadOnlySpan<System.Char> format = default(System.ReadOnlySpan<System.Char>), System.IFormatProvider formatProvider = default(System.IFormatProvider)) => throw null;
        public static bool TryParse(System.ReadOnlySpan<System.Char> input, System.IFormatProvider formatProvider, out System.TimeSpan result) => throw null;
        public static bool TryParse(System.ReadOnlySpan<System.Char> s, out System.TimeSpan result) => throw null;
        public static bool TryParse(string input, System.IFormatProvider formatProvider, out System.TimeSpan result) => throw null;
        public static bool TryParse(string s, out System.TimeSpan result) => throw null;
        public static bool TryParseExact(System.ReadOnlySpan<System.Char> input, System.ReadOnlySpan<System.Char> format, System.IFormatProvider formatProvider, System.Globalization.TimeSpanStyles styles, out System.TimeSpan result) => throw null;
        public static bool TryParseExact(System.ReadOnlySpan<System.Char> input, System.ReadOnlySpan<System.Char> format, System.IFormatProvider formatProvider, out System.TimeSpan result) => throw null;
        public static bool TryParseExact(System.ReadOnlySpan<System.Char> input, string[] formats, System.IFormatProvider formatProvider, System.Globalization.TimeSpanStyles styles, out System.TimeSpan result) => throw null;
        public static bool TryParseExact(System.ReadOnlySpan<System.Char> input, string[] formats, System.IFormatProvider formatProvider, out System.TimeSpan result) => throw null;
        public static bool TryParseExact(string input, string[] formats, System.IFormatProvider formatProvider, System.Globalization.TimeSpanStyles styles, out System.TimeSpan result) => throw null;
        public static bool TryParseExact(string input, string[] formats, System.IFormatProvider formatProvider, out System.TimeSpan result) => throw null;
        public static bool TryParseExact(string input, string format, System.IFormatProvider formatProvider, System.Globalization.TimeSpanStyles styles, out System.TimeSpan result) => throw null;
        public static bool TryParseExact(string input, string format, System.IFormatProvider formatProvider, out System.TimeSpan result) => throw null;
        public static System.TimeSpan Zero;
    }

    // Generated from `System.TimeZone` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public abstract class TimeZone
    {
        public static System.TimeZone CurrentTimeZone { get => throw null; }
        public abstract string DaylightName { get; }
        public abstract System.Globalization.DaylightTime GetDaylightChanges(int year);
        public abstract System.TimeSpan GetUtcOffset(System.DateTime time);
        public virtual bool IsDaylightSavingTime(System.DateTime time) => throw null;
        public static bool IsDaylightSavingTime(System.DateTime time, System.Globalization.DaylightTime daylightTimes) => throw null;
        public abstract string StandardName { get; }
        protected TimeZone() => throw null;
        public virtual System.DateTime ToLocalTime(System.DateTime time) => throw null;
        public virtual System.DateTime ToUniversalTime(System.DateTime time) => throw null;
    }

    // Generated from `System.TimeZoneInfo` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class TimeZoneInfo : System.IEquatable<System.TimeZoneInfo>, System.Runtime.Serialization.IDeserializationCallback, System.Runtime.Serialization.ISerializable
    {
        // Generated from `System.TimeZoneInfo+AdjustmentRule` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class AdjustmentRule : System.IEquatable<System.TimeZoneInfo.AdjustmentRule>, System.Runtime.Serialization.IDeserializationCallback, System.Runtime.Serialization.ISerializable
        {
            public static System.TimeZoneInfo.AdjustmentRule CreateAdjustmentRule(System.DateTime dateStart, System.DateTime dateEnd, System.TimeSpan daylightDelta, System.TimeZoneInfo.TransitionTime daylightTransitionStart, System.TimeZoneInfo.TransitionTime daylightTransitionEnd) => throw null;
            public System.DateTime DateEnd { get => throw null; }
            public System.DateTime DateStart { get => throw null; }
            public System.TimeSpan DaylightDelta { get => throw null; }
            public System.TimeZoneInfo.TransitionTime DaylightTransitionEnd { get => throw null; }
            public System.TimeZoneInfo.TransitionTime DaylightTransitionStart { get => throw null; }
            public bool Equals(System.TimeZoneInfo.AdjustmentRule other) => throw null;
            public override int GetHashCode() => throw null;
            void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            void System.Runtime.Serialization.IDeserializationCallback.OnDeserialization(object sender) => throw null;
        }


        // Generated from `System.TimeZoneInfo+TransitionTime` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public struct TransitionTime : System.IEquatable<System.TimeZoneInfo.TransitionTime>, System.Runtime.Serialization.IDeserializationCallback, System.Runtime.Serialization.ISerializable
        {
            public static bool operator !=(System.TimeZoneInfo.TransitionTime t1, System.TimeZoneInfo.TransitionTime t2) => throw null;
            public static bool operator ==(System.TimeZoneInfo.TransitionTime t1, System.TimeZoneInfo.TransitionTime t2) => throw null;
            public static System.TimeZoneInfo.TransitionTime CreateFixedDateRule(System.DateTime timeOfDay, int month, int day) => throw null;
            public static System.TimeZoneInfo.TransitionTime CreateFloatingDateRule(System.DateTime timeOfDay, int month, int week, System.DayOfWeek dayOfWeek) => throw null;
            public int Day { get => throw null; }
            public System.DayOfWeek DayOfWeek { get => throw null; }
            public bool Equals(System.TimeZoneInfo.TransitionTime other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public bool IsFixedDateRule { get => throw null; }
            public int Month { get => throw null; }
            void System.Runtime.Serialization.IDeserializationCallback.OnDeserialization(object sender) => throw null;
            public System.DateTime TimeOfDay { get => throw null; }
            // Stub generator skipped constructor 
            public int Week { get => throw null; }
        }


        public System.TimeSpan BaseUtcOffset { get => throw null; }
        public static void ClearCachedData() => throw null;
        public static System.DateTime ConvertTime(System.DateTime dateTime, System.TimeZoneInfo destinationTimeZone) => throw null;
        public static System.DateTime ConvertTime(System.DateTime dateTime, System.TimeZoneInfo sourceTimeZone, System.TimeZoneInfo destinationTimeZone) => throw null;
        public static System.DateTimeOffset ConvertTime(System.DateTimeOffset dateTimeOffset, System.TimeZoneInfo destinationTimeZone) => throw null;
        public static System.DateTime ConvertTimeBySystemTimeZoneId(System.DateTime dateTime, string destinationTimeZoneId) => throw null;
        public static System.DateTime ConvertTimeBySystemTimeZoneId(System.DateTime dateTime, string sourceTimeZoneId, string destinationTimeZoneId) => throw null;
        public static System.DateTimeOffset ConvertTimeBySystemTimeZoneId(System.DateTimeOffset dateTimeOffset, string destinationTimeZoneId) => throw null;
        public static System.DateTime ConvertTimeFromUtc(System.DateTime dateTime, System.TimeZoneInfo destinationTimeZone) => throw null;
        public static System.DateTime ConvertTimeToUtc(System.DateTime dateTime) => throw null;
        public static System.DateTime ConvertTimeToUtc(System.DateTime dateTime, System.TimeZoneInfo sourceTimeZone) => throw null;
        public static System.TimeZoneInfo CreateCustomTimeZone(string id, System.TimeSpan baseUtcOffset, string displayName, string standardDisplayName) => throw null;
        public static System.TimeZoneInfo CreateCustomTimeZone(string id, System.TimeSpan baseUtcOffset, string displayName, string standardDisplayName, string daylightDisplayName, System.TimeZoneInfo.AdjustmentRule[] adjustmentRules) => throw null;
        public static System.TimeZoneInfo CreateCustomTimeZone(string id, System.TimeSpan baseUtcOffset, string displayName, string standardDisplayName, string daylightDisplayName, System.TimeZoneInfo.AdjustmentRule[] adjustmentRules, bool disableDaylightSavingTime) => throw null;
        public string DaylightName { get => throw null; }
        public string DisplayName { get => throw null; }
        public bool Equals(System.TimeZoneInfo other) => throw null;
        public override bool Equals(object obj) => throw null;
        public static System.TimeZoneInfo FindSystemTimeZoneById(string id) => throw null;
        public static System.TimeZoneInfo FromSerializedString(string source) => throw null;
        public System.TimeZoneInfo.AdjustmentRule[] GetAdjustmentRules() => throw null;
        public System.TimeSpan[] GetAmbiguousTimeOffsets(System.DateTime dateTime) => throw null;
        public System.TimeSpan[] GetAmbiguousTimeOffsets(System.DateTimeOffset dateTimeOffset) => throw null;
        public override int GetHashCode() => throw null;
        void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public static System.Collections.ObjectModel.ReadOnlyCollection<System.TimeZoneInfo> GetSystemTimeZones() => throw null;
        public System.TimeSpan GetUtcOffset(System.DateTime dateTime) => throw null;
        public System.TimeSpan GetUtcOffset(System.DateTimeOffset dateTimeOffset) => throw null;
        public bool HasSameRules(System.TimeZoneInfo other) => throw null;
        public string Id { get => throw null; }
        public bool IsAmbiguousTime(System.DateTime dateTime) => throw null;
        public bool IsAmbiguousTime(System.DateTimeOffset dateTimeOffset) => throw null;
        public bool IsDaylightSavingTime(System.DateTime dateTime) => throw null;
        public bool IsDaylightSavingTime(System.DateTimeOffset dateTimeOffset) => throw null;
        public bool IsInvalidTime(System.DateTime dateTime) => throw null;
        public static System.TimeZoneInfo Local { get => throw null; }
        void System.Runtime.Serialization.IDeserializationCallback.OnDeserialization(object sender) => throw null;
        public string StandardName { get => throw null; }
        public bool SupportsDaylightSavingTime { get => throw null; }
        public string ToSerializedString() => throw null;
        public override string ToString() => throw null;
        public static System.TimeZoneInfo Utc { get => throw null; }
    }

    // Generated from `System.TimeZoneNotFoundException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class TimeZoneNotFoundException : System.Exception
    {
        public TimeZoneNotFoundException() => throw null;
        protected TimeZoneNotFoundException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public TimeZoneNotFoundException(string message) => throw null;
        public TimeZoneNotFoundException(string message, System.Exception innerException) => throw null;
    }

    // Generated from `System.TimeoutException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class TimeoutException : System.SystemException
    {
        public TimeoutException() => throw null;
        protected TimeoutException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public TimeoutException(string message) => throw null;
        public TimeoutException(string message, System.Exception innerException) => throw null;
    }

    // Generated from `System.Tuple` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public static class Tuple
    {
        public static System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8>> Create<T1, T2, T3, T4, T5, T6, T7, T8>(T1 item1, T2 item2, T3 item3, T4 item4, T5 item5, T6 item6, T7 item7, T8 item8) => throw null;
        public static System.Tuple<T1, T2, T3, T4, T5, T6, T7> Create<T1, T2, T3, T4, T5, T6, T7>(T1 item1, T2 item2, T3 item3, T4 item4, T5 item5, T6 item6, T7 item7) => throw null;
        public static System.Tuple<T1, T2, T3, T4, T5, T6> Create<T1, T2, T3, T4, T5, T6>(T1 item1, T2 item2, T3 item3, T4 item4, T5 item5, T6 item6) => throw null;
        public static System.Tuple<T1, T2, T3, T4, T5> Create<T1, T2, T3, T4, T5>(T1 item1, T2 item2, T3 item3, T4 item4, T5 item5) => throw null;
        public static System.Tuple<T1, T2, T3, T4> Create<T1, T2, T3, T4>(T1 item1, T2 item2, T3 item3, T4 item4) => throw null;
        public static System.Tuple<T1, T2, T3> Create<T1, T2, T3>(T1 item1, T2 item2, T3 item3) => throw null;
        public static System.Tuple<T1, T2> Create<T1, T2>(T1 item1, T2 item2) => throw null;
        public static System.Tuple<T1> Create<T1>(T1 item1) => throw null;
    }

    // Generated from `System.Tuple<,,,,,,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class Tuple<T1, T2, T3, T4, T5, T6, T7, TRest> : System.Collections.IStructuralComparable, System.Collections.IStructuralEquatable, System.IComparable, System.Runtime.CompilerServices.ITuple
    {
        int System.IComparable.CompareTo(object obj) => throw null;
        int System.Collections.IStructuralComparable.CompareTo(object other, System.Collections.IComparer comparer) => throw null;
        public override bool Equals(object obj) => throw null;
        bool System.Collections.IStructuralEquatable.Equals(object other, System.Collections.IEqualityComparer comparer) => throw null;
        public override int GetHashCode() => throw null;
        int System.Collections.IStructuralEquatable.GetHashCode(System.Collections.IEqualityComparer comparer) => throw null;
        public T1 Item1 { get => throw null; }
        public T2 Item2 { get => throw null; }
        public T3 Item3 { get => throw null; }
        public T4 Item4 { get => throw null; }
        public T5 Item5 { get => throw null; }
        public T6 Item6 { get => throw null; }
        public T7 Item7 { get => throw null; }
        object System.Runtime.CompilerServices.ITuple.this[int index] { get => throw null; }
        int System.Runtime.CompilerServices.ITuple.Length { get => throw null; }
        public TRest Rest { get => throw null; }
        public override string ToString() => throw null;
        public Tuple(T1 item1, T2 item2, T3 item3, T4 item4, T5 item5, T6 item6, T7 item7, TRest rest) => throw null;
    }

    // Generated from `System.Tuple<,,,,,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class Tuple<T1, T2, T3, T4, T5, T6, T7> : System.Collections.IStructuralComparable, System.Collections.IStructuralEquatable, System.IComparable, System.Runtime.CompilerServices.ITuple
    {
        int System.IComparable.CompareTo(object obj) => throw null;
        int System.Collections.IStructuralComparable.CompareTo(object other, System.Collections.IComparer comparer) => throw null;
        public override bool Equals(object obj) => throw null;
        bool System.Collections.IStructuralEquatable.Equals(object other, System.Collections.IEqualityComparer comparer) => throw null;
        public override int GetHashCode() => throw null;
        int System.Collections.IStructuralEquatable.GetHashCode(System.Collections.IEqualityComparer comparer) => throw null;
        public T1 Item1 { get => throw null; }
        public T2 Item2 { get => throw null; }
        public T3 Item3 { get => throw null; }
        public T4 Item4 { get => throw null; }
        public T5 Item5 { get => throw null; }
        public T6 Item6 { get => throw null; }
        public T7 Item7 { get => throw null; }
        object System.Runtime.CompilerServices.ITuple.this[int index] { get => throw null; }
        int System.Runtime.CompilerServices.ITuple.Length { get => throw null; }
        public override string ToString() => throw null;
        public Tuple(T1 item1, T2 item2, T3 item3, T4 item4, T5 item5, T6 item6, T7 item7) => throw null;
    }

    // Generated from `System.Tuple<,,,,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class Tuple<T1, T2, T3, T4, T5, T6> : System.Collections.IStructuralComparable, System.Collections.IStructuralEquatable, System.IComparable, System.Runtime.CompilerServices.ITuple
    {
        int System.IComparable.CompareTo(object obj) => throw null;
        int System.Collections.IStructuralComparable.CompareTo(object other, System.Collections.IComparer comparer) => throw null;
        public override bool Equals(object obj) => throw null;
        bool System.Collections.IStructuralEquatable.Equals(object other, System.Collections.IEqualityComparer comparer) => throw null;
        public override int GetHashCode() => throw null;
        int System.Collections.IStructuralEquatable.GetHashCode(System.Collections.IEqualityComparer comparer) => throw null;
        public T1 Item1 { get => throw null; }
        public T2 Item2 { get => throw null; }
        public T3 Item3 { get => throw null; }
        public T4 Item4 { get => throw null; }
        public T5 Item5 { get => throw null; }
        public T6 Item6 { get => throw null; }
        object System.Runtime.CompilerServices.ITuple.this[int index] { get => throw null; }
        int System.Runtime.CompilerServices.ITuple.Length { get => throw null; }
        public override string ToString() => throw null;
        public Tuple(T1 item1, T2 item2, T3 item3, T4 item4, T5 item5, T6 item6) => throw null;
    }

    // Generated from `System.Tuple<,,,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class Tuple<T1, T2, T3, T4, T5> : System.Collections.IStructuralComparable, System.Collections.IStructuralEquatable, System.IComparable, System.Runtime.CompilerServices.ITuple
    {
        int System.IComparable.CompareTo(object obj) => throw null;
        int System.Collections.IStructuralComparable.CompareTo(object other, System.Collections.IComparer comparer) => throw null;
        public override bool Equals(object obj) => throw null;
        bool System.Collections.IStructuralEquatable.Equals(object other, System.Collections.IEqualityComparer comparer) => throw null;
        public override int GetHashCode() => throw null;
        int System.Collections.IStructuralEquatable.GetHashCode(System.Collections.IEqualityComparer comparer) => throw null;
        public T1 Item1 { get => throw null; }
        public T2 Item2 { get => throw null; }
        public T3 Item3 { get => throw null; }
        public T4 Item4 { get => throw null; }
        public T5 Item5 { get => throw null; }
        object System.Runtime.CompilerServices.ITuple.this[int index] { get => throw null; }
        int System.Runtime.CompilerServices.ITuple.Length { get => throw null; }
        public override string ToString() => throw null;
        public Tuple(T1 item1, T2 item2, T3 item3, T4 item4, T5 item5) => throw null;
    }

    // Generated from `System.Tuple<,,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class Tuple<T1, T2, T3, T4> : System.Collections.IStructuralComparable, System.Collections.IStructuralEquatable, System.IComparable, System.Runtime.CompilerServices.ITuple
    {
        int System.IComparable.CompareTo(object obj) => throw null;
        int System.Collections.IStructuralComparable.CompareTo(object other, System.Collections.IComparer comparer) => throw null;
        public override bool Equals(object obj) => throw null;
        bool System.Collections.IStructuralEquatable.Equals(object other, System.Collections.IEqualityComparer comparer) => throw null;
        public override int GetHashCode() => throw null;
        int System.Collections.IStructuralEquatable.GetHashCode(System.Collections.IEqualityComparer comparer) => throw null;
        public T1 Item1 { get => throw null; }
        public T2 Item2 { get => throw null; }
        public T3 Item3 { get => throw null; }
        public T4 Item4 { get => throw null; }
        object System.Runtime.CompilerServices.ITuple.this[int index] { get => throw null; }
        int System.Runtime.CompilerServices.ITuple.Length { get => throw null; }
        public override string ToString() => throw null;
        public Tuple(T1 item1, T2 item2, T3 item3, T4 item4) => throw null;
    }

    // Generated from `System.Tuple<,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class Tuple<T1, T2, T3> : System.Collections.IStructuralComparable, System.Collections.IStructuralEquatable, System.IComparable, System.Runtime.CompilerServices.ITuple
    {
        int System.IComparable.CompareTo(object obj) => throw null;
        int System.Collections.IStructuralComparable.CompareTo(object other, System.Collections.IComparer comparer) => throw null;
        public override bool Equals(object obj) => throw null;
        bool System.Collections.IStructuralEquatable.Equals(object other, System.Collections.IEqualityComparer comparer) => throw null;
        public override int GetHashCode() => throw null;
        int System.Collections.IStructuralEquatable.GetHashCode(System.Collections.IEqualityComparer comparer) => throw null;
        public T1 Item1 { get => throw null; }
        public T2 Item2 { get => throw null; }
        public T3 Item3 { get => throw null; }
        object System.Runtime.CompilerServices.ITuple.this[int index] { get => throw null; }
        int System.Runtime.CompilerServices.ITuple.Length { get => throw null; }
        public override string ToString() => throw null;
        public Tuple(T1 item1, T2 item2, T3 item3) => throw null;
    }

    // Generated from `System.Tuple<,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class Tuple<T1, T2> : System.Collections.IStructuralComparable, System.Collections.IStructuralEquatable, System.IComparable, System.Runtime.CompilerServices.ITuple
    {
        int System.IComparable.CompareTo(object obj) => throw null;
        int System.Collections.IStructuralComparable.CompareTo(object other, System.Collections.IComparer comparer) => throw null;
        public override bool Equals(object obj) => throw null;
        bool System.Collections.IStructuralEquatable.Equals(object other, System.Collections.IEqualityComparer comparer) => throw null;
        public override int GetHashCode() => throw null;
        int System.Collections.IStructuralEquatable.GetHashCode(System.Collections.IEqualityComparer comparer) => throw null;
        public T1 Item1 { get => throw null; }
        public T2 Item2 { get => throw null; }
        object System.Runtime.CompilerServices.ITuple.this[int index] { get => throw null; }
        int System.Runtime.CompilerServices.ITuple.Length { get => throw null; }
        public override string ToString() => throw null;
        public Tuple(T1 item1, T2 item2) => throw null;
    }

    // Generated from `System.Tuple<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class Tuple<T1> : System.Collections.IStructuralComparable, System.Collections.IStructuralEquatable, System.IComparable, System.Runtime.CompilerServices.ITuple
    {
        int System.IComparable.CompareTo(object obj) => throw null;
        int System.Collections.IStructuralComparable.CompareTo(object other, System.Collections.IComparer comparer) => throw null;
        public override bool Equals(object obj) => throw null;
        bool System.Collections.IStructuralEquatable.Equals(object other, System.Collections.IEqualityComparer comparer) => throw null;
        public override int GetHashCode() => throw null;
        int System.Collections.IStructuralEquatable.GetHashCode(System.Collections.IEqualityComparer comparer) => throw null;
        public T1 Item1 { get => throw null; }
        object System.Runtime.CompilerServices.ITuple.this[int index] { get => throw null; }
        int System.Runtime.CompilerServices.ITuple.Length { get => throw null; }
        public override string ToString() => throw null;
        public Tuple(T1 item1) => throw null;
    }

    // Generated from `System.TupleExtensions` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public static class TupleExtensions
    {
        public static void Deconstruct<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21>(this System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9, T10, T11, T12, T13, T14, System.Tuple<T15, T16, T17, T18, T19, T20, T21>>> value, out T1 item1, out T2 item2, out T3 item3, out T4 item4, out T5 item5, out T6 item6, out T7 item7, out T8 item8, out T9 item9, out T10 item10, out T11 item11, out T12 item12, out T13 item13, out T14 item14, out T15 item15, out T16 item16, out T17 item17, out T18 item18, out T19 item19, out T20 item20, out T21 item21) => throw null;
        public static void Deconstruct<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20>(this System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9, T10, T11, T12, T13, T14, System.Tuple<T15, T16, T17, T18, T19, T20>>> value, out T1 item1, out T2 item2, out T3 item3, out T4 item4, out T5 item5, out T6 item6, out T7 item7, out T8 item8, out T9 item9, out T10 item10, out T11 item11, out T12 item12, out T13 item13, out T14 item14, out T15 item15, out T16 item16, out T17 item17, out T18 item18, out T19 item19, out T20 item20) => throw null;
        public static void Deconstruct<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19>(this System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9, T10, T11, T12, T13, T14, System.Tuple<T15, T16, T17, T18, T19>>> value, out T1 item1, out T2 item2, out T3 item3, out T4 item4, out T5 item5, out T6 item6, out T7 item7, out T8 item8, out T9 item9, out T10 item10, out T11 item11, out T12 item12, out T13 item13, out T14 item14, out T15 item15, out T16 item16, out T17 item17, out T18 item18, out T19 item19) => throw null;
        public static void Deconstruct<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18>(this System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9, T10, T11, T12, T13, T14, System.Tuple<T15, T16, T17, T18>>> value, out T1 item1, out T2 item2, out T3 item3, out T4 item4, out T5 item5, out T6 item6, out T7 item7, out T8 item8, out T9 item9, out T10 item10, out T11 item11, out T12 item12, out T13 item13, out T14 item14, out T15 item15, out T16 item16, out T17 item17, out T18 item18) => throw null;
        public static void Deconstruct<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17>(this System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9, T10, T11, T12, T13, T14, System.Tuple<T15, T16, T17>>> value, out T1 item1, out T2 item2, out T3 item3, out T4 item4, out T5 item5, out T6 item6, out T7 item7, out T8 item8, out T9 item9, out T10 item10, out T11 item11, out T12 item12, out T13 item13, out T14 item14, out T15 item15, out T16 item16, out T17 item17) => throw null;
        public static void Deconstruct<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16>(this System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9, T10, T11, T12, T13, T14, System.Tuple<T15, T16>>> value, out T1 item1, out T2 item2, out T3 item3, out T4 item4, out T5 item5, out T6 item6, out T7 item7, out T8 item8, out T9 item9, out T10 item10, out T11 item11, out T12 item12, out T13 item13, out T14 item14, out T15 item15, out T16 item16) => throw null;
        public static void Deconstruct<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15>(this System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9, T10, T11, T12, T13, T14, System.Tuple<T15>>> value, out T1 item1, out T2 item2, out T3 item3, out T4 item4, out T5 item5, out T6 item6, out T7 item7, out T8 item8, out T9 item9, out T10 item10, out T11 item11, out T12 item12, out T13 item13, out T14 item14, out T15 item15) => throw null;
        public static void Deconstruct<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>(this System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9, T10, T11, T12, T13, T14>> value, out T1 item1, out T2 item2, out T3 item3, out T4 item4, out T5 item5, out T6 item6, out T7 item7, out T8 item8, out T9 item9, out T10 item10, out T11 item11, out T12 item12, out T13 item13, out T14 item14) => throw null;
        public static void Deconstruct<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>(this System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9, T10, T11, T12, T13>> value, out T1 item1, out T2 item2, out T3 item3, out T4 item4, out T5 item5, out T6 item6, out T7 item7, out T8 item8, out T9 item9, out T10 item10, out T11 item11, out T12 item12, out T13 item13) => throw null;
        public static void Deconstruct<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>(this System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9, T10, T11, T12>> value, out T1 item1, out T2 item2, out T3 item3, out T4 item4, out T5 item5, out T6 item6, out T7 item7, out T8 item8, out T9 item9, out T10 item10, out T11 item11, out T12 item12) => throw null;
        public static void Deconstruct<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>(this System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9, T10, T11>> value, out T1 item1, out T2 item2, out T3 item3, out T4 item4, out T5 item5, out T6 item6, out T7 item7, out T8 item8, out T9 item9, out T10 item10, out T11 item11) => throw null;
        public static void Deconstruct<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>(this System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9, T10>> value, out T1 item1, out T2 item2, out T3 item3, out T4 item4, out T5 item5, out T6 item6, out T7 item7, out T8 item8, out T9 item9, out T10 item10) => throw null;
        public static void Deconstruct<T1, T2, T3, T4, T5, T6, T7, T8, T9>(this System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9>> value, out T1 item1, out T2 item2, out T3 item3, out T4 item4, out T5 item5, out T6 item6, out T7 item7, out T8 item8, out T9 item9) => throw null;
        public static void Deconstruct<T1, T2, T3, T4, T5, T6, T7, T8>(this System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8>> value, out T1 item1, out T2 item2, out T3 item3, out T4 item4, out T5 item5, out T6 item6, out T7 item7, out T8 item8) => throw null;
        public static void Deconstruct<T1, T2, T3, T4, T5, T6, T7>(this System.Tuple<T1, T2, T3, T4, T5, T6, T7> value, out T1 item1, out T2 item2, out T3 item3, out T4 item4, out T5 item5, out T6 item6, out T7 item7) => throw null;
        public static void Deconstruct<T1, T2, T3, T4, T5, T6>(this System.Tuple<T1, T2, T3, T4, T5, T6> value, out T1 item1, out T2 item2, out T3 item3, out T4 item4, out T5 item5, out T6 item6) => throw null;
        public static void Deconstruct<T1, T2, T3, T4, T5>(this System.Tuple<T1, T2, T3, T4, T5> value, out T1 item1, out T2 item2, out T3 item3, out T4 item4, out T5 item5) => throw null;
        public static void Deconstruct<T1, T2, T3, T4>(this System.Tuple<T1, T2, T3, T4> value, out T1 item1, out T2 item2, out T3 item3, out T4 item4) => throw null;
        public static void Deconstruct<T1, T2, T3>(this System.Tuple<T1, T2, T3> value, out T1 item1, out T2 item2, out T3 item3) => throw null;
        public static void Deconstruct<T1, T2>(this System.Tuple<T1, T2> value, out T1 item1, out T2 item2) => throw null;
        public static void Deconstruct<T1>(this System.Tuple<T1> value, out T1 item1) => throw null;
        public static System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9, T10, T11, T12, T13, T14, System.Tuple<T15, T16, T17, T18, T19, T20, T21>>> ToTuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21>(this (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21) value) => throw null;
        public static System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9, T10, T11, T12, T13, T14, System.Tuple<T15, T16, T17, T18, T19, T20>>> ToTuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20>(this (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20) value) => throw null;
        public static System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9, T10, T11, T12, T13, T14, System.Tuple<T15, T16, T17, T18, T19>>> ToTuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19>(this (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19) value) => throw null;
        public static System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9, T10, T11, T12, T13, T14, System.Tuple<T15, T16, T17, T18>>> ToTuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18>(this (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18) value) => throw null;
        public static System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9, T10, T11, T12, T13, T14, System.Tuple<T15, T16, T17>>> ToTuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17>(this (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17) value) => throw null;
        public static System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9, T10, T11, T12, T13, T14, System.Tuple<T15, T16>>> ToTuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16>(this (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16) value) => throw null;
        public static System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9, T10, T11, T12, T13, T14, System.Tuple<T15>>> ToTuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15>(this (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15) value) => throw null;
        public static System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9, T10, T11, T12, T13, T14>> ToTuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>(this (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14) value) => throw null;
        public static System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9, T10, T11, T12, T13>> ToTuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>(this (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13) value) => throw null;
        public static System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9, T10, T11, T12>> ToTuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>(this (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12) value) => throw null;
        public static System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9, T10, T11>> ToTuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>(this (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11) value) => throw null;
        public static System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9, T10>> ToTuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>(this (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10) value) => throw null;
        public static System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9>> ToTuple<T1, T2, T3, T4, T5, T6, T7, T8, T9>(this (T1, T2, T3, T4, T5, T6, T7, T8, T9) value) => throw null;
        public static System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8>> ToTuple<T1, T2, T3, T4, T5, T6, T7, T8>(this (T1, T2, T3, T4, T5, T6, T7, T8) value) => throw null;
        public static System.Tuple<T1, T2, T3, T4, T5, T6, T7> ToTuple<T1, T2, T3, T4, T5, T6, T7>(this (T1, T2, T3, T4, T5, T6, T7) value) => throw null;
        public static System.Tuple<T1, T2, T3, T4, T5, T6> ToTuple<T1, T2, T3, T4, T5, T6>(this (T1, T2, T3, T4, T5, T6) value) => throw null;
        public static System.Tuple<T1, T2, T3, T4, T5> ToTuple<T1, T2, T3, T4, T5>(this (T1, T2, T3, T4, T5) value) => throw null;
        public static System.Tuple<T1, T2, T3, T4> ToTuple<T1, T2, T3, T4>(this (T1, T2, T3, T4) value) => throw null;
        public static System.Tuple<T1, T2, T3> ToTuple<T1, T2, T3>(this (T1, T2, T3) value) => throw null;
        public static System.Tuple<T1, T2> ToTuple<T1, T2>(this (T1, T2) value) => throw null;
        public static System.Tuple<T1> ToTuple<T1>(this System.ValueTuple<T1> value) => throw null;
        public static (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21) ToValueTuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21>(this System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9, T10, T11, T12, T13, T14, System.Tuple<T15, T16, T17, T18, T19, T20, T21>>> value) => throw null;
        public static (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20) ToValueTuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20>(this System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9, T10, T11, T12, T13, T14, System.Tuple<T15, T16, T17, T18, T19, T20>>> value) => throw null;
        public static (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19) ToValueTuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19>(this System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9, T10, T11, T12, T13, T14, System.Tuple<T15, T16, T17, T18, T19>>> value) => throw null;
        public static (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18) ToValueTuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18>(this System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9, T10, T11, T12, T13, T14, System.Tuple<T15, T16, T17, T18>>> value) => throw null;
        public static (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17) ToValueTuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17>(this System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9, T10, T11, T12, T13, T14, System.Tuple<T15, T16, T17>>> value) => throw null;
        public static (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16) ToValueTuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16>(this System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9, T10, T11, T12, T13, T14, System.Tuple<T15, T16>>> value) => throw null;
        public static (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15) ToValueTuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15>(this System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9, T10, T11, T12, T13, T14, System.Tuple<T15>>> value) => throw null;
        public static (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14) ToValueTuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>(this System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9, T10, T11, T12, T13, T14>> value) => throw null;
        public static (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13) ToValueTuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>(this System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9, T10, T11, T12, T13>> value) => throw null;
        public static (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12) ToValueTuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>(this System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9, T10, T11, T12>> value) => throw null;
        public static (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11) ToValueTuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>(this System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9, T10, T11>> value) => throw null;
        public static (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10) ToValueTuple<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>(this System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9, T10>> value) => throw null;
        public static (T1, T2, T3, T4, T5, T6, T7, T8, T9) ToValueTuple<T1, T2, T3, T4, T5, T6, T7, T8, T9>(this System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8, T9>> value) => throw null;
        public static (T1, T2, T3, T4, T5, T6, T7, T8) ToValueTuple<T1, T2, T3, T4, T5, T6, T7, T8>(this System.Tuple<T1, T2, T3, T4, T5, T6, T7, System.Tuple<T8>> value) => throw null;
        public static (T1, T2, T3, T4, T5, T6, T7) ToValueTuple<T1, T2, T3, T4, T5, T6, T7>(this System.Tuple<T1, T2, T3, T4, T5, T6, T7> value) => throw null;
        public static (T1, T2, T3, T4, T5, T6) ToValueTuple<T1, T2, T3, T4, T5, T6>(this System.Tuple<T1, T2, T3, T4, T5, T6> value) => throw null;
        public static (T1, T2, T3, T4, T5) ToValueTuple<T1, T2, T3, T4, T5>(this System.Tuple<T1, T2, T3, T4, T5> value) => throw null;
        public static (T1, T2, T3, T4) ToValueTuple<T1, T2, T3, T4>(this System.Tuple<T1, T2, T3, T4> value) => throw null;
        public static (T1, T2, T3) ToValueTuple<T1, T2, T3>(this System.Tuple<T1, T2, T3> value) => throw null;
        public static (T1, T2) ToValueTuple<T1, T2>(this System.Tuple<T1, T2> value) => throw null;
        public static System.ValueTuple<T1> ToValueTuple<T1>(this System.Tuple<T1> value) => throw null;
    }

    // Generated from `System.Type` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public abstract class Type : System.Reflection.MemberInfo, System.Reflection.IReflect
    {
        public static bool operator !=(System.Type left, System.Type right) => throw null;
        public static bool operator ==(System.Type left, System.Type right) => throw null;
        public abstract System.Reflection.Assembly Assembly { get; }
        public abstract string AssemblyQualifiedName { get; }
        public System.Reflection.TypeAttributes Attributes { get => throw null; }
        public abstract System.Type BaseType { get; }
        public virtual bool ContainsGenericParameters { get => throw null; }
        public virtual System.Reflection.MethodBase DeclaringMethod { get => throw null; }
        public override System.Type DeclaringType { get => throw null; }
        public static System.Reflection.Binder DefaultBinder { get => throw null; }
        public static System.Char Delimiter;
        public static System.Type[] EmptyTypes;
        public virtual bool Equals(System.Type o) => throw null;
        public override bool Equals(object o) => throw null;
        public static System.Reflection.MemberFilter FilterAttribute;
        public static System.Reflection.MemberFilter FilterName;
        public static System.Reflection.MemberFilter FilterNameIgnoreCase;
        public virtual System.Type[] FindInterfaces(System.Reflection.TypeFilter filter, object filterCriteria) => throw null;
        public virtual System.Reflection.MemberInfo[] FindMembers(System.Reflection.MemberTypes memberType, System.Reflection.BindingFlags bindingAttr, System.Reflection.MemberFilter filter, object filterCriteria) => throw null;
        public abstract string FullName { get; }
        public abstract System.Guid GUID { get; }
        public virtual System.Reflection.GenericParameterAttributes GenericParameterAttributes { get => throw null; }
        public virtual int GenericParameterPosition { get => throw null; }
        public virtual System.Type[] GenericTypeArguments { get => throw null; }
        public virtual int GetArrayRank() => throw null;
        protected abstract System.Reflection.TypeAttributes GetAttributeFlagsImpl();
        public System.Reflection.ConstructorInfo GetConstructor(System.Reflection.BindingFlags bindingAttr, System.Reflection.Binder binder, System.Reflection.CallingConventions callConvention, System.Type[] types, System.Reflection.ParameterModifier[] modifiers) => throw null;
        public System.Reflection.ConstructorInfo GetConstructor(System.Reflection.BindingFlags bindingAttr, System.Reflection.Binder binder, System.Type[] types, System.Reflection.ParameterModifier[] modifiers) => throw null;
        public System.Reflection.ConstructorInfo GetConstructor(System.Type[] types) => throw null;
        protected abstract System.Reflection.ConstructorInfo GetConstructorImpl(System.Reflection.BindingFlags bindingAttr, System.Reflection.Binder binder, System.Reflection.CallingConventions callConvention, System.Type[] types, System.Reflection.ParameterModifier[] modifiers);
        public System.Reflection.ConstructorInfo[] GetConstructors() => throw null;
        public abstract System.Reflection.ConstructorInfo[] GetConstructors(System.Reflection.BindingFlags bindingAttr);
        public virtual System.Reflection.MemberInfo[] GetDefaultMembers() => throw null;
        public abstract System.Type GetElementType();
        public virtual string GetEnumName(object value) => throw null;
        public virtual string[] GetEnumNames() => throw null;
        public virtual System.Type GetEnumUnderlyingType() => throw null;
        public virtual System.Array GetEnumValues() => throw null;
        public System.Reflection.EventInfo GetEvent(string name) => throw null;
        public abstract System.Reflection.EventInfo GetEvent(string name, System.Reflection.BindingFlags bindingAttr);
        public virtual System.Reflection.EventInfo[] GetEvents() => throw null;
        public abstract System.Reflection.EventInfo[] GetEvents(System.Reflection.BindingFlags bindingAttr);
        public System.Reflection.FieldInfo GetField(string name) => throw null;
        public abstract System.Reflection.FieldInfo GetField(string name, System.Reflection.BindingFlags bindingAttr);
        public System.Reflection.FieldInfo[] GetFields() => throw null;
        public abstract System.Reflection.FieldInfo[] GetFields(System.Reflection.BindingFlags bindingAttr);
        public virtual System.Type[] GetGenericArguments() => throw null;
        public virtual System.Type[] GetGenericParameterConstraints() => throw null;
        public virtual System.Type GetGenericTypeDefinition() => throw null;
        public override int GetHashCode() => throw null;
        public System.Type GetInterface(string name) => throw null;
        public abstract System.Type GetInterface(string name, bool ignoreCase);
        public virtual System.Reflection.InterfaceMapping GetInterfaceMap(System.Type interfaceType) => throw null;
        public abstract System.Type[] GetInterfaces();
        public System.Reflection.MemberInfo[] GetMember(string name) => throw null;
        public virtual System.Reflection.MemberInfo[] GetMember(string name, System.Reflection.BindingFlags bindingAttr) => throw null;
        public virtual System.Reflection.MemberInfo[] GetMember(string name, System.Reflection.MemberTypes type, System.Reflection.BindingFlags bindingAttr) => throw null;
        public System.Reflection.MemberInfo[] GetMembers() => throw null;
        public abstract System.Reflection.MemberInfo[] GetMembers(System.Reflection.BindingFlags bindingAttr);
        public System.Reflection.MethodInfo GetMethod(string name) => throw null;
        public System.Reflection.MethodInfo GetMethod(string name, System.Reflection.BindingFlags bindingAttr) => throw null;
        public System.Reflection.MethodInfo GetMethod(string name, System.Reflection.BindingFlags bindingAttr, System.Reflection.Binder binder, System.Reflection.CallingConventions callConvention, System.Type[] types, System.Reflection.ParameterModifier[] modifiers) => throw null;
        public System.Reflection.MethodInfo GetMethod(string name, System.Reflection.BindingFlags bindingAttr, System.Reflection.Binder binder, System.Type[] types, System.Reflection.ParameterModifier[] modifiers) => throw null;
        public System.Reflection.MethodInfo GetMethod(string name, System.Type[] types) => throw null;
        public System.Reflection.MethodInfo GetMethod(string name, System.Type[] types, System.Reflection.ParameterModifier[] modifiers) => throw null;
        public System.Reflection.MethodInfo GetMethod(string name, int genericParameterCount, System.Reflection.BindingFlags bindingAttr, System.Reflection.Binder binder, System.Reflection.CallingConventions callConvention, System.Type[] types, System.Reflection.ParameterModifier[] modifiers) => throw null;
        public System.Reflection.MethodInfo GetMethod(string name, int genericParameterCount, System.Reflection.BindingFlags bindingAttr, System.Reflection.Binder binder, System.Type[] types, System.Reflection.ParameterModifier[] modifiers) => throw null;
        public System.Reflection.MethodInfo GetMethod(string name, int genericParameterCount, System.Type[] types) => throw null;
        public System.Reflection.MethodInfo GetMethod(string name, int genericParameterCount, System.Type[] types, System.Reflection.ParameterModifier[] modifiers) => throw null;
        protected abstract System.Reflection.MethodInfo GetMethodImpl(string name, System.Reflection.BindingFlags bindingAttr, System.Reflection.Binder binder, System.Reflection.CallingConventions callConvention, System.Type[] types, System.Reflection.ParameterModifier[] modifiers);
        protected virtual System.Reflection.MethodInfo GetMethodImpl(string name, int genericParameterCount, System.Reflection.BindingFlags bindingAttr, System.Reflection.Binder binder, System.Reflection.CallingConventions callConvention, System.Type[] types, System.Reflection.ParameterModifier[] modifiers) => throw null;
        public System.Reflection.MethodInfo[] GetMethods() => throw null;
        public abstract System.Reflection.MethodInfo[] GetMethods(System.Reflection.BindingFlags bindingAttr);
        public System.Type GetNestedType(string name) => throw null;
        public abstract System.Type GetNestedType(string name, System.Reflection.BindingFlags bindingAttr);
        public System.Type[] GetNestedTypes() => throw null;
        public abstract System.Type[] GetNestedTypes(System.Reflection.BindingFlags bindingAttr);
        public System.Reflection.PropertyInfo[] GetProperties() => throw null;
        public abstract System.Reflection.PropertyInfo[] GetProperties(System.Reflection.BindingFlags bindingAttr);
        public System.Reflection.PropertyInfo GetProperty(string name) => throw null;
        public System.Reflection.PropertyInfo GetProperty(string name, System.Reflection.BindingFlags bindingAttr) => throw null;
        public System.Reflection.PropertyInfo GetProperty(string name, System.Reflection.BindingFlags bindingAttr, System.Reflection.Binder binder, System.Type returnType, System.Type[] types, System.Reflection.ParameterModifier[] modifiers) => throw null;
        public System.Reflection.PropertyInfo GetProperty(string name, System.Type returnType) => throw null;
        public System.Reflection.PropertyInfo GetProperty(string name, System.Type returnType, System.Type[] types) => throw null;
        public System.Reflection.PropertyInfo GetProperty(string name, System.Type returnType, System.Type[] types, System.Reflection.ParameterModifier[] modifiers) => throw null;
        public System.Reflection.PropertyInfo GetProperty(string name, System.Type[] types) => throw null;
        protected abstract System.Reflection.PropertyInfo GetPropertyImpl(string name, System.Reflection.BindingFlags bindingAttr, System.Reflection.Binder binder, System.Type returnType, System.Type[] types, System.Reflection.ParameterModifier[] modifiers);
        public System.Type GetType() => throw null;
        public static System.Type GetType(string typeName) => throw null;
        public static System.Type GetType(string typeName, System.Func<System.Reflection.AssemblyName, System.Reflection.Assembly> assemblyResolver, System.Func<System.Reflection.Assembly, string, bool, System.Type> typeResolver) => throw null;
        public static System.Type GetType(string typeName, System.Func<System.Reflection.AssemblyName, System.Reflection.Assembly> assemblyResolver, System.Func<System.Reflection.Assembly, string, bool, System.Type> typeResolver, bool throwOnError) => throw null;
        public static System.Type GetType(string typeName, System.Func<System.Reflection.AssemblyName, System.Reflection.Assembly> assemblyResolver, System.Func<System.Reflection.Assembly, string, bool, System.Type> typeResolver, bool throwOnError, bool ignoreCase) => throw null;
        public static System.Type GetType(string typeName, bool throwOnError) => throw null;
        public static System.Type GetType(string typeName, bool throwOnError, bool ignoreCase) => throw null;
        public static System.Type[] GetTypeArray(object[] args) => throw null;
        public static System.TypeCode GetTypeCode(System.Type type) => throw null;
        protected virtual System.TypeCode GetTypeCodeImpl() => throw null;
        public static System.Type GetTypeFromCLSID(System.Guid clsid) => throw null;
        public static System.Type GetTypeFromCLSID(System.Guid clsid, bool throwOnError) => throw null;
        public static System.Type GetTypeFromCLSID(System.Guid clsid, string server) => throw null;
        public static System.Type GetTypeFromCLSID(System.Guid clsid, string server, bool throwOnError) => throw null;
        public static System.Type GetTypeFromHandle(System.RuntimeTypeHandle handle) => throw null;
        public static System.Type GetTypeFromProgID(string progID) => throw null;
        public static System.Type GetTypeFromProgID(string progID, bool throwOnError) => throw null;
        public static System.Type GetTypeFromProgID(string progID, string server) => throw null;
        public static System.Type GetTypeFromProgID(string progID, string server, bool throwOnError) => throw null;
        public static System.RuntimeTypeHandle GetTypeHandle(object o) => throw null;
        public bool HasElementType { get => throw null; }
        protected abstract bool HasElementTypeImpl();
        public object InvokeMember(string name, System.Reflection.BindingFlags invokeAttr, System.Reflection.Binder binder, object target, object[] args) => throw null;
        public object InvokeMember(string name, System.Reflection.BindingFlags invokeAttr, System.Reflection.Binder binder, object target, object[] args, System.Globalization.CultureInfo culture) => throw null;
        public abstract object InvokeMember(string name, System.Reflection.BindingFlags invokeAttr, System.Reflection.Binder binder, object target, object[] args, System.Reflection.ParameterModifier[] modifiers, System.Globalization.CultureInfo culture, string[] namedParameters);
        public bool IsAbstract { get => throw null; }
        public bool IsAnsiClass { get => throw null; }
        public bool IsArray { get => throw null; }
        protected abstract bool IsArrayImpl();
        public virtual bool IsAssignableFrom(System.Type c) => throw null;
        public bool IsAssignableTo(System.Type targetType) => throw null;
        public bool IsAutoClass { get => throw null; }
        public bool IsAutoLayout { get => throw null; }
        public bool IsByRef { get => throw null; }
        protected abstract bool IsByRefImpl();
        public virtual bool IsByRefLike { get => throw null; }
        public bool IsCOMObject { get => throw null; }
        protected abstract bool IsCOMObjectImpl();
        public bool IsClass { get => throw null; }
        public virtual bool IsConstructedGenericType { get => throw null; }
        public bool IsContextful { get => throw null; }
        protected virtual bool IsContextfulImpl() => throw null;
        public virtual bool IsEnum { get => throw null; }
        public virtual bool IsEnumDefined(object value) => throw null;
        public virtual bool IsEquivalentTo(System.Type other) => throw null;
        public bool IsExplicitLayout { get => throw null; }
        public virtual bool IsGenericMethodParameter { get => throw null; }
        public virtual bool IsGenericParameter { get => throw null; }
        public virtual bool IsGenericType { get => throw null; }
        public virtual bool IsGenericTypeDefinition { get => throw null; }
        public virtual bool IsGenericTypeParameter { get => throw null; }
        public bool IsImport { get => throw null; }
        public virtual bool IsInstanceOfType(object o) => throw null;
        public bool IsInterface { get => throw null; }
        public bool IsLayoutSequential { get => throw null; }
        public bool IsMarshalByRef { get => throw null; }
        protected virtual bool IsMarshalByRefImpl() => throw null;
        public bool IsNested { get => throw null; }
        public bool IsNestedAssembly { get => throw null; }
        public bool IsNestedFamANDAssem { get => throw null; }
        public bool IsNestedFamORAssem { get => throw null; }
        public bool IsNestedFamily { get => throw null; }
        public bool IsNestedPrivate { get => throw null; }
        public bool IsNestedPublic { get => throw null; }
        public bool IsNotPublic { get => throw null; }
        public bool IsPointer { get => throw null; }
        protected abstract bool IsPointerImpl();
        public bool IsPrimitive { get => throw null; }
        protected abstract bool IsPrimitiveImpl();
        public bool IsPublic { get => throw null; }
        public virtual bool IsSZArray { get => throw null; }
        public bool IsSealed { get => throw null; }
        public virtual bool IsSecurityCritical { get => throw null; }
        public virtual bool IsSecuritySafeCritical { get => throw null; }
        public virtual bool IsSecurityTransparent { get => throw null; }
        public virtual bool IsSerializable { get => throw null; }
        public virtual bool IsSignatureType { get => throw null; }
        public bool IsSpecialName { get => throw null; }
        public virtual bool IsSubclassOf(System.Type c) => throw null;
        public virtual bool IsTypeDefinition { get => throw null; }
        public bool IsUnicodeClass { get => throw null; }
        public bool IsValueType { get => throw null; }
        protected virtual bool IsValueTypeImpl() => throw null;
        public virtual bool IsVariableBoundArray { get => throw null; }
        public bool IsVisible { get => throw null; }
        public virtual System.Type MakeArrayType() => throw null;
        public virtual System.Type MakeArrayType(int rank) => throw null;
        public virtual System.Type MakeByRefType() => throw null;
        public static System.Type MakeGenericMethodParameter(int position) => throw null;
        public static System.Type MakeGenericSignatureType(System.Type genericTypeDefinition, params System.Type[] typeArguments) => throw null;
        public virtual System.Type MakeGenericType(params System.Type[] typeArguments) => throw null;
        public virtual System.Type MakePointerType() => throw null;
        public override System.Reflection.MemberTypes MemberType { get => throw null; }
        public static object Missing;
        public abstract System.Reflection.Module Module { get; }
        public abstract string Namespace { get; }
        public override System.Type ReflectedType { get => throw null; }
        public static System.Type ReflectionOnlyGetType(string typeName, bool throwIfNotFound, bool ignoreCase) => throw null;
        public virtual System.Runtime.InteropServices.StructLayoutAttribute StructLayoutAttribute { get => throw null; }
        public override string ToString() => throw null;
        protected Type() => throw null;
        public virtual System.RuntimeTypeHandle TypeHandle { get => throw null; }
        public System.Reflection.ConstructorInfo TypeInitializer { get => throw null; }
        public abstract System.Type UnderlyingSystemType { get; }
    }

    // Generated from `System.TypeAccessException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class TypeAccessException : System.TypeLoadException
    {
        public TypeAccessException() => throw null;
        protected TypeAccessException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public TypeAccessException(string message) => throw null;
        public TypeAccessException(string message, System.Exception inner) => throw null;
    }

    // Generated from `System.TypeCode` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public enum TypeCode
    {
        Boolean,
        Byte,
        Char,
        DBNull,
        DateTime,
        Decimal,
        Double,
        Empty,
        Int16,
        Int32,
        Int64,
        Object,
        SByte,
        Single,
        String,
        UInt16,
        UInt32,
        UInt64,
    }

    // Generated from `System.TypeInitializationException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class TypeInitializationException : System.SystemException
    {
        public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public TypeInitializationException(string fullTypeName, System.Exception innerException) => throw null;
        public string TypeName { get => throw null; }
    }

    // Generated from `System.TypeLoadException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class TypeLoadException : System.SystemException, System.Runtime.Serialization.ISerializable
    {
        public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public override string Message { get => throw null; }
        public TypeLoadException() => throw null;
        protected TypeLoadException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public TypeLoadException(string message) => throw null;
        public TypeLoadException(string message, System.Exception inner) => throw null;
        public string TypeName { get => throw null; }
    }

    // Generated from `System.TypeUnloadedException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class TypeUnloadedException : System.SystemException
    {
        public TypeUnloadedException() => throw null;
        protected TypeUnloadedException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public TypeUnloadedException(string message) => throw null;
        public TypeUnloadedException(string message, System.Exception innerException) => throw null;
    }

    // Generated from `System.TypedReference` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct TypedReference
    {
        public override bool Equals(object o) => throw null;
        public override int GetHashCode() => throw null;
        public static System.Type GetTargetType(System.TypedReference value) => throw null;
        public static System.TypedReference MakeTypedReference(object target, System.Reflection.FieldInfo[] flds) => throw null;
        public static void SetTypedReference(System.TypedReference target, object value) => throw null;
        public static System.RuntimeTypeHandle TargetTypeToken(System.TypedReference value) => throw null;
        public static object ToObject(System.TypedReference value) => throw null;
        // Stub generator skipped constructor 
    }

    // Generated from `System.UInt16` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct UInt16 : System.IComparable, System.IComparable<System.UInt16>, System.IConvertible, System.IEquatable<System.UInt16>, System.IFormattable
    {
        public int CompareTo(object value) => throw null;
        public int CompareTo(System.UInt16 value) => throw null;
        public override bool Equals(object obj) => throw null;
        public bool Equals(System.UInt16 obj) => throw null;
        public override int GetHashCode() => throw null;
        public System.TypeCode GetTypeCode() => throw null;
        public const System.UInt16 MaxValue = default;
        public const System.UInt16 MinValue = default;
        public static System.UInt16 Parse(System.ReadOnlySpan<System.Char> s, System.Globalization.NumberStyles style = default(System.Globalization.NumberStyles), System.IFormatProvider provider = default(System.IFormatProvider)) => throw null;
        public static System.UInt16 Parse(string s) => throw null;
        public static System.UInt16 Parse(string s, System.IFormatProvider provider) => throw null;
        public static System.UInt16 Parse(string s, System.Globalization.NumberStyles style) => throw null;
        public static System.UInt16 Parse(string s, System.Globalization.NumberStyles style, System.IFormatProvider provider) => throw null;
        bool System.IConvertible.ToBoolean(System.IFormatProvider provider) => throw null;
        System.Byte System.IConvertible.ToByte(System.IFormatProvider provider) => throw null;
        System.Char System.IConvertible.ToChar(System.IFormatProvider provider) => throw null;
        System.DateTime System.IConvertible.ToDateTime(System.IFormatProvider provider) => throw null;
        System.Decimal System.IConvertible.ToDecimal(System.IFormatProvider provider) => throw null;
        double System.IConvertible.ToDouble(System.IFormatProvider provider) => throw null;
        System.Int16 System.IConvertible.ToInt16(System.IFormatProvider provider) => throw null;
        int System.IConvertible.ToInt32(System.IFormatProvider provider) => throw null;
        System.Int64 System.IConvertible.ToInt64(System.IFormatProvider provider) => throw null;
        System.SByte System.IConvertible.ToSByte(System.IFormatProvider provider) => throw null;
        float System.IConvertible.ToSingle(System.IFormatProvider provider) => throw null;
        public override string ToString() => throw null;
        public string ToString(System.IFormatProvider provider) => throw null;
        public string ToString(string format) => throw null;
        public string ToString(string format, System.IFormatProvider provider) => throw null;
        object System.IConvertible.ToType(System.Type type, System.IFormatProvider provider) => throw null;
        System.UInt16 System.IConvertible.ToUInt16(System.IFormatProvider provider) => throw null;
        System.UInt32 System.IConvertible.ToUInt32(System.IFormatProvider provider) => throw null;
        System.UInt64 System.IConvertible.ToUInt64(System.IFormatProvider provider) => throw null;
        public bool TryFormat(System.Span<System.Char> destination, out int charsWritten, System.ReadOnlySpan<System.Char> format = default(System.ReadOnlySpan<System.Char>), System.IFormatProvider provider = default(System.IFormatProvider)) => throw null;
        public static bool TryParse(System.ReadOnlySpan<System.Char> s, System.Globalization.NumberStyles style, System.IFormatProvider provider, out System.UInt16 result) => throw null;
        public static bool TryParse(System.ReadOnlySpan<System.Char> s, out System.UInt16 result) => throw null;
        public static bool TryParse(string s, System.Globalization.NumberStyles style, System.IFormatProvider provider, out System.UInt16 result) => throw null;
        public static bool TryParse(string s, out System.UInt16 result) => throw null;
        // Stub generator skipped constructor 
    }

    // Generated from `System.UInt32` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct UInt32 : System.IComparable, System.IComparable<System.UInt32>, System.IConvertible, System.IEquatable<System.UInt32>, System.IFormattable
    {
        public int CompareTo(object value) => throw null;
        public int CompareTo(System.UInt32 value) => throw null;
        public override bool Equals(object obj) => throw null;
        public bool Equals(System.UInt32 obj) => throw null;
        public override int GetHashCode() => throw null;
        public System.TypeCode GetTypeCode() => throw null;
        public const System.UInt32 MaxValue = default;
        public const System.UInt32 MinValue = default;
        public static System.UInt32 Parse(System.ReadOnlySpan<System.Char> s, System.Globalization.NumberStyles style = default(System.Globalization.NumberStyles), System.IFormatProvider provider = default(System.IFormatProvider)) => throw null;
        public static System.UInt32 Parse(string s) => throw null;
        public static System.UInt32 Parse(string s, System.IFormatProvider provider) => throw null;
        public static System.UInt32 Parse(string s, System.Globalization.NumberStyles style) => throw null;
        public static System.UInt32 Parse(string s, System.Globalization.NumberStyles style, System.IFormatProvider provider) => throw null;
        bool System.IConvertible.ToBoolean(System.IFormatProvider provider) => throw null;
        System.Byte System.IConvertible.ToByte(System.IFormatProvider provider) => throw null;
        System.Char System.IConvertible.ToChar(System.IFormatProvider provider) => throw null;
        System.DateTime System.IConvertible.ToDateTime(System.IFormatProvider provider) => throw null;
        System.Decimal System.IConvertible.ToDecimal(System.IFormatProvider provider) => throw null;
        double System.IConvertible.ToDouble(System.IFormatProvider provider) => throw null;
        System.Int16 System.IConvertible.ToInt16(System.IFormatProvider provider) => throw null;
        int System.IConvertible.ToInt32(System.IFormatProvider provider) => throw null;
        System.Int64 System.IConvertible.ToInt64(System.IFormatProvider provider) => throw null;
        System.SByte System.IConvertible.ToSByte(System.IFormatProvider provider) => throw null;
        float System.IConvertible.ToSingle(System.IFormatProvider provider) => throw null;
        public override string ToString() => throw null;
        public string ToString(System.IFormatProvider provider) => throw null;
        public string ToString(string format) => throw null;
        public string ToString(string format, System.IFormatProvider provider) => throw null;
        object System.IConvertible.ToType(System.Type type, System.IFormatProvider provider) => throw null;
        System.UInt16 System.IConvertible.ToUInt16(System.IFormatProvider provider) => throw null;
        System.UInt32 System.IConvertible.ToUInt32(System.IFormatProvider provider) => throw null;
        System.UInt64 System.IConvertible.ToUInt64(System.IFormatProvider provider) => throw null;
        public bool TryFormat(System.Span<System.Char> destination, out int charsWritten, System.ReadOnlySpan<System.Char> format = default(System.ReadOnlySpan<System.Char>), System.IFormatProvider provider = default(System.IFormatProvider)) => throw null;
        public static bool TryParse(System.ReadOnlySpan<System.Char> s, System.Globalization.NumberStyles style, System.IFormatProvider provider, out System.UInt32 result) => throw null;
        public static bool TryParse(System.ReadOnlySpan<System.Char> s, out System.UInt32 result) => throw null;
        public static bool TryParse(string s, System.Globalization.NumberStyles style, System.IFormatProvider provider, out System.UInt32 result) => throw null;
        public static bool TryParse(string s, out System.UInt32 result) => throw null;
        // Stub generator skipped constructor 
    }

    // Generated from `System.UInt64` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct UInt64 : System.IComparable, System.IComparable<System.UInt64>, System.IConvertible, System.IEquatable<System.UInt64>, System.IFormattable
    {
        public int CompareTo(object value) => throw null;
        public int CompareTo(System.UInt64 value) => throw null;
        public override bool Equals(object obj) => throw null;
        public bool Equals(System.UInt64 obj) => throw null;
        public override int GetHashCode() => throw null;
        public System.TypeCode GetTypeCode() => throw null;
        public const System.UInt64 MaxValue = default;
        public const System.UInt64 MinValue = default;
        public static System.UInt64 Parse(System.ReadOnlySpan<System.Char> s, System.Globalization.NumberStyles style = default(System.Globalization.NumberStyles), System.IFormatProvider provider = default(System.IFormatProvider)) => throw null;
        public static System.UInt64 Parse(string s) => throw null;
        public static System.UInt64 Parse(string s, System.IFormatProvider provider) => throw null;
        public static System.UInt64 Parse(string s, System.Globalization.NumberStyles style) => throw null;
        public static System.UInt64 Parse(string s, System.Globalization.NumberStyles style, System.IFormatProvider provider) => throw null;
        bool System.IConvertible.ToBoolean(System.IFormatProvider provider) => throw null;
        System.Byte System.IConvertible.ToByte(System.IFormatProvider provider) => throw null;
        System.Char System.IConvertible.ToChar(System.IFormatProvider provider) => throw null;
        System.DateTime System.IConvertible.ToDateTime(System.IFormatProvider provider) => throw null;
        System.Decimal System.IConvertible.ToDecimal(System.IFormatProvider provider) => throw null;
        double System.IConvertible.ToDouble(System.IFormatProvider provider) => throw null;
        System.Int16 System.IConvertible.ToInt16(System.IFormatProvider provider) => throw null;
        int System.IConvertible.ToInt32(System.IFormatProvider provider) => throw null;
        System.Int64 System.IConvertible.ToInt64(System.IFormatProvider provider) => throw null;
        System.SByte System.IConvertible.ToSByte(System.IFormatProvider provider) => throw null;
        float System.IConvertible.ToSingle(System.IFormatProvider provider) => throw null;
        public override string ToString() => throw null;
        public string ToString(System.IFormatProvider provider) => throw null;
        public string ToString(string format) => throw null;
        public string ToString(string format, System.IFormatProvider provider) => throw null;
        object System.IConvertible.ToType(System.Type type, System.IFormatProvider provider) => throw null;
        System.UInt16 System.IConvertible.ToUInt16(System.IFormatProvider provider) => throw null;
        System.UInt32 System.IConvertible.ToUInt32(System.IFormatProvider provider) => throw null;
        System.UInt64 System.IConvertible.ToUInt64(System.IFormatProvider provider) => throw null;
        public bool TryFormat(System.Span<System.Char> destination, out int charsWritten, System.ReadOnlySpan<System.Char> format = default(System.ReadOnlySpan<System.Char>), System.IFormatProvider provider = default(System.IFormatProvider)) => throw null;
        public static bool TryParse(System.ReadOnlySpan<System.Char> s, System.Globalization.NumberStyles style, System.IFormatProvider provider, out System.UInt64 result) => throw null;
        public static bool TryParse(System.ReadOnlySpan<System.Char> s, out System.UInt64 result) => throw null;
        public static bool TryParse(string s, System.Globalization.NumberStyles style, System.IFormatProvider provider, out System.UInt64 result) => throw null;
        public static bool TryParse(string s, out System.UInt64 result) => throw null;
        // Stub generator skipped constructor 
    }

    // Generated from `System.UIntPtr` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct UIntPtr : System.IComparable, System.IComparable<System.UIntPtr>, System.IEquatable<System.UIntPtr>, System.IFormattable, System.Runtime.Serialization.ISerializable
    {
        public static bool operator !=(System.UIntPtr value1, System.UIntPtr value2) => throw null;
        public static System.UIntPtr operator +(System.UIntPtr pointer, int offset) => throw null;
        public static System.UIntPtr operator -(System.UIntPtr pointer, int offset) => throw null;
        public static bool operator ==(System.UIntPtr value1, System.UIntPtr value2) => throw null;
        public static System.UIntPtr Add(System.UIntPtr pointer, int offset) => throw null;
        public int CompareTo(System.UIntPtr value) => throw null;
        public int CompareTo(object value) => throw null;
        public bool Equals(System.UIntPtr other) => throw null;
        public override bool Equals(object obj) => throw null;
        public override int GetHashCode() => throw null;
        void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public static System.UIntPtr MaxValue { get => throw null; }
        public static System.UIntPtr MinValue { get => throw null; }
        public static System.UIntPtr Parse(string s) => throw null;
        public static System.UIntPtr Parse(string s, System.IFormatProvider provider) => throw null;
        public static System.UIntPtr Parse(string s, System.Globalization.NumberStyles style) => throw null;
        public static System.UIntPtr Parse(string s, System.Globalization.NumberStyles style, System.IFormatProvider provider) => throw null;
        public static int Size { get => throw null; }
        public static System.UIntPtr Subtract(System.UIntPtr pointer, int offset) => throw null;
        unsafe public void* ToPointer() => throw null;
        public override string ToString() => throw null;
        public string ToString(System.IFormatProvider provider) => throw null;
        public string ToString(string format) => throw null;
        public string ToString(string format, System.IFormatProvider provider) => throw null;
        public System.UInt32 ToUInt32() => throw null;
        public System.UInt64 ToUInt64() => throw null;
        public static bool TryParse(string s, System.Globalization.NumberStyles style, System.IFormatProvider provider, out System.UIntPtr result) => throw null;
        public static bool TryParse(string s, out System.UIntPtr result) => throw null;
        // Stub generator skipped constructor 
        unsafe public UIntPtr(void* value) => throw null;
        public UIntPtr(System.UInt32 value) => throw null;
        public UIntPtr(System.UInt64 value) => throw null;
        public static System.UIntPtr Zero;
        public static explicit operator System.UInt32(System.UIntPtr value) => throw null;
        public static explicit operator System.UInt64(System.UIntPtr value) => throw null;
        unsafe public static explicit operator void*(System.UIntPtr value) => throw null;
        unsafe public static explicit operator System.UIntPtr(void* value) => throw null;
        public static explicit operator System.UIntPtr(System.UInt32 value) => throw null;
        public static explicit operator System.UIntPtr(System.UInt64 value) => throw null;
    }

    // Generated from `System.UnauthorizedAccessException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class UnauthorizedAccessException : System.SystemException
    {
        public UnauthorizedAccessException() => throw null;
        protected UnauthorizedAccessException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public UnauthorizedAccessException(string message) => throw null;
        public UnauthorizedAccessException(string message, System.Exception inner) => throw null;
    }

    // Generated from `System.UnhandledExceptionEventArgs` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class UnhandledExceptionEventArgs : System.EventArgs
    {
        public object ExceptionObject { get => throw null; }
        public bool IsTerminating { get => throw null; }
        public UnhandledExceptionEventArgs(object exception, bool isTerminating) => throw null;
    }

    // Generated from `System.UnhandledExceptionEventHandler` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate void UnhandledExceptionEventHandler(object sender, System.UnhandledExceptionEventArgs e);

    // Generated from `System.Uri` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class Uri : System.Runtime.Serialization.ISerializable
    {
        public static bool operator !=(System.Uri uri1, System.Uri uri2) => throw null;
        public static bool operator ==(System.Uri uri1, System.Uri uri2) => throw null;
        public string AbsolutePath { get => throw null; }
        public string AbsoluteUri { get => throw null; }
        public string Authority { get => throw null; }
        protected virtual void Canonicalize() => throw null;
        public static System.UriHostNameType CheckHostName(string name) => throw null;
        public static bool CheckSchemeName(string schemeName) => throw null;
        protected virtual void CheckSecurity() => throw null;
        public static int Compare(System.Uri uri1, System.Uri uri2, System.UriComponents partsToCompare, System.UriFormat compareFormat, System.StringComparison comparisonType) => throw null;
        public string DnsSafeHost { get => throw null; }
        public override bool Equals(object comparand) => throw null;
        protected virtual void Escape() => throw null;
        public static string EscapeDataString(string stringToEscape) => throw null;
        protected static string EscapeString(string str) => throw null;
        public static string EscapeUriString(string stringToEscape) => throw null;
        public string Fragment { get => throw null; }
        public static int FromHex(System.Char digit) => throw null;
        public string GetComponents(System.UriComponents components, System.UriFormat format) => throw null;
        public override int GetHashCode() => throw null;
        public string GetLeftPart(System.UriPartial part) => throw null;
        protected void GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
        void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
        public static string HexEscape(System.Char character) => throw null;
        public static System.Char HexUnescape(string pattern, ref int index) => throw null;
        public string Host { get => throw null; }
        public System.UriHostNameType HostNameType { get => throw null; }
        public string IdnHost { get => throw null; }
        public bool IsAbsoluteUri { get => throw null; }
        protected virtual bool IsBadFileSystemCharacter(System.Char character) => throw null;
        public bool IsBaseOf(System.Uri uri) => throw null;
        public bool IsDefaultPort { get => throw null; }
        protected static bool IsExcludedCharacter(System.Char character) => throw null;
        public bool IsFile { get => throw null; }
        public static bool IsHexDigit(System.Char character) => throw null;
        public static bool IsHexEncoding(string pattern, int index) => throw null;
        public bool IsLoopback { get => throw null; }
        protected virtual bool IsReservedCharacter(System.Char character) => throw null;
        public bool IsUnc { get => throw null; }
        public bool IsWellFormedOriginalString() => throw null;
        public static bool IsWellFormedUriString(string uriString, System.UriKind uriKind) => throw null;
        public string LocalPath { get => throw null; }
        public string MakeRelative(System.Uri toUri) => throw null;
        public System.Uri MakeRelativeUri(System.Uri uri) => throw null;
        public string OriginalString { get => throw null; }
        protected virtual void Parse() => throw null;
        public string PathAndQuery { get => throw null; }
        public int Port { get => throw null; }
        public string Query { get => throw null; }
        public string Scheme { get => throw null; }
        public static string SchemeDelimiter;
        public string[] Segments { get => throw null; }
        public override string ToString() => throw null;
        public static bool TryCreate(System.Uri baseUri, System.Uri relativeUri, out System.Uri result) => throw null;
        public static bool TryCreate(System.Uri baseUri, string relativeUri, out System.Uri result) => throw null;
        public static bool TryCreate(string uriString, System.UriKind uriKind, out System.Uri result) => throw null;
        protected virtual string Unescape(string path) => throw null;
        public static string UnescapeDataString(string stringToUnescape) => throw null;
        protected Uri(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
        public Uri(System.Uri baseUri, System.Uri relativeUri) => throw null;
        public Uri(System.Uri baseUri, string relativeUri) => throw null;
        public Uri(System.Uri baseUri, string relativeUri, bool dontEscape) => throw null;
        public Uri(string uriString) => throw null;
        public Uri(string uriString, System.UriKind uriKind) => throw null;
        public Uri(string uriString, bool dontEscape) => throw null;
        public static string UriSchemeFile;
        public static string UriSchemeFtp;
        public static string UriSchemeGopher;
        public static string UriSchemeHttp;
        public static string UriSchemeHttps;
        public static string UriSchemeMailto;
        public static string UriSchemeNetPipe;
        public static string UriSchemeNetTcp;
        public static string UriSchemeNews;
        public static string UriSchemeNntp;
        public bool UserEscaped { get => throw null; }
        public string UserInfo { get => throw null; }
    }

    // Generated from `System.UriBuilder` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class UriBuilder
    {
        public override bool Equals(object rparam) => throw null;
        public string Fragment { get => throw null; set => throw null; }
        public override int GetHashCode() => throw null;
        public string Host { get => throw null; set => throw null; }
        public string Password { get => throw null; set => throw null; }
        public string Path { get => throw null; set => throw null; }
        public int Port { get => throw null; set => throw null; }
        public string Query { get => throw null; set => throw null; }
        public string Scheme { get => throw null; set => throw null; }
        public override string ToString() => throw null;
        public System.Uri Uri { get => throw null; }
        public UriBuilder() => throw null;
        public UriBuilder(System.Uri uri) => throw null;
        public UriBuilder(string uri) => throw null;
        public UriBuilder(string schemeName, string hostName) => throw null;
        public UriBuilder(string scheme, string host, int portNumber) => throw null;
        public UriBuilder(string scheme, string host, int port, string pathValue) => throw null;
        public UriBuilder(string scheme, string host, int port, string path, string extraValue) => throw null;
        public string UserName { get => throw null; set => throw null; }
    }

    // Generated from `System.UriComponents` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    [System.Flags]
    public enum UriComponents
    {
        AbsoluteUri,
        Fragment,
        Host,
        HostAndPort,
        HttpRequestUrl,
        KeepDelimiter,
        NormalizedHost,
        Path,
        PathAndQuery,
        Port,
        Query,
        Scheme,
        SchemeAndServer,
        SerializationInfoString,
        StrongAuthority,
        StrongPort,
        UserInfo,
    }

    // Generated from `System.UriFormat` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public enum UriFormat
    {
        SafeUnescaped,
        Unescaped,
        UriEscaped,
    }

    // Generated from `System.UriFormatException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class UriFormatException : System.FormatException, System.Runtime.Serialization.ISerializable
    {
        void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
        public UriFormatException() => throw null;
        protected UriFormatException(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
        public UriFormatException(string textString) => throw null;
        public UriFormatException(string textString, System.Exception e) => throw null;
    }

    // Generated from `System.UriHostNameType` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public enum UriHostNameType
    {
        Basic,
        Dns,
        IPv4,
        IPv6,
        Unknown,
    }

    // Generated from `System.UriKind` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public enum UriKind
    {
        Absolute,
        Relative,
        RelativeOrAbsolute,
    }

    // Generated from `System.UriParser` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public abstract class UriParser
    {
        protected virtual string GetComponents(System.Uri uri, System.UriComponents components, System.UriFormat format) => throw null;
        protected virtual void InitializeAndValidate(System.Uri uri, out System.UriFormatException parsingError) => throw null;
        protected virtual bool IsBaseOf(System.Uri baseUri, System.Uri relativeUri) => throw null;
        public static bool IsKnownScheme(string schemeName) => throw null;
        protected virtual bool IsWellFormedOriginalString(System.Uri uri) => throw null;
        protected virtual System.UriParser OnNewUri() => throw null;
        protected virtual void OnRegister(string schemeName, int defaultPort) => throw null;
        public static void Register(System.UriParser uriParser, string schemeName, int defaultPort) => throw null;
        protected virtual string Resolve(System.Uri baseUri, System.Uri relativeUri, out System.UriFormatException parsingError) => throw null;
        protected UriParser() => throw null;
    }

    // Generated from `System.UriPartial` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public enum UriPartial
    {
        Authority,
        Path,
        Query,
        Scheme,
    }

    // Generated from `System.ValueTuple` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct ValueTuple : System.Collections.IStructuralComparable, System.Collections.IStructuralEquatable, System.IComparable, System.IComparable<System.ValueTuple>, System.IEquatable<System.ValueTuple>, System.Runtime.CompilerServices.ITuple
    {
        public int CompareTo(System.ValueTuple other) => throw null;
        int System.IComparable.CompareTo(object other) => throw null;
        int System.Collections.IStructuralComparable.CompareTo(object other, System.Collections.IComparer comparer) => throw null;
        public static System.ValueTuple Create() => throw null;
        public static (T1, T2, T3, T4, T5, T6, T7, T8) Create<T1, T2, T3, T4, T5, T6, T7, T8>(T1 item1, T2 item2, T3 item3, T4 item4, T5 item5, T6 item6, T7 item7, T8 item8) => throw null;
        public static (T1, T2, T3, T4, T5, T6, T7) Create<T1, T2, T3, T4, T5, T6, T7>(T1 item1, T2 item2, T3 item3, T4 item4, T5 item5, T6 item6, T7 item7) => throw null;
        public static (T1, T2, T3, T4, T5, T6) Create<T1, T2, T3, T4, T5, T6>(T1 item1, T2 item2, T3 item3, T4 item4, T5 item5, T6 item6) => throw null;
        public static (T1, T2, T3, T4, T5) Create<T1, T2, T3, T4, T5>(T1 item1, T2 item2, T3 item3, T4 item4, T5 item5) => throw null;
        public static (T1, T2, T3, T4) Create<T1, T2, T3, T4>(T1 item1, T2 item2, T3 item3, T4 item4) => throw null;
        public static (T1, T2, T3) Create<T1, T2, T3>(T1 item1, T2 item2, T3 item3) => throw null;
        public static (T1, T2) Create<T1, T2>(T1 item1, T2 item2) => throw null;
        public static System.ValueTuple<T1> Create<T1>(T1 item1) => throw null;
        public bool Equals(System.ValueTuple other) => throw null;
        public override bool Equals(object obj) => throw null;
        bool System.Collections.IStructuralEquatable.Equals(object other, System.Collections.IEqualityComparer comparer) => throw null;
        public override int GetHashCode() => throw null;
        int System.Collections.IStructuralEquatable.GetHashCode(System.Collections.IEqualityComparer comparer) => throw null;
        object System.Runtime.CompilerServices.ITuple.this[int index] { get => throw null; }
        int System.Runtime.CompilerServices.ITuple.Length { get => throw null; }
        public override string ToString() => throw null;
        // Stub generator skipped constructor 
    }

    // Generated from `System.ValueTuple<,,,,,,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct ValueTuple<T1, T2, T3, T4, T5, T6, T7, TRest> : System.Collections.IStructuralComparable, System.Collections.IStructuralEquatable, System.IComparable, System.IComparable<System.ValueTuple<T1, T2, T3, T4, T5, T6, T7, TRest>>, System.IEquatable<System.ValueTuple<T1, T2, T3, T4, T5, T6, T7, TRest>>, System.Runtime.CompilerServices.ITuple where TRest : struct
    {
        public int CompareTo(System.ValueTuple<T1, T2, T3, T4, T5, T6, T7, TRest> other) => throw null;
        int System.IComparable.CompareTo(object other) => throw null;
        int System.Collections.IStructuralComparable.CompareTo(object other, System.Collections.IComparer comparer) => throw null;
        public bool Equals(System.ValueTuple<T1, T2, T3, T4, T5, T6, T7, TRest> other) => throw null;
        public override bool Equals(object obj) => throw null;
        bool System.Collections.IStructuralEquatable.Equals(object other, System.Collections.IEqualityComparer comparer) => throw null;
        public override int GetHashCode() => throw null;
        int System.Collections.IStructuralEquatable.GetHashCode(System.Collections.IEqualityComparer comparer) => throw null;
        public T1 Item1;
        public T2 Item2;
        public T3 Item3;
        public T4 Item4;
        public T5 Item5;
        public T6 Item6;
        public T7 Item7;
        object System.Runtime.CompilerServices.ITuple.this[int index] { get => throw null; }
        int System.Runtime.CompilerServices.ITuple.Length { get => throw null; }
        public TRest Rest;
        public override string ToString() => throw null;
        // Stub generator skipped constructor 
        public ValueTuple(T1 item1, T2 item2, T3 item3, T4 item4, T5 item5, T6 item6, T7 item7, TRest rest) => throw null;
    }

    // Generated from `System.ValueTuple<,,,,,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct ValueTuple<T1, T2, T3, T4, T5, T6, T7> : System.Collections.IStructuralComparable, System.Collections.IStructuralEquatable, System.IComparable, System.IComparable<(T1, T2, T3, T4, T5, T6, T7)>, System.IEquatable<(T1, T2, T3, T4, T5, T6, T7)>, System.Runtime.CompilerServices.ITuple
    {
        public int CompareTo((T1, T2, T3, T4, T5, T6, T7) other) => throw null;
        int System.IComparable.CompareTo(object other) => throw null;
        int System.Collections.IStructuralComparable.CompareTo(object other, System.Collections.IComparer comparer) => throw null;
        public bool Equals((T1, T2, T3, T4, T5, T6, T7) other) => throw null;
        public override bool Equals(object obj) => throw null;
        bool System.Collections.IStructuralEquatable.Equals(object other, System.Collections.IEqualityComparer comparer) => throw null;
        public override int GetHashCode() => throw null;
        int System.Collections.IStructuralEquatable.GetHashCode(System.Collections.IEqualityComparer comparer) => throw null;
        public T1 Item1;
        public T2 Item2;
        public T3 Item3;
        public T4 Item4;
        public T5 Item5;
        public T6 Item6;
        public T7 Item7;
        object System.Runtime.CompilerServices.ITuple.this[int index] { get => throw null; }
        int System.Runtime.CompilerServices.ITuple.Length { get => throw null; }
        public override string ToString() => throw null;
        // Stub generator skipped constructor 
        public ValueTuple(T1 item1, T2 item2, T3 item3, T4 item4, T5 item5, T6 item6, T7 item7) => throw null;
    }

    // Generated from `System.ValueTuple<,,,,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct ValueTuple<T1, T2, T3, T4, T5, T6> : System.Collections.IStructuralComparable, System.Collections.IStructuralEquatable, System.IComparable, System.IComparable<(T1, T2, T3, T4, T5, T6)>, System.IEquatable<(T1, T2, T3, T4, T5, T6)>, System.Runtime.CompilerServices.ITuple
    {
        public int CompareTo((T1, T2, T3, T4, T5, T6) other) => throw null;
        int System.IComparable.CompareTo(object other) => throw null;
        int System.Collections.IStructuralComparable.CompareTo(object other, System.Collections.IComparer comparer) => throw null;
        public bool Equals((T1, T2, T3, T4, T5, T6) other) => throw null;
        public override bool Equals(object obj) => throw null;
        bool System.Collections.IStructuralEquatable.Equals(object other, System.Collections.IEqualityComparer comparer) => throw null;
        public override int GetHashCode() => throw null;
        int System.Collections.IStructuralEquatable.GetHashCode(System.Collections.IEqualityComparer comparer) => throw null;
        public T1 Item1;
        public T2 Item2;
        public T3 Item3;
        public T4 Item4;
        public T5 Item5;
        public T6 Item6;
        object System.Runtime.CompilerServices.ITuple.this[int index] { get => throw null; }
        int System.Runtime.CompilerServices.ITuple.Length { get => throw null; }
        public override string ToString() => throw null;
        // Stub generator skipped constructor 
        public ValueTuple(T1 item1, T2 item2, T3 item3, T4 item4, T5 item5, T6 item6) => throw null;
    }

    // Generated from `System.ValueTuple<,,,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct ValueTuple<T1, T2, T3, T4, T5> : System.Collections.IStructuralComparable, System.Collections.IStructuralEquatable, System.IComparable, System.IComparable<(T1, T2, T3, T4, T5)>, System.IEquatable<(T1, T2, T3, T4, T5)>, System.Runtime.CompilerServices.ITuple
    {
        public int CompareTo((T1, T2, T3, T4, T5) other) => throw null;
        int System.IComparable.CompareTo(object other) => throw null;
        int System.Collections.IStructuralComparable.CompareTo(object other, System.Collections.IComparer comparer) => throw null;
        public bool Equals((T1, T2, T3, T4, T5) other) => throw null;
        public override bool Equals(object obj) => throw null;
        bool System.Collections.IStructuralEquatable.Equals(object other, System.Collections.IEqualityComparer comparer) => throw null;
        public override int GetHashCode() => throw null;
        int System.Collections.IStructuralEquatable.GetHashCode(System.Collections.IEqualityComparer comparer) => throw null;
        public T1 Item1;
        public T2 Item2;
        public T3 Item3;
        public T4 Item4;
        public T5 Item5;
        object System.Runtime.CompilerServices.ITuple.this[int index] { get => throw null; }
        int System.Runtime.CompilerServices.ITuple.Length { get => throw null; }
        public override string ToString() => throw null;
        // Stub generator skipped constructor 
        public ValueTuple(T1 item1, T2 item2, T3 item3, T4 item4, T5 item5) => throw null;
    }

    // Generated from `System.ValueTuple<,,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct ValueTuple<T1, T2, T3, T4> : System.Collections.IStructuralComparable, System.Collections.IStructuralEquatable, System.IComparable, System.IComparable<(T1, T2, T3, T4)>, System.IEquatable<(T1, T2, T3, T4)>, System.Runtime.CompilerServices.ITuple
    {
        public int CompareTo((T1, T2, T3, T4) other) => throw null;
        int System.IComparable.CompareTo(object other) => throw null;
        int System.Collections.IStructuralComparable.CompareTo(object other, System.Collections.IComparer comparer) => throw null;
        public bool Equals((T1, T2, T3, T4) other) => throw null;
        public override bool Equals(object obj) => throw null;
        bool System.Collections.IStructuralEquatable.Equals(object other, System.Collections.IEqualityComparer comparer) => throw null;
        public override int GetHashCode() => throw null;
        int System.Collections.IStructuralEquatable.GetHashCode(System.Collections.IEqualityComparer comparer) => throw null;
        public T1 Item1;
        public T2 Item2;
        public T3 Item3;
        public T4 Item4;
        object System.Runtime.CompilerServices.ITuple.this[int index] { get => throw null; }
        int System.Runtime.CompilerServices.ITuple.Length { get => throw null; }
        public override string ToString() => throw null;
        // Stub generator skipped constructor 
        public ValueTuple(T1 item1, T2 item2, T3 item3, T4 item4) => throw null;
    }

    // Generated from `System.ValueTuple<,,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct ValueTuple<T1, T2, T3> : System.Collections.IStructuralComparable, System.Collections.IStructuralEquatable, System.IComparable, System.IComparable<(T1, T2, T3)>, System.IEquatable<(T1, T2, T3)>, System.Runtime.CompilerServices.ITuple
    {
        public int CompareTo((T1, T2, T3) other) => throw null;
        int System.IComparable.CompareTo(object other) => throw null;
        int System.Collections.IStructuralComparable.CompareTo(object other, System.Collections.IComparer comparer) => throw null;
        public bool Equals((T1, T2, T3) other) => throw null;
        public override bool Equals(object obj) => throw null;
        bool System.Collections.IStructuralEquatable.Equals(object other, System.Collections.IEqualityComparer comparer) => throw null;
        public override int GetHashCode() => throw null;
        int System.Collections.IStructuralEquatable.GetHashCode(System.Collections.IEqualityComparer comparer) => throw null;
        public T1 Item1;
        public T2 Item2;
        public T3 Item3;
        object System.Runtime.CompilerServices.ITuple.this[int index] { get => throw null; }
        int System.Runtime.CompilerServices.ITuple.Length { get => throw null; }
        public override string ToString() => throw null;
        // Stub generator skipped constructor 
        public ValueTuple(T1 item1, T2 item2, T3 item3) => throw null;
    }

    // Generated from `System.ValueTuple<,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct ValueTuple<T1, T2> : System.Collections.IStructuralComparable, System.Collections.IStructuralEquatable, System.IComparable, System.IComparable<(T1, T2)>, System.IEquatable<(T1, T2)>, System.Runtime.CompilerServices.ITuple
    {
        public int CompareTo((T1, T2) other) => throw null;
        int System.IComparable.CompareTo(object other) => throw null;
        int System.Collections.IStructuralComparable.CompareTo(object other, System.Collections.IComparer comparer) => throw null;
        public bool Equals((T1, T2) other) => throw null;
        public override bool Equals(object obj) => throw null;
        bool System.Collections.IStructuralEquatable.Equals(object other, System.Collections.IEqualityComparer comparer) => throw null;
        public override int GetHashCode() => throw null;
        int System.Collections.IStructuralEquatable.GetHashCode(System.Collections.IEqualityComparer comparer) => throw null;
        public T1 Item1;
        public T2 Item2;
        object System.Runtime.CompilerServices.ITuple.this[int index] { get => throw null; }
        int System.Runtime.CompilerServices.ITuple.Length { get => throw null; }
        public override string ToString() => throw null;
        // Stub generator skipped constructor 
        public ValueTuple(T1 item1, T2 item2) => throw null;
    }

    // Generated from `System.ValueTuple<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct ValueTuple<T1> : System.Collections.IStructuralComparable, System.Collections.IStructuralEquatable, System.IComparable, System.IComparable<System.ValueTuple<T1>>, System.IEquatable<System.ValueTuple<T1>>, System.Runtime.CompilerServices.ITuple
    {
        public int CompareTo(System.ValueTuple<T1> other) => throw null;
        int System.IComparable.CompareTo(object other) => throw null;
        int System.Collections.IStructuralComparable.CompareTo(object other, System.Collections.IComparer comparer) => throw null;
        public bool Equals(System.ValueTuple<T1> other) => throw null;
        public override bool Equals(object obj) => throw null;
        bool System.Collections.IStructuralEquatable.Equals(object other, System.Collections.IEqualityComparer comparer) => throw null;
        public override int GetHashCode() => throw null;
        int System.Collections.IStructuralEquatable.GetHashCode(System.Collections.IEqualityComparer comparer) => throw null;
        public T1 Item1;
        object System.Runtime.CompilerServices.ITuple.this[int index] { get => throw null; }
        int System.Runtime.CompilerServices.ITuple.Length { get => throw null; }
        public override string ToString() => throw null;
        // Stub generator skipped constructor 
        public ValueTuple(T1 item1) => throw null;
    }

    // Generated from `System.ValueType` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public abstract class ValueType
    {
        public override bool Equals(object obj) => throw null;
        public override int GetHashCode() => throw null;
        public override string ToString() => throw null;
        protected ValueType() => throw null;
    }

    // Generated from `System.Version` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class Version : System.ICloneable, System.IComparable, System.IComparable<System.Version>, System.IEquatable<System.Version>
    {
        public static bool operator !=(System.Version v1, System.Version v2) => throw null;
        public static bool operator <(System.Version v1, System.Version v2) => throw null;
        public static bool operator <=(System.Version v1, System.Version v2) => throw null;
        public static bool operator ==(System.Version v1, System.Version v2) => throw null;
        public static bool operator >(System.Version v1, System.Version v2) => throw null;
        public static bool operator >=(System.Version v1, System.Version v2) => throw null;
        public int Build { get => throw null; }
        public object Clone() => throw null;
        public int CompareTo(System.Version value) => throw null;
        public int CompareTo(object version) => throw null;
        public bool Equals(System.Version obj) => throw null;
        public override bool Equals(object obj) => throw null;
        public override int GetHashCode() => throw null;
        public int Major { get => throw null; }
        public System.Int16 MajorRevision { get => throw null; }
        public int Minor { get => throw null; }
        public System.Int16 MinorRevision { get => throw null; }
        public static System.Version Parse(System.ReadOnlySpan<System.Char> input) => throw null;
        public static System.Version Parse(string input) => throw null;
        public int Revision { get => throw null; }
        public override string ToString() => throw null;
        public string ToString(int fieldCount) => throw null;
        public bool TryFormat(System.Span<System.Char> destination, int fieldCount, out int charsWritten) => throw null;
        public bool TryFormat(System.Span<System.Char> destination, out int charsWritten) => throw null;
        public static bool TryParse(System.ReadOnlySpan<System.Char> input, out System.Version result) => throw null;
        public static bool TryParse(string input, out System.Version result) => throw null;
        public Version() => throw null;
        public Version(int major, int minor) => throw null;
        public Version(int major, int minor, int build) => throw null;
        public Version(int major, int minor, int build, int revision) => throw null;
        public Version(string version) => throw null;
    }

    // Generated from `System.Void` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct Void
    {
    }

    // Generated from `System.WeakReference` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class WeakReference : System.Runtime.Serialization.ISerializable
    {
        public virtual void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public virtual bool IsAlive { get => throw null; }
        public virtual object Target { get => throw null; set => throw null; }
        public virtual bool TrackResurrection { get => throw null; }
        protected WeakReference(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public WeakReference(object target) => throw null;
        public WeakReference(object target, bool trackResurrection) => throw null;
        // ERR: Stub generator didn't handle member: ~WeakReference
    }

    // Generated from `System.WeakReference<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class WeakReference<T> : System.Runtime.Serialization.ISerializable where T : class
    {
        public void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public void SetTarget(T target) => throw null;
        public bool TryGetTarget(out T target) => throw null;
        public WeakReference(T target) => throw null;
        public WeakReference(T target, bool trackResurrection) => throw null;
        // ERR: Stub generator didn't handle member: ~WeakReference
    }

    namespace Buffers
    {
        // Generated from `System.Buffers.ArrayPool<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class ArrayPool<T>
        {
            protected ArrayPool() => throw null;
            public static System.Buffers.ArrayPool<T> Create() => throw null;
            public static System.Buffers.ArrayPool<T> Create(int maxArrayLength, int maxArraysPerBucket) => throw null;
            public abstract T[] Rent(int minimumLength);
            public abstract void Return(T[] array, bool clearArray = default(bool));
            public static System.Buffers.ArrayPool<T> Shared { get => throw null; }
        }

        // Generated from `System.Buffers.IMemoryOwner<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IMemoryOwner<T> : System.IDisposable
        {
            System.Memory<T> Memory { get; }
        }

        // Generated from `System.Buffers.IPinnable` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IPinnable
        {
            System.Buffers.MemoryHandle Pin(int elementIndex);
            void Unpin();
        }

        // Generated from `System.Buffers.MemoryHandle` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public struct MemoryHandle : System.IDisposable
        {
            public void Dispose() => throw null;
            // Stub generator skipped constructor 
            unsafe public MemoryHandle(void* pointer, System.Runtime.InteropServices.GCHandle handle = default(System.Runtime.InteropServices.GCHandle), System.Buffers.IPinnable pinnable = default(System.Buffers.IPinnable)) => throw null;
            unsafe public void* Pointer { get => throw null; }
        }

        // Generated from `System.Buffers.MemoryManager<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class MemoryManager<T> : System.Buffers.IMemoryOwner<T>, System.Buffers.IPinnable, System.IDisposable
        {
            protected System.Memory<T> CreateMemory(int length) => throw null;
            protected System.Memory<T> CreateMemory(int start, int length) => throw null;
            void System.IDisposable.Dispose() => throw null;
            protected abstract void Dispose(bool disposing);
            public abstract System.Span<T> GetSpan();
            public virtual System.Memory<T> Memory { get => throw null; }
            protected MemoryManager() => throw null;
            public abstract System.Buffers.MemoryHandle Pin(int elementIndex = default(int));
            protected internal virtual bool TryGetArray(out System.ArraySegment<T> segment) => throw null;
            public abstract void Unpin();
        }

        // Generated from `System.Buffers.OperationStatus` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum OperationStatus
        {
            DestinationTooSmall,
            Done,
            InvalidData,
            NeedMoreData,
        }

        // Generated from `System.Buffers.ReadOnlySpanAction<,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public delegate void ReadOnlySpanAction<T, TArg>(System.ReadOnlySpan<T> span, TArg arg);

        // Generated from `System.Buffers.SpanAction<,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public delegate void SpanAction<T, TArg>(System.Span<T> span, TArg arg);

    }
    namespace CodeDom
    {
        namespace Compiler
        {
            // Generated from `System.CodeDom.Compiler.GeneratedCodeAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class GeneratedCodeAttribute : System.Attribute
            {
                public GeneratedCodeAttribute(string tool, string version) => throw null;
                public string Tool { get => throw null; }
                public string Version { get => throw null; }
            }

            // Generated from `System.CodeDom.Compiler.IndentedTextWriter` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class IndentedTextWriter : System.IO.TextWriter
            {
                public override void Close() => throw null;
                public const string DefaultTabString = default;
                public override System.Text.Encoding Encoding { get => throw null; }
                public override void Flush() => throw null;
                public int Indent { get => throw null; set => throw null; }
                public IndentedTextWriter(System.IO.TextWriter writer) => throw null;
                public IndentedTextWriter(System.IO.TextWriter writer, string tabString) => throw null;
                public System.IO.TextWriter InnerWriter { get => throw null; }
                public override string NewLine { get => throw null; set => throw null; }
                protected virtual void OutputTabs() => throw null;
                public override void Write(System.Char[] buffer) => throw null;
                public override void Write(System.Char[] buffer, int index, int count) => throw null;
                public override void Write(bool value) => throw null;
                public override void Write(System.Char value) => throw null;
                public override void Write(double value) => throw null;
                public override void Write(float value) => throw null;
                public override void Write(int value) => throw null;
                public override void Write(System.Int64 value) => throw null;
                public override void Write(object value) => throw null;
                public override void Write(string s) => throw null;
                public override void Write(string format, object arg0) => throw null;
                public override void Write(string format, object arg0, object arg1) => throw null;
                public override void Write(string format, params object[] arg) => throw null;
                public override void WriteLine() => throw null;
                public override void WriteLine(System.Char[] buffer) => throw null;
                public override void WriteLine(System.Char[] buffer, int index, int count) => throw null;
                public override void WriteLine(bool value) => throw null;
                public override void WriteLine(System.Char value) => throw null;
                public override void WriteLine(double value) => throw null;
                public override void WriteLine(float value) => throw null;
                public override void WriteLine(int value) => throw null;
                public override void WriteLine(System.Int64 value) => throw null;
                public override void WriteLine(object value) => throw null;
                public override void WriteLine(string s) => throw null;
                public override void WriteLine(string format, object arg0) => throw null;
                public override void WriteLine(string format, object arg0, object arg1) => throw null;
                public override void WriteLine(string format, params object[] arg) => throw null;
                public override void WriteLine(System.UInt32 value) => throw null;
                public void WriteLineNoTabs(string s) => throw null;
            }

        }
    }
    namespace Collections
    {
        // Generated from `System.Collections.ArrayList` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ArrayList : System.Collections.ICollection, System.Collections.IEnumerable, System.Collections.IList, System.ICloneable
        {
            public static System.Collections.ArrayList Adapter(System.Collections.IList list) => throw null;
            public virtual int Add(object value) => throw null;
            public virtual void AddRange(System.Collections.ICollection c) => throw null;
            public ArrayList() => throw null;
            public ArrayList(System.Collections.ICollection c) => throw null;
            public ArrayList(int capacity) => throw null;
            public virtual int BinarySearch(int index, int count, object value, System.Collections.IComparer comparer) => throw null;
            public virtual int BinarySearch(object value) => throw null;
            public virtual int BinarySearch(object value, System.Collections.IComparer comparer) => throw null;
            public virtual int Capacity { get => throw null; set => throw null; }
            public virtual void Clear() => throw null;
            public virtual object Clone() => throw null;
            public virtual bool Contains(object item) => throw null;
            public virtual void CopyTo(System.Array array) => throw null;
            public virtual void CopyTo(System.Array array, int arrayIndex) => throw null;
            public virtual void CopyTo(int index, System.Array array, int arrayIndex, int count) => throw null;
            public virtual int Count { get => throw null; }
            public static System.Collections.ArrayList FixedSize(System.Collections.ArrayList list) => throw null;
            public static System.Collections.IList FixedSize(System.Collections.IList list) => throw null;
            public virtual System.Collections.IEnumerator GetEnumerator() => throw null;
            public virtual System.Collections.IEnumerator GetEnumerator(int index, int count) => throw null;
            public virtual System.Collections.ArrayList GetRange(int index, int count) => throw null;
            public virtual int IndexOf(object value) => throw null;
            public virtual int IndexOf(object value, int startIndex) => throw null;
            public virtual int IndexOf(object value, int startIndex, int count) => throw null;
            public virtual void Insert(int index, object value) => throw null;
            public virtual void InsertRange(int index, System.Collections.ICollection c) => throw null;
            public virtual bool IsFixedSize { get => throw null; }
            public virtual bool IsReadOnly { get => throw null; }
            public virtual bool IsSynchronized { get => throw null; }
            public virtual object this[int index] { get => throw null; set => throw null; }
            public virtual int LastIndexOf(object value) => throw null;
            public virtual int LastIndexOf(object value, int startIndex) => throw null;
            public virtual int LastIndexOf(object value, int startIndex, int count) => throw null;
            public static System.Collections.ArrayList ReadOnly(System.Collections.ArrayList list) => throw null;
            public static System.Collections.IList ReadOnly(System.Collections.IList list) => throw null;
            public virtual void Remove(object obj) => throw null;
            public virtual void RemoveAt(int index) => throw null;
            public virtual void RemoveRange(int index, int count) => throw null;
            public static System.Collections.ArrayList Repeat(object value, int count) => throw null;
            public virtual void Reverse() => throw null;
            public virtual void Reverse(int index, int count) => throw null;
            public virtual void SetRange(int index, System.Collections.ICollection c) => throw null;
            public virtual void Sort() => throw null;
            public virtual void Sort(System.Collections.IComparer comparer) => throw null;
            public virtual void Sort(int index, int count, System.Collections.IComparer comparer) => throw null;
            public virtual object SyncRoot { get => throw null; }
            public static System.Collections.ArrayList Synchronized(System.Collections.ArrayList list) => throw null;
            public static System.Collections.IList Synchronized(System.Collections.IList list) => throw null;
            public virtual object[] ToArray() => throw null;
            public virtual System.Array ToArray(System.Type type) => throw null;
            public virtual void TrimToSize() => throw null;
        }

        // Generated from `System.Collections.Comparer` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class Comparer : System.Collections.IComparer, System.Runtime.Serialization.ISerializable
        {
            public int Compare(object a, object b) => throw null;
            public Comparer(System.Globalization.CultureInfo culture) => throw null;
            public static System.Collections.Comparer Default;
            public static System.Collections.Comparer DefaultInvariant;
            public void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        }

        // Generated from `System.Collections.DictionaryEntry` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public struct DictionaryEntry
        {
            public void Deconstruct(out object key, out object value) => throw null;
            // Stub generator skipped constructor 
            public DictionaryEntry(object key, object value) => throw null;
            public object Key { get => throw null; set => throw null; }
            public object Value { get => throw null; set => throw null; }
        }

        // Generated from `System.Collections.Hashtable` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class Hashtable : System.Collections.ICollection, System.Collections.IDictionary, System.Collections.IEnumerable, System.ICloneable, System.Runtime.Serialization.IDeserializationCallback, System.Runtime.Serialization.ISerializable
        {
            public virtual void Add(object key, object value) => throw null;
            public virtual void Clear() => throw null;
            public virtual object Clone() => throw null;
            public virtual bool Contains(object key) => throw null;
            public virtual bool ContainsKey(object key) => throw null;
            public virtual bool ContainsValue(object value) => throw null;
            public virtual void CopyTo(System.Array array, int arrayIndex) => throw null;
            public virtual int Count { get => throw null; }
            protected System.Collections.IEqualityComparer EqualityComparer { get => throw null; }
            public virtual System.Collections.IDictionaryEnumerator GetEnumerator() => throw null;
            System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            protected virtual int GetHash(object key) => throw null;
            public virtual void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public Hashtable() => throw null;
            public Hashtable(System.Collections.IDictionary d) => throw null;
            public Hashtable(System.Collections.IDictionary d, System.Collections.IEqualityComparer equalityComparer) => throw null;
            public Hashtable(System.Collections.IDictionary d, System.Collections.IHashCodeProvider hcp, System.Collections.IComparer comparer) => throw null;
            public Hashtable(System.Collections.IDictionary d, float loadFactor) => throw null;
            public Hashtable(System.Collections.IDictionary d, float loadFactor, System.Collections.IEqualityComparer equalityComparer) => throw null;
            public Hashtable(System.Collections.IDictionary d, float loadFactor, System.Collections.IHashCodeProvider hcp, System.Collections.IComparer comparer) => throw null;
            public Hashtable(System.Collections.IEqualityComparer equalityComparer) => throw null;
            public Hashtable(System.Collections.IHashCodeProvider hcp, System.Collections.IComparer comparer) => throw null;
            protected Hashtable(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public Hashtable(int capacity) => throw null;
            public Hashtable(int capacity, System.Collections.IEqualityComparer equalityComparer) => throw null;
            public Hashtable(int capacity, System.Collections.IHashCodeProvider hcp, System.Collections.IComparer comparer) => throw null;
            public Hashtable(int capacity, float loadFactor) => throw null;
            public Hashtable(int capacity, float loadFactor, System.Collections.IEqualityComparer equalityComparer) => throw null;
            public Hashtable(int capacity, float loadFactor, System.Collections.IHashCodeProvider hcp, System.Collections.IComparer comparer) => throw null;
            public virtual bool IsFixedSize { get => throw null; }
            public virtual bool IsReadOnly { get => throw null; }
            public virtual bool IsSynchronized { get => throw null; }
            public virtual object this[object key] { get => throw null; set => throw null; }
            protected virtual bool KeyEquals(object item, object key) => throw null;
            public virtual System.Collections.ICollection Keys { get => throw null; }
            public virtual void OnDeserialization(object sender) => throw null;
            public virtual void Remove(object key) => throw null;
            public virtual object SyncRoot { get => throw null; }
            public static System.Collections.Hashtable Synchronized(System.Collections.Hashtable table) => throw null;
            public virtual System.Collections.ICollection Values { get => throw null; }
            protected System.Collections.IComparer comparer { get => throw null; set => throw null; }
            protected System.Collections.IHashCodeProvider hcp { get => throw null; set => throw null; }
        }

        // Generated from `System.Collections.ICollection` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface ICollection : System.Collections.IEnumerable
        {
            void CopyTo(System.Array array, int index);
            int Count { get; }
            bool IsSynchronized { get; }
            object SyncRoot { get; }
        }

        // Generated from `System.Collections.IComparer` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IComparer
        {
            int Compare(object x, object y);
        }

        // Generated from `System.Collections.IDictionary` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IDictionary : System.Collections.ICollection, System.Collections.IEnumerable
        {
            void Add(object key, object value);
            void Clear();
            bool Contains(object key);
            System.Collections.IDictionaryEnumerator GetEnumerator();
            bool IsFixedSize { get; }
            bool IsReadOnly { get; }
            object this[object key] { get; set; }
            System.Collections.ICollection Keys { get; }
            void Remove(object key);
            System.Collections.ICollection Values { get; }
        }

        // Generated from `System.Collections.IDictionaryEnumerator` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IDictionaryEnumerator : System.Collections.IEnumerator
        {
            System.Collections.DictionaryEntry Entry { get; }
            object Key { get; }
            object Value { get; }
        }

        // Generated from `System.Collections.IEnumerable` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IEnumerable
        {
            System.Collections.IEnumerator GetEnumerator();
        }

        // Generated from `System.Collections.IEnumerator` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IEnumerator
        {
            object Current { get; }
            bool MoveNext();
            void Reset();
        }

        // Generated from `System.Collections.IEqualityComparer` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IEqualityComparer
        {
            bool Equals(object x, object y);
            int GetHashCode(object obj);
        }

        // Generated from `System.Collections.IHashCodeProvider` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IHashCodeProvider
        {
            int GetHashCode(object obj);
        }

        // Generated from `System.Collections.IList` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IList : System.Collections.ICollection, System.Collections.IEnumerable
        {
            int Add(object value);
            void Clear();
            bool Contains(object value);
            int IndexOf(object value);
            void Insert(int index, object value);
            bool IsFixedSize { get; }
            bool IsReadOnly { get; }
            object this[int index] { get; set; }
            void Remove(object value);
            void RemoveAt(int index);
        }

        // Generated from `System.Collections.IStructuralComparable` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IStructuralComparable
        {
            int CompareTo(object other, System.Collections.IComparer comparer);
        }

        // Generated from `System.Collections.IStructuralEquatable` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IStructuralEquatable
        {
            bool Equals(object other, System.Collections.IEqualityComparer comparer);
            int GetHashCode(System.Collections.IEqualityComparer comparer);
        }

        namespace Generic
        {
            // Generated from `System.Collections.Generic.IAsyncEnumerable<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IAsyncEnumerable<T>
            {
                System.Collections.Generic.IAsyncEnumerator<T> GetAsyncEnumerator(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
            }

            // Generated from `System.Collections.Generic.IAsyncEnumerator<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IAsyncEnumerator<T> : System.IAsyncDisposable
            {
                T Current { get; }
                System.Threading.Tasks.ValueTask<bool> MoveNextAsync();
            }

            // Generated from `System.Collections.Generic.ICollection<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface ICollection<T> : System.Collections.Generic.IEnumerable<T>, System.Collections.IEnumerable
            {
                void Add(T item);
                void Clear();
                bool Contains(T item);
                void CopyTo(T[] array, int arrayIndex);
                int Count { get; }
                bool IsReadOnly { get; }
                bool Remove(T item);
            }

            // Generated from `System.Collections.Generic.IComparer<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IComparer<T>
            {
                int Compare(T x, T y);
            }

            // Generated from `System.Collections.Generic.IDictionary<,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IDictionary<TKey, TValue> : System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey, TValue>>, System.Collections.IEnumerable
            {
                void Add(TKey key, TValue value);
                bool ContainsKey(TKey key);
                TValue this[TKey key] { get; set; }
                System.Collections.Generic.ICollection<TKey> Keys { get; }
                bool Remove(TKey key);
                bool TryGetValue(TKey key, out TValue value);
                System.Collections.Generic.ICollection<TValue> Values { get; }
            }

            // Generated from `System.Collections.Generic.IEnumerable<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IEnumerable<T> : System.Collections.IEnumerable
            {
                System.Collections.Generic.IEnumerator<T> GetEnumerator();
            }

            // Generated from `System.Collections.Generic.IEnumerator<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IEnumerator<T> : System.Collections.IEnumerator, System.IDisposable
            {
                T Current { get; }
            }

            // Generated from `System.Collections.Generic.IEqualityComparer<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IEqualityComparer<T>
            {
                bool Equals(T x, T y);
                int GetHashCode(T obj);
            }

            // Generated from `System.Collections.Generic.IList<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IList<T> : System.Collections.Generic.ICollection<T>, System.Collections.Generic.IEnumerable<T>, System.Collections.IEnumerable
            {
                int IndexOf(T item);
                void Insert(int index, T item);
                T this[int index] { get; set; }
                void RemoveAt(int index);
            }

            // Generated from `System.Collections.Generic.IReadOnlyCollection<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IReadOnlyCollection<T> : System.Collections.Generic.IEnumerable<T>, System.Collections.IEnumerable
            {
                int Count { get; }
            }

            // Generated from `System.Collections.Generic.IReadOnlyDictionary<,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IReadOnlyDictionary<TKey, TValue> : System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey, TValue>>, System.Collections.Generic.IReadOnlyCollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>, System.Collections.IEnumerable
            {
                bool ContainsKey(TKey key);
                TValue this[TKey key] { get; }
                System.Collections.Generic.IEnumerable<TKey> Keys { get; }
                bool TryGetValue(TKey key, out TValue value);
                System.Collections.Generic.IEnumerable<TValue> Values { get; }
            }

            // Generated from `System.Collections.Generic.IReadOnlyList<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IReadOnlyList<T> : System.Collections.Generic.IEnumerable<T>, System.Collections.Generic.IReadOnlyCollection<T>, System.Collections.IEnumerable
            {
                T this[int index] { get; }
            }

            // Generated from `System.Collections.Generic.IReadOnlySet<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IReadOnlySet<T> : System.Collections.Generic.IEnumerable<T>, System.Collections.Generic.IReadOnlyCollection<T>, System.Collections.IEnumerable
            {
                bool Contains(T item);
                bool IsProperSubsetOf(System.Collections.Generic.IEnumerable<T> other);
                bool IsProperSupersetOf(System.Collections.Generic.IEnumerable<T> other);
                bool IsSubsetOf(System.Collections.Generic.IEnumerable<T> other);
                bool IsSupersetOf(System.Collections.Generic.IEnumerable<T> other);
                bool Overlaps(System.Collections.Generic.IEnumerable<T> other);
                bool SetEquals(System.Collections.Generic.IEnumerable<T> other);
            }

            // Generated from `System.Collections.Generic.ISet<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface ISet<T> : System.Collections.Generic.ICollection<T>, System.Collections.Generic.IEnumerable<T>, System.Collections.IEnumerable
            {
                bool Add(T item);
                void ExceptWith(System.Collections.Generic.IEnumerable<T> other);
                void IntersectWith(System.Collections.Generic.IEnumerable<T> other);
                bool IsProperSubsetOf(System.Collections.Generic.IEnumerable<T> other);
                bool IsProperSupersetOf(System.Collections.Generic.IEnumerable<T> other);
                bool IsSubsetOf(System.Collections.Generic.IEnumerable<T> other);
                bool IsSupersetOf(System.Collections.Generic.IEnumerable<T> other);
                bool Overlaps(System.Collections.Generic.IEnumerable<T> other);
                bool SetEquals(System.Collections.Generic.IEnumerable<T> other);
                void SymmetricExceptWith(System.Collections.Generic.IEnumerable<T> other);
                void UnionWith(System.Collections.Generic.IEnumerable<T> other);
            }

            // Generated from `System.Collections.Generic.KeyNotFoundException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class KeyNotFoundException : System.SystemException
            {
                public KeyNotFoundException() => throw null;
                protected KeyNotFoundException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public KeyNotFoundException(string message) => throw null;
                public KeyNotFoundException(string message, System.Exception innerException) => throw null;
            }

            // Generated from `System.Collections.Generic.KeyValuePair` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class KeyValuePair
            {
                public static System.Collections.Generic.KeyValuePair<TKey, TValue> Create<TKey, TValue>(TKey key, TValue value) => throw null;
            }

            // Generated from `System.Collections.Generic.KeyValuePair<,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct KeyValuePair<TKey, TValue>
            {
                public void Deconstruct(out TKey key, out TValue value) => throw null;
                public TKey Key { get => throw null; }
                // Stub generator skipped constructor 
                public KeyValuePair(TKey key, TValue value) => throw null;
                public override string ToString() => throw null;
                public TValue Value { get => throw null; }
            }

        }
        namespace ObjectModel
        {
            // Generated from `System.Collections.ObjectModel.Collection<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class Collection<T> : System.Collections.Generic.ICollection<T>, System.Collections.Generic.IEnumerable<T>, System.Collections.Generic.IList<T>, System.Collections.Generic.IReadOnlyCollection<T>, System.Collections.Generic.IReadOnlyList<T>, System.Collections.ICollection, System.Collections.IEnumerable, System.Collections.IList
            {
                public void Add(T item) => throw null;
                int System.Collections.IList.Add(object value) => throw null;
                public void Clear() => throw null;
                protected virtual void ClearItems() => throw null;
                public Collection() => throw null;
                public Collection(System.Collections.Generic.IList<T> list) => throw null;
                public bool Contains(T item) => throw null;
                bool System.Collections.IList.Contains(object value) => throw null;
                void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                public void CopyTo(T[] array, int index) => throw null;
                public int Count { get => throw null; }
                public System.Collections.Generic.IEnumerator<T> GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public int IndexOf(T item) => throw null;
                int System.Collections.IList.IndexOf(object value) => throw null;
                public void Insert(int index, T item) => throw null;
                void System.Collections.IList.Insert(int index, object value) => throw null;
                protected virtual void InsertItem(int index, T item) => throw null;
                bool System.Collections.IList.IsFixedSize { get => throw null; }
                bool System.Collections.Generic.ICollection<T>.IsReadOnly { get => throw null; }
                bool System.Collections.IList.IsReadOnly { get => throw null; }
                bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                public T this[int index] { get => throw null; set => throw null; }
                object System.Collections.IList.this[int index] { get => throw null; set => throw null; }
                protected System.Collections.Generic.IList<T> Items { get => throw null; }
                public bool Remove(T item) => throw null;
                void System.Collections.IList.Remove(object value) => throw null;
                public void RemoveAt(int index) => throw null;
                protected virtual void RemoveItem(int index) => throw null;
                protected virtual void SetItem(int index, T item) => throw null;
                object System.Collections.ICollection.SyncRoot { get => throw null; }
            }

            // Generated from `System.Collections.ObjectModel.ReadOnlyCollection<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ReadOnlyCollection<T> : System.Collections.Generic.ICollection<T>, System.Collections.Generic.IEnumerable<T>, System.Collections.Generic.IList<T>, System.Collections.Generic.IReadOnlyCollection<T>, System.Collections.Generic.IReadOnlyList<T>, System.Collections.ICollection, System.Collections.IEnumerable, System.Collections.IList
            {
                void System.Collections.Generic.ICollection<T>.Add(T value) => throw null;
                int System.Collections.IList.Add(object value) => throw null;
                void System.Collections.Generic.ICollection<T>.Clear() => throw null;
                void System.Collections.IList.Clear() => throw null;
                public bool Contains(T value) => throw null;
                bool System.Collections.IList.Contains(object value) => throw null;
                void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                public void CopyTo(T[] array, int index) => throw null;
                public int Count { get => throw null; }
                public System.Collections.Generic.IEnumerator<T> GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public int IndexOf(T value) => throw null;
                int System.Collections.IList.IndexOf(object value) => throw null;
                void System.Collections.Generic.IList<T>.Insert(int index, T value) => throw null;
                void System.Collections.IList.Insert(int index, object value) => throw null;
                bool System.Collections.IList.IsFixedSize { get => throw null; }
                bool System.Collections.Generic.ICollection<T>.IsReadOnly { get => throw null; }
                bool System.Collections.IList.IsReadOnly { get => throw null; }
                bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                public T this[int index] { get => throw null; }
                T System.Collections.Generic.IList<T>.this[int index] { get => throw null; set => throw null; }
                object System.Collections.IList.this[int index] { get => throw null; set => throw null; }
                protected System.Collections.Generic.IList<T> Items { get => throw null; }
                public ReadOnlyCollection(System.Collections.Generic.IList<T> list) => throw null;
                bool System.Collections.Generic.ICollection<T>.Remove(T value) => throw null;
                void System.Collections.IList.Remove(object value) => throw null;
                void System.Collections.Generic.IList<T>.RemoveAt(int index) => throw null;
                void System.Collections.IList.RemoveAt(int index) => throw null;
                object System.Collections.ICollection.SyncRoot { get => throw null; }
            }

        }
    }
    namespace ComponentModel
    {
        // Generated from `System.ComponentModel.DefaultValueAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DefaultValueAttribute : System.Attribute
        {
            public DefaultValueAttribute(System.Type type, string value) => throw null;
            public DefaultValueAttribute(bool value) => throw null;
            public DefaultValueAttribute(System.Byte value) => throw null;
            public DefaultValueAttribute(System.Char value) => throw null;
            public DefaultValueAttribute(double value) => throw null;
            public DefaultValueAttribute(float value) => throw null;
            public DefaultValueAttribute(int value) => throw null;
            public DefaultValueAttribute(System.Int64 value) => throw null;
            public DefaultValueAttribute(object value) => throw null;
            public DefaultValueAttribute(System.SByte value) => throw null;
            public DefaultValueAttribute(System.Int16 value) => throw null;
            public DefaultValueAttribute(string value) => throw null;
            public DefaultValueAttribute(System.UInt32 value) => throw null;
            public DefaultValueAttribute(System.UInt64 value) => throw null;
            public DefaultValueAttribute(System.UInt16 value) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            protected void SetValue(object value) => throw null;
            public virtual object Value { get => throw null; }
        }

        // Generated from `System.ComponentModel.EditorBrowsableAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class EditorBrowsableAttribute : System.Attribute
        {
            public EditorBrowsableAttribute() => throw null;
            public EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState state) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public System.ComponentModel.EditorBrowsableState State { get => throw null; }
        }

        // Generated from `System.ComponentModel.EditorBrowsableState` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum EditorBrowsableState
        {
            Advanced,
            Always,
            Never,
        }

    }
    namespace Configuration
    {
        namespace Assemblies
        {
            // Generated from `System.Configuration.Assemblies.AssemblyHashAlgorithm` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum AssemblyHashAlgorithm
            {
                MD5,
                None,
                SHA1,
                SHA256,
                SHA384,
                SHA512,
            }

            // Generated from `System.Configuration.Assemblies.AssemblyVersionCompatibility` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum AssemblyVersionCompatibility
            {
                SameDomain,
                SameMachine,
                SameProcess,
            }

        }
    }
    namespace Diagnostics
    {
        // Generated from `System.Diagnostics.ConditionalAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ConditionalAttribute : System.Attribute
        {
            public string ConditionString { get => throw null; }
            public ConditionalAttribute(string conditionString) => throw null;
        }

        // Generated from `System.Diagnostics.Debug` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public static class Debug
        {
            public static void Assert(bool condition) => throw null;
            public static void Assert(bool condition, string message) => throw null;
            public static void Assert(bool condition, string message, string detailMessage) => throw null;
            public static void Assert(bool condition, string message, string detailMessageFormat, params object[] args) => throw null;
            public static bool AutoFlush { get => throw null; set => throw null; }
            public static void Close() => throw null;
            public static void Fail(string message) => throw null;
            public static void Fail(string message, string detailMessage) => throw null;
            public static void Flush() => throw null;
            public static void Indent() => throw null;
            public static int IndentLevel { get => throw null; set => throw null; }
            public static int IndentSize { get => throw null; set => throw null; }
            public static void Print(string message) => throw null;
            public static void Print(string format, params object[] args) => throw null;
            public static void Unindent() => throw null;
            public static void Write(object value) => throw null;
            public static void Write(object value, string category) => throw null;
            public static void Write(string message) => throw null;
            public static void Write(string message, string category) => throw null;
            public static void WriteIf(bool condition, object value) => throw null;
            public static void WriteIf(bool condition, object value, string category) => throw null;
            public static void WriteIf(bool condition, string message) => throw null;
            public static void WriteIf(bool condition, string message, string category) => throw null;
            public static void WriteLine(object value) => throw null;
            public static void WriteLine(object value, string category) => throw null;
            public static void WriteLine(string message) => throw null;
            public static void WriteLine(string format, params object[] args) => throw null;
            public static void WriteLine(string message, string category) => throw null;
            public static void WriteLineIf(bool condition, object value) => throw null;
            public static void WriteLineIf(bool condition, object value, string category) => throw null;
            public static void WriteLineIf(bool condition, string message) => throw null;
            public static void WriteLineIf(bool condition, string message, string category) => throw null;
        }

        // Generated from `System.Diagnostics.DebuggableAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DebuggableAttribute : System.Attribute
        {
            // Generated from `System.Diagnostics.DebuggableAttribute+DebuggingModes` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum DebuggingModes
            {
                Default,
                DisableOptimizations,
                EnableEditAndContinue,
                IgnoreSymbolStoreSequencePoints,
                None,
            }


            public DebuggableAttribute(System.Diagnostics.DebuggableAttribute.DebuggingModes modes) => throw null;
            public DebuggableAttribute(bool isJITTrackingEnabled, bool isJITOptimizerDisabled) => throw null;
            public System.Diagnostics.DebuggableAttribute.DebuggingModes DebuggingFlags { get => throw null; }
            public bool IsJITOptimizerDisabled { get => throw null; }
            public bool IsJITTrackingEnabled { get => throw null; }
        }

        // Generated from `System.Diagnostics.Debugger` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public static class Debugger
        {
            public static void Break() => throw null;
            public static string DefaultCategory;
            public static bool IsAttached { get => throw null; }
            public static bool IsLogging() => throw null;
            public static bool Launch() => throw null;
            public static void Log(int level, string category, string message) => throw null;
            public static void NotifyOfCrossThreadDependency() => throw null;
        }

        // Generated from `System.Diagnostics.DebuggerBrowsableAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DebuggerBrowsableAttribute : System.Attribute
        {
            public DebuggerBrowsableAttribute(System.Diagnostics.DebuggerBrowsableState state) => throw null;
            public System.Diagnostics.DebuggerBrowsableState State { get => throw null; }
        }

        // Generated from `System.Diagnostics.DebuggerBrowsableState` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum DebuggerBrowsableState
        {
            Collapsed,
            Never,
            RootHidden,
        }

        // Generated from `System.Diagnostics.DebuggerDisplayAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DebuggerDisplayAttribute : System.Attribute
        {
            public DebuggerDisplayAttribute(string value) => throw null;
            public string Name { get => throw null; set => throw null; }
            public System.Type Target { get => throw null; set => throw null; }
            public string TargetTypeName { get => throw null; set => throw null; }
            public string Type { get => throw null; set => throw null; }
            public string Value { get => throw null; }
        }

        // Generated from `System.Diagnostics.DebuggerHiddenAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DebuggerHiddenAttribute : System.Attribute
        {
            public DebuggerHiddenAttribute() => throw null;
        }

        // Generated from `System.Diagnostics.DebuggerNonUserCodeAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DebuggerNonUserCodeAttribute : System.Attribute
        {
            public DebuggerNonUserCodeAttribute() => throw null;
        }

        // Generated from `System.Diagnostics.DebuggerStepThroughAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DebuggerStepThroughAttribute : System.Attribute
        {
            public DebuggerStepThroughAttribute() => throw null;
        }

        // Generated from `System.Diagnostics.DebuggerStepperBoundaryAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DebuggerStepperBoundaryAttribute : System.Attribute
        {
            public DebuggerStepperBoundaryAttribute() => throw null;
        }

        // Generated from `System.Diagnostics.DebuggerTypeProxyAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DebuggerTypeProxyAttribute : System.Attribute
        {
            public DebuggerTypeProxyAttribute(System.Type type) => throw null;
            public DebuggerTypeProxyAttribute(string typeName) => throw null;
            public string ProxyTypeName { get => throw null; }
            public System.Type Target { get => throw null; set => throw null; }
            public string TargetTypeName { get => throw null; set => throw null; }
        }

        // Generated from `System.Diagnostics.DebuggerVisualizerAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DebuggerVisualizerAttribute : System.Attribute
        {
            public DebuggerVisualizerAttribute(System.Type visualizer) => throw null;
            public DebuggerVisualizerAttribute(System.Type visualizer, System.Type visualizerObjectSource) => throw null;
            public DebuggerVisualizerAttribute(System.Type visualizer, string visualizerObjectSourceTypeName) => throw null;
            public DebuggerVisualizerAttribute(string visualizerTypeName) => throw null;
            public DebuggerVisualizerAttribute(string visualizerTypeName, System.Type visualizerObjectSource) => throw null;
            public DebuggerVisualizerAttribute(string visualizerTypeName, string visualizerObjectSourceTypeName) => throw null;
            public string Description { get => throw null; set => throw null; }
            public System.Type Target { get => throw null; set => throw null; }
            public string TargetTypeName { get => throw null; set => throw null; }
            public string VisualizerObjectSourceTypeName { get => throw null; }
            public string VisualizerTypeName { get => throw null; }
        }

        // Generated from `System.Diagnostics.Stopwatch` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class Stopwatch
        {
            public System.TimeSpan Elapsed { get => throw null; }
            public System.Int64 ElapsedMilliseconds { get => throw null; }
            public System.Int64 ElapsedTicks { get => throw null; }
            public static System.Int64 Frequency;
            public static System.Int64 GetTimestamp() => throw null;
            public static bool IsHighResolution;
            public bool IsRunning { get => throw null; }
            public void Reset() => throw null;
            public void Restart() => throw null;
            public void Start() => throw null;
            public static System.Diagnostics.Stopwatch StartNew() => throw null;
            public void Stop() => throw null;
            public Stopwatch() => throw null;
        }

        namespace CodeAnalysis
        {
            // Generated from `System.Diagnostics.CodeAnalysis.AllowNullAttribute` in `System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51; System.Formats.Asn1, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51; System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a; System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public partial class AllowNullAttribute : System.Attribute
            {
                public AllowNullAttribute() => throw null;
            }

            // Generated from `System.Diagnostics.CodeAnalysis.DisallowNullAttribute` in `System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51; System.Formats.Asn1, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51; System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a; System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public partial class DisallowNullAttribute : System.Attribute
            {
                public DisallowNullAttribute() => throw null;
            }

            // Generated from `System.Diagnostics.CodeAnalysis.DoesNotReturnAttribute` in `System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51; System.Formats.Asn1, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51; System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a; System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public partial class DoesNotReturnAttribute : System.Attribute
            {
                public DoesNotReturnAttribute() => throw null;
            }

            // Generated from `System.Diagnostics.CodeAnalysis.DoesNotReturnIfAttribute` in `System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51; System.Formats.Asn1, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51; System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a; System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public partial class DoesNotReturnIfAttribute : System.Attribute
            {
                public DoesNotReturnIfAttribute(bool parameterValue) => throw null;
                public bool ParameterValue { get => throw null; }
            }

            // Generated from `System.Diagnostics.CodeAnalysis.DynamicDependencyAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DynamicDependencyAttribute : System.Attribute
            {
                public string AssemblyName { get => throw null; }
                public string Condition { get => throw null; set => throw null; }
                public DynamicDependencyAttribute(System.Diagnostics.CodeAnalysis.DynamicallyAccessedMemberTypes memberTypes, System.Type type) => throw null;
                public DynamicDependencyAttribute(System.Diagnostics.CodeAnalysis.DynamicallyAccessedMemberTypes memberTypes, string typeName, string assemblyName) => throw null;
                public DynamicDependencyAttribute(string memberSignature) => throw null;
                public DynamicDependencyAttribute(string memberSignature, System.Type type) => throw null;
                public DynamicDependencyAttribute(string memberSignature, string typeName, string assemblyName) => throw null;
                public string MemberSignature { get => throw null; }
                public System.Diagnostics.CodeAnalysis.DynamicallyAccessedMemberTypes MemberTypes { get => throw null; }
                public System.Type Type { get => throw null; }
                public string TypeName { get => throw null; }
            }

            // Generated from `System.Diagnostics.CodeAnalysis.DynamicallyAccessedMemberTypes` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum DynamicallyAccessedMemberTypes
            {
                All,
                NonPublicConstructors,
                NonPublicEvents,
                NonPublicFields,
                NonPublicMethods,
                NonPublicNestedTypes,
                NonPublicProperties,
                None,
                PublicConstructors,
                PublicEvents,
                PublicFields,
                PublicMethods,
                PublicNestedTypes,
                PublicParameterlessConstructor,
                PublicProperties,
            }

            // Generated from `System.Diagnostics.CodeAnalysis.DynamicallyAccessedMembersAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DynamicallyAccessedMembersAttribute : System.Attribute
            {
                public DynamicallyAccessedMembersAttribute(System.Diagnostics.CodeAnalysis.DynamicallyAccessedMemberTypes memberTypes) => throw null;
                public System.Diagnostics.CodeAnalysis.DynamicallyAccessedMemberTypes MemberTypes { get => throw null; }
            }

            // Generated from `System.Diagnostics.CodeAnalysis.ExcludeFromCodeCoverageAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ExcludeFromCodeCoverageAttribute : System.Attribute
            {
                public ExcludeFromCodeCoverageAttribute() => throw null;
                public string Justification { get => throw null; set => throw null; }
            }

            // Generated from `System.Diagnostics.CodeAnalysis.MaybeNullAttribute` in `System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51; System.Formats.Asn1, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51; System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a; System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public partial class MaybeNullAttribute : System.Attribute
            {
                public MaybeNullAttribute() => throw null;
            }

            // Generated from `System.Diagnostics.CodeAnalysis.MaybeNullWhenAttribute` in `System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51; System.Formats.Asn1, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51; System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a; System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public partial class MaybeNullWhenAttribute : System.Attribute
            {
                public MaybeNullWhenAttribute(bool returnValue) => throw null;
                public bool ReturnValue { get => throw null; }
            }

            // Generated from `System.Diagnostics.CodeAnalysis.MemberNotNullAttribute` in `System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51; System.Formats.Asn1, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51; System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a; System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public partial class MemberNotNullAttribute : System.Attribute
            {
                public MemberNotNullAttribute(params string[] members) => throw null;
                public MemberNotNullAttribute(string member) => throw null;
                public string[] Members { get => throw null; }
            }

            // Generated from `System.Diagnostics.CodeAnalysis.MemberNotNullWhenAttribute` in `System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51; System.Formats.Asn1, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51; System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a; System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public partial class MemberNotNullWhenAttribute : System.Attribute
            {
                public MemberNotNullWhenAttribute(bool returnValue, params string[] members) => throw null;
                public MemberNotNullWhenAttribute(bool returnValue, string member) => throw null;
                public string[] Members { get => throw null; }
                public bool ReturnValue { get => throw null; }
            }

            // Generated from `System.Diagnostics.CodeAnalysis.NotNullAttribute` in `System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51; System.Formats.Asn1, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51; System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a; System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public partial class NotNullAttribute : System.Attribute
            {
                public NotNullAttribute() => throw null;
            }

            // Generated from `System.Diagnostics.CodeAnalysis.NotNullIfNotNullAttribute` in `System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51; System.Formats.Asn1, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51; System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a; System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public partial class NotNullIfNotNullAttribute : System.Attribute
            {
                public NotNullIfNotNullAttribute(string parameterName) => throw null;
                public string ParameterName { get => throw null; }
            }

            // Generated from `System.Diagnostics.CodeAnalysis.NotNullWhenAttribute` in `System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51; System.Formats.Asn1, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51; System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a; System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public partial class NotNullWhenAttribute : System.Attribute
            {
                public NotNullWhenAttribute(bool returnValue) => throw null;
                public bool ReturnValue { get => throw null; }
            }

            // Generated from `System.Diagnostics.CodeAnalysis.RequiresUnreferencedCodeAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class RequiresUnreferencedCodeAttribute : System.Attribute
            {
                public string Message { get => throw null; }
                public RequiresUnreferencedCodeAttribute(string message) => throw null;
                public string Url { get => throw null; set => throw null; }
            }

            // Generated from `System.Diagnostics.CodeAnalysis.SuppressMessageAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SuppressMessageAttribute : System.Attribute
            {
                public string Category { get => throw null; }
                public string CheckId { get => throw null; }
                public string Justification { get => throw null; set => throw null; }
                public string MessageId { get => throw null; set => throw null; }
                public string Scope { get => throw null; set => throw null; }
                public SuppressMessageAttribute(string category, string checkId) => throw null;
                public string Target { get => throw null; set => throw null; }
            }

            // Generated from `System.Diagnostics.CodeAnalysis.UnconditionalSuppressMessageAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class UnconditionalSuppressMessageAttribute : System.Attribute
            {
                public string Category { get => throw null; }
                public string CheckId { get => throw null; }
                public string Justification { get => throw null; set => throw null; }
                public string MessageId { get => throw null; set => throw null; }
                public string Scope { get => throw null; set => throw null; }
                public string Target { get => throw null; set => throw null; }
                public UnconditionalSuppressMessageAttribute(string category, string checkId) => throw null;
            }

        }
    }
    namespace Globalization
    {
        // Generated from `System.Globalization.Calendar` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class Calendar : System.ICloneable
        {
            public virtual System.DateTime AddDays(System.DateTime time, int days) => throw null;
            public virtual System.DateTime AddHours(System.DateTime time, int hours) => throw null;
            public virtual System.DateTime AddMilliseconds(System.DateTime time, double milliseconds) => throw null;
            public virtual System.DateTime AddMinutes(System.DateTime time, int minutes) => throw null;
            public abstract System.DateTime AddMonths(System.DateTime time, int months);
            public virtual System.DateTime AddSeconds(System.DateTime time, int seconds) => throw null;
            public virtual System.DateTime AddWeeks(System.DateTime time, int weeks) => throw null;
            public abstract System.DateTime AddYears(System.DateTime time, int years);
            public virtual System.Globalization.CalendarAlgorithmType AlgorithmType { get => throw null; }
            protected Calendar() => throw null;
            public virtual object Clone() => throw null;
            public const int CurrentEra = default;
            protected virtual int DaysInYearBeforeMinSupportedYear { get => throw null; }
            public abstract int[] Eras { get; }
            public abstract int GetDayOfMonth(System.DateTime time);
            public abstract System.DayOfWeek GetDayOfWeek(System.DateTime time);
            public abstract int GetDayOfYear(System.DateTime time);
            public virtual int GetDaysInMonth(int year, int month) => throw null;
            public abstract int GetDaysInMonth(int year, int month, int era);
            public virtual int GetDaysInYear(int year) => throw null;
            public abstract int GetDaysInYear(int year, int era);
            public abstract int GetEra(System.DateTime time);
            public virtual int GetHour(System.DateTime time) => throw null;
            public virtual int GetLeapMonth(int year) => throw null;
            public virtual int GetLeapMonth(int year, int era) => throw null;
            public virtual double GetMilliseconds(System.DateTime time) => throw null;
            public virtual int GetMinute(System.DateTime time) => throw null;
            public abstract int GetMonth(System.DateTime time);
            public virtual int GetMonthsInYear(int year) => throw null;
            public abstract int GetMonthsInYear(int year, int era);
            public virtual int GetSecond(System.DateTime time) => throw null;
            public virtual int GetWeekOfYear(System.DateTime time, System.Globalization.CalendarWeekRule rule, System.DayOfWeek firstDayOfWeek) => throw null;
            public abstract int GetYear(System.DateTime time);
            public virtual bool IsLeapDay(int year, int month, int day) => throw null;
            public abstract bool IsLeapDay(int year, int month, int day, int era);
            public virtual bool IsLeapMonth(int year, int month) => throw null;
            public abstract bool IsLeapMonth(int year, int month, int era);
            public virtual bool IsLeapYear(int year) => throw null;
            public abstract bool IsLeapYear(int year, int era);
            public bool IsReadOnly { get => throw null; }
            public virtual System.DateTime MaxSupportedDateTime { get => throw null; }
            public virtual System.DateTime MinSupportedDateTime { get => throw null; }
            public static System.Globalization.Calendar ReadOnly(System.Globalization.Calendar calendar) => throw null;
            public virtual System.DateTime ToDateTime(int year, int month, int day, int hour, int minute, int second, int millisecond) => throw null;
            public abstract System.DateTime ToDateTime(int year, int month, int day, int hour, int minute, int second, int millisecond, int era);
            public virtual int ToFourDigitYear(int year) => throw null;
            public virtual int TwoDigitYearMax { get => throw null; set => throw null; }
        }

        // Generated from `System.Globalization.CalendarAlgorithmType` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum CalendarAlgorithmType
        {
            LunarCalendar,
            LunisolarCalendar,
            SolarCalendar,
            Unknown,
        }

        // Generated from `System.Globalization.CalendarWeekRule` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum CalendarWeekRule
        {
            FirstDay,
            FirstFourDayWeek,
            FirstFullWeek,
        }

        // Generated from `System.Globalization.CharUnicodeInfo` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public static class CharUnicodeInfo
        {
            public static int GetDecimalDigitValue(System.Char ch) => throw null;
            public static int GetDecimalDigitValue(string s, int index) => throw null;
            public static int GetDigitValue(System.Char ch) => throw null;
            public static int GetDigitValue(string s, int index) => throw null;
            public static double GetNumericValue(System.Char ch) => throw null;
            public static double GetNumericValue(string s, int index) => throw null;
            public static System.Globalization.UnicodeCategory GetUnicodeCategory(System.Char ch) => throw null;
            public static System.Globalization.UnicodeCategory GetUnicodeCategory(int codePoint) => throw null;
            public static System.Globalization.UnicodeCategory GetUnicodeCategory(string s, int index) => throw null;
        }

        // Generated from `System.Globalization.ChineseLunisolarCalendar` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ChineseLunisolarCalendar : System.Globalization.EastAsianLunisolarCalendar
        {
            public const int ChineseEra = default;
            public ChineseLunisolarCalendar() => throw null;
            protected override int DaysInYearBeforeMinSupportedYear { get => throw null; }
            public override int[] Eras { get => throw null; }
            public override int GetEra(System.DateTime time) => throw null;
            public override System.DateTime MaxSupportedDateTime { get => throw null; }
            public override System.DateTime MinSupportedDateTime { get => throw null; }
        }

        // Generated from `System.Globalization.CompareInfo` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class CompareInfo : System.Runtime.Serialization.IDeserializationCallback
        {
            public int Compare(System.ReadOnlySpan<System.Char> string1, System.ReadOnlySpan<System.Char> string2, System.Globalization.CompareOptions options = default(System.Globalization.CompareOptions)) => throw null;
            public int Compare(string string1, int offset1, int length1, string string2, int offset2, int length2) => throw null;
            public int Compare(string string1, int offset1, int length1, string string2, int offset2, int length2, System.Globalization.CompareOptions options) => throw null;
            public int Compare(string string1, int offset1, string string2, int offset2) => throw null;
            public int Compare(string string1, int offset1, string string2, int offset2, System.Globalization.CompareOptions options) => throw null;
            public int Compare(string string1, string string2) => throw null;
            public int Compare(string string1, string string2, System.Globalization.CompareOptions options) => throw null;
            public override bool Equals(object value) => throw null;
            public static System.Globalization.CompareInfo GetCompareInfo(int culture) => throw null;
            public static System.Globalization.CompareInfo GetCompareInfo(int culture, System.Reflection.Assembly assembly) => throw null;
            public static System.Globalization.CompareInfo GetCompareInfo(string name) => throw null;
            public static System.Globalization.CompareInfo GetCompareInfo(string name, System.Reflection.Assembly assembly) => throw null;
            public override int GetHashCode() => throw null;
            public int GetHashCode(System.ReadOnlySpan<System.Char> source, System.Globalization.CompareOptions options) => throw null;
            public int GetHashCode(string source, System.Globalization.CompareOptions options) => throw null;
            public int GetSortKey(System.ReadOnlySpan<System.Char> source, System.Span<System.Byte> destination, System.Globalization.CompareOptions options = default(System.Globalization.CompareOptions)) => throw null;
            public System.Globalization.SortKey GetSortKey(string source) => throw null;
            public System.Globalization.SortKey GetSortKey(string source, System.Globalization.CompareOptions options) => throw null;
            public int GetSortKeyLength(System.ReadOnlySpan<System.Char> source, System.Globalization.CompareOptions options = default(System.Globalization.CompareOptions)) => throw null;
            public int IndexOf(System.ReadOnlySpan<System.Char> source, System.ReadOnlySpan<System.Char> value, System.Globalization.CompareOptions options = default(System.Globalization.CompareOptions)) => throw null;
            public int IndexOf(System.ReadOnlySpan<System.Char> source, System.ReadOnlySpan<System.Char> value, System.Globalization.CompareOptions options, out int matchLength) => throw null;
            public int IndexOf(System.ReadOnlySpan<System.Char> source, System.Text.Rune value, System.Globalization.CompareOptions options = default(System.Globalization.CompareOptions)) => throw null;
            public int IndexOf(string source, System.Char value) => throw null;
            public int IndexOf(string source, System.Char value, System.Globalization.CompareOptions options) => throw null;
            public int IndexOf(string source, System.Char value, int startIndex) => throw null;
            public int IndexOf(string source, System.Char value, int startIndex, System.Globalization.CompareOptions options) => throw null;
            public int IndexOf(string source, System.Char value, int startIndex, int count) => throw null;
            public int IndexOf(string source, System.Char value, int startIndex, int count, System.Globalization.CompareOptions options) => throw null;
            public int IndexOf(string source, string value) => throw null;
            public int IndexOf(string source, string value, System.Globalization.CompareOptions options) => throw null;
            public int IndexOf(string source, string value, int startIndex) => throw null;
            public int IndexOf(string source, string value, int startIndex, System.Globalization.CompareOptions options) => throw null;
            public int IndexOf(string source, string value, int startIndex, int count) => throw null;
            public int IndexOf(string source, string value, int startIndex, int count, System.Globalization.CompareOptions options) => throw null;
            public bool IsPrefix(System.ReadOnlySpan<System.Char> source, System.ReadOnlySpan<System.Char> prefix, System.Globalization.CompareOptions options = default(System.Globalization.CompareOptions)) => throw null;
            public bool IsPrefix(System.ReadOnlySpan<System.Char> source, System.ReadOnlySpan<System.Char> prefix, System.Globalization.CompareOptions options, out int matchLength) => throw null;
            public bool IsPrefix(string source, string prefix) => throw null;
            public bool IsPrefix(string source, string prefix, System.Globalization.CompareOptions options) => throw null;
            public static bool IsSortable(System.ReadOnlySpan<System.Char> text) => throw null;
            public static bool IsSortable(System.Text.Rune value) => throw null;
            public static bool IsSortable(System.Char ch) => throw null;
            public static bool IsSortable(string text) => throw null;
            public bool IsSuffix(System.ReadOnlySpan<System.Char> source, System.ReadOnlySpan<System.Char> suffix, System.Globalization.CompareOptions options = default(System.Globalization.CompareOptions)) => throw null;
            public bool IsSuffix(System.ReadOnlySpan<System.Char> source, System.ReadOnlySpan<System.Char> suffix, System.Globalization.CompareOptions options, out int matchLength) => throw null;
            public bool IsSuffix(string source, string suffix) => throw null;
            public bool IsSuffix(string source, string suffix, System.Globalization.CompareOptions options) => throw null;
            public int LCID { get => throw null; }
            public int LastIndexOf(System.ReadOnlySpan<System.Char> source, System.ReadOnlySpan<System.Char> value, System.Globalization.CompareOptions options = default(System.Globalization.CompareOptions)) => throw null;
            public int LastIndexOf(System.ReadOnlySpan<System.Char> source, System.ReadOnlySpan<System.Char> value, System.Globalization.CompareOptions options, out int matchLength) => throw null;
            public int LastIndexOf(System.ReadOnlySpan<System.Char> source, System.Text.Rune value, System.Globalization.CompareOptions options = default(System.Globalization.CompareOptions)) => throw null;
            public int LastIndexOf(string source, System.Char value) => throw null;
            public int LastIndexOf(string source, System.Char value, System.Globalization.CompareOptions options) => throw null;
            public int LastIndexOf(string source, System.Char value, int startIndex) => throw null;
            public int LastIndexOf(string source, System.Char value, int startIndex, System.Globalization.CompareOptions options) => throw null;
            public int LastIndexOf(string source, System.Char value, int startIndex, int count) => throw null;
            public int LastIndexOf(string source, System.Char value, int startIndex, int count, System.Globalization.CompareOptions options) => throw null;
            public int LastIndexOf(string source, string value) => throw null;
            public int LastIndexOf(string source, string value, System.Globalization.CompareOptions options) => throw null;
            public int LastIndexOf(string source, string value, int startIndex) => throw null;
            public int LastIndexOf(string source, string value, int startIndex, System.Globalization.CompareOptions options) => throw null;
            public int LastIndexOf(string source, string value, int startIndex, int count) => throw null;
            public int LastIndexOf(string source, string value, int startIndex, int count, System.Globalization.CompareOptions options) => throw null;
            public string Name { get => throw null; }
            void System.Runtime.Serialization.IDeserializationCallback.OnDeserialization(object sender) => throw null;
            public override string ToString() => throw null;
            public System.Globalization.SortVersion Version { get => throw null; }
        }

        // Generated from `System.Globalization.CompareOptions` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum CompareOptions
        {
            IgnoreCase,
            IgnoreKanaType,
            IgnoreNonSpace,
            IgnoreSymbols,
            IgnoreWidth,
            None,
            Ordinal,
            OrdinalIgnoreCase,
            StringSort,
        }

        // Generated from `System.Globalization.CultureInfo` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class CultureInfo : System.ICloneable, System.IFormatProvider
        {
            public virtual System.Globalization.Calendar Calendar { get => throw null; }
            public void ClearCachedData() => throw null;
            public virtual object Clone() => throw null;
            public virtual System.Globalization.CompareInfo CompareInfo { get => throw null; }
            public static System.Globalization.CultureInfo CreateSpecificCulture(string name) => throw null;
            public CultureInfo(int culture) => throw null;
            public CultureInfo(int culture, bool useUserOverride) => throw null;
            public CultureInfo(string name) => throw null;
            public CultureInfo(string name, bool useUserOverride) => throw null;
            public System.Globalization.CultureTypes CultureTypes { get => throw null; }
            public static System.Globalization.CultureInfo CurrentCulture { get => throw null; set => throw null; }
            public static System.Globalization.CultureInfo CurrentUICulture { get => throw null; set => throw null; }
            public virtual System.Globalization.DateTimeFormatInfo DateTimeFormat { get => throw null; set => throw null; }
            public static System.Globalization.CultureInfo DefaultThreadCurrentCulture { get => throw null; set => throw null; }
            public static System.Globalization.CultureInfo DefaultThreadCurrentUICulture { get => throw null; set => throw null; }
            public virtual string DisplayName { get => throw null; }
            public virtual string EnglishName { get => throw null; }
            public override bool Equals(object value) => throw null;
            public System.Globalization.CultureInfo GetConsoleFallbackUICulture() => throw null;
            public static System.Globalization.CultureInfo GetCultureInfo(int culture) => throw null;
            public static System.Globalization.CultureInfo GetCultureInfo(string name) => throw null;
            public static System.Globalization.CultureInfo GetCultureInfo(string name, bool predefinedOnly) => throw null;
            public static System.Globalization.CultureInfo GetCultureInfo(string name, string altName) => throw null;
            public static System.Globalization.CultureInfo GetCultureInfoByIetfLanguageTag(string name) => throw null;
            public static System.Globalization.CultureInfo[] GetCultures(System.Globalization.CultureTypes types) => throw null;
            public virtual object GetFormat(System.Type formatType) => throw null;
            public override int GetHashCode() => throw null;
            public string IetfLanguageTag { get => throw null; }
            public static System.Globalization.CultureInfo InstalledUICulture { get => throw null; }
            public static System.Globalization.CultureInfo InvariantCulture { get => throw null; }
            public virtual bool IsNeutralCulture { get => throw null; }
            public bool IsReadOnly { get => throw null; }
            public virtual int KeyboardLayoutId { get => throw null; }
            public virtual int LCID { get => throw null; }
            public virtual string Name { get => throw null; }
            public virtual string NativeName { get => throw null; }
            public virtual System.Globalization.NumberFormatInfo NumberFormat { get => throw null; set => throw null; }
            public virtual System.Globalization.Calendar[] OptionalCalendars { get => throw null; }
            public virtual System.Globalization.CultureInfo Parent { get => throw null; }
            public static System.Globalization.CultureInfo ReadOnly(System.Globalization.CultureInfo ci) => throw null;
            public virtual System.Globalization.TextInfo TextInfo { get => throw null; }
            public virtual string ThreeLetterISOLanguageName { get => throw null; }
            public virtual string ThreeLetterWindowsLanguageName { get => throw null; }
            public override string ToString() => throw null;
            public virtual string TwoLetterISOLanguageName { get => throw null; }
            public bool UseUserOverride { get => throw null; }
        }

        // Generated from `System.Globalization.CultureNotFoundException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class CultureNotFoundException : System.ArgumentException
        {
            public CultureNotFoundException() => throw null;
            protected CultureNotFoundException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public CultureNotFoundException(string message) => throw null;
            public CultureNotFoundException(string message, System.Exception innerException) => throw null;
            public CultureNotFoundException(string message, int invalidCultureId, System.Exception innerException) => throw null;
            public CultureNotFoundException(string paramName, int invalidCultureId, string message) => throw null;
            public CultureNotFoundException(string paramName, string message) => throw null;
            public CultureNotFoundException(string message, string invalidCultureName, System.Exception innerException) => throw null;
            public CultureNotFoundException(string paramName, string invalidCultureName, string message) => throw null;
            public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public virtual int? InvalidCultureId { get => throw null; }
            public virtual string InvalidCultureName { get => throw null; }
            public override string Message { get => throw null; }
        }

        // Generated from `System.Globalization.CultureTypes` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum CultureTypes
        {
            AllCultures,
            FrameworkCultures,
            InstalledWin32Cultures,
            NeutralCultures,
            ReplacementCultures,
            SpecificCultures,
            UserCustomCulture,
            WindowsOnlyCultures,
        }

        // Generated from `System.Globalization.DateTimeFormatInfo` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DateTimeFormatInfo : System.ICloneable, System.IFormatProvider
        {
            public string AMDesignator { get => throw null; set => throw null; }
            public string[] AbbreviatedDayNames { get => throw null; set => throw null; }
            public string[] AbbreviatedMonthGenitiveNames { get => throw null; set => throw null; }
            public string[] AbbreviatedMonthNames { get => throw null; set => throw null; }
            public System.Globalization.Calendar Calendar { get => throw null; set => throw null; }
            public System.Globalization.CalendarWeekRule CalendarWeekRule { get => throw null; set => throw null; }
            public object Clone() => throw null;
            public static System.Globalization.DateTimeFormatInfo CurrentInfo { get => throw null; }
            public string DateSeparator { get => throw null; set => throw null; }
            public DateTimeFormatInfo() => throw null;
            public string[] DayNames { get => throw null; set => throw null; }
            public System.DayOfWeek FirstDayOfWeek { get => throw null; set => throw null; }
            public string FullDateTimePattern { get => throw null; set => throw null; }
            public string GetAbbreviatedDayName(System.DayOfWeek dayofweek) => throw null;
            public string GetAbbreviatedEraName(int era) => throw null;
            public string GetAbbreviatedMonthName(int month) => throw null;
            public string[] GetAllDateTimePatterns() => throw null;
            public string[] GetAllDateTimePatterns(System.Char format) => throw null;
            public string GetDayName(System.DayOfWeek dayofweek) => throw null;
            public int GetEra(string eraName) => throw null;
            public string GetEraName(int era) => throw null;
            public object GetFormat(System.Type formatType) => throw null;
            public static System.Globalization.DateTimeFormatInfo GetInstance(System.IFormatProvider provider) => throw null;
            public string GetMonthName(int month) => throw null;
            public string GetShortestDayName(System.DayOfWeek dayOfWeek) => throw null;
            public static System.Globalization.DateTimeFormatInfo InvariantInfo { get => throw null; }
            public bool IsReadOnly { get => throw null; }
            public string LongDatePattern { get => throw null; set => throw null; }
            public string LongTimePattern { get => throw null; set => throw null; }
            public string MonthDayPattern { get => throw null; set => throw null; }
            public string[] MonthGenitiveNames { get => throw null; set => throw null; }
            public string[] MonthNames { get => throw null; set => throw null; }
            public string NativeCalendarName { get => throw null; }
            public string PMDesignator { get => throw null; set => throw null; }
            public string RFC1123Pattern { get => throw null; }
            public static System.Globalization.DateTimeFormatInfo ReadOnly(System.Globalization.DateTimeFormatInfo dtfi) => throw null;
            public void SetAllDateTimePatterns(string[] patterns, System.Char format) => throw null;
            public string ShortDatePattern { get => throw null; set => throw null; }
            public string ShortTimePattern { get => throw null; set => throw null; }
            public string[] ShortestDayNames { get => throw null; set => throw null; }
            public string SortableDateTimePattern { get => throw null; }
            public string TimeSeparator { get => throw null; set => throw null; }
            public string UniversalSortableDateTimePattern { get => throw null; }
            public string YearMonthPattern { get => throw null; set => throw null; }
        }

        // Generated from `System.Globalization.DateTimeStyles` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum DateTimeStyles
        {
            AdjustToUniversal,
            AllowInnerWhite,
            AllowLeadingWhite,
            AllowTrailingWhite,
            AllowWhiteSpaces,
            AssumeLocal,
            AssumeUniversal,
            NoCurrentDateDefault,
            None,
            RoundtripKind,
        }

        // Generated from `System.Globalization.DaylightTime` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DaylightTime
        {
            public DaylightTime(System.DateTime start, System.DateTime end, System.TimeSpan delta) => throw null;
            public System.TimeSpan Delta { get => throw null; }
            public System.DateTime End { get => throw null; }
            public System.DateTime Start { get => throw null; }
        }

        // Generated from `System.Globalization.DigitShapes` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum DigitShapes
        {
            Context,
            NativeNational,
            None,
        }

        // Generated from `System.Globalization.EastAsianLunisolarCalendar` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class EastAsianLunisolarCalendar : System.Globalization.Calendar
        {
            public override System.DateTime AddMonths(System.DateTime time, int months) => throw null;
            public override System.DateTime AddYears(System.DateTime time, int years) => throw null;
            public override System.Globalization.CalendarAlgorithmType AlgorithmType { get => throw null; }
            internal EastAsianLunisolarCalendar() => throw null;
            public int GetCelestialStem(int sexagenaryYear) => throw null;
            public override int GetDayOfMonth(System.DateTime time) => throw null;
            public override System.DayOfWeek GetDayOfWeek(System.DateTime time) => throw null;
            public override int GetDayOfYear(System.DateTime time) => throw null;
            public override int GetDaysInMonth(int year, int month, int era) => throw null;
            public override int GetDaysInYear(int year, int era) => throw null;
            public override int GetLeapMonth(int year, int era) => throw null;
            public override int GetMonth(System.DateTime time) => throw null;
            public override int GetMonthsInYear(int year, int era) => throw null;
            public virtual int GetSexagenaryYear(System.DateTime time) => throw null;
            public int GetTerrestrialBranch(int sexagenaryYear) => throw null;
            public override int GetYear(System.DateTime time) => throw null;
            public override bool IsLeapDay(int year, int month, int day, int era) => throw null;
            public override bool IsLeapMonth(int year, int month, int era) => throw null;
            public override bool IsLeapYear(int year, int era) => throw null;
            public override System.DateTime ToDateTime(int year, int month, int day, int hour, int minute, int second, int millisecond, int era) => throw null;
            public override int ToFourDigitYear(int year) => throw null;
            public override int TwoDigitYearMax { get => throw null; set => throw null; }
        }

        // Generated from `System.Globalization.GlobalizationExtensions` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public static class GlobalizationExtensions
        {
            public static System.StringComparer GetStringComparer(this System.Globalization.CompareInfo compareInfo, System.Globalization.CompareOptions options) => throw null;
        }

        // Generated from `System.Globalization.GregorianCalendar` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class GregorianCalendar : System.Globalization.Calendar
        {
            public const int ADEra = default;
            public override System.DateTime AddMonths(System.DateTime time, int months) => throw null;
            public override System.DateTime AddYears(System.DateTime time, int years) => throw null;
            public override System.Globalization.CalendarAlgorithmType AlgorithmType { get => throw null; }
            public virtual System.Globalization.GregorianCalendarTypes CalendarType { get => throw null; set => throw null; }
            public override int[] Eras { get => throw null; }
            public override int GetDayOfMonth(System.DateTime time) => throw null;
            public override System.DayOfWeek GetDayOfWeek(System.DateTime time) => throw null;
            public override int GetDayOfYear(System.DateTime time) => throw null;
            public override int GetDaysInMonth(int year, int month, int era) => throw null;
            public override int GetDaysInYear(int year, int era) => throw null;
            public override int GetEra(System.DateTime time) => throw null;
            public override int GetLeapMonth(int year, int era) => throw null;
            public override int GetMonth(System.DateTime time) => throw null;
            public override int GetMonthsInYear(int year, int era) => throw null;
            public override int GetYear(System.DateTime time) => throw null;
            public GregorianCalendar() => throw null;
            public GregorianCalendar(System.Globalization.GregorianCalendarTypes type) => throw null;
            public override bool IsLeapDay(int year, int month, int day, int era) => throw null;
            public override bool IsLeapMonth(int year, int month, int era) => throw null;
            public override bool IsLeapYear(int year, int era) => throw null;
            public override System.DateTime MaxSupportedDateTime { get => throw null; }
            public override System.DateTime MinSupportedDateTime { get => throw null; }
            public override System.DateTime ToDateTime(int year, int month, int day, int hour, int minute, int second, int millisecond, int era) => throw null;
            public override int ToFourDigitYear(int year) => throw null;
            public override int TwoDigitYearMax { get => throw null; set => throw null; }
        }

        // Generated from `System.Globalization.GregorianCalendarTypes` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum GregorianCalendarTypes
        {
            Arabic,
            Localized,
            MiddleEastFrench,
            TransliteratedEnglish,
            TransliteratedFrench,
            USEnglish,
        }

        // Generated from `System.Globalization.HebrewCalendar` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class HebrewCalendar : System.Globalization.Calendar
        {
            public override System.DateTime AddMonths(System.DateTime time, int months) => throw null;
            public override System.DateTime AddYears(System.DateTime time, int years) => throw null;
            public override System.Globalization.CalendarAlgorithmType AlgorithmType { get => throw null; }
            public override int[] Eras { get => throw null; }
            public override int GetDayOfMonth(System.DateTime time) => throw null;
            public override System.DayOfWeek GetDayOfWeek(System.DateTime time) => throw null;
            public override int GetDayOfYear(System.DateTime time) => throw null;
            public override int GetDaysInMonth(int year, int month, int era) => throw null;
            public override int GetDaysInYear(int year, int era) => throw null;
            public override int GetEra(System.DateTime time) => throw null;
            public override int GetLeapMonth(int year, int era) => throw null;
            public override int GetMonth(System.DateTime time) => throw null;
            public override int GetMonthsInYear(int year, int era) => throw null;
            public override int GetYear(System.DateTime time) => throw null;
            public HebrewCalendar() => throw null;
            public static int HebrewEra;
            public override bool IsLeapDay(int year, int month, int day, int era) => throw null;
            public override bool IsLeapMonth(int year, int month, int era) => throw null;
            public override bool IsLeapYear(int year, int era) => throw null;
            public override System.DateTime MaxSupportedDateTime { get => throw null; }
            public override System.DateTime MinSupportedDateTime { get => throw null; }
            public override System.DateTime ToDateTime(int year, int month, int day, int hour, int minute, int second, int millisecond, int era) => throw null;
            public override int ToFourDigitYear(int year) => throw null;
            public override int TwoDigitYearMax { get => throw null; set => throw null; }
        }

        // Generated from `System.Globalization.HijriCalendar` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class HijriCalendar : System.Globalization.Calendar
        {
            public override System.DateTime AddMonths(System.DateTime time, int months) => throw null;
            public override System.DateTime AddYears(System.DateTime time, int years) => throw null;
            public override System.Globalization.CalendarAlgorithmType AlgorithmType { get => throw null; }
            protected override int DaysInYearBeforeMinSupportedYear { get => throw null; }
            public override int[] Eras { get => throw null; }
            public override int GetDayOfMonth(System.DateTime time) => throw null;
            public override System.DayOfWeek GetDayOfWeek(System.DateTime time) => throw null;
            public override int GetDayOfYear(System.DateTime time) => throw null;
            public override int GetDaysInMonth(int year, int month, int era) => throw null;
            public override int GetDaysInYear(int year, int era) => throw null;
            public override int GetEra(System.DateTime time) => throw null;
            public override int GetLeapMonth(int year, int era) => throw null;
            public override int GetMonth(System.DateTime time) => throw null;
            public override int GetMonthsInYear(int year, int era) => throw null;
            public override int GetYear(System.DateTime time) => throw null;
            public int HijriAdjustment { get => throw null; set => throw null; }
            public HijriCalendar() => throw null;
            public static int HijriEra;
            public override bool IsLeapDay(int year, int month, int day, int era) => throw null;
            public override bool IsLeapMonth(int year, int month, int era) => throw null;
            public override bool IsLeapYear(int year, int era) => throw null;
            public override System.DateTime MaxSupportedDateTime { get => throw null; }
            public override System.DateTime MinSupportedDateTime { get => throw null; }
            public override System.DateTime ToDateTime(int year, int month, int day, int hour, int minute, int second, int millisecond, int era) => throw null;
            public override int ToFourDigitYear(int year) => throw null;
            public override int TwoDigitYearMax { get => throw null; set => throw null; }
        }

        // Generated from `System.Globalization.ISOWeek` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public static class ISOWeek
        {
            public static int GetWeekOfYear(System.DateTime date) => throw null;
            public static int GetWeeksInYear(int year) => throw null;
            public static int GetYear(System.DateTime date) => throw null;
            public static System.DateTime GetYearEnd(int year) => throw null;
            public static System.DateTime GetYearStart(int year) => throw null;
            public static System.DateTime ToDateTime(int year, int week, System.DayOfWeek dayOfWeek) => throw null;
        }

        // Generated from `System.Globalization.IdnMapping` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class IdnMapping
        {
            public bool AllowUnassigned { get => throw null; set => throw null; }
            public override bool Equals(object obj) => throw null;
            public string GetAscii(string unicode) => throw null;
            public string GetAscii(string unicode, int index) => throw null;
            public string GetAscii(string unicode, int index, int count) => throw null;
            public override int GetHashCode() => throw null;
            public string GetUnicode(string ascii) => throw null;
            public string GetUnicode(string ascii, int index) => throw null;
            public string GetUnicode(string ascii, int index, int count) => throw null;
            public IdnMapping() => throw null;
            public bool UseStd3AsciiRules { get => throw null; set => throw null; }
        }

        // Generated from `System.Globalization.JapaneseCalendar` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class JapaneseCalendar : System.Globalization.Calendar
        {
            public override System.DateTime AddMonths(System.DateTime time, int months) => throw null;
            public override System.DateTime AddYears(System.DateTime time, int years) => throw null;
            public override System.Globalization.CalendarAlgorithmType AlgorithmType { get => throw null; }
            public override int[] Eras { get => throw null; }
            public override int GetDayOfMonth(System.DateTime time) => throw null;
            public override System.DayOfWeek GetDayOfWeek(System.DateTime time) => throw null;
            public override int GetDayOfYear(System.DateTime time) => throw null;
            public override int GetDaysInMonth(int year, int month, int era) => throw null;
            public override int GetDaysInYear(int year, int era) => throw null;
            public override int GetEra(System.DateTime time) => throw null;
            public override int GetLeapMonth(int year, int era) => throw null;
            public override int GetMonth(System.DateTime time) => throw null;
            public override int GetMonthsInYear(int year, int era) => throw null;
            public override int GetWeekOfYear(System.DateTime time, System.Globalization.CalendarWeekRule rule, System.DayOfWeek firstDayOfWeek) => throw null;
            public override int GetYear(System.DateTime time) => throw null;
            public override bool IsLeapDay(int year, int month, int day, int era) => throw null;
            public override bool IsLeapMonth(int year, int month, int era) => throw null;
            public override bool IsLeapYear(int year, int era) => throw null;
            public JapaneseCalendar() => throw null;
            public override System.DateTime MaxSupportedDateTime { get => throw null; }
            public override System.DateTime MinSupportedDateTime { get => throw null; }
            public override System.DateTime ToDateTime(int year, int month, int day, int hour, int minute, int second, int millisecond, int era) => throw null;
            public override int ToFourDigitYear(int year) => throw null;
            public override int TwoDigitYearMax { get => throw null; set => throw null; }
        }

        // Generated from `System.Globalization.JapaneseLunisolarCalendar` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class JapaneseLunisolarCalendar : System.Globalization.EastAsianLunisolarCalendar
        {
            protected override int DaysInYearBeforeMinSupportedYear { get => throw null; }
            public override int[] Eras { get => throw null; }
            public override int GetEra(System.DateTime time) => throw null;
            public const int JapaneseEra = default;
            public JapaneseLunisolarCalendar() => throw null;
            public override System.DateTime MaxSupportedDateTime { get => throw null; }
            public override System.DateTime MinSupportedDateTime { get => throw null; }
        }

        // Generated from `System.Globalization.JulianCalendar` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class JulianCalendar : System.Globalization.Calendar
        {
            public override System.DateTime AddMonths(System.DateTime time, int months) => throw null;
            public override System.DateTime AddYears(System.DateTime time, int years) => throw null;
            public override System.Globalization.CalendarAlgorithmType AlgorithmType { get => throw null; }
            public override int[] Eras { get => throw null; }
            public override int GetDayOfMonth(System.DateTime time) => throw null;
            public override System.DayOfWeek GetDayOfWeek(System.DateTime time) => throw null;
            public override int GetDayOfYear(System.DateTime time) => throw null;
            public override int GetDaysInMonth(int year, int month, int era) => throw null;
            public override int GetDaysInYear(int year, int era) => throw null;
            public override int GetEra(System.DateTime time) => throw null;
            public override int GetLeapMonth(int year, int era) => throw null;
            public override int GetMonth(System.DateTime time) => throw null;
            public override int GetMonthsInYear(int year, int era) => throw null;
            public override int GetYear(System.DateTime time) => throw null;
            public override bool IsLeapDay(int year, int month, int day, int era) => throw null;
            public override bool IsLeapMonth(int year, int month, int era) => throw null;
            public override bool IsLeapYear(int year, int era) => throw null;
            public JulianCalendar() => throw null;
            public static int JulianEra;
            public override System.DateTime MaxSupportedDateTime { get => throw null; }
            public override System.DateTime MinSupportedDateTime { get => throw null; }
            public override System.DateTime ToDateTime(int year, int month, int day, int hour, int minute, int second, int millisecond, int era) => throw null;
            public override int ToFourDigitYear(int year) => throw null;
            public override int TwoDigitYearMax { get => throw null; set => throw null; }
        }

        // Generated from `System.Globalization.KoreanCalendar` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class KoreanCalendar : System.Globalization.Calendar
        {
            public override System.DateTime AddMonths(System.DateTime time, int months) => throw null;
            public override System.DateTime AddYears(System.DateTime time, int years) => throw null;
            public override System.Globalization.CalendarAlgorithmType AlgorithmType { get => throw null; }
            public override int[] Eras { get => throw null; }
            public override int GetDayOfMonth(System.DateTime time) => throw null;
            public override System.DayOfWeek GetDayOfWeek(System.DateTime time) => throw null;
            public override int GetDayOfYear(System.DateTime time) => throw null;
            public override int GetDaysInMonth(int year, int month, int era) => throw null;
            public override int GetDaysInYear(int year, int era) => throw null;
            public override int GetEra(System.DateTime time) => throw null;
            public override int GetLeapMonth(int year, int era) => throw null;
            public override int GetMonth(System.DateTime time) => throw null;
            public override int GetMonthsInYear(int year, int era) => throw null;
            public override int GetWeekOfYear(System.DateTime time, System.Globalization.CalendarWeekRule rule, System.DayOfWeek firstDayOfWeek) => throw null;
            public override int GetYear(System.DateTime time) => throw null;
            public override bool IsLeapDay(int year, int month, int day, int era) => throw null;
            public override bool IsLeapMonth(int year, int month, int era) => throw null;
            public override bool IsLeapYear(int year, int era) => throw null;
            public KoreanCalendar() => throw null;
            public const int KoreanEra = default;
            public override System.DateTime MaxSupportedDateTime { get => throw null; }
            public override System.DateTime MinSupportedDateTime { get => throw null; }
            public override System.DateTime ToDateTime(int year, int month, int day, int hour, int minute, int second, int millisecond, int era) => throw null;
            public override int ToFourDigitYear(int year) => throw null;
            public override int TwoDigitYearMax { get => throw null; set => throw null; }
        }

        // Generated from `System.Globalization.KoreanLunisolarCalendar` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class KoreanLunisolarCalendar : System.Globalization.EastAsianLunisolarCalendar
        {
            protected override int DaysInYearBeforeMinSupportedYear { get => throw null; }
            public override int[] Eras { get => throw null; }
            public override int GetEra(System.DateTime time) => throw null;
            public const int GregorianEra = default;
            public KoreanLunisolarCalendar() => throw null;
            public override System.DateTime MaxSupportedDateTime { get => throw null; }
            public override System.DateTime MinSupportedDateTime { get => throw null; }
        }

        // Generated from `System.Globalization.NumberFormatInfo` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class NumberFormatInfo : System.ICloneable, System.IFormatProvider
        {
            public object Clone() => throw null;
            public int CurrencyDecimalDigits { get => throw null; set => throw null; }
            public string CurrencyDecimalSeparator { get => throw null; set => throw null; }
            public string CurrencyGroupSeparator { get => throw null; set => throw null; }
            public int[] CurrencyGroupSizes { get => throw null; set => throw null; }
            public int CurrencyNegativePattern { get => throw null; set => throw null; }
            public int CurrencyPositivePattern { get => throw null; set => throw null; }
            public string CurrencySymbol { get => throw null; set => throw null; }
            public static System.Globalization.NumberFormatInfo CurrentInfo { get => throw null; }
            public System.Globalization.DigitShapes DigitSubstitution { get => throw null; set => throw null; }
            public object GetFormat(System.Type formatType) => throw null;
            public static System.Globalization.NumberFormatInfo GetInstance(System.IFormatProvider formatProvider) => throw null;
            public static System.Globalization.NumberFormatInfo InvariantInfo { get => throw null; }
            public bool IsReadOnly { get => throw null; }
            public string NaNSymbol { get => throw null; set => throw null; }
            public string[] NativeDigits { get => throw null; set => throw null; }
            public string NegativeInfinitySymbol { get => throw null; set => throw null; }
            public string NegativeSign { get => throw null; set => throw null; }
            public int NumberDecimalDigits { get => throw null; set => throw null; }
            public string NumberDecimalSeparator { get => throw null; set => throw null; }
            public NumberFormatInfo() => throw null;
            public string NumberGroupSeparator { get => throw null; set => throw null; }
            public int[] NumberGroupSizes { get => throw null; set => throw null; }
            public int NumberNegativePattern { get => throw null; set => throw null; }
            public string PerMilleSymbol { get => throw null; set => throw null; }
            public int PercentDecimalDigits { get => throw null; set => throw null; }
            public string PercentDecimalSeparator { get => throw null; set => throw null; }
            public string PercentGroupSeparator { get => throw null; set => throw null; }
            public int[] PercentGroupSizes { get => throw null; set => throw null; }
            public int PercentNegativePattern { get => throw null; set => throw null; }
            public int PercentPositivePattern { get => throw null; set => throw null; }
            public string PercentSymbol { get => throw null; set => throw null; }
            public string PositiveInfinitySymbol { get => throw null; set => throw null; }
            public string PositiveSign { get => throw null; set => throw null; }
            public static System.Globalization.NumberFormatInfo ReadOnly(System.Globalization.NumberFormatInfo nfi) => throw null;
        }

        // Generated from `System.Globalization.NumberStyles` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum NumberStyles
        {
            AllowCurrencySymbol,
            AllowDecimalPoint,
            AllowExponent,
            AllowHexSpecifier,
            AllowLeadingSign,
            AllowLeadingWhite,
            AllowParentheses,
            AllowThousands,
            AllowTrailingSign,
            AllowTrailingWhite,
            Any,
            Currency,
            Float,
            HexNumber,
            Integer,
            None,
            Number,
        }

        // Generated from `System.Globalization.PersianCalendar` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class PersianCalendar : System.Globalization.Calendar
        {
            public override System.DateTime AddMonths(System.DateTime time, int months) => throw null;
            public override System.DateTime AddYears(System.DateTime time, int years) => throw null;
            public override System.Globalization.CalendarAlgorithmType AlgorithmType { get => throw null; }
            public override int[] Eras { get => throw null; }
            public override int GetDayOfMonth(System.DateTime time) => throw null;
            public override System.DayOfWeek GetDayOfWeek(System.DateTime time) => throw null;
            public override int GetDayOfYear(System.DateTime time) => throw null;
            public override int GetDaysInMonth(int year, int month, int era) => throw null;
            public override int GetDaysInYear(int year, int era) => throw null;
            public override int GetEra(System.DateTime time) => throw null;
            public override int GetLeapMonth(int year, int era) => throw null;
            public override int GetMonth(System.DateTime time) => throw null;
            public override int GetMonthsInYear(int year, int era) => throw null;
            public override int GetYear(System.DateTime time) => throw null;
            public override bool IsLeapDay(int year, int month, int day, int era) => throw null;
            public override bool IsLeapMonth(int year, int month, int era) => throw null;
            public override bool IsLeapYear(int year, int era) => throw null;
            public override System.DateTime MaxSupportedDateTime { get => throw null; }
            public override System.DateTime MinSupportedDateTime { get => throw null; }
            public PersianCalendar() => throw null;
            public static int PersianEra;
            public override System.DateTime ToDateTime(int year, int month, int day, int hour, int minute, int second, int millisecond, int era) => throw null;
            public override int ToFourDigitYear(int year) => throw null;
            public override int TwoDigitYearMax { get => throw null; set => throw null; }
        }

        // Generated from `System.Globalization.RegionInfo` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class RegionInfo
        {
            public virtual string CurrencyEnglishName { get => throw null; }
            public virtual string CurrencyNativeName { get => throw null; }
            public virtual string CurrencySymbol { get => throw null; }
            public static System.Globalization.RegionInfo CurrentRegion { get => throw null; }
            public virtual string DisplayName { get => throw null; }
            public virtual string EnglishName { get => throw null; }
            public override bool Equals(object value) => throw null;
            public virtual int GeoId { get => throw null; }
            public override int GetHashCode() => throw null;
            public virtual string ISOCurrencySymbol { get => throw null; }
            public virtual bool IsMetric { get => throw null; }
            public virtual string Name { get => throw null; }
            public virtual string NativeName { get => throw null; }
            public RegionInfo(int culture) => throw null;
            public RegionInfo(string name) => throw null;
            public virtual string ThreeLetterISORegionName { get => throw null; }
            public virtual string ThreeLetterWindowsRegionName { get => throw null; }
            public override string ToString() => throw null;
            public virtual string TwoLetterISORegionName { get => throw null; }
        }

        // Generated from `System.Globalization.SortKey` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class SortKey
        {
            public static int Compare(System.Globalization.SortKey sortkey1, System.Globalization.SortKey sortkey2) => throw null;
            public override bool Equals(object value) => throw null;
            public override int GetHashCode() => throw null;
            public System.Byte[] KeyData { get => throw null; }
            public string OriginalString { get => throw null; }
            public override string ToString() => throw null;
        }

        // Generated from `System.Globalization.SortVersion` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class SortVersion : System.IEquatable<System.Globalization.SortVersion>
        {
            public static bool operator !=(System.Globalization.SortVersion left, System.Globalization.SortVersion right) => throw null;
            public static bool operator ==(System.Globalization.SortVersion left, System.Globalization.SortVersion right) => throw null;
            public bool Equals(System.Globalization.SortVersion other) => throw null;
            public override bool Equals(object obj) => throw null;
            public int FullVersion { get => throw null; }
            public override int GetHashCode() => throw null;
            public System.Guid SortId { get => throw null; }
            public SortVersion(int fullVersion, System.Guid sortId) => throw null;
        }

        // Generated from `System.Globalization.StringInfo` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class StringInfo
        {
            public override bool Equals(object value) => throw null;
            public override int GetHashCode() => throw null;
            public static string GetNextTextElement(string str) => throw null;
            public static string GetNextTextElement(string str, int index) => throw null;
            public static System.Globalization.TextElementEnumerator GetTextElementEnumerator(string str) => throw null;
            public static System.Globalization.TextElementEnumerator GetTextElementEnumerator(string str, int index) => throw null;
            public int LengthInTextElements { get => throw null; }
            public static int[] ParseCombiningCharacters(string str) => throw null;
            public string String { get => throw null; set => throw null; }
            public StringInfo() => throw null;
            public StringInfo(string value) => throw null;
            public string SubstringByTextElements(int startingTextElement) => throw null;
            public string SubstringByTextElements(int startingTextElement, int lengthInTextElements) => throw null;
        }

        // Generated from `System.Globalization.TaiwanCalendar` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class TaiwanCalendar : System.Globalization.Calendar
        {
            public override System.DateTime AddMonths(System.DateTime time, int months) => throw null;
            public override System.DateTime AddYears(System.DateTime time, int years) => throw null;
            public override System.Globalization.CalendarAlgorithmType AlgorithmType { get => throw null; }
            public override int[] Eras { get => throw null; }
            public override int GetDayOfMonth(System.DateTime time) => throw null;
            public override System.DayOfWeek GetDayOfWeek(System.DateTime time) => throw null;
            public override int GetDayOfYear(System.DateTime time) => throw null;
            public override int GetDaysInMonth(int year, int month, int era) => throw null;
            public override int GetDaysInYear(int year, int era) => throw null;
            public override int GetEra(System.DateTime time) => throw null;
            public override int GetLeapMonth(int year, int era) => throw null;
            public override int GetMonth(System.DateTime time) => throw null;
            public override int GetMonthsInYear(int year, int era) => throw null;
            public override int GetWeekOfYear(System.DateTime time, System.Globalization.CalendarWeekRule rule, System.DayOfWeek firstDayOfWeek) => throw null;
            public override int GetYear(System.DateTime time) => throw null;
            public override bool IsLeapDay(int year, int month, int day, int era) => throw null;
            public override bool IsLeapMonth(int year, int month, int era) => throw null;
            public override bool IsLeapYear(int year, int era) => throw null;
            public override System.DateTime MaxSupportedDateTime { get => throw null; }
            public override System.DateTime MinSupportedDateTime { get => throw null; }
            public TaiwanCalendar() => throw null;
            public override System.DateTime ToDateTime(int year, int month, int day, int hour, int minute, int second, int millisecond, int era) => throw null;
            public override int ToFourDigitYear(int year) => throw null;
            public override int TwoDigitYearMax { get => throw null; set => throw null; }
        }

        // Generated from `System.Globalization.TaiwanLunisolarCalendar` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class TaiwanLunisolarCalendar : System.Globalization.EastAsianLunisolarCalendar
        {
            protected override int DaysInYearBeforeMinSupportedYear { get => throw null; }
            public override int[] Eras { get => throw null; }
            public override int GetEra(System.DateTime time) => throw null;
            public override System.DateTime MaxSupportedDateTime { get => throw null; }
            public override System.DateTime MinSupportedDateTime { get => throw null; }
            public TaiwanLunisolarCalendar() => throw null;
        }

        // Generated from `System.Globalization.TextElementEnumerator` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class TextElementEnumerator : System.Collections.IEnumerator
        {
            public object Current { get => throw null; }
            public int ElementIndex { get => throw null; }
            public string GetTextElement() => throw null;
            public bool MoveNext() => throw null;
            public void Reset() => throw null;
        }

        // Generated from `System.Globalization.TextInfo` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class TextInfo : System.ICloneable, System.Runtime.Serialization.IDeserializationCallback
        {
            public int ANSICodePage { get => throw null; }
            public object Clone() => throw null;
            public string CultureName { get => throw null; }
            public int EBCDICCodePage { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public bool IsReadOnly { get => throw null; }
            public bool IsRightToLeft { get => throw null; }
            public int LCID { get => throw null; }
            public string ListSeparator { get => throw null; set => throw null; }
            public int MacCodePage { get => throw null; }
            public int OEMCodePage { get => throw null; }
            void System.Runtime.Serialization.IDeserializationCallback.OnDeserialization(object sender) => throw null;
            public static System.Globalization.TextInfo ReadOnly(System.Globalization.TextInfo textInfo) => throw null;
            public System.Char ToLower(System.Char c) => throw null;
            public string ToLower(string str) => throw null;
            public override string ToString() => throw null;
            public string ToTitleCase(string str) => throw null;
            public System.Char ToUpper(System.Char c) => throw null;
            public string ToUpper(string str) => throw null;
        }

        // Generated from `System.Globalization.ThaiBuddhistCalendar` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ThaiBuddhistCalendar : System.Globalization.Calendar
        {
            public override System.DateTime AddMonths(System.DateTime time, int months) => throw null;
            public override System.DateTime AddYears(System.DateTime time, int years) => throw null;
            public override System.Globalization.CalendarAlgorithmType AlgorithmType { get => throw null; }
            public override int[] Eras { get => throw null; }
            public override int GetDayOfMonth(System.DateTime time) => throw null;
            public override System.DayOfWeek GetDayOfWeek(System.DateTime time) => throw null;
            public override int GetDayOfYear(System.DateTime time) => throw null;
            public override int GetDaysInMonth(int year, int month, int era) => throw null;
            public override int GetDaysInYear(int year, int era) => throw null;
            public override int GetEra(System.DateTime time) => throw null;
            public override int GetLeapMonth(int year, int era) => throw null;
            public override int GetMonth(System.DateTime time) => throw null;
            public override int GetMonthsInYear(int year, int era) => throw null;
            public override int GetWeekOfYear(System.DateTime time, System.Globalization.CalendarWeekRule rule, System.DayOfWeek firstDayOfWeek) => throw null;
            public override int GetYear(System.DateTime time) => throw null;
            public override bool IsLeapDay(int year, int month, int day, int era) => throw null;
            public override bool IsLeapMonth(int year, int month, int era) => throw null;
            public override bool IsLeapYear(int year, int era) => throw null;
            public override System.DateTime MaxSupportedDateTime { get => throw null; }
            public override System.DateTime MinSupportedDateTime { get => throw null; }
            public ThaiBuddhistCalendar() => throw null;
            public const int ThaiBuddhistEra = default;
            public override System.DateTime ToDateTime(int year, int month, int day, int hour, int minute, int second, int millisecond, int era) => throw null;
            public override int ToFourDigitYear(int year) => throw null;
            public override int TwoDigitYearMax { get => throw null; set => throw null; }
        }

        // Generated from `System.Globalization.TimeSpanStyles` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum TimeSpanStyles
        {
            AssumeNegative,
            None,
        }

        // Generated from `System.Globalization.UmAlQuraCalendar` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class UmAlQuraCalendar : System.Globalization.Calendar
        {
            public override System.DateTime AddMonths(System.DateTime time, int months) => throw null;
            public override System.DateTime AddYears(System.DateTime time, int years) => throw null;
            public override System.Globalization.CalendarAlgorithmType AlgorithmType { get => throw null; }
            protected override int DaysInYearBeforeMinSupportedYear { get => throw null; }
            public override int[] Eras { get => throw null; }
            public override int GetDayOfMonth(System.DateTime time) => throw null;
            public override System.DayOfWeek GetDayOfWeek(System.DateTime time) => throw null;
            public override int GetDayOfYear(System.DateTime time) => throw null;
            public override int GetDaysInMonth(int year, int month, int era) => throw null;
            public override int GetDaysInYear(int year, int era) => throw null;
            public override int GetEra(System.DateTime time) => throw null;
            public override int GetLeapMonth(int year, int era) => throw null;
            public override int GetMonth(System.DateTime time) => throw null;
            public override int GetMonthsInYear(int year, int era) => throw null;
            public override int GetYear(System.DateTime time) => throw null;
            public override bool IsLeapDay(int year, int month, int day, int era) => throw null;
            public override bool IsLeapMonth(int year, int month, int era) => throw null;
            public override bool IsLeapYear(int year, int era) => throw null;
            public override System.DateTime MaxSupportedDateTime { get => throw null; }
            public override System.DateTime MinSupportedDateTime { get => throw null; }
            public override System.DateTime ToDateTime(int year, int month, int day, int hour, int minute, int second, int millisecond, int era) => throw null;
            public override int ToFourDigitYear(int year) => throw null;
            public override int TwoDigitYearMax { get => throw null; set => throw null; }
            public UmAlQuraCalendar() => throw null;
            public const int UmAlQuraEra = default;
        }

        // Generated from `System.Globalization.UnicodeCategory` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum UnicodeCategory
        {
            ClosePunctuation,
            ConnectorPunctuation,
            Control,
            CurrencySymbol,
            DashPunctuation,
            DecimalDigitNumber,
            EnclosingMark,
            FinalQuotePunctuation,
            Format,
            InitialQuotePunctuation,
            LetterNumber,
            LineSeparator,
            LowercaseLetter,
            MathSymbol,
            ModifierLetter,
            ModifierSymbol,
            NonSpacingMark,
            OpenPunctuation,
            OtherLetter,
            OtherNotAssigned,
            OtherNumber,
            OtherPunctuation,
            OtherSymbol,
            ParagraphSeparator,
            PrivateUse,
            SpaceSeparator,
            SpacingCombiningMark,
            Surrogate,
            TitlecaseLetter,
            UppercaseLetter,
        }

    }
    namespace IO
    {
        // Generated from `System.IO.BinaryReader` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class BinaryReader : System.IDisposable
        {
            public virtual System.IO.Stream BaseStream { get => throw null; }
            public BinaryReader(System.IO.Stream input) => throw null;
            public BinaryReader(System.IO.Stream input, System.Text.Encoding encoding) => throw null;
            public BinaryReader(System.IO.Stream input, System.Text.Encoding encoding, bool leaveOpen) => throw null;
            public virtual void Close() => throw null;
            public void Dispose() => throw null;
            protected virtual void Dispose(bool disposing) => throw null;
            protected virtual void FillBuffer(int numBytes) => throw null;
            public virtual int PeekChar() => throw null;
            public virtual int Read() => throw null;
            public virtual int Read(System.Byte[] buffer, int index, int count) => throw null;
            public virtual int Read(System.Char[] buffer, int index, int count) => throw null;
            public virtual int Read(System.Span<System.Byte> buffer) => throw null;
            public virtual int Read(System.Span<System.Char> buffer) => throw null;
            public int Read7BitEncodedInt() => throw null;
            public System.Int64 Read7BitEncodedInt64() => throw null;
            public virtual bool ReadBoolean() => throw null;
            public virtual System.Byte ReadByte() => throw null;
            public virtual System.Byte[] ReadBytes(int count) => throw null;
            public virtual System.Char ReadChar() => throw null;
            public virtual System.Char[] ReadChars(int count) => throw null;
            public virtual System.Decimal ReadDecimal() => throw null;
            public virtual double ReadDouble() => throw null;
            public virtual System.Int16 ReadInt16() => throw null;
            public virtual int ReadInt32() => throw null;
            public virtual System.Int64 ReadInt64() => throw null;
            public virtual System.SByte ReadSByte() => throw null;
            public virtual float ReadSingle() => throw null;
            public virtual string ReadString() => throw null;
            public virtual System.UInt16 ReadUInt16() => throw null;
            public virtual System.UInt32 ReadUInt32() => throw null;
            public virtual System.UInt64 ReadUInt64() => throw null;
        }

        // Generated from `System.IO.BinaryWriter` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class BinaryWriter : System.IAsyncDisposable, System.IDisposable
        {
            public virtual System.IO.Stream BaseStream { get => throw null; }
            protected BinaryWriter() => throw null;
            public BinaryWriter(System.IO.Stream output) => throw null;
            public BinaryWriter(System.IO.Stream output, System.Text.Encoding encoding) => throw null;
            public BinaryWriter(System.IO.Stream output, System.Text.Encoding encoding, bool leaveOpen) => throw null;
            public virtual void Close() => throw null;
            public void Dispose() => throw null;
            protected virtual void Dispose(bool disposing) => throw null;
            public virtual System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
            public virtual void Flush() => throw null;
            public static System.IO.BinaryWriter Null;
            protected System.IO.Stream OutStream;
            public virtual System.Int64 Seek(int offset, System.IO.SeekOrigin origin) => throw null;
            public virtual void Write(System.Byte[] buffer) => throw null;
            public virtual void Write(System.Byte[] buffer, int index, int count) => throw null;
            public virtual void Write(System.Char[] chars) => throw null;
            public virtual void Write(System.Char[] chars, int index, int count) => throw null;
            public virtual void Write(System.ReadOnlySpan<System.Byte> buffer) => throw null;
            public virtual void Write(System.ReadOnlySpan<System.Char> chars) => throw null;
            public virtual void Write(bool value) => throw null;
            public virtual void Write(System.Byte value) => throw null;
            public virtual void Write(System.Char ch) => throw null;
            public virtual void Write(System.Decimal value) => throw null;
            public virtual void Write(double value) => throw null;
            public virtual void Write(float value) => throw null;
            public virtual void Write(int value) => throw null;
            public virtual void Write(System.Int64 value) => throw null;
            public virtual void Write(System.SByte value) => throw null;
            public virtual void Write(System.Int16 value) => throw null;
            public virtual void Write(string value) => throw null;
            public virtual void Write(System.UInt32 value) => throw null;
            public virtual void Write(System.UInt64 value) => throw null;
            public virtual void Write(System.UInt16 value) => throw null;
            public void Write7BitEncodedInt(int value) => throw null;
            public void Write7BitEncodedInt64(System.Int64 value) => throw null;
        }

        // Generated from `System.IO.BufferedStream` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class BufferedStream : System.IO.Stream
        {
            public override System.IAsyncResult BeginRead(System.Byte[] buffer, int offset, int count, System.AsyncCallback callback, object state) => throw null;
            public override System.IAsyncResult BeginWrite(System.Byte[] buffer, int offset, int count, System.AsyncCallback callback, object state) => throw null;
            public int BufferSize { get => throw null; }
            public BufferedStream(System.IO.Stream stream) => throw null;
            public BufferedStream(System.IO.Stream stream, int bufferSize) => throw null;
            public override bool CanRead { get => throw null; }
            public override bool CanSeek { get => throw null; }
            public override bool CanWrite { get => throw null; }
            public override void CopyTo(System.IO.Stream destination, int bufferSize) => throw null;
            public override System.Threading.Tasks.Task CopyToAsync(System.IO.Stream destination, int bufferSize, System.Threading.CancellationToken cancellationToken) => throw null;
            protected override void Dispose(bool disposing) => throw null;
            public override System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
            public override int EndRead(System.IAsyncResult asyncResult) => throw null;
            public override void EndWrite(System.IAsyncResult asyncResult) => throw null;
            public override void Flush() => throw null;
            public override System.Threading.Tasks.Task FlushAsync(System.Threading.CancellationToken cancellationToken) => throw null;
            public override System.Int64 Length { get => throw null; }
            public override System.Int64 Position { get => throw null; set => throw null; }
            public override int Read(System.Byte[] array, int offset, int count) => throw null;
            public override int Read(System.Span<System.Byte> destination) => throw null;
            public override System.Threading.Tasks.Task<int> ReadAsync(System.Byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
            public override System.Threading.Tasks.ValueTask<int> ReadAsync(System.Memory<System.Byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override int ReadByte() => throw null;
            public override System.Int64 Seek(System.Int64 offset, System.IO.SeekOrigin origin) => throw null;
            public override void SetLength(System.Int64 value) => throw null;
            public System.IO.Stream UnderlyingStream { get => throw null; }
            public override void Write(System.Byte[] array, int offset, int count) => throw null;
            public override void Write(System.ReadOnlySpan<System.Byte> buffer) => throw null;
            public override System.Threading.Tasks.Task WriteAsync(System.Byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
            public override System.Threading.Tasks.ValueTask WriteAsync(System.ReadOnlyMemory<System.Byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override void WriteByte(System.Byte value) => throw null;
        }

        // Generated from `System.IO.DirectoryNotFoundException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DirectoryNotFoundException : System.IO.IOException
        {
            public DirectoryNotFoundException() => throw null;
            protected DirectoryNotFoundException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public DirectoryNotFoundException(string message) => throw null;
            public DirectoryNotFoundException(string message, System.Exception innerException) => throw null;
        }

        // Generated from `System.IO.EndOfStreamException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class EndOfStreamException : System.IO.IOException
        {
            public EndOfStreamException() => throw null;
            protected EndOfStreamException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public EndOfStreamException(string message) => throw null;
            public EndOfStreamException(string message, System.Exception innerException) => throw null;
        }

        // Generated from `System.IO.FileAccess` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum FileAccess
        {
            Read,
            ReadWrite,
            Write,
        }

        // Generated from `System.IO.FileAttributes` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum FileAttributes
        {
            Archive,
            Compressed,
            Device,
            Directory,
            Encrypted,
            Hidden,
            IntegrityStream,
            NoScrubData,
            Normal,
            NotContentIndexed,
            Offline,
            ReadOnly,
            ReparsePoint,
            SparseFile,
            System,
            Temporary,
        }

        // Generated from `System.IO.FileLoadException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class FileLoadException : System.IO.IOException
        {
            public FileLoadException() => throw null;
            protected FileLoadException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public FileLoadException(string message) => throw null;
            public FileLoadException(string message, System.Exception inner) => throw null;
            public FileLoadException(string message, string fileName) => throw null;
            public FileLoadException(string message, string fileName, System.Exception inner) => throw null;
            public string FileName { get => throw null; }
            public string FusionLog { get => throw null; }
            public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public override string Message { get => throw null; }
            public override string ToString() => throw null;
        }

        // Generated from `System.IO.FileMode` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum FileMode
        {
            Append,
            Create,
            CreateNew,
            Open,
            OpenOrCreate,
            Truncate,
        }

        // Generated from `System.IO.FileNotFoundException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class FileNotFoundException : System.IO.IOException
        {
            public string FileName { get => throw null; }
            public FileNotFoundException() => throw null;
            protected FileNotFoundException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public FileNotFoundException(string message) => throw null;
            public FileNotFoundException(string message, System.Exception innerException) => throw null;
            public FileNotFoundException(string message, string fileName) => throw null;
            public FileNotFoundException(string message, string fileName, System.Exception innerException) => throw null;
            public string FusionLog { get => throw null; }
            public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public override string Message { get => throw null; }
            public override string ToString() => throw null;
        }

        // Generated from `System.IO.FileOptions` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum FileOptions
        {
            Asynchronous,
            DeleteOnClose,
            Encrypted,
            None,
            RandomAccess,
            SequentialScan,
            WriteThrough,
        }

        // Generated from `System.IO.FileShare` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum FileShare
        {
            Delete,
            Inheritable,
            None,
            Read,
            ReadWrite,
            Write,
        }

        // Generated from `System.IO.FileStream` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class FileStream : System.IO.Stream
        {
            public override System.IAsyncResult BeginRead(System.Byte[] array, int offset, int numBytes, System.AsyncCallback callback, object state) => throw null;
            public override System.IAsyncResult BeginWrite(System.Byte[] array, int offset, int numBytes, System.AsyncCallback callback, object state) => throw null;
            public override bool CanRead { get => throw null; }
            public override bool CanSeek { get => throw null; }
            public override bool CanWrite { get => throw null; }
            public override System.Threading.Tasks.Task CopyToAsync(System.IO.Stream destination, int bufferSize, System.Threading.CancellationToken cancellationToken) => throw null;
            protected override void Dispose(bool disposing) => throw null;
            public override System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
            public override int EndRead(System.IAsyncResult asyncResult) => throw null;
            public override void EndWrite(System.IAsyncResult asyncResult) => throw null;
            public FileStream(System.IntPtr handle, System.IO.FileAccess access) => throw null;
            public FileStream(System.IntPtr handle, System.IO.FileAccess access, bool ownsHandle) => throw null;
            public FileStream(System.IntPtr handle, System.IO.FileAccess access, bool ownsHandle, int bufferSize) => throw null;
            public FileStream(System.IntPtr handle, System.IO.FileAccess access, bool ownsHandle, int bufferSize, bool isAsync) => throw null;
            public FileStream(Microsoft.Win32.SafeHandles.SafeFileHandle handle, System.IO.FileAccess access) => throw null;
            public FileStream(Microsoft.Win32.SafeHandles.SafeFileHandle handle, System.IO.FileAccess access, int bufferSize) => throw null;
            public FileStream(Microsoft.Win32.SafeHandles.SafeFileHandle handle, System.IO.FileAccess access, int bufferSize, bool isAsync) => throw null;
            public FileStream(string path, System.IO.FileMode mode) => throw null;
            public FileStream(string path, System.IO.FileMode mode, System.IO.FileAccess access) => throw null;
            public FileStream(string path, System.IO.FileMode mode, System.IO.FileAccess access, System.IO.FileShare share) => throw null;
            public FileStream(string path, System.IO.FileMode mode, System.IO.FileAccess access, System.IO.FileShare share, int bufferSize) => throw null;
            public FileStream(string path, System.IO.FileMode mode, System.IO.FileAccess access, System.IO.FileShare share, int bufferSize, System.IO.FileOptions options) => throw null;
            public FileStream(string path, System.IO.FileMode mode, System.IO.FileAccess access, System.IO.FileShare share, int bufferSize, bool useAsync) => throw null;
            public override void Flush() => throw null;
            public virtual void Flush(bool flushToDisk) => throw null;
            public override System.Threading.Tasks.Task FlushAsync(System.Threading.CancellationToken cancellationToken) => throw null;
            public virtual System.IntPtr Handle { get => throw null; }
            public virtual bool IsAsync { get => throw null; }
            public override System.Int64 Length { get => throw null; }
            public virtual void Lock(System.Int64 position, System.Int64 length) => throw null;
            public virtual string Name { get => throw null; }
            public override System.Int64 Position { get => throw null; set => throw null; }
            public override int Read(System.Byte[] array, int offset, int count) => throw null;
            public override int Read(System.Span<System.Byte> buffer) => throw null;
            public override System.Threading.Tasks.Task<int> ReadAsync(System.Byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
            public override System.Threading.Tasks.ValueTask<int> ReadAsync(System.Memory<System.Byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override int ReadByte() => throw null;
            public virtual Microsoft.Win32.SafeHandles.SafeFileHandle SafeFileHandle { get => throw null; }
            public override System.Int64 Seek(System.Int64 offset, System.IO.SeekOrigin origin) => throw null;
            public override void SetLength(System.Int64 value) => throw null;
            public virtual void Unlock(System.Int64 position, System.Int64 length) => throw null;
            public override void Write(System.Byte[] array, int offset, int count) => throw null;
            public override void Write(System.ReadOnlySpan<System.Byte> buffer) => throw null;
            public override System.Threading.Tasks.Task WriteAsync(System.Byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
            public override System.Threading.Tasks.ValueTask WriteAsync(System.ReadOnlyMemory<System.Byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override void WriteByte(System.Byte value) => throw null;
            // ERR: Stub generator didn't handle member: ~FileStream
        }

        // Generated from `System.IO.HandleInheritability` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum HandleInheritability
        {
            Inheritable,
            None,
        }

        // Generated from `System.IO.IOException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class IOException : System.SystemException
        {
            public IOException() => throw null;
            protected IOException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public IOException(string message) => throw null;
            public IOException(string message, System.Exception innerException) => throw null;
            public IOException(string message, int hresult) => throw null;
        }

        // Generated from `System.IO.InvalidDataException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class InvalidDataException : System.SystemException
        {
            public InvalidDataException() => throw null;
            public InvalidDataException(string message) => throw null;
            public InvalidDataException(string message, System.Exception innerException) => throw null;
        }

        // Generated from `System.IO.MemoryStream` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class MemoryStream : System.IO.Stream
        {
            public override System.IAsyncResult BeginRead(System.Byte[] buffer, int offset, int count, System.AsyncCallback callback, object state) => throw null;
            public override System.IAsyncResult BeginWrite(System.Byte[] buffer, int offset, int count, System.AsyncCallback callback, object state) => throw null;
            public override bool CanRead { get => throw null; }
            public override bool CanSeek { get => throw null; }
            public override bool CanWrite { get => throw null; }
            public virtual int Capacity { get => throw null; set => throw null; }
            public override void CopyTo(System.IO.Stream destination, int bufferSize) => throw null;
            public override System.Threading.Tasks.Task CopyToAsync(System.IO.Stream destination, int bufferSize, System.Threading.CancellationToken cancellationToken) => throw null;
            protected override void Dispose(bool disposing) => throw null;
            public override int EndRead(System.IAsyncResult asyncResult) => throw null;
            public override void EndWrite(System.IAsyncResult asyncResult) => throw null;
            public override void Flush() => throw null;
            public override System.Threading.Tasks.Task FlushAsync(System.Threading.CancellationToken cancellationToken) => throw null;
            public virtual System.Byte[] GetBuffer() => throw null;
            public override System.Int64 Length { get => throw null; }
            public MemoryStream() => throw null;
            public MemoryStream(System.Byte[] buffer) => throw null;
            public MemoryStream(System.Byte[] buffer, bool writable) => throw null;
            public MemoryStream(System.Byte[] buffer, int index, int count) => throw null;
            public MemoryStream(System.Byte[] buffer, int index, int count, bool writable) => throw null;
            public MemoryStream(System.Byte[] buffer, int index, int count, bool writable, bool publiclyVisible) => throw null;
            public MemoryStream(int capacity) => throw null;
            public override System.Int64 Position { get => throw null; set => throw null; }
            public override int Read(System.Byte[] buffer, int offset, int count) => throw null;
            public override int Read(System.Span<System.Byte> destination) => throw null;
            public override System.Threading.Tasks.Task<int> ReadAsync(System.Byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
            public override System.Threading.Tasks.ValueTask<int> ReadAsync(System.Memory<System.Byte> destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override int ReadByte() => throw null;
            public override System.Int64 Seek(System.Int64 offset, System.IO.SeekOrigin loc) => throw null;
            public override void SetLength(System.Int64 value) => throw null;
            public virtual System.Byte[] ToArray() => throw null;
            public virtual bool TryGetBuffer(out System.ArraySegment<System.Byte> buffer) => throw null;
            public override void Write(System.Byte[] buffer, int offset, int count) => throw null;
            public override void Write(System.ReadOnlySpan<System.Byte> source) => throw null;
            public override System.Threading.Tasks.Task WriteAsync(System.Byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
            public override System.Threading.Tasks.ValueTask WriteAsync(System.ReadOnlyMemory<System.Byte> source, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override void WriteByte(System.Byte value) => throw null;
            public virtual void WriteTo(System.IO.Stream stream) => throw null;
        }

        // Generated from `System.IO.Path` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public static class Path
        {
            public static System.Char AltDirectorySeparatorChar;
            public static string ChangeExtension(string path, string extension) => throw null;
            public static string Combine(params string[] paths) => throw null;
            public static string Combine(string path1, string path2) => throw null;
            public static string Combine(string path1, string path2, string path3) => throw null;
            public static string Combine(string path1, string path2, string path3, string path4) => throw null;
            public static System.Char DirectorySeparatorChar;
            public static bool EndsInDirectorySeparator(System.ReadOnlySpan<System.Char> path) => throw null;
            public static bool EndsInDirectorySeparator(string path) => throw null;
            public static System.ReadOnlySpan<System.Char> GetDirectoryName(System.ReadOnlySpan<System.Char> path) => throw null;
            public static string GetDirectoryName(string path) => throw null;
            public static System.ReadOnlySpan<System.Char> GetExtension(System.ReadOnlySpan<System.Char> path) => throw null;
            public static string GetExtension(string path) => throw null;
            public static System.ReadOnlySpan<System.Char> GetFileName(System.ReadOnlySpan<System.Char> path) => throw null;
            public static string GetFileName(string path) => throw null;
            public static System.ReadOnlySpan<System.Char> GetFileNameWithoutExtension(System.ReadOnlySpan<System.Char> path) => throw null;
            public static string GetFileNameWithoutExtension(string path) => throw null;
            public static string GetFullPath(string path) => throw null;
            public static string GetFullPath(string path, string basePath) => throw null;
            public static System.Char[] GetInvalidFileNameChars() => throw null;
            public static System.Char[] GetInvalidPathChars() => throw null;
            public static System.ReadOnlySpan<System.Char> GetPathRoot(System.ReadOnlySpan<System.Char> path) => throw null;
            public static string GetPathRoot(string path) => throw null;
            public static string GetRandomFileName() => throw null;
            public static string GetRelativePath(string relativeTo, string path) => throw null;
            public static string GetTempFileName() => throw null;
            public static string GetTempPath() => throw null;
            public static bool HasExtension(System.ReadOnlySpan<System.Char> path) => throw null;
            public static bool HasExtension(string path) => throw null;
            public static System.Char[] InvalidPathChars;
            public static bool IsPathFullyQualified(System.ReadOnlySpan<System.Char> path) => throw null;
            public static bool IsPathFullyQualified(string path) => throw null;
            public static bool IsPathRooted(System.ReadOnlySpan<System.Char> path) => throw null;
            public static bool IsPathRooted(string path) => throw null;
            public static string Join(System.ReadOnlySpan<System.Char> path1, System.ReadOnlySpan<System.Char> path2) => throw null;
            public static string Join(System.ReadOnlySpan<System.Char> path1, System.ReadOnlySpan<System.Char> path2, System.ReadOnlySpan<System.Char> path3) => throw null;
            public static string Join(System.ReadOnlySpan<System.Char> path1, System.ReadOnlySpan<System.Char> path2, System.ReadOnlySpan<System.Char> path3, System.ReadOnlySpan<System.Char> path4) => throw null;
            public static string Join(params string[] paths) => throw null;
            public static string Join(string path1, string path2) => throw null;
            public static string Join(string path1, string path2, string path3) => throw null;
            public static string Join(string path1, string path2, string path3, string path4) => throw null;
            public static System.Char PathSeparator;
            public static System.ReadOnlySpan<System.Char> TrimEndingDirectorySeparator(System.ReadOnlySpan<System.Char> path) => throw null;
            public static string TrimEndingDirectorySeparator(string path) => throw null;
            public static bool TryJoin(System.ReadOnlySpan<System.Char> path1, System.ReadOnlySpan<System.Char> path2, System.ReadOnlySpan<System.Char> path3, System.Span<System.Char> destination, out int charsWritten) => throw null;
            public static bool TryJoin(System.ReadOnlySpan<System.Char> path1, System.ReadOnlySpan<System.Char> path2, System.Span<System.Char> destination, out int charsWritten) => throw null;
            public static System.Char VolumeSeparatorChar;
        }

        // Generated from `System.IO.PathTooLongException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class PathTooLongException : System.IO.IOException
        {
            public PathTooLongException() => throw null;
            protected PathTooLongException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public PathTooLongException(string message) => throw null;
            public PathTooLongException(string message, System.Exception innerException) => throw null;
        }

        // Generated from `System.IO.SeekOrigin` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum SeekOrigin
        {
            Begin,
            Current,
            End,
        }

        // Generated from `System.IO.Stream` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class Stream : System.MarshalByRefObject, System.IAsyncDisposable, System.IDisposable
        {
            public virtual System.IAsyncResult BeginRead(System.Byte[] buffer, int offset, int count, System.AsyncCallback callback, object state) => throw null;
            public virtual System.IAsyncResult BeginWrite(System.Byte[] buffer, int offset, int count, System.AsyncCallback callback, object state) => throw null;
            public abstract bool CanRead { get; }
            public abstract bool CanSeek { get; }
            public virtual bool CanTimeout { get => throw null; }
            public abstract bool CanWrite { get; }
            public virtual void Close() => throw null;
            public void CopyTo(System.IO.Stream destination) => throw null;
            public virtual void CopyTo(System.IO.Stream destination, int bufferSize) => throw null;
            public System.Threading.Tasks.Task CopyToAsync(System.IO.Stream destination) => throw null;
            public System.Threading.Tasks.Task CopyToAsync(System.IO.Stream destination, System.Threading.CancellationToken cancellationToken) => throw null;
            public System.Threading.Tasks.Task CopyToAsync(System.IO.Stream destination, int bufferSize) => throw null;
            public virtual System.Threading.Tasks.Task CopyToAsync(System.IO.Stream destination, int bufferSize, System.Threading.CancellationToken cancellationToken) => throw null;
            protected virtual System.Threading.WaitHandle CreateWaitHandle() => throw null;
            public void Dispose() => throw null;
            protected virtual void Dispose(bool disposing) => throw null;
            public virtual System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
            public virtual int EndRead(System.IAsyncResult asyncResult) => throw null;
            public virtual void EndWrite(System.IAsyncResult asyncResult) => throw null;
            public abstract void Flush();
            public System.Threading.Tasks.Task FlushAsync() => throw null;
            public virtual System.Threading.Tasks.Task FlushAsync(System.Threading.CancellationToken cancellationToken) => throw null;
            public abstract System.Int64 Length { get; }
            public static System.IO.Stream Null;
            protected virtual void ObjectInvariant() => throw null;
            public abstract System.Int64 Position { get; set; }
            public abstract int Read(System.Byte[] buffer, int offset, int count);
            public virtual int Read(System.Span<System.Byte> buffer) => throw null;
            public System.Threading.Tasks.Task<int> ReadAsync(System.Byte[] buffer, int offset, int count) => throw null;
            public virtual System.Threading.Tasks.Task<int> ReadAsync(System.Byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
            public virtual System.Threading.Tasks.ValueTask<int> ReadAsync(System.Memory<System.Byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual int ReadByte() => throw null;
            public virtual int ReadTimeout { get => throw null; set => throw null; }
            public abstract System.Int64 Seek(System.Int64 offset, System.IO.SeekOrigin origin);
            public abstract void SetLength(System.Int64 value);
            protected Stream() => throw null;
            public static System.IO.Stream Synchronized(System.IO.Stream stream) => throw null;
            public abstract void Write(System.Byte[] buffer, int offset, int count);
            public virtual void Write(System.ReadOnlySpan<System.Byte> buffer) => throw null;
            public System.Threading.Tasks.Task WriteAsync(System.Byte[] buffer, int offset, int count) => throw null;
            public virtual System.Threading.Tasks.Task WriteAsync(System.Byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
            public virtual System.Threading.Tasks.ValueTask WriteAsync(System.ReadOnlyMemory<System.Byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual void WriteByte(System.Byte value) => throw null;
            public virtual int WriteTimeout { get => throw null; set => throw null; }
        }

        // Generated from `System.IO.StreamReader` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class StreamReader : System.IO.TextReader
        {
            public virtual System.IO.Stream BaseStream { get => throw null; }
            public override void Close() => throw null;
            public virtual System.Text.Encoding CurrentEncoding { get => throw null; }
            public void DiscardBufferedData() => throw null;
            protected override void Dispose(bool disposing) => throw null;
            public bool EndOfStream { get => throw null; }
            public static System.IO.StreamReader Null;
            public override int Peek() => throw null;
            public override int Read() => throw null;
            public override int Read(System.Char[] buffer, int index, int count) => throw null;
            public override int Read(System.Span<System.Char> buffer) => throw null;
            public override System.Threading.Tasks.Task<int> ReadAsync(System.Char[] buffer, int index, int count) => throw null;
            public override System.Threading.Tasks.ValueTask<int> ReadAsync(System.Memory<System.Char> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override int ReadBlock(System.Char[] buffer, int index, int count) => throw null;
            public override int ReadBlock(System.Span<System.Char> buffer) => throw null;
            public override System.Threading.Tasks.Task<int> ReadBlockAsync(System.Char[] buffer, int index, int count) => throw null;
            public override System.Threading.Tasks.ValueTask<int> ReadBlockAsync(System.Memory<System.Char> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override string ReadLine() => throw null;
            public override System.Threading.Tasks.Task<string> ReadLineAsync() => throw null;
            public override string ReadToEnd() => throw null;
            public override System.Threading.Tasks.Task<string> ReadToEndAsync() => throw null;
            public StreamReader(System.IO.Stream stream) => throw null;
            public StreamReader(System.IO.Stream stream, System.Text.Encoding encoding) => throw null;
            public StreamReader(System.IO.Stream stream, System.Text.Encoding encoding, bool detectEncodingFromByteOrderMarks) => throw null;
            public StreamReader(System.IO.Stream stream, System.Text.Encoding encoding, bool detectEncodingFromByteOrderMarks, int bufferSize) => throw null;
            public StreamReader(System.IO.Stream stream, System.Text.Encoding encoding = default(System.Text.Encoding), bool detectEncodingFromByteOrderMarks = default(bool), int bufferSize = default(int), bool leaveOpen = default(bool)) => throw null;
            public StreamReader(System.IO.Stream stream, bool detectEncodingFromByteOrderMarks) => throw null;
            public StreamReader(string path) => throw null;
            public StreamReader(string path, System.Text.Encoding encoding) => throw null;
            public StreamReader(string path, System.Text.Encoding encoding, bool detectEncodingFromByteOrderMarks) => throw null;
            public StreamReader(string path, System.Text.Encoding encoding, bool detectEncodingFromByteOrderMarks, int bufferSize) => throw null;
            public StreamReader(string path, bool detectEncodingFromByteOrderMarks) => throw null;
        }

        // Generated from `System.IO.StreamWriter` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class StreamWriter : System.IO.TextWriter
        {
            public virtual bool AutoFlush { get => throw null; set => throw null; }
            public virtual System.IO.Stream BaseStream { get => throw null; }
            public override void Close() => throw null;
            protected override void Dispose(bool disposing) => throw null;
            public override System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
            public override System.Text.Encoding Encoding { get => throw null; }
            public override void Flush() => throw null;
            public override System.Threading.Tasks.Task FlushAsync() => throw null;
            public static System.IO.StreamWriter Null;
            public StreamWriter(System.IO.Stream stream) => throw null;
            public StreamWriter(System.IO.Stream stream, System.Text.Encoding encoding) => throw null;
            public StreamWriter(System.IO.Stream stream, System.Text.Encoding encoding, int bufferSize) => throw null;
            public StreamWriter(System.IO.Stream stream, System.Text.Encoding encoding = default(System.Text.Encoding), int bufferSize = default(int), bool leaveOpen = default(bool)) => throw null;
            public StreamWriter(string path) => throw null;
            public StreamWriter(string path, bool append) => throw null;
            public StreamWriter(string path, bool append, System.Text.Encoding encoding) => throw null;
            public StreamWriter(string path, bool append, System.Text.Encoding encoding, int bufferSize) => throw null;
            public override void Write(System.Char[] buffer) => throw null;
            public override void Write(System.Char[] buffer, int index, int count) => throw null;
            public override void Write(System.ReadOnlySpan<System.Char> buffer) => throw null;
            public override void Write(System.Char value) => throw null;
            public override void Write(string value) => throw null;
            public override void Write(string format, object arg0) => throw null;
            public override void Write(string format, object arg0, object arg1) => throw null;
            public override void Write(string format, object arg0, object arg1, object arg2) => throw null;
            public override void Write(string format, params object[] arg) => throw null;
            public override System.Threading.Tasks.Task WriteAsync(System.Char[] buffer, int index, int count) => throw null;
            public override System.Threading.Tasks.Task WriteAsync(System.ReadOnlyMemory<System.Char> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteAsync(System.Char value) => throw null;
            public override System.Threading.Tasks.Task WriteAsync(string value) => throw null;
            public override void WriteLine(System.ReadOnlySpan<System.Char> buffer) => throw null;
            public override void WriteLine(string value) => throw null;
            public override void WriteLine(string format, object arg0) => throw null;
            public override void WriteLine(string format, object arg0, object arg1) => throw null;
            public override void WriteLine(string format, object arg0, object arg1, object arg2) => throw null;
            public override void WriteLine(string format, params object[] arg) => throw null;
            public override System.Threading.Tasks.Task WriteLineAsync() => throw null;
            public override System.Threading.Tasks.Task WriteLineAsync(System.Char[] buffer, int index, int count) => throw null;
            public override System.Threading.Tasks.Task WriteLineAsync(System.ReadOnlyMemory<System.Char> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteLineAsync(System.Char value) => throw null;
            public override System.Threading.Tasks.Task WriteLineAsync(string value) => throw null;
        }

        // Generated from `System.IO.StringReader` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class StringReader : System.IO.TextReader
        {
            public override void Close() => throw null;
            protected override void Dispose(bool disposing) => throw null;
            public override int Peek() => throw null;
            public override int Read() => throw null;
            public override int Read(System.Char[] buffer, int index, int count) => throw null;
            public override int Read(System.Span<System.Char> buffer) => throw null;
            public override System.Threading.Tasks.Task<int> ReadAsync(System.Char[] buffer, int index, int count) => throw null;
            public override System.Threading.Tasks.ValueTask<int> ReadAsync(System.Memory<System.Char> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override int ReadBlock(System.Span<System.Char> buffer) => throw null;
            public override System.Threading.Tasks.Task<int> ReadBlockAsync(System.Char[] buffer, int index, int count) => throw null;
            public override System.Threading.Tasks.ValueTask<int> ReadBlockAsync(System.Memory<System.Char> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override string ReadLine() => throw null;
            public override System.Threading.Tasks.Task<string> ReadLineAsync() => throw null;
            public override string ReadToEnd() => throw null;
            public override System.Threading.Tasks.Task<string> ReadToEndAsync() => throw null;
            public StringReader(string s) => throw null;
        }

        // Generated from `System.IO.StringWriter` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class StringWriter : System.IO.TextWriter
        {
            public override void Close() => throw null;
            protected override void Dispose(bool disposing) => throw null;
            public override System.Text.Encoding Encoding { get => throw null; }
            public override System.Threading.Tasks.Task FlushAsync() => throw null;
            public virtual System.Text.StringBuilder GetStringBuilder() => throw null;
            public StringWriter() => throw null;
            public StringWriter(System.IFormatProvider formatProvider) => throw null;
            public StringWriter(System.Text.StringBuilder sb) => throw null;
            public StringWriter(System.Text.StringBuilder sb, System.IFormatProvider formatProvider) => throw null;
            public override string ToString() => throw null;
            public override void Write(System.Char[] buffer, int index, int count) => throw null;
            public override void Write(System.ReadOnlySpan<System.Char> buffer) => throw null;
            public override void Write(System.Text.StringBuilder value) => throw null;
            public override void Write(System.Char value) => throw null;
            public override void Write(string value) => throw null;
            public override System.Threading.Tasks.Task WriteAsync(System.Char[] buffer, int index, int count) => throw null;
            public override System.Threading.Tasks.Task WriteAsync(System.ReadOnlyMemory<System.Char> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteAsync(System.Text.StringBuilder value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteAsync(System.Char value) => throw null;
            public override System.Threading.Tasks.Task WriteAsync(string value) => throw null;
            public override void WriteLine(System.ReadOnlySpan<System.Char> buffer) => throw null;
            public override void WriteLine(System.Text.StringBuilder value) => throw null;
            public override System.Threading.Tasks.Task WriteLineAsync(System.Char[] buffer, int index, int count) => throw null;
            public override System.Threading.Tasks.Task WriteLineAsync(System.ReadOnlyMemory<System.Char> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteLineAsync(System.Text.StringBuilder value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteLineAsync(System.Char value) => throw null;
            public override System.Threading.Tasks.Task WriteLineAsync(string value) => throw null;
        }

        // Generated from `System.IO.TextReader` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class TextReader : System.MarshalByRefObject, System.IDisposable
        {
            public virtual void Close() => throw null;
            public void Dispose() => throw null;
            protected virtual void Dispose(bool disposing) => throw null;
            public static System.IO.TextReader Null;
            public virtual int Peek() => throw null;
            public virtual int Read() => throw null;
            public virtual int Read(System.Char[] buffer, int index, int count) => throw null;
            public virtual int Read(System.Span<System.Char> buffer) => throw null;
            public virtual System.Threading.Tasks.Task<int> ReadAsync(System.Char[] buffer, int index, int count) => throw null;
            public virtual System.Threading.Tasks.ValueTask<int> ReadAsync(System.Memory<System.Char> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual int ReadBlock(System.Char[] buffer, int index, int count) => throw null;
            public virtual int ReadBlock(System.Span<System.Char> buffer) => throw null;
            public virtual System.Threading.Tasks.Task<int> ReadBlockAsync(System.Char[] buffer, int index, int count) => throw null;
            public virtual System.Threading.Tasks.ValueTask<int> ReadBlockAsync(System.Memory<System.Char> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual string ReadLine() => throw null;
            public virtual System.Threading.Tasks.Task<string> ReadLineAsync() => throw null;
            public virtual string ReadToEnd() => throw null;
            public virtual System.Threading.Tasks.Task<string> ReadToEndAsync() => throw null;
            public static System.IO.TextReader Synchronized(System.IO.TextReader reader) => throw null;
            protected TextReader() => throw null;
        }

        // Generated from `System.IO.TextWriter` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class TextWriter : System.MarshalByRefObject, System.IAsyncDisposable, System.IDisposable
        {
            public virtual void Close() => throw null;
            protected System.Char[] CoreNewLine;
            public void Dispose() => throw null;
            protected virtual void Dispose(bool disposing) => throw null;
            public virtual System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
            public abstract System.Text.Encoding Encoding { get; }
            public virtual void Flush() => throw null;
            public virtual System.Threading.Tasks.Task FlushAsync() => throw null;
            public virtual System.IFormatProvider FormatProvider { get => throw null; }
            public virtual string NewLine { get => throw null; set => throw null; }
            public static System.IO.TextWriter Null;
            public static System.IO.TextWriter Synchronized(System.IO.TextWriter writer) => throw null;
            protected TextWriter() => throw null;
            protected TextWriter(System.IFormatProvider formatProvider) => throw null;
            public virtual void Write(System.Char[] buffer) => throw null;
            public virtual void Write(System.Char[] buffer, int index, int count) => throw null;
            public virtual void Write(System.ReadOnlySpan<System.Char> buffer) => throw null;
            public virtual void Write(System.Text.StringBuilder value) => throw null;
            public virtual void Write(bool value) => throw null;
            public virtual void Write(System.Char value) => throw null;
            public virtual void Write(System.Decimal value) => throw null;
            public virtual void Write(double value) => throw null;
            public virtual void Write(float value) => throw null;
            public virtual void Write(int value) => throw null;
            public virtual void Write(System.Int64 value) => throw null;
            public virtual void Write(object value) => throw null;
            public virtual void Write(string value) => throw null;
            public virtual void Write(string format, object arg0) => throw null;
            public virtual void Write(string format, object arg0, object arg1) => throw null;
            public virtual void Write(string format, object arg0, object arg1, object arg2) => throw null;
            public virtual void Write(string format, params object[] arg) => throw null;
            public virtual void Write(System.UInt32 value) => throw null;
            public virtual void Write(System.UInt64 value) => throw null;
            public System.Threading.Tasks.Task WriteAsync(System.Char[] buffer) => throw null;
            public virtual System.Threading.Tasks.Task WriteAsync(System.Char[] buffer, int index, int count) => throw null;
            public virtual System.Threading.Tasks.Task WriteAsync(System.ReadOnlyMemory<System.Char> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteAsync(System.Text.StringBuilder value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteAsync(System.Char value) => throw null;
            public virtual System.Threading.Tasks.Task WriteAsync(string value) => throw null;
            public virtual void WriteLine() => throw null;
            public virtual void WriteLine(System.Char[] buffer) => throw null;
            public virtual void WriteLine(System.Char[] buffer, int index, int count) => throw null;
            public virtual void WriteLine(System.ReadOnlySpan<System.Char> buffer) => throw null;
            public virtual void WriteLine(System.Text.StringBuilder value) => throw null;
            public virtual void WriteLine(bool value) => throw null;
            public virtual void WriteLine(System.Char value) => throw null;
            public virtual void WriteLine(System.Decimal value) => throw null;
            public virtual void WriteLine(double value) => throw null;
            public virtual void WriteLine(float value) => throw null;
            public virtual void WriteLine(int value) => throw null;
            public virtual void WriteLine(System.Int64 value) => throw null;
            public virtual void WriteLine(object value) => throw null;
            public virtual void WriteLine(string value) => throw null;
            public virtual void WriteLine(string format, object arg0) => throw null;
            public virtual void WriteLine(string format, object arg0, object arg1) => throw null;
            public virtual void WriteLine(string format, object arg0, object arg1, object arg2) => throw null;
            public virtual void WriteLine(string format, params object[] arg) => throw null;
            public virtual void WriteLine(System.UInt32 value) => throw null;
            public virtual void WriteLine(System.UInt64 value) => throw null;
            public virtual System.Threading.Tasks.Task WriteLineAsync() => throw null;
            public System.Threading.Tasks.Task WriteLineAsync(System.Char[] buffer) => throw null;
            public virtual System.Threading.Tasks.Task WriteLineAsync(System.Char[] buffer, int index, int count) => throw null;
            public virtual System.Threading.Tasks.Task WriteLineAsync(System.ReadOnlyMemory<System.Char> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteLineAsync(System.Text.StringBuilder value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteLineAsync(System.Char value) => throw null;
            public virtual System.Threading.Tasks.Task WriteLineAsync(string value) => throw null;
        }

        // Generated from `System.IO.UnmanagedMemoryStream` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class UnmanagedMemoryStream : System.IO.Stream
        {
            public override bool CanRead { get => throw null; }
            public override bool CanSeek { get => throw null; }
            public override bool CanWrite { get => throw null; }
            public System.Int64 Capacity { get => throw null; }
            protected override void Dispose(bool disposing) => throw null;
            public override void Flush() => throw null;
            public override System.Threading.Tasks.Task FlushAsync(System.Threading.CancellationToken cancellationToken) => throw null;
            protected void Initialize(System.Runtime.InteropServices.SafeBuffer buffer, System.Int64 offset, System.Int64 length, System.IO.FileAccess access) => throw null;
            unsafe protected void Initialize(System.Byte* pointer, System.Int64 length, System.Int64 capacity, System.IO.FileAccess access) => throw null;
            public override System.Int64 Length { get => throw null; }
            public override System.Int64 Position { get => throw null; set => throw null; }
            unsafe public System.Byte* PositionPointer { get => throw null; set => throw null; }
            public override int Read(System.Byte[] buffer, int offset, int count) => throw null;
            public override int Read(System.Span<System.Byte> destination) => throw null;
            public override System.Threading.Tasks.Task<int> ReadAsync(System.Byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
            public override System.Threading.Tasks.ValueTask<int> ReadAsync(System.Memory<System.Byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override int ReadByte() => throw null;
            public override System.Int64 Seek(System.Int64 offset, System.IO.SeekOrigin loc) => throw null;
            public override void SetLength(System.Int64 value) => throw null;
            protected UnmanagedMemoryStream() => throw null;
            public UnmanagedMemoryStream(System.Runtime.InteropServices.SafeBuffer buffer, System.Int64 offset, System.Int64 length) => throw null;
            public UnmanagedMemoryStream(System.Runtime.InteropServices.SafeBuffer buffer, System.Int64 offset, System.Int64 length, System.IO.FileAccess access) => throw null;
            unsafe public UnmanagedMemoryStream(System.Byte* pointer, System.Int64 length) => throw null;
            unsafe public UnmanagedMemoryStream(System.Byte* pointer, System.Int64 length, System.Int64 capacity, System.IO.FileAccess access) => throw null;
            public override void Write(System.Byte[] buffer, int offset, int count) => throw null;
            public override void Write(System.ReadOnlySpan<System.Byte> source) => throw null;
            public override System.Threading.Tasks.Task WriteAsync(System.Byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
            public override System.Threading.Tasks.ValueTask WriteAsync(System.ReadOnlyMemory<System.Byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override void WriteByte(System.Byte value) => throw null;
        }

    }
    namespace Net
    {
        // Generated from `System.Net.WebUtility` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public static class WebUtility
        {
            public static string HtmlDecode(string value) => throw null;
            public static void HtmlDecode(string value, System.IO.TextWriter output) => throw null;
            public static string HtmlEncode(string value) => throw null;
            public static void HtmlEncode(string value, System.IO.TextWriter output) => throw null;
            public static string UrlDecode(string encodedValue) => throw null;
            public static System.Byte[] UrlDecodeToBytes(System.Byte[] encodedValue, int offset, int count) => throw null;
            public static string UrlEncode(string value) => throw null;
            public static System.Byte[] UrlEncodeToBytes(System.Byte[] value, int offset, int count) => throw null;
        }

    }
    namespace Numerics
    {
        // Generated from `System.Numerics.BitOperations` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public static class BitOperations
        {
            public static int LeadingZeroCount(System.UInt32 value) => throw null;
            public static int LeadingZeroCount(System.UInt64 value) => throw null;
            public static int Log2(System.UInt32 value) => throw null;
            public static int Log2(System.UInt64 value) => throw null;
            public static int PopCount(System.UInt32 value) => throw null;
            public static int PopCount(System.UInt64 value) => throw null;
            public static System.UInt32 RotateLeft(System.UInt32 value, int offset) => throw null;
            public static System.UInt64 RotateLeft(System.UInt64 value, int offset) => throw null;
            public static System.UInt32 RotateRight(System.UInt32 value, int offset) => throw null;
            public static System.UInt64 RotateRight(System.UInt64 value, int offset) => throw null;
            public static int TrailingZeroCount(int value) => throw null;
            public static int TrailingZeroCount(System.Int64 value) => throw null;
            public static int TrailingZeroCount(System.UInt32 value) => throw null;
            public static int TrailingZeroCount(System.UInt64 value) => throw null;
        }

    }
    namespace Reflection
    {
        // Generated from `System.Reflection.AmbiguousMatchException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class AmbiguousMatchException : System.SystemException
        {
            public AmbiguousMatchException() => throw null;
            public AmbiguousMatchException(string message) => throw null;
            public AmbiguousMatchException(string message, System.Exception inner) => throw null;
        }

        // Generated from `System.Reflection.Assembly` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class Assembly : System.Reflection.ICustomAttributeProvider, System.Runtime.Serialization.ISerializable
        {
            public static bool operator !=(System.Reflection.Assembly left, System.Reflection.Assembly right) => throw null;
            public static bool operator ==(System.Reflection.Assembly left, System.Reflection.Assembly right) => throw null;
            protected Assembly() => throw null;
            public virtual string CodeBase { get => throw null; }
            public object CreateInstance(string typeName) => throw null;
            public object CreateInstance(string typeName, bool ignoreCase) => throw null;
            public virtual object CreateInstance(string typeName, bool ignoreCase, System.Reflection.BindingFlags bindingAttr, System.Reflection.Binder binder, object[] args, System.Globalization.CultureInfo culture, object[] activationAttributes) => throw null;
            public static string CreateQualifiedName(string assemblyName, string typeName) => throw null;
            public virtual System.Collections.Generic.IEnumerable<System.Reflection.CustomAttributeData> CustomAttributes { get => throw null; }
            public virtual System.Collections.Generic.IEnumerable<System.Reflection.TypeInfo> DefinedTypes { get => throw null; }
            public virtual System.Reflection.MethodInfo EntryPoint { get => throw null; }
            public override bool Equals(object o) => throw null;
            public virtual string EscapedCodeBase { get => throw null; }
            public virtual System.Collections.Generic.IEnumerable<System.Type> ExportedTypes { get => throw null; }
            public virtual string FullName { get => throw null; }
            public static System.Reflection.Assembly GetAssembly(System.Type type) => throw null;
            public static System.Reflection.Assembly GetCallingAssembly() => throw null;
            public virtual object[] GetCustomAttributes(System.Type attributeType, bool inherit) => throw null;
            public virtual object[] GetCustomAttributes(bool inherit) => throw null;
            public virtual System.Collections.Generic.IList<System.Reflection.CustomAttributeData> GetCustomAttributesData() => throw null;
            public static System.Reflection.Assembly GetEntryAssembly() => throw null;
            public static System.Reflection.Assembly GetExecutingAssembly() => throw null;
            public virtual System.Type[] GetExportedTypes() => throw null;
            public virtual System.IO.FileStream GetFile(string name) => throw null;
            public virtual System.IO.FileStream[] GetFiles() => throw null;
            public virtual System.IO.FileStream[] GetFiles(bool getResourceModules) => throw null;
            public virtual System.Type[] GetForwardedTypes() => throw null;
            public override int GetHashCode() => throw null;
            public System.Reflection.Module[] GetLoadedModules() => throw null;
            public virtual System.Reflection.Module[] GetLoadedModules(bool getResourceModules) => throw null;
            public virtual System.Reflection.ManifestResourceInfo GetManifestResourceInfo(string resourceName) => throw null;
            public virtual string[] GetManifestResourceNames() => throw null;
            public virtual System.IO.Stream GetManifestResourceStream(System.Type type, string name) => throw null;
            public virtual System.IO.Stream GetManifestResourceStream(string name) => throw null;
            public virtual System.Reflection.Module GetModule(string name) => throw null;
            public System.Reflection.Module[] GetModules() => throw null;
            public virtual System.Reflection.Module[] GetModules(bool getResourceModules) => throw null;
            public virtual System.Reflection.AssemblyName GetName() => throw null;
            public virtual System.Reflection.AssemblyName GetName(bool copiedName) => throw null;
            public virtual void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public virtual System.Reflection.AssemblyName[] GetReferencedAssemblies() => throw null;
            public virtual System.Reflection.Assembly GetSatelliteAssembly(System.Globalization.CultureInfo culture) => throw null;
            public virtual System.Reflection.Assembly GetSatelliteAssembly(System.Globalization.CultureInfo culture, System.Version version) => throw null;
            public virtual System.Type GetType(string name) => throw null;
            public virtual System.Type GetType(string name, bool throwOnError) => throw null;
            public virtual System.Type GetType(string name, bool throwOnError, bool ignoreCase) => throw null;
            public virtual System.Type[] GetTypes() => throw null;
            public virtual bool GlobalAssemblyCache { get => throw null; }
            public virtual System.Int64 HostContext { get => throw null; }
            public virtual string ImageRuntimeVersion { get => throw null; }
            public virtual bool IsCollectible { get => throw null; }
            public virtual bool IsDefined(System.Type attributeType, bool inherit) => throw null;
            public virtual bool IsDynamic { get => throw null; }
            public bool IsFullyTrusted { get => throw null; }
            public static System.Reflection.Assembly Load(System.Reflection.AssemblyName assemblyRef) => throw null;
            public static System.Reflection.Assembly Load(System.Byte[] rawAssembly) => throw null;
            public static System.Reflection.Assembly Load(System.Byte[] rawAssembly, System.Byte[] rawSymbolStore) => throw null;
            public static System.Reflection.Assembly Load(string assemblyString) => throw null;
            public static System.Reflection.Assembly LoadFile(string path) => throw null;
            public static System.Reflection.Assembly LoadFrom(string assemblyFile) => throw null;
            public static System.Reflection.Assembly LoadFrom(string assemblyFile, System.Byte[] hashValue, System.Configuration.Assemblies.AssemblyHashAlgorithm hashAlgorithm) => throw null;
            public System.Reflection.Module LoadModule(string moduleName, System.Byte[] rawModule) => throw null;
            public virtual System.Reflection.Module LoadModule(string moduleName, System.Byte[] rawModule, System.Byte[] rawSymbolStore) => throw null;
            public static System.Reflection.Assembly LoadWithPartialName(string partialName) => throw null;
            public virtual string Location { get => throw null; }
            public virtual System.Reflection.Module ManifestModule { get => throw null; }
            public virtual event System.Reflection.ModuleResolveEventHandler ModuleResolve;
            public virtual System.Collections.Generic.IEnumerable<System.Reflection.Module> Modules { get => throw null; }
            public virtual bool ReflectionOnly { get => throw null; }
            public static System.Reflection.Assembly ReflectionOnlyLoad(System.Byte[] rawAssembly) => throw null;
            public static System.Reflection.Assembly ReflectionOnlyLoad(string assemblyString) => throw null;
            public static System.Reflection.Assembly ReflectionOnlyLoadFrom(string assemblyFile) => throw null;
            public virtual System.Security.SecurityRuleSet SecurityRuleSet { get => throw null; }
            public override string ToString() => throw null;
            public static System.Reflection.Assembly UnsafeLoadFrom(string assemblyFile) => throw null;
        }

        // Generated from `System.Reflection.AssemblyAlgorithmIdAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class AssemblyAlgorithmIdAttribute : System.Attribute
        {
            public System.UInt32 AlgorithmId { get => throw null; }
            public AssemblyAlgorithmIdAttribute(System.Configuration.Assemblies.AssemblyHashAlgorithm algorithmId) => throw null;
            public AssemblyAlgorithmIdAttribute(System.UInt32 algorithmId) => throw null;
        }

        // Generated from `System.Reflection.AssemblyCompanyAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class AssemblyCompanyAttribute : System.Attribute
        {
            public AssemblyCompanyAttribute(string company) => throw null;
            public string Company { get => throw null; }
        }

        // Generated from `System.Reflection.AssemblyConfigurationAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class AssemblyConfigurationAttribute : System.Attribute
        {
            public AssemblyConfigurationAttribute(string configuration) => throw null;
            public string Configuration { get => throw null; }
        }

        // Generated from `System.Reflection.AssemblyContentType` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum AssemblyContentType
        {
            Default,
            WindowsRuntime,
        }

        // Generated from `System.Reflection.AssemblyCopyrightAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class AssemblyCopyrightAttribute : System.Attribute
        {
            public AssemblyCopyrightAttribute(string copyright) => throw null;
            public string Copyright { get => throw null; }
        }

        // Generated from `System.Reflection.AssemblyCultureAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class AssemblyCultureAttribute : System.Attribute
        {
            public AssemblyCultureAttribute(string culture) => throw null;
            public string Culture { get => throw null; }
        }

        // Generated from `System.Reflection.AssemblyDefaultAliasAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class AssemblyDefaultAliasAttribute : System.Attribute
        {
            public AssemblyDefaultAliasAttribute(string defaultAlias) => throw null;
            public string DefaultAlias { get => throw null; }
        }

        // Generated from `System.Reflection.AssemblyDelaySignAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class AssemblyDelaySignAttribute : System.Attribute
        {
            public AssemblyDelaySignAttribute(bool delaySign) => throw null;
            public bool DelaySign { get => throw null; }
        }

        // Generated from `System.Reflection.AssemblyDescriptionAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class AssemblyDescriptionAttribute : System.Attribute
        {
            public AssemblyDescriptionAttribute(string description) => throw null;
            public string Description { get => throw null; }
        }

        // Generated from `System.Reflection.AssemblyFileVersionAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class AssemblyFileVersionAttribute : System.Attribute
        {
            public AssemblyFileVersionAttribute(string version) => throw null;
            public string Version { get => throw null; }
        }

        // Generated from `System.Reflection.AssemblyFlagsAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class AssemblyFlagsAttribute : System.Attribute
        {
            public int AssemblyFlags { get => throw null; }
            public AssemblyFlagsAttribute(System.Reflection.AssemblyNameFlags assemblyFlags) => throw null;
            public AssemblyFlagsAttribute(int assemblyFlags) => throw null;
            public AssemblyFlagsAttribute(System.UInt32 flags) => throw null;
            public System.UInt32 Flags { get => throw null; }
        }

        // Generated from `System.Reflection.AssemblyInformationalVersionAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class AssemblyInformationalVersionAttribute : System.Attribute
        {
            public AssemblyInformationalVersionAttribute(string informationalVersion) => throw null;
            public string InformationalVersion { get => throw null; }
        }

        // Generated from `System.Reflection.AssemblyKeyFileAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class AssemblyKeyFileAttribute : System.Attribute
        {
            public AssemblyKeyFileAttribute(string keyFile) => throw null;
            public string KeyFile { get => throw null; }
        }

        // Generated from `System.Reflection.AssemblyKeyNameAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class AssemblyKeyNameAttribute : System.Attribute
        {
            public AssemblyKeyNameAttribute(string keyName) => throw null;
            public string KeyName { get => throw null; }
        }

        // Generated from `System.Reflection.AssemblyMetadataAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class AssemblyMetadataAttribute : System.Attribute
        {
            public AssemblyMetadataAttribute(string key, string value) => throw null;
            public string Key { get => throw null; }
            public string Value { get => throw null; }
        }

        // Generated from `System.Reflection.AssemblyName` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class AssemblyName : System.ICloneable, System.Runtime.Serialization.IDeserializationCallback, System.Runtime.Serialization.ISerializable
        {
            public AssemblyName() => throw null;
            public AssemblyName(string assemblyName) => throw null;
            public object Clone() => throw null;
            public string CodeBase { get => throw null; set => throw null; }
            public System.Reflection.AssemblyContentType ContentType { get => throw null; set => throw null; }
            public System.Globalization.CultureInfo CultureInfo { get => throw null; set => throw null; }
            public string CultureName { get => throw null; set => throw null; }
            public string EscapedCodeBase { get => throw null; }
            public System.Reflection.AssemblyNameFlags Flags { get => throw null; set => throw null; }
            public string FullName { get => throw null; }
            public static System.Reflection.AssemblyName GetAssemblyName(string assemblyFile) => throw null;
            public void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public System.Byte[] GetPublicKey() => throw null;
            public System.Byte[] GetPublicKeyToken() => throw null;
            public System.Configuration.Assemblies.AssemblyHashAlgorithm HashAlgorithm { get => throw null; set => throw null; }
            public System.Reflection.StrongNameKeyPair KeyPair { get => throw null; set => throw null; }
            public string Name { get => throw null; set => throw null; }
            public void OnDeserialization(object sender) => throw null;
            public System.Reflection.ProcessorArchitecture ProcessorArchitecture { get => throw null; set => throw null; }
            public static bool ReferenceMatchesDefinition(System.Reflection.AssemblyName reference, System.Reflection.AssemblyName definition) => throw null;
            public void SetPublicKey(System.Byte[] publicKey) => throw null;
            public void SetPublicKeyToken(System.Byte[] publicKeyToken) => throw null;
            public override string ToString() => throw null;
            public System.Version Version { get => throw null; set => throw null; }
            public System.Configuration.Assemblies.AssemblyVersionCompatibility VersionCompatibility { get => throw null; set => throw null; }
        }

        // Generated from `System.Reflection.AssemblyNameFlags` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum AssemblyNameFlags
        {
            EnableJITcompileOptimizer,
            EnableJITcompileTracking,
            None,
            PublicKey,
            Retargetable,
        }

        // Generated from `System.Reflection.AssemblyNameProxy` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class AssemblyNameProxy : System.MarshalByRefObject
        {
            public AssemblyNameProxy() => throw null;
            public System.Reflection.AssemblyName GetAssemblyName(string assemblyFile) => throw null;
        }

        // Generated from `System.Reflection.AssemblyProductAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class AssemblyProductAttribute : System.Attribute
        {
            public AssemblyProductAttribute(string product) => throw null;
            public string Product { get => throw null; }
        }

        // Generated from `System.Reflection.AssemblySignatureKeyAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class AssemblySignatureKeyAttribute : System.Attribute
        {
            public AssemblySignatureKeyAttribute(string publicKey, string countersignature) => throw null;
            public string Countersignature { get => throw null; }
            public string PublicKey { get => throw null; }
        }

        // Generated from `System.Reflection.AssemblyTitleAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class AssemblyTitleAttribute : System.Attribute
        {
            public AssemblyTitleAttribute(string title) => throw null;
            public string Title { get => throw null; }
        }

        // Generated from `System.Reflection.AssemblyTrademarkAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class AssemblyTrademarkAttribute : System.Attribute
        {
            public AssemblyTrademarkAttribute(string trademark) => throw null;
            public string Trademark { get => throw null; }
        }

        // Generated from `System.Reflection.AssemblyVersionAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class AssemblyVersionAttribute : System.Attribute
        {
            public AssemblyVersionAttribute(string version) => throw null;
            public string Version { get => throw null; }
        }

        // Generated from `System.Reflection.Binder` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class Binder
        {
            public abstract System.Reflection.FieldInfo BindToField(System.Reflection.BindingFlags bindingAttr, System.Reflection.FieldInfo[] match, object value, System.Globalization.CultureInfo culture);
            public abstract System.Reflection.MethodBase BindToMethod(System.Reflection.BindingFlags bindingAttr, System.Reflection.MethodBase[] match, ref object[] args, System.Reflection.ParameterModifier[] modifiers, System.Globalization.CultureInfo culture, string[] names, out object state);
            protected Binder() => throw null;
            public abstract object ChangeType(object value, System.Type type, System.Globalization.CultureInfo culture);
            public abstract void ReorderArgumentArray(ref object[] args, object state);
            public abstract System.Reflection.MethodBase SelectMethod(System.Reflection.BindingFlags bindingAttr, System.Reflection.MethodBase[] match, System.Type[] types, System.Reflection.ParameterModifier[] modifiers);
            public abstract System.Reflection.PropertyInfo SelectProperty(System.Reflection.BindingFlags bindingAttr, System.Reflection.PropertyInfo[] match, System.Type returnType, System.Type[] indexes, System.Reflection.ParameterModifier[] modifiers);
        }

        // Generated from `System.Reflection.BindingFlags` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum BindingFlags
        {
            CreateInstance,
            DeclaredOnly,
            Default,
            DoNotWrapExceptions,
            ExactBinding,
            FlattenHierarchy,
            GetField,
            GetProperty,
            IgnoreCase,
            IgnoreReturn,
            Instance,
            InvokeMethod,
            NonPublic,
            OptionalParamBinding,
            Public,
            PutDispProperty,
            PutRefDispProperty,
            SetField,
            SetProperty,
            Static,
            SuppressChangeType,
        }

        // Generated from `System.Reflection.CallingConventions` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum CallingConventions
        {
            Any,
            ExplicitThis,
            HasThis,
            Standard,
            VarArgs,
        }

        // Generated from `System.Reflection.ConstructorInfo` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class ConstructorInfo : System.Reflection.MethodBase
        {
            public static bool operator !=(System.Reflection.ConstructorInfo left, System.Reflection.ConstructorInfo right) => throw null;
            public static bool operator ==(System.Reflection.ConstructorInfo left, System.Reflection.ConstructorInfo right) => throw null;
            protected ConstructorInfo() => throw null;
            public static string ConstructorName;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public abstract object Invoke(System.Reflection.BindingFlags invokeAttr, System.Reflection.Binder binder, object[] parameters, System.Globalization.CultureInfo culture);
            public object Invoke(object[] parameters) => throw null;
            public override System.Reflection.MemberTypes MemberType { get => throw null; }
            public static string TypeConstructorName;
        }

        // Generated from `System.Reflection.CustomAttributeData` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class CustomAttributeData
        {
            public virtual System.Type AttributeType { get => throw null; }
            public virtual System.Reflection.ConstructorInfo Constructor { get => throw null; }
            public virtual System.Collections.Generic.IList<System.Reflection.CustomAttributeTypedArgument> ConstructorArguments { get => throw null; }
            protected CustomAttributeData() => throw null;
            public override bool Equals(object obj) => throw null;
            public static System.Collections.Generic.IList<System.Reflection.CustomAttributeData> GetCustomAttributes(System.Reflection.Assembly target) => throw null;
            public static System.Collections.Generic.IList<System.Reflection.CustomAttributeData> GetCustomAttributes(System.Reflection.MemberInfo target) => throw null;
            public static System.Collections.Generic.IList<System.Reflection.CustomAttributeData> GetCustomAttributes(System.Reflection.Module target) => throw null;
            public static System.Collections.Generic.IList<System.Reflection.CustomAttributeData> GetCustomAttributes(System.Reflection.ParameterInfo target) => throw null;
            public override int GetHashCode() => throw null;
            public virtual System.Collections.Generic.IList<System.Reflection.CustomAttributeNamedArgument> NamedArguments { get => throw null; }
            public override string ToString() => throw null;
        }

        // Generated from `System.Reflection.CustomAttributeExtensions` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public static class CustomAttributeExtensions
        {
            public static System.Attribute GetCustomAttribute(this System.Reflection.Assembly element, System.Type attributeType) => throw null;
            public static System.Attribute GetCustomAttribute(this System.Reflection.MemberInfo element, System.Type attributeType) => throw null;
            public static System.Attribute GetCustomAttribute(this System.Reflection.MemberInfo element, System.Type attributeType, bool inherit) => throw null;
            public static System.Attribute GetCustomAttribute(this System.Reflection.Module element, System.Type attributeType) => throw null;
            public static System.Attribute GetCustomAttribute(this System.Reflection.ParameterInfo element, System.Type attributeType) => throw null;
            public static System.Attribute GetCustomAttribute(this System.Reflection.ParameterInfo element, System.Type attributeType, bool inherit) => throw null;
            public static T GetCustomAttribute<T>(this System.Reflection.Assembly element) where T : System.Attribute => throw null;
            public static T GetCustomAttribute<T>(this System.Reflection.MemberInfo element) where T : System.Attribute => throw null;
            public static T GetCustomAttribute<T>(this System.Reflection.MemberInfo element, bool inherit) where T : System.Attribute => throw null;
            public static T GetCustomAttribute<T>(this System.Reflection.Module element) where T : System.Attribute => throw null;
            public static T GetCustomAttribute<T>(this System.Reflection.ParameterInfo element) where T : System.Attribute => throw null;
            public static T GetCustomAttribute<T>(this System.Reflection.ParameterInfo element, bool inherit) where T : System.Attribute => throw null;
            public static System.Collections.Generic.IEnumerable<System.Attribute> GetCustomAttributes(this System.Reflection.Assembly element) => throw null;
            public static System.Collections.Generic.IEnumerable<System.Attribute> GetCustomAttributes(this System.Reflection.Assembly element, System.Type attributeType) => throw null;
            public static System.Collections.Generic.IEnumerable<System.Attribute> GetCustomAttributes(this System.Reflection.MemberInfo element) => throw null;
            public static System.Collections.Generic.IEnumerable<System.Attribute> GetCustomAttributes(this System.Reflection.MemberInfo element, System.Type attributeType) => throw null;
            public static System.Collections.Generic.IEnumerable<System.Attribute> GetCustomAttributes(this System.Reflection.MemberInfo element, System.Type attributeType, bool inherit) => throw null;
            public static System.Collections.Generic.IEnumerable<System.Attribute> GetCustomAttributes(this System.Reflection.MemberInfo element, bool inherit) => throw null;
            public static System.Collections.Generic.IEnumerable<System.Attribute> GetCustomAttributes(this System.Reflection.Module element) => throw null;
            public static System.Collections.Generic.IEnumerable<System.Attribute> GetCustomAttributes(this System.Reflection.Module element, System.Type attributeType) => throw null;
            public static System.Collections.Generic.IEnumerable<System.Attribute> GetCustomAttributes(this System.Reflection.ParameterInfo element) => throw null;
            public static System.Collections.Generic.IEnumerable<System.Attribute> GetCustomAttributes(this System.Reflection.ParameterInfo element, System.Type attributeType) => throw null;
            public static System.Collections.Generic.IEnumerable<System.Attribute> GetCustomAttributes(this System.Reflection.ParameterInfo element, System.Type attributeType, bool inherit) => throw null;
            public static System.Collections.Generic.IEnumerable<System.Attribute> GetCustomAttributes(this System.Reflection.ParameterInfo element, bool inherit) => throw null;
            public static System.Collections.Generic.IEnumerable<T> GetCustomAttributes<T>(this System.Reflection.Assembly element) where T : System.Attribute => throw null;
            public static System.Collections.Generic.IEnumerable<T> GetCustomAttributes<T>(this System.Reflection.MemberInfo element) where T : System.Attribute => throw null;
            public static System.Collections.Generic.IEnumerable<T> GetCustomAttributes<T>(this System.Reflection.MemberInfo element, bool inherit) where T : System.Attribute => throw null;
            public static System.Collections.Generic.IEnumerable<T> GetCustomAttributes<T>(this System.Reflection.Module element) where T : System.Attribute => throw null;
            public static System.Collections.Generic.IEnumerable<T> GetCustomAttributes<T>(this System.Reflection.ParameterInfo element) where T : System.Attribute => throw null;
            public static System.Collections.Generic.IEnumerable<T> GetCustomAttributes<T>(this System.Reflection.ParameterInfo element, bool inherit) where T : System.Attribute => throw null;
            public static bool IsDefined(this System.Reflection.Assembly element, System.Type attributeType) => throw null;
            public static bool IsDefined(this System.Reflection.MemberInfo element, System.Type attributeType) => throw null;
            public static bool IsDefined(this System.Reflection.MemberInfo element, System.Type attributeType, bool inherit) => throw null;
            public static bool IsDefined(this System.Reflection.Module element, System.Type attributeType) => throw null;
            public static bool IsDefined(this System.Reflection.ParameterInfo element, System.Type attributeType) => throw null;
            public static bool IsDefined(this System.Reflection.ParameterInfo element, System.Type attributeType, bool inherit) => throw null;
        }

        // Generated from `System.Reflection.CustomAttributeFormatException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class CustomAttributeFormatException : System.FormatException
        {
            public CustomAttributeFormatException() => throw null;
            protected CustomAttributeFormatException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public CustomAttributeFormatException(string message) => throw null;
            public CustomAttributeFormatException(string message, System.Exception inner) => throw null;
        }

        // Generated from `System.Reflection.CustomAttributeNamedArgument` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public struct CustomAttributeNamedArgument
        {
            public static bool operator !=(System.Reflection.CustomAttributeNamedArgument left, System.Reflection.CustomAttributeNamedArgument right) => throw null;
            public static bool operator ==(System.Reflection.CustomAttributeNamedArgument left, System.Reflection.CustomAttributeNamedArgument right) => throw null;
            // Stub generator skipped constructor 
            public CustomAttributeNamedArgument(System.Reflection.MemberInfo memberInfo, System.Reflection.CustomAttributeTypedArgument typedArgument) => throw null;
            public CustomAttributeNamedArgument(System.Reflection.MemberInfo memberInfo, object value) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public bool IsField { get => throw null; }
            public System.Reflection.MemberInfo MemberInfo { get => throw null; }
            public string MemberName { get => throw null; }
            public override string ToString() => throw null;
            public System.Reflection.CustomAttributeTypedArgument TypedValue { get => throw null; }
        }

        // Generated from `System.Reflection.CustomAttributeTypedArgument` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public struct CustomAttributeTypedArgument
        {
            public static bool operator !=(System.Reflection.CustomAttributeTypedArgument left, System.Reflection.CustomAttributeTypedArgument right) => throw null;
            public static bool operator ==(System.Reflection.CustomAttributeTypedArgument left, System.Reflection.CustomAttributeTypedArgument right) => throw null;
            public System.Type ArgumentType { get => throw null; }
            // Stub generator skipped constructor 
            public CustomAttributeTypedArgument(System.Type argumentType, object value) => throw null;
            public CustomAttributeTypedArgument(object value) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public override string ToString() => throw null;
            public object Value { get => throw null; }
        }

        // Generated from `System.Reflection.DefaultMemberAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DefaultMemberAttribute : System.Attribute
        {
            public DefaultMemberAttribute(string memberName) => throw null;
            public string MemberName { get => throw null; }
        }

        // Generated from `System.Reflection.EventAttributes` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum EventAttributes
        {
            None,
            RTSpecialName,
            ReservedMask,
            SpecialName,
        }

        // Generated from `System.Reflection.EventInfo` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class EventInfo : System.Reflection.MemberInfo
        {
            public static bool operator !=(System.Reflection.EventInfo left, System.Reflection.EventInfo right) => throw null;
            public static bool operator ==(System.Reflection.EventInfo left, System.Reflection.EventInfo right) => throw null;
            public virtual void AddEventHandler(object target, System.Delegate handler) => throw null;
            public virtual System.Reflection.MethodInfo AddMethod { get => throw null; }
            public abstract System.Reflection.EventAttributes Attributes { get; }
            public override bool Equals(object obj) => throw null;
            public virtual System.Type EventHandlerType { get => throw null; }
            protected EventInfo() => throw null;
            public System.Reflection.MethodInfo GetAddMethod() => throw null;
            public abstract System.Reflection.MethodInfo GetAddMethod(bool nonPublic);
            public override int GetHashCode() => throw null;
            public System.Reflection.MethodInfo[] GetOtherMethods() => throw null;
            public virtual System.Reflection.MethodInfo[] GetOtherMethods(bool nonPublic) => throw null;
            public System.Reflection.MethodInfo GetRaiseMethod() => throw null;
            public abstract System.Reflection.MethodInfo GetRaiseMethod(bool nonPublic);
            public System.Reflection.MethodInfo GetRemoveMethod() => throw null;
            public abstract System.Reflection.MethodInfo GetRemoveMethod(bool nonPublic);
            public virtual bool IsMulticast { get => throw null; }
            public bool IsSpecialName { get => throw null; }
            public override System.Reflection.MemberTypes MemberType { get => throw null; }
            public virtual System.Reflection.MethodInfo RaiseMethod { get => throw null; }
            public virtual void RemoveEventHandler(object target, System.Delegate handler) => throw null;
            public virtual System.Reflection.MethodInfo RemoveMethod { get => throw null; }
        }

        // Generated from `System.Reflection.ExceptionHandlingClause` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ExceptionHandlingClause
        {
            public virtual System.Type CatchType { get => throw null; }
            protected ExceptionHandlingClause() => throw null;
            public virtual int FilterOffset { get => throw null; }
            public virtual System.Reflection.ExceptionHandlingClauseOptions Flags { get => throw null; }
            public virtual int HandlerLength { get => throw null; }
            public virtual int HandlerOffset { get => throw null; }
            public override string ToString() => throw null;
            public virtual int TryLength { get => throw null; }
            public virtual int TryOffset { get => throw null; }
        }

        // Generated from `System.Reflection.ExceptionHandlingClauseOptions` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum ExceptionHandlingClauseOptions
        {
            Clause,
            Fault,
            Filter,
            Finally,
        }

        // Generated from `System.Reflection.FieldAttributes` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum FieldAttributes
        {
            Assembly,
            FamANDAssem,
            FamORAssem,
            Family,
            FieldAccessMask,
            HasDefault,
            HasFieldMarshal,
            HasFieldRVA,
            InitOnly,
            Literal,
            NotSerialized,
            PinvokeImpl,
            Private,
            PrivateScope,
            Public,
            RTSpecialName,
            ReservedMask,
            SpecialName,
            Static,
        }

        // Generated from `System.Reflection.FieldInfo` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class FieldInfo : System.Reflection.MemberInfo
        {
            public static bool operator !=(System.Reflection.FieldInfo left, System.Reflection.FieldInfo right) => throw null;
            public static bool operator ==(System.Reflection.FieldInfo left, System.Reflection.FieldInfo right) => throw null;
            public abstract System.Reflection.FieldAttributes Attributes { get; }
            public override bool Equals(object obj) => throw null;
            public abstract System.RuntimeFieldHandle FieldHandle { get; }
            protected FieldInfo() => throw null;
            public abstract System.Type FieldType { get; }
            public static System.Reflection.FieldInfo GetFieldFromHandle(System.RuntimeFieldHandle handle) => throw null;
            public static System.Reflection.FieldInfo GetFieldFromHandle(System.RuntimeFieldHandle handle, System.RuntimeTypeHandle declaringType) => throw null;
            public override int GetHashCode() => throw null;
            public virtual System.Type[] GetOptionalCustomModifiers() => throw null;
            public virtual object GetRawConstantValue() => throw null;
            public virtual System.Type[] GetRequiredCustomModifiers() => throw null;
            public abstract object GetValue(object obj);
            public virtual object GetValueDirect(System.TypedReference obj) => throw null;
            public bool IsAssembly { get => throw null; }
            public bool IsFamily { get => throw null; }
            public bool IsFamilyAndAssembly { get => throw null; }
            public bool IsFamilyOrAssembly { get => throw null; }
            public bool IsInitOnly { get => throw null; }
            public bool IsLiteral { get => throw null; }
            public bool IsNotSerialized { get => throw null; }
            public bool IsPinvokeImpl { get => throw null; }
            public bool IsPrivate { get => throw null; }
            public bool IsPublic { get => throw null; }
            public virtual bool IsSecurityCritical { get => throw null; }
            public virtual bool IsSecuritySafeCritical { get => throw null; }
            public virtual bool IsSecurityTransparent { get => throw null; }
            public bool IsSpecialName { get => throw null; }
            public bool IsStatic { get => throw null; }
            public override System.Reflection.MemberTypes MemberType { get => throw null; }
            public void SetValue(object obj, object value) => throw null;
            public abstract void SetValue(object obj, object value, System.Reflection.BindingFlags invokeAttr, System.Reflection.Binder binder, System.Globalization.CultureInfo culture);
            public virtual void SetValueDirect(System.TypedReference obj, object value) => throw null;
        }

        // Generated from `System.Reflection.GenericParameterAttributes` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum GenericParameterAttributes
        {
            Contravariant,
            Covariant,
            DefaultConstructorConstraint,
            None,
            NotNullableValueTypeConstraint,
            ReferenceTypeConstraint,
            SpecialConstraintMask,
            VarianceMask,
        }

        // Generated from `System.Reflection.ICustomAttributeProvider` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface ICustomAttributeProvider
        {
            object[] GetCustomAttributes(System.Type attributeType, bool inherit);
            object[] GetCustomAttributes(bool inherit);
            bool IsDefined(System.Type attributeType, bool inherit);
        }

        // Generated from `System.Reflection.IReflect` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IReflect
        {
            System.Reflection.FieldInfo GetField(string name, System.Reflection.BindingFlags bindingAttr);
            System.Reflection.FieldInfo[] GetFields(System.Reflection.BindingFlags bindingAttr);
            System.Reflection.MemberInfo[] GetMember(string name, System.Reflection.BindingFlags bindingAttr);
            System.Reflection.MemberInfo[] GetMembers(System.Reflection.BindingFlags bindingAttr);
            System.Reflection.MethodInfo GetMethod(string name, System.Reflection.BindingFlags bindingAttr);
            System.Reflection.MethodInfo GetMethod(string name, System.Reflection.BindingFlags bindingAttr, System.Reflection.Binder binder, System.Type[] types, System.Reflection.ParameterModifier[] modifiers);
            System.Reflection.MethodInfo[] GetMethods(System.Reflection.BindingFlags bindingAttr);
            System.Reflection.PropertyInfo[] GetProperties(System.Reflection.BindingFlags bindingAttr);
            System.Reflection.PropertyInfo GetProperty(string name, System.Reflection.BindingFlags bindingAttr);
            System.Reflection.PropertyInfo GetProperty(string name, System.Reflection.BindingFlags bindingAttr, System.Reflection.Binder binder, System.Type returnType, System.Type[] types, System.Reflection.ParameterModifier[] modifiers);
            object InvokeMember(string name, System.Reflection.BindingFlags invokeAttr, System.Reflection.Binder binder, object target, object[] args, System.Reflection.ParameterModifier[] modifiers, System.Globalization.CultureInfo culture, string[] namedParameters);
            System.Type UnderlyingSystemType { get; }
        }

        // Generated from `System.Reflection.IReflectableType` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IReflectableType
        {
            System.Reflection.TypeInfo GetTypeInfo();
        }

        // Generated from `System.Reflection.ImageFileMachine` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum ImageFileMachine
        {
            AMD64,
            ARM,
            I386,
            IA64,
        }

        // Generated from `System.Reflection.InterfaceMapping` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public struct InterfaceMapping
        {
            // Stub generator skipped constructor 
            public System.Reflection.MethodInfo[] InterfaceMethods;
            public System.Type InterfaceType;
            public System.Reflection.MethodInfo[] TargetMethods;
            public System.Type TargetType;
        }

        // Generated from `System.Reflection.IntrospectionExtensions` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public static class IntrospectionExtensions
        {
            public static System.Reflection.TypeInfo GetTypeInfo(this System.Type type) => throw null;
        }

        // Generated from `System.Reflection.InvalidFilterCriteriaException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class InvalidFilterCriteriaException : System.ApplicationException
        {
            public InvalidFilterCriteriaException() => throw null;
            protected InvalidFilterCriteriaException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public InvalidFilterCriteriaException(string message) => throw null;
            public InvalidFilterCriteriaException(string message, System.Exception inner) => throw null;
        }

        // Generated from `System.Reflection.LocalVariableInfo` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class LocalVariableInfo
        {
            public virtual bool IsPinned { get => throw null; }
            public virtual int LocalIndex { get => throw null; }
            public virtual System.Type LocalType { get => throw null; }
            protected LocalVariableInfo() => throw null;
            public override string ToString() => throw null;
        }

        // Generated from `System.Reflection.ManifestResourceInfo` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ManifestResourceInfo
        {
            public virtual string FileName { get => throw null; }
            public ManifestResourceInfo(System.Reflection.Assembly containingAssembly, string containingFileName, System.Reflection.ResourceLocation resourceLocation) => throw null;
            public virtual System.Reflection.Assembly ReferencedAssembly { get => throw null; }
            public virtual System.Reflection.ResourceLocation ResourceLocation { get => throw null; }
        }

        // Generated from `System.Reflection.MemberFilter` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public delegate bool MemberFilter(System.Reflection.MemberInfo m, object filterCriteria);

        // Generated from `System.Reflection.MemberInfo` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class MemberInfo : System.Reflection.ICustomAttributeProvider
        {
            public static bool operator !=(System.Reflection.MemberInfo left, System.Reflection.MemberInfo right) => throw null;
            public static bool operator ==(System.Reflection.MemberInfo left, System.Reflection.MemberInfo right) => throw null;
            public virtual System.Collections.Generic.IEnumerable<System.Reflection.CustomAttributeData> CustomAttributes { get => throw null; }
            public abstract System.Type DeclaringType { get; }
            public override bool Equals(object obj) => throw null;
            public abstract object[] GetCustomAttributes(System.Type attributeType, bool inherit);
            public abstract object[] GetCustomAttributes(bool inherit);
            public virtual System.Collections.Generic.IList<System.Reflection.CustomAttributeData> GetCustomAttributesData() => throw null;
            public override int GetHashCode() => throw null;
            public virtual bool HasSameMetadataDefinitionAs(System.Reflection.MemberInfo other) => throw null;
            public virtual bool IsCollectible { get => throw null; }
            public abstract bool IsDefined(System.Type attributeType, bool inherit);
            protected MemberInfo() => throw null;
            public abstract System.Reflection.MemberTypes MemberType { get; }
            public virtual int MetadataToken { get => throw null; }
            public virtual System.Reflection.Module Module { get => throw null; }
            public abstract string Name { get; }
            public abstract System.Type ReflectedType { get; }
        }

        // Generated from `System.Reflection.MemberTypes` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum MemberTypes
        {
            All,
            Constructor,
            Custom,
            Event,
            Field,
            Method,
            NestedType,
            Property,
            TypeInfo,
        }

        // Generated from `System.Reflection.MethodAttributes` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum MethodAttributes
        {
            Abstract,
            Assembly,
            CheckAccessOnOverride,
            FamANDAssem,
            FamORAssem,
            Family,
            Final,
            HasSecurity,
            HideBySig,
            MemberAccessMask,
            NewSlot,
            PinvokeImpl,
            Private,
            PrivateScope,
            Public,
            RTSpecialName,
            RequireSecObject,
            ReservedMask,
            ReuseSlot,
            SpecialName,
            Static,
            UnmanagedExport,
            Virtual,
            VtableLayoutMask,
        }

        // Generated from `System.Reflection.MethodBase` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class MethodBase : System.Reflection.MemberInfo
        {
            public static bool operator !=(System.Reflection.MethodBase left, System.Reflection.MethodBase right) => throw null;
            public static bool operator ==(System.Reflection.MethodBase left, System.Reflection.MethodBase right) => throw null;
            public abstract System.Reflection.MethodAttributes Attributes { get; }
            public virtual System.Reflection.CallingConventions CallingConvention { get => throw null; }
            public virtual bool ContainsGenericParameters { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public static System.Reflection.MethodBase GetCurrentMethod() => throw null;
            public virtual System.Type[] GetGenericArguments() => throw null;
            public override int GetHashCode() => throw null;
            public virtual System.Reflection.MethodBody GetMethodBody() => throw null;
            public static System.Reflection.MethodBase GetMethodFromHandle(System.RuntimeMethodHandle handle) => throw null;
            public static System.Reflection.MethodBase GetMethodFromHandle(System.RuntimeMethodHandle handle, System.RuntimeTypeHandle declaringType) => throw null;
            public abstract System.Reflection.MethodImplAttributes GetMethodImplementationFlags();
            public abstract System.Reflection.ParameterInfo[] GetParameters();
            public abstract object Invoke(object obj, System.Reflection.BindingFlags invokeAttr, System.Reflection.Binder binder, object[] parameters, System.Globalization.CultureInfo culture);
            public object Invoke(object obj, object[] parameters) => throw null;
            public bool IsAbstract { get => throw null; }
            public bool IsAssembly { get => throw null; }
            public virtual bool IsConstructedGenericMethod { get => throw null; }
            public bool IsConstructor { get => throw null; }
            public bool IsFamily { get => throw null; }
            public bool IsFamilyAndAssembly { get => throw null; }
            public bool IsFamilyOrAssembly { get => throw null; }
            public bool IsFinal { get => throw null; }
            public virtual bool IsGenericMethod { get => throw null; }
            public virtual bool IsGenericMethodDefinition { get => throw null; }
            public bool IsHideBySig { get => throw null; }
            public bool IsPrivate { get => throw null; }
            public bool IsPublic { get => throw null; }
            public virtual bool IsSecurityCritical { get => throw null; }
            public virtual bool IsSecuritySafeCritical { get => throw null; }
            public virtual bool IsSecurityTransparent { get => throw null; }
            public bool IsSpecialName { get => throw null; }
            public bool IsStatic { get => throw null; }
            public bool IsVirtual { get => throw null; }
            protected MethodBase() => throw null;
            public abstract System.RuntimeMethodHandle MethodHandle { get; }
            public virtual System.Reflection.MethodImplAttributes MethodImplementationFlags { get => throw null; }
        }

        // Generated from `System.Reflection.MethodBody` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class MethodBody
        {
            public virtual System.Collections.Generic.IList<System.Reflection.ExceptionHandlingClause> ExceptionHandlingClauses { get => throw null; }
            public virtual System.Byte[] GetILAsByteArray() => throw null;
            public virtual bool InitLocals { get => throw null; }
            public virtual int LocalSignatureMetadataToken { get => throw null; }
            public virtual System.Collections.Generic.IList<System.Reflection.LocalVariableInfo> LocalVariables { get => throw null; }
            public virtual int MaxStackSize { get => throw null; }
            protected MethodBody() => throw null;
        }

        // Generated from `System.Reflection.MethodImplAttributes` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum MethodImplAttributes
        {
            AggressiveInlining,
            AggressiveOptimization,
            CodeTypeMask,
            ForwardRef,
            IL,
            InternalCall,
            Managed,
            ManagedMask,
            MaxMethodImplVal,
            Native,
            NoInlining,
            NoOptimization,
            OPTIL,
            PreserveSig,
            Runtime,
            Synchronized,
            Unmanaged,
        }

        // Generated from `System.Reflection.MethodInfo` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class MethodInfo : System.Reflection.MethodBase
        {
            public static bool operator !=(System.Reflection.MethodInfo left, System.Reflection.MethodInfo right) => throw null;
            public static bool operator ==(System.Reflection.MethodInfo left, System.Reflection.MethodInfo right) => throw null;
            public virtual System.Delegate CreateDelegate(System.Type delegateType) => throw null;
            public virtual System.Delegate CreateDelegate(System.Type delegateType, object target) => throw null;
            public T CreateDelegate<T>() where T : System.Delegate => throw null;
            public T CreateDelegate<T>(object target) where T : System.Delegate => throw null;
            public override bool Equals(object obj) => throw null;
            public abstract System.Reflection.MethodInfo GetBaseDefinition();
            public override System.Type[] GetGenericArguments() => throw null;
            public virtual System.Reflection.MethodInfo GetGenericMethodDefinition() => throw null;
            public override int GetHashCode() => throw null;
            public virtual System.Reflection.MethodInfo MakeGenericMethod(params System.Type[] typeArguments) => throw null;
            public override System.Reflection.MemberTypes MemberType { get => throw null; }
            protected MethodInfo() => throw null;
            public virtual System.Reflection.ParameterInfo ReturnParameter { get => throw null; }
            public virtual System.Type ReturnType { get => throw null; }
            public abstract System.Reflection.ICustomAttributeProvider ReturnTypeCustomAttributes { get; }
        }

        // Generated from `System.Reflection.Missing` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class Missing : System.Runtime.Serialization.ISerializable
        {
            void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public static System.Reflection.Missing Value;
        }

        // Generated from `System.Reflection.Module` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class Module : System.Reflection.ICustomAttributeProvider, System.Runtime.Serialization.ISerializable
        {
            public static bool operator !=(System.Reflection.Module left, System.Reflection.Module right) => throw null;
            public static bool operator ==(System.Reflection.Module left, System.Reflection.Module right) => throw null;
            public virtual System.Reflection.Assembly Assembly { get => throw null; }
            public virtual System.Collections.Generic.IEnumerable<System.Reflection.CustomAttributeData> CustomAttributes { get => throw null; }
            public override bool Equals(object o) => throw null;
            public static System.Reflection.TypeFilter FilterTypeName;
            public static System.Reflection.TypeFilter FilterTypeNameIgnoreCase;
            public virtual System.Type[] FindTypes(System.Reflection.TypeFilter filter, object filterCriteria) => throw null;
            public virtual string FullyQualifiedName { get => throw null; }
            public virtual object[] GetCustomAttributes(System.Type attributeType, bool inherit) => throw null;
            public virtual object[] GetCustomAttributes(bool inherit) => throw null;
            public virtual System.Collections.Generic.IList<System.Reflection.CustomAttributeData> GetCustomAttributesData() => throw null;
            public System.Reflection.FieldInfo GetField(string name) => throw null;
            public virtual System.Reflection.FieldInfo GetField(string name, System.Reflection.BindingFlags bindingAttr) => throw null;
            public System.Reflection.FieldInfo[] GetFields() => throw null;
            public virtual System.Reflection.FieldInfo[] GetFields(System.Reflection.BindingFlags bindingFlags) => throw null;
            public override int GetHashCode() => throw null;
            public System.Reflection.MethodInfo GetMethod(string name) => throw null;
            public System.Reflection.MethodInfo GetMethod(string name, System.Reflection.BindingFlags bindingAttr, System.Reflection.Binder binder, System.Reflection.CallingConventions callConvention, System.Type[] types, System.Reflection.ParameterModifier[] modifiers) => throw null;
            public System.Reflection.MethodInfo GetMethod(string name, System.Type[] types) => throw null;
            protected virtual System.Reflection.MethodInfo GetMethodImpl(string name, System.Reflection.BindingFlags bindingAttr, System.Reflection.Binder binder, System.Reflection.CallingConventions callConvention, System.Type[] types, System.Reflection.ParameterModifier[] modifiers) => throw null;
            public System.Reflection.MethodInfo[] GetMethods() => throw null;
            public virtual System.Reflection.MethodInfo[] GetMethods(System.Reflection.BindingFlags bindingFlags) => throw null;
            public virtual void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public virtual void GetPEKind(out System.Reflection.PortableExecutableKinds peKind, out System.Reflection.ImageFileMachine machine) => throw null;
            public virtual System.Type GetType(string className) => throw null;
            public virtual System.Type GetType(string className, bool ignoreCase) => throw null;
            public virtual System.Type GetType(string className, bool throwOnError, bool ignoreCase) => throw null;
            public virtual System.Type[] GetTypes() => throw null;
            public virtual bool IsDefined(System.Type attributeType, bool inherit) => throw null;
            public virtual bool IsResource() => throw null;
            public virtual int MDStreamVersion { get => throw null; }
            public virtual int MetadataToken { get => throw null; }
            protected Module() => throw null;
            public System.ModuleHandle ModuleHandle { get => throw null; }
            public virtual System.Guid ModuleVersionId { get => throw null; }
            public virtual string Name { get => throw null; }
            public System.Reflection.FieldInfo ResolveField(int metadataToken) => throw null;
            public virtual System.Reflection.FieldInfo ResolveField(int metadataToken, System.Type[] genericTypeArguments, System.Type[] genericMethodArguments) => throw null;
            public System.Reflection.MemberInfo ResolveMember(int metadataToken) => throw null;
            public virtual System.Reflection.MemberInfo ResolveMember(int metadataToken, System.Type[] genericTypeArguments, System.Type[] genericMethodArguments) => throw null;
            public System.Reflection.MethodBase ResolveMethod(int metadataToken) => throw null;
            public virtual System.Reflection.MethodBase ResolveMethod(int metadataToken, System.Type[] genericTypeArguments, System.Type[] genericMethodArguments) => throw null;
            public virtual System.Byte[] ResolveSignature(int metadataToken) => throw null;
            public virtual string ResolveString(int metadataToken) => throw null;
            public System.Type ResolveType(int metadataToken) => throw null;
            public virtual System.Type ResolveType(int metadataToken, System.Type[] genericTypeArguments, System.Type[] genericMethodArguments) => throw null;
            public virtual string ScopeName { get => throw null; }
            public override string ToString() => throw null;
        }

        // Generated from `System.Reflection.ModuleResolveEventHandler` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public delegate System.Reflection.Module ModuleResolveEventHandler(object sender, System.ResolveEventArgs e);

        // Generated from `System.Reflection.ObfuscateAssemblyAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ObfuscateAssemblyAttribute : System.Attribute
        {
            public bool AssemblyIsPrivate { get => throw null; }
            public ObfuscateAssemblyAttribute(bool assemblyIsPrivate) => throw null;
            public bool StripAfterObfuscation { get => throw null; set => throw null; }
        }

        // Generated from `System.Reflection.ObfuscationAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ObfuscationAttribute : System.Attribute
        {
            public bool ApplyToMembers { get => throw null; set => throw null; }
            public bool Exclude { get => throw null; set => throw null; }
            public string Feature { get => throw null; set => throw null; }
            public ObfuscationAttribute() => throw null;
            public bool StripAfterObfuscation { get => throw null; set => throw null; }
        }

        // Generated from `System.Reflection.ParameterAttributes` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum ParameterAttributes
        {
            HasDefault,
            HasFieldMarshal,
            In,
            Lcid,
            None,
            Optional,
            Out,
            Reserved3,
            Reserved4,
            ReservedMask,
            Retval,
        }

        // Generated from `System.Reflection.ParameterInfo` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ParameterInfo : System.Reflection.ICustomAttributeProvider, System.Runtime.Serialization.IObjectReference
        {
            public virtual System.Reflection.ParameterAttributes Attributes { get => throw null; }
            protected System.Reflection.ParameterAttributes AttrsImpl;
            protected System.Type ClassImpl;
            public virtual System.Collections.Generic.IEnumerable<System.Reflection.CustomAttributeData> CustomAttributes { get => throw null; }
            public virtual object DefaultValue { get => throw null; }
            protected object DefaultValueImpl;
            public virtual object[] GetCustomAttributes(System.Type attributeType, bool inherit) => throw null;
            public virtual object[] GetCustomAttributes(bool inherit) => throw null;
            public virtual System.Collections.Generic.IList<System.Reflection.CustomAttributeData> GetCustomAttributesData() => throw null;
            public virtual System.Type[] GetOptionalCustomModifiers() => throw null;
            public object GetRealObject(System.Runtime.Serialization.StreamingContext context) => throw null;
            public virtual System.Type[] GetRequiredCustomModifiers() => throw null;
            public virtual bool HasDefaultValue { get => throw null; }
            public virtual bool IsDefined(System.Type attributeType, bool inherit) => throw null;
            public bool IsIn { get => throw null; }
            public bool IsLcid { get => throw null; }
            public bool IsOptional { get => throw null; }
            public bool IsOut { get => throw null; }
            public bool IsRetval { get => throw null; }
            public virtual System.Reflection.MemberInfo Member { get => throw null; }
            protected System.Reflection.MemberInfo MemberImpl;
            public virtual int MetadataToken { get => throw null; }
            public virtual string Name { get => throw null; }
            protected string NameImpl;
            protected ParameterInfo() => throw null;
            public virtual System.Type ParameterType { get => throw null; }
            public virtual int Position { get => throw null; }
            protected int PositionImpl;
            public virtual object RawDefaultValue { get => throw null; }
            public override string ToString() => throw null;
        }

        // Generated from `System.Reflection.ParameterModifier` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public struct ParameterModifier
        {
            public bool this[int index] { get => throw null; set => throw null; }
            // Stub generator skipped constructor 
            public ParameterModifier(int parameterCount) => throw null;
        }

        // Generated from `System.Reflection.Pointer` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class Pointer : System.Runtime.Serialization.ISerializable
        {
            unsafe public static object Box(void* ptr, System.Type type) => throw null;
            void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            unsafe public static void* Unbox(object ptr) => throw null;
        }

        // Generated from `System.Reflection.PortableExecutableKinds` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum PortableExecutableKinds
        {
            ILOnly,
            NotAPortableExecutableImage,
            PE32Plus,
            Preferred32Bit,
            Required32Bit,
            Unmanaged32Bit,
        }

        // Generated from `System.Reflection.ProcessorArchitecture` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum ProcessorArchitecture
        {
            Amd64,
            Arm,
            IA64,
            MSIL,
            None,
            X86,
        }

        // Generated from `System.Reflection.PropertyAttributes` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum PropertyAttributes
        {
            HasDefault,
            None,
            RTSpecialName,
            Reserved2,
            Reserved3,
            Reserved4,
            ReservedMask,
            SpecialName,
        }

        // Generated from `System.Reflection.PropertyInfo` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class PropertyInfo : System.Reflection.MemberInfo
        {
            public static bool operator !=(System.Reflection.PropertyInfo left, System.Reflection.PropertyInfo right) => throw null;
            public static bool operator ==(System.Reflection.PropertyInfo left, System.Reflection.PropertyInfo right) => throw null;
            public abstract System.Reflection.PropertyAttributes Attributes { get; }
            public abstract bool CanRead { get; }
            public abstract bool CanWrite { get; }
            public override bool Equals(object obj) => throw null;
            public System.Reflection.MethodInfo[] GetAccessors() => throw null;
            public abstract System.Reflection.MethodInfo[] GetAccessors(bool nonPublic);
            public virtual object GetConstantValue() => throw null;
            public System.Reflection.MethodInfo GetGetMethod() => throw null;
            public abstract System.Reflection.MethodInfo GetGetMethod(bool nonPublic);
            public override int GetHashCode() => throw null;
            public abstract System.Reflection.ParameterInfo[] GetIndexParameters();
            public virtual System.Reflection.MethodInfo GetMethod { get => throw null; }
            public virtual System.Type[] GetOptionalCustomModifiers() => throw null;
            public virtual object GetRawConstantValue() => throw null;
            public virtual System.Type[] GetRequiredCustomModifiers() => throw null;
            public System.Reflection.MethodInfo GetSetMethod() => throw null;
            public abstract System.Reflection.MethodInfo GetSetMethod(bool nonPublic);
            public object GetValue(object obj) => throw null;
            public abstract object GetValue(object obj, System.Reflection.BindingFlags invokeAttr, System.Reflection.Binder binder, object[] index, System.Globalization.CultureInfo culture);
            public virtual object GetValue(object obj, object[] index) => throw null;
            public bool IsSpecialName { get => throw null; }
            public override System.Reflection.MemberTypes MemberType { get => throw null; }
            protected PropertyInfo() => throw null;
            public abstract System.Type PropertyType { get; }
            public virtual System.Reflection.MethodInfo SetMethod { get => throw null; }
            public void SetValue(object obj, object value) => throw null;
            public abstract void SetValue(object obj, object value, System.Reflection.BindingFlags invokeAttr, System.Reflection.Binder binder, object[] index, System.Globalization.CultureInfo culture);
            public virtual void SetValue(object obj, object value, object[] index) => throw null;
        }

        // Generated from `System.Reflection.ReflectionContext` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class ReflectionContext
        {
            public virtual System.Reflection.TypeInfo GetTypeForObject(object value) => throw null;
            public abstract System.Reflection.Assembly MapAssembly(System.Reflection.Assembly assembly);
            public abstract System.Reflection.TypeInfo MapType(System.Reflection.TypeInfo type);
            protected ReflectionContext() => throw null;
        }

        // Generated from `System.Reflection.ReflectionTypeLoadException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ReflectionTypeLoadException : System.SystemException, System.Runtime.Serialization.ISerializable
        {
            public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public System.Exception[] LoaderExceptions { get => throw null; }
            public override string Message { get => throw null; }
            public ReflectionTypeLoadException(System.Type[] classes, System.Exception[] exceptions) => throw null;
            public ReflectionTypeLoadException(System.Type[] classes, System.Exception[] exceptions, string message) => throw null;
            public override string ToString() => throw null;
            public System.Type[] Types { get => throw null; }
        }

        // Generated from `System.Reflection.ResourceAttributes` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum ResourceAttributes
        {
            Private,
            Public,
        }

        // Generated from `System.Reflection.ResourceLocation` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum ResourceLocation
        {
            ContainedInAnotherAssembly,
            ContainedInManifestFile,
            Embedded,
        }

        // Generated from `System.Reflection.RuntimeReflectionExtensions` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public static class RuntimeReflectionExtensions
        {
            public static System.Reflection.MethodInfo GetMethodInfo(this System.Delegate del) => throw null;
            public static System.Reflection.MethodInfo GetRuntimeBaseDefinition(this System.Reflection.MethodInfo method) => throw null;
            public static System.Reflection.EventInfo GetRuntimeEvent(this System.Type type, string name) => throw null;
            public static System.Collections.Generic.IEnumerable<System.Reflection.EventInfo> GetRuntimeEvents(this System.Type type) => throw null;
            public static System.Reflection.FieldInfo GetRuntimeField(this System.Type type, string name) => throw null;
            public static System.Collections.Generic.IEnumerable<System.Reflection.FieldInfo> GetRuntimeFields(this System.Type type) => throw null;
            public static System.Reflection.InterfaceMapping GetRuntimeInterfaceMap(this System.Reflection.TypeInfo typeInfo, System.Type interfaceType) => throw null;
            public static System.Reflection.MethodInfo GetRuntimeMethod(this System.Type type, string name, System.Type[] parameters) => throw null;
            public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetRuntimeMethods(this System.Type type) => throw null;
            public static System.Collections.Generic.IEnumerable<System.Reflection.PropertyInfo> GetRuntimeProperties(this System.Type type) => throw null;
            public static System.Reflection.PropertyInfo GetRuntimeProperty(this System.Type type, string name) => throw null;
        }

        // Generated from `System.Reflection.StrongNameKeyPair` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class StrongNameKeyPair : System.Runtime.Serialization.IDeserializationCallback, System.Runtime.Serialization.ISerializable
        {
            void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            void System.Runtime.Serialization.IDeserializationCallback.OnDeserialization(object sender) => throw null;
            public System.Byte[] PublicKey { get => throw null; }
            public StrongNameKeyPair(System.Byte[] keyPairArray) => throw null;
            public StrongNameKeyPair(System.IO.FileStream keyPairFile) => throw null;
            protected StrongNameKeyPair(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public StrongNameKeyPair(string keyPairContainer) => throw null;
        }

        // Generated from `System.Reflection.TargetException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class TargetException : System.ApplicationException
        {
            public TargetException() => throw null;
            protected TargetException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public TargetException(string message) => throw null;
            public TargetException(string message, System.Exception inner) => throw null;
        }

        // Generated from `System.Reflection.TargetInvocationException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class TargetInvocationException : System.ApplicationException
        {
            public TargetInvocationException(System.Exception inner) => throw null;
            public TargetInvocationException(string message, System.Exception inner) => throw null;
        }

        // Generated from `System.Reflection.TargetParameterCountException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class TargetParameterCountException : System.ApplicationException
        {
            public TargetParameterCountException() => throw null;
            public TargetParameterCountException(string message) => throw null;
            public TargetParameterCountException(string message, System.Exception inner) => throw null;
        }

        // Generated from `System.Reflection.TypeAttributes` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum TypeAttributes
        {
            Abstract,
            AnsiClass,
            AutoClass,
            AutoLayout,
            BeforeFieldInit,
            Class,
            ClassSemanticsMask,
            CustomFormatClass,
            CustomFormatMask,
            ExplicitLayout,
            HasSecurity,
            Import,
            Interface,
            LayoutMask,
            NestedAssembly,
            NestedFamANDAssem,
            NestedFamORAssem,
            NestedFamily,
            NestedPrivate,
            NestedPublic,
            NotPublic,
            Public,
            RTSpecialName,
            ReservedMask,
            Sealed,
            SequentialLayout,
            Serializable,
            SpecialName,
            StringFormatMask,
            UnicodeClass,
            VisibilityMask,
            WindowsRuntime,
        }

        // Generated from `System.Reflection.TypeDelegator` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class TypeDelegator : System.Reflection.TypeInfo
        {
            public override System.Reflection.Assembly Assembly { get => throw null; }
            public override string AssemblyQualifiedName { get => throw null; }
            public override System.Type BaseType { get => throw null; }
            public override string FullName { get => throw null; }
            public override System.Guid GUID { get => throw null; }
            protected override System.Reflection.TypeAttributes GetAttributeFlagsImpl() => throw null;
            protected override System.Reflection.ConstructorInfo GetConstructorImpl(System.Reflection.BindingFlags bindingAttr, System.Reflection.Binder binder, System.Reflection.CallingConventions callConvention, System.Type[] types, System.Reflection.ParameterModifier[] modifiers) => throw null;
            public override System.Reflection.ConstructorInfo[] GetConstructors(System.Reflection.BindingFlags bindingAttr) => throw null;
            public override object[] GetCustomAttributes(System.Type attributeType, bool inherit) => throw null;
            public override object[] GetCustomAttributes(bool inherit) => throw null;
            public override System.Type GetElementType() => throw null;
            public override System.Reflection.EventInfo GetEvent(string name, System.Reflection.BindingFlags bindingAttr) => throw null;
            public override System.Reflection.EventInfo[] GetEvents() => throw null;
            public override System.Reflection.EventInfo[] GetEvents(System.Reflection.BindingFlags bindingAttr) => throw null;
            public override System.Reflection.FieldInfo GetField(string name, System.Reflection.BindingFlags bindingAttr) => throw null;
            public override System.Reflection.FieldInfo[] GetFields(System.Reflection.BindingFlags bindingAttr) => throw null;
            public override System.Type GetInterface(string name, bool ignoreCase) => throw null;
            public override System.Reflection.InterfaceMapping GetInterfaceMap(System.Type interfaceType) => throw null;
            public override System.Type[] GetInterfaces() => throw null;
            public override System.Reflection.MemberInfo[] GetMember(string name, System.Reflection.MemberTypes type, System.Reflection.BindingFlags bindingAttr) => throw null;
            public override System.Reflection.MemberInfo[] GetMembers(System.Reflection.BindingFlags bindingAttr) => throw null;
            protected override System.Reflection.MethodInfo GetMethodImpl(string name, System.Reflection.BindingFlags bindingAttr, System.Reflection.Binder binder, System.Reflection.CallingConventions callConvention, System.Type[] types, System.Reflection.ParameterModifier[] modifiers) => throw null;
            public override System.Reflection.MethodInfo[] GetMethods(System.Reflection.BindingFlags bindingAttr) => throw null;
            public override System.Type GetNestedType(string name, System.Reflection.BindingFlags bindingAttr) => throw null;
            public override System.Type[] GetNestedTypes(System.Reflection.BindingFlags bindingAttr) => throw null;
            public override System.Reflection.PropertyInfo[] GetProperties(System.Reflection.BindingFlags bindingAttr) => throw null;
            protected override System.Reflection.PropertyInfo GetPropertyImpl(string name, System.Reflection.BindingFlags bindingAttr, System.Reflection.Binder binder, System.Type returnType, System.Type[] types, System.Reflection.ParameterModifier[] modifiers) => throw null;
            protected override bool HasElementTypeImpl() => throw null;
            public override object InvokeMember(string name, System.Reflection.BindingFlags invokeAttr, System.Reflection.Binder binder, object target, object[] args, System.Reflection.ParameterModifier[] modifiers, System.Globalization.CultureInfo culture, string[] namedParameters) => throw null;
            protected override bool IsArrayImpl() => throw null;
            public override bool IsAssignableFrom(System.Reflection.TypeInfo typeInfo) => throw null;
            protected override bool IsByRefImpl() => throw null;
            public override bool IsByRefLike { get => throw null; }
            protected override bool IsCOMObjectImpl() => throw null;
            public override bool IsCollectible { get => throw null; }
            public override bool IsConstructedGenericType { get => throw null; }
            public override bool IsDefined(System.Type attributeType, bool inherit) => throw null;
            public override bool IsGenericMethodParameter { get => throw null; }
            public override bool IsGenericTypeParameter { get => throw null; }
            protected override bool IsPointerImpl() => throw null;
            protected override bool IsPrimitiveImpl() => throw null;
            public override bool IsSZArray { get => throw null; }
            public override bool IsTypeDefinition { get => throw null; }
            protected override bool IsValueTypeImpl() => throw null;
            public override bool IsVariableBoundArray { get => throw null; }
            public override int MetadataToken { get => throw null; }
            public override System.Reflection.Module Module { get => throw null; }
            public override string Name { get => throw null; }
            public override string Namespace { get => throw null; }
            protected TypeDelegator() => throw null;
            public TypeDelegator(System.Type delegatingType) => throw null;
            public override System.RuntimeTypeHandle TypeHandle { get => throw null; }
            public override System.Type UnderlyingSystemType { get => throw null; }
            protected System.Type typeImpl;
        }

        // Generated from `System.Reflection.TypeFilter` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public delegate bool TypeFilter(System.Type m, object filterCriteria);

        // Generated from `System.Reflection.TypeInfo` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class TypeInfo : System.Type, System.Reflection.IReflectableType
        {
            public virtual System.Type AsType() => throw null;
            public virtual System.Collections.Generic.IEnumerable<System.Reflection.ConstructorInfo> DeclaredConstructors { get => throw null; }
            public virtual System.Collections.Generic.IEnumerable<System.Reflection.EventInfo> DeclaredEvents { get => throw null; }
            public virtual System.Collections.Generic.IEnumerable<System.Reflection.FieldInfo> DeclaredFields { get => throw null; }
            public virtual System.Collections.Generic.IEnumerable<System.Reflection.MemberInfo> DeclaredMembers { get => throw null; }
            public virtual System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> DeclaredMethods { get => throw null; }
            public virtual System.Collections.Generic.IEnumerable<System.Reflection.TypeInfo> DeclaredNestedTypes { get => throw null; }
            public virtual System.Collections.Generic.IEnumerable<System.Reflection.PropertyInfo> DeclaredProperties { get => throw null; }
            public virtual System.Type[] GenericTypeParameters { get => throw null; }
            public virtual System.Reflection.EventInfo GetDeclaredEvent(string name) => throw null;
            public virtual System.Reflection.FieldInfo GetDeclaredField(string name) => throw null;
            public virtual System.Reflection.MethodInfo GetDeclaredMethod(string name) => throw null;
            public virtual System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetDeclaredMethods(string name) => throw null;
            public virtual System.Reflection.TypeInfo GetDeclaredNestedType(string name) => throw null;
            public virtual System.Reflection.PropertyInfo GetDeclaredProperty(string name) => throw null;
            System.Reflection.TypeInfo System.Reflection.IReflectableType.GetTypeInfo() => throw null;
            public virtual System.Collections.Generic.IEnumerable<System.Type> ImplementedInterfaces { get => throw null; }
            public virtual bool IsAssignableFrom(System.Reflection.TypeInfo typeInfo) => throw null;
            protected TypeInfo() => throw null;
        }

    }
    namespace Resources
    {
        // Generated from `System.Resources.IResourceReader` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IResourceReader : System.Collections.IEnumerable, System.IDisposable
        {
            void Close();
            System.Collections.IDictionaryEnumerator GetEnumerator();
        }

        // Generated from `System.Resources.MissingManifestResourceException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class MissingManifestResourceException : System.SystemException
        {
            public MissingManifestResourceException() => throw null;
            protected MissingManifestResourceException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public MissingManifestResourceException(string message) => throw null;
            public MissingManifestResourceException(string message, System.Exception inner) => throw null;
        }

        // Generated from `System.Resources.MissingSatelliteAssemblyException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class MissingSatelliteAssemblyException : System.SystemException
        {
            public string CultureName { get => throw null; }
            public MissingSatelliteAssemblyException() => throw null;
            protected MissingSatelliteAssemblyException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public MissingSatelliteAssemblyException(string message) => throw null;
            public MissingSatelliteAssemblyException(string message, System.Exception inner) => throw null;
            public MissingSatelliteAssemblyException(string message, string cultureName) => throw null;
        }

        // Generated from `System.Resources.NeutralResourcesLanguageAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class NeutralResourcesLanguageAttribute : System.Attribute
        {
            public string CultureName { get => throw null; }
            public System.Resources.UltimateResourceFallbackLocation Location { get => throw null; }
            public NeutralResourcesLanguageAttribute(string cultureName) => throw null;
            public NeutralResourcesLanguageAttribute(string cultureName, System.Resources.UltimateResourceFallbackLocation location) => throw null;
        }

        // Generated from `System.Resources.ResourceManager` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ResourceManager
        {
            public virtual string BaseName { get => throw null; }
            public static System.Resources.ResourceManager CreateFileBasedResourceManager(string baseName, string resourceDir, System.Type usingResourceSet) => throw null;
            protected System.Resources.UltimateResourceFallbackLocation FallbackLocation { get => throw null; set => throw null; }
            protected static System.Globalization.CultureInfo GetNeutralResourcesLanguage(System.Reflection.Assembly a) => throw null;
            public virtual object GetObject(string name) => throw null;
            public virtual object GetObject(string name, System.Globalization.CultureInfo culture) => throw null;
            protected virtual string GetResourceFileName(System.Globalization.CultureInfo culture) => throw null;
            public virtual System.Resources.ResourceSet GetResourceSet(System.Globalization.CultureInfo culture, bool createIfNotExists, bool tryParents) => throw null;
            protected static System.Version GetSatelliteContractVersion(System.Reflection.Assembly a) => throw null;
            public System.IO.UnmanagedMemoryStream GetStream(string name) => throw null;
            public System.IO.UnmanagedMemoryStream GetStream(string name, System.Globalization.CultureInfo culture) => throw null;
            public virtual string GetString(string name) => throw null;
            public virtual string GetString(string name, System.Globalization.CultureInfo culture) => throw null;
            public static int HeaderVersionNumber;
            public virtual bool IgnoreCase { get => throw null; set => throw null; }
            protected virtual System.Resources.ResourceSet InternalGetResourceSet(System.Globalization.CultureInfo culture, bool createIfNotExists, bool tryParents) => throw null;
            public static int MagicNumber;
            protected System.Reflection.Assembly MainAssembly;
            public virtual void ReleaseAllResources() => throw null;
            protected ResourceManager() => throw null;
            public ResourceManager(System.Type resourceSource) => throw null;
            public ResourceManager(string baseName, System.Reflection.Assembly assembly) => throw null;
            public ResourceManager(string baseName, System.Reflection.Assembly assembly, System.Type usingResourceSet) => throw null;
            public virtual System.Type ResourceSetType { get => throw null; }
        }

        // Generated from `System.Resources.ResourceReader` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ResourceReader : System.Collections.IEnumerable, System.IDisposable, System.Resources.IResourceReader
        {
            public void Close() => throw null;
            public void Dispose() => throw null;
            public System.Collections.IDictionaryEnumerator GetEnumerator() => throw null;
            System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            public void GetResourceData(string resourceName, out string resourceType, out System.Byte[] resourceData) => throw null;
            public ResourceReader(System.IO.Stream stream) => throw null;
            public ResourceReader(string fileName) => throw null;
        }

        // Generated from `System.Resources.ResourceSet` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ResourceSet : System.Collections.IEnumerable, System.IDisposable
        {
            public virtual void Close() => throw null;
            public void Dispose() => throw null;
            protected virtual void Dispose(bool disposing) => throw null;
            public virtual System.Type GetDefaultReader() => throw null;
            public virtual System.Type GetDefaultWriter() => throw null;
            public virtual System.Collections.IDictionaryEnumerator GetEnumerator() => throw null;
            System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            public virtual object GetObject(string name) => throw null;
            public virtual object GetObject(string name, bool ignoreCase) => throw null;
            public virtual string GetString(string name) => throw null;
            public virtual string GetString(string name, bool ignoreCase) => throw null;
            protected virtual void ReadResources() => throw null;
            protected ResourceSet() => throw null;
            public ResourceSet(System.Resources.IResourceReader reader) => throw null;
            public ResourceSet(System.IO.Stream stream) => throw null;
            public ResourceSet(string fileName) => throw null;
        }

        // Generated from `System.Resources.SatelliteContractVersionAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class SatelliteContractVersionAttribute : System.Attribute
        {
            public SatelliteContractVersionAttribute(string version) => throw null;
            public string Version { get => throw null; }
        }

        // Generated from `System.Resources.UltimateResourceFallbackLocation` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum UltimateResourceFallbackLocation
        {
            MainAssembly,
            Satellite,
        }

    }
    namespace Runtime
    {
        // Generated from `System.Runtime.AmbiguousImplementationException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class AmbiguousImplementationException : System.Exception
        {
            public AmbiguousImplementationException() => throw null;
            public AmbiguousImplementationException(string message) => throw null;
            public AmbiguousImplementationException(string message, System.Exception innerException) => throw null;
        }

        // Generated from `System.Runtime.AssemblyTargetedPatchBandAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class AssemblyTargetedPatchBandAttribute : System.Attribute
        {
            public AssemblyTargetedPatchBandAttribute(string targetedPatchBand) => throw null;
            public string TargetedPatchBand { get => throw null; }
        }

        // Generated from `System.Runtime.GCLargeObjectHeapCompactionMode` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum GCLargeObjectHeapCompactionMode
        {
            CompactOnce,
            Default,
        }

        // Generated from `System.Runtime.GCLatencyMode` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum GCLatencyMode
        {
            Batch,
            Interactive,
            LowLatency,
            NoGCRegion,
            SustainedLowLatency,
        }

        // Generated from `System.Runtime.GCSettings` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public static class GCSettings
        {
            public static bool IsServerGC { get => throw null; }
            public static System.Runtime.GCLargeObjectHeapCompactionMode LargeObjectHeapCompactionMode { get => throw null; set => throw null; }
            public static System.Runtime.GCLatencyMode LatencyMode { get => throw null; set => throw null; }
        }

        // Generated from `System.Runtime.MemoryFailPoint` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class MemoryFailPoint : System.Runtime.ConstrainedExecution.CriticalFinalizerObject, System.IDisposable
        {
            public void Dispose() => throw null;
            public MemoryFailPoint(int sizeInMegabytes) => throw null;
            // ERR: Stub generator didn't handle member: ~MemoryFailPoint
        }

        // Generated from `System.Runtime.ProfileOptimization` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public static class ProfileOptimization
        {
            public static void SetProfileRoot(string directoryPath) => throw null;
            public static void StartProfile(string profile) => throw null;
        }

        // Generated from `System.Runtime.TargetedPatchingOptOutAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class TargetedPatchingOptOutAttribute : System.Attribute
        {
            public string Reason { get => throw null; }
            public TargetedPatchingOptOutAttribute(string reason) => throw null;
        }

        namespace CompilerServices
        {
            // Generated from `System.Runtime.CompilerServices.AccessedThroughPropertyAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class AccessedThroughPropertyAttribute : System.Attribute
            {
                public AccessedThroughPropertyAttribute(string propertyName) => throw null;
                public string PropertyName { get => throw null; }
            }

            // Generated from `System.Runtime.CompilerServices.AsyncIteratorMethodBuilder` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct AsyncIteratorMethodBuilder
            {
                // Stub generator skipped constructor 
                public void AwaitOnCompleted<TAwaiter, TStateMachine>(ref TAwaiter awaiter, ref TStateMachine stateMachine) where TAwaiter : System.Runtime.CompilerServices.INotifyCompletion where TStateMachine : System.Runtime.CompilerServices.IAsyncStateMachine => throw null;
                public void AwaitUnsafeOnCompleted<TAwaiter, TStateMachine>(ref TAwaiter awaiter, ref TStateMachine stateMachine) where TAwaiter : System.Runtime.CompilerServices.ICriticalNotifyCompletion where TStateMachine : System.Runtime.CompilerServices.IAsyncStateMachine => throw null;
                public void Complete() => throw null;
                public static System.Runtime.CompilerServices.AsyncIteratorMethodBuilder Create() => throw null;
                public void MoveNext<TStateMachine>(ref TStateMachine stateMachine) where TStateMachine : System.Runtime.CompilerServices.IAsyncStateMachine => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.AsyncIteratorStateMachineAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class AsyncIteratorStateMachineAttribute : System.Runtime.CompilerServices.StateMachineAttribute
            {
                public AsyncIteratorStateMachineAttribute(System.Type stateMachineType) : base(default(System.Type)) => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.AsyncMethodBuilderAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class AsyncMethodBuilderAttribute : System.Attribute
            {
                public AsyncMethodBuilderAttribute(System.Type builderType) => throw null;
                public System.Type BuilderType { get => throw null; }
            }

            // Generated from `System.Runtime.CompilerServices.AsyncStateMachineAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class AsyncStateMachineAttribute : System.Runtime.CompilerServices.StateMachineAttribute
            {
                public AsyncStateMachineAttribute(System.Type stateMachineType) : base(default(System.Type)) => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.AsyncTaskMethodBuilder` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct AsyncTaskMethodBuilder
            {
                // Stub generator skipped constructor 
                public void AwaitOnCompleted<TAwaiter, TStateMachine>(ref TAwaiter awaiter, ref TStateMachine stateMachine) where TAwaiter : System.Runtime.CompilerServices.INotifyCompletion where TStateMachine : System.Runtime.CompilerServices.IAsyncStateMachine => throw null;
                public void AwaitUnsafeOnCompleted<TAwaiter, TStateMachine>(ref TAwaiter awaiter, ref TStateMachine stateMachine) where TAwaiter : System.Runtime.CompilerServices.ICriticalNotifyCompletion where TStateMachine : System.Runtime.CompilerServices.IAsyncStateMachine => throw null;
                public static System.Runtime.CompilerServices.AsyncTaskMethodBuilder Create() => throw null;
                public void SetException(System.Exception exception) => throw null;
                public void SetResult() => throw null;
                public void SetStateMachine(System.Runtime.CompilerServices.IAsyncStateMachine stateMachine) => throw null;
                public void Start<TStateMachine>(ref TStateMachine stateMachine) where TStateMachine : System.Runtime.CompilerServices.IAsyncStateMachine => throw null;
                public System.Threading.Tasks.Task Task { get => throw null; }
            }

            // Generated from `System.Runtime.CompilerServices.AsyncTaskMethodBuilder<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct AsyncTaskMethodBuilder<TResult>
            {
                // Stub generator skipped constructor 
                public void AwaitOnCompleted<TAwaiter, TStateMachine>(ref TAwaiter awaiter, ref TStateMachine stateMachine) where TAwaiter : System.Runtime.CompilerServices.INotifyCompletion where TStateMachine : System.Runtime.CompilerServices.IAsyncStateMachine => throw null;
                public void AwaitUnsafeOnCompleted<TAwaiter, TStateMachine>(ref TAwaiter awaiter, ref TStateMachine stateMachine) where TAwaiter : System.Runtime.CompilerServices.ICriticalNotifyCompletion where TStateMachine : System.Runtime.CompilerServices.IAsyncStateMachine => throw null;
                public static System.Runtime.CompilerServices.AsyncTaskMethodBuilder<TResult> Create() => throw null;
                public void SetException(System.Exception exception) => throw null;
                public void SetResult(TResult result) => throw null;
                public void SetStateMachine(System.Runtime.CompilerServices.IAsyncStateMachine stateMachine) => throw null;
                public void Start<TStateMachine>(ref TStateMachine stateMachine) where TStateMachine : System.Runtime.CompilerServices.IAsyncStateMachine => throw null;
                public System.Threading.Tasks.Task<TResult> Task { get => throw null; }
            }

            // Generated from `System.Runtime.CompilerServices.AsyncValueTaskMethodBuilder` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct AsyncValueTaskMethodBuilder
            {
                // Stub generator skipped constructor 
                public void AwaitOnCompleted<TAwaiter, TStateMachine>(ref TAwaiter awaiter, ref TStateMachine stateMachine) where TAwaiter : System.Runtime.CompilerServices.INotifyCompletion where TStateMachine : System.Runtime.CompilerServices.IAsyncStateMachine => throw null;
                public void AwaitUnsafeOnCompleted<TAwaiter, TStateMachine>(ref TAwaiter awaiter, ref TStateMachine stateMachine) where TAwaiter : System.Runtime.CompilerServices.ICriticalNotifyCompletion where TStateMachine : System.Runtime.CompilerServices.IAsyncStateMachine => throw null;
                public static System.Runtime.CompilerServices.AsyncValueTaskMethodBuilder Create() => throw null;
                public void SetException(System.Exception exception) => throw null;
                public void SetResult() => throw null;
                public void SetStateMachine(System.Runtime.CompilerServices.IAsyncStateMachine stateMachine) => throw null;
                public void Start<TStateMachine>(ref TStateMachine stateMachine) where TStateMachine : System.Runtime.CompilerServices.IAsyncStateMachine => throw null;
                public System.Threading.Tasks.ValueTask Task { get => throw null; }
            }

            // Generated from `System.Runtime.CompilerServices.AsyncValueTaskMethodBuilder<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct AsyncValueTaskMethodBuilder<TResult>
            {
                // Stub generator skipped constructor 
                public void AwaitOnCompleted<TAwaiter, TStateMachine>(ref TAwaiter awaiter, ref TStateMachine stateMachine) where TAwaiter : System.Runtime.CompilerServices.INotifyCompletion where TStateMachine : System.Runtime.CompilerServices.IAsyncStateMachine => throw null;
                public void AwaitUnsafeOnCompleted<TAwaiter, TStateMachine>(ref TAwaiter awaiter, ref TStateMachine stateMachine) where TAwaiter : System.Runtime.CompilerServices.ICriticalNotifyCompletion where TStateMachine : System.Runtime.CompilerServices.IAsyncStateMachine => throw null;
                public static System.Runtime.CompilerServices.AsyncValueTaskMethodBuilder<TResult> Create() => throw null;
                public void SetException(System.Exception exception) => throw null;
                public void SetResult(TResult result) => throw null;
                public void SetStateMachine(System.Runtime.CompilerServices.IAsyncStateMachine stateMachine) => throw null;
                public void Start<TStateMachine>(ref TStateMachine stateMachine) where TStateMachine : System.Runtime.CompilerServices.IAsyncStateMachine => throw null;
                public System.Threading.Tasks.ValueTask<TResult> Task { get => throw null; }
            }

            // Generated from `System.Runtime.CompilerServices.AsyncVoidMethodBuilder` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct AsyncVoidMethodBuilder
            {
                // Stub generator skipped constructor 
                public void AwaitOnCompleted<TAwaiter, TStateMachine>(ref TAwaiter awaiter, ref TStateMachine stateMachine) where TAwaiter : System.Runtime.CompilerServices.INotifyCompletion where TStateMachine : System.Runtime.CompilerServices.IAsyncStateMachine => throw null;
                public void AwaitUnsafeOnCompleted<TAwaiter, TStateMachine>(ref TAwaiter awaiter, ref TStateMachine stateMachine) where TAwaiter : System.Runtime.CompilerServices.ICriticalNotifyCompletion where TStateMachine : System.Runtime.CompilerServices.IAsyncStateMachine => throw null;
                public static System.Runtime.CompilerServices.AsyncVoidMethodBuilder Create() => throw null;
                public void SetException(System.Exception exception) => throw null;
                public void SetResult() => throw null;
                public void SetStateMachine(System.Runtime.CompilerServices.IAsyncStateMachine stateMachine) => throw null;
                public void Start<TStateMachine>(ref TStateMachine stateMachine) where TStateMachine : System.Runtime.CompilerServices.IAsyncStateMachine => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.CallConvCdecl` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class CallConvCdecl
            {
                public CallConvCdecl() => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.CallConvFastcall` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class CallConvFastcall
            {
                public CallConvFastcall() => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.CallConvStdcall` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class CallConvStdcall
            {
                public CallConvStdcall() => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.CallConvThiscall` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class CallConvThiscall
            {
                public CallConvThiscall() => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.CallerArgumentExpressionAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class CallerArgumentExpressionAttribute : System.Attribute
            {
                public CallerArgumentExpressionAttribute(string parameterName) => throw null;
                public string ParameterName { get => throw null; }
            }

            // Generated from `System.Runtime.CompilerServices.CallerFilePathAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class CallerFilePathAttribute : System.Attribute
            {
                public CallerFilePathAttribute() => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.CallerLineNumberAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class CallerLineNumberAttribute : System.Attribute
            {
                public CallerLineNumberAttribute() => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.CallerMemberNameAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class CallerMemberNameAttribute : System.Attribute
            {
                public CallerMemberNameAttribute() => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.CompilationRelaxations` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum CompilationRelaxations
            {
                NoStringInterning,
            }

            // Generated from `System.Runtime.CompilerServices.CompilationRelaxationsAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class CompilationRelaxationsAttribute : System.Attribute
            {
                public int CompilationRelaxations { get => throw null; }
                public CompilationRelaxationsAttribute(System.Runtime.CompilerServices.CompilationRelaxations relaxations) => throw null;
                public CompilationRelaxationsAttribute(int relaxations) => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.CompilerGeneratedAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class CompilerGeneratedAttribute : System.Attribute
            {
                public CompilerGeneratedAttribute() => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.CompilerGlobalScopeAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class CompilerGlobalScopeAttribute : System.Attribute
            {
                public CompilerGlobalScopeAttribute() => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.ConditionalWeakTable<,>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ConditionalWeakTable<TKey, TValue> : System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey, TValue>>, System.Collections.IEnumerable where TKey : class where TValue : class
            {
                // Generated from `System.Runtime.CompilerServices.ConditionalWeakTable<,>+CreateValueCallback` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public delegate TValue CreateValueCallback(TKey key);


                public void Add(TKey key, TValue value) => throw null;
                public void AddOrUpdate(TKey key, TValue value) => throw null;
                public void Clear() => throw null;
                public ConditionalWeakTable() => throw null;
                System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<TKey, TValue>> System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey, TValue>>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public TValue GetOrCreateValue(TKey key) => throw null;
                public TValue GetValue(TKey key, System.Runtime.CompilerServices.ConditionalWeakTable<TKey, TValue>.CreateValueCallback createValueCallback) => throw null;
                public bool Remove(TKey key) => throw null;
                public bool TryGetValue(TKey key, out TValue value) => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.ConfiguredAsyncDisposable` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct ConfiguredAsyncDisposable
            {
                // Stub generator skipped constructor 
                public System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable DisposeAsync() => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.ConfiguredCancelableAsyncEnumerable<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct ConfiguredCancelableAsyncEnumerable<T>
            {
                // Generated from `System.Runtime.CompilerServices.ConfiguredCancelableAsyncEnumerable<>+Enumerator` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public struct Enumerator
                {
                    public T Current { get => throw null; }
                    public System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable DisposeAsync() => throw null;
                    // Stub generator skipped constructor 
                    public System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable<bool> MoveNextAsync() => throw null;
                }


                public System.Runtime.CompilerServices.ConfiguredCancelableAsyncEnumerable<T> ConfigureAwait(bool continueOnCapturedContext) => throw null;
                // Stub generator skipped constructor 
                public System.Runtime.CompilerServices.ConfiguredCancelableAsyncEnumerable<T>.Enumerator GetAsyncEnumerator() => throw null;
                public System.Runtime.CompilerServices.ConfiguredCancelableAsyncEnumerable<T> WithCancellation(System.Threading.CancellationToken cancellationToken) => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.ConfiguredTaskAwaitable` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct ConfiguredTaskAwaitable
            {
                // Generated from `System.Runtime.CompilerServices.ConfiguredTaskAwaitable+ConfiguredTaskAwaiter` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public struct ConfiguredTaskAwaiter : System.Runtime.CompilerServices.ICriticalNotifyCompletion, System.Runtime.CompilerServices.INotifyCompletion
                {
                    // Stub generator skipped constructor 
                    public void GetResult() => throw null;
                    public bool IsCompleted { get => throw null; }
                    public void OnCompleted(System.Action continuation) => throw null;
                    public void UnsafeOnCompleted(System.Action continuation) => throw null;
                }


                // Stub generator skipped constructor 
                public System.Runtime.CompilerServices.ConfiguredTaskAwaitable.ConfiguredTaskAwaiter GetAwaiter() => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.ConfiguredTaskAwaitable<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct ConfiguredTaskAwaitable<TResult>
            {
                // Generated from `System.Runtime.CompilerServices.ConfiguredTaskAwaitable<>+ConfiguredTaskAwaiter` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public struct ConfiguredTaskAwaiter : System.Runtime.CompilerServices.ICriticalNotifyCompletion, System.Runtime.CompilerServices.INotifyCompletion
                {
                    // Stub generator skipped constructor 
                    public TResult GetResult() => throw null;
                    public bool IsCompleted { get => throw null; }
                    public void OnCompleted(System.Action continuation) => throw null;
                    public void UnsafeOnCompleted(System.Action continuation) => throw null;
                }


                // Stub generator skipped constructor 
                public System.Runtime.CompilerServices.ConfiguredTaskAwaitable<TResult>.ConfiguredTaskAwaiter GetAwaiter() => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct ConfiguredValueTaskAwaitable
            {
                // Generated from `System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable+ConfiguredValueTaskAwaiter` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public struct ConfiguredValueTaskAwaiter : System.Runtime.CompilerServices.ICriticalNotifyCompletion, System.Runtime.CompilerServices.INotifyCompletion
                {
                    // Stub generator skipped constructor 
                    public void GetResult() => throw null;
                    public bool IsCompleted { get => throw null; }
                    public void OnCompleted(System.Action continuation) => throw null;
                    public void UnsafeOnCompleted(System.Action continuation) => throw null;
                }


                // Stub generator skipped constructor 
                public System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable.ConfiguredValueTaskAwaiter GetAwaiter() => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct ConfiguredValueTaskAwaitable<TResult>
            {
                // Generated from `System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable<>+ConfiguredValueTaskAwaiter` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public struct ConfiguredValueTaskAwaiter : System.Runtime.CompilerServices.ICriticalNotifyCompletion, System.Runtime.CompilerServices.INotifyCompletion
                {
                    // Stub generator skipped constructor 
                    public TResult GetResult() => throw null;
                    public bool IsCompleted { get => throw null; }
                    public void OnCompleted(System.Action continuation) => throw null;
                    public void UnsafeOnCompleted(System.Action continuation) => throw null;
                }


                // Stub generator skipped constructor 
                public System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable<TResult>.ConfiguredValueTaskAwaiter GetAwaiter() => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.CustomConstantAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class CustomConstantAttribute : System.Attribute
            {
                protected CustomConstantAttribute() => throw null;
                public abstract object Value { get; }
            }

            // Generated from `System.Runtime.CompilerServices.DateTimeConstantAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DateTimeConstantAttribute : System.Runtime.CompilerServices.CustomConstantAttribute
            {
                public DateTimeConstantAttribute(System.Int64 ticks) => throw null;
                public override object Value { get => throw null; }
            }

            // Generated from `System.Runtime.CompilerServices.DecimalConstantAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DecimalConstantAttribute : System.Attribute
            {
                public DecimalConstantAttribute(System.Byte scale, System.Byte sign, int hi, int mid, int low) => throw null;
                public DecimalConstantAttribute(System.Byte scale, System.Byte sign, System.UInt32 hi, System.UInt32 mid, System.UInt32 low) => throw null;
                public System.Decimal Value { get => throw null; }
            }

            // Generated from `System.Runtime.CompilerServices.DefaultDependencyAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DefaultDependencyAttribute : System.Attribute
            {
                public DefaultDependencyAttribute(System.Runtime.CompilerServices.LoadHint loadHintArgument) => throw null;
                public System.Runtime.CompilerServices.LoadHint LoadHint { get => throw null; }
            }

            // Generated from `System.Runtime.CompilerServices.DependencyAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DependencyAttribute : System.Attribute
            {
                public DependencyAttribute(string dependentAssemblyArgument, System.Runtime.CompilerServices.LoadHint loadHintArgument) => throw null;
                public string DependentAssembly { get => throw null; }
                public System.Runtime.CompilerServices.LoadHint LoadHint { get => throw null; }
            }

            // Generated from `System.Runtime.CompilerServices.DisablePrivateReflectionAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DisablePrivateReflectionAttribute : System.Attribute
            {
                public DisablePrivateReflectionAttribute() => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.DiscardableAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DiscardableAttribute : System.Attribute
            {
                public DiscardableAttribute() => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.EnumeratorCancellationAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class EnumeratorCancellationAttribute : System.Attribute
            {
                public EnumeratorCancellationAttribute() => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.ExtensionAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ExtensionAttribute : System.Attribute
            {
                public ExtensionAttribute() => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.FixedAddressValueTypeAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class FixedAddressValueTypeAttribute : System.Attribute
            {
                public FixedAddressValueTypeAttribute() => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.FixedBufferAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class FixedBufferAttribute : System.Attribute
            {
                public System.Type ElementType { get => throw null; }
                public FixedBufferAttribute(System.Type elementType, int length) => throw null;
                public int Length { get => throw null; }
            }

            // Generated from `System.Runtime.CompilerServices.FormattableStringFactory` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class FormattableStringFactory
            {
                public static System.FormattableString Create(string format, params object[] arguments) => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.IAsyncStateMachine` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IAsyncStateMachine
            {
                void MoveNext();
                void SetStateMachine(System.Runtime.CompilerServices.IAsyncStateMachine stateMachine);
            }

            // Generated from `System.Runtime.CompilerServices.ICriticalNotifyCompletion` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface ICriticalNotifyCompletion : System.Runtime.CompilerServices.INotifyCompletion
            {
                void UnsafeOnCompleted(System.Action continuation);
            }

            // Generated from `System.Runtime.CompilerServices.INotifyCompletion` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface INotifyCompletion
            {
                void OnCompleted(System.Action continuation);
            }

            // Generated from `System.Runtime.CompilerServices.IStrongBox` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IStrongBox
            {
                object Value { get; set; }
            }

            // Generated from `System.Runtime.CompilerServices.ITuple` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface ITuple
            {
                object this[int index] { get; }
                int Length { get; }
            }

            // Generated from `System.Runtime.CompilerServices.IndexerNameAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class IndexerNameAttribute : System.Attribute
            {
                public IndexerNameAttribute(string indexerName) => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.InternalsVisibleToAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class InternalsVisibleToAttribute : System.Attribute
            {
                public bool AllInternalsVisible { get => throw null; set => throw null; }
                public string AssemblyName { get => throw null; }
                public InternalsVisibleToAttribute(string assemblyName) => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.IsByRefLikeAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class IsByRefLikeAttribute : System.Attribute
            {
                public IsByRefLikeAttribute() => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.IsConst` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class IsConst
            {
            }

            // Generated from `System.Runtime.CompilerServices.IsExternalInit` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class IsExternalInit
            {
            }

            // Generated from `System.Runtime.CompilerServices.IsReadOnlyAttribute` in `System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51; System.Formats.Asn1, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51; System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a; System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public partial class IsReadOnlyAttribute : System.Attribute
            {
                public IsReadOnlyAttribute() => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.IsVolatile` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class IsVolatile
            {
            }

            // Generated from `System.Runtime.CompilerServices.IteratorStateMachineAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class IteratorStateMachineAttribute : System.Runtime.CompilerServices.StateMachineAttribute
            {
                public IteratorStateMachineAttribute(System.Type stateMachineType) : base(default(System.Type)) => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.LoadHint` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum LoadHint
            {
                Always,
                Default,
                Sometimes,
            }

            // Generated from `System.Runtime.CompilerServices.MethodCodeType` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum MethodCodeType
            {
                IL,
                Native,
                OPTIL,
                Runtime,
            }

            // Generated from `System.Runtime.CompilerServices.MethodImplAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class MethodImplAttribute : System.Attribute
            {
                public System.Runtime.CompilerServices.MethodCodeType MethodCodeType;
                public MethodImplAttribute() => throw null;
                public MethodImplAttribute(System.Runtime.CompilerServices.MethodImplOptions methodImplOptions) => throw null;
                public MethodImplAttribute(System.Int16 value) => throw null;
                public System.Runtime.CompilerServices.MethodImplOptions Value { get => throw null; }
            }

            // Generated from `System.Runtime.CompilerServices.MethodImplOptions` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum MethodImplOptions
            {
                AggressiveInlining,
                AggressiveOptimization,
                ForwardRef,
                InternalCall,
                NoInlining,
                NoOptimization,
                PreserveSig,
                Synchronized,
                Unmanaged,
            }

            // Generated from `System.Runtime.CompilerServices.ModuleInitializerAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ModuleInitializerAttribute : System.Attribute
            {
                public ModuleInitializerAttribute() => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.PreserveBaseOverridesAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class PreserveBaseOverridesAttribute : System.Attribute
            {
                public PreserveBaseOverridesAttribute() => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.ReferenceAssemblyAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ReferenceAssemblyAttribute : System.Attribute
            {
                public string Description { get => throw null; }
                public ReferenceAssemblyAttribute() => throw null;
                public ReferenceAssemblyAttribute(string description) => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.RuntimeCompatibilityAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class RuntimeCompatibilityAttribute : System.Attribute
            {
                public RuntimeCompatibilityAttribute() => throw null;
                public bool WrapNonExceptionThrows { get => throw null; set => throw null; }
            }

            // Generated from `System.Runtime.CompilerServices.RuntimeFeature` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class RuntimeFeature
            {
                public const string CovariantReturnsOfClasses = default;
                public const string DefaultImplementationsOfInterfaces = default;
                public static bool IsDynamicCodeCompiled { get => throw null; }
                public static bool IsDynamicCodeSupported { get => throw null; }
                public static bool IsSupported(string feature) => throw null;
                public const string PortablePdb = default;
                public const string UnmanagedSignatureCallingConvention = default;
            }

            // Generated from `System.Runtime.CompilerServices.RuntimeHelpers` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class RuntimeHelpers
            {
                // Generated from `System.Runtime.CompilerServices.RuntimeHelpers+CleanupCode` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public delegate void CleanupCode(object userData, bool exceptionThrown);


                // Generated from `System.Runtime.CompilerServices.RuntimeHelpers+TryCode` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public delegate void TryCode(object userData);


                public static System.IntPtr AllocateTypeAssociatedMemory(System.Type type, int size) => throw null;
                public static void EnsureSufficientExecutionStack() => throw null;
                public static bool Equals(object o1, object o2) => throw null;
                public static void ExecuteCodeWithGuaranteedCleanup(System.Runtime.CompilerServices.RuntimeHelpers.TryCode code, System.Runtime.CompilerServices.RuntimeHelpers.CleanupCode backoutCode, object userData) => throw null;
                public static int GetHashCode(object o) => throw null;
                public static object GetObjectValue(object obj) => throw null;
                public static T[] GetSubArray<T>(T[] array, System.Range range) => throw null;
                public static object GetUninitializedObject(System.Type type) => throw null;
                public static void InitializeArray(System.Array array, System.RuntimeFieldHandle fldHandle) => throw null;
                public static bool IsReferenceOrContainsReferences<T>() => throw null;
                public static int OffsetToStringData { get => throw null; }
                public static void PrepareConstrainedRegions() => throw null;
                public static void PrepareConstrainedRegionsNoOP() => throw null;
                public static void PrepareContractedDelegate(System.Delegate d) => throw null;
                public static void PrepareDelegate(System.Delegate d) => throw null;
                public static void PrepareMethod(System.RuntimeMethodHandle method) => throw null;
                public static void PrepareMethod(System.RuntimeMethodHandle method, System.RuntimeTypeHandle[] instantiation) => throw null;
                public static void ProbeForSufficientStack() => throw null;
                public static void RunClassConstructor(System.RuntimeTypeHandle type) => throw null;
                public static void RunModuleConstructor(System.ModuleHandle module) => throw null;
                public static bool TryEnsureSufficientExecutionStack() => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.RuntimeWrappedException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class RuntimeWrappedException : System.Exception
            {
                public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public RuntimeWrappedException(object thrownObject) => throw null;
                public object WrappedException { get => throw null; }
            }

            // Generated from `System.Runtime.CompilerServices.SkipLocalsInitAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SkipLocalsInitAttribute : System.Attribute
            {
                public SkipLocalsInitAttribute() => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.SpecialNameAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SpecialNameAttribute : System.Attribute
            {
                public SpecialNameAttribute() => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.StateMachineAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class StateMachineAttribute : System.Attribute
            {
                public StateMachineAttribute(System.Type stateMachineType) => throw null;
                public System.Type StateMachineType { get => throw null; }
            }

            // Generated from `System.Runtime.CompilerServices.StringFreezingAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class StringFreezingAttribute : System.Attribute
            {
                public StringFreezingAttribute() => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.StrongBox<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class StrongBox<T> : System.Runtime.CompilerServices.IStrongBox
            {
                public StrongBox() => throw null;
                public StrongBox(T value) => throw null;
                public T Value;
                object System.Runtime.CompilerServices.IStrongBox.Value { get => throw null; set => throw null; }
            }

            // Generated from `System.Runtime.CompilerServices.SuppressIldasmAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SuppressIldasmAttribute : System.Attribute
            {
                public SuppressIldasmAttribute() => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.SwitchExpressionException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SwitchExpressionException : System.InvalidOperationException
            {
                public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public override string Message { get => throw null; }
                public SwitchExpressionException() => throw null;
                public SwitchExpressionException(System.Exception innerException) => throw null;
                public SwitchExpressionException(object unmatchedValue) => throw null;
                public SwitchExpressionException(string message) => throw null;
                public SwitchExpressionException(string message, System.Exception innerException) => throw null;
                public object UnmatchedValue { get => throw null; }
            }

            // Generated from `System.Runtime.CompilerServices.TaskAwaiter` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct TaskAwaiter : System.Runtime.CompilerServices.ICriticalNotifyCompletion, System.Runtime.CompilerServices.INotifyCompletion
            {
                public void GetResult() => throw null;
                public bool IsCompleted { get => throw null; }
                public void OnCompleted(System.Action continuation) => throw null;
                // Stub generator skipped constructor 
                public void UnsafeOnCompleted(System.Action continuation) => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.TaskAwaiter<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct TaskAwaiter<TResult> : System.Runtime.CompilerServices.ICriticalNotifyCompletion, System.Runtime.CompilerServices.INotifyCompletion
            {
                public TResult GetResult() => throw null;
                public bool IsCompleted { get => throw null; }
                public void OnCompleted(System.Action continuation) => throw null;
                // Stub generator skipped constructor 
                public void UnsafeOnCompleted(System.Action continuation) => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.TupleElementNamesAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class TupleElementNamesAttribute : System.Attribute
            {
                public System.Collections.Generic.IList<string> TransformNames { get => throw null; }
                public TupleElementNamesAttribute(string[] transformNames) => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.TypeForwardedFromAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class TypeForwardedFromAttribute : System.Attribute
            {
                public string AssemblyFullName { get => throw null; }
                public TypeForwardedFromAttribute(string assemblyFullName) => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.TypeForwardedToAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class TypeForwardedToAttribute : System.Attribute
            {
                public System.Type Destination { get => throw null; }
                public TypeForwardedToAttribute(System.Type destination) => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.UnsafeValueTypeAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class UnsafeValueTypeAttribute : System.Attribute
            {
                public UnsafeValueTypeAttribute() => throw null;
            }

            // Generated from `System.Runtime.CompilerServices.ValueTaskAwaiter` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct ValueTaskAwaiter : System.Runtime.CompilerServices.ICriticalNotifyCompletion, System.Runtime.CompilerServices.INotifyCompletion
            {
                public void GetResult() => throw null;
                public bool IsCompleted { get => throw null; }
                public void OnCompleted(System.Action continuation) => throw null;
                public void UnsafeOnCompleted(System.Action continuation) => throw null;
                // Stub generator skipped constructor 
            }

            // Generated from `System.Runtime.CompilerServices.ValueTaskAwaiter<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct ValueTaskAwaiter<TResult> : System.Runtime.CompilerServices.ICriticalNotifyCompletion, System.Runtime.CompilerServices.INotifyCompletion
            {
                public TResult GetResult() => throw null;
                public bool IsCompleted { get => throw null; }
                public void OnCompleted(System.Action continuation) => throw null;
                public void UnsafeOnCompleted(System.Action continuation) => throw null;
                // Stub generator skipped constructor 
            }

            // Generated from `System.Runtime.CompilerServices.YieldAwaitable` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct YieldAwaitable
            {
                // Generated from `System.Runtime.CompilerServices.YieldAwaitable+YieldAwaiter` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public struct YieldAwaiter : System.Runtime.CompilerServices.ICriticalNotifyCompletion, System.Runtime.CompilerServices.INotifyCompletion
                {
                    public void GetResult() => throw null;
                    public bool IsCompleted { get => throw null; }
                    public void OnCompleted(System.Action continuation) => throw null;
                    public void UnsafeOnCompleted(System.Action continuation) => throw null;
                    // Stub generator skipped constructor 
                }


                public System.Runtime.CompilerServices.YieldAwaitable.YieldAwaiter GetAwaiter() => throw null;
                // Stub generator skipped constructor 
            }

        }
        namespace ConstrainedExecution
        {
            // Generated from `System.Runtime.ConstrainedExecution.Cer` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum Cer
            {
                MayFail,
                None,
                Success,
            }

            // Generated from `System.Runtime.ConstrainedExecution.Consistency` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum Consistency
            {
                MayCorruptAppDomain,
                MayCorruptInstance,
                MayCorruptProcess,
                WillNotCorruptState,
            }

            // Generated from `System.Runtime.ConstrainedExecution.CriticalFinalizerObject` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class CriticalFinalizerObject
            {
                protected CriticalFinalizerObject() => throw null;
                // ERR: Stub generator didn't handle member: ~CriticalFinalizerObject
            }

            // Generated from `System.Runtime.ConstrainedExecution.PrePrepareMethodAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class PrePrepareMethodAttribute : System.Attribute
            {
                public PrePrepareMethodAttribute() => throw null;
            }

            // Generated from `System.Runtime.ConstrainedExecution.ReliabilityContractAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ReliabilityContractAttribute : System.Attribute
            {
                public System.Runtime.ConstrainedExecution.Cer Cer { get => throw null; }
                public System.Runtime.ConstrainedExecution.Consistency ConsistencyGuarantee { get => throw null; }
                public ReliabilityContractAttribute(System.Runtime.ConstrainedExecution.Consistency consistencyGuarantee, System.Runtime.ConstrainedExecution.Cer cer) => throw null;
            }

        }
        namespace ExceptionServices
        {
            // Generated from `System.Runtime.ExceptionServices.ExceptionDispatchInfo` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ExceptionDispatchInfo
            {
                public static System.Runtime.ExceptionServices.ExceptionDispatchInfo Capture(System.Exception source) => throw null;
                public static System.Exception SetCurrentStackTrace(System.Exception source) => throw null;
                public System.Exception SourceException { get => throw null; }
                public void Throw() => throw null;
                public static void Throw(System.Exception source) => throw null;
            }

            // Generated from `System.Runtime.ExceptionServices.FirstChanceExceptionEventArgs` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class FirstChanceExceptionEventArgs : System.EventArgs
            {
                public System.Exception Exception { get => throw null; }
                public FirstChanceExceptionEventArgs(System.Exception exception) => throw null;
            }

            // Generated from `System.Runtime.ExceptionServices.HandleProcessCorruptedStateExceptionsAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class HandleProcessCorruptedStateExceptionsAttribute : System.Attribute
            {
                public HandleProcessCorruptedStateExceptionsAttribute() => throw null;
            }

        }
        namespace InteropServices
        {
            // Generated from `System.Runtime.InteropServices.CharSet` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum CharSet
            {
                Ansi,
                Auto,
                None,
                Unicode,
            }

            // Generated from `System.Runtime.InteropServices.ComVisibleAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ComVisibleAttribute : System.Attribute
            {
                public ComVisibleAttribute(bool visibility) => throw null;
                public bool Value { get => throw null; }
            }

            // Generated from `System.Runtime.InteropServices.CriticalHandle` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class CriticalHandle : System.Runtime.ConstrainedExecution.CriticalFinalizerObject, System.IDisposable
            {
                public void Close() => throw null;
                protected CriticalHandle(System.IntPtr invalidHandleValue) => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public bool IsClosed { get => throw null; }
                public abstract bool IsInvalid { get; }
                protected abstract bool ReleaseHandle();
                protected void SetHandle(System.IntPtr handle) => throw null;
                public void SetHandleAsInvalid() => throw null;
                protected System.IntPtr handle;
                // ERR: Stub generator didn't handle member: ~CriticalHandle
            }

            // Generated from `System.Runtime.InteropServices.ExternalException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ExternalException : System.SystemException
            {
                public virtual int ErrorCode { get => throw null; }
                public ExternalException() => throw null;
                protected ExternalException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public ExternalException(string message) => throw null;
                public ExternalException(string message, System.Exception inner) => throw null;
                public ExternalException(string message, int errorCode) => throw null;
                public override string ToString() => throw null;
            }

            // Generated from `System.Runtime.InteropServices.FieldOffsetAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class FieldOffsetAttribute : System.Attribute
            {
                public FieldOffsetAttribute(int offset) => throw null;
                public int Value { get => throw null; }
            }

            // Generated from `System.Runtime.InteropServices.GCHandle` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct GCHandle
            {
                public static bool operator !=(System.Runtime.InteropServices.GCHandle a, System.Runtime.InteropServices.GCHandle b) => throw null;
                public static bool operator ==(System.Runtime.InteropServices.GCHandle a, System.Runtime.InteropServices.GCHandle b) => throw null;
                public System.IntPtr AddrOfPinnedObject() => throw null;
                public static System.Runtime.InteropServices.GCHandle Alloc(object value) => throw null;
                public static System.Runtime.InteropServices.GCHandle Alloc(object value, System.Runtime.InteropServices.GCHandleType type) => throw null;
                public override bool Equals(object o) => throw null;
                public void Free() => throw null;
                public static System.Runtime.InteropServices.GCHandle FromIntPtr(System.IntPtr value) => throw null;
                // Stub generator skipped constructor 
                public override int GetHashCode() => throw null;
                public bool IsAllocated { get => throw null; }
                public object Target { get => throw null; set => throw null; }
                public static System.IntPtr ToIntPtr(System.Runtime.InteropServices.GCHandle value) => throw null;
                public static explicit operator System.IntPtr(System.Runtime.InteropServices.GCHandle value) => throw null;
                public static explicit operator System.Runtime.InteropServices.GCHandle(System.IntPtr value) => throw null;
            }

            // Generated from `System.Runtime.InteropServices.GCHandleType` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum GCHandleType
            {
                Normal,
                Pinned,
                Weak,
                WeakTrackResurrection,
            }

            // Generated from `System.Runtime.InteropServices.InAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class InAttribute : System.Attribute
            {
                public InAttribute() => throw null;
            }

            // Generated from `System.Runtime.InteropServices.LayoutKind` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum LayoutKind
            {
                Auto,
                Explicit,
                Sequential,
            }

            // Generated from `System.Runtime.InteropServices.OutAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class OutAttribute : System.Attribute
            {
                public OutAttribute() => throw null;
            }

            // Generated from `System.Runtime.InteropServices.SafeBuffer` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class SafeBuffer : Microsoft.Win32.SafeHandles.SafeHandleZeroOrMinusOneIsInvalid
            {
                unsafe public void AcquirePointer(ref System.Byte* pointer) => throw null;
                public System.UInt64 ByteLength { get => throw null; }
                public void Initialize(System.UInt32 numElements, System.UInt32 sizeOfEachElement) => throw null;
                public void Initialize(System.UInt64 numBytes) => throw null;
                public void Initialize<T>(System.UInt32 numElements) where T : struct => throw null;
                public T Read<T>(System.UInt64 byteOffset) where T : struct => throw null;
                public void ReadArray<T>(System.UInt64 byteOffset, T[] array, int index, int count) where T : struct => throw null;
                public void ReleasePointer() => throw null;
                protected SafeBuffer(bool ownsHandle) : base(default(bool)) => throw null;
                public void Write<T>(System.UInt64 byteOffset, T value) where T : struct => throw null;
                public void WriteArray<T>(System.UInt64 byteOffset, T[] array, int index, int count) where T : struct => throw null;
            }

            // Generated from `System.Runtime.InteropServices.SafeHandle` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class SafeHandle : System.Runtime.ConstrainedExecution.CriticalFinalizerObject, System.IDisposable
            {
                public void Close() => throw null;
                public void DangerousAddRef(ref bool success) => throw null;
                public System.IntPtr DangerousGetHandle() => throw null;
                public void DangerousRelease() => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public bool IsClosed { get => throw null; }
                public abstract bool IsInvalid { get; }
                protected abstract bool ReleaseHandle();
                protected SafeHandle(System.IntPtr invalidHandleValue, bool ownsHandle) => throw null;
                protected void SetHandle(System.IntPtr handle) => throw null;
                public void SetHandleAsInvalid() => throw null;
                protected System.IntPtr handle;
                // ERR: Stub generator didn't handle member: ~SafeHandle
            }

            // Generated from `System.Runtime.InteropServices.StructLayoutAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class StructLayoutAttribute : System.Attribute
            {
                public System.Runtime.InteropServices.CharSet CharSet;
                public int Pack;
                public int Size;
                public StructLayoutAttribute(System.Runtime.InteropServices.LayoutKind layoutKind) => throw null;
                public StructLayoutAttribute(System.Int16 layoutKind) => throw null;
                public System.Runtime.InteropServices.LayoutKind Value { get => throw null; }
            }

            // Generated from `System.Runtime.InteropServices.SuppressGCTransitionAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SuppressGCTransitionAttribute : System.Attribute
            {
                public SuppressGCTransitionAttribute() => throw null;
            }

        }
        namespace Remoting
        {
            // Generated from `System.Runtime.Remoting.ObjectHandle` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ObjectHandle : System.MarshalByRefObject
            {
                public ObjectHandle(object o) => throw null;
                public object Unwrap() => throw null;
            }

        }
        namespace Serialization
        {
            // Generated from `System.Runtime.Serialization.IDeserializationCallback` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IDeserializationCallback
            {
                void OnDeserialization(object sender);
            }

            // Generated from `System.Runtime.Serialization.IFormatterConverter` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IFormatterConverter
            {
                object Convert(object value, System.Type type);
                object Convert(object value, System.TypeCode typeCode);
                bool ToBoolean(object value);
                System.Byte ToByte(object value);
                System.Char ToChar(object value);
                System.DateTime ToDateTime(object value);
                System.Decimal ToDecimal(object value);
                double ToDouble(object value);
                System.Int16 ToInt16(object value);
                int ToInt32(object value);
                System.Int64 ToInt64(object value);
                System.SByte ToSByte(object value);
                float ToSingle(object value);
                string ToString(object value);
                System.UInt16 ToUInt16(object value);
                System.UInt32 ToUInt32(object value);
                System.UInt64 ToUInt64(object value);
            }

            // Generated from `System.Runtime.Serialization.IObjectReference` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IObjectReference
            {
                object GetRealObject(System.Runtime.Serialization.StreamingContext context);
            }

            // Generated from `System.Runtime.Serialization.ISafeSerializationData` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface ISafeSerializationData
            {
                void CompleteDeserialization(object deserialized);
            }

            // Generated from `System.Runtime.Serialization.ISerializable` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface ISerializable
            {
                void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context);
            }

            // Generated from `System.Runtime.Serialization.OnDeserializedAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class OnDeserializedAttribute : System.Attribute
            {
                public OnDeserializedAttribute() => throw null;
            }

            // Generated from `System.Runtime.Serialization.OnDeserializingAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class OnDeserializingAttribute : System.Attribute
            {
                public OnDeserializingAttribute() => throw null;
            }

            // Generated from `System.Runtime.Serialization.OnSerializedAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class OnSerializedAttribute : System.Attribute
            {
                public OnSerializedAttribute() => throw null;
            }

            // Generated from `System.Runtime.Serialization.OnSerializingAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class OnSerializingAttribute : System.Attribute
            {
                public OnSerializingAttribute() => throw null;
            }

            // Generated from `System.Runtime.Serialization.OptionalFieldAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class OptionalFieldAttribute : System.Attribute
            {
                public OptionalFieldAttribute() => throw null;
                public int VersionAdded { get => throw null; set => throw null; }
            }

            // Generated from `System.Runtime.Serialization.SafeSerializationEventArgs` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SafeSerializationEventArgs : System.EventArgs
            {
                public void AddSerializedState(System.Runtime.Serialization.ISafeSerializationData serializedState) => throw null;
                public System.Runtime.Serialization.StreamingContext StreamingContext { get => throw null; }
            }

            // Generated from `System.Runtime.Serialization.SerializationEntry` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct SerializationEntry
            {
                public string Name { get => throw null; }
                public System.Type ObjectType { get => throw null; }
                // Stub generator skipped constructor 
                public object Value { get => throw null; }
            }

            // Generated from `System.Runtime.Serialization.SerializationException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SerializationException : System.SystemException
            {
                public SerializationException() => throw null;
                protected SerializationException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public SerializationException(string message) => throw null;
                public SerializationException(string message, System.Exception innerException) => throw null;
            }

            // Generated from `System.Runtime.Serialization.SerializationInfo` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SerializationInfo
            {
                public void AddValue(string name, System.DateTime value) => throw null;
                public void AddValue(string name, bool value) => throw null;
                public void AddValue(string name, System.Byte value) => throw null;
                public void AddValue(string name, System.Char value) => throw null;
                public void AddValue(string name, System.Decimal value) => throw null;
                public void AddValue(string name, double value) => throw null;
                public void AddValue(string name, float value) => throw null;
                public void AddValue(string name, int value) => throw null;
                public void AddValue(string name, System.Int64 value) => throw null;
                public void AddValue(string name, object value) => throw null;
                public void AddValue(string name, object value, System.Type type) => throw null;
                public void AddValue(string name, System.SByte value) => throw null;
                public void AddValue(string name, System.Int16 value) => throw null;
                public void AddValue(string name, System.UInt32 value) => throw null;
                public void AddValue(string name, System.UInt64 value) => throw null;
                public void AddValue(string name, System.UInt16 value) => throw null;
                public string AssemblyName { get => throw null; set => throw null; }
                public string FullTypeName { get => throw null; set => throw null; }
                public bool GetBoolean(string name) => throw null;
                public System.Byte GetByte(string name) => throw null;
                public System.Char GetChar(string name) => throw null;
                public System.DateTime GetDateTime(string name) => throw null;
                public System.Decimal GetDecimal(string name) => throw null;
                public double GetDouble(string name) => throw null;
                public System.Runtime.Serialization.SerializationInfoEnumerator GetEnumerator() => throw null;
                public System.Int16 GetInt16(string name) => throw null;
                public int GetInt32(string name) => throw null;
                public System.Int64 GetInt64(string name) => throw null;
                public System.SByte GetSByte(string name) => throw null;
                public float GetSingle(string name) => throw null;
                public string GetString(string name) => throw null;
                public System.UInt16 GetUInt16(string name) => throw null;
                public System.UInt32 GetUInt32(string name) => throw null;
                public System.UInt64 GetUInt64(string name) => throw null;
                public object GetValue(string name, System.Type type) => throw null;
                public bool IsAssemblyNameSetExplicit { get => throw null; }
                public bool IsFullTypeNameSetExplicit { get => throw null; }
                public int MemberCount { get => throw null; }
                public System.Type ObjectType { get => throw null; }
                public SerializationInfo(System.Type type, System.Runtime.Serialization.IFormatterConverter converter) => throw null;
                public SerializationInfo(System.Type type, System.Runtime.Serialization.IFormatterConverter converter, bool requireSameTokenInPartialTrust) => throw null;
                public void SetType(System.Type type) => throw null;
            }

            // Generated from `System.Runtime.Serialization.SerializationInfoEnumerator` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SerializationInfoEnumerator : System.Collections.IEnumerator
            {
                public System.Runtime.Serialization.SerializationEntry Current { get => throw null; }
                object System.Collections.IEnumerator.Current { get => throw null; }
                public bool MoveNext() => throw null;
                public string Name { get => throw null; }
                public System.Type ObjectType { get => throw null; }
                public void Reset() => throw null;
                public object Value { get => throw null; }
            }

            // Generated from `System.Runtime.Serialization.StreamingContext` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct StreamingContext
            {
                public object Context { get => throw null; }
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public System.Runtime.Serialization.StreamingContextStates State { get => throw null; }
                // Stub generator skipped constructor 
                public StreamingContext(System.Runtime.Serialization.StreamingContextStates state) => throw null;
                public StreamingContext(System.Runtime.Serialization.StreamingContextStates state, object additional) => throw null;
            }

            // Generated from `System.Runtime.Serialization.StreamingContextStates` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum StreamingContextStates
            {
                All,
                Clone,
                CrossAppDomain,
                CrossMachine,
                CrossProcess,
                File,
                Other,
                Persistence,
                Remoting,
            }

        }
        namespace Versioning
        {
            // Generated from `System.Runtime.Versioning.ComponentGuaranteesAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ComponentGuaranteesAttribute : System.Attribute
            {
                public ComponentGuaranteesAttribute(System.Runtime.Versioning.ComponentGuaranteesOptions guarantees) => throw null;
                public System.Runtime.Versioning.ComponentGuaranteesOptions Guarantees { get => throw null; }
            }

            // Generated from `System.Runtime.Versioning.ComponentGuaranteesOptions` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum ComponentGuaranteesOptions
            {
                Exchange,
                None,
                SideBySide,
                Stable,
            }

            // Generated from `System.Runtime.Versioning.FrameworkName` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class FrameworkName : System.IEquatable<System.Runtime.Versioning.FrameworkName>
            {
                public static bool operator !=(System.Runtime.Versioning.FrameworkName left, System.Runtime.Versioning.FrameworkName right) => throw null;
                public static bool operator ==(System.Runtime.Versioning.FrameworkName left, System.Runtime.Versioning.FrameworkName right) => throw null;
                public bool Equals(System.Runtime.Versioning.FrameworkName other) => throw null;
                public override bool Equals(object obj) => throw null;
                public FrameworkName(string frameworkName) => throw null;
                public FrameworkName(string identifier, System.Version version) => throw null;
                public FrameworkName(string identifier, System.Version version, string profile) => throw null;
                public string FullName { get => throw null; }
                public override int GetHashCode() => throw null;
                public string Identifier { get => throw null; }
                public string Profile { get => throw null; }
                public override string ToString() => throw null;
                public System.Version Version { get => throw null; }
            }

            // Generated from `System.Runtime.Versioning.OSPlatformAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class OSPlatformAttribute : System.Attribute
            {
                protected private OSPlatformAttribute(string platformName) => throw null;
                public string PlatformName { get => throw null; }
            }

            // Generated from `System.Runtime.Versioning.ResourceConsumptionAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ResourceConsumptionAttribute : System.Attribute
            {
                public System.Runtime.Versioning.ResourceScope ConsumptionScope { get => throw null; }
                public ResourceConsumptionAttribute(System.Runtime.Versioning.ResourceScope resourceScope) => throw null;
                public ResourceConsumptionAttribute(System.Runtime.Versioning.ResourceScope resourceScope, System.Runtime.Versioning.ResourceScope consumptionScope) => throw null;
                public System.Runtime.Versioning.ResourceScope ResourceScope { get => throw null; }
            }

            // Generated from `System.Runtime.Versioning.ResourceExposureAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ResourceExposureAttribute : System.Attribute
            {
                public ResourceExposureAttribute(System.Runtime.Versioning.ResourceScope exposureLevel) => throw null;
                public System.Runtime.Versioning.ResourceScope ResourceExposureLevel { get => throw null; }
            }

            // Generated from `System.Runtime.Versioning.ResourceScope` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum ResourceScope
            {
                AppDomain,
                Assembly,
                Library,
                Machine,
                None,
                Private,
                Process,
            }

            // Generated from `System.Runtime.Versioning.SupportedOSPlatformAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SupportedOSPlatformAttribute : System.Runtime.Versioning.OSPlatformAttribute
            {
                public SupportedOSPlatformAttribute(string platformName) : base(default(string)) => throw null;
            }

            // Generated from `System.Runtime.Versioning.TargetFrameworkAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class TargetFrameworkAttribute : System.Attribute
            {
                public string FrameworkDisplayName { get => throw null; set => throw null; }
                public string FrameworkName { get => throw null; }
                public TargetFrameworkAttribute(string frameworkName) => throw null;
            }

            // Generated from `System.Runtime.Versioning.TargetPlatformAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class TargetPlatformAttribute : System.Runtime.Versioning.OSPlatformAttribute
            {
                public TargetPlatformAttribute(string platformName) : base(default(string)) => throw null;
            }

            // Generated from `System.Runtime.Versioning.UnsupportedOSPlatformAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class UnsupportedOSPlatformAttribute : System.Runtime.Versioning.OSPlatformAttribute
            {
                public UnsupportedOSPlatformAttribute(string platformName) : base(default(string)) => throw null;
            }

            // Generated from `System.Runtime.Versioning.VersioningHelper` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class VersioningHelper
            {
                public static string MakeVersionSafeName(string name, System.Runtime.Versioning.ResourceScope from, System.Runtime.Versioning.ResourceScope to) => throw null;
                public static string MakeVersionSafeName(string name, System.Runtime.Versioning.ResourceScope from, System.Runtime.Versioning.ResourceScope to, System.Type type) => throw null;
            }

        }
    }
    namespace Security
    {
        // Generated from `System.Security.AllowPartiallyTrustedCallersAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class AllowPartiallyTrustedCallersAttribute : System.Attribute
        {
            public AllowPartiallyTrustedCallersAttribute() => throw null;
            public System.Security.PartialTrustVisibilityLevel PartialTrustVisibilityLevel { get => throw null; set => throw null; }
        }

        // Generated from `System.Security.IPermission` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IPermission : System.Security.ISecurityEncodable
        {
            System.Security.IPermission Copy();
            void Demand();
            System.Security.IPermission Intersect(System.Security.IPermission target);
            bool IsSubsetOf(System.Security.IPermission target);
            System.Security.IPermission Union(System.Security.IPermission target);
        }

        // Generated from `System.Security.ISecurityEncodable` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface ISecurityEncodable
        {
            void FromXml(System.Security.SecurityElement e);
            System.Security.SecurityElement ToXml();
        }

        // Generated from `System.Security.IStackWalk` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IStackWalk
        {
            void Assert();
            void Demand();
            void Deny();
            void PermitOnly();
        }

        // Generated from `System.Security.PartialTrustVisibilityLevel` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum PartialTrustVisibilityLevel
        {
            NotVisibleByDefault,
            VisibleToAllHosts,
        }

        // Generated from `System.Security.PermissionSet` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class PermissionSet : System.Collections.ICollection, System.Collections.IEnumerable, System.Runtime.Serialization.IDeserializationCallback, System.Security.ISecurityEncodable, System.Security.IStackWalk
        {
            public System.Security.IPermission AddPermission(System.Security.IPermission perm) => throw null;
            protected virtual System.Security.IPermission AddPermissionImpl(System.Security.IPermission perm) => throw null;
            public void Assert() => throw null;
            public bool ContainsNonCodeAccessPermissions() => throw null;
            public static System.Byte[] ConvertPermissionSet(string inFormat, System.Byte[] inData, string outFormat) => throw null;
            public virtual System.Security.PermissionSet Copy() => throw null;
            public virtual void CopyTo(System.Array array, int index) => throw null;
            public virtual int Count { get => throw null; }
            public void Demand() => throw null;
            public void Deny() => throw null;
            public override bool Equals(object o) => throw null;
            public virtual void FromXml(System.Security.SecurityElement et) => throw null;
            public System.Collections.IEnumerator GetEnumerator() => throw null;
            protected virtual System.Collections.IEnumerator GetEnumeratorImpl() => throw null;
            public override int GetHashCode() => throw null;
            public System.Security.IPermission GetPermission(System.Type permClass) => throw null;
            protected virtual System.Security.IPermission GetPermissionImpl(System.Type permClass) => throw null;
            public System.Security.PermissionSet Intersect(System.Security.PermissionSet other) => throw null;
            public bool IsEmpty() => throw null;
            public virtual bool IsReadOnly { get => throw null; }
            public bool IsSubsetOf(System.Security.PermissionSet target) => throw null;
            public virtual bool IsSynchronized { get => throw null; }
            public bool IsUnrestricted() => throw null;
            void System.Runtime.Serialization.IDeserializationCallback.OnDeserialization(object sender) => throw null;
            public PermissionSet(System.Security.PermissionSet permSet) => throw null;
            public PermissionSet(System.Security.Permissions.PermissionState state) => throw null;
            public void PermitOnly() => throw null;
            public System.Security.IPermission RemovePermission(System.Type permClass) => throw null;
            protected virtual System.Security.IPermission RemovePermissionImpl(System.Type permClass) => throw null;
            public static void RevertAssert() => throw null;
            public System.Security.IPermission SetPermission(System.Security.IPermission perm) => throw null;
            protected virtual System.Security.IPermission SetPermissionImpl(System.Security.IPermission perm) => throw null;
            public virtual object SyncRoot { get => throw null; }
            public override string ToString() => throw null;
            public virtual System.Security.SecurityElement ToXml() => throw null;
            public System.Security.PermissionSet Union(System.Security.PermissionSet other) => throw null;
        }

        // Generated from `System.Security.SecurityCriticalAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class SecurityCriticalAttribute : System.Attribute
        {
            public System.Security.SecurityCriticalScope Scope { get => throw null; }
            public SecurityCriticalAttribute() => throw null;
            public SecurityCriticalAttribute(System.Security.SecurityCriticalScope scope) => throw null;
        }

        // Generated from `System.Security.SecurityCriticalScope` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum SecurityCriticalScope
        {
            Everything,
            Explicit,
        }

        // Generated from `System.Security.SecurityElement` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class SecurityElement
        {
            public void AddAttribute(string name, string value) => throw null;
            public void AddChild(System.Security.SecurityElement child) => throw null;
            public string Attribute(string name) => throw null;
            public System.Collections.Hashtable Attributes { get => throw null; set => throw null; }
            public System.Collections.ArrayList Children { get => throw null; set => throw null; }
            public System.Security.SecurityElement Copy() => throw null;
            public bool Equal(System.Security.SecurityElement other) => throw null;
            public static string Escape(string str) => throw null;
            public static System.Security.SecurityElement FromString(string xml) => throw null;
            public static bool IsValidAttributeName(string name) => throw null;
            public static bool IsValidAttributeValue(string value) => throw null;
            public static bool IsValidTag(string tag) => throw null;
            public static bool IsValidText(string text) => throw null;
            public System.Security.SecurityElement SearchForChildByTag(string tag) => throw null;
            public string SearchForTextOfTag(string tag) => throw null;
            public SecurityElement(string tag) => throw null;
            public SecurityElement(string tag, string text) => throw null;
            public string Tag { get => throw null; set => throw null; }
            public string Text { get => throw null; set => throw null; }
            public override string ToString() => throw null;
        }

        // Generated from `System.Security.SecurityException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class SecurityException : System.SystemException
        {
            public object Demanded { get => throw null; set => throw null; }
            public object DenySetInstance { get => throw null; set => throw null; }
            public System.Reflection.AssemblyName FailedAssemblyInfo { get => throw null; set => throw null; }
            public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public string GrantedSet { get => throw null; set => throw null; }
            public System.Reflection.MethodInfo Method { get => throw null; set => throw null; }
            public string PermissionState { get => throw null; set => throw null; }
            public System.Type PermissionType { get => throw null; set => throw null; }
            public object PermitOnlySetInstance { get => throw null; set => throw null; }
            public string RefusedSet { get => throw null; set => throw null; }
            public SecurityException() => throw null;
            protected SecurityException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public SecurityException(string message) => throw null;
            public SecurityException(string message, System.Exception inner) => throw null;
            public SecurityException(string message, System.Type type) => throw null;
            public SecurityException(string message, System.Type type, string state) => throw null;
            public override string ToString() => throw null;
            public string Url { get => throw null; set => throw null; }
        }

        // Generated from `System.Security.SecurityRuleSet` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum SecurityRuleSet
        {
            Level1,
            Level2,
            None,
        }

        // Generated from `System.Security.SecurityRulesAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class SecurityRulesAttribute : System.Attribute
        {
            public System.Security.SecurityRuleSet RuleSet { get => throw null; }
            public SecurityRulesAttribute(System.Security.SecurityRuleSet ruleSet) => throw null;
            public bool SkipVerificationInFullTrust { get => throw null; set => throw null; }
        }

        // Generated from `System.Security.SecuritySafeCriticalAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class SecuritySafeCriticalAttribute : System.Attribute
        {
            public SecuritySafeCriticalAttribute() => throw null;
        }

        // Generated from `System.Security.SecurityTransparentAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class SecurityTransparentAttribute : System.Attribute
        {
            public SecurityTransparentAttribute() => throw null;
        }

        // Generated from `System.Security.SecurityTreatAsSafeAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class SecurityTreatAsSafeAttribute : System.Attribute
        {
            public SecurityTreatAsSafeAttribute() => throw null;
        }

        // Generated from `System.Security.SuppressUnmanagedCodeSecurityAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class SuppressUnmanagedCodeSecurityAttribute : System.Attribute
        {
            public SuppressUnmanagedCodeSecurityAttribute() => throw null;
        }

        // Generated from `System.Security.UnverifiableCodeAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class UnverifiableCodeAttribute : System.Attribute
        {
            public UnverifiableCodeAttribute() => throw null;
        }

        // Generated from `System.Security.VerificationException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class VerificationException : System.SystemException
        {
            public VerificationException() => throw null;
            protected VerificationException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public VerificationException(string message) => throw null;
            public VerificationException(string message, System.Exception innerException) => throw null;
        }

        namespace Cryptography
        {
            // Generated from `System.Security.Cryptography.CryptographicException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class CryptographicException : System.SystemException
            {
                public CryptographicException() => throw null;
                protected CryptographicException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public CryptographicException(int hr) => throw null;
                public CryptographicException(string message) => throw null;
                public CryptographicException(string message, System.Exception inner) => throw null;
                public CryptographicException(string format, string insert) => throw null;
            }

        }
        namespace Permissions
        {
            // Generated from `System.Security.Permissions.CodeAccessSecurityAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class CodeAccessSecurityAttribute : System.Security.Permissions.SecurityAttribute
            {
                protected CodeAccessSecurityAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
            }

            // Generated from `System.Security.Permissions.PermissionState` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum PermissionState
            {
                None,
                Unrestricted,
            }

            // Generated from `System.Security.Permissions.SecurityAction` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum SecurityAction
            {
                Assert,
                Demand,
                Deny,
                InheritanceDemand,
                LinkDemand,
                PermitOnly,
                RequestMinimum,
                RequestOptional,
                RequestRefuse,
            }

            // Generated from `System.Security.Permissions.SecurityAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class SecurityAttribute : System.Attribute
            {
                public System.Security.Permissions.SecurityAction Action { get => throw null; set => throw null; }
                public abstract System.Security.IPermission CreatePermission();
                protected SecurityAttribute(System.Security.Permissions.SecurityAction action) => throw null;
                public bool Unrestricted { get => throw null; set => throw null; }
            }

            // Generated from `System.Security.Permissions.SecurityPermissionAttribute` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SecurityPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public bool Assertion { get => throw null; set => throw null; }
                public bool BindingRedirects { get => throw null; set => throw null; }
                public bool ControlAppDomain { get => throw null; set => throw null; }
                public bool ControlDomainPolicy { get => throw null; set => throw null; }
                public bool ControlEvidence { get => throw null; set => throw null; }
                public bool ControlPolicy { get => throw null; set => throw null; }
                public bool ControlPrincipal { get => throw null; set => throw null; }
                public bool ControlThread { get => throw null; set => throw null; }
                public override System.Security.IPermission CreatePermission() => throw null;
                public bool Execution { get => throw null; set => throw null; }
                public System.Security.Permissions.SecurityPermissionFlag Flags { get => throw null; set => throw null; }
                public bool Infrastructure { get => throw null; set => throw null; }
                public bool RemotingConfiguration { get => throw null; set => throw null; }
                public SecurityPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public bool SerializationFormatter { get => throw null; set => throw null; }
                public bool SkipVerification { get => throw null; set => throw null; }
                public bool UnmanagedCode { get => throw null; set => throw null; }
            }

            // Generated from `System.Security.Permissions.SecurityPermissionFlag` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum SecurityPermissionFlag
            {
                AllFlags,
                Assertion,
                BindingRedirects,
                ControlAppDomain,
                ControlDomainPolicy,
                ControlEvidence,
                ControlPolicy,
                ControlPrincipal,
                ControlThread,
                Execution,
                Infrastructure,
                NoFlags,
                RemotingConfiguration,
                SerializationFormatter,
                SkipVerification,
                UnmanagedCode,
            }

        }
        namespace Principal
        {
            // Generated from `System.Security.Principal.IIdentity` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IIdentity
            {
                string AuthenticationType { get; }
                bool IsAuthenticated { get; }
                string Name { get; }
            }

            // Generated from `System.Security.Principal.IPrincipal` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IPrincipal
            {
                System.Security.Principal.IIdentity Identity { get; }
                bool IsInRole(string role);
            }

            // Generated from `System.Security.Principal.PrincipalPolicy` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum PrincipalPolicy
            {
                NoPrincipal,
                UnauthenticatedPrincipal,
                WindowsPrincipal,
            }

            // Generated from `System.Security.Principal.TokenImpersonationLevel` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum TokenImpersonationLevel
            {
                Anonymous,
                Delegation,
                Identification,
                Impersonation,
                None,
            }

        }
    }
    namespace Text
    {
        // Generated from `System.Text.Decoder` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class Decoder
        {
            public virtual void Convert(System.Byte[] bytes, int byteIndex, int byteCount, System.Char[] chars, int charIndex, int charCount, bool flush, out int bytesUsed, out int charsUsed, out bool completed) => throw null;
            public virtual void Convert(System.ReadOnlySpan<System.Byte> bytes, System.Span<System.Char> chars, bool flush, out int bytesUsed, out int charsUsed, out bool completed) => throw null;
            unsafe public virtual void Convert(System.Byte* bytes, int byteCount, System.Char* chars, int charCount, bool flush, out int bytesUsed, out int charsUsed, out bool completed) => throw null;
            protected Decoder() => throw null;
            public System.Text.DecoderFallback Fallback { get => throw null; set => throw null; }
            public System.Text.DecoderFallbackBuffer FallbackBuffer { get => throw null; }
            public abstract int GetCharCount(System.Byte[] bytes, int index, int count);
            public virtual int GetCharCount(System.Byte[] bytes, int index, int count, bool flush) => throw null;
            public virtual int GetCharCount(System.ReadOnlySpan<System.Byte> bytes, bool flush) => throw null;
            unsafe public virtual int GetCharCount(System.Byte* bytes, int count, bool flush) => throw null;
            public abstract int GetChars(System.Byte[] bytes, int byteIndex, int byteCount, System.Char[] chars, int charIndex);
            public virtual int GetChars(System.Byte[] bytes, int byteIndex, int byteCount, System.Char[] chars, int charIndex, bool flush) => throw null;
            public virtual int GetChars(System.ReadOnlySpan<System.Byte> bytes, System.Span<System.Char> chars, bool flush) => throw null;
            unsafe public virtual int GetChars(System.Byte* bytes, int byteCount, System.Char* chars, int charCount, bool flush) => throw null;
            public virtual void Reset() => throw null;
        }

        // Generated from `System.Text.DecoderExceptionFallback` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DecoderExceptionFallback : System.Text.DecoderFallback
        {
            public override System.Text.DecoderFallbackBuffer CreateFallbackBuffer() => throw null;
            public DecoderExceptionFallback() => throw null;
            public override bool Equals(object value) => throw null;
            public override int GetHashCode() => throw null;
            public override int MaxCharCount { get => throw null; }
        }

        // Generated from `System.Text.DecoderExceptionFallbackBuffer` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DecoderExceptionFallbackBuffer : System.Text.DecoderFallbackBuffer
        {
            public DecoderExceptionFallbackBuffer() => throw null;
            public override bool Fallback(System.Byte[] bytesUnknown, int index) => throw null;
            public override System.Char GetNextChar() => throw null;
            public override bool MovePrevious() => throw null;
            public override int Remaining { get => throw null; }
        }

        // Generated from `System.Text.DecoderFallback` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class DecoderFallback
        {
            public abstract System.Text.DecoderFallbackBuffer CreateFallbackBuffer();
            protected DecoderFallback() => throw null;
            public static System.Text.DecoderFallback ExceptionFallback { get => throw null; }
            public abstract int MaxCharCount { get; }
            public static System.Text.DecoderFallback ReplacementFallback { get => throw null; }
        }

        // Generated from `System.Text.DecoderFallbackBuffer` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class DecoderFallbackBuffer
        {
            protected DecoderFallbackBuffer() => throw null;
            public abstract bool Fallback(System.Byte[] bytesUnknown, int index);
            public abstract System.Char GetNextChar();
            public abstract bool MovePrevious();
            public abstract int Remaining { get; }
            public virtual void Reset() => throw null;
        }

        // Generated from `System.Text.DecoderFallbackException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DecoderFallbackException : System.ArgumentException
        {
            public System.Byte[] BytesUnknown { get => throw null; }
            public DecoderFallbackException() => throw null;
            public DecoderFallbackException(string message) => throw null;
            public DecoderFallbackException(string message, System.Byte[] bytesUnknown, int index) => throw null;
            public DecoderFallbackException(string message, System.Exception innerException) => throw null;
            public int Index { get => throw null; }
        }

        // Generated from `System.Text.DecoderReplacementFallback` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DecoderReplacementFallback : System.Text.DecoderFallback
        {
            public override System.Text.DecoderFallbackBuffer CreateFallbackBuffer() => throw null;
            public DecoderReplacementFallback() => throw null;
            public DecoderReplacementFallback(string replacement) => throw null;
            public string DefaultString { get => throw null; }
            public override bool Equals(object value) => throw null;
            public override int GetHashCode() => throw null;
            public override int MaxCharCount { get => throw null; }
        }

        // Generated from `System.Text.DecoderReplacementFallbackBuffer` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DecoderReplacementFallbackBuffer : System.Text.DecoderFallbackBuffer
        {
            public DecoderReplacementFallbackBuffer(System.Text.DecoderReplacementFallback fallback) => throw null;
            public override bool Fallback(System.Byte[] bytesUnknown, int index) => throw null;
            public override System.Char GetNextChar() => throw null;
            public override bool MovePrevious() => throw null;
            public override int Remaining { get => throw null; }
            public override void Reset() => throw null;
        }

        // Generated from `System.Text.Encoder` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class Encoder
        {
            public virtual void Convert(System.Char[] chars, int charIndex, int charCount, System.Byte[] bytes, int byteIndex, int byteCount, bool flush, out int charsUsed, out int bytesUsed, out bool completed) => throw null;
            public virtual void Convert(System.ReadOnlySpan<System.Char> chars, System.Span<System.Byte> bytes, bool flush, out int charsUsed, out int bytesUsed, out bool completed) => throw null;
            unsafe public virtual void Convert(System.Char* chars, int charCount, System.Byte* bytes, int byteCount, bool flush, out int charsUsed, out int bytesUsed, out bool completed) => throw null;
            protected Encoder() => throw null;
            public System.Text.EncoderFallback Fallback { get => throw null; set => throw null; }
            public System.Text.EncoderFallbackBuffer FallbackBuffer { get => throw null; }
            public abstract int GetByteCount(System.Char[] chars, int index, int count, bool flush);
            public virtual int GetByteCount(System.ReadOnlySpan<System.Char> chars, bool flush) => throw null;
            unsafe public virtual int GetByteCount(System.Char* chars, int count, bool flush) => throw null;
            public abstract int GetBytes(System.Char[] chars, int charIndex, int charCount, System.Byte[] bytes, int byteIndex, bool flush);
            public virtual int GetBytes(System.ReadOnlySpan<System.Char> chars, System.Span<System.Byte> bytes, bool flush) => throw null;
            unsafe public virtual int GetBytes(System.Char* chars, int charCount, System.Byte* bytes, int byteCount, bool flush) => throw null;
            public virtual void Reset() => throw null;
        }

        // Generated from `System.Text.EncoderExceptionFallback` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class EncoderExceptionFallback : System.Text.EncoderFallback
        {
            public override System.Text.EncoderFallbackBuffer CreateFallbackBuffer() => throw null;
            public EncoderExceptionFallback() => throw null;
            public override bool Equals(object value) => throw null;
            public override int GetHashCode() => throw null;
            public override int MaxCharCount { get => throw null; }
        }

        // Generated from `System.Text.EncoderExceptionFallbackBuffer` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class EncoderExceptionFallbackBuffer : System.Text.EncoderFallbackBuffer
        {
            public EncoderExceptionFallbackBuffer() => throw null;
            public override bool Fallback(System.Char charUnknownHigh, System.Char charUnknownLow, int index) => throw null;
            public override bool Fallback(System.Char charUnknown, int index) => throw null;
            public override System.Char GetNextChar() => throw null;
            public override bool MovePrevious() => throw null;
            public override int Remaining { get => throw null; }
        }

        // Generated from `System.Text.EncoderFallback` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class EncoderFallback
        {
            public abstract System.Text.EncoderFallbackBuffer CreateFallbackBuffer();
            protected EncoderFallback() => throw null;
            public static System.Text.EncoderFallback ExceptionFallback { get => throw null; }
            public abstract int MaxCharCount { get; }
            public static System.Text.EncoderFallback ReplacementFallback { get => throw null; }
        }

        // Generated from `System.Text.EncoderFallbackBuffer` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class EncoderFallbackBuffer
        {
            protected EncoderFallbackBuffer() => throw null;
            public abstract bool Fallback(System.Char charUnknownHigh, System.Char charUnknownLow, int index);
            public abstract bool Fallback(System.Char charUnknown, int index);
            public abstract System.Char GetNextChar();
            public abstract bool MovePrevious();
            public abstract int Remaining { get; }
            public virtual void Reset() => throw null;
        }

        // Generated from `System.Text.EncoderFallbackException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class EncoderFallbackException : System.ArgumentException
        {
            public System.Char CharUnknown { get => throw null; }
            public System.Char CharUnknownHigh { get => throw null; }
            public System.Char CharUnknownLow { get => throw null; }
            public EncoderFallbackException() => throw null;
            public EncoderFallbackException(string message) => throw null;
            public EncoderFallbackException(string message, System.Exception innerException) => throw null;
            public int Index { get => throw null; }
            public bool IsUnknownSurrogate() => throw null;
        }

        // Generated from `System.Text.EncoderReplacementFallback` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class EncoderReplacementFallback : System.Text.EncoderFallback
        {
            public override System.Text.EncoderFallbackBuffer CreateFallbackBuffer() => throw null;
            public string DefaultString { get => throw null; }
            public EncoderReplacementFallback() => throw null;
            public EncoderReplacementFallback(string replacement) => throw null;
            public override bool Equals(object value) => throw null;
            public override int GetHashCode() => throw null;
            public override int MaxCharCount { get => throw null; }
        }

        // Generated from `System.Text.EncoderReplacementFallbackBuffer` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class EncoderReplacementFallbackBuffer : System.Text.EncoderFallbackBuffer
        {
            public EncoderReplacementFallbackBuffer(System.Text.EncoderReplacementFallback fallback) => throw null;
            public override bool Fallback(System.Char charUnknownHigh, System.Char charUnknownLow, int index) => throw null;
            public override bool Fallback(System.Char charUnknown, int index) => throw null;
            public override System.Char GetNextChar() => throw null;
            public override bool MovePrevious() => throw null;
            public override int Remaining { get => throw null; }
            public override void Reset() => throw null;
        }

        // Generated from `System.Text.Encoding` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class Encoding : System.ICloneable
        {
            public static System.Text.Encoding ASCII { get => throw null; }
            public static System.Text.Encoding BigEndianUnicode { get => throw null; }
            public virtual string BodyName { get => throw null; }
            public virtual object Clone() => throw null;
            public virtual int CodePage { get => throw null; }
            public static System.Byte[] Convert(System.Text.Encoding srcEncoding, System.Text.Encoding dstEncoding, System.Byte[] bytes) => throw null;
            public static System.Byte[] Convert(System.Text.Encoding srcEncoding, System.Text.Encoding dstEncoding, System.Byte[] bytes, int index, int count) => throw null;
            public static System.IO.Stream CreateTranscodingStream(System.IO.Stream innerStream, System.Text.Encoding innerStreamEncoding, System.Text.Encoding outerStreamEncoding, bool leaveOpen = default(bool)) => throw null;
            public System.Text.DecoderFallback DecoderFallback { get => throw null; set => throw null; }
            public static System.Text.Encoding Default { get => throw null; }
            public System.Text.EncoderFallback EncoderFallback { get => throw null; set => throw null; }
            protected Encoding() => throw null;
            protected Encoding(int codePage) => throw null;
            protected Encoding(int codePage, System.Text.EncoderFallback encoderFallback, System.Text.DecoderFallback decoderFallback) => throw null;
            public virtual string EncodingName { get => throw null; }
            public override bool Equals(object value) => throw null;
            public virtual int GetByteCount(System.Char[] chars) => throw null;
            public abstract int GetByteCount(System.Char[] chars, int index, int count);
            public virtual int GetByteCount(System.ReadOnlySpan<System.Char> chars) => throw null;
            unsafe public virtual int GetByteCount(System.Char* chars, int count) => throw null;
            public virtual int GetByteCount(string s) => throw null;
            public int GetByteCount(string s, int index, int count) => throw null;
            public virtual System.Byte[] GetBytes(System.Char[] chars) => throw null;
            public virtual System.Byte[] GetBytes(System.Char[] chars, int index, int count) => throw null;
            public abstract int GetBytes(System.Char[] chars, int charIndex, int charCount, System.Byte[] bytes, int byteIndex);
            public virtual int GetBytes(System.ReadOnlySpan<System.Char> chars, System.Span<System.Byte> bytes) => throw null;
            unsafe public virtual int GetBytes(System.Char* chars, int charCount, System.Byte* bytes, int byteCount) => throw null;
            public virtual System.Byte[] GetBytes(string s) => throw null;
            public System.Byte[] GetBytes(string s, int index, int count) => throw null;
            public virtual int GetBytes(string s, int charIndex, int charCount, System.Byte[] bytes, int byteIndex) => throw null;
            public virtual int GetCharCount(System.Byte[] bytes) => throw null;
            public abstract int GetCharCount(System.Byte[] bytes, int index, int count);
            public virtual int GetCharCount(System.ReadOnlySpan<System.Byte> bytes) => throw null;
            unsafe public virtual int GetCharCount(System.Byte* bytes, int count) => throw null;
            public virtual System.Char[] GetChars(System.Byte[] bytes) => throw null;
            public virtual System.Char[] GetChars(System.Byte[] bytes, int index, int count) => throw null;
            public abstract int GetChars(System.Byte[] bytes, int byteIndex, int byteCount, System.Char[] chars, int charIndex);
            public virtual int GetChars(System.ReadOnlySpan<System.Byte> bytes, System.Span<System.Char> chars) => throw null;
            unsafe public virtual int GetChars(System.Byte* bytes, int byteCount, System.Char* chars, int charCount) => throw null;
            public virtual System.Text.Decoder GetDecoder() => throw null;
            public virtual System.Text.Encoder GetEncoder() => throw null;
            public static System.Text.Encoding GetEncoding(int codepage) => throw null;
            public static System.Text.Encoding GetEncoding(int codepage, System.Text.EncoderFallback encoderFallback, System.Text.DecoderFallback decoderFallback) => throw null;
            public static System.Text.Encoding GetEncoding(string name) => throw null;
            public static System.Text.Encoding GetEncoding(string name, System.Text.EncoderFallback encoderFallback, System.Text.DecoderFallback decoderFallback) => throw null;
            public static System.Text.EncodingInfo[] GetEncodings() => throw null;
            public override int GetHashCode() => throw null;
            public abstract int GetMaxByteCount(int charCount);
            public abstract int GetMaxCharCount(int byteCount);
            public virtual System.Byte[] GetPreamble() => throw null;
            public virtual string GetString(System.Byte[] bytes) => throw null;
            public virtual string GetString(System.Byte[] bytes, int index, int count) => throw null;
            public string GetString(System.ReadOnlySpan<System.Byte> bytes) => throw null;
            unsafe public string GetString(System.Byte* bytes, int byteCount) => throw null;
            public virtual string HeaderName { get => throw null; }
            public bool IsAlwaysNormalized() => throw null;
            public virtual bool IsAlwaysNormalized(System.Text.NormalizationForm form) => throw null;
            public virtual bool IsBrowserDisplay { get => throw null; }
            public virtual bool IsBrowserSave { get => throw null; }
            public virtual bool IsMailNewsDisplay { get => throw null; }
            public virtual bool IsMailNewsSave { get => throw null; }
            public bool IsReadOnly { get => throw null; }
            public virtual bool IsSingleByte { get => throw null; }
            public static System.Text.Encoding Latin1 { get => throw null; }
            public virtual System.ReadOnlySpan<System.Byte> Preamble { get => throw null; }
            public static void RegisterProvider(System.Text.EncodingProvider provider) => throw null;
            public static System.Text.Encoding UTF32 { get => throw null; }
            public static System.Text.Encoding UTF7 { get => throw null; }
            public static System.Text.Encoding UTF8 { get => throw null; }
            public static System.Text.Encoding Unicode { get => throw null; }
            public virtual string WebName { get => throw null; }
            public virtual int WindowsCodePage { get => throw null; }
        }

        // Generated from `System.Text.EncodingInfo` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class EncodingInfo
        {
            public int CodePage { get => throw null; }
            public string DisplayName { get => throw null; }
            public EncodingInfo(System.Text.EncodingProvider provider, int codePage, string name, string displayName) => throw null;
            public override bool Equals(object value) => throw null;
            public System.Text.Encoding GetEncoding() => throw null;
            public override int GetHashCode() => throw null;
            public string Name { get => throw null; }
        }

        // Generated from `System.Text.EncodingProvider` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class EncodingProvider
        {
            public EncodingProvider() => throw null;
            public abstract System.Text.Encoding GetEncoding(int codepage);
            public virtual System.Text.Encoding GetEncoding(int codepage, System.Text.EncoderFallback encoderFallback, System.Text.DecoderFallback decoderFallback) => throw null;
            public abstract System.Text.Encoding GetEncoding(string name);
            public virtual System.Text.Encoding GetEncoding(string name, System.Text.EncoderFallback encoderFallback, System.Text.DecoderFallback decoderFallback) => throw null;
            public virtual System.Collections.Generic.IEnumerable<System.Text.EncodingInfo> GetEncodings() => throw null;
        }

        // Generated from `System.Text.NormalizationForm` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum NormalizationForm
        {
            FormC,
            FormD,
            FormKC,
            FormKD,
        }

        // Generated from `System.Text.Rune` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public struct Rune : System.IComparable, System.IComparable<System.Text.Rune>, System.IEquatable<System.Text.Rune>
        {
            public static bool operator !=(System.Text.Rune left, System.Text.Rune right) => throw null;
            public static bool operator <(System.Text.Rune left, System.Text.Rune right) => throw null;
            public static bool operator <=(System.Text.Rune left, System.Text.Rune right) => throw null;
            public static bool operator ==(System.Text.Rune left, System.Text.Rune right) => throw null;
            public static bool operator >(System.Text.Rune left, System.Text.Rune right) => throw null;
            public static bool operator >=(System.Text.Rune left, System.Text.Rune right) => throw null;
            public int CompareTo(System.Text.Rune other) => throw null;
            int System.IComparable.CompareTo(object obj) => throw null;
            public static System.Buffers.OperationStatus DecodeFromUtf16(System.ReadOnlySpan<System.Char> source, out System.Text.Rune result, out int charsConsumed) => throw null;
            public static System.Buffers.OperationStatus DecodeFromUtf8(System.ReadOnlySpan<System.Byte> source, out System.Text.Rune result, out int bytesConsumed) => throw null;
            public static System.Buffers.OperationStatus DecodeLastFromUtf16(System.ReadOnlySpan<System.Char> source, out System.Text.Rune result, out int charsConsumed) => throw null;
            public static System.Buffers.OperationStatus DecodeLastFromUtf8(System.ReadOnlySpan<System.Byte> source, out System.Text.Rune value, out int bytesConsumed) => throw null;
            public int EncodeToUtf16(System.Span<System.Char> destination) => throw null;
            public int EncodeToUtf8(System.Span<System.Byte> destination) => throw null;
            public bool Equals(System.Text.Rune other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public static double GetNumericValue(System.Text.Rune value) => throw null;
            public static System.Text.Rune GetRuneAt(string input, int index) => throw null;
            public static System.Globalization.UnicodeCategory GetUnicodeCategory(System.Text.Rune value) => throw null;
            public bool IsAscii { get => throw null; }
            public bool IsBmp { get => throw null; }
            public static bool IsControl(System.Text.Rune value) => throw null;
            public static bool IsDigit(System.Text.Rune value) => throw null;
            public static bool IsLetter(System.Text.Rune value) => throw null;
            public static bool IsLetterOrDigit(System.Text.Rune value) => throw null;
            public static bool IsLower(System.Text.Rune value) => throw null;
            public static bool IsNumber(System.Text.Rune value) => throw null;
            public static bool IsPunctuation(System.Text.Rune value) => throw null;
            public static bool IsSeparator(System.Text.Rune value) => throw null;
            public static bool IsSymbol(System.Text.Rune value) => throw null;
            public static bool IsUpper(System.Text.Rune value) => throw null;
            public static bool IsValid(int value) => throw null;
            public static bool IsValid(System.UInt32 value) => throw null;
            public static bool IsWhiteSpace(System.Text.Rune value) => throw null;
            public int Plane { get => throw null; }
            public static System.Text.Rune ReplacementChar { get => throw null; }
            // Stub generator skipped constructor 
            public Rune(System.Char ch) => throw null;
            public Rune(System.Char highSurrogate, System.Char lowSurrogate) => throw null;
            public Rune(int value) => throw null;
            public Rune(System.UInt32 value) => throw null;
            public static System.Text.Rune ToLower(System.Text.Rune value, System.Globalization.CultureInfo culture) => throw null;
            public static System.Text.Rune ToLowerInvariant(System.Text.Rune value) => throw null;
            public override string ToString() => throw null;
            public static System.Text.Rune ToUpper(System.Text.Rune value, System.Globalization.CultureInfo culture) => throw null;
            public static System.Text.Rune ToUpperInvariant(System.Text.Rune value) => throw null;
            public static bool TryCreate(System.Char highSurrogate, System.Char lowSurrogate, out System.Text.Rune result) => throw null;
            public static bool TryCreate(System.Char ch, out System.Text.Rune result) => throw null;
            public static bool TryCreate(int value, out System.Text.Rune result) => throw null;
            public static bool TryCreate(System.UInt32 value, out System.Text.Rune result) => throw null;
            public bool TryEncodeToUtf16(System.Span<System.Char> destination, out int charsWritten) => throw null;
            public bool TryEncodeToUtf8(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
            public static bool TryGetRuneAt(string input, int index, out System.Text.Rune value) => throw null;
            public int Utf16SequenceLength { get => throw null; }
            public int Utf8SequenceLength { get => throw null; }
            public int Value { get => throw null; }
            public static explicit operator System.Text.Rune(System.Char ch) => throw null;
            public static explicit operator System.Text.Rune(int value) => throw null;
            public static explicit operator System.Text.Rune(System.UInt32 value) => throw null;
        }

        // Generated from `System.Text.StringBuilder` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class StringBuilder : System.Runtime.Serialization.ISerializable
        {
            // Generated from `System.Text.StringBuilder+ChunkEnumerator` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct ChunkEnumerator
            {
                // Stub generator skipped constructor 
                public System.ReadOnlyMemory<System.Char> Current { get => throw null; }
                public System.Text.StringBuilder.ChunkEnumerator GetEnumerator() => throw null;
                public bool MoveNext() => throw null;
            }


            public System.Text.StringBuilder Append(System.Char[] value) => throw null;
            public System.Text.StringBuilder Append(System.Char[] value, int startIndex, int charCount) => throw null;
            public System.Text.StringBuilder Append(System.ReadOnlyMemory<System.Char> value) => throw null;
            public System.Text.StringBuilder Append(System.ReadOnlySpan<System.Char> value) => throw null;
            public System.Text.StringBuilder Append(System.Text.StringBuilder value) => throw null;
            public System.Text.StringBuilder Append(System.Text.StringBuilder value, int startIndex, int count) => throw null;
            public System.Text.StringBuilder Append(bool value) => throw null;
            public System.Text.StringBuilder Append(System.Byte value) => throw null;
            public System.Text.StringBuilder Append(System.Char value) => throw null;
            unsafe public System.Text.StringBuilder Append(System.Char* value, int valueCount) => throw null;
            public System.Text.StringBuilder Append(System.Char value, int repeatCount) => throw null;
            public System.Text.StringBuilder Append(System.Decimal value) => throw null;
            public System.Text.StringBuilder Append(double value) => throw null;
            public System.Text.StringBuilder Append(float value) => throw null;
            public System.Text.StringBuilder Append(int value) => throw null;
            public System.Text.StringBuilder Append(System.Int64 value) => throw null;
            public System.Text.StringBuilder Append(object value) => throw null;
            public System.Text.StringBuilder Append(System.SByte value) => throw null;
            public System.Text.StringBuilder Append(System.Int16 value) => throw null;
            public System.Text.StringBuilder Append(string value) => throw null;
            public System.Text.StringBuilder Append(string value, int startIndex, int count) => throw null;
            public System.Text.StringBuilder Append(System.UInt32 value) => throw null;
            public System.Text.StringBuilder Append(System.UInt64 value) => throw null;
            public System.Text.StringBuilder Append(System.UInt16 value) => throw null;
            public System.Text.StringBuilder AppendFormat(System.IFormatProvider provider, string format, object arg0) => throw null;
            public System.Text.StringBuilder AppendFormat(System.IFormatProvider provider, string format, object arg0, object arg1) => throw null;
            public System.Text.StringBuilder AppendFormat(System.IFormatProvider provider, string format, object arg0, object arg1, object arg2) => throw null;
            public System.Text.StringBuilder AppendFormat(System.IFormatProvider provider, string format, params object[] args) => throw null;
            public System.Text.StringBuilder AppendFormat(string format, object arg0) => throw null;
            public System.Text.StringBuilder AppendFormat(string format, object arg0, object arg1) => throw null;
            public System.Text.StringBuilder AppendFormat(string format, object arg0, object arg1, object arg2) => throw null;
            public System.Text.StringBuilder AppendFormat(string format, params object[] args) => throw null;
            public System.Text.StringBuilder AppendJoin(System.Char separator, params object[] values) => throw null;
            public System.Text.StringBuilder AppendJoin(System.Char separator, params string[] values) => throw null;
            public System.Text.StringBuilder AppendJoin(string separator, params object[] values) => throw null;
            public System.Text.StringBuilder AppendJoin(string separator, params string[] values) => throw null;
            public System.Text.StringBuilder AppendJoin<T>(System.Char separator, System.Collections.Generic.IEnumerable<T> values) => throw null;
            public System.Text.StringBuilder AppendJoin<T>(string separator, System.Collections.Generic.IEnumerable<T> values) => throw null;
            public System.Text.StringBuilder AppendLine() => throw null;
            public System.Text.StringBuilder AppendLine(string value) => throw null;
            public int Capacity { get => throw null; set => throw null; }
            [System.Runtime.CompilerServices.IndexerName("Chars")]
            public System.Char this[int index] { get => throw null; set => throw null; }
            public System.Text.StringBuilder Clear() => throw null;
            public void CopyTo(int sourceIndex, System.Char[] destination, int destinationIndex, int count) => throw null;
            public void CopyTo(int sourceIndex, System.Span<System.Char> destination, int count) => throw null;
            public int EnsureCapacity(int capacity) => throw null;
            public bool Equals(System.ReadOnlySpan<System.Char> span) => throw null;
            public bool Equals(System.Text.StringBuilder sb) => throw null;
            public System.Text.StringBuilder.ChunkEnumerator GetChunks() => throw null;
            void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public System.Text.StringBuilder Insert(int index, System.Char[] value) => throw null;
            public System.Text.StringBuilder Insert(int index, System.Char[] value, int startIndex, int charCount) => throw null;
            public System.Text.StringBuilder Insert(int index, System.ReadOnlySpan<System.Char> value) => throw null;
            public System.Text.StringBuilder Insert(int index, bool value) => throw null;
            public System.Text.StringBuilder Insert(int index, System.Byte value) => throw null;
            public System.Text.StringBuilder Insert(int index, System.Char value) => throw null;
            public System.Text.StringBuilder Insert(int index, System.Decimal value) => throw null;
            public System.Text.StringBuilder Insert(int index, double value) => throw null;
            public System.Text.StringBuilder Insert(int index, float value) => throw null;
            public System.Text.StringBuilder Insert(int index, int value) => throw null;
            public System.Text.StringBuilder Insert(int index, System.Int64 value) => throw null;
            public System.Text.StringBuilder Insert(int index, object value) => throw null;
            public System.Text.StringBuilder Insert(int index, System.SByte value) => throw null;
            public System.Text.StringBuilder Insert(int index, System.Int16 value) => throw null;
            public System.Text.StringBuilder Insert(int index, string value) => throw null;
            public System.Text.StringBuilder Insert(int index, string value, int count) => throw null;
            public System.Text.StringBuilder Insert(int index, System.UInt32 value) => throw null;
            public System.Text.StringBuilder Insert(int index, System.UInt64 value) => throw null;
            public System.Text.StringBuilder Insert(int index, System.UInt16 value) => throw null;
            public int Length { get => throw null; set => throw null; }
            public int MaxCapacity { get => throw null; }
            public System.Text.StringBuilder Remove(int startIndex, int length) => throw null;
            public System.Text.StringBuilder Replace(System.Char oldChar, System.Char newChar) => throw null;
            public System.Text.StringBuilder Replace(System.Char oldChar, System.Char newChar, int startIndex, int count) => throw null;
            public System.Text.StringBuilder Replace(string oldValue, string newValue) => throw null;
            public System.Text.StringBuilder Replace(string oldValue, string newValue, int startIndex, int count) => throw null;
            public StringBuilder() => throw null;
            public StringBuilder(int capacity) => throw null;
            public StringBuilder(int capacity, int maxCapacity) => throw null;
            public StringBuilder(string value) => throw null;
            public StringBuilder(string value, int capacity) => throw null;
            public StringBuilder(string value, int startIndex, int length, int capacity) => throw null;
            public override string ToString() => throw null;
            public string ToString(int startIndex, int length) => throw null;
        }

        // Generated from `System.Text.StringRuneEnumerator` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public struct StringRuneEnumerator : System.Collections.Generic.IEnumerable<System.Text.Rune>, System.Collections.Generic.IEnumerator<System.Text.Rune>, System.Collections.IEnumerable, System.Collections.IEnumerator, System.IDisposable
        {
            public System.Text.Rune Current { get => throw null; }
            object System.Collections.IEnumerator.Current { get => throw null; }
            void System.IDisposable.Dispose() => throw null;
            public System.Text.StringRuneEnumerator GetEnumerator() => throw null;
            System.Collections.Generic.IEnumerator<System.Text.Rune> System.Collections.Generic.IEnumerable<System.Text.Rune>.GetEnumerator() => throw null;
            System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            public bool MoveNext() => throw null;
            void System.Collections.IEnumerator.Reset() => throw null;
            // Stub generator skipped constructor 
        }

        namespace Unicode
        {
            // Generated from `System.Text.Unicode.Utf8` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class Utf8
            {
                public static System.Buffers.OperationStatus FromUtf16(System.ReadOnlySpan<System.Char> source, System.Span<System.Byte> destination, out int charsRead, out int bytesWritten, bool replaceInvalidSequences = default(bool), bool isFinalBlock = default(bool)) => throw null;
                public static System.Buffers.OperationStatus ToUtf16(System.ReadOnlySpan<System.Byte> source, System.Span<System.Char> destination, out int bytesRead, out int charsWritten, bool replaceInvalidSequences = default(bool), bool isFinalBlock = default(bool)) => throw null;
            }

        }
    }
    namespace Threading
    {
        // Generated from `System.Threading.CancellationToken` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public struct CancellationToken
        {
            public static bool operator !=(System.Threading.CancellationToken left, System.Threading.CancellationToken right) => throw null;
            public static bool operator ==(System.Threading.CancellationToken left, System.Threading.CancellationToken right) => throw null;
            public bool CanBeCanceled { get => throw null; }
            // Stub generator skipped constructor 
            public CancellationToken(bool canceled) => throw null;
            public bool Equals(System.Threading.CancellationToken other) => throw null;
            public override bool Equals(object other) => throw null;
            public override int GetHashCode() => throw null;
            public bool IsCancellationRequested { get => throw null; }
            public static System.Threading.CancellationToken None { get => throw null; }
            public System.Threading.CancellationTokenRegistration Register(System.Action callback) => throw null;
            public System.Threading.CancellationTokenRegistration Register(System.Action callback, bool useSynchronizationContext) => throw null;
            public System.Threading.CancellationTokenRegistration Register(System.Action<object> callback, object state) => throw null;
            public System.Threading.CancellationTokenRegistration Register(System.Action<object> callback, object state, bool useSynchronizationContext) => throw null;
            public void ThrowIfCancellationRequested() => throw null;
            public System.Threading.CancellationTokenRegistration UnsafeRegister(System.Action<object> callback, object state) => throw null;
            public System.Threading.WaitHandle WaitHandle { get => throw null; }
        }

        // Generated from `System.Threading.CancellationTokenRegistration` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public struct CancellationTokenRegistration : System.IAsyncDisposable, System.IDisposable, System.IEquatable<System.Threading.CancellationTokenRegistration>
        {
            public static bool operator !=(System.Threading.CancellationTokenRegistration left, System.Threading.CancellationTokenRegistration right) => throw null;
            public static bool operator ==(System.Threading.CancellationTokenRegistration left, System.Threading.CancellationTokenRegistration right) => throw null;
            // Stub generator skipped constructor 
            public void Dispose() => throw null;
            public System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
            public bool Equals(System.Threading.CancellationTokenRegistration other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public System.Threading.CancellationToken Token { get => throw null; }
            public bool Unregister() => throw null;
        }

        // Generated from `System.Threading.CancellationTokenSource` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class CancellationTokenSource : System.IDisposable
        {
            public void Cancel() => throw null;
            public void Cancel(bool throwOnFirstException) => throw null;
            public void CancelAfter(System.TimeSpan delay) => throw null;
            public void CancelAfter(int millisecondsDelay) => throw null;
            public CancellationTokenSource() => throw null;
            public CancellationTokenSource(System.TimeSpan delay) => throw null;
            public CancellationTokenSource(int millisecondsDelay) => throw null;
            public static System.Threading.CancellationTokenSource CreateLinkedTokenSource(System.Threading.CancellationToken token) => throw null;
            public static System.Threading.CancellationTokenSource CreateLinkedTokenSource(System.Threading.CancellationToken token1, System.Threading.CancellationToken token2) => throw null;
            public static System.Threading.CancellationTokenSource CreateLinkedTokenSource(params System.Threading.CancellationToken[] tokens) => throw null;
            public void Dispose() => throw null;
            protected virtual void Dispose(bool disposing) => throw null;
            public bool IsCancellationRequested { get => throw null; }
            public System.Threading.CancellationToken Token { get => throw null; }
        }

        // Generated from `System.Threading.LazyThreadSafetyMode` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum LazyThreadSafetyMode
        {
            ExecutionAndPublication,
            None,
            PublicationOnly,
        }

        // Generated from `System.Threading.Timeout` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public static class Timeout
        {
            public const int Infinite = default;
            public static System.TimeSpan InfiniteTimeSpan;
        }

        // Generated from `System.Threading.Timer` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class Timer : System.MarshalByRefObject, System.IAsyncDisposable, System.IDisposable
        {
            public static System.Int64 ActiveCount { get => throw null; }
            public bool Change(System.TimeSpan dueTime, System.TimeSpan period) => throw null;
            public bool Change(int dueTime, int period) => throw null;
            public bool Change(System.Int64 dueTime, System.Int64 period) => throw null;
            public bool Change(System.UInt32 dueTime, System.UInt32 period) => throw null;
            public void Dispose() => throw null;
            public bool Dispose(System.Threading.WaitHandle notifyObject) => throw null;
            public System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
            public Timer(System.Threading.TimerCallback callback) => throw null;
            public Timer(System.Threading.TimerCallback callback, object state, System.TimeSpan dueTime, System.TimeSpan period) => throw null;
            public Timer(System.Threading.TimerCallback callback, object state, int dueTime, int period) => throw null;
            public Timer(System.Threading.TimerCallback callback, object state, System.Int64 dueTime, System.Int64 period) => throw null;
            public Timer(System.Threading.TimerCallback callback, object state, System.UInt32 dueTime, System.UInt32 period) => throw null;
        }

        // Generated from `System.Threading.TimerCallback` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public delegate void TimerCallback(object state);

        // Generated from `System.Threading.WaitHandle` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class WaitHandle : System.MarshalByRefObject, System.IDisposable
        {
            public virtual void Close() => throw null;
            public void Dispose() => throw null;
            protected virtual void Dispose(bool explicitDisposing) => throw null;
            public virtual System.IntPtr Handle { get => throw null; set => throw null; }
            protected static System.IntPtr InvalidHandle;
            public Microsoft.Win32.SafeHandles.SafeWaitHandle SafeWaitHandle { get => throw null; set => throw null; }
            public static bool SignalAndWait(System.Threading.WaitHandle toSignal, System.Threading.WaitHandle toWaitOn) => throw null;
            public static bool SignalAndWait(System.Threading.WaitHandle toSignal, System.Threading.WaitHandle toWaitOn, System.TimeSpan timeout, bool exitContext) => throw null;
            public static bool SignalAndWait(System.Threading.WaitHandle toSignal, System.Threading.WaitHandle toWaitOn, int millisecondsTimeout, bool exitContext) => throw null;
            public static bool WaitAll(System.Threading.WaitHandle[] waitHandles) => throw null;
            public static bool WaitAll(System.Threading.WaitHandle[] waitHandles, System.TimeSpan timeout) => throw null;
            public static bool WaitAll(System.Threading.WaitHandle[] waitHandles, System.TimeSpan timeout, bool exitContext) => throw null;
            public static bool WaitAll(System.Threading.WaitHandle[] waitHandles, int millisecondsTimeout) => throw null;
            public static bool WaitAll(System.Threading.WaitHandle[] waitHandles, int millisecondsTimeout, bool exitContext) => throw null;
            public static int WaitAny(System.Threading.WaitHandle[] waitHandles) => throw null;
            public static int WaitAny(System.Threading.WaitHandle[] waitHandles, System.TimeSpan timeout) => throw null;
            public static int WaitAny(System.Threading.WaitHandle[] waitHandles, System.TimeSpan timeout, bool exitContext) => throw null;
            public static int WaitAny(System.Threading.WaitHandle[] waitHandles, int millisecondsTimeout) => throw null;
            public static int WaitAny(System.Threading.WaitHandle[] waitHandles, int millisecondsTimeout, bool exitContext) => throw null;
            protected WaitHandle() => throw null;
            public virtual bool WaitOne() => throw null;
            public virtual bool WaitOne(System.TimeSpan timeout) => throw null;
            public virtual bool WaitOne(System.TimeSpan timeout, bool exitContext) => throw null;
            public virtual bool WaitOne(int millisecondsTimeout) => throw null;
            public virtual bool WaitOne(int millisecondsTimeout, bool exitContext) => throw null;
            public const int WaitTimeout = default;
        }

        // Generated from `System.Threading.WaitHandleExtensions` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public static class WaitHandleExtensions
        {
            public static Microsoft.Win32.SafeHandles.SafeWaitHandle GetSafeWaitHandle(this System.Threading.WaitHandle waitHandle) => throw null;
            public static void SetSafeWaitHandle(this System.Threading.WaitHandle waitHandle, Microsoft.Win32.SafeHandles.SafeWaitHandle value) => throw null;
        }

        namespace Tasks
        {
            // Generated from `System.Threading.Tasks.ConcurrentExclusiveSchedulerPair` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ConcurrentExclusiveSchedulerPair
            {
                public void Complete() => throw null;
                public System.Threading.Tasks.Task Completion { get => throw null; }
                public ConcurrentExclusiveSchedulerPair() => throw null;
                public ConcurrentExclusiveSchedulerPair(System.Threading.Tasks.TaskScheduler taskScheduler) => throw null;
                public ConcurrentExclusiveSchedulerPair(System.Threading.Tasks.TaskScheduler taskScheduler, int maxConcurrencyLevel) => throw null;
                public ConcurrentExclusiveSchedulerPair(System.Threading.Tasks.TaskScheduler taskScheduler, int maxConcurrencyLevel, int maxItemsPerTask) => throw null;
                public System.Threading.Tasks.TaskScheduler ConcurrentScheduler { get => throw null; }
                public System.Threading.Tasks.TaskScheduler ExclusiveScheduler { get => throw null; }
            }

            // Generated from `System.Threading.Tasks.Task` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class Task : System.IAsyncResult, System.IDisposable
            {
                public object AsyncState { get => throw null; }
                System.Threading.WaitHandle System.IAsyncResult.AsyncWaitHandle { get => throw null; }
                bool System.IAsyncResult.CompletedSynchronously { get => throw null; }
                public static System.Threading.Tasks.Task CompletedTask { get => throw null; }
                public System.Runtime.CompilerServices.ConfiguredTaskAwaitable ConfigureAwait(bool continueOnCapturedContext) => throw null;
                public System.Threading.Tasks.Task ContinueWith(System.Action<System.Threading.Tasks.Task, object> continuationAction, object state) => throw null;
                public System.Threading.Tasks.Task ContinueWith(System.Action<System.Threading.Tasks.Task, object> continuationAction, object state, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task ContinueWith(System.Action<System.Threading.Tasks.Task, object> continuationAction, object state, System.Threading.CancellationToken cancellationToken, System.Threading.Tasks.TaskContinuationOptions continuationOptions, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public System.Threading.Tasks.Task ContinueWith(System.Action<System.Threading.Tasks.Task, object> continuationAction, object state, System.Threading.Tasks.TaskContinuationOptions continuationOptions) => throw null;
                public System.Threading.Tasks.Task ContinueWith(System.Action<System.Threading.Tasks.Task, object> continuationAction, object state, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public System.Threading.Tasks.Task ContinueWith(System.Action<System.Threading.Tasks.Task> continuationAction) => throw null;
                public System.Threading.Tasks.Task ContinueWith(System.Action<System.Threading.Tasks.Task> continuationAction, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task ContinueWith(System.Action<System.Threading.Tasks.Task> continuationAction, System.Threading.CancellationToken cancellationToken, System.Threading.Tasks.TaskContinuationOptions continuationOptions, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public System.Threading.Tasks.Task ContinueWith(System.Action<System.Threading.Tasks.Task> continuationAction, System.Threading.Tasks.TaskContinuationOptions continuationOptions) => throw null;
                public System.Threading.Tasks.Task ContinueWith(System.Action<System.Threading.Tasks.Task> continuationAction, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWith<TResult>(System.Func<System.Threading.Tasks.Task, TResult> continuationFunction) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWith<TResult>(System.Func<System.Threading.Tasks.Task, TResult> continuationFunction, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWith<TResult>(System.Func<System.Threading.Tasks.Task, TResult> continuationFunction, System.Threading.CancellationToken cancellationToken, System.Threading.Tasks.TaskContinuationOptions continuationOptions, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWith<TResult>(System.Func<System.Threading.Tasks.Task, TResult> continuationFunction, System.Threading.Tasks.TaskContinuationOptions continuationOptions) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWith<TResult>(System.Func<System.Threading.Tasks.Task, TResult> continuationFunction, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWith<TResult>(System.Func<System.Threading.Tasks.Task, object, TResult> continuationFunction, object state) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWith<TResult>(System.Func<System.Threading.Tasks.Task, object, TResult> continuationFunction, object state, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWith<TResult>(System.Func<System.Threading.Tasks.Task, object, TResult> continuationFunction, object state, System.Threading.CancellationToken cancellationToken, System.Threading.Tasks.TaskContinuationOptions continuationOptions, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWith<TResult>(System.Func<System.Threading.Tasks.Task, object, TResult> continuationFunction, object state, System.Threading.Tasks.TaskContinuationOptions continuationOptions) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWith<TResult>(System.Func<System.Threading.Tasks.Task, object, TResult> continuationFunction, object state, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public System.Threading.Tasks.TaskCreationOptions CreationOptions { get => throw null; }
                public static int? CurrentId { get => throw null; }
                public static System.Threading.Tasks.Task Delay(System.TimeSpan delay) => throw null;
                public static System.Threading.Tasks.Task Delay(System.TimeSpan delay, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task Delay(int millisecondsDelay) => throw null;
                public static System.Threading.Tasks.Task Delay(int millisecondsDelay, System.Threading.CancellationToken cancellationToken) => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public System.AggregateException Exception { get => throw null; }
                public static System.Threading.Tasks.TaskFactory Factory { get => throw null; }
                public static System.Threading.Tasks.Task FromCanceled(System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<TResult> FromCanceled<TResult>(System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task FromException(System.Exception exception) => throw null;
                public static System.Threading.Tasks.Task<TResult> FromException<TResult>(System.Exception exception) => throw null;
                public static System.Threading.Tasks.Task<TResult> FromResult<TResult>(TResult result) => throw null;
                public System.Runtime.CompilerServices.TaskAwaiter GetAwaiter() => throw null;
                public int Id { get => throw null; }
                public bool IsCanceled { get => throw null; }
                public bool IsCompleted { get => throw null; }
                public bool IsCompletedSuccessfully { get => throw null; }
                public bool IsFaulted { get => throw null; }
                public static System.Threading.Tasks.Task Run(System.Action action) => throw null;
                public static System.Threading.Tasks.Task Run(System.Action action, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task Run(System.Func<System.Threading.Tasks.Task> function) => throw null;
                public static System.Threading.Tasks.Task Run(System.Func<System.Threading.Tasks.Task> function, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<TResult> Run<TResult>(System.Func<TResult> function) => throw null;
                public static System.Threading.Tasks.Task<TResult> Run<TResult>(System.Func<TResult> function, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<TResult> Run<TResult>(System.Func<System.Threading.Tasks.Task<TResult>> function) => throw null;
                public static System.Threading.Tasks.Task<TResult> Run<TResult>(System.Func<System.Threading.Tasks.Task<TResult>> function, System.Threading.CancellationToken cancellationToken) => throw null;
                public void RunSynchronously() => throw null;
                public void RunSynchronously(System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public void Start() => throw null;
                public void Start(System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public System.Threading.Tasks.TaskStatus Status { get => throw null; }
                public Task(System.Action action) => throw null;
                public Task(System.Action action, System.Threading.CancellationToken cancellationToken) => throw null;
                public Task(System.Action action, System.Threading.CancellationToken cancellationToken, System.Threading.Tasks.TaskCreationOptions creationOptions) => throw null;
                public Task(System.Action action, System.Threading.Tasks.TaskCreationOptions creationOptions) => throw null;
                public Task(System.Action<object> action, object state) => throw null;
                public Task(System.Action<object> action, object state, System.Threading.CancellationToken cancellationToken) => throw null;
                public Task(System.Action<object> action, object state, System.Threading.CancellationToken cancellationToken, System.Threading.Tasks.TaskCreationOptions creationOptions) => throw null;
                public Task(System.Action<object> action, object state, System.Threading.Tasks.TaskCreationOptions creationOptions) => throw null;
                public void Wait() => throw null;
                public void Wait(System.Threading.CancellationToken cancellationToken) => throw null;
                public bool Wait(System.TimeSpan timeout) => throw null;
                public bool Wait(int millisecondsTimeout) => throw null;
                public bool Wait(int millisecondsTimeout, System.Threading.CancellationToken cancellationToken) => throw null;
                public static void WaitAll(System.Threading.Tasks.Task[] tasks, System.Threading.CancellationToken cancellationToken) => throw null;
                public static bool WaitAll(System.Threading.Tasks.Task[] tasks, System.TimeSpan timeout) => throw null;
                public static bool WaitAll(System.Threading.Tasks.Task[] tasks, int millisecondsTimeout) => throw null;
                public static bool WaitAll(System.Threading.Tasks.Task[] tasks, int millisecondsTimeout, System.Threading.CancellationToken cancellationToken) => throw null;
                public static void WaitAll(params System.Threading.Tasks.Task[] tasks) => throw null;
                public static int WaitAny(System.Threading.Tasks.Task[] tasks, System.Threading.CancellationToken cancellationToken) => throw null;
                public static int WaitAny(System.Threading.Tasks.Task[] tasks, System.TimeSpan timeout) => throw null;
                public static int WaitAny(System.Threading.Tasks.Task[] tasks, int millisecondsTimeout) => throw null;
                public static int WaitAny(System.Threading.Tasks.Task[] tasks, int millisecondsTimeout, System.Threading.CancellationToken cancellationToken) => throw null;
                public static int WaitAny(params System.Threading.Tasks.Task[] tasks) => throw null;
                public static System.Threading.Tasks.Task WhenAll(System.Collections.Generic.IEnumerable<System.Threading.Tasks.Task> tasks) => throw null;
                public static System.Threading.Tasks.Task WhenAll(params System.Threading.Tasks.Task[] tasks) => throw null;
                public static System.Threading.Tasks.Task<TResult[]> WhenAll<TResult>(System.Collections.Generic.IEnumerable<System.Threading.Tasks.Task<TResult>> tasks) => throw null;
                public static System.Threading.Tasks.Task<TResult[]> WhenAll<TResult>(params System.Threading.Tasks.Task<TResult>[] tasks) => throw null;
                public static System.Threading.Tasks.Task<System.Threading.Tasks.Task> WhenAny(System.Collections.Generic.IEnumerable<System.Threading.Tasks.Task> tasks) => throw null;
                public static System.Threading.Tasks.Task<System.Threading.Tasks.Task> WhenAny(System.Threading.Tasks.Task task1, System.Threading.Tasks.Task task2) => throw null;
                public static System.Threading.Tasks.Task<System.Threading.Tasks.Task> WhenAny(params System.Threading.Tasks.Task[] tasks) => throw null;
                public static System.Threading.Tasks.Task<System.Threading.Tasks.Task<TResult>> WhenAny<TResult>(System.Collections.Generic.IEnumerable<System.Threading.Tasks.Task<TResult>> tasks) => throw null;
                public static System.Threading.Tasks.Task<System.Threading.Tasks.Task<TResult>> WhenAny<TResult>(System.Threading.Tasks.Task<TResult> task1, System.Threading.Tasks.Task<TResult> task2) => throw null;
                public static System.Threading.Tasks.Task<System.Threading.Tasks.Task<TResult>> WhenAny<TResult>(params System.Threading.Tasks.Task<TResult>[] tasks) => throw null;
                public static System.Runtime.CompilerServices.YieldAwaitable Yield() => throw null;
            }

            // Generated from `System.Threading.Tasks.Task<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class Task<TResult> : System.Threading.Tasks.Task
            {
                public System.Runtime.CompilerServices.ConfiguredTaskAwaitable<TResult> ConfigureAwait(bool continueOnCapturedContext) => throw null;
                public System.Threading.Tasks.Task ContinueWith(System.Action<System.Threading.Tasks.Task<TResult>, object> continuationAction, object state) => throw null;
                public System.Threading.Tasks.Task ContinueWith(System.Action<System.Threading.Tasks.Task<TResult>, object> continuationAction, object state, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task ContinueWith(System.Action<System.Threading.Tasks.Task<TResult>, object> continuationAction, object state, System.Threading.CancellationToken cancellationToken, System.Threading.Tasks.TaskContinuationOptions continuationOptions, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public System.Threading.Tasks.Task ContinueWith(System.Action<System.Threading.Tasks.Task<TResult>, object> continuationAction, object state, System.Threading.Tasks.TaskContinuationOptions continuationOptions) => throw null;
                public System.Threading.Tasks.Task ContinueWith(System.Action<System.Threading.Tasks.Task<TResult>, object> continuationAction, object state, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public System.Threading.Tasks.Task ContinueWith(System.Action<System.Threading.Tasks.Task<TResult>> continuationAction) => throw null;
                public System.Threading.Tasks.Task ContinueWith(System.Action<System.Threading.Tasks.Task<TResult>> continuationAction, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task ContinueWith(System.Action<System.Threading.Tasks.Task<TResult>> continuationAction, System.Threading.CancellationToken cancellationToken, System.Threading.Tasks.TaskContinuationOptions continuationOptions, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public System.Threading.Tasks.Task ContinueWith(System.Action<System.Threading.Tasks.Task<TResult>> continuationAction, System.Threading.Tasks.TaskContinuationOptions continuationOptions) => throw null;
                public System.Threading.Tasks.Task ContinueWith(System.Action<System.Threading.Tasks.Task<TResult>> continuationAction, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public System.Threading.Tasks.Task<TNewResult> ContinueWith<TNewResult>(System.Func<System.Threading.Tasks.Task<TResult>, TNewResult> continuationFunction) => throw null;
                public System.Threading.Tasks.Task<TNewResult> ContinueWith<TNewResult>(System.Func<System.Threading.Tasks.Task<TResult>, TNewResult> continuationFunction, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<TNewResult> ContinueWith<TNewResult>(System.Func<System.Threading.Tasks.Task<TResult>, TNewResult> continuationFunction, System.Threading.CancellationToken cancellationToken, System.Threading.Tasks.TaskContinuationOptions continuationOptions, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public System.Threading.Tasks.Task<TNewResult> ContinueWith<TNewResult>(System.Func<System.Threading.Tasks.Task<TResult>, TNewResult> continuationFunction, System.Threading.Tasks.TaskContinuationOptions continuationOptions) => throw null;
                public System.Threading.Tasks.Task<TNewResult> ContinueWith<TNewResult>(System.Func<System.Threading.Tasks.Task<TResult>, TNewResult> continuationFunction, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public System.Threading.Tasks.Task<TNewResult> ContinueWith<TNewResult>(System.Func<System.Threading.Tasks.Task<TResult>, object, TNewResult> continuationFunction, object state) => throw null;
                public System.Threading.Tasks.Task<TNewResult> ContinueWith<TNewResult>(System.Func<System.Threading.Tasks.Task<TResult>, object, TNewResult> continuationFunction, object state, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<TNewResult> ContinueWith<TNewResult>(System.Func<System.Threading.Tasks.Task<TResult>, object, TNewResult> continuationFunction, object state, System.Threading.CancellationToken cancellationToken, System.Threading.Tasks.TaskContinuationOptions continuationOptions, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public System.Threading.Tasks.Task<TNewResult> ContinueWith<TNewResult>(System.Func<System.Threading.Tasks.Task<TResult>, object, TNewResult> continuationFunction, object state, System.Threading.Tasks.TaskContinuationOptions continuationOptions) => throw null;
                public System.Threading.Tasks.Task<TNewResult> ContinueWith<TNewResult>(System.Func<System.Threading.Tasks.Task<TResult>, object, TNewResult> continuationFunction, object state, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public static System.Threading.Tasks.TaskFactory<TResult> Factory { get => throw null; }
                public System.Runtime.CompilerServices.TaskAwaiter<TResult> GetAwaiter() => throw null;
                public TResult Result { get => throw null; }
                public Task(System.Func<TResult> function) : base(default(System.Action)) => throw null;
                public Task(System.Func<TResult> function, System.Threading.CancellationToken cancellationToken) : base(default(System.Action)) => throw null;
                public Task(System.Func<TResult> function, System.Threading.CancellationToken cancellationToken, System.Threading.Tasks.TaskCreationOptions creationOptions) : base(default(System.Action)) => throw null;
                public Task(System.Func<TResult> function, System.Threading.Tasks.TaskCreationOptions creationOptions) : base(default(System.Action)) => throw null;
                public Task(System.Func<object, TResult> function, object state) : base(default(System.Action)) => throw null;
                public Task(System.Func<object, TResult> function, object state, System.Threading.CancellationToken cancellationToken) : base(default(System.Action)) => throw null;
                public Task(System.Func<object, TResult> function, object state, System.Threading.CancellationToken cancellationToken, System.Threading.Tasks.TaskCreationOptions creationOptions) : base(default(System.Action)) => throw null;
                public Task(System.Func<object, TResult> function, object state, System.Threading.Tasks.TaskCreationOptions creationOptions) : base(default(System.Action)) => throw null;
            }

            // Generated from `System.Threading.Tasks.TaskAsyncEnumerableExtensions` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class TaskAsyncEnumerableExtensions
            {
                public static System.Runtime.CompilerServices.ConfiguredAsyncDisposable ConfigureAwait(this System.IAsyncDisposable source, bool continueOnCapturedContext) => throw null;
                public static System.Runtime.CompilerServices.ConfiguredCancelableAsyncEnumerable<T> ConfigureAwait<T>(this System.Collections.Generic.IAsyncEnumerable<T> source, bool continueOnCapturedContext) => throw null;
                public static System.Runtime.CompilerServices.ConfiguredCancelableAsyncEnumerable<T> WithCancellation<T>(this System.Collections.Generic.IAsyncEnumerable<T> source, System.Threading.CancellationToken cancellationToken) => throw null;
            }

            // Generated from `System.Threading.Tasks.TaskCanceledException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class TaskCanceledException : System.OperationCanceledException
            {
                public System.Threading.Tasks.Task Task { get => throw null; }
                public TaskCanceledException() => throw null;
                protected TaskCanceledException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public TaskCanceledException(System.Threading.Tasks.Task task) => throw null;
                public TaskCanceledException(string message) => throw null;
                public TaskCanceledException(string message, System.Exception innerException) => throw null;
                public TaskCanceledException(string message, System.Exception innerException, System.Threading.CancellationToken token) => throw null;
            }

            // Generated from `System.Threading.Tasks.TaskCompletionSource` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class TaskCompletionSource
            {
                public void SetCanceled() => throw null;
                public void SetCanceled(System.Threading.CancellationToken cancellationToken) => throw null;
                public void SetException(System.Exception exception) => throw null;
                public void SetException(System.Collections.Generic.IEnumerable<System.Exception> exceptions) => throw null;
                public void SetResult() => throw null;
                public System.Threading.Tasks.Task Task { get => throw null; }
                public TaskCompletionSource() => throw null;
                public TaskCompletionSource(System.Threading.Tasks.TaskCreationOptions creationOptions) => throw null;
                public TaskCompletionSource(object state) => throw null;
                public TaskCompletionSource(object state, System.Threading.Tasks.TaskCreationOptions creationOptions) => throw null;
                public bool TrySetCanceled() => throw null;
                public bool TrySetCanceled(System.Threading.CancellationToken cancellationToken) => throw null;
                public bool TrySetException(System.Exception exception) => throw null;
                public bool TrySetException(System.Collections.Generic.IEnumerable<System.Exception> exceptions) => throw null;
                public bool TrySetResult() => throw null;
            }

            // Generated from `System.Threading.Tasks.TaskCompletionSource<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class TaskCompletionSource<TResult>
            {
                public void SetCanceled() => throw null;
                public void SetCanceled(System.Threading.CancellationToken cancellationToken) => throw null;
                public void SetException(System.Exception exception) => throw null;
                public void SetException(System.Collections.Generic.IEnumerable<System.Exception> exceptions) => throw null;
                public void SetResult(TResult result) => throw null;
                public System.Threading.Tasks.Task<TResult> Task { get => throw null; }
                public TaskCompletionSource() => throw null;
                public TaskCompletionSource(System.Threading.Tasks.TaskCreationOptions creationOptions) => throw null;
                public TaskCompletionSource(object state) => throw null;
                public TaskCompletionSource(object state, System.Threading.Tasks.TaskCreationOptions creationOptions) => throw null;
                public bool TrySetCanceled() => throw null;
                public bool TrySetCanceled(System.Threading.CancellationToken cancellationToken) => throw null;
                public bool TrySetException(System.Exception exception) => throw null;
                public bool TrySetException(System.Collections.Generic.IEnumerable<System.Exception> exceptions) => throw null;
                public bool TrySetResult(TResult result) => throw null;
            }

            // Generated from `System.Threading.Tasks.TaskContinuationOptions` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum TaskContinuationOptions
            {
                AttachedToParent,
                DenyChildAttach,
                ExecuteSynchronously,
                HideScheduler,
                LazyCancellation,
                LongRunning,
                None,
                NotOnCanceled,
                NotOnFaulted,
                NotOnRanToCompletion,
                OnlyOnCanceled,
                OnlyOnFaulted,
                OnlyOnRanToCompletion,
                PreferFairness,
                RunContinuationsAsynchronously,
            }

            // Generated from `System.Threading.Tasks.TaskCreationOptions` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum TaskCreationOptions
            {
                AttachedToParent,
                DenyChildAttach,
                HideScheduler,
                LongRunning,
                None,
                PreferFairness,
                RunContinuationsAsynchronously,
            }

            // Generated from `System.Threading.Tasks.TaskExtensions` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class TaskExtensions
            {
                public static System.Threading.Tasks.Task Unwrap(this System.Threading.Tasks.Task<System.Threading.Tasks.Task> task) => throw null;
                public static System.Threading.Tasks.Task<TResult> Unwrap<TResult>(this System.Threading.Tasks.Task<System.Threading.Tasks.Task<TResult>> task) => throw null;
            }

            // Generated from `System.Threading.Tasks.TaskFactory` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class TaskFactory
            {
                public System.Threading.CancellationToken CancellationToken { get => throw null; }
                public System.Threading.Tasks.TaskContinuationOptions ContinuationOptions { get => throw null; }
                public System.Threading.Tasks.Task ContinueWhenAll(System.Threading.Tasks.Task[] tasks, System.Action<System.Threading.Tasks.Task[]> continuationAction) => throw null;
                public System.Threading.Tasks.Task ContinueWhenAll(System.Threading.Tasks.Task[] tasks, System.Action<System.Threading.Tasks.Task[]> continuationAction, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task ContinueWhenAll(System.Threading.Tasks.Task[] tasks, System.Action<System.Threading.Tasks.Task[]> continuationAction, System.Threading.CancellationToken cancellationToken, System.Threading.Tasks.TaskContinuationOptions continuationOptions, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public System.Threading.Tasks.Task ContinueWhenAll(System.Threading.Tasks.Task[] tasks, System.Action<System.Threading.Tasks.Task[]> continuationAction, System.Threading.Tasks.TaskContinuationOptions continuationOptions) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWhenAll<TAntecedentResult, TResult>(System.Threading.Tasks.Task<TAntecedentResult>[] tasks, System.Func<System.Threading.Tasks.Task<TAntecedentResult>[], TResult> continuationFunction) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWhenAll<TAntecedentResult, TResult>(System.Threading.Tasks.Task<TAntecedentResult>[] tasks, System.Func<System.Threading.Tasks.Task<TAntecedentResult>[], TResult> continuationFunction, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWhenAll<TAntecedentResult, TResult>(System.Threading.Tasks.Task<TAntecedentResult>[] tasks, System.Func<System.Threading.Tasks.Task<TAntecedentResult>[], TResult> continuationFunction, System.Threading.CancellationToken cancellationToken, System.Threading.Tasks.TaskContinuationOptions continuationOptions, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWhenAll<TAntecedentResult, TResult>(System.Threading.Tasks.Task<TAntecedentResult>[] tasks, System.Func<System.Threading.Tasks.Task<TAntecedentResult>[], TResult> continuationFunction, System.Threading.Tasks.TaskContinuationOptions continuationOptions) => throw null;
                public System.Threading.Tasks.Task ContinueWhenAll<TAntecedentResult>(System.Threading.Tasks.Task<TAntecedentResult>[] tasks, System.Action<System.Threading.Tasks.Task<TAntecedentResult>[]> continuationAction) => throw null;
                public System.Threading.Tasks.Task ContinueWhenAll<TAntecedentResult>(System.Threading.Tasks.Task<TAntecedentResult>[] tasks, System.Action<System.Threading.Tasks.Task<TAntecedentResult>[]> continuationAction, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task ContinueWhenAll<TAntecedentResult>(System.Threading.Tasks.Task<TAntecedentResult>[] tasks, System.Action<System.Threading.Tasks.Task<TAntecedentResult>[]> continuationAction, System.Threading.CancellationToken cancellationToken, System.Threading.Tasks.TaskContinuationOptions continuationOptions, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public System.Threading.Tasks.Task ContinueWhenAll<TAntecedentResult>(System.Threading.Tasks.Task<TAntecedentResult>[] tasks, System.Action<System.Threading.Tasks.Task<TAntecedentResult>[]> continuationAction, System.Threading.Tasks.TaskContinuationOptions continuationOptions) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWhenAll<TResult>(System.Threading.Tasks.Task[] tasks, System.Func<System.Threading.Tasks.Task[], TResult> continuationFunction) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWhenAll<TResult>(System.Threading.Tasks.Task[] tasks, System.Func<System.Threading.Tasks.Task[], TResult> continuationFunction, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWhenAll<TResult>(System.Threading.Tasks.Task[] tasks, System.Func<System.Threading.Tasks.Task[], TResult> continuationFunction, System.Threading.CancellationToken cancellationToken, System.Threading.Tasks.TaskContinuationOptions continuationOptions, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWhenAll<TResult>(System.Threading.Tasks.Task[] tasks, System.Func<System.Threading.Tasks.Task[], TResult> continuationFunction, System.Threading.Tasks.TaskContinuationOptions continuationOptions) => throw null;
                public System.Threading.Tasks.Task ContinueWhenAny(System.Threading.Tasks.Task[] tasks, System.Action<System.Threading.Tasks.Task> continuationAction) => throw null;
                public System.Threading.Tasks.Task ContinueWhenAny(System.Threading.Tasks.Task[] tasks, System.Action<System.Threading.Tasks.Task> continuationAction, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task ContinueWhenAny(System.Threading.Tasks.Task[] tasks, System.Action<System.Threading.Tasks.Task> continuationAction, System.Threading.CancellationToken cancellationToken, System.Threading.Tasks.TaskContinuationOptions continuationOptions, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public System.Threading.Tasks.Task ContinueWhenAny(System.Threading.Tasks.Task[] tasks, System.Action<System.Threading.Tasks.Task> continuationAction, System.Threading.Tasks.TaskContinuationOptions continuationOptions) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWhenAny<TAntecedentResult, TResult>(System.Threading.Tasks.Task<TAntecedentResult>[] tasks, System.Func<System.Threading.Tasks.Task<TAntecedentResult>, TResult> continuationFunction) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWhenAny<TAntecedentResult, TResult>(System.Threading.Tasks.Task<TAntecedentResult>[] tasks, System.Func<System.Threading.Tasks.Task<TAntecedentResult>, TResult> continuationFunction, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWhenAny<TAntecedentResult, TResult>(System.Threading.Tasks.Task<TAntecedentResult>[] tasks, System.Func<System.Threading.Tasks.Task<TAntecedentResult>, TResult> continuationFunction, System.Threading.CancellationToken cancellationToken, System.Threading.Tasks.TaskContinuationOptions continuationOptions, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWhenAny<TAntecedentResult, TResult>(System.Threading.Tasks.Task<TAntecedentResult>[] tasks, System.Func<System.Threading.Tasks.Task<TAntecedentResult>, TResult> continuationFunction, System.Threading.Tasks.TaskContinuationOptions continuationOptions) => throw null;
                public System.Threading.Tasks.Task ContinueWhenAny<TAntecedentResult>(System.Threading.Tasks.Task<TAntecedentResult>[] tasks, System.Action<System.Threading.Tasks.Task<TAntecedentResult>> continuationAction) => throw null;
                public System.Threading.Tasks.Task ContinueWhenAny<TAntecedentResult>(System.Threading.Tasks.Task<TAntecedentResult>[] tasks, System.Action<System.Threading.Tasks.Task<TAntecedentResult>> continuationAction, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task ContinueWhenAny<TAntecedentResult>(System.Threading.Tasks.Task<TAntecedentResult>[] tasks, System.Action<System.Threading.Tasks.Task<TAntecedentResult>> continuationAction, System.Threading.CancellationToken cancellationToken, System.Threading.Tasks.TaskContinuationOptions continuationOptions, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public System.Threading.Tasks.Task ContinueWhenAny<TAntecedentResult>(System.Threading.Tasks.Task<TAntecedentResult>[] tasks, System.Action<System.Threading.Tasks.Task<TAntecedentResult>> continuationAction, System.Threading.Tasks.TaskContinuationOptions continuationOptions) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWhenAny<TResult>(System.Threading.Tasks.Task[] tasks, System.Func<System.Threading.Tasks.Task, TResult> continuationFunction) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWhenAny<TResult>(System.Threading.Tasks.Task[] tasks, System.Func<System.Threading.Tasks.Task, TResult> continuationFunction, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWhenAny<TResult>(System.Threading.Tasks.Task[] tasks, System.Func<System.Threading.Tasks.Task, TResult> continuationFunction, System.Threading.CancellationToken cancellationToken, System.Threading.Tasks.TaskContinuationOptions continuationOptions, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWhenAny<TResult>(System.Threading.Tasks.Task[] tasks, System.Func<System.Threading.Tasks.Task, TResult> continuationFunction, System.Threading.Tasks.TaskContinuationOptions continuationOptions) => throw null;
                public System.Threading.Tasks.TaskCreationOptions CreationOptions { get => throw null; }
                public System.Threading.Tasks.Task FromAsync(System.Func<System.AsyncCallback, object, System.IAsyncResult> beginMethod, System.Action<System.IAsyncResult> endMethod, object state) => throw null;
                public System.Threading.Tasks.Task FromAsync(System.Func<System.AsyncCallback, object, System.IAsyncResult> beginMethod, System.Action<System.IAsyncResult> endMethod, object state, System.Threading.Tasks.TaskCreationOptions creationOptions) => throw null;
                public System.Threading.Tasks.Task FromAsync(System.IAsyncResult asyncResult, System.Action<System.IAsyncResult> endMethod) => throw null;
                public System.Threading.Tasks.Task FromAsync(System.IAsyncResult asyncResult, System.Action<System.IAsyncResult> endMethod, System.Threading.Tasks.TaskCreationOptions creationOptions) => throw null;
                public System.Threading.Tasks.Task FromAsync(System.IAsyncResult asyncResult, System.Action<System.IAsyncResult> endMethod, System.Threading.Tasks.TaskCreationOptions creationOptions, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public System.Threading.Tasks.Task<TResult> FromAsync<TArg1, TArg2, TArg3, TResult>(System.Func<TArg1, TArg2, TArg3, System.AsyncCallback, object, System.IAsyncResult> beginMethod, System.Func<System.IAsyncResult, TResult> endMethod, TArg1 arg1, TArg2 arg2, TArg3 arg3, object state) => throw null;
                public System.Threading.Tasks.Task<TResult> FromAsync<TArg1, TArg2, TArg3, TResult>(System.Func<TArg1, TArg2, TArg3, System.AsyncCallback, object, System.IAsyncResult> beginMethod, System.Func<System.IAsyncResult, TResult> endMethod, TArg1 arg1, TArg2 arg2, TArg3 arg3, object state, System.Threading.Tasks.TaskCreationOptions creationOptions) => throw null;
                public System.Threading.Tasks.Task FromAsync<TArg1, TArg2, TArg3>(System.Func<TArg1, TArg2, TArg3, System.AsyncCallback, object, System.IAsyncResult> beginMethod, System.Action<System.IAsyncResult> endMethod, TArg1 arg1, TArg2 arg2, TArg3 arg3, object state) => throw null;
                public System.Threading.Tasks.Task FromAsync<TArg1, TArg2, TArg3>(System.Func<TArg1, TArg2, TArg3, System.AsyncCallback, object, System.IAsyncResult> beginMethod, System.Action<System.IAsyncResult> endMethod, TArg1 arg1, TArg2 arg2, TArg3 arg3, object state, System.Threading.Tasks.TaskCreationOptions creationOptions) => throw null;
                public System.Threading.Tasks.Task<TResult> FromAsync<TArg1, TArg2, TResult>(System.Func<TArg1, TArg2, System.AsyncCallback, object, System.IAsyncResult> beginMethod, System.Func<System.IAsyncResult, TResult> endMethod, TArg1 arg1, TArg2 arg2, object state) => throw null;
                public System.Threading.Tasks.Task<TResult> FromAsync<TArg1, TArg2, TResult>(System.Func<TArg1, TArg2, System.AsyncCallback, object, System.IAsyncResult> beginMethod, System.Func<System.IAsyncResult, TResult> endMethod, TArg1 arg1, TArg2 arg2, object state, System.Threading.Tasks.TaskCreationOptions creationOptions) => throw null;
                public System.Threading.Tasks.Task FromAsync<TArg1, TArg2>(System.Func<TArg1, TArg2, System.AsyncCallback, object, System.IAsyncResult> beginMethod, System.Action<System.IAsyncResult> endMethod, TArg1 arg1, TArg2 arg2, object state) => throw null;
                public System.Threading.Tasks.Task FromAsync<TArg1, TArg2>(System.Func<TArg1, TArg2, System.AsyncCallback, object, System.IAsyncResult> beginMethod, System.Action<System.IAsyncResult> endMethod, TArg1 arg1, TArg2 arg2, object state, System.Threading.Tasks.TaskCreationOptions creationOptions) => throw null;
                public System.Threading.Tasks.Task<TResult> FromAsync<TArg1, TResult>(System.Func<TArg1, System.AsyncCallback, object, System.IAsyncResult> beginMethod, System.Func<System.IAsyncResult, TResult> endMethod, TArg1 arg1, object state) => throw null;
                public System.Threading.Tasks.Task<TResult> FromAsync<TArg1, TResult>(System.Func<TArg1, System.AsyncCallback, object, System.IAsyncResult> beginMethod, System.Func<System.IAsyncResult, TResult> endMethod, TArg1 arg1, object state, System.Threading.Tasks.TaskCreationOptions creationOptions) => throw null;
                public System.Threading.Tasks.Task FromAsync<TArg1>(System.Func<TArg1, System.AsyncCallback, object, System.IAsyncResult> beginMethod, System.Action<System.IAsyncResult> endMethod, TArg1 arg1, object state) => throw null;
                public System.Threading.Tasks.Task FromAsync<TArg1>(System.Func<TArg1, System.AsyncCallback, object, System.IAsyncResult> beginMethod, System.Action<System.IAsyncResult> endMethod, TArg1 arg1, object state, System.Threading.Tasks.TaskCreationOptions creationOptions) => throw null;
                public System.Threading.Tasks.Task<TResult> FromAsync<TResult>(System.Func<System.AsyncCallback, object, System.IAsyncResult> beginMethod, System.Func<System.IAsyncResult, TResult> endMethod, object state) => throw null;
                public System.Threading.Tasks.Task<TResult> FromAsync<TResult>(System.Func<System.AsyncCallback, object, System.IAsyncResult> beginMethod, System.Func<System.IAsyncResult, TResult> endMethod, object state, System.Threading.Tasks.TaskCreationOptions creationOptions) => throw null;
                public System.Threading.Tasks.Task<TResult> FromAsync<TResult>(System.IAsyncResult asyncResult, System.Func<System.IAsyncResult, TResult> endMethod) => throw null;
                public System.Threading.Tasks.Task<TResult> FromAsync<TResult>(System.IAsyncResult asyncResult, System.Func<System.IAsyncResult, TResult> endMethod, System.Threading.Tasks.TaskCreationOptions creationOptions) => throw null;
                public System.Threading.Tasks.Task<TResult> FromAsync<TResult>(System.IAsyncResult asyncResult, System.Func<System.IAsyncResult, TResult> endMethod, System.Threading.Tasks.TaskCreationOptions creationOptions, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public System.Threading.Tasks.TaskScheduler Scheduler { get => throw null; }
                public System.Threading.Tasks.Task StartNew(System.Action action) => throw null;
                public System.Threading.Tasks.Task StartNew(System.Action action, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task StartNew(System.Action action, System.Threading.CancellationToken cancellationToken, System.Threading.Tasks.TaskCreationOptions creationOptions, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public System.Threading.Tasks.Task StartNew(System.Action action, System.Threading.Tasks.TaskCreationOptions creationOptions) => throw null;
                public System.Threading.Tasks.Task StartNew(System.Action<object> action, object state) => throw null;
                public System.Threading.Tasks.Task StartNew(System.Action<object> action, object state, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task StartNew(System.Action<object> action, object state, System.Threading.CancellationToken cancellationToken, System.Threading.Tasks.TaskCreationOptions creationOptions, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public System.Threading.Tasks.Task StartNew(System.Action<object> action, object state, System.Threading.Tasks.TaskCreationOptions creationOptions) => throw null;
                public System.Threading.Tasks.Task<TResult> StartNew<TResult>(System.Func<TResult> function) => throw null;
                public System.Threading.Tasks.Task<TResult> StartNew<TResult>(System.Func<TResult> function, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<TResult> StartNew<TResult>(System.Func<TResult> function, System.Threading.CancellationToken cancellationToken, System.Threading.Tasks.TaskCreationOptions creationOptions, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public System.Threading.Tasks.Task<TResult> StartNew<TResult>(System.Func<TResult> function, System.Threading.Tasks.TaskCreationOptions creationOptions) => throw null;
                public System.Threading.Tasks.Task<TResult> StartNew<TResult>(System.Func<object, TResult> function, object state) => throw null;
                public System.Threading.Tasks.Task<TResult> StartNew<TResult>(System.Func<object, TResult> function, object state, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<TResult> StartNew<TResult>(System.Func<object, TResult> function, object state, System.Threading.CancellationToken cancellationToken, System.Threading.Tasks.TaskCreationOptions creationOptions, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public System.Threading.Tasks.Task<TResult> StartNew<TResult>(System.Func<object, TResult> function, object state, System.Threading.Tasks.TaskCreationOptions creationOptions) => throw null;
                public TaskFactory() => throw null;
                public TaskFactory(System.Threading.CancellationToken cancellationToken) => throw null;
                public TaskFactory(System.Threading.CancellationToken cancellationToken, System.Threading.Tasks.TaskCreationOptions creationOptions, System.Threading.Tasks.TaskContinuationOptions continuationOptions, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public TaskFactory(System.Threading.Tasks.TaskCreationOptions creationOptions, System.Threading.Tasks.TaskContinuationOptions continuationOptions) => throw null;
                public TaskFactory(System.Threading.Tasks.TaskScheduler scheduler) => throw null;
            }

            // Generated from `System.Threading.Tasks.TaskFactory<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class TaskFactory<TResult>
            {
                public System.Threading.CancellationToken CancellationToken { get => throw null; }
                public System.Threading.Tasks.TaskContinuationOptions ContinuationOptions { get => throw null; }
                public System.Threading.Tasks.Task<TResult> ContinueWhenAll(System.Threading.Tasks.Task[] tasks, System.Func<System.Threading.Tasks.Task[], TResult> continuationFunction) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWhenAll(System.Threading.Tasks.Task[] tasks, System.Func<System.Threading.Tasks.Task[], TResult> continuationFunction, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWhenAll(System.Threading.Tasks.Task[] tasks, System.Func<System.Threading.Tasks.Task[], TResult> continuationFunction, System.Threading.CancellationToken cancellationToken, System.Threading.Tasks.TaskContinuationOptions continuationOptions, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWhenAll(System.Threading.Tasks.Task[] tasks, System.Func<System.Threading.Tasks.Task[], TResult> continuationFunction, System.Threading.Tasks.TaskContinuationOptions continuationOptions) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWhenAll<TAntecedentResult>(System.Threading.Tasks.Task<TAntecedentResult>[] tasks, System.Func<System.Threading.Tasks.Task<TAntecedentResult>[], TResult> continuationFunction) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWhenAll<TAntecedentResult>(System.Threading.Tasks.Task<TAntecedentResult>[] tasks, System.Func<System.Threading.Tasks.Task<TAntecedentResult>[], TResult> continuationFunction, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWhenAll<TAntecedentResult>(System.Threading.Tasks.Task<TAntecedentResult>[] tasks, System.Func<System.Threading.Tasks.Task<TAntecedentResult>[], TResult> continuationFunction, System.Threading.CancellationToken cancellationToken, System.Threading.Tasks.TaskContinuationOptions continuationOptions, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWhenAll<TAntecedentResult>(System.Threading.Tasks.Task<TAntecedentResult>[] tasks, System.Func<System.Threading.Tasks.Task<TAntecedentResult>[], TResult> continuationFunction, System.Threading.Tasks.TaskContinuationOptions continuationOptions) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWhenAny(System.Threading.Tasks.Task[] tasks, System.Func<System.Threading.Tasks.Task, TResult> continuationFunction) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWhenAny(System.Threading.Tasks.Task[] tasks, System.Func<System.Threading.Tasks.Task, TResult> continuationFunction, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWhenAny(System.Threading.Tasks.Task[] tasks, System.Func<System.Threading.Tasks.Task, TResult> continuationFunction, System.Threading.CancellationToken cancellationToken, System.Threading.Tasks.TaskContinuationOptions continuationOptions, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWhenAny(System.Threading.Tasks.Task[] tasks, System.Func<System.Threading.Tasks.Task, TResult> continuationFunction, System.Threading.Tasks.TaskContinuationOptions continuationOptions) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWhenAny<TAntecedentResult>(System.Threading.Tasks.Task<TAntecedentResult>[] tasks, System.Func<System.Threading.Tasks.Task<TAntecedentResult>, TResult> continuationFunction) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWhenAny<TAntecedentResult>(System.Threading.Tasks.Task<TAntecedentResult>[] tasks, System.Func<System.Threading.Tasks.Task<TAntecedentResult>, TResult> continuationFunction, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWhenAny<TAntecedentResult>(System.Threading.Tasks.Task<TAntecedentResult>[] tasks, System.Func<System.Threading.Tasks.Task<TAntecedentResult>, TResult> continuationFunction, System.Threading.CancellationToken cancellationToken, System.Threading.Tasks.TaskContinuationOptions continuationOptions, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public System.Threading.Tasks.Task<TResult> ContinueWhenAny<TAntecedentResult>(System.Threading.Tasks.Task<TAntecedentResult>[] tasks, System.Func<System.Threading.Tasks.Task<TAntecedentResult>, TResult> continuationFunction, System.Threading.Tasks.TaskContinuationOptions continuationOptions) => throw null;
                public System.Threading.Tasks.TaskCreationOptions CreationOptions { get => throw null; }
                public System.Threading.Tasks.Task<TResult> FromAsync(System.Func<System.AsyncCallback, object, System.IAsyncResult> beginMethod, System.Func<System.IAsyncResult, TResult> endMethod, object state) => throw null;
                public System.Threading.Tasks.Task<TResult> FromAsync(System.Func<System.AsyncCallback, object, System.IAsyncResult> beginMethod, System.Func<System.IAsyncResult, TResult> endMethod, object state, System.Threading.Tasks.TaskCreationOptions creationOptions) => throw null;
                public System.Threading.Tasks.Task<TResult> FromAsync(System.IAsyncResult asyncResult, System.Func<System.IAsyncResult, TResult> endMethod) => throw null;
                public System.Threading.Tasks.Task<TResult> FromAsync(System.IAsyncResult asyncResult, System.Func<System.IAsyncResult, TResult> endMethod, System.Threading.Tasks.TaskCreationOptions creationOptions) => throw null;
                public System.Threading.Tasks.Task<TResult> FromAsync(System.IAsyncResult asyncResult, System.Func<System.IAsyncResult, TResult> endMethod, System.Threading.Tasks.TaskCreationOptions creationOptions, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public System.Threading.Tasks.Task<TResult> FromAsync<TArg1, TArg2, TArg3>(System.Func<TArg1, TArg2, TArg3, System.AsyncCallback, object, System.IAsyncResult> beginMethod, System.Func<System.IAsyncResult, TResult> endMethod, TArg1 arg1, TArg2 arg2, TArg3 arg3, object state) => throw null;
                public System.Threading.Tasks.Task<TResult> FromAsync<TArg1, TArg2, TArg3>(System.Func<TArg1, TArg2, TArg3, System.AsyncCallback, object, System.IAsyncResult> beginMethod, System.Func<System.IAsyncResult, TResult> endMethod, TArg1 arg1, TArg2 arg2, TArg3 arg3, object state, System.Threading.Tasks.TaskCreationOptions creationOptions) => throw null;
                public System.Threading.Tasks.Task<TResult> FromAsync<TArg1, TArg2>(System.Func<TArg1, TArg2, System.AsyncCallback, object, System.IAsyncResult> beginMethod, System.Func<System.IAsyncResult, TResult> endMethod, TArg1 arg1, TArg2 arg2, object state) => throw null;
                public System.Threading.Tasks.Task<TResult> FromAsync<TArg1, TArg2>(System.Func<TArg1, TArg2, System.AsyncCallback, object, System.IAsyncResult> beginMethod, System.Func<System.IAsyncResult, TResult> endMethod, TArg1 arg1, TArg2 arg2, object state, System.Threading.Tasks.TaskCreationOptions creationOptions) => throw null;
                public System.Threading.Tasks.Task<TResult> FromAsync<TArg1>(System.Func<TArg1, System.AsyncCallback, object, System.IAsyncResult> beginMethod, System.Func<System.IAsyncResult, TResult> endMethod, TArg1 arg1, object state) => throw null;
                public System.Threading.Tasks.Task<TResult> FromAsync<TArg1>(System.Func<TArg1, System.AsyncCallback, object, System.IAsyncResult> beginMethod, System.Func<System.IAsyncResult, TResult> endMethod, TArg1 arg1, object state, System.Threading.Tasks.TaskCreationOptions creationOptions) => throw null;
                public System.Threading.Tasks.TaskScheduler Scheduler { get => throw null; }
                public System.Threading.Tasks.Task<TResult> StartNew(System.Func<TResult> function) => throw null;
                public System.Threading.Tasks.Task<TResult> StartNew(System.Func<TResult> function, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<TResult> StartNew(System.Func<TResult> function, System.Threading.CancellationToken cancellationToken, System.Threading.Tasks.TaskCreationOptions creationOptions, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public System.Threading.Tasks.Task<TResult> StartNew(System.Func<TResult> function, System.Threading.Tasks.TaskCreationOptions creationOptions) => throw null;
                public System.Threading.Tasks.Task<TResult> StartNew(System.Func<object, TResult> function, object state) => throw null;
                public System.Threading.Tasks.Task<TResult> StartNew(System.Func<object, TResult> function, object state, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<TResult> StartNew(System.Func<object, TResult> function, object state, System.Threading.CancellationToken cancellationToken, System.Threading.Tasks.TaskCreationOptions creationOptions, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public System.Threading.Tasks.Task<TResult> StartNew(System.Func<object, TResult> function, object state, System.Threading.Tasks.TaskCreationOptions creationOptions) => throw null;
                public TaskFactory() => throw null;
                public TaskFactory(System.Threading.CancellationToken cancellationToken) => throw null;
                public TaskFactory(System.Threading.CancellationToken cancellationToken, System.Threading.Tasks.TaskCreationOptions creationOptions, System.Threading.Tasks.TaskContinuationOptions continuationOptions, System.Threading.Tasks.TaskScheduler scheduler) => throw null;
                public TaskFactory(System.Threading.Tasks.TaskCreationOptions creationOptions, System.Threading.Tasks.TaskContinuationOptions continuationOptions) => throw null;
                public TaskFactory(System.Threading.Tasks.TaskScheduler scheduler) => throw null;
            }

            // Generated from `System.Threading.Tasks.TaskScheduler` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class TaskScheduler
            {
                public static System.Threading.Tasks.TaskScheduler Current { get => throw null; }
                public static System.Threading.Tasks.TaskScheduler Default { get => throw null; }
                public static System.Threading.Tasks.TaskScheduler FromCurrentSynchronizationContext() => throw null;
                protected abstract System.Collections.Generic.IEnumerable<System.Threading.Tasks.Task> GetScheduledTasks();
                public int Id { get => throw null; }
                public virtual int MaximumConcurrencyLevel { get => throw null; }
                protected internal abstract void QueueTask(System.Threading.Tasks.Task task);
                protected TaskScheduler() => throw null;
                protected internal virtual bool TryDequeue(System.Threading.Tasks.Task task) => throw null;
                protected bool TryExecuteTask(System.Threading.Tasks.Task task) => throw null;
                protected abstract bool TryExecuteTaskInline(System.Threading.Tasks.Task task, bool taskWasPreviouslyQueued);
                public static event System.EventHandler<System.Threading.Tasks.UnobservedTaskExceptionEventArgs> UnobservedTaskException;
            }

            // Generated from `System.Threading.Tasks.TaskSchedulerException` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class TaskSchedulerException : System.Exception
            {
                public TaskSchedulerException() => throw null;
                public TaskSchedulerException(System.Exception innerException) => throw null;
                protected TaskSchedulerException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public TaskSchedulerException(string message) => throw null;
                public TaskSchedulerException(string message, System.Exception innerException) => throw null;
            }

            // Generated from `System.Threading.Tasks.TaskStatus` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum TaskStatus
            {
                Canceled,
                Created,
                Faulted,
                RanToCompletion,
                Running,
                WaitingForActivation,
                WaitingForChildrenToComplete,
                WaitingToRun,
            }

            // Generated from `System.Threading.Tasks.UnobservedTaskExceptionEventArgs` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class UnobservedTaskExceptionEventArgs : System.EventArgs
            {
                public System.AggregateException Exception { get => throw null; }
                public bool Observed { get => throw null; }
                public void SetObserved() => throw null;
                public UnobservedTaskExceptionEventArgs(System.AggregateException exception) => throw null;
            }

            // Generated from `System.Threading.Tasks.ValueTask` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct ValueTask : System.IEquatable<System.Threading.Tasks.ValueTask>
            {
                public static bool operator !=(System.Threading.Tasks.ValueTask left, System.Threading.Tasks.ValueTask right) => throw null;
                public static bool operator ==(System.Threading.Tasks.ValueTask left, System.Threading.Tasks.ValueTask right) => throw null;
                public System.Threading.Tasks.Task AsTask() => throw null;
                public static System.Threading.Tasks.ValueTask CompletedTask { get => throw null; }
                public System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable ConfigureAwait(bool continueOnCapturedContext) => throw null;
                public bool Equals(System.Threading.Tasks.ValueTask other) => throw null;
                public override bool Equals(object obj) => throw null;
                public static System.Threading.Tasks.ValueTask FromCanceled(System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.ValueTask<TResult> FromCanceled<TResult>(System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.ValueTask FromException(System.Exception exception) => throw null;
                public static System.Threading.Tasks.ValueTask<TResult> FromException<TResult>(System.Exception exception) => throw null;
                public static System.Threading.Tasks.ValueTask<TResult> FromResult<TResult>(TResult result) => throw null;
                public System.Runtime.CompilerServices.ValueTaskAwaiter GetAwaiter() => throw null;
                public override int GetHashCode() => throw null;
                public bool IsCanceled { get => throw null; }
                public bool IsCompleted { get => throw null; }
                public bool IsCompletedSuccessfully { get => throw null; }
                public bool IsFaulted { get => throw null; }
                public System.Threading.Tasks.ValueTask Preserve() => throw null;
                // Stub generator skipped constructor 
                public ValueTask(System.Threading.Tasks.Sources.IValueTaskSource source, System.Int16 token) => throw null;
                public ValueTask(System.Threading.Tasks.Task task) => throw null;
            }

            // Generated from `System.Threading.Tasks.ValueTask<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct ValueTask<TResult> : System.IEquatable<System.Threading.Tasks.ValueTask<TResult>>
            {
                public static bool operator !=(System.Threading.Tasks.ValueTask<TResult> left, System.Threading.Tasks.ValueTask<TResult> right) => throw null;
                public static bool operator ==(System.Threading.Tasks.ValueTask<TResult> left, System.Threading.Tasks.ValueTask<TResult> right) => throw null;
                public System.Threading.Tasks.Task<TResult> AsTask() => throw null;
                public System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable<TResult> ConfigureAwait(bool continueOnCapturedContext) => throw null;
                public bool Equals(System.Threading.Tasks.ValueTask<TResult> other) => throw null;
                public override bool Equals(object obj) => throw null;
                public System.Runtime.CompilerServices.ValueTaskAwaiter<TResult> GetAwaiter() => throw null;
                public override int GetHashCode() => throw null;
                public bool IsCanceled { get => throw null; }
                public bool IsCompleted { get => throw null; }
                public bool IsCompletedSuccessfully { get => throw null; }
                public bool IsFaulted { get => throw null; }
                public System.Threading.Tasks.ValueTask<TResult> Preserve() => throw null;
                public TResult Result { get => throw null; }
                public override string ToString() => throw null;
                // Stub generator skipped constructor 
                public ValueTask(System.Threading.Tasks.Sources.IValueTaskSource<TResult> source, System.Int16 token) => throw null;
                public ValueTask(TResult result) => throw null;
                public ValueTask(System.Threading.Tasks.Task<TResult> task) => throw null;
            }

            namespace Sources
            {
                // Generated from `System.Threading.Tasks.Sources.IValueTaskSource` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public interface IValueTaskSource
                {
                    void GetResult(System.Int16 token);
                    System.Threading.Tasks.Sources.ValueTaskSourceStatus GetStatus(System.Int16 token);
                    void OnCompleted(System.Action<object> continuation, object state, System.Int16 token, System.Threading.Tasks.Sources.ValueTaskSourceOnCompletedFlags flags);
                }

                // Generated from `System.Threading.Tasks.Sources.IValueTaskSource<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public interface IValueTaskSource<TResult>
                {
                    TResult GetResult(System.Int16 token);
                    System.Threading.Tasks.Sources.ValueTaskSourceStatus GetStatus(System.Int16 token);
                    void OnCompleted(System.Action<object> continuation, object state, System.Int16 token, System.Threading.Tasks.Sources.ValueTaskSourceOnCompletedFlags flags);
                }

                // Generated from `System.Threading.Tasks.Sources.ManualResetValueTaskSourceCore<>` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public struct ManualResetValueTaskSourceCore<TResult>
                {
                    public TResult GetResult(System.Int16 token) => throw null;
                    public System.Threading.Tasks.Sources.ValueTaskSourceStatus GetStatus(System.Int16 token) => throw null;
                    // Stub generator skipped constructor 
                    public void OnCompleted(System.Action<object> continuation, object state, System.Int16 token, System.Threading.Tasks.Sources.ValueTaskSourceOnCompletedFlags flags) => throw null;
                    public void Reset() => throw null;
                    public bool RunContinuationsAsynchronously { get => throw null; set => throw null; }
                    public void SetException(System.Exception error) => throw null;
                    public void SetResult(TResult result) => throw null;
                    public System.Int16 Version { get => throw null; }
                }

                // Generated from `System.Threading.Tasks.Sources.ValueTaskSourceOnCompletedFlags` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                [System.Flags]
                public enum ValueTaskSourceOnCompletedFlags
                {
                    FlowExecutionContext,
                    None,
                    UseSchedulingContext,
                }

                // Generated from `System.Threading.Tasks.Sources.ValueTaskSourceStatus` in `System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public enum ValueTaskSourceStatus
                {
                    Canceled,
                    Faulted,
                    Pending,
                    Succeeded,
                }

            }
        }
    }
}
