// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace SignalR
        {
            // Generated from `Microsoft.AspNetCore.SignalR.ClientProxyExtensions` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class ClientProxyExtensions
            {
                public static System.Threading.Tasks.Task SendAsync(this Microsoft.AspNetCore.SignalR.IClientProxy clientProxy, string method, object arg1, object arg2, object arg3, object arg4, object arg5, object arg6, object arg7, object arg8, object arg9, object arg10, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task SendAsync(this Microsoft.AspNetCore.SignalR.IClientProxy clientProxy, string method, object arg1, object arg2, object arg3, object arg4, object arg5, object arg6, object arg7, object arg8, object arg9, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task SendAsync(this Microsoft.AspNetCore.SignalR.IClientProxy clientProxy, string method, object arg1, object arg2, object arg3, object arg4, object arg5, object arg6, object arg7, object arg8, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task SendAsync(this Microsoft.AspNetCore.SignalR.IClientProxy clientProxy, string method, object arg1, object arg2, object arg3, object arg4, object arg5, object arg6, object arg7, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task SendAsync(this Microsoft.AspNetCore.SignalR.IClientProxy clientProxy, string method, object arg1, object arg2, object arg3, object arg4, object arg5, object arg6, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task SendAsync(this Microsoft.AspNetCore.SignalR.IClientProxy clientProxy, string method, object arg1, object arg2, object arg3, object arg4, object arg5, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task SendAsync(this Microsoft.AspNetCore.SignalR.IClientProxy clientProxy, string method, object arg1, object arg2, object arg3, object arg4, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task SendAsync(this Microsoft.AspNetCore.SignalR.IClientProxy clientProxy, string method, object arg1, object arg2, object arg3, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task SendAsync(this Microsoft.AspNetCore.SignalR.IClientProxy clientProxy, string method, object arg1, object arg2, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task SendAsync(this Microsoft.AspNetCore.SignalR.IClientProxy clientProxy, string method, object arg1, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task SendAsync(this Microsoft.AspNetCore.SignalR.IClientProxy clientProxy, string method, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.SignalR.DefaultHubLifetimeManager<>` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class DefaultHubLifetimeManager<THub> : Microsoft.AspNetCore.SignalR.HubLifetimeManager<THub> where THub : Microsoft.AspNetCore.SignalR.Hub
            {
                public override System.Threading.Tasks.Task AddToGroupAsync(string connectionId, string groupName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public DefaultHubLifetimeManager(Microsoft.Extensions.Logging.ILogger<Microsoft.AspNetCore.SignalR.DefaultHubLifetimeManager<THub>> logger) => throw null;
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
            }

            // Generated from `Microsoft.AspNetCore.SignalR.DefaultUserIdProvider` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class DefaultUserIdProvider : Microsoft.AspNetCore.SignalR.IUserIdProvider
            {
                public DefaultUserIdProvider() => throw null;
                public virtual string GetUserId(Microsoft.AspNetCore.SignalR.HubConnectionContext connection) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.SignalR.DynamicHub` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public abstract class DynamicHub : Microsoft.AspNetCore.SignalR.Hub
            {
                public Microsoft.AspNetCore.SignalR.DynamicHubClients Clients { get => throw null; set => throw null; }
                protected DynamicHub() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.SignalR.DynamicHubClients` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
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

            // Generated from `Microsoft.AspNetCore.SignalR.Hub` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public abstract class Hub : System.IDisposable
            {
                public Microsoft.AspNetCore.SignalR.IHubCallerClients Clients { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.SignalR.HubCallerContext Context { get => throw null; set => throw null; }
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public Microsoft.AspNetCore.SignalR.IGroupManager Groups { get => throw null; set => throw null; }
                protected Hub() => throw null;
                public virtual System.Threading.Tasks.Task OnConnectedAsync() => throw null;
                public virtual System.Threading.Tasks.Task OnDisconnectedAsync(System.Exception exception) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.SignalR.Hub<>` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public abstract class Hub<T> : Microsoft.AspNetCore.SignalR.Hub where T : class
            {
                public Microsoft.AspNetCore.SignalR.IHubCallerClients<T> Clients { get => throw null; set => throw null; }
                protected Hub() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.SignalR.HubCallerContext` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public abstract class HubCallerContext
            {
                public abstract void Abort();
                public abstract System.Threading.CancellationToken ConnectionAborted { get; }
                public abstract string ConnectionId { get; }
                public abstract Microsoft.AspNetCore.Http.Features.IFeatureCollection Features { get; }
                protected HubCallerContext() => throw null;
                public abstract System.Collections.Generic.IDictionary<object, object> Items { get; }
                public abstract System.Security.Claims.ClaimsPrincipal User { get; }
                public abstract string UserIdentifier { get; }
            }

            // Generated from `Microsoft.AspNetCore.SignalR.HubClientsExtensions` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class HubClientsExtensions
            {
                public static T AllExcept<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string excludedConnectionId1, string excludedConnectionId2, string excludedConnectionId3, string excludedConnectionId4, string excludedConnectionId5, string excludedConnectionId6, string excludedConnectionId7, string excludedConnectionId8) => throw null;
                public static T AllExcept<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string excludedConnectionId1, string excludedConnectionId2, string excludedConnectionId3, string excludedConnectionId4, string excludedConnectionId5, string excludedConnectionId6, string excludedConnectionId7) => throw null;
                public static T AllExcept<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string excludedConnectionId1, string excludedConnectionId2, string excludedConnectionId3, string excludedConnectionId4, string excludedConnectionId5, string excludedConnectionId6) => throw null;
                public static T AllExcept<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string excludedConnectionId1, string excludedConnectionId2, string excludedConnectionId3, string excludedConnectionId4, string excludedConnectionId5) => throw null;
                public static T AllExcept<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string excludedConnectionId1, string excludedConnectionId2, string excludedConnectionId3, string excludedConnectionId4) => throw null;
                public static T AllExcept<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string excludedConnectionId1, string excludedConnectionId2, string excludedConnectionId3) => throw null;
                public static T AllExcept<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string excludedConnectionId1, string excludedConnectionId2) => throw null;
                public static T AllExcept<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string excludedConnectionId1) => throw null;
                public static T AllExcept<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, System.Collections.Generic.IEnumerable<string> excludedConnectionIds) => throw null;
                public static T Clients<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string connection1, string connection2, string connection3, string connection4, string connection5, string connection6, string connection7, string connection8) => throw null;
                public static T Clients<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string connection1, string connection2, string connection3, string connection4, string connection5, string connection6, string connection7) => throw null;
                public static T Clients<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string connection1, string connection2, string connection3, string connection4, string connection5, string connection6) => throw null;
                public static T Clients<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string connection1, string connection2, string connection3, string connection4, string connection5) => throw null;
                public static T Clients<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string connection1, string connection2, string connection3, string connection4) => throw null;
                public static T Clients<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string connection1, string connection2, string connection3) => throw null;
                public static T Clients<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string connection1, string connection2) => throw null;
                public static T Clients<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string connection1) => throw null;
                public static T Clients<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, System.Collections.Generic.IEnumerable<string> connectionIds) => throw null;
                public static T GroupExcept<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string groupName, string excludedConnectionId1, string excludedConnectionId2, string excludedConnectionId3, string excludedConnectionId4, string excludedConnectionId5, string excludedConnectionId6, string excludedConnectionId7, string excludedConnectionId8) => throw null;
                public static T GroupExcept<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string groupName, string excludedConnectionId1, string excludedConnectionId2, string excludedConnectionId3, string excludedConnectionId4, string excludedConnectionId5, string excludedConnectionId6, string excludedConnectionId7) => throw null;
                public static T GroupExcept<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string groupName, string excludedConnectionId1, string excludedConnectionId2, string excludedConnectionId3, string excludedConnectionId4, string excludedConnectionId5, string excludedConnectionId6) => throw null;
                public static T GroupExcept<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string groupName, string excludedConnectionId1, string excludedConnectionId2, string excludedConnectionId3, string excludedConnectionId4, string excludedConnectionId5) => throw null;
                public static T GroupExcept<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string groupName, string excludedConnectionId1, string excludedConnectionId2, string excludedConnectionId3, string excludedConnectionId4) => throw null;
                public static T GroupExcept<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string groupName, string excludedConnectionId1, string excludedConnectionId2, string excludedConnectionId3) => throw null;
                public static T GroupExcept<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string groupName, string excludedConnectionId1, string excludedConnectionId2) => throw null;
                public static T GroupExcept<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string groupName, string excludedConnectionId1) => throw null;
                public static T GroupExcept<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string groupName, System.Collections.Generic.IEnumerable<string> excludedConnectionIds) => throw null;
                public static T Groups<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string group1, string group2, string group3, string group4, string group5, string group6, string group7, string group8) => throw null;
                public static T Groups<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string group1, string group2, string group3, string group4, string group5, string group6, string group7) => throw null;
                public static T Groups<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string group1, string group2, string group3, string group4, string group5, string group6) => throw null;
                public static T Groups<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string group1, string group2, string group3, string group4, string group5) => throw null;
                public static T Groups<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string group1, string group2, string group3, string group4) => throw null;
                public static T Groups<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string group1, string group2, string group3) => throw null;
                public static T Groups<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string group1, string group2) => throw null;
                public static T Groups<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string group1) => throw null;
                public static T Groups<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, System.Collections.Generic.IEnumerable<string> groupNames) => throw null;
                public static T Users<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string user1, string user2, string user3, string user4, string user5, string user6, string user7, string user8) => throw null;
                public static T Users<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string user1, string user2, string user3, string user4, string user5, string user6, string user7) => throw null;
                public static T Users<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string user1, string user2, string user3, string user4, string user5, string user6) => throw null;
                public static T Users<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string user1, string user2, string user3, string user4, string user5) => throw null;
                public static T Users<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string user1, string user2, string user3, string user4) => throw null;
                public static T Users<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string user1, string user2, string user3) => throw null;
                public static T Users<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string user1, string user2) => throw null;
                public static T Users<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, string user1) => throw null;
                public static T Users<T>(this Microsoft.AspNetCore.SignalR.IHubClients<T> hubClients, System.Collections.Generic.IEnumerable<string> userIds) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.SignalR.HubConnectionContext` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HubConnectionContext
            {
                public virtual void Abort() => throw null;
                public virtual System.Threading.CancellationToken ConnectionAborted { get => throw null; }
                public virtual string ConnectionId { get => throw null; }
                public virtual Microsoft.AspNetCore.Http.Features.IFeatureCollection Features { get => throw null; }
                public HubConnectionContext(Microsoft.AspNetCore.Connections.ConnectionContext connectionContext, Microsoft.AspNetCore.SignalR.HubConnectionContextOptions contextOptions, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                public virtual System.Collections.Generic.IDictionary<object, object> Items { get => throw null; }
                public virtual Microsoft.AspNetCore.SignalR.Protocol.IHubProtocol Protocol { get => throw null; set => throw null; }
                public virtual System.Security.Claims.ClaimsPrincipal User { get => throw null; }
                public string UserIdentifier { get => throw null; set => throw null; }
                public virtual System.Threading.Tasks.ValueTask WriteAsync(Microsoft.AspNetCore.SignalR.SerializedHubMessage message, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.ValueTask WriteAsync(Microsoft.AspNetCore.SignalR.Protocol.HubMessage message, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.SignalR.HubConnectionContextOptions` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HubConnectionContextOptions
            {
                public System.TimeSpan ClientTimeoutInterval { get => throw null; set => throw null; }
                public HubConnectionContextOptions() => throw null;
                public System.TimeSpan KeepAliveInterval { get => throw null; set => throw null; }
                public int MaximumParallelInvocations { get => throw null; set => throw null; }
                public System.Int64? MaximumReceiveMessageSize { get => throw null; set => throw null; }
                public int StreamBufferCapacity { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.SignalR.HubConnectionHandler<>` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HubConnectionHandler<THub> : Microsoft.AspNetCore.Connections.ConnectionHandler where THub : Microsoft.AspNetCore.SignalR.Hub
            {
                public HubConnectionHandler(Microsoft.AspNetCore.SignalR.HubLifetimeManager<THub> lifetimeManager, Microsoft.AspNetCore.SignalR.IHubProtocolResolver protocolResolver, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.SignalR.HubOptions> globalHubOptions, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.SignalR.HubOptions<THub>> hubOptions, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.AspNetCore.SignalR.IUserIdProvider userIdProvider, Microsoft.Extensions.DependencyInjection.IServiceScopeFactory serviceScopeFactory) => throw null;
                public override System.Threading.Tasks.Task OnConnectedAsync(Microsoft.AspNetCore.Connections.ConnectionContext connection) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.SignalR.HubConnectionStore` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HubConnectionStore
            {
                public void Add(Microsoft.AspNetCore.SignalR.HubConnectionContext connection) => throw null;
                public int Count { get => throw null; }
                // Generated from `Microsoft.AspNetCore.SignalR.HubConnectionStore+Enumerator` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public struct Enumerator : System.IDisposable, System.Collections.IEnumerator, System.Collections.Generic.IEnumerator<Microsoft.AspNetCore.SignalR.HubConnectionContext>
                {
                    public Microsoft.AspNetCore.SignalR.HubConnectionContext Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    public void Dispose() => throw null;
                    public Enumerator(Microsoft.AspNetCore.SignalR.HubConnectionStore hubConnectionList) => throw null;
                    // Stub generator skipped constructor 
                    public bool MoveNext() => throw null;
                    public void Reset() => throw null;
                }


                public Microsoft.AspNetCore.SignalR.HubConnectionStore.Enumerator GetEnumerator() => throw null;
                public HubConnectionStore() => throw null;
                public Microsoft.AspNetCore.SignalR.HubConnectionContext this[string connectionId] { get => throw null; }
                public void Remove(Microsoft.AspNetCore.SignalR.HubConnectionContext connection) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.SignalR.HubInvocationContext` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HubInvocationContext
            {
                public Microsoft.AspNetCore.SignalR.HubCallerContext Context { get => throw null; }
                public Microsoft.AspNetCore.SignalR.Hub Hub { get => throw null; }
                public HubInvocationContext(Microsoft.AspNetCore.SignalR.HubCallerContext context, string hubMethodName, object[] hubMethodArguments) => throw null;
                public HubInvocationContext(Microsoft.AspNetCore.SignalR.HubCallerContext context, System.IServiceProvider serviceProvider, Microsoft.AspNetCore.SignalR.Hub hub, System.Reflection.MethodInfo hubMethod, System.Collections.Generic.IReadOnlyList<object> hubMethodArguments) => throw null;
                public System.Reflection.MethodInfo HubMethod { get => throw null; }
                public System.Collections.Generic.IReadOnlyList<object> HubMethodArguments { get => throw null; }
                public string HubMethodName { get => throw null; }
                public System.IServiceProvider ServiceProvider { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.SignalR.HubLifetimeContext` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HubLifetimeContext
            {
                public Microsoft.AspNetCore.SignalR.HubCallerContext Context { get => throw null; }
                public Microsoft.AspNetCore.SignalR.Hub Hub { get => throw null; }
                public HubLifetimeContext(Microsoft.AspNetCore.SignalR.HubCallerContext context, System.IServiceProvider serviceProvider, Microsoft.AspNetCore.SignalR.Hub hub) => throw null;
                public System.IServiceProvider ServiceProvider { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.SignalR.HubLifetimeManager<>` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public abstract class HubLifetimeManager<THub> where THub : Microsoft.AspNetCore.SignalR.Hub
            {
                public abstract System.Threading.Tasks.Task AddToGroupAsync(string connectionId, string groupName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                protected HubLifetimeManager() => throw null;
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
            }

            // Generated from `Microsoft.AspNetCore.SignalR.HubMetadata` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HubMetadata
            {
                public HubMetadata(System.Type hubType) => throw null;
                public System.Type HubType { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.SignalR.HubMethodNameAttribute` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HubMethodNameAttribute : System.Attribute
            {
                public HubMethodNameAttribute(string name) => throw null;
                public string Name { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.SignalR.HubOptions` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HubOptions
            {
                public System.TimeSpan? ClientTimeoutInterval { get => throw null; set => throw null; }
                public bool? EnableDetailedErrors { get => throw null; set => throw null; }
                public System.TimeSpan? HandshakeTimeout { get => throw null; set => throw null; }
                public HubOptions() => throw null;
                public System.TimeSpan? KeepAliveInterval { get => throw null; set => throw null; }
                public int MaximumParallelInvocationsPerClient { get => throw null; set => throw null; }
                public System.Int64? MaximumReceiveMessageSize { get => throw null; set => throw null; }
                public int? StreamBufferCapacity { get => throw null; set => throw null; }
                public System.Collections.Generic.IList<string> SupportedProtocols { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.SignalR.HubOptions<>` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HubOptions<THub> : Microsoft.AspNetCore.SignalR.HubOptions where THub : Microsoft.AspNetCore.SignalR.Hub
            {
                public HubOptions() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.SignalR.HubOptionsExtensions` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class HubOptionsExtensions
            {
                public static void AddFilter<TFilter>(this Microsoft.AspNetCore.SignalR.HubOptions options) where TFilter : Microsoft.AspNetCore.SignalR.IHubFilter => throw null;
                public static void AddFilter(this Microsoft.AspNetCore.SignalR.HubOptions options, System.Type filterType) => throw null;
                public static void AddFilter(this Microsoft.AspNetCore.SignalR.HubOptions options, Microsoft.AspNetCore.SignalR.IHubFilter hubFilter) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.SignalR.HubOptionsSetup` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HubOptionsSetup : Microsoft.Extensions.Options.IConfigureOptions<Microsoft.AspNetCore.SignalR.HubOptions>
            {
                public void Configure(Microsoft.AspNetCore.SignalR.HubOptions options) => throw null;
                public HubOptionsSetup(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.SignalR.Protocol.IHubProtocol> protocols) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.SignalR.HubOptionsSetup<>` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HubOptionsSetup<THub> : Microsoft.Extensions.Options.IConfigureOptions<Microsoft.AspNetCore.SignalR.HubOptions<THub>> where THub : Microsoft.AspNetCore.SignalR.Hub
            {
                public void Configure(Microsoft.AspNetCore.SignalR.HubOptions<THub> options) => throw null;
                public HubOptionsSetup(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.SignalR.HubOptions> options) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.SignalR.IClientProxy` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IClientProxy
            {
                System.Threading.Tasks.Task SendCoreAsync(string method, object[] args, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
            }

            // Generated from `Microsoft.AspNetCore.SignalR.IGroupManager` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IGroupManager
            {
                System.Threading.Tasks.Task AddToGroupAsync(string connectionId, string groupName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                System.Threading.Tasks.Task RemoveFromGroupAsync(string connectionId, string groupName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
            }

            // Generated from `Microsoft.AspNetCore.SignalR.IHubActivator<>` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IHubActivator<THub> where THub : Microsoft.AspNetCore.SignalR.Hub
            {
                THub Create();
                void Release(THub hub);
            }

            // Generated from `Microsoft.AspNetCore.SignalR.IHubCallerClients` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IHubCallerClients : Microsoft.AspNetCore.SignalR.IHubClients<Microsoft.AspNetCore.SignalR.IClientProxy>, Microsoft.AspNetCore.SignalR.IHubCallerClients<Microsoft.AspNetCore.SignalR.IClientProxy>
            {
            }

            // Generated from `Microsoft.AspNetCore.SignalR.IHubCallerClients<>` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IHubCallerClients<T> : Microsoft.AspNetCore.SignalR.IHubClients<T>
            {
                T Caller { get; }
                T Others { get; }
                T OthersInGroup(string groupName);
            }

            // Generated from `Microsoft.AspNetCore.SignalR.IHubClients` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IHubClients : Microsoft.AspNetCore.SignalR.IHubClients<Microsoft.AspNetCore.SignalR.IClientProxy>
            {
            }

            // Generated from `Microsoft.AspNetCore.SignalR.IHubClients<>` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
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

            // Generated from `Microsoft.AspNetCore.SignalR.IHubContext<,>` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IHubContext<THub, T> where T : class where THub : Microsoft.AspNetCore.SignalR.Hub<T>
            {
                Microsoft.AspNetCore.SignalR.IHubClients<T> Clients { get; }
                Microsoft.AspNetCore.SignalR.IGroupManager Groups { get; }
            }

            // Generated from `Microsoft.AspNetCore.SignalR.IHubContext<>` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IHubContext<THub> where THub : Microsoft.AspNetCore.SignalR.Hub
            {
                Microsoft.AspNetCore.SignalR.IHubClients Clients { get; }
                Microsoft.AspNetCore.SignalR.IGroupManager Groups { get; }
            }

            // Generated from `Microsoft.AspNetCore.SignalR.IHubFilter` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IHubFilter
            {
                System.Threading.Tasks.ValueTask<object> InvokeMethodAsync(Microsoft.AspNetCore.SignalR.HubInvocationContext invocationContext, System.Func<Microsoft.AspNetCore.SignalR.HubInvocationContext, System.Threading.Tasks.ValueTask<object>> next) => throw null;
                System.Threading.Tasks.Task OnConnectedAsync(Microsoft.AspNetCore.SignalR.HubLifetimeContext context, System.Func<Microsoft.AspNetCore.SignalR.HubLifetimeContext, System.Threading.Tasks.Task> next) => throw null;
                System.Threading.Tasks.Task OnDisconnectedAsync(Microsoft.AspNetCore.SignalR.HubLifetimeContext context, System.Exception exception, System.Func<Microsoft.AspNetCore.SignalR.HubLifetimeContext, System.Exception, System.Threading.Tasks.Task> next) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.SignalR.IHubProtocolResolver` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IHubProtocolResolver
            {
                System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.SignalR.Protocol.IHubProtocol> AllProtocols { get; }
                Microsoft.AspNetCore.SignalR.Protocol.IHubProtocol GetProtocol(string protocolName, System.Collections.Generic.IReadOnlyList<string> supportedProtocols);
            }

            // Generated from `Microsoft.AspNetCore.SignalR.ISignalRServerBuilder` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface ISignalRServerBuilder : Microsoft.AspNetCore.SignalR.ISignalRBuilder
            {
            }

            // Generated from `Microsoft.AspNetCore.SignalR.IUserIdProvider` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IUserIdProvider
            {
                string GetUserId(Microsoft.AspNetCore.SignalR.HubConnectionContext connection);
            }

            // Generated from `Microsoft.AspNetCore.SignalR.SerializedHubMessage` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class SerializedHubMessage
            {
                public System.ReadOnlyMemory<System.Byte> GetSerializedMessage(Microsoft.AspNetCore.SignalR.Protocol.IHubProtocol protocol) => throw null;
                public Microsoft.AspNetCore.SignalR.Protocol.HubMessage Message { get => throw null; }
                public SerializedHubMessage(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.SignalR.SerializedMessage> messages) => throw null;
                public SerializedHubMessage(Microsoft.AspNetCore.SignalR.Protocol.HubMessage message) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.SignalR.SerializedMessage` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public struct SerializedMessage
            {
                public string ProtocolName { get => throw null; }
                public System.ReadOnlyMemory<System.Byte> Serialized { get => throw null; }
                public SerializedMessage(string protocolName, System.ReadOnlyMemory<System.Byte> serialized) => throw null;
                // Stub generator skipped constructor 
            }

            // Generated from `Microsoft.AspNetCore.SignalR.SignalRConnectionBuilderExtensions` in `Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class SignalRConnectionBuilderExtensions
            {
                public static Microsoft.AspNetCore.Connections.IConnectionBuilder UseHub<THub>(this Microsoft.AspNetCore.Connections.IConnectionBuilder connectionBuilder) where THub : Microsoft.AspNetCore.SignalR.Hub => throw null;
            }

        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            // Generated from `Microsoft.Extensions.DependencyInjection.SignalRDependencyInjectionExtensions` in `Microsoft.AspNetCore.SignalR, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60; Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static partial class SignalRDependencyInjectionExtensions
            {
                public static Microsoft.AspNetCore.SignalR.ISignalRServerBuilder AddSignalRCore(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
            }

        }
    }
}
