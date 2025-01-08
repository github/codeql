using System.Reflection;
using System.Threading;
using Xunit.Runners;
using System;


/// <summary>
/// A testrunner for xunit tests we can use with bazel.
/// This file is compiled as part of each test target, due to limitations of the bazel `csharp_test`
/// target: It cannot pull in the main method from a different target.
/// Note: We're running the tests in parallel, which currently goes counter to the bazel execution model,
/// as bazel doesn't expect us to spawm more than one active thread. This for now works fine in practice,
/// as the tests finish quickly. If this ever becomes a problem, we need to implement the bazel sharding protocol explicitly.
/// </summary>
public class Testrunner
{
    private static readonly Lock ConsoleLock = new();

    private static readonly ManualResetEvent Finished = new(false);

    private static int Result = 0;

    private void OnDiscoveryComplete(DiscoveryCompleteInfo info)
    {
        lock (ConsoleLock)
            Console.WriteLine($"Running {info.TestCasesToRun} of {info.TestCasesDiscovered} tests...");
    }

    private void OnExecutionComplete(ExecutionCompleteInfo info)
    {
        lock (ConsoleLock)
            Console.WriteLine($"Finished: {info.TotalTests} tests in {Math.Round(info.ExecutionTime, 3)}s ({info.TestsFailed} failed, {info.TestsSkipped} skipped)");

        Finished.Set();
    }

    private void OnTestFailed(TestFailedInfo info)
    {
        lock (ConsoleLock)
        {
            Console.ForegroundColor = ConsoleColor.Red;

            Console.WriteLine($"[FAIL] {info.TestDisplayName}: {info.ExceptionMessage}");
            if (info.ExceptionStackTrace != null)
                Console.WriteLine(info.ExceptionStackTrace);

            Console.ResetColor();
        }

        Result = 1;
    }

    private void OnTestSkipped(TestSkippedInfo info)
    {
        lock (ConsoleLock)
        {
            Console.ForegroundColor = ConsoleColor.Yellow;
            Console.WriteLine($"[SKIP] {info.TestDisplayName}: {info.SkipReason}");
            Console.ResetColor();
        }
    }

    public int RunTests()
    {
        var assembly = Assembly.GetExecutingAssembly();
        using (var testrunner = AssemblyRunner.WithoutAppDomain(assembly.Location))
        {
            testrunner.OnDiscoveryComplete = OnDiscoveryComplete;
            testrunner.OnExecutionComplete = OnExecutionComplete;
            testrunner.OnTestFailed = OnTestFailed;
            testrunner.OnTestSkipped = OnTestSkipped;

            Console.WriteLine("Discovering tests...");
            testrunner.Start();

            Finished.WaitOne();
            Finished.Dispose();

            // Wait for assembly runner to finish.
            // If we try to dispose while runner is executing,
            // it will throw an error.
            while (testrunner.Status != AssemblyRunnerStatus.Idle)
                Thread.Sleep(100);
        }
        return Result;
    }

    public static int Main(string[] args)
    {
        return new Testrunner().RunTests();
    }
}
