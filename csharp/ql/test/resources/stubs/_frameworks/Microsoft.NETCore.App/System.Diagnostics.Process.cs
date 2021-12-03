// This file contains auto-generated code.

namespace Microsoft
{
    namespace Win32
    {
        namespace SafeHandles
        {
            // Generated from `Microsoft.Win32.SafeHandles.SafeProcessHandle` in `System.Diagnostics.Process, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SafeProcessHandle : Microsoft.Win32.SafeHandles.SafeHandleZeroOrMinusOneIsInvalid
            {
                protected override bool ReleaseHandle() => throw null;
                public SafeProcessHandle(System.IntPtr existingHandle, bool ownsHandle) : base(default(bool)) => throw null;
            }

        }
    }
}
namespace System
{
    namespace Diagnostics
    {
        // Generated from `System.Diagnostics.DataReceivedEventArgs` in `System.Diagnostics.Process, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DataReceivedEventArgs : System.EventArgs
        {
            public string Data { get => throw null; }
        }

        // Generated from `System.Diagnostics.DataReceivedEventHandler` in `System.Diagnostics.Process, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public delegate void DataReceivedEventHandler(object sender, System.Diagnostics.DataReceivedEventArgs e);

        // Generated from `System.Diagnostics.MonitoringDescriptionAttribute` in `System.Diagnostics.Process, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class MonitoringDescriptionAttribute : System.ComponentModel.DescriptionAttribute
        {
            public override string Description { get => throw null; }
            public MonitoringDescriptionAttribute(string description) => throw null;
        }

        // Generated from `System.Diagnostics.Process` in `System.Diagnostics.Process, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class Process : System.ComponentModel.Component, System.IDisposable
        {
            public int BasePriority { get => throw null; }
            public void BeginErrorReadLine() => throw null;
            public void BeginOutputReadLine() => throw null;
            public void CancelErrorRead() => throw null;
            public void CancelOutputRead() => throw null;
            public void Close() => throw null;
            public bool CloseMainWindow() => throw null;
            protected override void Dispose(bool disposing) => throw null;
            public bool EnableRaisingEvents { get => throw null; set => throw null; }
            public static void EnterDebugMode() => throw null;
            public event System.Diagnostics.DataReceivedEventHandler ErrorDataReceived;
            public int ExitCode { get => throw null; }
            public System.DateTime ExitTime { get => throw null; }
            public event System.EventHandler Exited;
            public static System.Diagnostics.Process GetCurrentProcess() => throw null;
            public static System.Diagnostics.Process GetProcessById(int processId) => throw null;
            public static System.Diagnostics.Process GetProcessById(int processId, string machineName) => throw null;
            public static System.Diagnostics.Process[] GetProcesses() => throw null;
            public static System.Diagnostics.Process[] GetProcesses(string machineName) => throw null;
            public static System.Diagnostics.Process[] GetProcessesByName(string processName) => throw null;
            public static System.Diagnostics.Process[] GetProcessesByName(string processName, string machineName) => throw null;
            public System.IntPtr Handle { get => throw null; }
            public int HandleCount { get => throw null; }
            public bool HasExited { get => throw null; }
            public int Id { get => throw null; }
            public void Kill() => throw null;
            public void Kill(bool entireProcessTree) => throw null;
            public static void LeaveDebugMode() => throw null;
            public string MachineName { get => throw null; }
            public System.Diagnostics.ProcessModule MainModule { get => throw null; }
            public System.IntPtr MainWindowHandle { get => throw null; }
            public string MainWindowTitle { get => throw null; }
            public System.IntPtr MaxWorkingSet { get => throw null; set => throw null; }
            public System.IntPtr MinWorkingSet { get => throw null; set => throw null; }
            public System.Diagnostics.ProcessModuleCollection Modules { get => throw null; }
            public int NonpagedSystemMemorySize { get => throw null; }
            public System.Int64 NonpagedSystemMemorySize64 { get => throw null; }
            protected void OnExited() => throw null;
            public event System.Diagnostics.DataReceivedEventHandler OutputDataReceived;
            public int PagedMemorySize { get => throw null; }
            public System.Int64 PagedMemorySize64 { get => throw null; }
            public int PagedSystemMemorySize { get => throw null; }
            public System.Int64 PagedSystemMemorySize64 { get => throw null; }
            public int PeakPagedMemorySize { get => throw null; }
            public System.Int64 PeakPagedMemorySize64 { get => throw null; }
            public int PeakVirtualMemorySize { get => throw null; }
            public System.Int64 PeakVirtualMemorySize64 { get => throw null; }
            public int PeakWorkingSet { get => throw null; }
            public System.Int64 PeakWorkingSet64 { get => throw null; }
            public bool PriorityBoostEnabled { get => throw null; set => throw null; }
            public System.Diagnostics.ProcessPriorityClass PriorityClass { get => throw null; set => throw null; }
            public int PrivateMemorySize { get => throw null; }
            public System.Int64 PrivateMemorySize64 { get => throw null; }
            public System.TimeSpan PrivilegedProcessorTime { get => throw null; }
            public Process() => throw null;
            public string ProcessName { get => throw null; }
            public System.IntPtr ProcessorAffinity { get => throw null; set => throw null; }
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
            public static System.Diagnostics.Process Start(string fileName, System.Collections.Generic.IEnumerable<string> arguments) => throw null;
            public static System.Diagnostics.Process Start(string fileName, string arguments) => throw null;
            public static System.Diagnostics.Process Start(string fileName, string userName, System.Security.SecureString password, string domain) => throw null;
            public static System.Diagnostics.Process Start(string fileName, string arguments, string userName, System.Security.SecureString password, string domain) => throw null;
            public System.Diagnostics.ProcessStartInfo StartInfo { get => throw null; set => throw null; }
            public System.DateTime StartTime { get => throw null; }
            public System.ComponentModel.ISynchronizeInvoke SynchronizingObject { get => throw null; set => throw null; }
            public System.Diagnostics.ProcessThreadCollection Threads { get => throw null; }
            public override string ToString() => throw null;
            public System.TimeSpan TotalProcessorTime { get => throw null; }
            public System.TimeSpan UserProcessorTime { get => throw null; }
            public int VirtualMemorySize { get => throw null; }
            public System.Int64 VirtualMemorySize64 { get => throw null; }
            public void WaitForExit() => throw null;
            public bool WaitForExit(int milliseconds) => throw null;
            public System.Threading.Tasks.Task WaitForExitAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public bool WaitForInputIdle() => throw null;
            public bool WaitForInputIdle(int milliseconds) => throw null;
            public int WorkingSet { get => throw null; }
            public System.Int64 WorkingSet64 { get => throw null; }
        }

        // Generated from `System.Diagnostics.ProcessModule` in `System.Diagnostics.Process, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ProcessModule : System.ComponentModel.Component
        {
            public System.IntPtr BaseAddress { get => throw null; }
            public System.IntPtr EntryPointAddress { get => throw null; }
            public string FileName { get => throw null; }
            public System.Diagnostics.FileVersionInfo FileVersionInfo { get => throw null; }
            public int ModuleMemorySize { get => throw null; }
            public string ModuleName { get => throw null; }
            public override string ToString() => throw null;
        }

        // Generated from `System.Diagnostics.ProcessModuleCollection` in `System.Diagnostics.Process, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ProcessModuleCollection : System.Collections.ReadOnlyCollectionBase
        {
            public bool Contains(System.Diagnostics.ProcessModule module) => throw null;
            public void CopyTo(System.Diagnostics.ProcessModule[] array, int index) => throw null;
            public int IndexOf(System.Diagnostics.ProcessModule module) => throw null;
            public System.Diagnostics.ProcessModule this[int index] { get => throw null; }
            protected ProcessModuleCollection() => throw null;
            public ProcessModuleCollection(System.Diagnostics.ProcessModule[] processModules) => throw null;
        }

        // Generated from `System.Diagnostics.ProcessPriorityClass` in `System.Diagnostics.Process, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum ProcessPriorityClass
        {
            AboveNormal,
            BelowNormal,
            High,
            Idle,
            Normal,
            RealTime,
        }

        // Generated from `System.Diagnostics.ProcessStartInfo` in `System.Diagnostics.Process, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ProcessStartInfo
        {
            public System.Collections.ObjectModel.Collection<string> ArgumentList { get => throw null; }
            public string Arguments { get => throw null; set => throw null; }
            public bool CreateNoWindow { get => throw null; set => throw null; }
            public string Domain { get => throw null; set => throw null; }
            public System.Collections.Generic.IDictionary<string, string> Environment { get => throw null; }
            public System.Collections.Specialized.StringDictionary EnvironmentVariables { get => throw null; }
            public bool ErrorDialog { get => throw null; set => throw null; }
            public System.IntPtr ErrorDialogParentHandle { get => throw null; set => throw null; }
            public string FileName { get => throw null; set => throw null; }
            public bool LoadUserProfile { get => throw null; set => throw null; }
            public System.Security.SecureString Password { get => throw null; set => throw null; }
            public string PasswordInClearText { get => throw null; set => throw null; }
            public ProcessStartInfo() => throw null;
            public ProcessStartInfo(string fileName) => throw null;
            public ProcessStartInfo(string fileName, string arguments) => throw null;
            public bool RedirectStandardError { get => throw null; set => throw null; }
            public bool RedirectStandardInput { get => throw null; set => throw null; }
            public bool RedirectStandardOutput { get => throw null; set => throw null; }
            public System.Text.Encoding StandardErrorEncoding { get => throw null; set => throw null; }
            public System.Text.Encoding StandardInputEncoding { get => throw null; set => throw null; }
            public System.Text.Encoding StandardOutputEncoding { get => throw null; set => throw null; }
            public bool UseShellExecute { get => throw null; set => throw null; }
            public string UserName { get => throw null; set => throw null; }
            public string Verb { get => throw null; set => throw null; }
            public string[] Verbs { get => throw null; }
            public System.Diagnostics.ProcessWindowStyle WindowStyle { get => throw null; set => throw null; }
            public string WorkingDirectory { get => throw null; set => throw null; }
        }

        // Generated from `System.Diagnostics.ProcessThread` in `System.Diagnostics.Process, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ProcessThread : System.ComponentModel.Component
        {
            public int BasePriority { get => throw null; }
            public int CurrentPriority { get => throw null; }
            public int Id { get => throw null; }
            public int IdealProcessor { set => throw null; }
            public bool PriorityBoostEnabled { get => throw null; set => throw null; }
            public System.Diagnostics.ThreadPriorityLevel PriorityLevel { get => throw null; set => throw null; }
            public System.TimeSpan PrivilegedProcessorTime { get => throw null; }
            public System.IntPtr ProcessorAffinity { set => throw null; }
            public void ResetIdealProcessor() => throw null;
            public System.IntPtr StartAddress { get => throw null; }
            public System.DateTime StartTime { get => throw null; }
            public System.Diagnostics.ThreadState ThreadState { get => throw null; }
            public System.TimeSpan TotalProcessorTime { get => throw null; }
            public System.TimeSpan UserProcessorTime { get => throw null; }
            public System.Diagnostics.ThreadWaitReason WaitReason { get => throw null; }
        }

        // Generated from `System.Diagnostics.ProcessThreadCollection` in `System.Diagnostics.Process, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ProcessThreadCollection : System.Collections.ReadOnlyCollectionBase
        {
            public int Add(System.Diagnostics.ProcessThread thread) => throw null;
            public bool Contains(System.Diagnostics.ProcessThread thread) => throw null;
            public void CopyTo(System.Diagnostics.ProcessThread[] array, int index) => throw null;
            public int IndexOf(System.Diagnostics.ProcessThread thread) => throw null;
            public void Insert(int index, System.Diagnostics.ProcessThread thread) => throw null;
            public System.Diagnostics.ProcessThread this[int index] { get => throw null; }
            protected ProcessThreadCollection() => throw null;
            public ProcessThreadCollection(System.Diagnostics.ProcessThread[] processThreads) => throw null;
            public void Remove(System.Diagnostics.ProcessThread thread) => throw null;
        }

        // Generated from `System.Diagnostics.ProcessWindowStyle` in `System.Diagnostics.Process, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum ProcessWindowStyle
        {
            Hidden,
            Maximized,
            Minimized,
            Normal,
        }

        // Generated from `System.Diagnostics.ThreadPriorityLevel` in `System.Diagnostics.Process, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum ThreadPriorityLevel
        {
            AboveNormal,
            BelowNormal,
            Highest,
            Idle,
            Lowest,
            Normal,
            TimeCritical,
        }

        // Generated from `System.Diagnostics.ThreadState` in `System.Diagnostics.Process, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum ThreadState
        {
            Initialized,
            Ready,
            Running,
            Standby,
            Terminated,
            Transition,
            Unknown,
            Wait,
        }

        // Generated from `System.Diagnostics.ThreadWaitReason` in `System.Diagnostics.Process, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum ThreadWaitReason
        {
            EventPairHigh,
            EventPairLow,
            ExecutionDelay,
            Executive,
            FreePage,
            LpcReceive,
            LpcReply,
            PageIn,
            PageOut,
            Suspended,
            SystemAllocation,
            Unknown,
            UserRequest,
            VirtualMemory,
        }

    }
}
