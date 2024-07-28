// This file contains auto-generated code.
// Generated from `System.Net.WebClient, Version=8.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`.
namespace System
{
    namespace Net
    {
        public class DownloadDataCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs
        {
            public byte[] Result { get => throw null; }
            internal DownloadDataCompletedEventArgs() : base(default(System.Exception), default(bool), default(object)) { }
        }
        public delegate void DownloadDataCompletedEventHandler(object sender, System.Net.DownloadDataCompletedEventArgs e);
        public class DownloadProgressChangedEventArgs : System.ComponentModel.ProgressChangedEventArgs
        {
            public long BytesReceived { get => throw null; }
            public long TotalBytesToReceive { get => throw null; }
            internal DownloadProgressChangedEventArgs() : base(default(int), default(object)) { }
        }
        public delegate void DownloadProgressChangedEventHandler(object sender, System.Net.DownloadProgressChangedEventArgs e);
        public class DownloadStringCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs
        {
            public string Result { get => throw null; }
            internal DownloadStringCompletedEventArgs() : base(default(System.Exception), default(bool), default(object)) { }
        }
        public delegate void DownloadStringCompletedEventHandler(object sender, System.Net.DownloadStringCompletedEventArgs e);
        public class OpenReadCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs
        {
            public System.IO.Stream Result { get => throw null; }
            internal OpenReadCompletedEventArgs() : base(default(System.Exception), default(bool), default(object)) { }
        }
        public delegate void OpenReadCompletedEventHandler(object sender, System.Net.OpenReadCompletedEventArgs e);
        public class OpenWriteCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs
        {
            public System.IO.Stream Result { get => throw null; }
            internal OpenWriteCompletedEventArgs() : base(default(System.Exception), default(bool), default(object)) { }
        }
        public delegate void OpenWriteCompletedEventHandler(object sender, System.Net.OpenWriteCompletedEventArgs e);
        public class UploadDataCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs
        {
            public byte[] Result { get => throw null; }
            internal UploadDataCompletedEventArgs() : base(default(System.Exception), default(bool), default(object)) { }
        }
        public delegate void UploadDataCompletedEventHandler(object sender, System.Net.UploadDataCompletedEventArgs e);
        public class UploadFileCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs
        {
            public byte[] Result { get => throw null; }
            internal UploadFileCompletedEventArgs() : base(default(System.Exception), default(bool), default(object)) { }
        }
        public delegate void UploadFileCompletedEventHandler(object sender, System.Net.UploadFileCompletedEventArgs e);
        public class UploadProgressChangedEventArgs : System.ComponentModel.ProgressChangedEventArgs
        {
            public long BytesReceived { get => throw null; }
            public long BytesSent { get => throw null; }
            public long TotalBytesToReceive { get => throw null; }
            public long TotalBytesToSend { get => throw null; }
            internal UploadProgressChangedEventArgs() : base(default(int), default(object)) { }
        }
        public delegate void UploadProgressChangedEventHandler(object sender, System.Net.UploadProgressChangedEventArgs e);
        public class UploadStringCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs
        {
            public string Result { get => throw null; }
            internal UploadStringCompletedEventArgs() : base(default(System.Exception), default(bool), default(object)) { }
        }
        public delegate void UploadStringCompletedEventHandler(object sender, System.Net.UploadStringCompletedEventArgs e);
        public class UploadValuesCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs
        {
            public byte[] Result { get => throw null; }
            internal UploadValuesCompletedEventArgs() : base(default(System.Exception), default(bool), default(object)) { }
        }
        public delegate void UploadValuesCompletedEventHandler(object sender, System.Net.UploadValuesCompletedEventArgs e);
        public class WebClient : System.ComponentModel.Component
        {
            public bool AllowReadStreamBuffering { get => throw null; set { } }
            public bool AllowWriteStreamBuffering { get => throw null; set { } }
            public string BaseAddress { get => throw null; set { } }
            public System.Net.Cache.RequestCachePolicy CachePolicy { get => throw null; set { } }
            public void CancelAsync() => throw null;
            public System.Net.ICredentials Credentials { get => throw null; set { } }
            public WebClient() => throw null;
            public byte[] DownloadData(string address) => throw null;
            public byte[] DownloadData(System.Uri address) => throw null;
            public void DownloadDataAsync(System.Uri address) => throw null;
            public void DownloadDataAsync(System.Uri address, object userToken) => throw null;
            public event System.Net.DownloadDataCompletedEventHandler DownloadDataCompleted;
            public System.Threading.Tasks.Task<byte[]> DownloadDataTaskAsync(string address) => throw null;
            public System.Threading.Tasks.Task<byte[]> DownloadDataTaskAsync(System.Uri address) => throw null;
            public void DownloadFile(string address, string fileName) => throw null;
            public void DownloadFile(System.Uri address, string fileName) => throw null;
            public void DownloadFileAsync(System.Uri address, string fileName) => throw null;
            public void DownloadFileAsync(System.Uri address, string fileName, object userToken) => throw null;
            public event System.ComponentModel.AsyncCompletedEventHandler DownloadFileCompleted;
            public System.Threading.Tasks.Task DownloadFileTaskAsync(string address, string fileName) => throw null;
            public System.Threading.Tasks.Task DownloadFileTaskAsync(System.Uri address, string fileName) => throw null;
            public event System.Net.DownloadProgressChangedEventHandler DownloadProgressChanged;
            public string DownloadString(string address) => throw null;
            public string DownloadString(System.Uri address) => throw null;
            public void DownloadStringAsync(System.Uri address) => throw null;
            public void DownloadStringAsync(System.Uri address, object userToken) => throw null;
            public event System.Net.DownloadStringCompletedEventHandler DownloadStringCompleted;
            public System.Threading.Tasks.Task<string> DownloadStringTaskAsync(string address) => throw null;
            public System.Threading.Tasks.Task<string> DownloadStringTaskAsync(System.Uri address) => throw null;
            public System.Text.Encoding Encoding { get => throw null; set { } }
            protected virtual System.Net.WebRequest GetWebRequest(System.Uri address) => throw null;
            protected virtual System.Net.WebResponse GetWebResponse(System.Net.WebRequest request) => throw null;
            protected virtual System.Net.WebResponse GetWebResponse(System.Net.WebRequest request, System.IAsyncResult result) => throw null;
            public System.Net.WebHeaderCollection Headers { get => throw null; set { } }
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
            public System.IO.Stream OpenRead(string address) => throw null;
            public System.IO.Stream OpenRead(System.Uri address) => throw null;
            public void OpenReadAsync(System.Uri address) => throw null;
            public void OpenReadAsync(System.Uri address, object userToken) => throw null;
            public event System.Net.OpenReadCompletedEventHandler OpenReadCompleted;
            public System.Threading.Tasks.Task<System.IO.Stream> OpenReadTaskAsync(string address) => throw null;
            public System.Threading.Tasks.Task<System.IO.Stream> OpenReadTaskAsync(System.Uri address) => throw null;
            public System.IO.Stream OpenWrite(string address) => throw null;
            public System.IO.Stream OpenWrite(string address, string method) => throw null;
            public System.IO.Stream OpenWrite(System.Uri address) => throw null;
            public System.IO.Stream OpenWrite(System.Uri address, string method) => throw null;
            public void OpenWriteAsync(System.Uri address) => throw null;
            public void OpenWriteAsync(System.Uri address, string method) => throw null;
            public void OpenWriteAsync(System.Uri address, string method, object userToken) => throw null;
            public event System.Net.OpenWriteCompletedEventHandler OpenWriteCompleted;
            public System.Threading.Tasks.Task<System.IO.Stream> OpenWriteTaskAsync(string address) => throw null;
            public System.Threading.Tasks.Task<System.IO.Stream> OpenWriteTaskAsync(string address, string method) => throw null;
            public System.Threading.Tasks.Task<System.IO.Stream> OpenWriteTaskAsync(System.Uri address) => throw null;
            public System.Threading.Tasks.Task<System.IO.Stream> OpenWriteTaskAsync(System.Uri address, string method) => throw null;
            public System.Net.IWebProxy Proxy { get => throw null; set { } }
            public System.Collections.Specialized.NameValueCollection QueryString { get => throw null; set { } }
            public System.Net.WebHeaderCollection ResponseHeaders { get => throw null; }
            public byte[] UploadData(string address, byte[] data) => throw null;
            public byte[] UploadData(string address, string method, byte[] data) => throw null;
            public byte[] UploadData(System.Uri address, byte[] data) => throw null;
            public byte[] UploadData(System.Uri address, string method, byte[] data) => throw null;
            public void UploadDataAsync(System.Uri address, byte[] data) => throw null;
            public void UploadDataAsync(System.Uri address, string method, byte[] data) => throw null;
            public void UploadDataAsync(System.Uri address, string method, byte[] data, object userToken) => throw null;
            public event System.Net.UploadDataCompletedEventHandler UploadDataCompleted;
            public System.Threading.Tasks.Task<byte[]> UploadDataTaskAsync(string address, byte[] data) => throw null;
            public System.Threading.Tasks.Task<byte[]> UploadDataTaskAsync(string address, string method, byte[] data) => throw null;
            public System.Threading.Tasks.Task<byte[]> UploadDataTaskAsync(System.Uri address, byte[] data) => throw null;
            public System.Threading.Tasks.Task<byte[]> UploadDataTaskAsync(System.Uri address, string method, byte[] data) => throw null;
            public byte[] UploadFile(string address, string fileName) => throw null;
            public byte[] UploadFile(string address, string method, string fileName) => throw null;
            public byte[] UploadFile(System.Uri address, string fileName) => throw null;
            public byte[] UploadFile(System.Uri address, string method, string fileName) => throw null;
            public void UploadFileAsync(System.Uri address, string fileName) => throw null;
            public void UploadFileAsync(System.Uri address, string method, string fileName) => throw null;
            public void UploadFileAsync(System.Uri address, string method, string fileName, object userToken) => throw null;
            public event System.Net.UploadFileCompletedEventHandler UploadFileCompleted;
            public System.Threading.Tasks.Task<byte[]> UploadFileTaskAsync(string address, string fileName) => throw null;
            public System.Threading.Tasks.Task<byte[]> UploadFileTaskAsync(string address, string method, string fileName) => throw null;
            public System.Threading.Tasks.Task<byte[]> UploadFileTaskAsync(System.Uri address, string fileName) => throw null;
            public System.Threading.Tasks.Task<byte[]> UploadFileTaskAsync(System.Uri address, string method, string fileName) => throw null;
            public event System.Net.UploadProgressChangedEventHandler UploadProgressChanged;
            public string UploadString(string address, string data) => throw null;
            public string UploadString(string address, string method, string data) => throw null;
            public string UploadString(System.Uri address, string data) => throw null;
            public string UploadString(System.Uri address, string method, string data) => throw null;
            public void UploadStringAsync(System.Uri address, string data) => throw null;
            public void UploadStringAsync(System.Uri address, string method, string data) => throw null;
            public void UploadStringAsync(System.Uri address, string method, string data, object userToken) => throw null;
            public event System.Net.UploadStringCompletedEventHandler UploadStringCompleted;
            public System.Threading.Tasks.Task<string> UploadStringTaskAsync(string address, string data) => throw null;
            public System.Threading.Tasks.Task<string> UploadStringTaskAsync(string address, string method, string data) => throw null;
            public System.Threading.Tasks.Task<string> UploadStringTaskAsync(System.Uri address, string data) => throw null;
            public System.Threading.Tasks.Task<string> UploadStringTaskAsync(System.Uri address, string method, string data) => throw null;
            public byte[] UploadValues(string address, System.Collections.Specialized.NameValueCollection data) => throw null;
            public byte[] UploadValues(string address, string method, System.Collections.Specialized.NameValueCollection data) => throw null;
            public byte[] UploadValues(System.Uri address, System.Collections.Specialized.NameValueCollection data) => throw null;
            public byte[] UploadValues(System.Uri address, string method, System.Collections.Specialized.NameValueCollection data) => throw null;
            public void UploadValuesAsync(System.Uri address, System.Collections.Specialized.NameValueCollection data) => throw null;
            public void UploadValuesAsync(System.Uri address, string method, System.Collections.Specialized.NameValueCollection data) => throw null;
            public void UploadValuesAsync(System.Uri address, string method, System.Collections.Specialized.NameValueCollection data, object userToken) => throw null;
            public event System.Net.UploadValuesCompletedEventHandler UploadValuesCompleted;
            public System.Threading.Tasks.Task<byte[]> UploadValuesTaskAsync(string address, System.Collections.Specialized.NameValueCollection data) => throw null;
            public System.Threading.Tasks.Task<byte[]> UploadValuesTaskAsync(string address, string method, System.Collections.Specialized.NameValueCollection data) => throw null;
            public System.Threading.Tasks.Task<byte[]> UploadValuesTaskAsync(System.Uri address, System.Collections.Specialized.NameValueCollection data) => throw null;
            public System.Threading.Tasks.Task<byte[]> UploadValuesTaskAsync(System.Uri address, string method, System.Collections.Specialized.NameValueCollection data) => throw null;
            public bool UseDefaultCredentials { get => throw null; set { } }
            public event System.Net.WriteStreamClosedEventHandler WriteStreamClosed;
        }
        public class WriteStreamClosedEventArgs : System.EventArgs
        {
            public WriteStreamClosedEventArgs() => throw null;
            public System.Exception Error { get => throw null; }
        }
        public delegate void WriteStreamClosedEventHandler(object sender, System.Net.WriteStreamClosedEventArgs e);
    }
}
