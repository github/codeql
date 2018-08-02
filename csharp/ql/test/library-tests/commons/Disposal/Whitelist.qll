/** Provides a simple whitelist for ignoring results. */

import dotnet

/** Holds if `type` is platform-specific. */
predicate whitelistedType(DotNet::Type type) {
  exists(string qn | qn = type.getQualifiedName() |
    qn = "System.Net.Http.WinHttpHandler" or
    qn.matches("Microsoft.Win32%") or
    qn = "System.ConsolePal.UnixConsoleStream" or
    qn = "System.Globalization.CompareInfo" or
    qn = "System.IO.FileSystemEnumerableIterator" or
    qn.matches("System.IO.FileStream%") or
    qn.matches("System.Net.Http.CurlHandler%") or
    qn = "System.Net.Http.HttpClientHandler" or
    qn.matches("System.Net.Http.WinHttp%")
  )
}
