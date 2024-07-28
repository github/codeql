// This file contains auto-generated code.
// Generated from `System.Reflection.Metadata, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace Reflection
    {
        [System.Flags]
        public enum AssemblyFlags
        {
            PublicKey = 1,
            Retargetable = 256,
            WindowsRuntime = 512,
            ContentTypeMask = 3584,
            DisableJitCompileOptimizer = 16384,
            EnableJitCompileTracking = 32768,
        }
        public enum AssemblyHashAlgorithm
        {
            None = 0,
            MD5 = 32771,
            Sha1 = 32772,
            Sha256 = 32780,
            Sha384 = 32781,
            Sha512 = 32782,
        }
        public enum DeclarativeSecurityAction : short
        {
            None = 0,
            Demand = 2,
            Assert = 3,
            Deny = 4,
            PermitOnly = 5,
            LinkDemand = 6,
            InheritanceDemand = 7,
            RequestMinimum = 8,
            RequestOptional = 9,
            RequestRefuse = 10,
        }
        [System.Flags]
        public enum ManifestResourceAttributes
        {
            Public = 1,
            Private = 2,
            VisibilityMask = 7,
        }
        namespace Metadata
        {
            public struct ArrayShape
            {
                public ArrayShape(int rank, System.Collections.Immutable.ImmutableArray<int> sizes, System.Collections.Immutable.ImmutableArray<int> lowerBounds) => throw null;
                public System.Collections.Immutable.ImmutableArray<int> LowerBounds { get => throw null; }
                public int Rank { get => throw null; }
                public System.Collections.Immutable.ImmutableArray<int> Sizes { get => throw null; }
            }
            public struct AssemblyDefinition
            {
                public System.Reflection.Metadata.StringHandle Culture { get => throw null; }
                public System.Reflection.AssemblyFlags Flags { get => throw null; }
                public System.Reflection.AssemblyName GetAssemblyName() => throw null;
                public System.Reflection.Metadata.CustomAttributeHandleCollection GetCustomAttributes() => throw null;
                public System.Reflection.Metadata.DeclarativeSecurityAttributeHandleCollection GetDeclarativeSecurityAttributes() => throw null;
                public System.Reflection.AssemblyHashAlgorithm HashAlgorithm { get => throw null; }
                public System.Reflection.Metadata.StringHandle Name { get => throw null; }
                public System.Reflection.Metadata.BlobHandle PublicKey { get => throw null; }
                public System.Version Version { get => throw null; }
            }
            public struct AssemblyDefinitionHandle : System.IEquatable<System.Reflection.Metadata.AssemblyDefinitionHandle>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.AssemblyDefinitionHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.AssemblyDefinitionHandle left, System.Reflection.Metadata.AssemblyDefinitionHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.AssemblyDefinitionHandle(System.Reflection.Metadata.EntityHandle handle) => throw null;
                public static explicit operator System.Reflection.Metadata.AssemblyDefinitionHandle(System.Reflection.Metadata.Handle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.EntityHandle(System.Reflection.Metadata.AssemblyDefinitionHandle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.Handle(System.Reflection.Metadata.AssemblyDefinitionHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.AssemblyDefinitionHandle left, System.Reflection.Metadata.AssemblyDefinitionHandle right) => throw null;
            }
            public struct AssemblyFile
            {
                public bool ContainsMetadata { get => throw null; }
                public System.Reflection.Metadata.CustomAttributeHandleCollection GetCustomAttributes() => throw null;
                public System.Reflection.Metadata.BlobHandle HashValue { get => throw null; }
                public System.Reflection.Metadata.StringHandle Name { get => throw null; }
            }
            public struct AssemblyFileHandle : System.IEquatable<System.Reflection.Metadata.AssemblyFileHandle>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.AssemblyFileHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.AssemblyFileHandle left, System.Reflection.Metadata.AssemblyFileHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.AssemblyFileHandle(System.Reflection.Metadata.EntityHandle handle) => throw null;
                public static explicit operator System.Reflection.Metadata.AssemblyFileHandle(System.Reflection.Metadata.Handle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.EntityHandle(System.Reflection.Metadata.AssemblyFileHandle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.Handle(System.Reflection.Metadata.AssemblyFileHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.AssemblyFileHandle left, System.Reflection.Metadata.AssemblyFileHandle right) => throw null;
            }
            public struct AssemblyFileHandleCollection : System.Collections.Generic.IEnumerable<System.Reflection.Metadata.AssemblyFileHandle>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Reflection.Metadata.AssemblyFileHandle>
            {
                public int Count { get => throw null; }
                public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<System.Reflection.Metadata.AssemblyFileHandle>, System.Collections.IEnumerator
                {
                    public System.Reflection.Metadata.AssemblyFileHandle Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    void System.IDisposable.Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }
                public System.Reflection.Metadata.AssemblyFileHandleCollection.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Reflection.Metadata.AssemblyFileHandle> System.Collections.Generic.IEnumerable<System.Reflection.Metadata.AssemblyFileHandle>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            }
            public struct AssemblyReference
            {
                public System.Reflection.Metadata.StringHandle Culture { get => throw null; }
                public System.Reflection.AssemblyFlags Flags { get => throw null; }
                public System.Reflection.AssemblyName GetAssemblyName() => throw null;
                public System.Reflection.Metadata.CustomAttributeHandleCollection GetCustomAttributes() => throw null;
                public System.Reflection.Metadata.BlobHandle HashValue { get => throw null; }
                public System.Reflection.Metadata.StringHandle Name { get => throw null; }
                public System.Reflection.Metadata.BlobHandle PublicKeyOrToken { get => throw null; }
                public System.Version Version { get => throw null; }
            }
            public struct AssemblyReferenceHandle : System.IEquatable<System.Reflection.Metadata.AssemblyReferenceHandle>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.AssemblyReferenceHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.AssemblyReferenceHandle left, System.Reflection.Metadata.AssemblyReferenceHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.AssemblyReferenceHandle(System.Reflection.Metadata.EntityHandle handle) => throw null;
                public static explicit operator System.Reflection.Metadata.AssemblyReferenceHandle(System.Reflection.Metadata.Handle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.EntityHandle(System.Reflection.Metadata.AssemblyReferenceHandle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.Handle(System.Reflection.Metadata.AssemblyReferenceHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.AssemblyReferenceHandle left, System.Reflection.Metadata.AssemblyReferenceHandle right) => throw null;
            }
            public struct AssemblyReferenceHandleCollection : System.Collections.Generic.IEnumerable<System.Reflection.Metadata.AssemblyReferenceHandle>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Reflection.Metadata.AssemblyReferenceHandle>
            {
                public int Count { get => throw null; }
                public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<System.Reflection.Metadata.AssemblyReferenceHandle>, System.Collections.IEnumerator
                {
                    public System.Reflection.Metadata.AssemblyReferenceHandle Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    void System.IDisposable.Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }
                public System.Reflection.Metadata.AssemblyReferenceHandleCollection.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Reflection.Metadata.AssemblyReferenceHandle> System.Collections.Generic.IEnumerable<System.Reflection.Metadata.AssemblyReferenceHandle>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            }
            public struct Blob
            {
                public System.ArraySegment<byte> GetBytes() => throw null;
                public bool IsDefault { get => throw null; }
                public int Length { get => throw null; }
            }
            public class BlobBuilder
            {
                public void Align(int alignment) => throw null;
                protected virtual System.Reflection.Metadata.BlobBuilder AllocateChunk(int minimalSize) => throw null;
                public struct Blobs : System.IDisposable, System.Collections.Generic.IEnumerable<System.Reflection.Metadata.Blob>, System.Collections.IEnumerable, System.Collections.Generic.IEnumerator<System.Reflection.Metadata.Blob>, System.Collections.IEnumerator
                {
                    public System.Reflection.Metadata.Blob Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    void System.IDisposable.Dispose() => throw null;
                    public System.Reflection.Metadata.BlobBuilder.Blobs GetEnumerator() => throw null;
                    System.Collections.Generic.IEnumerator<System.Reflection.Metadata.Blob> System.Collections.Generic.IEnumerable<System.Reflection.Metadata.Blob>.GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public bool MoveNext() => throw null;
                    public void Reset() => throw null;
                }
                protected int ChunkCapacity { get => throw null; }
                public void Clear() => throw null;
                public bool ContentEquals(System.Reflection.Metadata.BlobBuilder other) => throw null;
                public int Count { get => throw null; }
                public BlobBuilder(int capacity = default(int)) => throw null;
                protected void Free() => throw null;
                protected int FreeBytes { get => throw null; }
                protected virtual void FreeChunk() => throw null;
                public System.Reflection.Metadata.BlobBuilder.Blobs GetBlobs() => throw null;
                public void LinkPrefix(System.Reflection.Metadata.BlobBuilder prefix) => throw null;
                public void LinkSuffix(System.Reflection.Metadata.BlobBuilder suffix) => throw null;
                public void PadTo(int position) => throw null;
                public System.Reflection.Metadata.Blob ReserveBytes(int byteCount) => throw null;
                public byte[] ToArray() => throw null;
                public byte[] ToArray(int start, int byteCount) => throw null;
                public System.Collections.Immutable.ImmutableArray<byte> ToImmutableArray() => throw null;
                public System.Collections.Immutable.ImmutableArray<byte> ToImmutableArray(int start, int byteCount) => throw null;
                public int TryWriteBytes(System.IO.Stream source, int byteCount) => throw null;
                public void WriteBoolean(bool value) => throw null;
                public void WriteByte(byte value) => throw null;
                public unsafe void WriteBytes(byte* buffer, int byteCount) => throw null;
                public void WriteBytes(byte value, int byteCount) => throw null;
                public void WriteBytes(byte[] buffer) => throw null;
                public void WriteBytes(byte[] buffer, int start, int byteCount) => throw null;
                public void WriteBytes(System.Collections.Immutable.ImmutableArray<byte> buffer) => throw null;
                public void WriteBytes(System.Collections.Immutable.ImmutableArray<byte> buffer, int start, int byteCount) => throw null;
                public void WriteCompressedInteger(int value) => throw null;
                public void WriteCompressedSignedInteger(int value) => throw null;
                public void WriteConstant(object value) => throw null;
                public void WriteContentTo(System.IO.Stream destination) => throw null;
                public void WriteContentTo(System.Reflection.Metadata.BlobBuilder destination) => throw null;
                public void WriteContentTo(ref System.Reflection.Metadata.BlobWriter destination) => throw null;
                public void WriteDateTime(System.DateTime value) => throw null;
                public void WriteDecimal(decimal value) => throw null;
                public void WriteDouble(double value) => throw null;
                public void WriteGuid(System.Guid value) => throw null;
                public void WriteInt16(short value) => throw null;
                public void WriteInt16BE(short value) => throw null;
                public void WriteInt32(int value) => throw null;
                public void WriteInt32BE(int value) => throw null;
                public void WriteInt64(long value) => throw null;
                public void WriteReference(int reference, bool isSmall) => throw null;
                public void WriteSByte(sbyte value) => throw null;
                public void WriteSerializedString(string value) => throw null;
                public void WriteSingle(float value) => throw null;
                public void WriteUInt16(ushort value) => throw null;
                public void WriteUInt16BE(ushort value) => throw null;
                public void WriteUInt32(uint value) => throw null;
                public void WriteUInt32BE(uint value) => throw null;
                public void WriteUInt64(ulong value) => throw null;
                public void WriteUserString(string value) => throw null;
                public void WriteUTF16(char[] value) => throw null;
                public void WriteUTF16(string value) => throw null;
                public void WriteUTF8(string value, bool allowUnpairedSurrogates = default(bool)) => throw null;
            }
            public struct BlobContentId : System.IEquatable<System.Reflection.Metadata.BlobContentId>
            {
                public BlobContentId(byte[] id) => throw null;
                public BlobContentId(System.Collections.Immutable.ImmutableArray<byte> id) => throw null;
                public BlobContentId(System.Guid guid, uint stamp) => throw null;
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.BlobContentId other) => throw null;
                public static System.Reflection.Metadata.BlobContentId FromHash(byte[] hashCode) => throw null;
                public static System.Reflection.Metadata.BlobContentId FromHash(System.Collections.Immutable.ImmutableArray<byte> hashCode) => throw null;
                public override int GetHashCode() => throw null;
                public static System.Func<System.Collections.Generic.IEnumerable<System.Reflection.Metadata.Blob>, System.Reflection.Metadata.BlobContentId> GetTimeBasedProvider() => throw null;
                public System.Guid Guid { get => throw null; }
                public bool IsDefault { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.BlobContentId left, System.Reflection.Metadata.BlobContentId right) => throw null;
                public static bool operator !=(System.Reflection.Metadata.BlobContentId left, System.Reflection.Metadata.BlobContentId right) => throw null;
                public uint Stamp { get => throw null; }
            }
            public struct BlobHandle : System.IEquatable<System.Reflection.Metadata.BlobHandle>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.BlobHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.BlobHandle left, System.Reflection.Metadata.BlobHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.BlobHandle(System.Reflection.Metadata.Handle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.Handle(System.Reflection.Metadata.BlobHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.BlobHandle left, System.Reflection.Metadata.BlobHandle right) => throw null;
            }
            public struct BlobReader
            {
                public void Align(byte alignment) => throw null;
                public unsafe BlobReader(byte* buffer, int length) => throw null;
                public unsafe byte* CurrentPointer { get => throw null; }
                public int IndexOf(byte value) => throw null;
                public int Length { get => throw null; }
                public int Offset { get => throw null; set { } }
                public System.Reflection.Metadata.BlobHandle ReadBlobHandle() => throw null;
                public bool ReadBoolean() => throw null;
                public byte ReadByte() => throw null;
                public byte[] ReadBytes(int byteCount) => throw null;
                public void ReadBytes(int byteCount, byte[] buffer, int bufferOffset) => throw null;
                public char ReadChar() => throw null;
                public int ReadCompressedInteger() => throw null;
                public int ReadCompressedSignedInteger() => throw null;
                public object ReadConstant(System.Reflection.Metadata.ConstantTypeCode typeCode) => throw null;
                public System.DateTime ReadDateTime() => throw null;
                public decimal ReadDecimal() => throw null;
                public double ReadDouble() => throw null;
                public System.Guid ReadGuid() => throw null;
                public short ReadInt16() => throw null;
                public int ReadInt32() => throw null;
                public long ReadInt64() => throw null;
                public sbyte ReadSByte() => throw null;
                public System.Reflection.Metadata.SerializationTypeCode ReadSerializationTypeCode() => throw null;
                public string ReadSerializedString() => throw null;
                public System.Reflection.Metadata.SignatureHeader ReadSignatureHeader() => throw null;
                public System.Reflection.Metadata.SignatureTypeCode ReadSignatureTypeCode() => throw null;
                public float ReadSingle() => throw null;
                public System.Reflection.Metadata.EntityHandle ReadTypeHandle() => throw null;
                public ushort ReadUInt16() => throw null;
                public uint ReadUInt32() => throw null;
                public ulong ReadUInt64() => throw null;
                public string ReadUTF16(int byteCount) => throw null;
                public string ReadUTF8(int byteCount) => throw null;
                public int RemainingBytes { get => throw null; }
                public void Reset() => throw null;
                public unsafe byte* StartPointer { get => throw null; }
                public bool TryReadCompressedInteger(out int value) => throw null;
                public bool TryReadCompressedSignedInteger(out int value) => throw null;
            }
            public struct BlobWriter
            {
                public void Align(int alignment) => throw null;
                public System.Reflection.Metadata.Blob Blob { get => throw null; }
                public void Clear() => throw null;
                public bool ContentEquals(System.Reflection.Metadata.BlobWriter other) => throw null;
                public BlobWriter(byte[] buffer) => throw null;
                public BlobWriter(byte[] buffer, int start, int count) => throw null;
                public BlobWriter(int size) => throw null;
                public BlobWriter(System.Reflection.Metadata.Blob blob) => throw null;
                public int Length { get => throw null; }
                public int Offset { get => throw null; set { } }
                public void PadTo(int offset) => throw null;
                public int RemainingBytes { get => throw null; }
                public byte[] ToArray() => throw null;
                public byte[] ToArray(int start, int byteCount) => throw null;
                public System.Collections.Immutable.ImmutableArray<byte> ToImmutableArray() => throw null;
                public System.Collections.Immutable.ImmutableArray<byte> ToImmutableArray(int start, int byteCount) => throw null;
                public void WriteBoolean(bool value) => throw null;
                public void WriteByte(byte value) => throw null;
                public unsafe void WriteBytes(byte* buffer, int byteCount) => throw null;
                public void WriteBytes(byte value, int byteCount) => throw null;
                public void WriteBytes(byte[] buffer) => throw null;
                public void WriteBytes(byte[] buffer, int start, int byteCount) => throw null;
                public void WriteBytes(System.Collections.Immutable.ImmutableArray<byte> buffer) => throw null;
                public void WriteBytes(System.Collections.Immutable.ImmutableArray<byte> buffer, int start, int byteCount) => throw null;
                public int WriteBytes(System.IO.Stream source, int byteCount) => throw null;
                public void WriteBytes(System.Reflection.Metadata.BlobBuilder source) => throw null;
                public void WriteCompressedInteger(int value) => throw null;
                public void WriteCompressedSignedInteger(int value) => throw null;
                public void WriteConstant(object value) => throw null;
                public void WriteDateTime(System.DateTime value) => throw null;
                public void WriteDecimal(decimal value) => throw null;
                public void WriteDouble(double value) => throw null;
                public void WriteGuid(System.Guid value) => throw null;
                public void WriteInt16(short value) => throw null;
                public void WriteInt16BE(short value) => throw null;
                public void WriteInt32(int value) => throw null;
                public void WriteInt32BE(int value) => throw null;
                public void WriteInt64(long value) => throw null;
                public void WriteReference(int reference, bool isSmall) => throw null;
                public void WriteSByte(sbyte value) => throw null;
                public void WriteSerializedString(string str) => throw null;
                public void WriteSingle(float value) => throw null;
                public void WriteUInt16(ushort value) => throw null;
                public void WriteUInt16BE(ushort value) => throw null;
                public void WriteUInt32(uint value) => throw null;
                public void WriteUInt32BE(uint value) => throw null;
                public void WriteUInt64(ulong value) => throw null;
                public void WriteUserString(string value) => throw null;
                public void WriteUTF16(char[] value) => throw null;
                public void WriteUTF16(string value) => throw null;
                public void WriteUTF8(string value, bool allowUnpairedSurrogates) => throw null;
            }
            public struct Constant
            {
                public System.Reflection.Metadata.EntityHandle Parent { get => throw null; }
                public System.Reflection.Metadata.ConstantTypeCode TypeCode { get => throw null; }
                public System.Reflection.Metadata.BlobHandle Value { get => throw null; }
            }
            public struct ConstantHandle : System.IEquatable<System.Reflection.Metadata.ConstantHandle>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.ConstantHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.ConstantHandle left, System.Reflection.Metadata.ConstantHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.ConstantHandle(System.Reflection.Metadata.EntityHandle handle) => throw null;
                public static explicit operator System.Reflection.Metadata.ConstantHandle(System.Reflection.Metadata.Handle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.EntityHandle(System.Reflection.Metadata.ConstantHandle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.Handle(System.Reflection.Metadata.ConstantHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.ConstantHandle left, System.Reflection.Metadata.ConstantHandle right) => throw null;
            }
            public enum ConstantTypeCode : byte
            {
                Invalid = 0,
                Boolean = 2,
                Char = 3,
                SByte = 4,
                Byte = 5,
                Int16 = 6,
                UInt16 = 7,
                Int32 = 8,
                UInt32 = 9,
                Int64 = 10,
                UInt64 = 11,
                Single = 12,
                Double = 13,
                String = 14,
                NullReference = 18,
            }
            public struct CustomAttribute
            {
                public System.Reflection.Metadata.EntityHandle Constructor { get => throw null; }
                public System.Reflection.Metadata.CustomAttributeValue<TType> DecodeValue<TType>(System.Reflection.Metadata.ICustomAttributeTypeProvider<TType> provider) => throw null;
                public System.Reflection.Metadata.EntityHandle Parent { get => throw null; }
                public System.Reflection.Metadata.BlobHandle Value { get => throw null; }
            }
            public struct CustomAttributeHandle : System.IEquatable<System.Reflection.Metadata.CustomAttributeHandle>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.CustomAttributeHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.CustomAttributeHandle left, System.Reflection.Metadata.CustomAttributeHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.CustomAttributeHandle(System.Reflection.Metadata.EntityHandle handle) => throw null;
                public static explicit operator System.Reflection.Metadata.CustomAttributeHandle(System.Reflection.Metadata.Handle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.EntityHandle(System.Reflection.Metadata.CustomAttributeHandle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.Handle(System.Reflection.Metadata.CustomAttributeHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.CustomAttributeHandle left, System.Reflection.Metadata.CustomAttributeHandle right) => throw null;
            }
            public struct CustomAttributeHandleCollection : System.Collections.Generic.IEnumerable<System.Reflection.Metadata.CustomAttributeHandle>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Reflection.Metadata.CustomAttributeHandle>
            {
                public int Count { get => throw null; }
                public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<System.Reflection.Metadata.CustomAttributeHandle>, System.Collections.IEnumerator
                {
                    public System.Reflection.Metadata.CustomAttributeHandle Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    void System.IDisposable.Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }
                public System.Reflection.Metadata.CustomAttributeHandleCollection.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Reflection.Metadata.CustomAttributeHandle> System.Collections.Generic.IEnumerable<System.Reflection.Metadata.CustomAttributeHandle>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            }
            public struct CustomAttributeNamedArgument<TType>
            {
                public CustomAttributeNamedArgument(string name, System.Reflection.Metadata.CustomAttributeNamedArgumentKind kind, TType type, object value) => throw null;
                public System.Reflection.Metadata.CustomAttributeNamedArgumentKind Kind { get => throw null; }
                public string Name { get => throw null; }
                public TType Type { get => throw null; }
                public object Value { get => throw null; }
            }
            public enum CustomAttributeNamedArgumentKind : byte
            {
                Field = 83,
                Property = 84,
            }
            public struct CustomAttributeTypedArgument<TType>
            {
                public CustomAttributeTypedArgument(TType type, object value) => throw null;
                public TType Type { get => throw null; }
                public object Value { get => throw null; }
            }
            public struct CustomAttributeValue<TType>
            {
                public CustomAttributeValue(System.Collections.Immutable.ImmutableArray<System.Reflection.Metadata.CustomAttributeTypedArgument<TType>> fixedArguments, System.Collections.Immutable.ImmutableArray<System.Reflection.Metadata.CustomAttributeNamedArgument<TType>> namedArguments) => throw null;
                public System.Collections.Immutable.ImmutableArray<System.Reflection.Metadata.CustomAttributeTypedArgument<TType>> FixedArguments { get => throw null; }
                public System.Collections.Immutable.ImmutableArray<System.Reflection.Metadata.CustomAttributeNamedArgument<TType>> NamedArguments { get => throw null; }
            }
            public struct CustomDebugInformation
            {
                public System.Reflection.Metadata.GuidHandle Kind { get => throw null; }
                public System.Reflection.Metadata.EntityHandle Parent { get => throw null; }
                public System.Reflection.Metadata.BlobHandle Value { get => throw null; }
            }
            public struct CustomDebugInformationHandle : System.IEquatable<System.Reflection.Metadata.CustomDebugInformationHandle>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.CustomDebugInformationHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.CustomDebugInformationHandle left, System.Reflection.Metadata.CustomDebugInformationHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.CustomDebugInformationHandle(System.Reflection.Metadata.EntityHandle handle) => throw null;
                public static explicit operator System.Reflection.Metadata.CustomDebugInformationHandle(System.Reflection.Metadata.Handle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.EntityHandle(System.Reflection.Metadata.CustomDebugInformationHandle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.Handle(System.Reflection.Metadata.CustomDebugInformationHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.CustomDebugInformationHandle left, System.Reflection.Metadata.CustomDebugInformationHandle right) => throw null;
            }
            public struct CustomDebugInformationHandleCollection : System.Collections.Generic.IEnumerable<System.Reflection.Metadata.CustomDebugInformationHandle>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Reflection.Metadata.CustomDebugInformationHandle>
            {
                public int Count { get => throw null; }
                public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<System.Reflection.Metadata.CustomDebugInformationHandle>, System.Collections.IEnumerator
                {
                    public System.Reflection.Metadata.CustomDebugInformationHandle Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    void System.IDisposable.Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }
                public System.Reflection.Metadata.CustomDebugInformationHandleCollection.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Reflection.Metadata.CustomDebugInformationHandle> System.Collections.Generic.IEnumerable<System.Reflection.Metadata.CustomDebugInformationHandle>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            }
            public sealed class DebugMetadataHeader
            {
                public System.Reflection.Metadata.MethodDefinitionHandle EntryPoint { get => throw null; }
                public System.Collections.Immutable.ImmutableArray<byte> Id { get => throw null; }
                public int IdStartOffset { get => throw null; }
            }
            public struct DeclarativeSecurityAttribute
            {
                public System.Reflection.DeclarativeSecurityAction Action { get => throw null; }
                public System.Reflection.Metadata.EntityHandle Parent { get => throw null; }
                public System.Reflection.Metadata.BlobHandle PermissionSet { get => throw null; }
            }
            public struct DeclarativeSecurityAttributeHandle : System.IEquatable<System.Reflection.Metadata.DeclarativeSecurityAttributeHandle>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.DeclarativeSecurityAttributeHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.DeclarativeSecurityAttributeHandle left, System.Reflection.Metadata.DeclarativeSecurityAttributeHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.DeclarativeSecurityAttributeHandle(System.Reflection.Metadata.EntityHandle handle) => throw null;
                public static explicit operator System.Reflection.Metadata.DeclarativeSecurityAttributeHandle(System.Reflection.Metadata.Handle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.EntityHandle(System.Reflection.Metadata.DeclarativeSecurityAttributeHandle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.Handle(System.Reflection.Metadata.DeclarativeSecurityAttributeHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.DeclarativeSecurityAttributeHandle left, System.Reflection.Metadata.DeclarativeSecurityAttributeHandle right) => throw null;
            }
            public struct DeclarativeSecurityAttributeHandleCollection : System.Collections.Generic.IEnumerable<System.Reflection.Metadata.DeclarativeSecurityAttributeHandle>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Reflection.Metadata.DeclarativeSecurityAttributeHandle>
            {
                public int Count { get => throw null; }
                public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<System.Reflection.Metadata.DeclarativeSecurityAttributeHandle>, System.Collections.IEnumerator
                {
                    public System.Reflection.Metadata.DeclarativeSecurityAttributeHandle Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    void System.IDisposable.Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }
                public System.Reflection.Metadata.DeclarativeSecurityAttributeHandleCollection.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Reflection.Metadata.DeclarativeSecurityAttributeHandle> System.Collections.Generic.IEnumerable<System.Reflection.Metadata.DeclarativeSecurityAttributeHandle>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            }
            public struct Document
            {
                public System.Reflection.Metadata.BlobHandle Hash { get => throw null; }
                public System.Reflection.Metadata.GuidHandle HashAlgorithm { get => throw null; }
                public System.Reflection.Metadata.GuidHandle Language { get => throw null; }
                public System.Reflection.Metadata.DocumentNameBlobHandle Name { get => throw null; }
            }
            public struct DocumentHandle : System.IEquatable<System.Reflection.Metadata.DocumentHandle>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.DocumentHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.DocumentHandle left, System.Reflection.Metadata.DocumentHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.DocumentHandle(System.Reflection.Metadata.EntityHandle handle) => throw null;
                public static explicit operator System.Reflection.Metadata.DocumentHandle(System.Reflection.Metadata.Handle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.EntityHandle(System.Reflection.Metadata.DocumentHandle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.Handle(System.Reflection.Metadata.DocumentHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.DocumentHandle left, System.Reflection.Metadata.DocumentHandle right) => throw null;
            }
            public struct DocumentHandleCollection : System.Collections.Generic.IEnumerable<System.Reflection.Metadata.DocumentHandle>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Reflection.Metadata.DocumentHandle>
            {
                public int Count { get => throw null; }
                public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<System.Reflection.Metadata.DocumentHandle>, System.Collections.IEnumerator
                {
                    public System.Reflection.Metadata.DocumentHandle Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    void System.IDisposable.Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }
                public System.Reflection.Metadata.DocumentHandleCollection.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Reflection.Metadata.DocumentHandle> System.Collections.Generic.IEnumerable<System.Reflection.Metadata.DocumentHandle>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            }
            public struct DocumentNameBlobHandle : System.IEquatable<System.Reflection.Metadata.DocumentNameBlobHandle>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.DocumentNameBlobHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.DocumentNameBlobHandle left, System.Reflection.Metadata.DocumentNameBlobHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.DocumentNameBlobHandle(System.Reflection.Metadata.BlobHandle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.BlobHandle(System.Reflection.Metadata.DocumentNameBlobHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.DocumentNameBlobHandle left, System.Reflection.Metadata.DocumentNameBlobHandle right) => throw null;
            }
            namespace Ecma335
            {
                public struct ArrayShapeEncoder
                {
                    public System.Reflection.Metadata.BlobBuilder Builder { get => throw null; }
                    public ArrayShapeEncoder(System.Reflection.Metadata.BlobBuilder builder) => throw null;
                    public void Shape(int rank, System.Collections.Immutable.ImmutableArray<int> sizes, System.Collections.Immutable.ImmutableArray<int> lowerBounds) => throw null;
                }
                public struct BlobEncoder
                {
                    public System.Reflection.Metadata.BlobBuilder Builder { get => throw null; }
                    public BlobEncoder(System.Reflection.Metadata.BlobBuilder builder) => throw null;
                    public void CustomAttributeSignature(System.Action<System.Reflection.Metadata.Ecma335.FixedArgumentsEncoder> fixedArguments, System.Action<System.Reflection.Metadata.Ecma335.CustomAttributeNamedArgumentsEncoder> namedArguments) => throw null;
                    public void CustomAttributeSignature(out System.Reflection.Metadata.Ecma335.FixedArgumentsEncoder fixedArguments, out System.Reflection.Metadata.Ecma335.CustomAttributeNamedArgumentsEncoder namedArguments) => throw null;
                    public System.Reflection.Metadata.Ecma335.FieldTypeEncoder Field() => throw null;
                    public System.Reflection.Metadata.Ecma335.SignatureTypeEncoder FieldSignature() => throw null;
                    public System.Reflection.Metadata.Ecma335.LocalVariablesEncoder LocalVariableSignature(int variableCount) => throw null;
                    public System.Reflection.Metadata.Ecma335.MethodSignatureEncoder MethodSignature(System.Reflection.Metadata.SignatureCallingConvention convention = default(System.Reflection.Metadata.SignatureCallingConvention), int genericParameterCount = default(int), bool isInstanceMethod = default(bool)) => throw null;
                    public System.Reflection.Metadata.Ecma335.GenericTypeArgumentsEncoder MethodSpecificationSignature(int genericArgumentCount) => throw null;
                    public System.Reflection.Metadata.Ecma335.NamedArgumentsEncoder PermissionSetArguments(int argumentCount) => throw null;
                    public System.Reflection.Metadata.Ecma335.PermissionSetEncoder PermissionSetBlob(int attributeCount) => throw null;
                    public System.Reflection.Metadata.Ecma335.MethodSignatureEncoder PropertySignature(bool isInstanceProperty = default(bool)) => throw null;
                    public System.Reflection.Metadata.Ecma335.SignatureTypeEncoder TypeSpecificationSignature() => throw null;
                }
                public static class CodedIndex
                {
                    public static int CustomAttributeType(System.Reflection.Metadata.EntityHandle handle) => throw null;
                    public static int HasConstant(System.Reflection.Metadata.EntityHandle handle) => throw null;
                    public static int HasCustomAttribute(System.Reflection.Metadata.EntityHandle handle) => throw null;
                    public static int HasCustomDebugInformation(System.Reflection.Metadata.EntityHandle handle) => throw null;
                    public static int HasDeclSecurity(System.Reflection.Metadata.EntityHandle handle) => throw null;
                    public static int HasFieldMarshal(System.Reflection.Metadata.EntityHandle handle) => throw null;
                    public static int HasSemantics(System.Reflection.Metadata.EntityHandle handle) => throw null;
                    public static int Implementation(System.Reflection.Metadata.EntityHandle handle) => throw null;
                    public static int MemberForwarded(System.Reflection.Metadata.EntityHandle handle) => throw null;
                    public static int MemberRefParent(System.Reflection.Metadata.EntityHandle handle) => throw null;
                    public static int MethodDefOrRef(System.Reflection.Metadata.EntityHandle handle) => throw null;
                    public static int ResolutionScope(System.Reflection.Metadata.EntityHandle handle) => throw null;
                    public static int TypeDefOrRef(System.Reflection.Metadata.EntityHandle handle) => throw null;
                    public static int TypeDefOrRefOrSpec(System.Reflection.Metadata.EntityHandle handle) => throw null;
                    public static int TypeOrMethodDef(System.Reflection.Metadata.EntityHandle handle) => throw null;
                }
                public sealed class ControlFlowBuilder
                {
                    public void AddCatchRegion(System.Reflection.Metadata.Ecma335.LabelHandle tryStart, System.Reflection.Metadata.Ecma335.LabelHandle tryEnd, System.Reflection.Metadata.Ecma335.LabelHandle handlerStart, System.Reflection.Metadata.Ecma335.LabelHandle handlerEnd, System.Reflection.Metadata.EntityHandle catchType) => throw null;
                    public void AddFaultRegion(System.Reflection.Metadata.Ecma335.LabelHandle tryStart, System.Reflection.Metadata.Ecma335.LabelHandle tryEnd, System.Reflection.Metadata.Ecma335.LabelHandle handlerStart, System.Reflection.Metadata.Ecma335.LabelHandle handlerEnd) => throw null;
                    public void AddFilterRegion(System.Reflection.Metadata.Ecma335.LabelHandle tryStart, System.Reflection.Metadata.Ecma335.LabelHandle tryEnd, System.Reflection.Metadata.Ecma335.LabelHandle handlerStart, System.Reflection.Metadata.Ecma335.LabelHandle handlerEnd, System.Reflection.Metadata.Ecma335.LabelHandle filterStart) => throw null;
                    public void AddFinallyRegion(System.Reflection.Metadata.Ecma335.LabelHandle tryStart, System.Reflection.Metadata.Ecma335.LabelHandle tryEnd, System.Reflection.Metadata.Ecma335.LabelHandle handlerStart, System.Reflection.Metadata.Ecma335.LabelHandle handlerEnd) => throw null;
                    public void Clear() => throw null;
                    public ControlFlowBuilder() => throw null;
                }
                public struct CustomAttributeArrayTypeEncoder
                {
                    public System.Reflection.Metadata.BlobBuilder Builder { get => throw null; }
                    public CustomAttributeArrayTypeEncoder(System.Reflection.Metadata.BlobBuilder builder) => throw null;
                    public System.Reflection.Metadata.Ecma335.CustomAttributeElementTypeEncoder ElementType() => throw null;
                    public void ObjectArray() => throw null;
                }
                public struct CustomAttributeElementTypeEncoder
                {
                    public void Boolean() => throw null;
                    public System.Reflection.Metadata.BlobBuilder Builder { get => throw null; }
                    public void Byte() => throw null;
                    public void Char() => throw null;
                    public CustomAttributeElementTypeEncoder(System.Reflection.Metadata.BlobBuilder builder) => throw null;
                    public void Double() => throw null;
                    public void Enum(string enumTypeName) => throw null;
                    public void Int16() => throw null;
                    public void Int32() => throw null;
                    public void Int64() => throw null;
                    public void PrimitiveType(System.Reflection.Metadata.PrimitiveSerializationTypeCode type) => throw null;
                    public void SByte() => throw null;
                    public void Single() => throw null;
                    public void String() => throw null;
                    public void SystemType() => throw null;
                    public void UInt16() => throw null;
                    public void UInt32() => throw null;
                    public void UInt64() => throw null;
                }
                public struct CustomAttributeNamedArgumentsEncoder
                {
                    public System.Reflection.Metadata.BlobBuilder Builder { get => throw null; }
                    public System.Reflection.Metadata.Ecma335.NamedArgumentsEncoder Count(int count) => throw null;
                    public CustomAttributeNamedArgumentsEncoder(System.Reflection.Metadata.BlobBuilder builder) => throw null;
                }
                public struct CustomModifiersEncoder
                {
                    public System.Reflection.Metadata.Ecma335.CustomModifiersEncoder AddModifier(System.Reflection.Metadata.EntityHandle type, bool isOptional) => throw null;
                    public System.Reflection.Metadata.BlobBuilder Builder { get => throw null; }
                    public CustomModifiersEncoder(System.Reflection.Metadata.BlobBuilder builder) => throw null;
                }
                public struct EditAndContinueLogEntry : System.IEquatable<System.Reflection.Metadata.Ecma335.EditAndContinueLogEntry>
                {
                    public EditAndContinueLogEntry(System.Reflection.Metadata.EntityHandle handle, System.Reflection.Metadata.Ecma335.EditAndContinueOperation operation) => throw null;
                    public override bool Equals(object obj) => throw null;
                    public bool Equals(System.Reflection.Metadata.Ecma335.EditAndContinueLogEntry other) => throw null;
                    public override int GetHashCode() => throw null;
                    public System.Reflection.Metadata.EntityHandle Handle { get => throw null; }
                    public System.Reflection.Metadata.Ecma335.EditAndContinueOperation Operation { get => throw null; }
                }
                public enum EditAndContinueOperation
                {
                    Default = 0,
                    AddMethod = 1,
                    AddField = 2,
                    AddParameter = 3,
                    AddProperty = 4,
                    AddEvent = 5,
                }
                public struct ExceptionRegionEncoder
                {
                    public System.Reflection.Metadata.Ecma335.ExceptionRegionEncoder Add(System.Reflection.Metadata.ExceptionRegionKind kind, int tryOffset, int tryLength, int handlerOffset, int handlerLength, System.Reflection.Metadata.EntityHandle catchType = default(System.Reflection.Metadata.EntityHandle), int filterOffset = default(int)) => throw null;
                    public System.Reflection.Metadata.Ecma335.ExceptionRegionEncoder AddCatch(int tryOffset, int tryLength, int handlerOffset, int handlerLength, System.Reflection.Metadata.EntityHandle catchType) => throw null;
                    public System.Reflection.Metadata.Ecma335.ExceptionRegionEncoder AddFault(int tryOffset, int tryLength, int handlerOffset, int handlerLength) => throw null;
                    public System.Reflection.Metadata.Ecma335.ExceptionRegionEncoder AddFilter(int tryOffset, int tryLength, int handlerOffset, int handlerLength, int filterOffset) => throw null;
                    public System.Reflection.Metadata.Ecma335.ExceptionRegionEncoder AddFinally(int tryOffset, int tryLength, int handlerOffset, int handlerLength) => throw null;
                    public System.Reflection.Metadata.BlobBuilder Builder { get => throw null; }
                    public bool HasSmallFormat { get => throw null; }
                    public static bool IsSmallExceptionRegion(int startOffset, int length) => throw null;
                    public static bool IsSmallRegionCount(int exceptionRegionCount) => throw null;
                }
                public static partial class ExportedTypeExtensions
                {
                    public static int GetTypeDefinitionId(this System.Reflection.Metadata.ExportedType exportedType) => throw null;
                }
                public struct FieldTypeEncoder
                {
                    public System.Reflection.Metadata.BlobBuilder Builder { get => throw null; }
                    public FieldTypeEncoder(System.Reflection.Metadata.BlobBuilder builder) => throw null;
                    public System.Reflection.Metadata.Ecma335.CustomModifiersEncoder CustomModifiers() => throw null;
                    public System.Reflection.Metadata.Ecma335.SignatureTypeEncoder Type(bool isByRef = default(bool)) => throw null;
                    public void TypedReference() => throw null;
                }
                public struct FixedArgumentsEncoder
                {
                    public System.Reflection.Metadata.Ecma335.LiteralEncoder AddArgument() => throw null;
                    public System.Reflection.Metadata.BlobBuilder Builder { get => throw null; }
                    public FixedArgumentsEncoder(System.Reflection.Metadata.BlobBuilder builder) => throw null;
                }
                public enum FunctionPointerAttributes
                {
                    None = 0,
                    HasThis = 32,
                    HasExplicitThis = 96,
                }
                public struct GenericTypeArgumentsEncoder
                {
                    public System.Reflection.Metadata.Ecma335.SignatureTypeEncoder AddArgument() => throw null;
                    public System.Reflection.Metadata.BlobBuilder Builder { get => throw null; }
                    public GenericTypeArgumentsEncoder(System.Reflection.Metadata.BlobBuilder builder) => throw null;
                }
                public enum HeapIndex
                {
                    UserString = 0,
                    String = 1,
                    Blob = 2,
                    Guid = 3,
                }
                public struct InstructionEncoder
                {
                    public void Branch(System.Reflection.Metadata.ILOpCode code, System.Reflection.Metadata.Ecma335.LabelHandle label) => throw null;
                    public void Call(System.Reflection.Metadata.EntityHandle methodHandle) => throw null;
                    public void Call(System.Reflection.Metadata.MemberReferenceHandle methodHandle) => throw null;
                    public void Call(System.Reflection.Metadata.MethodDefinitionHandle methodHandle) => throw null;
                    public void Call(System.Reflection.Metadata.MethodSpecificationHandle methodHandle) => throw null;
                    public void CallIndirect(System.Reflection.Metadata.StandaloneSignatureHandle signature) => throw null;
                    public System.Reflection.Metadata.BlobBuilder CodeBuilder { get => throw null; }
                    public System.Reflection.Metadata.Ecma335.ControlFlowBuilder ControlFlowBuilder { get => throw null; }
                    public InstructionEncoder(System.Reflection.Metadata.BlobBuilder codeBuilder, System.Reflection.Metadata.Ecma335.ControlFlowBuilder controlFlowBuilder = default(System.Reflection.Metadata.Ecma335.ControlFlowBuilder)) => throw null;
                    public System.Reflection.Metadata.Ecma335.LabelHandle DefineLabel() => throw null;
                    public void LoadArgument(int argumentIndex) => throw null;
                    public void LoadArgumentAddress(int argumentIndex) => throw null;
                    public void LoadConstantI4(int value) => throw null;
                    public void LoadConstantI8(long value) => throw null;
                    public void LoadConstantR4(float value) => throw null;
                    public void LoadConstantR8(double value) => throw null;
                    public void LoadLocal(int slotIndex) => throw null;
                    public void LoadLocalAddress(int slotIndex) => throw null;
                    public void LoadString(System.Reflection.Metadata.UserStringHandle handle) => throw null;
                    public void MarkLabel(System.Reflection.Metadata.Ecma335.LabelHandle label) => throw null;
                    public int Offset { get => throw null; }
                    public void OpCode(System.Reflection.Metadata.ILOpCode code) => throw null;
                    public void StoreArgument(int argumentIndex) => throw null;
                    public void StoreLocal(int slotIndex) => throw null;
                    public System.Reflection.Metadata.Ecma335.SwitchInstructionEncoder Switch(int branchCount) => throw null;
                    public void Token(int token) => throw null;
                    public void Token(System.Reflection.Metadata.EntityHandle handle) => throw null;
                }
                public struct LabelHandle : System.IEquatable<System.Reflection.Metadata.Ecma335.LabelHandle>
                {
                    public override bool Equals(object obj) => throw null;
                    public bool Equals(System.Reflection.Metadata.Ecma335.LabelHandle other) => throw null;
                    public override int GetHashCode() => throw null;
                    public int Id { get => throw null; }
                    public bool IsNil { get => throw null; }
                    public static bool operator ==(System.Reflection.Metadata.Ecma335.LabelHandle left, System.Reflection.Metadata.Ecma335.LabelHandle right) => throw null;
                    public static bool operator !=(System.Reflection.Metadata.Ecma335.LabelHandle left, System.Reflection.Metadata.Ecma335.LabelHandle right) => throw null;
                }
                public struct LiteralEncoder
                {
                    public System.Reflection.Metadata.BlobBuilder Builder { get => throw null; }
                    public LiteralEncoder(System.Reflection.Metadata.BlobBuilder builder) => throw null;
                    public System.Reflection.Metadata.Ecma335.ScalarEncoder Scalar() => throw null;
                    public void TaggedScalar(System.Action<System.Reflection.Metadata.Ecma335.CustomAttributeElementTypeEncoder> type, System.Action<System.Reflection.Metadata.Ecma335.ScalarEncoder> scalar) => throw null;
                    public void TaggedScalar(out System.Reflection.Metadata.Ecma335.CustomAttributeElementTypeEncoder type, out System.Reflection.Metadata.Ecma335.ScalarEncoder scalar) => throw null;
                    public void TaggedVector(System.Action<System.Reflection.Metadata.Ecma335.CustomAttributeArrayTypeEncoder> arrayType, System.Action<System.Reflection.Metadata.Ecma335.VectorEncoder> vector) => throw null;
                    public void TaggedVector(out System.Reflection.Metadata.Ecma335.CustomAttributeArrayTypeEncoder arrayType, out System.Reflection.Metadata.Ecma335.VectorEncoder vector) => throw null;
                    public System.Reflection.Metadata.Ecma335.VectorEncoder Vector() => throw null;
                }
                public struct LiteralsEncoder
                {
                    public System.Reflection.Metadata.Ecma335.LiteralEncoder AddLiteral() => throw null;
                    public System.Reflection.Metadata.BlobBuilder Builder { get => throw null; }
                    public LiteralsEncoder(System.Reflection.Metadata.BlobBuilder builder) => throw null;
                }
                public struct LocalVariablesEncoder
                {
                    public System.Reflection.Metadata.Ecma335.LocalVariableTypeEncoder AddVariable() => throw null;
                    public System.Reflection.Metadata.BlobBuilder Builder { get => throw null; }
                    public LocalVariablesEncoder(System.Reflection.Metadata.BlobBuilder builder) => throw null;
                }
                public struct LocalVariableTypeEncoder
                {
                    public System.Reflection.Metadata.BlobBuilder Builder { get => throw null; }
                    public LocalVariableTypeEncoder(System.Reflection.Metadata.BlobBuilder builder) => throw null;
                    public System.Reflection.Metadata.Ecma335.CustomModifiersEncoder CustomModifiers() => throw null;
                    public System.Reflection.Metadata.Ecma335.SignatureTypeEncoder Type(bool isByRef = default(bool), bool isPinned = default(bool)) => throw null;
                    public void TypedReference() => throw null;
                }
                public sealed class MetadataAggregator
                {
                    public MetadataAggregator(System.Collections.Generic.IReadOnlyList<int> baseTableRowCounts, System.Collections.Generic.IReadOnlyList<int> baseHeapSizes, System.Collections.Generic.IReadOnlyList<System.Reflection.Metadata.MetadataReader> deltaReaders) => throw null;
                    public MetadataAggregator(System.Reflection.Metadata.MetadataReader baseReader, System.Collections.Generic.IReadOnlyList<System.Reflection.Metadata.MetadataReader> deltaReaders) => throw null;
                    public System.Reflection.Metadata.Handle GetGenerationHandle(System.Reflection.Metadata.Handle handle, out int generation) => throw null;
                }
                public sealed class MetadataBuilder
                {
                    public System.Reflection.Metadata.AssemblyDefinitionHandle AddAssembly(System.Reflection.Metadata.StringHandle name, System.Version version, System.Reflection.Metadata.StringHandle culture, System.Reflection.Metadata.BlobHandle publicKey, System.Reflection.AssemblyFlags flags, System.Reflection.AssemblyHashAlgorithm hashAlgorithm) => throw null;
                    public System.Reflection.Metadata.AssemblyFileHandle AddAssemblyFile(System.Reflection.Metadata.StringHandle name, System.Reflection.Metadata.BlobHandle hashValue, bool containsMetadata) => throw null;
                    public System.Reflection.Metadata.AssemblyReferenceHandle AddAssemblyReference(System.Reflection.Metadata.StringHandle name, System.Version version, System.Reflection.Metadata.StringHandle culture, System.Reflection.Metadata.BlobHandle publicKeyOrToken, System.Reflection.AssemblyFlags flags, System.Reflection.Metadata.BlobHandle hashValue) => throw null;
                    public System.Reflection.Metadata.ConstantHandle AddConstant(System.Reflection.Metadata.EntityHandle parent, object value) => throw null;
                    public System.Reflection.Metadata.CustomAttributeHandle AddCustomAttribute(System.Reflection.Metadata.EntityHandle parent, System.Reflection.Metadata.EntityHandle constructor, System.Reflection.Metadata.BlobHandle value) => throw null;
                    public System.Reflection.Metadata.CustomDebugInformationHandle AddCustomDebugInformation(System.Reflection.Metadata.EntityHandle parent, System.Reflection.Metadata.GuidHandle kind, System.Reflection.Metadata.BlobHandle value) => throw null;
                    public System.Reflection.Metadata.DeclarativeSecurityAttributeHandle AddDeclarativeSecurityAttribute(System.Reflection.Metadata.EntityHandle parent, System.Reflection.DeclarativeSecurityAction action, System.Reflection.Metadata.BlobHandle permissionSet) => throw null;
                    public System.Reflection.Metadata.DocumentHandle AddDocument(System.Reflection.Metadata.BlobHandle name, System.Reflection.Metadata.GuidHandle hashAlgorithm, System.Reflection.Metadata.BlobHandle hash, System.Reflection.Metadata.GuidHandle language) => throw null;
                    public void AddEncLogEntry(System.Reflection.Metadata.EntityHandle entity, System.Reflection.Metadata.Ecma335.EditAndContinueOperation code) => throw null;
                    public void AddEncMapEntry(System.Reflection.Metadata.EntityHandle entity) => throw null;
                    public System.Reflection.Metadata.EventDefinitionHandle AddEvent(System.Reflection.EventAttributes attributes, System.Reflection.Metadata.StringHandle name, System.Reflection.Metadata.EntityHandle type) => throw null;
                    public void AddEventMap(System.Reflection.Metadata.TypeDefinitionHandle declaringType, System.Reflection.Metadata.EventDefinitionHandle eventList) => throw null;
                    public System.Reflection.Metadata.ExportedTypeHandle AddExportedType(System.Reflection.TypeAttributes attributes, System.Reflection.Metadata.StringHandle @namespace, System.Reflection.Metadata.StringHandle name, System.Reflection.Metadata.EntityHandle implementation, int typeDefinitionId) => throw null;
                    public System.Reflection.Metadata.FieldDefinitionHandle AddFieldDefinition(System.Reflection.FieldAttributes attributes, System.Reflection.Metadata.StringHandle name, System.Reflection.Metadata.BlobHandle signature) => throw null;
                    public void AddFieldLayout(System.Reflection.Metadata.FieldDefinitionHandle field, int offset) => throw null;
                    public void AddFieldRelativeVirtualAddress(System.Reflection.Metadata.FieldDefinitionHandle field, int offset) => throw null;
                    public System.Reflection.Metadata.GenericParameterHandle AddGenericParameter(System.Reflection.Metadata.EntityHandle parent, System.Reflection.GenericParameterAttributes attributes, System.Reflection.Metadata.StringHandle name, int index) => throw null;
                    public System.Reflection.Metadata.GenericParameterConstraintHandle AddGenericParameterConstraint(System.Reflection.Metadata.GenericParameterHandle genericParameter, System.Reflection.Metadata.EntityHandle constraint) => throw null;
                    public System.Reflection.Metadata.ImportScopeHandle AddImportScope(System.Reflection.Metadata.ImportScopeHandle parentScope, System.Reflection.Metadata.BlobHandle imports) => throw null;
                    public System.Reflection.Metadata.InterfaceImplementationHandle AddInterfaceImplementation(System.Reflection.Metadata.TypeDefinitionHandle type, System.Reflection.Metadata.EntityHandle implementedInterface) => throw null;
                    public System.Reflection.Metadata.LocalConstantHandle AddLocalConstant(System.Reflection.Metadata.StringHandle name, System.Reflection.Metadata.BlobHandle signature) => throw null;
                    public System.Reflection.Metadata.LocalScopeHandle AddLocalScope(System.Reflection.Metadata.MethodDefinitionHandle method, System.Reflection.Metadata.ImportScopeHandle importScope, System.Reflection.Metadata.LocalVariableHandle variableList, System.Reflection.Metadata.LocalConstantHandle constantList, int startOffset, int length) => throw null;
                    public System.Reflection.Metadata.LocalVariableHandle AddLocalVariable(System.Reflection.Metadata.LocalVariableAttributes attributes, int index, System.Reflection.Metadata.StringHandle name) => throw null;
                    public System.Reflection.Metadata.ManifestResourceHandle AddManifestResource(System.Reflection.ManifestResourceAttributes attributes, System.Reflection.Metadata.StringHandle name, System.Reflection.Metadata.EntityHandle implementation, uint offset) => throw null;
                    public void AddMarshallingDescriptor(System.Reflection.Metadata.EntityHandle parent, System.Reflection.Metadata.BlobHandle descriptor) => throw null;
                    public System.Reflection.Metadata.MemberReferenceHandle AddMemberReference(System.Reflection.Metadata.EntityHandle parent, System.Reflection.Metadata.StringHandle name, System.Reflection.Metadata.BlobHandle signature) => throw null;
                    public System.Reflection.Metadata.MethodDebugInformationHandle AddMethodDebugInformation(System.Reflection.Metadata.DocumentHandle document, System.Reflection.Metadata.BlobHandle sequencePoints) => throw null;
                    public System.Reflection.Metadata.MethodDefinitionHandle AddMethodDefinition(System.Reflection.MethodAttributes attributes, System.Reflection.MethodImplAttributes implAttributes, System.Reflection.Metadata.StringHandle name, System.Reflection.Metadata.BlobHandle signature, int bodyOffset, System.Reflection.Metadata.ParameterHandle parameterList) => throw null;
                    public System.Reflection.Metadata.MethodImplementationHandle AddMethodImplementation(System.Reflection.Metadata.TypeDefinitionHandle type, System.Reflection.Metadata.EntityHandle methodBody, System.Reflection.Metadata.EntityHandle methodDeclaration) => throw null;
                    public void AddMethodImport(System.Reflection.Metadata.MethodDefinitionHandle method, System.Reflection.MethodImportAttributes attributes, System.Reflection.Metadata.StringHandle name, System.Reflection.Metadata.ModuleReferenceHandle module) => throw null;
                    public void AddMethodSemantics(System.Reflection.Metadata.EntityHandle association, System.Reflection.MethodSemanticsAttributes semantics, System.Reflection.Metadata.MethodDefinitionHandle methodDefinition) => throw null;
                    public System.Reflection.Metadata.MethodSpecificationHandle AddMethodSpecification(System.Reflection.Metadata.EntityHandle method, System.Reflection.Metadata.BlobHandle instantiation) => throw null;
                    public System.Reflection.Metadata.ModuleDefinitionHandle AddModule(int generation, System.Reflection.Metadata.StringHandle moduleName, System.Reflection.Metadata.GuidHandle mvid, System.Reflection.Metadata.GuidHandle encId, System.Reflection.Metadata.GuidHandle encBaseId) => throw null;
                    public System.Reflection.Metadata.ModuleReferenceHandle AddModuleReference(System.Reflection.Metadata.StringHandle moduleName) => throw null;
                    public void AddNestedType(System.Reflection.Metadata.TypeDefinitionHandle type, System.Reflection.Metadata.TypeDefinitionHandle enclosingType) => throw null;
                    public System.Reflection.Metadata.ParameterHandle AddParameter(System.Reflection.ParameterAttributes attributes, System.Reflection.Metadata.StringHandle name, int sequenceNumber) => throw null;
                    public System.Reflection.Metadata.PropertyDefinitionHandle AddProperty(System.Reflection.PropertyAttributes attributes, System.Reflection.Metadata.StringHandle name, System.Reflection.Metadata.BlobHandle signature) => throw null;
                    public void AddPropertyMap(System.Reflection.Metadata.TypeDefinitionHandle declaringType, System.Reflection.Metadata.PropertyDefinitionHandle propertyList) => throw null;
                    public System.Reflection.Metadata.StandaloneSignatureHandle AddStandaloneSignature(System.Reflection.Metadata.BlobHandle signature) => throw null;
                    public void AddStateMachineMethod(System.Reflection.Metadata.MethodDefinitionHandle moveNextMethod, System.Reflection.Metadata.MethodDefinitionHandle kickoffMethod) => throw null;
                    public System.Reflection.Metadata.TypeDefinitionHandle AddTypeDefinition(System.Reflection.TypeAttributes attributes, System.Reflection.Metadata.StringHandle @namespace, System.Reflection.Metadata.StringHandle name, System.Reflection.Metadata.EntityHandle baseType, System.Reflection.Metadata.FieldDefinitionHandle fieldList, System.Reflection.Metadata.MethodDefinitionHandle methodList) => throw null;
                    public void AddTypeLayout(System.Reflection.Metadata.TypeDefinitionHandle type, ushort packingSize, uint size) => throw null;
                    public System.Reflection.Metadata.TypeReferenceHandle AddTypeReference(System.Reflection.Metadata.EntityHandle resolutionScope, System.Reflection.Metadata.StringHandle @namespace, System.Reflection.Metadata.StringHandle name) => throw null;
                    public System.Reflection.Metadata.TypeSpecificationHandle AddTypeSpecification(System.Reflection.Metadata.BlobHandle signature) => throw null;
                    public MetadataBuilder(int userStringHeapStartOffset = default(int), int stringHeapStartOffset = default(int), int blobHeapStartOffset = default(int), int guidHeapStartOffset = default(int)) => throw null;
                    public System.Reflection.Metadata.BlobHandle GetOrAddBlob(byte[] value) => throw null;
                    public System.Reflection.Metadata.BlobHandle GetOrAddBlob(System.Collections.Immutable.ImmutableArray<byte> value) => throw null;
                    public System.Reflection.Metadata.BlobHandle GetOrAddBlob(System.Reflection.Metadata.BlobBuilder value) => throw null;
                    public System.Reflection.Metadata.BlobHandle GetOrAddBlobUTF16(string value) => throw null;
                    public System.Reflection.Metadata.BlobHandle GetOrAddBlobUTF8(string value, bool allowUnpairedSurrogates = default(bool)) => throw null;
                    public System.Reflection.Metadata.BlobHandle GetOrAddConstantBlob(object value) => throw null;
                    public System.Reflection.Metadata.BlobHandle GetOrAddDocumentName(string value) => throw null;
                    public System.Reflection.Metadata.GuidHandle GetOrAddGuid(System.Guid guid) => throw null;
                    public System.Reflection.Metadata.StringHandle GetOrAddString(string value) => throw null;
                    public System.Reflection.Metadata.UserStringHandle GetOrAddUserString(string value) => throw null;
                    public int GetRowCount(System.Reflection.Metadata.Ecma335.TableIndex table) => throw null;
                    public System.Collections.Immutable.ImmutableArray<int> GetRowCounts() => throw null;
                    public System.Reflection.Metadata.ReservedBlob<System.Reflection.Metadata.GuidHandle> ReserveGuid() => throw null;
                    public System.Reflection.Metadata.ReservedBlob<System.Reflection.Metadata.UserStringHandle> ReserveUserString(int length) => throw null;
                    public void SetCapacity(System.Reflection.Metadata.Ecma335.HeapIndex heap, int byteCount) => throw null;
                    public void SetCapacity(System.Reflection.Metadata.Ecma335.TableIndex table, int rowCount) => throw null;
                }
                public static partial class MetadataReaderExtensions
                {
                    public static System.Collections.Generic.IEnumerable<System.Reflection.Metadata.Ecma335.EditAndContinueLogEntry> GetEditAndContinueLogEntries(this System.Reflection.Metadata.MetadataReader reader) => throw null;
                    public static System.Collections.Generic.IEnumerable<System.Reflection.Metadata.EntityHandle> GetEditAndContinueMapEntries(this System.Reflection.Metadata.MetadataReader reader) => throw null;
                    public static int GetHeapMetadataOffset(this System.Reflection.Metadata.MetadataReader reader, System.Reflection.Metadata.Ecma335.HeapIndex heapIndex) => throw null;
                    public static int GetHeapSize(this System.Reflection.Metadata.MetadataReader reader, System.Reflection.Metadata.Ecma335.HeapIndex heapIndex) => throw null;
                    public static System.Reflection.Metadata.BlobHandle GetNextHandle(this System.Reflection.Metadata.MetadataReader reader, System.Reflection.Metadata.BlobHandle handle) => throw null;
                    public static System.Reflection.Metadata.StringHandle GetNextHandle(this System.Reflection.Metadata.MetadataReader reader, System.Reflection.Metadata.StringHandle handle) => throw null;
                    public static System.Reflection.Metadata.UserStringHandle GetNextHandle(this System.Reflection.Metadata.MetadataReader reader, System.Reflection.Metadata.UserStringHandle handle) => throw null;
                    public static int GetTableMetadataOffset(this System.Reflection.Metadata.MetadataReader reader, System.Reflection.Metadata.Ecma335.TableIndex tableIndex) => throw null;
                    public static int GetTableRowCount(this System.Reflection.Metadata.MetadataReader reader, System.Reflection.Metadata.Ecma335.TableIndex tableIndex) => throw null;
                    public static int GetTableRowSize(this System.Reflection.Metadata.MetadataReader reader, System.Reflection.Metadata.Ecma335.TableIndex tableIndex) => throw null;
                    public static System.Collections.Generic.IEnumerable<System.Reflection.Metadata.TypeDefinitionHandle> GetTypesWithEvents(this System.Reflection.Metadata.MetadataReader reader) => throw null;
                    public static System.Collections.Generic.IEnumerable<System.Reflection.Metadata.TypeDefinitionHandle> GetTypesWithProperties(this System.Reflection.Metadata.MetadataReader reader) => throw null;
                    public static System.Reflection.Metadata.SignatureTypeKind ResolveSignatureTypeKind(this System.Reflection.Metadata.MetadataReader reader, System.Reflection.Metadata.EntityHandle typeHandle, byte rawTypeKind) => throw null;
                }
                public sealed class MetadataRootBuilder
                {
                    public MetadataRootBuilder(System.Reflection.Metadata.Ecma335.MetadataBuilder tablesAndHeaps, string metadataVersion = default(string), bool suppressValidation = default(bool)) => throw null;
                    public string MetadataVersion { get => throw null; }
                    public void Serialize(System.Reflection.Metadata.BlobBuilder builder, int methodBodyStreamRva, int mappedFieldDataStreamRva) => throw null;
                    public System.Reflection.Metadata.Ecma335.MetadataSizes Sizes { get => throw null; }
                    public bool SuppressValidation { get => throw null; }
                }
                public sealed class MetadataSizes
                {
                    public System.Collections.Immutable.ImmutableArray<int> ExternalRowCounts { get => throw null; }
                    public int GetAlignedHeapSize(System.Reflection.Metadata.Ecma335.HeapIndex index) => throw null;
                    public System.Collections.Immutable.ImmutableArray<int> HeapSizes { get => throw null; }
                    public System.Collections.Immutable.ImmutableArray<int> RowCounts { get => throw null; }
                }
                public static class MetadataTokens
                {
                    public static System.Reflection.Metadata.AssemblyFileHandle AssemblyFileHandle(int rowNumber) => throw null;
                    public static System.Reflection.Metadata.AssemblyReferenceHandle AssemblyReferenceHandle(int rowNumber) => throw null;
                    public static System.Reflection.Metadata.BlobHandle BlobHandle(int offset) => throw null;
                    public static System.Reflection.Metadata.ConstantHandle ConstantHandle(int rowNumber) => throw null;
                    public static System.Reflection.Metadata.CustomAttributeHandle CustomAttributeHandle(int rowNumber) => throw null;
                    public static System.Reflection.Metadata.CustomDebugInformationHandle CustomDebugInformationHandle(int rowNumber) => throw null;
                    public static System.Reflection.Metadata.DeclarativeSecurityAttributeHandle DeclarativeSecurityAttributeHandle(int rowNumber) => throw null;
                    public static System.Reflection.Metadata.DocumentHandle DocumentHandle(int rowNumber) => throw null;
                    public static System.Reflection.Metadata.DocumentNameBlobHandle DocumentNameBlobHandle(int offset) => throw null;
                    public static System.Reflection.Metadata.EntityHandle EntityHandle(int token) => throw null;
                    public static System.Reflection.Metadata.EntityHandle EntityHandle(System.Reflection.Metadata.Ecma335.TableIndex tableIndex, int rowNumber) => throw null;
                    public static System.Reflection.Metadata.EventDefinitionHandle EventDefinitionHandle(int rowNumber) => throw null;
                    public static System.Reflection.Metadata.ExportedTypeHandle ExportedTypeHandle(int rowNumber) => throw null;
                    public static System.Reflection.Metadata.FieldDefinitionHandle FieldDefinitionHandle(int rowNumber) => throw null;
                    public static System.Reflection.Metadata.GenericParameterConstraintHandle GenericParameterConstraintHandle(int rowNumber) => throw null;
                    public static System.Reflection.Metadata.GenericParameterHandle GenericParameterHandle(int rowNumber) => throw null;
                    public static int GetHeapOffset(System.Reflection.Metadata.BlobHandle handle) => throw null;
                    public static int GetHeapOffset(System.Reflection.Metadata.GuidHandle handle) => throw null;
                    public static int GetHeapOffset(System.Reflection.Metadata.Handle handle) => throw null;
                    public static int GetHeapOffset(this System.Reflection.Metadata.MetadataReader reader, System.Reflection.Metadata.Handle handle) => throw null;
                    public static int GetHeapOffset(System.Reflection.Metadata.StringHandle handle) => throw null;
                    public static int GetHeapOffset(System.Reflection.Metadata.UserStringHandle handle) => throw null;
                    public static int GetRowNumber(System.Reflection.Metadata.EntityHandle handle) => throw null;
                    public static int GetRowNumber(this System.Reflection.Metadata.MetadataReader reader, System.Reflection.Metadata.EntityHandle handle) => throw null;
                    public static int GetToken(System.Reflection.Metadata.EntityHandle handle) => throw null;
                    public static int GetToken(System.Reflection.Metadata.Handle handle) => throw null;
                    public static int GetToken(this System.Reflection.Metadata.MetadataReader reader, System.Reflection.Metadata.EntityHandle handle) => throw null;
                    public static int GetToken(this System.Reflection.Metadata.MetadataReader reader, System.Reflection.Metadata.Handle handle) => throw null;
                    public static System.Reflection.Metadata.GuidHandle GuidHandle(int offset) => throw null;
                    public static System.Reflection.Metadata.Handle Handle(int token) => throw null;
                    public static System.Reflection.Metadata.EntityHandle Handle(System.Reflection.Metadata.Ecma335.TableIndex tableIndex, int rowNumber) => throw null;
                    public static readonly int HeapCount;
                    public static System.Reflection.Metadata.ImportScopeHandle ImportScopeHandle(int rowNumber) => throw null;
                    public static System.Reflection.Metadata.InterfaceImplementationHandle InterfaceImplementationHandle(int rowNumber) => throw null;
                    public static System.Reflection.Metadata.LocalConstantHandle LocalConstantHandle(int rowNumber) => throw null;
                    public static System.Reflection.Metadata.LocalScopeHandle LocalScopeHandle(int rowNumber) => throw null;
                    public static System.Reflection.Metadata.LocalVariableHandle LocalVariableHandle(int rowNumber) => throw null;
                    public static System.Reflection.Metadata.ManifestResourceHandle ManifestResourceHandle(int rowNumber) => throw null;
                    public static System.Reflection.Metadata.MemberReferenceHandle MemberReferenceHandle(int rowNumber) => throw null;
                    public static System.Reflection.Metadata.MethodDebugInformationHandle MethodDebugInformationHandle(int rowNumber) => throw null;
                    public static System.Reflection.Metadata.MethodDefinitionHandle MethodDefinitionHandle(int rowNumber) => throw null;
                    public static System.Reflection.Metadata.MethodImplementationHandle MethodImplementationHandle(int rowNumber) => throw null;
                    public static System.Reflection.Metadata.MethodSpecificationHandle MethodSpecificationHandle(int rowNumber) => throw null;
                    public static System.Reflection.Metadata.ModuleReferenceHandle ModuleReferenceHandle(int rowNumber) => throw null;
                    public static System.Reflection.Metadata.ParameterHandle ParameterHandle(int rowNumber) => throw null;
                    public static System.Reflection.Metadata.PropertyDefinitionHandle PropertyDefinitionHandle(int rowNumber) => throw null;
                    public static System.Reflection.Metadata.StandaloneSignatureHandle StandaloneSignatureHandle(int rowNumber) => throw null;
                    public static System.Reflection.Metadata.StringHandle StringHandle(int offset) => throw null;
                    public static readonly int TableCount;
                    public static bool TryGetHeapIndex(System.Reflection.Metadata.HandleKind type, out System.Reflection.Metadata.Ecma335.HeapIndex index) => throw null;
                    public static bool TryGetTableIndex(System.Reflection.Metadata.HandleKind type, out System.Reflection.Metadata.Ecma335.TableIndex index) => throw null;
                    public static System.Reflection.Metadata.TypeDefinitionHandle TypeDefinitionHandle(int rowNumber) => throw null;
                    public static System.Reflection.Metadata.TypeReferenceHandle TypeReferenceHandle(int rowNumber) => throw null;
                    public static System.Reflection.Metadata.TypeSpecificationHandle TypeSpecificationHandle(int rowNumber) => throw null;
                    public static System.Reflection.Metadata.UserStringHandle UserStringHandle(int offset) => throw null;
                }
                [System.Flags]
                public enum MethodBodyAttributes
                {
                    None = 0,
                    InitLocals = 1,
                }
                public struct MethodBodyStreamEncoder
                {
                    public System.Reflection.Metadata.Ecma335.MethodBodyStreamEncoder.MethodBody AddMethodBody(int codeSize, int maxStack, int exceptionRegionCount, bool hasSmallExceptionRegions, System.Reflection.Metadata.StandaloneSignatureHandle localVariablesSignature, System.Reflection.Metadata.Ecma335.MethodBodyAttributes attributes) => throw null;
                    public System.Reflection.Metadata.Ecma335.MethodBodyStreamEncoder.MethodBody AddMethodBody(int codeSize, int maxStack = default(int), int exceptionRegionCount = default(int), bool hasSmallExceptionRegions = default(bool), System.Reflection.Metadata.StandaloneSignatureHandle localVariablesSignature = default(System.Reflection.Metadata.StandaloneSignatureHandle), System.Reflection.Metadata.Ecma335.MethodBodyAttributes attributes = default(System.Reflection.Metadata.Ecma335.MethodBodyAttributes), bool hasDynamicStackAllocation = default(bool)) => throw null;
                    public int AddMethodBody(System.Reflection.Metadata.Ecma335.InstructionEncoder instructionEncoder, int maxStack, System.Reflection.Metadata.StandaloneSignatureHandle localVariablesSignature, System.Reflection.Metadata.Ecma335.MethodBodyAttributes attributes) => throw null;
                    public int AddMethodBody(System.Reflection.Metadata.Ecma335.InstructionEncoder instructionEncoder, int maxStack = default(int), System.Reflection.Metadata.StandaloneSignatureHandle localVariablesSignature = default(System.Reflection.Metadata.StandaloneSignatureHandle), System.Reflection.Metadata.Ecma335.MethodBodyAttributes attributes = default(System.Reflection.Metadata.Ecma335.MethodBodyAttributes), bool hasDynamicStackAllocation = default(bool)) => throw null;
                    public System.Reflection.Metadata.BlobBuilder Builder { get => throw null; }
                    public MethodBodyStreamEncoder(System.Reflection.Metadata.BlobBuilder builder) => throw null;
                    public struct MethodBody
                    {
                        public System.Reflection.Metadata.Ecma335.ExceptionRegionEncoder ExceptionRegions { get => throw null; }
                        public System.Reflection.Metadata.Blob Instructions { get => throw null; }
                        public int Offset { get => throw null; }
                    }
                }
                public struct MethodSignatureEncoder
                {
                    public System.Reflection.Metadata.BlobBuilder Builder { get => throw null; }
                    public MethodSignatureEncoder(System.Reflection.Metadata.BlobBuilder builder, bool hasVarArgs) => throw null;
                    public bool HasVarArgs { get => throw null; }
                    public void Parameters(int parameterCount, System.Action<System.Reflection.Metadata.Ecma335.ReturnTypeEncoder> returnType, System.Action<System.Reflection.Metadata.Ecma335.ParametersEncoder> parameters) => throw null;
                    public void Parameters(int parameterCount, out System.Reflection.Metadata.Ecma335.ReturnTypeEncoder returnType, out System.Reflection.Metadata.Ecma335.ParametersEncoder parameters) => throw null;
                }
                public struct NamedArgumentsEncoder
                {
                    public void AddArgument(bool isField, System.Action<System.Reflection.Metadata.Ecma335.NamedArgumentTypeEncoder> type, System.Action<System.Reflection.Metadata.Ecma335.NameEncoder> name, System.Action<System.Reflection.Metadata.Ecma335.LiteralEncoder> literal) => throw null;
                    public void AddArgument(bool isField, out System.Reflection.Metadata.Ecma335.NamedArgumentTypeEncoder type, out System.Reflection.Metadata.Ecma335.NameEncoder name, out System.Reflection.Metadata.Ecma335.LiteralEncoder literal) => throw null;
                    public System.Reflection.Metadata.BlobBuilder Builder { get => throw null; }
                    public NamedArgumentsEncoder(System.Reflection.Metadata.BlobBuilder builder) => throw null;
                }
                public struct NamedArgumentTypeEncoder
                {
                    public System.Reflection.Metadata.BlobBuilder Builder { get => throw null; }
                    public NamedArgumentTypeEncoder(System.Reflection.Metadata.BlobBuilder builder) => throw null;
                    public void Object() => throw null;
                    public System.Reflection.Metadata.Ecma335.CustomAttributeElementTypeEncoder ScalarType() => throw null;
                    public System.Reflection.Metadata.Ecma335.CustomAttributeArrayTypeEncoder SZArray() => throw null;
                }
                public struct NameEncoder
                {
                    public System.Reflection.Metadata.BlobBuilder Builder { get => throw null; }
                    public NameEncoder(System.Reflection.Metadata.BlobBuilder builder) => throw null;
                    public void Name(string name) => throw null;
                }
                public struct ParametersEncoder
                {
                    public System.Reflection.Metadata.Ecma335.ParameterTypeEncoder AddParameter() => throw null;
                    public System.Reflection.Metadata.BlobBuilder Builder { get => throw null; }
                    public ParametersEncoder(System.Reflection.Metadata.BlobBuilder builder, bool hasVarArgs = default(bool)) => throw null;
                    public bool HasVarArgs { get => throw null; }
                    public System.Reflection.Metadata.Ecma335.ParametersEncoder StartVarArgs() => throw null;
                }
                public struct ParameterTypeEncoder
                {
                    public System.Reflection.Metadata.BlobBuilder Builder { get => throw null; }
                    public ParameterTypeEncoder(System.Reflection.Metadata.BlobBuilder builder) => throw null;
                    public System.Reflection.Metadata.Ecma335.CustomModifiersEncoder CustomModifiers() => throw null;
                    public System.Reflection.Metadata.Ecma335.SignatureTypeEncoder Type(bool isByRef = default(bool)) => throw null;
                    public void TypedReference() => throw null;
                }
                public struct PermissionSetEncoder
                {
                    public System.Reflection.Metadata.Ecma335.PermissionSetEncoder AddPermission(string typeName, System.Collections.Immutable.ImmutableArray<byte> encodedArguments) => throw null;
                    public System.Reflection.Metadata.Ecma335.PermissionSetEncoder AddPermission(string typeName, System.Reflection.Metadata.BlobBuilder encodedArguments) => throw null;
                    public System.Reflection.Metadata.BlobBuilder Builder { get => throw null; }
                    public PermissionSetEncoder(System.Reflection.Metadata.BlobBuilder builder) => throw null;
                }
                public sealed class PortablePdbBuilder
                {
                    public PortablePdbBuilder(System.Reflection.Metadata.Ecma335.MetadataBuilder tablesAndHeaps, System.Collections.Immutable.ImmutableArray<int> typeSystemRowCounts, System.Reflection.Metadata.MethodDefinitionHandle entryPoint, System.Func<System.Collections.Generic.IEnumerable<System.Reflection.Metadata.Blob>, System.Reflection.Metadata.BlobContentId> idProvider = default(System.Func<System.Collections.Generic.IEnumerable<System.Reflection.Metadata.Blob>, System.Reflection.Metadata.BlobContentId>)) => throw null;
                    public ushort FormatVersion { get => throw null; }
                    public System.Func<System.Collections.Generic.IEnumerable<System.Reflection.Metadata.Blob>, System.Reflection.Metadata.BlobContentId> IdProvider { get => throw null; }
                    public string MetadataVersion { get => throw null; }
                    public System.Reflection.Metadata.BlobContentId Serialize(System.Reflection.Metadata.BlobBuilder builder) => throw null;
                }
                public struct ReturnTypeEncoder
                {
                    public System.Reflection.Metadata.BlobBuilder Builder { get => throw null; }
                    public ReturnTypeEncoder(System.Reflection.Metadata.BlobBuilder builder) => throw null;
                    public System.Reflection.Metadata.Ecma335.CustomModifiersEncoder CustomModifiers() => throw null;
                    public System.Reflection.Metadata.Ecma335.SignatureTypeEncoder Type(bool isByRef = default(bool)) => throw null;
                    public void TypedReference() => throw null;
                    public void Void() => throw null;
                }
                public struct ScalarEncoder
                {
                    public System.Reflection.Metadata.BlobBuilder Builder { get => throw null; }
                    public void Constant(object value) => throw null;
                    public ScalarEncoder(System.Reflection.Metadata.BlobBuilder builder) => throw null;
                    public void NullArray() => throw null;
                    public void SystemType(string serializedTypeName) => throw null;
                }
                public struct SignatureDecoder<TType, TGenericContext>
                {
                    public SignatureDecoder(System.Reflection.Metadata.ISignatureTypeProvider<TType, TGenericContext> provider, System.Reflection.Metadata.MetadataReader metadataReader, TGenericContext genericContext) => throw null;
                    public TType DecodeFieldSignature(ref System.Reflection.Metadata.BlobReader blobReader) => throw null;
                    public System.Collections.Immutable.ImmutableArray<TType> DecodeLocalSignature(ref System.Reflection.Metadata.BlobReader blobReader) => throw null;
                    public System.Reflection.Metadata.MethodSignature<TType> DecodeMethodSignature(ref System.Reflection.Metadata.BlobReader blobReader) => throw null;
                    public System.Collections.Immutable.ImmutableArray<TType> DecodeMethodSpecificationSignature(ref System.Reflection.Metadata.BlobReader blobReader) => throw null;
                    public TType DecodeType(ref System.Reflection.Metadata.BlobReader blobReader, bool allowTypeSpecifications = default(bool)) => throw null;
                }
                public struct SignatureTypeEncoder
                {
                    public void Array(System.Action<System.Reflection.Metadata.Ecma335.SignatureTypeEncoder> elementType, System.Action<System.Reflection.Metadata.Ecma335.ArrayShapeEncoder> arrayShape) => throw null;
                    public void Array(out System.Reflection.Metadata.Ecma335.SignatureTypeEncoder elementType, out System.Reflection.Metadata.Ecma335.ArrayShapeEncoder arrayShape) => throw null;
                    public void Boolean() => throw null;
                    public System.Reflection.Metadata.BlobBuilder Builder { get => throw null; }
                    public void Byte() => throw null;
                    public void Char() => throw null;
                    public SignatureTypeEncoder(System.Reflection.Metadata.BlobBuilder builder) => throw null;
                    public System.Reflection.Metadata.Ecma335.CustomModifiersEncoder CustomModifiers() => throw null;
                    public void Double() => throw null;
                    public System.Reflection.Metadata.Ecma335.MethodSignatureEncoder FunctionPointer(System.Reflection.Metadata.SignatureCallingConvention convention = default(System.Reflection.Metadata.SignatureCallingConvention), System.Reflection.Metadata.Ecma335.FunctionPointerAttributes attributes = default(System.Reflection.Metadata.Ecma335.FunctionPointerAttributes), int genericParameterCount = default(int)) => throw null;
                    public System.Reflection.Metadata.Ecma335.GenericTypeArgumentsEncoder GenericInstantiation(System.Reflection.Metadata.EntityHandle genericType, int genericArgumentCount, bool isValueType) => throw null;
                    public void GenericMethodTypeParameter(int parameterIndex) => throw null;
                    public void GenericTypeParameter(int parameterIndex) => throw null;
                    public void Int16() => throw null;
                    public void Int32() => throw null;
                    public void Int64() => throw null;
                    public void IntPtr() => throw null;
                    public void Object() => throw null;
                    public System.Reflection.Metadata.Ecma335.SignatureTypeEncoder Pointer() => throw null;
                    public void PrimitiveType(System.Reflection.Metadata.PrimitiveTypeCode type) => throw null;
                    public void SByte() => throw null;
                    public void Single() => throw null;
                    public void String() => throw null;
                    public System.Reflection.Metadata.Ecma335.SignatureTypeEncoder SZArray() => throw null;
                    public void Type(System.Reflection.Metadata.EntityHandle type, bool isValueType) => throw null;
                    public void TypedReference() => throw null;
                    public void UInt16() => throw null;
                    public void UInt32() => throw null;
                    public void UInt64() => throw null;
                    public void UIntPtr() => throw null;
                    public void VoidPointer() => throw null;
                }
                public struct SwitchInstructionEncoder
                {
                    public void Branch(System.Reflection.Metadata.Ecma335.LabelHandle label) => throw null;
                }
                public enum TableIndex : byte
                {
                    Module = 0,
                    TypeRef = 1,
                    TypeDef = 2,
                    FieldPtr = 3,
                    Field = 4,
                    MethodPtr = 5,
                    MethodDef = 6,
                    ParamPtr = 7,
                    Param = 8,
                    InterfaceImpl = 9,
                    MemberRef = 10,
                    Constant = 11,
                    CustomAttribute = 12,
                    FieldMarshal = 13,
                    DeclSecurity = 14,
                    ClassLayout = 15,
                    FieldLayout = 16,
                    StandAloneSig = 17,
                    EventMap = 18,
                    EventPtr = 19,
                    Event = 20,
                    PropertyMap = 21,
                    PropertyPtr = 22,
                    Property = 23,
                    MethodSemantics = 24,
                    MethodImpl = 25,
                    ModuleRef = 26,
                    TypeSpec = 27,
                    ImplMap = 28,
                    FieldRva = 29,
                    EncLog = 30,
                    EncMap = 31,
                    Assembly = 32,
                    AssemblyProcessor = 33,
                    AssemblyOS = 34,
                    AssemblyRef = 35,
                    AssemblyRefProcessor = 36,
                    AssemblyRefOS = 37,
                    File = 38,
                    ExportedType = 39,
                    ManifestResource = 40,
                    NestedClass = 41,
                    GenericParam = 42,
                    MethodSpec = 43,
                    GenericParamConstraint = 44,
                    Document = 48,
                    MethodDebugInformation = 49,
                    LocalScope = 50,
                    LocalVariable = 51,
                    LocalConstant = 52,
                    ImportScope = 53,
                    StateMachineMethod = 54,
                    CustomDebugInformation = 55,
                }
                public struct VectorEncoder
                {
                    public System.Reflection.Metadata.BlobBuilder Builder { get => throw null; }
                    public System.Reflection.Metadata.Ecma335.LiteralsEncoder Count(int count) => throw null;
                    public VectorEncoder(System.Reflection.Metadata.BlobBuilder builder) => throw null;
                }
            }
            public struct EntityHandle : System.IEquatable<System.Reflection.Metadata.EntityHandle>
            {
                public static readonly System.Reflection.Metadata.AssemblyDefinitionHandle AssemblyDefinition;
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.EntityHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public System.Reflection.Metadata.HandleKind Kind { get => throw null; }
                public static readonly System.Reflection.Metadata.ModuleDefinitionHandle ModuleDefinition;
                public static bool operator ==(System.Reflection.Metadata.EntityHandle left, System.Reflection.Metadata.EntityHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.EntityHandle(System.Reflection.Metadata.Handle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.Handle(System.Reflection.Metadata.EntityHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.EntityHandle left, System.Reflection.Metadata.EntityHandle right) => throw null;
            }
            public struct EventAccessors
            {
                public System.Reflection.Metadata.MethodDefinitionHandle Adder { get => throw null; }
                public System.Collections.Immutable.ImmutableArray<System.Reflection.Metadata.MethodDefinitionHandle> Others { get => throw null; }
                public System.Reflection.Metadata.MethodDefinitionHandle Raiser { get => throw null; }
                public System.Reflection.Metadata.MethodDefinitionHandle Remover { get => throw null; }
            }
            public struct EventDefinition
            {
                public System.Reflection.EventAttributes Attributes { get => throw null; }
                public System.Reflection.Metadata.EventAccessors GetAccessors() => throw null;
                public System.Reflection.Metadata.CustomAttributeHandleCollection GetCustomAttributes() => throw null;
                public System.Reflection.Metadata.StringHandle Name { get => throw null; }
                public System.Reflection.Metadata.EntityHandle Type { get => throw null; }
            }
            public struct EventDefinitionHandle : System.IEquatable<System.Reflection.Metadata.EventDefinitionHandle>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.EventDefinitionHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.EventDefinitionHandle left, System.Reflection.Metadata.EventDefinitionHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.EventDefinitionHandle(System.Reflection.Metadata.EntityHandle handle) => throw null;
                public static explicit operator System.Reflection.Metadata.EventDefinitionHandle(System.Reflection.Metadata.Handle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.EntityHandle(System.Reflection.Metadata.EventDefinitionHandle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.Handle(System.Reflection.Metadata.EventDefinitionHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.EventDefinitionHandle left, System.Reflection.Metadata.EventDefinitionHandle right) => throw null;
            }
            public struct EventDefinitionHandleCollection : System.Collections.Generic.IEnumerable<System.Reflection.Metadata.EventDefinitionHandle>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Reflection.Metadata.EventDefinitionHandle>
            {
                public int Count { get => throw null; }
                public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<System.Reflection.Metadata.EventDefinitionHandle>, System.Collections.IEnumerator
                {
                    public System.Reflection.Metadata.EventDefinitionHandle Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    void System.IDisposable.Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }
                public System.Reflection.Metadata.EventDefinitionHandleCollection.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Reflection.Metadata.EventDefinitionHandle> System.Collections.Generic.IEnumerable<System.Reflection.Metadata.EventDefinitionHandle>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            }
            public struct ExceptionRegion
            {
                public System.Reflection.Metadata.EntityHandle CatchType { get => throw null; }
                public int FilterOffset { get => throw null; }
                public int HandlerLength { get => throw null; }
                public int HandlerOffset { get => throw null; }
                public System.Reflection.Metadata.ExceptionRegionKind Kind { get => throw null; }
                public int TryLength { get => throw null; }
                public int TryOffset { get => throw null; }
            }
            public enum ExceptionRegionKind : ushort
            {
                Catch = 0,
                Filter = 1,
                Finally = 2,
                Fault = 4,
            }
            public struct ExportedType
            {
                public System.Reflection.TypeAttributes Attributes { get => throw null; }
                public System.Reflection.Metadata.CustomAttributeHandleCollection GetCustomAttributes() => throw null;
                public System.Reflection.Metadata.EntityHandle Implementation { get => throw null; }
                public bool IsForwarder { get => throw null; }
                public System.Reflection.Metadata.StringHandle Name { get => throw null; }
                public System.Reflection.Metadata.StringHandle Namespace { get => throw null; }
                public System.Reflection.Metadata.NamespaceDefinitionHandle NamespaceDefinition { get => throw null; }
            }
            public struct ExportedTypeHandle : System.IEquatable<System.Reflection.Metadata.ExportedTypeHandle>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.ExportedTypeHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.ExportedTypeHandle left, System.Reflection.Metadata.ExportedTypeHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.ExportedTypeHandle(System.Reflection.Metadata.EntityHandle handle) => throw null;
                public static explicit operator System.Reflection.Metadata.ExportedTypeHandle(System.Reflection.Metadata.Handle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.EntityHandle(System.Reflection.Metadata.ExportedTypeHandle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.Handle(System.Reflection.Metadata.ExportedTypeHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.ExportedTypeHandle left, System.Reflection.Metadata.ExportedTypeHandle right) => throw null;
            }
            public struct ExportedTypeHandleCollection : System.Collections.Generic.IEnumerable<System.Reflection.Metadata.ExportedTypeHandle>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Reflection.Metadata.ExportedTypeHandle>
            {
                public int Count { get => throw null; }
                public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<System.Reflection.Metadata.ExportedTypeHandle>, System.Collections.IEnumerator
                {
                    public System.Reflection.Metadata.ExportedTypeHandle Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    void System.IDisposable.Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }
                public System.Reflection.Metadata.ExportedTypeHandleCollection.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Reflection.Metadata.ExportedTypeHandle> System.Collections.Generic.IEnumerable<System.Reflection.Metadata.ExportedTypeHandle>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            }
            public struct FieldDefinition
            {
                public System.Reflection.FieldAttributes Attributes { get => throw null; }
                public TType DecodeSignature<TType, TGenericContext>(System.Reflection.Metadata.ISignatureTypeProvider<TType, TGenericContext> provider, TGenericContext genericContext) => throw null;
                public System.Reflection.Metadata.CustomAttributeHandleCollection GetCustomAttributes() => throw null;
                public System.Reflection.Metadata.TypeDefinitionHandle GetDeclaringType() => throw null;
                public System.Reflection.Metadata.ConstantHandle GetDefaultValue() => throw null;
                public System.Reflection.Metadata.BlobHandle GetMarshallingDescriptor() => throw null;
                public int GetOffset() => throw null;
                public int GetRelativeVirtualAddress() => throw null;
                public System.Reflection.Metadata.StringHandle Name { get => throw null; }
                public System.Reflection.Metadata.BlobHandle Signature { get => throw null; }
            }
            public struct FieldDefinitionHandle : System.IEquatable<System.Reflection.Metadata.FieldDefinitionHandle>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.FieldDefinitionHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.FieldDefinitionHandle left, System.Reflection.Metadata.FieldDefinitionHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.FieldDefinitionHandle(System.Reflection.Metadata.EntityHandle handle) => throw null;
                public static explicit operator System.Reflection.Metadata.FieldDefinitionHandle(System.Reflection.Metadata.Handle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.EntityHandle(System.Reflection.Metadata.FieldDefinitionHandle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.Handle(System.Reflection.Metadata.FieldDefinitionHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.FieldDefinitionHandle left, System.Reflection.Metadata.FieldDefinitionHandle right) => throw null;
            }
            public struct FieldDefinitionHandleCollection : System.Collections.Generic.IEnumerable<System.Reflection.Metadata.FieldDefinitionHandle>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Reflection.Metadata.FieldDefinitionHandle>
            {
                public int Count { get => throw null; }
                public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<System.Reflection.Metadata.FieldDefinitionHandle>, System.Collections.IEnumerator
                {
                    public System.Reflection.Metadata.FieldDefinitionHandle Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    void System.IDisposable.Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }
                public System.Reflection.Metadata.FieldDefinitionHandleCollection.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Reflection.Metadata.FieldDefinitionHandle> System.Collections.Generic.IEnumerable<System.Reflection.Metadata.FieldDefinitionHandle>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            }
            public struct GenericParameter
            {
                public System.Reflection.GenericParameterAttributes Attributes { get => throw null; }
                public System.Reflection.Metadata.GenericParameterConstraintHandleCollection GetConstraints() => throw null;
                public System.Reflection.Metadata.CustomAttributeHandleCollection GetCustomAttributes() => throw null;
                public int Index { get => throw null; }
                public System.Reflection.Metadata.StringHandle Name { get => throw null; }
                public System.Reflection.Metadata.EntityHandle Parent { get => throw null; }
            }
            public struct GenericParameterConstraint
            {
                public System.Reflection.Metadata.CustomAttributeHandleCollection GetCustomAttributes() => throw null;
                public System.Reflection.Metadata.GenericParameterHandle Parameter { get => throw null; }
                public System.Reflection.Metadata.EntityHandle Type { get => throw null; }
            }
            public struct GenericParameterConstraintHandle : System.IEquatable<System.Reflection.Metadata.GenericParameterConstraintHandle>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.GenericParameterConstraintHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.GenericParameterConstraintHandle left, System.Reflection.Metadata.GenericParameterConstraintHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.GenericParameterConstraintHandle(System.Reflection.Metadata.EntityHandle handle) => throw null;
                public static explicit operator System.Reflection.Metadata.GenericParameterConstraintHandle(System.Reflection.Metadata.Handle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.EntityHandle(System.Reflection.Metadata.GenericParameterConstraintHandle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.Handle(System.Reflection.Metadata.GenericParameterConstraintHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.GenericParameterConstraintHandle left, System.Reflection.Metadata.GenericParameterConstraintHandle right) => throw null;
            }
            public struct GenericParameterConstraintHandleCollection : System.Collections.Generic.IEnumerable<System.Reflection.Metadata.GenericParameterConstraintHandle>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Reflection.Metadata.GenericParameterConstraintHandle>, System.Collections.Generic.IReadOnlyList<System.Reflection.Metadata.GenericParameterConstraintHandle>
            {
                public int Count { get => throw null; }
                public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<System.Reflection.Metadata.GenericParameterConstraintHandle>, System.Collections.IEnumerator
                {
                    public System.Reflection.Metadata.GenericParameterConstraintHandle Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    void System.IDisposable.Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }
                public System.Reflection.Metadata.GenericParameterConstraintHandleCollection.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Reflection.Metadata.GenericParameterConstraintHandle> System.Collections.Generic.IEnumerable<System.Reflection.Metadata.GenericParameterConstraintHandle>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public System.Reflection.Metadata.GenericParameterConstraintHandle this[int index] { get => throw null; }
            }
            public struct GenericParameterHandle : System.IEquatable<System.Reflection.Metadata.GenericParameterHandle>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.GenericParameterHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.GenericParameterHandle left, System.Reflection.Metadata.GenericParameterHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.GenericParameterHandle(System.Reflection.Metadata.EntityHandle handle) => throw null;
                public static explicit operator System.Reflection.Metadata.GenericParameterHandle(System.Reflection.Metadata.Handle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.EntityHandle(System.Reflection.Metadata.GenericParameterHandle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.Handle(System.Reflection.Metadata.GenericParameterHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.GenericParameterHandle left, System.Reflection.Metadata.GenericParameterHandle right) => throw null;
            }
            public struct GenericParameterHandleCollection : System.Collections.Generic.IEnumerable<System.Reflection.Metadata.GenericParameterHandle>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Reflection.Metadata.GenericParameterHandle>, System.Collections.Generic.IReadOnlyList<System.Reflection.Metadata.GenericParameterHandle>
            {
                public int Count { get => throw null; }
                public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<System.Reflection.Metadata.GenericParameterHandle>, System.Collections.IEnumerator
                {
                    public System.Reflection.Metadata.GenericParameterHandle Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    void System.IDisposable.Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }
                public System.Reflection.Metadata.GenericParameterHandleCollection.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Reflection.Metadata.GenericParameterHandle> System.Collections.Generic.IEnumerable<System.Reflection.Metadata.GenericParameterHandle>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public System.Reflection.Metadata.GenericParameterHandle this[int index] { get => throw null; }
            }
            public struct GuidHandle : System.IEquatable<System.Reflection.Metadata.GuidHandle>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.GuidHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.GuidHandle left, System.Reflection.Metadata.GuidHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.GuidHandle(System.Reflection.Metadata.Handle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.Handle(System.Reflection.Metadata.GuidHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.GuidHandle left, System.Reflection.Metadata.GuidHandle right) => throw null;
            }
            public struct Handle : System.IEquatable<System.Reflection.Metadata.Handle>
            {
                public static readonly System.Reflection.Metadata.AssemblyDefinitionHandle AssemblyDefinition;
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.Handle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public System.Reflection.Metadata.HandleKind Kind { get => throw null; }
                public static readonly System.Reflection.Metadata.ModuleDefinitionHandle ModuleDefinition;
                public static bool operator ==(System.Reflection.Metadata.Handle left, System.Reflection.Metadata.Handle right) => throw null;
                public static bool operator !=(System.Reflection.Metadata.Handle left, System.Reflection.Metadata.Handle right) => throw null;
            }
            public sealed class HandleComparer : System.Collections.Generic.IComparer<System.Reflection.Metadata.EntityHandle>, System.Collections.Generic.IComparer<System.Reflection.Metadata.Handle>, System.Collections.Generic.IEqualityComparer<System.Reflection.Metadata.EntityHandle>, System.Collections.Generic.IEqualityComparer<System.Reflection.Metadata.Handle>
            {
                public int Compare(System.Reflection.Metadata.EntityHandle x, System.Reflection.Metadata.EntityHandle y) => throw null;
                public int Compare(System.Reflection.Metadata.Handle x, System.Reflection.Metadata.Handle y) => throw null;
                public static System.Reflection.Metadata.HandleComparer Default { get => throw null; }
                public bool Equals(System.Reflection.Metadata.EntityHandle x, System.Reflection.Metadata.EntityHandle y) => throw null;
                public bool Equals(System.Reflection.Metadata.Handle x, System.Reflection.Metadata.Handle y) => throw null;
                public int GetHashCode(System.Reflection.Metadata.EntityHandle obj) => throw null;
                public int GetHashCode(System.Reflection.Metadata.Handle obj) => throw null;
            }
            public enum HandleKind : byte
            {
                ModuleDefinition = 0,
                TypeReference = 1,
                TypeDefinition = 2,
                FieldDefinition = 4,
                MethodDefinition = 6,
                Parameter = 8,
                InterfaceImplementation = 9,
                MemberReference = 10,
                Constant = 11,
                CustomAttribute = 12,
                DeclarativeSecurityAttribute = 14,
                StandaloneSignature = 17,
                EventDefinition = 20,
                PropertyDefinition = 23,
                MethodImplementation = 25,
                ModuleReference = 26,
                TypeSpecification = 27,
                AssemblyDefinition = 32,
                AssemblyReference = 35,
                AssemblyFile = 38,
                ExportedType = 39,
                ManifestResource = 40,
                GenericParameter = 42,
                MethodSpecification = 43,
                GenericParameterConstraint = 44,
                Document = 48,
                MethodDebugInformation = 49,
                LocalScope = 50,
                LocalVariable = 51,
                LocalConstant = 52,
                ImportScope = 53,
                CustomDebugInformation = 55,
                UserString = 112,
                Blob = 113,
                Guid = 114,
                String = 120,
                NamespaceDefinition = 124,
            }
            public interface IConstructedTypeProvider<TType> : System.Reflection.Metadata.ISZArrayTypeProvider<TType>
            {
                TType GetArrayType(TType elementType, System.Reflection.Metadata.ArrayShape shape);
                TType GetByReferenceType(TType elementType);
                TType GetGenericInstantiation(TType genericType, System.Collections.Immutable.ImmutableArray<TType> typeArguments);
                TType GetPointerType(TType elementType);
            }
            public interface ICustomAttributeTypeProvider<TType> : System.Reflection.Metadata.ISimpleTypeProvider<TType>, System.Reflection.Metadata.ISZArrayTypeProvider<TType>
            {
                TType GetSystemType();
                TType GetTypeFromSerializedName(string name);
                System.Reflection.Metadata.PrimitiveTypeCode GetUnderlyingEnumType(TType type);
                bool IsSystemType(TType type);
            }
            public enum ILOpCode : ushort
            {
                Nop = 0,
                Break = 1,
                Ldarg_0 = 2,
                Ldarg_1 = 3,
                Ldarg_2 = 4,
                Ldarg_3 = 5,
                Ldloc_0 = 6,
                Ldloc_1 = 7,
                Ldloc_2 = 8,
                Ldloc_3 = 9,
                Stloc_0 = 10,
                Stloc_1 = 11,
                Stloc_2 = 12,
                Stloc_3 = 13,
                Ldarg_s = 14,
                Ldarga_s = 15,
                Starg_s = 16,
                Ldloc_s = 17,
                Ldloca_s = 18,
                Stloc_s = 19,
                Ldnull = 20,
                Ldc_i4_m1 = 21,
                Ldc_i4_0 = 22,
                Ldc_i4_1 = 23,
                Ldc_i4_2 = 24,
                Ldc_i4_3 = 25,
                Ldc_i4_4 = 26,
                Ldc_i4_5 = 27,
                Ldc_i4_6 = 28,
                Ldc_i4_7 = 29,
                Ldc_i4_8 = 30,
                Ldc_i4_s = 31,
                Ldc_i4 = 32,
                Ldc_i8 = 33,
                Ldc_r4 = 34,
                Ldc_r8 = 35,
                Dup = 37,
                Pop = 38,
                Jmp = 39,
                Call = 40,
                Calli = 41,
                Ret = 42,
                Br_s = 43,
                Brfalse_s = 44,
                Brtrue_s = 45,
                Beq_s = 46,
                Bge_s = 47,
                Bgt_s = 48,
                Ble_s = 49,
                Blt_s = 50,
                Bne_un_s = 51,
                Bge_un_s = 52,
                Bgt_un_s = 53,
                Ble_un_s = 54,
                Blt_un_s = 55,
                Br = 56,
                Brfalse = 57,
                Brtrue = 58,
                Beq = 59,
                Bge = 60,
                Bgt = 61,
                Ble = 62,
                Blt = 63,
                Bne_un = 64,
                Bge_un = 65,
                Bgt_un = 66,
                Ble_un = 67,
                Blt_un = 68,
                Switch = 69,
                Ldind_i1 = 70,
                Ldind_u1 = 71,
                Ldind_i2 = 72,
                Ldind_u2 = 73,
                Ldind_i4 = 74,
                Ldind_u4 = 75,
                Ldind_i8 = 76,
                Ldind_i = 77,
                Ldind_r4 = 78,
                Ldind_r8 = 79,
                Ldind_ref = 80,
                Stind_ref = 81,
                Stind_i1 = 82,
                Stind_i2 = 83,
                Stind_i4 = 84,
                Stind_i8 = 85,
                Stind_r4 = 86,
                Stind_r8 = 87,
                Add = 88,
                Sub = 89,
                Mul = 90,
                Div = 91,
                Div_un = 92,
                Rem = 93,
                Rem_un = 94,
                And = 95,
                Or = 96,
                Xor = 97,
                Shl = 98,
                Shr = 99,
                Shr_un = 100,
                Neg = 101,
                Not = 102,
                Conv_i1 = 103,
                Conv_i2 = 104,
                Conv_i4 = 105,
                Conv_i8 = 106,
                Conv_r4 = 107,
                Conv_r8 = 108,
                Conv_u4 = 109,
                Conv_u8 = 110,
                Callvirt = 111,
                Cpobj = 112,
                Ldobj = 113,
                Ldstr = 114,
                Newobj = 115,
                Castclass = 116,
                Isinst = 117,
                Conv_r_un = 118,
                Unbox = 121,
                Throw = 122,
                Ldfld = 123,
                Ldflda = 124,
                Stfld = 125,
                Ldsfld = 126,
                Ldsflda = 127,
                Stsfld = 128,
                Stobj = 129,
                Conv_ovf_i1_un = 130,
                Conv_ovf_i2_un = 131,
                Conv_ovf_i4_un = 132,
                Conv_ovf_i8_un = 133,
                Conv_ovf_u1_un = 134,
                Conv_ovf_u2_un = 135,
                Conv_ovf_u4_un = 136,
                Conv_ovf_u8_un = 137,
                Conv_ovf_i_un = 138,
                Conv_ovf_u_un = 139,
                Box = 140,
                Newarr = 141,
                Ldlen = 142,
                Ldelema = 143,
                Ldelem_i1 = 144,
                Ldelem_u1 = 145,
                Ldelem_i2 = 146,
                Ldelem_u2 = 147,
                Ldelem_i4 = 148,
                Ldelem_u4 = 149,
                Ldelem_i8 = 150,
                Ldelem_i = 151,
                Ldelem_r4 = 152,
                Ldelem_r8 = 153,
                Ldelem_ref = 154,
                Stelem_i = 155,
                Stelem_i1 = 156,
                Stelem_i2 = 157,
                Stelem_i4 = 158,
                Stelem_i8 = 159,
                Stelem_r4 = 160,
                Stelem_r8 = 161,
                Stelem_ref = 162,
                Ldelem = 163,
                Stelem = 164,
                Unbox_any = 165,
                Conv_ovf_i1 = 179,
                Conv_ovf_u1 = 180,
                Conv_ovf_i2 = 181,
                Conv_ovf_u2 = 182,
                Conv_ovf_i4 = 183,
                Conv_ovf_u4 = 184,
                Conv_ovf_i8 = 185,
                Conv_ovf_u8 = 186,
                Refanyval = 194,
                Ckfinite = 195,
                Mkrefany = 198,
                Ldtoken = 208,
                Conv_u2 = 209,
                Conv_u1 = 210,
                Conv_i = 211,
                Conv_ovf_i = 212,
                Conv_ovf_u = 213,
                Add_ovf = 214,
                Add_ovf_un = 215,
                Mul_ovf = 216,
                Mul_ovf_un = 217,
                Sub_ovf = 218,
                Sub_ovf_un = 219,
                Endfinally = 220,
                Leave = 221,
                Leave_s = 222,
                Stind_i = 223,
                Conv_u = 224,
                Arglist = 65024,
                Ceq = 65025,
                Cgt = 65026,
                Cgt_un = 65027,
                Clt = 65028,
                Clt_un = 65029,
                Ldftn = 65030,
                Ldvirtftn = 65031,
                Ldarg = 65033,
                Ldarga = 65034,
                Starg = 65035,
                Ldloc = 65036,
                Ldloca = 65037,
                Stloc = 65038,
                Localloc = 65039,
                Endfilter = 65041,
                Unaligned = 65042,
                Volatile = 65043,
                Tail = 65044,
                Initobj = 65045,
                Constrained = 65046,
                Cpblk = 65047,
                Initblk = 65048,
                Rethrow = 65050,
                Sizeof = 65052,
                Refanytype = 65053,
                Readonly = 65054,
            }
            public static partial class ILOpCodeExtensions
            {
                public static int GetBranchOperandSize(this System.Reflection.Metadata.ILOpCode opCode) => throw null;
                public static System.Reflection.Metadata.ILOpCode GetLongBranch(this System.Reflection.Metadata.ILOpCode opCode) => throw null;
                public static System.Reflection.Metadata.ILOpCode GetShortBranch(this System.Reflection.Metadata.ILOpCode opCode) => throw null;
                public static bool IsBranch(this System.Reflection.Metadata.ILOpCode opCode) => throw null;
            }
            public class ImageFormatLimitationException : System.Exception
            {
                public ImageFormatLimitationException() => throw null;
                public ImageFormatLimitationException(string message) => throw null;
                public ImageFormatLimitationException(string message, System.Exception innerException) => throw null;
                protected ImageFormatLimitationException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            }
            public struct ImportDefinition
            {
                public System.Reflection.Metadata.BlobHandle Alias { get => throw null; }
                public System.Reflection.Metadata.ImportDefinitionKind Kind { get => throw null; }
                public System.Reflection.Metadata.AssemblyReferenceHandle TargetAssembly { get => throw null; }
                public System.Reflection.Metadata.BlobHandle TargetNamespace { get => throw null; }
                public System.Reflection.Metadata.EntityHandle TargetType { get => throw null; }
            }
            public struct ImportDefinitionCollection : System.Collections.Generic.IEnumerable<System.Reflection.Metadata.ImportDefinition>, System.Collections.IEnumerable
            {
                public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<System.Reflection.Metadata.ImportDefinition>, System.Collections.IEnumerator
                {
                    public System.Reflection.Metadata.ImportDefinition Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    void System.IDisposable.Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    public void Reset() => throw null;
                }
                public System.Reflection.Metadata.ImportDefinitionCollection.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Reflection.Metadata.ImportDefinition> System.Collections.Generic.IEnumerable<System.Reflection.Metadata.ImportDefinition>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            }
            public enum ImportDefinitionKind
            {
                ImportNamespace = 1,
                ImportAssemblyNamespace = 2,
                ImportType = 3,
                ImportXmlNamespace = 4,
                ImportAssemblyReferenceAlias = 5,
                AliasAssemblyReference = 6,
                AliasNamespace = 7,
                AliasAssemblyNamespace = 8,
                AliasType = 9,
            }
            public struct ImportScope
            {
                public System.Reflection.Metadata.ImportDefinitionCollection GetImports() => throw null;
                public System.Reflection.Metadata.BlobHandle ImportsBlob { get => throw null; }
                public System.Reflection.Metadata.ImportScopeHandle Parent { get => throw null; }
            }
            public struct ImportScopeCollection : System.Collections.Generic.IEnumerable<System.Reflection.Metadata.ImportScopeHandle>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Reflection.Metadata.ImportScopeHandle>
            {
                public int Count { get => throw null; }
                public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<System.Reflection.Metadata.ImportScopeHandle>, System.Collections.IEnumerator
                {
                    public System.Reflection.Metadata.ImportScopeHandle Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    void System.IDisposable.Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }
                public System.Reflection.Metadata.ImportScopeCollection.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Reflection.Metadata.ImportScopeHandle> System.Collections.Generic.IEnumerable<System.Reflection.Metadata.ImportScopeHandle>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            }
            public struct ImportScopeHandle : System.IEquatable<System.Reflection.Metadata.ImportScopeHandle>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.ImportScopeHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.ImportScopeHandle left, System.Reflection.Metadata.ImportScopeHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.ImportScopeHandle(System.Reflection.Metadata.EntityHandle handle) => throw null;
                public static explicit operator System.Reflection.Metadata.ImportScopeHandle(System.Reflection.Metadata.Handle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.EntityHandle(System.Reflection.Metadata.ImportScopeHandle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.Handle(System.Reflection.Metadata.ImportScopeHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.ImportScopeHandle left, System.Reflection.Metadata.ImportScopeHandle right) => throw null;
            }
            public struct InterfaceImplementation
            {
                public System.Reflection.Metadata.CustomAttributeHandleCollection GetCustomAttributes() => throw null;
                public System.Reflection.Metadata.EntityHandle Interface { get => throw null; }
            }
            public struct InterfaceImplementationHandle : System.IEquatable<System.Reflection.Metadata.InterfaceImplementationHandle>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.InterfaceImplementationHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.InterfaceImplementationHandle left, System.Reflection.Metadata.InterfaceImplementationHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.InterfaceImplementationHandle(System.Reflection.Metadata.EntityHandle handle) => throw null;
                public static explicit operator System.Reflection.Metadata.InterfaceImplementationHandle(System.Reflection.Metadata.Handle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.EntityHandle(System.Reflection.Metadata.InterfaceImplementationHandle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.Handle(System.Reflection.Metadata.InterfaceImplementationHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.InterfaceImplementationHandle left, System.Reflection.Metadata.InterfaceImplementationHandle right) => throw null;
            }
            public struct InterfaceImplementationHandleCollection : System.Collections.Generic.IEnumerable<System.Reflection.Metadata.InterfaceImplementationHandle>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Reflection.Metadata.InterfaceImplementationHandle>
            {
                public int Count { get => throw null; }
                public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<System.Reflection.Metadata.InterfaceImplementationHandle>, System.Collections.IEnumerator
                {
                    public System.Reflection.Metadata.InterfaceImplementationHandle Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    void System.IDisposable.Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }
                public System.Reflection.Metadata.InterfaceImplementationHandleCollection.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Reflection.Metadata.InterfaceImplementationHandle> System.Collections.Generic.IEnumerable<System.Reflection.Metadata.InterfaceImplementationHandle>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            }
            public interface ISignatureTypeProvider<TType, TGenericContext> : System.Reflection.Metadata.IConstructedTypeProvider<TType>, System.Reflection.Metadata.ISimpleTypeProvider<TType>, System.Reflection.Metadata.ISZArrayTypeProvider<TType>
            {
                TType GetFunctionPointerType(System.Reflection.Metadata.MethodSignature<TType> signature);
                TType GetGenericMethodParameter(TGenericContext genericContext, int index);
                TType GetGenericTypeParameter(TGenericContext genericContext, int index);
                TType GetModifiedType(TType modifier, TType unmodifiedType, bool isRequired);
                TType GetPinnedType(TType elementType);
                TType GetTypeFromSpecification(System.Reflection.Metadata.MetadataReader reader, TGenericContext genericContext, System.Reflection.Metadata.TypeSpecificationHandle handle, byte rawTypeKind);
            }
            public interface ISimpleTypeProvider<TType>
            {
                TType GetPrimitiveType(System.Reflection.Metadata.PrimitiveTypeCode typeCode);
                TType GetTypeFromDefinition(System.Reflection.Metadata.MetadataReader reader, System.Reflection.Metadata.TypeDefinitionHandle handle, byte rawTypeKind);
                TType GetTypeFromReference(System.Reflection.Metadata.MetadataReader reader, System.Reflection.Metadata.TypeReferenceHandle handle, byte rawTypeKind);
            }
            public interface ISZArrayTypeProvider<TType>
            {
                TType GetSZArrayType(TType elementType);
            }
            public struct LocalConstant
            {
                public System.Reflection.Metadata.StringHandle Name { get => throw null; }
                public System.Reflection.Metadata.BlobHandle Signature { get => throw null; }
            }
            public struct LocalConstantHandle : System.IEquatable<System.Reflection.Metadata.LocalConstantHandle>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.LocalConstantHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.LocalConstantHandle left, System.Reflection.Metadata.LocalConstantHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.LocalConstantHandle(System.Reflection.Metadata.EntityHandle handle) => throw null;
                public static explicit operator System.Reflection.Metadata.LocalConstantHandle(System.Reflection.Metadata.Handle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.EntityHandle(System.Reflection.Metadata.LocalConstantHandle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.Handle(System.Reflection.Metadata.LocalConstantHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.LocalConstantHandle left, System.Reflection.Metadata.LocalConstantHandle right) => throw null;
            }
            public struct LocalConstantHandleCollection : System.Collections.Generic.IEnumerable<System.Reflection.Metadata.LocalConstantHandle>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Reflection.Metadata.LocalConstantHandle>
            {
                public int Count { get => throw null; }
                public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<System.Reflection.Metadata.LocalConstantHandle>, System.Collections.IEnumerator
                {
                    public System.Reflection.Metadata.LocalConstantHandle Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    void System.IDisposable.Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }
                public System.Reflection.Metadata.LocalConstantHandleCollection.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Reflection.Metadata.LocalConstantHandle> System.Collections.Generic.IEnumerable<System.Reflection.Metadata.LocalConstantHandle>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            }
            public struct LocalScope
            {
                public int EndOffset { get => throw null; }
                public System.Reflection.Metadata.LocalScopeHandleCollection.ChildrenEnumerator GetChildren() => throw null;
                public System.Reflection.Metadata.LocalConstantHandleCollection GetLocalConstants() => throw null;
                public System.Reflection.Metadata.LocalVariableHandleCollection GetLocalVariables() => throw null;
                public System.Reflection.Metadata.ImportScopeHandle ImportScope { get => throw null; }
                public int Length { get => throw null; }
                public System.Reflection.Metadata.MethodDefinitionHandle Method { get => throw null; }
                public int StartOffset { get => throw null; }
            }
            public struct LocalScopeHandle : System.IEquatable<System.Reflection.Metadata.LocalScopeHandle>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.LocalScopeHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.LocalScopeHandle left, System.Reflection.Metadata.LocalScopeHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.LocalScopeHandle(System.Reflection.Metadata.EntityHandle handle) => throw null;
                public static explicit operator System.Reflection.Metadata.LocalScopeHandle(System.Reflection.Metadata.Handle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.EntityHandle(System.Reflection.Metadata.LocalScopeHandle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.Handle(System.Reflection.Metadata.LocalScopeHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.LocalScopeHandle left, System.Reflection.Metadata.LocalScopeHandle right) => throw null;
            }
            public struct LocalScopeHandleCollection : System.Collections.Generic.IEnumerable<System.Reflection.Metadata.LocalScopeHandle>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Reflection.Metadata.LocalScopeHandle>
            {
                public struct ChildrenEnumerator : System.IDisposable, System.Collections.Generic.IEnumerator<System.Reflection.Metadata.LocalScopeHandle>, System.Collections.IEnumerator
                {
                    public System.Reflection.Metadata.LocalScopeHandle Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    void System.IDisposable.Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }
                public int Count { get => throw null; }
                public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<System.Reflection.Metadata.LocalScopeHandle>, System.Collections.IEnumerator
                {
                    public System.Reflection.Metadata.LocalScopeHandle Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    void System.IDisposable.Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }
                public System.Reflection.Metadata.LocalScopeHandleCollection.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Reflection.Metadata.LocalScopeHandle> System.Collections.Generic.IEnumerable<System.Reflection.Metadata.LocalScopeHandle>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            }
            public struct LocalVariable
            {
                public System.Reflection.Metadata.LocalVariableAttributes Attributes { get => throw null; }
                public int Index { get => throw null; }
                public System.Reflection.Metadata.StringHandle Name { get => throw null; }
            }
            [System.Flags]
            public enum LocalVariableAttributes
            {
                None = 0,
                DebuggerHidden = 1,
            }
            public struct LocalVariableHandle : System.IEquatable<System.Reflection.Metadata.LocalVariableHandle>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.LocalVariableHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.LocalVariableHandle left, System.Reflection.Metadata.LocalVariableHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.LocalVariableHandle(System.Reflection.Metadata.EntityHandle handle) => throw null;
                public static explicit operator System.Reflection.Metadata.LocalVariableHandle(System.Reflection.Metadata.Handle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.EntityHandle(System.Reflection.Metadata.LocalVariableHandle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.Handle(System.Reflection.Metadata.LocalVariableHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.LocalVariableHandle left, System.Reflection.Metadata.LocalVariableHandle right) => throw null;
            }
            public struct LocalVariableHandleCollection : System.Collections.Generic.IEnumerable<System.Reflection.Metadata.LocalVariableHandle>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Reflection.Metadata.LocalVariableHandle>
            {
                public int Count { get => throw null; }
                public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<System.Reflection.Metadata.LocalVariableHandle>, System.Collections.IEnumerator
                {
                    public System.Reflection.Metadata.LocalVariableHandle Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    void System.IDisposable.Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }
                public System.Reflection.Metadata.LocalVariableHandleCollection.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Reflection.Metadata.LocalVariableHandle> System.Collections.Generic.IEnumerable<System.Reflection.Metadata.LocalVariableHandle>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            }
            public struct ManifestResource
            {
                public System.Reflection.ManifestResourceAttributes Attributes { get => throw null; }
                public System.Reflection.Metadata.CustomAttributeHandleCollection GetCustomAttributes() => throw null;
                public System.Reflection.Metadata.EntityHandle Implementation { get => throw null; }
                public System.Reflection.Metadata.StringHandle Name { get => throw null; }
                public long Offset { get => throw null; }
            }
            public struct ManifestResourceHandle : System.IEquatable<System.Reflection.Metadata.ManifestResourceHandle>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.ManifestResourceHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.ManifestResourceHandle left, System.Reflection.Metadata.ManifestResourceHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.ManifestResourceHandle(System.Reflection.Metadata.EntityHandle handle) => throw null;
                public static explicit operator System.Reflection.Metadata.ManifestResourceHandle(System.Reflection.Metadata.Handle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.EntityHandle(System.Reflection.Metadata.ManifestResourceHandle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.Handle(System.Reflection.Metadata.ManifestResourceHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.ManifestResourceHandle left, System.Reflection.Metadata.ManifestResourceHandle right) => throw null;
            }
            public struct ManifestResourceHandleCollection : System.Collections.Generic.IEnumerable<System.Reflection.Metadata.ManifestResourceHandle>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Reflection.Metadata.ManifestResourceHandle>
            {
                public int Count { get => throw null; }
                public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<System.Reflection.Metadata.ManifestResourceHandle>, System.Collections.IEnumerator
                {
                    public System.Reflection.Metadata.ManifestResourceHandle Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    void System.IDisposable.Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }
                public System.Reflection.Metadata.ManifestResourceHandleCollection.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Reflection.Metadata.ManifestResourceHandle> System.Collections.Generic.IEnumerable<System.Reflection.Metadata.ManifestResourceHandle>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            }
            public struct MemberReference
            {
                public TType DecodeFieldSignature<TType, TGenericContext>(System.Reflection.Metadata.ISignatureTypeProvider<TType, TGenericContext> provider, TGenericContext genericContext) => throw null;
                public System.Reflection.Metadata.MethodSignature<TType> DecodeMethodSignature<TType, TGenericContext>(System.Reflection.Metadata.ISignatureTypeProvider<TType, TGenericContext> provider, TGenericContext genericContext) => throw null;
                public System.Reflection.Metadata.CustomAttributeHandleCollection GetCustomAttributes() => throw null;
                public System.Reflection.Metadata.MemberReferenceKind GetKind() => throw null;
                public System.Reflection.Metadata.StringHandle Name { get => throw null; }
                public System.Reflection.Metadata.EntityHandle Parent { get => throw null; }
                public System.Reflection.Metadata.BlobHandle Signature { get => throw null; }
            }
            public struct MemberReferenceHandle : System.IEquatable<System.Reflection.Metadata.MemberReferenceHandle>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.MemberReferenceHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.MemberReferenceHandle left, System.Reflection.Metadata.MemberReferenceHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.MemberReferenceHandle(System.Reflection.Metadata.EntityHandle handle) => throw null;
                public static explicit operator System.Reflection.Metadata.MemberReferenceHandle(System.Reflection.Metadata.Handle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.EntityHandle(System.Reflection.Metadata.MemberReferenceHandle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.Handle(System.Reflection.Metadata.MemberReferenceHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.MemberReferenceHandle left, System.Reflection.Metadata.MemberReferenceHandle right) => throw null;
            }
            public struct MemberReferenceHandleCollection : System.Collections.Generic.IEnumerable<System.Reflection.Metadata.MemberReferenceHandle>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Reflection.Metadata.MemberReferenceHandle>
            {
                public int Count { get => throw null; }
                public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<System.Reflection.Metadata.MemberReferenceHandle>, System.Collections.IEnumerator
                {
                    public System.Reflection.Metadata.MemberReferenceHandle Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    void System.IDisposable.Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }
                public System.Reflection.Metadata.MemberReferenceHandleCollection.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Reflection.Metadata.MemberReferenceHandle> System.Collections.Generic.IEnumerable<System.Reflection.Metadata.MemberReferenceHandle>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            }
            public enum MemberReferenceKind
            {
                Method = 0,
                Field = 1,
            }
            public enum MetadataKind
            {
                Ecma335 = 0,
                WindowsMetadata = 1,
                ManagedWindowsMetadata = 2,
            }
            public sealed class MetadataReader
            {
                public System.Reflection.Metadata.AssemblyFileHandleCollection AssemblyFiles { get => throw null; }
                public System.Reflection.Metadata.AssemblyReferenceHandleCollection AssemblyReferences { get => throw null; }
                public unsafe MetadataReader(byte* metadata, int length) => throw null;
                public unsafe MetadataReader(byte* metadata, int length, System.Reflection.Metadata.MetadataReaderOptions options) => throw null;
                public unsafe MetadataReader(byte* metadata, int length, System.Reflection.Metadata.MetadataReaderOptions options, System.Reflection.Metadata.MetadataStringDecoder utf8Decoder) => throw null;
                public System.Reflection.Metadata.CustomAttributeHandleCollection CustomAttributes { get => throw null; }
                public System.Reflection.Metadata.CustomDebugInformationHandleCollection CustomDebugInformation { get => throw null; }
                public System.Reflection.Metadata.DebugMetadataHeader DebugMetadataHeader { get => throw null; }
                public System.Reflection.Metadata.DeclarativeSecurityAttributeHandleCollection DeclarativeSecurityAttributes { get => throw null; }
                public System.Reflection.Metadata.DocumentHandleCollection Documents { get => throw null; }
                public System.Reflection.Metadata.EventDefinitionHandleCollection EventDefinitions { get => throw null; }
                public System.Reflection.Metadata.ExportedTypeHandleCollection ExportedTypes { get => throw null; }
                public System.Reflection.Metadata.FieldDefinitionHandleCollection FieldDefinitions { get => throw null; }
                public System.Reflection.Metadata.AssemblyDefinition GetAssemblyDefinition() => throw null;
                public System.Reflection.Metadata.AssemblyFile GetAssemblyFile(System.Reflection.Metadata.AssemblyFileHandle handle) => throw null;
                public static System.Reflection.AssemblyName GetAssemblyName(string assemblyFile) => throw null;
                public System.Reflection.Metadata.AssemblyReference GetAssemblyReference(System.Reflection.Metadata.AssemblyReferenceHandle handle) => throw null;
                public byte[] GetBlobBytes(System.Reflection.Metadata.BlobHandle handle) => throw null;
                public System.Collections.Immutable.ImmutableArray<byte> GetBlobContent(System.Reflection.Metadata.BlobHandle handle) => throw null;
                public System.Reflection.Metadata.BlobReader GetBlobReader(System.Reflection.Metadata.BlobHandle handle) => throw null;
                public System.Reflection.Metadata.BlobReader GetBlobReader(System.Reflection.Metadata.StringHandle handle) => throw null;
                public System.Reflection.Metadata.Constant GetConstant(System.Reflection.Metadata.ConstantHandle handle) => throw null;
                public System.Reflection.Metadata.CustomAttribute GetCustomAttribute(System.Reflection.Metadata.CustomAttributeHandle handle) => throw null;
                public System.Reflection.Metadata.CustomAttributeHandleCollection GetCustomAttributes(System.Reflection.Metadata.EntityHandle handle) => throw null;
                public System.Reflection.Metadata.CustomDebugInformation GetCustomDebugInformation(System.Reflection.Metadata.CustomDebugInformationHandle handle) => throw null;
                public System.Reflection.Metadata.CustomDebugInformationHandleCollection GetCustomDebugInformation(System.Reflection.Metadata.EntityHandle handle) => throw null;
                public System.Reflection.Metadata.DeclarativeSecurityAttribute GetDeclarativeSecurityAttribute(System.Reflection.Metadata.DeclarativeSecurityAttributeHandle handle) => throw null;
                public System.Reflection.Metadata.Document GetDocument(System.Reflection.Metadata.DocumentHandle handle) => throw null;
                public System.Reflection.Metadata.EventDefinition GetEventDefinition(System.Reflection.Metadata.EventDefinitionHandle handle) => throw null;
                public System.Reflection.Metadata.ExportedType GetExportedType(System.Reflection.Metadata.ExportedTypeHandle handle) => throw null;
                public System.Reflection.Metadata.FieldDefinition GetFieldDefinition(System.Reflection.Metadata.FieldDefinitionHandle handle) => throw null;
                public System.Reflection.Metadata.GenericParameter GetGenericParameter(System.Reflection.Metadata.GenericParameterHandle handle) => throw null;
                public System.Reflection.Metadata.GenericParameterConstraint GetGenericParameterConstraint(System.Reflection.Metadata.GenericParameterConstraintHandle handle) => throw null;
                public System.Guid GetGuid(System.Reflection.Metadata.GuidHandle handle) => throw null;
                public System.Reflection.Metadata.ImportScope GetImportScope(System.Reflection.Metadata.ImportScopeHandle handle) => throw null;
                public System.Reflection.Metadata.InterfaceImplementation GetInterfaceImplementation(System.Reflection.Metadata.InterfaceImplementationHandle handle) => throw null;
                public System.Reflection.Metadata.LocalConstant GetLocalConstant(System.Reflection.Metadata.LocalConstantHandle handle) => throw null;
                public System.Reflection.Metadata.LocalScope GetLocalScope(System.Reflection.Metadata.LocalScopeHandle handle) => throw null;
                public System.Reflection.Metadata.LocalScopeHandleCollection GetLocalScopes(System.Reflection.Metadata.MethodDebugInformationHandle handle) => throw null;
                public System.Reflection.Metadata.LocalScopeHandleCollection GetLocalScopes(System.Reflection.Metadata.MethodDefinitionHandle handle) => throw null;
                public System.Reflection.Metadata.LocalVariable GetLocalVariable(System.Reflection.Metadata.LocalVariableHandle handle) => throw null;
                public System.Reflection.Metadata.ManifestResource GetManifestResource(System.Reflection.Metadata.ManifestResourceHandle handle) => throw null;
                public System.Reflection.Metadata.MemberReference GetMemberReference(System.Reflection.Metadata.MemberReferenceHandle handle) => throw null;
                public System.Reflection.Metadata.MethodDebugInformation GetMethodDebugInformation(System.Reflection.Metadata.MethodDebugInformationHandle handle) => throw null;
                public System.Reflection.Metadata.MethodDebugInformation GetMethodDebugInformation(System.Reflection.Metadata.MethodDefinitionHandle handle) => throw null;
                public System.Reflection.Metadata.MethodDefinition GetMethodDefinition(System.Reflection.Metadata.MethodDefinitionHandle handle) => throw null;
                public System.Reflection.Metadata.MethodImplementation GetMethodImplementation(System.Reflection.Metadata.MethodImplementationHandle handle) => throw null;
                public System.Reflection.Metadata.MethodSpecification GetMethodSpecification(System.Reflection.Metadata.MethodSpecificationHandle handle) => throw null;
                public System.Reflection.Metadata.ModuleDefinition GetModuleDefinition() => throw null;
                public System.Reflection.Metadata.ModuleReference GetModuleReference(System.Reflection.Metadata.ModuleReferenceHandle handle) => throw null;
                public System.Reflection.Metadata.NamespaceDefinition GetNamespaceDefinition(System.Reflection.Metadata.NamespaceDefinitionHandle handle) => throw null;
                public System.Reflection.Metadata.NamespaceDefinition GetNamespaceDefinitionRoot() => throw null;
                public System.Reflection.Metadata.Parameter GetParameter(System.Reflection.Metadata.ParameterHandle handle) => throw null;
                public System.Reflection.Metadata.PropertyDefinition GetPropertyDefinition(System.Reflection.Metadata.PropertyDefinitionHandle handle) => throw null;
                public System.Reflection.Metadata.StandaloneSignature GetStandaloneSignature(System.Reflection.Metadata.StandaloneSignatureHandle handle) => throw null;
                public string GetString(System.Reflection.Metadata.DocumentNameBlobHandle handle) => throw null;
                public string GetString(System.Reflection.Metadata.NamespaceDefinitionHandle handle) => throw null;
                public string GetString(System.Reflection.Metadata.StringHandle handle) => throw null;
                public System.Reflection.Metadata.TypeDefinition GetTypeDefinition(System.Reflection.Metadata.TypeDefinitionHandle handle) => throw null;
                public System.Reflection.Metadata.TypeReference GetTypeReference(System.Reflection.Metadata.TypeReferenceHandle handle) => throw null;
                public System.Reflection.Metadata.TypeSpecification GetTypeSpecification(System.Reflection.Metadata.TypeSpecificationHandle handle) => throw null;
                public string GetUserString(System.Reflection.Metadata.UserStringHandle handle) => throw null;
                public System.Reflection.Metadata.ImportScopeCollection ImportScopes { get => throw null; }
                public bool IsAssembly { get => throw null; }
                public System.Reflection.Metadata.LocalConstantHandleCollection LocalConstants { get => throw null; }
                public System.Reflection.Metadata.LocalScopeHandleCollection LocalScopes { get => throw null; }
                public System.Reflection.Metadata.LocalVariableHandleCollection LocalVariables { get => throw null; }
                public System.Reflection.Metadata.ManifestResourceHandleCollection ManifestResources { get => throw null; }
                public System.Reflection.Metadata.MemberReferenceHandleCollection MemberReferences { get => throw null; }
                public System.Reflection.Metadata.MetadataKind MetadataKind { get => throw null; }
                public int MetadataLength { get => throw null; }
                public unsafe byte* MetadataPointer { get => throw null; }
                public string MetadataVersion { get => throw null; }
                public System.Reflection.Metadata.MethodDebugInformationHandleCollection MethodDebugInformation { get => throw null; }
                public System.Reflection.Metadata.MethodDefinitionHandleCollection MethodDefinitions { get => throw null; }
                public System.Reflection.Metadata.MetadataReaderOptions Options { get => throw null; }
                public System.Reflection.Metadata.PropertyDefinitionHandleCollection PropertyDefinitions { get => throw null; }
                public System.Reflection.Metadata.MetadataStringComparer StringComparer { get => throw null; }
                public System.Reflection.Metadata.TypeDefinitionHandleCollection TypeDefinitions { get => throw null; }
                public System.Reflection.Metadata.TypeReferenceHandleCollection TypeReferences { get => throw null; }
                public System.Reflection.Metadata.MetadataStringDecoder UTF8Decoder { get => throw null; }
            }
            [System.Flags]
            public enum MetadataReaderOptions
            {
                None = 0,
                ApplyWindowsRuntimeProjections = 1,
                Default = 1,
            }
            public sealed class MetadataReaderProvider : System.IDisposable
            {
                public void Dispose() => throw null;
                public static unsafe System.Reflection.Metadata.MetadataReaderProvider FromMetadataImage(byte* start, int size) => throw null;
                public static System.Reflection.Metadata.MetadataReaderProvider FromMetadataImage(System.Collections.Immutable.ImmutableArray<byte> image) => throw null;
                public static System.Reflection.Metadata.MetadataReaderProvider FromMetadataStream(System.IO.Stream stream, System.Reflection.Metadata.MetadataStreamOptions options = default(System.Reflection.Metadata.MetadataStreamOptions), int size = default(int)) => throw null;
                public static unsafe System.Reflection.Metadata.MetadataReaderProvider FromPortablePdbImage(byte* start, int size) => throw null;
                public static System.Reflection.Metadata.MetadataReaderProvider FromPortablePdbImage(System.Collections.Immutable.ImmutableArray<byte> image) => throw null;
                public static System.Reflection.Metadata.MetadataReaderProvider FromPortablePdbStream(System.IO.Stream stream, System.Reflection.Metadata.MetadataStreamOptions options = default(System.Reflection.Metadata.MetadataStreamOptions), int size = default(int)) => throw null;
                public System.Reflection.Metadata.MetadataReader GetMetadataReader(System.Reflection.Metadata.MetadataReaderOptions options = default(System.Reflection.Metadata.MetadataReaderOptions), System.Reflection.Metadata.MetadataStringDecoder utf8Decoder = default(System.Reflection.Metadata.MetadataStringDecoder)) => throw null;
            }
            [System.Flags]
            public enum MetadataStreamOptions
            {
                Default = 0,
                LeaveOpen = 1,
                PrefetchMetadata = 2,
            }
            public struct MetadataStringComparer
            {
                public bool Equals(System.Reflection.Metadata.DocumentNameBlobHandle handle, string value) => throw null;
                public bool Equals(System.Reflection.Metadata.DocumentNameBlobHandle handle, string value, bool ignoreCase) => throw null;
                public bool Equals(System.Reflection.Metadata.NamespaceDefinitionHandle handle, string value) => throw null;
                public bool Equals(System.Reflection.Metadata.NamespaceDefinitionHandle handle, string value, bool ignoreCase) => throw null;
                public bool Equals(System.Reflection.Metadata.StringHandle handle, string value) => throw null;
                public bool Equals(System.Reflection.Metadata.StringHandle handle, string value, bool ignoreCase) => throw null;
                public bool StartsWith(System.Reflection.Metadata.StringHandle handle, string value) => throw null;
                public bool StartsWith(System.Reflection.Metadata.StringHandle handle, string value, bool ignoreCase) => throw null;
            }
            public class MetadataStringDecoder
            {
                public MetadataStringDecoder(System.Text.Encoding encoding) => throw null;
                public static System.Reflection.Metadata.MetadataStringDecoder DefaultUTF8 { get => throw null; }
                public System.Text.Encoding Encoding { get => throw null; }
                public virtual unsafe string GetString(byte* bytes, int byteCount) => throw null;
            }
            public sealed class MethodBodyBlock
            {
                public static System.Reflection.Metadata.MethodBodyBlock Create(System.Reflection.Metadata.BlobReader reader) => throw null;
                public System.Collections.Immutable.ImmutableArray<System.Reflection.Metadata.ExceptionRegion> ExceptionRegions { get => throw null; }
                public byte[] GetILBytes() => throw null;
                public System.Collections.Immutable.ImmutableArray<byte> GetILContent() => throw null;
                public System.Reflection.Metadata.BlobReader GetILReader() => throw null;
                public System.Reflection.Metadata.StandaloneSignatureHandle LocalSignature { get => throw null; }
                public bool LocalVariablesInitialized { get => throw null; }
                public int MaxStack { get => throw null; }
                public int Size { get => throw null; }
            }
            public struct MethodDebugInformation
            {
                public System.Reflection.Metadata.DocumentHandle Document { get => throw null; }
                public System.Reflection.Metadata.SequencePointCollection GetSequencePoints() => throw null;
                public System.Reflection.Metadata.MethodDefinitionHandle GetStateMachineKickoffMethod() => throw null;
                public System.Reflection.Metadata.StandaloneSignatureHandle LocalSignature { get => throw null; }
                public System.Reflection.Metadata.BlobHandle SequencePointsBlob { get => throw null; }
            }
            public struct MethodDebugInformationHandle : System.IEquatable<System.Reflection.Metadata.MethodDebugInformationHandle>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.MethodDebugInformationHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.MethodDebugInformationHandle left, System.Reflection.Metadata.MethodDebugInformationHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.MethodDebugInformationHandle(System.Reflection.Metadata.EntityHandle handle) => throw null;
                public static explicit operator System.Reflection.Metadata.MethodDebugInformationHandle(System.Reflection.Metadata.Handle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.EntityHandle(System.Reflection.Metadata.MethodDebugInformationHandle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.Handle(System.Reflection.Metadata.MethodDebugInformationHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.MethodDebugInformationHandle left, System.Reflection.Metadata.MethodDebugInformationHandle right) => throw null;
                public System.Reflection.Metadata.MethodDefinitionHandle ToDefinitionHandle() => throw null;
            }
            public struct MethodDebugInformationHandleCollection : System.Collections.Generic.IEnumerable<System.Reflection.Metadata.MethodDebugInformationHandle>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Reflection.Metadata.MethodDebugInformationHandle>
            {
                public int Count { get => throw null; }
                public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<System.Reflection.Metadata.MethodDebugInformationHandle>, System.Collections.IEnumerator
                {
                    public System.Reflection.Metadata.MethodDebugInformationHandle Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    void System.IDisposable.Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }
                public System.Reflection.Metadata.MethodDebugInformationHandleCollection.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Reflection.Metadata.MethodDebugInformationHandle> System.Collections.Generic.IEnumerable<System.Reflection.Metadata.MethodDebugInformationHandle>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            }
            public struct MethodDefinition
            {
                public System.Reflection.MethodAttributes Attributes { get => throw null; }
                public System.Reflection.Metadata.MethodSignature<TType> DecodeSignature<TType, TGenericContext>(System.Reflection.Metadata.ISignatureTypeProvider<TType, TGenericContext> provider, TGenericContext genericContext) => throw null;
                public System.Reflection.Metadata.CustomAttributeHandleCollection GetCustomAttributes() => throw null;
                public System.Reflection.Metadata.DeclarativeSecurityAttributeHandleCollection GetDeclarativeSecurityAttributes() => throw null;
                public System.Reflection.Metadata.TypeDefinitionHandle GetDeclaringType() => throw null;
                public System.Reflection.Metadata.GenericParameterHandleCollection GetGenericParameters() => throw null;
                public System.Reflection.Metadata.MethodImport GetImport() => throw null;
                public System.Reflection.Metadata.ParameterHandleCollection GetParameters() => throw null;
                public System.Reflection.MethodImplAttributes ImplAttributes { get => throw null; }
                public System.Reflection.Metadata.StringHandle Name { get => throw null; }
                public int RelativeVirtualAddress { get => throw null; }
                public System.Reflection.Metadata.BlobHandle Signature { get => throw null; }
            }
            public struct MethodDefinitionHandle : System.IEquatable<System.Reflection.Metadata.MethodDefinitionHandle>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.MethodDefinitionHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.MethodDefinitionHandle left, System.Reflection.Metadata.MethodDefinitionHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.MethodDefinitionHandle(System.Reflection.Metadata.EntityHandle handle) => throw null;
                public static explicit operator System.Reflection.Metadata.MethodDefinitionHandle(System.Reflection.Metadata.Handle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.EntityHandle(System.Reflection.Metadata.MethodDefinitionHandle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.Handle(System.Reflection.Metadata.MethodDefinitionHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.MethodDefinitionHandle left, System.Reflection.Metadata.MethodDefinitionHandle right) => throw null;
                public System.Reflection.Metadata.MethodDebugInformationHandle ToDebugInformationHandle() => throw null;
            }
            public struct MethodDefinitionHandleCollection : System.Collections.Generic.IEnumerable<System.Reflection.Metadata.MethodDefinitionHandle>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Reflection.Metadata.MethodDefinitionHandle>
            {
                public int Count { get => throw null; }
                public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<System.Reflection.Metadata.MethodDefinitionHandle>, System.Collections.IEnumerator
                {
                    public System.Reflection.Metadata.MethodDefinitionHandle Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    void System.IDisposable.Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }
                public System.Reflection.Metadata.MethodDefinitionHandleCollection.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Reflection.Metadata.MethodDefinitionHandle> System.Collections.Generic.IEnumerable<System.Reflection.Metadata.MethodDefinitionHandle>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            }
            public struct MethodImplementation
            {
                public System.Reflection.Metadata.CustomAttributeHandleCollection GetCustomAttributes() => throw null;
                public System.Reflection.Metadata.EntityHandle MethodBody { get => throw null; }
                public System.Reflection.Metadata.EntityHandle MethodDeclaration { get => throw null; }
                public System.Reflection.Metadata.TypeDefinitionHandle Type { get => throw null; }
            }
            public struct MethodImplementationHandle : System.IEquatable<System.Reflection.Metadata.MethodImplementationHandle>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.MethodImplementationHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.MethodImplementationHandle left, System.Reflection.Metadata.MethodImplementationHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.MethodImplementationHandle(System.Reflection.Metadata.EntityHandle handle) => throw null;
                public static explicit operator System.Reflection.Metadata.MethodImplementationHandle(System.Reflection.Metadata.Handle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.EntityHandle(System.Reflection.Metadata.MethodImplementationHandle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.Handle(System.Reflection.Metadata.MethodImplementationHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.MethodImplementationHandle left, System.Reflection.Metadata.MethodImplementationHandle right) => throw null;
            }
            public struct MethodImplementationHandleCollection : System.Collections.Generic.IEnumerable<System.Reflection.Metadata.MethodImplementationHandle>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Reflection.Metadata.MethodImplementationHandle>
            {
                public int Count { get => throw null; }
                public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<System.Reflection.Metadata.MethodImplementationHandle>, System.Collections.IEnumerator
                {
                    public System.Reflection.Metadata.MethodImplementationHandle Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    void System.IDisposable.Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }
                public System.Reflection.Metadata.MethodImplementationHandleCollection.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Reflection.Metadata.MethodImplementationHandle> System.Collections.Generic.IEnumerable<System.Reflection.Metadata.MethodImplementationHandle>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            }
            public struct MethodImport
            {
                public System.Reflection.MethodImportAttributes Attributes { get => throw null; }
                public System.Reflection.Metadata.ModuleReferenceHandle Module { get => throw null; }
                public System.Reflection.Metadata.StringHandle Name { get => throw null; }
            }
            public struct MethodSignature<TType>
            {
                public MethodSignature(System.Reflection.Metadata.SignatureHeader header, TType returnType, int requiredParameterCount, int genericParameterCount, System.Collections.Immutable.ImmutableArray<TType> parameterTypes) => throw null;
                public int GenericParameterCount { get => throw null; }
                public System.Reflection.Metadata.SignatureHeader Header { get => throw null; }
                public System.Collections.Immutable.ImmutableArray<TType> ParameterTypes { get => throw null; }
                public int RequiredParameterCount { get => throw null; }
                public TType ReturnType { get => throw null; }
            }
            public struct MethodSpecification
            {
                public System.Collections.Immutable.ImmutableArray<TType> DecodeSignature<TType, TGenericContext>(System.Reflection.Metadata.ISignatureTypeProvider<TType, TGenericContext> provider, TGenericContext genericContext) => throw null;
                public System.Reflection.Metadata.CustomAttributeHandleCollection GetCustomAttributes() => throw null;
                public System.Reflection.Metadata.EntityHandle Method { get => throw null; }
                public System.Reflection.Metadata.BlobHandle Signature { get => throw null; }
            }
            public struct MethodSpecificationHandle : System.IEquatable<System.Reflection.Metadata.MethodSpecificationHandle>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.MethodSpecificationHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.MethodSpecificationHandle left, System.Reflection.Metadata.MethodSpecificationHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.MethodSpecificationHandle(System.Reflection.Metadata.EntityHandle handle) => throw null;
                public static explicit operator System.Reflection.Metadata.MethodSpecificationHandle(System.Reflection.Metadata.Handle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.EntityHandle(System.Reflection.Metadata.MethodSpecificationHandle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.Handle(System.Reflection.Metadata.MethodSpecificationHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.MethodSpecificationHandle left, System.Reflection.Metadata.MethodSpecificationHandle right) => throw null;
            }
            public struct ModuleDefinition
            {
                public System.Reflection.Metadata.GuidHandle BaseGenerationId { get => throw null; }
                public int Generation { get => throw null; }
                public System.Reflection.Metadata.GuidHandle GenerationId { get => throw null; }
                public System.Reflection.Metadata.CustomAttributeHandleCollection GetCustomAttributes() => throw null;
                public System.Reflection.Metadata.GuidHandle Mvid { get => throw null; }
                public System.Reflection.Metadata.StringHandle Name { get => throw null; }
            }
            public struct ModuleDefinitionHandle : System.IEquatable<System.Reflection.Metadata.ModuleDefinitionHandle>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.ModuleDefinitionHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.ModuleDefinitionHandle left, System.Reflection.Metadata.ModuleDefinitionHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.ModuleDefinitionHandle(System.Reflection.Metadata.EntityHandle handle) => throw null;
                public static explicit operator System.Reflection.Metadata.ModuleDefinitionHandle(System.Reflection.Metadata.Handle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.EntityHandle(System.Reflection.Metadata.ModuleDefinitionHandle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.Handle(System.Reflection.Metadata.ModuleDefinitionHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.ModuleDefinitionHandle left, System.Reflection.Metadata.ModuleDefinitionHandle right) => throw null;
            }
            public struct ModuleReference
            {
                public System.Reflection.Metadata.CustomAttributeHandleCollection GetCustomAttributes() => throw null;
                public System.Reflection.Metadata.StringHandle Name { get => throw null; }
            }
            public struct ModuleReferenceHandle : System.IEquatable<System.Reflection.Metadata.ModuleReferenceHandle>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.ModuleReferenceHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.ModuleReferenceHandle left, System.Reflection.Metadata.ModuleReferenceHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.ModuleReferenceHandle(System.Reflection.Metadata.EntityHandle handle) => throw null;
                public static explicit operator System.Reflection.Metadata.ModuleReferenceHandle(System.Reflection.Metadata.Handle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.EntityHandle(System.Reflection.Metadata.ModuleReferenceHandle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.Handle(System.Reflection.Metadata.ModuleReferenceHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.ModuleReferenceHandle left, System.Reflection.Metadata.ModuleReferenceHandle right) => throw null;
            }
            public struct NamespaceDefinition
            {
                public System.Collections.Immutable.ImmutableArray<System.Reflection.Metadata.ExportedTypeHandle> ExportedTypes { get => throw null; }
                public System.Reflection.Metadata.StringHandle Name { get => throw null; }
                public System.Collections.Immutable.ImmutableArray<System.Reflection.Metadata.NamespaceDefinitionHandle> NamespaceDefinitions { get => throw null; }
                public System.Reflection.Metadata.NamespaceDefinitionHandle Parent { get => throw null; }
                public System.Collections.Immutable.ImmutableArray<System.Reflection.Metadata.TypeDefinitionHandle> TypeDefinitions { get => throw null; }
            }
            public struct NamespaceDefinitionHandle : System.IEquatable<System.Reflection.Metadata.NamespaceDefinitionHandle>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.NamespaceDefinitionHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.NamespaceDefinitionHandle left, System.Reflection.Metadata.NamespaceDefinitionHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.NamespaceDefinitionHandle(System.Reflection.Metadata.Handle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.Handle(System.Reflection.Metadata.NamespaceDefinitionHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.NamespaceDefinitionHandle left, System.Reflection.Metadata.NamespaceDefinitionHandle right) => throw null;
            }
            public struct Parameter
            {
                public System.Reflection.ParameterAttributes Attributes { get => throw null; }
                public System.Reflection.Metadata.CustomAttributeHandleCollection GetCustomAttributes() => throw null;
                public System.Reflection.Metadata.ConstantHandle GetDefaultValue() => throw null;
                public System.Reflection.Metadata.BlobHandle GetMarshallingDescriptor() => throw null;
                public System.Reflection.Metadata.StringHandle Name { get => throw null; }
                public int SequenceNumber { get => throw null; }
            }
            public struct ParameterHandle : System.IEquatable<System.Reflection.Metadata.ParameterHandle>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.ParameterHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.ParameterHandle left, System.Reflection.Metadata.ParameterHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.ParameterHandle(System.Reflection.Metadata.EntityHandle handle) => throw null;
                public static explicit operator System.Reflection.Metadata.ParameterHandle(System.Reflection.Metadata.Handle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.EntityHandle(System.Reflection.Metadata.ParameterHandle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.Handle(System.Reflection.Metadata.ParameterHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.ParameterHandle left, System.Reflection.Metadata.ParameterHandle right) => throw null;
            }
            public struct ParameterHandleCollection : System.Collections.Generic.IEnumerable<System.Reflection.Metadata.ParameterHandle>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Reflection.Metadata.ParameterHandle>
            {
                public int Count { get => throw null; }
                public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<System.Reflection.Metadata.ParameterHandle>, System.Collections.IEnumerator
                {
                    public System.Reflection.Metadata.ParameterHandle Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    void System.IDisposable.Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }
                public System.Reflection.Metadata.ParameterHandleCollection.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Reflection.Metadata.ParameterHandle> System.Collections.Generic.IEnumerable<System.Reflection.Metadata.ParameterHandle>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            }
            public static partial class PEReaderExtensions
            {
                public static System.Reflection.Metadata.MetadataReader GetMetadataReader(this System.Reflection.PortableExecutable.PEReader peReader) => throw null;
                public static System.Reflection.Metadata.MetadataReader GetMetadataReader(this System.Reflection.PortableExecutable.PEReader peReader, System.Reflection.Metadata.MetadataReaderOptions options) => throw null;
                public static System.Reflection.Metadata.MetadataReader GetMetadataReader(this System.Reflection.PortableExecutable.PEReader peReader, System.Reflection.Metadata.MetadataReaderOptions options, System.Reflection.Metadata.MetadataStringDecoder utf8Decoder) => throw null;
                public static System.Reflection.Metadata.MethodBodyBlock GetMethodBody(this System.Reflection.PortableExecutable.PEReader peReader, int relativeVirtualAddress) => throw null;
            }
            public enum PrimitiveSerializationTypeCode : byte
            {
                Boolean = 2,
                Char = 3,
                SByte = 4,
                Byte = 5,
                Int16 = 6,
                UInt16 = 7,
                Int32 = 8,
                UInt32 = 9,
                Int64 = 10,
                UInt64 = 11,
                Single = 12,
                Double = 13,
                String = 14,
            }
            public enum PrimitiveTypeCode : byte
            {
                Void = 1,
                Boolean = 2,
                Char = 3,
                SByte = 4,
                Byte = 5,
                Int16 = 6,
                UInt16 = 7,
                Int32 = 8,
                UInt32 = 9,
                Int64 = 10,
                UInt64 = 11,
                Single = 12,
                Double = 13,
                String = 14,
                TypedReference = 22,
                IntPtr = 24,
                UIntPtr = 25,
                Object = 28,
            }
            public struct PropertyAccessors
            {
                public System.Reflection.Metadata.MethodDefinitionHandle Getter { get => throw null; }
                public System.Collections.Immutable.ImmutableArray<System.Reflection.Metadata.MethodDefinitionHandle> Others { get => throw null; }
                public System.Reflection.Metadata.MethodDefinitionHandle Setter { get => throw null; }
            }
            public struct PropertyDefinition
            {
                public System.Reflection.PropertyAttributes Attributes { get => throw null; }
                public System.Reflection.Metadata.MethodSignature<TType> DecodeSignature<TType, TGenericContext>(System.Reflection.Metadata.ISignatureTypeProvider<TType, TGenericContext> provider, TGenericContext genericContext) => throw null;
                public System.Reflection.Metadata.PropertyAccessors GetAccessors() => throw null;
                public System.Reflection.Metadata.CustomAttributeHandleCollection GetCustomAttributes() => throw null;
                public System.Reflection.Metadata.ConstantHandle GetDefaultValue() => throw null;
                public System.Reflection.Metadata.StringHandle Name { get => throw null; }
                public System.Reflection.Metadata.BlobHandle Signature { get => throw null; }
            }
            public struct PropertyDefinitionHandle : System.IEquatable<System.Reflection.Metadata.PropertyDefinitionHandle>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.PropertyDefinitionHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.PropertyDefinitionHandle left, System.Reflection.Metadata.PropertyDefinitionHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.PropertyDefinitionHandle(System.Reflection.Metadata.EntityHandle handle) => throw null;
                public static explicit operator System.Reflection.Metadata.PropertyDefinitionHandle(System.Reflection.Metadata.Handle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.EntityHandle(System.Reflection.Metadata.PropertyDefinitionHandle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.Handle(System.Reflection.Metadata.PropertyDefinitionHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.PropertyDefinitionHandle left, System.Reflection.Metadata.PropertyDefinitionHandle right) => throw null;
            }
            public struct PropertyDefinitionHandleCollection : System.Collections.Generic.IEnumerable<System.Reflection.Metadata.PropertyDefinitionHandle>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Reflection.Metadata.PropertyDefinitionHandle>
            {
                public int Count { get => throw null; }
                public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<System.Reflection.Metadata.PropertyDefinitionHandle>, System.Collections.IEnumerator
                {
                    public System.Reflection.Metadata.PropertyDefinitionHandle Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    void System.IDisposable.Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }
                public System.Reflection.Metadata.PropertyDefinitionHandleCollection.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Reflection.Metadata.PropertyDefinitionHandle> System.Collections.Generic.IEnumerable<System.Reflection.Metadata.PropertyDefinitionHandle>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            }
            public struct ReservedBlob<THandle> where THandle : struct
            {
                public System.Reflection.Metadata.Blob Content { get => throw null; }
                public System.Reflection.Metadata.BlobWriter CreateWriter() => throw null;
                public THandle Handle { get => throw null; }
            }
            public struct SequencePoint : System.IEquatable<System.Reflection.Metadata.SequencePoint>
            {
                public System.Reflection.Metadata.DocumentHandle Document { get => throw null; }
                public int EndColumn { get => throw null; }
                public int EndLine { get => throw null; }
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.SequencePoint other) => throw null;
                public override int GetHashCode() => throw null;
                public const int HiddenLine = 16707566;
                public bool IsHidden { get => throw null; }
                public int Offset { get => throw null; }
                public int StartColumn { get => throw null; }
                public int StartLine { get => throw null; }
            }
            public struct SequencePointCollection : System.Collections.Generic.IEnumerable<System.Reflection.Metadata.SequencePoint>, System.Collections.IEnumerable
            {
                public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<System.Reflection.Metadata.SequencePoint>, System.Collections.IEnumerator
                {
                    public System.Reflection.Metadata.SequencePoint Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    void System.IDisposable.Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    public void Reset() => throw null;
                }
                public System.Reflection.Metadata.SequencePointCollection.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Reflection.Metadata.SequencePoint> System.Collections.Generic.IEnumerable<System.Reflection.Metadata.SequencePoint>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            }
            public enum SerializationTypeCode : byte
            {
                Invalid = 0,
                Boolean = 2,
                Char = 3,
                SByte = 4,
                Byte = 5,
                Int16 = 6,
                UInt16 = 7,
                Int32 = 8,
                UInt32 = 9,
                Int64 = 10,
                UInt64 = 11,
                Single = 12,
                Double = 13,
                String = 14,
                SZArray = 29,
                Type = 80,
                TaggedObject = 81,
                Enum = 85,
            }
            [System.Flags]
            public enum SignatureAttributes : byte
            {
                None = 0,
                Generic = 16,
                Instance = 32,
                ExplicitThis = 64,
            }
            public enum SignatureCallingConvention : byte
            {
                Default = 0,
                CDecl = 1,
                StdCall = 2,
                ThisCall = 3,
                FastCall = 4,
                VarArgs = 5,
                Unmanaged = 9,
            }
            public struct SignatureHeader : System.IEquatable<System.Reflection.Metadata.SignatureHeader>
            {
                public System.Reflection.Metadata.SignatureAttributes Attributes { get => throw null; }
                public System.Reflection.Metadata.SignatureCallingConvention CallingConvention { get => throw null; }
                public const byte CallingConventionOrKindMask = 15;
                public SignatureHeader(byte rawValue) => throw null;
                public SignatureHeader(System.Reflection.Metadata.SignatureKind kind, System.Reflection.Metadata.SignatureCallingConvention convention, System.Reflection.Metadata.SignatureAttributes attributes) => throw null;
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.SignatureHeader other) => throw null;
                public override int GetHashCode() => throw null;
                public bool HasExplicitThis { get => throw null; }
                public bool IsGeneric { get => throw null; }
                public bool IsInstance { get => throw null; }
                public System.Reflection.Metadata.SignatureKind Kind { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.SignatureHeader left, System.Reflection.Metadata.SignatureHeader right) => throw null;
                public static bool operator !=(System.Reflection.Metadata.SignatureHeader left, System.Reflection.Metadata.SignatureHeader right) => throw null;
                public byte RawValue { get => throw null; }
                public override string ToString() => throw null;
            }
            public enum SignatureKind : byte
            {
                Method = 0,
                Field = 6,
                LocalVariables = 7,
                Property = 8,
                MethodSpecification = 10,
            }
            public enum SignatureTypeCode : byte
            {
                Invalid = 0,
                Void = 1,
                Boolean = 2,
                Char = 3,
                SByte = 4,
                Byte = 5,
                Int16 = 6,
                UInt16 = 7,
                Int32 = 8,
                UInt32 = 9,
                Int64 = 10,
                UInt64 = 11,
                Single = 12,
                Double = 13,
                String = 14,
                Pointer = 15,
                ByReference = 16,
                GenericTypeParameter = 19,
                Array = 20,
                GenericTypeInstance = 21,
                TypedReference = 22,
                IntPtr = 24,
                UIntPtr = 25,
                FunctionPointer = 27,
                Object = 28,
                SZArray = 29,
                GenericMethodParameter = 30,
                RequiredModifier = 31,
                OptionalModifier = 32,
                TypeHandle = 64,
                Sentinel = 65,
                Pinned = 69,
            }
            public enum SignatureTypeKind : byte
            {
                Unknown = 0,
                ValueType = 17,
                Class = 18,
            }
            public struct StandaloneSignature
            {
                public System.Collections.Immutable.ImmutableArray<TType> DecodeLocalSignature<TType, TGenericContext>(System.Reflection.Metadata.ISignatureTypeProvider<TType, TGenericContext> provider, TGenericContext genericContext) => throw null;
                public System.Reflection.Metadata.MethodSignature<TType> DecodeMethodSignature<TType, TGenericContext>(System.Reflection.Metadata.ISignatureTypeProvider<TType, TGenericContext> provider, TGenericContext genericContext) => throw null;
                public System.Reflection.Metadata.CustomAttributeHandleCollection GetCustomAttributes() => throw null;
                public System.Reflection.Metadata.StandaloneSignatureKind GetKind() => throw null;
                public System.Reflection.Metadata.BlobHandle Signature { get => throw null; }
            }
            public struct StandaloneSignatureHandle : System.IEquatable<System.Reflection.Metadata.StandaloneSignatureHandle>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.StandaloneSignatureHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.StandaloneSignatureHandle left, System.Reflection.Metadata.StandaloneSignatureHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.StandaloneSignatureHandle(System.Reflection.Metadata.EntityHandle handle) => throw null;
                public static explicit operator System.Reflection.Metadata.StandaloneSignatureHandle(System.Reflection.Metadata.Handle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.EntityHandle(System.Reflection.Metadata.StandaloneSignatureHandle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.Handle(System.Reflection.Metadata.StandaloneSignatureHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.StandaloneSignatureHandle left, System.Reflection.Metadata.StandaloneSignatureHandle right) => throw null;
            }
            public enum StandaloneSignatureKind
            {
                Method = 0,
                LocalVariables = 1,
            }
            public struct StringHandle : System.IEquatable<System.Reflection.Metadata.StringHandle>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.StringHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.StringHandle left, System.Reflection.Metadata.StringHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.StringHandle(System.Reflection.Metadata.Handle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.Handle(System.Reflection.Metadata.StringHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.StringHandle left, System.Reflection.Metadata.StringHandle right) => throw null;
            }
            public struct TypeDefinition
            {
                public System.Reflection.TypeAttributes Attributes { get => throw null; }
                public System.Reflection.Metadata.EntityHandle BaseType { get => throw null; }
                public System.Reflection.Metadata.CustomAttributeHandleCollection GetCustomAttributes() => throw null;
                public System.Reflection.Metadata.DeclarativeSecurityAttributeHandleCollection GetDeclarativeSecurityAttributes() => throw null;
                public System.Reflection.Metadata.TypeDefinitionHandle GetDeclaringType() => throw null;
                public System.Reflection.Metadata.EventDefinitionHandleCollection GetEvents() => throw null;
                public System.Reflection.Metadata.FieldDefinitionHandleCollection GetFields() => throw null;
                public System.Reflection.Metadata.GenericParameterHandleCollection GetGenericParameters() => throw null;
                public System.Reflection.Metadata.InterfaceImplementationHandleCollection GetInterfaceImplementations() => throw null;
                public System.Reflection.Metadata.TypeLayout GetLayout() => throw null;
                public System.Reflection.Metadata.MethodImplementationHandleCollection GetMethodImplementations() => throw null;
                public System.Reflection.Metadata.MethodDefinitionHandleCollection GetMethods() => throw null;
                public System.Collections.Immutable.ImmutableArray<System.Reflection.Metadata.TypeDefinitionHandle> GetNestedTypes() => throw null;
                public System.Reflection.Metadata.PropertyDefinitionHandleCollection GetProperties() => throw null;
                public bool IsNested { get => throw null; }
                public System.Reflection.Metadata.StringHandle Name { get => throw null; }
                public System.Reflection.Metadata.StringHandle Namespace { get => throw null; }
                public System.Reflection.Metadata.NamespaceDefinitionHandle NamespaceDefinition { get => throw null; }
            }
            public struct TypeDefinitionHandle : System.IEquatable<System.Reflection.Metadata.TypeDefinitionHandle>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.TypeDefinitionHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.TypeDefinitionHandle left, System.Reflection.Metadata.TypeDefinitionHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.TypeDefinitionHandle(System.Reflection.Metadata.EntityHandle handle) => throw null;
                public static explicit operator System.Reflection.Metadata.TypeDefinitionHandle(System.Reflection.Metadata.Handle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.EntityHandle(System.Reflection.Metadata.TypeDefinitionHandle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.Handle(System.Reflection.Metadata.TypeDefinitionHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.TypeDefinitionHandle left, System.Reflection.Metadata.TypeDefinitionHandle right) => throw null;
            }
            public struct TypeDefinitionHandleCollection : System.Collections.Generic.IEnumerable<System.Reflection.Metadata.TypeDefinitionHandle>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Reflection.Metadata.TypeDefinitionHandle>
            {
                public int Count { get => throw null; }
                public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<System.Reflection.Metadata.TypeDefinitionHandle>, System.Collections.IEnumerator
                {
                    public System.Reflection.Metadata.TypeDefinitionHandle Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    void System.IDisposable.Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }
                public System.Reflection.Metadata.TypeDefinitionHandleCollection.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Reflection.Metadata.TypeDefinitionHandle> System.Collections.Generic.IEnumerable<System.Reflection.Metadata.TypeDefinitionHandle>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            }
            public struct TypeLayout
            {
                public TypeLayout(int size, int packingSize) => throw null;
                public bool IsDefault { get => throw null; }
                public int PackingSize { get => throw null; }
                public int Size { get => throw null; }
            }
            public struct TypeReference
            {
                public System.Reflection.Metadata.StringHandle Name { get => throw null; }
                public System.Reflection.Metadata.StringHandle Namespace { get => throw null; }
                public System.Reflection.Metadata.EntityHandle ResolutionScope { get => throw null; }
            }
            public struct TypeReferenceHandle : System.IEquatable<System.Reflection.Metadata.TypeReferenceHandle>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.TypeReferenceHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.TypeReferenceHandle left, System.Reflection.Metadata.TypeReferenceHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.TypeReferenceHandle(System.Reflection.Metadata.EntityHandle handle) => throw null;
                public static explicit operator System.Reflection.Metadata.TypeReferenceHandle(System.Reflection.Metadata.Handle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.EntityHandle(System.Reflection.Metadata.TypeReferenceHandle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.Handle(System.Reflection.Metadata.TypeReferenceHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.TypeReferenceHandle left, System.Reflection.Metadata.TypeReferenceHandle right) => throw null;
            }
            public struct TypeReferenceHandleCollection : System.Collections.Generic.IEnumerable<System.Reflection.Metadata.TypeReferenceHandle>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Reflection.Metadata.TypeReferenceHandle>
            {
                public int Count { get => throw null; }
                public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<System.Reflection.Metadata.TypeReferenceHandle>, System.Collections.IEnumerator
                {
                    public System.Reflection.Metadata.TypeReferenceHandle Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    void System.IDisposable.Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }
                public System.Reflection.Metadata.TypeReferenceHandleCollection.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Reflection.Metadata.TypeReferenceHandle> System.Collections.Generic.IEnumerable<System.Reflection.Metadata.TypeReferenceHandle>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            }
            public struct TypeSpecification
            {
                public TType DecodeSignature<TType, TGenericContext>(System.Reflection.Metadata.ISignatureTypeProvider<TType, TGenericContext> provider, TGenericContext genericContext) => throw null;
                public System.Reflection.Metadata.CustomAttributeHandleCollection GetCustomAttributes() => throw null;
                public System.Reflection.Metadata.BlobHandle Signature { get => throw null; }
            }
            public struct TypeSpecificationHandle : System.IEquatable<System.Reflection.Metadata.TypeSpecificationHandle>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.TypeSpecificationHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.TypeSpecificationHandle left, System.Reflection.Metadata.TypeSpecificationHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.TypeSpecificationHandle(System.Reflection.Metadata.EntityHandle handle) => throw null;
                public static explicit operator System.Reflection.Metadata.TypeSpecificationHandle(System.Reflection.Metadata.Handle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.EntityHandle(System.Reflection.Metadata.TypeSpecificationHandle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.Handle(System.Reflection.Metadata.TypeSpecificationHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.TypeSpecificationHandle left, System.Reflection.Metadata.TypeSpecificationHandle right) => throw null;
            }
            public struct UserStringHandle : System.IEquatable<System.Reflection.Metadata.UserStringHandle>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Metadata.UserStringHandle other) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsNil { get => throw null; }
                public static bool operator ==(System.Reflection.Metadata.UserStringHandle left, System.Reflection.Metadata.UserStringHandle right) => throw null;
                public static explicit operator System.Reflection.Metadata.UserStringHandle(System.Reflection.Metadata.Handle handle) => throw null;
                public static implicit operator System.Reflection.Metadata.Handle(System.Reflection.Metadata.UserStringHandle handle) => throw null;
                public static bool operator !=(System.Reflection.Metadata.UserStringHandle left, System.Reflection.Metadata.UserStringHandle right) => throw null;
            }
        }
        [System.Flags]
        public enum MethodImportAttributes : short
        {
            None = 0,
            ExactSpelling = 1,
            CharSetAnsi = 2,
            CharSetUnicode = 4,
            CharSetAuto = 6,
            CharSetMask = 6,
            BestFitMappingEnable = 16,
            BestFitMappingDisable = 32,
            BestFitMappingMask = 48,
            SetLastError = 64,
            CallingConventionWinApi = 256,
            CallingConventionCDecl = 512,
            CallingConventionStdCall = 768,
            CallingConventionThisCall = 1024,
            CallingConventionFastCall = 1280,
            CallingConventionMask = 1792,
            ThrowOnUnmappableCharEnable = 4096,
            ThrowOnUnmappableCharDisable = 8192,
            ThrowOnUnmappableCharMask = 12288,
        }
        [System.Flags]
        public enum MethodSemanticsAttributes
        {
            Setter = 1,
            Getter = 2,
            Other = 4,
            Adder = 8,
            Remover = 16,
            Raiser = 32,
        }
        namespace PortableExecutable
        {
            [System.Flags]
            public enum Characteristics : ushort
            {
                RelocsStripped = 1,
                ExecutableImage = 2,
                LineNumsStripped = 4,
                LocalSymsStripped = 8,
                AggressiveWSTrim = 16,
                LargeAddressAware = 32,
                BytesReversedLo = 128,
                Bit32Machine = 256,
                DebugStripped = 512,
                RemovableRunFromSwap = 1024,
                NetRunFromSwap = 2048,
                System = 4096,
                Dll = 8192,
                UpSystemOnly = 16384,
                BytesReversedHi = 32768,
            }
            public struct CodeViewDebugDirectoryData
            {
                public int Age { get => throw null; }
                public System.Guid Guid { get => throw null; }
                public string Path { get => throw null; }
            }
            public sealed class CoffHeader
            {
                public System.Reflection.PortableExecutable.Characteristics Characteristics { get => throw null; }
                public System.Reflection.PortableExecutable.Machine Machine { get => throw null; }
                public short NumberOfSections { get => throw null; }
                public int NumberOfSymbols { get => throw null; }
                public int PointerToSymbolTable { get => throw null; }
                public short SizeOfOptionalHeader { get => throw null; }
                public int TimeDateStamp { get => throw null; }
            }
            [System.Flags]
            public enum CorFlags
            {
                ILOnly = 1,
                Requires32Bit = 2,
                ILLibrary = 4,
                StrongNameSigned = 8,
                NativeEntryPoint = 16,
                TrackDebugData = 65536,
                Prefers32Bit = 131072,
            }
            public sealed class CorHeader
            {
                public System.Reflection.PortableExecutable.DirectoryEntry CodeManagerTableDirectory { get => throw null; }
                public int EntryPointTokenOrRelativeVirtualAddress { get => throw null; }
                public System.Reflection.PortableExecutable.DirectoryEntry ExportAddressTableJumpsDirectory { get => throw null; }
                public System.Reflection.PortableExecutable.CorFlags Flags { get => throw null; }
                public ushort MajorRuntimeVersion { get => throw null; }
                public System.Reflection.PortableExecutable.DirectoryEntry ManagedNativeHeaderDirectory { get => throw null; }
                public System.Reflection.PortableExecutable.DirectoryEntry MetadataDirectory { get => throw null; }
                public ushort MinorRuntimeVersion { get => throw null; }
                public System.Reflection.PortableExecutable.DirectoryEntry ResourcesDirectory { get => throw null; }
                public System.Reflection.PortableExecutable.DirectoryEntry StrongNameSignatureDirectory { get => throw null; }
                public System.Reflection.PortableExecutable.DirectoryEntry VtableFixupsDirectory { get => throw null; }
            }
            public sealed class DebugDirectoryBuilder
            {
                public void AddCodeViewEntry(string pdbPath, System.Reflection.Metadata.BlobContentId pdbContentId, ushort portablePdbVersion) => throw null;
                public void AddCodeViewEntry(string pdbPath, System.Reflection.Metadata.BlobContentId pdbContentId, ushort portablePdbVersion, int age) => throw null;
                public void AddEmbeddedPortablePdbEntry(System.Reflection.Metadata.BlobBuilder debugMetadata, ushort portablePdbVersion) => throw null;
                public void AddEntry(System.Reflection.PortableExecutable.DebugDirectoryEntryType type, uint version, uint stamp) => throw null;
                public void AddEntry<TData>(System.Reflection.PortableExecutable.DebugDirectoryEntryType type, uint version, uint stamp, TData data, System.Action<System.Reflection.Metadata.BlobBuilder, TData> dataSerializer) => throw null;
                public void AddPdbChecksumEntry(string algorithmName, System.Collections.Immutable.ImmutableArray<byte> checksum) => throw null;
                public void AddReproducibleEntry() => throw null;
                public DebugDirectoryBuilder() => throw null;
            }
            public struct DebugDirectoryEntry
            {
                public DebugDirectoryEntry(uint stamp, ushort majorVersion, ushort minorVersion, System.Reflection.PortableExecutable.DebugDirectoryEntryType type, int dataSize, int dataRelativeVirtualAddress, int dataPointer) => throw null;
                public int DataPointer { get => throw null; }
                public int DataRelativeVirtualAddress { get => throw null; }
                public int DataSize { get => throw null; }
                public bool IsPortableCodeView { get => throw null; }
                public ushort MajorVersion { get => throw null; }
                public ushort MinorVersion { get => throw null; }
                public uint Stamp { get => throw null; }
                public System.Reflection.PortableExecutable.DebugDirectoryEntryType Type { get => throw null; }
            }
            public enum DebugDirectoryEntryType
            {
                Unknown = 0,
                Coff = 1,
                CodeView = 2,
                Reproducible = 16,
                EmbeddedPortablePdb = 17,
                PdbChecksum = 19,
            }
            public struct DirectoryEntry
            {
                public DirectoryEntry(int relativeVirtualAddress, int size) => throw null;
                public readonly int RelativeVirtualAddress;
                public readonly int Size;
            }
            [System.Flags]
            public enum DllCharacteristics : ushort
            {
                ProcessInit = 1,
                ProcessTerm = 2,
                ThreadInit = 4,
                ThreadTerm = 8,
                HighEntropyVirtualAddressSpace = 32,
                DynamicBase = 64,
                ForceIntegrity = 128,
                NxCompatible = 256,
                NoIsolation = 512,
                NoSeh = 1024,
                NoBind = 2048,
                AppContainer = 4096,
                WdmDriver = 8192,
                ControlFlowGuard = 16384,
                TerminalServerAware = 32768,
            }
            public enum Machine : ushort
            {
                Unknown = 0,
                I386 = 332,
                WceMipsV2 = 361,
                Alpha = 388,
                SH3 = 418,
                SH3Dsp = 419,
                SH3E = 420,
                SH4 = 422,
                SH5 = 424,
                Arm = 448,
                Thumb = 450,
                ArmThumb2 = 452,
                AM33 = 467,
                PowerPC = 496,
                PowerPCFP = 497,
                IA64 = 512,
                MIPS16 = 614,
                Alpha64 = 644,
                MipsFpu = 870,
                MipsFpu16 = 1126,
                Tricore = 1312,
                Ebc = 3772,
                Amd64 = 34404,
                M32R = 36929,
                Arm64 = 43620,
                LoongArch32 = 25138,
                LoongArch64 = 25188,
            }
            public class ManagedPEBuilder : System.Reflection.PortableExecutable.PEBuilder
            {
                protected override System.Collections.Immutable.ImmutableArray<System.Reflection.PortableExecutable.PEBuilder.Section> CreateSections() => throw null;
                public ManagedPEBuilder(System.Reflection.PortableExecutable.PEHeaderBuilder header, System.Reflection.Metadata.Ecma335.MetadataRootBuilder metadataRootBuilder, System.Reflection.Metadata.BlobBuilder ilStream, System.Reflection.Metadata.BlobBuilder mappedFieldData = default(System.Reflection.Metadata.BlobBuilder), System.Reflection.Metadata.BlobBuilder managedResources = default(System.Reflection.Metadata.BlobBuilder), System.Reflection.PortableExecutable.ResourceSectionBuilder nativeResources = default(System.Reflection.PortableExecutable.ResourceSectionBuilder), System.Reflection.PortableExecutable.DebugDirectoryBuilder debugDirectoryBuilder = default(System.Reflection.PortableExecutable.DebugDirectoryBuilder), int strongNameSignatureSize = default(int), System.Reflection.Metadata.MethodDefinitionHandle entryPoint = default(System.Reflection.Metadata.MethodDefinitionHandle), System.Reflection.PortableExecutable.CorFlags flags = default(System.Reflection.PortableExecutable.CorFlags), System.Func<System.Collections.Generic.IEnumerable<System.Reflection.Metadata.Blob>, System.Reflection.Metadata.BlobContentId> deterministicIdProvider = default(System.Func<System.Collections.Generic.IEnumerable<System.Reflection.Metadata.Blob>, System.Reflection.Metadata.BlobContentId>)) : base(default(System.Reflection.PortableExecutable.PEHeaderBuilder), default(System.Func<System.Collections.Generic.IEnumerable<System.Reflection.Metadata.Blob>, System.Reflection.Metadata.BlobContentId>)) => throw null;
                protected override System.Reflection.PortableExecutable.PEDirectoriesBuilder GetDirectories() => throw null;
                public const int ManagedResourcesDataAlignment = 8;
                public const int MappedFieldDataAlignment = 8;
                protected override System.Reflection.Metadata.BlobBuilder SerializeSection(string name, System.Reflection.PortableExecutable.SectionLocation location) => throw null;
                public void Sign(System.Reflection.Metadata.BlobBuilder peImage, System.Func<System.Collections.Generic.IEnumerable<System.Reflection.Metadata.Blob>, byte[]> signatureProvider) => throw null;
            }
            public struct PdbChecksumDebugDirectoryData
            {
                public string AlgorithmName { get => throw null; }
                public System.Collections.Immutable.ImmutableArray<byte> Checksum { get => throw null; }
            }
            public abstract class PEBuilder
            {
                protected abstract System.Collections.Immutable.ImmutableArray<System.Reflection.PortableExecutable.PEBuilder.Section> CreateSections();
                protected PEBuilder(System.Reflection.PortableExecutable.PEHeaderBuilder header, System.Func<System.Collections.Generic.IEnumerable<System.Reflection.Metadata.Blob>, System.Reflection.Metadata.BlobContentId> deterministicIdProvider) => throw null;
                protected abstract System.Reflection.PortableExecutable.PEDirectoriesBuilder GetDirectories();
                protected System.Collections.Immutable.ImmutableArray<System.Reflection.PortableExecutable.PEBuilder.Section> GetSections() => throw null;
                public System.Reflection.PortableExecutable.PEHeaderBuilder Header { get => throw null; }
                public System.Func<System.Collections.Generic.IEnumerable<System.Reflection.Metadata.Blob>, System.Reflection.Metadata.BlobContentId> IdProvider { get => throw null; }
                public bool IsDeterministic { get => throw null; }
                protected struct Section
                {
                    public readonly System.Reflection.PortableExecutable.SectionCharacteristics Characteristics;
                    public Section(string name, System.Reflection.PortableExecutable.SectionCharacteristics characteristics) => throw null;
                    public readonly string Name;
                }
                public System.Reflection.Metadata.BlobContentId Serialize(System.Reflection.Metadata.BlobBuilder builder) => throw null;
                protected abstract System.Reflection.Metadata.BlobBuilder SerializeSection(string name, System.Reflection.PortableExecutable.SectionLocation location);
            }
            public sealed class PEDirectoriesBuilder
            {
                public int AddressOfEntryPoint { get => throw null; set { } }
                public System.Reflection.PortableExecutable.DirectoryEntry BaseRelocationTable { get => throw null; set { } }
                public System.Reflection.PortableExecutable.DirectoryEntry BoundImportTable { get => throw null; set { } }
                public System.Reflection.PortableExecutable.DirectoryEntry CopyrightTable { get => throw null; set { } }
                public System.Reflection.PortableExecutable.DirectoryEntry CorHeaderTable { get => throw null; set { } }
                public PEDirectoriesBuilder() => throw null;
                public System.Reflection.PortableExecutable.DirectoryEntry DebugTable { get => throw null; set { } }
                public System.Reflection.PortableExecutable.DirectoryEntry DelayImportTable { get => throw null; set { } }
                public System.Reflection.PortableExecutable.DirectoryEntry ExceptionTable { get => throw null; set { } }
                public System.Reflection.PortableExecutable.DirectoryEntry ExportTable { get => throw null; set { } }
                public System.Reflection.PortableExecutable.DirectoryEntry GlobalPointerTable { get => throw null; set { } }
                public System.Reflection.PortableExecutable.DirectoryEntry ImportAddressTable { get => throw null; set { } }
                public System.Reflection.PortableExecutable.DirectoryEntry ImportTable { get => throw null; set { } }
                public System.Reflection.PortableExecutable.DirectoryEntry LoadConfigTable { get => throw null; set { } }
                public System.Reflection.PortableExecutable.DirectoryEntry ResourceTable { get => throw null; set { } }
                public System.Reflection.PortableExecutable.DirectoryEntry ThreadLocalStorageTable { get => throw null; set { } }
            }
            public sealed class PEHeader
            {
                public int AddressOfEntryPoint { get => throw null; }
                public int BaseOfCode { get => throw null; }
                public int BaseOfData { get => throw null; }
                public System.Reflection.PortableExecutable.DirectoryEntry BaseRelocationTableDirectory { get => throw null; }
                public System.Reflection.PortableExecutable.DirectoryEntry BoundImportTableDirectory { get => throw null; }
                public System.Reflection.PortableExecutable.DirectoryEntry CertificateTableDirectory { get => throw null; }
                public uint CheckSum { get => throw null; }
                public System.Reflection.PortableExecutable.DirectoryEntry CopyrightTableDirectory { get => throw null; }
                public System.Reflection.PortableExecutable.DirectoryEntry CorHeaderTableDirectory { get => throw null; }
                public System.Reflection.PortableExecutable.DirectoryEntry DebugTableDirectory { get => throw null; }
                public System.Reflection.PortableExecutable.DirectoryEntry DelayImportTableDirectory { get => throw null; }
                public System.Reflection.PortableExecutable.DllCharacteristics DllCharacteristics { get => throw null; }
                public System.Reflection.PortableExecutable.DirectoryEntry ExceptionTableDirectory { get => throw null; }
                public System.Reflection.PortableExecutable.DirectoryEntry ExportTableDirectory { get => throw null; }
                public int FileAlignment { get => throw null; }
                public System.Reflection.PortableExecutable.DirectoryEntry GlobalPointerTableDirectory { get => throw null; }
                public ulong ImageBase { get => throw null; }
                public System.Reflection.PortableExecutable.DirectoryEntry ImportAddressTableDirectory { get => throw null; }
                public System.Reflection.PortableExecutable.DirectoryEntry ImportTableDirectory { get => throw null; }
                public System.Reflection.PortableExecutable.DirectoryEntry LoadConfigTableDirectory { get => throw null; }
                public System.Reflection.PortableExecutable.PEMagic Magic { get => throw null; }
                public ushort MajorImageVersion { get => throw null; }
                public byte MajorLinkerVersion { get => throw null; }
                public ushort MajorOperatingSystemVersion { get => throw null; }
                public ushort MajorSubsystemVersion { get => throw null; }
                public ushort MinorImageVersion { get => throw null; }
                public byte MinorLinkerVersion { get => throw null; }
                public ushort MinorOperatingSystemVersion { get => throw null; }
                public ushort MinorSubsystemVersion { get => throw null; }
                public int NumberOfRvaAndSizes { get => throw null; }
                public System.Reflection.PortableExecutable.DirectoryEntry ResourceTableDirectory { get => throw null; }
                public int SectionAlignment { get => throw null; }
                public int SizeOfCode { get => throw null; }
                public int SizeOfHeaders { get => throw null; }
                public ulong SizeOfHeapCommit { get => throw null; }
                public ulong SizeOfHeapReserve { get => throw null; }
                public int SizeOfImage { get => throw null; }
                public int SizeOfInitializedData { get => throw null; }
                public ulong SizeOfStackCommit { get => throw null; }
                public ulong SizeOfStackReserve { get => throw null; }
                public int SizeOfUninitializedData { get => throw null; }
                public System.Reflection.PortableExecutable.Subsystem Subsystem { get => throw null; }
                public System.Reflection.PortableExecutable.DirectoryEntry ThreadLocalStorageTableDirectory { get => throw null; }
            }
            public sealed class PEHeaderBuilder
            {
                public static System.Reflection.PortableExecutable.PEHeaderBuilder CreateExecutableHeader() => throw null;
                public static System.Reflection.PortableExecutable.PEHeaderBuilder CreateLibraryHeader() => throw null;
                public PEHeaderBuilder(System.Reflection.PortableExecutable.Machine machine = default(System.Reflection.PortableExecutable.Machine), int sectionAlignment = default(int), int fileAlignment = default(int), ulong imageBase = default(ulong), byte majorLinkerVersion = default(byte), byte minorLinkerVersion = default(byte), ushort majorOperatingSystemVersion = default(ushort), ushort minorOperatingSystemVersion = default(ushort), ushort majorImageVersion = default(ushort), ushort minorImageVersion = default(ushort), ushort majorSubsystemVersion = default(ushort), ushort minorSubsystemVersion = default(ushort), System.Reflection.PortableExecutable.Subsystem subsystem = default(System.Reflection.PortableExecutable.Subsystem), System.Reflection.PortableExecutable.DllCharacteristics dllCharacteristics = default(System.Reflection.PortableExecutable.DllCharacteristics), System.Reflection.PortableExecutable.Characteristics imageCharacteristics = default(System.Reflection.PortableExecutable.Characteristics), ulong sizeOfStackReserve = default(ulong), ulong sizeOfStackCommit = default(ulong), ulong sizeOfHeapReserve = default(ulong), ulong sizeOfHeapCommit = default(ulong)) => throw null;
                public System.Reflection.PortableExecutable.DllCharacteristics DllCharacteristics { get => throw null; }
                public int FileAlignment { get => throw null; }
                public ulong ImageBase { get => throw null; }
                public System.Reflection.PortableExecutable.Characteristics ImageCharacteristics { get => throw null; }
                public System.Reflection.PortableExecutable.Machine Machine { get => throw null; }
                public ushort MajorImageVersion { get => throw null; }
                public byte MajorLinkerVersion { get => throw null; }
                public ushort MajorOperatingSystemVersion { get => throw null; }
                public ushort MajorSubsystemVersion { get => throw null; }
                public ushort MinorImageVersion { get => throw null; }
                public byte MinorLinkerVersion { get => throw null; }
                public ushort MinorOperatingSystemVersion { get => throw null; }
                public ushort MinorSubsystemVersion { get => throw null; }
                public int SectionAlignment { get => throw null; }
                public ulong SizeOfHeapCommit { get => throw null; }
                public ulong SizeOfHeapReserve { get => throw null; }
                public ulong SizeOfStackCommit { get => throw null; }
                public ulong SizeOfStackReserve { get => throw null; }
                public System.Reflection.PortableExecutable.Subsystem Subsystem { get => throw null; }
            }
            public sealed class PEHeaders
            {
                public System.Reflection.PortableExecutable.CoffHeader CoffHeader { get => throw null; }
                public int CoffHeaderStartOffset { get => throw null; }
                public System.Reflection.PortableExecutable.CorHeader CorHeader { get => throw null; }
                public int CorHeaderStartOffset { get => throw null; }
                public PEHeaders(System.IO.Stream peStream) => throw null;
                public PEHeaders(System.IO.Stream peStream, int size) => throw null;
                public PEHeaders(System.IO.Stream peStream, int size, bool isLoadedImage) => throw null;
                public int GetContainingSectionIndex(int relativeVirtualAddress) => throw null;
                public bool IsCoffOnly { get => throw null; }
                public bool IsConsoleApplication { get => throw null; }
                public bool IsDll { get => throw null; }
                public bool IsExe { get => throw null; }
                public int MetadataSize { get => throw null; }
                public int MetadataStartOffset { get => throw null; }
                public System.Reflection.PortableExecutable.PEHeader PEHeader { get => throw null; }
                public int PEHeaderStartOffset { get => throw null; }
                public System.Collections.Immutable.ImmutableArray<System.Reflection.PortableExecutable.SectionHeader> SectionHeaders { get => throw null; }
                public bool TryGetDirectoryOffset(System.Reflection.PortableExecutable.DirectoryEntry directory, out int offset) => throw null;
            }
            public enum PEMagic : ushort
            {
                PE32 = 267,
                PE32Plus = 523,
            }
            public struct PEMemoryBlock
            {
                public System.Collections.Immutable.ImmutableArray<byte> GetContent() => throw null;
                public System.Collections.Immutable.ImmutableArray<byte> GetContent(int start, int length) => throw null;
                public System.Reflection.Metadata.BlobReader GetReader() => throw null;
                public System.Reflection.Metadata.BlobReader GetReader(int start, int length) => throw null;
                public int Length { get => throw null; }
                public unsafe byte* Pointer { get => throw null; }
            }
            public sealed class PEReader : System.IDisposable
            {
                public unsafe PEReader(byte* peImage, int size) => throw null;
                public unsafe PEReader(byte* peImage, int size, bool isLoadedImage) => throw null;
                public PEReader(System.Collections.Immutable.ImmutableArray<byte> peImage) => throw null;
                public PEReader(System.IO.Stream peStream) => throw null;
                public PEReader(System.IO.Stream peStream, System.Reflection.PortableExecutable.PEStreamOptions options) => throw null;
                public PEReader(System.IO.Stream peStream, System.Reflection.PortableExecutable.PEStreamOptions options, int size) => throw null;
                public void Dispose() => throw null;
                public System.Reflection.PortableExecutable.PEMemoryBlock GetEntireImage() => throw null;
                public System.Reflection.PortableExecutable.PEMemoryBlock GetMetadata() => throw null;
                public System.Reflection.PortableExecutable.PEMemoryBlock GetSectionData(int relativeVirtualAddress) => throw null;
                public System.Reflection.PortableExecutable.PEMemoryBlock GetSectionData(string sectionName) => throw null;
                public bool HasMetadata { get => throw null; }
                public bool IsEntireImageAvailable { get => throw null; }
                public bool IsLoadedImage { get => throw null; }
                public System.Reflection.PortableExecutable.PEHeaders PEHeaders { get => throw null; }
                public System.Reflection.PortableExecutable.CodeViewDebugDirectoryData ReadCodeViewDebugDirectoryData(System.Reflection.PortableExecutable.DebugDirectoryEntry entry) => throw null;
                public System.Collections.Immutable.ImmutableArray<System.Reflection.PortableExecutable.DebugDirectoryEntry> ReadDebugDirectory() => throw null;
                public System.Reflection.Metadata.MetadataReaderProvider ReadEmbeddedPortablePdbDebugDirectoryData(System.Reflection.PortableExecutable.DebugDirectoryEntry entry) => throw null;
                public System.Reflection.PortableExecutable.PdbChecksumDebugDirectoryData ReadPdbChecksumDebugDirectoryData(System.Reflection.PortableExecutable.DebugDirectoryEntry entry) => throw null;
                public bool TryOpenAssociatedPortablePdb(string peImagePath, System.Func<string, System.IO.Stream> pdbFileStreamProvider, out System.Reflection.Metadata.MetadataReaderProvider pdbReaderProvider, out string pdbPath) => throw null;
            }
            [System.Flags]
            public enum PEStreamOptions
            {
                Default = 0,
                LeaveOpen = 1,
                PrefetchMetadata = 2,
                PrefetchEntireImage = 4,
                IsLoadedImage = 8,
            }
            public abstract class ResourceSectionBuilder
            {
                protected ResourceSectionBuilder() => throw null;
                protected abstract void Serialize(System.Reflection.Metadata.BlobBuilder builder, System.Reflection.PortableExecutable.SectionLocation location);
            }
            [System.Flags]
            public enum SectionCharacteristics : uint
            {
                TypeReg = 0,
                TypeDSect = 1,
                TypeNoLoad = 2,
                TypeGroup = 4,
                TypeNoPad = 8,
                TypeCopy = 16,
                ContainsCode = 32,
                ContainsInitializedData = 64,
                ContainsUninitializedData = 128,
                LinkerOther = 256,
                LinkerInfo = 512,
                TypeOver = 1024,
                LinkerRemove = 2048,
                LinkerComdat = 4096,
                MemProtected = 16384,
                NoDeferSpecExc = 16384,
                GPRel = 32768,
                MemFardata = 32768,
                MemSysheap = 65536,
                Mem16Bit = 131072,
                MemPurgeable = 131072,
                MemLocked = 262144,
                MemPreload = 524288,
                Align1Bytes = 1048576,
                Align2Bytes = 2097152,
                Align4Bytes = 3145728,
                Align8Bytes = 4194304,
                Align16Bytes = 5242880,
                Align32Bytes = 6291456,
                Align64Bytes = 7340032,
                Align128Bytes = 8388608,
                Align256Bytes = 9437184,
                Align512Bytes = 10485760,
                Align1024Bytes = 11534336,
                Align2048Bytes = 12582912,
                Align4096Bytes = 13631488,
                Align8192Bytes = 14680064,
                AlignMask = 15728640,
                LinkerNRelocOvfl = 16777216,
                MemDiscardable = 33554432,
                MemNotCached = 67108864,
                MemNotPaged = 134217728,
                MemShared = 268435456,
                MemExecute = 536870912,
                MemRead = 1073741824,
                MemWrite = 2147483648,
            }
            public struct SectionHeader
            {
                public string Name { get => throw null; }
                public ushort NumberOfLineNumbers { get => throw null; }
                public ushort NumberOfRelocations { get => throw null; }
                public int PointerToLineNumbers { get => throw null; }
                public int PointerToRawData { get => throw null; }
                public int PointerToRelocations { get => throw null; }
                public System.Reflection.PortableExecutable.SectionCharacteristics SectionCharacteristics { get => throw null; }
                public int SizeOfRawData { get => throw null; }
                public int VirtualAddress { get => throw null; }
                public int VirtualSize { get => throw null; }
            }
            public struct SectionLocation
            {
                public SectionLocation(int relativeVirtualAddress, int pointerToRawData) => throw null;
                public int PointerToRawData { get => throw null; }
                public int RelativeVirtualAddress { get => throw null; }
            }
            public enum Subsystem : ushort
            {
                Unknown = 0,
                Native = 1,
                WindowsGui = 2,
                WindowsCui = 3,
                OS2Cui = 5,
                PosixCui = 7,
                NativeWindows = 8,
                WindowsCEGui = 9,
                EfiApplication = 10,
                EfiBootServiceDriver = 11,
                EfiRuntimeDriver = 12,
                EfiRom = 13,
                Xbox = 14,
                WindowsBootApplication = 16,
            }
        }
    }
}
