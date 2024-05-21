// This file contains auto-generated code.
// Generated from `System.Text.Encoding.Extensions, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace Text
    {
        public class ASCIIEncoding : System.Text.Encoding
        {
            public ASCIIEncoding() => throw null;
            public override unsafe int GetByteCount(char* chars, int count) => throw null;
            public override int GetByteCount(char[] chars, int index, int count) => throw null;
            public override int GetByteCount(System.ReadOnlySpan<char> chars) => throw null;
            public override int GetByteCount(string chars) => throw null;
            public override unsafe int GetBytes(char* chars, int charCount, byte* bytes, int byteCount) => throw null;
            public override int GetBytes(char[] chars, int charIndex, int charCount, byte[] bytes, int byteIndex) => throw null;
            public override int GetBytes(System.ReadOnlySpan<char> chars, System.Span<byte> bytes) => throw null;
            public override int GetBytes(string chars, int charIndex, int charCount, byte[] bytes, int byteIndex) => throw null;
            public override unsafe int GetCharCount(byte* bytes, int count) => throw null;
            public override int GetCharCount(byte[] bytes, int index, int count) => throw null;
            public override int GetCharCount(System.ReadOnlySpan<byte> bytes) => throw null;
            public override unsafe int GetChars(byte* bytes, int byteCount, char* chars, int charCount) => throw null;
            public override int GetChars(byte[] bytes, int byteIndex, int byteCount, char[] chars, int charIndex) => throw null;
            public override int GetChars(System.ReadOnlySpan<byte> bytes, System.Span<char> chars) => throw null;
            public override System.Text.Decoder GetDecoder() => throw null;
            public override System.Text.Encoder GetEncoder() => throw null;
            public override int GetMaxByteCount(int charCount) => throw null;
            public override int GetMaxCharCount(int byteCount) => throw null;
            public override string GetString(byte[] bytes, int byteIndex, int byteCount) => throw null;
            public override bool IsSingleByte { get => throw null; }
            public override bool TryGetBytes(System.ReadOnlySpan<char> chars, System.Span<byte> bytes, out int bytesWritten) => throw null;
            public override bool TryGetChars(System.ReadOnlySpan<byte> bytes, System.Span<char> chars, out int charsWritten) => throw null;
        }
        public class UnicodeEncoding : System.Text.Encoding
        {
            public const int CharSize = 2;
            public UnicodeEncoding() => throw null;
            public UnicodeEncoding(bool bigEndian, bool byteOrderMark) => throw null;
            public UnicodeEncoding(bool bigEndian, bool byteOrderMark, bool throwOnInvalidBytes) => throw null;
            public override bool Equals(object value) => throw null;
            public override unsafe int GetByteCount(char* chars, int count) => throw null;
            public override int GetByteCount(char[] chars, int index, int count) => throw null;
            public override int GetByteCount(string s) => throw null;
            public override unsafe int GetBytes(char* chars, int charCount, byte* bytes, int byteCount) => throw null;
            public override int GetBytes(char[] chars, int charIndex, int charCount, byte[] bytes, int byteIndex) => throw null;
            public override int GetBytes(string s, int charIndex, int charCount, byte[] bytes, int byteIndex) => throw null;
            public override unsafe int GetCharCount(byte* bytes, int count) => throw null;
            public override int GetCharCount(byte[] bytes, int index, int count) => throw null;
            public override unsafe int GetChars(byte* bytes, int byteCount, char* chars, int charCount) => throw null;
            public override int GetChars(byte[] bytes, int byteIndex, int byteCount, char[] chars, int charIndex) => throw null;
            public override System.Text.Decoder GetDecoder() => throw null;
            public override System.Text.Encoder GetEncoder() => throw null;
            public override int GetHashCode() => throw null;
            public override int GetMaxByteCount(int charCount) => throw null;
            public override int GetMaxCharCount(int byteCount) => throw null;
            public override byte[] GetPreamble() => throw null;
            public override string GetString(byte[] bytes, int index, int count) => throw null;
            public override System.ReadOnlySpan<byte> Preamble { get => throw null; }
        }
        public sealed class UTF32Encoding : System.Text.Encoding
        {
            public UTF32Encoding() => throw null;
            public UTF32Encoding(bool bigEndian, bool byteOrderMark) => throw null;
            public UTF32Encoding(bool bigEndian, bool byteOrderMark, bool throwOnInvalidCharacters) => throw null;
            public override bool Equals(object value) => throw null;
            public override unsafe int GetByteCount(char* chars, int count) => throw null;
            public override int GetByteCount(char[] chars, int index, int count) => throw null;
            public override int GetByteCount(string s) => throw null;
            public override unsafe int GetBytes(char* chars, int charCount, byte* bytes, int byteCount) => throw null;
            public override int GetBytes(char[] chars, int charIndex, int charCount, byte[] bytes, int byteIndex) => throw null;
            public override int GetBytes(string s, int charIndex, int charCount, byte[] bytes, int byteIndex) => throw null;
            public override unsafe int GetCharCount(byte* bytes, int count) => throw null;
            public override int GetCharCount(byte[] bytes, int index, int count) => throw null;
            public override unsafe int GetChars(byte* bytes, int byteCount, char* chars, int charCount) => throw null;
            public override int GetChars(byte[] bytes, int byteIndex, int byteCount, char[] chars, int charIndex) => throw null;
            public override System.Text.Decoder GetDecoder() => throw null;
            public override System.Text.Encoder GetEncoder() => throw null;
            public override int GetHashCode() => throw null;
            public override int GetMaxByteCount(int charCount) => throw null;
            public override int GetMaxCharCount(int byteCount) => throw null;
            public override byte[] GetPreamble() => throw null;
            public override string GetString(byte[] bytes, int index, int count) => throw null;
            public override System.ReadOnlySpan<byte> Preamble { get => throw null; }
        }
        public class UTF7Encoding : System.Text.Encoding
        {
            public UTF7Encoding() => throw null;
            public UTF7Encoding(bool allowOptionals) => throw null;
            public override bool Equals(object value) => throw null;
            public override unsafe int GetByteCount(char* chars, int count) => throw null;
            public override int GetByteCount(char[] chars, int index, int count) => throw null;
            public override int GetByteCount(string s) => throw null;
            public override unsafe int GetBytes(char* chars, int charCount, byte* bytes, int byteCount) => throw null;
            public override int GetBytes(char[] chars, int charIndex, int charCount, byte[] bytes, int byteIndex) => throw null;
            public override int GetBytes(string s, int charIndex, int charCount, byte[] bytes, int byteIndex) => throw null;
            public override unsafe int GetCharCount(byte* bytes, int count) => throw null;
            public override int GetCharCount(byte[] bytes, int index, int count) => throw null;
            public override unsafe int GetChars(byte* bytes, int byteCount, char* chars, int charCount) => throw null;
            public override int GetChars(byte[] bytes, int byteIndex, int byteCount, char[] chars, int charIndex) => throw null;
            public override System.Text.Decoder GetDecoder() => throw null;
            public override System.Text.Encoder GetEncoder() => throw null;
            public override int GetHashCode() => throw null;
            public override int GetMaxByteCount(int charCount) => throw null;
            public override int GetMaxCharCount(int byteCount) => throw null;
            public override string GetString(byte[] bytes, int index, int count) => throw null;
        }
        public class UTF8Encoding : System.Text.Encoding
        {
            public UTF8Encoding() => throw null;
            public UTF8Encoding(bool encoderShouldEmitUTF8Identifier) => throw null;
            public UTF8Encoding(bool encoderShouldEmitUTF8Identifier, bool throwOnInvalidBytes) => throw null;
            public override bool Equals(object value) => throw null;
            public override unsafe int GetByteCount(char* chars, int count) => throw null;
            public override int GetByteCount(char[] chars, int index, int count) => throw null;
            public override int GetByteCount(System.ReadOnlySpan<char> chars) => throw null;
            public override int GetByteCount(string chars) => throw null;
            public override unsafe int GetBytes(char* chars, int charCount, byte* bytes, int byteCount) => throw null;
            public override int GetBytes(char[] chars, int charIndex, int charCount, byte[] bytes, int byteIndex) => throw null;
            public override int GetBytes(System.ReadOnlySpan<char> chars, System.Span<byte> bytes) => throw null;
            public override int GetBytes(string s, int charIndex, int charCount, byte[] bytes, int byteIndex) => throw null;
            public override unsafe int GetCharCount(byte* bytes, int count) => throw null;
            public override int GetCharCount(byte[] bytes, int index, int count) => throw null;
            public override int GetCharCount(System.ReadOnlySpan<byte> bytes) => throw null;
            public override unsafe int GetChars(byte* bytes, int byteCount, char* chars, int charCount) => throw null;
            public override int GetChars(byte[] bytes, int byteIndex, int byteCount, char[] chars, int charIndex) => throw null;
            public override int GetChars(System.ReadOnlySpan<byte> bytes, System.Span<char> chars) => throw null;
            public override System.Text.Decoder GetDecoder() => throw null;
            public override System.Text.Encoder GetEncoder() => throw null;
            public override int GetHashCode() => throw null;
            public override int GetMaxByteCount(int charCount) => throw null;
            public override int GetMaxCharCount(int byteCount) => throw null;
            public override byte[] GetPreamble() => throw null;
            public override string GetString(byte[] bytes, int index, int count) => throw null;
            public override System.ReadOnlySpan<byte> Preamble { get => throw null; }
            public override bool TryGetBytes(System.ReadOnlySpan<char> chars, System.Span<byte> bytes, out int bytesWritten) => throw null;
            public override bool TryGetChars(System.ReadOnlySpan<byte> bytes, System.Span<char> chars, out int charsWritten) => throw null;
        }
    }
}
