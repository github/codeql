// This file contains auto-generated code.
// Generated from `System.Net.WebHeaderCollection, Version=7.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.

namespace System
{
    namespace Net
    {
        public enum HttpRequestHeader : int
        {
            Accept = 20,
            AcceptCharset = 21,
            AcceptEncoding = 22,
            AcceptLanguage = 23,
            Allow = 10,
            Authorization = 24,
            CacheControl = 0,
            Connection = 1,
            ContentEncoding = 13,
            ContentLanguage = 14,
            ContentLength = 11,
            ContentLocation = 15,
            ContentMd5 = 16,
            ContentRange = 17,
            ContentType = 12,
            Cookie = 25,
            Date = 2,
            Expect = 26,
            Expires = 18,
            From = 27,
            Host = 28,
            IfMatch = 29,
            IfModifiedSince = 30,
            IfNoneMatch = 31,
            IfRange = 32,
            IfUnmodifiedSince = 33,
            KeepAlive = 3,
            LastModified = 19,
            MaxForwards = 34,
            Pragma = 4,
            ProxyAuthorization = 35,
            Range = 37,
            Referer = 36,
            Te = 38,
            Trailer = 5,
            TransferEncoding = 6,
            Translate = 39,
            Upgrade = 7,
            UserAgent = 40,
            Via = 8,
            Warning = 9,
        }

        public enum HttpResponseHeader : int
        {
            AcceptRanges = 20,
            Age = 21,
            Allow = 10,
            CacheControl = 0,
            Connection = 1,
            ContentEncoding = 13,
            ContentLanguage = 14,
            ContentLength = 11,
            ContentLocation = 15,
            ContentMd5 = 16,
            ContentRange = 17,
            ContentType = 12,
            Date = 2,
            ETag = 22,
            Expires = 18,
            KeepAlive = 3,
            LastModified = 19,
            Location = 23,
            Pragma = 4,
            ProxyAuthenticate = 24,
            RetryAfter = 25,
            Server = 26,
            SetCookie = 27,
            Trailer = 5,
            TransferEncoding = 6,
            Upgrade = 7,
            Vary = 28,
            Via = 8,
            Warning = 9,
            WwwAuthenticate = 29,
        }

        public class WebHeaderCollection : System.Collections.Specialized.NameValueCollection, System.Collections.IEnumerable, System.Runtime.Serialization.ISerializable
        {
            public void Add(System.Net.HttpRequestHeader header, string value) => throw null;
            public void Add(System.Net.HttpResponseHeader header, string value) => throw null;
            public void Add(string header) => throw null;
            public override void Add(string name, string value) => throw null;
            protected void AddWithoutValidate(string headerName, string headerValue) => throw null;
            public override string[] AllKeys { get => throw null; }
            public override void Clear() => throw null;
            public override int Count { get => throw null; }
            public override string Get(int index) => throw null;
            public override string Get(string name) => throw null;
            public override System.Collections.IEnumerator GetEnumerator() => throw null;
            public override string GetKey(int index) => throw null;
            public override void GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
            void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
            public override string[] GetValues(int index) => throw null;
            public override string[] GetValues(string header) => throw null;
            public static bool IsRestricted(string headerName) => throw null;
            public static bool IsRestricted(string headerName, bool response) => throw null;
            public string this[System.Net.HttpRequestHeader header] { get => throw null; set => throw null; }
            public string this[System.Net.HttpResponseHeader header] { get => throw null; set => throw null; }
            public override System.Collections.Specialized.NameObjectCollectionBase.KeysCollection Keys { get => throw null; }
            public override void OnDeserialization(object sender) => throw null;
            public void Remove(System.Net.HttpRequestHeader header) => throw null;
            public void Remove(System.Net.HttpResponseHeader header) => throw null;
            public override void Remove(string name) => throw null;
            public void Set(System.Net.HttpRequestHeader header, string value) => throw null;
            public void Set(System.Net.HttpResponseHeader header, string value) => throw null;
            public override void Set(string name, string value) => throw null;
            public System.Byte[] ToByteArray() => throw null;
            public override string ToString() => throw null;
            public WebHeaderCollection() => throw null;
            protected WebHeaderCollection(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
        }

    }
}
