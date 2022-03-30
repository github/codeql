// This file contains auto-generated code.

namespace System
{
    // Generated from `System.DataMisalignedException` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class DataMisalignedException : System.SystemException
    {
        public DataMisalignedException() => throw null;
        public DataMisalignedException(string message) => throw null;
        public DataMisalignedException(string message, System.Exception innerException) => throw null;
    }

    // Generated from `System.DllNotFoundException` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class DllNotFoundException : System.TypeLoadException
    {
        public DllNotFoundException() => throw null;
        protected DllNotFoundException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public DllNotFoundException(string message) => throw null;
        public DllNotFoundException(string message, System.Exception inner) => throw null;
    }

    namespace IO
    {
        // Generated from `System.IO.UnmanagedMemoryAccessor` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class UnmanagedMemoryAccessor : System.IDisposable
        {
            public bool CanRead { get => throw null; }
            public bool CanWrite { get => throw null; }
            public System.Int64 Capacity { get => throw null; }
            public void Dispose() => throw null;
            protected virtual void Dispose(bool disposing) => throw null;
            protected void Initialize(System.Runtime.InteropServices.SafeBuffer buffer, System.Int64 offset, System.Int64 capacity, System.IO.FileAccess access) => throw null;
            protected bool IsOpen { get => throw null; }
            public void Read<T>(System.Int64 position, out T structure) where T : struct => throw null;
            public int ReadArray<T>(System.Int64 position, T[] array, int offset, int count) where T : struct => throw null;
            public bool ReadBoolean(System.Int64 position) => throw null;
            public System.Byte ReadByte(System.Int64 position) => throw null;
            public System.Char ReadChar(System.Int64 position) => throw null;
            public System.Decimal ReadDecimal(System.Int64 position) => throw null;
            public double ReadDouble(System.Int64 position) => throw null;
            public System.Int16 ReadInt16(System.Int64 position) => throw null;
            public int ReadInt32(System.Int64 position) => throw null;
            public System.Int64 ReadInt64(System.Int64 position) => throw null;
            public System.SByte ReadSByte(System.Int64 position) => throw null;
            public float ReadSingle(System.Int64 position) => throw null;
            public System.UInt16 ReadUInt16(System.Int64 position) => throw null;
            public System.UInt32 ReadUInt32(System.Int64 position) => throw null;
            public System.UInt64 ReadUInt64(System.Int64 position) => throw null;
            protected UnmanagedMemoryAccessor() => throw null;
            public UnmanagedMemoryAccessor(System.Runtime.InteropServices.SafeBuffer buffer, System.Int64 offset, System.Int64 capacity) => throw null;
            public UnmanagedMemoryAccessor(System.Runtime.InteropServices.SafeBuffer buffer, System.Int64 offset, System.Int64 capacity, System.IO.FileAccess access) => throw null;
            public void Write(System.Int64 position, bool value) => throw null;
            public void Write(System.Int64 position, System.Byte value) => throw null;
            public void Write(System.Int64 position, System.Char value) => throw null;
            public void Write(System.Int64 position, System.Decimal value) => throw null;
            public void Write(System.Int64 position, double value) => throw null;
            public void Write(System.Int64 position, float value) => throw null;
            public void Write(System.Int64 position, int value) => throw null;
            public void Write(System.Int64 position, System.Int64 value) => throw null;
            public void Write(System.Int64 position, System.SByte value) => throw null;
            public void Write(System.Int64 position, System.Int16 value) => throw null;
            public void Write(System.Int64 position, System.UInt32 value) => throw null;
            public void Write(System.Int64 position, System.UInt64 value) => throw null;
            public void Write(System.Int64 position, System.UInt16 value) => throw null;
            public void Write<T>(System.Int64 position, ref T structure) where T : struct => throw null;
            public void WriteArray<T>(System.Int64 position, T[] array, int offset, int count) where T : struct => throw null;
        }

    }
    namespace Runtime
    {
        namespace CompilerServices
        {
            // Generated from `System.Runtime.CompilerServices.IDispatchConstantAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class IDispatchConstantAttribute : System.Runtime.CompilerServices.CustomConstantAttribute
            {
                public IDispatchConstantAttribute() => throw null;
                public override object Value { get => throw null; }
            }

            // Generated from `System.Runtime.CompilerServices.IUnknownConstantAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class IUnknownConstantAttribute : System.Runtime.CompilerServices.CustomConstantAttribute
            {
                public IUnknownConstantAttribute() => throw null;
                public override object Value { get => throw null; }
            }

        }
        namespace InteropServices
        {
            // Generated from `System.Runtime.InteropServices.AllowReversePInvokeCallsAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class AllowReversePInvokeCallsAttribute : System.Attribute
            {
                public AllowReversePInvokeCallsAttribute() => throw null;
            }

            // Generated from `System.Runtime.InteropServices.ArrayWithOffset` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct ArrayWithOffset
            {
                public static bool operator !=(System.Runtime.InteropServices.ArrayWithOffset a, System.Runtime.InteropServices.ArrayWithOffset b) => throw null;
                public static bool operator ==(System.Runtime.InteropServices.ArrayWithOffset a, System.Runtime.InteropServices.ArrayWithOffset b) => throw null;
                // Stub generator skipped constructor 
                public ArrayWithOffset(object array, int offset) => throw null;
                public bool Equals(System.Runtime.InteropServices.ArrayWithOffset obj) => throw null;
                public override bool Equals(object obj) => throw null;
                public object GetArray() => throw null;
                public override int GetHashCode() => throw null;
                public int GetOffset() => throw null;
            }

            // Generated from `System.Runtime.InteropServices.AutomationProxyAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class AutomationProxyAttribute : System.Attribute
            {
                public AutomationProxyAttribute(bool val) => throw null;
                public bool Value { get => throw null; }
            }

            // Generated from `System.Runtime.InteropServices.BStrWrapper` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class BStrWrapper
            {
                public BStrWrapper(object value) => throw null;
                public BStrWrapper(string value) => throw null;
                public string WrappedObject { get => throw null; }
            }

            // Generated from `System.Runtime.InteropServices.BestFitMappingAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class BestFitMappingAttribute : System.Attribute
            {
                public bool BestFitMapping { get => throw null; }
                public BestFitMappingAttribute(bool BestFitMapping) => throw null;
                public bool ThrowOnUnmappableChar;
            }

            // Generated from `System.Runtime.InteropServices.COMException` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class COMException : System.Runtime.InteropServices.ExternalException
            {
                public COMException() => throw null;
                protected COMException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public COMException(string message) => throw null;
                public COMException(string message, System.Exception inner) => throw null;
                public COMException(string message, int errorCode) => throw null;
                public override string ToString() => throw null;
            }

            // Generated from `System.Runtime.InteropServices.CallingConvention` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum CallingConvention
            {
                Cdecl,
                FastCall,
                StdCall,
                ThisCall,
                Winapi,
            }

            // Generated from `System.Runtime.InteropServices.ClassInterfaceAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ClassInterfaceAttribute : System.Attribute
            {
                public ClassInterfaceAttribute(System.Runtime.InteropServices.ClassInterfaceType classInterfaceType) => throw null;
                public ClassInterfaceAttribute(System.Int16 classInterfaceType) => throw null;
                public System.Runtime.InteropServices.ClassInterfaceType Value { get => throw null; }
            }

            // Generated from `System.Runtime.InteropServices.ClassInterfaceType` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum ClassInterfaceType
            {
                AutoDispatch,
                AutoDual,
                None,
            }

            // Generated from `System.Runtime.InteropServices.CoClassAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class CoClassAttribute : System.Attribute
            {
                public System.Type CoClass { get => throw null; }
                public CoClassAttribute(System.Type coClass) => throw null;
            }

            // Generated from `System.Runtime.InteropServices.CollectionsMarshal` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class CollectionsMarshal
            {
                public static System.Span<T> AsSpan<T>(System.Collections.Generic.List<T> list) => throw null;
            }

            // Generated from `System.Runtime.InteropServices.ComAliasNameAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ComAliasNameAttribute : System.Attribute
            {
                public ComAliasNameAttribute(string alias) => throw null;
                public string Value { get => throw null; }
            }

            // Generated from `System.Runtime.InteropServices.ComAwareEventInfo` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ComAwareEventInfo : System.Reflection.EventInfo
            {
                public override void AddEventHandler(object target, System.Delegate handler) => throw null;
                public override System.Reflection.EventAttributes Attributes { get => throw null; }
                public ComAwareEventInfo(System.Type type, string eventName) => throw null;
                public override System.Type DeclaringType { get => throw null; }
                public override System.Reflection.MethodInfo GetAddMethod(bool nonPublic) => throw null;
                public override object[] GetCustomAttributes(System.Type attributeType, bool inherit) => throw null;
                public override object[] GetCustomAttributes(bool inherit) => throw null;
                public override System.Collections.Generic.IList<System.Reflection.CustomAttributeData> GetCustomAttributesData() => throw null;
                public override System.Reflection.MethodInfo[] GetOtherMethods(bool nonPublic) => throw null;
                public override System.Reflection.MethodInfo GetRaiseMethod(bool nonPublic) => throw null;
                public override System.Reflection.MethodInfo GetRemoveMethod(bool nonPublic) => throw null;
                public override bool IsDefined(System.Type attributeType, bool inherit) => throw null;
                public override int MetadataToken { get => throw null; }
                public override System.Reflection.Module Module { get => throw null; }
                public override string Name { get => throw null; }
                public override System.Type ReflectedType { get => throw null; }
                public override void RemoveEventHandler(object target, System.Delegate handler) => throw null;
            }

            // Generated from `System.Runtime.InteropServices.ComCompatibleVersionAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ComCompatibleVersionAttribute : System.Attribute
            {
                public int BuildNumber { get => throw null; }
                public ComCompatibleVersionAttribute(int major, int minor, int build, int revision) => throw null;
                public int MajorVersion { get => throw null; }
                public int MinorVersion { get => throw null; }
                public int RevisionNumber { get => throw null; }
            }

            // Generated from `System.Runtime.InteropServices.ComConversionLossAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ComConversionLossAttribute : System.Attribute
            {
                public ComConversionLossAttribute() => throw null;
            }

            // Generated from `System.Runtime.InteropServices.ComDefaultInterfaceAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ComDefaultInterfaceAttribute : System.Attribute
            {
                public ComDefaultInterfaceAttribute(System.Type defaultInterface) => throw null;
                public System.Type Value { get => throw null; }
            }

            // Generated from `System.Runtime.InteropServices.ComEventInterfaceAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ComEventInterfaceAttribute : System.Attribute
            {
                public ComEventInterfaceAttribute(System.Type SourceInterface, System.Type EventProvider) => throw null;
                public System.Type EventProvider { get => throw null; }
                public System.Type SourceInterface { get => throw null; }
            }

            // Generated from `System.Runtime.InteropServices.ComEventsHelper` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class ComEventsHelper
            {
                public static void Combine(object rcw, System.Guid iid, int dispid, System.Delegate d) => throw null;
                public static System.Delegate Remove(object rcw, System.Guid iid, int dispid, System.Delegate d) => throw null;
            }

            // Generated from `System.Runtime.InteropServices.ComImportAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ComImportAttribute : System.Attribute
            {
                public ComImportAttribute() => throw null;
            }

            // Generated from `System.Runtime.InteropServices.ComInterfaceType` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum ComInterfaceType
            {
                InterfaceIsDual,
                InterfaceIsIDispatch,
                InterfaceIsIInspectable,
                InterfaceIsIUnknown,
            }

            // Generated from `System.Runtime.InteropServices.ComMemberType` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum ComMemberType
            {
                Method,
                PropGet,
                PropSet,
            }

            // Generated from `System.Runtime.InteropServices.ComRegisterFunctionAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ComRegisterFunctionAttribute : System.Attribute
            {
                public ComRegisterFunctionAttribute() => throw null;
            }

            // Generated from `System.Runtime.InteropServices.ComSourceInterfacesAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ComSourceInterfacesAttribute : System.Attribute
            {
                public ComSourceInterfacesAttribute(System.Type sourceInterface) => throw null;
                public ComSourceInterfacesAttribute(System.Type sourceInterface1, System.Type sourceInterface2) => throw null;
                public ComSourceInterfacesAttribute(System.Type sourceInterface1, System.Type sourceInterface2, System.Type sourceInterface3) => throw null;
                public ComSourceInterfacesAttribute(System.Type sourceInterface1, System.Type sourceInterface2, System.Type sourceInterface3, System.Type sourceInterface4) => throw null;
                public ComSourceInterfacesAttribute(string sourceInterfaces) => throw null;
                public string Value { get => throw null; }
            }

            // Generated from `System.Runtime.InteropServices.ComUnregisterFunctionAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ComUnregisterFunctionAttribute : System.Attribute
            {
                public ComUnregisterFunctionAttribute() => throw null;
            }

            // Generated from `System.Runtime.InteropServices.ComWrappers` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class ComWrappers
            {
                // Generated from `System.Runtime.InteropServices.ComWrappers+ComInterfaceDispatch` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public struct ComInterfaceDispatch
                {
                    // Stub generator skipped constructor 
                    unsafe public static T GetInstance<T>(System.Runtime.InteropServices.ComWrappers.ComInterfaceDispatch* dispatchPtr) where T : class => throw null;
                    public System.IntPtr Vtable;
                }


                // Generated from `System.Runtime.InteropServices.ComWrappers+ComInterfaceEntry` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public struct ComInterfaceEntry
                {
                    // Stub generator skipped constructor 
                    public System.Guid IID;
                    public System.IntPtr Vtable;
                }


                protected ComWrappers() => throw null;
                unsafe protected abstract System.Runtime.InteropServices.ComWrappers.ComInterfaceEntry* ComputeVtables(object obj, System.Runtime.InteropServices.CreateComInterfaceFlags flags, out int count);
                protected abstract object CreateObject(System.IntPtr externalComObject, System.Runtime.InteropServices.CreateObjectFlags flags);
                protected static void GetIUnknownImpl(out System.IntPtr fpQueryInterface, out System.IntPtr fpAddRef, out System.IntPtr fpRelease) => throw null;
                public System.IntPtr GetOrCreateComInterfaceForObject(object instance, System.Runtime.InteropServices.CreateComInterfaceFlags flags) => throw null;
                public object GetOrCreateObjectForComInstance(System.IntPtr externalComObject, System.Runtime.InteropServices.CreateObjectFlags flags) => throw null;
                public object GetOrRegisterObjectForComInstance(System.IntPtr externalComObject, System.Runtime.InteropServices.CreateObjectFlags flags, object wrapper) => throw null;
                public static void RegisterForMarshalling(System.Runtime.InteropServices.ComWrappers instance) => throw null;
                public static void RegisterForTrackerSupport(System.Runtime.InteropServices.ComWrappers instance) => throw null;
                protected abstract void ReleaseObjects(System.Collections.IEnumerable objects);
            }

            // Generated from `System.Runtime.InteropServices.CreateComInterfaceFlags` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum CreateComInterfaceFlags
            {
                CallerDefinedIUnknown,
                None,
                TrackerSupport,
            }

            // Generated from `System.Runtime.InteropServices.CreateObjectFlags` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum CreateObjectFlags
            {
                None,
                TrackerObject,
                UniqueInstance,
            }

            // Generated from `System.Runtime.InteropServices.CurrencyWrapper` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class CurrencyWrapper
            {
                public CurrencyWrapper(System.Decimal obj) => throw null;
                public CurrencyWrapper(object obj) => throw null;
                public System.Decimal WrappedObject { get => throw null; }
            }

            // Generated from `System.Runtime.InteropServices.CustomQueryInterfaceMode` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum CustomQueryInterfaceMode
            {
                Allow,
                Ignore,
            }

            // Generated from `System.Runtime.InteropServices.CustomQueryInterfaceResult` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum CustomQueryInterfaceResult
            {
                Failed,
                Handled,
                NotHandled,
            }

            // Generated from `System.Runtime.InteropServices.DefaultCharSetAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DefaultCharSetAttribute : System.Attribute
            {
                public System.Runtime.InteropServices.CharSet CharSet { get => throw null; }
                public DefaultCharSetAttribute(System.Runtime.InteropServices.CharSet charSet) => throw null;
            }

            // Generated from `System.Runtime.InteropServices.DefaultDllImportSearchPathsAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DefaultDllImportSearchPathsAttribute : System.Attribute
            {
                public DefaultDllImportSearchPathsAttribute(System.Runtime.InteropServices.DllImportSearchPath paths) => throw null;
                public System.Runtime.InteropServices.DllImportSearchPath Paths { get => throw null; }
            }

            // Generated from `System.Runtime.InteropServices.DefaultParameterValueAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DefaultParameterValueAttribute : System.Attribute
            {
                public DefaultParameterValueAttribute(object value) => throw null;
                public object Value { get => throw null; }
            }

            // Generated from `System.Runtime.InteropServices.DispIdAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DispIdAttribute : System.Attribute
            {
                public DispIdAttribute(int dispId) => throw null;
                public int Value { get => throw null; }
            }

            // Generated from `System.Runtime.InteropServices.DispatchWrapper` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DispatchWrapper
            {
                public DispatchWrapper(object obj) => throw null;
                public object WrappedObject { get => throw null; }
            }

            // Generated from `System.Runtime.InteropServices.DllImportAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DllImportAttribute : System.Attribute
            {
                public bool BestFitMapping;
                public System.Runtime.InteropServices.CallingConvention CallingConvention;
                public System.Runtime.InteropServices.CharSet CharSet;
                public DllImportAttribute(string dllName) => throw null;
                public string EntryPoint;
                public bool ExactSpelling;
                public bool PreserveSig;
                public bool SetLastError;
                public bool ThrowOnUnmappableChar;
                public string Value { get => throw null; }
            }

            // Generated from `System.Runtime.InteropServices.DllImportResolver` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public delegate System.IntPtr DllImportResolver(string libraryName, System.Reflection.Assembly assembly, System.Runtime.InteropServices.DllImportSearchPath? searchPath);

            // Generated from `System.Runtime.InteropServices.DllImportSearchPath` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum DllImportSearchPath
            {
                ApplicationDirectory,
                AssemblyDirectory,
                LegacyBehavior,
                SafeDirectories,
                System32,
                UseDllDirectoryForDependencies,
                UserDirectories,
            }

            // Generated from `System.Runtime.InteropServices.DynamicInterfaceCastableImplementationAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DynamicInterfaceCastableImplementationAttribute : System.Attribute
            {
                public DynamicInterfaceCastableImplementationAttribute() => throw null;
            }

            // Generated from `System.Runtime.InteropServices.ErrorWrapper` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ErrorWrapper
            {
                public int ErrorCode { get => throw null; }
                public ErrorWrapper(System.Exception e) => throw null;
                public ErrorWrapper(int errorCode) => throw null;
                public ErrorWrapper(object errorCode) => throw null;
            }

            // Generated from `System.Runtime.InteropServices.GuidAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class GuidAttribute : System.Attribute
            {
                public GuidAttribute(string guid) => throw null;
                public string Value { get => throw null; }
            }

            // Generated from `System.Runtime.InteropServices.HandleCollector` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class HandleCollector
            {
                public void Add() => throw null;
                public int Count { get => throw null; }
                public HandleCollector(string name, int initialThreshold) => throw null;
                public HandleCollector(string name, int initialThreshold, int maximumThreshold) => throw null;
                public int InitialThreshold { get => throw null; }
                public int MaximumThreshold { get => throw null; }
                public string Name { get => throw null; }
                public void Remove() => throw null;
            }

            // Generated from `System.Runtime.InteropServices.HandleRef` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct HandleRef
            {
                public System.IntPtr Handle { get => throw null; }
                // Stub generator skipped constructor 
                public HandleRef(object wrapper, System.IntPtr handle) => throw null;
                public static System.IntPtr ToIntPtr(System.Runtime.InteropServices.HandleRef value) => throw null;
                public object Wrapper { get => throw null; }
                public static explicit operator System.IntPtr(System.Runtime.InteropServices.HandleRef value) => throw null;
            }

            // Generated from `System.Runtime.InteropServices.ICustomAdapter` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface ICustomAdapter
            {
                object GetUnderlyingObject();
            }

            // Generated from `System.Runtime.InteropServices.ICustomFactory` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface ICustomFactory
            {
                System.MarshalByRefObject CreateInstance(System.Type serverType);
            }

            // Generated from `System.Runtime.InteropServices.ICustomMarshaler` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface ICustomMarshaler
            {
                void CleanUpManagedData(object ManagedObj);
                void CleanUpNativeData(System.IntPtr pNativeData);
                int GetNativeDataSize();
                System.IntPtr MarshalManagedToNative(object ManagedObj);
                object MarshalNativeToManaged(System.IntPtr pNativeData);
            }

            // Generated from `System.Runtime.InteropServices.ICustomQueryInterface` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface ICustomQueryInterface
            {
                System.Runtime.InteropServices.CustomQueryInterfaceResult GetInterface(ref System.Guid iid, out System.IntPtr ppv);
            }

            // Generated from `System.Runtime.InteropServices.IDynamicInterfaceCastable` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IDynamicInterfaceCastable
            {
                System.RuntimeTypeHandle GetInterfaceImplementation(System.RuntimeTypeHandle interfaceType);
                bool IsInterfaceImplemented(System.RuntimeTypeHandle interfaceType, bool throwIfNotImplemented);
            }

            // Generated from `System.Runtime.InteropServices.ImportedFromTypeLibAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ImportedFromTypeLibAttribute : System.Attribute
            {
                public ImportedFromTypeLibAttribute(string tlbFile) => throw null;
                public string Value { get => throw null; }
            }

            // Generated from `System.Runtime.InteropServices.InterfaceTypeAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class InterfaceTypeAttribute : System.Attribute
            {
                public InterfaceTypeAttribute(System.Runtime.InteropServices.ComInterfaceType interfaceType) => throw null;
                public InterfaceTypeAttribute(System.Int16 interfaceType) => throw null;
                public System.Runtime.InteropServices.ComInterfaceType Value { get => throw null; }
            }

            // Generated from `System.Runtime.InteropServices.InvalidComObjectException` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class InvalidComObjectException : System.SystemException
            {
                public InvalidComObjectException() => throw null;
                protected InvalidComObjectException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public InvalidComObjectException(string message) => throw null;
                public InvalidComObjectException(string message, System.Exception inner) => throw null;
            }

            // Generated from `System.Runtime.InteropServices.InvalidOleVariantTypeException` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class InvalidOleVariantTypeException : System.SystemException
            {
                public InvalidOleVariantTypeException() => throw null;
                protected InvalidOleVariantTypeException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public InvalidOleVariantTypeException(string message) => throw null;
                public InvalidOleVariantTypeException(string message, System.Exception inner) => throw null;
            }

            // Generated from `System.Runtime.InteropServices.LCIDConversionAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class LCIDConversionAttribute : System.Attribute
            {
                public LCIDConversionAttribute(int lcid) => throw null;
                public int Value { get => throw null; }
            }

            // Generated from `System.Runtime.InteropServices.ManagedToNativeComInteropStubAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ManagedToNativeComInteropStubAttribute : System.Attribute
            {
                public System.Type ClassType { get => throw null; }
                public ManagedToNativeComInteropStubAttribute(System.Type classType, string methodName) => throw null;
                public string MethodName { get => throw null; }
            }

            // Generated from `System.Runtime.InteropServices.Marshal` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class Marshal
            {
                public static int AddRef(System.IntPtr pUnk) => throw null;
                public static System.IntPtr AllocCoTaskMem(int cb) => throw null;
                public static System.IntPtr AllocHGlobal(System.IntPtr cb) => throw null;
                public static System.IntPtr AllocHGlobal(int cb) => throw null;
                public static bool AreComObjectsAvailableForCleanup() => throw null;
                public static object BindToMoniker(string monikerName) => throw null;
                public static void ChangeWrapperHandleStrength(object otp, bool fIsWeak) => throw null;
                public static void CleanupUnusedObjectsInCurrentContext() => throw null;
                public static void Copy(System.Byte[] source, int startIndex, System.IntPtr destination, int length) => throw null;
                public static void Copy(System.Char[] source, int startIndex, System.IntPtr destination, int length) => throw null;
                public static void Copy(double[] source, int startIndex, System.IntPtr destination, int length) => throw null;
                public static void Copy(System.Int16[] source, int startIndex, System.IntPtr destination, int length) => throw null;
                public static void Copy(int[] source, int startIndex, System.IntPtr destination, int length) => throw null;
                public static void Copy(System.Int64[] source, int startIndex, System.IntPtr destination, int length) => throw null;
                public static void Copy(System.IntPtr source, System.Byte[] destination, int startIndex, int length) => throw null;
                public static void Copy(System.IntPtr source, System.Char[] destination, int startIndex, int length) => throw null;
                public static void Copy(System.IntPtr source, double[] destination, int startIndex, int length) => throw null;
                public static void Copy(System.IntPtr source, System.Int16[] destination, int startIndex, int length) => throw null;
                public static void Copy(System.IntPtr source, int[] destination, int startIndex, int length) => throw null;
                public static void Copy(System.IntPtr source, System.Int64[] destination, int startIndex, int length) => throw null;
                public static void Copy(System.IntPtr source, System.IntPtr[] destination, int startIndex, int length) => throw null;
                public static void Copy(System.IntPtr source, float[] destination, int startIndex, int length) => throw null;
                public static void Copy(System.IntPtr[] source, int startIndex, System.IntPtr destination, int length) => throw null;
                public static void Copy(float[] source, int startIndex, System.IntPtr destination, int length) => throw null;
                public static System.IntPtr CreateAggregatedObject(System.IntPtr pOuter, object o) => throw null;
                public static System.IntPtr CreateAggregatedObject<T>(System.IntPtr pOuter, T o) => throw null;
                public static object CreateWrapperOfType(object o, System.Type t) => throw null;
                public static TWrapper CreateWrapperOfType<T, TWrapper>(T o) => throw null;
                public static void DestroyStructure(System.IntPtr ptr, System.Type structuretype) => throw null;
                public static void DestroyStructure<T>(System.IntPtr ptr) => throw null;
                public static int FinalReleaseComObject(object o) => throw null;
                public static void FreeBSTR(System.IntPtr ptr) => throw null;
                public static void FreeCoTaskMem(System.IntPtr ptr) => throw null;
                public static void FreeHGlobal(System.IntPtr hglobal) => throw null;
                public static System.Guid GenerateGuidForType(System.Type type) => throw null;
                public static string GenerateProgIdForType(System.Type type) => throw null;
                public static System.IntPtr GetComInterfaceForObject(object o, System.Type T) => throw null;
                public static System.IntPtr GetComInterfaceForObject(object o, System.Type T, System.Runtime.InteropServices.CustomQueryInterfaceMode mode) => throw null;
                public static System.IntPtr GetComInterfaceForObject<T, TInterface>(T o) => throw null;
                public static object GetComObjectData(object obj, object key) => throw null;
                public static System.Delegate GetDelegateForFunctionPointer(System.IntPtr ptr, System.Type t) => throw null;
                public static TDelegate GetDelegateForFunctionPointer<TDelegate>(System.IntPtr ptr) => throw null;
                public static int GetEndComSlot(System.Type t) => throw null;
                public static int GetExceptionCode() => throw null;
                public static System.Exception GetExceptionForHR(int errorCode) => throw null;
                public static System.Exception GetExceptionForHR(int errorCode, System.IntPtr errorInfo) => throw null;
                public static System.IntPtr GetExceptionPointers() => throw null;
                public static System.IntPtr GetFunctionPointerForDelegate(System.Delegate d) => throw null;
                public static System.IntPtr GetFunctionPointerForDelegate<TDelegate>(TDelegate d) => throw null;
                public static System.IntPtr GetHINSTANCE(System.Reflection.Module m) => throw null;
                public static int GetHRForException(System.Exception e) => throw null;
                public static int GetHRForLastWin32Error() => throw null;
                public static System.IntPtr GetIDispatchForObject(object o) => throw null;
                public static System.IntPtr GetIUnknownForObject(object o) => throw null;
                public static int GetLastWin32Error() => throw null;
                public static void GetNativeVariantForObject(object obj, System.IntPtr pDstNativeVariant) => throw null;
                public static void GetNativeVariantForObject<T>(T obj, System.IntPtr pDstNativeVariant) => throw null;
                public static object GetObjectForIUnknown(System.IntPtr pUnk) => throw null;
                public static object GetObjectForNativeVariant(System.IntPtr pSrcNativeVariant) => throw null;
                public static T GetObjectForNativeVariant<T>(System.IntPtr pSrcNativeVariant) => throw null;
                public static object[] GetObjectsForNativeVariants(System.IntPtr aSrcNativeVariant, int cVars) => throw null;
                public static T[] GetObjectsForNativeVariants<T>(System.IntPtr aSrcNativeVariant, int cVars) => throw null;
                public static int GetStartComSlot(System.Type t) => throw null;
                public static System.Type GetTypeFromCLSID(System.Guid clsid) => throw null;
                public static string GetTypeInfoName(System.Runtime.InteropServices.ComTypes.ITypeInfo typeInfo) => throw null;
                public static object GetTypedObjectForIUnknown(System.IntPtr pUnk, System.Type t) => throw null;
                public static object GetUniqueObjectForIUnknown(System.IntPtr unknown) => throw null;
                public static bool IsComObject(object o) => throw null;
                public static bool IsTypeVisibleFromCom(System.Type t) => throw null;
                public static System.IntPtr OffsetOf(System.Type t, string fieldName) => throw null;
                public static System.IntPtr OffsetOf<T>(string fieldName) => throw null;
                public static void Prelink(System.Reflection.MethodInfo m) => throw null;
                public static void PrelinkAll(System.Type c) => throw null;
                public static string PtrToStringAnsi(System.IntPtr ptr) => throw null;
                public static string PtrToStringAnsi(System.IntPtr ptr, int len) => throw null;
                public static string PtrToStringAuto(System.IntPtr ptr) => throw null;
                public static string PtrToStringAuto(System.IntPtr ptr, int len) => throw null;
                public static string PtrToStringBSTR(System.IntPtr ptr) => throw null;
                public static string PtrToStringUTF8(System.IntPtr ptr) => throw null;
                public static string PtrToStringUTF8(System.IntPtr ptr, int byteLen) => throw null;
                public static string PtrToStringUni(System.IntPtr ptr) => throw null;
                public static string PtrToStringUni(System.IntPtr ptr, int len) => throw null;
                public static object PtrToStructure(System.IntPtr ptr, System.Type structureType) => throw null;
                public static void PtrToStructure(System.IntPtr ptr, object structure) => throw null;
                public static T PtrToStructure<T>(System.IntPtr ptr) => throw null;
                public static void PtrToStructure<T>(System.IntPtr ptr, T structure) => throw null;
                public static int QueryInterface(System.IntPtr pUnk, ref System.Guid iid, out System.IntPtr ppv) => throw null;
                public static System.IntPtr ReAllocCoTaskMem(System.IntPtr pv, int cb) => throw null;
                public static System.IntPtr ReAllocHGlobal(System.IntPtr pv, System.IntPtr cb) => throw null;
                public static System.Byte ReadByte(System.IntPtr ptr) => throw null;
                public static System.Byte ReadByte(System.IntPtr ptr, int ofs) => throw null;
                public static System.Byte ReadByte(object ptr, int ofs) => throw null;
                public static System.Int16 ReadInt16(System.IntPtr ptr) => throw null;
                public static System.Int16 ReadInt16(System.IntPtr ptr, int ofs) => throw null;
                public static System.Int16 ReadInt16(object ptr, int ofs) => throw null;
                public static int ReadInt32(System.IntPtr ptr) => throw null;
                public static int ReadInt32(System.IntPtr ptr, int ofs) => throw null;
                public static int ReadInt32(object ptr, int ofs) => throw null;
                public static System.Int64 ReadInt64(System.IntPtr ptr) => throw null;
                public static System.Int64 ReadInt64(System.IntPtr ptr, int ofs) => throw null;
                public static System.Int64 ReadInt64(object ptr, int ofs) => throw null;
                public static System.IntPtr ReadIntPtr(System.IntPtr ptr) => throw null;
                public static System.IntPtr ReadIntPtr(System.IntPtr ptr, int ofs) => throw null;
                public static System.IntPtr ReadIntPtr(object ptr, int ofs) => throw null;
                public static int Release(System.IntPtr pUnk) => throw null;
                public static int ReleaseComObject(object o) => throw null;
                public static System.IntPtr SecureStringToBSTR(System.Security.SecureString s) => throw null;
                public static System.IntPtr SecureStringToCoTaskMemAnsi(System.Security.SecureString s) => throw null;
                public static System.IntPtr SecureStringToCoTaskMemUnicode(System.Security.SecureString s) => throw null;
                public static System.IntPtr SecureStringToGlobalAllocAnsi(System.Security.SecureString s) => throw null;
                public static System.IntPtr SecureStringToGlobalAllocUnicode(System.Security.SecureString s) => throw null;
                public static bool SetComObjectData(object obj, object key, object data) => throw null;
                public static int SizeOf(System.Type t) => throw null;
                public static int SizeOf(object structure) => throw null;
                public static int SizeOf<T>() => throw null;
                public static int SizeOf<T>(T structure) => throw null;
                public static System.IntPtr StringToBSTR(string s) => throw null;
                public static System.IntPtr StringToCoTaskMemAnsi(string s) => throw null;
                public static System.IntPtr StringToCoTaskMemAuto(string s) => throw null;
                public static System.IntPtr StringToCoTaskMemUTF8(string s) => throw null;
                public static System.IntPtr StringToCoTaskMemUni(string s) => throw null;
                public static System.IntPtr StringToHGlobalAnsi(string s) => throw null;
                public static System.IntPtr StringToHGlobalAuto(string s) => throw null;
                public static System.IntPtr StringToHGlobalUni(string s) => throw null;
                public static void StructureToPtr(object structure, System.IntPtr ptr, bool fDeleteOld) => throw null;
                public static void StructureToPtr<T>(T structure, System.IntPtr ptr, bool fDeleteOld) => throw null;
                public static int SystemDefaultCharSize;
                public static int SystemMaxDBCSCharSize;
                public static void ThrowExceptionForHR(int errorCode) => throw null;
                public static void ThrowExceptionForHR(int errorCode, System.IntPtr errorInfo) => throw null;
                public static System.IntPtr UnsafeAddrOfPinnedArrayElement(System.Array arr, int index) => throw null;
                public static System.IntPtr UnsafeAddrOfPinnedArrayElement<T>(T[] arr, int index) => throw null;
                public static void WriteByte(System.IntPtr ptr, System.Byte val) => throw null;
                public static void WriteByte(System.IntPtr ptr, int ofs, System.Byte val) => throw null;
                public static void WriteByte(object ptr, int ofs, System.Byte val) => throw null;
                public static void WriteInt16(System.IntPtr ptr, System.Char val) => throw null;
                public static void WriteInt16(System.IntPtr ptr, int ofs, System.Char val) => throw null;
                public static void WriteInt16(System.IntPtr ptr, int ofs, System.Int16 val) => throw null;
                public static void WriteInt16(System.IntPtr ptr, System.Int16 val) => throw null;
                public static void WriteInt16(object ptr, int ofs, System.Char val) => throw null;
                public static void WriteInt16(object ptr, int ofs, System.Int16 val) => throw null;
                public static void WriteInt32(System.IntPtr ptr, int val) => throw null;
                public static void WriteInt32(System.IntPtr ptr, int ofs, int val) => throw null;
                public static void WriteInt32(object ptr, int ofs, int val) => throw null;
                public static void WriteInt64(System.IntPtr ptr, int ofs, System.Int64 val) => throw null;
                public static void WriteInt64(System.IntPtr ptr, System.Int64 val) => throw null;
                public static void WriteInt64(object ptr, int ofs, System.Int64 val) => throw null;
                public static void WriteIntPtr(System.IntPtr ptr, System.IntPtr val) => throw null;
                public static void WriteIntPtr(System.IntPtr ptr, int ofs, System.IntPtr val) => throw null;
                public static void WriteIntPtr(object ptr, int ofs, System.IntPtr val) => throw null;
                public static void ZeroFreeBSTR(System.IntPtr s) => throw null;
                public static void ZeroFreeCoTaskMemAnsi(System.IntPtr s) => throw null;
                public static void ZeroFreeCoTaskMemUTF8(System.IntPtr s) => throw null;
                public static void ZeroFreeCoTaskMemUnicode(System.IntPtr s) => throw null;
                public static void ZeroFreeGlobalAllocAnsi(System.IntPtr s) => throw null;
                public static void ZeroFreeGlobalAllocUnicode(System.IntPtr s) => throw null;
            }

            // Generated from `System.Runtime.InteropServices.MarshalAsAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class MarshalAsAttribute : System.Attribute
            {
                public System.Runtime.InteropServices.UnmanagedType ArraySubType;
                public int IidParameterIndex;
                public MarshalAsAttribute(System.Runtime.InteropServices.UnmanagedType unmanagedType) => throw null;
                public MarshalAsAttribute(System.Int16 unmanagedType) => throw null;
                public string MarshalCookie;
                public string MarshalType;
                public System.Type MarshalTypeRef;
                public System.Runtime.InteropServices.VarEnum SafeArraySubType;
                public System.Type SafeArrayUserDefinedSubType;
                public int SizeConst;
                public System.Int16 SizeParamIndex;
                public System.Runtime.InteropServices.UnmanagedType Value { get => throw null; }
            }

            // Generated from `System.Runtime.InteropServices.MarshalDirectiveException` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class MarshalDirectiveException : System.SystemException
            {
                public MarshalDirectiveException() => throw null;
                protected MarshalDirectiveException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public MarshalDirectiveException(string message) => throw null;
                public MarshalDirectiveException(string message, System.Exception inner) => throw null;
            }

            // Generated from `System.Runtime.InteropServices.NativeLibrary` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class NativeLibrary
            {
                public static void Free(System.IntPtr handle) => throw null;
                public static System.IntPtr GetExport(System.IntPtr handle, string name) => throw null;
                public static System.IntPtr Load(string libraryPath) => throw null;
                public static System.IntPtr Load(string libraryName, System.Reflection.Assembly assembly, System.Runtime.InteropServices.DllImportSearchPath? searchPath) => throw null;
                public static void SetDllImportResolver(System.Reflection.Assembly assembly, System.Runtime.InteropServices.DllImportResolver resolver) => throw null;
                public static bool TryGetExport(System.IntPtr handle, string name, out System.IntPtr address) => throw null;
                public static bool TryLoad(string libraryName, System.Reflection.Assembly assembly, System.Runtime.InteropServices.DllImportSearchPath? searchPath, out System.IntPtr handle) => throw null;
                public static bool TryLoad(string libraryPath, out System.IntPtr handle) => throw null;
            }

            // Generated from `System.Runtime.InteropServices.OptionalAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class OptionalAttribute : System.Attribute
            {
                public OptionalAttribute() => throw null;
            }

            // Generated from `System.Runtime.InteropServices.PreserveSigAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class PreserveSigAttribute : System.Attribute
            {
                public PreserveSigAttribute() => throw null;
            }

            // Generated from `System.Runtime.InteropServices.PrimaryInteropAssemblyAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class PrimaryInteropAssemblyAttribute : System.Attribute
            {
                public int MajorVersion { get => throw null; }
                public int MinorVersion { get => throw null; }
                public PrimaryInteropAssemblyAttribute(int major, int minor) => throw null;
            }

            // Generated from `System.Runtime.InteropServices.ProgIdAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ProgIdAttribute : System.Attribute
            {
                public ProgIdAttribute(string progId) => throw null;
                public string Value { get => throw null; }
            }

            // Generated from `System.Runtime.InteropServices.RuntimeEnvironment` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class RuntimeEnvironment
            {
                public static bool FromGlobalAccessCache(System.Reflection.Assembly a) => throw null;
                public static string GetRuntimeDirectory() => throw null;
                public static System.IntPtr GetRuntimeInterfaceAsIntPtr(System.Guid clsid, System.Guid riid) => throw null;
                public static object GetRuntimeInterfaceAsObject(System.Guid clsid, System.Guid riid) => throw null;
                public static string GetSystemVersion() => throw null;
                public static string SystemConfigurationFile { get => throw null; }
            }

            // Generated from `System.Runtime.InteropServices.SEHException` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SEHException : System.Runtime.InteropServices.ExternalException
            {
                public virtual bool CanResume() => throw null;
                public SEHException() => throw null;
                protected SEHException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public SEHException(string message) => throw null;
                public SEHException(string message, System.Exception inner) => throw null;
            }

            // Generated from `System.Runtime.InteropServices.SafeArrayRankMismatchException` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SafeArrayRankMismatchException : System.SystemException
            {
                public SafeArrayRankMismatchException() => throw null;
                protected SafeArrayRankMismatchException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public SafeArrayRankMismatchException(string message) => throw null;
                public SafeArrayRankMismatchException(string message, System.Exception inner) => throw null;
            }

            // Generated from `System.Runtime.InteropServices.SafeArrayTypeMismatchException` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SafeArrayTypeMismatchException : System.SystemException
            {
                public SafeArrayTypeMismatchException() => throw null;
                protected SafeArrayTypeMismatchException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public SafeArrayTypeMismatchException(string message) => throw null;
                public SafeArrayTypeMismatchException(string message, System.Exception inner) => throw null;
            }

            // Generated from `System.Runtime.InteropServices.StandardOleMarshalObject` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class StandardOleMarshalObject : System.MarshalByRefObject
            {
                protected StandardOleMarshalObject() => throw null;
            }

            // Generated from `System.Runtime.InteropServices.TypeIdentifierAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class TypeIdentifierAttribute : System.Attribute
            {
                public string Identifier { get => throw null; }
                public string Scope { get => throw null; }
                public TypeIdentifierAttribute() => throw null;
                public TypeIdentifierAttribute(string scope, string identifier) => throw null;
            }

            // Generated from `System.Runtime.InteropServices.TypeLibFuncAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class TypeLibFuncAttribute : System.Attribute
            {
                public TypeLibFuncAttribute(System.Runtime.InteropServices.TypeLibFuncFlags flags) => throw null;
                public TypeLibFuncAttribute(System.Int16 flags) => throw null;
                public System.Runtime.InteropServices.TypeLibFuncFlags Value { get => throw null; }
            }

            // Generated from `System.Runtime.InteropServices.TypeLibFuncFlags` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum TypeLibFuncFlags
            {
                FBindable,
                FDefaultBind,
                FDefaultCollelem,
                FDisplayBind,
                FHidden,
                FImmediateBind,
                FNonBrowsable,
                FReplaceable,
                FRequestEdit,
                FRestricted,
                FSource,
                FUiDefault,
                FUsesGetLastError,
            }

            // Generated from `System.Runtime.InteropServices.TypeLibImportClassAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class TypeLibImportClassAttribute : System.Attribute
            {
                public TypeLibImportClassAttribute(System.Type importClass) => throw null;
                public string Value { get => throw null; }
            }

            // Generated from `System.Runtime.InteropServices.TypeLibTypeAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class TypeLibTypeAttribute : System.Attribute
            {
                public TypeLibTypeAttribute(System.Runtime.InteropServices.TypeLibTypeFlags flags) => throw null;
                public TypeLibTypeAttribute(System.Int16 flags) => throw null;
                public System.Runtime.InteropServices.TypeLibTypeFlags Value { get => throw null; }
            }

            // Generated from `System.Runtime.InteropServices.TypeLibTypeFlags` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum TypeLibTypeFlags
            {
                FAggregatable,
                FAppObject,
                FCanCreate,
                FControl,
                FDispatchable,
                FDual,
                FHidden,
                FLicensed,
                FNonExtensible,
                FOleAutomation,
                FPreDeclId,
                FReplaceable,
                FRestricted,
                FReverseBind,
            }

            // Generated from `System.Runtime.InteropServices.TypeLibVarAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class TypeLibVarAttribute : System.Attribute
            {
                public TypeLibVarAttribute(System.Runtime.InteropServices.TypeLibVarFlags flags) => throw null;
                public TypeLibVarAttribute(System.Int16 flags) => throw null;
                public System.Runtime.InteropServices.TypeLibVarFlags Value { get => throw null; }
            }

            // Generated from `System.Runtime.InteropServices.TypeLibVarFlags` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum TypeLibVarFlags
            {
                FBindable,
                FDefaultBind,
                FDefaultCollelem,
                FDisplayBind,
                FHidden,
                FImmediateBind,
                FNonBrowsable,
                FReadOnly,
                FReplaceable,
                FRequestEdit,
                FRestricted,
                FSource,
                FUiDefault,
            }

            // Generated from `System.Runtime.InteropServices.TypeLibVersionAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class TypeLibVersionAttribute : System.Attribute
            {
                public int MajorVersion { get => throw null; }
                public int MinorVersion { get => throw null; }
                public TypeLibVersionAttribute(int major, int minor) => throw null;
            }

            // Generated from `System.Runtime.InteropServices.UnknownWrapper` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class UnknownWrapper
            {
                public UnknownWrapper(object obj) => throw null;
                public object WrappedObject { get => throw null; }
            }

            // Generated from `System.Runtime.InteropServices.UnmanagedCallersOnlyAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class UnmanagedCallersOnlyAttribute : System.Attribute
            {
                public System.Type[] CallConvs;
                public string EntryPoint;
                public UnmanagedCallersOnlyAttribute() => throw null;
            }

            // Generated from `System.Runtime.InteropServices.UnmanagedFunctionPointerAttribute` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class UnmanagedFunctionPointerAttribute : System.Attribute
            {
                public bool BestFitMapping;
                public System.Runtime.InteropServices.CallingConvention CallingConvention { get => throw null; }
                public System.Runtime.InteropServices.CharSet CharSet;
                public bool SetLastError;
                public bool ThrowOnUnmappableChar;
                public UnmanagedFunctionPointerAttribute(System.Runtime.InteropServices.CallingConvention callingConvention) => throw null;
            }

            // Generated from `System.Runtime.InteropServices.UnmanagedType` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum UnmanagedType
            {
                AnsiBStr,
                AsAny,
                BStr,
                Bool,
                ByValArray,
                ByValTStr,
                Currency,
                CustomMarshaler,
                Error,
                FunctionPtr,
                HString,
                I1,
                I2,
                I4,
                I8,
                IDispatch,
                IInspectable,
                IUnknown,
                Interface,
                LPArray,
                LPStr,
                LPStruct,
                LPTStr,
                LPUTF8Str,
                LPWStr,
                R4,
                R8,
                SafeArray,
                Struct,
                SysInt,
                SysUInt,
                TBStr,
                U1,
                U2,
                U4,
                U8,
                VBByRefStr,
                VariantBool,
            }

            // Generated from `System.Runtime.InteropServices.VarEnum` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum VarEnum
            {
                VT_ARRAY,
                VT_BLOB,
                VT_BLOB_OBJECT,
                VT_BOOL,
                VT_BSTR,
                VT_BYREF,
                VT_CARRAY,
                VT_CF,
                VT_CLSID,
                VT_CY,
                VT_DATE,
                VT_DECIMAL,
                VT_DISPATCH,
                VT_EMPTY,
                VT_ERROR,
                VT_FILETIME,
                VT_HRESULT,
                VT_I1,
                VT_I2,
                VT_I4,
                VT_I8,
                VT_INT,
                VT_LPSTR,
                VT_LPWSTR,
                VT_NULL,
                VT_PTR,
                VT_R4,
                VT_R8,
                VT_RECORD,
                VT_SAFEARRAY,
                VT_STORAGE,
                VT_STORED_OBJECT,
                VT_STREAM,
                VT_STREAMED_OBJECT,
                VT_UI1,
                VT_UI2,
                VT_UI4,
                VT_UI8,
                VT_UINT,
                VT_UNKNOWN,
                VT_USERDEFINED,
                VT_VARIANT,
                VT_VECTOR,
                VT_VOID,
            }

            // Generated from `System.Runtime.InteropServices.VariantWrapper` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class VariantWrapper
            {
                public VariantWrapper(object obj) => throw null;
                public object WrappedObject { get => throw null; }
            }

            namespace ComTypes
            {
                // Generated from `System.Runtime.InteropServices.ComTypes.ADVF` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                [System.Flags]
                public enum ADVF
                {
                    ADVFCACHE_FORCEBUILTIN,
                    ADVFCACHE_NOHANDLER,
                    ADVFCACHE_ONSAVE,
                    ADVF_DATAONSTOP,
                    ADVF_NODATA,
                    ADVF_ONLYONCE,
                    ADVF_PRIMEFIRST,
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.BINDPTR` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public struct BINDPTR
                {
                    // Stub generator skipped constructor 
                    public System.IntPtr lpfuncdesc;
                    public System.IntPtr lptcomp;
                    public System.IntPtr lpvardesc;
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.BIND_OPTS` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public struct BIND_OPTS
                {
                    // Stub generator skipped constructor 
                    public int cbStruct;
                    public int dwTickCountDeadline;
                    public int grfFlags;
                    public int grfMode;
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.CALLCONV` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public enum CALLCONV
                {
                    CC_CDECL,
                    CC_MACPASCAL,
                    CC_MAX,
                    CC_MPWCDECL,
                    CC_MPWPASCAL,
                    CC_MSCPASCAL,
                    CC_PASCAL,
                    CC_RESERVED,
                    CC_STDCALL,
                    CC_SYSCALL,
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.CONNECTDATA` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public struct CONNECTDATA
                {
                    // Stub generator skipped constructor 
                    public int dwCookie;
                    public object pUnk;
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.DATADIR` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public enum DATADIR
                {
                    DATADIR_GET,
                    DATADIR_SET,
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.DESCKIND` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public enum DESCKIND
                {
                    DESCKIND_FUNCDESC,
                    DESCKIND_IMPLICITAPPOBJ,
                    DESCKIND_MAX,
                    DESCKIND_NONE,
                    DESCKIND_TYPECOMP,
                    DESCKIND_VARDESC,
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.DISPPARAMS` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public struct DISPPARAMS
                {
                    // Stub generator skipped constructor 
                    public int cArgs;
                    public int cNamedArgs;
                    public System.IntPtr rgdispidNamedArgs;
                    public System.IntPtr rgvarg;
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.DVASPECT` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                [System.Flags]
                public enum DVASPECT
                {
                    DVASPECT_CONTENT,
                    DVASPECT_DOCPRINT,
                    DVASPECT_ICON,
                    DVASPECT_THUMBNAIL,
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.ELEMDESC` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public struct ELEMDESC
                {
                    // Generated from `System.Runtime.InteropServices.ComTypes.ELEMDESC+DESCUNION` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                    public struct DESCUNION
                    {
                        // Stub generator skipped constructor 
                        public System.Runtime.InteropServices.ComTypes.IDLDESC idldesc;
                        public System.Runtime.InteropServices.ComTypes.PARAMDESC paramdesc;
                    }


                    // Stub generator skipped constructor 
                    public System.Runtime.InteropServices.ComTypes.ELEMDESC.DESCUNION desc;
                    public System.Runtime.InteropServices.ComTypes.TYPEDESC tdesc;
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.EXCEPINFO` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public struct EXCEPINFO
                {
                    // Stub generator skipped constructor 
                    public string bstrDescription;
                    public string bstrHelpFile;
                    public string bstrSource;
                    public int dwHelpContext;
                    public System.IntPtr pfnDeferredFillIn;
                    public System.IntPtr pvReserved;
                    public int scode;
                    public System.Int16 wCode;
                    public System.Int16 wReserved;
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.FILETIME` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public struct FILETIME
                {
                    // Stub generator skipped constructor 
                    public int dwHighDateTime;
                    public int dwLowDateTime;
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.FORMATETC` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public struct FORMATETC
                {
                    // Stub generator skipped constructor 
                    public System.Int16 cfFormat;
                    public System.Runtime.InteropServices.ComTypes.DVASPECT dwAspect;
                    public int lindex;
                    public System.IntPtr ptd;
                    public System.Runtime.InteropServices.ComTypes.TYMED tymed;
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.FUNCDESC` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public struct FUNCDESC
                {
                    // Stub generator skipped constructor 
                    public System.Int16 cParams;
                    public System.Int16 cParamsOpt;
                    public System.Int16 cScodes;
                    public System.Runtime.InteropServices.ComTypes.CALLCONV callconv;
                    public System.Runtime.InteropServices.ComTypes.ELEMDESC elemdescFunc;
                    public System.Runtime.InteropServices.ComTypes.FUNCKIND funckind;
                    public System.Runtime.InteropServices.ComTypes.INVOKEKIND invkind;
                    public System.IntPtr lprgelemdescParam;
                    public System.IntPtr lprgscode;
                    public int memid;
                    public System.Int16 oVft;
                    public System.Int16 wFuncFlags;
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.FUNCFLAGS` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                [System.Flags]
                public enum FUNCFLAGS
                {
                    FUNCFLAG_FBINDABLE,
                    FUNCFLAG_FDEFAULTBIND,
                    FUNCFLAG_FDEFAULTCOLLELEM,
                    FUNCFLAG_FDISPLAYBIND,
                    FUNCFLAG_FHIDDEN,
                    FUNCFLAG_FIMMEDIATEBIND,
                    FUNCFLAG_FNONBROWSABLE,
                    FUNCFLAG_FREPLACEABLE,
                    FUNCFLAG_FREQUESTEDIT,
                    FUNCFLAG_FRESTRICTED,
                    FUNCFLAG_FSOURCE,
                    FUNCFLAG_FUIDEFAULT,
                    FUNCFLAG_FUSESGETLASTERROR,
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.FUNCKIND` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public enum FUNCKIND
                {
                    FUNC_DISPATCH,
                    FUNC_NONVIRTUAL,
                    FUNC_PUREVIRTUAL,
                    FUNC_STATIC,
                    FUNC_VIRTUAL,
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.IAdviseSink` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public interface IAdviseSink
                {
                    void OnClose();
                    void OnDataChange(ref System.Runtime.InteropServices.ComTypes.FORMATETC format, ref System.Runtime.InteropServices.ComTypes.STGMEDIUM stgmedium);
                    void OnRename(System.Runtime.InteropServices.ComTypes.IMoniker moniker);
                    void OnSave();
                    void OnViewChange(int aspect, int index);
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.IBindCtx` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public interface IBindCtx
                {
                    void EnumObjectParam(out System.Runtime.InteropServices.ComTypes.IEnumString ppenum);
                    void GetBindOptions(ref System.Runtime.InteropServices.ComTypes.BIND_OPTS pbindopts);
                    void GetObjectParam(string pszKey, out object ppunk);
                    void GetRunningObjectTable(out System.Runtime.InteropServices.ComTypes.IRunningObjectTable pprot);
                    void RegisterObjectBound(object punk);
                    void RegisterObjectParam(string pszKey, object punk);
                    void ReleaseBoundObjects();
                    void RevokeObjectBound(object punk);
                    int RevokeObjectParam(string pszKey);
                    void SetBindOptions(ref System.Runtime.InteropServices.ComTypes.BIND_OPTS pbindopts);
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.IConnectionPoint` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public interface IConnectionPoint
                {
                    void Advise(object pUnkSink, out int pdwCookie);
                    void EnumConnections(out System.Runtime.InteropServices.ComTypes.IEnumConnections ppEnum);
                    void GetConnectionInterface(out System.Guid pIID);
                    void GetConnectionPointContainer(out System.Runtime.InteropServices.ComTypes.IConnectionPointContainer ppCPC);
                    void Unadvise(int dwCookie);
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.IConnectionPointContainer` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public interface IConnectionPointContainer
                {
                    void EnumConnectionPoints(out System.Runtime.InteropServices.ComTypes.IEnumConnectionPoints ppEnum);
                    void FindConnectionPoint(ref System.Guid riid, out System.Runtime.InteropServices.ComTypes.IConnectionPoint ppCP);
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.IDLDESC` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public struct IDLDESC
                {
                    // Stub generator skipped constructor 
                    public System.IntPtr dwReserved;
                    public System.Runtime.InteropServices.ComTypes.IDLFLAG wIDLFlags;
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.IDLFLAG` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                [System.Flags]
                public enum IDLFLAG
                {
                    IDLFLAG_FIN,
                    IDLFLAG_FLCID,
                    IDLFLAG_FOUT,
                    IDLFLAG_FRETVAL,
                    IDLFLAG_NONE,
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.IDataObject` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public interface IDataObject
                {
                    int DAdvise(ref System.Runtime.InteropServices.ComTypes.FORMATETC pFormatetc, System.Runtime.InteropServices.ComTypes.ADVF advf, System.Runtime.InteropServices.ComTypes.IAdviseSink adviseSink, out int connection);
                    void DUnadvise(int connection);
                    int EnumDAdvise(out System.Runtime.InteropServices.ComTypes.IEnumSTATDATA enumAdvise);
                    System.Runtime.InteropServices.ComTypes.IEnumFORMATETC EnumFormatEtc(System.Runtime.InteropServices.ComTypes.DATADIR direction);
                    int GetCanonicalFormatEtc(ref System.Runtime.InteropServices.ComTypes.FORMATETC formatIn, out System.Runtime.InteropServices.ComTypes.FORMATETC formatOut);
                    void GetData(ref System.Runtime.InteropServices.ComTypes.FORMATETC format, out System.Runtime.InteropServices.ComTypes.STGMEDIUM medium);
                    void GetDataHere(ref System.Runtime.InteropServices.ComTypes.FORMATETC format, ref System.Runtime.InteropServices.ComTypes.STGMEDIUM medium);
                    int QueryGetData(ref System.Runtime.InteropServices.ComTypes.FORMATETC format);
                    void SetData(ref System.Runtime.InteropServices.ComTypes.FORMATETC formatIn, ref System.Runtime.InteropServices.ComTypes.STGMEDIUM medium, bool release);
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.IEnumConnectionPoints` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public interface IEnumConnectionPoints
                {
                    void Clone(out System.Runtime.InteropServices.ComTypes.IEnumConnectionPoints ppenum);
                    int Next(int celt, System.Runtime.InteropServices.ComTypes.IConnectionPoint[] rgelt, System.IntPtr pceltFetched);
                    void Reset();
                    int Skip(int celt);
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.IEnumConnections` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public interface IEnumConnections
                {
                    void Clone(out System.Runtime.InteropServices.ComTypes.IEnumConnections ppenum);
                    int Next(int celt, System.Runtime.InteropServices.ComTypes.CONNECTDATA[] rgelt, System.IntPtr pceltFetched);
                    void Reset();
                    int Skip(int celt);
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.IEnumFORMATETC` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public interface IEnumFORMATETC
                {
                    void Clone(out System.Runtime.InteropServices.ComTypes.IEnumFORMATETC newEnum);
                    int Next(int celt, System.Runtime.InteropServices.ComTypes.FORMATETC[] rgelt, int[] pceltFetched);
                    int Reset();
                    int Skip(int celt);
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.IEnumMoniker` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public interface IEnumMoniker
                {
                    void Clone(out System.Runtime.InteropServices.ComTypes.IEnumMoniker ppenum);
                    int Next(int celt, System.Runtime.InteropServices.ComTypes.IMoniker[] rgelt, System.IntPtr pceltFetched);
                    void Reset();
                    int Skip(int celt);
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.IEnumSTATDATA` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public interface IEnumSTATDATA
                {
                    void Clone(out System.Runtime.InteropServices.ComTypes.IEnumSTATDATA newEnum);
                    int Next(int celt, System.Runtime.InteropServices.ComTypes.STATDATA[] rgelt, int[] pceltFetched);
                    int Reset();
                    int Skip(int celt);
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.IEnumString` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public interface IEnumString
                {
                    void Clone(out System.Runtime.InteropServices.ComTypes.IEnumString ppenum);
                    int Next(int celt, string[] rgelt, System.IntPtr pceltFetched);
                    void Reset();
                    int Skip(int celt);
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.IEnumVARIANT` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public interface IEnumVARIANT
                {
                    System.Runtime.InteropServices.ComTypes.IEnumVARIANT Clone();
                    int Next(int celt, object[] rgVar, System.IntPtr pceltFetched);
                    int Reset();
                    int Skip(int celt);
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.IMPLTYPEFLAGS` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                [System.Flags]
                public enum IMPLTYPEFLAGS
                {
                    IMPLTYPEFLAG_FDEFAULT,
                    IMPLTYPEFLAG_FDEFAULTVTABLE,
                    IMPLTYPEFLAG_FRESTRICTED,
                    IMPLTYPEFLAG_FSOURCE,
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.IMoniker` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public interface IMoniker
                {
                    void BindToObject(System.Runtime.InteropServices.ComTypes.IBindCtx pbc, System.Runtime.InteropServices.ComTypes.IMoniker pmkToLeft, ref System.Guid riidResult, out object ppvResult);
                    void BindToStorage(System.Runtime.InteropServices.ComTypes.IBindCtx pbc, System.Runtime.InteropServices.ComTypes.IMoniker pmkToLeft, ref System.Guid riid, out object ppvObj);
                    void CommonPrefixWith(System.Runtime.InteropServices.ComTypes.IMoniker pmkOther, out System.Runtime.InteropServices.ComTypes.IMoniker ppmkPrefix);
                    void ComposeWith(System.Runtime.InteropServices.ComTypes.IMoniker pmkRight, bool fOnlyIfNotGeneric, out System.Runtime.InteropServices.ComTypes.IMoniker ppmkComposite);
                    void Enum(bool fForward, out System.Runtime.InteropServices.ComTypes.IEnumMoniker ppenumMoniker);
                    void GetClassID(out System.Guid pClassID);
                    void GetDisplayName(System.Runtime.InteropServices.ComTypes.IBindCtx pbc, System.Runtime.InteropServices.ComTypes.IMoniker pmkToLeft, out string ppszDisplayName);
                    void GetSizeMax(out System.Int64 pcbSize);
                    void GetTimeOfLastChange(System.Runtime.InteropServices.ComTypes.IBindCtx pbc, System.Runtime.InteropServices.ComTypes.IMoniker pmkToLeft, out System.Runtime.InteropServices.ComTypes.FILETIME pFileTime);
                    void Hash(out int pdwHash);
                    void Inverse(out System.Runtime.InteropServices.ComTypes.IMoniker ppmk);
                    int IsDirty();
                    int IsEqual(System.Runtime.InteropServices.ComTypes.IMoniker pmkOtherMoniker);
                    int IsRunning(System.Runtime.InteropServices.ComTypes.IBindCtx pbc, System.Runtime.InteropServices.ComTypes.IMoniker pmkToLeft, System.Runtime.InteropServices.ComTypes.IMoniker pmkNewlyRunning);
                    int IsSystemMoniker(out int pdwMksys);
                    void Load(System.Runtime.InteropServices.ComTypes.IStream pStm);
                    void ParseDisplayName(System.Runtime.InteropServices.ComTypes.IBindCtx pbc, System.Runtime.InteropServices.ComTypes.IMoniker pmkToLeft, string pszDisplayName, out int pchEaten, out System.Runtime.InteropServices.ComTypes.IMoniker ppmkOut);
                    void Reduce(System.Runtime.InteropServices.ComTypes.IBindCtx pbc, int dwReduceHowFar, ref System.Runtime.InteropServices.ComTypes.IMoniker ppmkToLeft, out System.Runtime.InteropServices.ComTypes.IMoniker ppmkReduced);
                    void RelativePathTo(System.Runtime.InteropServices.ComTypes.IMoniker pmkOther, out System.Runtime.InteropServices.ComTypes.IMoniker ppmkRelPath);
                    void Save(System.Runtime.InteropServices.ComTypes.IStream pStm, bool fClearDirty);
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.INVOKEKIND` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                [System.Flags]
                public enum INVOKEKIND
                {
                    INVOKE_FUNC,
                    INVOKE_PROPERTYGET,
                    INVOKE_PROPERTYPUT,
                    INVOKE_PROPERTYPUTREF,
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.IPersistFile` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public interface IPersistFile
                {
                    void GetClassID(out System.Guid pClassID);
                    void GetCurFile(out string ppszFileName);
                    int IsDirty();
                    void Load(string pszFileName, int dwMode);
                    void Save(string pszFileName, bool fRemember);
                    void SaveCompleted(string pszFileName);
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.IRunningObjectTable` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public interface IRunningObjectTable
                {
                    void EnumRunning(out System.Runtime.InteropServices.ComTypes.IEnumMoniker ppenumMoniker);
                    int GetObject(System.Runtime.InteropServices.ComTypes.IMoniker pmkObjectName, out object ppunkObject);
                    int GetTimeOfLastChange(System.Runtime.InteropServices.ComTypes.IMoniker pmkObjectName, out System.Runtime.InteropServices.ComTypes.FILETIME pfiletime);
                    int IsRunning(System.Runtime.InteropServices.ComTypes.IMoniker pmkObjectName);
                    void NoteChangeTime(int dwRegister, ref System.Runtime.InteropServices.ComTypes.FILETIME pfiletime);
                    int Register(int grfFlags, object punkObject, System.Runtime.InteropServices.ComTypes.IMoniker pmkObjectName);
                    void Revoke(int dwRegister);
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.IStream` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public interface IStream
                {
                    void Clone(out System.Runtime.InteropServices.ComTypes.IStream ppstm);
                    void Commit(int grfCommitFlags);
                    void CopyTo(System.Runtime.InteropServices.ComTypes.IStream pstm, System.Int64 cb, System.IntPtr pcbRead, System.IntPtr pcbWritten);
                    void LockRegion(System.Int64 libOffset, System.Int64 cb, int dwLockType);
                    void Read(System.Byte[] pv, int cb, System.IntPtr pcbRead);
                    void Revert();
                    void Seek(System.Int64 dlibMove, int dwOrigin, System.IntPtr plibNewPosition);
                    void SetSize(System.Int64 libNewSize);
                    void Stat(out System.Runtime.InteropServices.ComTypes.STATSTG pstatstg, int grfStatFlag);
                    void UnlockRegion(System.Int64 libOffset, System.Int64 cb, int dwLockType);
                    void Write(System.Byte[] pv, int cb, System.IntPtr pcbWritten);
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.ITypeComp` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public interface ITypeComp
                {
                    void Bind(string szName, int lHashVal, System.Int16 wFlags, out System.Runtime.InteropServices.ComTypes.ITypeInfo ppTInfo, out System.Runtime.InteropServices.ComTypes.DESCKIND pDescKind, out System.Runtime.InteropServices.ComTypes.BINDPTR pBindPtr);
                    void BindType(string szName, int lHashVal, out System.Runtime.InteropServices.ComTypes.ITypeInfo ppTInfo, out System.Runtime.InteropServices.ComTypes.ITypeComp ppTComp);
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.ITypeInfo` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public interface ITypeInfo
                {
                    void AddressOfMember(int memid, System.Runtime.InteropServices.ComTypes.INVOKEKIND invKind, out System.IntPtr ppv);
                    void CreateInstance(object pUnkOuter, ref System.Guid riid, out object ppvObj);
                    void GetContainingTypeLib(out System.Runtime.InteropServices.ComTypes.ITypeLib ppTLB, out int pIndex);
                    void GetDllEntry(int memid, System.Runtime.InteropServices.ComTypes.INVOKEKIND invKind, System.IntPtr pBstrDllName, System.IntPtr pBstrName, System.IntPtr pwOrdinal);
                    void GetDocumentation(int index, out string strName, out string strDocString, out int dwHelpContext, out string strHelpFile);
                    void GetFuncDesc(int index, out System.IntPtr ppFuncDesc);
                    void GetIDsOfNames(string[] rgszNames, int cNames, int[] pMemId);
                    void GetImplTypeFlags(int index, out System.Runtime.InteropServices.ComTypes.IMPLTYPEFLAGS pImplTypeFlags);
                    void GetMops(int memid, out string pBstrMops);
                    void GetNames(int memid, string[] rgBstrNames, int cMaxNames, out int pcNames);
                    void GetRefTypeInfo(int hRef, out System.Runtime.InteropServices.ComTypes.ITypeInfo ppTI);
                    void GetRefTypeOfImplType(int index, out int href);
                    void GetTypeAttr(out System.IntPtr ppTypeAttr);
                    void GetTypeComp(out System.Runtime.InteropServices.ComTypes.ITypeComp ppTComp);
                    void GetVarDesc(int index, out System.IntPtr ppVarDesc);
                    void Invoke(object pvInstance, int memid, System.Int16 wFlags, ref System.Runtime.InteropServices.ComTypes.DISPPARAMS pDispParams, System.IntPtr pVarResult, System.IntPtr pExcepInfo, out int puArgErr);
                    void ReleaseFuncDesc(System.IntPtr pFuncDesc);
                    void ReleaseTypeAttr(System.IntPtr pTypeAttr);
                    void ReleaseVarDesc(System.IntPtr pVarDesc);
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.ITypeInfo2` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public interface ITypeInfo2 : System.Runtime.InteropServices.ComTypes.ITypeInfo
                {
                    void AddressOfMember(int memid, System.Runtime.InteropServices.ComTypes.INVOKEKIND invKind, out System.IntPtr ppv);
                    void CreateInstance(object pUnkOuter, ref System.Guid riid, out object ppvObj);
                    void GetAllCustData(System.IntPtr pCustData);
                    void GetAllFuncCustData(int index, System.IntPtr pCustData);
                    void GetAllImplTypeCustData(int index, System.IntPtr pCustData);
                    void GetAllParamCustData(int indexFunc, int indexParam, System.IntPtr pCustData);
                    void GetAllVarCustData(int index, System.IntPtr pCustData);
                    void GetContainingTypeLib(out System.Runtime.InteropServices.ComTypes.ITypeLib ppTLB, out int pIndex);
                    void GetCustData(ref System.Guid guid, out object pVarVal);
                    void GetDllEntry(int memid, System.Runtime.InteropServices.ComTypes.INVOKEKIND invKind, System.IntPtr pBstrDllName, System.IntPtr pBstrName, System.IntPtr pwOrdinal);
                    void GetDocumentation(int index, out string strName, out string strDocString, out int dwHelpContext, out string strHelpFile);
                    void GetDocumentation2(int memid, out string pbstrHelpString, out int pdwHelpStringContext, out string pbstrHelpStringDll);
                    void GetFuncCustData(int index, ref System.Guid guid, out object pVarVal);
                    void GetFuncDesc(int index, out System.IntPtr ppFuncDesc);
                    void GetFuncIndexOfMemId(int memid, System.Runtime.InteropServices.ComTypes.INVOKEKIND invKind, out int pFuncIndex);
                    void GetIDsOfNames(string[] rgszNames, int cNames, int[] pMemId);
                    void GetImplTypeCustData(int index, ref System.Guid guid, out object pVarVal);
                    void GetImplTypeFlags(int index, out System.Runtime.InteropServices.ComTypes.IMPLTYPEFLAGS pImplTypeFlags);
                    void GetMops(int memid, out string pBstrMops);
                    void GetNames(int memid, string[] rgBstrNames, int cMaxNames, out int pcNames);
                    void GetParamCustData(int indexFunc, int indexParam, ref System.Guid guid, out object pVarVal);
                    void GetRefTypeInfo(int hRef, out System.Runtime.InteropServices.ComTypes.ITypeInfo ppTI);
                    void GetRefTypeOfImplType(int index, out int href);
                    void GetTypeAttr(out System.IntPtr ppTypeAttr);
                    void GetTypeComp(out System.Runtime.InteropServices.ComTypes.ITypeComp ppTComp);
                    void GetTypeFlags(out int pTypeFlags);
                    void GetTypeKind(out System.Runtime.InteropServices.ComTypes.TYPEKIND pTypeKind);
                    void GetVarCustData(int index, ref System.Guid guid, out object pVarVal);
                    void GetVarDesc(int index, out System.IntPtr ppVarDesc);
                    void GetVarIndexOfMemId(int memid, out int pVarIndex);
                    void Invoke(object pvInstance, int memid, System.Int16 wFlags, ref System.Runtime.InteropServices.ComTypes.DISPPARAMS pDispParams, System.IntPtr pVarResult, System.IntPtr pExcepInfo, out int puArgErr);
                    void ReleaseFuncDesc(System.IntPtr pFuncDesc);
                    void ReleaseTypeAttr(System.IntPtr pTypeAttr);
                    void ReleaseVarDesc(System.IntPtr pVarDesc);
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.ITypeLib` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public interface ITypeLib
                {
                    void FindName(string szNameBuf, int lHashVal, System.Runtime.InteropServices.ComTypes.ITypeInfo[] ppTInfo, int[] rgMemId, ref System.Int16 pcFound);
                    void GetDocumentation(int index, out string strName, out string strDocString, out int dwHelpContext, out string strHelpFile);
                    void GetLibAttr(out System.IntPtr ppTLibAttr);
                    void GetTypeComp(out System.Runtime.InteropServices.ComTypes.ITypeComp ppTComp);
                    void GetTypeInfo(int index, out System.Runtime.InteropServices.ComTypes.ITypeInfo ppTI);
                    int GetTypeInfoCount();
                    void GetTypeInfoOfGuid(ref System.Guid guid, out System.Runtime.InteropServices.ComTypes.ITypeInfo ppTInfo);
                    void GetTypeInfoType(int index, out System.Runtime.InteropServices.ComTypes.TYPEKIND pTKind);
                    bool IsName(string szNameBuf, int lHashVal);
                    void ReleaseTLibAttr(System.IntPtr pTLibAttr);
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.ITypeLib2` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public interface ITypeLib2 : System.Runtime.InteropServices.ComTypes.ITypeLib
                {
                    void FindName(string szNameBuf, int lHashVal, System.Runtime.InteropServices.ComTypes.ITypeInfo[] ppTInfo, int[] rgMemId, ref System.Int16 pcFound);
                    void GetAllCustData(System.IntPtr pCustData);
                    void GetCustData(ref System.Guid guid, out object pVarVal);
                    void GetDocumentation(int index, out string strName, out string strDocString, out int dwHelpContext, out string strHelpFile);
                    void GetDocumentation2(int index, out string pbstrHelpString, out int pdwHelpStringContext, out string pbstrHelpStringDll);
                    void GetLibAttr(out System.IntPtr ppTLibAttr);
                    void GetLibStatistics(System.IntPtr pcUniqueNames, out int pcchUniqueNames);
                    void GetTypeComp(out System.Runtime.InteropServices.ComTypes.ITypeComp ppTComp);
                    void GetTypeInfo(int index, out System.Runtime.InteropServices.ComTypes.ITypeInfo ppTI);
                    int GetTypeInfoCount();
                    void GetTypeInfoOfGuid(ref System.Guid guid, out System.Runtime.InteropServices.ComTypes.ITypeInfo ppTInfo);
                    void GetTypeInfoType(int index, out System.Runtime.InteropServices.ComTypes.TYPEKIND pTKind);
                    bool IsName(string szNameBuf, int lHashVal);
                    void ReleaseTLibAttr(System.IntPtr pTLibAttr);
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.LIBFLAGS` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                [System.Flags]
                public enum LIBFLAGS
                {
                    LIBFLAG_FCONTROL,
                    LIBFLAG_FHASDISKIMAGE,
                    LIBFLAG_FHIDDEN,
                    LIBFLAG_FRESTRICTED,
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.PARAMDESC` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public struct PARAMDESC
                {
                    // Stub generator skipped constructor 
                    public System.IntPtr lpVarValue;
                    public System.Runtime.InteropServices.ComTypes.PARAMFLAG wParamFlags;
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.PARAMFLAG` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                [System.Flags]
                public enum PARAMFLAG
                {
                    PARAMFLAG_FHASCUSTDATA,
                    PARAMFLAG_FHASDEFAULT,
                    PARAMFLAG_FIN,
                    PARAMFLAG_FLCID,
                    PARAMFLAG_FOPT,
                    PARAMFLAG_FOUT,
                    PARAMFLAG_FRETVAL,
                    PARAMFLAG_NONE,
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.STATDATA` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public struct STATDATA
                {
                    // Stub generator skipped constructor 
                    public System.Runtime.InteropServices.ComTypes.IAdviseSink advSink;
                    public System.Runtime.InteropServices.ComTypes.ADVF advf;
                    public int connection;
                    public System.Runtime.InteropServices.ComTypes.FORMATETC formatetc;
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.STATSTG` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public struct STATSTG
                {
                    // Stub generator skipped constructor 
                    public System.Runtime.InteropServices.ComTypes.FILETIME atime;
                    public System.Int64 cbSize;
                    public System.Guid clsid;
                    public System.Runtime.InteropServices.ComTypes.FILETIME ctime;
                    public int grfLocksSupported;
                    public int grfMode;
                    public int grfStateBits;
                    public System.Runtime.InteropServices.ComTypes.FILETIME mtime;
                    public string pwcsName;
                    public int reserved;
                    public int type;
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.STGMEDIUM` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public struct STGMEDIUM
                {
                    // Stub generator skipped constructor 
                    public object pUnkForRelease;
                    public System.Runtime.InteropServices.ComTypes.TYMED tymed;
                    public System.IntPtr unionmember;
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.SYSKIND` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public enum SYSKIND
                {
                    SYS_MAC,
                    SYS_WIN16,
                    SYS_WIN32,
                    SYS_WIN64,
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.TYMED` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                [System.Flags]
                public enum TYMED
                {
                    TYMED_ENHMF,
                    TYMED_FILE,
                    TYMED_GDI,
                    TYMED_HGLOBAL,
                    TYMED_ISTORAGE,
                    TYMED_ISTREAM,
                    TYMED_MFPICT,
                    TYMED_NULL,
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.TYPEATTR` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public struct TYPEATTR
                {
                    public const int MEMBER_ID_NIL = default;
                    // Stub generator skipped constructor 
                    public System.Int16 cFuncs;
                    public System.Int16 cImplTypes;
                    public System.Int16 cVars;
                    public System.Int16 cbAlignment;
                    public int cbSizeInstance;
                    public System.Int16 cbSizeVft;
                    public int dwReserved;
                    public System.Guid guid;
                    public System.Runtime.InteropServices.ComTypes.IDLDESC idldescType;
                    public int lcid;
                    public System.IntPtr lpstrSchema;
                    public int memidConstructor;
                    public int memidDestructor;
                    public System.Runtime.InteropServices.ComTypes.TYPEDESC tdescAlias;
                    public System.Runtime.InteropServices.ComTypes.TYPEKIND typekind;
                    public System.Int16 wMajorVerNum;
                    public System.Int16 wMinorVerNum;
                    public System.Runtime.InteropServices.ComTypes.TYPEFLAGS wTypeFlags;
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.TYPEDESC` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public struct TYPEDESC
                {
                    // Stub generator skipped constructor 
                    public System.IntPtr lpValue;
                    public System.Int16 vt;
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.TYPEFLAGS` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                [System.Flags]
                public enum TYPEFLAGS
                {
                    TYPEFLAG_FAGGREGATABLE,
                    TYPEFLAG_FAPPOBJECT,
                    TYPEFLAG_FCANCREATE,
                    TYPEFLAG_FCONTROL,
                    TYPEFLAG_FDISPATCHABLE,
                    TYPEFLAG_FDUAL,
                    TYPEFLAG_FHIDDEN,
                    TYPEFLAG_FLICENSED,
                    TYPEFLAG_FNONEXTENSIBLE,
                    TYPEFLAG_FOLEAUTOMATION,
                    TYPEFLAG_FPREDECLID,
                    TYPEFLAG_FPROXY,
                    TYPEFLAG_FREPLACEABLE,
                    TYPEFLAG_FRESTRICTED,
                    TYPEFLAG_FREVERSEBIND,
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.TYPEKIND` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public enum TYPEKIND
                {
                    TKIND_ALIAS,
                    TKIND_COCLASS,
                    TKIND_DISPATCH,
                    TKIND_ENUM,
                    TKIND_INTERFACE,
                    TKIND_MAX,
                    TKIND_MODULE,
                    TKIND_RECORD,
                    TKIND_UNION,
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.TYPELIBATTR` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public struct TYPELIBATTR
                {
                    // Stub generator skipped constructor 
                    public System.Guid guid;
                    public int lcid;
                    public System.Runtime.InteropServices.ComTypes.SYSKIND syskind;
                    public System.Runtime.InteropServices.ComTypes.LIBFLAGS wLibFlags;
                    public System.Int16 wMajorVerNum;
                    public System.Int16 wMinorVerNum;
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.VARDESC` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public struct VARDESC
                {
                    // Generated from `System.Runtime.InteropServices.ComTypes.VARDESC+DESCUNION` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                    public struct DESCUNION
                    {
                        // Stub generator skipped constructor 
                        public System.IntPtr lpvarValue;
                        public int oInst;
                    }


                    // Stub generator skipped constructor 
                    public System.Runtime.InteropServices.ComTypes.VARDESC.DESCUNION desc;
                    public System.Runtime.InteropServices.ComTypes.ELEMDESC elemdescVar;
                    public string lpstrSchema;
                    public int memid;
                    public System.Runtime.InteropServices.ComTypes.VARKIND varkind;
                    public System.Int16 wVarFlags;
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.VARFLAGS` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                [System.Flags]
                public enum VARFLAGS
                {
                    VARFLAG_FBINDABLE,
                    VARFLAG_FDEFAULTBIND,
                    VARFLAG_FDEFAULTCOLLELEM,
                    VARFLAG_FDISPLAYBIND,
                    VARFLAG_FHIDDEN,
                    VARFLAG_FIMMEDIATEBIND,
                    VARFLAG_FNONBROWSABLE,
                    VARFLAG_FREADONLY,
                    VARFLAG_FREPLACEABLE,
                    VARFLAG_FREQUESTEDIT,
                    VARFLAG_FRESTRICTED,
                    VARFLAG_FSOURCE,
                    VARFLAG_FUIDEFAULT,
                }

                // Generated from `System.Runtime.InteropServices.ComTypes.VARKIND` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public enum VARKIND
                {
                    VAR_CONST,
                    VAR_DISPATCH,
                    VAR_PERINSTANCE,
                    VAR_STATIC,
                }

            }
        }
    }
    namespace Security
    {
        // Generated from `System.Security.SecureString` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class SecureString : System.IDisposable
        {
            public void AppendChar(System.Char c) => throw null;
            public void Clear() => throw null;
            public System.Security.SecureString Copy() => throw null;
            public void Dispose() => throw null;
            public void InsertAt(int index, System.Char c) => throw null;
            public bool IsReadOnly() => throw null;
            public int Length { get => throw null; }
            public void MakeReadOnly() => throw null;
            public void RemoveAt(int index) => throw null;
            public SecureString() => throw null;
            unsafe public SecureString(System.Char* value, int length) => throw null;
            public void SetAt(int index, System.Char c) => throw null;
        }

        // Generated from `System.Security.SecureStringMarshal` in `System.Runtime.InteropServices, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public static class SecureStringMarshal
        {
            public static System.IntPtr SecureStringToCoTaskMemAnsi(System.Security.SecureString s) => throw null;
            public static System.IntPtr SecureStringToCoTaskMemUnicode(System.Security.SecureString s) => throw null;
            public static System.IntPtr SecureStringToGlobalAllocAnsi(System.Security.SecureString s) => throw null;
            public static System.IntPtr SecureStringToGlobalAllocUnicode(System.Security.SecureString s) => throw null;
        }

    }
}
