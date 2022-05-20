// This file contains auto-generated code.

namespace System
{
    namespace Net
    {
        // Generated from `System.Net.DownloadDataCompletedEventArgs` in `System.Net.WebClient, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class DownloadDataCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs
        {
            internal DownloadDataCompletedEventArgs() : base(default(System.Exception), default(bool), default(object)) => throw null;
            public System.Byte[] Result { get => throw null; }
        }

        // Generated from `System.Net.DownloadDataCompletedEventHandler` in `System.Net.WebClient, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public delegate void DownloadDataCompletedEventHandler(object sender, System.Net.DownloadDataCompletedEventArgs e);

        // Generated from `System.Net.DownloadProgressChangedEventArgs` in `System.Net.WebClient, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class DownloadProgressChangedEventArgs : System.ComponentModel.ProgressChangedEventArgs
        {
            public System.Int64 BytesReceived { get => throw null; }
            internal DownloadProgressChangedEventArgs() : base(default(int), default(object)) => throw null;
            public System.Int64 TotalBytesToReceive { get => throw null; }
        }

        // Generated from `System.Net.DownloadProgressChangedEventHandler` in `System.Net.WebClient, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public delegate void DownloadProgressChangedEventHandler(object sender, System.Net.DownloadProgressChangedEventArgs e);

        // Generated from `System.Net.DownloadStringCompletedEventArgs` in `System.Net.WebClient, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class DownloadStringCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs
        {
            internal DownloadStringCompletedEventArgs() : base(default(System.Exception), default(bool), default(object)) => throw null;
            public string Result { get => throw null; }
        }

        // Generated from `System.Net.DownloadStringCompletedEventHandler` in `System.Net.WebClient, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public delegate void DownloadStringCompletedEventHandler(object sender, System.Net.DownloadStringCompletedEventArgs e);

        // Generated from `System.Net.OpenReadCompletedEventArgs` in `System.Net.WebClient, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class OpenReadCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs
        {
            internal OpenReadCompletedEventArgs() : base(default(System.Exception), default(bool), default(object)) => throw null;
            public System.IO.Stream Result { get => throw null; }
        }

        // Generated from `System.Net.OpenReadCompletedEventHandler` in `System.Net.WebClient, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public delegate void OpenReadCompletedEventHandler(object sender, System.Net.OpenReadCompletedEventArgs e);

        // Generated from `System.Net.OpenWriteCompletedEventArgs` in `System.Net.WebClient, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class OpenWriteCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs
        {
            internal OpenWriteCompletedEventArgs() : base(default(System.Exception), default(bool), default(object)) => throw null;
            public System.IO.Stream Result { get => throw null; }
        }

        // Generated from `System.Net.OpenWriteCompletedEventHandler` in `System.Net.WebClient, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public delegate void OpenWriteCompletedEventHandler(object sender, System.Net.OpenWriteCompletedEventArgs e);

        // Generated from `System.Net.UploadDataCompletedEventArgs` in `System.Net.WebClient, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class UploadDataCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs
        {
            public System.Byte[] Result { get => throw null; }
            internal UploadDataCompletedEventArgs() : base(default(System.Exception), default(bool), default(object)) => throw null;
        }

        // Generated from `System.Net.UploadDataCompletedEventHandler` in `System.Net.WebClient, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public delegate void UploadDataCompletedEventHandler(object sender, System.Net.UploadDataCompletedEventArgs e);

        // Generated from `System.Net.UploadFileCompletedEventArgs` in `System.Net.WebClient, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class UploadFileCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs
        {
            public System.Byte[] Result { get => throw null; }
            internal UploadFileCompletedEventArgs() : base(default(System.Exception), default(bool), default(object)) => throw null;
        }

        // Generated from `System.Net.UploadFileCompletedEventHandler` in `System.Net.WebClient, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public delegate void UploadFileCompletedEventHandler(object sender, System.Net.UploadFileCompletedEventArgs e);

        // Generated from `System.Net.UploadProgressChangedEventArgs` in `System.Net.WebClient, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class UploadProgressChangedEventArgs : System.ComponentModel.ProgressChangedEventArgs
        {
            public System.Int64 BytesReceived { get => throw null; }
            public System.Int64 BytesSent { get => throw null; }
            public System.Int64 TotalBytesToReceive { get => throw null; }
            public System.Int64 TotalBytesToSend { get => throw null; }
            internal UploadProgressChangedEventArgs() : base(default(int), default(object)) => throw null;
        }

        // Generated from `System.Net.UploadProgressChangedEventHandler` in `System.Net.WebClient, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public delegate void UploadProgressChangedEventHandler(object sender, System.Net.UploadProgressChangedEventArgs e);

        // Generated from `System.Net.UploadStringCompletedEventArgs` in `System.Net.WebClient, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class UploadStringCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs
        {
            public string Result { get => throw null; }
            internal UploadStringCompletedEventArgs() : base(default(System.Exception), default(bool), default(object)) => throw null;
        }

        // Generated from `System.Net.UploadStringCompletedEventHandler` in `System.Net.WebClient, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public delegate void UploadStringCompletedEventHandler(object sender, System.Net.UploadStringCompletedEventArgs e);

        // Generated from `System.Net.UploadValuesCompletedEventArgs` in `System.Net.WebClient, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class UploadValuesCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs
        {
            public System.Byte[] Result { get => throw null; }
            internal UploadValuesCompletedEventArgs() : base(default(System.Exception), default(bool), default(object)) => throw null;
        }

        // Generated from `System.Net.UploadValuesCompletedEventHandler` in `System.Net.WebClient, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public delegate void UploadValuesCompletedEventHandler(object sender, System.Net.UploadValuesCompletedEventArgs e);

        // Generated from `System.Net.WebClient` in `System.Net.WebClient, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class WebClient : System.ComponentModel.Component
        {
            public bool AllowReadStreamBuffering { get => throw null; set => throw null; }
            public bool AllowWriteStreamBuffering { get => throw null; set => throw null; }
            public string BaseAddress { get => throw null; set => throw null; }
            public System.Net.Cache.RequestCachePolicy CachePolicy { get => throw null; set => throw null; }
            public void CancelAsync() => throw null;
            public System.Net.ICredentials Credentials { get => throw null; set => throw null; }
            public System.Byte[] DownloadData(System.Uri address) => throw null;
            public System.Byte[] DownloadData(string address) => throw null;
            public void DownloadDataAsync(System.Uri address) => throw null;
            public void DownloadDataAsync(System.Uri address, object userToken) => throw null;
            public event System.Net.DownloadDataCompletedEventHandler DownloadDataCompleted;
            public System.Threading.Tasks.Task<System.Byte[]> DownloadDataTaskAsync(System.Uri address) => throw null;
            public System.Threading.Tasks.Task<System.Byte[]> DownloadDataTaskAsync(string address) => throw null;
            public void DownloadFile(System.Uri address, string fileName) => throw null;
            public void DownloadFile(string address, string fileName) => throw null;
            public void DownloadFileAsync(System.Uri address, string fileName) => throw null;
            public void DownloadFileAsync(System.Uri address, string fileName, object userToken) => throw null;
            public event System.ComponentModel.AsyncCompletedEventHandler DownloadFileCompleted;
            public System.Threading.Tasks.Task DownloadFileTaskAsync(System.Uri address, string fileName) => throw null;
            public System.Threading.Tasks.Task DownloadFileTaskAsync(string address, string fileName) => throw null;
            public event System.Net.DownloadProgressChangedEventHandler DownloadProgressChanged;
            public string DownloadString(System.Uri address) => throw null;
            public string DownloadString(string address) => throw null;
            public void DownloadStringAsync(System.Uri address) => throw null;
            public void DownloadStringAsync(System.Uri address, object userToken) => throw null;
            public event System.Net.DownloadStringCompletedEventHandler DownloadStringCompleted;
            public System.Threading.Tasks.Task<string> DownloadStringTaskAsync(System.Uri address) => throw null;
            public System.Threading.Tasks.Task<string> DownloadStringTaskAsync(string address) => throw null;
            public System.Text.Encoding Encoding { get => throw null; set => throw null; }
            protected virtual System.Net.WebRequest GetWebRequest(System.Uri address) => throw null;
            protected virtual System.Net.WebResponse GetWebResponse(System.Net.WebRequest request) => throw null;
            protected virtual System.Net.WebResponse GetWebResponse(System.Net.WebRequest request, System.IAsyncResult result) => throw null;
            public System.Net.WebHeaderCollection Headers { get => throw null; set => throw null; }
            public bool IsBusy { get => throw null; }
            protected virtual void OnDownloadDataCompleted(System.Net.DownloadDataCompletedEventArgs e) => throw null;
            protected virtual void OnDownloadFileCompleted(System.ComponentModel.AsyncCompletedEventArgs e) => throw null;
            protected virtual void OnDownloadProgressChanged(System.Net.DownloadProgressChangedEventArgs e) => throw null;
            protected virtual void OnDownloadStringCompleted(System.Net.DownloadStringCompletedEventArgs e) => throw null;
            protected virtual void OnOpenReadCompleted(System.Net.OpenReadCompletedEventArgs e) => throw null;
            protected virtual void OnOpenWriteCompleted(System.Net.OpenWriteCompletedEventArgs e) => throw null;
            protected virtual void OnUploadDataCompleted(System.Net.UploadDataCompletedEventArgs e) => throw null;
            protected virtual void OnUploadFileCompleted(System.Net.UploadFileCompletedEventArgs e) => throw null;
            protected virtual void OnUploadProgressChanged(System.Net.UploadProgressChangedEventArgs e) => throw null;
            protected virtual void OnUploadStringCompleted(System.Net.UploadStringCompletedEventArgs e) => throw null;
            protected virtual void OnUploadValuesCompleted(System.Net.UploadValuesCompletedEventArgs e) => throw null;
            protected virtual void OnWriteStreamClosed(System.Net.WriteStreamClosedEventArgs e) => throw null;
            public System.IO.Stream OpenRead(System.Uri address) => throw null;
            public System.IO.Stream OpenRead(string address) => throw null;
            public void OpenReadAsync(System.Uri address) => throw null;
            public void OpenReadAsync(System.Uri address, object userToken) => throw null;
            public event System.Net.OpenReadCompletedEventHandler OpenReadCompleted;
            public System.Threading.Tasks.Task<System.IO.Stream> OpenReadTaskAsync(System.Uri address) => throw null;
            public System.Threading.Tasks.Task<System.IO.Stream> OpenReadTaskAsync(string address) => throw null;
            public System.IO.Stream OpenWrite(System.Uri address) => throw null;
            public System.IO.Stream OpenWrite(System.Uri address, string method) => throw null;
            public System.IO.Stream OpenWrite(string address) => throw null;
            public System.IO.Stream OpenWrite(string address, string method) => throw null;
            public void OpenWriteAsync(System.Uri address) => throw null;
            public void OpenWriteAsync(System.Uri address, string method) => throw null;
            public void OpenWriteAsync(System.Uri address, string method, object userToken) => throw null;
            public event System.Net.OpenWriteCompletedEventHandler OpenWriteCompleted;
            public System.Threading.Tasks.Task<System.IO.Stream> OpenWriteTaskAsync(System.Uri address) => throw null;
            public System.Threading.Tasks.Task<System.IO.Stream> OpenWriteTaskAsync(System.Uri address, string method) => throw null;
            public System.Threading.Tasks.Task<System.IO.Stream> OpenWriteTaskAsync(string address) => throw null;
            public System.Threading.Tasks.Task<System.IO.Stream> OpenWriteTaskAsync(string address, string method) => throw null;
            public System.Net.IWebProxy Proxy { get => throw null; set => throw null; }
            public System.Collections.Specialized.NameValueCollection QueryString { get => throw null; set => throw null; }
            public System.Net.WebHeaderCollection ResponseHeaders { get => throw null; }
            public System.Byte[] UploadData(System.Uri address, System.Byte[] data) => throw null;
            public System.Byte[] UploadData(System.Uri address, string method, System.Byte[] data) => throw null;
            public System.Byte[] UploadData(string address, System.Byte[] data) => throw null;
            public System.Byte[] UploadData(string address, string method, System.Byte[] data) => throw null;
            public void UploadDataAsync(System.Uri address, System.Byte[] data) => throw null;
            public void UploadDataAsync(System.Uri address, string method, System.Byte[] data) => throw null;
            public void UploadDataAsync(System.Uri address, string method, System.Byte[] data, object userToken) => throw null;
            public event System.Net.UploadDataCompletedEventHandler UploadDataCompleted;
            public System.Threading.Tasks.Task<System.Byte[]> UploadDataTaskAsync(System.Uri address, System.Byte[] data) => throw null;
            public System.Threading.Tasks.Task<System.Byte[]> UploadDataTaskAsync(System.Uri address, string method, System.Byte[] data) => throw null;
            public System.Threading.Tasks.Task<System.Byte[]> UploadDataTaskAsync(string address, System.Byte[] data) => throw null;
            public System.Threading.Tasks.Task<System.Byte[]> UploadDataTaskAsync(string address, string method, System.Byte[] data) => throw null;
            public System.Byte[] UploadFile(System.Uri address, string fileName) => throw null;
            public System.Byte[] UploadFile(System.Uri address, string method, string fileName) => throw null;
            public System.Byte[] UploadFile(string address, string fileName) => throw null;
            public System.Byte[] UploadFile(string address, string method, string fileName) => throw null;
            public void UploadFileAsync(System.Uri address, string fileName) => throw null;
            public void UploadFileAsync(System.Uri address, string method, string fileName) => throw null;
            public void UploadFileAsync(System.Uri address, string method, string fileName, object userToken) => throw null;
            public event System.Net.UploadFileCompletedEventHandler UploadFileCompleted;
            public System.Threading.Tasks.Task<System.Byte[]> UploadFileTaskAsync(System.Uri address, string fileName) => throw null;
            public System.Threading.Tasks.Task<System.Byte[]> UploadFileTaskAsync(System.Uri address, string method, string fileName) => throw null;
            public System.Threading.Tasks.Task<System.Byte[]> UploadFileTaskAsync(string address, string fileName) => throw null;
            public System.Threading.Tasks.Task<System.Byte[]> UploadFileTaskAsync(string address, string method, string fileName) => throw null;
            public event System.Net.UploadProgressChangedEventHandler UploadProgressChanged;
            public string UploadString(System.Uri address, string data) => throw null;
            public string UploadString(System.Uri address, string method, string data) => throw null;
            public string UploadString(string address, string data) => throw null;
            public string UploadString(string address, string method, string data) => throw null;
            public void UploadStringAsync(System.Uri address, string data) => throw null;
            public void UploadStringAsync(System.Uri address, string method, string data) => throw null;
            public void UploadStringAsync(System.Uri address, string method, string data, object userToken) => throw null;
            public event System.Net.UploadStringCompletedEventHandler UploadStringCompleted;
            public System.Threading.Tasks.Task<string> UploadStringTaskAsync(System.Uri address, string data) => throw null;
            public System.Threading.Tasks.Task<string> UploadStringTaskAsync(System.Uri address, string method, string data) => throw null;
            public System.Threading.Tasks.Task<string> UploadStringTaskAsync(string address, string data) => throw null;
            public System.Threading.Tasks.Task<string> UploadStringTaskAsync(string address, string method, string data) => throw null;
            public System.Byte[] UploadValues(System.Uri address, System.Collections.Specialized.NameValueCollection data) => throw null;
            public System.Byte[] UploadValues(System.Uri address, string method, System.Collections.Specialized.NameValueCollection data) => throw null;
            public System.Byte[] UploadValues(string address, System.Collections.Specialized.NameValueCollection data) => throw null;
            public System.Byte[] UploadValues(string address, string method, System.Collections.Specialized.NameValueCollection data) => throw null;
            public void UploadValuesAsync(System.Uri address, System.Collections.Specialized.NameValueCollection data) => throw null;
            public void UploadValuesAsync(System.Uri address, string method, System.Collections.Specialized.NameValueCollection data) => throw null;
            public void UploadValuesAsync(System.Uri address, string method, System.Collections.Specialized.NameValueCollection data, object userToken) => throw null;
            public event System.Net.UploadValuesCompletedEventHandler UploadValuesCompleted;
            public System.Threading.Tasks.Task<System.Byte[]> UploadValuesTaskAsync(System.Uri address, System.Collections.Specialized.NameValueCollection data) => throw null;
            public System.Threading.Tasks.Task<System.Byte[]> UploadValuesTaskAsync(System.Uri address, string method, System.Collections.Specialized.NameValueCollection data) => throw null;
            public System.Threading.Tasks.Task<System.Byte[]> UploadValuesTaskAsync(string address, System.Collections.Specialized.NameValueCollection data) => throw null;
            public System.Threading.Tasks.Task<System.Byte[]> UploadValuesTaskAsync(string address, string method, System.Collections.Specialized.NameValueCollection data) => throw null;
            public bool UseDefaultCredentials { get => throw null; set => throw null; }
            public WebClient() => throw null;
            public event System.Net.WriteStreamClosedEventHandler WriteStreamClosed;
        }

        // Generated from `System.Net.WriteStreamClosedEventArgs` in `System.Net.WebClient, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class WriteStreamClosedEventArgs : System.EventArgs
        {
            public System.Exception Error { get => throw null; }
            public WriteStreamClosedEventArgs() => throw null;
        }

        // Generated from `System.Net.WriteStreamClosedEventHandler` in `System.Net.WebClient, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public delegate void WriteStreamClosedEventHandler(object sender, System.Net.WriteStreamClosedEventArgs e);

    }
}
