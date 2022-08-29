// This file contains auto-generated code.

namespace System
{
    namespace Net
    {
        // Generated from `System.Net.IWebProxyScript` in `System.Net.WebProxy, Version=6.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public interface IWebProxyScript
        {
            void Close();
            bool Load(System.Uri scriptLocation, string script, System.Type helperType);
            string Run(string url, string host);
        }

        // Generated from `System.Net.WebProxy` in `System.Net.WebProxy, Version=6.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class WebProxy : System.Net.IWebProxy, System.Runtime.Serialization.ISerializable
        {
            public System.Uri Address { get => throw null; set => throw null; }
            public System.Collections.ArrayList BypassArrayList { get => throw null; }
            public string[] BypassList { get => throw null; set => throw null; }
            public bool BypassProxyOnLocal { get => throw null; set => throw null; }
            public System.Net.ICredentials Credentials { get => throw null; set => throw null; }
            public static System.Net.WebProxy GetDefaultProxy() => throw null;
            protected virtual void GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
            void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
            public System.Uri GetProxy(System.Uri destination) => throw null;
            public bool IsBypassed(System.Uri host) => throw null;
            public bool UseDefaultCredentials { get => throw null; set => throw null; }
            public WebProxy() => throw null;
            protected WebProxy(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
            public WebProxy(System.Uri Address) => throw null;
            public WebProxy(System.Uri Address, bool BypassOnLocal) => throw null;
            public WebProxy(System.Uri Address, bool BypassOnLocal, string[] BypassList) => throw null;
            public WebProxy(System.Uri Address, bool BypassOnLocal, string[] BypassList, System.Net.ICredentials Credentials) => throw null;
            public WebProxy(string Address) => throw null;
            public WebProxy(string Address, bool BypassOnLocal) => throw null;
            public WebProxy(string Address, bool BypassOnLocal, string[] BypassList) => throw null;
            public WebProxy(string Address, bool BypassOnLocal, string[] BypassList, System.Net.ICredentials Credentials) => throw null;
            public WebProxy(string Host, int Port) => throw null;
        }

    }
}
