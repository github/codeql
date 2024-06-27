// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.SignalR.Core, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace SignalR
        {
            public static partial class ClientProxyExtensions
            {
                public static System.Threading.Tasks.Task<T> InvokeAsync<T>(this Microsoft.AspNetCore.SignalR.ISingleClientProxy clientProxy, string method, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<T> InvokeAsync<T>(this Microsoft.AspNetCore.SignalR.ISingleClientProxy clientProxy, string method, object arg1, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<T> InvokeAsync<T>(this Microsoft.AspNetCore.SignalR.ISingleClientProxy clientProxy, string method, object arg1, object arg2, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<T> InvokeAsync<T>(this Microsoft.AspNetCore.SignalR.ISingleClientProxy clientProxy, string method, object arg1, object arg2, object arg3, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<T> InvokeAsync<T>(this Microsoft.AspNetCore.SignalR.ISingleClientProxy clientProxy, string method, object arg1, object arg2, object arg3, object arg4, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<T> InvokeAsync<T>(this Microsoft.AspNetCore.SignalR.ISingleClientProxy clientProxy, string method, object arg1, object arg2, object arg3, object arg4, object arg5, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<T> InvokeAsync<T>(this Microsoft.AspNetCore.SignalR.ISingleClientProxy clientProxy, string method, object arg1, object arg2, object arg3, object arg4, object arg5, object arg6, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<T> InvokeAsync<T>(this Microsoft.AspNetCore.SignalR.ISingleClientProxy clientProxy, string method, object arg1, object arg2, object arg3, object arg4, object arg5, object arg6, object arg7, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<T> InvokeAsync<T>(this Microsoft.AspNetCore.SignalR.ISingleClientProxy clientProxy, string method, object arg1, object arg2, object arg3, object arg4, object arg5, object arg6, object arg7, object arg8, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<T> InvokeAsync<T>(this Microsoft.AspNetCore.SignalR.ISingleClientProxy clientProxy, string method, object arg1, object arg2, object arg3, object arg4, object arg5, object arg6, object arg7, object arg8, object arg9, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<T> InvokeAsync<T>(this Microsoft.AspNetCore.SignalR.ISingleClientProxy clientProxy, string method, object arg1, object arg2, object arg3, object arg4, object arg5, object arg6, object arg7, object arg8, object arg9, object arg10, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task SendAsync(this Microsoft.AspNetCore.SignalR.IClientProxy clientProxy, string method, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task SendAsync(this Microsoft.AspNetCore.SignalR.IClientProxy clientProxy, string method, object arg1, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task SendAsync(this Microsoft.AspNetCore.SignalR.IClientProxy clientProxy, string method, object arg1, object arg2, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task SendAsync(this Microsoft.AspNetCore.SignalR.IClientProxy clientProxy, string method, object arg1, object arg2, object arg3, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task SendAsync(this Microsoft.AspNetCore.SignalR.IClientProxy clientProxy, string method, object arg1, object arg2, object arg3, object arg4, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task SendAsync(this Microsoft.AspNetCore.SignalR.IClientProxy clientProxy, string method, object arg1, object arg2, object arg3, object arg4, object arg5, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task SendAsync(this Microsoft.AspNetCore.SignalR.IClientProxy clientProxy, string method, object arg1, object arg2, object arg3, object arg4, object arg5, object arg6, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task SendAsync(this Microsoft.AspNetCore.SignalR.IClientProxy clientProxy, string method, object arg1, object arg2, object arg3, object arg4, object arg5, object arg6, object arg7, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task SendAsync(this Microsoft.AspNetCore.SignalR.IClientProxy clientProxy, string method, object arg1, object arg2, object arg3, object arg4, object arg5, object arg6, object arg7, object arg8, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task SendAsync(this Microsoft.AspNetCore.SignalR.IClientProxy clientProxy, string method, object arg1, object arg2, object arg3, object arg4, object arg5, object arg6, object arg7, object arg8, object arg9, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task SendAsync(this Microsoft.AspNetCore.SignalR.IClientProxy clientProxy, string method, object arg1, object arg2, object arg3, object arg4, object arg5, object arg6, object arg7, object arg8, object arg9, object arg10, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }
            public class DefaultHubLifetimeManager<THub> : Microsoft.AspNetCore.SignalR.HubLifetimeManager<THub> where THub : Microsoft.AspNetCore.SignalR.Hub
            {
                public override System.Threading.Tasks.Task AddToGroupAsync(string connectionId, string groupName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public DefaultHubLifetimeManager(Microsoft.Extensions.Logging.ILogger<Microsoft.AspNetCore.SignalR.DefaultHubLifetimeManager<THub>> logger) => throw null;
                public override System.Threading.Tasks.Task<T> InvokeConnectionAsync<T>(string connectionId, string methodName, object[] args, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.Task OnConnectedAsync(Microsoft.AspNetCore.SignalR.HubConnectionContext connection) => throw null;
                public override System.Threading.Tasks.Task OnDisconnectedAsync(Microsoft.AspNetCore.SignalR.HubConnectionContext connection) => throw null;
                public override System.Threading.Tasks.Task RemoveFromGroupAsync(string connectionId, string groupName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override System.Threading.Tasks.Task SendAllAsync(string methodName, object[] args, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override System.Threading.Tasks.Task SendAllExceptAsync(string methodName, object[] args, System.Collections.Generic.IReadOnlyList<string> excludedConnectionIds, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override System.Threading.Tasks.Task SendConnectionAsync(string connectionId, string methodName, object[] args, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override System.Threading.Tasks.Task SendConnectionsAsync(System.Collections.Generic.IReadOnlyList<string> connectionIds, string methodName, object[] args, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override System.Threading.Tasks.Task SendGroupAsync(string groupName, string methodName, object[] args, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override System.Threading.Tasks.Task SendGroupExceptAsync(string groupName, string methodName, object[] args, System.Collections.Generic.IReadOnlyList<string> excludedConnectionIds, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override System.Threading.Tasks.Task SendGroupsAsync(System.Collections.Generic.IReadOnlyList<string> groupNames, string methodName, object[] args, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override System.Threading.Tasks.Task SendUserAsync(string userId, string methodName, object[] args, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override System.Threading.Tasks.Task SendUsersAsync(System.Collections.Generic.IReadOnlyList<string> userIds, string methodName, object[] args, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override System.Threading.Tasks.Task SetConnectionResultAsync(string connectionId, Microsoft.AspNetCore.SignalR.Protocol.CompletionMessage result) => throw null;
                public override bool TryGetReturnType(string invocationId, out System.Type type) => throw null;
            }
            public class DefaultUserIdProvider : Microsoft.AspNetCore.SignalR.IUserIdProvider
            {
                public DefaultUserIdProvider() => throw null;
                public virtual string GetUserId(Microsoft.AspNetCore.SignalR.HubConnectionContext connection) => throw null;
            }
            public abstract class DynamicHub : Microsoft.AspNetCore.SignalR.Hub
            {
                public Microsoft.AspNetCore.SignalR.DynamicHubClients Clients { get => throw null; set { } }
                protected DynamicHub() => throw null;
            }
            public class DynamicHubClients
            {
                public dynamic All { get => throw null; }
                public dynamic AllExcept(System.Collections.Generic.IReadOnlyList<string> excludedConnectionIds) => throw null;
                public dynamic Caller { get => throw null; }
                public dynamic Client(string connectionId) => throw null;
                public dynamic Clients(System.Collections.Generic.IReadOnlyList<string> connectionIds) => throw null;
                public DynamicHubClients(Microsoft.AspNetCore.SignalR.IHubCallerClients clients) => throw null;
                public dynamic Group(string groupName) => throw null;
                public dynamic GroupExcept(string groupName, System.Collections.Generic.IReadOnlyList<string> excludedConnectionIds) => throw null;
                public dynamic Groups(System.Collections.Generic.IReadOnlyList<string> groupNames) => throw null;
                public dynamic Others { get => throw null; }
                public dynamic OthersInGroup(string groupName) => throw null;
                public dynamic User(string userId) => throw null;
                public dynamic Users(System.Collections.Generic.IReadOnlyList<string> userIds) => throw null;
            }
            public abstract class Hub : System.IDisposable
            {
                public Microsoft.AspNetCore.SignalR.IHubCallerClients Clients { get => throw null; set { } }
                public Microsoft.AspNetCore.SignalR.HubCallerContext Context { get => throw null; set { } }
                protected Hub() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public void Dispose() => throw null;
                public Microsoft.AspNetCore.SignalR.IGroupManager Groups { get => throw null; set { } }
                public virtual System.Threading.Tasks.Task OnConnectedAsync() => throw null;
                public virtual System.Threading.Tasks.Task OnDisconnectedAsync(System.Exception exception) => throw null;
            }
            public abstract class Hub<T> : Microsoft.AspNetCore.SignalR.Hub where T : class
            {
                public Microsoft.AspNetCore.SignalR.IHubCallerClients<T> Clients { get => throw null; set { } }
                protected Hub() => throw null;
            }
            public abstract class HubCallerContext
            {
                public abstract void Abort();
                public abstract System.Threading.CancellationToken ConnectionAborted { get; }
                public abstract string ConnectionId { get; }
                protected HubCallerContext() => throw null;
                public abstract Microsoft.AspNetCore.Http.Features.IFeatureCollection Features { get; }
                public abstract System.Collections.Generic.IDictionary<object, object> Items { get; }
                public abstract System.Security.Claims.ClaimsPrincipal User { get; }
                public abstract string UserIdentifier { get; }
            }
            public static partial class HubClientsExtensions
            {
                public static T AllExcept<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string excludedConnectionId1) => throw null;
                public static T AllExcept<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string excludedConnectionId1, string excludedConnectionId2) => throw null;
                public static T AllExcept<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string excludedConnectionId1, string excludedConnectionId2, string excludedConnectionId3) => throw null;
                public static T AllExcept<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string excludedConnectionId1, string excludedConnectionId2, string excludedConnectionId3, string excludedConnectionId4) => throw null;
                public static T AllExcept<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string excludedConnectionId1, string excludedConnectionId2, string excludedConnectionId3, string excludedConnectionId4, string excludedConnectionId5) => throw null;
                public static T AllExcept<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string excludedConnectionId1, string excludedConnectionId2, string excludedConnectionId3, string excludedConnectionId4, string excludedConnectionId5, string excludedConnectionId6) => throw null;
                public static T AllExcept<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string excludedConnectionId1, string excludedConnectionId2, string excludedConnectionId3, string excludedConnectionId4, string excludedConnectionId5, string excludedConnectionId6, string excludedConnectionId7) => throw null;
                public static T AllExcept<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string excludedConnectionId1, string excludedConnectionId2, string excludedConnectionId3, string excludedConnectionId4, string excludedConnectionId5, string excludedConnectionId6, string excludedConnectionId7, string excludedConnectionId8) => throw null;
                public static T AllExcept<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, System.Collections.Generic.IEnumerable<string> excludedConnectionIds) => throw null;
                public static T Clients<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string connection1) => throw null;
                public static T Clients<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string connection1, string connection2) => throw null;
                public static T Clients<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string connection1, string connection2, string connection3) => throw null;
                public static T Clients<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string connection1, string connection2, string connection3, string connection4) => throw null;
                public static T Clients<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string connection1, string connection2, string connection3, string connection4, string connection5) => throw null;
                public static T Clients<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string connection1, string connection2, string connection3, string connection4, string connection5, string connection6) => throw null;
                public static T Clients<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string connection1, string connection2, string connection3, string connection4, string connection5, string connection6, string connection7) => throw null;
                public static T Clients<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string connection1, string connection2, string connection3, string connection4, string connection5, string connection6, string connection7, string connection8) => throw null;
                public static T Clients<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, System.Collections.Generic.IEnumerable<string> connectionIds) => throw null;
                public static T GroupExcept<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string groupName, string excludedConnectionId1) => throw null;
                public static T GroupExcept<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string groupName, string excludedConnectionId1, string excludedConnectionId2) => throw null;
                public static T GroupExcept<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string groupName, string excludedConnectionId1, string excludedConnectionId2, string excludedConnectionId3) => throw null;
                public static T GroupExcept<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string groupName, string excludedConnectionId1, string excludedConnectionId2, string excludedConnectionId3, string excludedConnectionId4) => throw null;
                public static T GroupExcept<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string groupName, string excludedConnectionId1, string excludedConnectionId2, string excludedConnectionId3, string excludedConnectionId4, string excludedConnectionId5) => throw null;
                public static T GroupExcept<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string groupName, string excludedConnectionId1, string excludedConnectionId2, string excludedConnectionId3, string excludedConnectionId4, string excludedConnectionId5, string excludedConnectionId6) => throw null;
                public static T GroupExcept<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string groupName, string excludedConnectionId1, string excludedConnectionId2, string excludedConnectionId3, string excludedConnectionId4, string excludedConnectionId5, string excludedConnectionId6, string excludedConnectionId7) => throw null;
                public static T GroupExcept<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string groupName, string excludedConnectionId1, string excludedConnectionId2, string excludedConnectionId3, string excludedConnectionId4, string excludedConnectionId5, string excludedConnectionId6, string excludedConnectionId7, string excludedConnectionId8) => throw null;
                public static T GroupExcept<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string groupName, System.Collections.Generic.IEnumerable<string> excludedConnectionIds) => throw null;
                public static T Groups<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string group1) => throw null;
                public static T Groups<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string group1, string group2) => throw null;
                public static T Groups<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string group1, string group2, string group3) => throw null;
                public static T Groups<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string group1, string group2, string group3, string group4) => throw null;
                public static T Groups<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string group1, string group2, string group3, string group4, string group5) => throw null;
                public static T Groups<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string group1, string group2, string group3, string group4, string group5, string group6) => throw null;
                public static T Groups<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string group1, string group2, string group3, string group4, string group5, string group6, string group7) => throw null;
                public static T Groups<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string group1, string group2, string group3, string group4, string group5, string group6, string group7, string group8) => throw null;
                public static T Groups<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, System.Collections.Generic.IEnumerable<string> groupNames) => throw null;
                public static T Users<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string user1) => throw null;
                public static T Users<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string user1, string user2) => throw null;
                public static T Users<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string user1, string user2, string user3) => throw null;
                public static T Users<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string user1, string user2, string user3, string user4) => throw null;
                public static T Users<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string user1, string user2, string user3, string user4, string user5) => throw null;
                public static T Users<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string user1, string user2, string user3, string user4, string user5, string user6) => throw null;
                public static T Users<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string user1, string user2, string user3, string user4, string user5, string user6, string user7) => throw null;
                public static T Users<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string user1, string user2, string user3, string user4, string user5, string user6, string user7, string user8) => throw null;
                public static T Users<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, System.Collections.Generic.IEnumerable<string> userIds) => throw null;
            }
            public class HubConnectionContext
            {
                public virtual void Abort() => throw null;
                public virtual System.Threading.CancellationToken ConnectionAborted { get => throw null; }
                public virtual string ConnectionId { get => throw null; }
                public HubConnectionContext(Microsoft.AspNetCore.Connections.ConnectionContext connectionContext, Microsoft.AspNetCore.SignalR.HubConnectionContextOptions contextOptions, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                public virtual Microsoft.AspNetCore.Http.Features.IFeatureCollection Features { get => throw null; }
                public virtual System.Collections.Generic.IDictionary<object, object> Items { get => throw null; }
                public virtual Microsoft.AspNetCore.SignalR.Protocol.IHubProtocol Protocol { get => throw null; set { } }
                public virtual System.Security.Claims.ClaimsPrincipal User { get => throw null; }
                public string UserIdentifier { get => throw null; set { } }
                public virtual System.Threading.Tasks.ValueTask WriteAsync(Microsoft.AspNetCore.SignalR.Protocol.HubMessage message, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.ValueTask WriteAsync(Microsoft.AspNetCore.SignalR.SerializedHubMessage message, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }
            public class HubConnectionContextOptions
            {
                public System.TimeSpan ClientTimeoutInterval { get => throw null; set { } }
                public HubConnectionContextOptions() => throw null;
                public System.TimeSpan KeepAliveInterval { get => throw null; set { } }
                public int MaximumParallelInvocations { get => throw null; set { } }
                public long? MaximumReceiveMessageSize { get => throw null; set { } }
                public int StreamBufferCapacity { get => throw null; set { } }
            }
            public class HubConnectionHandler<THub> : Microsoft.AspNetCore.Connections.ConnectionHandler where THub : Microsoft.AspNetCore.SignalR.Hub
            {
                public HubConnectionHandler(Microsoft.AspNetCore.SignalR.HubLifetimeManager<THub> lifetimeManager, Microsoft.AspNetCore.SignalR.IHubProtocolResolver protocolResolver, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.SignalR.HubOptions> globalHubOptions, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.SignalR.HubOptions<THub>> hubOptions, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.AspNetCore.SignalR.IUserIdProvider userIdProvider, Microsoft.Extensions.DependencyInjection.IServiceScopeFactory serviceScopeFactory) => throw null;
                public override System.Threading.Tasks.Task OnConnectedAsync(Microsoft.AspNetCore.Connections.ConnectionContext connection) => throw null;
            }
            public class HubConnectionStore
            {
                public void Add(Microsoft.AspNetCore.SignalR.HubConnectionContext connection) => throw null;
                public int Count { get => throw null; }
                public HubConnectionStore() => throw null;
                public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<Microsoft.AspNetCore.SignalR.HubConnectionContext>, System.Collections.IEnumerator
                {
                    public Enumerator(Microsoft.AspNetCore.SignalR.HubConnectionStore hubConnectionList) => throw null;
                    public Microsoft.AspNetCore.SignalR.HubConnectionContext Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    public void Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    public void Reset() => throw null;
                }
                public Microsoft.AspNetCore.SignalR.HubConnectionStore.Enumerator GetEnumerator() => throw null;
                public void Remove(Microsoft.AspNetCore.SignalR.HubConnectionContext connection) => throw null;
                public Microsoft.AspNetCore.SignalR.HubConnectionContext this[string connectionId] { get => throw null; }
            }
            public class HubInvocationContext
            {
                public Microsoft.AspNetCore.SignalR.HubCallerContext Context { get => throw null; }
                public HubInvocationContext(Microsoft.AspNetCore.SignalR.HubCallerContext context, System.IServiceProvider serviceProvider, Microsoft.AspNetCore.SignalR.Hub hub, System.Reflection.MethodInfo hubMethod, System.Collections.Generic.IReadOnlyList<object> hubMethodArguments) => throw null;
                public Microsoft.AspNetCore.SignalR.Hub Hub { get => throw null; }
                public System.Reflection.MethodInfo HubMethod { get => throw null; }
                public System.Collections.Generic.IReadOnlyList<object> HubMethodArguments { get => throw null; }
                public string HubMethodName { get => throw null; }
                public System.IServiceProvider ServiceProvider { get => throw null; }
            }
            public sealed class HubLifetimeContext
            {
                public Microsoft.AspNetCore.SignalR.HubCallerContext Context { get => throw null; }
                public HubLifetimeContext(Microsoft.AspNetCore.SignalR.HubCallerContext context, System.IServiceProvider serviceProvider, Microsoft.AspNetCore.SignalR.Hub hub) => throw null;
                public Microsoft.AspNetCore.SignalR.Hub Hub { get => throw null; }
                public System.IServiceProvider ServiceProvider { get => throw null; }
            }
            public abstract class HubLifetimeManager<THub> where THub : Microsoft.AspNetCore.SignalR.Hub
            {
                public abstract System.Threading.Tasks.Task AddToGroupAsync(string connectionId, string groupName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                protected HubLifetimeManager() => throw null;
                public virtual System.Threading.Tasks.Task<T> InvokeConnectionAsync<T>(string connectionId, string methodName, object[] args, System.Threading.CancellationToken cancellationToken) => throw null;
                public abstract System.Threading.Tasks.Task OnConnectedAsync(Microsoft.AspNetCore.SignalR.HubConnectionContext connection);
                public abstract System.Threading.Tasks.Task OnDisconnectedAsync(Microsoft.AspNetCore.SignalR.HubConnectionContext connection);
                public abstract System.Threading.Tasks.Task RemoveFromGroupAsync(string connectionId, string groupName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public abstract System.Threading.Tasks.Task SendAllAsync(string methodName, object[] args, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public abstract System.Threading.Tasks.Task SendAllExceptAsync(string methodName, object[] args, System.Collections.Generic.IReadOnlyList<string> excludedConnectionIds, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public abstract System.Threading.Tasks.Task SendConnectionAsync(string connectionId, string methodName, object[] args, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public abstract System.Threading.Tasks.Task SendConnectionsAsync(System.Collections.Generic.IReadOnlyList<string> connectionIds, string methodName, object[] args, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public abstract System.Threading.Tasks.Task SendGroupAsync(string groupName, string methodName, object[] args, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public abstract System.Threading.Tasks.Task SendGroupExceptAsync(string groupName, string methodName, object[] args, System.Collections.Generic.IReadOnlyList<string> excludedConnectionIds, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public abstract System.Threading.Tasks.Task SendGroupsAsync(System.Collections.Generic.IReadOnlyList<string> groupNames, string methodName, object[] args, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public abstract System.Threading.Tasks.Task SendUserAsync(string userId, string methodName, object[] args, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public abstract System.Threading.Tasks.Task SendUsersAsync(System.Collections.Generic.IReadOnlyList<string> userIds, string methodName, object[] args, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public virtual System.Threading.Tasks.Task SetConnectionResultAsync(string connectionId, Microsoft.AspNetCore.SignalR.Protocol.CompletionMessage result) => throw null;
                public virtual bool TryGetReturnType(string invocationId, out System.Type type) => throw null;
            }
            public class HubMetadata
            {
                public HubMetadata(System.Type hubType) => throw null;
                public System.Type HubType { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)64, AllowMultiple = false, Inherited = true)]
            public class HubMethodNameAttribute : System.Attribute
            {
                public HubMethodNameAttribute(string name) => throw null;
                public string Name { get => throw null; }
            }
            public class HubOptions
            {
                public System.TimeSpan? ClientTimeoutInterval { get => throw null; set { } }
                public HubOptions() => throw null;
                public bool DisableImplicitFromServicesParameters { get => throw null; set { } }
                public bool? EnableDetailedErrors { get => throw null; set { } }
                public System.TimeSpan? HandshakeTimeout { get => throw null; set { } }
                public System.TimeSpan? KeepAliveInterval { get => throw null; set { } }
                public int MaximumParallelInvocationsPerClient { get => throw null; set { } }
                public long? MaximumReceiveMessageSize { get => throw null; set { } }
                public long StatefulReconnectBufferSize { get => throw null; set { } }
                public int? StreamBufferCapacity { get => throw null; set { } }
                public System.Collections.Generic.IList<string> SupportedProtocols { get => throw null; set { } }
            }
            public class HubOptions<THub> : Microsoft.AspNetCore.SignalR.HubOptions where THub : Microsoft.AspNetCore.SignalR.Hub
            {
                public HubOptions() => throw null;
            }
            public static partial class HubOptionsExtensions
            {
                public static void AddFilter(this Microsoft.AspNetCore.SignalR.HubOptions options, Microsoft.AspNetCore.SignalR.IHubFilter hubFilter) => throw null;
                public static void AddFilter<TFilter>(this Microsoft.AspNetCore.SignalR.HubOptions options) where TFilter : Microsoft.AspNetCore.SignalR.IHubFilter => throw null;
                public static void AddFilter(this Microsoft.AspNetCore.SignalR.HubOptions options, System.Type filterType) => throw null;
            }
            public class HubOptionsSetup : Microsoft.Extensions.Options.IConfigureOptions<Microsoft.AspNetCore.SignalR.HubOptions>
            {
                public void Configure(Microsoft.AspNetCore.SignalR.HubOptions options) => throw null;
                public HubOptionsSetup(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.SignalR.Protocol.IHubProtocol> protocols) => throw null;
            }
            public class HubOptionsSetup<THub> : Microsoft.Extensions.Options.IConfigureOptions<Microsoft.AspNetCore.SignalR.HubOptions<THub>> where THub : Microsoft.AspNetCore.SignalR.Hub
            {
                public void Configure(Microsoft.AspNetCore.SignalR.HubOptions<THub> options) => throw null;
                public HubOptionsSetup(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.SignalR.HubOptions> options) => throw null;
            }
            public interface IClientProxy
            {
                System.Threading.Tasks.Task SendCoreAsync(string method, object[] args, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
            }
            public interface IGroupManager
            {
                System.Threading.Tasks.Task AddToGroupAsync(string connectionId, string groupName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                System.Threading.Tasks.Task RemoveFromGroupAsync(string connectionId, string groupName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
            }
            public interface IHubActivator<THub> where THub : Microsoft.AspNetCore.SignalR.Hub
            {
                THub Create();
                void Release(THub hub);
            }
            public interface IHubCallerClients : Microsoft.AspNetCore.SignalR.IHubCallerClients<Microsoft.AspNetCore.SignalR.IClientProxy>, Microsoft.AspNetCore.SignalR.IHubClients<Microsoft.AspNetCore.SignalR.IClientProxy>
            {
                virtual Microsoft.AspNetCore.SignalR.ISingleClientProxy Caller { get => throw null; }
                virtual Microsoft.AspNetCore.SignalR.ISingleClientProxy Client(string connectionId) => throw null;
            }
            public interface IHubCallerClients<T> : Microsoft.AspNetCore.SignalR.IHubClients<T>
            {
                T Caller { get; }
                T Others { get; }
                T OthersInGroup(string groupName);
            }
            public interface IHubClients : Microsoft.AspNetCore.SignalR.IHubClients<Microsoft.AspNetCore.SignalR.IClientProxy>
            {
                virtual Microsoft.AspNetCore.SignalR.ISingleClientProxy Client(string connectionId) => throw null;
            }
            public interface IHubClients<T>
            {
                T All { get; }
                T AllExcept(System.Collections.Generic.IReadOnlyList<string> excludedConnectionIds);
                T Client(string connectionId);
                T Clients(System.Collections.Generic.IReadOnlyList<string> connectionIds);
                T Group(string groupName);
                T GroupExcept(string groupName, System.Collections.Generic.IReadOnlyList<string> excludedConnectionIds);
                T Groups(System.Collections.Generic.IReadOnlyList<string> groupNames);
                T User(string userId);
                T Users(System.Collections.Generic.IReadOnlyList<string> userIds);
            }
            public interface IHubContext
            {
                Microsoft.AspNetCore.SignalR.IHubClients Clients { get; }
                Microsoft.AspNetCore.SignalR.IGroupManager Groups { get; }
            }
            public interface IHubContext<THub> where THub : Microsoft.AspNetCore.SignalR.Hub
            {
                Microsoft.AspNetCore.SignalR.IHubClients Clients { get; }
                Microsoft.AspNetCore.SignalR.IGroupManager Groups { get; }
            }
            public interface IHubContext<THub, T> where THub : Microsoft.AspNetCore.SignalR.Hub<T> where T : class
            {
                Microsoft.AspNetCore.SignalR.IHubClients<T> Clients { get; }
                Microsoft.AspNetCore.SignalR.IGroupManager Groups { get; }
            }
            public interface IHubFilter
            {
                virtual System.Threading.Tasks.ValueTask<object> InvokeMethodAsync(Microsoft.AspNetCore.SignalR.HubInvocationContext invocationContext, System.Func<Microsoft.AspNetCore.SignalR.HubInvocationContext, System.Threading.Tasks.ValueTask<object>> next) => throw null;
                virtual System.Threading.Tasks.Task OnConnectedAsync(Microsoft.AspNetCore.SignalR.HubLifetimeContext context, System.Func<Microsoft.AspNetCore.SignalR.HubLifetimeContext, System.Threading.Tasks.Task> next) => throw null;
                virtual System.Threading.Tasks.Task OnDisconnectedAsync(Microsoft.AspNetCore.SignalR.HubLifetimeContext context, System.Exception exception, System.Func<Microsoft.AspNetCore.SignalR.HubLifetimeContext, System.Exception, System.Threading.Tasks.Task> next) => throw null;
            }
            public interface IHubProtocolResolver
            {
                System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.SignalR.Protocol.IHubProtocol> AllProtocols { get; }
                Microsoft.AspNetCore.SignalR.Protocol.IHubProtocol GetProtocol(string protocolName, System.Collections.Generic.IReadOnlyList<string> supportedProtocols);
            }
            public interface ISignalRServerBuilder : Microsoft.AspNetCore.SignalR.ISignalRBuilder
            {
            }
            public interface ISingleClientProxy : Microsoft.AspNetCore.SignalR.IClientProxy
            {
                System.Threading.Tasks.Task<T> InvokeCoreAsync<T>(string method, object[] args, System.Threading.CancellationToken cancellationToken);
            }
            public interface IUserIdProvider
            {
                string GetUserId(Microsoft.AspNetCore.SignalR.HubConnectionContext connection);
            }
            public class SerializedHubMessage
            {
                public SerializedHubMessage(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.SignalR.SerializedMessage> messages) => throw null;
                public SerializedHubMessage(Microsoft.AspNetCore.SignalR.Protocol.HubMessage message) => throw null;
                public System.ReadOnlyMemory<byte> GetSerializedMessage(Microsoft.AspNetCore.SignalR.Protocol.IHubProtocol protocol) => throw null;
                public Microsoft.AspNetCore.SignalR.Protocol.HubMessage Message { get => throw null; }
            }
            public struct SerializedMessage
            {
                public SerializedMessage(string protocolName, System.ReadOnlyMemory<byte> serialized) => throw null;
                public string ProtocolName { get => throw null; }
                public System.ReadOnlyMemory<byte> Serialized { get => throw null; }
            }
            public static partial class SignalRConnectionBuilderExtensions
            {
                public static Microsoft.AspNetCore.Connections.IConnectionBuilder UseHub<THub>(this Microsoft.AspNetCore.Connections.IConnectionBuilder connectionBuilder) where THub : Microsoft.AspNetCore.SignalR.Hub => throw null;
            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class SignalRDependencyInjectionExtensions
            {
                public static Microsoft.AspNetCore.SignalR.ISignalRServerBuilder AddSignalRCore(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
            }
        }
    }
}
