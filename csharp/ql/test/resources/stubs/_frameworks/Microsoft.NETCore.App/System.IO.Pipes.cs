// This file contains auto-generated code.

namespace Microsoft
{
    namespace Win32
    {
        namespace SafeHandles
        {
            // Generated from `Microsoft.Win32.SafeHandles.SafePipeHandle` in `System.IO.Pipes, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SafePipeHandle : Microsoft.Win32.SafeHandles.SafeHandleZeroOrMinusOneIsInvalid
            {
                public override bool IsInvalid { get => throw null; }
                protected override bool ReleaseHandle() => throw null;
                public SafePipeHandle(System.IntPtr preexistingHandle, bool ownsHandle) : base(default(bool)) => throw null;
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
            // Generated from `System.IO.Pipes.AnonymousPipeClientStream` in `System.IO.Pipes, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class AnonymousPipeClientStream : System.IO.Pipes.PipeStream
            {
                public AnonymousPipeClientStream(System.IO.Pipes.PipeDirection direction, Microsoft.Win32.SafeHandles.SafePipeHandle safePipeHandle) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public AnonymousPipeClientStream(System.IO.Pipes.PipeDirection direction, string pipeHandleAsString) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public AnonymousPipeClientStream(string pipeHandleAsString) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public override System.IO.Pipes.PipeTransmissionMode ReadMode { set => throw null; }
                public override System.IO.Pipes.PipeTransmissionMode TransmissionMode { get => throw null; }
                // ERR: Stub generator didn't handle member: ~AnonymousPipeClientStream
            }

            // Generated from `System.IO.Pipes.AnonymousPipeServerStream` in `System.IO.Pipes, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class AnonymousPipeServerStream : System.IO.Pipes.PipeStream
            {
                public AnonymousPipeServerStream() : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public AnonymousPipeServerStream(System.IO.Pipes.PipeDirection direction) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public AnonymousPipeServerStream(System.IO.Pipes.PipeDirection direction, System.IO.HandleInheritability inheritability) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public AnonymousPipeServerStream(System.IO.Pipes.PipeDirection direction, System.IO.HandleInheritability inheritability, int bufferSize) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public AnonymousPipeServerStream(System.IO.Pipes.PipeDirection direction, Microsoft.Win32.SafeHandles.SafePipeHandle serverSafePipeHandle, Microsoft.Win32.SafeHandles.SafePipeHandle clientSafePipeHandle) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public Microsoft.Win32.SafeHandles.SafePipeHandle ClientSafePipeHandle { get => throw null; }
                protected override void Dispose(bool disposing) => throw null;
                public void DisposeLocalCopyOfClientHandle() => throw null;
                public string GetClientHandleAsString() => throw null;
                public override System.IO.Pipes.PipeTransmissionMode ReadMode { set => throw null; }
                public override System.IO.Pipes.PipeTransmissionMode TransmissionMode { get => throw null; }
                // ERR: Stub generator didn't handle member: ~AnonymousPipeServerStream
            }

            // Generated from `System.IO.Pipes.NamedPipeClientStream` in `System.IO.Pipes, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class NamedPipeClientStream : System.IO.Pipes.PipeStream
            {
                protected internal override void CheckPipePropertyOperations() => throw null;
                public void Connect() => throw null;
                public void Connect(int timeout) => throw null;
                public System.Threading.Tasks.Task ConnectAsync() => throw null;
                public System.Threading.Tasks.Task ConnectAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task ConnectAsync(int timeout) => throw null;
                public System.Threading.Tasks.Task ConnectAsync(int timeout, System.Threading.CancellationToken cancellationToken) => throw null;
                public NamedPipeClientStream(System.IO.Pipes.PipeDirection direction, bool isAsync, bool isConnected, Microsoft.Win32.SafeHandles.SafePipeHandle safePipeHandle) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public NamedPipeClientStream(string pipeName) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public NamedPipeClientStream(string serverName, string pipeName) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public NamedPipeClientStream(string serverName, string pipeName, System.IO.Pipes.PipeDirection direction) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public NamedPipeClientStream(string serverName, string pipeName, System.IO.Pipes.PipeDirection direction, System.IO.Pipes.PipeOptions options) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public NamedPipeClientStream(string serverName, string pipeName, System.IO.Pipes.PipeDirection direction, System.IO.Pipes.PipeOptions options, System.Security.Principal.TokenImpersonationLevel impersonationLevel) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public NamedPipeClientStream(string serverName, string pipeName, System.IO.Pipes.PipeDirection direction, System.IO.Pipes.PipeOptions options, System.Security.Principal.TokenImpersonationLevel impersonationLevel, System.IO.HandleInheritability inheritability) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public int NumberOfServerInstances { get => throw null; }
                // ERR: Stub generator didn't handle member: ~NamedPipeClientStream
            }

            // Generated from `System.IO.Pipes.NamedPipeServerStream` in `System.IO.Pipes, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class NamedPipeServerStream : System.IO.Pipes.PipeStream
            {
                public System.IAsyncResult BeginWaitForConnection(System.AsyncCallback callback, object state) => throw null;
                public void Disconnect() => throw null;
                public void EndWaitForConnection(System.IAsyncResult asyncResult) => throw null;
                public string GetImpersonationUserName() => throw null;
                public const int MaxAllowedServerInstances = default;
                public NamedPipeServerStream(System.IO.Pipes.PipeDirection direction, bool isAsync, bool isConnected, Microsoft.Win32.SafeHandles.SafePipeHandle safePipeHandle) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public NamedPipeServerStream(string pipeName) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public NamedPipeServerStream(string pipeName, System.IO.Pipes.PipeDirection direction) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public NamedPipeServerStream(string pipeName, System.IO.Pipes.PipeDirection direction, int maxNumberOfServerInstances) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public NamedPipeServerStream(string pipeName, System.IO.Pipes.PipeDirection direction, int maxNumberOfServerInstances, System.IO.Pipes.PipeTransmissionMode transmissionMode) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public NamedPipeServerStream(string pipeName, System.IO.Pipes.PipeDirection direction, int maxNumberOfServerInstances, System.IO.Pipes.PipeTransmissionMode transmissionMode, System.IO.Pipes.PipeOptions options) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public NamedPipeServerStream(string pipeName, System.IO.Pipes.PipeDirection direction, int maxNumberOfServerInstances, System.IO.Pipes.PipeTransmissionMode transmissionMode, System.IO.Pipes.PipeOptions options, int inBufferSize, int outBufferSize) : base(default(System.IO.Pipes.PipeDirection), default(int)) => throw null;
                public void RunAsClient(System.IO.Pipes.PipeStreamImpersonationWorker impersonationWorker) => throw null;
                public void WaitForConnection() => throw null;
                public System.Threading.Tasks.Task WaitForConnectionAsync() => throw null;
                public System.Threading.Tasks.Task WaitForConnectionAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                // ERR: Stub generator didn't handle member: ~NamedPipeServerStream
            }

            // Generated from `System.IO.Pipes.PipeDirection` in `System.IO.Pipes, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum PipeDirection
            {
                In,
                InOut,
                Out,
            }

            // Generated from `System.IO.Pipes.PipeOptions` in `System.IO.Pipes, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum PipeOptions
            {
                Asynchronous,
                CurrentUserOnly,
                None,
                WriteThrough,
            }

            // Generated from `System.IO.Pipes.PipeStream` in `System.IO.Pipes, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class PipeStream : System.IO.Stream
            {
                public override System.IAsyncResult BeginRead(System.Byte[] buffer, int offset, int count, System.AsyncCallback callback, object state) => throw null;
                public override System.IAsyncResult BeginWrite(System.Byte[] buffer, int offset, int count, System.AsyncCallback callback, object state) => throw null;
                public override bool CanRead { get => throw null; }
                public override bool CanSeek { get => throw null; }
                public override bool CanWrite { get => throw null; }
                protected internal virtual void CheckPipePropertyOperations() => throw null;
                protected internal void CheckReadOperations() => throw null;
                protected internal void CheckWriteOperations() => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override int EndRead(System.IAsyncResult asyncResult) => throw null;
                public override void EndWrite(System.IAsyncResult asyncResult) => throw null;
                public override void Flush() => throw null;
                public override System.Threading.Tasks.Task FlushAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public virtual int InBufferSize { get => throw null; }
                protected void InitializeHandle(Microsoft.Win32.SafeHandles.SafePipeHandle handle, bool isExposed, bool isAsync) => throw null;
                public bool IsAsync { get => throw null; }
                public bool IsConnected { get => throw null; set => throw null; }
                protected bool IsHandleExposed { get => throw null; }
                public bool IsMessageComplete { get => throw null; }
                public override System.Int64 Length { get => throw null; }
                public virtual int OutBufferSize { get => throw null; }
                protected PipeStream(System.IO.Pipes.PipeDirection direction, System.IO.Pipes.PipeTransmissionMode transmissionMode, int outBufferSize) => throw null;
                protected PipeStream(System.IO.Pipes.PipeDirection direction, int bufferSize) => throw null;
                public override System.Int64 Position { get => throw null; set => throw null; }
                public override int Read(System.Byte[] buffer, int offset, int count) => throw null;
                public override int Read(System.Span<System.Byte> buffer) => throw null;
                public override System.Threading.Tasks.Task<int> ReadAsync(System.Byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.ValueTask<int> ReadAsync(System.Memory<System.Byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override int ReadByte() => throw null;
                public virtual System.IO.Pipes.PipeTransmissionMode ReadMode { get => throw null; set => throw null; }
                public Microsoft.Win32.SafeHandles.SafePipeHandle SafePipeHandle { get => throw null; }
                public override System.Int64 Seek(System.Int64 offset, System.IO.SeekOrigin origin) => throw null;
                public override void SetLength(System.Int64 value) => throw null;
                public virtual System.IO.Pipes.PipeTransmissionMode TransmissionMode { get => throw null; }
                public void WaitForPipeDrain() => throw null;
                public override void Write(System.Byte[] buffer, int offset, int count) => throw null;
                public override void Write(System.ReadOnlySpan<System.Byte> buffer) => throw null;
                public override System.Threading.Tasks.Task WriteAsync(System.Byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.ValueTask WriteAsync(System.ReadOnlyMemory<System.Byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override void WriteByte(System.Byte value) => throw null;
            }

            // Generated from `System.IO.Pipes.PipeStreamImpersonationWorker` in `System.IO.Pipes, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public delegate void PipeStreamImpersonationWorker();

            // Generated from `System.IO.Pipes.PipeTransmissionMode` in `System.IO.Pipes, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum PipeTransmissionMode
            {
                Byte,
                Message,
            }

        }
    }
}
