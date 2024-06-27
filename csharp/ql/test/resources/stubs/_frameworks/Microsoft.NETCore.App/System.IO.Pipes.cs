// This file contains auto-generated code.
// Generated from `System.IO.Pipes, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace Microsoft
{
    namespace Win32
    {
        namespace SafeHandles
        {
            public sealed class SafePipeHandle : Microsoft.Win32.SafeHandles.SafeHandleZeroOrMinusOneIsInvalid
            {
                public SafePipeHandle() : base(default(bool)) => throw null;
                public SafePipeHandle(nint preexistingHandle, bool ownsHandle) : base(default(bool)) => throw null;
                public override bool IsInvalid { get => throw null; }
                protected override bool ReleaseHandle() => throw null;
            }
        }
    }
}
namespace System
{
    namespace IO
    {
        namespace Pipes
        {
            public sealed class AnonymousPipeClientStream : System.IO.Pipes.PipeStream
            {
                public AnonymousPipeClientStream(System.IO.Pipes.PipeDirection direction, Microsoft.Win32.SafeHandles.SafePipeHandle safePipeHandle) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public AnonymousPipeClientStream(System.IO.Pipes.PipeDirection direction, string pipeHandleAsString) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public AnonymousPipeClientStream(string pipeHandleAsString) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public override System.IO.Pipes.PipeTransmissionMode ReadMode { set { } }
                public override System.IO.Pipes.PipeTransmissionMode TransmissionMode { get => throw null; }
            }
            public sealed class AnonymousPipeServerStream : System.IO.Pipes.PipeStream
            {
                public Microsoft.Win32.SafeHandles.SafePipeHandle ClientSafePipeHandle { get => throw null; }
                public AnonymousPipeServerStream() : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public AnonymousPipeServerStream(System.IO.Pipes.PipeDirection direction) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public AnonymousPipeServerStream(System.IO.Pipes.PipeDirection direction, Microsoft.Win32.SafeHandles.SafePipeHandle serverSafePipeHandle, Microsoft.Win32.SafeHandles.SafePipeHandle clientSafePipeHandle) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public AnonymousPipeServerStream(System.IO.Pipes.PipeDirection direction, System.IO.HandleInheritability inheritability) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public AnonymousPipeServerStream(System.IO.Pipes.PipeDirection direction, System.IO.HandleInheritability inheritability, int bufferSize) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public void DisposeLocalCopyOfClientHandle() => throw null;
                public string GetClientHandleAsString() => throw null;
                public override System.IO.Pipes.PipeTransmissionMode ReadMode { set { } }
                public override System.IO.Pipes.PipeTransmissionMode TransmissionMode { get => throw null; }
            }
            public sealed class NamedPipeClientStream : System.IO.Pipes.PipeStream
            {
                protected override void CheckPipePropertyOperations() => throw null;
                public void Connect() => throw null;
                public void Connect(int timeout) => throw null;
                public void Connect(System.TimeSpan timeout) => throw null;
                public System.Threading.Tasks.Task ConnectAsync() => throw null;
                public System.Threading.Tasks.Task ConnectAsync(int timeout) => throw null;
                public System.Threading.Tasks.Task ConnectAsync(int timeout, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task ConnectAsync(System.TimeSpan timeout, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task ConnectAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public NamedPipeClientStream(System.IO.Pipes.PipeDirection direction, bool isAsync, bool isConnected, Microsoft.Win32.SafeHandles.SafePipeHandle safePipeHandle) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public NamedPipeClientStream(string pipeName) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public NamedPipeClientStream(string serverName, string pipeName) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public NamedPipeClientStream(string serverName, string pipeName, System.IO.Pipes.PipeDirection direction) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public NamedPipeClientStream(string serverName, string pipeName, System.IO.Pipes.PipeDirection direction, System.IO.Pipes.PipeOptions options) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public NamedPipeClientStream(string serverName, string pipeName, System.IO.Pipes.PipeDirection direction, System.IO.Pipes.PipeOptions options, System.Security.Principal.TokenImpersonationLevel impersonationLevel) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public NamedPipeClientStream(string serverName, string pipeName, System.IO.Pipes.PipeDirection direction, System.IO.Pipes.PipeOptions options, System.Security.Principal.TokenImpersonationLevel impersonationLevel, System.IO.HandleInheritability inheritability) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public int NumberOfServerInstances { get => throw null; }
            }
            public sealed class NamedPipeServerStream : System.IO.Pipes.PipeStream
            {
                public System.IAsyncResult BeginWaitForConnection(System.AsyncCallback callback, object state) => throw null;
                public NamedPipeServerStream(System.IO.Pipes.PipeDirection direction, bool isAsync, bool isConnected, Microsoft.Win32.SafeHandles.SafePipeHandle safePipeHandle) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public NamedPipeServerStream(string pipeName) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public NamedPipeServerStream(string pipeName, System.IO.Pipes.PipeDirection direction) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public NamedPipeServerStream(string pipeName, System.IO.Pipes.PipeDirection direction, int maxNumberOfServerInstances) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public NamedPipeServerStream(string pipeName, System.IO.Pipes.PipeDirection direction, int maxNumberOfServerInstances, System.IO.Pipes.PipeTransmissionMode transmissionMode) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public NamedPipeServerStream(string pipeName, System.IO.Pipes.PipeDirection direction, int maxNumberOfServerInstances, System.IO.Pipes.PipeTransmissionMode transmissionMode, System.IO.Pipes.PipeOptions options) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public NamedPipeServerStream(string pipeName, System.IO.Pipes.PipeDirection direction, int maxNumberOfServerInstances, System.IO.Pipes.PipeTransmissionMode transmissionMode, System.IO.Pipes.PipeOptions options, int inBufferSize, int outBufferSize) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public void Disconnect() => throw null;
                public void EndWaitForConnection(System.IAsyncResult asyncResult) => throw null;
                public string GetImpersonationUserName() => throw null;
                public const int MaxAllowedServerInstances = -1;
                public void RunAsClient(System.IO.Pipes.PipeStreamImpersonationWorker impersonationWorker) => throw null;
                public void WaitForConnection() => throw null;
                public System.Threading.Tasks.Task WaitForConnectionAsync() => throw null;
                public System.Threading.Tasks.Task WaitForConnectionAsync(System.Threading.CancellationToken cancellationToken) => throw null;
            }
            public enum PipeDirection
            {
                In = 1,
                Out = 2,
                InOut = 3,
            }
            [System.Flags]
            public enum PipeOptions
            {
                WriteThrough = -2147483648,
                None = 0,
                CurrentUserOnly = 536870912,
                Asynchronous = 1073741824,
                FirstPipeInstance = 524288,
            }
            public abstract class PipeStream : System.IO.Stream
            {
                public override System.IAsyncResult BeginRead(byte[] buffer, int offset, int count, System.AsyncCallback callback, object state) => throw null;
                public override System.IAsyncResult BeginWrite(byte[] buffer, int offset, int count, System.AsyncCallback callback, object state) => throw null;
                public override bool CanRead { get => throw null; }
                public override bool CanSeek { get => throw null; }
                public override bool CanWrite { get => throw null; }
                protected virtual void CheckPipePropertyOperations() => throw null;
                protected void CheckReadOperations() => throw null;
                protected void CheckWriteOperations() => throw null;
                protected PipeStream(System.IO.Pipes.PipeDirection direction, int bufferSize) => throw null;
                protected PipeStream(System.IO.Pipes.PipeDirection direction, System.IO.Pipes.PipeTransmissionMode transmissionMode, int outBufferSize) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override int EndRead(System.IAsyncResult asyncResult) => throw null;
                public override void EndWrite(System.IAsyncResult asyncResult) => throw null;
                public override void Flush() => throw null;
                public override System.Threading.Tasks.Task FlushAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public virtual int InBufferSize { get => throw null; }
                protected void InitializeHandle(Microsoft.Win32.SafeHandles.SafePipeHandle handle, bool isExposed, bool isAsync) => throw null;
                public bool IsAsync { get => throw null; }
                public bool IsConnected { get => throw null; set { } }
                protected bool IsHandleExposed { get => throw null; }
                public bool IsMessageComplete { get => throw null; }
                public override long Length { get => throw null; }
                public virtual int OutBufferSize { get => throw null; }
                public override long Position { get => throw null; set { } }
                public override int Read(byte[] buffer, int offset, int count) => throw null;
                public override int Read(System.Span<byte> buffer) => throw null;
                public override System.Threading.Tasks.Task<int> ReadAsync(byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.ValueTask<int> ReadAsync(System.Memory<byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override int ReadByte() => throw null;
                public virtual System.IO.Pipes.PipeTransmissionMode ReadMode { get => throw null; set { } }
                public Microsoft.Win32.SafeHandles.SafePipeHandle SafePipeHandle { get => throw null; }
                public override long Seek(long offset, System.IO.SeekOrigin origin) => throw null;
                public override void SetLength(long value) => throw null;
                public virtual System.IO.Pipes.PipeTransmissionMode TransmissionMode { get => throw null; }
                public void WaitForPipeDrain() => throw null;
                public override void Write(byte[] buffer, int offset, int count) => throw null;
                public override void Write(System.ReadOnlySpan<byte> buffer) => throw null;
                public override System.Threading.Tasks.Task WriteAsync(byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.ValueTask WriteAsync(System.ReadOnlyMemory<byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override void WriteByte(byte value) => throw null;
            }
            public delegate void PipeStreamImpersonationWorker();
            public enum PipeTransmissionMode
            {
                Byte = 0,
                Message = 1,
            }
        }
    }
}
