// This file contains auto-generated code.
// Generated from `System.Runtime.InteropServices, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    public sealed class DataMisalignedException : System.SystemException
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
            public long Capacity { get => throw null; }
            protected UnmanagedMemoryAccessor() => throw null;
            public UnmanagedMemoryAccessor(System.Runtime.InteropServices.SafeBuffer buffer, long offset, long capacity) => throw null;
            public UnmanagedMemoryAccessor(System.Runtime.InteropServices.SafeBuffer buffer, long offset, long capacity, System.IO.FileAccess access) => throw null;
            public void Dispose() => throw null;
            protected virtual void Dispose(bool disposing) => throw null;
            protected void Initialize(System.Runtime.InteropServices.SafeBuffer buffer, long offset, long capacity, System.IO.FileAccess access) => throw null;
            protected bool IsOpen { get => throw null; }
            public void Read<T>(long position, out T structure) where T : struct => throw null;
            public int ReadArray<T>(long position, T[] array, int offset, int count) where T : struct => throw null;
            public bool ReadBoolean(long position) => throw null;
            public byte ReadByte(long position) => throw null;
            public char ReadChar(long position) => throw null;
            public decimal ReadDecimal(long position) => throw null;
            public double ReadDouble(long position) => throw null;
            public short ReadInt16(long position) => throw null;
            public int ReadInt32(long position) => throw null;
            public long ReadInt64(long position) => throw null;
            public sbyte ReadSByte(long position) => throw null;
            public float ReadSingle(long position) => throw null;
            public ushort ReadUInt16(long position) => throw null;
            public uint ReadUInt32(long position) => throw null;
            public ulong ReadUInt64(long position) => throw null;
            public void Write(long position, bool value) => throw null;
            public void Write(long position, byte value) => throw null;
            public void Write(long position, char value) => throw null;
            public void Write(long position, decimal value) => throw null;
            public void Write(long position, double value) => throw null;
            public void Write(long position, short value) => throw null;
            public void Write(long position, int value) => throw null;
            public void Write(long position, long value) => throw null;
            public void Write(long position, sbyte value) => throw null;
            public void Write(long position, float value) => throw null;
            public void Write(long position, ushort value) => throw null;
            public void Write(long position, uint value) => throw null;
            public void Write(long position, ulong value) => throw null;
            public void Write<T>(long position, ref T structure) where T : struct => throw null;
            public void WriteArray<T>(long position, T[] array, int offset, int count) where T : struct => throw null;
        }
    }
    namespace Runtime
    {
        namespace CompilerServices
        {
            [System.AttributeUsage((System.AttributeTargets)2304, Inherited = false)]
            public sealed class IDispatchConstantAttribute : System.Runtime.CompilerServices.CustomConstantAttribute
            {
                public IDispatchConstantAttribute() => throw null;
                public override object Value { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)2304, Inherited = false)]
            public sealed class IUnknownConstantAttribute : System.Runtime.CompilerServices.CustomConstantAttribute
            {
                public IUnknownConstantAttribute() => throw null;
                public override object Value { get => throw null; }
            }
        }
        namespace InteropServices
        {
            [System.AttributeUsage((System.AttributeTargets)64, AllowMultiple = false, Inherited = false)]
            public sealed class AllowReversePInvokeCallsAttribute : System.Attribute
            {
                public AllowReversePInvokeCallsAttribute() => throw null;
            }
            public struct ArrayWithOffset : System.IEquatable<System.Runtime.InteropServices.ArrayWithOffset>
            {
                public ArrayWithOffset(object array, int offset) => throw null;
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Runtime.InteropServices.ArrayWithOffset obj) => throw null;
                public object GetArray() => throw null;
                public override int GetHashCode() => throw null;
                public int GetOffset() => throw null;
                public static bool operator ==(System.Runtime.InteropServices.ArrayWithOffset a, System.Runtime.InteropServices.ArrayWithOffset b) => throw null;
                public static bool operator !=(System.Runtime.InteropServices.ArrayWithOffset a, System.Runtime.InteropServices.ArrayWithOffset b) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)1029, Inherited = false)]
            public sealed class AutomationProxyAttribute : System.Attribute
            {
                public AutomationProxyAttribute(bool val) => throw null;
                public bool Value { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)1037, Inherited = false)]
            public sealed class BestFitMappingAttribute : System.Attribute
            {
                public bool BestFitMapping { get => throw null; }
                public BestFitMappingAttribute(bool BestFitMapping) => throw null;
                public bool ThrowOnUnmappableChar;
            }
            public sealed class BStrWrapper
            {
                public BStrWrapper(object value) => throw null;
                public BStrWrapper(string value) => throw null;
                public string WrappedObject { get => throw null; }
            }
            public enum CallingConvention
            {
                Winapi = 1,
                Cdecl = 2,
                StdCall = 3,
                ThisCall = 4,
                FastCall = 5,
            }
            [System.AttributeUsage((System.AttributeTargets)5, Inherited = false)]
            public sealed class ClassInterfaceAttribute : System.Attribute
            {
                public ClassInterfaceAttribute(short classInterfaceType) => throw null;
                public ClassInterfaceAttribute(System.Runtime.InteropServices.ClassInterfaceType classInterfaceType) => throw null;
                public System.Runtime.InteropServices.ClassInterfaceType Value { get => throw null; }
            }
            public enum ClassInterfaceType
            {
                None = 0,
                AutoDispatch = 1,
                AutoDual = 2,
            }
            public struct CLong : System.IEquatable<System.Runtime.InteropServices.CLong>
            {
                public CLong(int value) => throw null;
                public CLong(nint value) => throw null;
                public override bool Equals(object o) => throw null;
                public bool Equals(System.Runtime.InteropServices.CLong other) => throw null;
                public override int GetHashCode() => throw null;
                public override string ToString() => throw null;
                public nint Value { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)1024, Inherited = false)]
            public sealed class CoClassAttribute : System.Attribute
            {
                public System.Type CoClass { get => throw null; }
                public CoClassAttribute(System.Type coClass) => throw null;
            }
            public static class CollectionsMarshal
            {
                public static System.Span<T> AsSpan<T>(System.Collections.Generic.List<T> list) => throw null;
                public static TValue GetValueRefOrAddDefault<TKey, TValue>(System.Collections.Generic.Dictionary<TKey, TValue> dictionary, TKey key, out bool exists) => throw null;
                public static TValue GetValueRefOrNullRef<TKey, TValue>(System.Collections.Generic.Dictionary<TKey, TValue> dictionary, TKey key) => throw null;
                public static void SetCount<T>(System.Collections.Generic.List<T> list, int count) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)10624, Inherited = false)]
            public sealed class ComAliasNameAttribute : System.Attribute
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
                public override object[] GetCustomAttributes(bool inherit) => throw null;
                public override object[] GetCustomAttributes(System.Type attributeType, bool inherit) => throw null;
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
            [System.AttributeUsage((System.AttributeTargets)1, Inherited = false)]
            public sealed class ComCompatibleVersionAttribute : System.Attribute
            {
                public int BuildNumber { get => throw null; }
                public ComCompatibleVersionAttribute(int major, int minor, int build, int revision) => throw null;
                public int MajorVersion { get => throw null; }
                public int MinorVersion { get => throw null; }
                public int RevisionNumber { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)32767, Inherited = false)]
            public sealed class ComConversionLossAttribute : System.Attribute
            {
                public ComConversionLossAttribute() => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)4, Inherited = false)]
            public sealed class ComDefaultInterfaceAttribute : System.Attribute
            {
                public ComDefaultInterfaceAttribute(System.Type defaultInterface) => throw null;
                public System.Type Value { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)1024, Inherited = false)]
            public sealed class ComEventInterfaceAttribute : System.Attribute
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
            public class COMException : System.Runtime.InteropServices.ExternalException
            {
                public COMException() => throw null;
                protected COMException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public COMException(string message) => throw null;
                public COMException(string message, System.Exception inner) => throw null;
                public COMException(string message, int errorCode) => throw null;
                public override string ToString() => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)1028, Inherited = false)]
            public sealed class ComImportAttribute : System.Attribute
            {
                public ComImportAttribute() => throw null;
            }
            public enum ComInterfaceType
            {
                InterfaceIsDual = 0,
                InterfaceIsIUnknown = 1,
                InterfaceIsIDispatch = 2,
                InterfaceIsIInspectable = 3,
            }
            public enum ComMemberType
            {
                Method = 0,
                PropGet = 1,
                PropSet = 2,
            }
            [System.AttributeUsage((System.AttributeTargets)64, Inherited = false)]
            public sealed class ComRegisterFunctionAttribute : System.Attribute
            {
                public ComRegisterFunctionAttribute() => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)4, Inherited = true)]
            public sealed class ComSourceInterfacesAttribute : System.Attribute
            {
                public ComSourceInterfacesAttribute(string sourceInterfaces) => throw null;
                public ComSourceInterfacesAttribute(System.Type sourceInterface) => throw null;
                public ComSourceInterfacesAttribute(System.Type sourceInterface1, System.Type sourceInterface2) => throw null;
                public ComSourceInterfacesAttribute(System.Type sourceInterface1, System.Type sourceInterface2, System.Type sourceInterface3) => throw null;
                public ComSourceInterfacesAttribute(System.Type sourceInterface1, System.Type sourceInterface2, System.Type sourceInterface3, System.Type sourceInterface4) => throw null;
                public string Value { get => throw null; }
            }
            namespace ComTypes
            {
                [System.Flags]
                public enum ADVF
                {
                    ADVF_NODATA = 1,
                    ADVF_PRIMEFIRST = 2,
                    ADVF_ONLYONCE = 4,
                    ADVFCACHE_NOHANDLER = 8,
                    ADVFCACHE_FORCEBUILTIN = 16,
                    ADVFCACHE_ONSAVE = 32,
                    ADVF_DATAONSTOP = 64,
                }
                public struct BIND_OPTS
                {
                    public int cbStruct;
                    public int dwTickCountDeadline;
                    public int grfFlags;
                    public int grfMode;
                }
                public struct BINDPTR
                {
                    public nint lpfuncdesc;
                    public nint lptcomp;
                    public nint lpvardesc;
                }
                public enum CALLCONV
                {
                    CC_CDECL = 1,
                    CC_MSCPASCAL = 2,
                    CC_PASCAL = 2,
                    CC_MACPASCAL = 3,
                    CC_STDCALL = 4,
                    CC_RESERVED = 5,
                    CC_SYSCALL = 6,
                    CC_MPWCDECL = 7,
                    CC_MPWPASCAL = 8,
                    CC_MAX = 9,
                }
                public struct CONNECTDATA
                {
                    public int dwCookie;
                    public object pUnk;
                }
                public enum DATADIR
                {
                    DATADIR_GET = 1,
                    DATADIR_SET = 2,
                }
                public enum DESCKIND
                {
                    DESCKIND_NONE = 0,
                    DESCKIND_FUNCDESC = 1,
                    DESCKIND_VARDESC = 2,
                    DESCKIND_TYPECOMP = 3,
                    DESCKIND_IMPLICITAPPOBJ = 4,
                    DESCKIND_MAX = 5,
                }
                public struct DISPPARAMS
                {
                    public int cArgs;
                    public int cNamedArgs;
                    public nint rgdispidNamedArgs;
                    public nint rgvarg;
                }
                [System.Flags]
                public enum DVASPECT
                {
                    DVASPECT_CONTENT = 1,
                    DVASPECT_THUMBNAIL = 2,
                    DVASPECT_ICON = 4,
                    DVASPECT_DOCPRINT = 8,
                }
                public struct ELEMDESC
                {
                    public System.Runtime.InteropServices.ComTypes.ELEMDESC.DESCUNION desc;
                    public struct DESCUNION
                    {
                        public System.Runtime.InteropServices.ComTypes.IDLDESC idldesc;
                        public System.Runtime.InteropServices.ComTypes.PARAMDESC paramdesc;
                    }
                    public System.Runtime.InteropServices.ComTypes.TYPEDESC tdesc;
                }
                public struct EXCEPINFO
                {
                    public string bstrDescription;
                    public string bstrHelpFile;
                    public string bstrSource;
                    public int dwHelpContext;
                    public nint pfnDeferredFillIn;
                    public nint pvReserved;
                    public int scode;
                    public short wCode;
                    public short wReserved;
                }
                public struct FILETIME
                {
                    public int dwHighDateTime;
                    public int dwLowDateTime;
                }
                public struct FORMATETC
                {
                    public short cfFormat;
                    public System.Runtime.InteropServices.ComTypes.DVASPECT dwAspect;
                    public int lindex;
                    public nint ptd;
                    public System.Runtime.InteropServices.ComTypes.TYMED tymed;
                }
                public struct FUNCDESC
                {
                    public System.Runtime.InteropServices.ComTypes.CALLCONV callconv;
                    public short cParams;
                    public short cParamsOpt;
                    public short cScodes;
                    public System.Runtime.InteropServices.ComTypes.ELEMDESC elemdescFunc;
                    public System.Runtime.InteropServices.ComTypes.FUNCKIND funckind;
                    public System.Runtime.InteropServices.ComTypes.INVOKEKIND invkind;
                    public nint lprgelemdescParam;
                    public nint lprgscode;
                    public int memid;
                    public short oVft;
                    public short wFuncFlags;
                }
                [System.Flags]
                public enum FUNCFLAGS : short
                {
                    FUNCFLAG_FRESTRICTED = 1,
                    FUNCFLAG_FSOURCE = 2,
                    FUNCFLAG_FBINDABLE = 4,
                    FUNCFLAG_FREQUESTEDIT = 8,
                    FUNCFLAG_FDISPLAYBIND = 16,
                    FUNCFLAG_FDEFAULTBIND = 32,
                    FUNCFLAG_FHIDDEN = 64,
                    FUNCFLAG_FUSESGETLASTERROR = 128,
                    FUNCFLAG_FDEFAULTCOLLELEM = 256,
                    FUNCFLAG_FUIDEFAULT = 512,
                    FUNCFLAG_FNONBROWSABLE = 1024,
                    FUNCFLAG_FREPLACEABLE = 2048,
                    FUNCFLAG_FIMMEDIATEBIND = 4096,
                }
                public enum FUNCKIND
                {
                    FUNC_VIRTUAL = 0,
                    FUNC_PUREVIRTUAL = 1,
                    FUNC_NONVIRTUAL = 2,
                    FUNC_STATIC = 3,
                    FUNC_DISPATCH = 4,
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
                public struct IDLDESC
                {
                    public nint dwReserved;
                    public System.Runtime.InteropServices.ComTypes.IDLFLAG wIDLFlags;
                }
                [System.Flags]
                public enum IDLFLAG : short
                {
                    IDLFLAG_NONE = 0,
                    IDLFLAG_FIN = 1,
                    IDLFLAG_FOUT = 2,
                    IDLFLAG_FLCID = 4,
                    IDLFLAG_FRETVAL = 8,
                }
                public interface IEnumConnectionPoints
                {
                    void Clone(out System.Runtime.InteropServices.ComTypes.IEnumConnectionPoints ppenum);
                    int Next(int celt, System.Runtime.InteropServices.ComTypes.IConnectionPoint[] rgelt, nint pceltFetched);
                    void Reset();
                    int Skip(int celt);
                }
                public interface IEnumConnections
                {
                    void Clone(out System.Runtime.InteropServices.ComTypes.IEnumConnections ppenum);
                    int Next(int celt, System.Runtime.InteropServices.ComTypes.CONNECTDATA[] rgelt, nint pceltFetched);
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
                    int Next(int celt, System.Runtime.InteropServices.ComTypes.IMoniker[] rgelt, nint pceltFetched);
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
                    int Next(int celt, string[] rgelt, nint pceltFetched);
                    void Reset();
                    int Skip(int celt);
                }
                public interface IEnumVARIANT
                {
                    System.Runtime.InteropServices.ComTypes.IEnumVARIANT Clone();
                    int Next(int celt, object[] rgVar, nint pceltFetched);
                    int Reset();
                    int Skip(int celt);
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
                    void GetSizeMax(out long pcbSize);
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
                public enum IMPLTYPEFLAGS
                {
                    IMPLTYPEFLAG_FDEFAULT = 1,
                    IMPLTYPEFLAG_FSOURCE = 2,
                    IMPLTYPEFLAG_FRESTRICTED = 4,
                    IMPLTYPEFLAG_FDEFAULTVTABLE = 8,
                }
                [System.Flags]
                public enum INVOKEKIND
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
                    void CopyTo(System.Runtime.InteropServices.ComTypes.IStream pstm, long cb, nint pcbRead, nint pcbWritten);
                    void LockRegion(long libOffset, long cb, int dwLockType);
                    void Read(byte[] pv, int cb, nint pcbRead);
                    void Revert();
                    void Seek(long dlibMove, int dwOrigin, nint plibNewPosition);
                    void SetSize(long libNewSize);
                    void Stat(out System.Runtime.InteropServices.ComTypes.STATSTG pstatstg, int grfStatFlag);
                    void UnlockRegion(long libOffset, long cb, int dwLockType);
                    void Write(byte[] pv, int cb, nint pcbWritten);
                }
                public interface ITypeComp
                {
                    void Bind(string szName, int lHashVal, short wFlags, out System.Runtime.InteropServices.ComTypes.ITypeInfo ppTInfo, out System.Runtime.InteropServices.ComTypes.DESCKIND pDescKind, out System.Runtime.InteropServices.ComTypes.BINDPTR pBindPtr);
                    void BindType(string szName, int lHashVal, out System.Runtime.InteropServices.ComTypes.ITypeInfo ppTInfo, out System.Runtime.InteropServices.ComTypes.ITypeComp ppTComp);
                }
                public interface ITypeInfo
                {
                    void AddressOfMember(int memid, System.Runtime.InteropServices.ComTypes.INVOKEKIND invKind, out nint ppv);
                    void CreateInstance(object pUnkOuter, ref System.Guid riid, out object ppvObj);
                    void GetContainingTypeLib(out System.Runtime.InteropServices.ComTypes.ITypeLib ppTLB, out int pIndex);
                    void GetDllEntry(int memid, System.Runtime.InteropServices.ComTypes.INVOKEKIND invKind, nint pBstrDllName, nint pBstrName, nint pwOrdinal);
                    void GetDocumentation(int index, out string strName, out string strDocString, out int dwHelpContext, out string strHelpFile);
                    void GetFuncDesc(int index, out nint ppFuncDesc);
                    void GetIDsOfNames(string[] rgszNames, int cNames, int[] pMemId);
                    void GetImplTypeFlags(int index, out System.Runtime.InteropServices.ComTypes.IMPLTYPEFLAGS pImplTypeFlags);
                    void GetMops(int memid, out string pBstrMops);
                    void GetNames(int memid, string[] rgBstrNames, int cMaxNames, out int pcNames);
                    void GetRefTypeInfo(int hRef, out System.Runtime.InteropServices.ComTypes.ITypeInfo ppTI);
                    void GetRefTypeOfImplType(int index, out int href);
                    void GetTypeAttr(out nint ppTypeAttr);
                    void GetTypeComp(out System.Runtime.InteropServices.ComTypes.ITypeComp ppTComp);
                    void GetVarDesc(int index, out nint ppVarDesc);
                    void Invoke(object pvInstance, int memid, short wFlags, ref System.Runtime.InteropServices.ComTypes.DISPPARAMS pDispParams, nint pVarResult, nint pExcepInfo, out int puArgErr);
                    void ReleaseFuncDesc(nint pFuncDesc);
                    void ReleaseTypeAttr(nint pTypeAttr);
                    void ReleaseVarDesc(nint pVarDesc);
                }
                public interface ITypeInfo2 : System.Runtime.InteropServices.ComTypes.ITypeInfo
                {
                    void AddressOfMember(int memid, System.Runtime.InteropServices.ComTypes.INVOKEKIND invKind, out nint ppv);
                    void CreateInstance(object pUnkOuter, ref System.Guid riid, out object ppvObj);
                    void GetAllCustData(nint pCustData);
                    void GetAllFuncCustData(int index, nint pCustData);
                    void GetAllImplTypeCustData(int index, nint pCustData);
                    void GetAllParamCustData(int indexFunc, int indexParam, nint pCustData);
                    void GetAllVarCustData(int index, nint pCustData);
                    void GetContainingTypeLib(out System.Runtime.InteropServices.ComTypes.ITypeLib ppTLB, out int pIndex);
                    void GetCustData(ref System.Guid guid, out object pVarVal);
                    void GetDllEntry(int memid, System.Runtime.InteropServices.ComTypes.INVOKEKIND invKind, nint pBstrDllName, nint pBstrName, nint pwOrdinal);
                    void GetDocumentation(int index, out string strName, out string strDocString, out int dwHelpContext, out string strHelpFile);
                    void GetDocumentation2(int memid, out string pbstrHelpString, out int pdwHelpStringContext, out string pbstrHelpStringDll);
                    void GetFuncCustData(int index, ref System.Guid guid, out object pVarVal);
                    void GetFuncDesc(int index, out nint ppFuncDesc);
                    void GetFuncIndexOfMemId(int memid, System.Runtime.InteropServices.ComTypes.INVOKEKIND invKind, out int pFuncIndex);
                    void GetIDsOfNames(string[] rgszNames, int cNames, int[] pMemId);
                    void GetImplTypeCustData(int index, ref System.Guid guid, out object pVarVal);
                    void GetImplTypeFlags(int index, out System.Runtime.InteropServices.ComTypes.IMPLTYPEFLAGS pImplTypeFlags);
                    void GetMops(int memid, out string pBstrMops);
                    void GetNames(int memid, string[] rgBstrNames, int cMaxNames, out int pcNames);
                    void GetParamCustData(int indexFunc, int indexParam, ref System.Guid guid, out object pVarVal);
                    void GetRefTypeInfo(int hRef, out System.Runtime.InteropServices.ComTypes.ITypeInfo ppTI);
                    void GetRefTypeOfImplType(int index, out int href);
                    void GetTypeAttr(out nint ppTypeAttr);
                    void GetTypeComp(out System.Runtime.InteropServices.ComTypes.ITypeComp ppTComp);
                    void GetTypeFlags(out int pTypeFlags);
                    void GetTypeKind(out System.Runtime.InteropServices.ComTypes.TYPEKIND pTypeKind);
                    void GetVarCustData(int index, ref System.Guid guid, out object pVarVal);
                    void GetVarDesc(int index, out nint ppVarDesc);
                    void GetVarIndexOfMemId(int memid, out int pVarIndex);
                    void Invoke(object pvInstance, int memid, short wFlags, ref System.Runtime.InteropServices.ComTypes.DISPPARAMS pDispParams, nint pVarResult, nint pExcepInfo, out int puArgErr);
                    void ReleaseFuncDesc(nint pFuncDesc);
                    void ReleaseTypeAttr(nint pTypeAttr);
                    void ReleaseVarDesc(nint pVarDesc);
                }
                public interface ITypeLib
                {
                    void FindName(string szNameBuf, int lHashVal, System.Runtime.InteropServices.ComTypes.ITypeInfo[] ppTInfo, int[] rgMemId, ref short pcFound);
                    void GetDocumentation(int index, out string strName, out string strDocString, out int dwHelpContext, out string strHelpFile);
                    void GetLibAttr(out nint ppTLibAttr);
                    void GetTypeComp(out System.Runtime.InteropServices.ComTypes.ITypeComp ppTComp);
                    void GetTypeInfo(int index, out System.Runtime.InteropServices.ComTypes.ITypeInfo ppTI);
                    int GetTypeInfoCount();
                    void GetTypeInfoOfGuid(ref System.Guid guid, out System.Runtime.InteropServices.ComTypes.ITypeInfo ppTInfo);
                    void GetTypeInfoType(int index, out System.Runtime.InteropServices.ComTypes.TYPEKIND pTKind);
                    bool IsName(string szNameBuf, int lHashVal);
                    void ReleaseTLibAttr(nint pTLibAttr);
                }
                public interface ITypeLib2 : System.Runtime.InteropServices.ComTypes.ITypeLib
                {
                    void FindName(string szNameBuf, int lHashVal, System.Runtime.InteropServices.ComTypes.ITypeInfo[] ppTInfo, int[] rgMemId, ref short pcFound);
                    void GetAllCustData(nint pCustData);
                    void GetCustData(ref System.Guid guid, out object pVarVal);
                    void GetDocumentation(int index, out string strName, out string strDocString, out int dwHelpContext, out string strHelpFile);
                    void GetDocumentation2(int index, out string pbstrHelpString, out int pdwHelpStringContext, out string pbstrHelpStringDll);
                    void GetLibAttr(out nint ppTLibAttr);
                    void GetLibStatistics(nint pcUniqueNames, out int pcchUniqueNames);
                    void GetTypeComp(out System.Runtime.InteropServices.ComTypes.ITypeComp ppTComp);
                    void GetTypeInfo(int index, out System.Runtime.InteropServices.ComTypes.ITypeInfo ppTI);
                    int GetTypeInfoCount();
                    void GetTypeInfoOfGuid(ref System.Guid guid, out System.Runtime.InteropServices.ComTypes.ITypeInfo ppTInfo);
                    void GetTypeInfoType(int index, out System.Runtime.InteropServices.ComTypes.TYPEKIND pTKind);
                    bool IsName(string szNameBuf, int lHashVal);
                    void ReleaseTLibAttr(nint pTLibAttr);
                }
                [System.Flags]
                public enum LIBFLAGS : short
                {
                    LIBFLAG_FRESTRICTED = 1,
                    LIBFLAG_FCONTROL = 2,
                    LIBFLAG_FHIDDEN = 4,
                    LIBFLAG_FHASDISKIMAGE = 8,
                }
                public struct PARAMDESC
                {
                    public nint lpVarValue;
                    public System.Runtime.InteropServices.ComTypes.PARAMFLAG wParamFlags;
                }
                [System.Flags]
                public enum PARAMFLAG : short
                {
                    PARAMFLAG_NONE = 0,
                    PARAMFLAG_FIN = 1,
                    PARAMFLAG_FOUT = 2,
                    PARAMFLAG_FLCID = 4,
                    PARAMFLAG_FRETVAL = 8,
                    PARAMFLAG_FOPT = 16,
                    PARAMFLAG_FHASDEFAULT = 32,
                    PARAMFLAG_FHASCUSTDATA = 64,
                }
                public struct STATDATA
                {
                    public System.Runtime.InteropServices.ComTypes.ADVF advf;
                    public System.Runtime.InteropServices.ComTypes.IAdviseSink advSink;
                    public int connection;
                    public System.Runtime.InteropServices.ComTypes.FORMATETC formatetc;
                }
                public struct STATSTG
                {
                    public System.Runtime.InteropServices.ComTypes.FILETIME atime;
                    public long cbSize;
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
                    public object pUnkForRelease;
                    public System.Runtime.InteropServices.ComTypes.TYMED tymed;
                    public nint unionmember;
                }
                public enum SYSKIND
                {
                    SYS_WIN16 = 0,
                    SYS_WIN32 = 1,
                    SYS_MAC = 2,
                    SYS_WIN64 = 3,
                }
                [System.Flags]
                public enum TYMED
                {
                    TYMED_NULL = 0,
                    TYMED_HGLOBAL = 1,
                    TYMED_FILE = 2,
                    TYMED_ISTREAM = 4,
                    TYMED_ISTORAGE = 8,
                    TYMED_GDI = 16,
                    TYMED_MFPICT = 32,
                    TYMED_ENHMF = 64,
                }
                public struct TYPEATTR
                {
                    public short cbAlignment;
                    public int cbSizeInstance;
                    public short cbSizeVft;
                    public short cFuncs;
                    public short cImplTypes;
                    public short cVars;
                    public int dwReserved;
                    public System.Guid guid;
                    public System.Runtime.InteropServices.ComTypes.IDLDESC idldescType;
                    public int lcid;
                    public nint lpstrSchema;
                    public const int MEMBER_ID_NIL = -1;
                    public int memidConstructor;
                    public int memidDestructor;
                    public System.Runtime.InteropServices.ComTypes.TYPEDESC tdescAlias;
                    public System.Runtime.InteropServices.ComTypes.TYPEKIND typekind;
                    public short wMajorVerNum;
                    public short wMinorVerNum;
                    public System.Runtime.InteropServices.ComTypes.TYPEFLAGS wTypeFlags;
                }
                public struct TYPEDESC
                {
                    public nint lpValue;
                    public short vt;
                }
                [System.Flags]
                public enum TYPEFLAGS : short
                {
                    TYPEFLAG_FAPPOBJECT = 1,
                    TYPEFLAG_FCANCREATE = 2,
                    TYPEFLAG_FLICENSED = 4,
                    TYPEFLAG_FPREDECLID = 8,
                    TYPEFLAG_FHIDDEN = 16,
                    TYPEFLAG_FCONTROL = 32,
                    TYPEFLAG_FDUAL = 64,
                    TYPEFLAG_FNONEXTENSIBLE = 128,
                    TYPEFLAG_FOLEAUTOMATION = 256,
                    TYPEFLAG_FRESTRICTED = 512,
                    TYPEFLAG_FAGGREGATABLE = 1024,
                    TYPEFLAG_FREPLACEABLE = 2048,
                    TYPEFLAG_FDISPATCHABLE = 4096,
                    TYPEFLAG_FREVERSEBIND = 8192,
                    TYPEFLAG_FPROXY = 16384,
                }
                public enum TYPEKIND
                {
                    TKIND_ENUM = 0,
                    TKIND_RECORD = 1,
                    TKIND_MODULE = 2,
                    TKIND_INTERFACE = 3,
                    TKIND_DISPATCH = 4,
                    TKIND_COCLASS = 5,
                    TKIND_ALIAS = 6,
                    TKIND_UNION = 7,
                    TKIND_MAX = 8,
                }
                public struct TYPELIBATTR
                {
                    public System.Guid guid;
                    public int lcid;
                    public System.Runtime.InteropServices.ComTypes.SYSKIND syskind;
                    public System.Runtime.InteropServices.ComTypes.LIBFLAGS wLibFlags;
                    public short wMajorVerNum;
                    public short wMinorVerNum;
                }
                public struct VARDESC
                {
                    public System.Runtime.InteropServices.ComTypes.VARDESC.DESCUNION desc;
                    public struct DESCUNION
                    {
                        public nint lpvarValue;
                        public int oInst;
                    }
                    public System.Runtime.InteropServices.ComTypes.ELEMDESC elemdescVar;
                    public string lpstrSchema;
                    public int memid;
                    public System.Runtime.InteropServices.ComTypes.VARKIND varkind;
                    public short wVarFlags;
                }
                [System.Flags]
                public enum VARFLAGS : short
                {
                    VARFLAG_FREADONLY = 1,
                    VARFLAG_FSOURCE = 2,
                    VARFLAG_FBINDABLE = 4,
                    VARFLAG_FREQUESTEDIT = 8,
                    VARFLAG_FDISPLAYBIND = 16,
                    VARFLAG_FDEFAULTBIND = 32,
                    VARFLAG_FHIDDEN = 64,
                    VARFLAG_FRESTRICTED = 128,
                    VARFLAG_FDEFAULTCOLLELEM = 256,
                    VARFLAG_FUIDEFAULT = 512,
                    VARFLAG_FNONBROWSABLE = 1024,
                    VARFLAG_FREPLACEABLE = 2048,
                    VARFLAG_FIMMEDIATEBIND = 4096,
                }
                public enum VARKIND
                {
                    VAR_PERINSTANCE = 0,
                    VAR_STATIC = 1,
                    VAR_CONST = 2,
                    VAR_DISPATCH = 3,
                }
            }
            [System.AttributeUsage((System.AttributeTargets)64, Inherited = false)]
            public sealed class ComUnregisterFunctionAttribute : System.Attribute
            {
                public ComUnregisterFunctionAttribute() => throw null;
            }
            public abstract class ComWrappers
            {
                public struct ComInterfaceDispatch
                {
                    public static unsafe T GetInstance<T>(System.Runtime.InteropServices.ComWrappers.ComInterfaceDispatch* dispatchPtr) where T : class => throw null;
                    public nint Vtable;
                }
                public struct ComInterfaceEntry
                {
                    public System.Guid IID;
                    public nint Vtable;
                }
                protected abstract unsafe System.Runtime.InteropServices.ComWrappers.ComInterfaceEntry* ComputeVtables(object obj, System.Runtime.InteropServices.CreateComInterfaceFlags flags, out int count);
                protected abstract object CreateObject(nint externalComObject, System.Runtime.InteropServices.CreateObjectFlags flags);
                protected ComWrappers() => throw null;
                public static void GetIUnknownImpl(out nint fpQueryInterface, out nint fpAddRef, out nint fpRelease) => throw null;
                public nint GetOrCreateComInterfaceForObject(object instance, System.Runtime.InteropServices.CreateComInterfaceFlags flags) => throw null;
                public object GetOrCreateObjectForComInstance(nint externalComObject, System.Runtime.InteropServices.CreateObjectFlags flags) => throw null;
                public object GetOrRegisterObjectForComInstance(nint externalComObject, System.Runtime.InteropServices.CreateObjectFlags flags, object wrapper) => throw null;
                public object GetOrRegisterObjectForComInstance(nint externalComObject, System.Runtime.InteropServices.CreateObjectFlags flags, object wrapper, nint inner) => throw null;
                public static void RegisterForMarshalling(System.Runtime.InteropServices.ComWrappers instance) => throw null;
                public static void RegisterForTrackerSupport(System.Runtime.InteropServices.ComWrappers instance) => throw null;
                protected abstract void ReleaseObjects(System.Collections.IEnumerable objects);
                public static bool TryGetComInstance(object obj, out nint unknown) => throw null;
                public static bool TryGetObject(nint unknown, out object obj) => throw null;
            }
            [System.Flags]
            public enum CreateComInterfaceFlags
            {
                None = 0,
                CallerDefinedIUnknown = 1,
                TrackerSupport = 2,
            }
            [System.Flags]
            public enum CreateObjectFlags
            {
                None = 0,
                TrackerObject = 1,
                UniqueInstance = 2,
                Aggregation = 4,
                Unwrap = 8,
            }
            public struct CULong : System.IEquatable<System.Runtime.InteropServices.CULong>
            {
                public CULong(uint value) => throw null;
                public CULong(nuint value) => throw null;
                public override bool Equals(object o) => throw null;
                public bool Equals(System.Runtime.InteropServices.CULong other) => throw null;
                public override int GetHashCode() => throw null;
                public override string ToString() => throw null;
                public nuint Value { get => throw null; }
            }
            public sealed class CurrencyWrapper
            {
                public CurrencyWrapper(decimal obj) => throw null;
                public CurrencyWrapper(object obj) => throw null;
                public decimal WrappedObject { get => throw null; }
            }
            public enum CustomQueryInterfaceMode
            {
                Ignore = 0,
                Allow = 1,
            }
            public enum CustomQueryInterfaceResult
            {
                Handled = 0,
                NotHandled = 1,
                Failed = 2,
            }
            [System.AttributeUsage((System.AttributeTargets)2, Inherited = false)]
            public sealed class DefaultCharSetAttribute : System.Attribute
            {
                public System.Runtime.InteropServices.CharSet CharSet { get => throw null; }
                public DefaultCharSetAttribute(System.Runtime.InteropServices.CharSet charSet) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)65, AllowMultiple = false)]
            public sealed class DefaultDllImportSearchPathsAttribute : System.Attribute
            {
                public DefaultDllImportSearchPathsAttribute(System.Runtime.InteropServices.DllImportSearchPath paths) => throw null;
                public System.Runtime.InteropServices.DllImportSearchPath Paths { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)2048)]
            public sealed class DefaultParameterValueAttribute : System.Attribute
            {
                public DefaultParameterValueAttribute(object value) => throw null;
                public object Value { get => throw null; }
            }
            public sealed class DispatchWrapper
            {
                public DispatchWrapper(object obj) => throw null;
                public object WrappedObject { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)960, Inherited = false)]
            public sealed class DispIdAttribute : System.Attribute
            {
                public DispIdAttribute(int dispId) => throw null;
                public int Value { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)64, Inherited = false)]
            public sealed class DllImportAttribute : System.Attribute
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
            public delegate nint DllImportResolver(string libraryName, System.Reflection.Assembly assembly, System.Runtime.InteropServices.DllImportSearchPath? searchPath);
            [System.Flags]
            public enum DllImportSearchPath
            {
                LegacyBehavior = 0,
                AssemblyDirectory = 2,
                UseDllDirectoryForDependencies = 256,
                ApplicationDirectory = 512,
                UserDirectories = 1024,
                System32 = 2048,
                SafeDirectories = 4096,
            }
            [System.AttributeUsage((System.AttributeTargets)1024, AllowMultiple = false, Inherited = false)]
            public sealed class DynamicInterfaceCastableImplementationAttribute : System.Attribute
            {
                public DynamicInterfaceCastableImplementationAttribute() => throw null;
            }
            public sealed class ErrorWrapper
            {
                public ErrorWrapper(System.Exception e) => throw null;
                public ErrorWrapper(int errorCode) => throw null;
                public ErrorWrapper(object errorCode) => throw null;
                public int ErrorCode { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)5149, Inherited = false)]
            public sealed class GuidAttribute : System.Attribute
            {
                public GuidAttribute(string guid) => throw null;
                public string Value { get => throw null; }
            }
            public sealed class HandleCollector
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
                public HandleRef(object wrapper, nint handle) => throw null;
                public nint Handle { get => throw null; }
                public static explicit operator nint(System.Runtime.InteropServices.HandleRef value) => throw null;
                public static nint ToIntPtr(System.Runtime.InteropServices.HandleRef value) => throw null;
                public object Wrapper { get => throw null; }
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
                void CleanUpNativeData(nint pNativeData);
                int GetNativeDataSize();
                nint MarshalManagedToNative(object ManagedObj);
                object MarshalNativeToManaged(nint pNativeData);
            }
            public interface ICustomQueryInterface
            {
                System.Runtime.InteropServices.CustomQueryInterfaceResult GetInterface(ref System.Guid iid, out nint ppv);
            }
            public interface IDynamicInterfaceCastable
            {
                System.RuntimeTypeHandle GetInterfaceImplementation(System.RuntimeTypeHandle interfaceType);
                bool IsInterfaceImplemented(System.RuntimeTypeHandle interfaceType, bool throwIfNotImplemented);
            }
            [System.AttributeUsage((System.AttributeTargets)1, Inherited = false)]
            public sealed class ImportedFromTypeLibAttribute : System.Attribute
            {
                public ImportedFromTypeLibAttribute(string tlbFile) => throw null;
                public string Value { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)1024, Inherited = false)]
            public sealed class InterfaceTypeAttribute : System.Attribute
            {
                public InterfaceTypeAttribute(short interfaceType) => throw null;
                public InterfaceTypeAttribute(System.Runtime.InteropServices.ComInterfaceType interfaceType) => throw null;
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
            [System.AttributeUsage((System.AttributeTargets)64, Inherited = false)]
            public sealed class LCIDConversionAttribute : System.Attribute
            {
                public LCIDConversionAttribute(int lcid) => throw null;
                public int Value { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)64, AllowMultiple = false, Inherited = false)]
            public sealed class LibraryImportAttribute : System.Attribute
            {
                public LibraryImportAttribute(string libraryName) => throw null;
                public string EntryPoint { get => throw null; set { } }
                public string LibraryName { get => throw null; }
                public bool SetLastError { get => throw null; set { } }
                public System.Runtime.InteropServices.StringMarshalling StringMarshalling { get => throw null; set { } }
                public System.Type StringMarshallingCustomType { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)64, Inherited = false, AllowMultiple = false)]
            public sealed class ManagedToNativeComInteropStubAttribute : System.Attribute
            {
                public System.Type ClassType { get => throw null; }
                public ManagedToNativeComInteropStubAttribute(System.Type classType, string methodName) => throw null;
                public string MethodName { get => throw null; }
            }
            public static class Marshal
            {
                public static int AddRef(nint pUnk) => throw null;
                public static nint AllocCoTaskMem(int cb) => throw null;
                public static nint AllocHGlobal(int cb) => throw null;
                public static nint AllocHGlobal(nint cb) => throw null;
                public static bool AreComObjectsAvailableForCleanup() => throw null;
                public static object BindToMoniker(string monikerName) => throw null;
                public static void ChangeWrapperHandleStrength(object otp, bool fIsWeak) => throw null;
                public static void CleanupUnusedObjectsInCurrentContext() => throw null;
                public static void Copy(byte[] source, int startIndex, nint destination, int length) => throw null;
                public static void Copy(char[] source, int startIndex, nint destination, int length) => throw null;
                public static void Copy(double[] source, int startIndex, nint destination, int length) => throw null;
                public static void Copy(short[] source, int startIndex, nint destination, int length) => throw null;
                public static void Copy(int[] source, int startIndex, nint destination, int length) => throw null;
                public static void Copy(long[] source, int startIndex, nint destination, int length) => throw null;
                public static void Copy(nint source, byte[] destination, int startIndex, int length) => throw null;
                public static void Copy(nint source, char[] destination, int startIndex, int length) => throw null;
                public static void Copy(nint source, double[] destination, int startIndex, int length) => throw null;
                public static void Copy(nint source, short[] destination, int startIndex, int length) => throw null;
                public static void Copy(nint source, int[] destination, int startIndex, int length) => throw null;
                public static void Copy(nint source, long[] destination, int startIndex, int length) => throw null;
                public static void Copy(nint source, nint[] destination, int startIndex, int length) => throw null;
                public static void Copy(nint source, float[] destination, int startIndex, int length) => throw null;
                public static void Copy(nint[] source, int startIndex, nint destination, int length) => throw null;
                public static void Copy(float[] source, int startIndex, nint destination, int length) => throw null;
                public static nint CreateAggregatedObject(nint pOuter, object o) => throw null;
                public static nint CreateAggregatedObject<T>(nint pOuter, T o) => throw null;
                public static object CreateWrapperOfType(object o, System.Type t) => throw null;
                public static TWrapper CreateWrapperOfType<T, TWrapper>(T o) => throw null;
                public static void DestroyStructure(nint ptr, System.Type structuretype) => throw null;
                public static void DestroyStructure<T>(nint ptr) => throw null;
                public static int FinalReleaseComObject(object o) => throw null;
                public static void FreeBSTR(nint ptr) => throw null;
                public static void FreeCoTaskMem(nint ptr) => throw null;
                public static void FreeHGlobal(nint hglobal) => throw null;
                public static System.Guid GenerateGuidForType(System.Type type) => throw null;
                public static string GenerateProgIdForType(System.Type type) => throw null;
                public static nint GetComInterfaceForObject(object o, System.Type T) => throw null;
                public static nint GetComInterfaceForObject(object o, System.Type T, System.Runtime.InteropServices.CustomQueryInterfaceMode mode) => throw null;
                public static nint GetComInterfaceForObject<T, TInterface>(T o) => throw null;
                public static object GetComObjectData(object obj, object key) => throw null;
                public static System.Delegate GetDelegateForFunctionPointer(nint ptr, System.Type t) => throw null;
                public static TDelegate GetDelegateForFunctionPointer<TDelegate>(nint ptr) => throw null;
                public static int GetEndComSlot(System.Type t) => throw null;
                public static int GetExceptionCode() => throw null;
                public static System.Exception GetExceptionForHR(int errorCode) => throw null;
                public static System.Exception GetExceptionForHR(int errorCode, nint errorInfo) => throw null;
                public static nint GetExceptionPointers() => throw null;
                public static nint GetFunctionPointerForDelegate(System.Delegate d) => throw null;
                public static nint GetFunctionPointerForDelegate<TDelegate>(TDelegate d) => throw null;
                public static nint GetHINSTANCE(System.Reflection.Module m) => throw null;
                public static int GetHRForException(System.Exception e) => throw null;
                public static int GetHRForLastWin32Error() => throw null;
                public static nint GetIDispatchForObject(object o) => throw null;
                public static nint GetIUnknownForObject(object o) => throw null;
                public static int GetLastPInvokeError() => throw null;
                public static string GetLastPInvokeErrorMessage() => throw null;
                public static int GetLastSystemError() => throw null;
                public static int GetLastWin32Error() => throw null;
                public static void GetNativeVariantForObject(object obj, nint pDstNativeVariant) => throw null;
                public static void GetNativeVariantForObject<T>(T obj, nint pDstNativeVariant) => throw null;
                public static object GetObjectForIUnknown(nint pUnk) => throw null;
                public static object GetObjectForNativeVariant(nint pSrcNativeVariant) => throw null;
                public static T GetObjectForNativeVariant<T>(nint pSrcNativeVariant) => throw null;
                public static object[] GetObjectsForNativeVariants(nint aSrcNativeVariant, int cVars) => throw null;
                public static T[] GetObjectsForNativeVariants<T>(nint aSrcNativeVariant, int cVars) => throw null;
                public static string GetPInvokeErrorMessage(int error) => throw null;
                public static int GetStartComSlot(System.Type t) => throw null;
                public static object GetTypedObjectForIUnknown(nint pUnk, System.Type t) => throw null;
                public static System.Type GetTypeFromCLSID(System.Guid clsid) => throw null;
                public static string GetTypeInfoName(System.Runtime.InteropServices.ComTypes.ITypeInfo typeInfo) => throw null;
                public static object GetUniqueObjectForIUnknown(nint unknown) => throw null;
                public static void InitHandle(System.Runtime.InteropServices.SafeHandle safeHandle, nint handle) => throw null;
                public static bool IsComObject(object o) => throw null;
                public static bool IsTypeVisibleFromCom(System.Type t) => throw null;
                public static nint OffsetOf(System.Type t, string fieldName) => throw null;
                public static nint OffsetOf<T>(string fieldName) => throw null;
                public static void Prelink(System.Reflection.MethodInfo m) => throw null;
                public static void PrelinkAll(System.Type c) => throw null;
                public static string PtrToStringAnsi(nint ptr) => throw null;
                public static string PtrToStringAnsi(nint ptr, int len) => throw null;
                public static string PtrToStringAuto(nint ptr) => throw null;
                public static string PtrToStringAuto(nint ptr, int len) => throw null;
                public static string PtrToStringBSTR(nint ptr) => throw null;
                public static string PtrToStringUni(nint ptr) => throw null;
                public static string PtrToStringUni(nint ptr, int len) => throw null;
                public static string PtrToStringUTF8(nint ptr) => throw null;
                public static string PtrToStringUTF8(nint ptr, int byteLen) => throw null;
                public static void PtrToStructure(nint ptr, object structure) => throw null;
                public static object PtrToStructure(nint ptr, System.Type structureType) => throw null;
                public static T PtrToStructure<T>(nint ptr) => throw null;
                public static void PtrToStructure<T>(nint ptr, T structure) => throw null;
                public static int QueryInterface(nint pUnk, ref readonly System.Guid iid, out nint ppv) => throw null;
                public static byte ReadByte(nint ptr) => throw null;
                public static byte ReadByte(nint ptr, int ofs) => throw null;
                public static byte ReadByte(object ptr, int ofs) => throw null;
                public static short ReadInt16(nint ptr) => throw null;
                public static short ReadInt16(nint ptr, int ofs) => throw null;
                public static short ReadInt16(object ptr, int ofs) => throw null;
                public static int ReadInt32(nint ptr) => throw null;
                public static int ReadInt32(nint ptr, int ofs) => throw null;
                public static int ReadInt32(object ptr, int ofs) => throw null;
                public static long ReadInt64(nint ptr) => throw null;
                public static long ReadInt64(nint ptr, int ofs) => throw null;
                public static long ReadInt64(object ptr, int ofs) => throw null;
                public static nint ReadIntPtr(nint ptr) => throw null;
                public static nint ReadIntPtr(nint ptr, int ofs) => throw null;
                public static nint ReadIntPtr(object ptr, int ofs) => throw null;
                public static nint ReAllocCoTaskMem(nint pv, int cb) => throw null;
                public static nint ReAllocHGlobal(nint pv, nint cb) => throw null;
                public static int Release(nint pUnk) => throw null;
                public static int ReleaseComObject(object o) => throw null;
                public static nint SecureStringToBSTR(System.Security.SecureString s) => throw null;
                public static nint SecureStringToCoTaskMemAnsi(System.Security.SecureString s) => throw null;
                public static nint SecureStringToCoTaskMemUnicode(System.Security.SecureString s) => throw null;
                public static nint SecureStringToGlobalAllocAnsi(System.Security.SecureString s) => throw null;
                public static nint SecureStringToGlobalAllocUnicode(System.Security.SecureString s) => throw null;
                public static bool SetComObjectData(object obj, object key, object data) => throw null;
                public static void SetLastPInvokeError(int error) => throw null;
                public static void SetLastSystemError(int error) => throw null;
                public static int SizeOf(object structure) => throw null;
                public static int SizeOf(System.Type t) => throw null;
                public static int SizeOf<T>() => throw null;
                public static int SizeOf<T>(T structure) => throw null;
                public static nint StringToBSTR(string s) => throw null;
                public static nint StringToCoTaskMemAnsi(string s) => throw null;
                public static nint StringToCoTaskMemAuto(string s) => throw null;
                public static nint StringToCoTaskMemUni(string s) => throw null;
                public static nint StringToCoTaskMemUTF8(string s) => throw null;
                public static nint StringToHGlobalAnsi(string s) => throw null;
                public static nint StringToHGlobalAuto(string s) => throw null;
                public static nint StringToHGlobalUni(string s) => throw null;
                public static void StructureToPtr(object structure, nint ptr, bool fDeleteOld) => throw null;
                public static void StructureToPtr<T>(T structure, nint ptr, bool fDeleteOld) => throw null;
                public static readonly int SystemDefaultCharSize;
                public static readonly int SystemMaxDBCSCharSize;
                public static void ThrowExceptionForHR(int errorCode) => throw null;
                public static void ThrowExceptionForHR(int errorCode, nint errorInfo) => throw null;
                public static nint UnsafeAddrOfPinnedArrayElement(System.Array arr, int index) => throw null;
                public static nint UnsafeAddrOfPinnedArrayElement<T>(T[] arr, int index) => throw null;
                public static void WriteByte(nint ptr, byte val) => throw null;
                public static void WriteByte(nint ptr, int ofs, byte val) => throw null;
                public static void WriteByte(object ptr, int ofs, byte val) => throw null;
                public static void WriteInt16(nint ptr, char val) => throw null;
                public static void WriteInt16(nint ptr, short val) => throw null;
                public static void WriteInt16(nint ptr, int ofs, char val) => throw null;
                public static void WriteInt16(nint ptr, int ofs, short val) => throw null;
                public static void WriteInt16(object ptr, int ofs, char val) => throw null;
                public static void WriteInt16(object ptr, int ofs, short val) => throw null;
                public static void WriteInt32(nint ptr, int val) => throw null;
                public static void WriteInt32(nint ptr, int ofs, int val) => throw null;
                public static void WriteInt32(object ptr, int ofs, int val) => throw null;
                public static void WriteInt64(nint ptr, int ofs, long val) => throw null;
                public static void WriteInt64(nint ptr, long val) => throw null;
                public static void WriteInt64(object ptr, int ofs, long val) => throw null;
                public static void WriteIntPtr(nint ptr, int ofs, nint val) => throw null;
                public static void WriteIntPtr(nint ptr, nint val) => throw null;
                public static void WriteIntPtr(object ptr, int ofs, nint val) => throw null;
                public static void ZeroFreeBSTR(nint s) => throw null;
                public static void ZeroFreeCoTaskMemAnsi(nint s) => throw null;
                public static void ZeroFreeCoTaskMemUnicode(nint s) => throw null;
                public static void ZeroFreeCoTaskMemUTF8(nint s) => throw null;
                public static void ZeroFreeGlobalAllocAnsi(nint s) => throw null;
                public static void ZeroFreeGlobalAllocUnicode(nint s) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)10496, Inherited = false)]
            public sealed class MarshalAsAttribute : System.Attribute
            {
                public System.Runtime.InteropServices.UnmanagedType ArraySubType;
                public MarshalAsAttribute(short unmanagedType) => throw null;
                public MarshalAsAttribute(System.Runtime.InteropServices.UnmanagedType unmanagedType) => throw null;
                public int IidParameterIndex;
                public string MarshalCookie;
                public string MarshalType;
                public System.Type MarshalTypeRef;
                public System.Runtime.InteropServices.VarEnum SafeArraySubType;
                public System.Type SafeArrayUserDefinedSubType;
                public int SizeConst;
                public short SizeParamIndex;
                public System.Runtime.InteropServices.UnmanagedType Value { get => throw null; }
            }
            public class MarshalDirectiveException : System.SystemException
            {
                public MarshalDirectiveException() => throw null;
                protected MarshalDirectiveException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public MarshalDirectiveException(string message) => throw null;
                public MarshalDirectiveException(string message, System.Exception inner) => throw null;
            }
            namespace Marshalling
            {
                public static class AnsiStringMarshaller
                {
                    public static unsafe string ConvertToManaged(byte* unmanaged) => throw null;
                    public static unsafe byte* ConvertToUnmanaged(string managed) => throw null;
                    public static unsafe void Free(byte* unmanaged) => throw null;
                    public struct ManagedToUnmanagedIn
                    {
                        public static int BufferSize { get => throw null; }
                        public void Free() => throw null;
                        public void FromManaged(string managed, System.Span<byte> buffer) => throw null;
                        public unsafe byte* ToUnmanaged() => throw null;
                    }
                }
                public static class ArrayMarshaller<T, TUnmanagedElement> where TUnmanagedElement : unmanaged
                {
                    public static unsafe T[] AllocateContainerForManagedElements(TUnmanagedElement* unmanaged, int numElements) => throw null;
                    public static unsafe TUnmanagedElement* AllocateContainerForUnmanagedElements(T[] managed, out int numElements) => throw null;
                    public static unsafe void Free(TUnmanagedElement* unmanaged) => throw null;
                    public static System.Span<T> GetManagedValuesDestination(T[] managed) => throw null;
                    public static System.ReadOnlySpan<T> GetManagedValuesSource(T[] managed) => throw null;
                    public static unsafe System.Span<TUnmanagedElement> GetUnmanagedValuesDestination(TUnmanagedElement* unmanaged, int numElements) => throw null;
                    public static unsafe System.ReadOnlySpan<TUnmanagedElement> GetUnmanagedValuesSource(TUnmanagedElement* unmanagedValue, int numElements) => throw null;
                    public struct ManagedToUnmanagedIn
                    {
                        public static int BufferSize { get => throw null; }
                        public void Free() => throw null;
                        public void FromManaged(T[] array, System.Span<TUnmanagedElement> buffer) => throw null;
                        public System.ReadOnlySpan<T> GetManagedValuesSource() => throw null;
                        public TUnmanagedElement GetPinnableReference() => throw null;
                        public static T GetPinnableReference(T[] array) => throw null;
                        public System.Span<TUnmanagedElement> GetUnmanagedValuesDestination() => throw null;
                        public unsafe TUnmanagedElement* ToUnmanaged() => throw null;
                    }
                }
                public static class BStrStringMarshaller
                {
                    public static unsafe string ConvertToManaged(ushort* unmanaged) => throw null;
                    public static unsafe ushort* ConvertToUnmanaged(string managed) => throw null;
                    public static unsafe void Free(ushort* unmanaged) => throw null;
                    public struct ManagedToUnmanagedIn
                    {
                        public static int BufferSize { get => throw null; }
                        public void Free() => throw null;
                        public void FromManaged(string managed, System.Span<byte> buffer) => throw null;
                        public unsafe ushort* ToUnmanaged() => throw null;
                    }
                }
                [System.AttributeUsage((System.AttributeTargets)4, Inherited = false)]
                public sealed class ComExposedClassAttribute<T> : System.Attribute, System.Runtime.InteropServices.Marshalling.IComExposedDetails where T : System.Runtime.InteropServices.Marshalling.IComExposedClass
                {
                    public ComExposedClassAttribute() => throw null;
                    public unsafe System.Runtime.InteropServices.ComWrappers.ComInterfaceEntry* GetComInterfaceEntries(out int count) => throw null;
                }
                public static class ComInterfaceMarshaller<T>
                {
                    public static unsafe T ConvertToManaged(void* unmanaged) => throw null;
                    public static unsafe void* ConvertToUnmanaged(T managed) => throw null;
                    public static unsafe void Free(void* unmanaged) => throw null;
                }
                [System.Flags]
                public enum ComInterfaceOptions
                {
                    None = 0,
                    ManagedObjectWrapper = 1,
                    ComObjectWrapper = 2,
                }
                public sealed class ComObject : System.Runtime.InteropServices.IDynamicInterfaceCastable, System.Runtime.InteropServices.Marshalling.IUnmanagedVirtualMethodTableProvider
                {
                    public void FinalRelease() => throw null;
                    System.RuntimeTypeHandle System.Runtime.InteropServices.IDynamicInterfaceCastable.GetInterfaceImplementation(System.RuntimeTypeHandle interfaceType) => throw null;
                    System.Runtime.InteropServices.Marshalling.VirtualMethodTableInfo System.Runtime.InteropServices.Marshalling.IUnmanagedVirtualMethodTableProvider.GetVirtualMethodTableInfoForKey(System.Type type) => throw null;
                    bool System.Runtime.InteropServices.IDynamicInterfaceCastable.IsInterfaceImplemented(System.RuntimeTypeHandle interfaceType, bool throwIfNotImplemented) => throw null;
                }
                public static class ExceptionAsDefaultMarshaller<T> where T : struct
                {
                    public static T ConvertToUnmanaged(System.Exception e) => throw null;
                }
                public static class ExceptionAsHResultMarshaller<T> where T : struct
                {
                    public static T ConvertToUnmanaged(System.Exception e) => throw null;
                }
                public static class ExceptionAsNaNMarshaller<T> where T : struct
                {
                    public static T ConvertToUnmanaged(System.Exception e) => throw null;
                }
                public static class ExceptionAsVoidMarshaller
                {
                    public static void ConvertToUnmanaged(System.Exception e) => throw null;
                }
                [System.AttributeUsage((System.AttributeTargets)4)]
                public sealed class GeneratedComClassAttribute : System.Attribute
                {
                    public GeneratedComClassAttribute() => throw null;
                }
                [System.AttributeUsage((System.AttributeTargets)1024)]
                public class GeneratedComInterfaceAttribute : System.Attribute
                {
                    public GeneratedComInterfaceAttribute() => throw null;
                    public System.Runtime.InteropServices.Marshalling.ComInterfaceOptions Options { get => throw null; set { } }
                    public System.Runtime.InteropServices.StringMarshalling StringMarshalling { get => throw null; set { } }
                    public System.Type StringMarshallingCustomType { get => throw null; set { } }
                }
                public interface IComExposedClass
                {
                    abstract static unsafe System.Runtime.InteropServices.ComWrappers.ComInterfaceEntry* GetComInterfaceEntries(out int count);
                }
                public interface IComExposedDetails
                {
                    unsafe System.Runtime.InteropServices.ComWrappers.ComInterfaceEntry* GetComInterfaceEntries(out int count);
                }
                public interface IIUnknownCacheStrategy
                {
                    void Clear(System.Runtime.InteropServices.Marshalling.IIUnknownStrategy unknownStrategy);
                    unsafe System.Runtime.InteropServices.Marshalling.IIUnknownCacheStrategy.TableInfo ConstructTableInfo(System.RuntimeTypeHandle handle, System.Runtime.InteropServices.Marshalling.IIUnknownDerivedDetails interfaceDetails, void* ptr);
                    struct TableInfo
                    {
                        public System.RuntimeTypeHandle ManagedType { get => throw null; set { } }
                        public unsafe void** Table { get => throw null; set { } }
                        public unsafe void* ThisPtr { get => throw null; set { } }
                    }
                    bool TryGetTableInfo(System.RuntimeTypeHandle handle, out System.Runtime.InteropServices.Marshalling.IIUnknownCacheStrategy.TableInfo info);
                    bool TrySetTableInfo(System.RuntimeTypeHandle handle, System.Runtime.InteropServices.Marshalling.IIUnknownCacheStrategy.TableInfo info);
                }
                public interface IIUnknownDerivedDetails
                {
                    System.Guid Iid { get; }
                    System.Type Implementation { get; }
                    unsafe void** ManagedVirtualMethodTable { get; }
                }
                public interface IIUnknownInterfaceDetailsStrategy
                {
                    System.Runtime.InteropServices.Marshalling.IComExposedDetails GetComExposedTypeDetails(System.RuntimeTypeHandle type);
                    System.Runtime.InteropServices.Marshalling.IIUnknownDerivedDetails GetIUnknownDerivedDetails(System.RuntimeTypeHandle type);
                }
                public interface IIUnknownInterfaceType
                {
                    abstract static System.Guid Iid { get; }
                    abstract static unsafe void** ManagedVirtualMethodTable { get; }
                }
                public interface IIUnknownStrategy
                {
                    unsafe void* CreateInstancePointer(void* unknown);
                    unsafe int QueryInterface(void* instancePtr, in System.Guid iid, out void* ppObj);
                    unsafe int Release(void* instancePtr);
                }
                [System.AttributeUsage((System.AttributeTargets)1024, Inherited = false)]
                public class IUnknownDerivedAttribute<T, TImpl> : System.Attribute, System.Runtime.InteropServices.Marshalling.IIUnknownDerivedDetails where T : System.Runtime.InteropServices.Marshalling.IIUnknownInterfaceType
                {
                    public IUnknownDerivedAttribute() => throw null;
                    public System.Guid Iid { get => throw null; }
                    public System.Type Implementation { get => throw null; }
                    public unsafe void** ManagedVirtualMethodTable { get => throw null; }
                }
                public interface IUnmanagedVirtualMethodTableProvider
                {
                    System.Runtime.InteropServices.Marshalling.VirtualMethodTableInfo GetVirtualMethodTableInfoForKey(System.Type type);
                }
                [System.AttributeUsage((System.AttributeTargets)10240, AllowMultiple = true)]
                public sealed class MarshalUsingAttribute : System.Attribute
                {
                    public int ConstantElementCount { get => throw null; set { } }
                    public string CountElementName { get => throw null; set { } }
                    public MarshalUsingAttribute() => throw null;
                    public MarshalUsingAttribute(System.Type nativeType) => throw null;
                    public int ElementIndirectionDepth { get => throw null; set { } }
                    public System.Type NativeType { get => throw null; }
                    public const string ReturnsCountValue = default;
                }
                public static class PointerArrayMarshaller<T, TUnmanagedElement> where T : unmanaged where TUnmanagedElement : unmanaged
                {
                    public static unsafe T*[] AllocateContainerForManagedElements(TUnmanagedElement* unmanaged, int numElements) => throw null;
                    public static unsafe TUnmanagedElement* AllocateContainerForUnmanagedElements(T*[] managed, out int numElements) => throw null;
                    public static unsafe void Free(TUnmanagedElement* unmanaged) => throw null;
                    public static unsafe System.Span<nint> GetManagedValuesDestination(T*[] managed) => throw null;
                    public static unsafe System.ReadOnlySpan<nint> GetManagedValuesSource(T*[] managed) => throw null;
                    public static unsafe System.Span<TUnmanagedElement> GetUnmanagedValuesDestination(TUnmanagedElement* unmanaged, int numElements) => throw null;
                    public static unsafe System.ReadOnlySpan<TUnmanagedElement> GetUnmanagedValuesSource(TUnmanagedElement* unmanagedValue, int numElements) => throw null;
                    public struct ManagedToUnmanagedIn
                    {
                        public static int BufferSize { get => throw null; }
                        public void Free() => throw null;
                        public unsafe void FromManaged(T*[] array, System.Span<TUnmanagedElement> buffer) => throw null;
                        public System.ReadOnlySpan<nint> GetManagedValuesSource() => throw null;
                        public TUnmanagedElement GetPinnableReference() => throw null;
                        public static unsafe byte GetPinnableReference(T*[] array) => throw null;
                        public System.Span<TUnmanagedElement> GetUnmanagedValuesDestination() => throw null;
                        public unsafe TUnmanagedElement* ToUnmanaged() => throw null;
                    }
                }
                public class StrategyBasedComWrappers : System.Runtime.InteropServices.ComWrappers
                {
                    protected override sealed unsafe System.Runtime.InteropServices.ComWrappers.ComInterfaceEntry* ComputeVtables(object obj, System.Runtime.InteropServices.CreateComInterfaceFlags flags, out int count) => throw null;
                    protected virtual System.Runtime.InteropServices.Marshalling.IIUnknownCacheStrategy CreateCacheStrategy() => throw null;
                    protected static System.Runtime.InteropServices.Marshalling.IIUnknownCacheStrategy CreateDefaultCacheStrategy() => throw null;
                    protected override sealed object CreateObject(nint externalComObject, System.Runtime.InteropServices.CreateObjectFlags flags) => throw null;
                    public StrategyBasedComWrappers() => throw null;
                    public static System.Runtime.InteropServices.Marshalling.IIUnknownInterfaceDetailsStrategy DefaultIUnknownInterfaceDetailsStrategy { get => throw null; }
                    public static System.Runtime.InteropServices.Marshalling.IIUnknownStrategy DefaultIUnknownStrategy { get => throw null; }
                    protected virtual System.Runtime.InteropServices.Marshalling.IIUnknownInterfaceDetailsStrategy GetOrCreateInterfaceDetailsStrategy() => throw null;
                    protected virtual System.Runtime.InteropServices.Marshalling.IIUnknownStrategy GetOrCreateIUnknownStrategy() => throw null;
                    protected override sealed void ReleaseObjects(System.Collections.IEnumerable objects) => throw null;
                }
                public static class UniqueComInterfaceMarshaller<T>
                {
                    public static unsafe T ConvertToManaged(void* unmanaged) => throw null;
                    public static unsafe void* ConvertToUnmanaged(T managed) => throw null;
                    public static unsafe void Free(void* unmanaged) => throw null;
                }
                public static class Utf16StringMarshaller
                {
                    public static unsafe string ConvertToManaged(ushort* unmanaged) => throw null;
                    public static unsafe ushort* ConvertToUnmanaged(string managed) => throw null;
                    public static unsafe void Free(ushort* unmanaged) => throw null;
                    public static char GetPinnableReference(string str) => throw null;
                }
                public static class Utf8StringMarshaller
                {
                    public static unsafe string ConvertToManaged(byte* unmanaged) => throw null;
                    public static unsafe byte* ConvertToUnmanaged(string managed) => throw null;
                    public static unsafe void Free(byte* unmanaged) => throw null;
                    public struct ManagedToUnmanagedIn
                    {
                        public static int BufferSize { get => throw null; }
                        public void Free() => throw null;
                        public void FromManaged(string managed, System.Span<byte> buffer) => throw null;
                        public unsafe byte* ToUnmanaged() => throw null;
                    }
                }
                public struct VirtualMethodTableInfo
                {
                    public unsafe VirtualMethodTableInfo(void* thisPointer, void** virtualMethodTable) => throw null;
                    public unsafe void Deconstruct(out void* thisPointer, out void** virtualMethodTable) => throw null;
                    public unsafe void* ThisPointer { get => throw null; }
                    public unsafe void** VirtualMethodTable { get => throw null; }
                }
            }
            public static class NativeLibrary
            {
                public static void Free(nint handle) => throw null;
                public static nint GetExport(nint handle, string name) => throw null;
                public static nint GetMainProgramHandle() => throw null;
                public static nint Load(string libraryPath) => throw null;
                public static nint Load(string libraryName, System.Reflection.Assembly assembly, System.Runtime.InteropServices.DllImportSearchPath? searchPath) => throw null;
                public static void SetDllImportResolver(System.Reflection.Assembly assembly, System.Runtime.InteropServices.DllImportResolver resolver) => throw null;
                public static bool TryGetExport(nint handle, string name, out nint address) => throw null;
                public static bool TryLoad(string libraryPath, out nint handle) => throw null;
                public static bool TryLoad(string libraryName, System.Reflection.Assembly assembly, System.Runtime.InteropServices.DllImportSearchPath? searchPath, out nint handle) => throw null;
            }
            public static class NativeMemory
            {
                public static unsafe void* AlignedAlloc(nuint byteCount, nuint alignment) => throw null;
                public static unsafe void AlignedFree(void* ptr) => throw null;
                public static unsafe void* AlignedRealloc(void* ptr, nuint byteCount, nuint alignment) => throw null;
                public static unsafe void* Alloc(nuint byteCount) => throw null;
                public static unsafe void* Alloc(nuint elementCount, nuint elementSize) => throw null;
                public static unsafe void* AllocZeroed(nuint byteCount) => throw null;
                public static unsafe void* AllocZeroed(nuint elementCount, nuint elementSize) => throw null;
                public static unsafe void Clear(void* ptr, nuint byteCount) => throw null;
                public static unsafe void Copy(void* source, void* destination, nuint byteCount) => throw null;
                public static unsafe void Fill(void* ptr, nuint byteCount, byte value) => throw null;
                public static unsafe void Free(void* ptr) => throw null;
                public static unsafe void* Realloc(void* ptr, nuint byteCount) => throw null;
            }
            public struct NFloat : System.Numerics.IAdditionOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>, System.Numerics.IAdditiveIdentity<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>, System.Numerics.IBinaryFloatingPointIeee754<System.Runtime.InteropServices.NFloat>, System.Numerics.IBinaryNumber<System.Runtime.InteropServices.NFloat>, System.Numerics.IBitwiseOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>, System.IComparable, System.IComparable<System.Runtime.InteropServices.NFloat>, System.Numerics.IComparisonOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, bool>, System.Numerics.IDecrementOperators<System.Runtime.InteropServices.NFloat>, System.Numerics.IDivisionOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>, System.Numerics.IEqualityOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, bool>, System.IEquatable<System.Runtime.InteropServices.NFloat>, System.Numerics.IExponentialFunctions<System.Runtime.InteropServices.NFloat>, System.Numerics.IFloatingPoint<System.Runtime.InteropServices.NFloat>, System.Numerics.IFloatingPointConstants<System.Runtime.InteropServices.NFloat>, System.Numerics.IFloatingPointIeee754<System.Runtime.InteropServices.NFloat>, System.IFormattable, System.Numerics.IHyperbolicFunctions<System.Runtime.InteropServices.NFloat>, System.Numerics.IIncrementOperators<System.Runtime.InteropServices.NFloat>, System.Numerics.ILogarithmicFunctions<System.Runtime.InteropServices.NFloat>, System.Numerics.IMinMaxValue<System.Runtime.InteropServices.NFloat>, System.Numerics.IModulusOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>, System.Numerics.IMultiplicativeIdentity<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>, System.Numerics.IMultiplyOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>, System.Numerics.INumber<System.Runtime.InteropServices.NFloat>, System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>, System.IParsable<System.Runtime.InteropServices.NFloat>, System.Numerics.IPowerFunctions<System.Runtime.InteropServices.NFloat>, System.Numerics.IRootFunctions<System.Runtime.InteropServices.NFloat>, System.Numerics.ISignedNumber<System.Runtime.InteropServices.NFloat>, System.ISpanFormattable, System.ISpanParsable<System.Runtime.InteropServices.NFloat>, System.Numerics.ISubtractionOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>, System.Numerics.ITrigonometricFunctions<System.Runtime.InteropServices.NFloat>, System.Numerics.IUnaryNegationOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>, System.Numerics.IUnaryPlusOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>, System.IUtf8SpanFormattable, System.IUtf8SpanParsable<System.Runtime.InteropServices.NFloat>
            {
                static System.Runtime.InteropServices.NFloat System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.Abs(System.Runtime.InteropServices.NFloat value) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.ITrigonometricFunctions<System.Runtime.InteropServices.NFloat>.Acos(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IHyperbolicFunctions<System.Runtime.InteropServices.NFloat>.Acosh(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.ITrigonometricFunctions<System.Runtime.InteropServices.NFloat>.AcosPi(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IAdditiveIdentity<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>.AdditiveIdentity { get => throw null; }
                static System.Runtime.InteropServices.NFloat System.Numerics.IBinaryNumber<System.Runtime.InteropServices.NFloat>.AllBitsSet { get => throw null; }
                static System.Runtime.InteropServices.NFloat System.Numerics.ITrigonometricFunctions<System.Runtime.InteropServices.NFloat>.Asin(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IHyperbolicFunctions<System.Runtime.InteropServices.NFloat>.Asinh(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.ITrigonometricFunctions<System.Runtime.InteropServices.NFloat>.AsinPi(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.ITrigonometricFunctions<System.Runtime.InteropServices.NFloat>.Atan(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IFloatingPointIeee754<System.Runtime.InteropServices.NFloat>.Atan2(System.Runtime.InteropServices.NFloat y, System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IFloatingPointIeee754<System.Runtime.InteropServices.NFloat>.Atan2Pi(System.Runtime.InteropServices.NFloat y, System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IHyperbolicFunctions<System.Runtime.InteropServices.NFloat>.Atanh(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.ITrigonometricFunctions<System.Runtime.InteropServices.NFloat>.AtanPi(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IFloatingPointIeee754<System.Runtime.InteropServices.NFloat>.BitDecrement(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IFloatingPointIeee754<System.Runtime.InteropServices.NFloat>.BitIncrement(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IRootFunctions<System.Runtime.InteropServices.NFloat>.Cbrt(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IFloatingPoint<System.Runtime.InteropServices.NFloat>.Ceiling(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.INumber<System.Runtime.InteropServices.NFloat>.Clamp(System.Runtime.InteropServices.NFloat value, System.Runtime.InteropServices.NFloat min, System.Runtime.InteropServices.NFloat max) => throw null;
                public int CompareTo(object obj) => throw null;
                public int CompareTo(System.Runtime.InteropServices.NFloat other) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.INumber<System.Runtime.InteropServices.NFloat>.CopySign(System.Runtime.InteropServices.NFloat value, System.Runtime.InteropServices.NFloat sign) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.ITrigonometricFunctions<System.Runtime.InteropServices.NFloat>.Cos(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IHyperbolicFunctions<System.Runtime.InteropServices.NFloat>.Cosh(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.ITrigonometricFunctions<System.Runtime.InteropServices.NFloat>.CosPi(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.CreateChecked<TOther>(TOther value) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.CreateSaturating<TOther>(TOther value) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.CreateTruncating<TOther>(TOther value) => throw null;
                public NFloat(double value) => throw null;
                public NFloat(float value) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.ITrigonometricFunctions<System.Runtime.InteropServices.NFloat>.DegreesToRadians(System.Runtime.InteropServices.NFloat degrees) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IFloatingPointConstants<System.Runtime.InteropServices.NFloat>.E { get => throw null; }
                static System.Runtime.InteropServices.NFloat System.Numerics.IFloatingPointIeee754<System.Runtime.InteropServices.NFloat>.Epsilon { get => throw null; }
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Runtime.InteropServices.NFloat other) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IExponentialFunctions<System.Runtime.InteropServices.NFloat>.Exp(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IExponentialFunctions<System.Runtime.InteropServices.NFloat>.Exp10(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IExponentialFunctions<System.Runtime.InteropServices.NFloat>.Exp10M1(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IExponentialFunctions<System.Runtime.InteropServices.NFloat>.Exp2(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IExponentialFunctions<System.Runtime.InteropServices.NFloat>.Exp2M1(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IExponentialFunctions<System.Runtime.InteropServices.NFloat>.ExpM1(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IFloatingPoint<System.Runtime.InteropServices.NFloat>.Floor(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IFloatingPointIeee754<System.Runtime.InteropServices.NFloat>.FusedMultiplyAdd(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right, System.Runtime.InteropServices.NFloat addend) => throw null;
                int System.Numerics.IFloatingPoint<System.Runtime.InteropServices.NFloat>.GetExponentByteCount() => throw null;
                int System.Numerics.IFloatingPoint<System.Runtime.InteropServices.NFloat>.GetExponentShortestBitLength() => throw null;
                public override int GetHashCode() => throw null;
                int System.Numerics.IFloatingPoint<System.Runtime.InteropServices.NFloat>.GetSignificandBitLength() => throw null;
                int System.Numerics.IFloatingPoint<System.Runtime.InteropServices.NFloat>.GetSignificandByteCount() => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IRootFunctions<System.Runtime.InteropServices.NFloat>.Hypot(System.Runtime.InteropServices.NFloat x, System.Runtime.InteropServices.NFloat y) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IFloatingPointIeee754<System.Runtime.InteropServices.NFloat>.Ieee754Remainder(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right) => throw null;
                static int System.Numerics.IFloatingPointIeee754<System.Runtime.InteropServices.NFloat>.ILogB(System.Runtime.InteropServices.NFloat x) => throw null;
                static bool System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.IsCanonical(System.Runtime.InteropServices.NFloat value) => throw null;
                static bool System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.IsComplexNumber(System.Runtime.InteropServices.NFloat value) => throw null;
                static bool System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.IsEvenInteger(System.Runtime.InteropServices.NFloat value) => throw null;
                static bool System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.IsFinite(System.Runtime.InteropServices.NFloat value) => throw null;
                static bool System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.IsImaginaryNumber(System.Runtime.InteropServices.NFloat value) => throw null;
                static bool System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.IsInfinity(System.Runtime.InteropServices.NFloat value) => throw null;
                static bool System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.IsInteger(System.Runtime.InteropServices.NFloat value) => throw null;
                static bool System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.IsNaN(System.Runtime.InteropServices.NFloat value) => throw null;
                static bool System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.IsNegative(System.Runtime.InteropServices.NFloat value) => throw null;
                static bool System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.IsNegativeInfinity(System.Runtime.InteropServices.NFloat value) => throw null;
                static bool System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.IsNormal(System.Runtime.InteropServices.NFloat value) => throw null;
                static bool System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.IsOddInteger(System.Runtime.InteropServices.NFloat value) => throw null;
                static bool System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.IsPositive(System.Runtime.InteropServices.NFloat value) => throw null;
                static bool System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.IsPositiveInfinity(System.Runtime.InteropServices.NFloat value) => throw null;
                static bool System.Numerics.IBinaryNumber<System.Runtime.InteropServices.NFloat>.IsPow2(System.Runtime.InteropServices.NFloat value) => throw null;
                static bool System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.IsRealNumber(System.Runtime.InteropServices.NFloat value) => throw null;
                static bool System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.IsSubnormal(System.Runtime.InteropServices.NFloat value) => throw null;
                static bool System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.IsZero(System.Runtime.InteropServices.NFloat value) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IFloatingPointIeee754<System.Runtime.InteropServices.NFloat>.Lerp(System.Runtime.InteropServices.NFloat value1, System.Runtime.InteropServices.NFloat value2, System.Runtime.InteropServices.NFloat amount) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.ILogarithmicFunctions<System.Runtime.InteropServices.NFloat>.Log(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.ILogarithmicFunctions<System.Runtime.InteropServices.NFloat>.Log(System.Runtime.InteropServices.NFloat x, System.Runtime.InteropServices.NFloat newBase) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.ILogarithmicFunctions<System.Runtime.InteropServices.NFloat>.Log10(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.ILogarithmicFunctions<System.Runtime.InteropServices.NFloat>.Log10P1(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IBinaryNumber<System.Runtime.InteropServices.NFloat>.Log2(System.Runtime.InteropServices.NFloat value) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.ILogarithmicFunctions<System.Runtime.InteropServices.NFloat>.Log2(System.Runtime.InteropServices.NFloat value) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.ILogarithmicFunctions<System.Runtime.InteropServices.NFloat>.Log2P1(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.ILogarithmicFunctions<System.Runtime.InteropServices.NFloat>.LogP1(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.INumber<System.Runtime.InteropServices.NFloat>.Max(System.Runtime.InteropServices.NFloat x, System.Runtime.InteropServices.NFloat y) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.MaxMagnitude(System.Runtime.InteropServices.NFloat x, System.Runtime.InteropServices.NFloat y) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.MaxMagnitudeNumber(System.Runtime.InteropServices.NFloat x, System.Runtime.InteropServices.NFloat y) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.INumber<System.Runtime.InteropServices.NFloat>.MaxNumber(System.Runtime.InteropServices.NFloat x, System.Runtime.InteropServices.NFloat y) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IMinMaxValue<System.Runtime.InteropServices.NFloat>.MaxValue { get => throw null; }
                static System.Runtime.InteropServices.NFloat System.Numerics.INumber<System.Runtime.InteropServices.NFloat>.Min(System.Runtime.InteropServices.NFloat x, System.Runtime.InteropServices.NFloat y) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.MinMagnitude(System.Runtime.InteropServices.NFloat x, System.Runtime.InteropServices.NFloat y) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.MinMagnitudeNumber(System.Runtime.InteropServices.NFloat x, System.Runtime.InteropServices.NFloat y) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.INumber<System.Runtime.InteropServices.NFloat>.MinNumber(System.Runtime.InteropServices.NFloat x, System.Runtime.InteropServices.NFloat y) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IMinMaxValue<System.Runtime.InteropServices.NFloat>.MinValue { get => throw null; }
                static System.Runtime.InteropServices.NFloat System.Numerics.IMultiplicativeIdentity<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>.MultiplicativeIdentity { get => throw null; }
                static System.Runtime.InteropServices.NFloat System.Numerics.IFloatingPointIeee754<System.Runtime.InteropServices.NFloat>.NaN { get => throw null; }
                static System.Runtime.InteropServices.NFloat System.Numerics.IFloatingPointIeee754<System.Runtime.InteropServices.NFloat>.NegativeInfinity { get => throw null; }
                static System.Runtime.InteropServices.NFloat System.Numerics.ISignedNumber<System.Runtime.InteropServices.NFloat>.NegativeOne { get => throw null; }
                static System.Runtime.InteropServices.NFloat System.Numerics.IFloatingPointIeee754<System.Runtime.InteropServices.NFloat>.NegativeZero { get => throw null; }
                static System.Runtime.InteropServices.NFloat System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.One { get => throw null; }
                static System.Runtime.InteropServices.NFloat System.Numerics.IAdditionOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>.operator +(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IBitwiseOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>.operator &(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IBitwiseOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>.operator |(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IAdditionOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>.operator checked +(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IDecrementOperators<System.Runtime.InteropServices.NFloat>.operator checked --(System.Runtime.InteropServices.NFloat value) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IDivisionOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>.operator checked /(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right) => throw null;
                public static explicit operator checked byte(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator checked char(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator checked short(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator checked int(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator checked long(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator checked System.Int128(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator checked nint(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator checked sbyte(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator checked ushort(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator checked uint(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator checked ulong(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator checked System.UInt128(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator checked nuint(System.Runtime.InteropServices.NFloat value) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IIncrementOperators<System.Runtime.InteropServices.NFloat>.operator checked ++(System.Runtime.InteropServices.NFloat value) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IMultiplyOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>.operator checked *(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.ISubtractionOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>.operator checked -(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IUnaryNegationOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>.operator checked -(System.Runtime.InteropServices.NFloat value) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IDecrementOperators<System.Runtime.InteropServices.NFloat>.operator --(System.Runtime.InteropServices.NFloat value) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IDivisionOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>.operator /(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right) => throw null;
                static bool System.Numerics.IEqualityOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, bool>.operator ==(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IBitwiseOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>.operator ^(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right) => throw null;
                public static explicit operator System.Runtime.InteropServices.NFloat(decimal value) => throw null;
                public static explicit operator System.Runtime.InteropServices.NFloat(double value) => throw null;
                public static explicit operator System.Runtime.InteropServices.NFloat(System.Int128 value) => throw null;
                public static explicit operator byte(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator char(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator decimal(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator System.Half(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator System.Int128(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator short(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator int(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator long(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator nint(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator sbyte(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator float(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator System.UInt128(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator ushort(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator uint(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator ulong(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator nuint(System.Runtime.InteropServices.NFloat value) => throw null;
                public static explicit operator System.Runtime.InteropServices.NFloat(System.UInt128 value) => throw null;
                static bool System.Numerics.IComparisonOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, bool>.operator >(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right) => throw null;
                static bool System.Numerics.IComparisonOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, bool>.operator >=(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right) => throw null;
                public static implicit operator System.Runtime.InteropServices.NFloat(byte value) => throw null;
                public static implicit operator System.Runtime.InteropServices.NFloat(char value) => throw null;
                public static implicit operator System.Runtime.InteropServices.NFloat(short value) => throw null;
                public static implicit operator System.Runtime.InteropServices.NFloat(int value) => throw null;
                public static implicit operator System.Runtime.InteropServices.NFloat(long value) => throw null;
                public static implicit operator System.Runtime.InteropServices.NFloat(nint value) => throw null;
                public static implicit operator System.Runtime.InteropServices.NFloat(System.Half value) => throw null;
                public static implicit operator double(System.Runtime.InteropServices.NFloat value) => throw null;
                public static implicit operator System.Runtime.InteropServices.NFloat(sbyte value) => throw null;
                public static implicit operator System.Runtime.InteropServices.NFloat(float value) => throw null;
                public static implicit operator System.Runtime.InteropServices.NFloat(ushort value) => throw null;
                public static implicit operator System.Runtime.InteropServices.NFloat(uint value) => throw null;
                public static implicit operator System.Runtime.InteropServices.NFloat(ulong value) => throw null;
                public static implicit operator System.Runtime.InteropServices.NFloat(nuint value) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IIncrementOperators<System.Runtime.InteropServices.NFloat>.operator ++(System.Runtime.InteropServices.NFloat value) => throw null;
                static bool System.Numerics.IEqualityOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, bool>.operator !=(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right) => throw null;
                static bool System.Numerics.IComparisonOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, bool>.operator <(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right) => throw null;
                static bool System.Numerics.IComparisonOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, bool>.operator <=(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IModulusOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>.operator %(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IMultiplyOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>.operator *(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IBitwiseOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>.operator ~(System.Runtime.InteropServices.NFloat value) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.ISubtractionOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>.operator -(System.Runtime.InteropServices.NFloat left, System.Runtime.InteropServices.NFloat right) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IUnaryNegationOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>.operator -(System.Runtime.InteropServices.NFloat value) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IUnaryPlusOperators<System.Runtime.InteropServices.NFloat, System.Runtime.InteropServices.NFloat>.operator +(System.Runtime.InteropServices.NFloat value) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.Parse(System.ReadOnlySpan<byte> utf8Text, System.Globalization.NumberStyles style = default(System.Globalization.NumberStyles), System.IFormatProvider provider = default(System.IFormatProvider)) => throw null;
                static System.Runtime.InteropServices.NFloat System.IUtf8SpanParsable<System.Runtime.InteropServices.NFloat>.Parse(System.ReadOnlySpan<byte> utf8Text, System.IFormatProvider provider) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.Parse(System.ReadOnlySpan<char> s, System.Globalization.NumberStyles style = default(System.Globalization.NumberStyles), System.IFormatProvider provider = default(System.IFormatProvider)) => throw null;
                static System.Runtime.InteropServices.NFloat System.ISpanParsable<System.Runtime.InteropServices.NFloat>.Parse(System.ReadOnlySpan<char> s, System.IFormatProvider provider) => throw null;
                public static System.Runtime.InteropServices.NFloat Parse(string s) => throw null;
                public static System.Runtime.InteropServices.NFloat Parse(string s, System.Globalization.NumberStyles style) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.Parse(string s, System.Globalization.NumberStyles style, System.IFormatProvider provider) => throw null;
                static System.Runtime.InteropServices.NFloat System.IParsable<System.Runtime.InteropServices.NFloat>.Parse(string s, System.IFormatProvider provider) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IFloatingPointConstants<System.Runtime.InteropServices.NFloat>.Pi { get => throw null; }
                static System.Runtime.InteropServices.NFloat System.Numerics.IFloatingPointIeee754<System.Runtime.InteropServices.NFloat>.PositiveInfinity { get => throw null; }
                static System.Runtime.InteropServices.NFloat System.Numerics.IPowerFunctions<System.Runtime.InteropServices.NFloat>.Pow(System.Runtime.InteropServices.NFloat x, System.Runtime.InteropServices.NFloat y) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.ITrigonometricFunctions<System.Runtime.InteropServices.NFloat>.RadiansToDegrees(System.Runtime.InteropServices.NFloat radians) => throw null;
                static int System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.Radix { get => throw null; }
                static System.Runtime.InteropServices.NFloat System.Numerics.IFloatingPointIeee754<System.Runtime.InteropServices.NFloat>.ReciprocalEstimate(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IFloatingPointIeee754<System.Runtime.InteropServices.NFloat>.ReciprocalSqrtEstimate(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IRootFunctions<System.Runtime.InteropServices.NFloat>.RootN(System.Runtime.InteropServices.NFloat x, int n) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IFloatingPoint<System.Runtime.InteropServices.NFloat>.Round(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IFloatingPoint<System.Runtime.InteropServices.NFloat>.Round(System.Runtime.InteropServices.NFloat x, int digits) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IFloatingPoint<System.Runtime.InteropServices.NFloat>.Round(System.Runtime.InteropServices.NFloat x, int digits, System.MidpointRounding mode) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IFloatingPoint<System.Runtime.InteropServices.NFloat>.Round(System.Runtime.InteropServices.NFloat x, System.MidpointRounding mode) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IFloatingPointIeee754<System.Runtime.InteropServices.NFloat>.ScaleB(System.Runtime.InteropServices.NFloat x, int n) => throw null;
                static int System.Numerics.INumber<System.Runtime.InteropServices.NFloat>.Sign(System.Runtime.InteropServices.NFloat value) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.ITrigonometricFunctions<System.Runtime.InteropServices.NFloat>.Sin(System.Runtime.InteropServices.NFloat x) => throw null;
                static (System.Runtime.InteropServices.NFloat Sin, System.Runtime.InteropServices.NFloat Cos) System.Numerics.ITrigonometricFunctions<System.Runtime.InteropServices.NFloat>.SinCos(System.Runtime.InteropServices.NFloat x) => throw null;
                static (System.Runtime.InteropServices.NFloat SinPi, System.Runtime.InteropServices.NFloat CosPi) System.Numerics.ITrigonometricFunctions<System.Runtime.InteropServices.NFloat>.SinCosPi(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IHyperbolicFunctions<System.Runtime.InteropServices.NFloat>.Sinh(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.ITrigonometricFunctions<System.Runtime.InteropServices.NFloat>.SinPi(System.Runtime.InteropServices.NFloat x) => throw null;
                public static int Size { get => throw null; }
                static System.Runtime.InteropServices.NFloat System.Numerics.IRootFunctions<System.Runtime.InteropServices.NFloat>.Sqrt(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.ITrigonometricFunctions<System.Runtime.InteropServices.NFloat>.Tan(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IHyperbolicFunctions<System.Runtime.InteropServices.NFloat>.Tanh(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.ITrigonometricFunctions<System.Runtime.InteropServices.NFloat>.TanPi(System.Runtime.InteropServices.NFloat x) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IFloatingPointConstants<System.Runtime.InteropServices.NFloat>.Tau { get => throw null; }
                public override string ToString() => throw null;
                public string ToString(System.IFormatProvider provider) => throw null;
                public string ToString(string format) => throw null;
                public string ToString(string format, System.IFormatProvider provider) => throw null;
                static System.Runtime.InteropServices.NFloat System.Numerics.IFloatingPoint<System.Runtime.InteropServices.NFloat>.Truncate(System.Runtime.InteropServices.NFloat x) => throw null;
                static bool System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.TryConvertFromChecked<TOther>(TOther value, out System.Runtime.InteropServices.NFloat result) => throw null;
                static bool System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.TryConvertFromSaturating<TOther>(TOther value, out System.Runtime.InteropServices.NFloat result) => throw null;
                static bool System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.TryConvertFromTruncating<TOther>(TOther value, out System.Runtime.InteropServices.NFloat result) => throw null;
                static bool System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.TryConvertToChecked<TOther>(System.Runtime.InteropServices.NFloat value, out TOther result) => throw null;
                static bool System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.TryConvertToSaturating<TOther>(System.Runtime.InteropServices.NFloat value, out TOther result) => throw null;
                static bool System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.TryConvertToTruncating<TOther>(System.Runtime.InteropServices.NFloat value, out TOther result) => throw null;
                public bool TryFormat(System.Span<char> destination, out int charsWritten, System.ReadOnlySpan<char> format = default(System.ReadOnlySpan<char>), System.IFormatProvider provider = default(System.IFormatProvider)) => throw null;
                public bool TryFormat(System.Span<byte> utf8Destination, out int bytesWritten, System.ReadOnlySpan<char> format = default(System.ReadOnlySpan<char>), System.IFormatProvider provider = default(System.IFormatProvider)) => throw null;
                static bool System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.TryParse(System.ReadOnlySpan<byte> utf8Text, System.Globalization.NumberStyles style, System.IFormatProvider provider, out System.Runtime.InteropServices.NFloat result) => throw null;
                static bool System.IUtf8SpanParsable<System.Runtime.InteropServices.NFloat>.TryParse(System.ReadOnlySpan<byte> utf8Text, System.IFormatProvider provider, out System.Runtime.InteropServices.NFloat result) => throw null;
                public static bool TryParse(System.ReadOnlySpan<byte> utf8Text, out System.Runtime.InteropServices.NFloat result) => throw null;
                static bool System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.TryParse(System.ReadOnlySpan<char> s, System.Globalization.NumberStyles style, System.IFormatProvider provider, out System.Runtime.InteropServices.NFloat result) => throw null;
                static bool System.ISpanParsable<System.Runtime.InteropServices.NFloat>.TryParse(System.ReadOnlySpan<char> s, System.IFormatProvider provider, out System.Runtime.InteropServices.NFloat result) => throw null;
                public static bool TryParse(System.ReadOnlySpan<char> s, out System.Runtime.InteropServices.NFloat result) => throw null;
                static bool System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.TryParse(string s, System.Globalization.NumberStyles style, System.IFormatProvider provider, out System.Runtime.InteropServices.NFloat result) => throw null;
                static bool System.IParsable<System.Runtime.InteropServices.NFloat>.TryParse(string s, System.IFormatProvider provider, out System.Runtime.InteropServices.NFloat result) => throw null;
                public static bool TryParse(string s, out System.Runtime.InteropServices.NFloat result) => throw null;
                bool System.Numerics.IFloatingPoint<System.Runtime.InteropServices.NFloat>.TryWriteExponentBigEndian(System.Span<byte> destination, out int bytesWritten) => throw null;
                bool System.Numerics.IFloatingPoint<System.Runtime.InteropServices.NFloat>.TryWriteExponentLittleEndian(System.Span<byte> destination, out int bytesWritten) => throw null;
                bool System.Numerics.IFloatingPoint<System.Runtime.InteropServices.NFloat>.TryWriteSignificandBigEndian(System.Span<byte> destination, out int bytesWritten) => throw null;
                bool System.Numerics.IFloatingPoint<System.Runtime.InteropServices.NFloat>.TryWriteSignificandLittleEndian(System.Span<byte> destination, out int bytesWritten) => throw null;
                public double Value { get => throw null; }
                static System.Runtime.InteropServices.NFloat System.Numerics.INumberBase<System.Runtime.InteropServices.NFloat>.Zero { get => throw null; }
            }
            namespace ObjectiveC
            {
                public static class ObjectiveCMarshal
                {
                    public static System.Runtime.InteropServices.GCHandle CreateReferenceTrackingHandle(object obj, out System.Span<nint> taggedMemory) => throw null;
                    public static unsafe void Initialize(delegate* unmanaged<void> beginEndCallback, delegate* unmanaged<nint, int> isReferencedCallback, delegate* unmanaged<nint, void> trackedObjectEnteredFinalization, System.Runtime.InteropServices.ObjectiveC.ObjectiveCMarshal.UnhandledExceptionPropagationHandler unhandledExceptionPropagationHandler) => throw null;
                    public enum MessageSendFunction
                    {
                        MsgSend = 0,
                        MsgSendFpret = 1,
                        MsgSendStret = 2,
                        MsgSendSuper = 3,
                        MsgSendSuperStret = 4,
                    }
                    public static void SetMessageSendCallback(System.Runtime.InteropServices.ObjectiveC.ObjectiveCMarshal.MessageSendFunction msgSendFunction, nint func) => throw null;
                    public static void SetMessageSendPendingException(System.Exception exception) => throw null;
                    public unsafe delegate delegate* unmanaged<nint, void> UnhandledExceptionPropagationHandler(System.Exception exception, System.RuntimeMethodHandle lastMethod, out nint context);
                }
                [System.AttributeUsage((System.AttributeTargets)4, Inherited = true, AllowMultiple = false)]
                public sealed class ObjectiveCTrackedTypeAttribute : System.Attribute
                {
                    public ObjectiveCTrackedTypeAttribute() => throw null;
                }
            }
            [System.AttributeUsage((System.AttributeTargets)2048, Inherited = false)]
            public sealed class OptionalAttribute : System.Attribute
            {
                public OptionalAttribute() => throw null;
            }
            public enum PosixSignal
            {
                SIGTSTP = -10,
                SIGTTOU = -9,
                SIGTTIN = -8,
                SIGWINCH = -7,
                SIGCONT = -6,
                SIGCHLD = -5,
                SIGTERM = -4,
                SIGQUIT = -3,
                SIGINT = -2,
                SIGHUP = -1,
            }
            public sealed class PosixSignalContext
            {
                public bool Cancel { get => throw null; set { } }
                public PosixSignalContext(System.Runtime.InteropServices.PosixSignal signal) => throw null;
                public System.Runtime.InteropServices.PosixSignal Signal { get => throw null; }
            }
            public sealed class PosixSignalRegistration : System.IDisposable
            {
                public static System.Runtime.InteropServices.PosixSignalRegistration Create(System.Runtime.InteropServices.PosixSignal signal, System.Action<System.Runtime.InteropServices.PosixSignalContext> handler) => throw null;
                public void Dispose() => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)64, Inherited = false)]
            public sealed class PreserveSigAttribute : System.Attribute
            {
                public PreserveSigAttribute() => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)1, Inherited = false, AllowMultiple = true)]
            public sealed class PrimaryInteropAssemblyAttribute : System.Attribute
            {
                public PrimaryInteropAssemblyAttribute(int major, int minor) => throw null;
                public int MajorVersion { get => throw null; }
                public int MinorVersion { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)4, Inherited = false)]
            public sealed class ProgIdAttribute : System.Attribute
            {
                public ProgIdAttribute(string progId) => throw null;
                public string Value { get => throw null; }
            }
            public static class RuntimeEnvironment
            {
                public static bool FromGlobalAccessCache(System.Reflection.Assembly a) => throw null;
                public static string GetRuntimeDirectory() => throw null;
                public static nint GetRuntimeInterfaceAsIntPtr(System.Guid clsid, System.Guid riid) => throw null;
                public static object GetRuntimeInterfaceAsObject(System.Guid clsid, System.Guid riid) => throw null;
                public static string GetSystemVersion() => throw null;
                public static string SystemConfigurationFile { get => throw null; }
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
            public class SEHException : System.Runtime.InteropServices.ExternalException
            {
                public virtual bool CanResume() => throw null;
                public SEHException() => throw null;
                protected SEHException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public SEHException(string message) => throw null;
                public SEHException(string message, System.Exception inner) => throw null;
            }
            public class StandardOleMarshalObject : System.MarshalByRefObject
            {
                protected StandardOleMarshalObject() => throw null;
            }
            public enum StringMarshalling
            {
                Custom = 0,
                Utf8 = 1,
                Utf16 = 2,
            }
            [System.AttributeUsage((System.AttributeTargets)5144, AllowMultiple = false, Inherited = false)]
            public sealed class TypeIdentifierAttribute : System.Attribute
            {
                public TypeIdentifierAttribute() => throw null;
                public TypeIdentifierAttribute(string scope, string identifier) => throw null;
                public string Identifier { get => throw null; }
                public string Scope { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)64, Inherited = false)]
            public sealed class TypeLibFuncAttribute : System.Attribute
            {
                public TypeLibFuncAttribute(short flags) => throw null;
                public TypeLibFuncAttribute(System.Runtime.InteropServices.TypeLibFuncFlags flags) => throw null;
                public System.Runtime.InteropServices.TypeLibFuncFlags Value { get => throw null; }
            }
            [System.Flags]
            public enum TypeLibFuncFlags
            {
                FRestricted = 1,
                FSource = 2,
                FBindable = 4,
                FRequestEdit = 8,
                FDisplayBind = 16,
                FDefaultBind = 32,
                FHidden = 64,
                FUsesGetLastError = 128,
                FDefaultCollelem = 256,
                FUiDefault = 512,
                FNonBrowsable = 1024,
                FReplaceable = 2048,
                FImmediateBind = 4096,
            }
            [System.AttributeUsage((System.AttributeTargets)1024, Inherited = false)]
            public sealed class TypeLibImportClassAttribute : System.Attribute
            {
                public TypeLibImportClassAttribute(System.Type importClass) => throw null;
                public string Value { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)1052, Inherited = false)]
            public sealed class TypeLibTypeAttribute : System.Attribute
            {
                public TypeLibTypeAttribute(short flags) => throw null;
                public TypeLibTypeAttribute(System.Runtime.InteropServices.TypeLibTypeFlags flags) => throw null;
                public System.Runtime.InteropServices.TypeLibTypeFlags Value { get => throw null; }
            }
            [System.Flags]
            public enum TypeLibTypeFlags
            {
                FAppObject = 1,
                FCanCreate = 2,
                FLicensed = 4,
                FPreDeclId = 8,
                FHidden = 16,
                FControl = 32,
                FDual = 64,
                FNonExtensible = 128,
                FOleAutomation = 256,
                FRestricted = 512,
                FAggregatable = 1024,
                FReplaceable = 2048,
                FDispatchable = 4096,
                FReverseBind = 8192,
            }
            [System.AttributeUsage((System.AttributeTargets)256, Inherited = false)]
            public sealed class TypeLibVarAttribute : System.Attribute
            {
                public TypeLibVarAttribute(short flags) => throw null;
                public TypeLibVarAttribute(System.Runtime.InteropServices.TypeLibVarFlags flags) => throw null;
                public System.Runtime.InteropServices.TypeLibVarFlags Value { get => throw null; }
            }
            [System.Flags]
            public enum TypeLibVarFlags
            {
                FReadOnly = 1,
                FSource = 2,
                FBindable = 4,
                FRequestEdit = 8,
                FDisplayBind = 16,
                FDefaultBind = 32,
                FHidden = 64,
                FRestricted = 128,
                FDefaultCollelem = 256,
                FUiDefault = 512,
                FNonBrowsable = 1024,
                FReplaceable = 2048,
                FImmediateBind = 4096,
            }
            [System.AttributeUsage((System.AttributeTargets)1, Inherited = false)]
            public sealed class TypeLibVersionAttribute : System.Attribute
            {
                public TypeLibVersionAttribute(int major, int minor) => throw null;
                public int MajorVersion { get => throw null; }
                public int MinorVersion { get => throw null; }
            }
            public sealed class UnknownWrapper
            {
                public UnknownWrapper(object obj) => throw null;
                public object WrappedObject { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)64, AllowMultiple = false, Inherited = false)]
            public sealed class UnmanagedCallConvAttribute : System.Attribute
            {
                public System.Type[] CallConvs;
                public UnmanagedCallConvAttribute() => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)64, Inherited = false)]
            public sealed class UnmanagedCallersOnlyAttribute : System.Attribute
            {
                public System.Type[] CallConvs;
                public UnmanagedCallersOnlyAttribute() => throw null;
                public string EntryPoint;
            }
            [System.AttributeUsage((System.AttributeTargets)4096, AllowMultiple = false, Inherited = false)]
            public sealed class UnmanagedFunctionPointerAttribute : System.Attribute
            {
                public bool BestFitMapping;
                public System.Runtime.InteropServices.CallingConvention CallingConvention { get => throw null; }
                public System.Runtime.InteropServices.CharSet CharSet;
                public UnmanagedFunctionPointerAttribute(System.Runtime.InteropServices.CallingConvention callingConvention) => throw null;
                public bool SetLastError;
                public bool ThrowOnUnmappableChar;
            }
            public enum VarEnum
            {
                VT_EMPTY = 0,
                VT_NULL = 1,
                VT_I2 = 2,
                VT_I4 = 3,
                VT_R4 = 4,
                VT_R8 = 5,
                VT_CY = 6,
                VT_DATE = 7,
                VT_BSTR = 8,
                VT_DISPATCH = 9,
                VT_ERROR = 10,
                VT_BOOL = 11,
                VT_VARIANT = 12,
                VT_UNKNOWN = 13,
                VT_DECIMAL = 14,
                VT_I1 = 16,
                VT_UI1 = 17,
                VT_UI2 = 18,
                VT_UI4 = 19,
                VT_I8 = 20,
                VT_UI8 = 21,
                VT_INT = 22,
                VT_UINT = 23,
                VT_VOID = 24,
                VT_HRESULT = 25,
                VT_PTR = 26,
                VT_SAFEARRAY = 27,
                VT_CARRAY = 28,
                VT_USERDEFINED = 29,
                VT_LPSTR = 30,
                VT_LPWSTR = 31,
                VT_RECORD = 36,
                VT_FILETIME = 64,
                VT_BLOB = 65,
                VT_STREAM = 66,
                VT_STORAGE = 67,
                VT_STREAMED_OBJECT = 68,
                VT_STORED_OBJECT = 69,
                VT_BLOB_OBJECT = 70,
                VT_CF = 71,
                VT_CLSID = 72,
                VT_VECTOR = 4096,
                VT_ARRAY = 8192,
                VT_BYREF = 16384,
            }
            public sealed class VariantWrapper
            {
                public VariantWrapper(object obj) => throw null;
                public object WrappedObject { get => throw null; }
            }
        }
    }
    namespace Security
    {
        public sealed class SecureString : System.IDisposable
        {
            public void AppendChar(char c) => throw null;
            public void Clear() => throw null;
            public System.Security.SecureString Copy() => throw null;
            public SecureString() => throw null;
            public unsafe SecureString(char* value, int length) => throw null;
            public void Dispose() => throw null;
            public void InsertAt(int index, char c) => throw null;
            public bool IsReadOnly() => throw null;
            public int Length { get => throw null; }
            public void MakeReadOnly() => throw null;
            public void RemoveAt(int index) => throw null;
            public void SetAt(int index, char c) => throw null;
        }
        public static class SecureStringMarshal
        {
            public static nint SecureStringToCoTaskMemAnsi(System.Security.SecureString s) => throw null;
            public static nint SecureStringToCoTaskMemUnicode(System.Security.SecureString s) => throw null;
            public static nint SecureStringToGlobalAllocAnsi(System.Security.SecureString s) => throw null;
            public static nint SecureStringToGlobalAllocUnicode(System.Security.SecureString s) => throw null;
        }
    }
}
