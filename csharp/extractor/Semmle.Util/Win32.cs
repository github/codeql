using Microsoft.Win32.SafeHandles;
using System;
using System.Runtime.InteropServices;
using System.Text;

namespace Semmle.Util
{
    /// <summary>
    /// Holder for various Win32 functions.
    /// </summary>
    public static class Win32
    {
        [DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
        public static extern int GetFinalPathNameByHandle(  // lgtm[cs/unmanaged-code]
            SafeHandle handle,
            [In, Out] StringBuilder path,
            int bufLen,
            int flags);

        [DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
        public static extern SafeFileHandle CreateFile(  // lgtm[cs/unmanaged-code]
            string filename,
            uint desiredAccess,
            uint shareMode,
            IntPtr securityAttributes,
            uint creationDisposition,
            uint flags,
            IntPtr hTemplateFile);

        /// <summary>
        /// Is the system Windows, and should we use kernel32.dll?
        /// </summary>
        /// <returns>If it's Windows.</returns>
        public static bool IsWindows()
        {
            switch ((int)Environment.OSVersion.Platform)
            {
                // See: http://www.mono-project.com/docs/faq/technical/#how-to-detect-the-execution-platform

                case 4:
                case 6:
                case 128:
                    // Running on Unix
                    return false;
                default:
                    // Running on Windows
                    return true;
            }
        }

        public const int ERROR_FILE_NOT_FOUND = 0x02;
        public const int ERROR_PATH_NOT_FOUND = 0x03;
        public const int ERROR_ALREADY_EXISTS = 0xb7;

        public const uint FILE_SHARE_READ = 1;
        public const uint FILE_SHARE_WRITE = 2;
        public const uint FILE_SHARE_DELETE = 4;

        public const uint FILE_ATTRIBUTE_READONLY = 1;
        public const uint FILE_ATTRIBUTE_NORMAL = 128;
        public const uint FILE_FLAG_BACKUP_SEMANTICS = 0x02000000;
        public const int INVALID_HANDLE_VALUE = -1;
        public const int MAX_PATH = 260;

        public const uint GENERIC_READ = 0x80000000;
        public const uint GENERIC_WRITE = 0x40000000;

        public const uint CREATE_ALWAYS = 2;
        public const uint CREATE_NEW = 1;
        public const uint OPEN_ALWAYS = 4;
        public const uint OPEN_EXISTING = 3;
        public const uint TRUNCATE_EXISTING = 5;

        public const int MOVEFILE_REPLACE_EXISTING = 1;
        public const int MOVEFILE_COPY_ALLOWED = 2;
        public const uint INVALID_FILE_ATTRIBUTES = 0xffffffff;
    }
}
