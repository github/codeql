// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.Logging.Abstractions, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.

namespace Microsoft
{
    namespace Extensions
    {
        namespace Logging
        {
            public struct EventId : System.IEquatable<Microsoft.Extensions.Logging.EventId>
            {
                public static bool operator !=(Microsoft.Extensions.Logging.EventId left, Microsoft.Extensions.Logging.EventId right) => throw null;
                public static bool operator ==(Microsoft.Extensions.Logging.EventId left, Microsoft.Extensions.Logging.EventId right) => throw null;
                public bool Equals(Microsoft.Extensions.Logging.EventId other) => throw null;
                public override bool Equals(object obj) => throw null;
                // Stub generator skipped constructor 
                public EventId(int id, string name = default(string)) => throw null;
                public override int GetHashCode() => throw null;
                public int Id { get => throw null; }
                public string Name { get => throw null; }
                public override string ToString() => throw null;
                public static implicit operator Microsoft.Extensions.Logging.EventId(int i) => throw null;
            }

            public interface IExternalScopeProvider
            {
                void ForEachScope<TState>(System.Action<object, TState> callback, TState state);
                System.IDisposable Push(object state);
            }

            public interface ILogger
            {
                System.IDisposable BeginScope<TState>(TState state);
                bool IsEnabled(Microsoft.Extensions.Logging.LogLevel logLevel);
                void Log<TState>(Microsoft.Extensions.Logging.LogLevel logLevel, Microsoft.Extensions.Logging.EventId eventId, TState state, System.Exception exception, System.Func<TState, System.Exception, string> formatter);
            }

            public interface ILogger<TCategoryName> : Microsoft.Extensions.Logging.ILogger
            {
            }

            public interface ILoggerFactory : System.IDisposable
            {
                void AddProvider(Microsoft.Extensions.Logging.ILoggerProvider provider);
                Microsoft.Extensions.Logging.ILogger CreateLogger(string categoryName);
            }

            public interface ILoggerProvider : System.IDisposable
            {
                Microsoft.Extensions.Logging.ILogger CreateLogger(string categoryName);
            }

            public interface ISupportExternalScope
            {
                void SetScopeProvider(Microsoft.Extensions.Logging.IExternalScopeProvider scopeProvider);
            }

            public class LogDefineOptions
            {
                public LogDefineOptions() => throw null;
                public bool SkipEnabledCheck { get => throw null; set => throw null; }
            }

            public enum LogLevel : int
            {
                Critical = 5,
                Debug = 1,
                Error = 4,
                Information = 2,
                None = 6,
                Trace = 0,
                Warning = 3,
            }

            public class Logger<T> : Microsoft.Extensions.Logging.ILogger, Microsoft.Extensions.Logging.ILogger<T>
            {
                System.IDisposable Microsoft.Extensions.Logging.ILogger.BeginScope<TState>(TState state) => throw null;
                bool Microsoft.Extensions.Logging.ILogger.IsEnabled(Microsoft.Extensions.Logging.LogLevel logLevel) => throw null;
                void Microsoft.Extensions.Logging.ILogger.Log<TState>(Microsoft.Extensions.Logging.LogLevel logLevel, Microsoft.Extensions.Logging.EventId eventId, TState state, System.Exception exception, System.Func<TState, System.Exception, string> formatter) => throw null;
                public Logger(Microsoft.Extensions.Logging.ILoggerFactory factory) => throw null;
            }

            public static class LoggerExtensions
            {
                public static System.IDisposable BeginScope(this Microsoft.Extensions.Logging.ILogger logger, string messageFormat, params object[] args) => throw null;
                public static void Log(this Microsoft.Extensions.Logging.ILogger logger, Microsoft.Extensions.Logging.LogLevel logLevel, Microsoft.Extensions.Logging.EventId eventId, System.Exception exception, string message, params object[] args) => throw null;
                public static void Log(this Microsoft.Extensions.Logging.ILogger logger, Microsoft.Extensions.Logging.LogLevel logLevel, Microsoft.Extensions.Logging.EventId eventId, string message, params object[] args) => throw null;
                public static void Log(this Microsoft.Extensions.Logging.ILogger logger, Microsoft.Extensions.Logging.LogLevel logLevel, System.Exception exception, string message, params object[] args) => throw null;
                public static void Log(this Microsoft.Extensions.Logging.ILogger logger, Microsoft.Extensions.Logging.LogLevel logLevel, string message, params object[] args) => throw null;
                public static void LogCritical(this Microsoft.Extensions.Logging.ILogger logger, Microsoft.Extensions.Logging.EventId eventId, System.Exception exception, string message, params object[] args) => throw null;
                public static void LogCritical(this Microsoft.Extensions.Logging.ILogger logger, Microsoft.Extensions.Logging.EventId eventId, string message, params object[] args) => throw null;
                public static void LogCritical(this Microsoft.Extensions.Logging.ILogger logger, System.Exception exception, string message, params object[] args) => throw null;
                public static void LogCritical(this Microsoft.Extensions.Logging.ILogger logger, string message, params object[] args) => throw null;
                public static void LogDebug(this Microsoft.Extensions.Logging.ILogger logger, Microsoft.Extensions.Logging.EventId eventId, System.Exception exception, string message, params object[] args) => throw null;
                public static void LogDebug(this Microsoft.Extensions.Logging.ILogger logger, Microsoft.Extensions.Logging.EventId eventId, string message, params object[] args) => throw null;
                public static void LogDebug(this Microsoft.Extensions.Logging.ILogger logger, System.Exception exception, string message, params object[] args) => throw null;
                public static void LogDebug(this Microsoft.Extensions.Logging.ILogger logger, string message, params object[] args) => throw null;
                public static void LogError(this Microsoft.Extensions.Logging.ILogger logger, Microsoft.Extensions.Logging.EventId eventId, System.Exception exception, string message, params object[] args) => throw null;
                public static void LogError(this Microsoft.Extensions.Logging.ILogger logger, Microsoft.Extensions.Logging.EventId eventId, string message, params object[] args) => throw null;
                public static void LogError(this Microsoft.Extensions.Logging.ILogger logger, System.Exception exception, string message, params object[] args) => throw null;
                public static void LogError(this Microsoft.Extensions.Logging.ILogger logger, string message, params object[] args) => throw null;
                public static void LogInformation(this Microsoft.Extensions.Logging.ILogger logger, Microsoft.Extensions.Logging.EventId eventId, System.Exception exception, string message, params object[] args) => throw null;
                public static void LogInformation(this Microsoft.Extensions.Logging.ILogger logger, Microsoft.Extensions.Logging.EventId eventId, string message, params object[] args) => throw null;
                public static void LogInformation(this Microsoft.Extensions.Logging.ILogger logger, System.Exception exception, string message, params object[] args) => throw null;
                public static void LogInformation(this Microsoft.Extensions.Logging.ILogger logger, string message, params object[] args) => throw null;
                public static void LogTrace(this Microsoft.Extensions.Logging.ILogger logger, Microsoft.Extensions.Logging.EventId eventId, System.Exception exception, string message, params object[] args) => throw null;
                public static void LogTrace(this Microsoft.Extensions.Logging.ILogger logger, Microsoft.Extensions.Logging.EventId eventId, string message, params object[] args) => throw null;
                public static void LogTrace(this Microsoft.Extensions.Logging.ILogger logger, System.Exception exception, string message, params object[] args) => throw null;
                public static void LogTrace(this Microsoft.Extensions.Logging.ILogger logger, string message, params object[] args) => throw null;
                public static void LogWarning(this Microsoft.Extensions.Logging.ILogger logger, Microsoft.Extensions.Logging.EventId eventId, System.Exception exception, string message, params object[] args) => throw null;
                public static void LogWarning(this Microsoft.Extensions.Logging.ILogger logger, Microsoft.Extensions.Logging.EventId eventId, string message, params object[] args) => throw null;
                public static void LogWarning(this Microsoft.Extensions.Logging.ILogger logger, System.Exception exception, string message, params object[] args) => throw null;
                public static void LogWarning(this Microsoft.Extensions.Logging.ILogger logger, string message, params object[] args) => throw null;
            }

            public class LoggerExternalScopeProvider : Microsoft.Extensions.Logging.IExternalScopeProvider
            {
                public void ForEachScope<TState>(System.Action<object, TState> callback, TState state) => throw null;
                public LoggerExternalScopeProvider() => throw null;
                public System.IDisposable Push(object state) => throw null;
            }

            public static class LoggerFactoryExtensions
            {
                public static Microsoft.Extensions.Logging.ILogger CreateLogger(this Microsoft.Extensions.Logging.ILoggerFactory factory, System.Type type) => throw null;
                public static Microsoft.Extensions.Logging.ILogger<T> CreateLogger<T>(this Microsoft.Extensions.Logging.ILoggerFactory factory) => throw null;
            }

            public static class LoggerMessage
            {
                public static System.Action<Microsoft.Extensions.Logging.ILogger, System.Exception> Define(Microsoft.Extensions.Logging.LogLevel logLevel, Microsoft.Extensions.Logging.EventId eventId, string formatString) => throw null;
                public static System.Action<Microsoft.Extensions.Logging.ILogger, System.Exception> Define(Microsoft.Extensions.Logging.LogLevel logLevel, Microsoft.Extensions.Logging.EventId eventId, string formatString, Microsoft.Extensions.Logging.LogDefineOptions options) => throw null;
                public static System.Action<Microsoft.Extensions.Logging.ILogger, T1, T2, T3, T4, T5, T6, System.Exception> Define<T1, T2, T3, T4, T5, T6>(Microsoft.Extensions.Logging.LogLevel logLevel, Microsoft.Extensions.Logging.EventId eventId, string formatString) => throw null;
                public static System.Action<Microsoft.Extensions.Logging.ILogger, T1, T2, T3, T4, T5, T6, System.Exception> Define<T1, T2, T3, T4, T5, T6>(Microsoft.Extensions.Logging.LogLevel logLevel, Microsoft.Extensions.Logging.EventId eventId, string formatString, Microsoft.Extensions.Logging.LogDefineOptions options) => throw null;
                public static System.Action<Microsoft.Extensions.Logging.ILogger, T1, T2, T3, T4, T5, System.Exception> Define<T1, T2, T3, T4, T5>(Microsoft.Extensions.Logging.LogLevel logLevel, Microsoft.Extensions.Logging.EventId eventId, string formatString) => throw null;
                public static System.Action<Microsoft.Extensions.Logging.ILogger, T1, T2, T3, T4, T5, System.Exception> Define<T1, T2, T3, T4, T5>(Microsoft.Extensions.Logging.LogLevel logLevel, Microsoft.Extensions.Logging.EventId eventId, string formatString, Microsoft.Extensions.Logging.LogDefineOptions options) => throw null;
                public static System.Action<Microsoft.Extensions.Logging.ILogger, T1, T2, T3, T4, System.Exception> Define<T1, T2, T3, T4>(Microsoft.Extensions.Logging.LogLevel logLevel, Microsoft.Extensions.Logging.EventId eventId, string formatString) => throw null;
                public static System.Action<Microsoft.Extensions.Logging.ILogger, T1, T2, T3, T4, System.Exception> Define<T1, T2, T3, T4>(Microsoft.Extensions.Logging.LogLevel logLevel, Microsoft.Extensions.Logging.EventId eventId, string formatString, Microsoft.Extensions.Logging.LogDefineOptions options) => throw null;
                public static System.Action<Microsoft.Extensions.Logging.ILogger, T1, T2, T3, System.Exception> Define<T1, T2, T3>(Microsoft.Extensions.Logging.LogLevel logLevel, Microsoft.Extensions.Logging.EventId eventId, string formatString) => throw null;
                public static System.Action<Microsoft.Extensions.Logging.ILogger, T1, T2, T3, System.Exception> Define<T1, T2, T3>(Microsoft.Extensions.Logging.LogLevel logLevel, Microsoft.Extensions.Logging.EventId eventId, string formatString, Microsoft.Extensions.Logging.LogDefineOptions options) => throw null;
                public static System.Action<Microsoft.Extensions.Logging.ILogger, T1, T2, System.Exception> Define<T1, T2>(Microsoft.Extensions.Logging.LogLevel logLevel, Microsoft.Extensions.Logging.EventId eventId, string formatString) => throw null;
                public static System.Action<Microsoft.Extensions.Logging.ILogger, T1, T2, System.Exception> Define<T1, T2>(Microsoft.Extensions.Logging.LogLevel logLevel, Microsoft.Extensions.Logging.EventId eventId, string formatString, Microsoft.Extensions.Logging.LogDefineOptions options) => throw null;
                public static System.Action<Microsoft.Extensions.Logging.ILogger, T1, System.Exception> Define<T1>(Microsoft.Extensions.Logging.LogLevel logLevel, Microsoft.Extensions.Logging.EventId eventId, string formatString) => throw null;
                public static System.Action<Microsoft.Extensions.Logging.ILogger, T1, System.Exception> Define<T1>(Microsoft.Extensions.Logging.LogLevel logLevel, Microsoft.Extensions.Logging.EventId eventId, string formatString, Microsoft.Extensions.Logging.LogDefineOptions options) => throw null;
                public static System.Func<Microsoft.Extensions.Logging.ILogger, System.IDisposable> DefineScope(string formatString) => throw null;
                public static System.Func<Microsoft.Extensions.Logging.ILogger, T1, T2, T3, T4, T5, T6, System.IDisposable> DefineScope<T1, T2, T3, T4, T5, T6>(string formatString) => throw null;
                public static System.Func<Microsoft.Extensions.Logging.ILogger, T1, T2, T3, T4, T5, System.IDisposable> DefineScope<T1, T2, T3, T4, T5>(string formatString) => throw null;
                public static System.Func<Microsoft.Extensions.Logging.ILogger, T1, T2, T3, T4, System.IDisposable> DefineScope<T1, T2, T3, T4>(string formatString) => throw null;
                public static System.Func<Microsoft.Extensions.Logging.ILogger, T1, T2, T3, System.IDisposable> DefineScope<T1, T2, T3>(string formatString) => throw null;
                public static System.Func<Microsoft.Extensions.Logging.ILogger, T1, T2, System.IDisposable> DefineScope<T1, T2>(string formatString) => throw null;
                public static System.Func<Microsoft.Extensions.Logging.ILogger, T1, System.IDisposable> DefineScope<T1>(string formatString) => throw null;
            }

            public class LoggerMessageAttribute : System.Attribute
            {
                public int EventId { get => throw null; set => throw null; }
                public string EventName { get => throw null; set => throw null; }
                public Microsoft.Extensions.Logging.LogLevel Level { get => throw null; set => throw null; }
                public LoggerMessageAttribute() => throw null;
                public LoggerMessageAttribute(int eventId, Microsoft.Extensions.Logging.LogLevel level, string message) => throw null;
                public string Message { get => throw null; set => throw null; }
                public bool SkipEnabledCheck { get => throw null; set => throw null; }
            }

            namespace Abstractions
            {
                public struct LogEntry<TState>
                {
                    public string Category { get => throw null; }
                    public Microsoft.Extensions.Logging.EventId EventId { get => throw null; }
                    public System.Exception Exception { get => throw null; }
                    public System.Func<TState, System.Exception, string> Formatter { get => throw null; }
                    // Stub generator skipped constructor 
                    public LogEntry(Microsoft.Extensions.Logging.LogLevel logLevel, string category, Microsoft.Extensions.Logging.EventId eventId, TState state, System.Exception exception, System.Func<TState, System.Exception, string> formatter) => throw null;
                    public Microsoft.Extensions.Logging.LogLevel LogLevel { get => throw null; }
                    public TState State { get => throw null; }
                }

                public class NullLogger : Microsoft.Extensions.Logging.ILogger
                {
                    public System.IDisposable BeginScope<TState>(TState state) => throw null;
                    public static Microsoft.Extensions.Logging.Abstractions.NullLogger Instance { get => throw null; }
                    public bool IsEnabled(Microsoft.Extensions.Logging.LogLevel logLevel) => throw null;
                    public void Log<TState>(Microsoft.Extensions.Logging.LogLevel logLevel, Microsoft.Extensions.Logging.EventId eventId, TState state, System.Exception exception, System.Func<TState, System.Exception, string> formatter) => throw null;
                }

                public class NullLogger<T> : Microsoft.Extensions.Logging.ILogger, Microsoft.Extensions.Logging.ILogger<T>
                {
                    public System.IDisposable BeginScope<TState>(TState state) => throw null;
                    public static Microsoft.Extensions.Logging.Abstractions.NullLogger<T> Instance;
                    public bool IsEnabled(Microsoft.Extensions.Logging.LogLevel logLevel) => throw null;
                    public void Log<TState>(Microsoft.Extensions.Logging.LogLevel logLevel, Microsoft.Extensions.Logging.EventId eventId, TState state, System.Exception exception, System.Func<TState, System.Exception, string> formatter) => throw null;
                    public NullLogger() => throw null;
                }

                public class NullLoggerFactory : Microsoft.Extensions.Logging.ILoggerFactory, System.IDisposable
                {
                    public void AddProvider(Microsoft.Extensions.Logging.ILoggerProvider provider) => throw null;
                    public Microsoft.Extensions.Logging.ILogger CreateLogger(string name) => throw null;
                    public void Dispose() => throw null;
                    public static Microsoft.Extensions.Logging.Abstractions.NullLoggerFactory Instance;
                    public NullLoggerFactory() => throw null;
                }

                public class NullLoggerProvider : Microsoft.Extensions.Logging.ILoggerProvider, System.IDisposable
                {
                    public Microsoft.Extensions.Logging.ILogger CreateLogger(string categoryName) => throw null;
                    public void Dispose() => throw null;
                    public static Microsoft.Extensions.Logging.Abstractions.NullLoggerProvider Instance { get => throw null; }
                }

            }
        }
    }
}
