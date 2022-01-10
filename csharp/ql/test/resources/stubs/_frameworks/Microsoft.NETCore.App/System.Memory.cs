// This file contains auto-generated code.

namespace System
{
    // Generated from `System.MemoryExtensions` in `System.Memory, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
    public static class MemoryExtensions
    {
        public static System.ReadOnlyMemory<System.Char> AsMemory(this string text) => throw null;
        public static System.ReadOnlyMemory<System.Char> AsMemory(this string text, System.Index startIndex) => throw null;
        public static System.ReadOnlyMemory<System.Char> AsMemory(this string text, System.Range range) => throw null;
        public static System.ReadOnlyMemory<System.Char> AsMemory(this string text, int start) => throw null;
        public static System.ReadOnlyMemory<System.Char> AsMemory(this string text, int start, int length) => throw null;
        public static System.Memory<T> AsMemory<T>(this System.ArraySegment<T> segment) => throw null;
        public static System.Memory<T> AsMemory<T>(this System.ArraySegment<T> segment, int start) => throw null;
        public static System.Memory<T> AsMemory<T>(this System.ArraySegment<T> segment, int start, int length) => throw null;
        public static System.Memory<T> AsMemory<T>(this T[] array) => throw null;
        public static System.Memory<T> AsMemory<T>(this T[] array, System.Index startIndex) => throw null;
        public static System.Memory<T> AsMemory<T>(this T[] array, System.Range range) => throw null;
        public static System.Memory<T> AsMemory<T>(this T[] array, int start) => throw null;
        public static System.Memory<T> AsMemory<T>(this T[] array, int start, int length) => throw null;
        public static System.ReadOnlySpan<System.Char> AsSpan(this string text) => throw null;
        public static System.ReadOnlySpan<System.Char> AsSpan(this string text, int start) => throw null;
        public static System.ReadOnlySpan<System.Char> AsSpan(this string text, int start, int length) => throw null;
        public static System.Span<T> AsSpan<T>(this System.ArraySegment<T> segment) => throw null;
        public static System.Span<T> AsSpan<T>(this System.ArraySegment<T> segment, System.Index startIndex) => throw null;
        public static System.Span<T> AsSpan<T>(this System.ArraySegment<T> segment, System.Range range) => throw null;
        public static System.Span<T> AsSpan<T>(this System.ArraySegment<T> segment, int start) => throw null;
        public static System.Span<T> AsSpan<T>(this System.ArraySegment<T> segment, int start, int length) => throw null;
        public static System.Span<T> AsSpan<T>(this T[] array) => throw null;
        public static System.Span<T> AsSpan<T>(this T[] array, System.Index startIndex) => throw null;
        public static System.Span<T> AsSpan<T>(this T[] array, System.Range range) => throw null;
        public static System.Span<T> AsSpan<T>(this T[] array, int start) => throw null;
        public static System.Span<T> AsSpan<T>(this T[] array, int start, int length) => throw null;
        public static int BinarySearch<T, TComparable>(this System.ReadOnlySpan<T> span, TComparable comparable) where TComparable : System.IComparable<T> => throw null;
        public static int BinarySearch<T, TComparable>(this System.Span<T> span, TComparable comparable) where TComparable : System.IComparable<T> => throw null;
        public static int BinarySearch<T, TComparer>(this System.ReadOnlySpan<T> span, T value, TComparer comparer) where TComparer : System.Collections.Generic.IComparer<T> => throw null;
        public static int BinarySearch<T, TComparer>(this System.Span<T> span, T value, TComparer comparer) where TComparer : System.Collections.Generic.IComparer<T> => throw null;
        public static int BinarySearch<T>(this System.ReadOnlySpan<T> span, System.IComparable<T> comparable) => throw null;
        public static int BinarySearch<T>(this System.Span<T> span, System.IComparable<T> comparable) => throw null;
        public static int CompareTo(this System.ReadOnlySpan<System.Char> span, System.ReadOnlySpan<System.Char> other, System.StringComparison comparisonType) => throw null;
        public static bool Contains(this System.ReadOnlySpan<System.Char> span, System.ReadOnlySpan<System.Char> value, System.StringComparison comparisonType) => throw null;
        public static bool Contains<T>(this System.ReadOnlySpan<T> span, T value) where T : System.IEquatable<T> => throw null;
        public static bool Contains<T>(this System.Span<T> span, T value) where T : System.IEquatable<T> => throw null;
        public static void CopyTo<T>(this T[] source, System.Memory<T> destination) => throw null;
        public static void CopyTo<T>(this T[] source, System.Span<T> destination) => throw null;
        public static bool EndsWith(this System.ReadOnlySpan<System.Char> span, System.ReadOnlySpan<System.Char> value, System.StringComparison comparisonType) => throw null;
        public static bool EndsWith<T>(this System.ReadOnlySpan<T> span, System.ReadOnlySpan<T> value) where T : System.IEquatable<T> => throw null;
        public static bool EndsWith<T>(this System.Span<T> span, System.ReadOnlySpan<T> value) where T : System.IEquatable<T> => throw null;
        public static System.Text.SpanRuneEnumerator EnumerateRunes(this System.ReadOnlySpan<System.Char> span) => throw null;
        public static System.Text.SpanRuneEnumerator EnumerateRunes(this System.Span<System.Char> span) => throw null;
        public static bool Equals(this System.ReadOnlySpan<System.Char> span, System.ReadOnlySpan<System.Char> other, System.StringComparison comparisonType) => throw null;
        public static int IndexOf(this System.ReadOnlySpan<System.Char> span, System.ReadOnlySpan<System.Char> value, System.StringComparison comparisonType) => throw null;
        public static int IndexOf<T>(this System.ReadOnlySpan<T> span, System.ReadOnlySpan<T> value) where T : System.IEquatable<T> => throw null;
        public static int IndexOf<T>(this System.ReadOnlySpan<T> span, T value) where T : System.IEquatable<T> => throw null;
        public static int IndexOf<T>(this System.Span<T> span, System.ReadOnlySpan<T> value) where T : System.IEquatable<T> => throw null;
        public static int IndexOf<T>(this System.Span<T> span, T value) where T : System.IEquatable<T> => throw null;
        public static int IndexOfAny<T>(this System.ReadOnlySpan<T> span, System.ReadOnlySpan<T> values) where T : System.IEquatable<T> => throw null;
        public static int IndexOfAny<T>(this System.ReadOnlySpan<T> span, T value0, T value1) where T : System.IEquatable<T> => throw null;
        public static int IndexOfAny<T>(this System.ReadOnlySpan<T> span, T value0, T value1, T value2) where T : System.IEquatable<T> => throw null;
        public static int IndexOfAny<T>(this System.Span<T> span, System.ReadOnlySpan<T> values) where T : System.IEquatable<T> => throw null;
        public static int IndexOfAny<T>(this System.Span<T> span, T value0, T value1) where T : System.IEquatable<T> => throw null;
        public static int IndexOfAny<T>(this System.Span<T> span, T value0, T value1, T value2) where T : System.IEquatable<T> => throw null;
        public static bool IsWhiteSpace(this System.ReadOnlySpan<System.Char> span) => throw null;
        public static int LastIndexOf(this System.ReadOnlySpan<System.Char> span, System.ReadOnlySpan<System.Char> value, System.StringComparison comparisonType) => throw null;
        public static int LastIndexOf<T>(this System.ReadOnlySpan<T> span, System.ReadOnlySpan<T> value) where T : System.IEquatable<T> => throw null;
        public static int LastIndexOf<T>(this System.ReadOnlySpan<T> span, T value) where T : System.IEquatable<T> => throw null;
        public static int LastIndexOf<T>(this System.Span<T> span, System.ReadOnlySpan<T> value) where T : System.IEquatable<T> => throw null;
        public static int LastIndexOf<T>(this System.Span<T> span, T value) where T : System.IEquatable<T> => throw null;
        public static int LastIndexOfAny<T>(this System.ReadOnlySpan<T> span, System.ReadOnlySpan<T> values) where T : System.IEquatable<T> => throw null;
        public static int LastIndexOfAny<T>(this System.ReadOnlySpan<T> span, T value0, T value1) where T : System.IEquatable<T> => throw null;
        public static int LastIndexOfAny<T>(this System.ReadOnlySpan<T> span, T value0, T value1, T value2) where T : System.IEquatable<T> => throw null;
        public static int LastIndexOfAny<T>(this System.Span<T> span, System.ReadOnlySpan<T> values) where T : System.IEquatable<T> => throw null;
        public static int LastIndexOfAny<T>(this System.Span<T> span, T value0, T value1) where T : System.IEquatable<T> => throw null;
        public static int LastIndexOfAny<T>(this System.Span<T> span, T value0, T value1, T value2) where T : System.IEquatable<T> => throw null;
        public static bool Overlaps<T>(this System.ReadOnlySpan<T> span, System.ReadOnlySpan<T> other) => throw null;
        public static bool Overlaps<T>(this System.ReadOnlySpan<T> span, System.ReadOnlySpan<T> other, out int elementOffset) => throw null;
        public static bool Overlaps<T>(this System.Span<T> span, System.ReadOnlySpan<T> other) => throw null;
        public static bool Overlaps<T>(this System.Span<T> span, System.ReadOnlySpan<T> other, out int elementOffset) => throw null;
        public static void Reverse<T>(this System.Span<T> span) => throw null;
        public static int SequenceCompareTo<T>(this System.ReadOnlySpan<T> span, System.ReadOnlySpan<T> other) where T : System.IComparable<T> => throw null;
        public static int SequenceCompareTo<T>(this System.Span<T> span, System.ReadOnlySpan<T> other) where T : System.IComparable<T> => throw null;
        public static bool SequenceEqual<T>(this System.ReadOnlySpan<T> span, System.ReadOnlySpan<T> other) where T : System.IEquatable<T> => throw null;
        public static bool SequenceEqual<T>(this System.Span<T> span, System.ReadOnlySpan<T> other) where T : System.IEquatable<T> => throw null;
        public static void Sort<T, TComparer>(this System.Span<T> span, TComparer comparer) where TComparer : System.Collections.Generic.IComparer<T> => throw null;
        public static void Sort<T>(this System.Span<T> span) => throw null;
        public static void Sort<T>(this System.Span<T> span, System.Comparison<T> comparison) => throw null;
        public static void Sort<TKey, TValue, TComparer>(this System.Span<TKey> keys, System.Span<TValue> items, TComparer comparer) where TComparer : System.Collections.Generic.IComparer<TKey> => throw null;
        public static void Sort<TKey, TValue>(this System.Span<TKey> keys, System.Span<TValue> items) => throw null;
        public static void Sort<TKey, TValue>(this System.Span<TKey> keys, System.Span<TValue> items, System.Comparison<TKey> comparison) => throw null;
        public static bool StartsWith(this System.ReadOnlySpan<System.Char> span, System.ReadOnlySpan<System.Char> value, System.StringComparison comparisonType) => throw null;
        public static bool StartsWith<T>(this System.ReadOnlySpan<T> span, System.ReadOnlySpan<T> value) where T : System.IEquatable<T> => throw null;
        public static bool StartsWith<T>(this System.Span<T> span, System.ReadOnlySpan<T> value) where T : System.IEquatable<T> => throw null;
        public static int ToLower(this System.ReadOnlySpan<System.Char> source, System.Span<System.Char> destination, System.Globalization.CultureInfo culture) => throw null;
        public static int ToLowerInvariant(this System.ReadOnlySpan<System.Char> source, System.Span<System.Char> destination) => throw null;
        public static int ToUpper(this System.ReadOnlySpan<System.Char> source, System.Span<System.Char> destination, System.Globalization.CultureInfo culture) => throw null;
        public static int ToUpperInvariant(this System.ReadOnlySpan<System.Char> source, System.Span<System.Char> destination) => throw null;
        public static System.Memory<System.Char> Trim(this System.Memory<System.Char> memory) => throw null;
        public static System.ReadOnlyMemory<System.Char> Trim(this System.ReadOnlyMemory<System.Char> memory) => throw null;
        public static System.ReadOnlySpan<System.Char> Trim(this System.ReadOnlySpan<System.Char> span) => throw null;
        public static System.ReadOnlySpan<System.Char> Trim(this System.ReadOnlySpan<System.Char> span, System.ReadOnlySpan<System.Char> trimChars) => throw null;
        public static System.ReadOnlySpan<System.Char> Trim(this System.ReadOnlySpan<System.Char> span, System.Char trimChar) => throw null;
        public static System.Span<System.Char> Trim(this System.Span<System.Char> span) => throw null;
        public static System.Memory<T> Trim<T>(this System.Memory<T> memory, System.ReadOnlySpan<T> trimElements) where T : System.IEquatable<T> => throw null;
        public static System.Memory<T> Trim<T>(this System.Memory<T> memory, T trimElement) where T : System.IEquatable<T> => throw null;
        public static System.ReadOnlyMemory<T> Trim<T>(this System.ReadOnlyMemory<T> memory, System.ReadOnlySpan<T> trimElements) where T : System.IEquatable<T> => throw null;
        public static System.ReadOnlyMemory<T> Trim<T>(this System.ReadOnlyMemory<T> memory, T trimElement) where T : System.IEquatable<T> => throw null;
        public static System.ReadOnlySpan<T> Trim<T>(this System.ReadOnlySpan<T> span, System.ReadOnlySpan<T> trimElements) where T : System.IEquatable<T> => throw null;
        public static System.ReadOnlySpan<T> Trim<T>(this System.ReadOnlySpan<T> span, T trimElement) where T : System.IEquatable<T> => throw null;
        public static System.Span<T> Trim<T>(this System.Span<T> span, System.ReadOnlySpan<T> trimElements) where T : System.IEquatable<T> => throw null;
        public static System.Span<T> Trim<T>(this System.Span<T> span, T trimElement) where T : System.IEquatable<T> => throw null;
        public static System.Memory<System.Char> TrimEnd(this System.Memory<System.Char> memory) => throw null;
        public static System.ReadOnlyMemory<System.Char> TrimEnd(this System.ReadOnlyMemory<System.Char> memory) => throw null;
        public static System.ReadOnlySpan<System.Char> TrimEnd(this System.ReadOnlySpan<System.Char> span) => throw null;
        public static System.ReadOnlySpan<System.Char> TrimEnd(this System.ReadOnlySpan<System.Char> span, System.ReadOnlySpan<System.Char> trimChars) => throw null;
        public static System.ReadOnlySpan<System.Char> TrimEnd(this System.ReadOnlySpan<System.Char> span, System.Char trimChar) => throw null;
        public static System.Span<System.Char> TrimEnd(this System.Span<System.Char> span) => throw null;
        public static System.Memory<T> TrimEnd<T>(this System.Memory<T> memory, System.ReadOnlySpan<T> trimElements) where T : System.IEquatable<T> => throw null;
        public static System.Memory<T> TrimEnd<T>(this System.Memory<T> memory, T trimElement) where T : System.IEquatable<T> => throw null;
        public static System.ReadOnlyMemory<T> TrimEnd<T>(this System.ReadOnlyMemory<T> memory, System.ReadOnlySpan<T> trimElements) where T : System.IEquatable<T> => throw null;
        public static System.ReadOnlyMemory<T> TrimEnd<T>(this System.ReadOnlyMemory<T> memory, T trimElement) where T : System.IEquatable<T> => throw null;
        public static System.ReadOnlySpan<T> TrimEnd<T>(this System.ReadOnlySpan<T> span, System.ReadOnlySpan<T> trimElements) where T : System.IEquatable<T> => throw null;
        public static System.ReadOnlySpan<T> TrimEnd<T>(this System.ReadOnlySpan<T> span, T trimElement) where T : System.IEquatable<T> => throw null;
        public static System.Span<T> TrimEnd<T>(this System.Span<T> span, System.ReadOnlySpan<T> trimElements) where T : System.IEquatable<T> => throw null;
        public static System.Span<T> TrimEnd<T>(this System.Span<T> span, T trimElement) where T : System.IEquatable<T> => throw null;
        public static System.Memory<System.Char> TrimStart(this System.Memory<System.Char> memory) => throw null;
        public static System.ReadOnlyMemory<System.Char> TrimStart(this System.ReadOnlyMemory<System.Char> memory) => throw null;
        public static System.ReadOnlySpan<System.Char> TrimStart(this System.ReadOnlySpan<System.Char> span) => throw null;
        public static System.ReadOnlySpan<System.Char> TrimStart(this System.ReadOnlySpan<System.Char> span, System.ReadOnlySpan<System.Char> trimChars) => throw null;
        public static System.ReadOnlySpan<System.Char> TrimStart(this System.ReadOnlySpan<System.Char> span, System.Char trimChar) => throw null;
        public static System.Span<System.Char> TrimStart(this System.Span<System.Char> span) => throw null;
        public static System.Memory<T> TrimStart<T>(this System.Memory<T> memory, System.ReadOnlySpan<T> trimElements) where T : System.IEquatable<T> => throw null;
        public static System.Memory<T> TrimStart<T>(this System.Memory<T> memory, T trimElement) where T : System.IEquatable<T> => throw null;
        public static System.ReadOnlyMemory<T> TrimStart<T>(this System.ReadOnlyMemory<T> memory, System.ReadOnlySpan<T> trimElements) where T : System.IEquatable<T> => throw null;
        public static System.ReadOnlyMemory<T> TrimStart<T>(this System.ReadOnlyMemory<T> memory, T trimElement) where T : System.IEquatable<T> => throw null;
        public static System.ReadOnlySpan<T> TrimStart<T>(this System.ReadOnlySpan<T> span, System.ReadOnlySpan<T> trimElements) where T : System.IEquatable<T> => throw null;
        public static System.ReadOnlySpan<T> TrimStart<T>(this System.ReadOnlySpan<T> span, T trimElement) where T : System.IEquatable<T> => throw null;
        public static System.Span<T> TrimStart<T>(this System.Span<T> span, System.ReadOnlySpan<T> trimElements) where T : System.IEquatable<T> => throw null;
        public static System.Span<T> TrimStart<T>(this System.Span<T> span, T trimElement) where T : System.IEquatable<T> => throw null;
    }

    // Generated from `System.SequencePosition` in `System.Memory, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
    public struct SequencePosition : System.IEquatable<System.SequencePosition>
    {
        public bool Equals(System.SequencePosition other) => throw null;
        public override bool Equals(object obj) => throw null;
        public override int GetHashCode() => throw null;
        public int GetInteger() => throw null;
        public object GetObject() => throw null;
        // Stub generator skipped constructor 
        public SequencePosition(object @object, int integer) => throw null;
    }

    namespace Buffers
    {
        // Generated from `System.Buffers.ArrayBufferWriter<>` in `System.Memory, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ArrayBufferWriter<T> : System.Buffers.IBufferWriter<T>
        {
            public void Advance(int count) => throw null;
            public ArrayBufferWriter() => throw null;
            public ArrayBufferWriter(int initialCapacity) => throw null;
            public int Capacity { get => throw null; }
            public void Clear() => throw null;
            public int FreeCapacity { get => throw null; }
            public System.Memory<T> GetMemory(int sizeHint = default(int)) => throw null;
            public System.Span<T> GetSpan(int sizeHint = default(int)) => throw null;
            public int WrittenCount { get => throw null; }
            public System.ReadOnlyMemory<T> WrittenMemory { get => throw null; }
            public System.ReadOnlySpan<T> WrittenSpan { get => throw null; }
        }

        // Generated from `System.Buffers.BuffersExtensions` in `System.Memory, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public static class BuffersExtensions
        {
            public static void CopyTo<T>(System.Buffers.ReadOnlySequence<T> source, System.Span<T> destination) => throw null;
            public static System.SequencePosition? PositionOf<T>(System.Buffers.ReadOnlySequence<T> source, T value) where T : System.IEquatable<T> => throw null;
            public static T[] ToArray<T>(System.Buffers.ReadOnlySequence<T> sequence) => throw null;
            public static void Write<T>(this System.Buffers.IBufferWriter<T> writer, System.ReadOnlySpan<T> value) => throw null;
        }

        // Generated from `System.Buffers.IBufferWriter<>` in `System.Memory, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public interface IBufferWriter<T>
        {
            void Advance(int count);
            System.Memory<T> GetMemory(int sizeHint = default(int));
            System.Span<T> GetSpan(int sizeHint = default(int));
        }

        // Generated from `System.Buffers.MemoryPool<>` in `System.Memory, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public abstract class MemoryPool<T> : System.IDisposable
        {
            public void Dispose() => throw null;
            protected abstract void Dispose(bool disposing);
            public abstract int MaxBufferSize { get; }
            protected MemoryPool() => throw null;
            public abstract System.Buffers.IMemoryOwner<T> Rent(int minBufferSize = default(int));
            public static System.Buffers.MemoryPool<T> Shared { get => throw null; }
        }

        // Generated from `System.Buffers.ReadOnlySequence<>` in `System.Memory, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public struct ReadOnlySequence<T>
        {
            // Generated from `System.Buffers.ReadOnlySequence<>+Enumerator` in `System.Memory, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public struct Enumerator
            {
                public System.ReadOnlyMemory<T> Current { get => throw null; }
                // Stub generator skipped constructor 
                public Enumerator(System.Buffers.ReadOnlySequence<T> sequence) => throw null;
                public bool MoveNext() => throw null;
            }


            public static System.Buffers.ReadOnlySequence<T> Empty;
            public System.SequencePosition End { get => throw null; }
            public System.ReadOnlyMemory<T> First { get => throw null; }
            public System.ReadOnlySpan<T> FirstSpan { get => throw null; }
            public System.Buffers.ReadOnlySequence<T>.Enumerator GetEnumerator() => throw null;
            public System.Int64 GetOffset(System.SequencePosition position) => throw null;
            public System.SequencePosition GetPosition(System.Int64 offset) => throw null;
            public System.SequencePosition GetPosition(System.Int64 offset, System.SequencePosition origin) => throw null;
            public bool IsEmpty { get => throw null; }
            public bool IsSingleSegment { get => throw null; }
            public System.Int64 Length { get => throw null; }
            // Stub generator skipped constructor 
            public ReadOnlySequence(System.ReadOnlyMemory<T> memory) => throw null;
            public ReadOnlySequence(System.Buffers.ReadOnlySequenceSegment<T> startSegment, int startIndex, System.Buffers.ReadOnlySequenceSegment<T> endSegment, int endIndex) => throw null;
            public ReadOnlySequence(T[] array) => throw null;
            public ReadOnlySequence(T[] array, int start, int length) => throw null;
            public System.Buffers.ReadOnlySequence<T> Slice(System.SequencePosition start) => throw null;
            public System.Buffers.ReadOnlySequence<T> Slice(System.SequencePosition start, System.SequencePosition end) => throw null;
            public System.Buffers.ReadOnlySequence<T> Slice(System.SequencePosition start, int length) => throw null;
            public System.Buffers.ReadOnlySequence<T> Slice(System.SequencePosition start, System.Int64 length) => throw null;
            public System.Buffers.ReadOnlySequence<T> Slice(int start, System.SequencePosition end) => throw null;
            public System.Buffers.ReadOnlySequence<T> Slice(int start, int length) => throw null;
            public System.Buffers.ReadOnlySequence<T> Slice(System.Int64 start) => throw null;
            public System.Buffers.ReadOnlySequence<T> Slice(System.Int64 start, System.SequencePosition end) => throw null;
            public System.Buffers.ReadOnlySequence<T> Slice(System.Int64 start, System.Int64 length) => throw null;
            public System.SequencePosition Start { get => throw null; }
            public override string ToString() => throw null;
            public bool TryGet(ref System.SequencePosition position, out System.ReadOnlyMemory<T> memory, bool advance = default(bool)) => throw null;
        }

        // Generated from `System.Buffers.ReadOnlySequenceSegment<>` in `System.Memory, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public abstract class ReadOnlySequenceSegment<T>
        {
            public System.ReadOnlyMemory<T> Memory { get => throw null; set => throw null; }
            public System.Buffers.ReadOnlySequenceSegment<T> Next { get => throw null; set => throw null; }
            protected ReadOnlySequenceSegment() => throw null;
            public System.Int64 RunningIndex { get => throw null; set => throw null; }
        }

        // Generated from `System.Buffers.SequenceReader<>` in `System.Memory, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public struct SequenceReader<T> where T : unmanaged, System.IEquatable<T>
        {
            public void Advance(System.Int64 count) => throw null;
            public System.Int64 AdvancePast(T value) => throw null;
            public System.Int64 AdvancePastAny(System.ReadOnlySpan<T> values) => throw null;
            public System.Int64 AdvancePastAny(T value0, T value1) => throw null;
            public System.Int64 AdvancePastAny(T value0, T value1, T value2) => throw null;
            public System.Int64 AdvancePastAny(T value0, T value1, T value2, T value3) => throw null;
            public void AdvanceToEnd() => throw null;
            public System.Int64 Consumed { get => throw null; }
            public System.ReadOnlySpan<T> CurrentSpan { get => throw null; }
            public int CurrentSpanIndex { get => throw null; }
            public bool End { get => throw null; }
            public bool IsNext(System.ReadOnlySpan<T> next, bool advancePast = default(bool)) => throw null;
            public bool IsNext(T next, bool advancePast = default(bool)) => throw null;
            public System.Int64 Length { get => throw null; }
            public System.SequencePosition Position { get => throw null; }
            public System.Int64 Remaining { get => throw null; }
            public void Rewind(System.Int64 count) => throw null;
            public System.Buffers.ReadOnlySequence<T> Sequence { get => throw null; }
            // Stub generator skipped constructor 
            public SequenceReader(System.Buffers.ReadOnlySequence<T> sequence) => throw null;
            public bool TryAdvanceTo(T delimiter, bool advancePastDelimiter = default(bool)) => throw null;
            public bool TryAdvanceToAny(System.ReadOnlySpan<T> delimiters, bool advancePastDelimiter = default(bool)) => throw null;
            public bool TryCopyTo(System.Span<T> destination) => throw null;
            public bool TryPeek(System.Int64 offset, out T value) => throw null;
            public bool TryPeek(out T value) => throw null;
            public bool TryRead(out T value) => throw null;
            public bool TryReadTo(out System.Buffers.ReadOnlySequence<T> sequence, System.ReadOnlySpan<T> delimiter, bool advancePastDelimiter = default(bool)) => throw null;
            public bool TryReadTo(out System.Buffers.ReadOnlySequence<T> sequence, T delimiter, T delimiterEscape, bool advancePastDelimiter = default(bool)) => throw null;
            public bool TryReadTo(out System.Buffers.ReadOnlySequence<T> sequence, T delimiter, bool advancePastDelimiter = default(bool)) => throw null;
            public bool TryReadTo(out System.ReadOnlySpan<T> span, System.ReadOnlySpan<T> delimiter, bool advancePastDelimiter = default(bool)) => throw null;
            public bool TryReadTo(out System.ReadOnlySpan<T> span, T delimiter, T delimiterEscape, bool advancePastDelimiter = default(bool)) => throw null;
            public bool TryReadTo(out System.ReadOnlySpan<T> span, T delimiter, bool advancePastDelimiter = default(bool)) => throw null;
            public bool TryReadToAny(out System.Buffers.ReadOnlySequence<T> sequence, System.ReadOnlySpan<T> delimiters, bool advancePastDelimiter = default(bool)) => throw null;
            public bool TryReadToAny(out System.ReadOnlySpan<T> span, System.ReadOnlySpan<T> delimiters, bool advancePastDelimiter = default(bool)) => throw null;
            public System.Buffers.ReadOnlySequence<T> UnreadSequence { get => throw null; }
            public System.ReadOnlySpan<T> UnreadSpan { get => throw null; }
        }

        // Generated from `System.Buffers.SequenceReaderExtensions` in `System.Memory, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public static class SequenceReaderExtensions
        {
            public static bool TryReadBigEndian(ref System.Buffers.SequenceReader<System.Byte> reader, out int value) => throw null;
            public static bool TryReadBigEndian(ref System.Buffers.SequenceReader<System.Byte> reader, out System.Int64 value) => throw null;
            public static bool TryReadBigEndian(ref System.Buffers.SequenceReader<System.Byte> reader, out System.Int16 value) => throw null;
            public static bool TryReadLittleEndian(ref System.Buffers.SequenceReader<System.Byte> reader, out int value) => throw null;
            public static bool TryReadLittleEndian(ref System.Buffers.SequenceReader<System.Byte> reader, out System.Int64 value) => throw null;
            public static bool TryReadLittleEndian(ref System.Buffers.SequenceReader<System.Byte> reader, out System.Int16 value) => throw null;
        }

        // Generated from `System.Buffers.StandardFormat` in `System.Memory, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public struct StandardFormat : System.IEquatable<System.Buffers.StandardFormat>
        {
            public static bool operator !=(System.Buffers.StandardFormat left, System.Buffers.StandardFormat right) => throw null;
            public static bool operator ==(System.Buffers.StandardFormat left, System.Buffers.StandardFormat right) => throw null;
            public bool Equals(System.Buffers.StandardFormat other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public bool HasPrecision { get => throw null; }
            public bool IsDefault { get => throw null; }
            public const System.Byte MaxPrecision = default;
            public const System.Byte NoPrecision = default;
            public static System.Buffers.StandardFormat Parse(System.ReadOnlySpan<System.Char> format) => throw null;
            public static System.Buffers.StandardFormat Parse(string format) => throw null;
            public System.Byte Precision { get => throw null; }
            // Stub generator skipped constructor 
            public StandardFormat(System.Char symbol, System.Byte precision = default(System.Byte)) => throw null;
            public System.Char Symbol { get => throw null; }
            public override string ToString() => throw null;
            public static bool TryParse(System.ReadOnlySpan<System.Char> format, out System.Buffers.StandardFormat result) => throw null;
            public static implicit operator System.Buffers.StandardFormat(System.Char symbol) => throw null;
        }

        namespace Binary
        {
            // Generated from `System.Buffers.Binary.BinaryPrimitives` in `System.Memory, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public static class BinaryPrimitives
            {
                public static double ReadDoubleBigEndian(System.ReadOnlySpan<System.Byte> source) => throw null;
                public static double ReadDoubleLittleEndian(System.ReadOnlySpan<System.Byte> source) => throw null;
                public static System.Int16 ReadInt16BigEndian(System.ReadOnlySpan<System.Byte> source) => throw null;
                public static System.Int16 ReadInt16LittleEndian(System.ReadOnlySpan<System.Byte> source) => throw null;
                public static int ReadInt32BigEndian(System.ReadOnlySpan<System.Byte> source) => throw null;
                public static int ReadInt32LittleEndian(System.ReadOnlySpan<System.Byte> source) => throw null;
                public static System.Int64 ReadInt64BigEndian(System.ReadOnlySpan<System.Byte> source) => throw null;
                public static System.Int64 ReadInt64LittleEndian(System.ReadOnlySpan<System.Byte> source) => throw null;
                public static float ReadSingleBigEndian(System.ReadOnlySpan<System.Byte> source) => throw null;
                public static float ReadSingleLittleEndian(System.ReadOnlySpan<System.Byte> source) => throw null;
                public static System.UInt16 ReadUInt16BigEndian(System.ReadOnlySpan<System.Byte> source) => throw null;
                public static System.UInt16 ReadUInt16LittleEndian(System.ReadOnlySpan<System.Byte> source) => throw null;
                public static System.UInt32 ReadUInt32BigEndian(System.ReadOnlySpan<System.Byte> source) => throw null;
                public static System.UInt32 ReadUInt32LittleEndian(System.ReadOnlySpan<System.Byte> source) => throw null;
                public static System.UInt64 ReadUInt64BigEndian(System.ReadOnlySpan<System.Byte> source) => throw null;
                public static System.UInt64 ReadUInt64LittleEndian(System.ReadOnlySpan<System.Byte> source) => throw null;
                public static System.Byte ReverseEndianness(System.Byte value) => throw null;
                public static int ReverseEndianness(int value) => throw null;
                public static System.Int64 ReverseEndianness(System.Int64 value) => throw null;
                public static System.SByte ReverseEndianness(System.SByte value) => throw null;
                public static System.Int16 ReverseEndianness(System.Int16 value) => throw null;
                public static System.UInt32 ReverseEndianness(System.UInt32 value) => throw null;
                public static System.UInt64 ReverseEndianness(System.UInt64 value) => throw null;
                public static System.UInt16 ReverseEndianness(System.UInt16 value) => throw null;
                public static bool TryReadDoubleBigEndian(System.ReadOnlySpan<System.Byte> source, out double value) => throw null;
                public static bool TryReadDoubleLittleEndian(System.ReadOnlySpan<System.Byte> source, out double value) => throw null;
                public static bool TryReadInt16BigEndian(System.ReadOnlySpan<System.Byte> source, out System.Int16 value) => throw null;
                public static bool TryReadInt16LittleEndian(System.ReadOnlySpan<System.Byte> source, out System.Int16 value) => throw null;
                public static bool TryReadInt32BigEndian(System.ReadOnlySpan<System.Byte> source, out int value) => throw null;
                public static bool TryReadInt32LittleEndian(System.ReadOnlySpan<System.Byte> source, out int value) => throw null;
                public static bool TryReadInt64BigEndian(System.ReadOnlySpan<System.Byte> source, out System.Int64 value) => throw null;
                public static bool TryReadInt64LittleEndian(System.ReadOnlySpan<System.Byte> source, out System.Int64 value) => throw null;
                public static bool TryReadSingleBigEndian(System.ReadOnlySpan<System.Byte> source, out float value) => throw null;
                public static bool TryReadSingleLittleEndian(System.ReadOnlySpan<System.Byte> source, out float value) => throw null;
                public static bool TryReadUInt16BigEndian(System.ReadOnlySpan<System.Byte> source, out System.UInt16 value) => throw null;
                public static bool TryReadUInt16LittleEndian(System.ReadOnlySpan<System.Byte> source, out System.UInt16 value) => throw null;
                public static bool TryReadUInt32BigEndian(System.ReadOnlySpan<System.Byte> source, out System.UInt32 value) => throw null;
                public static bool TryReadUInt32LittleEndian(System.ReadOnlySpan<System.Byte> source, out System.UInt32 value) => throw null;
                public static bool TryReadUInt64BigEndian(System.ReadOnlySpan<System.Byte> source, out System.UInt64 value) => throw null;
                public static bool TryReadUInt64LittleEndian(System.ReadOnlySpan<System.Byte> source, out System.UInt64 value) => throw null;
                public static bool TryWriteDoubleBigEndian(System.Span<System.Byte> destination, double value) => throw null;
                public static bool TryWriteDoubleLittleEndian(System.Span<System.Byte> destination, double value) => throw null;
                public static bool TryWriteInt16BigEndian(System.Span<System.Byte> destination, System.Int16 value) => throw null;
                public static bool TryWriteInt16LittleEndian(System.Span<System.Byte> destination, System.Int16 value) => throw null;
                public static bool TryWriteInt32BigEndian(System.Span<System.Byte> destination, int value) => throw null;
                public static bool TryWriteInt32LittleEndian(System.Span<System.Byte> destination, int value) => throw null;
                public static bool TryWriteInt64BigEndian(System.Span<System.Byte> destination, System.Int64 value) => throw null;
                public static bool TryWriteInt64LittleEndian(System.Span<System.Byte> destination, System.Int64 value) => throw null;
                public static bool TryWriteSingleBigEndian(System.Span<System.Byte> destination, float value) => throw null;
                public static bool TryWriteSingleLittleEndian(System.Span<System.Byte> destination, float value) => throw null;
                public static bool TryWriteUInt16BigEndian(System.Span<System.Byte> destination, System.UInt16 value) => throw null;
                public static bool TryWriteUInt16LittleEndian(System.Span<System.Byte> destination, System.UInt16 value) => throw null;
                public static bool TryWriteUInt32BigEndian(System.Span<System.Byte> destination, System.UInt32 value) => throw null;
                public static bool TryWriteUInt32LittleEndian(System.Span<System.Byte> destination, System.UInt32 value) => throw null;
                public static bool TryWriteUInt64BigEndian(System.Span<System.Byte> destination, System.UInt64 value) => throw null;
                public static bool TryWriteUInt64LittleEndian(System.Span<System.Byte> destination, System.UInt64 value) => throw null;
                public static void WriteDoubleBigEndian(System.Span<System.Byte> destination, double value) => throw null;
                public static void WriteDoubleLittleEndian(System.Span<System.Byte> destination, double value) => throw null;
                public static void WriteInt16BigEndian(System.Span<System.Byte> destination, System.Int16 value) => throw null;
                public static void WriteInt16LittleEndian(System.Span<System.Byte> destination, System.Int16 value) => throw null;
                public static void WriteInt32BigEndian(System.Span<System.Byte> destination, int value) => throw null;
                public static void WriteInt32LittleEndian(System.Span<System.Byte> destination, int value) => throw null;
                public static void WriteInt64BigEndian(System.Span<System.Byte> destination, System.Int64 value) => throw null;
                public static void WriteInt64LittleEndian(System.Span<System.Byte> destination, System.Int64 value) => throw null;
                public static void WriteSingleBigEndian(System.Span<System.Byte> destination, float value) => throw null;
                public static void WriteSingleLittleEndian(System.Span<System.Byte> destination, float value) => throw null;
                public static void WriteUInt16BigEndian(System.Span<System.Byte> destination, System.UInt16 value) => throw null;
                public static void WriteUInt16LittleEndian(System.Span<System.Byte> destination, System.UInt16 value) => throw null;
                public static void WriteUInt32BigEndian(System.Span<System.Byte> destination, System.UInt32 value) => throw null;
                public static void WriteUInt32LittleEndian(System.Span<System.Byte> destination, System.UInt32 value) => throw null;
                public static void WriteUInt64BigEndian(System.Span<System.Byte> destination, System.UInt64 value) => throw null;
                public static void WriteUInt64LittleEndian(System.Span<System.Byte> destination, System.UInt64 value) => throw null;
            }

        }
        namespace Text
        {
            // Generated from `System.Buffers.Text.Base64` in `System.Memory, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public static class Base64
            {
                public static System.Buffers.OperationStatus DecodeFromUtf8(System.ReadOnlySpan<System.Byte> utf8, System.Span<System.Byte> bytes, out int bytesConsumed, out int bytesWritten, bool isFinalBlock = default(bool)) => throw null;
                public static System.Buffers.OperationStatus DecodeFromUtf8InPlace(System.Span<System.Byte> buffer, out int bytesWritten) => throw null;
                public static System.Buffers.OperationStatus EncodeToUtf8(System.ReadOnlySpan<System.Byte> bytes, System.Span<System.Byte> utf8, out int bytesConsumed, out int bytesWritten, bool isFinalBlock = default(bool)) => throw null;
                public static System.Buffers.OperationStatus EncodeToUtf8InPlace(System.Span<System.Byte> buffer, int dataLength, out int bytesWritten) => throw null;
                public static int GetMaxDecodedFromUtf8Length(int length) => throw null;
                public static int GetMaxEncodedToUtf8Length(int length) => throw null;
            }

            // Generated from `System.Buffers.Text.Utf8Formatter` in `System.Memory, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public static class Utf8Formatter
            {
                public static bool TryFormat(System.DateTime value, System.Span<System.Byte> destination, out int bytesWritten, System.Buffers.StandardFormat format = default(System.Buffers.StandardFormat)) => throw null;
                public static bool TryFormat(System.DateTimeOffset value, System.Span<System.Byte> destination, out int bytesWritten, System.Buffers.StandardFormat format = default(System.Buffers.StandardFormat)) => throw null;
                public static bool TryFormat(System.Guid value, System.Span<System.Byte> destination, out int bytesWritten, System.Buffers.StandardFormat format = default(System.Buffers.StandardFormat)) => throw null;
                public static bool TryFormat(System.TimeSpan value, System.Span<System.Byte> destination, out int bytesWritten, System.Buffers.StandardFormat format = default(System.Buffers.StandardFormat)) => throw null;
                public static bool TryFormat(bool value, System.Span<System.Byte> destination, out int bytesWritten, System.Buffers.StandardFormat format = default(System.Buffers.StandardFormat)) => throw null;
                public static bool TryFormat(System.Byte value, System.Span<System.Byte> destination, out int bytesWritten, System.Buffers.StandardFormat format = default(System.Buffers.StandardFormat)) => throw null;
                public static bool TryFormat(System.Decimal value, System.Span<System.Byte> destination, out int bytesWritten, System.Buffers.StandardFormat format = default(System.Buffers.StandardFormat)) => throw null;
                public static bool TryFormat(double value, System.Span<System.Byte> destination, out int bytesWritten, System.Buffers.StandardFormat format = default(System.Buffers.StandardFormat)) => throw null;
                public static bool TryFormat(float value, System.Span<System.Byte> destination, out int bytesWritten, System.Buffers.StandardFormat format = default(System.Buffers.StandardFormat)) => throw null;
                public static bool TryFormat(int value, System.Span<System.Byte> destination, out int bytesWritten, System.Buffers.StandardFormat format = default(System.Buffers.StandardFormat)) => throw null;
                public static bool TryFormat(System.Int64 value, System.Span<System.Byte> destination, out int bytesWritten, System.Buffers.StandardFormat format = default(System.Buffers.StandardFormat)) => throw null;
                public static bool TryFormat(System.SByte value, System.Span<System.Byte> destination, out int bytesWritten, System.Buffers.StandardFormat format = default(System.Buffers.StandardFormat)) => throw null;
                public static bool TryFormat(System.Int16 value, System.Span<System.Byte> destination, out int bytesWritten, System.Buffers.StandardFormat format = default(System.Buffers.StandardFormat)) => throw null;
                public static bool TryFormat(System.UInt32 value, System.Span<System.Byte> destination, out int bytesWritten, System.Buffers.StandardFormat format = default(System.Buffers.StandardFormat)) => throw null;
                public static bool TryFormat(System.UInt64 value, System.Span<System.Byte> destination, out int bytesWritten, System.Buffers.StandardFormat format = default(System.Buffers.StandardFormat)) => throw null;
                public static bool TryFormat(System.UInt16 value, System.Span<System.Byte> destination, out int bytesWritten, System.Buffers.StandardFormat format = default(System.Buffers.StandardFormat)) => throw null;
            }

            // Generated from `System.Buffers.Text.Utf8Parser` in `System.Memory, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public static class Utf8Parser
            {
                public static bool TryParse(System.ReadOnlySpan<System.Byte> source, out System.DateTime value, out int bytesConsumed, System.Char standardFormat = default(System.Char)) => throw null;
                public static bool TryParse(System.ReadOnlySpan<System.Byte> source, out System.DateTimeOffset value, out int bytesConsumed, System.Char standardFormat = default(System.Char)) => throw null;
                public static bool TryParse(System.ReadOnlySpan<System.Byte> source, out System.Guid value, out int bytesConsumed, System.Char standardFormat = default(System.Char)) => throw null;
                public static bool TryParse(System.ReadOnlySpan<System.Byte> source, out System.TimeSpan value, out int bytesConsumed, System.Char standardFormat = default(System.Char)) => throw null;
                public static bool TryParse(System.ReadOnlySpan<System.Byte> source, out bool value, out int bytesConsumed, System.Char standardFormat = default(System.Char)) => throw null;
                public static bool TryParse(System.ReadOnlySpan<System.Byte> source, out System.Byte value, out int bytesConsumed, System.Char standardFormat = default(System.Char)) => throw null;
                public static bool TryParse(System.ReadOnlySpan<System.Byte> source, out System.Decimal value, out int bytesConsumed, System.Char standardFormat = default(System.Char)) => throw null;
                public static bool TryParse(System.ReadOnlySpan<System.Byte> source, out double value, out int bytesConsumed, System.Char standardFormat = default(System.Char)) => throw null;
                public static bool TryParse(System.ReadOnlySpan<System.Byte> source, out float value, out int bytesConsumed, System.Char standardFormat = default(System.Char)) => throw null;
                public static bool TryParse(System.ReadOnlySpan<System.Byte> source, out int value, out int bytesConsumed, System.Char standardFormat = default(System.Char)) => throw null;
                public static bool TryParse(System.ReadOnlySpan<System.Byte> source, out System.Int64 value, out int bytesConsumed, System.Char standardFormat = default(System.Char)) => throw null;
                public static bool TryParse(System.ReadOnlySpan<System.Byte> source, out System.SByte value, out int bytesConsumed, System.Char standardFormat = default(System.Char)) => throw null;
                public static bool TryParse(System.ReadOnlySpan<System.Byte> source, out System.Int16 value, out int bytesConsumed, System.Char standardFormat = default(System.Char)) => throw null;
                public static bool TryParse(System.ReadOnlySpan<System.Byte> source, out System.UInt32 value, out int bytesConsumed, System.Char standardFormat = default(System.Char)) => throw null;
                public static bool TryParse(System.ReadOnlySpan<System.Byte> source, out System.UInt64 value, out int bytesConsumed, System.Char standardFormat = default(System.Char)) => throw null;
                public static bool TryParse(System.ReadOnlySpan<System.Byte> source, out System.UInt16 value, out int bytesConsumed, System.Char standardFormat = default(System.Char)) => throw null;
            }

        }
    }
    namespace Runtime
    {
        namespace InteropServices
        {
            // Generated from `System.Runtime.InteropServices.MemoryMarshal` in `System.Memory, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public static class MemoryMarshal
            {
                public static System.ReadOnlySpan<System.Byte> AsBytes<T>(System.ReadOnlySpan<T> span) where T : struct => throw null;
                public static System.Span<System.Byte> AsBytes<T>(System.Span<T> span) where T : struct => throw null;
                public static System.Memory<T> AsMemory<T>(System.ReadOnlyMemory<T> memory) => throw null;
                public static T AsRef<T>(System.ReadOnlySpan<System.Byte> span) where T : struct => throw null;
                public static T AsRef<T>(System.Span<System.Byte> span) where T : struct => throw null;
                public static System.ReadOnlySpan<TTo> Cast<TFrom, TTo>(System.ReadOnlySpan<TFrom> span) where TFrom : struct where TTo : struct => throw null;
                public static System.Span<TTo> Cast<TFrom, TTo>(System.Span<TFrom> span) where TFrom : struct where TTo : struct => throw null;
                public static System.Memory<T> CreateFromPinnedArray<T>(T[] array, int start, int length) => throw null;
                public static System.ReadOnlySpan<T> CreateReadOnlySpan<T>(ref T reference, int length) => throw null;
                public static System.Span<T> CreateSpan<T>(ref T reference, int length) => throw null;
                public static T GetArrayDataReference<T>(T[] array) => throw null;
                public static T GetReference<T>(System.ReadOnlySpan<T> span) => throw null;
                public static T GetReference<T>(System.Span<T> span) => throw null;
                public static T Read<T>(System.ReadOnlySpan<System.Byte> source) where T : struct => throw null;
                public static System.Collections.Generic.IEnumerable<T> ToEnumerable<T>(System.ReadOnlyMemory<T> memory) => throw null;
                public static bool TryGetArray<T>(System.ReadOnlyMemory<T> memory, out System.ArraySegment<T> segment) => throw null;
                public static bool TryGetMemoryManager<T, TManager>(System.ReadOnlyMemory<T> memory, out TManager manager) where TManager : System.Buffers.MemoryManager<T> => throw null;
                public static bool TryGetMemoryManager<T, TManager>(System.ReadOnlyMemory<T> memory, out TManager manager, out int start, out int length) where TManager : System.Buffers.MemoryManager<T> => throw null;
                public static bool TryGetString(System.ReadOnlyMemory<System.Char> memory, out string text, out int start, out int length) => throw null;
                public static bool TryRead<T>(System.ReadOnlySpan<System.Byte> source, out T value) where T : struct => throw null;
                public static bool TryWrite<T>(System.Span<System.Byte> destination, ref T value) where T : struct => throw null;
                public static void Write<T>(System.Span<System.Byte> destination, ref T value) where T : struct => throw null;
            }

            // Generated from `System.Runtime.InteropServices.SequenceMarshal` in `System.Memory, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public static class SequenceMarshal
            {
                public static bool TryGetArray<T>(System.Buffers.ReadOnlySequence<T> sequence, out System.ArraySegment<T> segment) => throw null;
                public static bool TryGetReadOnlyMemory<T>(System.Buffers.ReadOnlySequence<T> sequence, out System.ReadOnlyMemory<T> memory) => throw null;
                public static bool TryGetReadOnlySequenceSegment<T>(System.Buffers.ReadOnlySequence<T> sequence, out System.Buffers.ReadOnlySequenceSegment<T> startSegment, out int startIndex, out System.Buffers.ReadOnlySequenceSegment<T> endSegment, out int endIndex) => throw null;
                public static bool TryRead<T>(ref System.Buffers.SequenceReader<System.Byte> reader, out T value) where T : unmanaged => throw null;
            }

        }
    }
    namespace Text
    {
        // Generated from `System.Text.EncodingExtensions` in `System.Memory, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public static class EncodingExtensions
        {
            public static void Convert(this System.Text.Decoder decoder, System.Buffers.ReadOnlySequence<System.Byte> bytes, System.Buffers.IBufferWriter<System.Char> writer, bool flush, out System.Int64 charsUsed, out bool completed) => throw null;
            public static void Convert(this System.Text.Decoder decoder, System.ReadOnlySpan<System.Byte> bytes, System.Buffers.IBufferWriter<System.Char> writer, bool flush, out System.Int64 charsUsed, out bool completed) => throw null;
            public static void Convert(this System.Text.Encoder encoder, System.Buffers.ReadOnlySequence<System.Char> chars, System.Buffers.IBufferWriter<System.Byte> writer, bool flush, out System.Int64 bytesUsed, out bool completed) => throw null;
            public static void Convert(this System.Text.Encoder encoder, System.ReadOnlySpan<System.Char> chars, System.Buffers.IBufferWriter<System.Byte> writer, bool flush, out System.Int64 bytesUsed, out bool completed) => throw null;
            public static System.Byte[] GetBytes(this System.Text.Encoding encoding, System.Buffers.ReadOnlySequence<System.Char> chars) => throw null;
            public static System.Int64 GetBytes(this System.Text.Encoding encoding, System.Buffers.ReadOnlySequence<System.Char> chars, System.Buffers.IBufferWriter<System.Byte> writer) => throw null;
            public static int GetBytes(this System.Text.Encoding encoding, System.Buffers.ReadOnlySequence<System.Char> chars, System.Span<System.Byte> bytes) => throw null;
            public static System.Int64 GetBytes(this System.Text.Encoding encoding, System.ReadOnlySpan<System.Char> chars, System.Buffers.IBufferWriter<System.Byte> writer) => throw null;
            public static System.Int64 GetChars(this System.Text.Encoding encoding, System.Buffers.ReadOnlySequence<System.Byte> bytes, System.Buffers.IBufferWriter<System.Char> writer) => throw null;
            public static int GetChars(this System.Text.Encoding encoding, System.Buffers.ReadOnlySequence<System.Byte> bytes, System.Span<System.Char> chars) => throw null;
            public static System.Int64 GetChars(this System.Text.Encoding encoding, System.ReadOnlySpan<System.Byte> bytes, System.Buffers.IBufferWriter<System.Char> writer) => throw null;
            public static string GetString(this System.Text.Encoding encoding, System.Buffers.ReadOnlySequence<System.Byte> bytes) => throw null;
        }

        // Generated from `System.Text.SpanRuneEnumerator` in `System.Memory, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public struct SpanRuneEnumerator
        {
            public System.Text.Rune Current { get => throw null; }
            public System.Text.SpanRuneEnumerator GetEnumerator() => throw null;
            public bool MoveNext() => throw null;
            // Stub generator skipped constructor 
        }

    }
}
