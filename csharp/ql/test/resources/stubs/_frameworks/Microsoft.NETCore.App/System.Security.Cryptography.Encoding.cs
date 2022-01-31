// This file contains auto-generated code.

namespace System
{
    namespace Security
    {
        namespace Cryptography
        {
            // Generated from `System.Security.Cryptography.AsnEncodedData` in `System.Security.Cryptography.Encoding, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class AsnEncodedData
            {
                protected AsnEncodedData() => throw null;
                public AsnEncodedData(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                public AsnEncodedData(System.Byte[] rawData) => throw null;
                public AsnEncodedData(System.Security.Cryptography.Oid oid, System.Byte[] rawData) => throw null;
                public AsnEncodedData(System.Security.Cryptography.Oid oid, System.ReadOnlySpan<System.Byte> rawData) => throw null;
                public AsnEncodedData(System.ReadOnlySpan<System.Byte> rawData) => throw null;
                public AsnEncodedData(string oid, System.Byte[] rawData) => throw null;
                public AsnEncodedData(string oid, System.ReadOnlySpan<System.Byte> rawData) => throw null;
                public virtual void CopyFrom(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                public virtual string Format(bool multiLine) => throw null;
                public System.Security.Cryptography.Oid Oid { get => throw null; set => throw null; }
                public System.Byte[] RawData { get => throw null; set => throw null; }
            }

            // Generated from `System.Security.Cryptography.AsnEncodedDataCollection` in `System.Security.Cryptography.Encoding, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class AsnEncodedDataCollection : System.Collections.ICollection, System.Collections.IEnumerable
            {
                public int Add(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                public AsnEncodedDataCollection() => throw null;
                public AsnEncodedDataCollection(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                public void CopyTo(System.Security.Cryptography.AsnEncodedData[] array, int index) => throw null;
                public int Count { get => throw null; }
                public System.Security.Cryptography.AsnEncodedDataEnumerator GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public bool IsSynchronized { get => throw null; }
                public System.Security.Cryptography.AsnEncodedData this[int index] { get => throw null; }
                public void Remove(System.Security.Cryptography.AsnEncodedData asnEncodedData) => throw null;
                public object SyncRoot { get => throw null; }
            }

            // Generated from `System.Security.Cryptography.AsnEncodedDataEnumerator` in `System.Security.Cryptography.Encoding, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class AsnEncodedDataEnumerator : System.Collections.IEnumerator
            {
                public System.Security.Cryptography.AsnEncodedData Current { get => throw null; }
                object System.Collections.IEnumerator.Current { get => throw null; }
                public bool MoveNext() => throw null;
                public void Reset() => throw null;
            }

            // Generated from `System.Security.Cryptography.FromBase64Transform` in `System.Security.Cryptography.Encoding, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class FromBase64Transform : System.IDisposable, System.Security.Cryptography.ICryptoTransform
            {
                public virtual bool CanReuseTransform { get => throw null; }
                public bool CanTransformMultipleBlocks { get => throw null; }
                public void Clear() => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public FromBase64Transform() => throw null;
                public FromBase64Transform(System.Security.Cryptography.FromBase64TransformMode whitespaces) => throw null;
                public int InputBlockSize { get => throw null; }
                public int OutputBlockSize { get => throw null; }
                public int TransformBlock(System.Byte[] inputBuffer, int inputOffset, int inputCount, System.Byte[] outputBuffer, int outputOffset) => throw null;
                public System.Byte[] TransformFinalBlock(System.Byte[] inputBuffer, int inputOffset, int inputCount) => throw null;
                // ERR: Stub generator didn't handle member: ~FromBase64Transform
            }

            // Generated from `System.Security.Cryptography.FromBase64TransformMode` in `System.Security.Cryptography.Encoding, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum FromBase64TransformMode
            {
                DoNotIgnoreWhiteSpaces,
                IgnoreWhiteSpaces,
            }

            // Generated from `System.Security.Cryptography.Oid` in `System.Security.Cryptography.Encoding, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class Oid
            {
                public string FriendlyName { get => throw null; set => throw null; }
                public static System.Security.Cryptography.Oid FromFriendlyName(string friendlyName, System.Security.Cryptography.OidGroup group) => throw null;
                public static System.Security.Cryptography.Oid FromOidValue(string oidValue, System.Security.Cryptography.OidGroup group) => throw null;
                public Oid() => throw null;
                public Oid(System.Security.Cryptography.Oid oid) => throw null;
                public Oid(string oid) => throw null;
                public Oid(string value, string friendlyName) => throw null;
                public string Value { get => throw null; set => throw null; }
            }

            // Generated from `System.Security.Cryptography.OidCollection` in `System.Security.Cryptography.Encoding, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class OidCollection : System.Collections.ICollection, System.Collections.IEnumerable
            {
                public int Add(System.Security.Cryptography.Oid oid) => throw null;
                void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                public void CopyTo(System.Security.Cryptography.Oid[] array, int index) => throw null;
                public int Count { get => throw null; }
                public System.Security.Cryptography.OidEnumerator GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public bool IsSynchronized { get => throw null; }
                public System.Security.Cryptography.Oid this[int index] { get => throw null; }
                public System.Security.Cryptography.Oid this[string oid] { get => throw null; }
                public OidCollection() => throw null;
                public object SyncRoot { get => throw null; }
            }

            // Generated from `System.Security.Cryptography.OidEnumerator` in `System.Security.Cryptography.Encoding, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class OidEnumerator : System.Collections.IEnumerator
            {
                public System.Security.Cryptography.Oid Current { get => throw null; }
                object System.Collections.IEnumerator.Current { get => throw null; }
                public bool MoveNext() => throw null;
                public void Reset() => throw null;
            }

            // Generated from `System.Security.Cryptography.OidGroup` in `System.Security.Cryptography.Encoding, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum OidGroup
            {
                All,
                Attribute,
                EncryptionAlgorithm,
                EnhancedKeyUsage,
                ExtensionOrAttribute,
                HashAlgorithm,
                KeyDerivationFunction,
                Policy,
                PublicKeyAlgorithm,
                SignatureAlgorithm,
                Template,
            }

            // Generated from `System.Security.Cryptography.PemEncoding` in `System.Security.Cryptography.Encoding, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class PemEncoding
            {
                public static System.Security.Cryptography.PemFields Find(System.ReadOnlySpan<System.Char> pemData) => throw null;
                public static int GetEncodedSize(int labelLength, int dataLength) => throw null;
                public static bool TryFind(System.ReadOnlySpan<System.Char> pemData, out System.Security.Cryptography.PemFields fields) => throw null;
                public static bool TryWrite(System.ReadOnlySpan<System.Char> label, System.ReadOnlySpan<System.Byte> data, System.Span<System.Char> destination, out int charsWritten) => throw null;
                public static System.Char[] Write(System.ReadOnlySpan<System.Char> label, System.ReadOnlySpan<System.Byte> data) => throw null;
            }

            // Generated from `System.Security.Cryptography.PemFields` in `System.Security.Cryptography.Encoding, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct PemFields
            {
                public System.Range Base64Data { get => throw null; }
                public int DecodedDataLength { get => throw null; }
                public System.Range Label { get => throw null; }
                public System.Range Location { get => throw null; }
                // Stub generator skipped constructor 
            }

            // Generated from `System.Security.Cryptography.ToBase64Transform` in `System.Security.Cryptography.Encoding, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ToBase64Transform : System.IDisposable, System.Security.Cryptography.ICryptoTransform
            {
                public virtual bool CanReuseTransform { get => throw null; }
                public bool CanTransformMultipleBlocks { get => throw null; }
                public void Clear() => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public int InputBlockSize { get => throw null; }
                public int OutputBlockSize { get => throw null; }
                public ToBase64Transform() => throw null;
                public int TransformBlock(System.Byte[] inputBuffer, int inputOffset, int inputCount, System.Byte[] outputBuffer, int outputOffset) => throw null;
                public System.Byte[] TransformFinalBlock(System.Byte[] inputBuffer, int inputOffset, int inputCount) => throw null;
                // ERR: Stub generator didn't handle member: ~ToBase64Transform
            }

        }
    }
}
