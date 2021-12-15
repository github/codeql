using System;
using System.Runtime.InteropServices;
using System.Text;

namespace System.IO
{
    public class File
    {
        public static DateTime GetLastWriteTime(string s)
        {
            return new DateTime(DateTime.MaxValue.Ticks);
        }
    }
}

namespace System.Diagnostics
{
    public class Process
    {
        public static string GetCurrentProcess() { return "test"; }
    }
}

class External {
    [DllImport("advapi32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool InitiateSystemShutdownExW([In] string lpMachineName, [In] string lpMessage, [In] uint dwTimeout, [MarshalAs(UnmanagedType.Bool)][In] bool bForceAppsClosed, [MarshalAs(UnmanagedType.Bool)][In] bool bRebootAfterShutdown, [In] uint dwReason);

    void TestDangerousNativeFunctionCall()
    {
        InitiateSystemShutdownExW(null, null, 0U, true, true, 2147745794U); // BUG : DangerousNativeFunctionCall
    }

    ulong GetFvnHash(string s)
    {
        ulong num = 14695981039346656037UL; /* FNV base offset */
        try
        {
            foreach (byte b in Encoding.UTF8.GetBytes(s))
            {
                num ^= (ulong)b;
                num *= 1099511628211UL; /* FNV prime */
            }
        }
        catch
        {
        }
        // regular FVN
        return num; 
    }

    void IndirectTestProcessNameToHashTaintFlow( string s)
    {
        GetFvnHash(s); // BUG : ProcessNameToHashTaintFlow
    }

    void TestProcessNameToHashTaintFlow()
    {
        GetFvnHash( System.Diagnostics.Process.GetCurrentProcess() ); // BUG : ProcessNameToHashTaintFlow

        string proc = System.Diagnostics.Process.GetCurrentProcess();

        IndirectTestProcessNameToHashTaintFlow( proc );
    }

    void TestTimeBomb() 
    {
        DateTime lastWriteTime = System.IO.File.GetLastWriteTime("someFile");
        int num = new Random().Next(288, 336);
        if (DateTime.Now.CompareTo(lastWriteTime.AddHours((double)num)) >= 0) // BUG : Potential time bomb
        {
            // Some code here
        }
    }

}