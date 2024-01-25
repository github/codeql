// This file contains auto-generated code.
// Generated from `System.Memory, Version=8.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`.
namespace System
{
    namespace Buffers
    {
        public sealed class ArrayBufferWriter<T> : System.Buffers.IBufferWriter<T>
        {
            public void Advance(int count) => throw null;
            public int Capacity { get => throw null; }
            public void Clear() => throw null;
            public ArrayBufferWriter() => throw null;
            public ArrayBufferWriter(int initialCapacity) => throw null;
            public int FreeCapacity { get => throw null; }
            public System.Memory<T> GetMemory(int sizeHint = default(int)) => throw null;
            public System.Span<T> GetSpan(int sizeHint = default(int)) => throw null;
            public void ResetWrittenCount() => throw null;
            public int WrittenCount { get => throw null; }
            public System.ReadOnlyMemory<T> WrittenMemory { get => throw null; }
            public System.ReadOnlySpan<T> WrittenSpan { get => throw null; }
        }
        namespace Binary
        {
            public static class BinaryPrimitives
            {
                public static double ReadDoubleBigEndian(System.ReadOnlySpan<byte> source) => throw null;
                public static double ReadDoubleLittleEndian(System.ReadOnlySpan<byte> source) => throw null;
                public static System.Half ReadHalfBigEndian(System.ReadOnlySpan<byte> source) => throw null;
                public static System.Half ReadHalfLittleEndian(System.ReadOnlySpan<byte> source) => throw null;
                public static System.Int128 ReadInt128BigEndian(System.ReadOnlySpan<byte> source) => throw null;
                public static System.Int128 ReadInt128LittleEndian(System.ReadOnlySpan<byte> source) => throw null;
                public static short ReadInt16BigEndian(System.ReadOnlySpan<byte> source) => throw null;
                public static short ReadInt16LittleEndian(System.ReadOnlySpan<byte> source) => throw null;
                public static int ReadInt32BigEndian(System.ReadOnlySpan<byte> source) => throw null;
                public static int ReadInt32LittleEndian(System.ReadOnlySpan<byte> source) => throw null;
                public static long ReadInt64BigEndian(System.ReadOnlySpan<byte> source) => throw null;
                public static long ReadInt64LittleEndian(System.ReadOnlySpan<byte> source) => throw null;
                public static nint ReadIntPtrBigEndian(System.ReadOnlySpan<byte> source) => throw null;
                public static nint ReadIntPtrLittleEndian(System.ReadOnlySpan<byte> source) => throw null;
                public static float ReadSingleBigEndian(System.ReadOnlySpan<byte> source) => throw null;
                public static float ReadSingleLittleEndian(System.ReadOnlySpan<byte> source) => throw null;
                public static System.UInt128 ReadUInt128BigEndian(System.ReadOnlySpan<byte> source) => throw null;
                public static System.UInt128 ReadUInt128LittleEndian(System.ReadOnlySpan<byte> source) => throw null;
                public static ushort ReadUInt16BigEndian(System.ReadOnlySpan<byte> source) => throw null;
                public static ushort ReadUInt16LittleEndian(System.ReadOnlySpan<byte> source) => throw null;
                public static uint ReadUInt32BigEndian(System.ReadOnlySpan<byte> source) => throw null;
                public static uint ReadUInt32LittleEndian(System.ReadOnlySpan<byte> source) => throw null;
                public static ulong ReadUInt64BigEndian(System.ReadOnlySpan<byte> source) => throw null;
                public static ulong ReadUInt64LittleEndian(System.ReadOnlySpan<byte> source) => throw null;
                public static nuint ReadUIntPtrBigEndian(System.ReadOnlySpan<byte> source) => throw null;
                public static nuint ReadUIntPtrLittleEndian(System.ReadOnlySpan<byte> source) => throw null;
                public static byte ReverseEndianness(byte value) => throw null;
                public static short ReverseEndianness(short value) => throw null;
                public static int ReverseEndianness(int value) => throw null;
                public static long ReverseEndianness(long value) => throw null;
                public static sbyte ReverseEndianness(sbyte value) => throw null;
                public static ushort ReverseEndianness(ushort value) => throw null;
                public static uint ReverseEndianness(uint value) => throw null;
                public static ulong ReverseEndianness(ulong value) => throw null;
                public static nint ReverseEndianness(nint value) => throw null;
                public static nuint ReverseEndianness(nuint value) => throw null;
                public static System.Int128 ReverseEndianness(System.Int128 value) => throw null;
                public static System.UInt128 ReverseEndianness(System.UInt128 value) => throw null;
                public static void ReverseEndianness(System.ReadOnlySpan<int> source, System.Span<int> destination) => throw null;
                public static void ReverseEndianness(System.ReadOnlySpan<System.Int128> source, System.Span<System.Int128> destination) => throw null;
                public static void ReverseEndianness(System.ReadOnlySpan<long> source, System.Span<long> destination) => throw null;
                public static void ReverseEndianness(System.ReadOnlySpan<nint> source, System.Span<nint> destination) => throw null;
                public static void ReverseEndianness(System.ReadOnlySpan<short> source, System.Span<short> destination) => throw null;
                public static void ReverseEndianness(System.ReadOnlySpan<nuint> source, System.Span<nuint> destination) => throw null;
                public static void ReverseEndianness(System.ReadOnlySpan<uint> source, System.Span<uint> destination) => throw null;
                public static void ReverseEndianness(System.ReadOnlySpan<System.UInt128> source, System.Span<System.UInt128> destination) => throw null;
                public static void ReverseEndianness(System.ReadOnlySpan<ulong> source, System.Span<ulong> destination) => throw null;
                public static void ReverseEndianness(System.ReadOnlySpan<ushort> source, System.Span<ushort> destination) => throw null;
                public static bool TryReadDoubleBigEndian(System.ReadOnlySpan<byte> source, out double value) => throw null;
                public static bool TryReadDoubleLittleEndian(System.ReadOnlySpan<byte> source, out double value) => throw null;
                public static bool TryReadHalfBigEndian(System.ReadOnlySpan<byte> source, out System.Half value) => throw null;
                public static bool TryReadHalfLittleEndian(System.ReadOnlySpan<byte> source, out System.Half value) => throw null;
                public static bool TryReadInt128BigEndian(System.ReadOnlySpan<byte> source, out System.Int128 value) => throw null;
                public static bool TryReadInt128LittleEndian(System.ReadOnlySpan<byte> source, out System.Int128 value) => throw null;
                public static bool TryReadInt16BigEndian(System.ReadOnlySpan<byte> source, out short value) => throw null;
                public static bool TryReadInt16LittleEndian(System.ReadOnlySpan<byte> source, out short value) => throw null;
                public static bool TryReadInt32BigEndian(System.ReadOnlySpan<byte> source, out int value) => throw null;
                public static bool TryReadInt32LittleEndian(System.ReadOnlySpan<byte> source, out int value) => throw null;
                public static bool TryReadInt64BigEndian(System.ReadOnlySpan<byte> source, out long value) => throw null;
                public static bool TryReadInt64LittleEndian(System.ReadOnlySpan<byte> source, out long value) => throw null;
                public static bool TryReadIntPtrBigEndian(System.ReadOnlySpan<byte> source, out nint value) => throw null;
                public static bool TryReadIntPtrLittleEndian(System.ReadOnlySpan<byte> source, out nint value) => throw null;
                public static bool TryReadSingleBigEndian(System.ReadOnlySpan<byte> source, out float value) => throw null;
                public static bool TryReadSingleLittleEndian(System.ReadOnlySpan<byte> source, out float value) => throw null;
                public static bool TryReadUInt128BigEndian(System.ReadOnlySpan<byte> source, out System.UInt128 value) => throw null;
                public static bool TryReadUInt128LittleEndian(System.ReadOnlySpan<byte> source, out System.UInt128 value) => throw null;
                public static bool TryReadUInt16BigEndian(System.ReadOnlySpan<byte> source, out ushort value) => throw null;
                public static bool TryReadUInt16LittleEndian(System.ReadOnlySpan<byte> source, out ushort value) => throw null;
                public static bool TryReadUInt32BigEndian(System.ReadOnlySpan<byte> source, out uint value) => throw null;
                public static bool TryReadUInt32LittleEndian(System.ReadOnlySpan<byte> source, out uint value) => throw null;
                public static bool TryReadUInt64BigEndian(System.ReadOnlySpan<byte> source, out ulong value) => throw null;
                public static bool TryReadUInt64LittleEndian(System.ReadOnlySpan<byte> source, out ulong value) => throw null;
                public static bool TryReadUIntPtrBigEndian(System.ReadOnlySpan<byte> source, out nuint value) => throw null;
                public static bool TryReadUIntPtrLittleEndian(System.ReadOnlySpan<byte> source, out nuint value) => throw null;
                public static bool TryWriteDoubleBigEndian(System.Span<byte> destination, double value) => throw null;
                public static bool TryWriteDoubleLittleEndian(System.Span<byte> destination, double value) => throw null;
                public static bool TryWriteHalfBigEndian(System.Span<byte> destination, System.Half value) => throw null;
                public static bool TryWriteHalfLittleEndian(System.Span<byte> destination, System.Half value) => throw null;
                public static bool TryWriteInt128BigEndian(System.Span<byte> destination, System.Int128 value) => throw null;
                public static bool TryWriteInt128LittleEndian(System.Span<byte> destination, System.Int128 value) => throw null;
                public static bool TryWriteInt16BigEndian(System.Span<byte> destination, short value) => throw null;
                public static bool TryWriteInt16LittleEndian(System.Span<byte> destination, short value) => throw null;
                public static bool TryWriteInt32BigEndian(System.Span<byte> destination, int value) => throw null;
                public static bool TryWriteInt32LittleEndian(System.Span<byte> destination, int value) => throw null;
                public static bool TryWriteInt64BigEndian(System.Span<byte> destination, long value) => throw null;
                public static bool TryWriteInt64LittleEndian(System.Span<byte> destination, long value) => throw null;
                public static bool TryWriteIntPtrBigEndian(System.Span<byte> destination, nint value) => throw null;
                public static bool TryWriteIntPtrLittleEndian(System.Span<byte> destination, nint value) => throw null;
                public static bool TryWriteSingleBigEndian(System.Span<byte> destination, float value) => throw null;
                public static bool TryWriteSingleLittleEndian(System.Span<byte> destination, float value) => throw null;
                public static bool TryWriteUInt128BigEndian(System.Span<byte> destination, System.UInt128 value) => throw null;
                public static bool TryWriteUInt128LittleEndian(System.Span<byte> destination, System.UInt128 value) => throw null;
                public static bool TryWriteUInt16BigEndian(System.Span<byte> destination, ushort value) => throw null;
                public static bool TryWriteUInt16LittleEndian(System.Span<byte> destination, ushort value) => throw null;
                public static bool TryWriteUInt32BigEndian(System.Span<byte> destination, uint value) => throw null;
                public static bool TryWriteUInt32LittleEndian(System.Span<byte> destination, uint value) => throw null;
                public static bool TryWriteUInt64BigEndian(System.Span<byte> destination, ulong value) => throw null;
                public static bool TryWriteUInt64LittleEndian(System.Span<byte> destination, ulong value) => throw null;
                public static bool TryWriteUIntPtrBigEndian(System.Span<byte> destination, nuint value) => throw null;
                public static bool TryWriteUIntPtrLittleEndian(System.Span<byte> destination, nuint value) => throw null;
                public static void WriteDoubleBigEndian(System.Span<byte> destination, double value) => throw null;
                public static void WriteDoubleLittleEndian(System.Span<byte> destination, double value) => throw null;
                public static void WriteHalfBigEndian(System.Span<byte> destination, System.Half value) => throw null;
                public static void WriteHalfLittleEndian(System.Span<byte> destination, System.Half value) => throw null;
                public static void WriteInt128BigEndian(System.Span<byte> destination, System.Int128 value) => throw null;
                public static void WriteInt128LittleEndian(System.Span<byte> destination, System.Int128 value) => throw null;
                public static void WriteInt16BigEndian(System.Span<byte> destination, short value) => throw null;
                public static void WriteInt16LittleEndian(System.Span<byte> destination, short value) => throw null;
                public static void WriteInt32BigEndian(System.Span<byte> destination, int value) => throw null;
                public static void WriteInt32LittleEndian(System.Span<byte> destination, int value) => throw null;
                public static void WriteInt64BigEndian(System.Span<byte> destination, long value) => throw null;
                public static void WriteInt64LittleEndian(System.Span<byte> destination, long value) => throw null;
                public static void WriteIntPtrBigEndian(System.Span<byte> destination, nint value) => throw null;
                public static void WriteIntPtrLittleEndian(System.Span<byte> destination, nint value) => throw null;
                public static void WriteSingleBigEndian(System.Span<byte> destination, float value) => throw null;
                public static void WriteSingleLittleEndian(System.Span<byte> destination, float value) => throw null;
                public static void WriteUInt128BigEndian(System.Span<byte> destination, System.UInt128 value) => throw null;
                public static void WriteUInt128LittleEndian(System.Span<byte> destination, System.UInt128 value) => throw null;
                public static void WriteUInt16BigEndian(System.Span<byte> destination, ushort value) => throw null;
                public static void WriteUInt16LittleEndian(System.Span<byte> destination, ushort value) => throw null;
                public static void WriteUInt32BigEndian(System.Span<byte> destination, uint value) => throw null;
                public static void WriteUInt32LittleEndian(System.Span<byte> destination, uint value) => throw null;
                public static void WriteUInt64BigEndian(System.Span<byte> destination, ulong value) => throw null;
                public static void WriteUInt64LittleEndian(System.Span<byte> destination, ulong value) => throw null;
                public static void WriteUIntPtrBigEndian(System.Span<byte> destination, nuint value) => throw null;
                public static void WriteUIntPtrLittleEndian(System.Span<byte> destination, nuint value) => throw null;
            }
        }
        public static partial class BuffersExtensions
        {
            public static void CopyTo<T>(this in System.Buffers.ReadOnlySequence<T> source, System.Span<T> destination) => throw null;
            public static System.SequencePosition? PositionOf<T>(this in System.Buffers.ReadOnlySequence<T> source, T value) where T : System.IEquatable<T> => throw null;
            public static T[] ToArray<T>(this in System.Buffers.ReadOnlySequence<T> sequence) => throw null;
            public static void Write<T>(this System.Buffers.IBufferWriter<T> writer, System.ReadOnlySpan<T> value) => throw null;
        }
        public interface IBufferWriter<T>
        {
            void Advance(int count);
            System.Memory<T> GetMemory(int sizeHint = default(int));
            System.Span<T> GetSpan(int sizeHint = default(int));
        }
        public abstract class MemoryPool<T> : System.IDisposable
        {
            protected MemoryPool() => throw null;
            public void Dispose() => throw null;
            protected abstract void Dispose(bool disposing);
            public abstract int MaxBufferSize { get; }
            public abstract System.Buffers.IMemoryOwner<T> Rent(int minBufferSize = default(int));
            public static System.Buffers.MemoryPool<T> Shared { get => throw null; }
        }
        public struct ReadOnlySequence<T>
        {
            public ReadOnlySequence(System.Buffers.ReadOnlySequenceSegment<T> startSegment, int startIndex, System.Buffers.ReadOnlySequenceSegment<T> endSegment, int endIndex) => throw null;
            public ReadOnlySequence(System.ReadOnlyMemory<T> memory) => throw null;
            public ReadOnlySequence(T[] array) => throw null;
            public ReadOnlySequence(T[] array, int start, int length) => throw null;
            public static readonly System.Buffers.ReadOnlySequence<T> Empty;
            public System.SequencePosition End { get => throw null; }
            public struct Enumerator
            {
                public Enumerator(in System.Buffers.ReadOnlySequence<T> sequence) => throw null;
                public System.ReadOnlyMemory<T> Current { get => throw null; }
                public bool MoveNext() => throw null;
            }
            public System.ReadOnlyMemory<T> First { get => throw null; }
            public System.ReadOnlySpan<T> FirstSpan { get => throw null; }
            public System.Buffers.ReadOnlySequence<T>.Enumerator GetEnumerator() => throw null;
            public long GetOffset(System.SequencePosition position) => throw null;
            public System.SequencePosition GetPosition(long offset) => throw null;
            public System.SequencePosition GetPosition(long offset, System.SequencePosition origin) => throw null;
            public bool IsEmpty { get => throw null; }
            public bool IsSingleSegment { get => throw null; }
            public long Length { get => throw null; }
            public System.Buffers.ReadOnlySequence<T> Slice(int start, int length) => throw null;
            public System.Buffers.ReadOnlySequence<T> Slice(int start, System.SequencePosition end) => throw null;
            public System.Buffers.ReadOnlySequence<T> Slice(long start) => throw null;
            public System.Buffers.ReadOnlySequence<T> Slice(long start, long length) => throw null;
            public System.Buffers.ReadOnlySequence<T> Slice(long start, System.SequencePosition end) => throw null;
            public System.Buffers.ReadOnlySequence<T> Slice(System.SequencePosition start) => throw null;
            public System.Buffers.ReadOnlySequence<T> Slice(System.SequencePosition start, int length) => throw null;
            public System.Buffers.ReadOnlySequence<T> Slice(System.SequencePosition start, long length) => throw null;
            public System.Buffers.ReadOnlySequence<T> Slice(System.SequencePosition start, System.SequencePosition end) => throw null;
            public System.SequencePosition Start { get => throw null; }
            public override string ToString() => throw null;
            public bool TryGet(ref System.SequencePosition position, out System.ReadOnlyMemory<T> memory, bool advance = default(bool)) => throw null;
        }
        public abstract class ReadOnlySequenceSegment<T>
        {
            protected ReadOnlySequenceSegment() => throw null;
            public System.ReadOnlyMemory<T> Memory { get => throw null; set { } }
            public System.Buffers.ReadOnlySequenceSegment<T> Next { get => throw null; set { } }
            public long RunningIndex { get => throw null; set { } }
        }
        public struct SequenceReader<T> where T : unmanaged, System.IEquatable<T>
        {
            public void Advance(long count) => throw null;
            public long AdvancePast(T value) => throw null;
            public long AdvancePastAny(System.ReadOnlySpan<T> values) => throw null;
            public long AdvancePastAny(T value0, T value1) => throw null;
            public long AdvancePastAny(T value0, T value1, T value2) => throw null;
            public long AdvancePastAny(T value0, T value1, T value2, T value3) => throw null;
            public void AdvanceToEnd() => throw null;
            public long Consumed { get => throw null; }
            public SequenceReader(System.Buffers.ReadOnlySequence<T> sequence) => throw null;
            public System.ReadOnlySpan<T> CurrentSpan { get => throw null; }
            public int CurrentSpanIndex { get => throw null; }
            public bool End { get => throw null; }
            public bool IsNext(System.ReadOnlySpan<T> next, bool advancePast = default(bool)) => throw null;
            public bool IsNext(T next, bool advancePast = default(bool)) => throw null;
            public long Length { get => throw null; }
            public System.SequencePosition Position { get => throw null; }
            public long Remaining { get => throw null; }
            public void Rewind(long count) => throw null;
            public System.Buffers.ReadOnlySequence<T> Sequence { get => throw null; }
            public bool TryAdvanceTo(T delimiter, bool advancePastDelimiter = default(bool)) => throw null;
            public bool TryAdvanceToAny(System.ReadOnlySpan<T> delimiters, bool advancePastDelimiter = default(bool)) => throw null;
            public bool TryCopyTo(System.Span<T> destination) => throw null;
            public bool TryPeek(out T value) => throw null;
            public bool TryPeek(long offset, out T value) => throw null;
            public bool TryRead(out T value) => throw null;
            public bool TryReadExact(int count, out System.Buffers.ReadOnlySequence<T> sequence) => throw null;
            public bool TryReadTo(out System.Buffers.ReadOnlySequence<T> sequence, System.ReadOnlySpan<T> delimiter, bool advancePastDelimiter = default(bool)) => throw null;
            public bool TryReadTo(out System.Buffers.ReadOnlySequence<T> sequence, T delimiter, bool advancePastDelimiter = default(bool)) => throw null;
            public bool TryReadTo(out System.Buffers.ReadOnlySequence<T> sequence, T delimiter, T delimiterEscape, bool advancePastDelimiter = default(bool)) => throw null;
            public bool TryReadTo(out System.ReadOnlySpan<T> span, System.ReadOnlySpan<T> delimiter, bool advancePastDelimiter = default(bool)) => throw null;
            public bool TryReadTo(out System.ReadOnlySpan<T> span, T delimiter, bool advancePastDelimiter = default(bool)) => throw null;
            public bool TryReadTo(out System.ReadOnlySpan<T> span, T delimiter, T delimiterEscape, bool advancePastDelimiter = default(bool)) => throw null;
            public bool TryReadToAny(out System.Buffers.ReadOnlySequence<T> sequence, System.ReadOnlySpan<T> delimiters, bool advancePastDelimiter = default(bool)) => throw null;
            public bool TryReadToAny(out System.ReadOnlySpan<T> span, System.ReadOnlySpan<T> delimiters, bool advancePastDelimiter = default(bool)) => throw null;
            public System.Buffers.ReadOnlySequence<T> UnreadSequence { get => throw null; }
            public System.ReadOnlySpan<T> UnreadSpan { get => throw null; }
        }
        public static partial class SequenceReaderExtensions
        {
            public static bool TryReadBigEndian(this ref System.Buffers.SequenceReader<byte> reader, out short value) => throw null;
            public static bool TryReadBigEndian(this ref System.Buffers.SequenceReader<byte> reader, out int value) => throw null;
            public static bool TryReadBigEndian(this ref System.Buffers.SequenceReader<byte> reader, out long value) => throw null;
            public static bool TryReadLittleEndian(this ref System.Buffers.SequenceReader<byte> reader, out short value) => throw null;
            public static bool TryReadLittleEndian(this ref System.Buffers.SequenceReader<byte> reader, out int value) => throw null;
            public static bool TryReadLittleEndian(this ref System.Buffers.SequenceReader<byte> reader, out long value) => throw null;
        }
        public struct StandardFormat : System.IEquatable<System.Buffers.StandardFormat>
        {
            public StandardFormat(char symbol, byte precision = default(byte)) => throw null;
            public bool Equals(System.Buffers.StandardFormat other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public bool HasPrecision { get => throw null; }
            public bool IsDefault { get => throw null; }
            public const byte MaxPrecision = 99;
            public const byte NoPrecision = 255;
            public static bool operator ==(System.Buffers.StandardFormat left, System.Buffers.StandardFormat right) => throw null;
            public static implicit operator System.Buffers.StandardFormat(char symbol) => throw null;
            public static bool operator !=(System.Buffers.StandardFormat left, System.Buffers.StandardFormat right) => throw null;
            public static System.Buffers.StandardFormat Parse(System.ReadOnlySpan<char> format) => throw null;
            public static System.Buffers.StandardFormat Parse(string format) => throw null;
            public byte Precision { get => throw null; }
            public char Symbol { get => throw null; }
            public override string ToString() => throw null;
            public static bool TryParse(System.ReadOnlySpan<char> format, out System.Buffers.StandardFormat result) => throw null;
        }
        namespace Text
        {
            public static class Utf8Formatter
            {
                public static bool TryFormat(bool value, System.Span<byte> destination, out int bytesWritten, System.Buffers.StandardFormat format = default(System.Buffers.StandardFormat)) => throw null;
                public static bool TryFormat(byte value, System.Span<byte> destination, out int bytesWritten, System.Buffers.StandardFormat format = default(System.Buffers.StandardFormat)) => throw null;
                public static bool TryFormat(System.DateTime value, System.Span<byte> destination, out int bytesWritten, System.Buffers.StandardFormat format = default(System.Buffers.StandardFormat)) => throw null;
                public static bool TryFormat(System.DateTimeOffset value, System.Span<byte> destination, out int bytesWritten, System.Buffers.StandardFormat format = default(System.Buffers.StandardFormat)) => throw null;
                public static bool TryFormat(decimal value, System.Span<byte> destination, out int bytesWritten, System.Buffers.StandardFormat format = default(System.Buffers.StandardFormat)) => throw null;
                public static bool TryFormat(double value, System.Span<byte> destination, out int bytesWritten, System.Buffers.StandardFormat format = default(System.Buffers.StandardFormat)) => throw null;
                public static bool TryFormat(System.Guid value, System.Span<byte> destination, out int bytesWritten, System.Buffers.StandardFormat format = default(System.Buffers.StandardFormat)) => throw null;
                public static bool TryFormat(short value, System.Span<byte> destination, out int bytesWritten, System.Buffers.StandardFormat format = default(System.Buffers.StandardFormat)) => throw null;
                public static bool TryFormat(int value, System.Span<byte> destination, out int bytesWritten, System.Buffers.StandardFormat format = default(System.Buffers.StandardFormat)) => throw null;
                public static bool TryFormat(long value, System.Span<byte> destination, out int bytesWritten, System.Buffers.StandardFormat format = default(System.Buffers.StandardFormat)) => throw null;
                public static bool TryFormat(sbyte value, System.Span<byte> destination, out int bytesWritten, System.Buffers.StandardFormat format = default(System.Buffers.StandardFormat)) => throw null;
                public static bool TryFormat(float value, System.Span<byte> destination, out int bytesWritten, System.Buffers.StandardFormat format = default(System.Buffers.StandardFormat)) => throw null;
                public static bool TryFormat(System.TimeSpan value, System.Span<byte> destination, out int bytesWritten, System.Buffers.StandardFormat format = default(System.Buffers.StandardFormat)) => throw null;
                public static bool TryFormat(ushort value, System.Span<byte> destination, out int bytesWritten, System.Buffers.StandardFormat format = default(System.Buffers.StandardFormat)) => throw null;
                public static bool TryFormat(uint value, System.Span<byte> destination, out int bytesWritten, System.Buffers.StandardFormat format = default(System.Buffers.StandardFormat)) => throw null;
                public static bool TryFormat(ulong value, System.Span<byte> destination, out int bytesWritten, System.Buffers.StandardFormat format = default(System.Buffers.StandardFormat)) => throw null;
            }
            public static class Utf8Parser
            {
                public static bool TryParse(System.ReadOnlySpan<byte> source, out bool value, out int bytesConsumed, char standardFormat = default(char)) => throw null;
                public static bool TryParse(System.ReadOnlySpan<byte> source, out byte value, out int bytesConsumed, char standardFormat = default(char)) => throw null;
                public static bool TryParse(System.ReadOnlySpan<byte> source, out System.DateTime value, out int bytesConsumed, char standardFormat = default(char)) => throw null;
                public static bool TryParse(System.ReadOnlySpan<byte> source, out System.DateTimeOffset value, out int bytesConsumed, char standardFormat = default(char)) => throw null;
                public static bool TryParse(System.ReadOnlySpan<byte> source, out decimal value, out int bytesConsumed, char standardFormat = default(char)) => throw null;
                public static bool TryParse(System.ReadOnlySpan<byte> source, out double value, out int bytesConsumed, char standardFormat = default(char)) => throw null;
                public static bool TryParse(System.ReadOnlySpan<byte> source, out System.Guid value, out int bytesConsumed, char standardFormat = default(char)) => throw null;
                public static bool TryParse(System.ReadOnlySpan<byte> source, out short value, out int bytesConsumed, char standardFormat = default(char)) => throw null;
                public static bool TryParse(System.ReadOnlySpan<byte> source, out int value, out int bytesConsumed, char standardFormat = default(char)) => throw null;
                public static bool TryParse(System.ReadOnlySpan<byte> source, out long value, out int bytesConsumed, char standardFormat = default(char)) => throw null;
                public static bool TryParse(System.ReadOnlySpan<byte> source, out sbyte value, out int bytesConsumed, char standardFormat = default(char)) => throw null;
                public static bool TryParse(System.ReadOnlySpan<byte> source, out float value, out int bytesConsumed, char standardFormat = default(char)) => throw null;
                public static bool TryParse(System.ReadOnlySpan<byte> source, out System.TimeSpan value, out int bytesConsumed, char standardFormat = default(char)) => throw null;
                public static bool TryParse(System.ReadOnlySpan<byte> source, out ushort value, out int bytesConsumed, char standardFormat = default(char)) => throw null;
                public static bool TryParse(System.ReadOnlySpan<byte> source, out uint value, out int bytesConsumed, char standardFormat = default(char)) => throw null;
                public static bool TryParse(System.ReadOnlySpan<byte> source, out ulong value, out int bytesConsumed, char standardFormat = default(char)) => throw null;
            }
        }
    }
    public static partial class MemoryExtensions
    {
        public static System.ReadOnlyMemory<char> AsMemory(this string text) => throw null;
        public static System.ReadOnlyMemory<char> AsMemory(this string text, System.Index startIndex) => throw null;
        public static System.ReadOnlyMemory<char> AsMemory(this string text, int start) => throw null;
        public static System.ReadOnlyMemory<char> AsMemory(this string text, int start, int length) => throw null;
        public static System.ReadOnlyMemory<char> AsMemory(this string text, System.Range range) => throw null;
        public static System.Memory<T> AsMemory<T>(this System.ArraySegment<T> segment) => throw null;
        public static System.Memory<T> AsMemory<T>(this System.ArraySegment<T> segment, int start) => throw null;
        public static System.Memory<T> AsMemory<T>(this System.ArraySegment<T> segment, int start, int length) => throw null;
        public static System.Memory<T> AsMemory<T>(this T[] array) => throw null;
        public static System.Memory<T> AsMemory<T>(this T[] array, System.Index startIndex) => throw null;
        public static System.Memory<T> AsMemory<T>(this T[] array, int start) => throw null;
        public static System.Memory<T> AsMemory<T>(this T[] array, int start, int length) => throw null;
        public static System.Memory<T> AsMemory<T>(this T[] array, System.Range range) => throw null;
        public static System.ReadOnlySpan<char> AsSpan(this string text) => throw null;
        public static System.ReadOnlySpan<char> AsSpan(this string text, int start) => throw null;
        public static System.ReadOnlySpan<char> AsSpan(this string text, int start, int length) => throw null;
        public static System.ReadOnlySpan<char> AsSpan(this string text, System.Index startIndex) => throw null;
        public static System.ReadOnlySpan<char> AsSpan(this string text, System.Range range) => throw null;
        public static System.Span<T> AsSpan<T>(this System.ArraySegment<T> segment) => throw null;
        public static System.Span<T> AsSpan<T>(this System.ArraySegment<T> segment, System.Index startIndex) => throw null;
        public static System.Span<T> AsSpan<T>(this System.ArraySegment<T> segment, int start) => throw null;
        public static System.Span<T> AsSpan<T>(this System.ArraySegment<T> segment, int start, int length) => throw null;
        public static System.Span<T> AsSpan<T>(this System.ArraySegment<T> segment, System.Range range) => throw null;
        public static System.Span<T> AsSpan<T>(this T[] array) => throw null;
        public static System.Span<T> AsSpan<T>(this T[] array, System.Index startIndex) => throw null;
        public static System.Span<T> AsSpan<T>(this T[] array, int start) => throw null;
        public static System.Span<T> AsSpan<T>(this T[] array, int start, int length) => throw null;
        public static System.Span<T> AsSpan<T>(this T[] array, System.Range range) => throw null;
        public static int BinarySearch<T>(this System.ReadOnlySpan<T> span, System.IComparable<T> comparable) => throw null;
        public static int BinarySearch<T>(this System.Span<T> span, System.IComparable<T> comparable) => throw null;
        public static int BinarySearch<T, TComparer>(this System.ReadOnlySpan<T> span, T value, TComparer comparer) where TComparer : System.Collections.Generic.IComparer<T> => throw null;
        public static int BinarySearch<T, TComparable>(this System.ReadOnlySpan<T> span, TComparable comparable) where TComparable : System.IComparable<T> => throw null;
        public static int BinarySearch<T, TComparer>(this System.Span<T> span, T value, TComparer comparer) where TComparer : System.Collections.Generic.IComparer<T> => throw null;
        public static int BinarySearch<T, TComparable>(this System.Span<T> span, TComparable comparable) where TComparable : System.IComparable<T> => throw null;
        public static int CommonPrefixLength<T>(this System.Span<T> span, System.ReadOnlySpan<T> other) => throw null;
        public static int CommonPrefixLength<T>(this System.Span<T> span, System.ReadOnlySpan<T> other, System.Collections.Generic.IEqualityComparer<T> comparer) => throw null;
        public static int CommonPrefixLength<T>(this System.ReadOnlySpan<T> span, System.ReadOnlySpan<T> other) => throw null;
        public static int CommonPrefixLength<T>(this System.ReadOnlySpan<T> span, System.ReadOnlySpan<T> other, System.Collections.Generic.IEqualityComparer<T> comparer) => throw null;
        public static int CompareTo(this System.ReadOnlySpan<char> span, System.ReadOnlySpan<char> other, System.StringComparison comparisonType) => throw null;
        public static bool Contains(this System.ReadOnlySpan<char> span, System.ReadOnlySpan<char> value, System.StringComparison comparisonType) => throw null;
        public static bool Contains<T>(this System.ReadOnlySpan<T> span, T value) where T : System.IEquatable<T> => throw null;
        public static bool Contains<T>(this System.Span<T> span, T value) where T : System.IEquatable<T> => throw null;
        public static bool ContainsAny<T>(this System.ReadOnlySpan<T> span, System.Buffers.SearchValues<T> values) where T : System.IEquatable<T> => throw null;
        public static bool ContainsAny<T>(this System.ReadOnlySpan<T> span, System.ReadOnlySpan<T> values) where T : System.IEquatable<T> => throw null;
        public static bool ContainsAny<T>(this System.ReadOnlySpan<T> span, T value0, T value1) where T : System.IEquatable<T> => throw null;
        public static bool ContainsAny<T>(this System.ReadOnlySpan<T> span, T value0, T value1, T value2) where T : System.IEquatable<T> => throw null;
        public static bool ContainsAny<T>(this System.Span<T> span, System.Buffers.SearchValues<T> values) where T : System.IEquatable<T> => throw null;
        public static bool ContainsAny<T>(this System.Span<T> span, System.ReadOnlySpan<T> values) where T : System.IEquatable<T> => throw null;
        public static bool ContainsAny<T>(this System.Span<T> span, T value0, T value1) where T : System.IEquatable<T> => throw null;
        public static bool ContainsAny<T>(this System.Span<T> span, T value0, T value1, T value2) where T : System.IEquatable<T> => throw null;
        public static bool ContainsAnyExcept<T>(this System.ReadOnlySpan<T> span, System.Buffers.SearchValues<T> values) where T : System.IEquatable<T> => throw null;
        public static bool ContainsAnyExcept<T>(this System.ReadOnlySpan<T> span, System.ReadOnlySpan<T> values) where T : System.IEquatable<T> => throw null;
        public static bool ContainsAnyExcept<T>(this System.ReadOnlySpan<T> span, T value) where T : System.IEquatable<T> => throw null;
        public static bool ContainsAnyExcept<T>(this System.ReadOnlySpan<T> span, T value0, T value1) where T : System.IEquatable<T> => throw null;
        public static bool ContainsAnyExcept<T>(this System.ReadOnlySpan<T> span, T value0, T value1, T value2) where T : System.IEquatable<T> => throw null;
        public static bool ContainsAnyExcept<T>(this System.Span<T> span, System.Buffers.SearchValues<T> values) where T : System.IEquatable<T> => throw null;
        public static bool ContainsAnyExcept<T>(this System.Span<T> span, System.ReadOnlySpan<T> values) where T : System.IEquatable<T> => throw null;
        public static bool ContainsAnyExcept<T>(this System.Span<T> span, T value) where T : System.IEquatable<T> => throw null;
        public static bool ContainsAnyExcept<T>(this System.Span<T> span, T value0, T value1) where T : System.IEquatable<T> => throw null;
        public static bool ContainsAnyExcept<T>(this System.Span<T> span, T value0, T value1, T value2) where T : System.IEquatable<T> => throw null;
        public static bool ContainsAnyExceptInRange<T>(this System.ReadOnlySpan<T> span, T lowInclusive, T highInclusive) where T : System.IComparable<T> => throw null;
        public static bool ContainsAnyExceptInRange<T>(this System.Span<T> span, T lowInclusive, T highInclusive) where T : System.IComparable<T> => throw null;
        public static bool ContainsAnyInRange<T>(this System.ReadOnlySpan<T> span, T lowInclusive, T highInclusive) where T : System.IComparable<T> => throw null;
        public static bool ContainsAnyInRange<T>(this System.Span<T> span, T lowInclusive, T highInclusive) where T : System.IComparable<T> => throw null;
        public static void CopyTo<T>(this T[] source, System.Memory<T> destination) => throw null;
        public static void CopyTo<T>(this T[] source, System.Span<T> destination) => throw null;
        public static int Count<T>(this System.Span<T> span, T value) where T : System.IEquatable<T> => throw null;
        public static int Count<T>(this System.ReadOnlySpan<T> span, T value) where T : System.IEquatable<T> => throw null;
        public static int Count<T>(this System.Span<T> span, System.ReadOnlySpan<T> value) where T : System.IEquatable<T> => throw null;
        public static int Count<T>(this System.ReadOnlySpan<T> span, System.ReadOnlySpan<T> value) where T : System.IEquatable<T> => throw null;
        public static bool EndsWith(this System.ReadOnlySpan<char> span, System.ReadOnlySpan<char> value, System.StringComparison comparisonType) => throw null;
        public static bool EndsWith<T>(this System.ReadOnlySpan<T> span, System.ReadOnlySpan<T> value) where T : System.IEquatable<T> => throw null;
        public static bool EndsWith<T>(this System.Span<T> span, System.ReadOnlySpan<T> value) where T : System.IEquatable<T> => throw null;
        public static System.Text.SpanLineEnumerator EnumerateLines(this System.ReadOnlySpan<char> span) => throw null;
        public static System.Text.SpanLineEnumerator EnumerateLines(this System.Span<char> span) => throw null;
        public static System.Text.SpanRuneEnumerator EnumerateRunes(this System.ReadOnlySpan<char> span) => throw null;
        public static System.Text.SpanRuneEnumerator EnumerateRunes(this System.Span<char> span) => throw null;
        public static bool Equals(this System.ReadOnlySpan<char> span, System.ReadOnlySpan<char> other, System.StringComparison comparisonType) => throw null;
        public static int IndexOf(this System.ReadOnlySpan<char> span, System.ReadOnlySpan<char> value, System.StringComparison comparisonType) => throw null;
        public static int IndexOf<T>(this System.ReadOnlySpan<T> span, System.ReadOnlySpan<T> value) where T : System.IEquatable<T> => throw null;
        public static int IndexOf<T>(this System.ReadOnlySpan<T> span, T value) where T : System.IEquatable<T> => throw null;
        public static int IndexOf<T>(this System.Span<T> span, System.ReadOnlySpan<T> value) where T : System.IEquatable<T> => throw null;
        public static int IndexOf<T>(this System.Span<T> span, T value) where T : System.IEquatable<T> => throw null;
        public static int IndexOfAny<T>(this System.ReadOnlySpan<T> span, System.Buffers.SearchValues<T> values) where T : System.IEquatable<T> => throw null;
        public static int IndexOfAny<T>(this System.ReadOnlySpan<T> span, System.ReadOnlySpan<T> values) where T : System.IEquatable<T> => throw null;
        public static int IndexOfAny<T>(this System.ReadOnlySpan<T> span, T value0, T value1) where T : System.IEquatable<T> => throw null;
        public static int IndexOfAny<T>(this System.ReadOnlySpan<T> span, T value0, T value1, T value2) where T : System.IEquatable<T> => throw null;
        public static int IndexOfAny<T>(this System.Span<T> span, System.Buffers.SearchValues<T> values) where T : System.IEquatable<T> => throw null;
        public static int IndexOfAny<T>(this System.Span<T> span, System.ReadOnlySpan<T> values) where T : System.IEquatable<T> => throw null;
        public static int IndexOfAny<T>(this System.Span<T> span, T value0, T value1) where T : System.IEquatable<T> => throw null;
        public static int IndexOfAny<T>(this System.Span<T> span, T value0, T value1, T value2) where T : System.IEquatable<T> => throw null;
        public static int IndexOfAnyExcept<T>(this System.Span<T> span, T value) where T : System.IEquatable<T> => throw null;
        public static int IndexOfAnyExcept<T>(this System.Span<T> span, T value0, T value1) where T : System.IEquatable<T> => throw null;
        public static int IndexOfAnyExcept<T>(this System.Span<T> span, T value0, T value1, T value2) where T : System.IEquatable<T> => throw null;
        public static int IndexOfAnyExcept<T>(this System.Span<T> span, System.Buffers.SearchValues<T> values) where T : System.IEquatable<T> => throw null;
        public static int IndexOfAnyExcept<T>(this System.Span<T> span, System.ReadOnlySpan<T> values) where T : System.IEquatable<T> => throw null;
        public static int IndexOfAnyExcept<T>(this System.ReadOnlySpan<T> span, T value) where T : System.IEquatable<T> => throw null;
        public static int IndexOfAnyExcept<T>(this System.ReadOnlySpan<T> span, T value0, T value1) where T : System.IEquatable<T> => throw null;
        public static int IndexOfAnyExcept<T>(this System.ReadOnlySpan<T> span, T value0, T value1, T value2) where T : System.IEquatable<T> => throw null;
        public static int IndexOfAnyExcept<T>(this System.ReadOnlySpan<T> span, System.Buffers.SearchValues<T> values) where T : System.IEquatable<T> => throw null;
        public static int IndexOfAnyExcept<T>(this System.ReadOnlySpan<T> span, System.ReadOnlySpan<T> values) where T : System.IEquatable<T> => throw null;
        public static int IndexOfAnyExceptInRange<T>(this System.ReadOnlySpan<T> span, T lowInclusive, T highInclusive) where T : System.IComparable<T> => throw null;
        public static int IndexOfAnyExceptInRange<T>(this System.Span<T> span, T lowInclusive, T highInclusive) where T : System.IComparable<T> => throw null;
        public static int IndexOfAnyInRange<T>(this System.ReadOnlySpan<T> span, T lowInclusive, T highInclusive) where T : System.IComparable<T> => throw null;
        public static int IndexOfAnyInRange<T>(this System.Span<T> span, T lowInclusive, T highInclusive) where T : System.IComparable<T> => throw null;
        public static bool IsWhiteSpace(this System.ReadOnlySpan<char> span) => throw null;
        public static int LastIndexOf(this System.ReadOnlySpan<char> span, System.ReadOnlySpan<char> value, System.StringComparison comparisonType) => throw null;
        public static int LastIndexOf<T>(this System.ReadOnlySpan<T> span, System.ReadOnlySpan<T> value) where T : System.IEquatable<T> => throw null;
        public static int LastIndexOf<T>(this System.ReadOnlySpan<T> span, T value) where T : System.IEquatable<T> => throw null;
        public static int LastIndexOf<T>(this System.Span<T> span, System.ReadOnlySpan<T> value) where T : System.IEquatable<T> => throw null;
        public static int LastIndexOf<T>(this System.Span<T> span, T value) where T : System.IEquatable<T> => throw null;
        public static int LastIndexOfAny<T>(this System.ReadOnlySpan<T> span, System.Buffers.SearchValues<T> values) where T : System.IEquatable<T> => throw null;
        public static int LastIndexOfAny<T>(this System.ReadOnlySpan<T> span, System.ReadOnlySpan<T> values) where T : System.IEquatable<T> => throw null;
        public static int LastIndexOfAny<T>(this System.ReadOnlySpan<T> span, T value0, T value1) where T : System.IEquatable<T> => throw null;
        public static int LastIndexOfAny<T>(this System.ReadOnlySpan<T> span, T value0, T value1, T value2) where T : System.IEquatable<T> => throw null;
        public static int LastIndexOfAny<T>(this System.Span<T> span, System.Buffers.SearchValues<T> values) where T : System.IEquatable<T> => throw null;
        public static int LastIndexOfAny<T>(this System.Span<T> span, System.ReadOnlySpan<T> values) where T : System.IEquatable<T> => throw null;
        public static int LastIndexOfAny<T>(this System.Span<T> span, T value0, T value1) where T : System.IEquatable<T> => throw null;
        public static int LastIndexOfAny<T>(this System.Span<T> span, T value0, T value1, T value2) where T : System.IEquatable<T> => throw null;
        public static int LastIndexOfAnyExcept<T>(this System.Span<T> span, T value) where T : System.IEquatable<T> => throw null;
        public static int LastIndexOfAnyExcept<T>(this System.Span<T> span, T value0, T value1) where T : System.IEquatable<T> => throw null;
        public static int LastIndexOfAnyExcept<T>(this System.Span<T> span, T value0, T value1, T value2) where T : System.IEquatable<T> => throw null;
        public static int LastIndexOfAnyExcept<T>(this System.Span<T> span, System.Buffers.SearchValues<T> values) where T : System.IEquatable<T> => throw null;
        public static int LastIndexOfAnyExcept<T>(this System.Span<T> span, System.ReadOnlySpan<T> values) where T : System.IEquatable<T> => throw null;
        public static int LastIndexOfAnyExcept<T>(this System.ReadOnlySpan<T> span, T value) where T : System.IEquatable<T> => throw null;
        public static int LastIndexOfAnyExcept<T>(this System.ReadOnlySpan<T> span, T value0, T value1) where T : System.IEquatable<T> => throw null;
        public static int LastIndexOfAnyExcept<T>(this System.ReadOnlySpan<T> span, T value0, T value1, T value2) where T : System.IEquatable<T> => throw null;
        public static int LastIndexOfAnyExcept<T>(this System.ReadOnlySpan<T> span, System.Buffers.SearchValues<T> values) where T : System.IEquatable<T> => throw null;
        public static int LastIndexOfAnyExcept<T>(this System.ReadOnlySpan<T> span, System.ReadOnlySpan<T> values) where T : System.IEquatable<T> => throw null;
        public static int LastIndexOfAnyExceptInRange<T>(this System.ReadOnlySpan<T> span, T lowInclusive, T highInclusive) where T : System.IComparable<T> => throw null;
        public static int LastIndexOfAnyExceptInRange<T>(this System.Span<T> span, T lowInclusive, T highInclusive) where T : System.IComparable<T> => throw null;
        public static int LastIndexOfAnyInRange<T>(this System.ReadOnlySpan<T> span, T lowInclusive, T highInclusive) where T : System.IComparable<T> => throw null;
        public static int LastIndexOfAnyInRange<T>(this System.Span<T> span, T lowInclusive, T highInclusive) where T : System.IComparable<T> => throw null;
        public static bool Overlaps<T>(this System.ReadOnlySpan<T> span, System.ReadOnlySpan<T> other) => throw null;
        public static bool Overlaps<T>(this System.ReadOnlySpan<T> span, System.ReadOnlySpan<T> other, out int elementOffset) => throw null;
        public static bool Overlaps<T>(this System.Span<T> span, System.ReadOnlySpan<T> other) => throw null;
        public static bool Overlaps<T>(this System.Span<T> span, System.ReadOnlySpan<T> other, out int elementOffset) => throw null;
        public static void Replace<T>(this System.Span<T> span, T oldValue, T newValue) where T : System.IEquatable<T> => throw null;
        public static void Replace<T>(this System.ReadOnlySpan<T> source, System.Span<T> destination, T oldValue, T newValue) where T : System.IEquatable<T> => throw null;
        public static void Reverse<T>(this System.Span<T> span) => throw null;
        public static int SequenceCompareTo<T>(this System.ReadOnlySpan<T> span, System.ReadOnlySpan<T> other) where T : System.IComparable<T> => throw null;
        public static int SequenceCompareTo<T>(this System.Span<T> span, System.ReadOnlySpan<T> other) where T : System.IComparable<T> => throw null;
        public static bool SequenceEqual<T>(this System.ReadOnlySpan<T> span, System.ReadOnlySpan<T> other) where T : System.IEquatable<T> => throw null;
        public static bool SequenceEqual<T>(this System.Span<T> span, System.ReadOnlySpan<T> other) where T : System.IEquatable<T> => throw null;
        public static bool SequenceEqual<T>(this System.ReadOnlySpan<T> span, System.ReadOnlySpan<T> other, System.Collections.Generic.IEqualityComparer<T> comparer = default(System.Collections.Generic.IEqualityComparer<T>)) => throw null;
        public static bool SequenceEqual<T>(this System.Span<T> span, System.ReadOnlySpan<T> other, System.Collections.Generic.IEqualityComparer<T> comparer = default(System.Collections.Generic.IEqualityComparer<T>)) => throw null;
        public static void Sort<T>(this System.Span<T> span) => throw null;
        public static void Sort<T>(this System.Span<T> span, System.Comparison<T> comparison) => throw null;
        public static void Sort<TKey, TValue>(this System.Span<TKey> keys, System.Span<TValue> items) => throw null;
        public static void Sort<TKey, TValue>(this System.Span<TKey> keys, System.Span<TValue> items, System.Comparison<TKey> comparison) => throw null;
        public static void Sort<T, TComparer>(this System.Span<T> span, TComparer comparer) where TComparer : System.Collections.Generic.IComparer<T> => throw null;
        public static void Sort<TKey, TValue, TComparer>(this System.Span<TKey> keys, System.Span<TValue> items, TComparer comparer) where TComparer : System.Collections.Generic.IComparer<TKey> => throw null;
        public static int Split(this System.ReadOnlySpan<char> source, System.Span<System.Range> destination, char separator, System.StringSplitOptions options = default(System.StringSplitOptions)) => throw null;
        public static int Split(this System.ReadOnlySpan<char> source, System.Span<System.Range> destination, System.ReadOnlySpan<char> separator, System.StringSplitOptions options = default(System.StringSplitOptions)) => throw null;
        public static int SplitAny(this System.ReadOnlySpan<char> source, System.Span<System.Range> destination, System.ReadOnlySpan<char> separators, System.StringSplitOptions options = default(System.StringSplitOptions)) => throw null;
        public static int SplitAny(this System.ReadOnlySpan<char> source, System.Span<System.Range> destination, System.ReadOnlySpan<string> separators, System.StringSplitOptions options = default(System.StringSplitOptions)) => throw null;
        public static bool StartsWith(this System.ReadOnlySpan<char> span, System.ReadOnlySpan<char> value, System.StringComparison comparisonType) => throw null;
        public static bool StartsWith<T>(this System.ReadOnlySpan<T> span, System.ReadOnlySpan<T> value) where T : System.IEquatable<T> => throw null;
        public static bool StartsWith<T>(this System.Span<T> span, System.ReadOnlySpan<T> value) where T : System.IEquatable<T> => throw null;
        public static int ToLower(this System.ReadOnlySpan<char> source, System.Span<char> destination, System.Globalization.CultureInfo culture) => throw null;
        public static int ToLowerInvariant(this System.ReadOnlySpan<char> source, System.Span<char> destination) => throw null;
        public static int ToUpper(this System.ReadOnlySpan<char> source, System.Span<char> destination, System.Globalization.CultureInfo culture) => throw null;
        public static int ToUpperInvariant(this System.ReadOnlySpan<char> source, System.Span<char> destination) => throw null;
        public static System.Memory<char> Trim(this System.Memory<char> memory) => throw null;
        public static System.ReadOnlyMemory<char> Trim(this System.ReadOnlyMemory<char> memory) => throw null;
        public static System.ReadOnlySpan<char> Trim(this System.ReadOnlySpan<char> span) => throw null;
        public static System.ReadOnlySpan<char> Trim(this System.ReadOnlySpan<char> span, char trimChar) => throw null;
        public static System.ReadOnlySpan<char> Trim(this System.ReadOnlySpan<char> span, System.ReadOnlySpan<char> trimChars) => throw null;
        public static System.Span<char> Trim(this System.Span<char> span) => throw null;
        public static System.Memory<T> Trim<T>(this System.Memory<T> memory, System.ReadOnlySpan<T> trimElements) where T : System.IEquatable<T> => throw null;
        public static System.Memory<T> Trim<T>(this System.Memory<T> memory, T trimElement) where T : System.IEquatable<T> => throw null;
        public static System.ReadOnlyMemory<T> Trim<T>(this System.ReadOnlyMemory<T> memory, System.ReadOnlySpan<T> trimElements) where T : System.IEquatable<T> => throw null;
        public static System.ReadOnlyMemory<T> Trim<T>(this System.ReadOnlyMemory<T> memory, T trimElement) where T : System.IEquatable<T> => throw null;
        public static System.ReadOnlySpan<T> Trim<T>(this System.ReadOnlySpan<T> span, System.ReadOnlySpan<T> trimElements) where T : System.IEquatable<T> => throw null;
        public static System.ReadOnlySpan<T> Trim<T>(this System.ReadOnlySpan<T> span, T trimElement) where T : System.IEquatable<T> => throw null;
        public static System.Span<T> Trim<T>(this System.Span<T> span, System.ReadOnlySpan<T> trimElements) where T : System.IEquatable<T> => throw null;
        public static System.Span<T> Trim<T>(this System.Span<T> span, T trimElement) where T : System.IEquatable<T> => throw null;
        public static System.Memory<char> TrimEnd(this System.Memory<char> memory) => throw null;
        public static System.ReadOnlyMemory<char> TrimEnd(this System.ReadOnlyMemory<char> memory) => throw null;
        public static System.ReadOnlySpan<char> TrimEnd(this System.ReadOnlySpan<char> span) => throw null;
        public static System.ReadOnlySpan<char> TrimEnd(this System.ReadOnlySpan<char> span, char trimChar) => throw null;
        public static System.ReadOnlySpan<char> TrimEnd(this System.ReadOnlySpan<char> span, System.ReadOnlySpan<char> trimChars) => throw null;
        public static System.Span<char> TrimEnd(this System.Span<char> span) => throw null;
        public static System.Memory<T> TrimEnd<T>(this System.Memory<T> memory, System.ReadOnlySpan<T> trimElements) where T : System.IEquatable<T> => throw null;
        public static System.Memory<T> TrimEnd<T>(this System.Memory<T> memory, T trimElement) where T : System.IEquatable<T> => throw null;
        public static System.ReadOnlyMemory<T> TrimEnd<T>(this System.ReadOnlyMemory<T> memory, System.ReadOnlySpan<T> trimElements) where T : System.IEquatable<T> => throw null;
        public static System.ReadOnlyMemory<T> TrimEnd<T>(this System.ReadOnlyMemory<T> memory, T trimElement) where T : System.IEquatable<T> => throw null;
        public static System.ReadOnlySpan<T> TrimEnd<T>(this System.ReadOnlySpan<T> span, System.ReadOnlySpan<T> trimElements) where T : System.IEquatable<T> => throw null;
        public static System.ReadOnlySpan<T> TrimEnd<T>(this System.ReadOnlySpan<T> span, T trimElement) where T : System.IEquatable<T> => throw null;
        public static System.Span<T> TrimEnd<T>(this System.Span<T> span, System.ReadOnlySpan<T> trimElements) where T : System.IEquatable<T> => throw null;
        public static System.Span<T> TrimEnd<T>(this System.Span<T> span, T trimElement) where T : System.IEquatable<T> => throw null;
        public static System.Memory<char> TrimStart(this System.Memory<char> memory) => throw null;
        public static System.ReadOnlyMemory<char> TrimStart(this System.ReadOnlyMemory<char> memory) => throw null;
        public static System.ReadOnlySpan<char> TrimStart(this System.ReadOnlySpan<char> span) => throw null;
        public static System.ReadOnlySpan<char> TrimStart(this System.ReadOnlySpan<char> span, char trimChar) => throw null;
        public static System.ReadOnlySpan<char> TrimStart(this System.ReadOnlySpan<char> span, System.ReadOnlySpan<char> trimChars) => throw null;
        public static System.Span<char> TrimStart(this System.Span<char> span) => throw null;
        public static System.Memory<T> TrimStart<T>(this System.Memory<T> memory, System.ReadOnlySpan<T> trimElements) where T : System.IEquatable<T> => throw null;
        public static System.Memory<T> TrimStart<T>(this System.Memory<T> memory, T trimElement) where T : System.IEquatable<T> => throw null;
        public static System.ReadOnlyMemory<T> TrimStart<T>(this System.ReadOnlyMemory<T> memory, System.ReadOnlySpan<T> trimElements) where T : System.IEquatable<T> => throw null;
        public static System.ReadOnlyMemory<T> TrimStart<T>(this System.ReadOnlyMemory<T> memory, T trimElement) where T : System.IEquatable<T> => throw null;
        public static System.ReadOnlySpan<T> TrimStart<T>(this System.ReadOnlySpan<T> span, System.ReadOnlySpan<T> trimElements) where T : System.IEquatable<T> => throw null;
        public static System.ReadOnlySpan<T> TrimStart<T>(this System.ReadOnlySpan<T> span, T trimElement) where T : System.IEquatable<T> => throw null;
        public static System.Span<T> TrimStart<T>(this System.Span<T> span, System.ReadOnlySpan<T> trimElements) where T : System.IEquatable<T> => throw null;
        public static System.Span<T> TrimStart<T>(this System.Span<T> span, T trimElement) where T : System.IEquatable<T> => throw null;
        public static bool TryWrite(this System.Span<char> destination, [System.Runtime.CompilerServices.InterpolatedStringHandlerArgument("destination")] ref System.MemoryExtensions.TryWriteInterpolatedStringHandler handler, out int charsWritten) => throw null;
        public static bool TryWrite(this System.Span<char> destination, System.IFormatProvider provider, [System.Runtime.CompilerServices.InterpolatedStringHandlerArgument(new[] { "destination", "provider" })] ref System.MemoryExtensions.TryWriteInterpolatedStringHandler handler, out int charsWritten) => throw null;
        public static bool TryWrite<TArg0>(this System.Span<char> destination, System.IFormatProvider provider, System.Text.CompositeFormat format, out int charsWritten, TArg0 arg0) => throw null;
        public static bool TryWrite<TArg0, TArg1>(this System.Span<char> destination, System.IFormatProvider provider, System.Text.CompositeFormat format, out int charsWritten, TArg0 arg0, TArg1 arg1) => throw null;
        public static bool TryWrite<TArg0, TArg1, TArg2>(this System.Span<char> destination, System.IFormatProvider provider, System.Text.CompositeFormat format, out int charsWritten, TArg0 arg0, TArg1 arg1, TArg2 arg2) => throw null;
        public static bool TryWrite(this System.Span<char> destination, System.IFormatProvider provider, System.Text.CompositeFormat format, out int charsWritten, params object[] args) => throw null;
        public static bool TryWrite(this System.Span<char> destination, System.IFormatProvider provider, System.Text.CompositeFormat format, out int charsWritten, System.ReadOnlySpan<object> args) => throw null;
        [System.Runtime.CompilerServices.InterpolatedStringHandler]
        public struct TryWriteInterpolatedStringHandler
        {
            public bool AppendFormatted(System.ReadOnlySpan<char> value) => throw null;
            public bool AppendFormatted(System.ReadOnlySpan<char> value, int alignment = default(int), string format = default(string)) => throw null;
            public bool AppendFormatted<T>(T value) => throw null;
            public bool AppendFormatted<T>(T value, string format) => throw null;
            public bool AppendFormatted<T>(T value, int alignment) => throw null;
            public bool AppendFormatted<T>(T value, int alignment, string format) => throw null;
            public bool AppendFormatted(object value, int alignment = default(int), string format = default(string)) => throw null;
            public bool AppendFormatted(string value) => throw null;
            public bool AppendFormatted(string value, int alignment = default(int), string format = default(string)) => throw null;
            public bool AppendLiteral(string value) => throw null;
            public TryWriteInterpolatedStringHandler(int literalLength, int formattedCount, System.Span<char> destination, out bool shouldAppend) => throw null;
            public TryWriteInterpolatedStringHandler(int literalLength, int formattedCount, System.Span<char> destination, System.IFormatProvider provider, out bool shouldAppend) => throw null;
        }
    }
    namespace Runtime
    {
        namespace InteropServices
        {
            public static class MemoryMarshal
            {
                public static System.ReadOnlySpan<byte> AsBytes<T>(System.ReadOnlySpan<T> span) where T : struct => throw null;
                public static System.Span<byte> AsBytes<T>(System.Span<T> span) where T : struct => throw null;
                public static System.Memory<T> AsMemory<T>(System.ReadOnlyMemory<T> memory) => throw null;
                public static T AsRef<T>(System.ReadOnlySpan<byte> span) where T : struct => throw null;
                public static T AsRef<T>(System.Span<byte> span) where T : struct => throw null;
                public static System.ReadOnlySpan<TTo> Cast<TFrom, TTo>(System.ReadOnlySpan<TFrom> span) where TFrom : struct where TTo : struct => throw null;
                public static System.Span<TTo> Cast<TFrom, TTo>(System.Span<TFrom> span) where TFrom : struct where TTo : struct => throw null;
                public static System.Memory<T> CreateFromPinnedArray<T>(T[] array, int start, int length) => throw null;
                public static System.ReadOnlySpan<T> CreateReadOnlySpan<T>(ref readonly T reference, int length) => throw null;
                public static unsafe System.ReadOnlySpan<byte> CreateReadOnlySpanFromNullTerminated(byte* value) => throw null;
                public static unsafe System.ReadOnlySpan<char> CreateReadOnlySpanFromNullTerminated(char* value) => throw null;
                public static System.Span<T> CreateSpan<T>(ref T reference, int length) => throw null;
                public static T GetArrayDataReference<T>(T[] array) => throw null;
                public static byte GetArrayDataReference(System.Array array) => throw null;
                public static T GetReference<T>(System.ReadOnlySpan<T> span) => throw null;
                public static T GetReference<T>(System.Span<T> span) => throw null;
                public static T Read<T>(System.ReadOnlySpan<byte> source) where T : struct => throw null;
                public static System.Collections.Generic.IEnumerable<T> ToEnumerable<T>(System.ReadOnlyMemory<T> memory) => throw null;
                public static bool TryGetArray<T>(System.ReadOnlyMemory<T> memory, out System.ArraySegment<T> segment) => throw null;
                public static bool TryGetMemoryManager<T, TManager>(System.ReadOnlyMemory<T> memory, out TManager manager) where TManager : System.Buffers.MemoryManager<T> => throw null;
                public static bool TryGetMemoryManager<T, TManager>(System.ReadOnlyMemory<T> memory, out TManager manager, out int start, out int length) where TManager : System.Buffers.MemoryManager<T> => throw null;
                public static bool TryGetString(System.ReadOnlyMemory<char> memory, out string text, out int start, out int length) => throw null;
                public static bool TryRead<T>(System.ReadOnlySpan<byte> source, out T value) where T : struct => throw null;
                public static bool TryWrite<T>(System.Span<byte> destination, in T value) where T : struct => throw null;
                public static void Write<T>(System.Span<byte> destination, in T value) where T : struct => throw null;
            }
            public static class SequenceMarshal
            {
                public static bool TryGetArray<T>(System.Buffers.ReadOnlySequence<T> sequence, out System.ArraySegment<T> segment) => throw null;
                public static bool TryGetReadOnlyMemory<T>(System.Buffers.ReadOnlySequence<T> sequence, out System.ReadOnlyMemory<T> memory) => throw null;
                public static bool TryGetReadOnlySequenceSegment<T>(System.Buffers.ReadOnlySequence<T> sequence, out System.Buffers.ReadOnlySequenceSegment<T> startSegment, out int startIndex, out System.Buffers.ReadOnlySequenceSegment<T> endSegment, out int endIndex) => throw null;
                public static bool TryRead<T>(ref System.Buffers.SequenceReader<byte> reader, out T value) where T : unmanaged => throw null;
            }
        }
    }
    public struct SequencePosition : System.IEquatable<System.SequencePosition>
    {
        public SequencePosition(object @object, int integer) => throw null;
        public override bool Equals(object obj) => throw null;
        public bool Equals(System.SequencePosition other) => throw null;
        public override int GetHashCode() => throw null;
        public int GetInteger() => throw null;
        public object GetObject() => throw null;
    }
    namespace Text
    {
        public static partial class EncodingExtensions
        {
            public static void Convert(this System.Text.Decoder decoder, in System.Buffers.ReadOnlySequence<byte> bytes, System.Buffers.IBufferWriter<char> writer, bool flush, out long charsUsed, out bool completed) => throw null;
            public static void Convert(this System.Text.Decoder decoder, System.ReadOnlySpan<byte> bytes, System.Buffers.IBufferWriter<char> writer, bool flush, out long charsUsed, out bool completed) => throw null;
            public static void Convert(this System.Text.Encoder encoder, in System.Buffers.ReadOnlySequence<char> chars, System.Buffers.IBufferWriter<byte> writer, bool flush, out long bytesUsed, out bool completed) => throw null;
            public static void Convert(this System.Text.Encoder encoder, System.ReadOnlySpan<char> chars, System.Buffers.IBufferWriter<byte> writer, bool flush, out long bytesUsed, out bool completed) => throw null;
            public static byte[] GetBytes(this System.Text.Encoding encoding, in System.Buffers.ReadOnlySequence<char> chars) => throw null;
            public static long GetBytes(this System.Text.Encoding encoding, in System.Buffers.ReadOnlySequence<char> chars, System.Buffers.IBufferWriter<byte> writer) => throw null;
            public static int GetBytes(this System.Text.Encoding encoding, in System.Buffers.ReadOnlySequence<char> chars, System.Span<byte> bytes) => throw null;
            public static long GetBytes(this System.Text.Encoding encoding, System.ReadOnlySpan<char> chars, System.Buffers.IBufferWriter<byte> writer) => throw null;
            public static long GetChars(this System.Text.Encoding encoding, in System.Buffers.ReadOnlySequence<byte> bytes, System.Buffers.IBufferWriter<char> writer) => throw null;
            public static int GetChars(this System.Text.Encoding encoding, in System.Buffers.ReadOnlySequence<byte> bytes, System.Span<char> chars) => throw null;
            public static long GetChars(this System.Text.Encoding encoding, System.ReadOnlySpan<byte> bytes, System.Buffers.IBufferWriter<char> writer) => throw null;
            public static string GetString(this System.Text.Encoding encoding, in System.Buffers.ReadOnlySequence<byte> bytes) => throw null;
        }
        public struct SpanLineEnumerator
        {
            public System.ReadOnlySpan<char> Current { get => throw null; }
            public System.Text.SpanLineEnumerator GetEnumerator() => throw null;
            public bool MoveNext() => throw null;
        }
        public struct SpanRuneEnumerator
        {
            public System.Text.Rune Current { get => throw null; }
            public System.Text.SpanRuneEnumerator GetEnumerator() => throw null;
            public bool MoveNext() => throw null;
        }
    }
}
