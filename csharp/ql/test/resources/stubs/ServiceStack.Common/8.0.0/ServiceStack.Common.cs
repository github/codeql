// This file contains auto-generated code.
// Generated from `ServiceStack.Common, Version=6.0.0.0, Culture=neutral, PublicKeyToken=null`.
namespace ServiceStack
{
    public static partial class ActionExecExtensions
    {
        public static void ExecAllAndWait(this System.Collections.Generic.ICollection<System.Action> actions, System.TimeSpan timeout) => throw null;
        public static System.Collections.Generic.List<System.Threading.WaitHandle> ExecAsync(this System.Collections.Generic.IEnumerable<System.Action> actions) => throw null;
        public static bool WaitAll(this System.Collections.Generic.List<System.Threading.WaitHandle> waitHandles, int timeoutMs) => throw null;
        public static bool WaitAll(this System.Collections.Generic.ICollection<System.Threading.WaitHandle> waitHandles, int timeoutMs) => throw null;
        public static bool WaitAll(this System.Collections.Generic.ICollection<System.Threading.WaitHandle> waitHandles, System.TimeSpan timeout) => throw null;
        public static bool WaitAll(this System.Collections.Generic.List<System.IAsyncResult> asyncResults, System.TimeSpan timeout) => throw null;
        public static bool WaitAll(System.Threading.WaitHandle[] waitHandles, System.TimeSpan timeout) => throw null;
        public static bool WaitAll(System.Threading.WaitHandle[] waitHandles, int timeOutMs) => throw null;
    }
    public delegate void ActionInvoker(object instance, params object[] args);
    public static class AiUtils
    {
        public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<(string, int)>> GetPhraseWeightsAsync(this ServiceStack.AI.IPromptProvider provider, int? defaultWeight = default(int?), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
    }
    public class AppTaskResult
    {
        public AppTaskResult(System.Collections.Generic.List<ServiceStack.IAppTask> tasksRun) => throw null;
        public System.Exception Error { get => throw null; set { } }
        public string GetLogs() => throw null;
        public bool Succeeded { get => throw null; }
        public System.Collections.Generic.List<ServiceStack.IAppTask> TasksRun { get => throw null; }
        public System.Collections.Generic.List<System.Type> TypesCompleted { get => throw null; }
    }
    public class AppTasks
    {
        public AppTasks() => throw null;
        public static string GetAppTaskCommands() => throw null;
        public static string GetAppTaskCommands(string[] args) => throw null;
        public static string GetDesc(System.Type nextRun) => throw null;
        public static string GetDescFmt(System.Type nextRun) => throw null;
        public static ServiceStack.AppTasks Instance { get => throw null; set { } }
        public static bool IsRunAsAppTask() => throw null;
        public ServiceStack.Logging.ILog Log { get => throw null; set { } }
        public static int? RanAsTask() => throw null;
        public static void Register(string taskName, System.Action<string[]> appTask) => throw null;
        public static void Run(System.Action onExit = default(System.Action)) => throw null;
        public System.Collections.Generic.Dictionary<string, System.Action<string[]>> Tasks { get => throw null; }
    }
    public static partial class AssertExtensions
    {
        public static void ThrowIfNull(this object obj) => throw null;
        public static void ThrowIfNull(this object obj, string varName) => throw null;
        public static T ThrowIfNull<T>(this T obj, string varName) => throw null;
        public static string ThrowIfNullOrEmpty(this string strValue) => throw null;
        public static string ThrowIfNullOrEmpty(this string strValue, string varName) => throw null;
        public static System.Collections.ICollection ThrowIfNullOrEmpty(this System.Collections.ICollection collection) => throw null;
        public static System.Collections.ICollection ThrowIfNullOrEmpty(this System.Collections.ICollection collection, string varName) => throw null;
        public static System.Collections.Generic.ICollection<T> ThrowIfNullOrEmpty<T>(this System.Collections.Generic.ICollection<T> collection) => throw null;
        public static System.Collections.Generic.ICollection<T> ThrowIfNullOrEmpty<T>(this System.Collections.Generic.ICollection<T> collection, string varName) => throw null;
        public static void ThrowOnFirstNull(params object[] objs) => throw null;
    }
    public static class AssertUtils
    {
        public static void AreNotNull<T>(params T[] fields) => throw null;
        public static void AreNotNull(System.Collections.Generic.IDictionary<string, object> fieldMap) => throw null;
    }
    namespace AsyncEx
    {
        public sealed class AsyncManualResetEvent
        {
            public AsyncManualResetEvent(bool set) => throw null;
            public AsyncManualResetEvent() => throw null;
            public int Id { get => throw null; }
            public bool IsSet { get => throw null; }
            public void Reset() => throw null;
            public void Set() => throw null;
            public void Wait() => throw null;
            public void Wait(System.Threading.CancellationToken cancellationToken) => throw null;
            public System.Threading.Tasks.Task WaitAsync() => throw null;
            public System.Threading.Tasks.Task WaitAsync(System.Threading.CancellationToken cancellationToken) => throw null;
        }
        public sealed class CancellationTokenTaskSource<T> : System.IDisposable
        {
            public CancellationTokenTaskSource(System.Threading.CancellationToken cancellationToken) => throw null;
            public void Dispose() => throw null;
            public System.Threading.Tasks.Task<T> Task { get => throw null; }
        }
        public static partial class TaskCompletionSourceExtensions
        {
            public static System.Threading.Tasks.TaskCompletionSource<TResult> CreateAsyncTaskSource<TResult>() => throw null;
            public static bool TryCompleteFromCompletedTask<TResult, TSourceResult>(this System.Threading.Tasks.TaskCompletionSource<TResult> @this, System.Threading.Tasks.Task<TSourceResult> task) where TSourceResult : TResult => throw null;
            public static bool TryCompleteFromCompletedTask<TResult>(this System.Threading.Tasks.TaskCompletionSource<TResult> @this, System.Threading.Tasks.Task task, System.Func<TResult> resultFunc) => throw null;
        }
        public static partial class TaskExtensions
        {
            public static void WaitAndUnwrapException(this System.Threading.Tasks.Task task) => throw null;
            public static void WaitAndUnwrapException(this System.Threading.Tasks.Task task, System.Threading.CancellationToken cancellationToken) => throw null;
            public static TResult WaitAndUnwrapException<TResult>(this System.Threading.Tasks.Task<TResult> task) => throw null;
            public static TResult WaitAndUnwrapException<TResult>(this System.Threading.Tasks.Task<TResult> task, System.Threading.CancellationToken cancellationToken) => throw null;
            public static System.Threading.Tasks.Task WaitAsync(this System.Threading.Tasks.Task @this, System.Threading.CancellationToken cancellationToken) => throw null;
            public static void WaitWithoutException(this System.Threading.Tasks.Task task) => throw null;
            public static void WaitWithoutException(this System.Threading.Tasks.Task task, System.Threading.CancellationToken cancellationToken) => throw null;
        }
    }
    public class BundleOptions
    {
        public bool Async { get => throw null; set { } }
        public bool Bundle { get => throw null; set { } }
        public bool Cache { get => throw null; set { } }
        public BundleOptions() => throw null;
        public bool Defer { get => throw null; set { } }
        public bool IIFE { get => throw null; set { } }
        public bool Minify { get => throw null; set { } }
        public bool Module { get => throw null; set { } }
        public string OutputTo { get => throw null; set { } }
        public string OutputWebPath { get => throw null; set { } }
        public string PathBase { get => throw null; set { } }
        public bool RegisterModuleInAmd { get => throw null; set { } }
        public bool SaveToDisk { get => throw null; set { } }
        public System.Collections.Generic.List<string> Sources { get => throw null; set { } }
    }
    public class ByteArrayComparer : System.Collections.Generic.IEqualityComparer<byte[]>
    {
        public ByteArrayComparer() => throw null;
        public bool Equals(byte[] left, byte[] right) => throw null;
        public int GetHashCode(byte[] key) => throw null;
        public static ServiceStack.ByteArrayComparer Instance;
    }
    public static partial class ByteArrayExtensions
    {
        public static bool AreEqual(this byte[] b1, byte[] b2) => throw null;
        public static byte[] ToSha1Hash(this byte[] bytes) => throw null;
    }
    public static class CachedExpressionCompiler
    {
        public static System.Func<TModel, TValue> Compile<TModel, TValue>(this System.Linq.Expressions.Expression<System.Func<TModel, TValue>> lambdaExpression) => throw null;
        public static object Evaluate(System.Linq.Expressions.Expression arg) => throw null;
    }
    public class Command
    {
        public System.Collections.Generic.List<System.ReadOnlyMemory<char>> Args { get => throw null; }
        public System.ReadOnlyMemory<char> AsMemory() => throw null;
        public Command() => throw null;
        public int IndexOfMethodEnd(System.ReadOnlyMemory<char> commandsString, int pos) => throw null;
        public string Name { get => throw null; set { } }
        public System.ReadOnlyMemory<char> Original { get => throw null; set { } }
        public System.ReadOnlyMemory<char> Suffix { get => throw null; set { } }
        public virtual string ToDebugString() => throw null;
        public override string ToString() => throw null;
    }
    public class CommandsUtils
    {
        public CommandsUtils() => throw null;
        public static void ExecuteAsyncCommandExec(System.TimeSpan timeout, System.Collections.Generic.IEnumerable<ServiceStack.Commands.ICommandExec> commands) => throw null;
        public static System.Collections.Generic.List<System.Threading.WaitHandle> ExecuteAsyncCommandExec(System.Collections.Generic.IEnumerable<ServiceStack.Commands.ICommandExec> commands) => throw null;
        public static System.Collections.Generic.List<T> ExecuteAsyncCommandList<T>(System.TimeSpan timeout, params ServiceStack.Commands.ICommandList<T>[] commands) => throw null;
        public static System.Collections.Generic.List<T> ExecuteAsyncCommandList<T>(System.TimeSpan timeout, System.Collections.Generic.IEnumerable<ServiceStack.Commands.ICommandList<T>> commands) => throw null;
        public static void WaitAll(System.Threading.WaitHandle[] waitHandles, System.TimeSpan timeout) => throw null;
    }
    public static class CommonDiagnosticUtils
    {
        public static void Init(this System.Diagnostics.DiagnosticListener listener, ServiceStack.Messaging.IMessage msg) => throw null;
    }
    public class ConnectionInfo
    {
        public string ConnectionString { get => throw null; set { } }
        public ConnectionInfo() => throw null;
        public string NamedConnection { get => throw null; set { } }
        public string ProviderName { get => throw null; set { } }
    }
    public static partial class ContainerExtensions
    {
        public static ServiceStack.IContainer AddSingleton<TService>(this ServiceStack.IContainer container) => throw null;
        public static ServiceStack.IContainer AddSingleton<TService>(this ServiceStack.IContainer container, System.Func<TService> factory) => throw null;
        public static ServiceStack.IContainer AddSingleton<TService, TImpl>(this ServiceStack.IContainer container) where TImpl : TService => throw null;
        public static ServiceStack.IContainer AddSingleton(this ServiceStack.IContainer container, System.Type type) => throw null;
        public static ServiceStack.IContainer AddTransient<TService>(this ServiceStack.IContainer container) => throw null;
        public static ServiceStack.IContainer AddTransient<TService>(this ServiceStack.IContainer container, System.Func<TService> factory) => throw null;
        public static ServiceStack.IContainer AddTransient<TService, TImpl>(this ServiceStack.IContainer container) where TImpl : TService => throw null;
        public static ServiceStack.IContainer AddTransient(this ServiceStack.IContainer container, System.Type type) => throw null;
        public static bool Exists<T>(this ServiceStack.IContainer container) => throw null;
        public static T Resolve<T>(this ServiceStack.Configuration.IResolver container) => throw null;
        public static T Resolve<T>(this ServiceStack.IContainer container) => throw null;
    }
    namespace Data
    {
        public class DbConnectionFactory : ServiceStack.Data.IDbConnectionFactory
        {
            public System.Data.IDbConnection CreateDbConnection() => throw null;
            public DbConnectionFactory(System.Func<System.Data.IDbConnection> connectionFactoryFn) => throw null;
            public System.Data.IDbConnection OpenDbConnection() => throw null;
        }
        public interface IDbConnectionFactory
        {
            System.Data.IDbConnection CreateDbConnection();
            System.Data.IDbConnection OpenDbConnection();
        }
        public interface IDbConnectionFactoryExtended : ServiceStack.Data.IDbConnectionFactory
        {
            System.Data.IDbConnection OpenDbConnection(string namedConnection);
            System.Data.IDbConnection OpenDbConnectionString(string connectionString);
            System.Data.IDbConnection OpenDbConnectionString(string connectionString, string providerName);
        }
        public interface IHasDbCommand
        {
            System.Data.IDbCommand DbCommand { get; }
        }
        public interface IHasDbConnection
        {
            System.Data.IDbConnection DbConnection { get; }
        }
        public interface IHasDbTransaction
        {
            System.Data.IDbTransaction DbTransaction { get; }
        }
    }
    public static partial class DictionaryExtensions
    {
        public static System.Collections.Generic.List<T> ConvertAll<T, K, V>(System.Collections.Generic.IDictionary<K, V> map, System.Func<K, V, T> createFn) => throw null;
        public static void ForEach<TKey, TValue>(this System.Collections.Generic.Dictionary<TKey, TValue> dictionary, System.Action<TKey, TValue> onEachFn) => throw null;
        public static V GetOrAdd<K, V>(this System.Collections.Generic.Dictionary<K, V> map, K key, System.Func<K, V> createFn) => throw null;
        public static TValue GetValue<TValue, TKey>(this System.Collections.Generic.Dictionary<TKey, TValue> dictionary, TKey key, System.Func<TValue> defaultValue) => throw null;
        public static TValue GetValueOrDefault<TValue, TKey>(this System.Collections.Generic.Dictionary<TKey, TValue> dictionary, TKey key) => throw null;
        public static bool IsNullOrEmpty(this System.Collections.IDictionary dictionary) => throw null;
        public static System.Collections.Generic.Dictionary<TKey, TValue> Merge<TKey, TValue>(this System.Collections.Generic.IDictionary<TKey, TValue> initial, params System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey, TValue>>[] withSources) => throw null;
        public static System.Collections.Generic.Dictionary<TKey, TValue> MoveKey<TKey, TValue>(this System.Collections.Generic.Dictionary<TKey, TValue> map, TKey oldKey, TKey newKey, System.Func<TValue, TValue> valueFilter = default(System.Func<TValue, TValue>)) => throw null;
        public static System.Collections.Generic.KeyValuePair<TKey, TValue> PairWith<TKey, TValue>(this TKey key, TValue value) => throw null;
        public static System.Collections.Generic.Dictionary<TKey, TValue> RemoveKey<TKey, TValue>(this System.Collections.Generic.Dictionary<TKey, TValue> map, TKey key) => throw null;
        public static System.Collections.Concurrent.ConcurrentDictionary<TKey, TValue> ToConcurrentDictionary<TKey, TValue>(this System.Collections.Generic.IDictionary<TKey, TValue> from) => throw null;
        public static System.Collections.Generic.Dictionary<TKey, TValue> ToDictionary<TKey, TValue>(this System.Collections.Concurrent.ConcurrentDictionary<TKey, TValue> map) => throw null;
        public static bool TryRemove<TKey, TValue>(this System.Collections.Generic.Dictionary<TKey, TValue> map, TKey key, out TValue value) => throw null;
        public static bool UnorderedEquivalentTo<K, V>(this System.Collections.Generic.IDictionary<K, V> thisMap, System.Collections.Generic.IDictionary<K, V> otherMap) => throw null;
    }
    public static partial class DirectoryInfoExtensions
    {
        public static System.Collections.Generic.IEnumerable<string> GetMatchingFiles(this System.IO.DirectoryInfo rootDirPath, string fileSearchPattern) => throw null;
        public static System.Collections.Generic.IEnumerable<string> GetMatchingFiles(string rootDirPath, string fileSearchPattern) => throw null;
    }
    public static partial class DisposableExtensions
    {
        public static void Dispose(this System.Collections.Generic.IEnumerable<System.IDisposable> resources, ServiceStack.Logging.ILog log) => throw null;
        public static void Dispose(this System.Collections.Generic.IEnumerable<System.IDisposable> resources) => throw null;
        public static void Dispose(params System.IDisposable[] disposables) => throw null;
        public static void Run<T>(this T disposable, System.Action<T> runActionThenDispose) where T : System.IDisposable => throw null;
    }
    public static partial class EnumerableExtensions
    {
        public static System.Threading.Tasks.Task<bool> AllAsync<T>(this System.Collections.Generic.IEnumerable<T> source, System.Func<T, System.Threading.Tasks.Task<bool>> predicate) => throw null;
        public static System.Threading.Tasks.Task<bool> AllAsync<T>(this System.Collections.Generic.IEnumerable<System.Threading.Tasks.Task<T>> source, System.Func<T, bool> predicate) => throw null;
        public static System.Collections.Generic.List<string> AllKeysWithDefaultValues(System.Collections.IEnumerable collection) => throw null;
        public static System.Threading.Tasks.Task<bool> AnyAsync<T>(this System.Collections.Generic.IEnumerable<T> source, System.Func<T, System.Threading.Tasks.Task<bool>> predicate) => throw null;
        public static System.Threading.Tasks.Task<bool> AnyAsync<T>(this System.Collections.Generic.IEnumerable<System.Threading.Tasks.Task<T>> source, System.Func<T, bool> predicate) => throw null;
        public static System.Collections.Generic.IEnumerable<T[]> BatchesOf<T>(this System.Collections.Generic.IEnumerable<T> sequence, int batchSize) => throw null;
        public static T[] CombineDistinct<T>(this T[] original, params T[][] others) => throw null;
        public static System.Collections.Generic.HashSet<T> CombineSet<T>(this T[] original, params T[][] others) => throw null;
        public static void Each<T>(this System.Collections.Generic.IEnumerable<T> values, System.Action<T> action) => throw null;
        public static void Each<T>(this System.Collections.Generic.IEnumerable<T> values, System.Action<int, T> action) => throw null;
        public static void Each<TKey, TValue>(this System.Collections.Generic.IDictionary<TKey, TValue> map, System.Action<TKey, TValue> action) => throw null;
        public static bool EquivalentTo(this byte[] bytes, byte[] other) => throw null;
        public static bool EquivalentTo<T>(this T[] array, T[] otherArray, System.Func<T, T, bool> comparer = default(System.Func<T, T, bool>)) => throw null;
        public static bool EquivalentTo<T>(this System.Collections.Generic.IEnumerable<T> thisList, System.Collections.Generic.IEnumerable<T> otherList, System.Func<T, T, bool> comparer = default(System.Func<T, T, bool>)) => throw null;
        public static bool EquivalentTo<K, V>(this System.Collections.Generic.IDictionary<K, V> a, System.Collections.Generic.IDictionary<K, V> b, System.Func<V, V, bool> comparer = default(System.Func<V, V, bool>)) => throw null;
        public static System.Type FirstElementType(System.Collections.IEnumerable collection, string key) => throw null;
        public static T FirstNonDefault<T>(this System.Collections.Generic.IEnumerable<T> values) => throw null;
        public static string FirstNonDefaultOrEmpty(this System.Collections.Generic.IEnumerable<string> values) => throw null;
        public static bool IsEmpty<T>(this System.Collections.Generic.ICollection<T> collection) => throw null;
        public static bool IsEmpty<T>(this T[] collection) => throw null;
        public static System.Collections.Generic.List<To> Map<To, From>(this System.Collections.Generic.IEnumerable<From> items, System.Func<From, To> converter) => throw null;
        public static System.Collections.Generic.List<To> Map<To>(this System.Collections.IEnumerable items, System.Func<object, To> converter) => throw null;
        public static System.Collections.Generic.IEnumerable<T> Safe<T>(this System.Collections.Generic.IEnumerable<T> enumerable) => throw null;
        public static System.Collections.IEnumerable Safe(this System.Collections.IEnumerable enumerable) => throw null;
        public static System.Collections.Generic.Dictionary<TKey, TValue> ToDictionary<T, TKey, TValue>(this System.Collections.Generic.IEnumerable<T> list, System.Func<T, System.Collections.Generic.KeyValuePair<TKey, TValue>> map) => throw null;
        public static System.Collections.Generic.HashSet<T> ToHashSet<T>(this System.Collections.Generic.IEnumerable<T> items) => throw null;
        public static System.Collections.Generic.List<object> ToObjects<T>(this System.Collections.Generic.IEnumerable<T> items) => throw null;
        public static System.Collections.Generic.Dictionary<TKey, T> ToSafeDictionary<T, TKey>(this System.Collections.Generic.IEnumerable<T> list, System.Func<T, TKey> expr) => throw null;
        public static System.Collections.Generic.HashSet<T> ToSet<T>(this System.Collections.Generic.IEnumerable<T> items) => throw null;
        public static System.Collections.Generic.HashSet<T> ToSet<T>(this System.Collections.Generic.IEnumerable<T> items, System.Collections.Generic.IEqualityComparer<T> comparer) => throw null;
    }
    public static class EnumerableUtils
    {
        public static int Count(System.Collections.IEnumerable items) => throw null;
        public static object ElementAt(System.Collections.IEnumerable items, int index) => throw null;
        public static object FirstOrDefault(System.Collections.IEnumerable items) => throw null;
        public static bool IsEmpty(System.Collections.IEnumerable items) => throw null;
        public static System.Collections.IEnumerable NullIfEmpty(System.Collections.IEnumerable items) => throw null;
        public static System.Collections.Generic.List<object> Skip(System.Collections.IEnumerable items, int count) => throw null;
        public static System.Collections.Generic.List<object> SplitOnFirst(System.Collections.IEnumerable items, out object first) => throw null;
        public static System.Collections.Generic.List<object> Take(System.Collections.IEnumerable items, int count) => throw null;
        public static System.Collections.Generic.List<object> ToList(System.Collections.IEnumerable items) => throw null;
    }
    public static partial class EnumExtensions
    {
        public static T Add<T>(this System.Enum @enum, T value) => throw null;
        public static System.TypeCode GetTypeCode(this System.Enum @enum) => throw null;
        public static bool Has<T>(this System.Enum @enum, T value) => throw null;
        public static bool Is<T>(this System.Enum @enum, T value) => throw null;
        public static T Remove<T>(this System.Enum @enum, T value) => throw null;
        public static string ToDescription(this System.Enum @enum) => throw null;
        public static System.Collections.Generic.List<System.Collections.Generic.KeyValuePair<string, string>> ToKeyValuePairs<T>(this System.Collections.Generic.IEnumerable<T> enums) where T : System.Enum => throw null;
        public static System.Collections.Generic.List<string> ToList(this System.Enum @enum) => throw null;
    }
    public static class EnumUtils
    {
        public static object FromEnumFlagsList(System.Type enumType, System.Collections.Generic.List<string> enums) => throw null;
        public static T FromEnumFlagsList<T>(System.Collections.Generic.List<string> enums) where T : System.Enum => throw null;
        public static System.Reflection.FieldInfo GetEnumMember(System.Type type, string name) => throw null;
        public static System.Collections.Generic.IEnumerable<T> GetValues<T>() where T : System.Enum => throw null;
        public static System.Collections.Generic.List<string> ToEnumFlagsList(this System.Enum enumValue) => throw null;
    }
    public static class ExecUtils
    {
        public static int BaseDelayMs { get => throw null; set { } }
        public static int CalculateExponentialDelay(int retriesAttempted) => throw null;
        public static int CalculateExponentialDelay(int retriesAttempted, int baseDelay, int maxBackOffMs) => throw null;
        public static int CalculateFullJitterBackOffDelay(int retriesAttempted) => throw null;
        public static int CalculateFullJitterBackOffDelay(int retriesAttempted, int baseDelay, int maxBackOffMs) => throw null;
        public static int CalculateMemoryLockDelay(int retries) => throw null;
        public static System.Threading.Tasks.Task DelayBackOffMultiplierAsync(int retriesAttempted) => throw null;
        public static void ExecAll<T>(this System.Collections.Generic.IEnumerable<T> instances, System.Action<T> action) => throw null;
        public static System.Threading.Tasks.Task ExecAllAsync<T>(this System.Collections.Generic.IEnumerable<T> instances, System.Func<T, System.Threading.Tasks.Task> action) => throw null;
        public static System.Threading.Tasks.Task<TReturn> ExecAllReturnFirstAsync<T, TReturn>(this System.Collections.Generic.IEnumerable<T> instances, System.Func<T, System.Threading.Tasks.Task<TReturn>> action) => throw null;
        public static void ExecAllWithFirstOut<T, TReturn>(this System.Collections.Generic.IEnumerable<T> instances, System.Func<T, TReturn> action, ref TReturn firstResult) => throw null;
        public static TReturn ExecReturnFirstWithResult<T, TReturn>(this System.Collections.Generic.IEnumerable<T> instances, System.Func<T, TReturn> action) => throw null;
        public static System.Threading.Tasks.Task<TReturn> ExecReturnFirstWithResultAsync<T, TReturn>(this System.Collections.Generic.IEnumerable<T> instances, System.Func<T, System.Threading.Tasks.Task<TReturn>> action) => throw null;
        public static void LogError(System.Type declaringType, string clientMethodName, System.Exception ex) => throw null;
        public static int MaxBackOffMs { get => throw null; set { } }
        public static int MaxRetries { get => throw null; set { } }
        public static void RetryOnException(System.Action action, System.TimeSpan? timeOut) => throw null;
        public static void RetryOnException(System.Action action, int maxRetries) => throw null;
        public static System.Threading.Tasks.Task RetryOnExceptionAsync(System.Func<System.Threading.Tasks.Task> action, System.TimeSpan? timeOut) => throw null;
        public static System.Threading.Tasks.Task RetryOnExceptionAsync(System.Func<System.Threading.Tasks.Task> action, int maxRetries) => throw null;
        public static void RetryUntilTrue(System.Func<bool> action, System.TimeSpan? timeOut = default(System.TimeSpan?)) => throw null;
        public static System.Threading.Tasks.Task RetryUntilTrueAsync(System.Func<System.Threading.Tasks.Task<bool>> action, System.TimeSpan? timeOut = default(System.TimeSpan?)) => throw null;
        public static string ShellExec(string command, System.Collections.Generic.Dictionary<string, object> args = default(System.Collections.Generic.Dictionary<string, object>)) => throw null;
        public static void SleepBackOffMultiplier(int retriesAttempted) => throw null;
    }
    public static class ExpressionUtils
    {
        public static System.Collections.Generic.Dictionary<string, object> AssignedValues<T>(this System.Linq.Expressions.Expression<System.Func<T>> expr) => throw null;
        public static string[] GetFieldNames<T>(this System.Linq.Expressions.Expression<System.Func<T, object>> expr) => throw null;
        public static System.Linq.Expressions.MemberExpression GetMemberExpression<T>(System.Linq.Expressions.Expression<System.Func<T, object>> expr) => throw null;
        public static string GetMemberName<T>(System.Linq.Expressions.Expression<System.Func<T, object>> fieldExpr) => throw null;
        public static object GetValue(this System.Linq.Expressions.MemberBinding binding) => throw null;
        public static System.Reflection.PropertyInfo ToPropertyInfo(this System.Linq.Expressions.Expression fieldExpr) => throw null;
        public static System.Reflection.PropertyInfo ToPropertyInfo(System.Linq.Expressions.LambdaExpression lambda) => throw null;
        public static System.Reflection.PropertyInfo ToPropertyInfo(System.Linq.Expressions.MemberExpression m) => throw null;
    }
    namespace Extensions
    {
        public static partial class UtilExtensions
        {
        }
    }
    public static class FuncUtils
    {
        public static bool TryExec(System.Action action) => throw null;
        public static T TryExec<T>(System.Func<T> func) => throw null;
        public static T TryExec<T>(System.Func<T> func, T defaultValue) => throw null;
        public static void WaitWhile(System.Func<bool> condition, int millisecondTimeout, int millisecondPollPeriod = default(int)) => throw null;
    }
    public class Gist
    {
        public System.DateTime Created_At { get => throw null; set { } }
        public Gist() => throw null;
        public string Description { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, ServiceStack.GistFile> Files { get => throw null; set { } }
        public string Html_Url { get => throw null; set { } }
        public string Id { get => throw null; set { } }
        public bool Public { get => throw null; set { } }
        public System.DateTime? Updated_At { get => throw null; set { } }
        public string Url { get => throw null; set { } }
        public string UserId { get => throw null; set { } }
    }
    public class GistChangeStatus
    {
        public int Additions { get => throw null; set { } }
        public GistChangeStatus() => throw null;
        public int Deletions { get => throw null; set { } }
        public int Total { get => throw null; set { } }
    }
    public class GistFile
    {
        public string Content { get => throw null; set { } }
        public GistFile() => throw null;
        public string Filename { get => throw null; set { } }
        public string Language { get => throw null; set { } }
        public string Raw_Url { get => throw null; set { } }
        public int Size { get => throw null; set { } }
        public bool Truncated { get => throw null; set { } }
        public string Type { get => throw null; set { } }
    }
    public class GistHistory
    {
        public ServiceStack.GistChangeStatus Change_Status { get => throw null; set { } }
        public System.DateTime Committed_At { get => throw null; set { } }
        public GistHistory() => throw null;
        public string Url { get => throw null; set { } }
        public ServiceStack.GithubUser User { get => throw null; set { } }
        public string Version { get => throw null; set { } }
    }
    public class GistLink
    {
        public GistLink() => throw null;
        public string Description { get => throw null; set { } }
        public static ServiceStack.GistLink Get(System.Collections.Generic.List<ServiceStack.GistLink> links, string gistAlias) => throw null;
        public string GistId { get => throw null; set { } }
        public bool MatchesTag(string tagName) => throw null;
        public System.Collections.Generic.Dictionary<string, object> Modifiers { get => throw null; set { } }
        public string Name { get => throw null; set { } }
        public static System.Collections.Generic.List<ServiceStack.GistLink> Parse(string md) => throw null;
        public static string RenderLinks(System.Collections.Generic.List<ServiceStack.GistLink> links) => throw null;
        public string Repo { get => throw null; set { } }
        public string[] Tags { get => throw null; set { } }
        public string To { get => throw null; set { } }
        public string ToListItem() => throw null;
        public override string ToString() => throw null;
        public string ToTagsString() => throw null;
        public static bool TryParseGitHubUrl(string url, out string gistId, out string user, out string repo) => throw null;
        public string Url { get => throw null; set { } }
        public string User { get => throw null; set { } }
    }
    public class GistUser
    {
        public string Avatar_Url { get => throw null; set { } }
        public GistUser() => throw null;
        public string Gists_Url { get => throw null; set { } }
        public string Gravatar_Id { get => throw null; set { } }
        public string Html_Url { get => throw null; set { } }
        public long Id { get => throw null; set { } }
        public string Login { get => throw null; set { } }
        public bool Site_Admin { get => throw null; set { } }
        public string Type { get => throw null; set { } }
        public string Url { get => throw null; set { } }
    }
    public class GitHubGateway : ServiceStack.IGistGateway, ServiceStack.IGitHubGateway
    {
        public string AccessToken { get => throw null; set { } }
        public const string ApiBaseUrl = default;
        public virtual void ApplyRequestFilters(System.Net.Http.HttpRequestMessage req) => throw null;
        protected virtual void AssertAccessToken() => throw null;
        public virtual System.Tuple<string, string> AssertRepo(string[] orgs, string name, bool useFork = default(bool)) => throw null;
        public string BaseUrl { get => throw null; set { } }
        public virtual ServiceStack.Gist CreateGist(string description, bool isPublic, System.Collections.Generic.Dictionary<string, object> files) => throw null;
        public virtual ServiceStack.Gist CreateGist(string description, bool isPublic, System.Collections.Generic.Dictionary<string, string> textFiles) => throw null;
        public virtual void CreateGistFile(string gistId, string filePath, string contents) => throw null;
        public virtual ServiceStack.GithubGist CreateGithubGist(string description, bool isPublic, System.Collections.Generic.Dictionary<string, object> files) => throw null;
        public virtual ServiceStack.GithubGist CreateGithubGist(string description, bool isPublic, System.Collections.Generic.Dictionary<string, string> textFiles) => throw null;
        public GitHubGateway() => throw null;
        public GitHubGateway(string accessToken) => throw null;
        public virtual void DeleteGistFiles(string gistId, params string[] filePaths) => throw null;
        public virtual void DownloadFile(string downloadUrl, string fileName) => throw null;
        public virtual System.Tuple<string, string> FindRepo(string[] orgs, string name, bool useFork = default(bool)) => throw null;
        public virtual ServiceStack.Gist GetGist(string gistId) => throw null;
        public ServiceStack.Gist GetGist(string gistId, string version) => throw null;
        public System.Threading.Tasks.Task<ServiceStack.Gist> GetGistAsync(string gistId) => throw null;
        public System.Threading.Tasks.Task<ServiceStack.Gist> GetGistAsync(string gistId, string version) => throw null;
        public virtual ServiceStack.GithubGist GetGithubGist(string gistId) => throw null;
        public virtual ServiceStack.GithubGist GetGithubGist(string gistId, string version) => throw null;
        public virtual string GetJson(string route) => throw null;
        public virtual T GetJson<T>(string route) => throw null;
        public virtual System.Threading.Tasks.Task<string> GetJsonAsync(string route) => throw null;
        public virtual System.Threading.Tasks.Task<T> GetJsonAsync<T>(string route) => throw null;
        public virtual System.Threading.Tasks.Task<System.Collections.Generic.List<T>> GetJsonCollectionAsync<T>(string route) => throw null;
        public System.Func<string, string> GetJsonFilter { get => throw null; set { } }
        public virtual System.Collections.Generic.List<ServiceStack.GithubRepo> GetOrgRepos(string githubOrg) => throw null;
        public virtual System.Threading.Tasks.Task<System.Collections.Generic.List<ServiceStack.GithubRepo>> GetOrgReposAsync(string githubOrg) => throw null;
        public ServiceStack.GithubRateLimits GetRateLimits() => throw null;
        public System.Threading.Tasks.Task<ServiceStack.GithubRateLimits> GetRateLimitsAsync() => throw null;
        public virtual ServiceStack.GithubRepo GetRepo(string userOrOrg, string repo) => throw null;
        public virtual System.Threading.Tasks.Task<ServiceStack.GithubRepo> GetRepoAsync(string userOrOrg, string repo) => throw null;
        public virtual System.Threading.Tasks.Task<System.Collections.Generic.List<ServiceStack.GithubRepo>> GetSourceReposAsync(string orgName) => throw null;
        public virtual string GetSourceZipUrl(string user, string repo) => throw null;
        public virtual string GetSourceZipUrl(string user, string repo, string tag) => throw null;
        public virtual System.Threading.Tasks.Task<string> GetSourceZipUrlAsync(string user, string repo) => throw null;
        public virtual System.Threading.Tasks.Task<System.Collections.Generic.List<ServiceStack.GithubRepo>> GetUserAndOrgReposAsync(string githubOrgOrUser) => throw null;
        public virtual System.Collections.Generic.List<ServiceStack.GithubRepo> GetUserRepos(string githubUser) => throw null;
        public virtual System.Threading.Tasks.Task<System.Collections.Generic.List<ServiceStack.GithubRepo>> GetUserReposAsync(string githubUser) => throw null;
        public static bool IsDirSep(char c) => throw null;
        public virtual System.Collections.Generic.Dictionary<string, string> ParseLinkUrls(string linkHeader) => throw null;
        public virtual System.Collections.Generic.IEnumerable<T> StreamJsonCollection<T>(string route) => throw null;
        public static System.Collections.Generic.Dictionary<string, string> ToTextFiles(System.Collections.Generic.Dictionary<string, object> files) => throw null;
        public string UserAgent { get => throw null; set { } }
        public virtual void WriteGistFile(string gistId, string filePath, string contents) => throw null;
        public virtual void WriteGistFiles(string gistId, System.Collections.Generic.Dictionary<string, object> files, string description = default(string), bool deleteMissing = default(bool)) => throw null;
        public virtual void WriteGistFiles(string gistId, System.Collections.Generic.Dictionary<string, string> textFiles, string description = default(string), bool deleteMissing = default(bool)) => throw null;
    }
    public class GithubGist : ServiceStack.Gist
    {
        public int Comments { get => throw null; set { } }
        public string Comments_Url { get => throw null; set { } }
        public string Commits_Url { get => throw null; set { } }
        public GithubGist() => throw null;
        public string Forks_Url { get => throw null; set { } }
        public string Git_Pull_Url { get => throw null; set { } }
        public string Git_Push_Url { get => throw null; set { } }
        public ServiceStack.GistHistory[] History { get => throw null; set { } }
        public string Node_Id { get => throw null; set { } }
        public ServiceStack.GithubUser Owner { get => throw null; set { } }
        public bool Truncated { get => throw null; set { } }
    }
    public class GithubRateLimit
    {
        public GithubRateLimit() => throw null;
        public int Limit { get => throw null; set { } }
        public int Remaining { get => throw null; set { } }
        public long Reset { get => throw null; set { } }
        public int Used { get => throw null; set { } }
    }
    public class GithubRateLimits
    {
        public GithubRateLimits() => throw null;
        public ServiceStack.GithubResourcesRateLimits Resources { get => throw null; set { } }
    }
    public class GithubRepo
    {
        public System.DateTime Created_At { get => throw null; set { } }
        public GithubRepo() => throw null;
        public string Description { get => throw null; set { } }
        public bool Fork { get => throw null; set { } }
        public string Full_Name { get => throw null; set { } }
        public bool Has_Downloads { get => throw null; set { } }
        public string Homepage { get => throw null; set { } }
        public string Html_Url { get => throw null; set { } }
        public int Id { get => throw null; set { } }
        public string Name { get => throw null; set { } }
        public ServiceStack.GithubRepo Parent { get => throw null; set { } }
        public bool Private { get => throw null; set { } }
        public int Size { get => throw null; set { } }
        public int Stargazers_Count { get => throw null; set { } }
        public System.DateTime? Updated_At { get => throw null; set { } }
        public string Url { get => throw null; set { } }
        public int Watchers_Count { get => throw null; set { } }
    }
    public class GithubResourcesRateLimits
    {
        public ServiceStack.GithubRateLimit Core { get => throw null; set { } }
        public GithubResourcesRateLimits() => throw null;
        public ServiceStack.GithubRateLimit Graphql { get => throw null; set { } }
        public ServiceStack.GithubRateLimit Integration_Manifest { get => throw null; set { } }
        public ServiceStack.GithubRateLimit Search { get => throw null; set { } }
    }
    public class GithubUser : ServiceStack.GistUser
    {
        public GithubUser() => throw null;
        public string Events_Url { get => throw null; set { } }
        public string Followers_Url { get => throw null; set { } }
        public string Following_Url { get => throw null; set { } }
        public string Node_Id { get => throw null; set { } }
        public string Organizations_Url { get => throw null; set { } }
        public string Received_Events_Url { get => throw null; set { } }
        public string Repos_Url { get => throw null; set { } }
        public string Starred_Url { get => throw null; set { } }
        public string Subscriptions_Url { get => throw null; set { } }
    }
    public class HtmlDumpOptions
    {
        public string Caption { get => throw null; set { } }
        public string CaptionIfEmpty { get => throw null; set { } }
        public string ChildClass { get => throw null; set { } }
        public string ClassName { get => throw null; set { } }
        public HtmlDumpOptions() => throw null;
        public ServiceStack.Script.DefaultScripts Defaults { get => throw null; set { } }
        public string Display { get => throw null; set { } }
        public string[] Headers { get => throw null; set { } }
        public ServiceStack.TextStyle HeaderStyle { get => throw null; set { } }
        public string HeaderTag { get => throw null; set { } }
        public string Id { get => throw null; set { } }
        public static ServiceStack.HtmlDumpOptions Parse(System.Collections.Generic.Dictionary<string, object> options, ServiceStack.Script.DefaultScripts defaults = default(ServiceStack.Script.DefaultScripts)) => throw null;
    }
    public interface IAppTask
    {
        System.DateTime? CompletedDate { get; set; }
        System.Exception Error { get; set; }
        string Log { get; set; }
        System.DateTime? StartedAt { get; set; }
    }
    public static class IdUtils<T>
    {
        public static object GetId(T entity) => throw null;
    }
    public static class IdUtils
    {
        public static string CreateCacheKeyPath<T>(string idValue) => throw null;
        public static string CreateUrn<T>(object id) => throw null;
        public static string CreateUrn(System.Type type, object id) => throw null;
        public static string CreateUrn(string type, object id) => throw null;
        public static string CreateUrn<T>(this T entity) => throw null;
        public static object GetId<T>(this T entity) => throw null;
        public static System.Reflection.PropertyInfo GetIdProperty(this System.Type type) => throw null;
        public static object GetObjectId(this object entity) => throw null;
        public const string IdField = default;
        public static object ToId<T>(this T entity) => throw null;
        public static string ToSafePathCacheKey<T>(this string idValue) => throw null;
        public static string ToUrn<T>(this T entity) => throw null;
        public static string ToUrn<T>(this object id) => throw null;
    }
    public interface IGistGateway
    {
        ServiceStack.Gist CreateGist(string description, bool isPublic, System.Collections.Generic.Dictionary<string, object> files);
        ServiceStack.Gist CreateGist(string description, bool isPublic, System.Collections.Generic.Dictionary<string, string> textFiles);
        void CreateGistFile(string gistId, string filePath, string contents);
        void DeleteGistFiles(string gistId, params string[] filePaths);
        ServiceStack.Gist GetGist(string gistId);
        ServiceStack.Gist GetGist(string gistId, string version);
        System.Threading.Tasks.Task<ServiceStack.Gist> GetGistAsync(string gistId);
        System.Threading.Tasks.Task<ServiceStack.Gist> GetGistAsync(string gistId, string version);
        void WriteGistFile(string gistId, string filePath, string contents);
        void WriteGistFiles(string gistId, System.Collections.Generic.Dictionary<string, object> files, string description = default(string), bool deleteMissing = default(bool));
        void WriteGistFiles(string gistId, System.Collections.Generic.Dictionary<string, string> textFiles, string description = default(string), bool deleteMissing = default(bool));
    }
    public interface IGitHubGateway : ServiceStack.IGistGateway
    {
        void DownloadFile(string downloadUrl, string fileName);
        System.Tuple<string, string> FindRepo(string[] orgs, string name, bool useFork = default(bool));
        string GetJson(string route);
        T GetJson<T>(string route);
        System.Threading.Tasks.Task<string> GetJsonAsync(string route);
        System.Threading.Tasks.Task<T> GetJsonAsync<T>(string route);
        System.Threading.Tasks.Task<System.Collections.Generic.List<T>> GetJsonCollectionAsync<T>(string route);
        System.Collections.Generic.List<ServiceStack.GithubRepo> GetOrgRepos(string githubOrg);
        System.Threading.Tasks.Task<System.Collections.Generic.List<ServiceStack.GithubRepo>> GetOrgReposAsync(string githubOrg);
        ServiceStack.GithubRepo GetRepo(string userOrOrg, string repo);
        System.Threading.Tasks.Task<ServiceStack.GithubRepo> GetRepoAsync(string userOrOrg, string repo);
        System.Threading.Tasks.Task<System.Collections.Generic.List<ServiceStack.GithubRepo>> GetSourceReposAsync(string orgName);
        string GetSourceZipUrl(string user, string repo);
        System.Threading.Tasks.Task<string> GetSourceZipUrlAsync(string user, string repo);
        System.Threading.Tasks.Task<System.Collections.Generic.List<ServiceStack.GithubRepo>> GetUserAndOrgReposAsync(string githubOrgOrUser);
        System.Collections.Generic.List<ServiceStack.GithubRepo> GetUserRepos(string githubUser);
        System.Threading.Tasks.Task<System.Collections.Generic.List<ServiceStack.GithubRepo>> GetUserReposAsync(string githubUser);
        System.Collections.Generic.IEnumerable<T> StreamJsonCollection<T>(string route);
    }
    public class InputOptions
    {
        public InputOptions() => throw null;
        public string ErrorClass { get => throw null; set { } }
        public string Help { get => throw null; set { } }
        public bool Inline { get => throw null; set { } }
        public System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> InputValues { set { } }
        public string Label { get => throw null; set { } }
        public string LabelClass { get => throw null; set { } }
        public bool PreserveValue { get => throw null; set { } }
        public bool ShowErrors { get => throw null; set { } }
        public string Size { get => throw null; set { } }
        public object Values { get => throw null; set { } }
    }
    public static class Inspect
    {
        public static class Config
        {
            public static void DefaultVarsFilter(object anonArgs) => throw null;
            public static System.Func<object, string> DumpTableFilter { get => throw null; set { } }
            public static System.Action<object> VarsFilter { get => throw null; set { } }
            public const string VarsName = default;
        }
        public static string dump<T>(T instance) => throw null;
        public static string dumpTable(object instance) => throw null;
        public static string dumpTable(object instance, ServiceStack.TextDumpOptions options) => throw null;
        public static string dumpTable(object instance, string[] headers) => throw null;
        public static string htmlDump(object target) => throw null;
        public static string htmlDump(object target, ServiceStack.HtmlDumpOptions options) => throw null;
        public static string htmlDump(object target, string[] headers) => throw null;
        public static void printDump<T>(T instance) => throw null;
        public static void printDumpTable(object instance) => throw null;
        public static void printDumpTable(object instance, string[] headers) => throw null;
        public static void printHtmlDump(object instance) => throw null;
        public static void printHtmlDump(object instance, string[] headers) => throw null;
        public static void vars(object anonArgs) => throw null;
    }
    public delegate object InstanceMapper(object instance);
    public static partial class IntExtensions
    {
        public static System.Collections.Generic.IEnumerable<int> Times(this int times) => throw null;
        public static void Times(this int times, System.Action<int> actionFn) => throw null;
        public static void Times(this int times, System.Action actionFn) => throw null;
        public static System.Collections.Generic.List<T> Times<T>(this int times, System.Func<T> actionFn) => throw null;
        public static System.Collections.Generic.List<T> Times<T>(this int times, System.Func<int, T> actionFn) => throw null;
        public static System.Threading.Tasks.Task TimesAsync(this int times, System.Func<int, System.Threading.Tasks.Task> actionFn, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<System.Collections.Generic.List<T>> TimesAsync<T>(this int times, System.Func<int, System.Threading.Tasks.Task<T>> actionFn, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Collections.Generic.List<System.IAsyncResult> TimesAsync(this int times, System.Action<int> actionFn) => throw null;
        public static System.Collections.Generic.List<System.IAsyncResult> TimesAsync(this int times, System.Action actionFn) => throw null;
    }
    namespace IO
    {
        public class FileContents
        {
            public FileContents(System.IO.Stream stream) => throw null;
            public FileContents(string text) => throw null;
            public static System.Threading.Tasks.Task<ServiceStack.IO.FileContents> GetAsync(object contents, bool buffer = default(bool)) => throw null;
            public System.IO.Stream Stream { get => throw null; }
            public string Text { get => throw null; }
        }
        public class FileSystemVirtualFiles : ServiceStack.VirtualPath.AbstractVirtualPathProviderBase, ServiceStack.IO.IVirtualFiles, ServiceStack.IO.IVirtualPathProvider
        {
            public void AppendFile(string filePath, string textContents) => throw null;
            public void AppendFile(string filePath, System.IO.Stream stream) => throw null;
            public static string AssertDirectory(string dirPath, int timeoutMs = default(int)) => throw null;
            public static void CopyAll(System.IO.DirectoryInfo source, System.IO.DirectoryInfo target) => throw null;
            public FileSystemVirtualFiles(string rootDirectoryPath) => throw null;
            public FileSystemVirtualFiles(System.IO.DirectoryInfo rootDirInfo) => throw null;
            public static void DeleteDirectory(string path) => throw null;
            public void DeleteFile(string filePath) => throw null;
            public void DeleteFiles(System.Collections.Generic.IEnumerable<string> filePaths) => throw null;
            public void DeleteFolder(string dirPath) => throw null;
            public override bool DirectoryExists(string virtualPath) => throw null;
            public string EnsureDirectory(string dirPath) => throw null;
            public override bool FileExists(string virtualPath) => throw null;
            protected override sealed void Initialize() => throw null;
            public override string RealPathSeparator { get => throw null; }
            public static void RecreateDirectory(string dirPath, int timeoutMs = default(int)) => throw null;
            protected ServiceStack.VirtualPath.FileSystemVirtualDirectory RootDir;
            public override ServiceStack.IO.IVirtualDirectory RootDirectory { get => throw null; }
            public System.IO.DirectoryInfo RootDirInfo { get => throw null; set { } }
            public override string VirtualPathSeparator { get => throw null; }
            public void WriteFile(string filePath, string textContents) => throw null;
            public void WriteFile(string filePath, System.IO.Stream stream) => throw null;
            public override System.Threading.Tasks.Task WriteFileAsync(string filePath, object contents, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public void WriteFiles(System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> files, System.Func<ServiceStack.IO.IVirtualFile, string> toPath = default(System.Func<ServiceStack.IO.IVirtualFile, string>)) => throw null;
        }
        public class GistVirtualDirectory : ServiceStack.VirtualPath.AbstractVirtualDirectoryBase
        {
            public void AddFile(string virtualPath, string contents) => throw null;
            public void AddFile(string virtualPath, System.IO.Stream stream) => throw null;
            public GistVirtualDirectory(ServiceStack.IO.GistVirtualFiles pathProvider, string dirPath, ServiceStack.IO.GistVirtualDirectory parentDir) : base(default(ServiceStack.IO.IVirtualPathProvider)) => throw null;
            public override System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualDirectory> Directories { get => throw null; }
            public System.DateTime DirLastModified { get => throw null; set { } }
            public string DirPath { get => throw null; set { } }
            public System.Collections.Generic.IEnumerable<ServiceStack.IO.GistVirtualFile> EnumerateFiles(string pattern) => throw null;
            public override System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> Files { get => throw null; }
            public ServiceStack.IGistGateway Gateway { get => throw null; }
            public override System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> GetAllMatchingFiles(string globPattern, int maxDepth = default(int)) => throw null;
            protected override ServiceStack.IO.IVirtualDirectory GetDirectoryFromBackingDirectoryOrDefault(string directoryName) => throw null;
            public override System.Collections.Generic.IEnumerator<ServiceStack.IO.IVirtualNode> GetEnumerator() => throw null;
            public override ServiceStack.IO.IVirtualFile GetFile(string virtualPath) => throw null;
            protected override ServiceStack.IO.IVirtualFile GetFileFromBackingDirectoryOrDefault(string fileName) => throw null;
            protected override System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> GetMatchingFilesInDir(string globPattern) => throw null;
            public string GistId { get => throw null; }
            public override System.DateTime LastModified { get => throw null; }
            public override string Name { get => throw null; }
            public override string VirtualPath { get => throw null; }
        }
        public class GistVirtualFile : ServiceStack.VirtualPath.AbstractVirtualFileBase
        {
            public ServiceStack.IGistGateway Client { get => throw null; }
            public long ContentLength { get => throw null; set { } }
            public string ContentType { get => throw null; set { } }
            public GistVirtualFile(ServiceStack.IO.GistVirtualFiles pathProvider, ServiceStack.IO.IVirtualDirectory directory) : base(default(ServiceStack.IO.IVirtualPathProvider), default(ServiceStack.IO.IVirtualDirectory)) => throw null;
            public string DirPath { get => throw null; }
            public override string Extension { get => throw null; }
            public System.DateTime FileLastModified { get => throw null; set { } }
            public string FilePath { get => throw null; set { } }
            public override object GetContents() => throw null;
            public string GistId { get => throw null; }
            public ServiceStack.IO.GistVirtualFile Init(string filePath, System.DateTime lastModified, string text, System.IO.MemoryStream stream) => throw null;
            public override System.DateTime LastModified { get => throw null; }
            public override long Length { get => throw null; }
            public override string Name { get => throw null; }
            public override System.IO.Stream OpenRead() => throw null;
            public override byte[] ReadAllBytes() => throw null;
            public override void Refresh() => throw null;
            public System.IO.Stream Stream { get => throw null; set { } }
            public string Text { get => throw null; set { } }
            public override string VirtualPath { get => throw null; }
        }
        public class GistVirtualFiles : ServiceStack.VirtualPath.AbstractVirtualPathProviderBase, ServiceStack.IO.IVirtualFiles, ServiceStack.IO.IVirtualPathProvider
        {
            public void AppendFile(string filePath, string textContents) => throw null;
            public void AppendFile(string filePath, System.IO.Stream stream) => throw null;
            public const string Base64Modifier = default;
            public void ClearGist() => throw null;
            public GistVirtualFiles(string gistId) => throw null;
            public GistVirtualFiles(string gistId, string accessToken) => throw null;
            public GistVirtualFiles(string gistId, ServiceStack.IGistGateway gateway) => throw null;
            public GistVirtualFiles(ServiceStack.Gist gist) => throw null;
            public GistVirtualFiles(ServiceStack.Gist gist, string accessToken) => throw null;
            public GistVirtualFiles(ServiceStack.Gist gist, ServiceStack.IGistGateway gateway) => throw null;
            public void DeleteFile(string filePath) => throw null;
            public void DeleteFiles(System.Collections.Generic.IEnumerable<string> virtualFilePaths) => throw null;
            public void DeleteFolder(string dirPath) => throw null;
            public override bool DirectoryExists(string virtualPath) => throw null;
            public const char DirSep = default;
            public System.Collections.Generic.IEnumerable<ServiceStack.IO.GistVirtualFile> EnumerateFiles(string prefix = default(string)) => throw null;
            public override bool FileExists(string virtualPath) => throw null;
            public ServiceStack.IGistGateway Gateway { get => throw null; }
            public override System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> GetAllFiles() => throw null;
            public override ServiceStack.IO.IVirtualDirectory GetDirectory(string virtualPath) => throw null;
            public string GetDirPath(string filePath) => throw null;
            public override ServiceStack.IO.IVirtualFile GetFile(string virtualPath) => throw null;
            public static string GetFileName(string filePath) => throw null;
            public ServiceStack.Gist GetGist(bool refresh = default(bool)) => throw null;
            public System.Threading.Tasks.Task<ServiceStack.Gist> GetGistAsync(bool refresh = default(bool)) => throw null;
            public static bool GetGistContents(string filePath, ServiceStack.Gist gist, out string text, out System.IO.MemoryStream stream) => throw null;
            public static bool GetGistTextContents(string filePath, ServiceStack.Gist gist, out string text) => throw null;
            public System.Collections.Generic.IEnumerable<ServiceStack.IO.GistVirtualDirectory> GetImmediateDirectories(string fromDirPath) => throw null;
            public System.Collections.Generic.IEnumerable<ServiceStack.IO.GistVirtualFile> GetImmediateFiles(string fromDirPath) => throw null;
            public string GetImmediateSubDirPath(string fromDirPath, string subDirPath) => throw null;
            public string GistId { get => throw null; }
            protected override void Initialize() => throw null;
            public static bool IsDirSep(char c) => throw null;
            public System.DateTime LastRefresh { get => throw null; }
            public System.Threading.Tasks.Task LoadAllTruncatedFilesAsync() => throw null;
            public override string RealPathSeparator { get => throw null; }
            public System.TimeSpan RefreshAfter { get => throw null; set { } }
            public string ResolveGistFileName(string filePath) => throw null;
            public override ServiceStack.IO.IVirtualDirectory RootDirectory { get => throw null; }
            public override string SanitizePath(string filePath) => throw null;
            public static string ToBase64(System.IO.Stream stream) => throw null;
            public static string ToBase64(byte[] bytes) => throw null;
            public override string VirtualPathSeparator { get => throw null; }
            public void WriteFile(string virtualPath, string contents) => throw null;
            public void WriteFile(string virtualPath, System.IO.Stream stream) => throw null;
            public override void WriteFiles(System.Collections.Generic.Dictionary<string, string> textFiles) => throw null;
            public override void WriteFiles(System.Collections.Generic.Dictionary<string, object> files) => throw null;
            public void WriteFiles(System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> files, System.Func<ServiceStack.IO.IVirtualFile, string> toPath = default(System.Func<ServiceStack.IO.IVirtualFile, string>)) => throw null;
        }
        public class InMemoryVirtualDirectory : ServiceStack.VirtualPath.AbstractVirtualDirectoryBase
        {
            public void AddFile(string filePath, string contents) => throw null;
            public void AddFile(string filePath, System.IO.Stream stream) => throw null;
            public InMemoryVirtualDirectory(ServiceStack.IO.MemoryVirtualFiles pathProvider, string dirPath, ServiceStack.IO.IVirtualDirectory parentDir = default(ServiceStack.IO.IVirtualDirectory)) : base(default(ServiceStack.IO.IVirtualPathProvider)) => throw null;
            public override System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualDirectory> Directories { get => throw null; }
            public System.DateTime DirLastModified { get => throw null; set { } }
            public string DirPath { get => throw null; set { } }
            public System.Collections.Generic.IEnumerable<ServiceStack.IO.InMemoryVirtualFile> EnumerateFiles(string pattern) => throw null;
            public override System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> Files { get => throw null; }
            public override System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> GetAllMatchingFiles(string globPattern, int maxDepth = default(int)) => throw null;
            protected override ServiceStack.IO.IVirtualDirectory GetDirectoryFromBackingDirectoryOrDefault(string directoryName) => throw null;
            public override System.Collections.Generic.IEnumerator<ServiceStack.IO.IVirtualNode> GetEnumerator() => throw null;
            public override ServiceStack.IO.IVirtualFile GetFile(string virtualPath) => throw null;
            protected override ServiceStack.IO.IVirtualFile GetFileFromBackingDirectoryOrDefault(string fileName) => throw null;
            protected override System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> GetMatchingFilesInDir(string globPattern) => throw null;
            public bool HasFiles() => throw null;
            public override System.DateTime LastModified { get => throw null; }
            public override string Name { get => throw null; }
            public override string VirtualPath { get => throw null; }
        }
        public class InMemoryVirtualFile : ServiceStack.VirtualPath.AbstractVirtualFileBase
        {
            public byte[] ByteContents { get => throw null; set { } }
            public InMemoryVirtualFile(ServiceStack.IO.IVirtualPathProvider owningProvider, ServiceStack.IO.IVirtualDirectory directory) : base(default(ServiceStack.IO.IVirtualPathProvider), default(ServiceStack.IO.IVirtualDirectory)) => throw null;
            public string DirPath { get => throw null; }
            public System.DateTime FileLastModified { get => throw null; set { } }
            public string FilePath { get => throw null; set { } }
            public override object GetContents() => throw null;
            public override System.DateTime LastModified { get => throw null; }
            public override long Length { get => throw null; }
            public override string Name { get => throw null; }
            public override System.IO.Stream OpenRead() => throw null;
            public override byte[] ReadAllBytes() => throw null;
            public override void Refresh() => throw null;
            public void SetContents(string text, byte[] bytes) => throw null;
            public string TextContents { get => throw null; set { } }
            public override string VirtualPath { get => throw null; }
        }
        public class MemoryVirtualFiles : ServiceStack.VirtualPath.AbstractVirtualPathProviderBase, ServiceStack.IO.IVirtualFiles, ServiceStack.IO.IVirtualPathProvider
        {
            public void AddFile(ServiceStack.IO.InMemoryVirtualFile file) => throw null;
            public void AppendFile(string filePath, string textContents) => throw null;
            public void AppendFile(string filePath, System.IO.Stream stream) => throw null;
            public void Clear() => throw null;
            public MemoryVirtualFiles() => throw null;
            public void DeleteFile(string filePath) => throw null;
            public void DeleteFiles(System.Collections.Generic.IEnumerable<string> filePaths) => throw null;
            public void DeleteFolder(string dirPath) => throw null;
            public override bool DirectoryExists(string virtualPath) => throw null;
            public const char DirSep = default;
            public System.Collections.Generic.List<ServiceStack.IO.InMemoryVirtualFile> Files { get => throw null; }
            public override System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> GetAllFiles() => throw null;
            public override ServiceStack.IO.IVirtualDirectory GetDirectory(string virtualPath) => throw null;
            public ServiceStack.IO.IVirtualDirectory GetDirectory(string virtualPath, bool forceDir) => throw null;
            public string GetDirPath(string filePath) => throw null;
            public override ServiceStack.IO.IVirtualFile GetFile(string virtualPath) => throw null;
            public System.Collections.Generic.IEnumerable<ServiceStack.IO.InMemoryVirtualDirectory> GetImmediateDirectories(string fromDirPath) => throw null;
            public System.Collections.Generic.IEnumerable<ServiceStack.IO.InMemoryVirtualFile> GetImmediateFiles(string fromDirPath) => throw null;
            public string GetImmediateSubDirPath(string fromDirPath, string subDirPath) => throw null;
            public ServiceStack.IO.IVirtualDirectory GetParentDirectory(string dirPath) => throw null;
            protected override void Initialize() => throw null;
            public override string RealPathSeparator { get => throw null; }
            public override ServiceStack.IO.IVirtualDirectory RootDirectory { get => throw null; }
            public override string VirtualPathSeparator { get => throw null; }
            public void WriteFile(string filePath, string textContents) => throw null;
            public void WriteFile(string filePath, System.IO.Stream stream) => throw null;
            public void WriteFiles(System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> files, System.Func<ServiceStack.IO.IVirtualFile, string> toPath = default(System.Func<ServiceStack.IO.IVirtualFile, string>)) => throw null;
        }
        public class MultiVirtualDirectory : System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualNode>, System.Collections.IEnumerable, ServiceStack.IO.IVirtualDirectory, ServiceStack.IO.IVirtualNode
        {
            public MultiVirtualDirectory(ServiceStack.IO.IVirtualDirectory[] dirs) => throw null;
            public System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualDirectory> Directories { get => throw null; }
            public ServiceStack.IO.IVirtualDirectory Directory { get => throw null; }
            public System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> Files { get => throw null; }
            public System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> GetAllMatchingFiles(string globPattern, int maxDepth = default(int)) => throw null;
            public ServiceStack.IO.IVirtualDirectory GetDirectory(string virtualPath) => throw null;
            public ServiceStack.IO.IVirtualDirectory GetDirectory(System.Collections.Generic.Stack<string> virtualPath) => throw null;
            public System.Collections.Generic.IEnumerator<ServiceStack.IO.IVirtualNode> GetEnumerator() => throw null;
            System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            public ServiceStack.IO.IVirtualFile GetFile(string virtualPath) => throw null;
            public ServiceStack.IO.IVirtualFile GetFile(System.Collections.Generic.Stack<string> virtualPath) => throw null;
            public bool IsDirectory { get => throw null; }
            public bool IsRoot { get => throw null; }
            public System.DateTime LastModified { get => throw null; }
            public string Name { get => throw null; }
            public ServiceStack.IO.IVirtualDirectory ParentDirectory { get => throw null; }
            public string RealPath { get => throw null; }
            public static ServiceStack.IO.IVirtualDirectory ToVirtualDirectory(System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualDirectory> dirs) => throw null;
            public string VirtualPath { get => throw null; }
        }
        public class MultiVirtualFiles : ServiceStack.VirtualPath.AbstractVirtualPathProviderBase, ServiceStack.IO.IVirtualFiles, ServiceStack.IO.IVirtualPathProvider
        {
            public void AppendFile(string filePath, string textContents) => throw null;
            public void AppendFile(string filePath, System.IO.Stream stream) => throw null;
            public System.Collections.Generic.List<ServiceStack.IO.IVirtualPathProvider> ChildProviders { get => throw null; set { } }
            public System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualPathProvider> ChildVirtualFiles { get => throw null; }
            public override string CombineVirtualPath(string basePath, string relativePath) => throw null;
            public MultiVirtualFiles(params ServiceStack.IO.IVirtualPathProvider[] childProviders) => throw null;
            public void DeleteFile(string filePath) => throw null;
            public void DeleteFiles(System.Collections.Generic.IEnumerable<string> filePaths) => throw null;
            public void DeleteFolder(string dirPath) => throw null;
            public override bool DirectoryExists(string virtualPath) => throw null;
            public override bool FileExists(string virtualPath) => throw null;
            public override System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> GetAllFiles() => throw null;
            public override System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> GetAllMatchingFiles(string globPattern, int maxDepth = default(int)) => throw null;
            public override ServiceStack.IO.IVirtualDirectory GetDirectory(string virtualPath) => throw null;
            public override ServiceStack.IO.IVirtualFile GetFile(string virtualPath) => throw null;
            public override System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualDirectory> GetRootDirectories() => throw null;
            public override System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> GetRootFiles() => throw null;
            protected override sealed void Initialize() => throw null;
            public override bool IsSharedFile(ServiceStack.IO.IVirtualFile virtualFile) => throw null;
            public override bool IsViewFile(ServiceStack.IO.IVirtualFile virtualFile) => throw null;
            public override string RealPathSeparator { get => throw null; }
            public override ServiceStack.IO.IVirtualDirectory RootDirectory { get => throw null; }
            public override string ToString() => throw null;
            public override string VirtualPathSeparator { get => throw null; }
            public void WriteFile(string filePath, string textContents) => throw null;
            public void WriteFile(string filePath, System.IO.Stream stream) => throw null;
            public void WriteFiles(System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> files, System.Func<ServiceStack.IO.IVirtualFile, string> toPath = default(System.Func<ServiceStack.IO.IVirtualFile, string>)) => throw null;
        }
        public class ResourceVirtualFiles : ServiceStack.VirtualPath.AbstractVirtualPathProviderBase
        {
            public System.Reflection.Assembly BackingAssembly { get => throw null; }
            public string CleanPath(string filePath) => throw null;
            public override string CombineVirtualPath(string basePath, string relativePath) => throw null;
            public ResourceVirtualFiles(System.Type baseTypeInAssembly) => throw null;
            public ResourceVirtualFiles(System.Reflection.Assembly backingAssembly, string rootNamespace = default(string)) => throw null;
            public override ServiceStack.IO.IVirtualFile GetFile(string virtualPath) => throw null;
            protected override sealed void Initialize() => throw null;
            public System.DateTime LastModified { get => throw null; set { } }
            public static System.Collections.Generic.HashSet<string> PartialFileNames { get => throw null; set { } }
            public override string RealPathSeparator { get => throw null; }
            protected ServiceStack.VirtualPath.ResourceVirtualDirectory RootDir;
            public override ServiceStack.IO.IVirtualDirectory RootDirectory { get => throw null; }
            public string RootNamespace { get => throw null; }
            public override string VirtualPathSeparator { get => throw null; }
        }
        public static partial class VirtualDirectoryExtensions
        {
            public static System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> GetAllFiles(this ServiceStack.IO.IVirtualDirectory dir) => throw null;
            public static System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualDirectory> GetDirectories(this ServiceStack.IO.IVirtualDirectory dir) => throw null;
            public static System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> GetFiles(this ServiceStack.IO.IVirtualDirectory dir) => throw null;
            public static System.Threading.Tasks.Task WriteFileAsync(this ServiceStack.IO.IVirtualFiles vfs, string filePath, ServiceStack.IO.IVirtualFile file, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task WriteFileAsync(this ServiceStack.IO.IVirtualFiles vfs, string filePath, string textContents, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task WriteFileAsync(this ServiceStack.IO.IVirtualFiles vfs, string filePath, System.ReadOnlyMemory<char> textContents, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task WriteFileAsync(this ServiceStack.IO.IVirtualFiles vfs, string filePath, byte[] binaryContents, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task WriteFileAsync(this ServiceStack.IO.IVirtualFiles vfs, string filePath, System.ReadOnlyMemory<byte> romBytes, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task WriteFileAsync(this ServiceStack.IO.IVirtualFiles vfs, string filePath, System.IO.Stream stream, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        }
        public static partial class VirtualFilesExtensions
        {
            public static void AppendFile(this ServiceStack.IO.IVirtualPathProvider pathProvider, string filePath, string textContents) => throw null;
            public static void AppendFile(this ServiceStack.IO.IVirtualPathProvider pathProvider, string filePath, System.IO.Stream stream) => throw null;
            public static void AppendFile(this ServiceStack.IO.IVirtualPathProvider pathProvider, string filePath, byte[] bytes) => throw null;
            public static void AppendFile(this ServiceStack.IO.IVirtualPathProvider pathProvider, string filePath, object contents) => throw null;
            public static void AppendFile(this ServiceStack.IO.IVirtualPathProvider pathProvider, string filePath, System.ReadOnlyMemory<char> text) => throw null;
            public static void AppendFile(this ServiceStack.IO.IVirtualPathProvider pathProvider, string filePath, System.ReadOnlyMemory<byte> bytes) => throw null;
            public static void CopyFrom(this ServiceStack.IO.IVirtualPathProvider pathProvider, System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> srcFiles, System.Func<ServiceStack.IO.IVirtualFile, string> toPath = default(System.Func<ServiceStack.IO.IVirtualFile, string>)) => throw null;
            public static void DeleteFile(this ServiceStack.IO.IVirtualPathProvider pathProvider, string filePath) => throw null;
            public static void DeleteFile(this ServiceStack.IO.IVirtualPathProvider pathProvider, ServiceStack.IO.IVirtualFile file) => throw null;
            public static void DeleteFiles(this ServiceStack.IO.IVirtualPathProvider pathProvider, System.Collections.Generic.IEnumerable<string> filePaths) => throw null;
            public static void DeleteFiles(this ServiceStack.IO.IVirtualPathProvider pathProvider, System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> files) => throw null;
            public static void DeleteFolder(this ServiceStack.IO.IVirtualPathProvider pathProvider, string dirPath) => throw null;
            public static bool IsDirectory(this ServiceStack.IO.IVirtualPathProvider pathProvider, string filePath) => throw null;
            public static bool IsFile(this ServiceStack.IO.IVirtualPathProvider pathProvider, string filePath) => throw null;
            public static void WriteFile(this ServiceStack.IO.IVirtualPathProvider pathProvider, string filePath, string textContents) => throw null;
            public static void WriteFile(this ServiceStack.IO.IVirtualPathProvider pathProvider, string filePath, System.IO.Stream stream) => throw null;
            public static void WriteFile(this ServiceStack.IO.IVirtualPathProvider pathProvider, string filePath, byte[] bytes) => throw null;
            public static void WriteFile(this ServiceStack.IO.IVirtualPathProvider pathProvider, string filePath, System.ReadOnlyMemory<char> text) => throw null;
            public static void WriteFile(this ServiceStack.IO.IVirtualPathProvider pathProvider, string filePath, System.ReadOnlyMemory<byte> bytes) => throw null;
            public static void WriteFile(this ServiceStack.IO.IVirtualPathProvider pathProvider, string filePath, object contents) => throw null;
            public static void WriteFile(this ServiceStack.IO.IVirtualPathProvider pathProvider, ServiceStack.IO.IVirtualFile file, string filePath = default(string)) => throw null;
            public static void WriteFiles(this ServiceStack.IO.IVirtualPathProvider pathProvider, System.Collections.Generic.Dictionary<string, string> textFiles) => throw null;
            public static void WriteFiles(this ServiceStack.IO.IVirtualPathProvider pathProvider, System.Collections.Generic.Dictionary<string, object> files) => throw null;
            public static void WriteFiles(this ServiceStack.IO.IVirtualPathProvider pathProvider, System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> srcFiles, System.Func<ServiceStack.IO.IVirtualFile, string> toPath = default(System.Func<ServiceStack.IO.IVirtualFile, string>)) => throw null;
        }
    }
    public static partial class IPAddressExtensions
    {
        public static System.Collections.Generic.Dictionary<System.Net.IPAddress, System.Net.IPAddress> GetAllNetworkInterfaceIpv4Addresses() => throw null;
        public static System.Collections.Generic.List<System.Net.IPAddress> GetAllNetworkInterfaceIpv6Addresses() => throw null;
        public static System.Net.IPAddress GetBroadcastAddress(this System.Net.IPAddress address, System.Net.IPAddress subnetMask) => throw null;
        public static System.Net.IPAddress GetNetworkAddress(this System.Net.IPAddress address, System.Net.IPAddress subnetMask) => throw null;
        public static byte[] GetNetworkAddressBytes(byte[] ipAddressBytes, byte[] subnetMaskBytes) => throw null;
        public static bool IsInSameIpv4Subnet(this System.Net.IPAddress address2, System.Net.IPAddress address, System.Net.IPAddress subnetMask) => throw null;
        public static bool IsInSameIpv4Subnet(this byte[] address1Bytes, byte[] address2Bytes, byte[] subnetMaskBytes) => throw null;
        public static bool IsInSameIpv6Subnet(this System.Net.IPAddress address2, System.Net.IPAddress address) => throw null;
        public static bool IsInSameIpv6Subnet(this byte[] address1Bytes, byte[] address2Bytes) => throw null;
    }
    public static class JS
    {
        public static void Configure() => throw null;
        public static ServiceStack.Script.ScriptScopeContext CreateScope(System.Collections.Generic.Dictionary<string, object> args = default(System.Collections.Generic.Dictionary<string, object>), ServiceStack.Script.ScriptMethods functions = default(ServiceStack.Script.ScriptMethods)) => throw null;
        public static object eval(string js) => throw null;
        public static object eval(string js, ServiceStack.Script.ScriptScopeContext scope) => throw null;
        public static object eval(System.ReadOnlySpan<char> js, ServiceStack.Script.ScriptScopeContext scope) => throw null;
        public static object eval(ServiceStack.Script.ScriptContext context, string expr, System.Collections.Generic.Dictionary<string, object> args = default(System.Collections.Generic.Dictionary<string, object>)) => throw null;
        public static object eval(ServiceStack.Script.ScriptContext context, System.ReadOnlySpan<char> expr, System.Collections.Generic.Dictionary<string, object> args = default(System.Collections.Generic.Dictionary<string, object>)) => throw null;
        public static object eval(ServiceStack.Script.ScriptContext context, ServiceStack.Script.JsToken token, System.Collections.Generic.Dictionary<string, object> args = default(System.Collections.Generic.Dictionary<string, object>)) => throw null;
        public const string EvalAstCacheKeyPrefix = default;
        public static object evalCached(ServiceStack.Script.ScriptContext context, string expr) => throw null;
        public const string EvalCacheKeyPrefix = default;
        public const string EvalScriptCacheKeyPrefix = default;
        public static ServiceStack.Script.JsToken expression(string js) => throw null;
        public static ServiceStack.Script.JsToken expressionCached(ServiceStack.Script.ScriptContext context, string expr) => throw null;
        public static System.Collections.Generic.Dictionary<string, object> ParseObject(string js) => throw null;
        public static ServiceStack.Script.SharpPage scriptCached(ServiceStack.Script.ScriptContext context, string evalCode) => throw null;
        public static void UnConfigure() => throw null;
    }
    public static class JSON
    {
        public static object parse(string json) => throw null;
        public static object parseSpan(System.ReadOnlySpan<char> json) => throw null;
        public static string stringify(object value) => throw null;
    }
    namespace Logging
    {
        public class ConsoleLogFactory : ServiceStack.Logging.ILogFactory
        {
            public static void Configure(bool debugEnabled = default(bool)) => throw null;
            public ConsoleLogFactory(bool debugEnabled = default(bool)) => throw null;
            public ServiceStack.Logging.ILog GetLogger(System.Type type) => throw null;
            public ServiceStack.Logging.ILog GetLogger(string typeName) => throw null;
        }
        public class ConsoleLogger : ServiceStack.Logging.ILog
        {
            public ConsoleLogger(string type) => throw null;
            public ConsoleLogger(System.Type type) => throw null;
            public void Debug(object message, System.Exception exception) => throw null;
            public void Debug(object message) => throw null;
            public void DebugFormat(string format, params object[] args) => throw null;
            public void Error(object message, System.Exception exception) => throw null;
            public void Error(object message) => throw null;
            public void ErrorFormat(string format, params object[] args) => throw null;
            public void Fatal(object message, System.Exception exception) => throw null;
            public void Fatal(object message) => throw null;
            public void FatalFormat(string format, params object[] args) => throw null;
            public void Info(object message, System.Exception exception) => throw null;
            public void Info(object message) => throw null;
            public void InfoFormat(string format, params object[] args) => throw null;
            public bool IsDebugEnabled { get => throw null; set { } }
            public void Warn(object message, System.Exception exception) => throw null;
            public void Warn(object message) => throw null;
            public void WarnFormat(string format, params object[] args) => throw null;
        }
        public class DebugLogFactory : ServiceStack.Logging.ILogFactory
        {
            public DebugLogFactory(bool debugEnabled = default(bool)) => throw null;
            public ServiceStack.Logging.ILog GetLogger(System.Type type) => throw null;
            public ServiceStack.Logging.ILog GetLogger(string typeName) => throw null;
        }
        public class DebugLogger : ServiceStack.Logging.ILog
        {
            public DebugLogger(string type) => throw null;
            public DebugLogger(System.Type type) => throw null;
            public void Debug(object message, System.Exception exception) => throw null;
            public void Debug(object message) => throw null;
            public void DebugFormat(string format, params object[] args) => throw null;
            public void Error(object message, System.Exception exception) => throw null;
            public void Error(object message) => throw null;
            public void ErrorFormat(string format, params object[] args) => throw null;
            public void Fatal(object message, System.Exception exception) => throw null;
            public void Fatal(object message) => throw null;
            public void FatalFormat(string format, params object[] args) => throw null;
            public void Info(object message, System.Exception exception) => throw null;
            public void Info(object message) => throw null;
            public void InfoFormat(string format, params object[] args) => throw null;
            public bool IsDebugEnabled { get => throw null; set { } }
            public void Warn(object message, System.Exception exception) => throw null;
            public void Warn(object message) => throw null;
            public void WarnFormat(string format, params object[] args) => throw null;
        }
    }
    public delegate object MethodInvoker(object instance, params object[] args);
    namespace MiniProfiler
    {
        namespace Data
        {
            public enum ExecuteType : byte
            {
                None = 0,
                NonQuery = 1,
                Scalar = 2,
                Reader = 3,
            }
            public interface IDbProfiler
            {
                void ExecuteFinish(System.Data.Common.DbCommand profiledDbCommand, ServiceStack.MiniProfiler.Data.ExecuteType executeType, System.Data.Common.DbDataReader reader);
                void ExecuteStart(System.Data.Common.DbCommand profiledDbCommand, ServiceStack.MiniProfiler.Data.ExecuteType executeType);
                bool IsActive { get; }
                void OnError(System.Data.Common.DbCommand profiledDbCommand, ServiceStack.MiniProfiler.Data.ExecuteType executeType, System.Exception exception);
                void ReaderFinish(System.Data.Common.DbDataReader reader);
            }
            public class ProfiledCommand : System.Data.Common.DbCommand, ServiceStack.Data.IHasDbCommand
            {
                public override void Cancel() => throw null;
                public override string CommandText { get => throw null; set { } }
                public override int CommandTimeout { get => throw null; set { } }
                public override System.Data.CommandType CommandType { get => throw null; set { } }
                protected override System.Data.Common.DbParameter CreateDbParameter() => throw null;
                public ProfiledCommand(System.Data.Common.DbCommand cmd, System.Data.Common.DbConnection conn, ServiceStack.MiniProfiler.Data.IDbProfiler profiler) => throw null;
                public System.Data.Common.DbCommand DbCommand { get => throw null; set { } }
                System.Data.IDbCommand ServiceStack.Data.IHasDbCommand.DbCommand { get => throw null; }
                protected override System.Data.Common.DbConnection DbConnection { get => throw null; set { } }
                protected override System.Data.Common.DbParameterCollection DbParameterCollection { get => throw null; }
                protected ServiceStack.MiniProfiler.Data.IDbProfiler DbProfiler { get => throw null; set { } }
                protected override System.Data.Common.DbTransaction DbTransaction { get => throw null; set { } }
                public override bool DesignTimeVisible { get => throw null; set { } }
                protected override void Dispose(bool disposing) => throw null;
                protected override System.Data.Common.DbDataReader ExecuteDbDataReader(System.Data.CommandBehavior behavior) => throw null;
                public override int ExecuteNonQuery() => throw null;
                public override object ExecuteScalar() => throw null;
                public override void Prepare() => throw null;
                public override System.Data.UpdateRowSource UpdatedRowSource { get => throw null; set { } }
            }
            public class ProfiledConnection : System.Data.Common.DbConnection, ServiceStack.Data.IHasDbConnection
            {
                protected bool AutoDisposeConnection { get => throw null; set { } }
                protected override System.Data.Common.DbTransaction BeginDbTransaction(System.Data.IsolationLevel isolationLevel) => throw null;
                protected override bool CanRaiseEvents { get => throw null; }
                public override void ChangeDatabase(string databaseName) => throw null;
                public override void Close() => throw null;
                public override string ConnectionString { get => throw null; set { } }
                public override int ConnectionTimeout { get => throw null; }
                protected override System.Data.Common.DbCommand CreateDbCommand() => throw null;
                public ProfiledConnection(System.Data.Common.DbConnection connection, ServiceStack.MiniProfiler.Data.IDbProfiler profiler, bool autoDisposeConnection = default(bool)) => throw null;
                public ProfiledConnection(System.Data.IDbConnection connection, ServiceStack.MiniProfiler.Data.IDbProfiler profiler, bool autoDisposeConnection = default(bool)) => throw null;
                public override string Database { get => throw null; }
                public override string DataSource { get => throw null; }
                public System.Data.IDbConnection DbConnection { get => throw null; }
                protected override void Dispose(bool disposing) => throw null;
                public System.Data.Common.DbConnection InnerConnection { get => throw null; set { } }
                public override void Open() => throw null;
                public ServiceStack.MiniProfiler.Data.IDbProfiler Profiler { get => throw null; set { } }
                public override string ServerVersion { get => throw null; }
                public override System.Data.ConnectionState State { get => throw null; }
                public System.Data.Common.DbConnection WrappedConnection { get => throw null; }
            }
            public class ProfiledDbDataReader : System.Data.Common.DbDataReader
            {
                public override void Close() => throw null;
                public ProfiledDbDataReader(System.Data.Common.DbDataReader reader, System.Data.Common.DbConnection connection, ServiceStack.MiniProfiler.Data.IDbProfiler profiler) => throw null;
                public override int Depth { get => throw null; }
                public override int FieldCount { get => throw null; }
                public override bool GetBoolean(int ordinal) => throw null;
                public override byte GetByte(int ordinal) => throw null;
                public override long GetBytes(int ordinal, long dataOffset, byte[] buffer, int bufferOffset, int length) => throw null;
                public override char GetChar(int ordinal) => throw null;
                public override long GetChars(int ordinal, long dataOffset, char[] buffer, int bufferOffset, int length) => throw null;
                public override string GetDataTypeName(int ordinal) => throw null;
                public override System.DateTime GetDateTime(int ordinal) => throw null;
                public override decimal GetDecimal(int ordinal) => throw null;
                public override double GetDouble(int ordinal) => throw null;
                public override System.Collections.IEnumerator GetEnumerator() => throw null;
                public override System.Type GetFieldType(int ordinal) => throw null;
                public override float GetFloat(int ordinal) => throw null;
                public override System.Guid GetGuid(int ordinal) => throw null;
                public override short GetInt16(int ordinal) => throw null;
                public override int GetInt32(int ordinal) => throw null;
                public override long GetInt64(int ordinal) => throw null;
                public override string GetName(int ordinal) => throw null;
                public override int GetOrdinal(string name) => throw null;
                public override string GetString(int ordinal) => throw null;
                public override object GetValue(int ordinal) => throw null;
                public override int GetValues(object[] values) => throw null;
                public override bool HasRows { get => throw null; }
                public override bool IsClosed { get => throw null; }
                public override bool IsDBNull(int ordinal) => throw null;
                public override bool NextResult() => throw null;
                public override bool Read() => throw null;
                public override int RecordsAffected { get => throw null; }
                public override object this[string name] { get => throw null; }
                public override object this[int ordinal] { get => throw null; }
            }
            public class ProfiledDbTransaction : System.Data.Common.DbTransaction, ServiceStack.Data.IHasDbTransaction
            {
                public override void Commit() => throw null;
                public ProfiledDbTransaction(System.Data.Common.DbTransaction transaction, ServiceStack.MiniProfiler.Data.ProfiledConnection connection) => throw null;
                protected override System.Data.Common.DbConnection DbConnection { get => throw null; }
                public System.Data.IDbTransaction DbTransaction { get => throw null; }
                protected override void Dispose(bool disposing) => throw null;
                public override System.Data.IsolationLevel IsolationLevel { get => throw null; }
                public override void Rollback() => throw null;
            }
            public class ProfiledProviderFactory : System.Data.Common.DbProviderFactory
            {
                public override System.Data.Common.DbCommand CreateCommand() => throw null;
                public override System.Data.Common.DbConnection CreateConnection() => throw null;
                public override System.Data.Common.DbConnectionStringBuilder CreateConnectionStringBuilder() => throw null;
                public override System.Data.Common.DbParameter CreateParameter() => throw null;
                protected ProfiledProviderFactory() => throw null;
                public ProfiledProviderFactory(ServiceStack.MiniProfiler.Data.IDbProfiler profiler, System.Data.Common.DbProviderFactory wrappedFactory) => throw null;
                public void InitProfiledDbProviderFactory(ServiceStack.MiniProfiler.Data.IDbProfiler profiler, System.Data.Common.DbProviderFactory wrappedFactory) => throw null;
                public static ServiceStack.MiniProfiler.Data.ProfiledProviderFactory Instance;
                protected ServiceStack.MiniProfiler.Data.IDbProfiler Profiler { get => throw null; }
                protected System.Data.Common.DbProviderFactory WrappedFactory { get => throw null; }
            }
        }
    }
    public class ModelConfig<T>
    {
        public ModelConfig() => throw null;
        public static void Id(ServiceStack.GetMemberDelegate<T> getIdFn) => throw null;
    }
    public static class NavbarDefaults
    {
        public static ServiceStack.NavOptions Create() => throw null;
        public static ServiceStack.NavOptions ForNavbar(this ServiceStack.NavOptions options) => throw null;
        public static string NavClass { get => throw null; set { } }
    }
    public static class NavButtonGroupDefaults
    {
        public static ServiceStack.NavOptions Create() => throw null;
        public static ServiceStack.NavOptions ForNavButtonGroup(this ServiceStack.NavOptions options) => throw null;
        public static string NavClass { get => throw null; set { } }
        public static string NavItemClass { get => throw null; set { } }
    }
    public static class NavDefaults
    {
        public static string ActiveClass { get => throw null; set { } }
        public static string ChildNavItemClass { get => throw null; set { } }
        public static string ChildNavLinkClass { get => throw null; set { } }
        public static string ChildNavMenuClass { get => throw null; set { } }
        public static string ChildNavMenuItemClass { get => throw null; set { } }
        public static ServiceStack.NavOptions Create() => throw null;
        public static ServiceStack.NavOptions ForNav(this ServiceStack.NavOptions options) => throw null;
        public static string NavClass { get => throw null; set { } }
        public static string NavItemClass { get => throw null; set { } }
        public static string NavLinkClass { get => throw null; set { } }
        public static ServiceStack.NavOptions OverrideDefaults(ServiceStack.NavOptions targets, ServiceStack.NavOptions source) => throw null;
    }
    public static class NavLinkDefaults
    {
        public static ServiceStack.NavOptions ForNavLink(this ServiceStack.NavOptions options) => throw null;
    }
    public class NavOptions
    {
        public string ActiveClass { get => throw null; set { } }
        public string ActivePath { get => throw null; set { } }
        public System.Collections.Generic.HashSet<string> Attributes { get => throw null; set { } }
        public string BaseHref { get => throw null; set { } }
        public string ChildNavItemClass { get => throw null; set { } }
        public string ChildNavLinkClass { get => throw null; set { } }
        public string ChildNavMenuClass { get => throw null; set { } }
        public string ChildNavMenuItemClass { get => throw null; set { } }
        public NavOptions() => throw null;
        public string NavClass { get => throw null; set { } }
        public string NavItemClass { get => throw null; set { } }
        public string NavLinkClass { get => throw null; set { } }
    }
    public static partial class NetCoreExtensions
    {
        public static void Close(this System.Net.Sockets.Socket socket) => throw null;
        public static void Close(this System.Data.Common.DbDataReader reader) => throw null;
    }
    public delegate object ObjectActivator(params object[] args);
    public static class PerfUtils
    {
        public static double Measure(System.Action fn, int times = default(int), int runForMs = default(int), System.Action setup = default(System.Action), System.Action warmup = default(System.Action), System.Action teardown = default(System.Action)) => throw null;
        public static double MeasureFor(System.Action fn, int runForMs) => throw null;
        public static System.TimeSpan ToTimeSpan(this long fromTicks) => throw null;
    }
    public class ProcessResult
    {
        public long? CallbackDurationMs { get => throw null; set { } }
        public ProcessResult() => throw null;
        public long DurationMs { get => throw null; set { } }
        public System.DateTime EndAt { get => throw null; set { } }
        public int? ExitCode { get => throw null; set { } }
        public System.DateTime StartAt { get => throw null; set { } }
        public string StdErr { get => throw null; set { } }
        public string StdOut { get => throw null; set { } }
    }
    public static class ProcessUtils
    {
        public static System.Diagnostics.ProcessStartInfo ConvertToCmdExec(this System.Diagnostics.ProcessStartInfo startInfo) => throw null;
        public static ServiceStack.ProcessResult CreateErrorResult(System.Exception e) => throw null;
        public static System.Diagnostics.Process CreateProcess(string fileName, string arguments, string workingDir) => throw null;
        public static string FindExePath(string exeName) => throw null;
        public static string Run(string fileName, string arguments = default(string), string workingDir = default(string)) => throw null;
        public static System.Threading.Tasks.Task<ServiceStack.ProcessResult> RunAsync(System.Diagnostics.ProcessStartInfo startInfo, int? timeoutMs = default(int?), System.Action<string> onOut = default(System.Action<string>), System.Action<string> onError = default(System.Action<string>)) => throw null;
        public static string RunShell(string arguments, string workingDir = default(string)) => throw null;
        public static System.Threading.Tasks.Task RunShellAsync(string arguments, string workingDir = default(string), int? timeoutMs = default(int?), System.Action<string> onOut = default(System.Action<string>), System.Action<string> onError = default(System.Action<string>)) => throw null;
    }
    namespace Reflection
    {
        public static class DelegateFactory
        {
            public static ServiceStack.Reflection.DelegateFactory.LateBoundMethod Create(System.Reflection.MethodInfo method) => throw null;
            public static ServiceStack.Reflection.DelegateFactory.LateBoundVoid CreateVoid(System.Reflection.MethodInfo method) => throw null;
            public delegate object LateBoundMethod(object target, object[] arguments);
            public delegate void LateBoundVoid(object target, object[] arguments);
        }
    }
    public static class RequestScriptUtils
    {
        public static void AddToMap(this System.Collections.Specialized.NameValueCollection nvc, System.Collections.Generic.Dictionary<string, string> map, System.Collections.Generic.HashSet<string> exclude = default(System.Collections.Generic.HashSet<string>)) => throw null;
        public static System.Collections.Generic.Dictionary<string, string> GetRequestParams(ServiceStack.Web.IRequest request) => throw null;
    }
    public enum Run
    {
        Always = 0,
        IgnoreInDebug = 1,
        OnlyInDebug = 2,
    }
    namespace Script
    {
        public class BindingExpressionException : System.Exception
        {
            public BindingExpressionException(string message, string member, string expression, System.Exception inner = default(System.Exception)) => throw null;
            public string Expression { get => throw null; }
            public string Member { get => throw null; }
        }
        public static class CallExpressionUtils
        {
            public static System.ReadOnlySpan<char> ParseJsCallExpression(this System.ReadOnlySpan<char> literal, out ServiceStack.Script.JsCallExpression expression, bool filterExpression = default(bool)) => throw null;
        }
        public class CaptureScriptBlock : ServiceStack.Script.ScriptBlock
        {
            public override ServiceStack.Script.ScriptLanguage Body { get => throw null; }
            public CaptureScriptBlock() => throw null;
            public override string Name { get => throw null; }
            public override System.Threading.Tasks.Task WriteAsync(ServiceStack.Script.ScriptScopeContext scope, ServiceStack.Script.PageBlockFragment block, System.Threading.CancellationToken token) => throw null;
        }
        public class CsvScriptBlock : ServiceStack.Script.ScriptBlock
        {
            public override ServiceStack.Script.ScriptLanguage Body { get => throw null; }
            public CsvScriptBlock() => throw null;
            public override string Name { get => throw null; }
            public override System.Threading.Tasks.Task WriteAsync(ServiceStack.Script.ScriptScopeContext scope, ServiceStack.Script.PageBlockFragment block, System.Threading.CancellationToken ct) => throw null;
        }
        public class DefaultScriptBlocks : ServiceStack.Script.IScriptPlugin
        {
            public DefaultScriptBlocks() => throw null;
            public void Register(ServiceStack.Script.ScriptContext context) => throw null;
        }
        public class DefaultScripts : ServiceStack.Script.ScriptMethods, ServiceStack.Script.IConfigureScriptContext
        {
            public double abs(double value) => throw null;
            public double acos(double value) => throw null;
            public object add(object lhs, object rhs) => throw null;
            public System.DateTime addDays(System.DateTime target, int count) => throw null;
            public string addHashParams(string url, object urlParams) => throw null;
            public System.DateTime addHours(System.DateTime target, int count) => throw null;
            public object addItem(object collection, object value) => throw null;
            public System.DateTime addMilliseconds(System.DateTime target, int count) => throw null;
            public System.DateTime addMinutes(System.DateTime target, int count) => throw null;
            public System.DateTime addMonths(System.DateTime target, int count) => throw null;
            public string addPath(string target, string pathToAppend) => throw null;
            public string addPaths(string target, System.Collections.IEnumerable pathsToAppend) => throw null;
            public string addQueryString(string url, object urlParams) => throw null;
            public System.DateTime addSeconds(System.DateTime target, int count) => throw null;
            public System.DateTime addTicks(System.DateTime target, int count) => throw null;
            public ServiceStack.Script.IgnoreResult addTo(ServiceStack.Script.ScriptScopeContext scope, object value, object argExpr) => throw null;
            public ServiceStack.Script.IgnoreResult addToGlobal(ServiceStack.Script.ScriptScopeContext scope, object value, object argExpr) => throw null;
            public ServiceStack.Script.IgnoreResult addToStart(ServiceStack.Script.ScriptScopeContext scope, object value, object argExpr) => throw null;
            public ServiceStack.Script.IgnoreResult addToStartGlobal(ServiceStack.Script.ScriptScopeContext scope, object value, object argExpr) => throw null;
            public System.DateTime addYears(System.DateTime target, int count) => throw null;
            public bool all(ServiceStack.Script.ScriptScopeContext scope, object target, object expression) => throw null;
            public bool all(ServiceStack.Script.ScriptScopeContext scope, object target, object expression, object scopeOptions) => throw null;
            public bool AND(object lhs, object rhs) => throw null;
            public bool any(ServiceStack.Script.ScriptScopeContext scope, object target) => throw null;
            public bool any(ServiceStack.Script.ScriptScopeContext scope, object target, object expression) => throw null;
            public bool any(ServiceStack.Script.ScriptScopeContext scope, object target, object expression, object scopeOptions) => throw null;
            public string append(string target, string suffix) => throw null;
            public string appendFmt(string target, string format, object arg) => throw null;
            public string appendFmt(string target, string format, object arg0, object arg1) => throw null;
            public string appendFmt(string target, string format, object arg0, object arg1, object arg2) => throw null;
            public string appendLine(string target) => throw null;
            public ServiceStack.Script.IgnoreResult appendTo(ServiceStack.Script.ScriptScopeContext scope, string value, object argExpr) => throw null;
            public ServiceStack.Script.IgnoreResult appendToGlobal(ServiceStack.Script.ScriptScopeContext scope, string value, object argExpr) => throw null;
            public string appSetting(string name) => throw null;
            public int AssertWithinMaxQuota(int value) => throw null;
            public object assign(ServiceStack.Script.ScriptScopeContext scope, string argExpr, object value) => throw null;
            public object assignError(ServiceStack.Script.ScriptScopeContext scope, string errorBinding) => throw null;
            public object assignErrorAndContinueExecuting(ServiceStack.Script.ScriptScopeContext scope, string errorBinding) => throw null;
            public object assignGlobal(ServiceStack.Script.ScriptScopeContext scope, string argExpr, object value) => throw null;
            public ServiceStack.Script.IgnoreResult assignTo(ServiceStack.Script.ScriptScopeContext scope, object value, object argExpr) => throw null;
            public System.Threading.Tasks.Task assignTo(ServiceStack.Script.ScriptScopeContext scope, object argExpr) => throw null;
            public ServiceStack.Script.IgnoreResult assignToGlobal(ServiceStack.Script.ScriptScopeContext scope, object value, object argExpr) => throw null;
            public System.Threading.Tasks.Task assignToGlobal(ServiceStack.Script.ScriptScopeContext scope, object argExpr) => throw null;
            public string asString(object target) => throw null;
            public double atan(double value) => throw null;
            public double atan2(double y, double x) => throw null;
            public double average(ServiceStack.Script.ScriptScopeContext scope, object target) => throw null;
            public double average(ServiceStack.Script.ScriptScopeContext scope, object target, object expression) => throw null;
            public double average(ServiceStack.Script.ScriptScopeContext scope, object target, object expression, object scopeOptions) => throw null;
            public string base64(byte[] bytes) => throw null;
            public System.Threading.Tasks.Task buffer(ServiceStack.Script.ScriptScopeContext scope, object target) => throw null;
            public string camelCase(string text) => throw null;
            public object catchError(ServiceStack.Script.ScriptScopeContext scope, string errorBinding) => throw null;
            public double ceiling(double value) => throw null;
            public object coerce(string str) => throw null;
            public int compareTo(string text, string other) => throw null;
            public System.Collections.Generic.IEnumerable<object> concat(System.Collections.Generic.IEnumerable<object> target, System.Collections.Generic.IEnumerable<object> items) => throw null;
            public string concat(System.Collections.Generic.IEnumerable<string> target) => throw null;
            public void Configure(ServiceStack.Script.ScriptContext context) => throw null;
            public bool contains(object target, object needle) => throw null;
            public bool containsXss(object target) => throw null;
            public static bool ContainsXss(string text) => throw null;
            public string contentType(string fileOrExt) => throw null;
            public object continueExecutingFiltersOnError(ServiceStack.Script.ScriptScopeContext scope, object ignoreTarget) => throw null;
            public object continueExecutingFiltersOnError(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public double cos(double value) => throw null;
            public int count(ServiceStack.Script.ScriptScopeContext scope, object target) => throw null;
            public int count(ServiceStack.Script.ScriptScopeContext scope, object target, object expression) => throw null;
            public int count(ServiceStack.Script.ScriptScopeContext scope, object target, object expression, object scopeOptions) => throw null;
            public ServiceStack.IRawString cssIncludes(System.Collections.IEnumerable cssFiles) => throw null;
            public ServiceStack.IRawString csv(object value) => throw null;
            public System.Threading.Tasks.Task csv(ServiceStack.Script.ScriptScopeContext scope, object items) => throw null;
            public DefaultScripts() => throw null;
            public string currency(decimal decimalValue) => throw null;
            public string currency(decimal decimalValue, string culture) => throw null;
            public System.DateTime date(int year, int month, int day) => throw null;
            public System.DateTime date(int year, int month, int day, int hour, int min, int secs) => throw null;
            public string dateFormat(System.DateTime dateValue) => throw null;
            public string dateFormat(System.DateTime dateValue, string format) => throw null;
            public string dateTimeFormat(System.DateTime dateValue) => throw null;
            public object debugMode(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public decimal decimalAdd(decimal lhs, decimal rhs) => throw null;
            public decimal decimalDiv(decimal lhs, decimal rhs) => throw null;
            public decimal decimalMul(decimal lhs, decimal rhs) => throw null;
            public decimal decimalSub(decimal lhs, decimal rhs) => throw null;
            public long decr(long value) => throw null;
            public long decrBy(long value, long by) => throw null;
            public long decrement(long value) => throw null;
            public long decrementBy(long value, long by) => throw null;
            public object @default(object returnTarget, object elseReturn) => throw null;
            public string dirPath(string filePath) => throw null;
            public System.Collections.Generic.IEnumerable<object> distinct(System.Collections.Generic.IEnumerable<object> items) => throw null;
            public double div(double lhs, double rhs) => throw null;
            public double divide(double lhs, double rhs) => throw null;
            public object @do(ServiceStack.Script.ScriptScopeContext scope, object expression) => throw null;
            public System.Threading.Tasks.Task @do(ServiceStack.Script.ScriptScopeContext scope, object target, object expression) => throw null;
            public System.Threading.Tasks.Task @do(ServiceStack.Script.ScriptScopeContext scope, object target, object expression, object scopeOptions) => throw null;
            public object doIf(object test) => throw null;
            public object doIf(object ignoreTarget, object test) => throw null;
            public double doubleAdd(double lhs, double rhs) => throw null;
            public double doubleDiv(double lhs, double rhs) => throw null;
            public double doubleMul(double lhs, double rhs) => throw null;
            public double doubleSub(double lhs, double rhs) => throw null;
            public ServiceStack.IRawString dump(object value) => throw null;
            public System.Threading.Tasks.Task dump(ServiceStack.Script.ScriptScopeContext scope, object items) => throw null;
            public System.Threading.Tasks.Task dump(ServiceStack.Script.ScriptScopeContext scope, object items, string jsConfig) => throw null;
            public double e() => throw null;
            public object echo(object value) => throw null;
            public object elementAt(System.Collections.IEnumerable target, int index) => throw null;
            public ServiceStack.Script.StopExecution end() => throw null;
            public System.Threading.Tasks.Task end(ServiceStack.Script.ScriptScopeContext scope, object ignore) => throw null;
            public ServiceStack.Script.StopExecution end(object ignore) => throw null;
            public object endIf(object test) => throw null;
            public object endIf(object returnTarget, bool test) => throw null;
            public object endIfAll(ServiceStack.Script.ScriptScopeContext scope, object target, object expression) => throw null;
            public object endIfAny(ServiceStack.Script.ScriptScopeContext scope, object target, object expression) => throw null;
            public object endIfDebug(object returnTarget) => throw null;
            public object endIfEmpty(object target) => throw null;
            public object endIfEmpty(object ignoreTarget, object target) => throw null;
            public object endIfError(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public object endIfError(ServiceStack.Script.ScriptScopeContext scope, object value) => throw null;
            public object endIfExists(object target) => throw null;
            public object endIfExists(object ignoreTarget, object target) => throw null;
            public object endIfFalsy(object target) => throw null;
            public object endIfFalsy(object ignoreTarget, object target) => throw null;
            public object endIfNotEmpty(object target) => throw null;
            public object endIfNotEmpty(object ignoreTarget, object target) => throw null;
            public object endIfNotNull(object target) => throw null;
            public object endIfNotNull(object ignoreTarget, object target) => throw null;
            public object endIfNull(object target) => throw null;
            public object endIfNull(object ignoreTarget, object target) => throw null;
            public object endIfTruthy(object target) => throw null;
            public object endIfTruthy(object ignoreTarget, object target) => throw null;
            public bool endsWith(string text, string needle) => throw null;
            public object endWhere(ServiceStack.Script.ScriptScopeContext scope, object target, object expression) => throw null;
            public object endWhere(ServiceStack.Script.ScriptScopeContext scope, object target, object expression, object scopeOptions) => throw null;
            public object ensureAllArgsNotEmpty(ServiceStack.Script.ScriptScopeContext scope, object args) => throw null;
            public object ensureAllArgsNotEmpty(ServiceStack.Script.ScriptScopeContext scope, object args, object options) => throw null;
            public object ensureAllArgsNotNull(ServiceStack.Script.ScriptScopeContext scope, object args) => throw null;
            public object ensureAllArgsNotNull(ServiceStack.Script.ScriptScopeContext scope, object args, object options) => throw null;
            public object ensureAnyArgsNotEmpty(ServiceStack.Script.ScriptScopeContext scope, object args) => throw null;
            public object ensureAnyArgsNotEmpty(ServiceStack.Script.ScriptScopeContext scope, object args, object options) => throw null;
            public object ensureAnyArgsNotNull(ServiceStack.Script.ScriptScopeContext scope, object args) => throw null;
            public object ensureAnyArgsNotNull(ServiceStack.Script.ScriptScopeContext scope, object args, object options) => throw null;
            public bool eq(object target, object other) => throw null;
            public bool equals(object target, object other) => throw null;
            public bool equivalentTo(System.Collections.Generic.IEnumerable<object> target, System.Collections.Generic.IEnumerable<object> items) => throw null;
            public string escapeBackticks(string text) => throw null;
            public string escapeDoubleQuotes(string text) => throw null;
            public string escapeNewLines(string text) => throw null;
            public string escapePrimeQuotes(string text) => throw null;
            public string escapeSingleQuotes(string text) => throw null;
            public object eval(ServiceStack.Script.ScriptScopeContext scope, string js) => throw null;
            public System.Threading.Tasks.Task<object> evalScript(ServiceStack.Script.ScriptScopeContext scope, string source) => throw null;
            public System.Threading.Tasks.Task<object> evalScript(ServiceStack.Script.ScriptScopeContext scope, string source, System.Collections.Generic.Dictionary<string, object> args) => throw null;
            public System.Threading.Tasks.Task<object> evalTemplate(ServiceStack.Script.ScriptScopeContext scope, string source) => throw null;
            public System.Threading.Tasks.Task<object> evalTemplate(ServiceStack.Script.ScriptScopeContext scope, string source, System.Collections.Generic.Dictionary<string, object> args) => throw null;
            public static System.Collections.Generic.List<string> EvaluateWhenSkippingFilterExecution;
            public bool every(ServiceStack.Script.ScriptScopeContext scope, System.Collections.IList list, ServiceStack.Script.JsArrowFunctionExpression expression) => throw null;
            public System.Collections.Generic.IEnumerable<object> except(System.Collections.Generic.IEnumerable<object> target, System.Collections.Generic.IEnumerable<object> items) => throw null;
            public bool exists(object test) => throw null;
            public double exp(double value) => throw null;
            public object falsy(object test, object returnIfFalsy) => throw null;
            public object field(object target, string fieldName) => throw null;
            public System.Collections.Generic.List<string> fields(object o) => throw null;
            public System.Reflection.FieldInfo[] fieldTypes(object o) => throw null;
            public System.Collections.Generic.List<object> filter(ServiceStack.Script.ScriptScopeContext scope, System.Collections.IList list, ServiceStack.Script.JsArrowFunctionExpression expression) => throw null;
            public object find(ServiceStack.Script.ScriptScopeContext scope, System.Collections.IList list, ServiceStack.Script.JsArrowFunctionExpression expression) => throw null;
            public int findIndex(ServiceStack.Script.ScriptScopeContext scope, System.Collections.IList list, ServiceStack.Script.JsArrowFunctionExpression expression) => throw null;
            public object first(ServiceStack.Script.ScriptScopeContext scope, object target) => throw null;
            public object first(ServiceStack.Script.ScriptScopeContext scope, object target, object expression) => throw null;
            public object first(ServiceStack.Script.ScriptScopeContext scope, object target, object expression, object scopeOptions) => throw null;
            public System.Collections.Generic.List<object> flat(System.Collections.IList list) => throw null;
            public System.Collections.Generic.List<object> flat(System.Collections.IList list, int depth) => throw null;
            public System.Collections.Generic.List<object> flatMap(ServiceStack.Script.ScriptScopeContext scope, System.Collections.IList list, ServiceStack.Script.JsArrowFunctionExpression expression) => throw null;
            public System.Collections.Generic.List<object> flatMap(ServiceStack.Script.ScriptScopeContext scope, System.Collections.IList list, ServiceStack.Script.JsArrowFunctionExpression expression, int depth) => throw null;
            public System.Collections.Generic.List<object> flatten(object target) => throw null;
            public System.Collections.Generic.List<object> flatten(object target, int depth) => throw null;
            public double floor(double value) => throw null;
            public string fmt(string format, object arg) => throw null;
            public string fmt(string format, object arg0, object arg1) => throw null;
            public string fmt(string format, object arg0, object arg1, object arg2) => throw null;
            public ServiceStack.Script.IgnoreResult forEach(ServiceStack.Script.ScriptScopeContext scope, object target, ServiceStack.Script.JsArrowFunctionExpression arrowExpr) => throw null;
            public System.Collections.Specialized.NameValueCollection form(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public string format(object obj, string format) => throw null;
            public ServiceStack.IRawString formatRaw(object obj, string fmt) => throw null;
            public System.Collections.Generic.Dictionary<string, object> formDictionary(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public string formQuery(ServiceStack.Script.ScriptScopeContext scope, string name) => throw null;
            public string[] formQueryValues(ServiceStack.Script.ScriptScopeContext scope, string name) => throw null;
            public byte[] fromBase64(string base64) => throw null;
            public char fromCharCode(int charCode) => throw null;
            public object fromEnumFlagsList(System.Collections.IList values, System.Type enumType) => throw null;
            public string fromUtf8Bytes(byte[] target) => throw null;
            public string generateSlug(string phrase) => throw null;
            public object get(object target, object key) => throw null;
            public static string GetVarNameFromStringOrArrowExpression(string filterName, object argExpr) => throw null;
            public string[] glob(System.Collections.Generic.IEnumerable<string> strings, string pattern) => throw null;
            public string globln(System.Collections.Generic.IEnumerable<string> strings, string pattern) => throw null;
            public bool greaterThan(object target, object other) => throw null;
            public bool greaterThanEqual(object target, object other) => throw null;
            public System.Collections.Generic.IEnumerable<System.Linq.IGrouping<object, object>> groupBy(ServiceStack.Script.ScriptScopeContext scope, System.Collections.Generic.IEnumerable<object> items, object expression) => throw null;
            public System.Collections.Generic.IEnumerable<System.Linq.IGrouping<object, object>> groupBy(ServiceStack.Script.ScriptScopeContext scope, System.Collections.Generic.IEnumerable<object> items, object expression, object scopeOptions) => throw null;
            public bool gt(object target, object other) => throw null;
            public bool gte(object target, object other) => throw null;
            public bool hasError(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public bool hasFlag(System.Enum source, object value) => throw null;
            public bool hasMaxCount(object target, int maxCount) => throw null;
            public bool hasMinCount(object target, int minCount) => throw null;
            public string htmlDecode(string value) => throw null;
            public string htmlEncode(string value) => throw null;
            public string httpMethod(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public string httpParam(ServiceStack.Script.ScriptScopeContext scope, string name) => throw null;
            public string httpPathInfo(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public string httpRequestUrl(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public string humanize(string text) => throw null;
            public object @if(object test) => throw null;
            public object @if(object returnTarget, object test) => throw null;
            public object ifDebug(ServiceStack.Script.ScriptScopeContext scope, object ignoreTarget) => throw null;
            public object ifDebug(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public object ifDo(object test) => throw null;
            public object ifDo(object ignoreTarget, object test) => throw null;
            public object ifElse(object returnTarget, object test, object defaultValue) => throw null;
            public object ifEmpty(object returnTarget, object test) => throw null;
            public object ifEnd(bool test) => throw null;
            public object ifEnd(object ignoreTarget, bool test) => throw null;
            public object ifError(ServiceStack.Script.ScriptScopeContext scope, object ignoreTarget) => throw null;
            public object ifError(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public object ifExists(object target) => throw null;
            public object ifExists(object returnTarget, object test) => throw null;
            public object ifFalse(object returnTarget, object test) => throw null;
            public object ifFalsy(object returnTarget, object test) => throw null;
            public object ifHttpDelete(ServiceStack.Script.ScriptScopeContext scope, object ignoreTarget) => throw null;
            public object ifHttpDelete(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public object ifHttpGet(ServiceStack.Script.ScriptScopeContext scope, object ignoreTarget) => throw null;
            public object ifHttpGet(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public object ifHttpPatch(ServiceStack.Script.ScriptScopeContext scope, object ignoreTarget) => throw null;
            public object ifHttpPatch(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public object ifHttpPost(ServiceStack.Script.ScriptScopeContext scope, object ignoreTarget) => throw null;
            public object ifHttpPost(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public object ifHttpPut(ServiceStack.Script.ScriptScopeContext scope, object ignoreTarget) => throw null;
            public object ifHttpPut(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public object ifMatchesPathInfo(ServiceStack.Script.ScriptScopeContext scope, object returnTarget, string pathInfo) => throw null;
            public object ifNo(object returnTarget, object target) => throw null;
            public object ifNoError(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public object ifNoError(ServiceStack.Script.ScriptScopeContext scope, object value) => throw null;
            public object ifNot(object returnTarget, object test) => throw null;
            public object ifNotElse(object returnTarget, object test, object defaultValue) => throw null;
            public object ifNotEmpty(object target) => throw null;
            public object ifNotEmpty(object returnTarget, object test) => throw null;
            public object ifNotEnd(bool test) => throw null;
            public object ifNotEnd(object ignoreTarget, bool test) => throw null;
            public object ifNotExists(object returnTarget, object test) => throw null;
            public object ifNotOnly(bool test) => throw null;
            public object ifNotOnly(object ignoreTarget, bool test) => throw null;
            public object ifOnly(bool test) => throw null;
            public object ifOnly(object ignoreTarget, bool test) => throw null;
            public object ifShow(object test, object useValue) => throw null;
            public object ifShowRaw(object test, object useValue) => throw null;
            public object ifThrow(ServiceStack.Script.ScriptScopeContext scope, bool test, string message) => throw null;
            public object ifThrow(ServiceStack.Script.ScriptScopeContext scope, bool test, string message, object options) => throw null;
            public object ifThrowArgumentException(ServiceStack.Script.ScriptScopeContext scope, bool test, string message) => throw null;
            public object ifThrowArgumentException(ServiceStack.Script.ScriptScopeContext scope, bool test, string message, object options) => throw null;
            public object ifThrowArgumentException(ServiceStack.Script.ScriptScopeContext scope, bool test, string message, string paramName, object options) => throw null;
            public object ifThrowArgumentNullException(ServiceStack.Script.ScriptScopeContext scope, bool test, string paramName) => throw null;
            public object ifThrowArgumentNullException(ServiceStack.Script.ScriptScopeContext scope, bool test, string paramName, object options) => throw null;
            public object ifTrue(object returnTarget, object test) => throw null;
            public object ifTruthy(object returnTarget, object test) => throw null;
            public object ifUse(object test, object useValue) => throw null;
            public object iif(object test, object ifTrue, object ifFalse) => throw null;
            public object importRequestParams(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public object importRequestParams(ServiceStack.Script.ScriptScopeContext scope, System.Collections.IEnumerable onlyImportArgNames) => throw null;
            public bool includes(System.Collections.IList list, object item) => throw null;
            public bool includes(System.Collections.IList list, object item, int fromIndex) => throw null;
            public long incr(long value) => throw null;
            public long incrBy(long value, long by) => throw null;
            public long increment(long value) => throw null;
            public long incrementBy(long value, long by) => throw null;
            public string indent() => throw null;
            public ServiceStack.IRawString indentJson(object value) => throw null;
            public ServiceStack.IRawString indentJson(object value, string jsconfig) => throw null;
            public string indents(int count) => throw null;
            public int indexOf(object target, object item) => throw null;
            public int indexOf(object target, object item, int startIndex) => throw null;
            public static readonly ServiceStack.Script.DefaultScripts Instance;
            public bool instanceOf(object target, object type) => throw null;
            public int intAdd(int lhs, int rhs) => throw null;
            public int intDiv(int lhs, int rhs) => throw null;
            public System.Collections.Generic.IEnumerable<object> intersect(System.Collections.Generic.IEnumerable<object> target, System.Collections.Generic.IEnumerable<object> items) => throw null;
            public int intMul(int lhs, int rhs) => throw null;
            public int intSub(int lhs, int rhs) => throw null;
            public bool isAnonObject(object target) => throw null;
            public bool isArray(object target) => throw null;
            public bool isBinary(string fileOrExt) => throw null;
            public bool isBool(object target) => throw null;
            public bool isByte(object target) => throw null;
            public bool isBytes(object target) => throw null;
            public bool isChar(object target) => throw null;
            public bool isChars(object target) => throw null;
            public bool isClass(object target) => throw null;
            public bool isDecimal(object target) => throw null;
            public bool isDictionary(object target) => throw null;
            public bool isDouble(object target) => throw null;
            public bool isDto(object target) => throw null;
            public bool isEmpty(object target) => throw null;
            public bool isEnum(System.Enum source, object value) => throw null;
            public bool isEnum(object target) => throw null;
            public bool isEnumerable(object target) => throw null;
            public bool isEven(int value) => throw null;
            public static bool isFalsy(object target) => throw null;
            public bool isFloat(object target) => throw null;
            public bool isHttpDelete(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public bool isHttpGet(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public bool isHttpPatch(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public bool isHttpPost(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public bool isHttpPut(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public bool isInfinity(double value) => throw null;
            public bool isInt(object target) => throw null;
            public bool isInteger(object target) => throw null;
            public bool isKeyValuePair(object target) => throw null;
            public bool isList(object target) => throw null;
            public bool isLong(object target) => throw null;
            public bool isNaN(double value) => throw null;
            public bool isNegative(double value) => throw null;
            public bool isNotNull(object test) => throw null;
            public bool isNull(object test) => throw null;
            public bool IsNullOrWhiteSpace(object target) => throw null;
            public bool isNumber(object target) => throw null;
            public bool isObjectDictionary(object target) => throw null;
            public bool isOdd(int value) => throw null;
            public bool isPositive(double value) => throw null;
            public bool isRealNumber(object target) => throw null;
            public bool isString(object target) => throw null;
            public bool isStringDictionary(object target) => throw null;
            public static bool isTrue(object target) => throw null;
            public static bool isTruthy(object target) => throw null;
            public bool isTuple(object target) => throw null;
            public bool isType(object target, string typeName) => throw null;
            public bool isValueType(object target) => throw null;
            public bool isZero(double value) => throw null;
            public System.Collections.Generic.List<object> itemsOf(int count, object target) => throw null;
            public string join(System.Collections.Generic.IEnumerable<object> values) => throw null;
            public string join(System.Collections.Generic.IEnumerable<object> values, string delimiter) => throw null;
            public string joinln(System.Collections.Generic.IEnumerable<object> values) => throw null;
            public ServiceStack.IRawString jsIncludes(System.Collections.IEnumerable jsFiles) => throw null;
            public ServiceStack.IRawString json(object value) => throw null;
            public ServiceStack.IRawString json(object value, string jsconfig) => throw null;
            public System.Threading.Tasks.Task json(ServiceStack.Script.ScriptScopeContext scope, object items) => throw null;
            public System.Threading.Tasks.Task json(ServiceStack.Script.ScriptScopeContext scope, object items, string jsConfig) => throw null;
            public ServiceStack.Text.JsonArrayObjects jsonToArrayObjects(string json) => throw null;
            public ServiceStack.Text.JsonObject jsonToObject(string json) => throw null;
            public System.Collections.Generic.Dictionary<string, object> jsonToObjectDictionary(string json) => throw null;
            public System.Collections.Generic.Dictionary<string, string> jsonToStringDictionary(string json) => throw null;
            public ServiceStack.IRawString jsQuotedString(string text) => throw null;
            public ServiceStack.IRawString jsString(string text) => throw null;
            public ServiceStack.IRawString jsv(object value) => throw null;
            public ServiceStack.IRawString jsv(object value, string jsconfig) => throw null;
            public System.Threading.Tasks.Task jsv(ServiceStack.Script.ScriptScopeContext scope, object items) => throw null;
            public System.Threading.Tasks.Task jsv(ServiceStack.Script.ScriptScopeContext scope, object items, string jsConfig) => throw null;
            public System.Collections.Generic.Dictionary<string, object> jsvToObjectDictionary(string json) => throw null;
            public System.Collections.Generic.Dictionary<string, string> jsvToStringDictionary(string json) => throw null;
            public string kebabCase(string text) => throw null;
            public System.Collections.ICollection keys(object target) => throw null;
            public System.Collections.Generic.KeyValuePair<string, object> keyValuePair(string key, object value) => throw null;
            public object last(ServiceStack.Script.ScriptScopeContext scope, object target) => throw null;
            public System.Exception lastError(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public string lastErrorMessage(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public string lastErrorStackTrace(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public int lastIndexOf(object target, object item) => throw null;
            public int lastIndexOf(object target, object item, int startIndex) => throw null;
            public string lastLeftPart(string text, string needle) => throw null;
            public string lastRightPart(string text, string needle) => throw null;
            public string leftPart(string text, string needle) => throw null;
            public int length(object target) => throw null;
            public bool lessThan(object target, object other) => throw null;
            public bool lessThanEqual(object target, object other) => throw null;
            public object let(ServiceStack.Script.ScriptScopeContext scope, object target, object scopeBindings) => throw null;
            public System.Collections.Generic.IEnumerable<object> limit(ServiceStack.Script.ScriptScopeContext scope, System.Collections.Generic.IEnumerable<object> original, object skipOrBinding, object takeOrBinding) => throw null;
            public double log(double value) => throw null;
            public double log(double a, double newBase) => throw null;
            public double log10(double value) => throw null;
            public double log2(double value) => throw null;
            public long longAdd(long lhs, long rhs) => throw null;
            public long longDiv(long lhs, long rhs) => throw null;
            public long longMul(long lhs, long rhs) => throw null;
            public long longSub(long lhs, long rhs) => throw null;
            public string lower(string text) => throw null;
            public bool lt(object target, object other) => throw null;
            public bool lte(object target, object other) => throw null;
            public object map(ServiceStack.Script.ScriptScopeContext scope, object items, object expression) => throw null;
            public object map(ServiceStack.Script.ScriptScopeContext scope, object target, object expression, object scopeOptions) => throw null;
            public bool matchesPathInfo(ServiceStack.Script.ScriptScopeContext scope, string pathInfo) => throw null;
            public static bool MatchesStringValue(object target, System.Func<string, bool> match) => throw null;
            public object max(ServiceStack.Script.ScriptScopeContext scope, object target) => throw null;
            public object max(ServiceStack.Script.ScriptScopeContext scope, object target, object expression) => throw null;
            public object max(ServiceStack.Script.ScriptScopeContext scope, object target, object expression, object scopeOptions) => throw null;
            public object merge(object sources) => throw null;
            public object merge(System.Collections.Generic.IDictionary<string, object> target, object sources) => throw null;
            public object min(ServiceStack.Script.ScriptScopeContext scope, object target) => throw null;
            public object min(ServiceStack.Script.ScriptScopeContext scope, object target, object expression) => throw null;
            public object min(ServiceStack.Script.ScriptScopeContext scope, object target, object expression, object scopeOptions) => throw null;
            public long mod(long value, long divisor) => throw null;
            public object mul(object lhs, object rhs) => throw null;
            public object multiply(object lhs, object rhs) => throw null;
            public System.Collections.Generic.List<ServiceStack.NavItem> navItems() => throw null;
            public System.Collections.Generic.List<ServiceStack.NavItem> navItems(string key) => throw null;
            public string newLine() => throw null;
            public string newLine(string target) => throw null;
            public string newLines(int count) => throw null;
            public System.Guid nguid() => throw null;
            public bool not(bool target) => throw null;
            public bool not(object target, object other) => throw null;
            public bool notEquals(object target, object other) => throw null;
            public System.DateTime now() => throw null;
            public System.DateTimeOffset nowOffset() => throw null;
            public System.Collections.IEnumerable of(ServiceStack.Script.ScriptScopeContext scope, System.Collections.IEnumerable target, object scopeOptions) => throw null;
            public object onlyIf(object test) => throw null;
            public object onlyIf(object returnTarget, bool test) => throw null;
            public object onlyIfAll(ServiceStack.Script.ScriptScopeContext scope, object target, object expression) => throw null;
            public object onlyIfAny(ServiceStack.Script.ScriptScopeContext scope, object target, object expression) => throw null;
            public object onlyIfDebug(object returnTarget) => throw null;
            public object onlyIfEmpty(object target) => throw null;
            public object onlyIfEmpty(object ignoreTarget, object target) => throw null;
            public object onlyIfExists(object target) => throw null;
            public object onlyIfExists(object ignoreTarget, object target) => throw null;
            public object onlyIfFalsy(object target) => throw null;
            public object onlyIfFalsy(object ignoreTarget, object target) => throw null;
            public object onlyIfNotEmpty(object target) => throw null;
            public object onlyIfNotEmpty(object ignoreTarget, object target) => throw null;
            public object onlyIfNotNull(object target) => throw null;
            public object onlyIfNotNull(object ignoreTarget, object target) => throw null;
            public object onlyIfNull(object target) => throw null;
            public object onlyIfNull(object ignoreTarget, object target) => throw null;
            public object onlyIfTruthy(object target) => throw null;
            public object onlyIfTruthy(object ignoreTarget, object target) => throw null;
            public object onlyWhere(ServiceStack.Script.ScriptScopeContext scope, object target, object expression) => throw null;
            public object onlyWhere(ServiceStack.Script.ScriptScopeContext scope, object target, object expression, object scopeOptions) => throw null;
            public bool OR(object lhs, object rhs) => throw null;
            public System.Collections.Generic.IEnumerable<object> orderBy(ServiceStack.Script.ScriptScopeContext scope, object target, object expression) => throw null;
            public System.Collections.Generic.IEnumerable<object> orderBy(ServiceStack.Script.ScriptScopeContext scope, object target, object expression, object scopeOptions) => throw null;
            public System.Collections.Generic.IEnumerable<object> orderByDesc(ServiceStack.Script.ScriptScopeContext scope, object target, object expression) => throw null;
            public System.Collections.Generic.IEnumerable<object> orderByDesc(ServiceStack.Script.ScriptScopeContext scope, object target, object expression, object scopeOptions) => throw null;
            public System.Collections.Generic.IEnumerable<object> orderByDescending(ServiceStack.Script.ScriptScopeContext scope, object target, object expression) => throw null;
            public System.Collections.Generic.IEnumerable<object> orderByDescending(ServiceStack.Script.ScriptScopeContext scope, object target, object expression, object scopeOptions) => throw null;
            public static System.Collections.Generic.IEnumerable<object> orderByInternal(string filterName, ServiceStack.Script.ScriptScopeContext scope, object target, object expression, object scopeOptions) => throw null;
            public object otherwise(object returnTarget, object elseReturn) => throw null;
            public object ownProps(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>> target) => throw null;
            public string padLeft(string text, int totalWidth) => throw null;
            public string padLeft(string text, int totalWidth, char padChar) => throw null;
            public string padRight(string text, int totalWidth) => throw null;
            public string padRight(string text, int totalWidth, char padChar) => throw null;
            public System.Collections.Generic.KeyValuePair<string, object> pair(string key, object value) => throw null;
            public System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> parseAsKeyValues(string target) => throw null;
            public System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> parseAsKeyValues(string target, string delimiter) => throw null;
            public System.Collections.Generic.List<System.Collections.Generic.List<string>> parseCsv(string csv) => throw null;
            public object parseJson(string json) => throw null;
            public System.Collections.Generic.List<System.Collections.Generic.KeyValuePair<string, string>> parseKeyValues(string keyValuesText) => throw null;
            public System.Collections.Generic.List<System.Collections.Generic.KeyValuePair<string, string>> parseKeyValues(string keyValuesText, string delimiter) => throw null;
            public System.Collections.Generic.Dictionary<string, string> parseKeyValueText(string target) => throw null;
            public System.Collections.Generic.Dictionary<string, string> parseKeyValueText(string target, string delimiter) => throw null;
            public System.Threading.Tasks.Task partial(ServiceStack.Script.ScriptScopeContext scope, object target) => throw null;
            public System.Threading.Tasks.Task partial(ServiceStack.Script.ScriptScopeContext scope, object target, object scopedParams) => throw null;
            public string pascalCase(string text) => throw null;
            public ServiceStack.IRawString pass(string target) => throw null;
            public double pi() => throw null;
            public object pop(System.Collections.IList list) => throw null;
            public double pow(double x, double y) => throw null;
            public ServiceStack.Script.IgnoreResult prependTo(ServiceStack.Script.ScriptScopeContext scope, string value, object argExpr) => throw null;
            public ServiceStack.Script.IgnoreResult prependToGlobal(ServiceStack.Script.ScriptScopeContext scope, string value, object argExpr) => throw null;
            public object property(object target, string propertyName) => throw null;
            public System.Collections.Generic.List<string> props(object o) => throw null;
            public System.Reflection.PropertyInfo[] propTypes(object o) => throw null;
            public int push(System.Collections.IList list, object item) => throw null;
            public object putItem(System.Collections.IDictionary dictionary, object key, object value) => throw null;
            public System.Collections.Specialized.NameValueCollection qs(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public System.Collections.Specialized.NameValueCollection query(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public System.Collections.Generic.Dictionary<string, object> queryDictionary(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public string queryString(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public System.Collections.Generic.IEnumerable<int> range(int count) => throw null;
            public System.Collections.Generic.IEnumerable<int> range(int start, int count) => throw null;
            public ServiceStack.IRawString raw(object value) => throw null;
            public object rawBodyAsJson(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public string rawBodyAsString(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public System.Collections.Generic.IEnumerable<string> readLines(string contents) => throw null;
            public object reduce(ServiceStack.Script.ScriptScopeContext scope, object target, object expression) => throw null;
            public object reduce(ServiceStack.Script.ScriptScopeContext scope, object target, object expression, object scopeOptions) => throw null;
            public object remove(object target, object keysToRemove) => throw null;
            public object removeKeyFromDictionary(System.Collections.IDictionary dictionary, object keyToRemove) => throw null;
            public static System.Collections.Generic.List<string> RemoveNewLinesFor { get => throw null; }
            public string repeat(string text, int times) => throw null;
            public string repeating(int times, string text) => throw null;
            public string replace(string text, string oldValue, string newValue) => throw null;
            public System.IO.Stream requestBody(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public System.Threading.Tasks.Task<object> requestBodyAsJson(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public System.Threading.Tasks.Task<object> requestBodyAsString(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public object resolveArg(ServiceStack.Script.ScriptScopeContext scope, string name) => throw null;
            public string resolveAsset(ServiceStack.Script.ScriptScopeContext scope, string virtualPath) => throw null;
            public object resolveContextArg(ServiceStack.Script.ScriptScopeContext scope, string name) => throw null;
            public object resolveGlobal(ServiceStack.Script.ScriptScopeContext scope, string name) => throw null;
            public object resolvePageArg(ServiceStack.Script.ScriptScopeContext scope, string name) => throw null;
            public ServiceStack.Script.StopExecution @return(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public ServiceStack.Script.StopExecution @return(ServiceStack.Script.ScriptScopeContext scope, object returnValue) => throw null;
            public ServiceStack.Script.StopExecution @return(ServiceStack.Script.ScriptScopeContext scope, object returnValue, System.Collections.Generic.Dictionary<string, object> returnArgs) => throw null;
            public System.Collections.Generic.IEnumerable<object> reverse(ServiceStack.Script.ScriptScopeContext scope, System.Collections.Generic.IEnumerable<object> original) => throw null;
            public string rightPart(string text, string needle) => throw null;
            public double round(double value) => throw null;
            public double round(double value, int decimals) => throw null;
            public object scopeVars(object target) => throw null;
            public System.Threading.Tasks.Task select(ServiceStack.Script.ScriptScopeContext scope, object target, object selectTemplate) => throw null;
            public System.Threading.Tasks.Task select(ServiceStack.Script.ScriptScopeContext scope, object target, object selectTemplate, object scopeOptions) => throw null;
            public System.Threading.Tasks.Task selectEach(ServiceStack.Script.ScriptScopeContext scope, object target, object items) => throw null;
            public System.Threading.Tasks.Task selectEach(ServiceStack.Script.ScriptScopeContext scope, object target, object items, object scopeOptions) => throw null;
            public object selectFields(object target, object names) => throw null;
            public System.Threading.Tasks.Task selectPartial(ServiceStack.Script.ScriptScopeContext scope, object target, string pageName) => throw null;
            public System.Threading.Tasks.Task selectPartial(ServiceStack.Script.ScriptScopeContext scope, object target, string pageName, object scopedParams) => throw null;
            public bool sequenceEquals(System.Collections.IEnumerable a, System.Collections.IEnumerable b) => throw null;
            public string setHashParams(string url, object urlParams) => throw null;
            public string setQueryString(string url, object urlParams) => throw null;
            public object shift(System.Collections.IList list) => throw null;
            public object show(object ignoreTarget, object useValue) => throw null;
            public object showFmt(object ignoreTarget, string format, object arg) => throw null;
            public object showFmt(object ignoreTarget, string format, object arg1, object arg2) => throw null;
            public object showFmt(object ignoreTarget, string format, object arg1, object arg2, object arg3) => throw null;
            public ServiceStack.IRawString showFmtRaw(object ignoreTarget, string format, object arg) => throw null;
            public ServiceStack.IRawString showFmtRaw(object ignoreTarget, string format, object arg1, object arg2) => throw null;
            public ServiceStack.IRawString showFmtRaw(object ignoreTarget, string format, object arg1, object arg2, object arg3) => throw null;
            public object showFormat(object ignoreTarget, object arg, string fmt) => throw null;
            public object showIf(object useValue, object test) => throw null;
            public object showIfExists(object useValue, object test) => throw null;
            public ServiceStack.IRawString showRaw(object ignoreTarget, string content) => throw null;
            public int sign(double value) => throw null;
            public double sin(double value) => throw null;
            public double sinh(double value) => throw null;
            public System.Collections.Generic.IEnumerable<object> skip(ServiceStack.Script.ScriptScopeContext scope, System.Collections.Generic.IEnumerable<object> original, object countOrBinding) => throw null;
            public object skipExecutingFiltersOnError(ServiceStack.Script.ScriptScopeContext scope, object ignoreTarget) => throw null;
            public object skipExecutingFiltersOnError(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public System.Collections.Generic.IEnumerable<object> skipWhile(ServiceStack.Script.ScriptScopeContext scope, object target, object expression) => throw null;
            public System.Collections.Generic.IEnumerable<object> skipWhile(ServiceStack.Script.ScriptScopeContext scope, object target, object expression, object scopeOptions) => throw null;
            public System.Collections.Generic.List<object> slice(System.Collections.IList list) => throw null;
            public System.Collections.Generic.List<object> slice(System.Collections.IList list, int begin) => throw null;
            public System.Collections.Generic.List<object> slice(System.Collections.IList list, int begin, int end) => throw null;
            public string snakeCase(string text) => throw null;
            public bool some(ServiceStack.Script.ScriptScopeContext scope, System.Collections.IList list, ServiceStack.Script.JsArrowFunctionExpression expression) => throw null;
            public System.Collections.Generic.List<object> sort(System.Collections.Generic.List<object> list) => throw null;
            public string space() => throw null;
            public string spaces(int count) => throw null;
            public object splice(System.Collections.IList list, int removeAt) => throw null;
            public System.Collections.Generic.List<object> splice(System.Collections.IList list, int removeAt, int deleteCount) => throw null;
            public System.Collections.Generic.List<object> splice(System.Collections.IList list, int removeAt, int deleteCount, System.Collections.Generic.List<object> insertItems) => throw null;
            public string[] split(string stringList) => throw null;
            public string[] split(string stringList, object delimiter) => throw null;
            public string splitCase(string text) => throw null;
            public static string[] splitLines(string contents) => throw null;
            public string[] splitOnFirst(string text, string needle) => throw null;
            public string[] splitOnLast(string text, string needle) => throw null;
            public System.Collections.Generic.List<string> splitStringList(System.Collections.IEnumerable strings) => throw null;
            public double sqrt(double value) => throw null;
            public bool startsWith(string text, string needle) => throw null;
            public bool startsWithPathInfo(ServiceStack.Script.ScriptScopeContext scope, string pathInfo) => throw null;
            public System.Collections.Generic.List<string> staticFields(object o) => throw null;
            public System.Reflection.FieldInfo[] staticFieldTypes(object o) => throw null;
            public System.Collections.Generic.List<string> staticProps(object o) => throw null;
            public System.Reflection.PropertyInfo[] staticPropTypes(object o) => throw null;
            public System.Collections.Generic.List<object> step(System.Collections.IEnumerable target, object scopeOptions) => throw null;
            public object sub(object lhs, object rhs) => throw null;
            public string substring(string text, int startIndex) => throw null;
            public string substring(string text, int startIndex, int length) => throw null;
            public string substringWithElipsis(string text, int length) => throw null;
            public string substringWithElipsis(string text, int startIndex, int length) => throw null;
            public string substringWithEllipsis(string text, int length) => throw null;
            public string substringWithEllipsis(string text, int startIndex, int length) => throw null;
            public object subtract(object lhs, object rhs) => throw null;
            public object sum(ServiceStack.Script.ScriptScopeContext scope, object target) => throw null;
            public object sum(ServiceStack.Script.ScriptScopeContext scope, object target, object expression) => throw null;
            public object sum(ServiceStack.Script.ScriptScopeContext scope, object target, object expression, object scopeOptions) => throw null;
            public object sync(object value) => throw null;
            public System.Collections.Generic.IEnumerable<object> take(ServiceStack.Script.ScriptScopeContext scope, System.Collections.Generic.IEnumerable<object> original, object countOrBinding) => throw null;
            public System.Collections.Generic.IEnumerable<object> takeWhile(ServiceStack.Script.ScriptScopeContext scope, object target, object expression) => throw null;
            public System.Collections.Generic.IEnumerable<object> takeWhile(ServiceStack.Script.ScriptScopeContext scope, object target, object expression, object scopeOptions) => throw null;
            public double tan(double value) => throw null;
            public double tanh(double value) => throw null;
            public ServiceStack.IRawString textDump(object target) => throw null;
            public ServiceStack.IRawString textDump(object target, System.Collections.Generic.Dictionary<string, object> options) => throw null;
            public static string TextDump(object target, ServiceStack.TextDumpOptions options) => throw null;
            public ServiceStack.IRawString textList(System.Collections.IEnumerable target) => throw null;
            public ServiceStack.IRawString textList(System.Collections.IEnumerable target, System.Collections.Generic.Dictionary<string, object> options) => throw null;
            public static string TextList(System.Collections.IEnumerable items, ServiceStack.TextDumpOptions options) => throw null;
            public string textStyle(string text, string headerStyle) => throw null;
            public System.Collections.Generic.IEnumerable<object> thenBy(ServiceStack.Script.ScriptScopeContext scope, object target, object expression) => throw null;
            public System.Collections.Generic.IEnumerable<object> thenBy(ServiceStack.Script.ScriptScopeContext scope, object target, object expression, object scopeOptions) => throw null;
            public System.Collections.Generic.IEnumerable<object> thenByDescending(ServiceStack.Script.ScriptScopeContext scope, object target, object expression) => throw null;
            public System.Collections.Generic.IEnumerable<object> thenByDescending(ServiceStack.Script.ScriptScopeContext scope, object target, object expression, object scopeOptions) => throw null;
            public static System.Collections.Generic.IEnumerable<object> thenByInternal(string filterName, ServiceStack.Script.ScriptScopeContext scope, object target, object expression, object scopeOptions) => throw null;
            public object @throw(ServiceStack.Script.ScriptScopeContext scope, string message) => throw null;
            public object @throw(ServiceStack.Script.ScriptScopeContext scope, string message, object options) => throw null;
            public object throwArgumentException(ServiceStack.Script.ScriptScopeContext scope, string message) => throw null;
            public object throwArgumentException(ServiceStack.Script.ScriptScopeContext scope, string message, string options) => throw null;
            public object throwArgumentNullException(ServiceStack.Script.ScriptScopeContext scope, string paramName) => throw null;
            public object throwArgumentNullException(ServiceStack.Script.ScriptScopeContext scope, string paramName, object options) => throw null;
            public object throwArgumentNullExceptionIf(ServiceStack.Script.ScriptScopeContext scope, string paramName, bool test) => throw null;
            public object throwArgumentNullExceptionIf(ServiceStack.Script.ScriptScopeContext scope, string paramName, bool test, object options) => throw null;
            public System.Threading.Tasks.Task<object> throwAsync(ServiceStack.Script.ScriptScopeContext scope, string message) => throw null;
            public System.Threading.Tasks.Task<object> throwAsync(ServiceStack.Script.ScriptScopeContext scope, string message, object options) => throw null;
            public object throwFileNotFoundException(ServiceStack.Script.ScriptScopeContext scope, string message) => throw null;
            public object throwFileNotFoundException(ServiceStack.Script.ScriptScopeContext scope, string message, object options) => throw null;
            public object throwIf(ServiceStack.Script.ScriptScopeContext scope, string message, bool test) => throw null;
            public object throwIf(ServiceStack.Script.ScriptScopeContext scope, string message, bool test, object options) => throw null;
            public object throwNotImplementedException(ServiceStack.Script.ScriptScopeContext scope, string message) => throw null;
            public object throwNotImplementedException(ServiceStack.Script.ScriptScopeContext scope, string message, object options) => throw null;
            public object throwNotSupportedException(ServiceStack.Script.ScriptScopeContext scope, string message) => throw null;
            public object throwNotSupportedException(ServiceStack.Script.ScriptScopeContext scope, string message, object options) => throw null;
            public object throwOptimisticConcurrencyException(ServiceStack.Script.ScriptScopeContext scope, string message) => throw null;
            public object throwOptimisticConcurrencyException(ServiceStack.Script.ScriptScopeContext scope, string message, object options) => throw null;
            public object throwUnauthorizedAccessException(ServiceStack.Script.ScriptScopeContext scope, string message) => throw null;
            public object throwUnauthorizedAccessException(ServiceStack.Script.ScriptScopeContext scope, string message, object options) => throw null;
            public System.TimeSpan time(int hours, int mins, int secs) => throw null;
            public System.TimeSpan time(int days, int hours, int mins, int secs) => throw null;
            public string timeFormat(System.TimeSpan timeValue) => throw null;
            public string timeFormat(System.TimeSpan timeValue, string format) => throw null;
            public System.Collections.Generic.List<int> times(int count) => throw null;
            public string titleCase(string text) => throw null;
            public ServiceStack.Script.IgnoreResult to(ServiceStack.Script.ScriptScopeContext scope, object value, object argExpr) => throw null;
            public System.Threading.Tasks.Task to(ServiceStack.Script.ScriptScopeContext scope, object argExpr) => throw null;
            public object[] toArray(System.Collections.IEnumerable target) => throw null;
            public bool toBool(object target) => throw null;
            public byte toByte(object target) => throw null;
            public char toChar(object target) => throw null;
            public int toCharCode(object target) => throw null;
            public char[] toChars(object target) => throw null;
            public System.Collections.Generic.Dictionary<string, object> toCoercedDictionary(object target) => throw null;
            public System.DateTime toDateTime(object target) => throw null;
            public decimal toDecimal(object target) => throw null;
            public System.Collections.Generic.Dictionary<object, object> toDictionary(ServiceStack.Script.ScriptScopeContext scope, object target, object expression) => throw null;
            public System.Collections.Generic.Dictionary<object, object> toDictionary(ServiceStack.Script.ScriptScopeContext scope, object target, object expression, object scopeOptions) => throw null;
            public double toDouble(object target) => throw null;
            public System.Collections.Generic.List<string> toEnumFlagsList(object enumValue) => throw null;
            public float toFloat(object target) => throw null;
            public ServiceStack.Script.IgnoreResult toGlobal(ServiceStack.Script.ScriptScopeContext scope, object value, object argExpr) => throw null;
            public System.Threading.Tasks.Task toGlobal(ServiceStack.Script.ScriptScopeContext scope, object argExpr) => throw null;
            public int toInt(object target) => throw null;
            public System.Collections.Generic.List<string> toKeys(object target) => throw null;
            public System.Collections.Generic.List<object> toList(System.Collections.IEnumerable target) => throw null;
            public long toLong(object target) => throw null;
            public System.Collections.Generic.Dictionary<string, object> toObjectDictionary(object target) => throw null;
            public string toQueryString(object keyValuePairs) => throw null;
            public string toString(object target) => throw null;
            public System.Collections.Generic.Dictionary<string, string> toStringDictionary(System.Collections.IDictionary map) => throw null;
            public System.Collections.Generic.List<string> toStringList(System.Collections.IEnumerable target) => throw null;
            public System.TimeSpan toTimeSpan(object target) => throw null;
            public byte[] toUtf8Bytes(string target) => throw null;
            public System.Collections.Generic.List<object> toValues(object target) => throw null;
            public System.Collections.Generic.List<string> toVarNames(System.Collections.IEnumerable names) => throw null;
            public string trim(string text) => throw null;
            public string trim(string text, char c) => throw null;
            public string trimEnd(string text) => throw null;
            public string trimEnd(string text, char c) => throw null;
            public string trimStart(string text) => throw null;
            public string trimStart(string text, char c) => throw null;
            public double truncate(double value) => throw null;
            public object truthy(object test, object returnIfTruthy) => throw null;
            public ServiceStack.IRawString typeFullName(object target) => throw null;
            public ServiceStack.IRawString typeName(object target) => throw null;
            public System.Collections.Generic.IEnumerable<object> union(System.Collections.Generic.IEnumerable<object> target, System.Collections.Generic.IEnumerable<object> items) => throw null;
            public object unless(object returnTarget, object test) => throw null;
            public object unlessElse(object returnTarget, object test, object defaultValue) => throw null;
            public object unshift(System.Collections.IList list, object item) => throw null;
            public object unwrap(object value) => throw null;
            public string upper(string text) => throw null;
            public string urlDecode(string value) => throw null;
            public string urlEncode(string value, bool upperCase) => throw null;
            public string urlEncode(string value) => throw null;
            public object use(object ignoreTarget, object useValue) => throw null;
            public object useFmt(object ignoreTarget, string format, object arg) => throw null;
            public object useFmt(object ignoreTarget, string format, object arg1, object arg2) => throw null;
            public object useFmt(object ignoreTarget, string format, object arg1, object arg2, object arg3) => throw null;
            public object useFormat(object ignoreTarget, object arg, string fmt) => throw null;
            public object useIf(object useValue, object test) => throw null;
            public System.DateTime utcNow() => throw null;
            public System.DateTimeOffset utcNowOffset() => throw null;
            public System.Collections.ICollection values(object target) => throw null;
            public object when(object returnTarget, object test) => throw null;
            public System.Collections.Generic.IEnumerable<object> where(ServiceStack.Script.ScriptScopeContext scope, object target, object expression) => throw null;
            public System.Collections.Generic.IEnumerable<object> where(ServiceStack.Script.ScriptScopeContext scope, object target, object expression, object scopeOptions) => throw null;
            public object withKeys(System.Collections.Generic.IDictionary<string, object> target, object keys) => throw null;
            public object withoutEmptyValues(object target) => throw null;
            public object withoutKeys(System.Collections.Generic.IDictionary<string, object> target, object keys) => throw null;
            public object withoutNullValues(object target) => throw null;
            public ServiceStack.Script.IgnoreResult write(ServiceStack.Script.ScriptScopeContext scope, object value) => throw null;
            public ServiceStack.Script.IgnoreResult writeln(ServiceStack.Script.ScriptScopeContext scope, object value) => throw null;
            public System.Threading.Tasks.Task xml(ServiceStack.Script.ScriptScopeContext scope, object items) => throw null;
            public static string[] XssFragments;
            public System.Collections.Generic.List<object[]> zip(ServiceStack.Script.ScriptScopeContext scope, System.Collections.IEnumerable original, object itemsOrBinding) => throw null;
        }
        public class DefnScriptBlock : ServiceStack.Script.ScriptBlock
        {
            public override ServiceStack.Script.ScriptLanguage Body { get => throw null; }
            public DefnScriptBlock() => throw null;
            public override string Name { get => throw null; }
            public override System.Threading.Tasks.Task WriteAsync(ServiceStack.Script.ScriptScopeContext scope, ServiceStack.Script.PageBlockFragment block, System.Threading.CancellationToken token) => throw null;
        }
        public class DirectoryScripts : ServiceStack.Script.IOScript
        {
            public ServiceStack.Script.IgnoreResult Copy(string from, string to) => throw null;
            public static void CopyAllTo(string src, string dst, string[] excludePaths = default(string[])) => throw null;
            public ServiceStack.Script.IgnoreResult CreateDirectory(string path) => throw null;
            public DirectoryScripts() => throw null;
            public ServiceStack.Script.IgnoreResult Delete(string path) => throw null;
            public bool Exists(string path) => throw null;
            public string GetCurrentDirectory() => throw null;
            public string[] GetDirectories(string path) => throw null;
            public string GetDirectoryRoot(string path) => throw null;
            public string[] GetFiles(string path) => throw null;
            public string[] GetFileSystemEntries(string path) => throw null;
            public string[] GetLogicalDrives() => throw null;
            public System.IO.DirectoryInfo GetParent(string path) => throw null;
            public ServiceStack.Script.IgnoreResult Move(string from, string to) => throw null;
        }
        public class EachScriptBlock : ServiceStack.Script.ScriptBlock
        {
            public EachScriptBlock() => throw null;
            public override string Name { get => throw null; }
            public override System.Threading.Tasks.Task WriteAsync(ServiceStack.Script.ScriptScopeContext scope, ServiceStack.Script.PageBlockFragment block, System.Threading.CancellationToken token) => throw null;
        }
        public class EvalScriptBlock : ServiceStack.Script.ScriptBlock
        {
            public override ServiceStack.Script.ScriptLanguage Body { get => throw null; }
            public EvalScriptBlock() => throw null;
            public override string Name { get => throw null; }
            public override System.Threading.Tasks.Task WriteAsync(ServiceStack.Script.ScriptScopeContext scope, ServiceStack.Script.PageBlockFragment block, System.Threading.CancellationToken token) => throw null;
        }
        public class FileScripts : ServiceStack.Script.IOScript
        {
            public ServiceStack.Script.IgnoreResult AppendAllLines(string path, string[] lines) => throw null;
            public ServiceStack.Script.IgnoreResult AppendAllText(string path, string text) => throw null;
            public ServiceStack.Script.IgnoreResult Copy(string from, string to) => throw null;
            public ServiceStack.Script.IgnoreResult Create(string path) => throw null;
            public FileScripts() => throw null;
            public ServiceStack.Script.IgnoreResult Decrypt(string path) => throw null;
            public ServiceStack.Script.IgnoreResult Delete(string path) => throw null;
            public ServiceStack.Script.IgnoreResult Encrypt(string path) => throw null;
            public bool Exists(string path) => throw null;
            public ServiceStack.Script.IgnoreResult Move(string from, string to) => throw null;
            public byte[] ReadAllBytes(string path) => throw null;
            public string[] ReadAllLines(string path) => throw null;
            public string ReadAllText(string path) => throw null;
            public ServiceStack.Script.IgnoreResult Replace(string from, string to, string backup) => throw null;
            public ServiceStack.Script.IgnoreResult WriteAllBytes(string path, byte[] bytes) => throw null;
            public ServiceStack.Script.IgnoreResult WriteAllLines(string path, string[] lines) => throw null;
            public ServiceStack.Script.IgnoreResult WriteAllText(string path, string text) => throw null;
        }
        public class FunctionScriptBlock : ServiceStack.Script.ScriptBlock
        {
            public override ServiceStack.Script.ScriptLanguage Body { get => throw null; }
            public FunctionScriptBlock() => throw null;
            public override string Name { get => throw null; }
            public override System.Threading.Tasks.Task WriteAsync(ServiceStack.Script.ScriptScopeContext scope, ServiceStack.Script.PageBlockFragment block, System.Threading.CancellationToken token) => throw null;
        }
        public class GitHubPlugin : ServiceStack.Script.IScriptPlugin
        {
            public GitHubPlugin() => throw null;
            public void Register(ServiceStack.Script.ScriptContext context) => throw null;
        }
        public class GitHubScripts : ServiceStack.Script.ScriptMethods
        {
            public GitHubScripts() => throw null;
            public ServiceStack.IO.GistVirtualFiles gistVirtualFiles(string gistId) => throw null;
            public ServiceStack.IO.GistVirtualFiles gistVirtualFiles(string gistId, string accessToken) => throw null;
            public ServiceStack.GithubGist githubCreateGist(ServiceStack.GitHubGateway gateway, string description, System.Collections.Generic.Dictionary<string, string> files) => throw null;
            public ServiceStack.GithubGist githubCreatePrivateGist(ServiceStack.GitHubGateway gateway, string description, System.Collections.Generic.Dictionary<string, string> files) => throw null;
            public ServiceStack.GitHubGateway githubGateway() => throw null;
            public ServiceStack.GitHubGateway githubGateway(string accessToken) => throw null;
            public ServiceStack.GithubGist githubGist(ServiceStack.GitHubGateway gateway, string gistId) => throw null;
            public System.Collections.Generic.List<ServiceStack.GithubRepo> githubOrgRepos(ServiceStack.GitHubGateway gateway, string githubOrg) => throw null;
            public System.Threading.Tasks.Task<object> githubSourceRepos(ServiceStack.GitHubGateway gateway, string orgName) => throw null;
            public string githubSourceZipUrl(ServiceStack.GitHubGateway gateway, string orgNames, string name) => throw null;
            public System.Threading.Tasks.Task<object> githubUserAndOrgRepos(ServiceStack.GitHubGateway gateway, string githubOrgOrUser) => throw null;
            public System.Collections.Generic.List<ServiceStack.GithubRepo> githubUserRepos(ServiceStack.GitHubGateway gateway, string githubUser) => throw null;
            public ServiceStack.Script.IgnoreResult githubWriteGistFile(ServiceStack.GitHubGateway gateway, string gistId, string filePath, string contents) => throw null;
            public ServiceStack.Script.IgnoreResult githubWriteGistFiles(ServiceStack.GitHubGateway gateway, string gistId, System.Collections.Generic.Dictionary<string, string> gistFiles) => throw null;
            public ServiceStack.Script.IgnoreResult githuDeleteGistFiles(ServiceStack.GitHubGateway gateway, string gistId, string filePath) => throw null;
            public ServiceStack.Script.IgnoreResult githuDeleteGistFiles(ServiceStack.GitHubGateway gateway, string gistId, System.Collections.Generic.IEnumerable<string> filePaths) => throw null;
        }
        public class HtmlPageFormat : ServiceStack.Script.PageFormat
        {
            public HtmlPageFormat() => throw null;
            public static System.Threading.Tasks.Task<System.IO.Stream> HtmlEncodeTransformer(System.IO.Stream stream) => throw null;
            public static string HtmlEncodeValue(object value) => throw null;
            public virtual object HtmlExpressionException(ServiceStack.Script.PageResult result, System.Exception ex) => throw null;
            public ServiceStack.Script.SharpPage HtmlResolveLayout(ServiceStack.Script.SharpPage page) => throw null;
        }
        public class HtmlScriptBlocks : ServiceStack.Script.IScriptPlugin
        {
            public HtmlScriptBlocks() => throw null;
            public void Register(ServiceStack.Script.ScriptContext context) => throw null;
        }
        public class HtmlScripts : ServiceStack.Script.ScriptMethods, ServiceStack.Script.IConfigureScriptContext
        {
            public void Configure(ServiceStack.Script.ScriptContext context) => throw null;
            public HtmlScripts() => throw null;
            public static System.Collections.Generic.List<string> EvaluateWhenSkippingFilterExecution;
            public ServiceStack.IRawString htmlA(System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlA(string innerHtml, System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public string htmlAddClass(object target, string name) => throw null;
            public ServiceStack.IRawString htmlAttrs(object target) => throw null;
            public string htmlAttrsList(System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlB(string innerHtml, System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlB(string text) => throw null;
            public ServiceStack.IRawString htmlButton(System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlButton(string innerHtml, System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlClass(object target) => throw null;
            public string htmlClassList(object target) => throw null;
            public ServiceStack.IRawString htmlDiv(System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlDiv(string innerHtml, System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlDump(object target) => throw null;
            public ServiceStack.IRawString htmlDump(object target, System.Collections.Generic.Dictionary<string, object> options) => throw null;
            public static string HtmlDump(object target, ServiceStack.HtmlDumpOptions options) => throw null;
            public ServiceStack.IRawString htmlEm(string innerHtml, System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlEm(string text) => throw null;
            public ServiceStack.IRawString htmlError(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public ServiceStack.IRawString htmlError(ServiceStack.Script.ScriptScopeContext scope, System.Exception ex) => throw null;
            public ServiceStack.IRawString htmlError(ServiceStack.Script.ScriptScopeContext scope, System.Exception ex, object options) => throw null;
            public ServiceStack.IRawString htmlErrorDebug(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public ServiceStack.IRawString htmlErrorDebug(ServiceStack.Script.ScriptScopeContext scope, object ex) => throw null;
            public ServiceStack.IRawString htmlErrorDebug(ServiceStack.Script.ScriptScopeContext scope, System.Exception ex, object options) => throw null;
            public ServiceStack.IRawString htmlErrorMessage(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public ServiceStack.IRawString htmlErrorMessage(System.Exception ex) => throw null;
            public ServiceStack.IRawString htmlErrorMessage(System.Exception ex, object options) => throw null;
            public ServiceStack.IRawString htmlForm(System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlForm(string innerHtml, System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlFormat(string htmlWithFormat, string arg) => throw null;
            public ServiceStack.IRawString htmlH1(System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlH1(string innerHtml, System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlH2(System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlH2(string innerHtml, System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlH3(System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlH3(string innerHtml, System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlH4(System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlH4(string innerHtml, System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlH5(System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlH5(string innerHtml, System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlH6(System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlH6(string innerHtml, System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public bool htmlHasClass(object target, string name) => throw null;
            public ServiceStack.IRawString htmlHiddenInputs(System.Collections.Generic.Dictionary<string, object> inputValues) => throw null;
            public ServiceStack.IRawString htmlImage(string src) => throw null;
            public ServiceStack.IRawString htmlImage(string src, System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlImg(System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlImg(string innerHtml, System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlInput(System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlInput(string innerHtml, System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlLabel(System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlLabel(string innerHtml, System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlLi(System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlLi(string innerHtml, System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlLink(string href) => throw null;
            public ServiceStack.IRawString htmlLink(string href, System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlList(System.Collections.IEnumerable target) => throw null;
            public ServiceStack.IRawString htmlList(System.Collections.IEnumerable target, System.Collections.Generic.Dictionary<string, object> options) => throw null;
            public static string HtmlList(System.Collections.IEnumerable items, ServiceStack.HtmlDumpOptions options) => throw null;
            public ServiceStack.IRawString htmlOl(System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlOl(string innerHtml, System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlOption(string innerHtml, System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlOption(string text) => throw null;
            public ServiceStack.IRawString htmlOptions(object values) => throw null;
            public ServiceStack.IRawString htmlOptions(object values, object options) => throw null;
            public ServiceStack.IRawString htmlSelect(System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlSelect(string innerHtml, System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlSpan(System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlSpan(string innerHtml, System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlTable(System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlTable(string innerHtml, System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlTag(System.Collections.Generic.Dictionary<string, object> attrs, string tag) => throw null;
            public ServiceStack.IRawString htmlTag(string innerHtml, System.Collections.Generic.Dictionary<string, object> attrs, string tag) => throw null;
            public ServiceStack.IRawString htmlTd(System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlTd(string innerHtml, System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlTextArea(System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlTextArea(string innerHtml, System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlTh(System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlTh(string innerHtml, System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlTr(System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlTr(string innerHtml, System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlUl(System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public ServiceStack.IRawString htmlUl(string innerHtml, System.Collections.Generic.Dictionary<string, object> attrs) => throw null;
            public static System.Collections.Generic.HashSet<string> VoidElements { get => throw null; }
        }
        public interface IConfigurePageResult
        {
            void Configure(ServiceStack.Script.PageResult pageResult);
        }
        public interface IConfigureScriptContext
        {
            void Configure(ServiceStack.Script.ScriptContext context);
        }
        public class IfScriptBlock : ServiceStack.Script.ScriptBlock
        {
            public IfScriptBlock() => throw null;
            public override string Name { get => throw null; }
            public override System.Threading.Tasks.Task WriteAsync(ServiceStack.Script.ScriptScopeContext scope, ServiceStack.Script.PageBlockFragment block, System.Threading.CancellationToken token) => throw null;
        }
        public class IgnoreResult : ServiceStack.Script.IResultInstruction
        {
            public static readonly ServiceStack.Script.IgnoreResult Value;
        }
        public enum InvokerType
        {
            Filter = 0,
            ContextFilter = 1,
            ContextBlock = 2,
        }
        public interface IOScript
        {
            ServiceStack.Script.IgnoreResult Copy(string from, string to);
            ServiceStack.Script.IgnoreResult Delete(string path);
            bool Exists(string target);
            ServiceStack.Script.IgnoreResult Move(string from, string to);
        }
        public interface IPageResult
        {
        }
        public interface IResultInstruction
        {
        }
        public interface IScriptPlugin
        {
            void Register(ServiceStack.Script.ScriptContext context);
        }
        public interface IScriptPluginAfter
        {
            void AfterPluginsLoaded(ServiceStack.Script.ScriptContext context);
        }
        public interface IScriptPluginBefore
        {
            void BeforePluginsLoaded(ServiceStack.Script.ScriptContext context);
        }
        public interface ISharpPages
        {
            ServiceStack.Script.SharpPage AddPage(string virtualPath, ServiceStack.IO.IVirtualFile file);
            ServiceStack.Script.SharpCodePage GetCodePage(string virtualPath);
            System.DateTime GetLastModified(ServiceStack.Script.SharpPage page);
            ServiceStack.Script.SharpPage GetPage(string virtualPath);
            ServiceStack.Script.SharpPage OneTimePage(string contents, string ext);
            ServiceStack.Script.SharpPage OneTimePage(string contents, string ext, System.Action<ServiceStack.Script.SharpPage> init);
            ServiceStack.Script.SharpPage ResolveLayoutPage(ServiceStack.Script.SharpPage page, string layout);
            ServiceStack.Script.SharpPage ResolveLayoutPage(ServiceStack.Script.SharpCodePage page, string layout);
            ServiceStack.Script.SharpPage TryGetPage(string path);
        }
        public class JsAddition : ServiceStack.Script.JsBinaryOperator
        {
            public override object Evaluate(object lhs, object rhs) => throw null;
            public static ServiceStack.Script.JsAddition Operator;
            public override string Token { get => throw null; }
        }
        public class JsAnd : ServiceStack.Script.JsLogicOperator
        {
            public static ServiceStack.Script.JsAnd Operator;
            public override bool Test(object lhs, object rhs) => throw null;
            public override string Token { get => throw null; }
        }
        public class JsArrayExpression : ServiceStack.Script.JsExpression
        {
            public JsArrayExpression(params ServiceStack.Script.JsToken[] elements) => throw null;
            public JsArrayExpression(System.Collections.Generic.IEnumerable<ServiceStack.Script.JsToken> elements) => throw null;
            public ServiceStack.Script.JsToken[] Elements { get => throw null; }
            protected bool Equals(ServiceStack.Script.JsArrayExpression other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override object Evaluate(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public override int GetHashCode() => throw null;
            public override System.Collections.Generic.Dictionary<string, object> ToJsAst() => throw null;
            public override string ToRawString() => throw null;
        }
        public class JsArrowFunctionExpression : ServiceStack.Script.JsExpression
        {
            public ServiceStack.Script.JsToken Body { get => throw null; }
            public JsArrowFunctionExpression(ServiceStack.Script.JsIdentifier param, ServiceStack.Script.JsToken body) => throw null;
            public JsArrowFunctionExpression(ServiceStack.Script.JsIdentifier[] @params, ServiceStack.Script.JsToken body) => throw null;
            protected bool Equals(ServiceStack.Script.JsArrowFunctionExpression other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override object Evaluate(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public override int GetHashCode() => throw null;
            public object Invoke(params object[] @params) => throw null;
            public object Invoke(ServiceStack.Script.ScriptScopeContext scope, params object[] @params) => throw null;
            public ServiceStack.Script.JsIdentifier[] Params { get => throw null; }
            public override System.Collections.Generic.Dictionary<string, object> ToJsAst() => throw null;
            public override string ToRawString() => throw null;
        }
        public class JsAssignment : ServiceStack.Script.JsBinaryOperator
        {
            public override object Evaluate(object lhs, object rhs) => throw null;
            public static ServiceStack.Script.JsAssignment Operator;
            public override string Token { get => throw null; }
        }
        public class JsAssignmentExpression : ServiceStack.Script.JsExpression
        {
            public JsAssignmentExpression(ServiceStack.Script.JsToken left, ServiceStack.Script.JsAssignment @operator, ServiceStack.Script.JsToken right) => throw null;
            protected bool Equals(ServiceStack.Script.JsAssignmentExpression other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override object Evaluate(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public override int GetHashCode() => throw null;
            public ServiceStack.Script.JsToken Left { get => throw null; set { } }
            public ServiceStack.Script.JsAssignment Operator { get => throw null; set { } }
            public ServiceStack.Script.JsToken Right { get => throw null; set { } }
            public override System.Collections.Generic.Dictionary<string, object> ToJsAst() => throw null;
            public override string ToRawString() => throw null;
        }
        public class JsBinaryExpression : ServiceStack.Script.JsExpression
        {
            public JsBinaryExpression(ServiceStack.Script.JsToken left, ServiceStack.Script.JsBinaryOperator @operator, ServiceStack.Script.JsToken right) => throw null;
            protected bool Equals(ServiceStack.Script.JsBinaryExpression other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override object Evaluate(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public override int GetHashCode() => throw null;
            public ServiceStack.Script.JsToken Left { get => throw null; set { } }
            public ServiceStack.Script.JsBinaryOperator Operator { get => throw null; set { } }
            public ServiceStack.Script.JsToken Right { get => throw null; set { } }
            public override System.Collections.Generic.Dictionary<string, object> ToJsAst() => throw null;
            public override string ToRawString() => throw null;
        }
        public abstract class JsBinaryOperator : ServiceStack.Script.JsOperator
        {
            protected JsBinaryOperator() => throw null;
            public abstract object Evaluate(object lhs, object rhs);
        }
        public class JsBitwiseAnd : ServiceStack.Script.JsBinaryOperator
        {
            public override object Evaluate(object lhs, object rhs) => throw null;
            public static ServiceStack.Script.JsBitwiseAnd Operator;
            public override string Token { get => throw null; }
        }
        public class JsBitwiseLeftShift : ServiceStack.Script.JsBinaryOperator
        {
            public override object Evaluate(object lhs, object rhs) => throw null;
            public static ServiceStack.Script.JsBitwiseLeftShift Operator;
            public override string Token { get => throw null; }
        }
        public class JsBitwiseNot : ServiceStack.Script.JsUnaryOperator
        {
            public override object Evaluate(object target) => throw null;
            public static ServiceStack.Script.JsBitwiseNot Operator;
            public override string Token { get => throw null; }
        }
        public class JsBitwiseOr : ServiceStack.Script.JsBinaryOperator
        {
            public override object Evaluate(object lhs, object rhs) => throw null;
            public static ServiceStack.Script.JsBitwiseOr Operator;
            public override string Token { get => throw null; }
        }
        public class JsBitwiseRightShift : ServiceStack.Script.JsBinaryOperator
        {
            public override object Evaluate(object lhs, object rhs) => throw null;
            public static ServiceStack.Script.JsBitwiseRightShift Operator;
            public override string Token { get => throw null; }
        }
        public class JsBitwiseXOr : ServiceStack.Script.JsBinaryOperator
        {
            public override object Evaluate(object lhs, object rhs) => throw null;
            public static ServiceStack.Script.JsBitwiseXOr Operator;
            public override string Token { get => throw null; }
        }
        public class JsBlockStatement : ServiceStack.Script.JsStatement
        {
            public JsBlockStatement(ServiceStack.Script.JsStatement[] statements) => throw null;
            public JsBlockStatement(ServiceStack.Script.JsStatement statement) => throw null;
            protected bool Equals(ServiceStack.Script.JsBlockStatement other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public ServiceStack.Script.JsStatement[] Statements { get => throw null; }
        }
        public class JsCallExpression : ServiceStack.Script.JsExpression
        {
            public ServiceStack.Script.JsToken[] Arguments { get => throw null; }
            public ServiceStack.Script.JsToken Callee { get => throw null; }
            public JsCallExpression(ServiceStack.Script.JsToken callee, params ServiceStack.Script.JsToken[] arguments) => throw null;
            protected bool Equals(ServiceStack.Script.JsCallExpression other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override object Evaluate(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public static System.Collections.Generic.List<object> EvaluateArgumentValues(ServiceStack.Script.ScriptScopeContext scope, ServiceStack.Script.JsToken[] args) => throw null;
            public string GetDisplayName() => throw null;
            public override int GetHashCode() => throw null;
            public static object InvokeDelegate(System.Delegate fn, object target, bool isMemberExpr, System.Collections.Generic.List<object> fnArgValues) => throw null;
            public string Name { get => throw null; }
            public override System.Collections.Generic.Dictionary<string, object> ToJsAst() => throw null;
            public override string ToRawString() => throw null;
            public override string ToString() => throw null;
        }
        public class JsCoalescing : ServiceStack.Script.JsBinaryOperator
        {
            public override object Evaluate(object lhs, object rhs) => throw null;
            public static ServiceStack.Script.JsCoalescing Operator;
            public override string Token { get => throw null; }
        }
        public class JsConditionalExpression : ServiceStack.Script.JsExpression
        {
            public ServiceStack.Script.JsToken Alternate { get => throw null; }
            public ServiceStack.Script.JsToken Consequent { get => throw null; }
            public JsConditionalExpression(ServiceStack.Script.JsToken test, ServiceStack.Script.JsToken consequent, ServiceStack.Script.JsToken alternate) => throw null;
            protected bool Equals(ServiceStack.Script.JsConditionalExpression other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override object Evaluate(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public override int GetHashCode() => throw null;
            public ServiceStack.Script.JsToken Test { get => throw null; }
            public override System.Collections.Generic.Dictionary<string, object> ToJsAst() => throw null;
            public override string ToRawString() => throw null;
        }
        public class JsDeclaration : ServiceStack.Script.JsExpression
        {
            public JsDeclaration(ServiceStack.Script.JsIdentifier id, ServiceStack.Script.JsToken init) => throw null;
            protected bool Equals(ServiceStack.Script.JsDeclaration other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override object Evaluate(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public override int GetHashCode() => throw null;
            public ServiceStack.Script.JsIdentifier Id { get => throw null; set { } }
            public ServiceStack.Script.JsToken Init { get => throw null; set { } }
            public override System.Collections.Generic.Dictionary<string, object> ToJsAst() => throw null;
            public override string ToRawString() => throw null;
        }
        public class JsDivision : ServiceStack.Script.JsBinaryOperator
        {
            public override object Evaluate(object lhs, object rhs) => throw null;
            public static ServiceStack.Script.JsDivision Operator;
            public override string Token { get => throw null; }
        }
        public class JsEquals : ServiceStack.Script.JsLogicOperator
        {
            public static ServiceStack.Script.JsEquals Operator;
            public override bool Test(object lhs, object rhs) => throw null;
            public override string Token { get => throw null; }
        }
        public abstract class JsExpression : ServiceStack.Script.JsToken
        {
            protected JsExpression() => throw null;
            public abstract System.Collections.Generic.Dictionary<string, object> ToJsAst();
            public virtual string ToJsAstType() => throw null;
        }
        public class JsExpressionStatement : ServiceStack.Script.JsStatement
        {
            public JsExpressionStatement(ServiceStack.Script.JsToken expression) => throw null;
            protected bool Equals(ServiceStack.Script.JsExpressionStatement other) => throw null;
            public override bool Equals(object obj) => throw null;
            public ServiceStack.Script.JsToken Expression { get => throw null; }
            public override int GetHashCode() => throw null;
        }
        public static class JsExpressionUtils
        {
            public static ServiceStack.Script.JsExpression CreateJsExpression(ServiceStack.Script.JsToken lhs, ServiceStack.Script.JsBinaryOperator op, ServiceStack.Script.JsToken rhs) => throw null;
            public static ServiceStack.Script.JsToken GetCachedJsExpression(this System.ReadOnlyMemory<char> expr, ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public static ServiceStack.Script.JsToken GetCachedJsExpression(this string expr, ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public static object GetJsExpressionAndEvaluate(this System.ReadOnlyMemory<char> expr, ServiceStack.Script.ScriptScopeContext scope, System.Action ifNone = default(System.Action)) => throw null;
            public static System.Threading.Tasks.Task<object> GetJsExpressionAndEvaluateAsync(this System.ReadOnlyMemory<char> expr, ServiceStack.Script.ScriptScopeContext scope, System.Action ifNone = default(System.Action)) => throw null;
            public static bool GetJsExpressionAndEvaluateToBool(this System.ReadOnlyMemory<char> expr, ServiceStack.Script.ScriptScopeContext scope, System.Action ifNone = default(System.Action)) => throw null;
            public static System.Threading.Tasks.Task<bool> GetJsExpressionAndEvaluateToBoolAsync(this System.ReadOnlyMemory<char> expr, ServiceStack.Script.ScriptScopeContext scope, System.Action ifNone = default(System.Action)) => throw null;
            public static System.ReadOnlySpan<char> ParseBinaryExpression(this System.ReadOnlySpan<char> literal, out ServiceStack.Script.JsExpression expr, bool filterExpression) => throw null;
            public static System.ReadOnlySpan<char> ParseJsExpression(this string literal, out ServiceStack.Script.JsToken token) => throw null;
            public static System.ReadOnlySpan<char> ParseJsExpression(this System.ReadOnlySpan<char> literal, out ServiceStack.Script.JsToken token) => throw null;
            public static System.ReadOnlySpan<char> ParseJsExpression(this System.ReadOnlyMemory<char> literal, out ServiceStack.Script.JsToken token) => throw null;
            public static System.ReadOnlySpan<char> ParseJsExpression(this System.ReadOnlySpan<char> literal, out ServiceStack.Script.JsToken token, bool filterExpression) => throw null;
        }
        public class JsFilterExpressionStatement : ServiceStack.Script.JsStatement
        {
            public JsFilterExpressionStatement(System.ReadOnlyMemory<char> originalText, ServiceStack.Script.JsToken expr, System.Collections.Generic.List<ServiceStack.Script.JsCallExpression> filters) => throw null;
            public JsFilterExpressionStatement(string originalText, ServiceStack.Script.JsToken expr, params ServiceStack.Script.JsCallExpression[] filters) => throw null;
            protected bool Equals(ServiceStack.Script.JsFilterExpressionStatement other) => throw null;
            public override bool Equals(object obj) => throw null;
            public ServiceStack.Script.PageVariableFragment FilterExpression { get => throw null; }
            public override int GetHashCode() => throw null;
        }
        public class JsGreaterThan : ServiceStack.Script.JsLogicOperator
        {
            public static ServiceStack.Script.JsGreaterThan Operator;
            public override bool Test(object lhs, object rhs) => throw null;
            public override string Token { get => throw null; }
        }
        public class JsGreaterThanEqual : ServiceStack.Script.JsLogicOperator
        {
            public static ServiceStack.Script.JsGreaterThanEqual Operator;
            public override bool Test(object lhs, object rhs) => throw null;
            public override string Token { get => throw null; }
        }
        public class JsIdentifier : ServiceStack.Script.JsExpression
        {
            public JsIdentifier(string name) => throw null;
            public JsIdentifier(System.ReadOnlySpan<char> name) => throw null;
            protected bool Equals(ServiceStack.Script.JsIdentifier other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override object Evaluate(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public override int GetHashCode() => throw null;
            public string Name { get => throw null; }
            public override System.Collections.Generic.Dictionary<string, object> ToJsAst() => throw null;
            public override string ToRawString() => throw null;
            public override string ToString() => throw null;
        }
        public class JsLessThan : ServiceStack.Script.JsLogicOperator
        {
            public static ServiceStack.Script.JsLessThan Operator;
            public override bool Test(object lhs, object rhs) => throw null;
            public override string Token { get => throw null; }
        }
        public class JsLessThanEqual : ServiceStack.Script.JsLogicOperator
        {
            public static ServiceStack.Script.JsLessThanEqual Operator;
            public override bool Test(object lhs, object rhs) => throw null;
            public override string Token { get => throw null; }
        }
        public class JsLiteral : ServiceStack.Script.JsExpression
        {
            public JsLiteral(object value) => throw null;
            protected bool Equals(ServiceStack.Script.JsLiteral other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override object Evaluate(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public static ServiceStack.Script.JsLiteral False;
            public override int GetHashCode() => throw null;
            public override System.Collections.Generic.Dictionary<string, object> ToJsAst() => throw null;
            public override string ToRawString() => throw null;
            public override string ToString() => throw null;
            public static ServiceStack.Script.JsLiteral True;
            public object Value { get => throw null; }
        }
        public class JsLogicalExpression : ServiceStack.Script.JsExpression
        {
            public JsLogicalExpression(ServiceStack.Script.JsToken left, ServiceStack.Script.JsLogicOperator @operator, ServiceStack.Script.JsToken right) => throw null;
            protected bool Equals(ServiceStack.Script.JsLogicalExpression other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override object Evaluate(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public override int GetHashCode() => throw null;
            public ServiceStack.Script.JsToken Left { get => throw null; set { } }
            public ServiceStack.Script.JsLogicOperator Operator { get => throw null; set { } }
            public ServiceStack.Script.JsToken Right { get => throw null; set { } }
            public override System.Collections.Generic.Dictionary<string, object> ToJsAst() => throw null;
            public override string ToRawString() => throw null;
        }
        public abstract class JsLogicOperator : ServiceStack.Script.JsBinaryOperator
        {
            protected JsLogicOperator() => throw null;
            public override object Evaluate(object lhs, object rhs) => throw null;
            public abstract bool Test(object lhs, object rhs);
        }
        public class JsMemberExpression : ServiceStack.Script.JsExpression
        {
            public bool Computed { get => throw null; }
            public JsMemberExpression(ServiceStack.Script.JsToken @object, ServiceStack.Script.JsToken property) => throw null;
            public JsMemberExpression(ServiceStack.Script.JsToken @object, ServiceStack.Script.JsToken property, bool computed) => throw null;
            protected bool Equals(ServiceStack.Script.JsMemberExpression other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override object Evaluate(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public override int GetHashCode() => throw null;
            public ServiceStack.Script.JsToken Object { get => throw null; }
            public ServiceStack.Script.JsToken Property { get => throw null; }
            public override System.Collections.Generic.Dictionary<string, object> ToJsAst() => throw null;
            public override string ToRawString() => throw null;
        }
        public class JsMinus : ServiceStack.Script.JsUnaryOperator
        {
            public override object Evaluate(object target) => throw null;
            public static ServiceStack.Script.JsMinus Operator;
            public override string Token { get => throw null; }
        }
        public class JsMod : ServiceStack.Script.JsBinaryOperator
        {
            public override object Evaluate(object lhs, object rhs) => throw null;
            public static ServiceStack.Script.JsMod Operator;
            public override string Token { get => throw null; }
        }
        public class JsMultiplication : ServiceStack.Script.JsBinaryOperator
        {
            public override object Evaluate(object lhs, object rhs) => throw null;
            public static ServiceStack.Script.JsMultiplication Operator;
            public override string Token { get => throw null; }
        }
        public class JsNot : ServiceStack.Script.JsUnaryOperator
        {
            public override object Evaluate(object target) => throw null;
            public static ServiceStack.Script.JsNot Operator;
            public override string Token { get => throw null; }
        }
        public class JsNotEquals : ServiceStack.Script.JsLogicOperator
        {
            public static ServiceStack.Script.JsNotEquals Operator;
            public override bool Test(object lhs, object rhs) => throw null;
            public override string Token { get => throw null; }
        }
        public static class JsNull
        {
            public const string String = default;
            public static ServiceStack.Script.JsLiteral Value;
        }
        public class JsObjectExpression : ServiceStack.Script.JsExpression
        {
            public JsObjectExpression(params ServiceStack.Script.JsProperty[] properties) => throw null;
            public JsObjectExpression(System.Collections.Generic.IEnumerable<ServiceStack.Script.JsProperty> properties) => throw null;
            protected bool Equals(ServiceStack.Script.JsObjectExpression other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override object Evaluate(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public override int GetHashCode() => throw null;
            public static string GetKey(ServiceStack.Script.JsToken token) => throw null;
            public ServiceStack.Script.JsProperty[] Properties { get => throw null; }
            public override System.Collections.Generic.Dictionary<string, object> ToJsAst() => throw null;
            public override string ToRawString() => throw null;
        }
        public abstract class JsOperator : ServiceStack.Script.JsToken
        {
            protected JsOperator() => throw null;
            public override object Evaluate(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public abstract string Token { get; }
            public override string ToRawString() => throw null;
        }
        public class JsOr : ServiceStack.Script.JsLogicOperator
        {
            public static ServiceStack.Script.JsOr Operator;
            public override bool Test(object lhs, object rhs) => throw null;
            public override string Token { get => throw null; }
        }
        public class JsPageBlockFragmentStatement : ServiceStack.Script.JsStatement
        {
            public ServiceStack.Script.PageBlockFragment Block { get => throw null; }
            public JsPageBlockFragmentStatement(ServiceStack.Script.PageBlockFragment block) => throw null;
            protected bool Equals(ServiceStack.Script.JsPageBlockFragmentStatement other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
        }
        public class JsPlus : ServiceStack.Script.JsUnaryOperator
        {
            public override object Evaluate(object target) => throw null;
            public static ServiceStack.Script.JsPlus Operator;
            public override string Token { get => throw null; }
        }
        public class JsProperty
        {
            public JsProperty(ServiceStack.Script.JsToken key, ServiceStack.Script.JsToken value) => throw null;
            public JsProperty(ServiceStack.Script.JsToken key, ServiceStack.Script.JsToken value, bool shorthand) => throw null;
            protected bool Equals(ServiceStack.Script.JsProperty other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public ServiceStack.Script.JsToken Key { get => throw null; }
            public bool Shorthand { get => throw null; }
            public ServiceStack.Script.JsToken Value { get => throw null; }
        }
        public class JsSpreadElement : ServiceStack.Script.JsExpression
        {
            public ServiceStack.Script.JsToken Argument { get => throw null; }
            public JsSpreadElement(ServiceStack.Script.JsToken argument) => throw null;
            protected bool Equals(ServiceStack.Script.JsSpreadElement other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override object Evaluate(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public override int GetHashCode() => throw null;
            public override System.Collections.Generic.Dictionary<string, object> ToJsAst() => throw null;
            public override string ToRawString() => throw null;
        }
        public abstract class JsStatement
        {
            protected JsStatement() => throw null;
        }
        public class JsStrictEquals : ServiceStack.Script.JsLogicOperator
        {
            public static ServiceStack.Script.JsStrictEquals Operator;
            public override bool Test(object lhs, object rhs) => throw null;
            public override string Token { get => throw null; }
        }
        public class JsStrictNotEquals : ServiceStack.Script.JsLogicOperator
        {
            public static ServiceStack.Script.JsStrictNotEquals Operator;
            public override bool Test(object lhs, object rhs) => throw null;
            public override string Token { get => throw null; }
        }
        public class JsSubtraction : ServiceStack.Script.JsBinaryOperator
        {
            public override object Evaluate(object lhs, object rhs) => throw null;
            public static ServiceStack.Script.JsSubtraction Operator;
            public override string Token { get => throw null; }
        }
        public class JsTemplateElement
        {
            public JsTemplateElement(string raw, string cooked, bool tail = default(bool)) => throw null;
            public JsTemplateElement(ServiceStack.Script.JsTemplateElementValue value, bool tail) => throw null;
            protected bool Equals(ServiceStack.Script.JsTemplateElement other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public bool Tail { get => throw null; }
            public ServiceStack.Script.JsTemplateElementValue Value { get => throw null; }
        }
        public class JsTemplateElementValue
        {
            public string Cooked { get => throw null; }
            public JsTemplateElementValue(string raw, string cooked) => throw null;
            protected bool Equals(ServiceStack.Script.JsTemplateElementValue other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public string Raw { get => throw null; }
        }
        public class JsTemplateLiteral : ServiceStack.Script.JsExpression
        {
            public JsTemplateLiteral(string cooked) => throw null;
            public JsTemplateLiteral(ServiceStack.Script.JsTemplateElement[] quasis = default(ServiceStack.Script.JsTemplateElement[]), ServiceStack.Script.JsToken[] expressions = default(ServiceStack.Script.JsToken[])) => throw null;
            protected bool Equals(ServiceStack.Script.JsTemplateLiteral other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override object Evaluate(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public ServiceStack.Script.JsToken[] Expressions { get => throw null; }
            public override int GetHashCode() => throw null;
            public ServiceStack.Script.JsTemplateElement[] Quasis { get => throw null; }
            public override System.Collections.Generic.Dictionary<string, object> ToJsAst() => throw null;
            public override string ToRawString() => throw null;
            public override string ToString() => throw null;
        }
        public abstract class JsToken : ServiceStack.IRawString
        {
            protected JsToken() => throw null;
            public abstract object Evaluate(ServiceStack.Script.ScriptScopeContext scope);
            public string JsonValue(object value) => throw null;
            public abstract string ToRawString();
            public override string ToString() => throw null;
            public static object UnwrapValue(ServiceStack.Script.JsToken token) => throw null;
        }
        public static class JsTokenUtils
        {
            public static System.ReadOnlySpan<char> AdvancePastPipeOperator(this System.ReadOnlySpan<char> literal) => throw null;
            public static System.ReadOnlyMemory<char> Chop(this System.ReadOnlyMemory<char> literal, char c) => throw null;
            public static System.ReadOnlySpan<char> Chop(this System.ReadOnlySpan<char> literal, char c) => throw null;
            public static System.ReadOnlyMemory<char> ChopNewLine(this System.ReadOnlyMemory<char> literal) => throw null;
            public static int CountPrecedingOccurrences(this System.ReadOnlySpan<char> literal, int index, char c) => throw null;
            public static object Evaluate(this ServiceStack.Script.JsToken token) => throw null;
            public static bool Evaluate(this ServiceStack.Script.JsToken token, ServiceStack.Script.ScriptScopeContext scope, out object result, out System.Threading.Tasks.Task<object> asyncResult) => throw null;
            public static System.Threading.Tasks.Task<object> EvaluateAsync(this ServiceStack.Script.JsToken token, ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public static bool EvaluateToBool(this ServiceStack.Script.JsToken token, ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public static bool EvaluateToBool(this ServiceStack.Script.JsToken token, ServiceStack.Script.ScriptScopeContext scope, out bool? result, out System.Threading.Tasks.Task<bool> asyncResult) => throw null;
            public static System.Threading.Tasks.Task<bool> EvaluateToBoolAsync(this ServiceStack.Script.JsToken token, ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public static bool FirstCharEquals(this System.ReadOnlySpan<char> literal, char c) => throw null;
            public static bool FirstCharEquals(this string literal, char c) => throw null;
            public static int GetBinaryPrecedence(string token) => throw null;
            public static ServiceStack.Script.JsUnaryOperator GetUnaryOperator(this char c) => throw null;
            public static int IndexOfQuotedString(this System.ReadOnlySpan<char> literal, char quoteChar, out bool hasEscapeChars) => throw null;
            public static bool IsEnd(this char c) => throw null;
            public static bool IsExpressionTerminatorChar(this char c) => throw null;
            public static bool IsNumericChar(this char c) => throw null;
            public static bool IsOperatorChar(this char c) => throw null;
            public static bool IsValidVarNameChar(this char c) => throw null;
            public static readonly byte[] NewLineUtf8;
            public static readonly System.Collections.Generic.Dictionary<string, int> OperatorPrecedence;
            public static System.ReadOnlySpan<char> ParseArgumentsList(this System.ReadOnlySpan<char> literal, out System.Collections.Generic.List<ServiceStack.Script.JsIdentifier> args) => throw null;
            public static System.ReadOnlySpan<char> ParseJsToken(this System.ReadOnlySpan<char> literal, out ServiceStack.Script.JsToken token) => throw null;
            public static System.ReadOnlySpan<char> ParseJsToken(this System.ReadOnlySpan<char> literal, out ServiceStack.Script.JsToken token, bool filterExpression) => throw null;
            public static System.ReadOnlySpan<char> ParseVarName(this System.ReadOnlySpan<char> literal, out System.ReadOnlySpan<char> varName) => throw null;
            public static System.ReadOnlyMemory<char> ParseVarName(this System.ReadOnlyMemory<char> literal, out System.ReadOnlyMemory<char> varName) => throw null;
            public static bool SafeCharEquals(this System.ReadOnlySpan<char> literal, int index, char c) => throw null;
            public static char SafeGetChar(this System.ReadOnlySpan<char> literal, int index) => throw null;
            public static char SafeGetChar(this System.ReadOnlyMemory<char> literal, int index) => throw null;
            public static System.Collections.Generic.Dictionary<string, object> ToJsAst(this ServiceStack.Script.JsToken token) => throw null;
            public static string ToJsAstString(this ServiceStack.Script.JsToken token) => throw null;
            public static string ToJsAstType(this System.Type type) => throw null;
        }
        public class JsUnaryExpression : ServiceStack.Script.JsExpression
        {
            public ServiceStack.Script.JsToken Argument { get => throw null; }
            public JsUnaryExpression(ServiceStack.Script.JsUnaryOperator @operator, ServiceStack.Script.JsToken argument) => throw null;
            protected bool Equals(ServiceStack.Script.JsUnaryExpression other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override object Evaluate(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public override int GetHashCode() => throw null;
            public ServiceStack.Script.JsUnaryOperator Operator { get => throw null; }
            public override System.Collections.Generic.Dictionary<string, object> ToJsAst() => throw null;
            public override string ToRawString() => throw null;
        }
        public abstract class JsUnaryOperator : ServiceStack.Script.JsOperator
        {
            protected JsUnaryOperator() => throw null;
            public abstract object Evaluate(object target);
        }
        public class JsVariableDeclaration : ServiceStack.Script.JsExpression
        {
            public JsVariableDeclaration(ServiceStack.Script.JsVariableDeclarationKind kind, params ServiceStack.Script.JsDeclaration[] declarations) => throw null;
            public ServiceStack.Script.JsDeclaration[] Declarations { get => throw null; }
            protected bool Equals(ServiceStack.Script.JsVariableDeclaration other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override object Evaluate(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public override int GetHashCode() => throw null;
            public ServiceStack.Script.JsVariableDeclarationKind Kind { get => throw null; }
            public override System.Collections.Generic.Dictionary<string, object> ToJsAst() => throw null;
            public override string ToRawString() => throw null;
        }
        public enum JsVariableDeclarationKind
        {
            Var = 0,
            Let = 1,
            Const = 2,
        }
        public class KeyValuesScriptBlock : ServiceStack.Script.ScriptBlock
        {
            public override ServiceStack.Script.ScriptLanguage Body { get => throw null; }
            public KeyValuesScriptBlock() => throw null;
            public override string Name { get => throw null; }
            public override System.Threading.Tasks.Task WriteAsync(ServiceStack.Script.ScriptScopeContext scope, ServiceStack.Script.PageBlockFragment block, System.Threading.CancellationToken ct) => throw null;
        }
        public static class Lisp
        {
            public static bool AllowLoadingRemoteScripts { get => throw null; set { } }
            public static readonly ServiceStack.Script.Lisp.Sym BOOL_FALSE;
            public static readonly ServiceStack.Script.Lisp.Sym BOOL_TRUE;
            public sealed class BuiltInFunc : ServiceStack.Script.Lisp.LispFunc
            {
                public ServiceStack.Script.Lisp.BuiltInFuncBody Body { get => throw null; }
                public BuiltInFunc(string name, int carity, ServiceStack.Script.Lisp.BuiltInFuncBody body) : base(default(int)) => throw null;
                public object EvalWith(ServiceStack.Script.Lisp.Interpreter interp, ServiceStack.Script.Lisp.Cell arg, ServiceStack.Script.Lisp.Cell interpEnv) => throw null;
                public string Name { get => throw null; }
                public override string ToString() => throw null;
            }
            public delegate object BuiltInFuncBody(ServiceStack.Script.Lisp.Interpreter interp, object[] frame);
            public sealed class Cell : System.Collections.IEnumerable
            {
                public object Car;
                public object Cdr;
                public Cell(object car, object cdr) => throw null;
                public System.Collections.IEnumerator GetEnumerator() => throw null;
                public int Length { get => throw null; }
                public override string ToString() => throw null;
                public void Walk(System.Action<ServiceStack.Script.Lisp.Cell> fn) => throw null;
            }
            public static ServiceStack.Script.Lisp.Interpreter CreateInterpreter() => throw null;
            public const string Extensions = default;
            public static void Import(string lisp) => throw null;
            public static void Import(System.ReadOnlyMemory<char> lisp) => throw null;
            public static string IndexGistId { get => throw null; set { } }
            public static void Init() => throw null;
            public static string InitScript;
            public class Interpreter
            {
                public ServiceStack.Script.ScriptScopeContext AssertScope() => throw null;
                public System.IO.TextWriter COut { get => throw null; set { } }
                public Interpreter() => throw null;
                public Interpreter(ServiceStack.Script.Lisp.Interpreter globalInterp) => throw null;
                public void Def(string name, int carity, ServiceStack.Script.Lisp.BuiltInFuncBody body) => throw null;
                public void Def(string name, int carity, System.Func<object[], object> body) => throw null;
                public object Eval(System.Collections.Generic.IEnumerable<object> sExpressions) => throw null;
                public object Eval(System.Collections.Generic.IEnumerable<object> sExpressions, ServiceStack.Script.Lisp.Cell env) => throw null;
                public object Eval(object x) => throw null;
                public object Eval(object x, ServiceStack.Script.Lisp.Cell env) => throw null;
                public static object[] EvalArgs(ServiceStack.Script.Lisp.Cell arg, ServiceStack.Script.Lisp.Interpreter interp, ServiceStack.Script.Lisp.Cell env = default(ServiceStack.Script.Lisp.Cell)) => throw null;
                public static System.Collections.Generic.Dictionary<string, object> EvalMapArgs(ServiceStack.Script.Lisp.Cell arg, ServiceStack.Script.Lisp.Interpreter interp, ServiceStack.Script.Lisp.Cell env = default(ServiceStack.Script.Lisp.Cell)) => throw null;
                public int Evaluations { get => throw null; set { } }
                public object GetSymbolValue(string name) => throw null;
                public void InitGlobals() => throw null;
                public string ReplEval(ServiceStack.Script.ScriptContext context, System.IO.Stream outputStream, string lisp, System.Collections.Generic.Dictionary<string, object> args = default(System.Collections.Generic.Dictionary<string, object>)) => throw null;
                public ServiceStack.Script.ScriptScopeContext? Scope { get => throw null; set { } }
                public void SetSymbolValue(string name, object value) => throw null;
                public static int TotalEvaluations { get => throw null; }
            }
            public const string LispCore = default;
            public abstract class LispFunc
            {
                public int Carity { get => throw null; }
                protected LispFunc(int carity) => throw null;
                public void EvalFrame(object[] frame, ServiceStack.Script.Lisp.Interpreter interp, ServiceStack.Script.Lisp.Cell env) => throw null;
                public object[] MakeFrame(ServiceStack.Script.Lisp.Cell arg) => throw null;
            }
            public static System.Collections.Generic.List<object> Parse(string lisp) => throw null;
            public static System.Collections.Generic.List<object> Parse(System.ReadOnlyMemory<char> lisp) => throw null;
            public const string Prelude = default;
            public static object QqExpand(object x) => throw null;
            public static object QqQuote(object x) => throw null;
            public class Reader
            {
                public Reader(System.ReadOnlyMemory<char> source) => throw null;
                public static object EOF;
                public object Read() => throw null;
            }
            public static void Reset() => throw null;
            public static void RunRepl(ServiceStack.Script.ScriptContext context) => throw null;
            public static void Set(string symbolName, object value) => throw null;
            public static string Str(object x, bool quoteString = default(bool)) => throw null;
            public class Sym
            {
                public Sym(string name) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsInterned { get => throw null; }
                public string Name { get => throw null; }
                protected static ServiceStack.Script.Lisp.Sym New(string name, System.Func<string, ServiceStack.Script.Lisp.Sym> make) => throw null;
                public static ServiceStack.Script.Lisp.Sym New(string name) => throw null;
                protected static readonly System.Collections.Generic.Dictionary<string, ServiceStack.Script.Lisp.Sym> Table;
                public override string ToString() => throw null;
            }
            public static ServiceStack.Script.Lisp.Cell ToCons(System.Collections.IEnumerable seq) => throw null;
            public static readonly ServiceStack.Script.Lisp.Sym TRUE;
        }
        public class LispEvalException : System.Exception
        {
            public LispEvalException(string msg, object x, bool quoteString = default(bool)) => throw null;
            public override string ToString() => throw null;
            public System.Collections.Generic.List<string> Trace { get => throw null; }
        }
        public class LispScriptMethods : ServiceStack.Script.ScriptMethods
        {
            public LispScriptMethods() => throw null;
            public System.Collections.Generic.List<ServiceStack.GistLink> gistindex(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public System.Collections.Generic.List<string> symbols(ServiceStack.Script.ScriptScopeContext scope) => throw null;
        }
        public class LispStatements : ServiceStack.Script.JsStatement
        {
            public LispStatements(object[] sExpressions) => throw null;
            protected bool Equals(ServiceStack.Script.LispStatements other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public object[] SExpressions { get => throw null; }
        }
        public class MarkdownTable
        {
            public string Caption { get => throw null; set { } }
            public MarkdownTable() => throw null;
            public System.Collections.Generic.List<string> Headers { get => throw null; }
            public System.Collections.Generic.List<System.Type> HeaderTypes { get => throw null; set { } }
            public bool IncludeHeaders { get => throw null; set { } }
            public bool IncludeRowNumbers { get => throw null; set { } }
            public string Render() => throw null;
            public System.Collections.Generic.List<System.Collections.Generic.List<string>> Rows { get => throw null; }
        }
        public class NoopScriptBlock : ServiceStack.Script.ScriptBlock
        {
            public override ServiceStack.Script.ScriptLanguage Body { get => throw null; }
            public NoopScriptBlock() => throw null;
            public override string Name { get => throw null; }
            public override System.Threading.Tasks.Task WriteAsync(ServiceStack.Script.ScriptScopeContext scope, ServiceStack.Script.PageBlockFragment block, System.Threading.CancellationToken token) => throw null;
        }
        public class PageBlockFragment : ServiceStack.Script.PageFragment
        {
            public System.ReadOnlyMemory<char> Argument { get => throw null; }
            public string ArgumentString { get => throw null; }
            public ServiceStack.Script.PageFragment[] Body { get => throw null; }
            public PageBlockFragment(string originalText, string name, string argument, ServiceStack.Script.JsStatement body, System.Collections.Generic.IEnumerable<ServiceStack.Script.PageElseBlock> elseStatements = default(System.Collections.Generic.IEnumerable<ServiceStack.Script.PageElseBlock>)) => throw null;
            public PageBlockFragment(string originalText, string name, string argument, ServiceStack.Script.JsBlockStatement body, System.Collections.Generic.IEnumerable<ServiceStack.Script.PageElseBlock> elseStatements = default(System.Collections.Generic.IEnumerable<ServiceStack.Script.PageElseBlock>)) => throw null;
            public PageBlockFragment(string originalText, string name, string argument, System.Collections.Generic.List<ServiceStack.Script.PageFragment> body, System.Collections.Generic.List<ServiceStack.Script.PageElseBlock> elseStatements = default(System.Collections.Generic.List<ServiceStack.Script.PageElseBlock>)) => throw null;
            public PageBlockFragment(string name, System.ReadOnlyMemory<char> argument, System.Collections.Generic.List<ServiceStack.Script.PageFragment> body, System.Collections.Generic.List<ServiceStack.Script.PageElseBlock> elseStatements = default(System.Collections.Generic.List<ServiceStack.Script.PageElseBlock>)) => throw null;
            public PageBlockFragment(System.ReadOnlyMemory<char> originalText, string name, System.ReadOnlyMemory<char> argument, System.Collections.Generic.IEnumerable<ServiceStack.Script.PageFragment> body, System.Collections.Generic.IEnumerable<ServiceStack.Script.PageElseBlock> elseStatements = default(System.Collections.Generic.IEnumerable<ServiceStack.Script.PageElseBlock>)) => throw null;
            public ServiceStack.Script.PageElseBlock[] ElseBlocks { get => throw null; }
            protected bool Equals(ServiceStack.Script.PageBlockFragment other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public string Name { get => throw null; }
            public System.ReadOnlyMemory<char> OriginalText { get => throw null; }
        }
        public class PageElseBlock : ServiceStack.Script.PageFragment
        {
            public System.ReadOnlyMemory<char> Argument { get => throw null; }
            public ServiceStack.Script.PageFragment[] Body { get => throw null; }
            public PageElseBlock(string argument, System.Collections.Generic.List<ServiceStack.Script.PageFragment> body) => throw null;
            public PageElseBlock(string argument, ServiceStack.Script.JsStatement statement) => throw null;
            public PageElseBlock(string argument, ServiceStack.Script.JsBlockStatement block) => throw null;
            public PageElseBlock(System.ReadOnlyMemory<char> argument, System.Collections.Generic.IEnumerable<ServiceStack.Script.PageFragment> body) => throw null;
            public PageElseBlock(System.ReadOnlyMemory<char> argument, ServiceStack.Script.PageFragment[] body) => throw null;
            protected bool Equals(ServiceStack.Script.PageElseBlock other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
        }
        public class PageFormat
        {
            public string ArgsPrefix { get => throw null; set { } }
            public string ArgsSuffix { get => throw null; set { } }
            public string ContentType { get => throw null; set { } }
            public PageFormat() => throw null;
            public string DefaultEncodeValue(object value) => throw null;
            public virtual object DefaultExpressionException(ServiceStack.Script.PageResult result, System.Exception ex) => throw null;
            public ServiceStack.Script.SharpPage DefaultResolveLayout(ServiceStack.Script.SharpPage page) => throw null;
            public virtual System.Threading.Tasks.Task DefaultViewException(ServiceStack.Script.PageResult pageResult, ServiceStack.Web.IRequest req, System.Exception ex) => throw null;
            public System.Func<object, string> EncodeValue { get => throw null; set { } }
            public string Extension { get => throw null; set { } }
            public System.Func<ServiceStack.Script.PageResult, System.Exception, object> OnExpressionException { get => throw null; set { } }
            public System.Func<ServiceStack.Script.PageResult, ServiceStack.Web.IRequest, System.Exception, System.Threading.Tasks.Task> OnViewException { get => throw null; set { } }
            public System.Func<ServiceStack.Script.SharpPage, ServiceStack.Script.SharpPage> ResolveLayout { get => throw null; set { } }
        }
        public abstract class PageFragment
        {
            protected PageFragment() => throw null;
        }
        public class PageJsBlockStatementFragment : ServiceStack.Script.PageFragment
        {
            public ServiceStack.Script.JsBlockStatement Block { get => throw null; }
            public PageJsBlockStatementFragment(ServiceStack.Script.JsBlockStatement statement) => throw null;
            protected bool Equals(ServiceStack.Script.PageJsBlockStatementFragment other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public bool Quiet { get => throw null; set { } }
        }
        public class PageLispStatementFragment : ServiceStack.Script.PageFragment
        {
            public PageLispStatementFragment(ServiceStack.Script.LispStatements statements) => throw null;
            protected bool Equals(ServiceStack.Script.PageLispStatementFragment other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public ServiceStack.Script.LispStatements LispStatements { get => throw null; }
            public bool Quiet { get => throw null; set { } }
        }
        public class PageResult : System.IDisposable, ServiceStack.Web.IHasOptions, ServiceStack.Script.IPageResult, ServiceStack.Web.IStreamWriterAsync
        {
            public System.Collections.Generic.Dictionary<string, object> Args { get => throw null; set { } }
            public void AssertNextEvaluation() => throw null;
            public void AssertNextPartial() => throw null;
            public ServiceStack.Script.PageResult AssignArgs(System.Collections.Generic.Dictionary<string, object> args) => throw null;
            public string AssignExceptionsTo { get => throw null; set { } }
            public string CatchExceptionsIn { get => throw null; set { } }
            public ServiceStack.Script.PageResult Clone(ServiceStack.Script.SharpPage page) => throw null;
            public ServiceStack.Script.SharpCodePage CodePage { get => throw null; }
            public string ContentType { get => throw null; set { } }
            public ServiceStack.Script.ScriptContext Context { get => throw null; }
            public ServiceStack.Script.ScriptScopeContext CreateScope(System.IO.Stream outputStream = default(System.IO.Stream)) => throw null;
            public PageResult(ServiceStack.Script.SharpPage page) => throw null;
            public PageResult(ServiceStack.Script.SharpCodePage page) => throw null;
            public bool DisableBuffering { get => throw null; set { } }
            public void Dispose() => throw null;
            public object EvaluateIfToken(object value, ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public long Evaluations { get => throw null; }
            public System.Collections.Generic.HashSet<string> ExcludeFiltersNamed { get => throw null; }
            public ServiceStack.Script.PageResult Execute() => throw null;
            public System.Collections.Generic.Dictionary<string, System.Func<System.IO.Stream, System.Threading.Tasks.Task<System.IO.Stream>>> FilterTransformers { get => throw null; set { } }
            public ServiceStack.Script.PageFormat Format { get => throw null; }
            public ServiceStack.Script.ScriptBlock GetBlock(string name) => throw null;
            public bool HaltExecution { get => throw null; set { } }
            public System.Threading.Tasks.Task<ServiceStack.Script.PageResult> Init() => throw null;
            public System.Exception LastFilterError { get => throw null; set { } }
            public string[] LastFilterStackTrace { get => throw null; set { } }
            public string Layout { get => throw null; set { } }
            public ServiceStack.Script.SharpPage LayoutPage { get => throw null; set { } }
            public object Model { get => throw null; set { } }
            public bool NoLayout { get => throw null; set { } }
            public System.Collections.Generic.IDictionary<string, string> Options { get => throw null; set { } }
            public System.Collections.Generic.List<System.Func<System.IO.Stream, System.Threading.Tasks.Task<System.IO.Stream>>> OutputTransformers { get => throw null; set { } }
            public ServiceStack.Script.SharpPage Page { get => throw null; }
            public System.Collections.Generic.List<System.Func<System.IO.Stream, System.Threading.Tasks.Task<System.IO.Stream>>> PageTransformers { get => throw null; set { } }
            public System.ReadOnlySpan<char> ParseJsExpression(ServiceStack.Script.ScriptScopeContext scope, System.ReadOnlySpan<char> literal, out ServiceStack.Script.JsToken token) => throw null;
            public System.Collections.Generic.Dictionary<string, ServiceStack.Script.SharpPage> Partials { get => throw null; set { } }
            public int PartialStackDepth { get => throw null; }
            public void ResetIterations() => throw null;
            public string Result { get => throw null; }
            public string ResultOutput { get => throw null; }
            public bool RethrowExceptions { get => throw null; set { } }
            public ServiceStack.Script.ReturnValue ReturnValue { get => throw null; set { } }
            public System.Collections.Generic.List<ServiceStack.Script.ScriptBlock> ScriptBlocks { get => throw null; set { } }
            public System.Collections.Generic.List<ServiceStack.Script.ScriptMethods> ScriptMethods { get => throw null; set { } }
            public bool ShouldSkipFilterExecution(ServiceStack.Script.PageVariableFragment var) => throw null;
            public bool ShouldSkipFilterExecution(ServiceStack.Script.PageFragment fragment) => throw null;
            public bool ShouldSkipFilterExecution(ServiceStack.Script.JsStatement statement) => throw null;
            public bool? SkipExecutingFiltersIfError { get => throw null; set { } }
            public bool SkipFilterExecution { get => throw null; set { } }
            public int StackDepth { get => throw null; }
            public System.Collections.Generic.List<ServiceStack.Script.ScriptBlock> TemplateBlocks { get => throw null; }
            public System.Collections.Generic.List<ServiceStack.Script.ScriptMethods> TemplateFilters { get => throw null; }
            public ServiceStack.Script.ScriptBlock TryGetBlock(string name) => throw null;
            public string VirtualPath { get => throw null; }
            public System.Threading.Tasks.Task WriteCodePageAsync(ServiceStack.Script.SharpCodePage page, ServiceStack.Script.ScriptScopeContext scope, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public System.Threading.Tasks.Task WritePageAsync(ServiceStack.Script.SharpPage page, ServiceStack.Script.SharpCodePage codePage, ServiceStack.Script.ScriptScopeContext scope, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public System.Threading.Tasks.Task WritePageAsync(ServiceStack.Script.SharpPage page, ServiceStack.Script.ScriptScopeContext scope, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public System.Threading.Tasks.Task WritePageFragmentAsync(ServiceStack.Script.ScriptScopeContext scope, ServiceStack.Script.PageFragment fragment, System.Threading.CancellationToken token) => throw null;
            public System.Threading.Tasks.Task WriteStatementsAsync(ServiceStack.Script.ScriptScopeContext scope, System.Collections.Generic.IEnumerable<ServiceStack.Script.JsStatement> blockStatements, string callTrace, System.Threading.CancellationToken token) => throw null;
            public System.Threading.Tasks.Task WriteStatementsAsync(ServiceStack.Script.ScriptScopeContext scope, System.Collections.Generic.IEnumerable<ServiceStack.Script.JsStatement> blockStatements, System.Threading.CancellationToken token) => throw null;
            public System.Threading.Tasks.Task WriteToAsync(System.IO.Stream responseStream, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public System.Threading.Tasks.Task WriteVarAsync(ServiceStack.Script.ScriptScopeContext scope, ServiceStack.Script.PageVariableFragment var, System.Threading.CancellationToken token) => throw null;
        }
        public class PageStringFragment : ServiceStack.Script.PageFragment
        {
            public PageStringFragment(string value) => throw null;
            public PageStringFragment(System.ReadOnlyMemory<char> value) => throw null;
            protected bool Equals(ServiceStack.Script.PageStringFragment other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public System.ReadOnlyMemory<char> Value { get => throw null; set { } }
            public string ValueString { get => throw null; }
            public System.ReadOnlyMemory<byte> ValueUtf8 { get => throw null; }
        }
        public class PageVariableFragment : ServiceStack.Script.PageFragment
        {
            public string Binding { get => throw null; }
            public PageVariableFragment(System.ReadOnlyMemory<char> originalText, ServiceStack.Script.JsToken expr, System.Collections.Generic.List<ServiceStack.Script.JsCallExpression> filterCommands) => throw null;
            protected bool Equals(ServiceStack.Script.PageVariableFragment other) => throw null;
            public override bool Equals(object obj) => throw null;
            public object Evaluate(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public ServiceStack.Script.JsToken Expression { get => throw null; }
            public ServiceStack.Script.JsCallExpression[] FilterExpressions { get => throw null; }
            public override int GetHashCode() => throw null;
            public ServiceStack.Script.JsCallExpression InitialExpression { get => throw null; }
            public object InitialValue { get => throw null; }
            public System.ReadOnlyMemory<char> OriginalText { get => throw null; set { } }
            public System.ReadOnlyMemory<byte> OriginalTextUtf8 { get => throw null; }
        }
        public delegate object ParseRealNumber(System.ReadOnlySpan<char> numLiteral);
        public class PartialScriptBlock : ServiceStack.Script.ScriptBlock
        {
            public override ServiceStack.Script.ScriptLanguage Body { get => throw null; }
            public PartialScriptBlock() => throw null;
            public override string Name { get => throw null; }
            public override System.Threading.Tasks.Task WriteAsync(ServiceStack.Script.ScriptScopeContext scope, ServiceStack.Script.PageBlockFragment block, System.Threading.CancellationToken token) => throw null;
        }
        public class ProtectedScriptBlocks : ServiceStack.Script.IScriptPlugin
        {
            public ProtectedScriptBlocks() => throw null;
            public void Register(ServiceStack.Script.ScriptContext context) => throw null;
        }
        public class ProtectedScripts : ServiceStack.Script.ScriptMethods
        {
            public System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> allFiles() => throw null;
            public System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> allFiles(ServiceStack.IO.IVirtualPathProvider vfs) => throw null;
            public System.Reflection.MemberInfo[] allMemberInfos(object o) => throw null;
            public ServiceStack.Script.ScriptMethodInfo[] allMethodTypes(object o) => throw null;
            public System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualDirectory> allRootDirectories() => throw null;
            public System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualDirectory> allRootDirectories(ServiceStack.IO.IVirtualPathProvider vfs) => throw null;
            public System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> allRootFiles() => throw null;
            public System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> allRootFiles(ServiceStack.IO.IVirtualPathProvider vfs) => throw null;
            public ServiceStack.Script.IgnoreResult AppendAllLines(string path, string[] lines) => throw null;
            public ServiceStack.Script.IgnoreResult AppendAllLines(ServiceStack.Script.FileScripts fs, string path, string[] lines) => throw null;
            public ServiceStack.Script.IgnoreResult AppendAllText(string path, string text) => throw null;
            public ServiceStack.Script.IgnoreResult AppendAllText(ServiceStack.Script.FileScripts fs, string path, string text) => throw null;
            public string appendToFile(string virtualPath, object contents) => throw null;
            public string appendToFile(ServiceStack.IO.IVirtualPathProvider vfs, string virtualPath, object contents) => throw null;
            public System.Type assertTypeOf(string name) => throw null;
            public byte[] bytesContent(ServiceStack.IO.IVirtualFile file) => throw null;
            public System.Delegate C(string qualifiedMethodName) => throw null;
            public object cacheClear(ServiceStack.Script.ScriptScopeContext scope, object cacheNames) => throw null;
            public object call(object instance, string name) => throw null;
            public object call(object instance, string name, System.Collections.Generic.List<object> args) => throw null;
            public string cat(ServiceStack.Script.ScriptScopeContext scope, string target) => throw null;
            public string combinePath(string basePath, string relativePath) => throw null;
            public string combinePath(ServiceStack.IO.IVirtualPathProvider vfs, string basePath, string relativePath) => throw null;
            public ServiceStack.ObjectActivator Constructor(string qualifiedConstructorName) => throw null;
            public ServiceStack.Script.IgnoreResult Copy(string from, string to) => throw null;
            public ServiceStack.Script.IgnoreResult Copy(ServiceStack.Script.IOScript os, string from, string to) => throw null;
            public string cp(ServiceStack.Script.ScriptScopeContext scope, string from, string to) => throw null;
            public ServiceStack.Script.IgnoreResult Create(string from, string to) => throw null;
            public ServiceStack.Script.IgnoreResult Create(ServiceStack.Script.FileScripts fs, string from, string to) => throw null;
            public static string CreateCacheKey(string url, System.Collections.Generic.Dictionary<string, object> options = default(System.Collections.Generic.Dictionary<string, object>)) => throw null;
            public ServiceStack.Script.IgnoreResult CreateDirectory(string path) => throw null;
            public ServiceStack.Script.IgnoreResult CreateDirectory(ServiceStack.Script.DirectoryScripts ds, string path) => throw null;
            public object createInstance(System.Type type) => throw null;
            public object createInstance(System.Type type, System.Collections.Generic.List<object> constructorArgs) => throw null;
            public ProtectedScripts() => throw null;
            public ServiceStack.Script.IgnoreResult Decrypt(string path) => throw null;
            public ServiceStack.Script.IgnoreResult Decrypt(ServiceStack.Script.FileScripts fs, string path) => throw null;
            public object @default(string typeName) => throw null;
            public ServiceStack.Script.IgnoreResult Delete(string path) => throw null;
            public ServiceStack.Script.IgnoreResult Delete(ServiceStack.Script.IOScript os, string path) => throw null;
            public string deleteDirectory(string virtualPath) => throw null;
            public string deleteDirectory(ServiceStack.IO.IVirtualPathProvider vfs, string virtualPath) => throw null;
            public string deleteFile(string virtualPath) => throw null;
            public string deleteFile(ServiceStack.IO.IVirtualPathProvider vfs, string virtualPath) => throw null;
            public ServiceStack.IO.IVirtualDirectory dir(string virtualPath) => throw null;
            public ServiceStack.IO.IVirtualDirectory dir(ServiceStack.IO.IVirtualPathProvider vfs, string virtualPath) => throw null;
            public string dirDelete(string virtualPath) => throw null;
            public System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualDirectory> dirDirectories(string dirPath) => throw null;
            public System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualDirectory> dirDirectories(ServiceStack.IO.IVirtualPathProvider vfs, string dirPath) => throw null;
            public ServiceStack.IO.IVirtualDirectory dirDirectory(string dirPath, string dirName) => throw null;
            public ServiceStack.IO.IVirtualDirectory dirDirectory(ServiceStack.IO.IVirtualPathProvider vfs, string dirPath, string dirName) => throw null;
            public ServiceStack.Script.DirectoryScripts Directory() => throw null;
            public bool dirExists(string virtualPath) => throw null;
            public bool dirExists(ServiceStack.IO.IVirtualPathProvider vfs, string virtualPath) => throw null;
            public ServiceStack.IO.IVirtualFile dirFile(string dirPath, string fileName) => throw null;
            public ServiceStack.IO.IVirtualFile dirFile(ServiceStack.IO.IVirtualPathProvider vfs, string dirPath, string fileName) => throw null;
            public System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> dirFiles(string dirPath) => throw null;
            public System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> dirFiles(ServiceStack.IO.IVirtualPathProvider vfs, string dirPath) => throw null;
            public System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> dirFilesFind(string dirPath, string globPattern) => throw null;
            public System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> dirFindFiles(ServiceStack.IO.IVirtualDirectory dir, string globPattern) => throw null;
            public System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> dirFindFiles(ServiceStack.IO.IVirtualDirectory dir, string globPattern, int maxDepth) => throw null;
            public ServiceStack.Script.IgnoreResult Encrypt(string path) => throw null;
            public ServiceStack.Script.IgnoreResult Encrypt(ServiceStack.Script.FileScripts fs, string path) => throw null;
            public string exePath(string exeName) => throw null;
            public bool Exists(string path) => throw null;
            public bool Exists(ServiceStack.Script.IOScript os, string path) => throw null;
            public ServiceStack.Script.StopExecution exit(int exitCode) => throw null;
            public System.Delegate F(string qualifiedMethodName) => throw null;
            public System.Delegate F(string qualifiedMethodName, System.Collections.Generic.List<object> args) => throw null;
            public ServiceStack.IO.IVirtualFile file(string virtualPath) => throw null;
            public ServiceStack.IO.IVirtualFile file(ServiceStack.IO.IVirtualPathProvider vfs, string virtualPath) => throw null;
            public ServiceStack.Script.FileScripts File() => throw null;
            public string fileAppend(string virtualPath, object contents) => throw null;
            public byte[] fileBytesContent(string virtualPath) => throw null;
            public byte[] fileBytesContent(ServiceStack.IO.IVirtualPathProvider vfs, string virtualPath) => throw null;
            public object fileContents(ServiceStack.IO.IVirtualPathProvider vfs, string virtualPath) => throw null;
            public object fileContents(object file) => throw null;
            public System.Threading.Tasks.Task fileContentsWithCache(ServiceStack.Script.ScriptScopeContext scope, string virtualPath) => throw null;
            public System.Threading.Tasks.Task fileContentsWithCache(ServiceStack.Script.ScriptScopeContext scope, string virtualPath, object options) => throw null;
            public string fileContentType(ServiceStack.IO.IVirtualFile file) => throw null;
            public string fileDelete(string virtualPath) => throw null;
            public bool fileExists(string virtualPath) => throw null;
            public bool fileExists(ServiceStack.IO.IVirtualPathProvider vfs, string virtualPath) => throw null;
            public string fileHash(string virtualPath) => throw null;
            public string fileHash(ServiceStack.IO.IVirtualPathProvider vfs, string virtualPath) => throw null;
            public string fileHash(ServiceStack.IO.IVirtualFile file) => throw null;
            public bool fileIsBinary(ServiceStack.IO.IVirtualFile file) => throw null;
            public string fileReadAll(string virtualPath) => throw null;
            public byte[] fileReadAllBytes(string virtualPath) => throw null;
            public System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> filesFind(string globPattern) => throw null;
            public string fileTextContents(string virtualPath) => throw null;
            public string fileTextContents(ServiceStack.IO.IVirtualPathProvider vfs, string virtualPath) => throw null;
            public string fileWrite(string virtualPath, object contents) => throw null;
            public System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> findFiles(string globPattern) => throw null;
            public System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> findFiles(ServiceStack.IO.IVirtualPathProvider vfs, string globPattern) => throw null;
            public System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> findFiles(ServiceStack.IO.IVirtualPathProvider vfs, string globPattern, int maxDepth) => throw null;
            public System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> findFilesInDirectory(string dirPath, string globPattern) => throw null;
            public System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> findFilesInDirectory(ServiceStack.IO.IVirtualPathProvider vfs, string dirPath, string globPattern) => throw null;
            public System.Delegate Function(string qualifiedMethodName) => throw null;
            public System.Delegate Function(string qualifiedMethodName, System.Collections.Generic.List<object> args) => throw null;
            public string GetCurrentDirectory() => throw null;
            public string GetCurrentDirectory(ServiceStack.Script.DirectoryScripts ds) => throw null;
            public string[] GetDirectories(string path) => throw null;
            public string[] GetDirectories(ServiceStack.Script.DirectoryScripts ds, string path) => throw null;
            public string GetDirectoryRoot(string path) => throw null;
            public string GetDirectoryRoot(ServiceStack.Script.DirectoryScripts ds, string path) => throw null;
            public string[] GetFiles(string path) => throw null;
            public string[] GetFiles(ServiceStack.Script.DirectoryScripts ds, string path) => throw null;
            public string[] GetLogicalDrives() => throw null;
            public string[] GetLogicalDrives(ServiceStack.Script.DirectoryScripts ds) => throw null;
            public System.Type getType(object instance) => throw null;
            public System.Threading.Tasks.Task ifDebugIncludeScript(ServiceStack.Script.ScriptScopeContext scope, string virtualPath) => throw null;
            public System.Threading.Tasks.Task includeFile(ServiceStack.Script.ScriptScopeContext scope, string virtualPath) => throw null;
            public System.Threading.Tasks.Task includeFileWithCache(ServiceStack.Script.ScriptScopeContext scope, string virtualPath) => throw null;
            public System.Threading.Tasks.Task includeFileWithCache(ServiceStack.Script.ScriptScopeContext scope, string virtualPath, object options) => throw null;
            public System.Threading.Tasks.Task includeUrl(ServiceStack.Script.ScriptScopeContext scope, string url) => throw null;
            public System.Threading.Tasks.Task includeUrl(ServiceStack.Script.ScriptScopeContext scope, string url, object options) => throw null;
            public System.Threading.Tasks.Task includeUrlWithCache(ServiceStack.Script.ScriptScopeContext scope, string url) => throw null;
            public System.Threading.Tasks.Task includeUrlWithCache(ServiceStack.Script.ScriptScopeContext scope, string url, object options) => throw null;
            public ServiceStack.Script.IgnoreResult inspectVars(object vars) => throw null;
            public static readonly ServiceStack.Script.ProtectedScripts Instance;
            public object invalidateAllCaches(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public System.Collections.Generic.List<string> methods(object o) => throw null;
            public ServiceStack.Script.ScriptMethodInfo[] methodTypes(object o) => throw null;
            public string mkdir(ServiceStack.Script.ScriptScopeContext scope, string target) => throw null;
            public ServiceStack.Script.IgnoreResult Move(string from, string to) => throw null;
            public ServiceStack.Script.IgnoreResult Move(ServiceStack.Script.IOScript os, string from, string to) => throw null;
            public string mv(ServiceStack.Script.ScriptScopeContext scope, string from, string to) => throw null;
            public object @new(string typeName) => throw null;
            public object @new(string typeName, System.Collections.Generic.List<object> constructorArgs) => throw null;
            public string osPaths(string path) => throw null;
            public string proc(ServiceStack.Script.ScriptScopeContext scope, string fileName) => throw null;
            public string proc(ServiceStack.Script.ScriptScopeContext scope, string fileName, System.Collections.Generic.Dictionary<string, object> options) => throw null;
            public byte[] ReadAllBytes(string path) => throw null;
            public byte[] ReadAllBytes(ServiceStack.Script.FileScripts fs, string path) => throw null;
            public string[] ReadAllLines(string path) => throw null;
            public string[] ReadAllLines(ServiceStack.Script.FileScripts fs, string path) => throw null;
            public string ReadAllText(string path) => throw null;
            public string ReadAllText(ServiceStack.Script.FileScripts fs, string path) => throw null;
            public ServiceStack.Script.IgnoreResult Replace(string from, string to, string backup) => throw null;
            public ServiceStack.Script.IgnoreResult Replace(ServiceStack.Script.FileScripts fs, string from, string to, string backup) => throw null;
            public object resolve(ServiceStack.Script.ScriptScopeContext scope, object type) => throw null;
            public ServiceStack.IO.IVirtualFile resolveFile(ServiceStack.Script.ScriptScopeContext scope, string virtualPath) => throw null;
            public ServiceStack.IO.IVirtualFile ResolveFile(string filterName, ServiceStack.Script.ScriptScopeContext scope, string virtualPath) => throw null;
            public ServiceStack.IO.IVirtualFile ResolveFile(ServiceStack.IO.IVirtualPathProvider virtualFiles, string fromVirtualPath, string virtualPath) => throw null;
            public string rm(ServiceStack.Script.ScriptScopeContext scope, string from, string to) => throw null;
            public string rmdir(ServiceStack.Script.ScriptScopeContext scope, string target) => throw null;
            public System.Collections.Generic.List<string> scriptMethodNames(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public System.Collections.Generic.List<ServiceStack.Script.ScriptMethodInfo> scriptMethods(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public System.Collections.Generic.List<string> scriptMethodSignatures(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public object set(object instance, System.Collections.Generic.Dictionary<string, object> args) => throw null;
            public string sh(ServiceStack.Script.ScriptScopeContext scope, string arguments) => throw null;
            public string sh(ServiceStack.Script.ScriptScopeContext scope, string arguments, System.Collections.Generic.Dictionary<string, object> options) => throw null;
            public string sha1(object target) => throw null;
            public string sha256(object target) => throw null;
            public string sha512(object target) => throw null;
            public System.Collections.Generic.List<string> staticMethods(object o) => throw null;
            public ServiceStack.Script.ScriptMethodInfo[] staticMethodTypes(object o) => throw null;
            public string textContents(ServiceStack.IO.IVirtualFile file) => throw null;
            public string touch(ServiceStack.Script.ScriptScopeContext scope, string target) => throw null;
            public static string TypeNotFoundErrorMessage(string typeName) => throw null;
            public System.Type @typeof(string typeName) => throw null;
            public System.Type typeofProgId(string name) => throw null;
            public string typeQualifiedName(System.Type type) => throw null;
            public System.ReadOnlyMemory<byte> urlBytesContents(ServiceStack.Script.ScriptScopeContext scope, string url, object options) => throw null;
            public System.Threading.Tasks.Task urlContents(ServiceStack.Script.ScriptScopeContext scope, string url) => throw null;
            public System.Threading.Tasks.Task urlContents(ServiceStack.Script.ScriptScopeContext scope, string url, object options) => throw null;
            public System.Threading.Tasks.Task urlContentsWithCache(ServiceStack.Script.ScriptScopeContext scope, string url) => throw null;
            public System.Threading.Tasks.Task urlContentsWithCache(ServiceStack.Script.ScriptScopeContext scope, string url, object options) => throw null;
            public string urlTextContents(ServiceStack.Script.ScriptScopeContext scope, string url) => throw null;
            public string urlTextContents(ServiceStack.Script.ScriptScopeContext scope, string url, object options) => throw null;
            public System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> vfsAllFiles() => throw null;
            public System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualDirectory> vfsAllRootDirectories() => throw null;
            public System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> vfsAllRootFiles() => throw null;
            public string vfsCombinePath(string basePath, string relativePath) => throw null;
            public ServiceStack.IO.FileSystemVirtualFiles vfsFileSystem(string dirPath) => throw null;
            public ServiceStack.IO.GistVirtualFiles vfsGist(string gistId) => throw null;
            public ServiceStack.IO.GistVirtualFiles vfsGist(string gistId, string accessToken) => throw null;
            public ServiceStack.IO.MemoryVirtualFiles vfsMemory() => throw null;
            public ServiceStack.Script.IgnoreResult WriteAllBytes(string path, byte[] bytes) => throw null;
            public ServiceStack.Script.IgnoreResult WriteAllBytes(ServiceStack.Script.FileScripts fs, string path, byte[] bytes) => throw null;
            public ServiceStack.Script.IgnoreResult WriteAllLines(string path, string[] lines) => throw null;
            public ServiceStack.Script.IgnoreResult WriteAllLines(ServiceStack.Script.FileScripts fs, string path, string[] lines) => throw null;
            public ServiceStack.Script.IgnoreResult WriteAllText(string path, string text) => throw null;
            public ServiceStack.Script.IgnoreResult WriteAllText(ServiceStack.Script.FileScripts fs, string path, string text) => throw null;
            public string writeFile(string virtualPath, object contents) => throw null;
            public string writeFile(ServiceStack.IO.IVirtualPathProvider vfs, string virtualPath, object contents) => throw null;
            public object writeFiles(ServiceStack.IO.IVirtualPathProvider vfs, System.Collections.Generic.Dictionary<string, object> files) => throw null;
            public object writeTextFiles(ServiceStack.IO.IVirtualPathProvider vfs, System.Collections.Generic.Dictionary<string, string> textFiles) => throw null;
            public string xcopy(ServiceStack.Script.ScriptScopeContext scope, string from, string to) => throw null;
        }
        public class RawScriptBlock : ServiceStack.Script.ScriptBlock
        {
            public override ServiceStack.Script.ScriptLanguage Body { get => throw null; }
            public RawScriptBlock() => throw null;
            public override string Name { get => throw null; }
            public override System.Threading.Tasks.Task WriteAsync(ServiceStack.Script.ScriptScopeContext scope, ServiceStack.Script.PageBlockFragment block, System.Threading.CancellationToken token) => throw null;
        }
        public class RawString : ServiceStack.IRawString
        {
            public RawString(string value) => throw null;
            public static ServiceStack.Script.RawString Empty;
            public string ToRawString() => throw null;
        }
        public class ReturnValue
        {
            public System.Collections.Generic.Dictionary<string, object> Args { get => throw null; }
            public ReturnValue(object result, System.Collections.Generic.Dictionary<string, object> args) => throw null;
            public object Result { get => throw null; }
        }
        public class ScopeVars : System.Collections.Generic.Dictionary<string, object>
        {
            public ScopeVars() => throw null;
            public ScopeVars(System.Collections.Generic.IDictionary<string, object> dictionary) => throw null;
            public ScopeVars(System.Collections.Generic.IDictionary<string, object> dictionary, System.Collections.Generic.IEqualityComparer<string> comparer) => throw null;
            public ScopeVars(System.Collections.Generic.IEqualityComparer<string> comparer) => throw null;
            public ScopeVars(int capacity) => throw null;
            public ScopeVars(int capacity, System.Collections.Generic.IEqualityComparer<string> comparer) => throw null;
        }
        public class ScriptABlock : ServiceStack.Script.ScriptHtmlBlock
        {
            public ScriptABlock() => throw null;
            public override string Suffix { get => throw null; }
            public override string Tag { get => throw null; }
        }
        public class ScriptBBlock : ServiceStack.Script.ScriptHtmlBlock
        {
            public ScriptBBlock() => throw null;
            public override string Suffix { get => throw null; }
            public override string Tag { get => throw null; }
        }
        public abstract class ScriptBlock : ServiceStack.Script.IConfigureScriptContext
        {
            protected int AssertWithinMaxQuota(int value) => throw null;
            public virtual ServiceStack.Script.ScriptLanguage Body { get => throw null; }
            protected bool CanExportScopeArgs(object element) => throw null;
            public void Configure(ServiceStack.Script.ScriptContext context) => throw null;
            public ServiceStack.Script.ScriptContext Context { get => throw null; set { } }
            protected ScriptBlock() => throw null;
            protected virtual string GetCallTrace(ServiceStack.Script.PageBlockFragment fragment) => throw null;
            protected virtual string GetElseCallTrace(ServiceStack.Script.PageElseBlock fragment) => throw null;
            public abstract string Name { get; }
            public ServiceStack.Script.ISharpPages Pages { get => throw null; set { } }
            public abstract System.Threading.Tasks.Task WriteAsync(ServiceStack.Script.ScriptScopeContext scope, ServiceStack.Script.PageBlockFragment block, System.Threading.CancellationToken token);
            protected virtual System.Threading.Tasks.Task WriteAsync(ServiceStack.Script.ScriptScopeContext scope, ServiceStack.Script.PageFragment[] body, string callTrace, System.Threading.CancellationToken cancel) => throw null;
            protected virtual System.Threading.Tasks.Task WriteAsync(ServiceStack.Script.ScriptScopeContext scope, ServiceStack.Script.JsStatement[] body, string callTrace, System.Threading.CancellationToken cancel) => throw null;
            protected virtual System.Threading.Tasks.Task WriteBodyAsync(ServiceStack.Script.ScriptScopeContext scope, ServiceStack.Script.PageBlockFragment fragment, System.Threading.CancellationToken token) => throw null;
            protected virtual System.Threading.Tasks.Task WriteElseAsync(ServiceStack.Script.ScriptScopeContext scope, ServiceStack.Script.PageElseBlock fragment, System.Threading.CancellationToken token) => throw null;
            protected System.Threading.Tasks.Task WriteElseAsync(ServiceStack.Script.ScriptScopeContext scope, ServiceStack.Script.PageElseBlock[] elseBlocks, System.Threading.CancellationToken cancel) => throw null;
        }
        public class ScriptButtonBlock : ServiceStack.Script.ScriptHtmlBlock
        {
            public ScriptButtonBlock() => throw null;
            public override string Tag { get => throw null; }
        }
        public sealed class ScriptCode : ServiceStack.Script.ScriptLanguage
        {
            public static readonly ServiceStack.Script.ScriptLanguage Language;
            public override string Name { get => throw null; }
            public override System.Collections.Generic.List<ServiceStack.Script.PageFragment> Parse(ServiceStack.Script.ScriptContext context, System.ReadOnlyMemory<char> body, System.ReadOnlyMemory<char> modifiers) => throw null;
            public override System.Threading.Tasks.Task<bool> WritePageFragmentAsync(ServiceStack.Script.ScriptScopeContext scope, ServiceStack.Script.PageFragment fragment, System.Threading.CancellationToken token) => throw null;
            public override System.Threading.Tasks.Task<bool> WriteStatementAsync(ServiceStack.Script.ScriptScopeContext scope, ServiceStack.Script.JsStatement statement, System.Threading.CancellationToken token) => throw null;
        }
        public static class ScriptCodeUtils
        {
            public static ServiceStack.Script.SharpPage CodeBlock(this ServiceStack.Script.ScriptContext context, string code) => throw null;
            public static ServiceStack.Script.SharpPage CodeSharpPage(this ServiceStack.Script.ScriptContext context, string code) => throw null;
            public static string EnsureReturn(string code) => throw null;
            public static T EvaluateCode<T>(this ServiceStack.Script.ScriptContext context, string code, System.Collections.Generic.Dictionary<string, object> args = default(System.Collections.Generic.Dictionary<string, object>)) => throw null;
            public static object EvaluateCode(this ServiceStack.Script.ScriptContext context, string code, System.Collections.Generic.Dictionary<string, object> args = default(System.Collections.Generic.Dictionary<string, object>)) => throw null;
            public static System.Threading.Tasks.Task<T> EvaluateCodeAsync<T>(this ServiceStack.Script.ScriptContext context, string code, System.Collections.Generic.Dictionary<string, object> args = default(System.Collections.Generic.Dictionary<string, object>)) => throw null;
            public static System.Threading.Tasks.Task<object> EvaluateCodeAsync(this ServiceStack.Script.ScriptContext context, string code, System.Collections.Generic.Dictionary<string, object> args = default(System.Collections.Generic.Dictionary<string, object>)) => throw null;
            public static ServiceStack.Script.JsBlockStatement ParseCode(this ServiceStack.Script.ScriptContext context, string code) => throw null;
            public static ServiceStack.Script.JsBlockStatement ParseCode(this ServiceStack.Script.ScriptContext context, System.ReadOnlyMemory<char> code) => throw null;
            public static System.ReadOnlyMemory<char> ParseCodeScriptBlock(this System.ReadOnlyMemory<char> literal, ServiceStack.Script.ScriptContext context, out ServiceStack.Script.PageBlockFragment blockFragment) => throw null;
            public static string RenderCode(this ServiceStack.Script.ScriptContext context, string code, System.Collections.Generic.Dictionary<string, object> args = default(System.Collections.Generic.Dictionary<string, object>)) => throw null;
            public static System.Threading.Tasks.Task<string> RenderCodeAsync(this ServiceStack.Script.ScriptContext context, string code, System.Collections.Generic.Dictionary<string, object> args = default(System.Collections.Generic.Dictionary<string, object>)) => throw null;
        }
        public static class ScriptConfig
        {
            public static bool AllowAssignmentExpressions { get => throw null; set { } }
            public static bool AllowUnixPipeSyntax { get => throw null; set { } }
            public static System.Collections.Generic.HashSet<System.Type> CaptureAndEvaluateExceptionsToNull { get => throw null; set { } }
            public static System.Globalization.CultureInfo CreateCulture() => throw null;
            public static System.Globalization.CultureInfo DefaultCulture { get => throw null; set { } }
            public static string DefaultDateFormat { get => throw null; set { } }
            public static string DefaultDateTimeFormat { get => throw null; set { } }
            public static string DefaultErrorClassName { get => throw null; set { } }
            public static System.TimeSpan DefaultFileCacheExpiry { get => throw null; set { } }
            public static string DefaultIndent { get => throw null; set { } }
            public static string DefaultJsConfig { get => throw null; set { } }
            public static string DefaultNewLine { get => throw null; set { } }
            public static System.StringComparison DefaultStringComparison { get => throw null; set { } }
            public static string DefaultTableClassName { get => throw null; set { } }
            public static string DefaultTimeFormat { get => throw null; set { } }
            public static System.TimeSpan DefaultUrlCacheExpiry { get => throw null; set { } }
            public static System.Collections.Generic.HashSet<System.Type> FatalExceptions { get => throw null; set { } }
            public static ServiceStack.Script.ParseRealNumber ParseRealNumber;
        }
        public static class ScriptConstants
        {
            public const string AssetsBase = default;
            public const string AssignError = default;
            public const string BaseUrl = default;
            public const string CatchError = default;
            public const string Comparer = default;
            public const string Debug = default;
            public const string DefaultCulture = default;
            public const string DefaultDateFormat = default;
            public const string DefaultDateTimeFormat = default;
            public const string DefaultErrorClassName = default;
            public const string DefaultFileCacheExpiry = default;
            public const string DefaultIndent = default;
            public const string DefaultJsConfig = default;
            public const string DefaultNewLine = default;
            public const string DefaultStringComparison = default;
            public const string DefaultTableClassName = default;
            public const string DefaultTimeFormat = default;
            public const string DefaultUrlCacheExpiry = default;
            public const string Dto = default;
            public static ServiceStack.IRawString EmptyRawString { get => throw null; }
            public const string ErrorCode = default;
            public const string ErrorMessage = default;
            public static ServiceStack.IRawString FalseRawString { get => throw null; }
            public const string Field = default;
            public const string Format = default;
            public const string Global = default;
            public const string HtmlEncode = default;
            public const string IfErrorReturn = default;
            public const string Index = default;
            public const string It = default;
            public const string Map = default;
            public const string Model = default;
            public const string Page = default;
            public const string Partial = default;
            public const string PartialArg = default;
            public const string PathArgs = default;
            public const string PathBase = default;
            public const string PathInfo = default;
            public const string Request = default;
            public const string Return = default;
            public const string TempFilePath = default;
            public static ServiceStack.IRawString TrueRawString { get => throw null; }
        }
        public class ScriptContext : System.IDisposable
        {
            public bool AllowScriptingOfAllTypes { get => throw null; set { } }
            public ServiceStack.Configuration.IAppSettings AppSettings { get => throw null; set { } }
            public System.Collections.Generic.Dictionary<string, object> Args { get => throw null; }
            public ServiceStack.Script.ProtectedScripts AssertProtectedMethods() => throw null;
            public string AssignExceptionsTo { get => throw null; set { } }
            public System.Collections.Concurrent.ConcurrentDictionary<string, System.Action<ServiceStack.Script.ScriptScopeContext, object, object>> AssignExpressionCache { get => throw null; }
            public System.Collections.Concurrent.ConcurrentDictionary<string, object> Cache { get => throw null; }
            public ServiceStack.IO.IVirtualFiles CacheFiles { get => throw null; set { } }
            public System.Collections.Concurrent.ConcurrentDictionary<System.ReadOnlyMemory<char>, object> CacheMemory { get => throw null; }
            public bool CheckForModifiedPages { get => throw null; set { } }
            public System.TimeSpan? CheckForModifiedPagesAfter { get => throw null; set { } }
            public System.Collections.Concurrent.ConcurrentDictionary<System.Type, System.Tuple<System.Reflection.MethodInfo, ServiceStack.MethodInvoker>> CodePageInvokers { get => throw null; }
            public System.Collections.Generic.Dictionary<string, System.Type> CodePages { get => throw null; }
            public ServiceStack.IContainer Container { get => throw null; set { } }
            public ScriptContext() => throw null;
            public bool DebugMode { get => throw null; set { } }
            public string DefaultLayoutPage { get => throw null; set { } }
            public ServiceStack.Script.DefaultScripts DefaultMethods { get => throw null; }
            public ServiceStack.Script.ScriptLanguage DefaultScriptLanguage { get => throw null; set { } }
            public void Dispose() => throw null;
            public ServiceStack.IO.InMemoryVirtualFile EmptyFile { get => throw null; }
            public ServiceStack.Script.SharpPage EmptyPage { get => throw null; }
            public System.Collections.Generic.HashSet<string> ExcludeFiltersNamed { get => throw null; }
            public System.Collections.Concurrent.ConcurrentDictionary<string, System.Tuple<System.DateTime, object>> ExpiringCache { get => throw null; }
            public System.Collections.Generic.HashSet<string> FileFilterNames { get => throw null; }
            public System.Collections.Generic.Dictionary<string, System.Func<System.IO.Stream, System.Threading.Tasks.Task<System.IO.Stream>>> FilterTransformers { get => throw null; set { } }
            public System.Action<ServiceStack.Script.ScriptScopeContext, object, object> GetAssignExpression(System.Type targetType, System.ReadOnlyMemory<char> expression) => throw null;
            public ServiceStack.Script.ScriptBlock GetBlock(string name) => throw null;
            public ServiceStack.Script.SharpCodePage GetCodePage(string virtualPath) => throw null;
            public ServiceStack.Script.PageFormat GetFormat(string extension) => throw null;
            public ServiceStack.Script.SharpPage GetPage(string virtualPath) => throw null;
            public void GetPage(string fromVirtualPath, string virtualPath, out ServiceStack.Script.SharpPage page, out ServiceStack.Script.SharpCodePage codePage) => throw null;
            public string GetPathMapping(string prefix, string key) => throw null;
            public ServiceStack.Script.ScriptLanguage GetScriptLanguage(string name) => throw null;
            public bool HasInit { get => throw null; }
            public ServiceStack.Script.HtmlScripts HtmlMethods { get => throw null; }
            public string IndexPage { get => throw null; set { } }
            public ServiceStack.Script.ScriptContext Init() => throw null;
            public System.Collections.Generic.List<ServiceStack.Script.IScriptPlugin> InsertPlugins { get => throw null; }
            public System.Collections.Generic.List<ServiceStack.Script.ScriptBlock> InsertScriptBlocks { get => throw null; }
            public System.Collections.Generic.List<ServiceStack.Script.ScriptMethods> InsertScriptMethods { get => throw null; }
            public System.DateTime? InvalidateCachesBefore { get => throw null; set { } }
            public System.Collections.Concurrent.ConcurrentDictionary<System.ReadOnlyMemory<char>, ServiceStack.Script.JsToken> JsTokenCache { get => throw null; }
            public ServiceStack.Logging.ILog Log { get => throw null; }
            public long MaxEvaluations { get => throw null; set { } }
            public int MaxQuota { get => throw null; set { } }
            public int MaxStackDepth { get => throw null; set { } }
            public System.Action<ServiceStack.Script.ScriptContext> OnAfterPlugins { get => throw null; set { } }
            public ServiceStack.Script.SharpPage OneTimePage(string contents, string ext = default(string)) => throw null;
            public System.Collections.Generic.HashSet<string> OnlyEvaluateFiltersWhenSkippingPageFilterExecution { get => throw null; set { } }
            public System.Action<ServiceStack.Script.PageResult, System.Exception> OnRenderException { get => throw null; set { } }
            public System.Func<ServiceStack.Script.PageVariableFragment, System.ReadOnlyMemory<byte>> OnUnhandledExpression { get => throw null; set { } }
            public System.Collections.Generic.List<ServiceStack.Script.PageFormat> PageFormats { get => throw null; set { } }
            public ServiceStack.Script.ISharpPages Pages { get => throw null; set { } }
            public System.Collections.Generic.Dictionary<string, ServiceStack.Script.ScriptLanguage> ParseAsLanguage { get => throw null; set { } }
            public System.Collections.Concurrent.ConcurrentDictionary<string, string> PathMappings { get => throw null; }
            public System.Collections.Generic.List<ServiceStack.Script.IScriptPlugin> Plugins { get => throw null; }
            public System.Collections.Generic.List<System.Func<string, string>> Preprocessors { get => throw null; }
            public ServiceStack.Script.ProtectedScripts ProtectedMethods { get => throw null; }
            public ServiceStack.Script.ScriptContext RemoveBlocks(System.Predicate<ServiceStack.Script.ScriptBlock> match) => throw null;
            public ServiceStack.Script.ScriptContext RemoveFilters(System.Predicate<ServiceStack.Script.ScriptMethods> match) => throw null;
            public System.Collections.Generic.HashSet<string> RemoveNewLineAfterFiltersNamed { get => throw null; set { } }
            public void RemovePathMapping(string prefix, string mapPath) => throw null;
            public ServiceStack.Script.ScriptContext RemovePlugins(System.Predicate<ServiceStack.Script.IScriptPlugin> match) => throw null;
            public bool RenderExpressionExceptions { get => throw null; set { } }
            public System.Collections.Generic.List<System.Reflection.Assembly> ScanAssemblies { get => throw null; set { } }
            public ServiceStack.Script.ScriptContext ScanType(System.Type type) => throw null;
            public System.Collections.Generic.List<System.Type> ScanTypes { get => throw null; set { } }
            public System.Collections.Generic.List<System.Reflection.Assembly> ScriptAssemblies { get => throw null; set { } }
            public System.Collections.Generic.List<ServiceStack.Script.ScriptBlock> ScriptBlocks { get => throw null; }
            public System.Collections.Generic.List<ServiceStack.Script.ScriptLanguage> ScriptLanguages { get => throw null; }
            public System.Collections.Generic.List<ServiceStack.Script.ScriptMethods> ScriptMethods { get => throw null; }
            public System.Collections.Generic.List<string> ScriptNamespaces { get => throw null; set { } }
            public System.Collections.Generic.Dictionary<string, System.Type> ScriptTypeNameMap { get => throw null; }
            public System.Collections.Generic.Dictionary<string, System.Type> ScriptTypeQualifiedNameMap { get => throw null; }
            public System.Collections.Generic.List<System.Type> ScriptTypes { get => throw null; set { } }
            public string SetPathMapping(string prefix, string mapPath, string toPath) => throw null;
            public bool SkipExecutingFiltersIfError { get => throw null; set { } }
            public bool TryGetPage(string fromVirtualPath, string virtualPath, out ServiceStack.Script.SharpPage page, out ServiceStack.Script.SharpCodePage codePage) => throw null;
            public ServiceStack.IO.IVirtualPathProvider VirtualFiles { get => throw null; set { } }
        }
        public static class ScriptContextUtils
        {
            public static ServiceStack.Script.ScriptScopeContext CreateScope(this ServiceStack.Script.ScriptContext context, System.Collections.Generic.Dictionary<string, object> args = default(System.Collections.Generic.Dictionary<string, object>), ServiceStack.Script.ScriptMethods functions = default(ServiceStack.Script.ScriptMethods), ServiceStack.Script.ScriptBlock blocks = default(ServiceStack.Script.ScriptBlock)) => throw null;
            public static string ErrorNoReturn;
            public static bool EvaluateResult(this ServiceStack.Script.PageResult pageResult, out object returnValue) => throw null;
            public static System.Threading.Tasks.Task<System.Tuple<bool, object>> EvaluateResultAsync(this ServiceStack.Script.PageResult pageResult) => throw null;
            public static System.Exception HandleException(System.Exception e, ServiceStack.Script.PageResult pageResult) => throw null;
            public static System.Threading.Tasks.Task RenderAsync(this ServiceStack.Script.PageResult pageResult, System.IO.Stream stream, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static string RenderScript(this ServiceStack.Script.PageResult pageResult) => throw null;
            public static System.Threading.Tasks.Task<string> RenderScriptAsync(this ServiceStack.Script.PageResult pageResult, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static void RenderToStream(this ServiceStack.Script.PageResult pageResult, System.IO.Stream stream) => throw null;
            public static System.Threading.Tasks.Task RenderToStreamAsync(this ServiceStack.Script.PageResult pageResult, System.IO.Stream stream) => throw null;
            public static bool ShouldRethrow(System.Exception e) => throw null;
            public static void ThrowNoReturn() => throw null;
        }
        public class ScriptDdBlock : ServiceStack.Script.ScriptHtmlBlock
        {
            public ScriptDdBlock() => throw null;
            public override string Tag { get => throw null; }
        }
        public class ScriptDivBlock : ServiceStack.Script.ScriptHtmlBlock
        {
            public ScriptDivBlock() => throw null;
            public override string Tag { get => throw null; }
        }
        public class ScriptDlBlock : ServiceStack.Script.ScriptHtmlBlock
        {
            public ScriptDlBlock() => throw null;
            public override string Tag { get => throw null; }
        }
        public class ScriptDtBlock : ServiceStack.Script.ScriptHtmlBlock
        {
            public ScriptDtBlock() => throw null;
            public override string Tag { get => throw null; }
        }
        public class ScriptEmBlock : ServiceStack.Script.ScriptHtmlBlock
        {
            public ScriptEmBlock() => throw null;
            public override string Suffix { get => throw null; }
            public override string Tag { get => throw null; }
        }
        public class ScriptException : System.Exception
        {
            public ScriptException(ServiceStack.Script.PageResult pageResult) => throw null;
            public ServiceStack.Script.PageResult PageResult { get => throw null; }
            public string PageStackTrace { get => throw null; }
        }
        public static partial class ScriptExtensions
        {
            public static string AsString(this object str) => throw null;
            public static object InStopFilter(this System.Exception ex, ServiceStack.Script.ScriptScopeContext scope, object options) => throw null;
        }
        public class ScriptFormBlock : ServiceStack.Script.ScriptHtmlBlock
        {
            public ScriptFormBlock() => throw null;
            public override string Tag { get => throw null; }
        }
        public abstract class ScriptHtmlBlock : ServiceStack.Script.ScriptBlock
        {
            public override ServiceStack.Script.ScriptLanguage Body { get => throw null; }
            protected ScriptHtmlBlock() => throw null;
            public override string Name { get => throw null; }
            public virtual string Suffix { get => throw null; }
            public abstract string Tag { get; }
            public override System.Threading.Tasks.Task WriteAsync(ServiceStack.Script.ScriptScopeContext scope, ServiceStack.Script.PageBlockFragment block, System.Threading.CancellationToken token) => throw null;
        }
        public class ScriptIBlock : ServiceStack.Script.ScriptHtmlBlock
        {
            public ScriptIBlock() => throw null;
            public override string Suffix { get => throw null; }
            public override string Tag { get => throw null; }
        }
        public class ScriptImgBlock : ServiceStack.Script.ScriptHtmlBlock
        {
            public ScriptImgBlock() => throw null;
            public override string Suffix { get => throw null; }
            public override string Tag { get => throw null; }
        }
        public class ScriptInputBlock : ServiceStack.Script.ScriptHtmlBlock
        {
            public ScriptInputBlock() => throw null;
            public override string Tag { get => throw null; }
        }
        public abstract class ScriptLanguage
        {
            protected ScriptLanguage() => throw null;
            public virtual string LineComment { get => throw null; }
            public abstract string Name { get; }
            public System.Collections.Generic.List<ServiceStack.Script.PageFragment> Parse(ServiceStack.Script.ScriptContext context, System.ReadOnlyMemory<char> body) => throw null;
            public abstract System.Collections.Generic.List<ServiceStack.Script.PageFragment> Parse(ServiceStack.Script.ScriptContext context, System.ReadOnlyMemory<char> body, System.ReadOnlyMemory<char> modifiers);
            public virtual ServiceStack.Script.PageBlockFragment ParseVerbatimBlock(string blockName, System.ReadOnlyMemory<char> argument, System.ReadOnlyMemory<char> body) => throw null;
            public static object UnwrapValue(object value) => throw null;
            public static ServiceStack.Script.ScriptLanguage Verbatim { get => throw null; }
            public virtual System.Threading.Tasks.Task<bool> WritePageFragmentAsync(ServiceStack.Script.ScriptScopeContext scope, ServiceStack.Script.PageFragment fragment, System.Threading.CancellationToken token) => throw null;
            public virtual System.Threading.Tasks.Task<bool> WriteStatementAsync(ServiceStack.Script.ScriptScopeContext scope, ServiceStack.Script.JsStatement statement, System.Threading.CancellationToken token) => throw null;
        }
        public class ScriptLiBlock : ServiceStack.Script.ScriptHtmlBlock
        {
            public ScriptLiBlock() => throw null;
            public override string Tag { get => throw null; }
        }
        public class ScriptLinkBlock : ServiceStack.Script.ScriptHtmlBlock
        {
            public ScriptLinkBlock() => throw null;
            public override string Suffix { get => throw null; }
            public override string Tag { get => throw null; }
        }
        public sealed class ScriptLisp : ServiceStack.Script.ScriptLanguage, ServiceStack.Script.IConfigureScriptContext
        {
            public void Configure(ServiceStack.Script.ScriptContext context) => throw null;
            public static readonly ServiceStack.Script.ScriptLanguage Language;
            public override string LineComment { get => throw null; }
            public override string Name { get => throw null; }
            public override System.Collections.Generic.List<ServiceStack.Script.PageFragment> Parse(ServiceStack.Script.ScriptContext context, System.ReadOnlyMemory<char> body, System.ReadOnlyMemory<char> modifiers) => throw null;
            public override System.Threading.Tasks.Task<bool> WritePageFragmentAsync(ServiceStack.Script.ScriptScopeContext scope, ServiceStack.Script.PageFragment fragment, System.Threading.CancellationToken token) => throw null;
            public override System.Threading.Tasks.Task<bool> WriteStatementAsync(ServiceStack.Script.ScriptScopeContext scope, ServiceStack.Script.JsStatement statement, System.Threading.CancellationToken token) => throw null;
        }
        public static class ScriptLispUtils
        {
            public static string EnsureReturn(string lisp) => throw null;
            public static T EvaluateLisp<T>(this ServiceStack.Script.ScriptContext context, string lisp, System.Collections.Generic.Dictionary<string, object> args = default(System.Collections.Generic.Dictionary<string, object>)) => throw null;
            public static object EvaluateLisp(this ServiceStack.Script.ScriptContext context, string lisp, System.Collections.Generic.Dictionary<string, object> args = default(System.Collections.Generic.Dictionary<string, object>)) => throw null;
            public static System.Threading.Tasks.Task<T> EvaluateLispAsync<T>(this ServiceStack.Script.ScriptContext context, string lisp, System.Collections.Generic.Dictionary<string, object> args = default(System.Collections.Generic.Dictionary<string, object>)) => throw null;
            public static System.Threading.Tasks.Task<object> EvaluateLispAsync(this ServiceStack.Script.ScriptContext context, string lisp, System.Collections.Generic.Dictionary<string, object> args = default(System.Collections.Generic.Dictionary<string, object>)) => throw null;
            public static ServiceStack.Script.Lisp.Interpreter GetLispInterpreter(this ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public static ServiceStack.Script.Lisp.Interpreter GetLispInterpreter(this ServiceStack.Script.PageResult pageResult, ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public static ServiceStack.Script.SharpPage LispSharpPage(this ServiceStack.Script.ScriptContext context, string lisp) => throw null;
            public static ServiceStack.Script.LispStatements ParseLisp(this ServiceStack.Script.ScriptContext context, string lisp) => throw null;
            public static ServiceStack.Script.LispStatements ParseLisp(this ServiceStack.Script.ScriptContext context, System.ReadOnlyMemory<char> lisp) => throw null;
            public static string RenderLisp(this ServiceStack.Script.ScriptContext context, string lisp, System.Collections.Generic.Dictionary<string, object> args = default(System.Collections.Generic.Dictionary<string, object>)) => throw null;
            public static System.Threading.Tasks.Task<string> RenderLispAsync(this ServiceStack.Script.ScriptContext context, string lisp, System.Collections.Generic.Dictionary<string, object> args = default(System.Collections.Generic.Dictionary<string, object>)) => throw null;
        }
        public class ScriptMetaBlock : ServiceStack.Script.ScriptHtmlBlock
        {
            public ScriptMetaBlock() => throw null;
            public override string Suffix { get => throw null; }
            public override string Tag { get => throw null; }
        }
        public class ScriptMethodInfo
        {
            public string Body { get => throw null; }
            public static ServiceStack.Script.ScriptMethodInfo Create(System.Reflection.MethodInfo mi) => throw null;
            public ScriptMethodInfo(System.Reflection.MethodInfo methodInfo, System.Reflection.ParameterInfo[] @params) => throw null;
            public string FirstParam { get => throw null; }
            public string FirstParamType { get => throw null; }
            public System.Reflection.MethodInfo GetMethodInfo() => throw null;
            public static System.Collections.Generic.List<ServiceStack.Script.ScriptMethodInfo> GetScriptMethods(System.Type scriptMethodsType, System.Func<System.Reflection.MethodInfo, bool> where = default(System.Func<System.Reflection.MethodInfo, bool>)) => throw null;
            public string Name { get => throw null; }
            public int ParamCount { get => throw null; }
            public string[] ParamNames { get => throw null; }
            public string[] ParamTypes { get => throw null; }
            public string[] RemainingParams { get => throw null; }
            public string Return { get => throw null; }
            public string ReturnType { get => throw null; }
            public string ScriptSignature { get => throw null; }
            public string Signature { get => throw null; }
            public override string ToString() => throw null;
        }
        public class ScriptMethods
        {
            public ServiceStack.Script.ScriptContext Context { get => throw null; set { } }
            public ScriptMethods() => throw null;
            public ServiceStack.MethodInvoker GetInvoker(string name, int argsCount, ServiceStack.Script.InvokerType type) => throw null;
            public System.Collections.Concurrent.ConcurrentDictionary<string, ServiceStack.MethodInvoker> InvokerCache { get => throw null; }
            public ServiceStack.Script.ISharpPages Pages { get => throw null; set { } }
            public System.Collections.Generic.List<System.Reflection.MethodInfo> QueryFilters(string filterName) => throw null;
        }
        public class ScriptOlBlock : ServiceStack.Script.ScriptHtmlBlock
        {
            public ScriptOlBlock() => throw null;
            public override string Tag { get => throw null; }
        }
        public class ScriptOptionBlock : ServiceStack.Script.ScriptHtmlBlock
        {
            public ScriptOptionBlock() => throw null;
            public override string Tag { get => throw null; }
        }
        public class ScriptPBlock : ServiceStack.Script.ScriptHtmlBlock
        {
            public ScriptPBlock() => throw null;
            public override string Tag { get => throw null; }
        }
        public static class ScriptPreprocessors
        {
            public static string TransformCodeBlocks(string script) => throw null;
            public static string TransformStatementBody(string body) => throw null;
        }
        public struct ScriptScopeContext
        {
            public ServiceStack.Script.ScriptScopeContext Clone() => throw null;
            public ServiceStack.Script.SharpCodePage CodePage { get => throw null; }
            public ServiceStack.Script.ScriptContext Context { get => throw null; }
            public ScriptScopeContext(ServiceStack.Script.PageResult pageResult, System.IO.Stream outputStream, System.Collections.Generic.Dictionary<string, object> scopedParams) => throw null;
            public ScriptScopeContext(ServiceStack.Script.ScriptContext context, System.Collections.Generic.Dictionary<string, object> scopedParams) => throw null;
            public System.IO.Stream OutputStream { get => throw null; }
            public ServiceStack.Script.SharpPage Page { get => throw null; }
            public ServiceStack.Script.PageResult PageResult { get => throw null; }
            public System.Collections.Generic.Dictionary<string, object> ScopedParams { get => throw null; }
        }
        public static class ScriptScopeContextUtils
        {
            public static ServiceStack.Script.ScriptScopeContext CreateScopedContext(this ServiceStack.Script.ScriptScopeContext scope, string template, System.Collections.Generic.Dictionary<string, object> scopeParams = default(System.Collections.Generic.Dictionary<string, object>), bool cachePage = default(bool)) => throw null;
            public static object EvaluateExpression(this ServiceStack.Script.ScriptScopeContext scope, string expr) => throw null;
            public static object GetArgument(this ServiceStack.Script.ScriptScopeContext scope, string name) => throw null;
            public static object GetValue(this ServiceStack.Script.ScriptScopeContext scope, string name) => throw null;
            public static void InvokeAssignExpression(this ServiceStack.Script.ScriptScopeContext scope, string assignExpr, object target, object value) => throw null;
            public static ServiceStack.Script.StopExecution ReturnValue(this ServiceStack.Script.ScriptScopeContext scope, object returnValue, System.Collections.Generic.Dictionary<string, object> returnArgs = default(System.Collections.Generic.Dictionary<string, object>)) => throw null;
            public static ServiceStack.Script.ScriptScopeContext ScopeWith(this ServiceStack.Script.ScriptScopeContext parentContext, System.Collections.Generic.Dictionary<string, object> scopedParams = default(System.Collections.Generic.Dictionary<string, object>), System.IO.Stream outputStream = default(System.IO.Stream)) => throw null;
            public static ServiceStack.Script.ScriptScopeContext ScopeWithParams(this ServiceStack.Script.ScriptScopeContext parentContext, System.Collections.Generic.Dictionary<string, object> scopedParams) => throw null;
            public static ServiceStack.Script.ScriptScopeContext ScopeWithStream(this ServiceStack.Script.ScriptScopeContext scope, System.IO.Stream stream) => throw null;
            public static bool TryGetMethod(this ServiceStack.Script.ScriptScopeContext scope, string name, int fnArgValuesCount, out System.Delegate fn, out ServiceStack.Script.ScriptMethods scriptMethod, out bool requiresScope) => throw null;
            public static bool TryGetValue(this ServiceStack.Script.ScriptScopeContext scope, string name, out object value) => throw null;
            public static System.Threading.Tasks.Task WritePageAsync(this ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public static System.Threading.Tasks.Task WritePageAsync(this ServiceStack.Script.ScriptScopeContext scope, ServiceStack.Script.SharpPage page, ServiceStack.Script.SharpCodePage codePage, System.Collections.Generic.Dictionary<string, object> pageParams, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        }
        public class ScriptScriptBlock : ServiceStack.Script.ScriptHtmlBlock
        {
            public ScriptScriptBlock() => throw null;
            public override string Suffix { get => throw null; }
            public override string Tag { get => throw null; }
        }
        public class ScriptSelectBlock : ServiceStack.Script.ScriptHtmlBlock
        {
            public ScriptSelectBlock() => throw null;
            public override string Tag { get => throw null; }
        }
        public class ScriptSpanBlock : ServiceStack.Script.ScriptHtmlBlock
        {
            public ScriptSpanBlock() => throw null;
            public override string Suffix { get => throw null; }
            public override string Tag { get => throw null; }
        }
        public class ScriptStrongBlock : ServiceStack.Script.ScriptHtmlBlock
        {
            public ScriptStrongBlock() => throw null;
            public override string Suffix { get => throw null; }
            public override string Tag { get => throw null; }
        }
        public class ScriptStyleBlock : ServiceStack.Script.ScriptHtmlBlock
        {
            public ScriptStyleBlock() => throw null;
            public override string Suffix { get => throw null; }
            public override string Tag { get => throw null; }
        }
        public class ScriptTableBlock : ServiceStack.Script.ScriptHtmlBlock
        {
            public ScriptTableBlock() => throw null;
            public override string Tag { get => throw null; }
        }
        public class ScriptTBodyBlock : ServiceStack.Script.ScriptHtmlBlock
        {
            public ScriptTBodyBlock() => throw null;
            public override string Tag { get => throw null; }
        }
        public class ScriptTdBlock : ServiceStack.Script.ScriptHtmlBlock
        {
            public ScriptTdBlock() => throw null;
            public override string Tag { get => throw null; }
        }
        public sealed class ScriptTemplate : ServiceStack.Script.ScriptLanguage
        {
            public static readonly ServiceStack.Script.ScriptLanguage Language;
            public override string Name { get => throw null; }
            public override System.Collections.Generic.List<ServiceStack.Script.PageFragment> Parse(ServiceStack.Script.ScriptContext context, System.ReadOnlyMemory<char> body, System.ReadOnlyMemory<char> modifiers) => throw null;
            public override System.Threading.Tasks.Task<bool> WritePageFragmentAsync(ServiceStack.Script.ScriptScopeContext scope, ServiceStack.Script.PageFragment fragment, System.Threading.CancellationToken token) => throw null;
        }
        public static class ScriptTemplateUtils
        {
            public static System.Collections.Concurrent.ConcurrentDictionary<string, System.Func<ServiceStack.Script.ScriptScopeContext, object, object>> BinderCache { get => throw null; }
            public static System.Func<ServiceStack.Script.ScriptScopeContext, object, object> Compile(System.Type type, System.ReadOnlyMemory<char> expr) => throw null;
            public static System.Action<ServiceStack.Script.ScriptScopeContext, object, object> CompileAssign(System.Type type, System.ReadOnlyMemory<char> expr) => throw null;
            public static System.Reflection.MethodInfo CreateConvertMethod(System.Type toType) => throw null;
            public static T Evaluate<T>(this ServiceStack.Script.ScriptContext context, string script, System.Collections.Generic.Dictionary<string, object> args = default(System.Collections.Generic.Dictionary<string, object>)) => throw null;
            public static object Evaluate(this ServiceStack.Script.ScriptContext context, string script, System.Collections.Generic.Dictionary<string, object> args = default(System.Collections.Generic.Dictionary<string, object>)) => throw null;
            public static System.Threading.Tasks.Task<T> EvaluateAsync<T>(this ServiceStack.Script.ScriptContext context, string script, System.Collections.Generic.Dictionary<string, object> args = default(System.Collections.Generic.Dictionary<string, object>)) => throw null;
            public static System.Threading.Tasks.Task<object> EvaluateAsync(this ServiceStack.Script.ScriptContext context, string script, System.Collections.Generic.Dictionary<string, object> args = default(System.Collections.Generic.Dictionary<string, object>)) => throw null;
            public static object EvaluateBinding(ServiceStack.Script.ScriptScopeContext scope, ServiceStack.Script.JsToken token) => throw null;
            public static T EvaluateBindingAs<T>(ServiceStack.Script.ScriptScopeContext scope, ServiceStack.Script.JsToken token) => throw null;
            public static string EvaluateScript(this ServiceStack.Script.ScriptContext context, string script, out ServiceStack.Script.ScriptException error) => throw null;
            public static string EvaluateScript(this ServiceStack.Script.ScriptContext context, string script, System.Collections.Generic.Dictionary<string, object> args, out ServiceStack.Script.ScriptException error) => throw null;
            public static string EvaluateScript(this ServiceStack.Script.ScriptContext context, string script, System.Collections.Generic.Dictionary<string, object> args = default(System.Collections.Generic.Dictionary<string, object>)) => throw null;
            public static System.Threading.Tasks.Task<string> EvaluateScriptAsync(this ServiceStack.Script.ScriptContext context, string script, System.Collections.Generic.Dictionary<string, object> args = default(System.Collections.Generic.Dictionary<string, object>)) => throw null;
            public static System.Func<ServiceStack.Script.ScriptScopeContext, object, object> GetMemberExpression(System.Type targetType, System.ReadOnlyMemory<char> expression) => throw null;
            public static bool IsWhiteSpace(this char c) => throw null;
            public static System.Collections.Generic.List<ServiceStack.Script.PageFragment> ParseScript(this ServiceStack.Script.ScriptContext context, System.ReadOnlyMemory<char> text) => throw null;
            public static System.Collections.Generic.List<ServiceStack.Script.PageFragment> ParseTemplate(string text) => throw null;
            public static System.Collections.Generic.List<ServiceStack.Script.PageFragment> ParseTemplate(this ServiceStack.Script.ScriptContext context, System.ReadOnlyMemory<char> text) => throw null;
            public static System.ReadOnlyMemory<char> ParseTemplateBody(this System.ReadOnlyMemory<char> literal, System.ReadOnlyMemory<char> blockName, out System.ReadOnlyMemory<char> body) => throw null;
            public static System.ReadOnlyMemory<char> ParseTemplateElseBlock(this System.ReadOnlyMemory<char> literal, string blockName, out System.ReadOnlyMemory<char> elseArgument, out System.ReadOnlyMemory<char> elseBody) => throw null;
            public static System.ReadOnlyMemory<char> ParseTemplateScriptBlock(this System.ReadOnlyMemory<char> literal, ServiceStack.Script.ScriptContext context, out ServiceStack.Script.PageBlockFragment blockFragment) => throw null;
            public static string RenderScript(this ServiceStack.Script.ScriptContext context, string script, out ServiceStack.Script.ScriptException error) => throw null;
            public static string RenderScript(this ServiceStack.Script.ScriptContext context, string script, System.Collections.Generic.Dictionary<string, object> args, out ServiceStack.Script.ScriptException error) => throw null;
            public static string RenderScript(this ServiceStack.Script.ScriptContext context, string script, System.Collections.Generic.Dictionary<string, object> args = default(System.Collections.Generic.Dictionary<string, object>)) => throw null;
            public static System.Threading.Tasks.Task<string> RenderScriptAsync(this ServiceStack.Script.ScriptContext context, string script, System.Collections.Generic.Dictionary<string, object> args = default(System.Collections.Generic.Dictionary<string, object>)) => throw null;
            public static ServiceStack.Script.SharpPage SharpScriptPage(this ServiceStack.Script.ScriptContext context, string code) => throw null;
            public static ServiceStack.Script.SharpPage TemplateSharpPage(this ServiceStack.Script.ScriptContext context, string code) => throw null;
            public static ServiceStack.IRawString ToRawString(this string value) => throw null;
        }
        public class ScriptTextAreaBlock : ServiceStack.Script.ScriptHtmlBlock
        {
            public ScriptTextAreaBlock() => throw null;
            public override string Tag { get => throw null; }
        }
        public class ScriptTFootBlock : ServiceStack.Script.ScriptHtmlBlock
        {
            public ScriptTFootBlock() => throw null;
            public override string Tag { get => throw null; }
        }
        public class ScriptTHeadBlock : ServiceStack.Script.ScriptHtmlBlock
        {
            public ScriptTHeadBlock() => throw null;
            public override string Tag { get => throw null; }
        }
        public class ScriptTrBlock : ServiceStack.Script.ScriptHtmlBlock
        {
            public ScriptTrBlock() => throw null;
            public override string Tag { get => throw null; }
        }
        public class ScriptUlBlock : ServiceStack.Script.ScriptHtmlBlock
        {
            public ScriptUlBlock() => throw null;
            public override string Tag { get => throw null; }
        }
        public sealed class ScriptVerbatim : ServiceStack.Script.ScriptLanguage
        {
            public static readonly ServiceStack.Script.ScriptLanguage Language;
            public override string Name { get => throw null; }
            public override System.Collections.Generic.List<ServiceStack.Script.PageFragment> Parse(ServiceStack.Script.ScriptContext context, System.ReadOnlyMemory<char> body, System.ReadOnlyMemory<char> modifiers) => throw null;
        }
        public abstract class SharpCodePage : System.IDisposable
        {
            public System.Collections.Generic.Dictionary<string, object> Args { get => throw null; }
            public ServiceStack.Script.ScriptContext Context { get => throw null; set { } }
            protected SharpCodePage(string layout = default(string)) => throw null;
            public virtual void Dispose() => throw null;
            public ServiceStack.Script.PageFormat Format { get => throw null; set { } }
            public bool HasInit { get => throw null; }
            public virtual ServiceStack.Script.SharpCodePage Init() => throw null;
            public string Layout { get => throw null; set { } }
            public ServiceStack.Script.SharpPage LayoutPage { get => throw null; set { } }
            public ServiceStack.Script.ISharpPages Pages { get => throw null; set { } }
            public ServiceStack.Script.ScriptScopeContext Scope { get => throw null; set { } }
            public string VirtualPath { get => throw null; set { } }
            public System.Threading.Tasks.Task WriteAsync(ServiceStack.Script.ScriptScopeContext scope) => throw null;
        }
        public class SharpPage
        {
            public System.Collections.Generic.Dictionary<string, object> Args { get => throw null; set { } }
            public System.ReadOnlyMemory<char> BodyContents { get => throw null; }
            public ServiceStack.Script.ScriptContext Context { get => throw null; }
            public SharpPage(ServiceStack.Script.ScriptContext context, ServiceStack.IO.IVirtualFile file, ServiceStack.Script.PageFormat format = default(ServiceStack.Script.PageFormat)) => throw null;
            public SharpPage(ServiceStack.Script.ScriptContext context, ServiceStack.Script.PageFragment[] body) => throw null;
            public ServiceStack.IO.IVirtualFile File { get => throw null; }
            public System.ReadOnlyMemory<char> FileContents { get => throw null; }
            public ServiceStack.Script.PageFormat Format { get => throw null; }
            public bool HasInit { get => throw null; }
            public virtual System.Threading.Tasks.Task<ServiceStack.Script.SharpPage> Init() => throw null;
            public bool IsImmutable { get => throw null; }
            public bool IsLayout { get => throw null; }
            public bool IsTempFile { get => throw null; }
            public System.DateTime LastModified { get => throw null; set { } }
            public System.DateTime LastModifiedCheck { get => throw null; }
            public ServiceStack.Script.SharpPage LayoutPage { get => throw null; set { } }
            public System.Threading.Tasks.Task<ServiceStack.Script.SharpPage> Load() => throw null;
            public ServiceStack.Script.PageFragment[] PageFragments { get => throw null; set { } }
            public ServiceStack.Script.ScriptLanguage ScriptLanguage { get => throw null; set { } }
            public string VirtualPath { get => throw null; }
        }
        public class SharpPages : ServiceStack.Script.ISharpPages
        {
            public virtual ServiceStack.Script.SharpPage AddPage(string virtualPath, ServiceStack.IO.IVirtualFile file) => throw null;
            public ServiceStack.Script.ScriptContext Context { get => throw null; }
            public SharpPages(ServiceStack.Script.ScriptContext context) => throw null;
            public ServiceStack.Script.SharpCodePage GetCodePage(string virtualPath) => throw null;
            public System.DateTime GetLastModified(ServiceStack.Script.SharpPage page) => throw null;
            public System.DateTime GetLastModifiedPage(ServiceStack.Script.SharpPage page) => throw null;
            public virtual ServiceStack.Script.SharpPage GetPage(string pathInfo) => throw null;
            public static string Layout;
            public virtual ServiceStack.Script.SharpPage OneTimePage(string contents, string ext) => throw null;
            public ServiceStack.Script.SharpPage OneTimePage(string contents, string ext, System.Action<ServiceStack.Script.SharpPage> init) => throw null;
            public virtual ServiceStack.Script.SharpPage ResolveLayoutPage(ServiceStack.Script.SharpPage page, string layout) => throw null;
            public virtual ServiceStack.Script.SharpPage ResolveLayoutPage(ServiceStack.Script.SharpCodePage page, string layout) => throw null;
            public virtual ServiceStack.Script.SharpPage TryGetPage(string path) => throw null;
        }
        public class SharpPartialPage : ServiceStack.Script.SharpPage
        {
            public SharpPartialPage(ServiceStack.Script.ScriptContext context, string name, System.Collections.Generic.IEnumerable<ServiceStack.Script.PageFragment> body, string format, System.Collections.Generic.Dictionary<string, object> args = default(System.Collections.Generic.Dictionary<string, object>)) : base(default(ServiceStack.Script.ScriptContext), default(ServiceStack.Script.PageFragment[])) => throw null;
            public override System.Threading.Tasks.Task<ServiceStack.Script.SharpPage> Init() => throw null;
        }
        public sealed class SharpScript : ServiceStack.Script.ScriptLanguage
        {
            public static readonly ServiceStack.Script.ScriptLanguage Language;
            public override string Name { get => throw null; }
            public override System.Collections.Generic.List<ServiceStack.Script.PageFragment> Parse(ServiceStack.Script.ScriptContext context, System.ReadOnlyMemory<char> body, System.ReadOnlyMemory<char> modifiers) => throw null;
        }
        public struct SpanJsToken
        {
            public SpanJsToken(System.ReadOnlySpan<char> value, ServiceStack.Script.JsToken node) => throw null;
            public ServiceStack.Script.JsToken Node { get => throw null; }
            public System.ReadOnlySpan<char> Span { get => throw null; }
        }
        public class StopExecution : ServiceStack.Script.IResultInstruction
        {
            public static ServiceStack.Script.StopExecution Value;
        }
        public class StopFilterExecutionException : ServiceStack.StopExecutionException, ServiceStack.Model.IResponseStatusConvertible
        {
            public StopFilterExecutionException(ServiceStack.Script.ScriptScopeContext scope, object options, System.Exception innerException) => throw null;
            public object Options { get => throw null; }
            public ServiceStack.Script.ScriptScopeContext Scope { get => throw null; }
            public ServiceStack.ResponseStatus ToResponseStatus() => throw null;
        }
        public class SyntaxErrorException : System.ArgumentException
        {
            public SyntaxErrorException() => throw null;
            public SyntaxErrorException(string message) => throw null;
            public SyntaxErrorException(string message, System.Exception innerException) => throw null;
        }
        public static class TemplateFilterUtils
        {
            public static ServiceStack.Script.ScriptScopeContext AddItemToScope(this ServiceStack.Script.ScriptScopeContext scope, string itemBinding, object item, int index) => throw null;
            public static ServiceStack.Script.ScriptScopeContext AddItemToScope(this ServiceStack.Script.ScriptScopeContext scope, string itemBinding, object item) => throw null;
            public static System.Collections.Generic.IEnumerable<object> AssertEnumerable(this object items, string filterName) => throw null;
            public static string AssertExpression(this ServiceStack.Script.ScriptScopeContext scope, string filterName, object expression) => throw null;
            public static ServiceStack.Script.JsToken AssertExpression(this ServiceStack.Script.ScriptScopeContext scope, string filterName, object expression, object scopeOptions, out string itemBinding) => throw null;
            public static object AssertNoCircularDeps(this object value) => throw null;
            public static System.Collections.Generic.Dictionary<string, object> AssertOptions(this ServiceStack.Script.ScriptScopeContext scope, string filterName, object scopedParams) => throw null;
            public static System.Collections.Generic.Dictionary<string, object> AssertOptions(this object scopedParams, string filterName) => throw null;
            public static ServiceStack.Script.ScriptContext CreateNewContext(this ServiceStack.Script.ScriptScopeContext scope, System.Collections.Generic.Dictionary<string, object> args) => throw null;
            public static System.Collections.Generic.Dictionary<string, object> GetParamsWithItemBinding(this ServiceStack.Script.ScriptScopeContext scope, string filterName, object scopedParams, out string itemBinding) => throw null;
            public static System.Collections.Generic.Dictionary<string, object> GetParamsWithItemBinding(this ServiceStack.Script.ScriptScopeContext scope, string filterName, ServiceStack.Script.SharpPage page, object scopedParams, out string itemBinding) => throw null;
            public static System.Collections.Generic.Dictionary<string, object> GetParamsWithItemBindingOnly(this ServiceStack.Script.ScriptScopeContext scope, string filterName, ServiceStack.Script.SharpPage page, object scopedParams, out string itemBinding) => throw null;
            public static T GetValueOrEvaluateBinding<T>(this ServiceStack.Script.ScriptScopeContext scope, object valueOrBinding) => throw null;
            public static object GetValueOrEvaluateBinding(this ServiceStack.Script.ScriptScopeContext scope, object valueOrBinding, System.Type returnType) => throw null;
            public static bool TryGetPage(this ServiceStack.Script.ScriptScopeContext scope, string virtualPath, out ServiceStack.Script.SharpPage page, out ServiceStack.Script.SharpCodePage codePage) => throw null;
        }
        public class TypeScriptMethods : ServiceStack.Script.ScriptMethods
        {
            public TypeScriptMethods() => throw null;
            public ServiceStack.Script.RawString tsUnionStrings(System.Collections.Generic.IEnumerable<string> strings) => throw null;
            public ServiceStack.Script.RawString tsUnionTypes(System.Collections.Generic.IEnumerable<string> strings) => throw null;
        }
        public class TypeScriptPlugin : ServiceStack.Script.IScriptPlugin
        {
            public TypeScriptPlugin() => throw null;
            public void Register(ServiceStack.Script.ScriptContext context) => throw null;
        }
        public class WhileScriptBlock : ServiceStack.Script.ScriptBlock
        {
            public WhileScriptBlock() => throw null;
            public override string Name { get => throw null; }
            public override System.Threading.Tasks.Task WriteAsync(ServiceStack.Script.ScriptScopeContext scope, ServiceStack.Script.PageBlockFragment block, System.Threading.CancellationToken ct) => throw null;
        }
        public class WithScriptBlock : ServiceStack.Script.ScriptBlock
        {
            public WithScriptBlock() => throw null;
            public override string Name { get => throw null; }
            public override System.Threading.Tasks.Task WriteAsync(ServiceStack.Script.ScriptScopeContext scope, ServiceStack.Script.PageBlockFragment block, System.Threading.CancellationToken token) => throw null;
        }
    }
    public static partial class SharpPagesExtensions
    {
        public static System.Threading.Tasks.Task<string> RenderToStringAsync(this ServiceStack.Web.IStreamWriterAsync writer) => throw null;
    }
    public class SimpleAppSettings : ServiceStack.Configuration.IAppSettings
    {
        public SimpleAppSettings(System.Collections.Generic.Dictionary<string, string> settings = default(System.Collections.Generic.Dictionary<string, string>)) => throw null;
        public bool Exists(string key) => throw null;
        public T Get<T>(string key) => throw null;
        public T Get<T>(string key, T defaultValue) => throw null;
        public System.Collections.Generic.Dictionary<string, string> GetAll() => throw null;
        public System.Collections.Generic.List<string> GetAllKeys() => throw null;
        public System.Collections.Generic.IDictionary<string, string> GetDictionary(string key) => throw null;
        public System.Collections.Generic.List<System.Collections.Generic.KeyValuePair<string, string>> GetKeyValuePairs(string key) => throw null;
        public System.Collections.Generic.IList<string> GetList(string key) => throw null;
        public string GetString(string key) => throw null;
        public void Set<T>(string key, T value) => throw null;
    }
    public class SimpleContainer : ServiceStack.IContainer, ServiceStack.Configuration.IResolver
    {
        public ServiceStack.IContainer AddSingleton(System.Type type, System.Func<object> factory) => throw null;
        public ServiceStack.IContainer AddTransient(System.Type type, System.Func<object> factory) => throw null;
        public System.Func<object> CreateFactory(System.Type type) => throw null;
        public SimpleContainer() => throw null;
        public void Dispose() => throw null;
        public bool Exists(System.Type type) => throw null;
        protected readonly System.Collections.Concurrent.ConcurrentDictionary<System.Type, System.Func<object>> Factory;
        public System.Collections.Generic.HashSet<string> IgnoreTypesNamed { get => throw null; }
        protected virtual bool IncludeProperty(System.Reflection.PropertyInfo pi) => throw null;
        protected readonly System.Collections.Concurrent.ConcurrentDictionary<System.Type, object> InstanceCache;
        public object RequiredResolve(System.Type type, System.Type ownerType) => throw null;
        public object Resolve(System.Type type) => throw null;
        protected virtual System.Reflection.ConstructorInfo ResolveBestConstructor(System.Type type) => throw null;
        public T TryResolve<T>() => throw null;
    }
    public static class SiteUtils
    {
        public static string ToUrlEncoded(System.Collections.Generic.List<string> args) => throw null;
        public static string UrlFromSlug(string slug) => throw null;
        public static string UrlToSlug(string url) => throw null;
    }
    public delegate void StaticActionInvoker(params object[] args);
    public delegate object StaticMethodInvoker(params object[] args);
    public class StopExecutionException : System.Exception
    {
        public StopExecutionException() => throw null;
        public StopExecutionException(string message) => throw null;
        public StopExecutionException(string message, System.Exception innerException) => throw null;
    }
    public static class StringUtils
    {
        public static void AppendLine(this System.Text.StringBuilder sb, System.ReadOnlyMemory<char> line) => throw null;
        public static string ConvertHtmlCodes(this string html) => throw null;
        public static readonly System.Collections.Generic.Dictionary<char, string> EscapedCharMap;
        public static readonly System.Collections.Generic.IDictionary<string, string> HtmlCharacterCodes;
        public static string HtmlDecode(this string html) => throw null;
        public static string HtmlEncode(this string html) => throw null;
        public static string HtmlEncodeLite(this string html) => throw null;
        public static string Join(string delimiter, System.Collections.Generic.IEnumerable<string> values, int lineBreak = default(int), string linePrefix = default(string)) => throw null;
        public static System.ReadOnlyMemory<char> NewLineMemory;
        public static System.ReadOnlyMemory<char> ParseArguments(System.ReadOnlyMemory<char> argsString, out System.Collections.Generic.List<System.ReadOnlyMemory<char>> args) => throw null;
        public static System.Collections.Generic.List<ServiceStack.Command> ParseCommands(this string commandsString) => throw null;
        public static System.Collections.Generic.List<ServiceStack.Command> ParseCommands(this System.ReadOnlyMemory<char> commandsString, char separator = default(char)) => throw null;
        public static ServiceStack.TextNode ParseTypeIntoNodes(this string typeDef) => throw null;
        public static ServiceStack.TextNode ParseTypeIntoNodes(this string typeDef, char[] genericDelimChars) => throw null;
        public static string RemoveSuffix(string name, string suffix) => throw null;
        public static string ReplaceOutsideOfQuotes(this string str, params string[] replaceStringsPairs) => throw null;
        public static string ReplacePairs(string str, string[] replaceStringsPairs) => throw null;
        public static string SafeInput(this string text) => throw null;
        public static string SnakeCaseToPascalCase(string snakeCase) => throw null;
        public static System.Collections.Generic.List<string> SplitGenericArgs(string argList) => throw null;
        public static string[] SplitVarNames(string fields) => throw null;
        public static string ToChar(this int codePoint) => throw null;
        public static string ToEscapedString(this string input) => throw null;
    }
    namespace Support
    {
        public class ActionExecHandler : ServiceStack.Commands.ICommand<bool>, ServiceStack.Commands.ICommandExec
        {
            public ActionExecHandler(System.Action action, System.Threading.AutoResetEvent waitHandle) => throw null;
            public bool Execute() => throw null;
        }
        public abstract class AdapterBase
        {
            protected AdapterBase() => throw null;
            protected T Execute<T>(System.Func<T> action) => throw null;
            protected void Execute(System.Action action) => throw null;
            protected System.Threading.Tasks.Task<T> ExecuteAsync<T>(System.Func<System.Threading.Tasks.Task<T>> action) => throw null;
            protected System.Threading.Tasks.Task<T> ExecuteAsync<T>(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.Task<T>> action, System.Threading.CancellationToken token) => throw null;
            protected System.Threading.Tasks.Task ExecuteAsync(System.Func<System.Threading.Tasks.Task> action) => throw null;
            protected System.Threading.Tasks.Task ExecuteAsync(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.Task> action, System.Threading.CancellationToken token) => throw null;
            protected abstract ServiceStack.Logging.ILog Log { get; }
        }
        public class CommandExecsHandler : ServiceStack.Commands.ICommand<bool>, ServiceStack.Commands.ICommandExec
        {
            public CommandExecsHandler(ServiceStack.Commands.ICommandExec command, System.Threading.AutoResetEvent waitHandle) => throw null;
            public bool Execute() => throw null;
        }
        public class CommandResultsHandler<T> : ServiceStack.Commands.ICommand<bool>, ServiceStack.Commands.ICommandExec
        {
            public CommandResultsHandler(System.Collections.Generic.List<T> results, ServiceStack.Commands.ICommandList<T> command, System.Threading.AutoResetEvent waitHandle) => throw null;
            public bool Execute() => throw null;
        }
        public class InMemoryLog : ServiceStack.Logging.ILog
        {
            public System.Text.StringBuilder CombinedLog { get => throw null; }
            public InMemoryLog(string loggerName) => throw null;
            public void Debug(object message) => throw null;
            public void Debug(object message, System.Exception exception) => throw null;
            public System.Collections.Generic.List<string> DebugEntries { get => throw null; set { } }
            public System.Collections.Generic.List<System.Exception> DebugExceptions { get => throw null; set { } }
            public void DebugFormat(string format, params object[] args) => throw null;
            public void Error(object message) => throw null;
            public void Error(object message, System.Exception exception) => throw null;
            public System.Collections.Generic.List<string> ErrorEntries { get => throw null; set { } }
            public System.Collections.Generic.List<System.Exception> ErrorExceptions { get => throw null; set { } }
            public void ErrorFormat(string format, params object[] args) => throw null;
            public void Fatal(object message) => throw null;
            public void Fatal(object message, System.Exception exception) => throw null;
            public System.Collections.Generic.List<string> FatalEntries { get => throw null; set { } }
            public System.Collections.Generic.List<System.Exception> FatalExceptions { get => throw null; set { } }
            public void FatalFormat(string format, params object[] args) => throw null;
            public bool HasExceptions { get => throw null; }
            public void Info(object message) => throw null;
            public void Info(object message, System.Exception exception) => throw null;
            public System.Collections.Generic.List<string> InfoEntries { get => throw null; set { } }
            public System.Collections.Generic.List<System.Exception> InfoExceptions { get => throw null; set { } }
            public void InfoFormat(string format, params object[] args) => throw null;
            public bool IsDebugEnabled { get => throw null; set { } }
            public string LoggerName { get => throw null; }
            public void Warn(object message) => throw null;
            public void Warn(object message, System.Exception exception) => throw null;
            public System.Collections.Generic.List<string> WarnEntries { get => throw null; set { } }
            public System.Collections.Generic.List<System.Exception> WarnExceptions { get => throw null; set { } }
            public void WarnFormat(string format, params object[] args) => throw null;
        }
        public class InMemoryLogFactory : ServiceStack.Logging.ILogFactory
        {
            public InMemoryLogFactory(bool debugEnabled = default(bool)) => throw null;
            public ServiceStack.Logging.ILog GetLogger(System.Type type) => throw null;
            public ServiceStack.Logging.ILog GetLogger(string typeName) => throw null;
        }
    }
    public static class TaskExt
    {
        public static System.Threading.Tasks.Task<object> AsTaskException(this System.Exception ex) => throw null;
        public static System.Threading.Tasks.Task<T> AsTaskException<T>(this System.Exception ex) => throw null;
        public static System.Threading.Tasks.Task<T> AsTaskResult<T>(this T result) => throw null;
        public static System.Threading.Tasks.ValueTask AsValueTask(this System.Threading.Tasks.Task task) => throw null;
        public static System.Threading.Tasks.ValueTask<T> AsValueTask<T>(this System.Threading.Tasks.Task<T> task) => throw null;
        public static object GetResult(this System.Threading.Tasks.Task task) => throw null;
        public static T GetResult<T>(this System.Threading.Tasks.Task<T> task) => throw null;
        public static void RunSync(System.Func<System.Threading.Tasks.Task> task) => throw null;
        public static TResult RunSync<TResult>(System.Func<System.Threading.Tasks.Task<TResult>> task) => throw null;
        public static void Wait(this System.Threading.Tasks.ValueTask task) => throw null;
    }
    public class TextDumpOptions
    {
        public string Caption { get => throw null; set { } }
        public string CaptionIfEmpty { get => throw null; set { } }
        public TextDumpOptions() => throw null;
        public ServiceStack.Script.DefaultScripts Defaults { get => throw null; set { } }
        public string[] Headers { get => throw null; set { } }
        public ServiceStack.TextStyle HeaderStyle { get => throw null; set { } }
        public bool IncludeRowNumbers { get => throw null; set { } }
        public static ServiceStack.TextDumpOptions Parse(System.Collections.Generic.Dictionary<string, object> options, ServiceStack.Script.DefaultScripts defaults = default(ServiceStack.Script.DefaultScripts)) => throw null;
    }
    public class TextNode
    {
        public System.Collections.Generic.List<ServiceStack.TextNode> Children { get => throw null; set { } }
        public TextNode() => throw null;
        public string Text { get => throw null; set { } }
    }
    public enum TextStyle
    {
        None = 0,
        SplitCase = 1,
        Humanize = 2,
        TitleCase = 3,
        PascalCase = 4,
        CamelCase = 5,
    }
    public static partial class TypeExtensions
    {
        public static void AddReferencedTypes(System.Type type, System.Collections.Generic.HashSet<System.Type> refTypes) => throw null;
        public static T ConvertFromObject<T>(object value) => throw null;
        public static object ConvertToObject<T>(T value) => throw null;
        public static System.Linq.Expressions.LambdaExpression CreatePropertyAccessorExpression(System.Type type, System.Reflection.PropertyInfo forProperty) => throw null;
        public static ServiceStack.ActionInvoker GetActionInvoker(this System.Reflection.MethodInfo method) => throw null;
        public static ServiceStack.ActionInvoker GetActionInvokerToCache(System.Reflection.MethodInfo method) => throw null;
        public static ServiceStack.ObjectActivator GetActivator(this System.Reflection.ConstructorInfo ctor) => throw null;
        public static ServiceStack.ObjectActivator GetActivatorToCache(System.Reflection.ConstructorInfo ctor) => throw null;
        public static ServiceStack.MethodInvoker GetInvoker(this System.Reflection.MethodInfo method) => throw null;
        public static System.Delegate GetInvokerDelegate(this System.Reflection.MethodInfo method) => throw null;
        public static ServiceStack.MethodInvoker GetInvokerToCache(System.Reflection.MethodInfo method) => throw null;
        public static System.Func<object, object> GetPropertyAccessor(this System.Type type, System.Reflection.PropertyInfo forProperty) => throw null;
        public static System.Type[] GetReferencedTypes(this System.Type type) => throw null;
        public static ServiceStack.StaticActionInvoker GetStaticActionInvoker(this System.Reflection.MethodInfo method) => throw null;
        public static ServiceStack.StaticActionInvoker GetStaticActionInvokerToCache(System.Reflection.MethodInfo method) => throw null;
        public static ServiceStack.StaticMethodInvoker GetStaticInvoker(this System.Reflection.MethodInfo method) => throw null;
        public static ServiceStack.StaticMethodInvoker GetStaticInvokerToCache(System.Reflection.MethodInfo method) => throw null;
    }
    public class UrnId
    {
        public static string Create(string objectTypeName, string idFieldValue) => throw null;
        public static string Create<T>(string idFieldValue) => throw null;
        public static string Create<T>(object idFieldValue) => throw null;
        public static string Create(System.Type objectType, string idFieldValue) => throw null;
        public static string Create<T>(string idFieldName, string idFieldValue) => throw null;
        public static string Create(System.Type objectType, string idFieldName, string idFieldValue) => throw null;
        public static string CreateWithParts(string objectTypeName, params string[] keyParts) => throw null;
        public static string CreateWithParts<T>(params string[] keyParts) => throw null;
        public static System.Guid GetGuidId(string urn) => throw null;
        public static long GetLongId(string urn) => throw null;
        public static string GetStringId(string urn) => throw null;
        public string IdFieldName { get => throw null; }
        public string IdFieldValue { get => throw null; }
        public static ServiceStack.UrnId Parse(string urnId) => throw null;
        public string TypeName { get => throw null; }
    }
    public static class View
    {
        public static System.Collections.Generic.List<ServiceStack.NavItem> GetNavItems(string key) => throw null;
        public static void Load(ServiceStack.Configuration.IAppSettings settings) => throw null;
        public static System.Collections.Generic.List<ServiceStack.NavItem> NavItems { get => throw null; }
        public static System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<ServiceStack.NavItem>> NavItemsMap { get => throw null; }
    }
    public static class ViewUtils
    {
        public static string BundleCss(string filterName, ServiceStack.IO.IVirtualPathProvider webVfs, ServiceStack.IO.IVirtualPathProvider contentVfs, ServiceStack.ICompressor cssCompressor, ServiceStack.BundleOptions options) => throw null;
        public static string BundleHtml(string filterName, ServiceStack.IO.IVirtualPathProvider webVfs, ServiceStack.IO.IVirtualPathProvider contentVfs, ServiceStack.ICompressor htmlCompressor, ServiceStack.BundleOptions options) => throw null;
        public static string BundleJs(string filterName, ServiceStack.IO.IVirtualPathProvider webVfs, ServiceStack.IO.IVirtualPathProvider contentVfs, ServiceStack.ICompressor jsCompressor, ServiceStack.BundleOptions options) => throw null;
        public static string CssIncludes(ServiceStack.IO.IVirtualPathProvider vfs, System.Collections.Generic.List<string> cssFiles) => throw null;
        public static string DumpTable(this object target) => throw null;
        public static string DumpTable(this object target, ServiceStack.TextDumpOptions options) => throw null;
        public static string ErrorResponse(ServiceStack.ResponseStatus errorStatus, string fieldName) => throw null;
        public static string ErrorResponseExcept(ServiceStack.ResponseStatus errorStatus, string fieldNames) => throw null;
        public static string ErrorResponseExcept(ServiceStack.ResponseStatus errorStatus, System.Collections.Generic.ICollection<string> fieldNames) => throw null;
        public static string ErrorResponseSummary(ServiceStack.ResponseStatus errorStatus) => throw null;
        public static bool FormCheckValue(ServiceStack.Web.IRequest req, string name) => throw null;
        public static string FormControl(ServiceStack.Web.IRequest req, System.Collections.Generic.Dictionary<string, object> args, string tagName, ServiceStack.InputOptions inputOptions) => throw null;
        public static string FormQuery(ServiceStack.Web.IRequest req, string name) => throw null;
        public static string[] FormQueryValues(ServiceStack.Web.IRequest req, string name) => throw null;
        public static string FormValue(ServiceStack.Web.IRequest req, string name) => throw null;
        public static string FormValue(ServiceStack.Web.IRequest req, string name, string defaultValue) => throw null;
        public static string[] FormValues(ServiceStack.Web.IRequest req, string name) => throw null;
        public static System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> GetBundleFiles(string filterName, ServiceStack.IO.IVirtualPathProvider webVfs, ServiceStack.IO.IVirtualPathProvider contentVfs, System.Collections.Generic.IEnumerable<string> virtualPaths, string assetExt) => throw null;
        public static System.Globalization.CultureInfo GetDefaultCulture(this ServiceStack.Script.DefaultScripts defaultScripts) => throw null;
        public static string GetDefaultTableClassName(this ServiceStack.Script.DefaultScripts defaultScripts) => throw null;
        public static ServiceStack.ResponseStatus GetErrorStatus(ServiceStack.Web.IRequest req) => throw null;
        public static System.Collections.Generic.List<ServiceStack.NavItem> GetNavItems(string key) => throw null;
        public static string GetParam(ServiceStack.Web.IRequest req, string name) => throw null;
        public static bool HasErrorStatus(ServiceStack.Web.IRequest req) => throw null;
        public static string HtmlDump(object target) => throw null;
        public static string HtmlDump(object target, ServiceStack.HtmlDumpOptions options) => throw null;
        public static string HtmlHiddenInputs(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>> inputValues) => throw null;
        public static bool IsNull(object test) => throw null;
        public static string JsIncludes(ServiceStack.IO.IVirtualPathProvider vfs, System.Collections.Generic.List<string> jsFiles) => throw null;
        public static void Load(ServiceStack.Configuration.IAppSettings settings) => throw null;
        public static string Nav(System.Collections.Generic.List<ServiceStack.NavItem> navItems, ServiceStack.NavOptions options) => throw null;
        public static string NavButtonGroup(System.Collections.Generic.List<ServiceStack.NavItem> navItems, ServiceStack.NavOptions options) => throw null;
        public static string NavButtonGroup(ServiceStack.NavItem navItem, ServiceStack.NavOptions options) => throw null;
        public static System.Collections.Generic.List<ServiceStack.NavItem> NavItems { get => throw null; }
        public static string NavItemsKey { get => throw null; set { } }
        public static System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<ServiceStack.NavItem>> NavItemsMap { get => throw null; }
        public static string NavItemsMapKey { get => throw null; set { } }
        public static string NavLink(ServiceStack.NavItem navItem, ServiceStack.NavOptions options) => throw null;
        public static void NavLink(System.Text.StringBuilder sb, ServiceStack.NavItem navItem, ServiceStack.NavOptions options) => throw null;
        public static void NavLinkButton(System.Text.StringBuilder sb, ServiceStack.NavItem navItem, ServiceStack.NavOptions options) => throw null;
        public static void PrintDumpTable(this object target) => throw null;
        public static void PrintDumpTable(this object target, ServiceStack.TextDumpOptions options) => throw null;
        public static bool ShowNav(this ServiceStack.NavItem navItem, System.Collections.Generic.HashSet<string> attributes) => throw null;
        public static System.Collections.Generic.List<string> SplitStringList(System.Collections.IEnumerable strings) => throw null;
        public static string StyleText(string text, ServiceStack.TextStyle textStyle) => throw null;
        public static string TextDump(this object target) => throw null;
        public static string TextDump(this object target, ServiceStack.TextDumpOptions options) => throw null;
        public static System.Collections.Generic.List<System.Collections.Generic.KeyValuePair<string, string>> ToKeyValues(object values) => throw null;
        public static System.Collections.Generic.List<string> ToStringList(System.Collections.IEnumerable strings) => throw null;
        public static System.Collections.Generic.IEnumerable<string> ToStrings(string filterName, object arg) => throw null;
        public static System.Collections.Generic.List<string> ToVarNames(string fieldNames) => throw null;
        public static string ValidationSuccess(string message, System.Collections.Generic.Dictionary<string, object> divAttrs) => throw null;
        public static string ValidationSuccessCssClassNames;
        public static string ValidationSummary(ServiceStack.ResponseStatus errorStatus, string exceptFor) => throw null;
        public static string ValidationSummary(ServiceStack.ResponseStatus errorStatus, System.Collections.Generic.ICollection<string> exceptFields, System.Collections.Generic.Dictionary<string, object> divAttrs) => throw null;
        public static string ValidationSummaryCssClassNames;
    }
    public static partial class VirtualFileExtensions
    {
        public static ServiceStack.IO.IVirtualFile AssertFile(this ServiceStack.IO.IVirtualPathProvider vfs, string path) => throw null;
        public static ServiceStack.IO.IVirtualDirectory[] GetAllRootDirectories(this ServiceStack.IO.IVirtualPathProvider vfs) => throw null;
        public static byte[] GetBytesContentsAsBytes(this ServiceStack.IO.IVirtualFile file) => throw null;
        public static System.ReadOnlyMemory<byte> GetBytesContentsAsMemory(this ServiceStack.IO.IVirtualFile file) => throw null;
        public static ServiceStack.IO.FileSystemVirtualFiles GetFileSystemVirtualFiles(this ServiceStack.IO.IVirtualPathProvider vfs) => throw null;
        public static ServiceStack.IO.GistVirtualFiles GetGistVirtualFiles(this ServiceStack.IO.IVirtualPathProvider vfs) => throw null;
        public static ServiceStack.IO.MemoryVirtualFiles GetMemoryVirtualFiles(this ServiceStack.IO.IVirtualPathProvider vfs) => throw null;
        public static ServiceStack.IO.ResourceVirtualFiles GetResourceVirtualFiles(this ServiceStack.IO.IVirtualPathProvider vfs) => throw null;
        public static System.ReadOnlyMemory<char> GetTextContentsAsMemory(this ServiceStack.IO.IVirtualFile file) => throw null;
        public static T GetVirtualFileSource<T>(this ServiceStack.IO.IVirtualPathProvider vfs) where T : class => throw null;
        public static System.ReadOnlyMemory<byte> ReadAllBytesAsMemory(this ServiceStack.IO.IVirtualFile file) => throw null;
        public static System.ReadOnlyMemory<char> ReadAllTextAsMemory(this ServiceStack.IO.IVirtualFile file) => throw null;
        public static bool ShouldSkipPath(this ServiceStack.IO.IVirtualNode node) => throw null;
    }
    namespace VirtualPath
    {
        public abstract class AbstractVirtualDirectoryBase : System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualNode>, System.Collections.IEnumerable, ServiceStack.IO.IVirtualDirectory, ServiceStack.IO.IVirtualNode
        {
            protected AbstractVirtualDirectoryBase(ServiceStack.IO.IVirtualPathProvider owningProvider) => throw null;
            protected AbstractVirtualDirectoryBase(ServiceStack.IO.IVirtualPathProvider owningProvider, ServiceStack.IO.IVirtualDirectory parentDirectory) => throw null;
            public abstract System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualDirectory> Directories { get; }
            public ServiceStack.IO.IVirtualDirectory Directory { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public abstract System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> Files { get; }
            public virtual System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> GetAllMatchingFiles(string globPattern, int maxDepth = default(int)) => throw null;
            public virtual ServiceStack.IO.IVirtualDirectory GetDirectory(string virtualPath) => throw null;
            public virtual ServiceStack.IO.IVirtualDirectory GetDirectory(System.Collections.Generic.Stack<string> virtualPath) => throw null;
            protected abstract ServiceStack.IO.IVirtualDirectory GetDirectoryFromBackingDirectoryOrDefault(string directoryName);
            System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            public abstract System.Collections.Generic.IEnumerator<ServiceStack.IO.IVirtualNode> GetEnumerator();
            public virtual ServiceStack.IO.IVirtualFile GetFile(string virtualPath) => throw null;
            public virtual ServiceStack.IO.IVirtualFile GetFile(System.Collections.Generic.Stack<string> virtualPath) => throw null;
            protected abstract ServiceStack.IO.IVirtualFile GetFileFromBackingDirectoryOrDefault(string fileName);
            public override int GetHashCode() => throw null;
            protected abstract System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> GetMatchingFilesInDir(string globPattern);
            protected virtual string GetPathToRoot(string separator, System.Func<ServiceStack.IO.IVirtualDirectory, string> pathSel) => throw null;
            protected virtual string GetRealPathToRoot() => throw null;
            protected virtual string GetVirtualPathToRoot() => throw null;
            public virtual bool IsDirectory { get => throw null; }
            public virtual bool IsRoot { get => throw null; }
            public abstract System.DateTime LastModified { get; }
            public abstract string Name { get; }
            public ServiceStack.IO.IVirtualDirectory ParentDirectory { get => throw null; set { } }
            public virtual string RealPath { get => throw null; }
            public override string ToString() => throw null;
            public virtual string VirtualPath { get => throw null; }
            protected ServiceStack.IO.IVirtualPathProvider VirtualPathProvider;
        }
        public abstract class AbstractVirtualFileBase : ServiceStack.IO.IVirtualFile, ServiceStack.IO.IVirtualNode
        {
            protected AbstractVirtualFileBase(ServiceStack.IO.IVirtualPathProvider owningProvider, ServiceStack.IO.IVirtualDirectory directory) => throw null;
            public ServiceStack.IO.IVirtualDirectory Directory { get => throw null; set { } }
            public override bool Equals(object obj) => throw null;
            public virtual string Extension { get => throw null; }
            public virtual object GetContents() => throw null;
            public virtual string GetFileHash() => throw null;
            public override int GetHashCode() => throw null;
            protected virtual string GetPathToRoot(string separator, System.Func<ServiceStack.IO.IVirtualDirectory, string> pathSel) => throw null;
            protected virtual string GetRealPathToRoot() => throw null;
            protected virtual string GetVirtualPathToRoot() => throw null;
            public virtual bool IsDirectory { get => throw null; }
            public abstract System.DateTime LastModified { get; }
            public abstract long Length { get; }
            public abstract string Name { get; }
            public abstract System.IO.Stream OpenRead();
            public virtual System.IO.StreamReader OpenText() => throw null;
            public virtual byte[] ReadAllBytes() => throw null;
            public virtual System.Threading.Tasks.Task<byte[]> ReadAllBytesAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public virtual string ReadAllText() => throw null;
            public virtual System.Threading.Tasks.Task<string> ReadAllTextAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public virtual string RealPath { get => throw null; }
            public virtual void Refresh() => throw null;
            public static System.Collections.Generic.List<string> ScanSkipPaths { get => throw null; set { } }
            public override string ToString() => throw null;
            public virtual string VirtualPath { get => throw null; }
            public ServiceStack.IO.IVirtualPathProvider VirtualPathProvider { get => throw null; set { } }
            public virtual System.Threading.Tasks.Task WritePartialToAsync(System.IO.Stream toStream, long start, long end, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        }
        public abstract class AbstractVirtualPathProviderBase : ServiceStack.IO.IVirtualPathProvider
        {
            public virtual void AppendFile(string path, System.ReadOnlyMemory<char> text) => throw null;
            public virtual void AppendFile(string path, System.ReadOnlyMemory<byte> bytes) => throw null;
            public virtual void AppendFile(string path, object contents) => throw null;
            protected ServiceStack.IO.IVirtualFiles AssertVirtualFiles() => throw null;
            public virtual string CombineVirtualPath(string basePath, string relativePath) => throw null;
            protected System.NotSupportedException CreateContentNotSupportedException(object value) => throw null;
            protected AbstractVirtualPathProviderBase() => throw null;
            public virtual bool DirectoryExists(string virtualPath) => throw null;
            public virtual bool FileExists(string virtualPath) => throw null;
            public virtual System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> GetAllFiles() => throw null;
            public virtual System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> GetAllMatchingFiles(string globPattern, int maxDepth = default(int)) => throw null;
            public virtual ServiceStack.IO.IVirtualDirectory GetDirectory(string virtualPath) => throw null;
            public virtual ServiceStack.IO.IVirtualFile GetFile(string virtualPath) => throw null;
            public virtual string GetFileHash(string virtualPath) => throw null;
            public virtual string GetFileHash(ServiceStack.IO.IVirtualFile virtualFile) => throw null;
            public virtual System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualDirectory> GetRootDirectories() => throw null;
            public virtual System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> GetRootFiles() => throw null;
            protected abstract void Initialize();
            public virtual bool IsSharedFile(ServiceStack.IO.IVirtualFile virtualFile) => throw null;
            public virtual bool IsViewFile(ServiceStack.IO.IVirtualFile virtualFile) => throw null;
            public abstract string RealPathSeparator { get; }
            public abstract ServiceStack.IO.IVirtualDirectory RootDirectory { get; }
            public virtual string SanitizePath(string filePath) => throw null;
            public override string ToString() => throw null;
            public abstract string VirtualPathSeparator { get; }
            public virtual void WriteFile(string path, System.ReadOnlyMemory<char> text) => throw null;
            public virtual void WriteFile(string path, System.ReadOnlyMemory<byte> bytes) => throw null;
            public virtual void WriteFile(string path, object contents) => throw null;
            public virtual System.Threading.Tasks.Task WriteFileAsync(string path, object contents, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public virtual void WriteFiles(System.Collections.Generic.Dictionary<string, string> textFiles) => throw null;
            public virtual void WriteFiles(System.Collections.Generic.Dictionary<string, object> files) => throw null;
        }
        public class FileSystemMapping : ServiceStack.VirtualPath.AbstractVirtualPathProviderBase
        {
            public string Alias { get => throw null; }
            public FileSystemMapping(string alias, string rootDirectoryPath) => throw null;
            public FileSystemMapping(string alias, System.IO.DirectoryInfo rootDirInfo) => throw null;
            public override ServiceStack.IO.IVirtualDirectory GetDirectory(string virtualPath) => throw null;
            public override ServiceStack.IO.IVirtualFile GetFile(string virtualPath) => throw null;
            public string GetRealVirtualPath(string virtualPath) => throw null;
            public override System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualDirectory> GetRootDirectories() => throw null;
            public override System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> GetRootFiles() => throw null;
            protected override sealed void Initialize() => throw null;
            public override string RealPathSeparator { get => throw null; }
            protected ServiceStack.VirtualPath.FileSystemVirtualDirectory RootDir;
            public override ServiceStack.IO.IVirtualDirectory RootDirectory { get => throw null; }
            protected readonly System.IO.DirectoryInfo RootDirInfo;
            public override string VirtualPathSeparator { get => throw null; }
        }
        public class FileSystemVirtualDirectory : ServiceStack.VirtualPath.AbstractVirtualDirectoryBase
        {
            protected System.IO.DirectoryInfo BackingDirInfo;
            public FileSystemVirtualDirectory(ServiceStack.IO.IVirtualPathProvider owningProvider, ServiceStack.IO.IVirtualDirectory parentDirectory, System.IO.DirectoryInfo dInfo) : base(default(ServiceStack.IO.IVirtualPathProvider)) => throw null;
            public override System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualDirectory> Directories { get => throw null; }
            public System.Collections.Generic.IEnumerable<System.IO.DirectoryInfo> EnumerateDirectories(string dirName) => throw null;
            public System.Collections.Generic.IEnumerable<System.IO.FileInfo> EnumerateFiles(string pattern) => throw null;
            public override System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> Files { get => throw null; }
            protected override ServiceStack.IO.IVirtualDirectory GetDirectoryFromBackingDirectoryOrDefault(string dName) => throw null;
            public override System.Collections.Generic.IEnumerator<ServiceStack.IO.IVirtualNode> GetEnumerator() => throw null;
            protected override ServiceStack.IO.IVirtualFile GetFileFromBackingDirectoryOrDefault(string fName) => throw null;
            protected override System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> GetMatchingFilesInDir(string globPattern) => throw null;
            public override System.DateTime LastModified { get => throw null; }
            public override string Name { get => throw null; }
            public override string RealPath { get => throw null; }
        }
        public class FileSystemVirtualFile : ServiceStack.VirtualPath.AbstractVirtualFileBase
        {
            protected System.IO.FileInfo BackingFile;
            public FileSystemVirtualFile(ServiceStack.IO.IVirtualPathProvider owningProvider, ServiceStack.IO.IVirtualDirectory directory, System.IO.FileInfo fInfo) : base(default(ServiceStack.IO.IVirtualPathProvider), default(ServiceStack.IO.IVirtualDirectory)) => throw null;
            public override System.DateTime LastModified { get => throw null; }
            public override long Length { get => throw null; }
            public override string Name { get => throw null; }
            public override System.IO.Stream OpenRead() => throw null;
            public override string RealPath { get => throw null; }
            public override void Refresh() => throw null;
        }
        public class ResourceVirtualDirectory : ServiceStack.VirtualPath.AbstractVirtualDirectoryBase
        {
            protected System.Reflection.Assembly backingAssembly;
            protected virtual ServiceStack.VirtualPath.ResourceVirtualDirectory ConsumeTokensForVirtualDir(System.Collections.Generic.Stack<string> resourceTokens) => throw null;
            protected virtual ServiceStack.VirtualPath.ResourceVirtualDirectory CreateVirtualDirectory(System.Linq.IGrouping<string, string[]> subResources) => throw null;
            protected virtual ServiceStack.VirtualPath.ResourceVirtualFile CreateVirtualFile(string resourceName) => throw null;
            public ResourceVirtualDirectory(ServiceStack.IO.IVirtualPathProvider owningProvider, ServiceStack.IO.IVirtualDirectory parentDir, System.Reflection.Assembly backingAsm, System.DateTime lastModified, string rootNamespace) : base(default(ServiceStack.IO.IVirtualPathProvider)) => throw null;
            public ResourceVirtualDirectory(ServiceStack.IO.IVirtualPathProvider owningProvider, ServiceStack.IO.IVirtualDirectory parentDir, System.Reflection.Assembly backingAsm, System.DateTime lastModified, string rootNamespace, string directoryName, System.Collections.Generic.List<string> manifestResourceNames) : base(default(ServiceStack.IO.IVirtualPathProvider)) => throw null;
            public override System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualDirectory> Directories { get => throw null; }
            public string DirectoryName { get => throw null; set { } }
            public static System.Collections.Generic.HashSet<string> EmbeddedResourceTreatAsFiles { get => throw null; set { } }
            public override System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> Files { get => throw null; }
            protected override ServiceStack.IO.IVirtualDirectory GetDirectoryFromBackingDirectoryOrDefault(string directoryName) => throw null;
            public override System.Collections.Generic.IEnumerator<ServiceStack.IO.IVirtualNode> GetEnumerator() => throw null;
            protected override ServiceStack.IO.IVirtualFile GetFileFromBackingDirectoryOrDefault(string fileName) => throw null;
            protected override System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> GetMatchingFilesInDir(string globPattern) => throw null;
            protected override string GetRealPathToRoot() => throw null;
            public static System.Collections.Generic.List<string> GetResourceNames(System.Reflection.Assembly asm, string basePath) => throw null;
            protected void InitializeDirectoryStructure(System.Collections.Generic.List<string> manifestResourceNames) => throw null;
            public override System.DateTime LastModified { get => throw null; }
            public override string Name { get => throw null; }
            public string rootNamespace { get => throw null; set { } }
            protected System.Collections.Generic.List<ServiceStack.VirtualPath.ResourceVirtualDirectory> SubDirectories;
            protected System.Collections.Generic.List<ServiceStack.VirtualPath.ResourceVirtualFile> SubFiles;
            public string TranslatePath(string path) => throw null;
        }
        public class ResourceVirtualFile : ServiceStack.VirtualPath.AbstractVirtualFileBase
        {
            protected readonly System.Reflection.Assembly BackingAssembly;
            public ResourceVirtualFile(ServiceStack.IO.IVirtualPathProvider owningProvider, ServiceStack.VirtualPath.ResourceVirtualDirectory directory, string fileName) : base(default(ServiceStack.IO.IVirtualPathProvider), default(ServiceStack.IO.IVirtualDirectory)) => throw null;
            protected readonly string FileName;
            public override System.DateTime LastModified { get => throw null; }
            public override long Length { get => throw null; }
            public override string Name { get => throw null; }
            public override System.IO.Stream OpenRead() => throw null;
            public override string RealPath { get => throw null; }
            public override string VirtualPath { get => throw null; }
        }
    }
    public static class VirtualPathUtils
    {
        public static bool Exists(this ServiceStack.IO.IVirtualNode node) => throw null;
        public static ServiceStack.IO.IVirtualFile GetDefaultDocument(this ServiceStack.IO.IVirtualDirectory dir, System.Collections.Generic.List<string> defaultDocuments) => throw null;
        public static ServiceStack.IO.IVirtualNode GetVirtualNode(this ServiceStack.IO.IVirtualPathProvider pathProvider, string virtualPath) => throw null;
        public static System.Collections.Generic.IEnumerable<System.Linq.IGrouping<string, string[]>> GroupByFirstToken(this System.Collections.Generic.IEnumerable<string> resourceNames, char pathSeparator = default(char)) => throw null;
        public static bool IsDirectory(this ServiceStack.IO.IVirtualNode node) => throw null;
        public static bool IsFile(this ServiceStack.IO.IVirtualNode node) => throw null;
        public static bool IsValidFileName(string path) => throw null;
        public static bool IsValidFilePath(string path) => throw null;
        public static System.TimeSpan MaxRetryOnExceptionTimeout { get => throw null; }
        public static byte[] ReadAllBytes(this ServiceStack.IO.IVirtualFile file) => throw null;
        public static string SafeFileName(string uri) => throw null;
        public static System.Collections.Generic.Stack<string> TokenizeResourcePath(this string str, char pathSeparator = default(char)) => throw null;
        public static System.Collections.Generic.Stack<string> TokenizeVirtualPath(this string str, ServiceStack.IO.IVirtualPathProvider pathProvider) => throw null;
        public static System.Collections.Generic.Stack<string> TokenizeVirtualPath(this string str, string virtualPathSeparator) => throw null;
    }
    public static class When
    {
        public static string Development { get => throw null; }
        public static string HasClaim(string claim) => throw null;
        public static string HasPermission(string perm) => throw null;
        public static string HasRole(string role) => throw null;
        public static string HasScope(string scope) => throw null;
        public static string IsAuthenticated { get => throw null; }
        public static string Production { get => throw null; }
    }
    public static partial class XLinqExtensions
    {
        public static System.Collections.Generic.IEnumerable<System.Xml.Linq.XElement> AllElements(this System.Xml.Linq.XElement element, string name) => throw null;
        public static System.Collections.Generic.IEnumerable<System.Xml.Linq.XElement> AllElements(this System.Collections.Generic.IEnumerable<System.Xml.Linq.XElement> elements, string name) => throw null;
        public static System.Xml.Linq.XAttribute AnyAttribute(this System.Xml.Linq.XElement element, string name) => throw null;
        public static System.Xml.Linq.XElement AnyElement(this System.Xml.Linq.XElement element, string name) => throw null;
        public static System.Xml.Linq.XElement AnyElement(this System.Collections.Generic.IEnumerable<System.Xml.Linq.XElement> elements, string name) => throw null;
        public static void AssertElementHasValue(this System.Xml.Linq.XElement element, string name) => throw null;
        public static System.Xml.Linq.XElement FirstElement(this System.Xml.Linq.XElement element) => throw null;
        public static T GetAttributeValueOrDefault<T>(this System.Xml.Linq.XAttribute attr, string name, System.Func<System.Xml.Linq.XAttribute, T> converter) => throw null;
        public static bool GetBool(this System.Xml.Linq.XElement el, string name) => throw null;
        public static bool GetBoolOrDefault(this System.Xml.Linq.XElement el, string name) => throw null;
        public static System.DateTime GetDateTime(this System.Xml.Linq.XElement el, string name) => throw null;
        public static System.DateTime GetDateTimeOrDefault(this System.Xml.Linq.XElement el, string name) => throw null;
        public static decimal GetDecimal(this System.Xml.Linq.XElement el, string name) => throw null;
        public static decimal GetDecimalOrDefault(this System.Xml.Linq.XElement el, string name) => throw null;
        public static System.Xml.Linq.XElement GetElement(this System.Xml.Linq.XElement element, string name) => throw null;
        public static T GetElementValueOrDefault<T>(this System.Xml.Linq.XElement element, string name, System.Func<System.Xml.Linq.XElement, T> converter) => throw null;
        public static System.Guid GetGuid(this System.Xml.Linq.XElement el, string name) => throw null;
        public static System.Guid GetGuidOrDefault(this System.Xml.Linq.XElement el, string name) => throw null;
        public static int GetInt(this System.Xml.Linq.XElement el, string name) => throw null;
        public static int GetIntOrDefault(this System.Xml.Linq.XElement el, string name) => throw null;
        public static long GetLong(this System.Xml.Linq.XElement el, string name) => throw null;
        public static long GetLongOrDefault(this System.Xml.Linq.XElement el, string name) => throw null;
        public static bool? GetNullableBool(this System.Xml.Linq.XElement el, string name) => throw null;
        public static System.DateTime? GetNullableDateTime(this System.Xml.Linq.XElement el, string name) => throw null;
        public static decimal? GetNullableDecimal(this System.Xml.Linq.XElement el, string name) => throw null;
        public static System.Guid? GetNullableGuid(this System.Xml.Linq.XElement el, string name) => throw null;
        public static int? GetNullableInt(this System.Xml.Linq.XElement el, string name) => throw null;
        public static long? GetNullableLong(this System.Xml.Linq.XElement el, string name) => throw null;
        public static System.TimeSpan? GetNullableTimeSpan(this System.Xml.Linq.XElement el, string name) => throw null;
        public static string GetString(this System.Xml.Linq.XElement el, string name) => throw null;
        public static string GetStringAttributeOrDefault(this System.Xml.Linq.XElement element, string name) => throw null;
        public static System.TimeSpan GetTimeSpan(this System.Xml.Linq.XElement el, string name) => throw null;
        public static System.TimeSpan GetTimeSpanOrDefault(this System.Xml.Linq.XElement el, string name) => throw null;
        public static System.Collections.Generic.List<string> GetValues(this System.Collections.Generic.IEnumerable<System.Xml.Linq.XElement> els) => throw null;
        public static System.Xml.Linq.XElement NextElement(this System.Xml.Linq.XElement element) => throw null;
    }
}
