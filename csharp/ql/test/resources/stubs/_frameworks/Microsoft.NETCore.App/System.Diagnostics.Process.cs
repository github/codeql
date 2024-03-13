// This file contains auto-generated code.
// Generated from `System.Diagnostics.Process, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace Microsoft
{
    namespace Win32
    {
        namespace SafeHandles
        {
            public sealed class SafeProcessHandle : Microsoft.Win32.SafeHandles.SafeHandleZeroOrMinusOneIsInvalid
            {
                public SafeProcessHandle() : base(default(bool)) => throw null;
                public SafeProcessHandle(nint existingHandle, bool ownsHandle) : base(default(bool)) => throw null;
                protected override bool ReleaseHandle() => throw null;
            }
        }
    }
}
namespace System
{
    namespace Diagnostics
    {
        public class DataReceivedEventArgs : System.EventArgs
        {
            public string Data { get => throw null; }
        }
        public delegate void DataReceivedEventHandler(object sender, System.Diagnostics.DataReceivedEventArgs e);
        [System.AttributeUsage((System.AttributeTargets)32767)]
        public class MonitoringDescriptionAttribute : System.ComponentModel.DescriptionAttribute
        {
            public MonitoringDescriptionAttribute(string description) => throw null;
            public override string Description { get => throw null; }
        }
        public class Process : System.ComponentModel.Component, System.IDisposable
        {
            public int BasePriority { get => throw null; }
            public void BeginErrorReadLine() => throw null;
            public void BeginOutputReadLine() => throw null;
            public void CancelErrorRead() => throw null;
            public void CancelOutputRead() => throw null;
            public void Close() => throw null;
            public bool CloseMainWindow() => throw null;
            public Process() => throw null;
            protected override void Dispose(bool disposing) => throw null;
            public bool EnableRaisingEvents { get => throw null; set { } }
            public static void EnterDebugMode() => throw null;
            public event System.Diagnostics.DataReceivedEventHandler ErrorDataReceived;
            public int ExitCode { get => throw null; }
            public event System.EventHandler Exited;
            public System.DateTime ExitTime { get => throw null; }
            public static System.Diagnostics.Process GetCurrentProcess() => throw null;
            public static System.Diagnostics.Process GetProcessById(int processId) => throw null;
            public static System.Diagnostics.Process GetProcessById(int processId, string machineName) => throw null;
            public static System.Diagnostics.Process[] GetProcesses() => throw null;
            public static System.Diagnostics.Process[] GetProcesses(string machineName) => throw null;
            public static System.Diagnostics.Process[] GetProcessesByName(string processName) => throw null;
            public static System.Diagnostics.Process[] GetProcessesByName(string processName, string machineName) => throw null;
            public nint Handle { get => throw null; }
            public int HandleCount { get => throw null; }
            public bool HasExited { get => throw null; }
            public int Id { get => throw null; }
            public void Kill() => throw null;
            public void Kill(bool entireProcessTree) => throw null;
            public static void LeaveDebugMode() => throw null;
            public string MachineName { get => throw null; }
            public System.Diagnostics.ProcessModule MainModule { get => throw null; }
            public nint MainWindowHandle { get => throw null; }
            public string MainWindowTitle { get => throw null; }
            public nint MaxWorkingSet { get => throw null; set { } }
            public nint MinWorkingSet { get => throw null; set { } }
            public System.Diagnostics.ProcessModuleCollection Modules { get => throw null; }
            public int NonpagedSystemMemorySize { get => throw null; }
            public long NonpagedSystemMemorySize64 { get => throw null; }
            protected void OnExited() => throw null;
            public event System.Diagnostics.DataReceivedEventHandler OutputDataReceived;
            public int PagedMemorySize { get => throw null; }
            public long PagedMemorySize64 { get => throw null; }
            public int PagedSystemMemorySize { get => throw null; }
            public long PagedSystemMemorySize64 { get => throw null; }
            public int PeakPagedMemorySize { get => throw null; }
            public long PeakPagedMemorySize64 { get => throw null; }
            public int PeakVirtualMemorySize { get => throw null; }
            public long PeakVirtualMemorySize64 { get => throw null; }
            public int PeakWorkingSet { get => throw null; }
            public long PeakWorkingSet64 { get => throw null; }
            public bool PriorityBoostEnabled { get => throw null; set { } }
            public System.Diagnostics.ProcessPriorityClass PriorityClass { get => throw null; set { } }
            public int PrivateMemorySize { get => throw null; }
            public long PrivateMemorySize64 { get => throw null; }
            public System.TimeSpan PrivilegedProcessorTime { get => throw null; }
            public string ProcessName { get => throw null; }
            public nint ProcessorAffinity { get => throw null; set { } }
            public void Refresh() => throw null;
            public bool Responding { get => throw null; }
            public Microsoft.Win32.SafeHandles.SafeProcessHandle SafeHandle { get => throw null; }
            public int SessionId { get => throw null; }
            public System.IO.StreamReader StandardError { get => throw null; }
            public System.IO.StreamWriter StandardInput { get => throw null; }
            public System.IO.StreamReader StandardOutput { get => throw null; }
            public bool Start() => throw null;
            public static System.Diagnostics.Process Start(System.Diagnostics.ProcessStartInfo startInfo) => throw null;
            public static System.Diagnostics.Process Start(string fileName) => throw null;
            public static System.Diagnostics.Process Start(string fileName, string arguments) => throw null;
            public static System.Diagnostics.Process Start(string fileName, System.Collections.Generic.IEnumerable<string> arguments) => throw null;
            public static System.Diagnostics.Process Start(string fileName, string userName, System.Security.SecureString password, string domain) => throw null;
            public static System.Diagnostics.Process Start(string fileName, string arguments, string userName, System.Security.SecureString password, string domain) => throw null;
            public System.Diagnostics.ProcessStartInfo StartInfo { get => throw null; set { } }
            public System.DateTime StartTime { get => throw null; }
            public System.ComponentModel.ISynchronizeInvoke SynchronizingObject { get => throw null; set { } }
            public System.Diagnostics.ProcessThreadCollection Threads { get => throw null; }
            public override string ToString() => throw null;
            public System.TimeSpan TotalProcessorTime { get => throw null; }
            public System.TimeSpan UserProcessorTime { get => throw null; }
            public int VirtualMemorySize { get => throw null; }
            public long VirtualMemorySize64 { get => throw null; }
            public void WaitForExit() => throw null;
            public bool WaitForExit(int milliseconds) => throw null;
            public bool WaitForExit(System.TimeSpan timeout) => throw null;
            public System.Threading.Tasks.Task WaitForExitAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public bool WaitForInputIdle() => throw null;
            public bool WaitForInputIdle(int milliseconds) => throw null;
            public bool WaitForInputIdle(System.TimeSpan timeout) => throw null;
            public int WorkingSet { get => throw null; }
            public long WorkingSet64 { get => throw null; }
        }
        public class ProcessModule : System.ComponentModel.Component
        {
            public nint BaseAddress { get => throw null; }
            public nint EntryPointAddress { get => throw null; }
            public string FileName { get => throw null; }
            public System.Diagnostics.FileVersionInfo FileVersionInfo { get => throw null; }
            public int ModuleMemorySize { get => throw null; }
            public string ModuleName { get => throw null; }
            public override string ToString() => throw null;
        }
        public class ProcessModuleCollection : System.Collections.ReadOnlyCollectionBase
        {
            public bool Contains(System.Diagnostics.ProcessModule module) => throw null;
            public void CopyTo(System.Diagnostics.ProcessModule[] array, int index) => throw null;
            protected ProcessModuleCollection() => throw null;
            public ProcessModuleCollection(System.Diagnostics.ProcessModule[] processModules) => throw null;
            public int IndexOf(System.Diagnostics.ProcessModule module) => throw null;
            public System.Diagnostics.ProcessModule this[int index] { get => throw null; }
        }
        public enum ProcessPriorityClass
        {
            Normal = 32,
            Idle = 64,
            High = 128,
            RealTime = 256,
            BelowNormal = 16384,
            AboveNormal = 32768,
        }
        public sealed class ProcessStartInfo
        {
            public System.Collections.ObjectModel.Collection<string> ArgumentList { get => throw null; }
            public string Arguments { get => throw null; set { } }
            public bool CreateNoWindow { get => throw null; set { } }
            public ProcessStartInfo() => throw null;
            public ProcessStartInfo(string fileName) => throw null;
            public ProcessStartInfo(string fileName, string arguments) => throw null;
            public ProcessStartInfo(string fileName, System.Collections.Generic.IEnumerable<string> arguments) => throw null;
            public string Domain { get => throw null; set { } }
            public System.Collections.Generic.IDictionary<string, string> Environment { get => throw null; }
            public System.Collections.Specialized.StringDictionary EnvironmentVariables { get => throw null; }
            public bool ErrorDialog { get => throw null; set { } }
            public nint ErrorDialogParentHandle { get => throw null; set { } }
            public string FileName { get => throw null; set { } }
            public bool LoadUserProfile { get => throw null; set { } }
            public System.Security.SecureString Password { get => throw null; set { } }
            public string PasswordInClearText { get => throw null; set { } }
            public bool RedirectStandardError { get => throw null; set { } }
            public bool RedirectStandardInput { get => throw null; set { } }
            public bool RedirectStandardOutput { get => throw null; set { } }
            public System.Text.Encoding StandardErrorEncoding { get => throw null; set { } }
            public System.Text.Encoding StandardInputEncoding { get => throw null; set { } }
            public System.Text.Encoding StandardOutputEncoding { get => throw null; set { } }
            public bool UseCredentialsForNetworkingOnly { get => throw null; set { } }
            public string UserName { get => throw null; set { } }
            public bool UseShellExecute { get => throw null; set { } }
            public string Verb { get => throw null; set { } }
            public string[] Verbs { get => throw null; }
            public System.Diagnostics.ProcessWindowStyle WindowStyle { get => throw null; set { } }
            public string WorkingDirectory { get => throw null; set { } }
        }
        public class ProcessThread : System.ComponentModel.Component
        {
            public int BasePriority { get => throw null; }
            public int CurrentPriority { get => throw null; }
            public int Id { get => throw null; }
            public int IdealProcessor { set { } }
            public bool PriorityBoostEnabled { get => throw null; set { } }
            public System.Diagnostics.ThreadPriorityLevel PriorityLevel { get => throw null; set { } }
            public System.TimeSpan PrivilegedProcessorTime { get => throw null; }
            public nint ProcessorAffinity { set { } }
            public void ResetIdealProcessor() => throw null;
            public nint StartAddress { get => throw null; }
            public System.DateTime StartTime { get => throw null; }
            public System.Diagnostics.ThreadState ThreadState { get => throw null; }
            public System.TimeSpan TotalProcessorTime { get => throw null; }
            public System.TimeSpan UserProcessorTime { get => throw null; }
            public System.Diagnostics.ThreadWaitReason WaitReason { get => throw null; }
        }
        public class ProcessThreadCollection : System.Collections.ReadOnlyCollectionBase
        {
            public int Add(System.Diagnostics.ProcessThread thread) => throw null;
            public bool Contains(System.Diagnostics.ProcessThread thread) => throw null;
            public void CopyTo(System.Diagnostics.ProcessThread[] array, int index) => throw null;
            protected ProcessThreadCollection() => throw null;
            public ProcessThreadCollection(System.Diagnostics.ProcessThread[] processThreads) => throw null;
            public int IndexOf(System.Diagnostics.ProcessThread thread) => throw null;
            public void Insert(int index, System.Diagnostics.ProcessThread thread) => throw null;
            public void Remove(System.Diagnostics.ProcessThread thread) => throw null;
            public System.Diagnostics.ProcessThread this[int index] { get => throw null; }
        }
        public enum ProcessWindowStyle
        {
            Normal = 0,
            Hidden = 1,
            Minimized = 2,
            Maximized = 3,
        }
        public enum ThreadPriorityLevel
        {
            Idle = -15,
            Lowest = -2,
            BelowNormal = -1,
            Normal = 0,
            AboveNormal = 1,
            Highest = 2,
            TimeCritical = 15,
        }
        public enum ThreadState
        {
            Initialized = 0,
            Ready = 1,
            Running = 2,
            Standby = 3,
            Terminated = 4,
            Wait = 5,
            Transition = 6,
            Unknown = 7,
        }
        public enum ThreadWaitReason
        {
            Executive = 0,
            FreePage = 1,
            PageIn = 2,
            SystemAllocation = 3,
            ExecutionDelay = 4,
            Suspended = 5,
            UserRequest = 6,
            EventPairHigh = 7,
            EventPairLow = 8,
            LpcReceive = 9,
            LpcReply = 10,
            VirtualMemory = 11,
            PageOut = 12,
            Unknown = 13,
        }
    }
}
