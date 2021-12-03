// This file contains auto-generated code.

namespace System
{
    namespace Net
    {
        // Generated from `System.Net.HttpRequestHeader` in `System.Net.WebHeaderCollection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum HttpRequestHeader
        {
            Accept,
            AcceptCharset,
            AcceptEncoding,
            AcceptLanguage,
            Allow,
            Authorization,
            CacheControl,
            Connection,
            ContentEncoding,
            ContentLanguage,
            ContentLength,
            ContentLocation,
            ContentMd5,
            ContentRange,
            ContentType,
            Cookie,
            Date,
            Expect,
            Expires,
            From,
            Host,
            IfMatch,
            IfModifiedSince,
            IfNoneMatch,
            IfRange,
            IfUnmodifiedSince,
            KeepAlive,
            LastModified,
            MaxForwards,
            Pragma,
            ProxyAuthorization,
            Range,
            Referer,
            Te,
            Trailer,
            TransferEncoding,
            Translate,
            Upgrade,
            UserAgent,
            Via,
            Warning,
        }

        // Generated from `System.Net.HttpResponseHeader` in `System.Net.WebHeaderCollection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum HttpResponseHeader
        {
            AcceptRanges,
            Age,
            Allow,
            CacheControl,
            Connection,
            ContentEncoding,
            ContentLanguage,
            ContentLength,
            ContentLocation,
            ContentMd5,
            ContentRange,
            ContentType,
            Date,
            ETag,
            Expires,
            KeepAlive,
            LastModified,
            Location,
            Pragma,
            ProxyAuthenticate,
            RetryAfter,
            Server,
            SetCookie,
            Trailer,
            TransferEncoding,
            Upgrade,
            Vary,
            Via,
            Warning,
            WwwAuthenticate,
        }

        // Generated from `System.Net.WebHeaderCollection` in `System.Net.WebHeaderCollection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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
