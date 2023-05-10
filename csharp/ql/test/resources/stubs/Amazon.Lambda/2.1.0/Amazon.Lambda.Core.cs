
using System.Collections.Generic;

namespace Amazon.Lambda.Core
{
    public interface ILambdaContext
    {
        string AwsRequestId { get; }

        IClientContext ClientContext { get; }

        string FunctionName { get; }

        string FunctionVersion { get; }

        string InvokedFunctionArn { get; }

        ILambdaLogger Logger { get; }

        string LogGroupName { get; }

        string LogStreamName { get; }

        int MemoryLimitInMB { get; }
    }

    public interface IClientContext
    {
        IDictionary<string, string> Environment { get; }

        IClientApplication Client { get; }

        IDictionary<string, string> Custom { get; }
    }

    public interface IClientApplication
    {
        string AppPackageName { get; }
        
        string AppTitle { get; }
        
        string AppVersionCode { get; }
        
        string AppVersionName { get; }

        string InstallationId { get; }
    }

    public enum LogLevel 
    {
        Trace = 0,
        Debug = 1,
        Information = 2,
        Warning = 3,
        Error = 4,
        Critical = 5
    }

    public interface ILambdaLogger
    {
        void Log(string message);

        void LogLine(string message);

        void Log(string level, string message) => throw null;

        void Log(LogLevel level, string message) => throw null;

        void LogTrace(string message) => throw null;

        void LogDebug(string message) => throw null;

        void LogInformation(string message) => throw null;

        void LogWarning(string message) => throw null;

        void LogError(string message) => throw null;

        void LogCritical(string message) => throw null;
    }
}