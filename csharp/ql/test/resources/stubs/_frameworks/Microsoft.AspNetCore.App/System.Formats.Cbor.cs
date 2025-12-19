// This file contains auto-generated code.
// Generated from `System.Formats.Cbor, Version=10.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`.
namespace System
{
    namespace Formats
    {
        namespace Cbor
        {
            public enum CborConformanceMode
            {
                Lax = 0,
                Strict = 1,
                Canonical = 2,
                Ctap2Canonical = 3,
            }
            public class CborContentException : System.Exception
            {
                protected CborContentException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public CborContentException(string message) => throw null;
                public CborContentException(string message, System.Exception inner) => throw null;
            }
            public class CborReader
            {
                public bool AllowMultipleRootLevelValues { get => throw null; }
                public int BytesRemaining { get => throw null; }
                public System.Formats.Cbor.CborConformanceMode ConformanceMode { get => throw null; }
                public CborReader(System.ReadOnlyMemory<byte> data, System.Formats.Cbor.CborConformanceMode conformanceMode = default(System.Formats.Cbor.CborConformanceMode), bool allowMultipleRootLevelValues = default(bool)) => throw null;
                public int CurrentDepth { get => throw null; }
                public System.Formats.Cbor.CborReaderState PeekState() => throw null;
                public System.Formats.Cbor.CborTag PeekTag() => throw null;
                public System.Numerics.BigInteger ReadBigInteger() => throw null;
                public bool ReadBoolean() => throw null;
                public byte[] ReadByteString() => throw null;
                public ulong ReadCborNegativeIntegerRepresentation() => throw null;
                public System.DateTimeOffset ReadDateTimeOffset() => throw null;
                public decimal ReadDecimal() => throw null;
                public System.ReadOnlyMemory<byte> ReadDefiniteLengthByteString() => throw null;
                public System.ReadOnlyMemory<byte> ReadDefiniteLengthTextStringBytes() => throw null;
                public double ReadDouble() => throw null;
                public System.ReadOnlyMemory<byte> ReadEncodedValue(bool disableConformanceModeChecks = default(bool)) => throw null;
                public void ReadEndArray() => throw null;
                public void ReadEndIndefiniteLengthByteString() => throw null;
                public void ReadEndIndefiniteLengthTextString() => throw null;
                public void ReadEndMap() => throw null;
                public System.Half ReadHalf() => throw null;
                public int ReadInt32() => throw null;
                public long ReadInt64() => throw null;
                public void ReadNull() => throw null;
                public System.Formats.Cbor.CborSimpleValue ReadSimpleValue() => throw null;
                public float ReadSingle() => throw null;
                public int? ReadStartArray() => throw null;
                public void ReadStartIndefiniteLengthByteString() => throw null;
                public void ReadStartIndefiniteLengthTextString() => throw null;
                public int? ReadStartMap() => throw null;
                public System.Formats.Cbor.CborTag ReadTag() => throw null;
                public string ReadTextString() => throw null;
                public uint ReadUInt32() => throw null;
                public ulong ReadUInt64() => throw null;
                public System.DateTimeOffset ReadUnixTimeSeconds() => throw null;
                public void Reset(System.ReadOnlyMemory<byte> data) => throw null;
                public void SkipToParent(bool disableConformanceModeChecks = default(bool)) => throw null;
                public void SkipValue(bool disableConformanceModeChecks = default(bool)) => throw null;
                public bool TryReadByteString(System.Span<byte> destination, out int bytesWritten) => throw null;
                public bool TryReadTextString(System.Span<char> destination, out int charsWritten) => throw null;
            }
            public enum CborReaderState
            {
                Undefined = 0,
                UnsignedInteger = 1,
                NegativeInteger = 2,
                ByteString = 3,
                StartIndefiniteLengthByteString = 4,
                EndIndefiniteLengthByteString = 5,
                TextString = 6,
                StartIndefiniteLengthTextString = 7,
                EndIndefiniteLengthTextString = 8,
                StartArray = 9,
                EndArray = 10,
                StartMap = 11,
                EndMap = 12,
                Tag = 13,
                SimpleValue = 14,
                HalfPrecisionFloat = 15,
                SinglePrecisionFloat = 16,
                DoublePrecisionFloat = 17,
                Null = 18,
                Boolean = 19,
                Finished = 20,
            }
            public enum CborSimpleValue : byte
            {
                False = 20,
                True = 21,
                Null = 22,
                Undefined = 23,
            }
            public enum CborTag : ulong
            {
                DateTimeString = 0,
                UnixTimeSeconds = 1,
                UnsignedBigNum = 2,
                NegativeBigNum = 3,
                DecimalFraction = 4,
                BigFloat = 5,
                Base64UrlLaterEncoding = 21,
                Base64StringLaterEncoding = 22,
                Base16StringLaterEncoding = 23,
                EncodedCborDataItem = 24,
                Uri = 32,
                Base64Url = 33,
                Base64 = 34,
                Regex = 35,
                MimeMessage = 36,
                SelfDescribeCbor = 55799,
            }
            public class CborWriter
            {
                public bool AllowMultipleRootLevelValues { get => throw null; }
                public int BytesWritten { get => throw null; }
                public System.Formats.Cbor.CborConformanceMode ConformanceMode { get => throw null; }
                public bool ConvertIndefiniteLengthEncodings { get => throw null; }
                public CborWriter(System.Formats.Cbor.CborConformanceMode conformanceMode, bool convertIndefiniteLengthEncodings, bool allowMultipleRootLevelValues) => throw null;
                public CborWriter(System.Formats.Cbor.CborConformanceMode conformanceMode = default(System.Formats.Cbor.CborConformanceMode), bool convertIndefiniteLengthEncodings = default(bool), bool allowMultipleRootLevelValues = default(bool), int initialCapacity = default(int)) => throw null;
                public int CurrentDepth { get => throw null; }
                public byte[] Encode() => throw null;
                public int Encode(System.Span<byte> destination) => throw null;
                public bool IsWriteCompleted { get => throw null; }
                public void Reset() => throw null;
                public bool TryEncode(System.Span<byte> destination, out int bytesWritten) => throw null;
                public void WriteBigInteger(System.Numerics.BigInteger value) => throw null;
                public void WriteBoolean(bool value) => throw null;
                public void WriteByteString(byte[] value) => throw null;
                public void WriteByteString(System.ReadOnlySpan<byte> value) => throw null;
                public void WriteCborNegativeIntegerRepresentation(ulong value) => throw null;
                public void WriteDateTimeOffset(System.DateTimeOffset value) => throw null;
                public void WriteDecimal(decimal value) => throw null;
                public void WriteDouble(double value) => throw null;
                public void WriteEncodedValue(System.ReadOnlySpan<byte> encodedValue) => throw null;
                public void WriteEndArray() => throw null;
                public void WriteEndIndefiniteLengthByteString() => throw null;
                public void WriteEndIndefiniteLengthTextString() => throw null;
                public void WriteEndMap() => throw null;
                public void WriteHalf(System.Half value) => throw null;
                public void WriteInt32(int value) => throw null;
                public void WriteInt64(long value) => throw null;
                public void WriteNull() => throw null;
                public void WriteSimpleValue(System.Formats.Cbor.CborSimpleValue value) => throw null;
                public void WriteSingle(float value) => throw null;
                public void WriteStartArray(int? definiteLength) => throw null;
                public void WriteStartIndefiniteLengthByteString() => throw null;
                public void WriteStartIndefiniteLengthTextString() => throw null;
                public void WriteStartMap(int? definiteLength) => throw null;
                public void WriteTag(System.Formats.Cbor.CborTag tag) => throw null;
                public void WriteTextString(System.ReadOnlySpan<char> value) => throw null;
                public void WriteTextString(string value) => throw null;
                public void WriteUInt32(uint value) => throw null;
                public void WriteUInt64(ulong value) => throw null;
                public void WriteUnixTimeSeconds(double seconds) => throw null;
                public void WriteUnixTimeSeconds(long seconds) => throw null;
            }
        }
    }
}
