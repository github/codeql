// This file contains auto-generated code.
// Generated from `System.Formats.Asn1, Version=7.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`.

namespace System
{
    namespace Formats
    {
        namespace Asn1
        {
            public struct Asn1Tag : System.IEquatable<System.Formats.Asn1.Asn1Tag>
            {
                public static bool operator !=(System.Formats.Asn1.Asn1Tag left, System.Formats.Asn1.Asn1Tag right) => throw null;
                public static bool operator ==(System.Formats.Asn1.Asn1Tag left, System.Formats.Asn1.Asn1Tag right) => throw null;
                public System.Formats.Asn1.Asn1Tag AsConstructed() => throw null;
                public System.Formats.Asn1.Asn1Tag AsPrimitive() => throw null;
                // Stub generator skipped constructor 
                public Asn1Tag(System.Formats.Asn1.TagClass tagClass, int tagValue, bool isConstructed = default(bool)) => throw null;
                public Asn1Tag(System.Formats.Asn1.UniversalTagNumber universalTagNumber, bool isConstructed = default(bool)) => throw null;
                public static System.Formats.Asn1.Asn1Tag Boolean;
                public int CalculateEncodedSize() => throw null;
                public static System.Formats.Asn1.Asn1Tag ConstructedBitString;
                public static System.Formats.Asn1.Asn1Tag ConstructedOctetString;
                public static System.Formats.Asn1.Asn1Tag Decode(System.ReadOnlySpan<System.Byte> source, out int bytesConsumed) => throw null;
                public int Encode(System.Span<System.Byte> destination) => throw null;
                public static System.Formats.Asn1.Asn1Tag Enumerated;
                public bool Equals(System.Formats.Asn1.Asn1Tag other) => throw null;
                public override bool Equals(object obj) => throw null;
                public static System.Formats.Asn1.Asn1Tag GeneralizedTime;
                public override int GetHashCode() => throw null;
                public bool HasSameClassAndValue(System.Formats.Asn1.Asn1Tag other) => throw null;
                public static System.Formats.Asn1.Asn1Tag Integer;
                public bool IsConstructed { get => throw null; }
                public static System.Formats.Asn1.Asn1Tag Null;
                public static System.Formats.Asn1.Asn1Tag ObjectIdentifier;
                public static System.Formats.Asn1.Asn1Tag PrimitiveBitString;
                public static System.Formats.Asn1.Asn1Tag PrimitiveOctetString;
                public static System.Formats.Asn1.Asn1Tag Sequence;
                public static System.Formats.Asn1.Asn1Tag SetOf;
                public System.Formats.Asn1.TagClass TagClass { get => throw null; }
                public int TagValue { get => throw null; }
                public override string ToString() => throw null;
                public static bool TryDecode(System.ReadOnlySpan<System.Byte> source, out System.Formats.Asn1.Asn1Tag tag, out int bytesConsumed) => throw null;
                public bool TryEncode(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public static System.Formats.Asn1.Asn1Tag UtcTime;
            }

            public class AsnContentException : System.Exception
            {
                public AsnContentException() => throw null;
                protected AsnContentException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public AsnContentException(string message) => throw null;
                public AsnContentException(string message, System.Exception inner) => throw null;
            }

            public static class AsnDecoder
            {
                public static System.Byte[] ReadBitString(System.ReadOnlySpan<System.Byte> source, System.Formats.Asn1.AsnEncodingRules ruleSet, out int unusedBitCount, out int bytesConsumed, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public static bool ReadBoolean(System.ReadOnlySpan<System.Byte> source, System.Formats.Asn1.AsnEncodingRules ruleSet, out int bytesConsumed, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public static string ReadCharacterString(System.ReadOnlySpan<System.Byte> source, System.Formats.Asn1.AsnEncodingRules ruleSet, System.Formats.Asn1.UniversalTagNumber encodingType, out int bytesConsumed, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public static System.Formats.Asn1.Asn1Tag ReadEncodedValue(System.ReadOnlySpan<System.Byte> source, System.Formats.Asn1.AsnEncodingRules ruleSet, out int contentOffset, out int contentLength, out int bytesConsumed) => throw null;
                public static System.ReadOnlySpan<System.Byte> ReadEnumeratedBytes(System.ReadOnlySpan<System.Byte> source, System.Formats.Asn1.AsnEncodingRules ruleSet, out int bytesConsumed, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public static System.Enum ReadEnumeratedValue(System.ReadOnlySpan<System.Byte> source, System.Formats.Asn1.AsnEncodingRules ruleSet, System.Type enumType, out int bytesConsumed, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public static TEnum ReadEnumeratedValue<TEnum>(System.ReadOnlySpan<System.Byte> source, System.Formats.Asn1.AsnEncodingRules ruleSet, out int bytesConsumed, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) where TEnum : System.Enum => throw null;
                public static System.DateTimeOffset ReadGeneralizedTime(System.ReadOnlySpan<System.Byte> source, System.Formats.Asn1.AsnEncodingRules ruleSet, out int bytesConsumed, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public static System.Numerics.BigInteger ReadInteger(System.ReadOnlySpan<System.Byte> source, System.Formats.Asn1.AsnEncodingRules ruleSet, out int bytesConsumed, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public static System.ReadOnlySpan<System.Byte> ReadIntegerBytes(System.ReadOnlySpan<System.Byte> source, System.Formats.Asn1.AsnEncodingRules ruleSet, out int bytesConsumed, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public static System.Collections.BitArray ReadNamedBitList(System.ReadOnlySpan<System.Byte> source, System.Formats.Asn1.AsnEncodingRules ruleSet, out int bytesConsumed, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public static System.Enum ReadNamedBitListValue(System.ReadOnlySpan<System.Byte> source, System.Formats.Asn1.AsnEncodingRules ruleSet, System.Type flagsEnumType, out int bytesConsumed, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public static TFlagsEnum ReadNamedBitListValue<TFlagsEnum>(System.ReadOnlySpan<System.Byte> source, System.Formats.Asn1.AsnEncodingRules ruleSet, out int bytesConsumed, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) where TFlagsEnum : System.Enum => throw null;
                public static void ReadNull(System.ReadOnlySpan<System.Byte> source, System.Formats.Asn1.AsnEncodingRules ruleSet, out int bytesConsumed, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public static string ReadObjectIdentifier(System.ReadOnlySpan<System.Byte> source, System.Formats.Asn1.AsnEncodingRules ruleSet, out int bytesConsumed, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public static System.Byte[] ReadOctetString(System.ReadOnlySpan<System.Byte> source, System.Formats.Asn1.AsnEncodingRules ruleSet, out int bytesConsumed, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public static void ReadSequence(System.ReadOnlySpan<System.Byte> source, System.Formats.Asn1.AsnEncodingRules ruleSet, out int contentOffset, out int contentLength, out int bytesConsumed, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public static void ReadSetOf(System.ReadOnlySpan<System.Byte> source, System.Formats.Asn1.AsnEncodingRules ruleSet, out int contentOffset, out int contentLength, out int bytesConsumed, bool skipSortOrderValidation = default(bool), System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public static System.DateTimeOffset ReadUtcTime(System.ReadOnlySpan<System.Byte> source, System.Formats.Asn1.AsnEncodingRules ruleSet, out int bytesConsumed, int twoDigitYearMax = default(int), System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public static bool TryReadBitString(System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination, System.Formats.Asn1.AsnEncodingRules ruleSet, out int unusedBitCount, out int bytesConsumed, out int bytesWritten, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public static bool TryReadCharacterString(System.ReadOnlySpan<System.Byte> source, System.Span<System.Char> destination, System.Formats.Asn1.AsnEncodingRules ruleSet, System.Formats.Asn1.UniversalTagNumber encodingType, out int bytesConsumed, out int charsWritten, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public static bool TryReadCharacterStringBytes(System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination, System.Formats.Asn1.AsnEncodingRules ruleSet, System.Formats.Asn1.Asn1Tag expectedTag, out int bytesConsumed, out int bytesWritten) => throw null;
                public static bool TryReadEncodedValue(System.ReadOnlySpan<System.Byte> source, System.Formats.Asn1.AsnEncodingRules ruleSet, out System.Formats.Asn1.Asn1Tag tag, out int contentOffset, out int contentLength, out int bytesConsumed) => throw null;
                public static bool TryReadInt32(System.ReadOnlySpan<System.Byte> source, System.Formats.Asn1.AsnEncodingRules ruleSet, out int value, out int bytesConsumed, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public static bool TryReadInt64(System.ReadOnlySpan<System.Byte> source, System.Formats.Asn1.AsnEncodingRules ruleSet, out System.Int64 value, out int bytesConsumed, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public static bool TryReadOctetString(System.ReadOnlySpan<System.Byte> source, System.Span<System.Byte> destination, System.Formats.Asn1.AsnEncodingRules ruleSet, out int bytesConsumed, out int bytesWritten, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public static bool TryReadPrimitiveBitString(System.ReadOnlySpan<System.Byte> source, System.Formats.Asn1.AsnEncodingRules ruleSet, out int unusedBitCount, out System.ReadOnlySpan<System.Byte> value, out int bytesConsumed, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public static bool TryReadPrimitiveCharacterStringBytes(System.ReadOnlySpan<System.Byte> source, System.Formats.Asn1.AsnEncodingRules ruleSet, System.Formats.Asn1.Asn1Tag expectedTag, out System.ReadOnlySpan<System.Byte> value, out int bytesConsumed) => throw null;
                public static bool TryReadPrimitiveOctetString(System.ReadOnlySpan<System.Byte> source, System.Formats.Asn1.AsnEncodingRules ruleSet, out System.ReadOnlySpan<System.Byte> value, out int bytesConsumed, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public static bool TryReadUInt32(System.ReadOnlySpan<System.Byte> source, System.Formats.Asn1.AsnEncodingRules ruleSet, out System.UInt32 value, out int bytesConsumed, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public static bool TryReadUInt64(System.ReadOnlySpan<System.Byte> source, System.Formats.Asn1.AsnEncodingRules ruleSet, out System.UInt64 value, out int bytesConsumed, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
            }

            public enum AsnEncodingRules : int
            {
                BER = 0,
                CER = 1,
                DER = 2,
            }

            public class AsnReader
            {
                public AsnReader(System.ReadOnlyMemory<System.Byte> data, System.Formats.Asn1.AsnEncodingRules ruleSet, System.Formats.Asn1.AsnReaderOptions options = default(System.Formats.Asn1.AsnReaderOptions)) => throw null;
                public bool HasData { get => throw null; }
                public System.ReadOnlyMemory<System.Byte> PeekContentBytes() => throw null;
                public System.ReadOnlyMemory<System.Byte> PeekEncodedValue() => throw null;
                public System.Formats.Asn1.Asn1Tag PeekTag() => throw null;
                public System.Byte[] ReadBitString(out int unusedBitCount, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public bool ReadBoolean(System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public string ReadCharacterString(System.Formats.Asn1.UniversalTagNumber encodingType, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public System.ReadOnlyMemory<System.Byte> ReadEncodedValue() => throw null;
                public System.ReadOnlyMemory<System.Byte> ReadEnumeratedBytes(System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public System.Enum ReadEnumeratedValue(System.Type enumType, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public TEnum ReadEnumeratedValue<TEnum>(System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) where TEnum : System.Enum => throw null;
                public System.DateTimeOffset ReadGeneralizedTime(System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public System.Numerics.BigInteger ReadInteger(System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public System.ReadOnlyMemory<System.Byte> ReadIntegerBytes(System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public System.Collections.BitArray ReadNamedBitList(System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public System.Enum ReadNamedBitListValue(System.Type flagsEnumType, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public TFlagsEnum ReadNamedBitListValue<TFlagsEnum>(System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) where TFlagsEnum : System.Enum => throw null;
                public void ReadNull(System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public string ReadObjectIdentifier(System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public System.Byte[] ReadOctetString(System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public System.Formats.Asn1.AsnReader ReadSequence(System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public System.Formats.Asn1.AsnReader ReadSetOf(System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public System.Formats.Asn1.AsnReader ReadSetOf(bool skipSortOrderValidation, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public System.DateTimeOffset ReadUtcTime(System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public System.DateTimeOffset ReadUtcTime(int twoDigitYearMax, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public System.Formats.Asn1.AsnEncodingRules RuleSet { get => throw null; }
                public void ThrowIfNotEmpty() => throw null;
                public bool TryReadBitString(System.Span<System.Byte> destination, out int unusedBitCount, out int bytesWritten, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public bool TryReadCharacterString(System.Span<System.Char> destination, System.Formats.Asn1.UniversalTagNumber encodingType, out int charsWritten, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public bool TryReadCharacterStringBytes(System.Span<System.Byte> destination, System.Formats.Asn1.Asn1Tag expectedTag, out int bytesWritten) => throw null;
                public bool TryReadInt32(out int value, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public bool TryReadInt64(out System.Int64 value, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public bool TryReadOctetString(System.Span<System.Byte> destination, out int bytesWritten, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public bool TryReadPrimitiveBitString(out int unusedBitCount, out System.ReadOnlyMemory<System.Byte> value, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public bool TryReadPrimitiveCharacterStringBytes(System.Formats.Asn1.Asn1Tag expectedTag, out System.ReadOnlyMemory<System.Byte> contents) => throw null;
                public bool TryReadPrimitiveOctetString(out System.ReadOnlyMemory<System.Byte> contents, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public bool TryReadUInt32(out System.UInt32 value, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public bool TryReadUInt64(out System.UInt64 value, System.Formats.Asn1.Asn1Tag? expectedTag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
            }

            public struct AsnReaderOptions
            {
                // Stub generator skipped constructor 
                public bool SkipSetSortOrderVerification { get => throw null; set => throw null; }
                public int UtcTimeTwoDigitYearMax { get => throw null; set => throw null; }
            }

            public class AsnWriter
            {
                public struct Scope : System.IDisposable
                {
                    public void Dispose() => throw null;
                    // Stub generator skipped constructor 
                }


                public AsnWriter(System.Formats.Asn1.AsnEncodingRules ruleSet) => throw null;
                public AsnWriter(System.Formats.Asn1.AsnEncodingRules ruleSet, int initialCapacity) => throw null;
                public void CopyTo(System.Formats.Asn1.AsnWriter destination) => throw null;
                public System.Byte[] Encode() => throw null;
                public int Encode(System.Span<System.Byte> destination) => throw null;
                public bool EncodedValueEquals(System.Formats.Asn1.AsnWriter other) => throw null;
                public bool EncodedValueEquals(System.ReadOnlySpan<System.Byte> other) => throw null;
                public int GetEncodedLength() => throw null;
                public void PopOctetString(System.Formats.Asn1.Asn1Tag? tag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public void PopSequence(System.Formats.Asn1.Asn1Tag? tag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public void PopSetOf(System.Formats.Asn1.Asn1Tag? tag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public System.Formats.Asn1.AsnWriter.Scope PushOctetString(System.Formats.Asn1.Asn1Tag? tag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public System.Formats.Asn1.AsnWriter.Scope PushSequence(System.Formats.Asn1.Asn1Tag? tag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public System.Formats.Asn1.AsnWriter.Scope PushSetOf(System.Formats.Asn1.Asn1Tag? tag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public void Reset() => throw null;
                public System.Formats.Asn1.AsnEncodingRules RuleSet { get => throw null; }
                public bool TryEncode(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
                public void WriteBitString(System.ReadOnlySpan<System.Byte> value, int unusedBitCount = default(int), System.Formats.Asn1.Asn1Tag? tag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public void WriteBoolean(bool value, System.Formats.Asn1.Asn1Tag? tag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public void WriteCharacterString(System.Formats.Asn1.UniversalTagNumber encodingType, System.ReadOnlySpan<System.Char> str, System.Formats.Asn1.Asn1Tag? tag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public void WriteCharacterString(System.Formats.Asn1.UniversalTagNumber encodingType, string value, System.Formats.Asn1.Asn1Tag? tag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public void WriteEncodedValue(System.ReadOnlySpan<System.Byte> value) => throw null;
                public void WriteEnumeratedValue(System.Enum value, System.Formats.Asn1.Asn1Tag? tag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public void WriteEnumeratedValue<TEnum>(TEnum value, System.Formats.Asn1.Asn1Tag? tag = default(System.Formats.Asn1.Asn1Tag?)) where TEnum : System.Enum => throw null;
                public void WriteGeneralizedTime(System.DateTimeOffset value, bool omitFractionalSeconds = default(bool), System.Formats.Asn1.Asn1Tag? tag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public void WriteInteger(System.Numerics.BigInteger value, System.Formats.Asn1.Asn1Tag? tag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public void WriteInteger(System.ReadOnlySpan<System.Byte> value, System.Formats.Asn1.Asn1Tag? tag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public void WriteInteger(System.Int64 value, System.Formats.Asn1.Asn1Tag? tag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public void WriteInteger(System.UInt64 value, System.Formats.Asn1.Asn1Tag? tag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public void WriteIntegerUnsigned(System.ReadOnlySpan<System.Byte> value, System.Formats.Asn1.Asn1Tag? tag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public void WriteNamedBitList(System.Collections.BitArray value, System.Formats.Asn1.Asn1Tag? tag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public void WriteNamedBitList(System.Enum value, System.Formats.Asn1.Asn1Tag? tag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public void WriteNamedBitList<TEnum>(TEnum value, System.Formats.Asn1.Asn1Tag? tag = default(System.Formats.Asn1.Asn1Tag?)) where TEnum : System.Enum => throw null;
                public void WriteNull(System.Formats.Asn1.Asn1Tag? tag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public void WriteObjectIdentifier(System.ReadOnlySpan<System.Char> oidValue, System.Formats.Asn1.Asn1Tag? tag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public void WriteObjectIdentifier(string oidValue, System.Formats.Asn1.Asn1Tag? tag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public void WriteOctetString(System.ReadOnlySpan<System.Byte> value, System.Formats.Asn1.Asn1Tag? tag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public void WriteUtcTime(System.DateTimeOffset value, System.Formats.Asn1.Asn1Tag? tag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
                public void WriteUtcTime(System.DateTimeOffset value, int twoDigitYearMax, System.Formats.Asn1.Asn1Tag? tag = default(System.Formats.Asn1.Asn1Tag?)) => throw null;
            }

            public enum TagClass : int
            {
                Application = 64,
                ContextSpecific = 128,
                Private = 192,
                Universal = 0,
            }

            public enum UniversalTagNumber : int
            {
                BMPString = 30,
                BitString = 3,
                Boolean = 1,
                Date = 31,
                DateTime = 33,
                Duration = 34,
                Embedded = 11,
                EndOfContents = 0,
                Enumerated = 10,
                External = 8,
                GeneralString = 27,
                GeneralizedTime = 24,
                GraphicString = 25,
                IA5String = 22,
                ISO646String = 26,
                InstanceOf = 8,
                Integer = 2,
                Null = 5,
                NumericString = 18,
                ObjectDescriptor = 7,
                ObjectIdentifier = 6,
                ObjectIdentifierIRI = 35,
                OctetString = 4,
                PrintableString = 19,
                Real = 9,
                RelativeObjectIdentifier = 13,
                RelativeObjectIdentifierIRI = 36,
                Sequence = 16,
                SequenceOf = 16,
                Set = 17,
                SetOf = 17,
                T61String = 20,
                TeletexString = 20,
                Time = 14,
                TimeOfDay = 32,
                UTF8String = 12,
                UniversalString = 28,
                UnrestrictedCharacterString = 29,
                UtcTime = 23,
                VideotexString = 21,
                VisibleString = 26,
            }

        }
    }
}
