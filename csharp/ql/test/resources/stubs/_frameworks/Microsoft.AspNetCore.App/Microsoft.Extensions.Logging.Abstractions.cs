// This file contains auto-generated code.

namespace Microsoft
{
    namespace Extensions
    {
        namespace Logging
        {
            // Generated from `Microsoft.Extensions.Logging.EventId` in `Microsoft.Extensions.Logging.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public struct EventId
            {
                public static bool operator !=(Microsoft.Extensions.Logging.EventId left, Microsoft.Extensions.Logging.EventId right) => throw null;
                public static bool operator ==(Microsoft.Extensions.Logging.EventId left, Microsoft.Extensions.Logging.EventId right) => throw null;
                public override bool Equals(object obj) => throw null;
                public bool Equals(Microsoft.Extensions.Logging.EventId other) => throw null;
                public EventId(int id, string name = default(string)) => throw null;
                // Stub generator skipped constructor 
                public override int GetHashCode() => throw null;
                public int Id { get => throw null; }
                public string Name { get => throw null; }
                public override string ToString() => throw null;
                public static implicit operator Microsoft.Extensions.Logging.EventId(int i) => throw null;
            }

            // Generated from `Microsoft.Extensions.Logging.IExternalScopeProvider` in `Microsoft.Extensions.Logging.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IExternalScopeProvider
            {
                void ForEachScope<TState>(System.Action<object, TState> callback, TState state);
                System.IDisposable Push(object state);
            }

            // Generated from `Microsoft.Extensions.Logging.ILogger` in `Microsoft.Extensions.Logging.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface ILogger
            {
                System.IDisposable BeginScope<TState>(TState state);
                bool IsEnabled(Microsoft.Extensions.Logging.LogLevel logLevel);
                void Log<TState>(Microsoft.Extensions.Logging.LogLevel logLevel, Microsoft.Extensions.Logging.EventId eventId, TState state, System.Exception exception, System.Func<TState, System.Exception, string> formatter);
            }

            // Generated from `Microsoft.Extensions.Logging.ILogger<>` in `Microsoft.Extensions.Logging.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface ILogger<TCategoryName> : Microsoft.Extensions.Logging.ILogger
            {
            }

            // Generated from `Microsoft.Extensions.Logging.ILoggerFactory` in `Microsoft.Extensions.Logging.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface ILoggerFactory : System.IDisposable
            {
                void AddProvider(Microsoft.Extensions.Logging.ILoggerProvider provider);
                Microsoft.Extensions.Logging.ILogger CreateLogger(string categoryName);
            }

            // Generated from `Microsoft.Extensions.Logging.ILoggerProvider` in `Microsoft.Extensions.Logging.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface ILoggerProvider : System.IDisposable
            {
                Microsoft.Extensions.Logging.ILogger CreateLogger(string categoryName);
            }

            // Generated from `Microsoft.Extensions.Logging.ISupportExternalScope` in `Microsoft.Extensions.Logging.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface ISupportExternalScope
            {
                void SetScopeProvider(Microsoft.Extensions.Logging.IExternalScopeProvider scopeProvider);
            }

            // Generated from `Microsoft.Extensions.Logging.LogLevel` in `Microsoft.Extensions.Logging.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public enum LogLevel
            {
                Critical,
                Debug,
                Error,
                Information,
                None,
                Trace,
                Warning,
            }

            // Generated from `Microsoft.Extensions.Logging.Logger<>` in `Microsoft.Extensions.Logging.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class Logger<T> : Microsoft.Extensions.Logging.ILogger<T>, Microsoft.Extensions.Logging.ILogger
            {
                System.IDisposable Microsoft.Extensions.Logging.ILogger.BeginScope<TState>(TState state) => throw null;
                bool Microsoft.Extensions.Logging.ILogger.IsEnabled(Microsoft.Extensions.Logging.LogLevel logLevel) => throw null;
                void Microsoft.Extensions.Logging.ILogger.Log<TState>(Microsoft.Extensions.Logging.LogLevel logLevel, Microsoft.Extensions.Logging.EventId eventId, TState state, System.Exception exception, System.Func<TState, System.Exception, string> formatter) => throw null;
                public Logger(Microsoft.Extensions.Logging.ILoggerFactory factory) => throw null;
            }

            // Generated from `Microsoft.Extensions.Logging.LoggerExtensions` in `Microsoft.Extensions.Logging.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class LoggerExtensions
            {
                public static System.IDisposable BeginScope(this Microsoft.Extensions.Logging.ILogger logger, string messageFormat, params object[] args) => throw null;
                public static void Log(this Microsoft.Extensions.Logging.ILogger logger, Microsoft.Extensions.Logging.LogLevel logLevel, string message, params object[] args) => throw null;
                public static void Log(this Microsoft.Extensions.Logging.ILogger logger, Microsoft.Extensions.Logging.LogLevel logLevel, System.Exception exception, string message, params object[] args) => throw null;
                public static void Log(this Microsoft.Extensions.Logging.ILogger logger, Microsoft.Extensions.Logging.LogLevel logLevel, Microsoft.Extensions.Logging.EventId eventId, string message, params object[] args) => throw null;
                public static void Log(this Microsoft.Extensions.Logging.ILogger logger, Microsoft.Extensions.Logging.LogLevel logLevel, Microsoft.Extensions.Logging.EventId eventId, System.Exception exception, string message, params object[] args) => throw null;
                public static void LogCritical(this Microsoft.Extensions.Logging.ILogger logger, string message, params object[] args) => throw null;
                public static void LogCritical(this Microsoft.Extensions.Logging.ILogger logger, System.Exception exception, string message, params object[] args) => throw null;
                public static void LogCritical(this Microsoft.Extensions.Logging.ILogger logger, Microsoft.Extensions.Logging.EventId eventId, string message, params object[] args) => throw null;
                public static void LogCritical(this Microsoft.Extensions.Logging.ILogger logger, Microsoft.Extensions.Logging.EventId eventId, System.Exception exception, string message, params object[] args) => throw null;
                public static void LogDebug(this Microsoft.Extensions.Logging.ILogger logger, string message, params object[] args) => throw null;
                public static void LogDebug(this Microsoft.Extensions.Logging.ILogger logger, System.Exception exception, string message, params object[] args) => throw null;
                public static void LogDebug(this Microsoft.Extensions.Logging.ILogger logger, Microsoft.Extensions.Logging.EventId eventId, string message, params object[] args) => throw null;
                public static void LogDebug(this Microsoft.Extensions.Logging.ILogger logger, Microsoft.Extensions.Logging.EventId eventId, System.Exception exception, string message, params object[] args) => throw null;
                public static void LogError(this Microsoft.Extensions.Logging.ILogger logger, string message, params object[] args) => throw null;
                public static void LogError(this Microsoft.Extensions.Logging.ILogger logger, System.Exception exception, string message, params object[] args) => throw null;
                public static void LogError(this Microsoft.Extensions.Logging.ILogger logger, Microsoft.Extensions.Logging.EventId eventId, string message, params object[] args) => throw null;
                public static void LogError(this Microsoft.Extensions.Logging.ILogger logger, Microsoft.Extensions.Logging.EventId eventId, System.Exception exception, string message, params object[] args) => throw null;
                public static void LogInformation(this Microsoft.Extensions.Logging.ILogger logger, string message, params object[] args) => throw null;
                public static void LogInformation(this Microsoft.Extensions.Logging.ILogger logger, System.Exception exception, string message, params object[] args) => throw null;
                public static void LogInformation(this Microsoft.Extensions.Logging.ILogger logger, Microsoft.Extensions.Logging.EventId eventId, string message, params object[] args) => throw null;
                public static void LogInformation(this Microsoft.Extensions.Logging.ILogger logger, Microsoft.Extensions.Logging.EventId eventId, System.Exception exception, string message, params object[] args) => throw null;
                public static void LogTrace(this Microsoft.Extensions.Logging.ILogger logger, string message, params object[] args) => throw null;
                public static void LogTrace(this Microsoft.Extensions.Logging.ILogger logger, System.Exception exception, string message, params object[] args) => throw null;
                public static void LogTrace(this Microsoft.Extensions.Logging.ILogger logger, Microsoft.Extensions.Logging.EventId eventId, string message, params object[] args) => throw null;
                public static void LogTrace(this Microsoft.Extensions.Logging.ILogger logger, Microsoft.Extensions.Logging.EventId eventId, System.Exception exception, string message, params object[] args) => throw null;
                public static void LogWarning(this Microsoft.Extensions.Logging.ILogger logger, string message, params object[] args) => throw null;
                public static void LogWarning(this Microsoft.Extensions.Logging.ILogger logger, System.Exception exception, string message, params object[] args) => throw null;
                public static void LogWarning(this Microsoft.Extensions.Logging.ILogger logger, Microsoft.Extensions.Logging.EventId eventId, string message, params object[] args) => throw null;
                public static void LogWarning(this Microsoft.Extensions.Logging.ILogger logger, Microsoft.Extensions.Logging.EventId eventId, System.Exception exception, string message, params object[] args) => throw null;
            }

            // Generated from `Microsoft.Extensions.Logging.LoggerExternalScopeProvider` in `Microsoft.Extensions.Logging.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class LoggerExternalScopeProvider : Microsoft.Extensions.Logging.IExternalScopeProvider
            {
                public void ForEachScope<TState>(System.Action<object, TState> callback, TState state) => throw null;
                public LoggerExternalScopeProvider() => throw null;
                public System.IDisposable Push(object state) => throw null;
            }

            // Generated from `Microsoft.Extensions.Logging.LoggerFactoryExtensions` in `Microsoft.Extensions.Logging.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class LoggerFactoryExtensions
            {
                public static Microsoft.Extensions.Logging.ILogger<T> CreateLogger<T>(this Microsoft.Extensions.Logging.ILoggerFactory factory) => throw null;
                public static Microsoft.Extensions.Logging.ILogger CreateLogger(this Microsoft.Extensions.Logging.ILoggerFactory factory, System.Type type) => throw null;
            }

            // Generated from `Microsoft.Extensions.Logging.LoggerMessage` in `Microsoft.Extensions.Logging.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class LoggerMessage
            {
                public static System.Action<Microsoft.Extensions.Logging.ILogger, T1, T2, T3, T4, T5, T6, System.Exception> Define<T1, T2, T3, T4, T5, T6>(Microsoft.Extensions.Logging.LogLevel logLevel, Microsoft.Extensions.Logging.EventId eventId, string formatString) => throw null;
                public static System.Action<Microsoft.Extensions.Logging.ILogger, T1, T2, T3, T4, T5, System.Exception> Define<T1, T2, T3, T4, T5>(Microsoft.Extensions.Logging.LogLevel logLevel, Microsoft.Extensions.Logging.EventId eventId, string formatString) => throw null;
                public static System.Action<Microsoft.Extensions.Logging.ILogger, T1, T2, T3, T4, System.Exception> Define<T1, T2, T3, T4>(Microsoft.Extensions.Logging.LogLevel logLevel, Microsoft.Extensions.Logging.EventId eventId, string formatString) => throw null;
                public static System.Action<Microsoft.Extensions.Logging.ILogger, T1, T2, T3, System.Exception> Define<T1, T2, T3>(Microsoft.Extensions.Logging.LogLevel logLevel, Microsoft.Extensions.Logging.EventId eventId, string formatString) => throw null;
                public static System.Action<Microsoft.Extensions.Logging.ILogger, T1, T2, System.Exception> Define<T1, T2>(Microsoft.Extensions.Logging.LogLevel logLevel, Microsoft.Extensions.Logging.EventId eventId, string formatString) => throw null;
                public static System.Action<Microsoft.Extensions.Logging.ILogger, T1, System.Exception> Define<T1>(Microsoft.Extensions.Logging.LogLevel logLevel, Microsoft.Extensions.Logging.EventId eventId, string formatString) => throw null;
                public static System.Action<Microsoft.Extensions.Logging.ILogger, System.Exception> Define(Microsoft.Extensions.Logging.LogLevel logLevel, Microsoft.Extensions.Logging.EventId eventId, string formatString) => throw null;
                public static System.Func<Microsoft.Extensions.Logging.ILogger, T1, T2, T3, T4, T5, T6, System.IDisposable> DefineScope<T1, T2, T3, T4, T5, T6>(string formatString) => throw null;
                public static System.Func<Microsoft.Extensions.Logging.ILogger, T1, T2, T3, T4, T5, System.IDisposable> DefineScope<T1, T2, T3, T4, T5>(string formatString) => throw null;
                public static System.Func<Microsoft.Extensions.Logging.ILogger, T1, T2, T3, T4, System.IDisposable> DefineScope<T1, T2, T3, T4>(string formatString) => throw null;
                public static System.Func<Microsoft.Extensions.Logging.ILogger, T1, T2, T3, System.IDisposable> DefineScope<T1, T2, T3>(string formatString) => throw null;
                public static System.Func<Microsoft.Extensions.Logging.ILogger, T1, T2, System.IDisposable> DefineScope<T1, T2>(string formatString) => throw null;
                public static System.Func<Microsoft.Extensions.Logging.ILogger, T1, System.IDisposable> DefineScope<T1>(string formatString) => throw null;
                public static System.Func<Microsoft.Extensions.Logging.ILogger, System.IDisposable> DefineScope(string formatString) => throw null;
            }

            namespace Abstractions
            {
                // Generated from `Microsoft.Extensions.Logging.Abstractions.LogEntry<>` in `Microsoft.Extensions.Logging.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public struct LogEntry<TState>
                {
                    public string Category { get => throw null; }
                    public Microsoft.Extensions.Logging.EventId EventId { get => throw null; }
                    public System.Exception Exception { get => throw null; }
                    public System.Func<TState, System.Exception, string> Formatter { get => throw null; }
                    public LogEntry(Microsoft.Extensions.Logging.LogLevel logLevel, string category, Microsoft.Extensions.Logging.EventId eventId, TState state, System.Exception exception, System.Func<TState, System.Exception, string> formatter) => throw null;
                    // Stub generator skipped constructor 
                    public Microsoft.Extensions.Logging.LogLevel LogLevel { get => throw null; }
                    public TState State { get => throw null; }
                }

                // Generated from `Microsoft.Extensions.Logging.Abstractions.NullLogger` in `Microsoft.Extensions.Logging.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class NullLogger : Microsoft.Extensions.Logging.ILogger
                {
                    public System.IDisposable BeginScope<TState>(TState state) => throw null;
                    public static Microsoft.Extensions.Logging.Abstractions.NullLogger Instance { get => throw null; }
                    public bool IsEnabled(Microsoft.Extensions.Logging.LogLevel logLevel) => throw null;
                    public void Log<TState>(Microsoft.Extensions.Logging.LogLevel logLevel, Microsoft.Extensions.Logging.EventId eventId, TState state, System.Exception exception, System.Func<TState, System.Exception, string> formatter) => throw null;
                }

                // Generated from `Microsoft.Extensions.Logging.Abstractions.NullLogger<>` in `Microsoft.Extensions.Logging.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class NullLogger<T> : Microsoft.Extensions.Logging.ILogger<T>, Microsoft.Extensions.Logging.ILogger
                {
                    public System.IDisposable BeginScope<TState>(TState state) => throw null;
                    public static Microsoft.Extensions.Logging.Abstractions.NullLogger<T> Instance;
                    public bool IsEnabled(Microsoft.Extensions.Logging.LogLevel logLevel) => throw null;
                    public void Log<TState>(Microsoft.Extensions.Logging.LogLevel logLevel, Microsoft.Extensions.Logging.EventId eventId, TState state, System.Exception exception, System.Func<TState, System.Exception, string> formatter) => throw null;
                    public NullLogger() => throw null;
                }

                // Generated from `Microsoft.Extensions.Logging.Abstractions.NullLoggerFactory` in `Microsoft.Extensions.Logging.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class NullLoggerFactory : System.IDisposable, Microsoft.Extensions.Logging.ILoggerFactory
                {
                    public void AddProvider(Microsoft.Extensions.Logging.ILoggerProvider provider) => throw null;
                    public Microsoft.Extensions.Logging.ILogger CreateLogger(string name) => throw null;
                    public void Dispose() => throw null;
                    public static Microsoft.Extensions.Logging.Abstractions.NullLoggerFactory Instance;
                    public NullLoggerFactory() => throw null;
                }

                // Generated from `Microsoft.Extensions.Logging.Abstractions.NullLoggerProvider` in `Microsoft.Extensions.Logging.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class NullLoggerProvider : System.IDisposable, Microsoft.Extensions.Logging.ILoggerProvider
                {
                    public Microsoft.Extensions.Logging.ILogger CreateLogger(string categoryName) => throw null;
                    public void Dispose() => throw null;
                    public static Microsoft.Extensions.Logging.Abstractions.NullLoggerProvider Instance { get => throw null; }
                }

            }
        }
    }
}
namespace System
{
    namespace Runtime
    {
        namespace CompilerServices
        {
            /* Duplicate type 'IsReadOnlyAttribute' is not stubbed in this assembly 'Microsoft.Extensions.Logging.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60'. */

        }
    }
}
