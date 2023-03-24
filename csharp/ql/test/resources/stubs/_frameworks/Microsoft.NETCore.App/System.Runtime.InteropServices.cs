// This file contains auto-generated code.
// Generated from `System.Runtime.InteropServices, Version=7.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.

namespace System
{
    public class DataMisalignedException : System.SystemException
    {
        public DataMisalignedException() => throw null;
        public DataMisalignedException(string message) => throw null;
        public DataMisalignedException(string message, System.Exception innerException) => throw null;
    }

    public class DllNotFoundException : System.TypeLoadException
    {
        public DllNotFoundException() => throw null;
        protected DllNotFoundException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public DllNotFoundException(string message) => throw null;
        public DllNotFoundException(string message, System.Exception inner) => throw null;
    }

    namespace IO
    {
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
            public class IDispatchConstantAttribute : System.Runtime.CompilerServices.CustomConstantAttribute
            {
                public IDispatchConstantAttribute() => throw null;
                public override object Value { get => throw null; }
            }

            public class IUnknownConstantAttribute : System.Runtime.CompilerServices.CustomConstantAttribute
            {
                public IUnknownConstantAttribute() => throw null;
                public override object Value { get => throw null; }
            }

        }
        namespace InteropServices
        {
            public class AllowReversePInvokeCallsAttribute : System.Attribute
            {
                public AllowReversePInvokeCallsAttribute() => throw null;
            }

            public struct ArrayWithOffset : System.IEquatable<System.Runtime.InteropServices.ArrayWithOffset>
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

            public class AutomationProxyAttribute : System.Attribute
            {
                public AutomationProxyAttribute(bool val) => throw null;
                public bool Value { get => throw null; }
            }

            public class BStrWrapper
            {
                public BStrWrapper(object value) => throw null;
                public BStrWrapper(string value) => throw null;
                public string WrappedObject { get => throw null; }
            }

            public class BestFitMappingAttribute : System.Attribute
            {
                public bool BestFitMapping { get => throw null; }
                public BestFitMappingAttribute(bool BestFitMapping) => throw null;
                public bool ThrowOnUnmappableChar;
            }

            public struct CLong : System.IEquatable<System.Runtime.InteropServices.CLong>
            {
                // Stub generator skipped constructor 
                public CLong(System.IntPtr value) => throw null;
                public CLong(int value) => throw null;
                public bool Equals(System.Runtime.InteropServices.CLong other) => throw null;
                public override bool Equals(object o) => throw null;
                public override int GetHashCode() => throw null;
                public override string ToString() => throw null;
                public System.IntPtr Value { get => throw null; }
            }

            public class COMException : System.Runtime.InteropServices.ExternalException
            {
                public COMException() => throw null;
                protected COMException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public COMException(string message) => throw null;
                public COMException(string message, System.Exception inner) => throw null;
                public COMException(string message, int errorCode) => throw null;
                public override string ToString() => throw null;
            }

            public struct CULong : System.IEquatable<System.Runtime.InteropServices.CULong>
            {
                // Stub generator skipped constructor 
                public CULong(System.UIntPtr value) => throw null;
                public CULong(System.UInt32 value) => throw null;
                public bool Equals(System.Runtime.InteropServices.CULong other) => throw null;
                public override bool Equals(object o) => throw null;
                public override int GetHashCode() => throw null;
                public override string ToString() => throw null;
                public System.UIntPtr Value { get => throw null; }
            }

            public enum CallingConvention : int
            {
                Cdecl = 2,
                FastCall = 5,
                StdCall = 3,
                ThisCall = 4,
                Winapi = 1,
            }

            public class ClassInterfaceAttribute : System.Attribute
            {
                public ClassInterfaceAttribute(System.Runtime.InteropServices.ClassInterfaceType classInterfaceType) => throw null;
                public ClassInterfaceAttribute(System.Int16 classInterfaceType) => throw null;
                public System.Runtime.InteropServices.ClassInterfaceType Value { get => throw null; }
            }

            public enum ClassInterfaceType : int
            {
                AutoDispatch = 1,
                AutoDual = 2,
                None = 0,
            }

            public class CoClassAttribute : System.Attribute
            {
                public System.Type CoClass { get => throw null; }
                public CoClassAttribute(System.Type coClass) => throw null;
            }

            public static class CollectionsMarshal
            {
                public static System.Span<T> AsSpan<T>(System.Collections.Generic.List<T> list) => throw null;
                public static TValue GetValueRefOrAddDefault<TKey, TValue>(System.Collections.Generic.Dictionary<TKey, TValue> dictionary, TKey key, out bool exists) => throw null;
                public static TValue GetValueRefOrNullRef<TKey, TValue>(System.Collections.Generic.Dictionary<TKey, TValue> dictionary, TKey key) => throw null;
            }

            public class ComAliasNameAttribute : System.Attribute
            {
                public ComAliasNameAttribute(string alias) => throw null;
                public string Value { get => throw null; }
            }

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

            public class ComCompatibleVersionAttribute : System.Attribute
            {
                public int BuildNumber { get => throw null; }
                public ComCompatibleVersionAttribute(int major, int minor, int build, int revision) => throw null;
                public int MajorVersion { get => throw null; }
                public int MinorVersion { get => throw null; }
                public int RevisionNumber { get => throw null; }
            }

            public class ComConversionLossAttribute : System.Attribute
            {
                public ComConversionLossAttribute() => throw null;
            }

            public class ComDefaultInterfaceAttribute : System.Attribute
            {
                public ComDefaultInterfaceAttribute(System.Type defaultInterface) => throw null;
                public System.Type Value { get => throw null; }
            }

            public class ComEventInterfaceAttribute : System.Attribute
            {
                public ComEventInterfaceAttribute(System.Type SourceInterface, System.Type EventProvider) => throw null;
                public System.Type EventProvider { get => throw null; }
                public System.Type SourceInterface { get => throw null; }
            }

            public static class ComEventsHelper
            {
                public static void Combine(object rcw, System.Guid iid, int dispid, System.Delegate d) => throw null;
                public static System.Delegate Remove(object rcw, System.Guid iid, int dispid, System.Delegate d) => throw null;
            }

            public class ComImportAttribute : System.Attribute
            {
                public ComImportAttribute() => throw null;
            }

            public enum ComInterfaceType : int
            {
                InterfaceIsDual = 0,
                InterfaceIsIDispatch = 2,
                InterfaceIsIInspectable = 3,
                InterfaceIsIUnknown = 1,
            }

            public enum ComMemberType : int
            {
                Method = 0,
                PropGet = 1,
                PropSet = 2,
            }

            public class ComRegisterFunctionAttribute : System.Attribute
            {
                public ComRegisterFunctionAttribute() => throw null;
            }

            public class ComSourceInterfacesAttribute : System.Attribute
            {
                public ComSourceInterfacesAttribute(System.Type sourceInterface) => throw null;
                public ComSourceInterfacesAttribute(System.Type sourceInterface1, System.Type sourceInterface2) => throw null;
                public ComSourceInterfacesAttribute(System.Type sourceInterface1, System.Type sourceInterface2, System.Type sourceInterface3) => throw null;
                public ComSourceInterfacesAttribute(System.Type sourceInterface1, System.Type sourceInterface2, System.Type sourceInterface3, System.Type sourceInterface4) => throw null;
                public ComSourceInterfacesAttribute(string sourceInterfaces) => throw null;
                public string Value { get => throw null; }
            }

            public class ComUnregisterFunctionAttribute : System.Attribute
            {
                public ComUnregisterFunctionAttribute() => throw null;
            }

            public abstract class ComWrappers
            {
                public struct ComInterfaceDispatch
                {
                    // Stub generator skipped constructor 
                    unsafe public static T GetInstance<T>(System.Runtime.InteropServices.ComWrappers.ComInterfaceDispatch* dispatchPtr) where T : class => throw null;
                    public System.IntPtr Vtable;
                }


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
                public object GetOrRegisterObjectForComInstance(System.IntPtr externalComObject, System.Runtime.InteropServices.CreateObjectFlags flags, object wrapper, System.IntPtr inner) => throw null;
                public static void RegisterForMarshalling(System.Runtime.InteropServices.ComWrappers instance) => throw null;
                public static void RegisterForTrackerSupport(System.Runtime.InteropServices.ComWrappers instance) => throw null;
                protected abstract void ReleaseObjects(System.Collections.IEnumerable objects);
            }

            [System.Flags]
            public enum CreateComInterfaceFlags : int
            {
                CallerDefinedIUnknown = 1,
                None = 0,
                TrackerSupport = 2,
            }

            [System.Flags]
            public enum CreateObjectFlags : int
            {
                Aggregation = 4,
                None = 0,
                TrackerObject = 1,
                UniqueInstance = 2,
                Unwrap = 8,
            }

            public class CurrencyWrapper
            {
                public CurrencyWrapper(System.Decimal obj) => throw null;
                public CurrencyWrapper(object obj) => throw null;
                public System.Decimal WrappedObject { get => throw null; }
            }

            public enum CustomQueryInterfaceMode : int
            {
                Allow = 1,
                Ignore = 0,
            }

            public enum CustomQueryInterfaceResult : int
            {
                Failed = 2,
                Handled = 0,
                NotHandled = 1,
            }

            public class DefaultCharSetAttribute : System.Attribute
            {
                public System.Runtime.InteropServices.CharSet CharSet { get => throw null; }
                public DefaultCharSetAttribute(System.Runtime.InteropServices.CharSet charSet) => throw null;
            }

            public class DefaultDllImportSearchPathsAttribute : System.Attribute
            {
                public DefaultDllImportSearchPathsAttribute(System.Runtime.InteropServices.DllImportSearchPath paths) => throw null;
                public System.Runtime.InteropServices.DllImportSearchPath Paths { get => throw null; }
            }

            public class DefaultParameterValueAttribute : System.Attribute
            {
                public DefaultParameterValueAttribute(object value) => throw null;
                public object Value { get => throw null; }
            }

            public class DispIdAttribute : System.Attribute
            {
                public DispIdAttribute(int dispId) => throw null;
                public int Value { get => throw null; }
            }

            public class DispatchWrapper
            {
                public DispatchWrapper(object obj) => throw null;
                public object WrappedObject { get => throw null; }
            }

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

            public delegate System.IntPtr DllImportResolver(string libraryName, System.Reflection.Assembly assembly, System.Runtime.InteropServices.DllImportSearchPath? searchPath);

            [System.Flags]
            public enum DllImportSearchPath : int
            {
                ApplicationDirectory = 512,
                AssemblyDirectory = 2,
                LegacyBehavior = 0,
                SafeDirectories = 4096,
                System32 = 2048,
                UseDllDirectoryForDependencies = 256,
                UserDirectories = 1024,
            }

            public class DynamicInterfaceCastableImplementationAttribute : System.Attribute
            {
                public DynamicInterfaceCastableImplementationAttribute() => throw null;
            }

            public class ErrorWrapper
            {
                public int ErrorCode { get => throw null; }
                public ErrorWrapper(System.Exception e) => throw null;
                public ErrorWrapper(int errorCode) => throw null;
                public ErrorWrapper(object errorCode) => throw null;
            }

            public class GuidAttribute : System.Attribute
            {
                public GuidAttribute(string guid) => throw null;
                public string Value { get => throw null; }
            }

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

            public struct HandleRef
            {
                public System.IntPtr Handle { get => throw null; }
                // Stub generator skipped constructor 
                public HandleRef(object wrapper, System.IntPtr handle) => throw null;
                public static System.IntPtr ToIntPtr(System.Runtime.InteropServices.HandleRef value) => throw null;
                public object Wrapper { get => throw null; }
                public static explicit operator System.IntPtr(System.Runtime.InteropServices.HandleRef value) => throw null;
            }

            public interface ICustomAdapter
            {
                object GetUnderlyingObject();
            }

            public interface ICustomFactory
            {
                System.MarshalByRefObject CreateInstance(System.Type serverType);
            }

            public interface ICustomMarshaler
            {
                void CleanUpManagedData(object ManagedObj);
                void CleanUpNativeData(System.IntPtr pNativeData);
                int GetNativeDataSize();
                System.IntPtr MarshalManagedToNative(object ManagedObj);
                object MarshalNativeToManaged(System.IntPtr pNativeData);
            }

            public interface ICustomQueryInterface
            {
                System.Runtime.InteropServices.CustomQueryInterfaceResult GetInterface(ref System.Guid iid, out System.IntPtr ppv);
            }

            public interface IDynamicInterfaceCastable
            {
                System.RuntimeTypeHandle GetInterfaceImplementation(System.RuntimeTypeHandle interfaceType);
                bool IsInterfaceImplemented(System.RuntimeTypeHandle interfaceType, bool throwIfNotImplemented);
            }

            public class ImportedFromTypeLibAttribute : System.Attribute
            {
                public ImportedFromTypeLibAttribute(string tlbFile) => throw null;
                public string Value { get => throw null; }
            }

            public class InterfaceTypeAttribute : System.Attribute
            {
                public InterfaceTypeAttribute(System.Runtime.InteropServices.ComInterfaceType interfaceType) => throw null;
                public InterfaceTypeAttribute(System.Int16 interfaceType) => throw null;
                public System.Runtime.InteropServices.ComInterfaceType Value { get => throw null; }
            }

            public class InvalidComObjectException : System.SystemException
            {
                public InvalidComObjectException() => throw null;
                protected InvalidComObjectException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public InvalidComObjectException(string message) => throw null;
                public InvalidComObjectException(string message, System.Exception inner) => throw null;
            }

            public class InvalidOleVariantTypeException : System.SystemException
            {
                public InvalidOleVariantTypeException() => throw null;
                protected InvalidOleVariantTypeException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public InvalidOleVariantTypeException(string message) => throw null;
                public InvalidOleVariantTypeException(string message, System.Exception inner) => throw null;
            }

            public class LCIDConversionAttribute : System.Attribute
            {
                public LCIDConversionAttribute(int lcid) => throw null;
                public int Value { get => throw null; }
            }

            public class LibraryImportAttribute : System.Attribute
            {
                public string EntryPoint { get => throw null; set => throw null; }
                public LibraryImportAttribute(string libraryName) => throw null;
                public string LibraryName { get => throw null; }
                public bool SetLastError { get => throw null; set => throw null; }
                public System.Runtime.InteropServices.StringMarshalling StringMarshalling { get => throw null; set => throw null; }
                public System.Type StringMarshallingCustomType { get => throw null; set => throw null; }
            }

            public class ManagedToNativeComInteropStubAttribute : System.Attribute
            {
                public System.Type ClassType { get => throw null; }
                public ManagedToNativeComInteropStubAttribute(System.Type classType, string methodName) => throw null;
                public string MethodName { get => throw null; }
            }

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
                public static int GetLastPInvokeError() => throw null;
                public static string GetLastPInvokeErrorMessage() => throw null;
                public static int GetLastSystemError() => throw null;
                public static int GetLastWin32Error() => throw null;
                public static void GetNativeVariantForObject(object obj, System.IntPtr pDstNativeVariant) => throw null;
                public static void GetNativeVariantForObject<T>(T obj, System.IntPtr pDstNativeVariant) => throw null;
                public static object GetObjectForIUnknown(System.IntPtr pUnk) => throw null;
                public static object GetObjectForNativeVariant(System.IntPtr pSrcNativeVariant) => throw null;
                public static T GetObjectForNativeVariant<T>(System.IntPtr pSrcNativeVariant) => throw null;
                public static object[] GetObjectsForNativeVariants(System.IntPtr aSrcNativeVariant, int cVars) => throw null;
                public static T[] GetObjectsForNativeVariants<T>(System.IntPtr aSrcNativeVariant, int cVars) => throw null;
                public static string GetPInvokeErrorMessage(int error) => throw null;
                public static int GetStartComSlot(System.Type t) => throw null;
                public static System.Type GetTypeFromCLSID(System.Guid clsid) => throw null;
                public static string GetTypeInfoName(System.Runtime.InteropServices.ComTypes.ITypeInfo typeInfo) => throw null;
                public static object GetTypedObjectForIUnknown(System.IntPtr pUnk, System.Type t) => throw null;
                public static object GetUniqueObjectForIUnknown(System.IntPtr unknown) => throw null;
                public static void InitHandle(System.Runtime.InteropServices.SafeHandle safeHandle, System.IntPtr handle) => throw null;
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
                public static void SetLastPInvokeError(int error) => throw null;
                public static void SetLastSystemError(int error) => throw null;
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

            public class MarshalDirectiveException : System.SystemException
            {
                public MarshalDirectiveException() => throw null;
                protected MarshalDirectiveException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public MarshalDirectiveException(string message) => throw null;
                public MarshalDirectiveException(string message, System.Exception inner) => throw null;
            }

            public struct NFloat : System.IComparable, System.IComparable<System.Runtime.InteropServices.NFloat>, System.IEquatable<System.Runtime.InteropServices.NFloat>, System.IFormattable, System.IParsable<System.Runtime.InteropServices.NFloat>, System.ISpanFormattable, System.ISpanParsable<System.Runtime.InteropServices.NFloat>, System.Numerics.IAdditionOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>, System.Numerics.IAdditiveIdentity<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>, System.Numerics.IBinaryFloatingPointIeee754<System.Runtime.InteropServices.NFloat>, System.Numerics.IBinaryNumber<System.Runtime.InteropServices.NFloat>, System.Numerics.IBitwiseOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>, System.Numerics.IComparisonOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, bool>, System.Numerics.IDecrementOperators<System.Runtime.InteropServices.NFloat>, System.Numerics.IDivisionOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>, System.Numerics.IEqualityOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, bool>, System.Numerics.IExponentialFunctions<System.Runtime.InteropServices.NFloat>, System.Numerics.IFloatingPoint<System.Runtime.InteropServices.NFloat>, System.Numerics.IFloatingPointConstants<System.Runtime.InteropServices.NFloat>, System.Numerics.IFloatingPointIeee754<System.Runtime.InteropServices.NFloat>, System.Numerics.IHyperbolicFunctions<System.Runtime.InteropServices.NFloat>, System.Numerics.IIncrementOperators<System.Runtime.InteropServices.NFloat>, System.Numerics.ILogarithmicFunctions<System.Runtime.InteropServices.NFloat>, System.Numerics.IMinMaxValue<System.Runtime.InteropServices.NFloat>, System.Numerics.IModulusOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>, System.Numerics.IMultiplicativeIdentity<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>, System.Numerics.IMultiplyOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>, System.Numerics.INumber<System.Runtime.InteropServices.NFloat>, System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>, System.Numerics.IPowerFunctions<System.Runtime.InteropServices.NFloat>, System.Numerics.IRootFunctions<System.Runtime.InteropServices.NFloat>, System.Numerics.ISignedNumber<System.Runtime.InteropServices.NFloat>, System.Numerics.ISubtractionOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>, System.Numerics.ITrigonometricFunctions<System.Runtime.InteropServices.NFloat>, System.Numerics.IUnaryNegationOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>, System.Numerics.IUnaryPlusOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>
            {
                static bool System.Numerics.IEqualityOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, bool>.operator !=(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IModulusOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>.operator %(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IBitwiseOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>.operator &(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IMultiplyOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>.operator *(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IUnaryPlusOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>.operator +(System.Runtime.InteropServices.NFloat value) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IAdditionOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>.operator +(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IIncrementOperators<System.Runtime.InteropServices.NFloat>.operator ++(System.Runtime.InteropServices.NFloat value) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IUnaryNegationOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>.operator -(System.Runtime.InteropServices.NFloat value) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.ISubtractionOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>.operator -(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IDecrementOperators<System.Runtime.InteropServices.NFloat>.operator --(System.Runtime.InteropServices.NFloat value) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IDivisionOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>.operator /(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right) => throw null;
                static bool System.Numerics.IComparisonOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, bool>.operator <(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right) => throw null;
                static bool System.Numerics.IComparisonOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, bool>.operator <=(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right) => throw null;
                static bool System.Numerics.IEqualityOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, bool>.operator ==(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right) => throw null;
                static bool System.Numerics.IComparisonOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, bool>.operator >(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right) => throw null;
                static bool System.Numerics.IComparisonOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, bool>.operator >=(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right) => throw null;
                public static System.Runtime.InteropServices.NFloat Abs(System.Runtime.InteropServices.NFloat value) => throw null;
                public static System.Runtime.InteropServices.NFloat Acos(System.Runtime.InteropServices.NFloat x) => throw null;
                public static System.Runtime.InteropServices.NFloat AcosPi(System.Runtime.InteropServices.NFloat x) => throw null;
                public static System.Runtime.InteropServices.NFloat Acosh(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IAdditiveIdentity<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>.AdditiveIdentity { get => throw null; }
                static System.Runtime.InteropServices.NFloat System.Numerics.IBinaryNumber<System.Runtime.InteropServices.NFloat>.AllBitsSet { get => throw null; }
                public static System.Runtime.InteropServices.NFloat Asin(System.Runtime.InteropServices.NFloat x) => throw null;
                public static System.Runtime.InteropServices.NFloat AsinPi(System.Runtime.InteropServices.NFloat x) => throw null;
                public static System.Runtime.InteropServices.NFloat Asinh(System.Runtime.InteropServices.NFloat x) => throw null;
                public static System.Runtime.InteropServices.NFloat Atan(System.Runtime.InteropServices.NFloat x) => throw null;
                public static System.Runtime.InteropServices.NFloat Atan2(System.Runtime.InteropServices.NFloat y, System.Runtime.InteropServices.NFloat x) => throw null;
                public static System.Runtime.InteropServices.NFloat Atan2Pi(System.Runtime.InteropServices.NFloat y, System.Runtime.InteropServices.NFloat x) => throw null;
                public static System.Runtime.InteropServices.NFloat AtanPi(System.Runtime.InteropServices.NFloat x) => throw null;
                public static System.Runtime.InteropServices.NFloat Atanh(System.Runtime.InteropServices.NFloat x) => throw null;
                public static System.Runtime.InteropServices.NFloat BitDecrement(System.Runtime.InteropServices.NFloat x) => throw null;
                public static System.Runtime.InteropServices.NFloat BitIncrement(System.Runtime.InteropServices.NFloat x) => throw null;
                public static System.Runtime.InteropServices.NFloat Cbrt(System.Runtime.InteropServices.NFloat x) => throw null;
                public static System.Runtime.InteropServices.NFloat Ceiling(System.Runtime.InteropServices.NFloat x) => throw null;
                public static System.Runtime.InteropServices.NFloat Clamp(System.Runtime.InteropServices.NFloat value, System.Runtime.InteropServices.NFloat min, System.Runtime.InteropServices.NFloat max) => throw null;
                public int CompareTo(System.Runtime.InteropServices.NFloat other) => throw null;
                public int CompareTo(object obj) => throw null;
                public static System.Runtime.InteropServices.NFloat CopySign(System.Runtime.InteropServices.NFloat value, System.Runtime.InteropServices.NFloat sign) => throw null;
                public static System.Runtime.InteropServices.NFloat Cos(System.Runtime.InteropServices.NFloat x) => throw null;
                public static System.Runtime.InteropServices.NFloat CosPi(System.Runtime.InteropServices.NFloat x) => throw null;
                public static System.Runtime.InteropServices.NFloat Cosh(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.CreateChecked<TOther>(TOther value) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.CreateSaturating<TOther>(TOther value) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.CreateTruncating<TOther>(TOther value) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IFloatingPointConstants<System.Runtime.InteropServices.NFloat>.E { get => throw null; }
                static System.Runtime.InteropServices.NFloat System.Numerics.IFloatingPointIeee754<System.Runtime.InteropServices.NFloat>.Epsilon { get => throw null; }
                public bool Equals(System.Runtime.InteropServices.NFloat other) => throw null;
                public override bool Equals(object obj) => throw null;
                public static System.Runtime.InteropServices.NFloat Exp(System.Runtime.InteropServices.NFloat x) => throw null;
                public static System.Runtime.InteropServices.NFloat Exp10(System.Runtime.InteropServices.NFloat x) => throw null;
                public static System.Runtime.InteropServices.NFloat Exp10M1(System.Runtime.InteropServices.NFloat x) => throw null;
                public static System.Runtime.InteropServices.NFloat Exp2(System.Runtime.InteropServices.NFloat x) => throw null;
                public static System.Runtime.InteropServices.NFloat Exp2M1(System.Runtime.InteropServices.NFloat x) => throw null;
                public static System.Runtime.InteropServices.NFloat ExpM1(System.Runtime.InteropServices.NFloat x) => throw null;
                public static System.Runtime.InteropServices.NFloat Floor(System.Runtime.InteropServices.NFloat x) => throw null;
                public static System.Runtime.InteropServices.NFloat FusedMultiplyAdd(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right, System.Runtime.InteropServices.NFloat addend) => throw null;
                int System.Numerics.IFloatingPoint<System.Runtime.InteropServices.NFloat>.GetExponentByteCount() => throw null;
                int System.Numerics.IFloatingPoint<System.Runtime.InteropServices.NFloat>.GetExponentShortestBitLength() => throw null;
                public override int GetHashCode() => throw null;
                int System.Numerics.IFloatingPoint<System.Runtime.InteropServices.NFloat>.GetSignificandBitLength() => throw null;
                int System.Numerics.IFloatingPoint<System.Runtime.InteropServices.NFloat>.GetSignificandByteCount() => throw null;
                public static System.Runtime.InteropServices.NFloat Hypot(System.Runtime.InteropServices.NFloat x, System.Runtime.InteropServices.NFloat y) => throw null;
                public static int ILogB(System.Runtime.InteropServices.NFloat x) => throw null;
                public static System.Runtime.InteropServices.NFloat Ieee754Remainder(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right) => throw null;
                public static bool IsCanonical(System.Runtime.InteropServices.NFloat value) => throw null;
                public static bool IsComplexNumber(System.Runtime.InteropServices.NFloat value) => throw null;
                public static bool IsEvenInteger(System.Runtime.InteropServices.NFloat value) => throw null;
                public static bool IsFinite(System.Runtime.InteropServices.NFloat value) => throw null;
                public static bool IsImaginaryNumber(System.Runtime.InteropServices.NFloat value) => throw null;
                public static bool IsInfinity(System.Runtime.InteropServices.NFloat value) => throw null;
                public static bool IsInteger(System.Runtime.InteropServices.NFloat value) => throw null;
                public static bool IsNaN(System.Runtime.InteropServices.NFloat value) => throw null;
                public static bool IsNegative(System.Runtime.InteropServices.NFloat value) => throw null;
                public static bool IsNegativeInfinity(System.Runtime.InteropServices.NFloat value) => throw null;
                public static bool IsNormal(System.Runtime.InteropServices.NFloat value) => throw null;
                public static bool IsOddInteger(System.Runtime.InteropServices.NFloat value) => throw null;
                public static bool IsPositive(System.Runtime.InteropServices.NFloat value) => throw null;
                public static bool IsPositiveInfinity(System.Runtime.InteropServices.NFloat value) => throw null;
                public static bool IsPow2(System.Runtime.InteropServices.NFloat value) => throw null;
                public static bool IsRealNumber(System.Runtime.InteropServices.NFloat value) => throw null;
                public static bool IsSubnormal(System.Runtime.InteropServices.NFloat value) => throw null;
                public static bool IsZero(System.Runtime.InteropServices.NFloat value) => throw null;
                public static System.Runtime.InteropServices.NFloat Log(System.Runtime.InteropServices.NFloat x) => throw null;
                public static System.Runtime.InteropServices.NFloat Log(System.Runtime.InteropServices.NFloat x, System.Runtime.InteropServices.NFloat newBase) => throw null;
                public static System.Runtime.InteropServices.NFloat Log10(System.Runtime.InteropServices.NFloat x) => throw null;
                public static System.Runtime.InteropServices.NFloat Log10P1(System.Runtime.InteropServices.NFloat x) => throw null;
                public static System.Runtime.InteropServices.NFloat Log2(System.Runtime.InteropServices.NFloat value) => throw null;
                public static System.Runtime.InteropServices.NFloat Log2P1(System.Runtime.InteropServices.NFloat x) => throw null;
                public static System.Runtime.InteropServices.NFloat LogP1(System.Runtime.InteropServices.NFloat x) => throw null;
                public static System.Runtime.InteropServices.NFloat Max(System.Runtime.InteropServices.NFloat x, System.Runtime.InteropServices.NFloat y) => throw null;
                public static System.Runtime.InteropServices.NFloat MaxMagnitude(System.Runtime.InteropServices.NFloat x, System.Runtime.InteropServices.NFloat y) => throw null;
                public static System.Runtime.InteropServices.NFloat MaxMagnitudeNumber(System.Runtime.InteropServices.NFloat x, System.Runtime.InteropServices.NFloat y) => throw null;
                public static System.Runtime.InteropServices.NFloat MaxNumber(System.Runtime.InteropServices.NFloat x, System.Runtime.InteropServices.NFloat y) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IMinMaxValue<System.Runtime.InteropServices.NFloat>.MaxValue { get => throw null; }
                public static System.Runtime.InteropServices.NFloat Min(System.Runtime.InteropServices.NFloat x, System.Runtime.InteropServices.NFloat y) => throw null;
                public static System.Runtime.InteropServices.NFloat MinMagnitude(System.Runtime.InteropServices.NFloat x, System.Runtime.InteropServices.NFloat y) => throw null;
                public static System.Runtime.InteropServices.NFloat MinMagnitudeNumber(System.Runtime.InteropServices.NFloat x, System.Runtime.InteropServices.NFloat y) => throw null;
                public static System.Runtime.InteropServices.NFloat MinNumber(System.Runtime.InteropServices.NFloat x, System.Runtime.InteropServices.NFloat y) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IMinMaxValue<System.Runtime.InteropServices.NFloat>.MinValue { get => throw null; }
                static System.Runtime.InteropServices.NFloat System.Numerics.IMultiplicativeIdentity<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>.MultiplicativeIdentity { get => throw null; }
                // Stub generator skipped constructor 
                public NFloat(double value) => throw null;
                public NFloat(float value) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IFloatingPointIeee754<System.Runtime.InteropServices.NFloat>.NaN { get => throw null; }
                static System.Runtime.InteropServices.NFloat System.Numerics.IFloatingPointIeee754<System.Runtime.InteropServices.NFloat>.NegativeInfinity { get => throw null; }
                static System.Runtime.InteropServices.NFloat System.Numerics.ISignedNumber<System.Runtime.InteropServices.NFloat>.NegativeOne { get => throw null; }
                static System.Runtime.InteropServices.NFloat System.Numerics.IFloatingPointIeee754<System.Runtime.InteropServices.NFloat>.NegativeZero { get => throw null; }
                static System.Runtime.InteropServices.NFloat System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.One { get => throw null; }
                public static System.Runtime.InteropServices.NFloat Parse(System.ReadOnlySpan<System.Char> s, System.IFormatProvider provider) => throw null;
                public static System.Runtime.InteropServices.NFloat Parse(System.ReadOnlySpan<System.Char> s, System.Globalization.NumberStyles style = default(System.Globalization.NumberStyles), System.IFormatProvider provider = default(System.IFormatProvider)) => throw null;
                public static System.Runtime.InteropServices.NFloat Parse(string s) => throw null;
                public static System.Runtime.InteropServices.NFloat Parse(string s, System.IFormatProvider provider) => throw null;
                public static System.Runtime.InteropServices.NFloat Parse(string s, System.Globalization.NumberStyles style) => throw null;
                public static System.Runtime.InteropServices.NFloat Parse(string s, System.Globalization.NumberStyles style, System.IFormatProvider provider) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IFloatingPointConstants<System.Runtime.InteropServices.NFloat>.Pi { get => throw null; }
                static System.Runtime.InteropServices.NFloat System.Numerics.IFloatingPointIeee754<System.Runtime.InteropServices.NFloat>.PositiveInfinity { get => throw null; }
                public static System.Runtime.InteropServices.NFloat Pow(System.Runtime.InteropServices.NFloat x, System.Runtime.InteropServices.NFloat y) => throw null;
                static int System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.Radix { get => throw null; }
                public static System.Runtime.InteropServices.NFloat ReciprocalEstimate(System.Runtime.InteropServices.NFloat x) => throw null;
                public static System.Runtime.InteropServices.NFloat ReciprocalSqrtEstimate(System.Runtime.InteropServices.NFloat x) => throw null;
                public static System.Runtime.InteropServices.NFloat RootN(System.Runtime.InteropServices.NFloat x, int n) => throw null;
                public static System.Runtime.InteropServices.NFloat Round(System.Runtime.InteropServices.NFloat x) => throw null;
                public static System.Runtime.InteropServices.NFloat Round(System.Runtime.InteropServices.NFloat x, System.MidpointRounding mode) => throw null;
                public static System.Runtime.InteropServices.NFloat Round(System.Runtime.InteropServices.NFloat x, int digits) => throw null;
                public static System.Runtime.InteropServices.NFloat Round(System.Runtime.InteropServices.NFloat x, int digits, System.MidpointRounding mode) => throw null;
                public static System.Runtime.InteropServices.NFloat ScaleB(System.Runtime.InteropServices.NFloat x, int n) => throw null;
                public static int Sign(System.Runtime.InteropServices.NFloat value) => throw null;
                public static System.Runtime.InteropServices.NFloat Sin(System.Runtime.InteropServices.NFloat x) => throw null;
                public static (System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat) SinCos(System.Runtime.InteropServices.NFloat x) => throw null;
                public static (System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat) SinCosPi(System.Runtime.InteropServices.NFloat x) => throw null;
                public static System.Runtime.InteropServices.NFloat SinPi(System.Runtime.InteropServices.NFloat x) => throw null;
                public static System.Runtime.InteropServices.NFloat Sinh(System.Runtime.InteropServices.NFloat x) => throw null;
                public static int Size { get => throw null; }
                public static System.Runtime.InteropServices.NFloat Sqrt(System.Runtime.InteropServices.NFloat x) => throw null;
                public static System.Runtime.InteropServices.NFloat Tan(System.Runtime.InteropServices.NFloat x) => throw null;
                public static System.Runtime.InteropServices.NFloat TanPi(System.Runtime.InteropServices.NFloat x) => throw null;
                public static System.Runtime.InteropServices.NFloat Tanh(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IFloatingPointConstants<System.Runtime.InteropServices.NFloat>.Tau { get => throw null; }
                public override string ToString() => throw null;
                public string ToString(System.IFormatProvider provider) => throw null;
                public string ToString(string format) => throw null;
                public string ToString(string format, System.IFormatProvider provider) => throw null;
                public static System.Runtime.InteropServices.NFloat Truncate(System.Runtime.InteropServices.NFloat x) => throw null;
                static bool System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.TryConvertFromChecked<TOther>(TOther value, out System.Runtime.InteropServices.NFloat result) => throw null;
                static bool System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.TryConvertFromSaturating<TOther>(TOther value, out System.Runtime.InteropServices.NFloat result) => throw null;
                static bool System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.TryConvertFromTruncating<TOther>(TOther value, out System.Runtime.InteropServices.NFloat result) => throw null;
                static bool System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.TryConvertToChecked<TOther>(System.Runtime.InteropServices.NFloat value, out TOther result) => throw null;
                static bool System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.TryConvertToSaturating<TOther>(System.Runtime.InteropServices.NFloat value, out TOther result) => throw null;
                static bool System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.TryConvertToTruncating<TOther>(System.Runtime.InteropServices.NFloat value, out TOther result) => throw null;
                public bool TryFormat(System.Span<System.Char> destination, out int charsWritten, System.ReadOnlySpan<System.Char> format = default(System.ReadOnlySpan<System.Char>), System.IFormatProvider provider = default(System.IFormatProvider)) => throw null;
                public static bool TryParse(System.ReadOnlySpan<System.Char> s, System.IFormatProvider provider, out System.Runtime.InteropServices.NFloat result) => throw null;
                public static bool TryParse(System.ReadOnlySpan<System.Char> s, System.Globalization.NumberStyles style, System.IFormatProvider provider, out System.Runtime.InteropServices.NFloat result) => throw null;
                public static bool TryParse(System.ReadOnlySpan<System.Char> s, out System.Runtime.InteropServices.NFloat result) => throw null;
                public static bool TryParse(string s, System.IFormatProvider provider, out System.Runtime.InteropServices.NFloat result) => throw null;
                public static bool TryParse(string s, System.Globalization.NumberStyles style, System.IFormatProvider provider, out System.Runtime.InteropServices.NFloat result) => throw null;
                public static bool TryParse(string s, out System.Runtime.InteropServices.NFloat result) => throw null;
                bool System.Numerics.IFloatingPoint<System.Runtime.InteropServices.NFloat>.TryWriteExponentBigEndian(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                bool System.Numerics.IFloatingPoint<System.Runtime.InteropServices.NFloat>.TryWriteExponentLittleEndian(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                bool System.Numerics.IFloatingPoint<System.Runtime.InteropServices.NFloat>.TryWriteSignificandBigEndian(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                bool System.Numerics.IFloatingPoint<System.Runtime.InteropServices.NFloat>.TryWriteSignificandLittleEndian(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public double Value { get => throw null; }
                static System.Runtime.InteropServices.NFloat System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.Zero { get => throw null; }
                static System.Runtime.InteropServices.NFloat System.Numerics.IBitwiseOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>.operator ^(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IMultiplyOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>.operator checked *(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IAdditionOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>.operator checked +(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IIncrementOperators<System.Runtime.InteropServices.NFloat>.operator checked ++(System.Runtime.InteropServices.NFloat value) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IUnaryNegationOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>.operator checked -(System.Runtime.InteropServices.NFloat value) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.ISubtractionOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>.operator checked -(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IDecrementOperators<System.Runtime.InteropServices.NFloat>.operator checked --(System.Runtime.InteropServices.NFloat value) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IDivisionOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>.operator checked /(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right) => throw null;
                public static explicit operator checked System.Byte(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator checked System.Char(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator checked System.Int128(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator checked System.Int16(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator checked System.Int64(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator checked System.IntPtr(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator checked System.SByte(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator checked System.UInt128(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator checked System.UInt16(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator checked System.UInt32(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator checked System.UInt64(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator checked System.UIntPtr(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator checked int(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator System.Runtime.InteropServices.NFloat(System.Int128 value) => throw null;
                public static explicit operator System.Byte(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator System.Char(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator System.Decimal(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator System.Half(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator System.Int128(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator System.Int16(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator System.Int64(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator System.IntPtr(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator System.SByte(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator System.UInt128(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator System.UInt16(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator System.UInt32(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator System.UInt64(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator System.UIntPtr(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator float(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator int(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator System.Runtime.InteropServices.NFloat(System.UInt128 value) => throw null;
                public static explicit operator System.Runtime.InteropServices.NFloat(System.Decimal value) => throw null;
                public static explicit operator System.Runtime.InteropServices.NFloat(double value) => throw null;
                public static implicit operator System.Runtime.InteropServices.NFloat(System.Half value) => throw null;
                public static implicit operator System.Runtime.InteropServices.NFloat(System.IntPtr value) => throw null;
                public static implicit operator double(System.Runtime.InteropServices.NFloat value) => throw null;
                public static implicit operator System.Runtime.InteropServices.NFloat(System.UIntPtr value) => throw null;
                public static implicit operator System.Runtime.InteropServices.NFloat(System.Byte value) => throw null;
                public static implicit operator System.Runtime.InteropServices.NFloat(System.Char value) => throw null;
                public static implicit operator System.Runtime.InteropServices.NFloat(float value) => throw null;
                public static implicit operator System.Runtime.InteropServices.NFloat(int value) => throw null;
                public static implicit operator System.Runtime.InteropServices.NFloat(System.Int64 value) => throw null;
                public static implicit operator System.Runtime.InteropServices.NFloat(System.SByte value) => throw null;
                public static implicit operator System.Runtime.InteropServices.NFloat(System.Int16 value) => throw null;
                public static implicit operator System.Runtime.InteropServices.NFloat(System.UInt32 value) => throw null;
                public static implicit operator System.Runtime.InteropServices.NFloat(System.UInt64 value) => throw null;
                public static implicit operator System.Runtime.InteropServices.NFloat(System.UInt16 value) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IBitwiseOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>.operator |(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IBitwiseOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>.operator ~(System.Runtime.InteropServices.NFloat value) => throw null;
            }

            public static class NativeLibrary
            {
                public static void Free(System.IntPtr handle) => throw null;
                public static System.IntPtr GetExport(System.IntPtr handle, string name) => throw null;
                public static System.IntPtr GetMainProgramHandle() => throw null;
                public static System.IntPtr Load(string libraryPath) => throw null;
                public static System.IntPtr Load(string libraryName, System.Reflection.Assembly assembly, System.Runtime.InteropServices.DllImportSearchPath? searchPath) => throw null;
                public static void SetDllImportResolver(System.Reflection.Assembly assembly, System.Runtime.InteropServices.DllImportResolver resolver) => throw null;
                public static bool TryGetExport(System.IntPtr handle, string name, out System.IntPtr address) => throw null;
                public static bool TryLoad(string libraryName, System.Reflection.Assembly assembly, System.Runtime.InteropServices.DllImportSearchPath? searchPath, out System.IntPtr handle) => throw null;
                public static bool TryLoad(string libraryPath, out System.IntPtr handle) => throw null;
            }

            public static class NativeMemory
            {
                unsafe public static void* AlignedAlloc(System.UIntPtr byteCount, System.UIntPtr alignment) => throw null;
                unsafe public static void AlignedFree(void* ptr) => throw null;
                unsafe public static void* AlignedRealloc(void* ptr, System.UIntPtr byteCount, System.UIntPtr alignment) => throw null;
                unsafe public static void* Alloc(System.UIntPtr byteCount) => throw null;
                unsafe public static void* Alloc(System.UIntPtr elementCount, System.UIntPtr elementSize) => throw null;
                unsafe public static void* AllocZeroed(System.UIntPtr byteCount) => throw null;
                unsafe public static void* AllocZeroed(System.UIntPtr elementCount, System.UIntPtr elementSize) => throw null;
                unsafe public static void Clear(void* ptr, System.UIntPtr byteCount) => throw null;
                unsafe public static void Copy(void* source, void* destination, System.UIntPtr byteCount) => throw null;
                unsafe public static void Fill(void* ptr, System.UIntPtr byteCount, System.Byte value) => throw null;
                unsafe public static void Free(void* ptr) => throw null;
                unsafe public static void* Realloc(void* ptr, System.UIntPtr byteCount) => throw null;
            }

            public class OptionalAttribute : System.Attribute
            {
                public OptionalAttribute() => throw null;
            }

            public enum PosixSignal : int
            {
                SIGCHLD = -5,
                SIGCONT = -6,
                SIGHUP = -1,
                SIGINT = -2,
                SIGQUIT = -3,
                SIGTERM = -4,
                SIGTSTP = -10,
                SIGTTIN = -8,
                SIGTTOU = -9,
                SIGWINCH = -7,
            }

            public class PosixSignalContext
            {
                public bool Cancel { get => throw null; set => throw null; }
                public PosixSignalContext(System.Runtime.InteropServices.PosixSignal signal) => throw null;
                public System.Runtime.InteropServices.PosixSignal Signal { get => throw null; }
            }

            public class PosixSignalRegistration : System.IDisposable
            {
                public static System.Runtime.InteropServices.PosixSignalRegistration Create(System.Runtime.InteropServices.PosixSignal signal, System.Action<System.Runtime.InteropServices.PosixSignalContext> handler) => throw null;
                public void Dispose() => throw null;
                // ERR: Stub generator didn't handle member: ~PosixSignalRegistration
            }

            public class PreserveSigAttribute : System.Attribute
            {
                public PreserveSigAttribute() => throw null;
            }

            public class PrimaryInteropAssemblyAttribute : System.Attribute
            {
                public int MajorVersion { get => throw null; }
                public int MinorVersion { get => throw null; }
                public PrimaryInteropAssemblyAttribute(int major, int minor) => throw null;
            }

            public class ProgIdAttribute : System.Attribute
            {
                public ProgIdAttribute(string progId) => throw null;
                public string Value { get => throw null; }
            }

            public static class RuntimeEnvironment
            {
                public static bool FromGlobalAccessCache(System.Reflection.Assembly a) => throw null;
                public static string GetRuntimeDirectory() => throw null;
                public static System.IntPtr GetRuntimeInterfaceAsIntPtr(System.Guid clsid, System.Guid riid) => throw null;
                public static object GetRuntimeInterfaceAsObject(System.Guid clsid, System.Guid riid) => throw null;
                public static string GetSystemVersion() => throw null;
                public static string SystemConfigurationFile { get => throw null; }
            }

            public class SEHException : System.Runtime.InteropServices.ExternalException
            {
                public virtual bool CanResume() => throw null;
                public SEHException() => throw null;
                protected SEHException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public SEHException(string message) => throw null;
                public SEHException(string message, System.Exception inner) => throw null;
            }

            public class SafeArrayRankMismatchException : System.SystemException
            {
                public SafeArrayRankMismatchException() => throw null;
                protected SafeArrayRankMismatchException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public SafeArrayRankMismatchException(string message) => throw null;
                public SafeArrayRankMismatchException(string message, System.Exception inner) => throw null;
            }

            public class SafeArrayTypeMismatchException : System.SystemException
            {
                public SafeArrayTypeMismatchException() => throw null;
                protected SafeArrayTypeMismatchException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public SafeArrayTypeMismatchException(string message) => throw null;
                public SafeArrayTypeMismatchException(string message, System.Exception inner) => throw null;
            }

            public class StandardOleMarshalObject : System.MarshalByRefObject
            {
                protected StandardOleMarshalObject() => throw null;
            }

            public enum StringMarshalling : int
            {
                Custom = 0,
                Utf16 = 2,
                Utf8 = 1,
            }

            public class TypeIdentifierAttribute : System.Attribute
            {
                public string Identifier { get => throw null; }
                public string Scope { get => throw null; }
                public TypeIdentifierAttribute() => throw null;
                public TypeIdentifierAttribute(string scope, string identifier) => throw null;
            }

            public class TypeLibFuncAttribute : System.Attribute
            {
                public TypeLibFuncAttribute(System.Runtime.InteropServices.TypeLibFuncFlags flags) => throw null;
                public TypeLibFuncAttribute(System.Int16 flags) => throw null;
                public System.Runtime.InteropServices.TypeLibFuncFlags Value { get => throw null; }
            }

            [System.Flags]
            public enum TypeLibFuncFlags : int
            {
                FBindable = 4,
                FDefaultBind = 32,
                FDefaultCollelem = 256,
                FDisplayBind = 16,
                FHidden = 64,
                FImmediateBind = 4096,
                FNonBrowsable = 1024,
                FReplaceable = 2048,
                FRequestEdit = 8,
                FRestricted = 1,
                FSource = 2,
                FUiDefault = 512,
                FUsesGetLastError = 128,
            }

            public class TypeLibImportClassAttribute : System.Attribute
            {
                public TypeLibImportClassAttribute(System.Type importClass) => throw null;
                public string Value { get => throw null; }
            }

            public class TypeLibTypeAttribute : System.Attribute
            {
                public TypeLibTypeAttribute(System.Runtime.InteropServices.TypeLibTypeFlags flags) => throw null;
                public TypeLibTypeAttribute(System.Int16 flags) => throw null;
                public System.Runtime.InteropServices.TypeLibTypeFlags Value { get => throw null; }
            }

            [System.Flags]
            public enum TypeLibTypeFlags : int
            {
                FAggregatable = 1024,
                FAppObject = 1,
                FCanCreate = 2,
                FControl = 32,
                FDispatchable = 4096,
                FDual = 64,
                FHidden = 16,
                FLicensed = 4,
                FNonExtensible = 128,
                FOleAutomation = 256,
                FPreDeclId = 8,
                FReplaceable = 2048,
                FRestricted = 512,
                FReverseBind = 8192,
            }

            public class TypeLibVarAttribute : System.Attribute
            {
                public TypeLibVarAttribute(System.Runtime.InteropServices.TypeLibVarFlags flags) => throw null;
                public TypeLibVarAttribute(System.Int16 flags) => throw null;
                public System.Runtime.InteropServices.TypeLibVarFlags Value { get => throw null; }
            }

            [System.Flags]
            public enum TypeLibVarFlags : int
            {
                FBindable = 4,
                FDefaultBind = 32,
                FDefaultCollelem = 256,
                FDisplayBind = 16,
                FHidden = 64,
                FImmediateBind = 4096,
                FNonBrowsable = 1024,
                FReadOnly = 1,
                FReplaceable = 2048,
                FRequestEdit = 8,
                FRestricted = 128,
                FSource = 2,
                FUiDefault = 512,
            }

            public class TypeLibVersionAttribute : System.Attribute
            {
                public int MajorVersion { get => throw null; }
                public int MinorVersion { get => throw null; }
                public TypeLibVersionAttribute(int major, int minor) => throw null;
            }

            public class UnknownWrapper
            {
                public UnknownWrapper(object obj) => throw null;
                public object WrappedObject { get => throw null; }
            }

            public class UnmanagedCallConvAttribute : System.Attribute
            {
                public System.Type[] CallConvs;
                public UnmanagedCallConvAttribute() => throw null;
            }

            public class UnmanagedCallersOnlyAttribute : System.Attribute
            {
                public System.Type[] CallConvs;
                public string EntryPoint;
                public UnmanagedCallersOnlyAttribute() => throw null;
            }

            public class UnmanagedFunctionPointerAttribute : System.Attribute
            {
                public bool BestFitMapping;
                public System.Runtime.InteropServices.CallingConvention CallingConvention { get => throw null; }
                public System.Runtime.InteropServices.CharSet CharSet;
                public bool SetLastError;
                public bool ThrowOnUnmappableChar;
                public UnmanagedFunctionPointerAttribute(System.Runtime.InteropServices.CallingConvention callingConvention) => throw null;
            }

            public enum VarEnum : int
            {
                VT_ARRAY = 8192,
                VT_BLOB = 65,
                VT_BLOB_OBJECT = 70,
                VT_BOOL = 11,
                VT_BSTR = 8,
                VT_BYREF = 16384,
                VT_CARRAY = 28,
                VT_CF = 71,
                VT_CLSID = 72,
                VT_CY = 6,
                VT_DATE = 7,
                VT_DECIMAL = 14,
                VT_DISPATCH = 9,
                VT_EMPTY = 0,
                VT_ERROR = 10,
                VT_FILETIME = 64,
                VT_HRESULT = 25,
                VT_I1 = 16,
                VT_I2 = 2,
                VT_I4 = 3,
                VT_I8 = 20,
                VT_INT = 22,
                VT_LPSTR = 30,
                VT_LPWSTR = 31,
                VT_NULL = 1,
                VT_PTR = 26,
                VT_R4 = 4,
                VT_R8 = 5,
                VT_RECORD = 36,
                VT_SAFEARRAY = 27,
                VT_STORAGE = 67,
                VT_STORED_OBJECT = 69,
                VT_STREAM = 66,
                VT_STREAMED_OBJECT = 68,
                VT_UI1 = 17,
                VT_UI2 = 18,
                VT_UI4 = 19,
                VT_UI8 = 21,
                VT_UINT = 23,
                VT_UNKNOWN = 13,
                VT_USERDEFINED = 29,
                VT_VARIANT = 12,
                VT_VECTOR = 4096,
                VT_VOID = 24,
            }

            public class VariantWrapper
            {
                public VariantWrapper(object obj) => throw null;
                public object WrappedObject { get => throw null; }
            }

            namespace ComTypes
            {
                [System.Flags]
                public enum ADVF : int
                {
                    ADVFCACHE_FORCEBUILTIN = 16,
                    ADVFCACHE_NOHANDLER = 8,
                    ADVFCACHE_ONSAVE = 32,
                    ADVF_DATAONSTOP = 64,
                    ADVF_NODATA = 1,
                    ADVF_ONLYONCE = 4,
                    ADVF_PRIMEFIRST = 2,
                }

                public struct BINDPTR
                {
                    // Stub generator skipped constructor 
                    public System.IntPtr lpfuncdesc;
                    public System.IntPtr lptcomp;
                    public System.IntPtr lpvardesc;
                }

                public struct BIND_OPTS
                {
                    // Stub generator skipped constructor 
                    public int cbStruct;
                    public int dwTickCountDeadline;
                    public int grfFlags;
                    public int grfMode;
                }

                public enum CALLCONV : int
                {
                    CC_CDECL = 1,
                    CC_MACPASCAL = 3,
                    CC_MAX = 9,
                    CC_MPWCDECL = 7,
                    CC_MPWPASCAL = 8,
                    CC_MSCPASCAL = 2,
                    CC_PASCAL = 2,
                    CC_RESERVED = 5,
                    CC_STDCALL = 4,
                    CC_SYSCALL = 6,
                }

                public struct CONNECTDATA
                {
                    // Stub generator skipped constructor 
                    public int dwCookie;
                    public object pUnk;
                }

                public enum DATADIR : int
                {
                    DATADIR_GET = 1,
                    DATADIR_SET = 2,
                }

                public enum DESCKIND : int
                {
                    DESCKIND_FUNCDESC = 1,
                    DESCKIND_IMPLICITAPPOBJ = 4,
                    DESCKIND_MAX = 5,
                    DESCKIND_NONE = 0,
                    DESCKIND_TYPECOMP = 3,
                    DESCKIND_VARDESC = 2,
                }

                public struct DISPPARAMS
                {
                    // Stub generator skipped constructor 
                    public int cArgs;
                    public int cNamedArgs;
                    public System.IntPtr rgdispidNamedArgs;
                    public System.IntPtr rgvarg;
                }

                [System.Flags]
                public enum DVASPECT : int
                {
                    DVASPECT_CONTENT = 1,
                    DVASPECT_DOCPRINT = 8,
                    DVASPECT_ICON = 4,
                    DVASPECT_THUMBNAIL = 2,
                }

                public struct ELEMDESC
                {
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

                public struct FILETIME
                {
                    // Stub generator skipped constructor 
                    public int dwHighDateTime;
                    public int dwLowDateTime;
                }

                public struct FORMATETC
                {
                    // Stub generator skipped constructor 
                    public System.Int16 cfFormat;
                    public System.Runtime.InteropServices.ComTypes.DVASPECT dwAspect;
                    public int lindex;
                    public System.IntPtr ptd;
                    public System.Runtime.InteropServices.ComTypes.TYMED tymed;
                }

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

                [System.Flags]
                public enum FUNCFLAGS : short
                {
                    FUNCFLAG_FBINDABLE = 4,
                    FUNCFLAG_FDEFAULTBIND = 32,
                    FUNCFLAG_FDEFAULTCOLLELEM = 256,
                    FUNCFLAG_FDISPLAYBIND = 16,
                    FUNCFLAG_FHIDDEN = 64,
                    FUNCFLAG_FIMMEDIATEBIND = 4096,
                    FUNCFLAG_FNONBROWSABLE = 1024,
                    FUNCFLAG_FREPLACEABLE = 2048,
                    FUNCFLAG_FREQUESTEDIT = 8,
                    FUNCFLAG_FRESTRICTED = 1,
                    FUNCFLAG_FSOURCE = 2,
                    FUNCFLAG_FUIDEFAULT = 512,
                    FUNCFLAG_FUSESGETLASTERROR = 128,
                }

                public enum FUNCKIND : int
                {
                    FUNC_DISPATCH = 4,
                    FUNC_NONVIRTUAL = 2,
                    FUNC_PUREVIRTUAL = 1,
                    FUNC_STATIC = 3,
                    FUNC_VIRTUAL = 0,
                }

                public interface IAdviseSink
                {
                    void OnClose();
                    void OnDataChange(ref System.Runtime.InteropServices.ComTypes.FORMATETC format, ref System.Runtime.InteropServices.ComTypes.STGMEDIUM stgmedium);
                    void OnRename(System.Runtime.InteropServices.ComTypes.IMoniker moniker);
                    void OnSave();
                    void OnViewChange(int aspect, int index);
                }

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

                public interface IConnectionPoint
                {
                    void Advise(object pUnkSink, out int pdwCookie);
                    void EnumConnections(out System.Runtime.InteropServices.ComTypes.IEnumConnections ppEnum);
                    void GetConnectionInterface(out System.Guid pIID);
                    void GetConnectionPointContainer(out System.Runtime.InteropServices.ComTypes.IConnectionPointContainer ppCPC);
                    void Unadvise(int dwCookie);
                }

                public interface IConnectionPointContainer
                {
                    void EnumConnectionPoints(out System.Runtime.InteropServices.ComTypes.IEnumConnectionPoints ppEnum);
                    void FindConnectionPoint(ref System.Guid riid, out System.Runtime.InteropServices.ComTypes.IConnectionPoint ppCP);
                }

                public struct IDLDESC
                {
                    // Stub generator skipped constructor 
                    public System.IntPtr dwReserved;
                    public System.Runtime.InteropServices.ComTypes.IDLFLAG wIDLFlags;
                }

                [System.Flags]
                public enum IDLFLAG : short
                {
                    IDLFLAG_FIN = 1,
                    IDLFLAG_FLCID = 4,
                    IDLFLAG_FOUT = 2,
                    IDLFLAG_FRETVAL = 8,
                    IDLFLAG_NONE = 0,
                }

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

                public interface IEnumConnectionPoints
                {
                    void Clone(out System.Runtime.InteropServices.ComTypes.IEnumConnectionPoints ppenum);
                    int Next(int celt, System.Runtime.InteropServices.ComTypes.IConnectionPoint[] rgelt, System.IntPtr pceltFetched);
                    void Reset();
                    int Skip(int celt);
                }

                public interface IEnumConnections
                {
                    void Clone(out System.Runtime.InteropServices.ComTypes.IEnumConnections ppenum);
                    int Next(int celt, System.Runtime.InteropServices.ComTypes.CONNECTDATA[] rgelt, System.IntPtr pceltFetched);
                    void Reset();
                    int Skip(int celt);
                }

                public interface IEnumFORMATETC
                {
                    void Clone(out System.Runtime.InteropServices.ComTypes.IEnumFORMATETC newEnum);
                    int Next(int celt, System.Runtime.InteropServices.ComTypes.FORMATETC[] rgelt, int[] pceltFetched);
                    int Reset();
                    int Skip(int celt);
                }

                public interface IEnumMoniker
                {
                    void Clone(out System.Runtime.InteropServices.ComTypes.IEnumMoniker ppenum);
                    int Next(int celt, System.Runtime.InteropServices.ComTypes.IMoniker[] rgelt, System.IntPtr pceltFetched);
                    void Reset();
                    int Skip(int celt);
                }

                public interface IEnumSTATDATA
                {
                    void Clone(out System.Runtime.InteropServices.ComTypes.IEnumSTATDATA newEnum);
                    int Next(int celt, System.Runtime.InteropServices.ComTypes.STATDATA[] rgelt, int[] pceltFetched);
                    int Reset();
                    int Skip(int celt);
                }

                public interface IEnumString
                {
                    void Clone(out System.Runtime.InteropServices.ComTypes.IEnumString ppenum);
                    int Next(int celt, string[] rgelt, System.IntPtr pceltFetched);
                    void Reset();
                    int Skip(int celt);
                }

                public interface IEnumVARIANT
                {
                    System.Runtime.InteropServices.ComTypes.IEnumVARIANT Clone();
                    int Next(int celt, object[] rgVar, System.IntPtr pceltFetched);
                    int Reset();
                    int Skip(int celt);
                }

                [System.Flags]
                public enum IMPLTYPEFLAGS : int
                {
                    IMPLTYPEFLAG_FDEFAULT = 1,
                    IMPLTYPEFLAG_FDEFAULTVTABLE = 8,
                    IMPLTYPEFLAG_FRESTRICTED = 4,
                    IMPLTYPEFLAG_FSOURCE = 2,
                }

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

                [System.Flags]
                public enum INVOKEKIND : int
                {
                    INVOKE_FUNC = 1,
                    INVOKE_PROPERTYGET = 2,
                    INVOKE_PROPERTYPUT = 4,
                    INVOKE_PROPERTYPUTREF = 8,
                }

                public interface IPersistFile
                {
                    void GetClassID(out System.Guid pClassID);
                    void GetCurFile(out string ppszFileName);
                    int IsDirty();
                    void Load(string pszFileName, int dwMode);
                    void Save(string pszFileName, bool fRemember);
                    void SaveCompleted(string pszFileName);
                }

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

                public interface ITypeComp
                {
                    void Bind(string szName, int lHashVal, System.Int16 wFlags, out System.Runtime.InteropServices.ComTypes.ITypeInfo ppTInfo, out System.Runtime.InteropServices.ComTypes.DESCKIND pDescKind, out System.Runtime.InteropServices.ComTypes.BINDPTR pBindPtr);
                    void BindType(string szName, int lHashVal, out System.Runtime.InteropServices.ComTypes.ITypeInfo ppTInfo, out System.Runtime.InteropServices.ComTypes.ITypeComp ppTComp);
                }

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

                [System.Flags]
                public enum LIBFLAGS : short
                {
                    LIBFLAG_FCONTROL = 2,
                    LIBFLAG_FHASDISKIMAGE = 8,
                    LIBFLAG_FHIDDEN = 4,
                    LIBFLAG_FRESTRICTED = 1,
                }

                public struct PARAMDESC
                {
                    // Stub generator skipped constructor 
                    public System.IntPtr lpVarValue;
                    public System.Runtime.InteropServices.ComTypes.PARAMFLAG wParamFlags;
                }

                [System.Flags]
                public enum PARAMFLAG : short
                {
                    PARAMFLAG_FHASCUSTDATA = 64,
                    PARAMFLAG_FHASDEFAULT = 32,
                    PARAMFLAG_FIN = 1,
                    PARAMFLAG_FLCID = 4,
                    PARAMFLAG_FOPT = 16,
                    PARAMFLAG_FOUT = 2,
                    PARAMFLAG_FRETVAL = 8,
                    PARAMFLAG_NONE = 0,
                }

                public struct STATDATA
                {
                    // Stub generator skipped constructor 
                    public System.Runtime.InteropServices.ComTypes.IAdviseSink advSink;
                    public System.Runtime.InteropServices.ComTypes.ADVF advf;
                    public int connection;
                    public System.Runtime.InteropServices.ComTypes.FORMATETC formatetc;
                }

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

                public struct STGMEDIUM
                {
                    // Stub generator skipped constructor 
                    public object pUnkForRelease;
                    public System.Runtime.InteropServices.ComTypes.TYMED tymed;
                    public System.IntPtr unionmember;
                }

                public enum SYSKIND : int
                {
                    SYS_MAC = 2,
                    SYS_WIN16 = 0,
                    SYS_WIN32 = 1,
                    SYS_WIN64 = 3,
                }

                [System.Flags]
                public enum TYMED : int
                {
                    TYMED_ENHMF = 64,
                    TYMED_FILE = 2,
                    TYMED_GDI = 16,
                    TYMED_HGLOBAL = 1,
                    TYMED_ISTORAGE = 8,
                    TYMED_ISTREAM = 4,
                    TYMED_MFPICT = 32,
                    TYMED_NULL = 0,
                }

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

                public struct TYPEDESC
                {
                    // Stub generator skipped constructor 
                    public System.IntPtr lpValue;
                    public System.Int16 vt;
                }

                [System.Flags]
                public enum TYPEFLAGS : short
                {
                    TYPEFLAG_FAGGREGATABLE = 1024,
                    TYPEFLAG_FAPPOBJECT = 1,
                    TYPEFLAG_FCANCREATE = 2,
                    TYPEFLAG_FCONTROL = 32,
                    TYPEFLAG_FDISPATCHABLE = 4096,
                    TYPEFLAG_FDUAL = 64,
                    TYPEFLAG_FHIDDEN = 16,
                    TYPEFLAG_FLICENSED = 4,
                    TYPEFLAG_FNONEXTENSIBLE = 128,
                    TYPEFLAG_FOLEAUTOMATION = 256,
                    TYPEFLAG_FPREDECLID = 8,
                    TYPEFLAG_FPROXY = 16384,
                    TYPEFLAG_FREPLACEABLE = 2048,
                    TYPEFLAG_FRESTRICTED = 512,
                    TYPEFLAG_FREVERSEBIND = 8192,
                }

                public enum TYPEKIND : int
                {
                    TKIND_ALIAS = 6,
                    TKIND_COCLASS = 5,
                    TKIND_DISPATCH = 4,
                    TKIND_ENUM = 0,
                    TKIND_INTERFACE = 3,
                    TKIND_MAX = 8,
                    TKIND_MODULE = 2,
                    TKIND_RECORD = 1,
                    TKIND_UNION = 7,
                }

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

                public struct VARDESC
                {
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

                [System.Flags]
                public enum VARFLAGS : short
                {
                    VARFLAG_FBINDABLE = 4,
                    VARFLAG_FDEFAULTBIND = 32,
                    VARFLAG_FDEFAULTCOLLELEM = 256,
                    VARFLAG_FDISPLAYBIND = 16,
                    VARFLAG_FHIDDEN = 64,
                    VARFLAG_FIMMEDIATEBIND = 4096,
                    VARFLAG_FNONBROWSABLE = 1024,
                    VARFLAG_FREADONLY = 1,
                    VARFLAG_FREPLACEABLE = 2048,
                    VARFLAG_FREQUESTEDIT = 8,
                    VARFLAG_FRESTRICTED = 128,
                    VARFLAG_FSOURCE = 2,
                    VARFLAG_FUIDEFAULT = 512,
                }

                public enum VARKIND : int
                {
                    VAR_CONST = 2,
                    VAR_DISPATCH = 3,
                    VAR_PERINSTANCE = 0,
                    VAR_STATIC = 1,
                }

            }
            namespace Marshalling
            {
                public static class AnsiStringMarshaller
                {
                    public struct ManagedToUnmanagedIn
                    {
                        public static int BufferSize { get => throw null; }
                        public void Free() => throw null;
                        public void FromManaged(string managed, System.Span<System.Byte> buffer) => throw null;
                        // Stub generator skipped constructor 
                        unsafe public System.Byte* ToUnmanaged() => throw null;
                    }


                    unsafe public static string ConvertToManaged(System.Byte* unmanaged) => throw null;
                    unsafe public static System.Byte* ConvertToUnmanaged(string managed) => throw null;
                    unsafe public static void Free(System.Byte* unmanaged) => throw null;
                }

                public static class ArrayMarshaller<T, TUnmanagedElement> where TUnmanagedElement : unmanaged
                {
                    public struct ManagedToUnmanagedIn
                    {
                        public static int BufferSize { get => throw null; }
                        public void Free() => throw null;
                        public void FromManaged(T[] array, System.Span<TUnmanagedElement> buffer) => throw null;
                        public System.ReadOnlySpan<T> GetManagedValuesSource() => throw null;
                        public TUnmanagedElement GetPinnableReference() => throw null;
                        public static T GetPinnableReference(T[] array) => throw null;
                        public System.Span<TUnmanagedElement> GetUnmanagedValuesDestination() => throw null;
                        // Stub generator skipped constructor 
                        unsafe public TUnmanagedElement* ToUnmanaged() => throw null;
                    }


                    unsafe public static T[] AllocateContainerForManagedElements(TUnmanagedElement* unmanaged, int numElements) => throw null;
                    unsafe public static TUnmanagedElement* AllocateContainerForUnmanagedElements(T[] managed, out int numElements) => throw null;
                    unsafe public static void Free(TUnmanagedElement* unmanaged) => throw null;
                    public static System.Span<T> GetManagedValuesDestination(T[] managed) => throw null;
                    public static System.ReadOnlySpan<T> GetManagedValuesSource(T[] managed) => throw null;
                    unsafe public static System.Span<TUnmanagedElement> GetUnmanagedValuesDestination(TUnmanagedElement* unmanaged, int numElements) => throw null;
                    unsafe public static System.ReadOnlySpan<TUnmanagedElement> GetUnmanagedValuesSource(TUnmanagedElement* unmanagedValue, int numElements) => throw null;
                }

                public static class BStrStringMarshaller
                {
                    public struct ManagedToUnmanagedIn
                    {
                        public static int BufferSize { get => throw null; }
                        public void Free() => throw null;
                        public void FromManaged(string managed, System.Span<System.Byte> buffer) => throw null;
                        // Stub generator skipped constructor 
                        unsafe public System.UInt16* ToUnmanaged() => throw null;
                    }


                    unsafe public static string ConvertToManaged(System.UInt16* unmanaged) => throw null;
                    unsafe public static System.UInt16* ConvertToUnmanaged(string managed) => throw null;
                    unsafe public static void Free(System.UInt16* unmanaged) => throw null;
                }

                public class MarshalUsingAttribute : System.Attribute
                {
                    public int ConstantElementCount { get => throw null; set => throw null; }
                    public string CountElementName { get => throw null; set => throw null; }
                    public int ElementIndirectionDepth { get => throw null; set => throw null; }
                    public MarshalUsingAttribute() => throw null;
                    public MarshalUsingAttribute(System.Type nativeType) => throw null;
                    public System.Type NativeType { get => throw null; }
                    public const string ReturnsCountValue = default;
                }

                public static class PointerArrayMarshaller<T, TUnmanagedElement> where T : unmanaged where TUnmanagedElement : unmanaged
                {
                    public struct ManagedToUnmanagedIn
                    {
                        public static int BufferSize { get => throw null; }
                        public void Free() => throw null;
                        unsafe public void FromManaged(T*[] array, System.Span<TUnmanagedElement> buffer) => throw null;
                        public System.ReadOnlySpan<System.IntPtr> GetManagedValuesSource() => throw null;
                        public TUnmanagedElement GetPinnableReference() => throw null;
                        unsafe public static System.Byte GetPinnableReference(T*[] array) => throw null;
                        public System.Span<TUnmanagedElement> GetUnmanagedValuesDestination() => throw null;
                        // Stub generator skipped constructor 
                        unsafe public TUnmanagedElement* ToUnmanaged() => throw null;
                    }


                    unsafe public static T*[] AllocateContainerForManagedElements(TUnmanagedElement* unmanaged, int numElements) => throw null;
                    unsafe public static TUnmanagedElement* AllocateContainerForUnmanagedElements(T*[] managed, out int numElements) => throw null;
                    unsafe public static void Free(TUnmanagedElement* unmanaged) => throw null;
                    unsafe public static System.Span<System.IntPtr> GetManagedValuesDestination(T*[] managed) => throw null;
                    unsafe public static System.ReadOnlySpan<System.IntPtr> GetManagedValuesSource(T*[] managed) => throw null;
                    unsafe public static System.Span<TUnmanagedElement> GetUnmanagedValuesDestination(TUnmanagedElement* unmanaged, int numElements) => throw null;
                    unsafe public static System.ReadOnlySpan<TUnmanagedElement> GetUnmanagedValuesSource(TUnmanagedElement* unmanagedValue, int numElements) => throw null;
                }

                public static class Utf16StringMarshaller
                {
                    unsafe public static string ConvertToManaged(System.UInt16* unmanaged) => throw null;
                    unsafe public static System.UInt16* ConvertToUnmanaged(string managed) => throw null;
                    unsafe public static void Free(System.UInt16* unmanaged) => throw null;
                    public static System.Char GetPinnableReference(string str) => throw null;
                }

                public static class Utf8StringMarshaller
                {
                    public struct ManagedToUnmanagedIn
                    {
                        public static int BufferSize { get => throw null; }
                        public void Free() => throw null;
                        public void FromManaged(string managed, System.Span<System.Byte> buffer) => throw null;
                        // Stub generator skipped constructor 
                        unsafe public System.Byte* ToUnmanaged() => throw null;
                    }


                    unsafe public static string ConvertToManaged(System.Byte* unmanaged) => throw null;
                    unsafe public static System.Byte* ConvertToUnmanaged(string managed) => throw null;
                    unsafe public static void Free(System.Byte* unmanaged) => throw null;
                }

            }
            namespace ObjectiveC
            {
                public static class ObjectiveCMarshal
                {
                    public enum MessageSendFunction : int
                    {
                        MsgSend = 0,
                        MsgSendFpret = 1,
                        MsgSendStret = 2,
                        MsgSendSuper = 3,
                        MsgSendSuperStret = 4,
                    }


                    unsafe public delegate delegate* unmanaged<System.IntPtr, void> UnhandledExceptionPropagationHandler(System.Exception exception, System.RuntimeMethodHandle lastMethod, out System.IntPtr context);


                    public static System.Runtime.InteropServices.GCHandle CreateReferenceTrackingHandle(object obj, out System.Span<System.IntPtr> taggedMemory) => throw null;
                    unsafe public static void Initialize(delegate* unmanaged<void> beginEndCallback, delegate* unmanaged<System.IntPtr, int> isReferencedCallback, delegate* unmanaged<System.IntPtr, void> trackedObjectEnteredFinalization, System.Runtime.InteropServices.ObjectiveC.ObjectiveCMarshal.UnhandledExceptionPropagationHandler unhandledExceptionPropagationHandler) => throw null;
                    public static void SetMessageSendCallback(System.Runtime.InteropServices.ObjectiveC.ObjectiveCMarshal.MessageSendFunction msgSendFunction, System.IntPtr func) => throw null;
                    public static void SetMessageSendPendingException(System.Exception exception) => throw null;
                }

                public class ObjectiveCTrackedTypeAttribute : System.Attribute
                {
                    public ObjectiveCTrackedTypeAttribute() => throw null;
                }

            }
        }
    }
    namespace Security
    {
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

        public static class SecureStringMarshal
        {
            public static System.IntPtr SecureStringToCoTaskMemAnsi(System.Security.SecureString s) => throw null;
            public static System.IntPtr SecureStringToCoTaskMemUnicode(System.Security.SecureString s) => throw null;
            public static System.IntPtr SecureStringToGlobalAllocAnsi(System.Security.SecureString s) => throw null;
            public static System.IntPtr SecureStringToGlobalAllocUnicode(System.Security.SecureString s) => throw null;
        }

    }
}
