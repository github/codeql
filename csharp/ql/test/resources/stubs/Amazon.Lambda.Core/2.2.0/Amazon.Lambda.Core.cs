// This file contains auto-generated code.
// Generated from `Amazon.Lambda.Core, Version=1.0.0.0, Culture=neutral, PublicKeyToken=885c28607f98e604`.
namespace Amazon
{
    namespace Lambda
    {
        namespace Core
        {
            public interface IClientApplication
            {
                string AppPackageName { get; }
                string AppTitle { get; }
                string AppVersionCode { get; }
                string AppVersionName { get; }
                string InstallationId { get; }
            }
            public interface IClientContext
            {
                Amazon.Lambda.Core.IClientApplication Client { get; }
                System.Collections.Generic.IDictionary<string, string> Custom { get; }
                System.Collections.Generic.IDictionary<string, string> Environment { get; }
            }
            public interface ICognitoIdentity
            {
                string IdentityId { get; }
                string IdentityPoolId { get; }
            }
            public interface ILambdaContext
            {
                string AwsRequestId { get; }
                Amazon.Lambda.Core.IClientContext ClientContext { get; }
                string FunctionName { get; }
                string FunctionVersion { get; }
                Amazon.Lambda.Core.ICognitoIdentity Identity { get; }
                string InvokedFunctionArn { get; }
                Amazon.Lambda.Core.ILambdaLogger Logger { get; }
                string LogGroupName { get; }
                string LogStreamName { get; }
                int MemoryLimitInMB { get; }
                System.TimeSpan RemainingTime { get; }
            }
            public interface ILambdaLogger
            {
                void Log(string message);
                virtual void Log(string level, string message) => throw null;
                virtual void Log(Amazon.Lambda.Core.LogLevel level, string message) => throw null;
                virtual void LogCritical(string message) => throw null;
                virtual void LogDebug(string message) => throw null;
                virtual void LogError(string message) => throw null;
                virtual void LogInformation(string message) => throw null;
                void LogLine(string message);
                virtual void LogTrace(string message) => throw null;
                virtual void LogWarning(string message) => throw null;
            }
            public interface ILambdaSerializer
            {
                T Deserialize<T>(System.IO.Stream requestStream);
                void Serialize<T>(T response, System.IO.Stream responseStream);
            }
            public static class LambdaLogger
            {
                public static void Log(string message) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)65, AllowMultiple = false)]
            public sealed class LambdaSerializerAttribute : System.Attribute
            {
                public LambdaSerializerAttribute(System.Type serializerType) => throw null;
                public System.Type SerializerType { get => throw null; set { } }
            }
            public enum LogLevel
            {
                Trace = 0,
                Debug = 1,
                Information = 2,
                Warning = 3,
                Error = 4,
                Critical = 5,
            }
        }
    }
}
