// This file contains auto-generated code.

// Generated from `SentinelInfo` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
public class SentinelInfo
{
    public string MasterName { get => throw null; set => throw null; }
    public string[] RedisMasters { get => throw null; set => throw null; }
    public string[] RedisSlaves { get => throw null; set => throw null; }
    public SentinelInfo(string masterName, System.Collections.Generic.IEnumerable<string> redisMasters, System.Collections.Generic.IEnumerable<string> redisReplicas) => throw null;
    public override string ToString() => throw null;
}

namespace ServiceStack
{
    namespace Redis
    {
        // Generated from `ServiceStack.Redis.BasicRedisClientManager` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class BasicRedisClientManager : System.IDisposable, System.IAsyncDisposable, ServiceStack.Redis.IRedisFailover, ServiceStack.Redis.IRedisClientsManagerAsync, ServiceStack.Redis.IRedisClientsManager, ServiceStack.Redis.IHasRedisResolver, ServiceStack.Caching.ICacheClientAsync, ServiceStack.Caching.ICacheClient
        {
            public bool Add<T>(string key, T value, System.TimeSpan expiresIn) => throw null;
            public bool Add<T>(string key, T value, System.DateTime expiresAt) => throw null;
            public bool Add<T>(string key, T value) => throw null;
            System.Threading.Tasks.Task<bool> ServiceStack.Caching.ICacheClientAsync.AddAsync<T>(string key, T value, System.TimeSpan expiresIn, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.Task<bool> ServiceStack.Caching.ICacheClientAsync.AddAsync<T>(string key, T value, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.Task<bool> ServiceStack.Caching.ICacheClientAsync.AddAsync<T>(string key, T value, System.DateTime expiresAt, System.Threading.CancellationToken token) => throw null;
            public BasicRedisClientManager(params string[] readWriteHosts) => throw null;
            public BasicRedisClientManager(int initialDb, params string[] readWriteHosts) => throw null;
            public BasicRedisClientManager(System.Collections.Generic.IEnumerable<string> readWriteHosts, System.Collections.Generic.IEnumerable<string> readOnlyHosts, System.Int64? initalDb = default(System.Int64?)) => throw null;
            public BasicRedisClientManager(System.Collections.Generic.IEnumerable<ServiceStack.Redis.RedisEndpoint> readWriteHosts, System.Collections.Generic.IEnumerable<ServiceStack.Redis.RedisEndpoint> readOnlyHosts, System.Int64? initalDb = default(System.Int64?)) => throw null;
            public BasicRedisClientManager() => throw null;
            public System.Func<ServiceStack.Redis.RedisEndpoint, ServiceStack.Redis.RedisClient> ClientFactory { get => throw null; set => throw null; }
            public int? ConnectTimeout { get => throw null; set => throw null; }
            public System.Action<ServiceStack.Redis.IRedisNativeClient> ConnectionFilter { get => throw null; set => throw null; }
            public System.Int64? Db { get => throw null; set => throw null; }
            public System.Int64 Decrement(string key, System.UInt32 amount) => throw null;
            System.Threading.Tasks.Task<System.Int64> ServiceStack.Caching.ICacheClientAsync.DecrementAsync(string key, System.UInt32 amount, System.Threading.CancellationToken token) => throw null;
            public void Dispose() => throw null;
            System.Threading.Tasks.ValueTask System.IAsyncDisposable.DisposeAsync() => throw null;
            public void FailoverTo(params string[] readWriteHosts) => throw null;
            public void FailoverTo(System.Collections.Generic.IEnumerable<string> readWriteHosts, System.Collections.Generic.IEnumerable<string> readOnlyHosts) => throw null;
            public void FlushAll() => throw null;
            System.Threading.Tasks.Task ServiceStack.Caching.ICacheClientAsync.FlushAllAsync(System.Threading.CancellationToken token) => throw null;
            public T Get<T>(string key) => throw null;
            public System.Collections.Generic.IDictionary<string, T> GetAll<T>(System.Collections.Generic.IEnumerable<string> keys) => throw null;
            System.Threading.Tasks.Task<System.Collections.Generic.IDictionary<string, T>> ServiceStack.Caching.ICacheClientAsync.GetAllAsync<T>(System.Collections.Generic.IEnumerable<string> keys, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.Task<T> ServiceStack.Caching.ICacheClientAsync.GetAsync<T>(string key, System.Threading.CancellationToken token) => throw null;
            public ServiceStack.Caching.ICacheClient GetCacheClient() => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Caching.ICacheClientAsync> ServiceStack.Redis.IRedisClientsManagerAsync.GetCacheClientAsync(System.Threading.CancellationToken token) => throw null;
            public ServiceStack.Redis.IRedisClient GetClient() => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.IRedisClientAsync> ServiceStack.Redis.IRedisClientsManagerAsync.GetClientAsync(System.Threading.CancellationToken token) => throw null;
            System.Collections.Generic.IAsyncEnumerable<string> ServiceStack.Caching.ICacheClientAsync.GetKeysByPatternAsync(string pattern, System.Threading.CancellationToken token) => throw null;
            public ServiceStack.Caching.ICacheClient GetReadOnlyCacheClient() => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Caching.ICacheClientAsync> ServiceStack.Redis.IRedisClientsManagerAsync.GetReadOnlyCacheClientAsync(System.Threading.CancellationToken token) => throw null;
            public virtual ServiceStack.Redis.IRedisClient GetReadOnlyClient() => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.IRedisClientAsync> ServiceStack.Redis.IRedisClientsManagerAsync.GetReadOnlyClientAsync(System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.Task<System.TimeSpan?> ServiceStack.Caching.ICacheClientAsync.GetTimeToLiveAsync(string key, System.Threading.CancellationToken token) => throw null;
            public int? IdleTimeOutSecs { get => throw null; set => throw null; }
            public System.Int64 Increment(string key, System.UInt32 amount) => throw null;
            System.Threading.Tasks.Task<System.Int64> ServiceStack.Caching.ICacheClientAsync.IncrementAsync(string key, System.UInt32 amount, System.Threading.CancellationToken token) => throw null;
            public static ServiceStack.Logging.ILog Log;
            public string NamespacePrefix { get => throw null; set => throw null; }
            public System.Collections.Generic.List<System.Action<ServiceStack.Redis.IRedisClientsManager>> OnFailover { get => throw null; set => throw null; }
            protected virtual void OnStart() => throw null;
            protected int RedisClientCounter;
            public ServiceStack.Redis.IRedisResolver RedisResolver { get => throw null; set => throw null; }
            public bool Remove(string key) => throw null;
            public void RemoveAll(System.Collections.Generic.IEnumerable<string> keys) => throw null;
            System.Threading.Tasks.Task ServiceStack.Caching.ICacheClientAsync.RemoveAllAsync(System.Collections.Generic.IEnumerable<string> keys, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.Task<bool> ServiceStack.Caching.ICacheClientAsync.RemoveAsync(string key, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.Task ServiceStack.Caching.ICacheClientAsync.RemoveExpiredEntriesAsync(System.Threading.CancellationToken token) => throw null;
            public bool Replace<T>(string key, T value, System.TimeSpan expiresIn) => throw null;
            public bool Replace<T>(string key, T value, System.DateTime expiresAt) => throw null;
            public bool Replace<T>(string key, T value) => throw null;
            System.Threading.Tasks.Task<bool> ServiceStack.Caching.ICacheClientAsync.ReplaceAsync<T>(string key, T value, System.TimeSpan expiresIn, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.Task<bool> ServiceStack.Caching.ICacheClientAsync.ReplaceAsync<T>(string key, T value, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.Task<bool> ServiceStack.Caching.ICacheClientAsync.ReplaceAsync<T>(string key, T value, System.DateTime expiresAt, System.Threading.CancellationToken token) => throw null;
            public bool Set<T>(string key, T value, System.TimeSpan expiresIn) => throw null;
            public bool Set<T>(string key, T value, System.DateTime expiresAt) => throw null;
            public bool Set<T>(string key, T value) => throw null;
            public void SetAll<T>(System.Collections.Generic.IDictionary<string, T> values) => throw null;
            System.Threading.Tasks.Task ServiceStack.Caching.ICacheClientAsync.SetAllAsync<T>(System.Collections.Generic.IDictionary<string, T> values, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.Task<bool> ServiceStack.Caching.ICacheClientAsync.SetAsync<T>(string key, T value, System.TimeSpan expiresIn, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.Task<bool> ServiceStack.Caching.ICacheClientAsync.SetAsync<T>(string key, T value, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.Task<bool> ServiceStack.Caching.ICacheClientAsync.SetAsync<T>(string key, T value, System.DateTime expiresAt, System.Threading.CancellationToken token) => throw null;
            public int? SocketReceiveTimeout { get => throw null; set => throw null; }
            public int? SocketSendTimeout { get => throw null; set => throw null; }
            public void Start() => throw null;
        }

        // Generated from `ServiceStack.Redis.BasicRedisResolver` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class BasicRedisResolver : ServiceStack.Redis.IRedisResolverExtended, ServiceStack.Redis.IRedisResolver
        {
            public BasicRedisResolver(System.Collections.Generic.IEnumerable<ServiceStack.Redis.RedisEndpoint> masters, System.Collections.Generic.IEnumerable<ServiceStack.Redis.RedisEndpoint> replicas) => throw null;
            public System.Func<ServiceStack.Redis.RedisEndpoint, ServiceStack.Redis.RedisClient> ClientFactory { get => throw null; set => throw null; }
            public ServiceStack.Redis.RedisClient CreateMasterClient(int desiredIndex) => throw null;
            public ServiceStack.Redis.RedisClient CreateRedisClient(ServiceStack.Redis.RedisEndpoint config, bool master) => throw null;
            public ServiceStack.Redis.RedisClient CreateSlaveClient(int desiredIndex) => throw null;
            public ServiceStack.Redis.RedisEndpoint GetReadOnlyHost(int desiredIndex) => throw null;
            public ServiceStack.Redis.RedisEndpoint GetReadWriteHost(int desiredIndex) => throw null;
            public ServiceStack.Redis.RedisEndpoint[] Masters { get => throw null; }
            public int ReadOnlyHostsCount { get => throw null; set => throw null; }
            public int ReadWriteHostsCount { get => throw null; set => throw null; }
            public ServiceStack.Redis.RedisEndpoint[] Replicas { get => throw null; }
            public virtual void ResetMasters(System.Collections.Generic.List<ServiceStack.Redis.RedisEndpoint> newMasters) => throw null;
            public virtual void ResetMasters(System.Collections.Generic.IEnumerable<string> hosts) => throw null;
            public virtual void ResetSlaves(System.Collections.Generic.List<ServiceStack.Redis.RedisEndpoint> newReplicas) => throw null;
            public virtual void ResetSlaves(System.Collections.Generic.IEnumerable<string> hosts) => throw null;
        }

        // Generated from `ServiceStack.Redis.Commands` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class Commands
        {
            public static System.Byte[] Addr;
            public static System.Byte[] After;
            public static System.Byte[] Alpha;
            public static System.Byte[] Append;
            public static System.Byte[] Asc;
            public static System.Byte[] Auth;
            public static System.Byte[] BLPop;
            public static System.Byte[] BRPop;
            public static System.Byte[] BRPopLPush;
            public static System.Byte[] Before;
            public static System.Byte[] BgRewriteAof;
            public static System.Byte[] BgSave;
            public static System.Byte[] BitCount;
            public static System.Byte[] By;
            public static System.Byte[] Client;
            public static System.Byte[] Config;
            public static System.Byte[] Count;
            public static System.Byte[] DbSize;
            public static System.Byte[] Debug;
            public static System.Byte[] Decr;
            public static System.Byte[] DecrBy;
            public static System.Byte[] Del;
            public static System.Byte[] Desc;
            public static System.Byte[] Discard;
            public static System.Byte[] Dump;
            public static System.Byte[] Echo;
            public static System.Byte[] Eval;
            public static System.Byte[] EvalSha;
            public static System.Byte[] Ex;
            public static System.Byte[] Exec;
            public static System.Byte[] Exists;
            public static System.Byte[] Expire;
            public static System.Byte[] ExpireAt;
            public static System.Byte[] Failover;
            public static System.Byte[] Feet;
            public static System.Byte[] Flush;
            public static System.Byte[] FlushAll;
            public static System.Byte[] FlushDb;
            public static System.Byte[] GeoAdd;
            public static System.Byte[] GeoDist;
            public static System.Byte[] GeoHash;
            public static System.Byte[] GeoPos;
            public static System.Byte[] GeoRadius;
            public static System.Byte[] GeoRadiusByMember;
            public static System.Byte[] Get;
            public static System.Byte[] GetBit;
            public static System.Byte[] GetMasterAddrByName;
            public static System.Byte[] GetName;
            public static System.Byte[] GetRange;
            public static System.Byte[] GetSet;
            public static System.Byte[] GetUnit(string unit) => throw null;
            public static System.Byte[] HDel;
            public static System.Byte[] HExists;
            public static System.Byte[] HGet;
            public static System.Byte[] HGetAll;
            public static System.Byte[] HIncrBy;
            public static System.Byte[] HIncrByFloat;
            public static System.Byte[] HKeys;
            public static System.Byte[] HLen;
            public static System.Byte[] HMGet;
            public static System.Byte[] HMSet;
            public static System.Byte[] HScan;
            public static System.Byte[] HSet;
            public static System.Byte[] HSetNx;
            public static System.Byte[] HVals;
            public static System.Byte[] Id;
            public static System.Byte[] IdleTime;
            public static System.Byte[] Incr;
            public static System.Byte[] IncrBy;
            public static System.Byte[] IncrByFloat;
            public static System.Byte[] Info;
            public static System.Byte[] Keys;
            public static System.Byte[] Kill;
            public static System.Byte[] Kilometers;
            public static System.Byte[] LIndex;
            public static System.Byte[] LInsert;
            public static System.Byte[] LLen;
            public static System.Byte[] LPop;
            public static System.Byte[] LPush;
            public static System.Byte[] LPushX;
            public static System.Byte[] LRange;
            public static System.Byte[] LRem;
            public static System.Byte[] LSet;
            public static System.Byte[] LTrim;
            public static System.Byte[] LastSave;
            public static System.Byte[] Limit;
            public static System.Byte[] List;
            public static System.Byte[] Load;
            public static System.Byte[] MGet;
            public static System.Byte[] MSet;
            public static System.Byte[] MSetNx;
            public static System.Byte[] Master;
            public static System.Byte[] Masters;
            public static System.Byte[] Match;
            public static System.Byte[] Meters;
            public static System.Byte[] Migrate;
            public static System.Byte[] Miles;
            public static System.Byte[] Monitor;
            public static System.Byte[] Move;
            public static System.Byte[] Multi;
            public static System.Byte[] No;
            public static System.Byte[] NoSave;
            public static System.Byte[] Nx;
            public static System.Byte[] Object;
            public static System.Byte[] One;
            public static System.Byte[] PExpire;
            public static System.Byte[] PExpireAt;
            public static System.Byte[] PSetEx;
            public static System.Byte[] PSubscribe;
            public static System.Byte[] PTtl;
            public static System.Byte[] PUnSubscribe;
            public static System.Byte[] Pause;
            public static System.Byte[] Persist;
            public static System.Byte[] PfAdd;
            public static System.Byte[] PfCount;
            public static System.Byte[] PfMerge;
            public static System.Byte[] Ping;
            public static System.Byte[] Publish;
            public static System.Byte[] Px;
            public static System.Byte[] Quit;
            public static System.Byte[] RPop;
            public static System.Byte[] RPopLPush;
            public static System.Byte[] RPush;
            public static System.Byte[] RPushX;
            public static System.Byte[] RandomKey;
            public static System.Byte[] Rename;
            public static System.Byte[] RenameNx;
            public static System.Byte[] ResetStat;
            public static System.Byte[] Restore;
            public static System.Byte[] Rewrite;
            public static System.Byte[] Role;
            public static System.Byte[] SAdd;
            public static System.Byte[] SCard;
            public static System.Byte[] SDiff;
            public static System.Byte[] SDiffStore;
            public static System.Byte[] SInter;
            public static System.Byte[] SInterStore;
            public static System.Byte[] SIsMember;
            public static System.Byte[] SMembers;
            public static System.Byte[] SMove;
            public static System.Byte[] SPop;
            public static System.Byte[] SRandMember;
            public static System.Byte[] SRem;
            public static System.Byte[] SScan;
            public static System.Byte[] SUnion;
            public static System.Byte[] SUnionStore;
            public static System.Byte[] Save;
            public static System.Byte[] Scan;
            public static System.Byte[] Script;
            public static System.Byte[] Segfault;
            public static System.Byte[] Select;
            public static System.Byte[] Sentinel;
            public static System.Byte[] Sentinels;
            public static System.Byte[] Set;
            public static System.Byte[] SetBit;
            public static System.Byte[] SetEx;
            public static System.Byte[] SetName;
            public static System.Byte[] SetNx;
            public static System.Byte[] SetRange;
            public static System.Byte[] Shutdown;
            public static System.Byte[] SkipMe;
            public static System.Byte[] SlaveOf;
            public static System.Byte[] Slaves;
            public static System.Byte[] Sleep;
            public static System.Byte[] Slowlog;
            public static System.Byte[] Sort;
            public static System.Byte[] Store;
            public static System.Byte[] StrLen;
            public static System.Byte[] Subscribe;
            public static System.Byte[] Time;
            public static System.Byte[] Ttl;
            public static System.Byte[] Type;
            public static System.Byte[] UnSubscribe;
            public static System.Byte[] UnWatch;
            public static System.Byte[] Watch;
            public static System.Byte[] WithCoord;
            public static System.Byte[] WithDist;
            public static System.Byte[] WithHash;
            public static System.Byte[] WithScores;
            public static System.Byte[] Xx;
            public static System.Byte[] ZAdd;
            public static System.Byte[] ZCard;
            public static System.Byte[] ZCount;
            public static System.Byte[] ZIncrBy;
            public static System.Byte[] ZInterStore;
            public static System.Byte[] ZLexCount;
            public static System.Byte[] ZRange;
            public static System.Byte[] ZRangeByLex;
            public static System.Byte[] ZRangeByScore;
            public static System.Byte[] ZRank;
            public static System.Byte[] ZRem;
            public static System.Byte[] ZRemRangeByLex;
            public static System.Byte[] ZRemRangeByRank;
            public static System.Byte[] ZRemRangeByScore;
            public static System.Byte[] ZRevRange;
            public static System.Byte[] ZRevRangeByScore;
            public static System.Byte[] ZRevRank;
            public static System.Byte[] ZScan;
            public static System.Byte[] ZScore;
            public static System.Byte[] ZUnionStore;
        }

        // Generated from `ServiceStack.Redis.IHandleClientDispose` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IHandleClientDispose
        {
            void DisposeClient(ServiceStack.Redis.RedisNativeClient client);
        }

        // Generated from `ServiceStack.Redis.IHasRedisResolver` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IHasRedisResolver
        {
            ServiceStack.Redis.IRedisResolver RedisResolver { get; set; }
        }

        // Generated from `ServiceStack.Redis.IRedisFailover` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IRedisFailover
        {
            void FailoverTo(params string[] readWriteHosts);
            void FailoverTo(System.Collections.Generic.IEnumerable<string> readWriteHosts, System.Collections.Generic.IEnumerable<string> readOnlyHosts);
            System.Collections.Generic.List<System.Action<ServiceStack.Redis.IRedisClientsManager>> OnFailover { get; }
        }

        // Generated from `ServiceStack.Redis.IRedisResolver` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IRedisResolver
        {
            System.Func<ServiceStack.Redis.RedisEndpoint, ServiceStack.Redis.RedisClient> ClientFactory { get; set; }
            ServiceStack.Redis.RedisClient CreateMasterClient(int desiredIndex);
            ServiceStack.Redis.RedisClient CreateSlaveClient(int desiredIndex);
            int ReadOnlyHostsCount { get; }
            int ReadWriteHostsCount { get; }
            void ResetMasters(System.Collections.Generic.IEnumerable<string> hosts);
            void ResetSlaves(System.Collections.Generic.IEnumerable<string> hosts);
        }

        // Generated from `ServiceStack.Redis.IRedisResolverExtended` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IRedisResolverExtended : ServiceStack.Redis.IRedisResolver
        {
            ServiceStack.Redis.RedisClient CreateRedisClient(ServiceStack.Redis.RedisEndpoint config, bool master);
            ServiceStack.Redis.RedisEndpoint GetReadOnlyHost(int desiredIndex);
            ServiceStack.Redis.RedisEndpoint GetReadWriteHost(int desiredIndex);
        }

        // Generated from `ServiceStack.Redis.IRedisSentinel` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IRedisSentinel : System.IDisposable
        {
            ServiceStack.Redis.IRedisClientsManager Start();
        }

        // Generated from `ServiceStack.Redis.InvalidAccessException` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class InvalidAccessException : ServiceStack.Redis.RedisException
        {
            public InvalidAccessException(int threadId, string stackTrace) : base(default(string)) => throw null;
        }

        // Generated from `ServiceStack.Redis.PooledRedisClientManager` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class PooledRedisClientManager : System.IDisposable, System.IAsyncDisposable, ServiceStack.Redis.IRedisFailover, ServiceStack.Redis.IRedisClientsManagerAsync, ServiceStack.Redis.IRedisClientsManager, ServiceStack.Redis.IRedisClientCacheManager, ServiceStack.Redis.IHasRedisResolver, ServiceStack.Redis.IHandleClientDispose
        {
            public bool AssertAccessOnlyOnSameThread { get => throw null; set => throw null; }
            protected ServiceStack.Redis.RedisClientManagerConfig Config { get => throw null; set => throw null; }
            public int? ConnectTimeout { get => throw null; set => throw null; }
            public System.Action<ServiceStack.Redis.IRedisNativeClient> ConnectionFilter { get => throw null; set => throw null; }
            public System.Int64? Db { get => throw null; set => throw null; }
            // Generated from `ServiceStack.Redis.PooledRedisClientManager+DisposablePooledClient<>` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public class DisposablePooledClient<T> : System.IDisposable where T : ServiceStack.Redis.RedisNativeClient
            {
                public T Client { get => throw null; }
                public DisposablePooledClient(ServiceStack.Redis.PooledRedisClientManager clientManager) => throw null;
                public void Dispose() => throw null;
            }


            public void Dispose() => throw null;
            protected void Dispose(ServiceStack.Redis.RedisClient redisClient) => throw null;
            protected virtual void Dispose(bool disposing) => throw null;
            System.Threading.Tasks.ValueTask System.IAsyncDisposable.DisposeAsync() => throw null;
            public void DisposeClient(ServiceStack.Redis.RedisNativeClient client) => throw null;
            public void DisposeReadOnlyClient(ServiceStack.Redis.RedisNativeClient client) => throw null;
            public void DisposeWriteClient(ServiceStack.Redis.RedisNativeClient client) => throw null;
            public void FailoverTo(params string[] readWriteHosts) => throw null;
            public void FailoverTo(System.Collections.Generic.IEnumerable<string> readWriteHosts, System.Collections.Generic.IEnumerable<string> readOnlyHosts) => throw null;
            public ServiceStack.Caching.ICacheClient GetCacheClient() => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Caching.ICacheClientAsync> ServiceStack.Redis.IRedisClientsManagerAsync.GetCacheClientAsync(System.Threading.CancellationToken token) => throw null;
            public ServiceStack.Redis.IRedisClient GetClient() => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.IRedisClientAsync> ServiceStack.Redis.IRedisClientsManagerAsync.GetClientAsync(System.Threading.CancellationToken token) => throw null;
            public int[] GetClientPoolActiveStates() => throw null;
            public ServiceStack.Redis.PooledRedisClientManager.DisposablePooledClient<T> GetDisposableClient<T>() where T : ServiceStack.Redis.RedisNativeClient => throw null;
            public ServiceStack.Caching.ICacheClient GetReadOnlyCacheClient() => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Caching.ICacheClientAsync> ServiceStack.Redis.IRedisClientsManagerAsync.GetReadOnlyCacheClientAsync(System.Threading.CancellationToken token) => throw null;
            public virtual ServiceStack.Redis.IRedisClient GetReadOnlyClient() => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.IRedisClientAsync> ServiceStack.Redis.IRedisClientsManagerAsync.GetReadOnlyClientAsync(System.Threading.CancellationToken token) => throw null;
            public int[] GetReadOnlyClientPoolActiveStates() => throw null;
            public System.Collections.Generic.Dictionary<string, string> GetStats() => throw null;
            public int? IdleTimeOutSecs { get => throw null; set => throw null; }
            public string NamespacePrefix { get => throw null; set => throw null; }
            public System.Collections.Generic.List<System.Action<ServiceStack.Redis.IRedisClientsManager>> OnFailover { get => throw null; set => throw null; }
            protected virtual void OnStart() => throw null;
            protected int PoolSizeMultiplier;
            public int? PoolTimeout { get => throw null; set => throw null; }
            public PooledRedisClientManager(params string[] readWriteHosts) => throw null;
            public PooledRedisClientManager(int poolSize, int poolTimeOutSeconds, params string[] readWriteHosts) => throw null;
            public PooledRedisClientManager(System.Int64 initialDb, params string[] readWriteHosts) => throw null;
            public PooledRedisClientManager(System.Collections.Generic.IEnumerable<string> readWriteHosts, System.Collections.Generic.IEnumerable<string> readOnlyHosts, System.Int64 initialDb) => throw null;
            public PooledRedisClientManager(System.Collections.Generic.IEnumerable<string> readWriteHosts, System.Collections.Generic.IEnumerable<string> readOnlyHosts, ServiceStack.Redis.RedisClientManagerConfig config, System.Int64? initialDb, int? poolSizeMultiplier, int? poolTimeOutSeconds) => throw null;
            public PooledRedisClientManager(System.Collections.Generic.IEnumerable<string> readWriteHosts, System.Collections.Generic.IEnumerable<string> readOnlyHosts, ServiceStack.Redis.RedisClientManagerConfig config) => throw null;
            public PooledRedisClientManager(System.Collections.Generic.IEnumerable<string> readWriteHosts, System.Collections.Generic.IEnumerable<string> readOnlyHosts) => throw null;
            public PooledRedisClientManager() => throw null;
            protected int ReadPoolIndex;
            public int RecheckPoolAfterMs;
            protected int RedisClientCounter;
            public ServiceStack.Redis.IRedisResolver RedisResolver { get => throw null; set => throw null; }
            public int? SocketReceiveTimeout { get => throw null; set => throw null; }
            public int? SocketSendTimeout { get => throw null; set => throw null; }
            public void Start() => throw null;
            public static bool UseGetClientBlocking;
            protected int WritePoolIndex;
            // ERR: Stub generator didn't handle member: ~PooledRedisClientManager
        }

        // Generated from `ServiceStack.Redis.RedisAllPurposePipeline` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class RedisAllPurposePipeline : ServiceStack.Redis.RedisCommandQueue, System.IDisposable, System.IAsyncDisposable, ServiceStack.Redis.Pipeline.IRedisQueueableOperationAsync, ServiceStack.Redis.Pipeline.IRedisQueueableOperation, ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperationAsync, ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperation, ServiceStack.Redis.Pipeline.IRedisPipelineSharedAsync, ServiceStack.Redis.Pipeline.IRedisPipelineShared, ServiceStack.Redis.Pipeline.IRedisPipelineAsync, ServiceStack.Redis.Pipeline.IRedisPipeline
        {
            protected void ClosePipeline() => throw null;
            void ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperationAsync.CompleteBytesQueuedCommandAsync(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<System.Byte[]>> bytesReadCommand) => throw null;
            void ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperationAsync.CompleteDoubleQueuedCommandAsync(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<double>> doubleReadCommand) => throw null;
            void ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperationAsync.CompleteIntQueuedCommandAsync(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<int>> intReadCommand) => throw null;
            void ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperationAsync.CompleteLongQueuedCommandAsync(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<System.Int64>> longReadCommand) => throw null;
            void ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperationAsync.CompleteMultiBytesQueuedCommandAsync(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<System.Byte[][]>> multiBytesReadCommand) => throw null;
            void ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperationAsync.CompleteMultiStringQueuedCommandAsync(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>>> multiStringReadCommand) => throw null;
            void ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperationAsync.CompleteRedisDataQueuedCommandAsync(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisData>> redisDataReadCommand) => throw null;
            void ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperationAsync.CompleteStringQueuedCommandAsync(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<string>> stringReadCommand) => throw null;
            void ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperationAsync.CompleteVoidQueuedCommandAsync(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.ValueTask> voidReadCommand) => throw null;
            public virtual void Dispose() => throw null;
            System.Threading.Tasks.ValueTask System.IAsyncDisposable.DisposeAsync() => throw null;
            protected void Execute() => throw null;
            protected System.Threading.Tasks.ValueTask ExecuteAsync() => throw null;
            public void Flush() => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.Pipeline.IRedisPipelineSharedAsync.FlushAsync(System.Threading.CancellationToken token) => throw null;
            protected virtual void Init() => throw null;
            void ServiceStack.Redis.Pipeline.IRedisQueueableOperationAsync.QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask> command, System.Action onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
            void ServiceStack.Redis.Pipeline.IRedisQueueableOperationAsync.QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask<string>> command, System.Action<string> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
            void ServiceStack.Redis.Pipeline.IRedisQueueableOperationAsync.QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask<int>> command, System.Action<int> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
            void ServiceStack.Redis.Pipeline.IRedisQueueableOperationAsync.QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask<double>> command, System.Action<double> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
            void ServiceStack.Redis.Pipeline.IRedisQueueableOperationAsync.QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask<bool>> command, System.Action<bool> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
            void ServiceStack.Redis.Pipeline.IRedisQueueableOperationAsync.QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask<System.Int64>> command, System.Action<System.Int64> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
            void ServiceStack.Redis.Pipeline.IRedisQueueableOperationAsync.QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>>> command, System.Action<System.Collections.Generic.List<string>> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
            void ServiceStack.Redis.Pipeline.IRedisQueueableOperationAsync.QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<string>>> command, System.Action<System.Collections.Generic.HashSet<string>> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
            void ServiceStack.Redis.Pipeline.IRedisQueueableOperationAsync.QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask<System.Collections.Generic.Dictionary<string, string>>> command, System.Action<System.Collections.Generic.Dictionary<string, string>> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
            void ServiceStack.Redis.Pipeline.IRedisQueueableOperationAsync.QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask<System.Byte[][]>> command, System.Action<System.Byte[][]> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
            void ServiceStack.Redis.Pipeline.IRedisQueueableOperationAsync.QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask<System.Byte[]>> command, System.Action<System.Byte[]> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
            void ServiceStack.Redis.Pipeline.IRedisQueueableOperationAsync.QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisText>> command, System.Action<ServiceStack.Redis.RedisText> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
            void ServiceStack.Redis.Pipeline.IRedisQueueableOperationAsync.QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisData>> command, System.Action<ServiceStack.Redis.RedisData> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
            public RedisAllPurposePipeline(ServiceStack.Redis.RedisClient redisClient) : base(default(ServiceStack.Redis.RedisClient)) => throw null;
            public virtual bool Replay() => throw null;
            System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.Pipeline.IRedisPipelineSharedAsync.ReplayAsync(System.Threading.CancellationToken token) => throw null;
        }

        // Generated from `ServiceStack.Redis.RedisClient` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class RedisClient : ServiceStack.Redis.RedisNativeClient, System.IDisposable, System.IAsyncDisposable, ServiceStack.Redis.IRedisClientAsync, ServiceStack.Redis.IRedisClient, ServiceStack.Data.IEntityStoreAsync, ServiceStack.Data.IEntityStore, ServiceStack.Caching.IRemoveByPatternAsync, ServiceStack.Caching.IRemoveByPattern, ServiceStack.Caching.ICacheClientExtended, ServiceStack.Caching.ICacheClientAsync, ServiceStack.Caching.ICacheClient
        {
            public System.IDisposable AcquireLock(string key, System.TimeSpan timeOut) => throw null;
            public System.IDisposable AcquireLock(string key) => throw null;
            System.Threading.Tasks.ValueTask<System.IAsyncDisposable> ServiceStack.Redis.IRedisClientAsync.AcquireLockAsync(string key, System.TimeSpan? timeOut, System.Threading.CancellationToken token) => throw null;
            public bool Add<T>(string key, T value, System.TimeSpan expiresIn) => throw null;
            public bool Add<T>(string key, T value, System.DateTime expiresAt) => throw null;
            public bool Add<T>(string key, T value) => throw null;
            System.Threading.Tasks.Task<bool> ServiceStack.Caching.ICacheClientAsync.AddAsync<T>(string key, T value, System.TimeSpan expiresIn, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.Task<bool> ServiceStack.Caching.ICacheClientAsync.AddAsync<T>(string key, T value, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.Task<bool> ServiceStack.Caching.ICacheClientAsync.AddAsync<T>(string key, T value, System.DateTime expiresAt, System.Threading.CancellationToken token) => throw null;
            public System.Int64 AddGeoMember(string key, double longitude, double latitude, string member) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.AddGeoMemberAsync(string key, double longitude, double latitude, string member, System.Threading.CancellationToken token) => throw null;
            public System.Int64 AddGeoMembers(string key, params ServiceStack.Redis.RedisGeo[] geoPoints) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.AddGeoMembersAsync(string key, params ServiceStack.Redis.RedisGeo[] geoPoints) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.AddGeoMembersAsync(string key, ServiceStack.Redis.RedisGeo[] geoPoints, System.Threading.CancellationToken token) => throw null;
            public void AddItemToList(string listId, string value) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.AddItemToListAsync(string listId, string value, System.Threading.CancellationToken token) => throw null;
            public void AddItemToSet(string setId, string item) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.AddItemToSetAsync(string setId, string item, System.Threading.CancellationToken token) => throw null;
            public bool AddItemToSortedSet(string setId, string value, double score) => throw null;
            public bool AddItemToSortedSet(string setId, string value, System.Int64 score) => throw null;
            public bool AddItemToSortedSet(string setId, string value) => throw null;
            System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.IRedisClientAsync.AddItemToSortedSetAsync(string setId, string value, double score, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.IRedisClientAsync.AddItemToSortedSetAsync(string setId, string value, System.Threading.CancellationToken token) => throw null;
            public void AddRangeToList(string listId, System.Collections.Generic.List<string> values) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.AddRangeToListAsync(string listId, System.Collections.Generic.List<string> values, System.Threading.CancellationToken token) => throw null;
            public void AddRangeToSet(string setId, System.Collections.Generic.List<string> items) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.AddRangeToSetAsync(string setId, System.Collections.Generic.List<string> items, System.Threading.CancellationToken token) => throw null;
            public bool AddRangeToSortedSet(string setId, System.Collections.Generic.List<string> values, double score) => throw null;
            public bool AddRangeToSortedSet(string setId, System.Collections.Generic.List<string> values, System.Int64 score) => throw null;
            System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.IRedisClientAsync.AddRangeToSortedSetAsync(string setId, System.Collections.Generic.List<string> values, double score, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.IRedisClientAsync.AddRangeToSortedSetAsync(string setId, System.Collections.Generic.List<string> values, System.Int64 score, System.Threading.CancellationToken token) => throw null;
            public bool AddToHyperLog(string key, params string[] elements) => throw null;
            System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.IRedisClientAsync.AddToHyperLogAsync(string key, string[] elements, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.IRedisClientAsync.AddToHyperLogAsync(string key, params string[] elements) => throw null;
            public System.Int64 AppendToValue(string key, string value) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.AppendToValueAsync(string key, string value, System.Threading.CancellationToken token) => throw null;
            public ServiceStack.Redis.Generic.IRedisTypedClient<T> As<T>() => throw null;
            ServiceStack.Redis.Generic.IRedisTypedClientAsync<T> ServiceStack.Redis.IRedisClientAsync.As<T>() => throw null;
            public ServiceStack.Redis.IRedisClientAsync AsAsync() => throw null;
            public void AssertNotInTransaction() => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.BackgroundRewriteAppendOnlyFileAsync(System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.BackgroundSaveAsync(System.Threading.CancellationToken token) => throw null;
            public string BlockingDequeueItemFromList(string listId, System.TimeSpan? timeOut) => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisClientAsync.BlockingDequeueItemFromListAsync(string listId, System.TimeSpan? timeOut, System.Threading.CancellationToken token) => throw null;
            public ServiceStack.Redis.ItemRef BlockingDequeueItemFromLists(string[] listIds, System.TimeSpan? timeOut) => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.ItemRef> ServiceStack.Redis.IRedisClientAsync.BlockingDequeueItemFromListsAsync(string[] listIds, System.TimeSpan? timeOut, System.Threading.CancellationToken token) => throw null;
            public string BlockingPopAndPushItemBetweenLists(string fromListId, string toListId, System.TimeSpan? timeOut) => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisClientAsync.BlockingPopAndPushItemBetweenListsAsync(string fromListId, string toListId, System.TimeSpan? timeOut, System.Threading.CancellationToken token) => throw null;
            public string BlockingPopItemFromList(string listId, System.TimeSpan? timeOut) => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisClientAsync.BlockingPopItemFromListAsync(string listId, System.TimeSpan? timeOut, System.Threading.CancellationToken token) => throw null;
            public ServiceStack.Redis.ItemRef BlockingPopItemFromLists(string[] listIds, System.TimeSpan? timeOut) => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.ItemRef> ServiceStack.Redis.IRedisClientAsync.BlockingPopItemFromListsAsync(string[] listIds, System.TimeSpan? timeOut, System.Threading.CancellationToken token) => throw null;
            public string BlockingRemoveStartFromList(string listId, System.TimeSpan? timeOut) => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisClientAsync.BlockingRemoveStartFromListAsync(string listId, System.TimeSpan? timeOut, System.Threading.CancellationToken token) => throw null;
            public ServiceStack.Redis.ItemRef BlockingRemoveStartFromLists(string[] listIds, System.TimeSpan? timeOut) => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.ItemRef> ServiceStack.Redis.IRedisClientAsync.BlockingRemoveStartFromListsAsync(string[] listIds, System.TimeSpan? timeOut, System.Threading.CancellationToken token) => throw null;
            public double CalculateDistanceBetweenGeoMembers(string key, string fromMember, string toMember, string unit = default(string)) => throw null;
            System.Threading.Tasks.ValueTask<double> ServiceStack.Redis.IRedisClientAsync.CalculateDistanceBetweenGeoMembersAsync(string key, string fromMember, string toMember, string unit, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisClientAsync.CalculateSha1Async(string luaBody, System.Threading.CancellationToken token) => throw null;
            public ServiceStack.Redis.RedisClient CloneClient() => throw null;
            public bool ContainsKey(string key) => throw null;
            System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.IRedisClientAsync.ContainsKeyAsync(string key, System.Threading.CancellationToken token) => throw null;
            public static System.Func<object, System.Collections.Generic.Dictionary<string, string>> ConvertToHashFn;
            public System.DateTime ConvertToServerDate(System.DateTime expiresAt) => throw null;
            public System.Int64 CountHyperLog(string key) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.CountHyperLogAsync(string key, System.Threading.CancellationToken token) => throw null;
            public ServiceStack.Redis.Pipeline.IRedisPipeline CreatePipeline() => throw null;
            ServiceStack.Redis.Pipeline.IRedisPipelineAsync ServiceStack.Redis.IRedisClientAsync.CreatePipeline() => throw null;
            public override ServiceStack.Redis.IRedisSubscription CreateSubscription() => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.IRedisSubscriptionAsync> ServiceStack.Redis.IRedisClientAsync.CreateSubscriptionAsync(System.Threading.CancellationToken token) => throw null;
            public ServiceStack.Redis.IRedisTransaction CreateTransaction() => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.IRedisTransactionAsync> ServiceStack.Redis.IRedisClientAsync.CreateTransactionAsync(System.Threading.CancellationToken token) => throw null;
            public ServiceStack.Redis.RedisText Custom(params object[] cmdWithArgs) => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisText> ServiceStack.Redis.IRedisClientAsync.CustomAsync(params object[] cmdWithArgs) => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisText> ServiceStack.Redis.IRedisClientAsync.CustomAsync(object[] cmdWithArgs, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.DbSizeAsync(System.Threading.CancellationToken token) => throw null;
            public System.Int64 Decrement(string key, System.UInt32 amount) => throw null;
            System.Threading.Tasks.Task<System.Int64> ServiceStack.Caching.ICacheClientAsync.DecrementAsync(string key, System.UInt32 amount, System.Threading.CancellationToken token) => throw null;
            public System.Int64 DecrementValue(string key) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.DecrementValueAsync(string key, System.Threading.CancellationToken token) => throw null;
            public System.Int64 DecrementValueBy(string key, int count) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.DecrementValueByAsync(string key, int count, System.Threading.CancellationToken token) => throw null;
            public void Delete<T>(T entity) => throw null;
            public void DeleteAll<T>() => throw null;
            System.Threading.Tasks.Task ServiceStack.Data.IEntityStoreAsync.DeleteAllAsync<T>(System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.Task ServiceStack.Data.IEntityStoreAsync.DeleteAsync<T>(T entity, System.Threading.CancellationToken token) => throw null;
            public void DeleteById<T>(object id) => throw null;
            System.Threading.Tasks.Task ServiceStack.Data.IEntityStoreAsync.DeleteByIdAsync<T>(object id, System.Threading.CancellationToken token) => throw null;
            public void DeleteByIds<T>(System.Collections.ICollection ids) => throw null;
            System.Threading.Tasks.Task ServiceStack.Data.IEntityStoreAsync.DeleteByIdsAsync<T>(System.Collections.ICollection ids, System.Threading.CancellationToken token) => throw null;
            public string DequeueItemFromList(string listId) => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisClientAsync.DequeueItemFromListAsync(string listId, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask System.IAsyncDisposable.DisposeAsync() => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisClientAsync.EchoAsync(string text, System.Threading.CancellationToken token) => throw null;
            public void EnqueueItemOnList(string listId, string value) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.EnqueueItemOnListAsync(string listId, string value, System.Threading.CancellationToken token) => throw null;
            public void Exec(System.Action<ServiceStack.Redis.RedisClient> action) => throw null;
            public T Exec<T>(System.Func<ServiceStack.Redis.RedisClient, T> action) => throw null;
            public T ExecCachedLua<T>(string scriptBody, System.Func<string, T> scriptSha1) => throw null;
            System.Threading.Tasks.ValueTask<T> ServiceStack.Redis.IRedisClientAsync.ExecCachedLuaAsync<T>(string scriptBody, System.Func<string, System.Threading.Tasks.ValueTask<T>> scriptSha1, System.Threading.CancellationToken token) => throw null;
            public ServiceStack.Redis.RedisText ExecLua(string luaBody, string[] keys, string[] args) => throw null;
            public ServiceStack.Redis.RedisText ExecLua(string body, params string[] args) => throw null;
            public System.Int64 ExecLuaAsInt(string luaBody, string[] keys, string[] args) => throw null;
            public System.Int64 ExecLuaAsInt(string body, params string[] args) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.ExecLuaAsIntAsync(string luaBody, params string[] args) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.ExecLuaAsIntAsync(string body, string[] keys, string[] args, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.ExecLuaAsIntAsync(string body, string[] args, System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.List<string> ExecLuaAsList(string luaBody, string[] keys, string[] args) => throw null;
            public System.Collections.Generic.List<string> ExecLuaAsList(string body, params string[] args) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ServiceStack.Redis.IRedisClientAsync.ExecLuaAsListAsync(string luaBody, params string[] args) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ServiceStack.Redis.IRedisClientAsync.ExecLuaAsListAsync(string body, string[] keys, string[] args, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ServiceStack.Redis.IRedisClientAsync.ExecLuaAsListAsync(string body, string[] args, System.Threading.CancellationToken token) => throw null;
            public string ExecLuaAsString(string sha1, string[] keys, string[] args) => throw null;
            public string ExecLuaAsString(string body, params string[] args) => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisClientAsync.ExecLuaAsStringAsync(string luaBody, string[] keys, string[] args, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisClientAsync.ExecLuaAsStringAsync(string luaBody, params string[] args) => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisClientAsync.ExecLuaAsStringAsync(string body, string[] args, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisText> ServiceStack.Redis.IRedisClientAsync.ExecLuaAsync(string luaBody, string[] keys, string[] args, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisText> ServiceStack.Redis.IRedisClientAsync.ExecLuaAsync(string body, string[] args, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisText> ServiceStack.Redis.IRedisClientAsync.ExecLuaAsync(string body, params string[] args) => throw null;
            public ServiceStack.Redis.RedisText ExecLuaSha(string sha1, string[] keys, string[] args) => throw null;
            public ServiceStack.Redis.RedisText ExecLuaSha(string sha1, params string[] args) => throw null;
            public System.Int64 ExecLuaShaAsInt(string sha1, string[] keys, string[] args) => throw null;
            public System.Int64 ExecLuaShaAsInt(string sha1, params string[] args) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.ExecLuaShaAsIntAsync(string sha1, string[] keys, string[] args, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.ExecLuaShaAsIntAsync(string sha1, string[] args, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.ExecLuaShaAsIntAsync(string sha1, params string[] args) => throw null;
            public System.Collections.Generic.List<string> ExecLuaShaAsList(string sha1, string[] keys, string[] args) => throw null;
            public System.Collections.Generic.List<string> ExecLuaShaAsList(string sha1, params string[] args) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ServiceStack.Redis.IRedisClientAsync.ExecLuaShaAsListAsync(string sha1, string[] keys, string[] args, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ServiceStack.Redis.IRedisClientAsync.ExecLuaShaAsListAsync(string sha1, string[] args, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ServiceStack.Redis.IRedisClientAsync.ExecLuaShaAsListAsync(string sha1, params string[] args) => throw null;
            public string ExecLuaShaAsString(string sha1, string[] keys, string[] args) => throw null;
            public string ExecLuaShaAsString(string sha1, params string[] args) => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisClientAsync.ExecLuaShaAsStringAsync(string sha1, string[] keys, string[] args, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisClientAsync.ExecLuaShaAsStringAsync(string sha1, string[] args, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisClientAsync.ExecLuaShaAsStringAsync(string sha1, params string[] args) => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisText> ServiceStack.Redis.IRedisClientAsync.ExecLuaShaAsync(string sha1, string[] keys, string[] args, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisText> ServiceStack.Redis.IRedisClientAsync.ExecLuaShaAsync(string sha1, string[] args, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisText> ServiceStack.Redis.IRedisClientAsync.ExecLuaShaAsync(string sha1, params string[] args) => throw null;
            public bool ExpireEntryAt(string key, System.DateTime expireAt) => throw null;
            System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.IRedisClientAsync.ExpireEntryAtAsync(string key, System.DateTime expireAt, System.Threading.CancellationToken token) => throw null;
            public bool ExpireEntryIn(string key, System.TimeSpan expireIn) => throw null;
            public bool ExpireEntryIn(System.Byte[] key, System.TimeSpan expireIn) => throw null;
            System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.IRedisClientAsync.ExpireEntryInAsync(string key, System.TimeSpan expireIn, System.Threading.CancellationToken token) => throw null;
            public string[] FindGeoMembersInRadius(string key, string member, double radius, string unit) => throw null;
            public string[] FindGeoMembersInRadius(string key, double longitude, double latitude, double radius, string unit) => throw null;
            System.Threading.Tasks.ValueTask<string[]> ServiceStack.Redis.IRedisClientAsync.FindGeoMembersInRadiusAsync(string key, string member, double radius, string unit, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<string[]> ServiceStack.Redis.IRedisClientAsync.FindGeoMembersInRadiusAsync(string key, double longitude, double latitude, double radius, string unit, System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.List<ServiceStack.Redis.RedisGeoResult> FindGeoResultsInRadius(string key, string member, double radius, string unit, int? count = default(int?), bool? sortByNearest = default(bool?)) => throw null;
            public System.Collections.Generic.List<ServiceStack.Redis.RedisGeoResult> FindGeoResultsInRadius(string key, double longitude, double latitude, double radius, string unit, int? count = default(int?), bool? sortByNearest = default(bool?)) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<ServiceStack.Redis.RedisGeoResult>> ServiceStack.Redis.IRedisClientAsync.FindGeoResultsInRadiusAsync(string key, string member, double radius, string unit, int? count, bool? sortByNearest, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<ServiceStack.Redis.RedisGeoResult>> ServiceStack.Redis.IRedisClientAsync.FindGeoResultsInRadiusAsync(string key, double longitude, double latitude, double radius, string unit, int? count, bool? sortByNearest, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.Task ServiceStack.Caching.ICacheClientAsync.FlushAllAsync(System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.FlushDbAsync(System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.ForegroundSaveAsync(System.Threading.CancellationToken token) => throw null;
            public T Get<T>(string key) => throw null;
            public System.Collections.Generic.IList<T> GetAll<T>() => throw null;
            public System.Collections.Generic.IDictionary<string, T> GetAll<T>(System.Collections.Generic.IEnumerable<string> keys) => throw null;
            System.Threading.Tasks.Task<System.Collections.Generic.IDictionary<string, T>> ServiceStack.Caching.ICacheClientAsync.GetAllAsync<T>(System.Collections.Generic.IEnumerable<string> keys, System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.Dictionary<string, string> GetAllEntriesFromHash(string hashId) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.Dictionary<string, string>> ServiceStack.Redis.IRedisClientAsync.GetAllEntriesFromHashAsync(string hashId, System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.List<string> GetAllItemsFromList(string listId) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ServiceStack.Redis.IRedisClientAsync.GetAllItemsFromListAsync(string listId, System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.HashSet<string> GetAllItemsFromSet(string setId) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<string>> ServiceStack.Redis.IRedisClientAsync.GetAllItemsFromSetAsync(string setId, System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.List<string> GetAllItemsFromSortedSet(string setId) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ServiceStack.Redis.IRedisClientAsync.GetAllItemsFromSortedSetAsync(string setId, System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.List<string> GetAllItemsFromSortedSetDesc(string setId) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ServiceStack.Redis.IRedisClientAsync.GetAllItemsFromSortedSetDescAsync(string setId, System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.List<string> GetAllKeys() => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ServiceStack.Redis.IRedisClientAsync.GetAllKeysAsync(System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.IDictionary<string, double> GetAllWithScoresFromSortedSet(string setId) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> ServiceStack.Redis.IRedisClientAsync.GetAllWithScoresFromSortedSetAsync(string setId, System.Threading.CancellationToken token) => throw null;
            public string GetAndSetValue(string key, string value) => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisClientAsync.GetAndSetValueAsync(string key, string value, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.Task<T> ServiceStack.Caching.ICacheClientAsync.GetAsync<T>(string key, System.Threading.CancellationToken token) => throw null;
            public T GetById<T>(object id) => throw null;
            System.Threading.Tasks.Task<T> ServiceStack.Data.IEntityStoreAsync.GetByIdAsync<T>(object id, System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.IList<T> GetByIds<T>(System.Collections.ICollection ids) => throw null;
            System.Threading.Tasks.Task<System.Collections.Generic.IList<T>> ServiceStack.Data.IEntityStoreAsync.GetByIdsAsync<T>(System.Collections.ICollection ids, System.Threading.CancellationToken token) => throw null;
            public string GetClient() => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisClientAsync.GetClientAsync(System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.List<System.Collections.Generic.Dictionary<string, string>> GetClientsInfo() => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<System.Collections.Generic.Dictionary<string, string>>> ServiceStack.Redis.IRedisClientAsync.GetClientsInfoAsync(System.Threading.CancellationToken token) => throw null;
            public string GetConfig(string configItem) => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisClientAsync.GetConfigAsync(string configItem, System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.HashSet<string> GetDifferencesFromSet(string fromSetId, params string[] withSetIds) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<string>> ServiceStack.Redis.IRedisClientAsync.GetDifferencesFromSetAsync(string fromSetId, string[] withSetIds, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<string>> ServiceStack.Redis.IRedisClientAsync.GetDifferencesFromSetAsync(string fromSetId, params string[] withSetIds) => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisKeyType> ServiceStack.Redis.IRedisClientAsync.GetEntryTypeAsync(string key, System.Threading.CancellationToken token) => throw null;
            public T GetFromHash<T>(object id) => throw null;
            System.Threading.Tasks.ValueTask<T> ServiceStack.Redis.IRedisClientAsync.GetFromHashAsync<T>(object id, System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.List<ServiceStack.Redis.RedisGeo> GetGeoCoordinates(string key, params string[] members) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<ServiceStack.Redis.RedisGeo>> ServiceStack.Redis.IRedisClientAsync.GetGeoCoordinatesAsync(string key, string[] members, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<ServiceStack.Redis.RedisGeo>> ServiceStack.Redis.IRedisClientAsync.GetGeoCoordinatesAsync(string key, params string[] members) => throw null;
            public string[] GetGeohashes(string key, params string[] members) => throw null;
            System.Threading.Tasks.ValueTask<string[]> ServiceStack.Redis.IRedisClientAsync.GetGeohashesAsync(string key, string[] members, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<string[]> ServiceStack.Redis.IRedisClientAsync.GetGeohashesAsync(string key, params string[] members) => throw null;
            public System.Int64 GetHashCount(string hashId) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.GetHashCountAsync(string hashId, System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.List<string> GetHashKeys(string hashId) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ServiceStack.Redis.IRedisClientAsync.GetHashKeysAsync(string hashId, System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.List<string> GetHashValues(string hashId) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ServiceStack.Redis.IRedisClientAsync.GetHashValuesAsync(string hashId, System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.HashSet<string> GetIntersectFromSets(params string[] setIds) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<string>> ServiceStack.Redis.IRedisClientAsync.GetIntersectFromSetsAsync(string[] setIds, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<string>> ServiceStack.Redis.IRedisClientAsync.GetIntersectFromSetsAsync(params string[] setIds) => throw null;
            public string GetItemFromList(string listId, int listIndex) => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisClientAsync.GetItemFromListAsync(string listId, int listIndex, System.Threading.CancellationToken token) => throw null;
            public System.Int64 GetItemIndexInSortedSet(string setId, string value) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.GetItemIndexInSortedSetAsync(string setId, string value, System.Threading.CancellationToken token) => throw null;
            public System.Int64 GetItemIndexInSortedSetDesc(string setId, string value) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.GetItemIndexInSortedSetDescAsync(string setId, string value, System.Threading.CancellationToken token) => throw null;
            public double GetItemScoreInSortedSet(string setId, string value) => throw null;
            System.Threading.Tasks.ValueTask<double> ServiceStack.Redis.IRedisClientAsync.GetItemScoreInSortedSetAsync(string setId, string value, System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.IEnumerable<string> GetKeysByPattern(string pattern) => throw null;
            System.Collections.Generic.IAsyncEnumerable<string> ServiceStack.Caching.ICacheClientAsync.GetKeysByPatternAsync(string pattern, System.Threading.CancellationToken token) => throw null;
            public static double GetLexicalScore(string value) => throw null;
            public System.Int64 GetListCount(string listId) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.GetListCountAsync(string listId, System.Threading.CancellationToken token) => throw null;
            public string GetRandomItemFromSet(string setId) => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisClientAsync.GetRandomItemFromSetAsync(string setId, System.Threading.CancellationToken token) => throw null;
            public string GetRandomKey() => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisClientAsync.GetRandomKeyAsync(System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.List<string> GetRangeFromList(string listId, int startingFrom, int endingAt) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ServiceStack.Redis.IRedisClientAsync.GetRangeFromListAsync(string listId, int startingFrom, int endingAt, System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.List<string> GetRangeFromSortedList(string listId, int startingFrom, int endingAt) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ServiceStack.Redis.IRedisClientAsync.GetRangeFromSortedListAsync(string listId, int startingFrom, int endingAt, System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.List<string> GetRangeFromSortedSet(string setId, int fromRank, int toRank) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ServiceStack.Redis.IRedisClientAsync.GetRangeFromSortedSetAsync(string setId, int fromRank, int toRank, System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.List<string> GetRangeFromSortedSetByHighestScore(string setId, string fromStringScore, string toStringScore, int? skip, int? take) => throw null;
            public System.Collections.Generic.List<string> GetRangeFromSortedSetByHighestScore(string setId, string fromStringScore, string toStringScore) => throw null;
            public System.Collections.Generic.List<string> GetRangeFromSortedSetByHighestScore(string setId, double fromScore, double toScore, int? skip, int? take) => throw null;
            public System.Collections.Generic.List<string> GetRangeFromSortedSetByHighestScore(string setId, double fromScore, double toScore) => throw null;
            public System.Collections.Generic.List<string> GetRangeFromSortedSetByHighestScore(string setId, System.Int64 fromScore, System.Int64 toScore, int? skip, int? take) => throw null;
            public System.Collections.Generic.List<string> GetRangeFromSortedSetByHighestScore(string setId, System.Int64 fromScore, System.Int64 toScore) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ServiceStack.Redis.IRedisClientAsync.GetRangeFromSortedSetByHighestScoreAsync(string setId, string fromStringScore, string toStringScore, int? skip, int? take, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ServiceStack.Redis.IRedisClientAsync.GetRangeFromSortedSetByHighestScoreAsync(string setId, string fromStringScore, string toStringScore, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ServiceStack.Redis.IRedisClientAsync.GetRangeFromSortedSetByHighestScoreAsync(string setId, double fromScore, double toScore, int? skip, int? take, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ServiceStack.Redis.IRedisClientAsync.GetRangeFromSortedSetByHighestScoreAsync(string setId, double fromScore, double toScore, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ServiceStack.Redis.IRedisClientAsync.GetRangeFromSortedSetByHighestScoreAsync(string setId, System.Int64 fromScore, System.Int64 toScore, int? skip, int? take, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ServiceStack.Redis.IRedisClientAsync.GetRangeFromSortedSetByHighestScoreAsync(string setId, System.Int64 fromScore, System.Int64 toScore, System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.List<string> GetRangeFromSortedSetByLowestScore(string setId, string fromStringScore, string toStringScore, int? skip, int? take) => throw null;
            public System.Collections.Generic.List<string> GetRangeFromSortedSetByLowestScore(string setId, string fromStringScore, string toStringScore) => throw null;
            public System.Collections.Generic.List<string> GetRangeFromSortedSetByLowestScore(string setId, double fromScore, double toScore, int? skip, int? take) => throw null;
            public System.Collections.Generic.List<string> GetRangeFromSortedSetByLowestScore(string setId, double fromScore, double toScore) => throw null;
            public System.Collections.Generic.List<string> GetRangeFromSortedSetByLowestScore(string setId, System.Int64 fromScore, System.Int64 toScore, int? skip, int? take) => throw null;
            public System.Collections.Generic.List<string> GetRangeFromSortedSetByLowestScore(string setId, System.Int64 fromScore, System.Int64 toScore) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ServiceStack.Redis.IRedisClientAsync.GetRangeFromSortedSetByLowestScoreAsync(string setId, string fromStringScore, string toStringScore, int? skip, int? take, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ServiceStack.Redis.IRedisClientAsync.GetRangeFromSortedSetByLowestScoreAsync(string setId, string fromStringScore, string toStringScore, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ServiceStack.Redis.IRedisClientAsync.GetRangeFromSortedSetByLowestScoreAsync(string setId, double fromScore, double toScore, int? skip, int? take, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ServiceStack.Redis.IRedisClientAsync.GetRangeFromSortedSetByLowestScoreAsync(string setId, double fromScore, double toScore, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ServiceStack.Redis.IRedisClientAsync.GetRangeFromSortedSetByLowestScoreAsync(string setId, System.Int64 fromScore, System.Int64 toScore, int? skip, int? take, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ServiceStack.Redis.IRedisClientAsync.GetRangeFromSortedSetByLowestScoreAsync(string setId, System.Int64 fromScore, System.Int64 toScore, System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.List<string> GetRangeFromSortedSetDesc(string setId, int fromRank, int toRank) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ServiceStack.Redis.IRedisClientAsync.GetRangeFromSortedSetDescAsync(string setId, int fromRank, int toRank, System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSet(string setId, int fromRank, int toRank) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> ServiceStack.Redis.IRedisClientAsync.GetRangeWithScoresFromSortedSetAsync(string setId, int fromRank, int toRank, System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetByHighestScore(string setId, string fromStringScore, string toStringScore, int? skip, int? take) => throw null;
            public System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetByHighestScore(string setId, string fromStringScore, string toStringScore) => throw null;
            public System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetByHighestScore(string setId, double fromScore, double toScore, int? skip, int? take) => throw null;
            public System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetByHighestScore(string setId, double fromScore, double toScore) => throw null;
            public System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetByHighestScore(string setId, System.Int64 fromScore, System.Int64 toScore, int? skip, int? take) => throw null;
            public System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetByHighestScore(string setId, System.Int64 fromScore, System.Int64 toScore) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> ServiceStack.Redis.IRedisClientAsync.GetRangeWithScoresFromSortedSetByHighestScoreAsync(string setId, string fromStringScore, string toStringScore, int? skip, int? take, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> ServiceStack.Redis.IRedisClientAsync.GetRangeWithScoresFromSortedSetByHighestScoreAsync(string setId, string fromStringScore, string toStringScore, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> ServiceStack.Redis.IRedisClientAsync.GetRangeWithScoresFromSortedSetByHighestScoreAsync(string setId, double fromScore, double toScore, int? skip, int? take, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> ServiceStack.Redis.IRedisClientAsync.GetRangeWithScoresFromSortedSetByHighestScoreAsync(string setId, double fromScore, double toScore, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> ServiceStack.Redis.IRedisClientAsync.GetRangeWithScoresFromSortedSetByHighestScoreAsync(string setId, System.Int64 fromScore, System.Int64 toScore, int? skip, int? take, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> ServiceStack.Redis.IRedisClientAsync.GetRangeWithScoresFromSortedSetByHighestScoreAsync(string setId, System.Int64 fromScore, System.Int64 toScore, System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetByLowestScore(string setId, string fromStringScore, string toStringScore, int? skip, int? take) => throw null;
            public System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetByLowestScore(string setId, string fromStringScore, string toStringScore) => throw null;
            public System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetByLowestScore(string setId, double fromScore, double toScore, int? skip, int? take) => throw null;
            public System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetByLowestScore(string setId, double fromScore, double toScore) => throw null;
            public System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetByLowestScore(string setId, System.Int64 fromScore, System.Int64 toScore, int? skip, int? take) => throw null;
            public System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetByLowestScore(string setId, System.Int64 fromScore, System.Int64 toScore) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> ServiceStack.Redis.IRedisClientAsync.GetRangeWithScoresFromSortedSetByLowestScoreAsync(string setId, string fromStringScore, string toStringScore, int? skip, int? take, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> ServiceStack.Redis.IRedisClientAsync.GetRangeWithScoresFromSortedSetByLowestScoreAsync(string setId, string fromStringScore, string toStringScore, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> ServiceStack.Redis.IRedisClientAsync.GetRangeWithScoresFromSortedSetByLowestScoreAsync(string setId, double fromScore, double toScore, int? skip, int? take, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> ServiceStack.Redis.IRedisClientAsync.GetRangeWithScoresFromSortedSetByLowestScoreAsync(string setId, double fromScore, double toScore, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> ServiceStack.Redis.IRedisClientAsync.GetRangeWithScoresFromSortedSetByLowestScoreAsync(string setId, System.Int64 fromScore, System.Int64 toScore, int? skip, int? take, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> ServiceStack.Redis.IRedisClientAsync.GetRangeWithScoresFromSortedSetByLowestScoreAsync(string setId, System.Int64 fromScore, System.Int64 toScore, System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetDesc(string setId, int fromRank, int toRank) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> ServiceStack.Redis.IRedisClientAsync.GetRangeWithScoresFromSortedSetDescAsync(string setId, int fromRank, int toRank, System.Threading.CancellationToken token) => throw null;
            public ServiceStack.Redis.RedisServerRole GetServerRole() => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisServerRole> ServiceStack.Redis.IRedisClientAsync.GetServerRoleAsync(System.Threading.CancellationToken token) => throw null;
            public ServiceStack.Redis.RedisText GetServerRoleInfo() => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisText> ServiceStack.Redis.IRedisClientAsync.GetServerRoleInfoAsync(System.Threading.CancellationToken token) => throw null;
            public System.DateTime GetServerTime() => throw null;
            System.Threading.Tasks.ValueTask<System.DateTime> ServiceStack.Redis.IRedisClientAsync.GetServerTimeAsync(System.Threading.CancellationToken token) => throw null;
            public System.Int64 GetSetCount(string setId) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.GetSetCountAsync(string setId, System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.IEnumerable<ServiceStack.Redis.SlowlogItem> GetSlowlog(int? numberOfRecords = default(int?)) => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.SlowlogItem[]> ServiceStack.Redis.IRedisClientAsync.GetSlowlogAsync(int? numberOfRecords, System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.List<string> GetSortedEntryValues(string setId, int startingFrom, int endingAt) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ServiceStack.Redis.IRedisClientAsync.GetSortedEntryValuesAsync(string setId, int startingFrom, int endingAt, System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.List<string> GetSortedItemsFromList(string listId, ServiceStack.Redis.SortOptions sortOptions) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ServiceStack.Redis.IRedisClientAsync.GetSortedItemsFromListAsync(string listId, ServiceStack.Redis.SortOptions sortOptions, System.Threading.CancellationToken token) => throw null;
            public System.Int64 GetSortedSetCount(string setId, string fromStringScore, string toStringScore) => throw null;
            public System.Int64 GetSortedSetCount(string setId, double fromScore, double toScore) => throw null;
            public System.Int64 GetSortedSetCount(string setId, System.Int64 fromScore, System.Int64 toScore) => throw null;
            public System.Int64 GetSortedSetCount(string setId) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.GetSortedSetCountAsync(string setId, string fromStringScore, string toStringScore, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.GetSortedSetCountAsync(string setId, double fromScore, double toScore, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.GetSortedSetCountAsync(string setId, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.GetSortedSetCountAsync(string setId, System.Int64 fromScore, System.Int64 toScore, System.Threading.CancellationToken token) => throw null;
            public System.Int64 GetStringCount(string key) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.GetStringCountAsync(string key, System.Threading.CancellationToken token) => throw null;
            public System.TimeSpan? GetTimeToLive(string key) => throw null;
            System.Threading.Tasks.Task<System.TimeSpan?> ServiceStack.Caching.ICacheClientAsync.GetTimeToLiveAsync(string key, System.Threading.CancellationToken token) => throw null;
            public string GetTypeIdsSetKey<T>() => throw null;
            public string GetTypeIdsSetKey(System.Type type) => throw null;
            public string GetTypeSequenceKey<T>() => throw null;
            public System.Collections.Generic.HashSet<string> GetUnionFromSets(params string[] setIds) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<string>> ServiceStack.Redis.IRedisClientAsync.GetUnionFromSetsAsync(string[] setIds, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<string>> ServiceStack.Redis.IRedisClientAsync.GetUnionFromSetsAsync(params string[] setIds) => throw null;
            public string GetValue(string key) => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisClientAsync.GetValueAsync(string key, System.Threading.CancellationToken token) => throw null;
            public string GetValueFromHash(string hashId, string key) => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisClientAsync.GetValueFromHashAsync(string hashId, string key, System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.List<string> GetValues(System.Collections.Generic.List<string> keys) => throw null;
            public System.Collections.Generic.List<T> GetValues<T>(System.Collections.Generic.List<string> keys) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ServiceStack.Redis.IRedisClientAsync.GetValuesAsync(System.Collections.Generic.List<string> keys, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> ServiceStack.Redis.IRedisClientAsync.GetValuesAsync<T>(System.Collections.Generic.List<string> keys, System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.List<string> GetValuesFromHash(string hashId, params string[] keys) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ServiceStack.Redis.IRedisClientAsync.GetValuesFromHashAsync(string hashId, string[] keys, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ServiceStack.Redis.IRedisClientAsync.GetValuesFromHashAsync(string hashId, params string[] keys) => throw null;
            public System.Collections.Generic.Dictionary<string, string> GetValuesMap(System.Collections.Generic.List<string> keys) => throw null;
            public System.Collections.Generic.Dictionary<string, T> GetValuesMap<T>(System.Collections.Generic.List<string> keys) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.Dictionary<string, string>> ServiceStack.Redis.IRedisClientAsync.GetValuesMapAsync(System.Collections.Generic.List<string> keys, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.Dictionary<string, T>> ServiceStack.Redis.IRedisClientAsync.GetValuesMapAsync<T>(System.Collections.Generic.List<string> keys, System.Threading.CancellationToken token) => throw null;
            public bool HasLuaScript(string sha1Ref) => throw null;
            System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.IRedisClientAsync.HasLuaScriptAsync(string sha1Ref, System.Threading.CancellationToken token) => throw null;
            public bool HashContainsEntry(string hashId, string key) => throw null;
            System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.IRedisClientAsync.HashContainsEntryAsync(string hashId, string key, System.Threading.CancellationToken token) => throw null;
            public ServiceStack.Model.IHasNamed<ServiceStack.Redis.IRedisHash> Hashes { get => throw null; set => throw null; }
            ServiceStack.Model.IHasNamed<ServiceStack.Redis.IRedisHashAsync> ServiceStack.Redis.IRedisClientAsync.Hashes { get => throw null; }
            public System.Int64 Increment(string key, System.UInt32 amount) => throw null;
            System.Threading.Tasks.Task<System.Int64> ServiceStack.Caching.ICacheClientAsync.IncrementAsync(string key, System.UInt32 amount, System.Threading.CancellationToken token) => throw null;
            public double IncrementItemInSortedSet(string setId, string value, double incrementBy) => throw null;
            public double IncrementItemInSortedSet(string setId, string value, System.Int64 incrementBy) => throw null;
            System.Threading.Tasks.ValueTask<double> ServiceStack.Redis.IRedisClientAsync.IncrementItemInSortedSetAsync(string setId, string value, double incrementBy, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<double> ServiceStack.Redis.IRedisClientAsync.IncrementItemInSortedSetAsync(string setId, string value, System.Int64 incrementBy, System.Threading.CancellationToken token) => throw null;
            public System.Int64 IncrementValue(string key) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.IncrementValueAsync(string key, System.Threading.CancellationToken token) => throw null;
            public double IncrementValueBy(string key, double count) => throw null;
            public System.Int64 IncrementValueBy(string key, int count) => throw null;
            public System.Int64 IncrementValueBy(string key, System.Int64 count) => throw null;
            System.Threading.Tasks.ValueTask<double> ServiceStack.Redis.IRedisClientAsync.IncrementValueByAsync(string key, double count, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.IncrementValueByAsync(string key, int count, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.IncrementValueByAsync(string key, System.Int64 count, System.Threading.CancellationToken token) => throw null;
            public double IncrementValueInHash(string hashId, string key, double incrementBy) => throw null;
            public System.Int64 IncrementValueInHash(string hashId, string key, int incrementBy) => throw null;
            public System.Int64 IncrementValueInHash(string hashId, string key, System.Int64 incrementBy) => throw null;
            System.Threading.Tasks.ValueTask<double> ServiceStack.Redis.IRedisClientAsync.IncrementValueInHashAsync(string hashId, string key, double incrementBy, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.IncrementValueInHashAsync(string hashId, string key, int incrementBy, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.Dictionary<string, string>> ServiceStack.Redis.IRedisClientAsync.InfoAsync(System.Threading.CancellationToken token) => throw null;
            public void Init() => throw null;
            public string this[string key] { get => throw null; set => throw null; }
            public void KillClient(string address) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.KillClientAsync(string address, System.Threading.CancellationToken token) => throw null;
            public System.Int64 KillClients(string fromAddress = default(string), string withId = default(string), ServiceStack.Redis.RedisClientType? ofType = default(ServiceStack.Redis.RedisClientType?), bool? skipMe = default(bool?)) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.KillClientsAsync(string fromAddress, string withId, ServiceStack.Redis.RedisClientType? ofType, bool? skipMe, System.Threading.CancellationToken token) => throw null;
            public void KillRunningLuaScript() => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.KillRunningLuaScriptAsync(System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.DateTime> ServiceStack.Redis.IRedisClientAsync.LastSaveAsync(System.Threading.CancellationToken token) => throw null;
            public ServiceStack.Model.IHasNamed<ServiceStack.Redis.IRedisList> Lists { get => throw null; set => throw null; }
            ServiceStack.Model.IHasNamed<ServiceStack.Redis.IRedisListAsync> ServiceStack.Redis.IRedisClientAsync.Lists { get => throw null; }
            public string LoadLuaScript(string body) => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisClientAsync.LoadLuaScriptAsync(string body, System.Threading.CancellationToken token) => throw null;
            public void MergeHyperLogs(string toKey, params string[] fromKeys) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.MergeHyperLogsAsync(string toKey, string[] fromKeys, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.MergeHyperLogsAsync(string toKey, params string[] fromKeys) => throw null;
            public void MoveBetweenSets(string fromSetId, string toSetId, string item) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.MoveBetweenSetsAsync(string fromSetId, string toSetId, string item, System.Threading.CancellationToken token) => throw null;
            public static ServiceStack.Redis.RedisClient New() => throw null;
            public static System.Func<ServiceStack.Redis.RedisClient> NewFactoryFn;
            public override void OnConnected() => throw null;
            public void PauseAllClients(System.TimeSpan duration) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.PauseAllClientsAsync(System.TimeSpan duration, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.IRedisClientAsync.PingAsync(System.Threading.CancellationToken token) => throw null;
            public string PopAndPushItemBetweenLists(string fromListId, string toListId) => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisClientAsync.PopAndPushItemBetweenListsAsync(string fromListId, string toListId, System.Threading.CancellationToken token) => throw null;
            public string PopItemFromList(string listId) => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisClientAsync.PopItemFromListAsync(string listId, System.Threading.CancellationToken token) => throw null;
            public string PopItemFromSet(string setId) => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisClientAsync.PopItemFromSetAsync(string setId, System.Threading.CancellationToken token) => throw null;
            public string PopItemWithHighestScoreFromSortedSet(string setId) => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisClientAsync.PopItemWithHighestScoreFromSortedSetAsync(string setId, System.Threading.CancellationToken token) => throw null;
            public string PopItemWithLowestScoreFromSortedSet(string setId) => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisClientAsync.PopItemWithLowestScoreFromSortedSetAsync(string setId, System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.List<string> PopItemsFromSet(string setId, int count) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ServiceStack.Redis.IRedisClientAsync.PopItemsFromSetAsync(string setId, int count, System.Threading.CancellationToken token) => throw null;
            public void PrependItemToList(string listId, string value) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.PrependItemToListAsync(string listId, string value, System.Threading.CancellationToken token) => throw null;
            public void PrependRangeToList(string listId, System.Collections.Generic.List<string> values) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.PrependRangeToListAsync(string listId, System.Collections.Generic.List<string> values, System.Threading.CancellationToken token) => throw null;
            public System.Int64 PublishMessage(string toChannel, string message) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.PublishMessageAsync(string toChannel, string message, System.Threading.CancellationToken token) => throw null;
            public void PushItemToList(string listId, string value) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.PushItemToListAsync(string listId, string value, System.Threading.CancellationToken token) => throw null;
            public RedisClient(string host, int port, string password = default(string), System.Int64 db = default(System.Int64)) => throw null;
            public RedisClient(string host, int port) => throw null;
            public RedisClient(string host) => throw null;
            public RedisClient(System.Uri uri) => throw null;
            public RedisClient(ServiceStack.Redis.RedisEndpoint config) => throw null;
            public RedisClient() => throw null;
            public bool Remove(string key) => throw null;
            public bool Remove(System.Byte[] key) => throw null;
            public void RemoveAll(System.Collections.Generic.IEnumerable<string> keys) => throw null;
            System.Threading.Tasks.Task ServiceStack.Caching.ICacheClientAsync.RemoveAllAsync(System.Collections.Generic.IEnumerable<string> keys, System.Threading.CancellationToken token) => throw null;
            public void RemoveAllFromList(string listId) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.RemoveAllFromListAsync(string listId, System.Threading.CancellationToken token) => throw null;
            public void RemoveAllLuaScripts() => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.RemoveAllLuaScriptsAsync(System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.Task<bool> ServiceStack.Caching.ICacheClientAsync.RemoveAsync(string key, System.Threading.CancellationToken token) => throw null;
            public void RemoveByPattern(string pattern) => throw null;
            System.Threading.Tasks.Task ServiceStack.Caching.IRemoveByPatternAsync.RemoveByPatternAsync(string pattern, System.Threading.CancellationToken token) => throw null;
            public void RemoveByRegex(string pattern) => throw null;
            System.Threading.Tasks.Task ServiceStack.Caching.IRemoveByPatternAsync.RemoveByRegexAsync(string regex, System.Threading.CancellationToken token) => throw null;
            public string RemoveEndFromList(string listId) => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisClientAsync.RemoveEndFromListAsync(string listId, System.Threading.CancellationToken token) => throw null;
            public bool RemoveEntry(params string[] keys) => throw null;
            System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.IRedisClientAsync.RemoveEntryAsync(string[] keys, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.IRedisClientAsync.RemoveEntryAsync(params string[] args) => throw null;
            public bool RemoveEntryFromHash(string hashId, string key) => throw null;
            System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.IRedisClientAsync.RemoveEntryFromHashAsync(string hashId, string key, System.Threading.CancellationToken token) => throw null;
            public void RemoveExpiredEntries() => throw null;
            System.Threading.Tasks.Task ServiceStack.Caching.ICacheClientAsync.RemoveExpiredEntriesAsync(System.Threading.CancellationToken token) => throw null;
            public System.Int64 RemoveItemFromList(string listId, string value, int noOfMatches) => throw null;
            public System.Int64 RemoveItemFromList(string listId, string value) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.RemoveItemFromListAsync(string listId, string value, int noOfMatches, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.RemoveItemFromListAsync(string listId, string value, System.Threading.CancellationToken token) => throw null;
            public void RemoveItemFromSet(string setId, string item) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.RemoveItemFromSetAsync(string setId, string item, System.Threading.CancellationToken token) => throw null;
            public bool RemoveItemFromSortedSet(string setId, string value) => throw null;
            System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.IRedisClientAsync.RemoveItemFromSortedSetAsync(string setId, string value, System.Threading.CancellationToken token) => throw null;
            public System.Int64 RemoveItemsFromSortedSet(string setId, System.Collections.Generic.List<string> values) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.RemoveItemsFromSortedSetAsync(string setId, System.Collections.Generic.List<string> values, System.Threading.CancellationToken token) => throw null;
            public System.Int64 RemoveRangeFromSortedSet(string setId, int minRank, int maxRank) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.RemoveRangeFromSortedSetAsync(string setId, int minRank, int maxRank, System.Threading.CancellationToken token) => throw null;
            public System.Int64 RemoveRangeFromSortedSetByScore(string setId, double fromScore, double toScore) => throw null;
            public System.Int64 RemoveRangeFromSortedSetByScore(string setId, System.Int64 fromScore, System.Int64 toScore) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.RemoveRangeFromSortedSetByScoreAsync(string setId, double fromScore, double toScore, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.RemoveRangeFromSortedSetByScoreAsync(string setId, System.Int64 fromScore, System.Int64 toScore, System.Threading.CancellationToken token) => throw null;
            public System.Int64 RemoveRangeFromSortedSetBySearch(string setId, string start = default(string), string end = default(string)) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.RemoveRangeFromSortedSetBySearchAsync(string setId, string start, string end, System.Threading.CancellationToken token) => throw null;
            public string RemoveStartFromList(string listId) => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisClientAsync.RemoveStartFromListAsync(string listId, System.Threading.CancellationToken token) => throw null;
            public void RenameKey(string fromName, string toName) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.RenameKeyAsync(string fromName, string toName, System.Threading.CancellationToken token) => throw null;
            public bool Replace<T>(string key, T value, System.TimeSpan expiresIn) => throw null;
            public bool Replace<T>(string key, T value, System.DateTime expiresAt) => throw null;
            public bool Replace<T>(string key, T value) => throw null;
            System.Threading.Tasks.Task<bool> ServiceStack.Caching.ICacheClientAsync.ReplaceAsync<T>(string key, T value, System.TimeSpan expiresIn, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.Task<bool> ServiceStack.Caching.ICacheClientAsync.ReplaceAsync<T>(string key, T value, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.Task<bool> ServiceStack.Caching.ICacheClientAsync.ReplaceAsync<T>(string key, T value, System.DateTime expiresAt, System.Threading.CancellationToken token) => throw null;
            public void ResetInfoStats() => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.ResetInfoStatsAsync(System.Threading.CancellationToken token) => throw null;
            public void RewriteAppendOnlyFileAsync() => throw null;
            public void SaveConfig() => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.SaveConfigAsync(System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> ScanAllHashEntries(string hashId, string pattern = default(string), int pageSize = default(int)) => throw null;
            System.Collections.Generic.IAsyncEnumerable<System.Collections.Generic.KeyValuePair<string, string>> ServiceStack.Redis.IRedisClientAsync.ScanAllHashEntriesAsync(string hashId, string pattern, int pageSize, System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.IEnumerable<string> ScanAllKeys(string pattern = default(string), int pageSize = default(int)) => throw null;
            System.Collections.Generic.IAsyncEnumerable<string> ServiceStack.Redis.IRedisClientAsync.ScanAllKeysAsync(string pattern, int pageSize, System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.IEnumerable<string> ScanAllSetItems(string setId, string pattern = default(string), int pageSize = default(int)) => throw null;
            System.Collections.Generic.IAsyncEnumerable<string> ServiceStack.Redis.IRedisClientAsync.ScanAllSetItemsAsync(string setId, string pattern, int pageSize, System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, double>> ScanAllSortedSetItems(string setId, string pattern = default(string), int pageSize = default(int)) => throw null;
            System.Collections.Generic.IAsyncEnumerable<System.Collections.Generic.KeyValuePair<string, double>> ServiceStack.Redis.IRedisClientAsync.ScanAllSortedSetItemsAsync(string setId, string pattern, int pageSize, System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.List<string> SearchKeys(string pattern) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ServiceStack.Redis.IRedisClientAsync.SearchKeysAsync(string pattern, System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.List<string> SearchSortedSet(string setId, string start = default(string), string end = default(string), int? skip = default(int?), int? take = default(int?)) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ServiceStack.Redis.IRedisClientAsync.SearchSortedSetAsync(string setId, string start, string end, int? skip, int? take, System.Threading.CancellationToken token) => throw null;
            public System.Int64 SearchSortedSetCount(string setId, string start = default(string), string end = default(string)) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.SearchSortedSetCountAsync(string setId, string start, string end, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.SelectAsync(System.Int64 db, System.Threading.CancellationToken token) => throw null;
            public static System.Byte[] SerializeToUtf8Bytes<T>(T value) => throw null;
            public bool Set<T>(string key, T value, System.TimeSpan expiresIn) => throw null;
            public bool Set<T>(string key, T value, System.DateTime expiresAt) => throw null;
            public bool Set<T>(string key, T value) => throw null;
            public void SetAll<T>(System.Collections.Generic.IDictionary<string, T> values) => throw null;
            public void SetAll(System.Collections.Generic.IEnumerable<string> keys, System.Collections.Generic.IEnumerable<string> values) => throw null;
            public void SetAll(System.Collections.Generic.Dictionary<string, string> map) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.SetAllAsync(System.Collections.Generic.IEnumerable<string> keys, System.Collections.Generic.IEnumerable<string> values, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.SetAllAsync(System.Collections.Generic.IDictionary<string, string> map, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.Task ServiceStack.Caching.ICacheClientAsync.SetAllAsync<T>(System.Collections.Generic.IDictionary<string, T> values, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.Task<bool> ServiceStack.Caching.ICacheClientAsync.SetAsync<T>(string key, T value, System.TimeSpan expiresIn, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.Task<bool> ServiceStack.Caching.ICacheClientAsync.SetAsync<T>(string key, T value, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.Task<bool> ServiceStack.Caching.ICacheClientAsync.SetAsync<T>(string key, T value, System.DateTime expiresAt, System.Threading.CancellationToken token) => throw null;
            public void SetClient(string name) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.SetClientAsync(string name, System.Threading.CancellationToken token) => throw null;
            public void SetConfig(string configItem, string value) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.SetConfigAsync(string configItem, string value, System.Threading.CancellationToken token) => throw null;
            public bool SetContainsItem(string setId, string item) => throw null;
            System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.IRedisClientAsync.SetContainsItemAsync(string setId, string item, System.Threading.CancellationToken token) => throw null;
            public bool SetEntryInHash(string hashId, string key, string value) => throw null;
            System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.IRedisClientAsync.SetEntryInHashAsync(string hashId, string key, string value, System.Threading.CancellationToken token) => throw null;
            public bool SetEntryInHashIfNotExists(string hashId, string key, string value) => throw null;
            System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.IRedisClientAsync.SetEntryInHashIfNotExistsAsync(string hashId, string key, string value, System.Threading.CancellationToken token) => throw null;
            public void SetItemInList(string listId, int listIndex, string value) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.SetItemInListAsync(string listId, int listIndex, string value, System.Threading.CancellationToken token) => throw null;
            public void SetRangeInHash(string hashId, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> keyValuePairs) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.SetRangeInHashAsync(string hashId, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> keyValuePairs, System.Threading.CancellationToken token) => throw null;
            public void SetValue(string key, string value, System.TimeSpan expireIn) => throw null;
            public void SetValue(string key, string value) => throw null;
            public bool SetValue(System.Byte[] key, System.Byte[] value, System.TimeSpan expireIn) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.SetValueAsync(string key, string value, System.TimeSpan expireIn, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.SetValueAsync(string key, string value, System.Threading.CancellationToken token) => throw null;
            public bool SetValueIfExists(string key, string value, System.TimeSpan expireIn) => throw null;
            public bool SetValueIfExists(string key, string value) => throw null;
            System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.IRedisClientAsync.SetValueIfExistsAsync(string key, string value, System.TimeSpan? expireIn, System.Threading.CancellationToken token) => throw null;
            public bool SetValueIfNotExists(string key, string value, System.TimeSpan expireIn) => throw null;
            public bool SetValueIfNotExists(string key, string value) => throw null;
            System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.IRedisClientAsync.SetValueIfNotExistsAsync(string key, string value, System.TimeSpan? expireIn, System.Threading.CancellationToken token) => throw null;
            public void SetValues(System.Collections.Generic.Dictionary<string, string> map) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.SetValuesAsync(System.Collections.Generic.IDictionary<string, string> map, System.Threading.CancellationToken token) => throw null;
            public ServiceStack.Model.IHasNamed<ServiceStack.Redis.IRedisSet> Sets { get => throw null; set => throw null; }
            ServiceStack.Model.IHasNamed<ServiceStack.Redis.IRedisSetAsync> ServiceStack.Redis.IRedisClientAsync.Sets { get => throw null; }
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.ShutdownAsync(System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.ShutdownNoSaveAsync(System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.SlowlogResetAsync(System.Threading.CancellationToken token) => throw null;
            public bool SortedSetContainsItem(string setId, string value) => throw null;
            System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.IRedisClientAsync.SortedSetContainsItemAsync(string setId, string value, System.Threading.CancellationToken token) => throw null;
            public ServiceStack.Model.IHasNamed<ServiceStack.Redis.IRedisSortedSet> SortedSets { get => throw null; set => throw null; }
            ServiceStack.Model.IHasNamed<ServiceStack.Redis.IRedisSortedSetAsync> ServiceStack.Redis.IRedisClientAsync.SortedSets { get => throw null; }
            public T Store<T>(T entity) => throw null;
            public void StoreAll<TEntity>(System.Collections.Generic.IEnumerable<TEntity> entities) => throw null;
            System.Threading.Tasks.Task ServiceStack.Data.IEntityStoreAsync.StoreAllAsync<TEntity>(System.Collections.Generic.IEnumerable<TEntity> entities, System.Threading.CancellationToken token) => throw null;
            public void StoreAsHash<T>(T entity) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.StoreAsHashAsync<T>(T entity, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.Task<T> ServiceStack.Data.IEntityStoreAsync.StoreAsync<T>(T entity, System.Threading.CancellationToken token) => throw null;
            public void StoreDifferencesFromSet(string intoSetId, string fromSetId, params string[] withSetIds) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.StoreDifferencesFromSetAsync(string intoSetId, string fromSetId, string[] withSetIds, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.StoreDifferencesFromSetAsync(string intoSetId, string fromSetId, params string[] withSetIds) => throw null;
            public void StoreIntersectFromSets(string intoSetId, params string[] setIds) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.StoreIntersectFromSetsAsync(string intoSetId, string[] setIds, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.StoreIntersectFromSetsAsync(string intoSetId, params string[] setIds) => throw null;
            public System.Int64 StoreIntersectFromSortedSets(string intoSetId, string[] setIds, string[] args) => throw null;
            public System.Int64 StoreIntersectFromSortedSets(string intoSetId, params string[] setIds) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.StoreIntersectFromSortedSetsAsync(string intoSetId, string[] setIds, string[] args, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.StoreIntersectFromSortedSetsAsync(string intoSetId, string[] setIds, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.StoreIntersectFromSortedSetsAsync(string intoSetId, params string[] setIds) => throw null;
            public object StoreObject(object entity) => throw null;
            System.Threading.Tasks.ValueTask<object> ServiceStack.Redis.IRedisClientAsync.StoreObjectAsync(object entity, System.Threading.CancellationToken token) => throw null;
            public void StoreUnionFromSets(string intoSetId, params string[] setIds) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.StoreUnionFromSetsAsync(string intoSetId, string[] setIds, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.StoreUnionFromSetsAsync(string intoSetId, params string[] setIds) => throw null;
            public System.Int64 StoreUnionFromSortedSets(string intoSetId, string[] setIds, string[] args) => throw null;
            public System.Int64 StoreUnionFromSortedSets(string intoSetId, params string[] setIds) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.StoreUnionFromSortedSetsAsync(string intoSetId, string[] setIds, string[] args, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.StoreUnionFromSortedSetsAsync(string intoSetId, string[] setIds, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisClientAsync.StoreUnionFromSortedSetsAsync(string intoSetId, params string[] setIds) => throw null;
            public void TrimList(string listId, int keepStartingFrom, int keepEndingAt) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.TrimListAsync(string listId, int keepStartingFrom, int keepEndingAt, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisClientAsync.TypeAsync(string key, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.UnWatchAsync(System.Threading.CancellationToken token) => throw null;
            public string UrnKey<T>(object id) => throw null;
            public string UrnKey<T>(T value) => throw null;
            public string UrnKey(System.Type type, object id) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.WatchAsync(string[] keys, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.WatchAsync(params string[] keys) => throw null;
            public System.Collections.Generic.Dictionary<string, bool> WhichLuaScriptsExists(params string[] sha1Refs) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.Dictionary<string, bool>> ServiceStack.Redis.IRedisClientAsync.WhichLuaScriptsExistsAsync(string[] sha1Refs, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.Dictionary<string, bool>> ServiceStack.Redis.IRedisClientAsync.WhichLuaScriptsExistsAsync(params string[] sha1Refs) => throw null;
            public void WriteAll<TEntity>(System.Collections.Generic.IEnumerable<TEntity> entities) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisClientAsync.WriteAllAsync<TEntity>(System.Collections.Generic.IEnumerable<TEntity> entities, System.Threading.CancellationToken token) => throw null;
        }

        // Generated from `ServiceStack.Redis.RedisClientExtensions` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class RedisClientExtensions
        {
            public static string GetHostString(this ServiceStack.Redis.RedisEndpoint config) => throw null;
            public static string GetHostString(this ServiceStack.Redis.IRedisClient redis) => throw null;
        }

        // Generated from `ServiceStack.Redis.RedisClientManagerCacheClient` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class RedisClientManagerCacheClient : System.IDisposable, System.IAsyncDisposable, ServiceStack.Caching.IRemoveByPatternAsync, ServiceStack.Caching.IRemoveByPattern, ServiceStack.Caching.ICacheClientExtended, ServiceStack.Caching.ICacheClientAsync, ServiceStack.Caching.ICacheClient
        {
            public bool Add<T>(string key, T value, System.TimeSpan expiresIn) => throw null;
            public bool Add<T>(string key, T value, System.DateTime expiresAt) => throw null;
            public bool Add<T>(string key, T value) => throw null;
            System.Threading.Tasks.Task<bool> ServiceStack.Caching.ICacheClientAsync.AddAsync<T>(string key, T value, System.TimeSpan expiresIn, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.Task<bool> ServiceStack.Caching.ICacheClientAsync.AddAsync<T>(string key, T value, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.Task<bool> ServiceStack.Caching.ICacheClientAsync.AddAsync<T>(string key, T value, System.DateTime expiresAt, System.Threading.CancellationToken token) => throw null;
            public System.Int64 Decrement(string key, System.UInt32 amount) => throw null;
            System.Threading.Tasks.Task<System.Int64> ServiceStack.Caching.ICacheClientAsync.DecrementAsync(string key, System.UInt32 amount, System.Threading.CancellationToken token) => throw null;
            public void Dispose() => throw null;
            System.Threading.Tasks.ValueTask System.IAsyncDisposable.DisposeAsync() => throw null;
            public void FlushAll() => throw null;
            System.Threading.Tasks.Task ServiceStack.Caching.ICacheClientAsync.FlushAllAsync(System.Threading.CancellationToken token) => throw null;
            public T Get<T>(string key) => throw null;
            public System.Collections.Generic.IDictionary<string, T> GetAll<T>(System.Collections.Generic.IEnumerable<string> keys) => throw null;
            System.Threading.Tasks.Task<System.Collections.Generic.IDictionary<string, T>> ServiceStack.Caching.ICacheClientAsync.GetAllAsync<T>(System.Collections.Generic.IEnumerable<string> keys, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.Task<T> ServiceStack.Caching.ICacheClientAsync.GetAsync<T>(string key, System.Threading.CancellationToken token) => throw null;
            public ServiceStack.Caching.ICacheClient GetClient() => throw null;
            public System.Collections.Generic.IEnumerable<string> GetKeysByPattern(string pattern) => throw null;
            System.Collections.Generic.IAsyncEnumerable<string> ServiceStack.Caching.ICacheClientAsync.GetKeysByPatternAsync(string pattern, System.Threading.CancellationToken token) => throw null;
            public System.TimeSpan? GetTimeToLive(string key) => throw null;
            System.Threading.Tasks.Task<System.TimeSpan?> ServiceStack.Caching.ICacheClientAsync.GetTimeToLiveAsync(string key, System.Threading.CancellationToken token) => throw null;
            public System.Int64 Increment(string key, System.UInt32 amount) => throw null;
            System.Threading.Tasks.Task<System.Int64> ServiceStack.Caching.ICacheClientAsync.IncrementAsync(string key, System.UInt32 amount, System.Threading.CancellationToken token) => throw null;
            public bool ReadOnly { get => throw null; set => throw null; }
            public RedisClientManagerCacheClient(ServiceStack.Redis.IRedisClientsManager redisManager) => throw null;
            public bool Remove(string key) => throw null;
            public void RemoveAll(System.Collections.Generic.IEnumerable<string> keys) => throw null;
            System.Threading.Tasks.Task ServiceStack.Caching.ICacheClientAsync.RemoveAllAsync(System.Collections.Generic.IEnumerable<string> keys, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.Task<bool> ServiceStack.Caching.ICacheClientAsync.RemoveAsync(string key, System.Threading.CancellationToken token) => throw null;
            public void RemoveByPattern(string pattern) => throw null;
            System.Threading.Tasks.Task ServiceStack.Caching.IRemoveByPatternAsync.RemoveByPatternAsync(string pattern, System.Threading.CancellationToken token) => throw null;
            public void RemoveByRegex(string pattern) => throw null;
            System.Threading.Tasks.Task ServiceStack.Caching.IRemoveByPatternAsync.RemoveByRegexAsync(string regex, System.Threading.CancellationToken token) => throw null;
            public void RemoveExpiredEntries() => throw null;
            System.Threading.Tasks.Task ServiceStack.Caching.ICacheClientAsync.RemoveExpiredEntriesAsync(System.Threading.CancellationToken token) => throw null;
            public bool Replace<T>(string key, T value, System.TimeSpan expiresIn) => throw null;
            public bool Replace<T>(string key, T value, System.DateTime expiresAt) => throw null;
            public bool Replace<T>(string key, T value) => throw null;
            System.Threading.Tasks.Task<bool> ServiceStack.Caching.ICacheClientAsync.ReplaceAsync<T>(string key, T value, System.TimeSpan expiresIn, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.Task<bool> ServiceStack.Caching.ICacheClientAsync.ReplaceAsync<T>(string key, T value, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.Task<bool> ServiceStack.Caching.ICacheClientAsync.ReplaceAsync<T>(string key, T value, System.DateTime expiresAt, System.Threading.CancellationToken token) => throw null;
            public bool Set<T>(string key, T value, System.TimeSpan expiresIn) => throw null;
            public bool Set<T>(string key, T value, System.DateTime expiresAt) => throw null;
            public bool Set<T>(string key, T value) => throw null;
            public void SetAll<T>(System.Collections.Generic.IDictionary<string, T> values) => throw null;
            System.Threading.Tasks.Task ServiceStack.Caching.ICacheClientAsync.SetAllAsync<T>(System.Collections.Generic.IDictionary<string, T> values, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.Task<bool> ServiceStack.Caching.ICacheClientAsync.SetAsync<T>(string key, T value, System.TimeSpan expiresIn, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.Task<bool> ServiceStack.Caching.ICacheClientAsync.SetAsync<T>(string key, T value, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.Task<bool> ServiceStack.Caching.ICacheClientAsync.SetAsync<T>(string key, T value, System.DateTime expiresAt, System.Threading.CancellationToken token) => throw null;
        }

        // Generated from `ServiceStack.Redis.RedisClientManagerConfig` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class RedisClientManagerConfig
        {
            public bool AutoStart { get => throw null; set => throw null; }
            public System.Int64? DefaultDb { get => throw null; set => throw null; }
            public int MaxReadPoolSize { get => throw null; set => throw null; }
            public int MaxWritePoolSize { get => throw null; set => throw null; }
            public RedisClientManagerConfig() => throw null;
        }

        // Generated from `ServiceStack.Redis.RedisClientsManagerExtensions` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class RedisClientsManagerExtensions
        {
            public static ServiceStack.Redis.IRedisPubSubServer CreatePubSubServer(this ServiceStack.Redis.IRedisClientsManager redisManager, string channel, System.Action<string, string> onMessage = default(System.Action<string, string>), System.Action<System.Exception> onError = default(System.Action<System.Exception>), System.Action onInit = default(System.Action), System.Action onStart = default(System.Action), System.Action onStop = default(System.Action)) => throw null;
            public static void Exec(this ServiceStack.Redis.IRedisClientsManager redisManager, System.Action<ServiceStack.Redis.IRedisClient> lambda) => throw null;
            public static string Exec(this ServiceStack.Redis.IRedisClientsManager redisManager, System.Func<ServiceStack.Redis.IRedisClient, string> lambda) => throw null;
            public static int Exec(this ServiceStack.Redis.IRedisClientsManager redisManager, System.Func<ServiceStack.Redis.IRedisClient, int> lambda) => throw null;
            public static double Exec(this ServiceStack.Redis.IRedisClientsManager redisManager, System.Func<ServiceStack.Redis.IRedisClient, double> lambda) => throw null;
            public static bool Exec(this ServiceStack.Redis.IRedisClientsManager redisManager, System.Func<ServiceStack.Redis.IRedisClient, bool> lambda) => throw null;
            public static System.Int64 Exec(this ServiceStack.Redis.IRedisClientsManager redisManager, System.Func<ServiceStack.Redis.IRedisClient, System.Int64> lambda) => throw null;
            public static void ExecAs<T>(this ServiceStack.Redis.IRedisClientsManager redisManager, System.Action<ServiceStack.Redis.Generic.IRedisTypedClient<T>> lambda) => throw null;
            public static T ExecAs<T>(this ServiceStack.Redis.IRedisClientsManager redisManager, System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, T> lambda) => throw null;
            public static System.Collections.Generic.List<T> ExecAs<T>(this ServiceStack.Redis.IRedisClientsManager redisManager, System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Collections.Generic.List<T>> lambda) => throw null;
            public static System.Collections.Generic.IList<T> ExecAs<T>(this ServiceStack.Redis.IRedisClientsManager redisManager, System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Collections.Generic.IList<T>> lambda) => throw null;
            public static System.Threading.Tasks.ValueTask<T> ExecAsAsync<T>(this ServiceStack.Redis.IRedisClientsManager redisManager, System.Func<ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>, System.Threading.Tasks.ValueTask<T>> lambda) => throw null;
            public static System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> ExecAsAsync<T>(this ServiceStack.Redis.IRedisClientsManager redisManager, System.Func<ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>, System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>>> lambda) => throw null;
            public static System.Threading.Tasks.ValueTask<System.Collections.Generic.IList<T>> ExecAsAsync<T>(this ServiceStack.Redis.IRedisClientsManager redisManager, System.Func<ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>, System.Threading.Tasks.ValueTask<System.Collections.Generic.IList<T>>> lambda) => throw null;
            public static System.Threading.Tasks.ValueTask ExecAsAsync<T>(this ServiceStack.Redis.IRedisClientsManager redisManager, System.Func<ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>, System.Threading.Tasks.ValueTask> lambda) => throw null;
            public static System.Threading.Tasks.ValueTask<T> ExecAsync<T>(this ServiceStack.Redis.IRedisClientsManager redisManager, System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask<T>> lambda) => throw null;
            public static System.Threading.Tasks.ValueTask ExecAsync(this ServiceStack.Redis.IRedisClientsManager redisManager, System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask> lambda) => throw null;
            public static void ExecTrans(this ServiceStack.Redis.IRedisClientsManager redisManager, System.Action<ServiceStack.Redis.IRedisTransaction> lambda) => throw null;
            public static System.Threading.Tasks.ValueTask<ServiceStack.Caching.ICacheClientAsync> GetCacheClientAsync(this ServiceStack.Redis.IRedisClientsManager redisManager, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.ValueTask<ServiceStack.Redis.IRedisClientAsync> GetClientAsync(this ServiceStack.Redis.IRedisClientsManager redisManager, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.ValueTask<ServiceStack.Caching.ICacheClientAsync> GetReadOnlyCacheClientAsync(this ServiceStack.Redis.IRedisClientsManager redisManager, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.ValueTask<ServiceStack.Redis.IRedisClientAsync> GetReadOnlyClientAsync(this ServiceStack.Redis.IRedisClientsManager redisManager, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        }

        // Generated from `ServiceStack.Redis.RedisCommandQueue` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class RedisCommandQueue : ServiceStack.Redis.RedisQueueCompletableOperation
        {
            public void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, string> command, System.Action<string> onSuccessCallback) => throw null;
            public void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, string> command) => throw null;
            public void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, int> command, System.Action<int> onSuccessCallback) => throw null;
            public void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, int> command) => throw null;
            public void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, double> command, System.Action<double> onSuccessCallback) => throw null;
            public void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, double> command) => throw null;
            public void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, bool> command, System.Action<bool> onSuccessCallback) => throw null;
            public void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, bool> command) => throw null;
            public void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Int64> command, System.Action<System.Int64> onSuccessCallback) => throw null;
            public void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Int64> command) => throw null;
            public void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Collections.Generic.List<string>> command, System.Action<System.Collections.Generic.List<string>> onSuccessCallback) => throw null;
            public void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Collections.Generic.List<string>> command) => throw null;
            public void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Collections.Generic.HashSet<string>> command, System.Action<System.Collections.Generic.HashSet<string>> onSuccessCallback) => throw null;
            public void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Collections.Generic.HashSet<string>> command) => throw null;
            public void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Collections.Generic.Dictionary<string, string>> command, System.Action<System.Collections.Generic.Dictionary<string, string>> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
            public void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Collections.Generic.Dictionary<string, string>> command, System.Action<System.Collections.Generic.Dictionary<string, string>> onSuccessCallback) => throw null;
            public void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Collections.Generic.Dictionary<string, string>> command) => throw null;
            public void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Byte[][]> command, System.Action<System.Byte[][]> onSuccessCallback) => throw null;
            public void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Byte[][]> command) => throw null;
            public void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Byte[]> command, System.Action<System.Byte[]> onSuccessCallback) => throw null;
            public void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Byte[]> command) => throw null;
            public void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, ServiceStack.Redis.RedisText> command, System.Action<ServiceStack.Redis.RedisText> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
            public void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, ServiceStack.Redis.RedisText> command, System.Action<ServiceStack.Redis.RedisText> onSuccessCallback) => throw null;
            public void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, ServiceStack.Redis.RedisText> command) => throw null;
            public void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, ServiceStack.Redis.RedisData> command, System.Action<ServiceStack.Redis.RedisData> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
            public void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, ServiceStack.Redis.RedisData> command, System.Action<ServiceStack.Redis.RedisData> onSuccessCallback) => throw null;
            public void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, ServiceStack.Redis.RedisData> command) => throw null;
            public void QueueCommand(System.Action<ServiceStack.Redis.IRedisClient> command, System.Action onSuccessCallback) => throw null;
            public void QueueCommand(System.Action<ServiceStack.Redis.IRedisClient> command) => throw null;
            public virtual void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, string> command, System.Action<string> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
            public virtual void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, int> command, System.Action<int> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
            public virtual void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, double> command, System.Action<double> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
            public virtual void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, bool> command, System.Action<bool> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
            public virtual void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Int64> command, System.Action<System.Int64> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
            public virtual void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Collections.Generic.List<string>> command, System.Action<System.Collections.Generic.List<string>> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
            public virtual void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Collections.Generic.HashSet<string>> command, System.Action<System.Collections.Generic.HashSet<string>> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
            public virtual void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Byte[][]> command, System.Action<System.Byte[][]> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
            public virtual void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Byte[]> command, System.Action<System.Byte[]> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
            public virtual void QueueCommand(System.Action<ServiceStack.Redis.IRedisClient> command, System.Action onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
            protected ServiceStack.Redis.RedisClient RedisClient;
            public RedisCommandQueue(ServiceStack.Redis.RedisClient redisClient) => throw null;
        }

        // Generated from `ServiceStack.Redis.RedisConfig` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class RedisConfig
        {
            public static bool AssertAccessOnlyOnSameThread;
            public static int? AssumeServerVersion;
            public static int BackOffMultiplier;
            public static int BufferLength { get => throw null; }
            public static int BufferPoolMaxSize;
            public static System.Net.Security.LocalCertificateSelectionCallback CertificateSelectionCallback { get => throw null; set => throw null; }
            public static System.Net.Security.RemoteCertificateValidationCallback CertificateValidationCallback { get => throw null; set => throw null; }
            public static System.Func<ServiceStack.Redis.RedisEndpoint, ServiceStack.Redis.RedisClient> ClientFactory;
            public static System.TimeSpan DeactivatedClientsExpiry;
            public static int DefaultConnectTimeout;
            public const System.Int64 DefaultDb = default;
            public const string DefaultHost = default;
            public static int DefaultIdleTimeOutSecs;
            public static int? DefaultMaxPoolSize;
            public static int DefaultPoolSizeMultiplier;
            public const int DefaultPort = default;
            public const int DefaultPortSentinel = default;
            public const int DefaultPortSsl = default;
            public static int DefaultReceiveTimeout;
            public static int DefaultRetryTimeout;
            public static int DefaultSendTimeout;
            public static bool DisableVerboseLogging { get => throw null; set => throw null; }
            public static bool EnableVerboseLogging;
            public static int HostLookupTimeoutMs;
            public RedisConfig() => throw null;
            public static void Reset() => throw null;
            public static bool RetryReconnectOnFailedMasters;
            public static bool VerifyMasterConnections;
        }

        // Generated from `ServiceStack.Redis.RedisDataExtensions` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class RedisDataExtensions
        {
            public static string GetResult(this ServiceStack.Redis.RedisText from) => throw null;
            public static T GetResult<T>(this ServiceStack.Redis.RedisText from) => throw null;
            public static System.Collections.Generic.List<string> GetResults(this ServiceStack.Redis.RedisText from) => throw null;
            public static System.Collections.Generic.List<T> GetResults<T>(this ServiceStack.Redis.RedisText from) => throw null;
            public static double ToDouble(this ServiceStack.Redis.RedisData data) => throw null;
            public static System.Int64 ToInt64(this ServiceStack.Redis.RedisData data) => throw null;
            public static ServiceStack.Redis.RedisText ToRedisText(this ServiceStack.Redis.RedisData data) => throw null;
        }

        // Generated from `ServiceStack.Redis.RedisDataInfoExtensions` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class RedisDataInfoExtensions
        {
            public static string ToJsonInfo(this ServiceStack.Redis.RedisText redisText) => throw null;
        }

        // Generated from `ServiceStack.Redis.RedisEndpoint` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class RedisEndpoint : ServiceStack.IO.IEndpoint
        {
            public string Client { get => throw null; set => throw null; }
            public int ConnectTimeout { get => throw null; set => throw null; }
            public System.Int64 Db { get => throw null; set => throw null; }
            public override bool Equals(object obj) => throw null;
            protected bool Equals(ServiceStack.Redis.RedisEndpoint other) => throw null;
            public override int GetHashCode() => throw null;
            public string Host { get => throw null; set => throw null; }
            public int IdleTimeOutSecs { get => throw null; set => throw null; }
            public string NamespacePrefix { get => throw null; set => throw null; }
            public string Password { get => throw null; set => throw null; }
            public int Port { get => throw null; set => throw null; }
            public int ReceiveTimeout { get => throw null; set => throw null; }
            public RedisEndpoint(string host, int port, string password = default(string), System.Int64 db = default(System.Int64)) => throw null;
            public RedisEndpoint() => throw null;
            public bool RequiresAuth { get => throw null; }
            public int RetryTimeout { get => throw null; set => throw null; }
            public int SendTimeout { get => throw null; set => throw null; }
            public bool Ssl { get => throw null; set => throw null; }
            public System.Security.Authentication.SslProtocols? SslProtocols { get => throw null; set => throw null; }
            public override string ToString() => throw null;
        }

        // Generated from `ServiceStack.Redis.RedisException` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class RedisException : System.Exception
        {
            public RedisException(string message, System.Exception innerException) => throw null;
            public RedisException(string message) => throw null;
        }

        // Generated from `ServiceStack.Redis.RedisExtensions` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class RedisExtensions
        {
            public static System.Collections.Generic.List<ServiceStack.Redis.RedisEndpoint> ToRedisEndPoints(this System.Collections.Generic.IEnumerable<string> hosts) => throw null;
            public static ServiceStack.Redis.RedisEndpoint ToRedisEndpoint(this string connectionString, int? defaultPort = default(int?)) => throw null;
        }

        // Generated from `ServiceStack.Redis.RedisLock` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class RedisLock : System.IDisposable, System.IAsyncDisposable
        {
            public void Dispose() => throw null;
            System.Threading.Tasks.ValueTask System.IAsyncDisposable.DisposeAsync() => throw null;
            public RedisLock(ServiceStack.Redis.IRedisClient redisClient, string key, System.TimeSpan? timeOut) => throw null;
        }

        // Generated from `ServiceStack.Redis.RedisManagerPool` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class RedisManagerPool : System.IDisposable, System.IAsyncDisposable, ServiceStack.Redis.IRedisFailover, ServiceStack.Redis.IRedisClientsManagerAsync, ServiceStack.Redis.IRedisClientsManager, ServiceStack.Redis.IRedisClientCacheManager, ServiceStack.Redis.IHasRedisResolver, ServiceStack.Redis.IHandleClientDispose
        {
            public bool AssertAccessOnlyOnSameThread { get => throw null; set => throw null; }
            public System.Func<ServiceStack.Redis.RedisEndpoint, ServiceStack.Redis.RedisClient> ClientFactory { get => throw null; set => throw null; }
            public System.Action<ServiceStack.Redis.IRedisNativeClient> ConnectionFilter { get => throw null; set => throw null; }
            public void Dispose() => throw null;
            protected void Dispose(ServiceStack.Redis.RedisClient redisClient) => throw null;
            protected virtual void Dispose(bool disposing) => throw null;
            System.Threading.Tasks.ValueTask System.IAsyncDisposable.DisposeAsync() => throw null;
            public void DisposeClient(ServiceStack.Redis.RedisNativeClient client) => throw null;
            public void DisposeWriteClient(ServiceStack.Redis.RedisNativeClient client) => throw null;
            public void FailoverTo(params string[] readWriteHosts) => throw null;
            public void FailoverTo(System.Collections.Generic.IEnumerable<string> readWriteHosts, System.Collections.Generic.IEnumerable<string> readOnlyHosts) => throw null;
            public ServiceStack.Caching.ICacheClient GetCacheClient() => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Caching.ICacheClientAsync> ServiceStack.Redis.IRedisClientsManagerAsync.GetCacheClientAsync(System.Threading.CancellationToken token) => throw null;
            public ServiceStack.Redis.IRedisClient GetClient() => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.IRedisClientAsync> ServiceStack.Redis.IRedisClientsManagerAsync.GetClientAsync(System.Threading.CancellationToken token) => throw null;
            public int[] GetClientPoolActiveStates() => throw null;
            public ServiceStack.Caching.ICacheClient GetReadOnlyCacheClient() => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Caching.ICacheClientAsync> ServiceStack.Redis.IRedisClientsManagerAsync.GetReadOnlyCacheClientAsync(System.Threading.CancellationToken token) => throw null;
            public ServiceStack.Redis.IRedisClient GetReadOnlyClient() => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.IRedisClientAsync> ServiceStack.Redis.IRedisClientsManagerAsync.GetReadOnlyClientAsync(System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.Dictionary<string, string> GetStats() => throw null;
            public int MaxPoolSize { get => throw null; set => throw null; }
            public System.Collections.Generic.List<System.Action<ServiceStack.Redis.IRedisClientsManager>> OnFailover { get => throw null; set => throw null; }
            public int RecheckPoolAfterMs;
            protected int RedisClientCounter;
            public RedisManagerPool(string host, ServiceStack.Redis.RedisPoolConfig config) => throw null;
            public RedisManagerPool(string host) => throw null;
            public RedisManagerPool(System.Collections.Generic.IEnumerable<string> hosts, ServiceStack.Redis.RedisPoolConfig config) => throw null;
            public RedisManagerPool(System.Collections.Generic.IEnumerable<string> hosts) => throw null;
            public RedisManagerPool() => throw null;
            public ServiceStack.Redis.IRedisResolver RedisResolver { get => throw null; set => throw null; }
            protected int poolIndex;
            // ERR: Stub generator didn't handle member: ~RedisManagerPool
        }

        // Generated from `ServiceStack.Redis.RedisNativeClient` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class RedisNativeClient : System.IDisposable, System.IAsyncDisposable, ServiceStack.Redis.IRedisNativeClientAsync, ServiceStack.Redis.IRedisNativeClient
        {
            public System.Int64 Append(string key, System.Byte[] value) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.AppendAsync(string key, System.Byte[] value, System.Threading.CancellationToken token) => throw null;
            public int AssertServerVersionNumber() => throw null;
            public System.Byte[][] BLPop(string[] listIds, int timeOutSecs) => throw null;
            public System.Byte[][] BLPop(string listId, int timeOutSecs) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.BLPopAsync(string[] listIds, int timeOutSecs, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.BLPopAsync(string listId, int timeOutSecs, System.Threading.CancellationToken token) => throw null;
            public System.Byte[][] BLPopValue(string[] listIds, int timeOutSecs) => throw null;
            public System.Byte[] BLPopValue(string listId, int timeOutSecs) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.BLPopValueAsync(string[] listIds, int timeOutSecs, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[]> ServiceStack.Redis.IRedisNativeClientAsync.BLPopValueAsync(string listId, int timeOutSecs, System.Threading.CancellationToken token) => throw null;
            public System.Byte[][] BRPop(string[] listIds, int timeOutSecs) => throw null;
            public System.Byte[][] BRPop(string listId, int timeOutSecs) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.BRPopAsync(string[] listIds, int timeOutSecs, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.BRPopAsync(string listId, int timeOutSecs, System.Threading.CancellationToken token) => throw null;
            public System.Byte[] BRPopLPush(string fromListId, string toListId, int timeOutSecs) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[]> ServiceStack.Redis.IRedisNativeClientAsync.BRPopLPushAsync(string fromListId, string toListId, int timeOutSecs, System.Threading.CancellationToken token) => throw null;
            public System.Byte[][] BRPopValue(string[] listIds, int timeOutSecs) => throw null;
            public System.Byte[] BRPopValue(string listId, int timeOutSecs) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.BRPopValueAsync(string[] listIds, int timeOutSecs, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[]> ServiceStack.Redis.IRedisNativeClientAsync.BRPopValueAsync(string listId, int timeOutSecs, System.Threading.CancellationToken token) => throw null;
            public void BgRewriteAof() => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.BgRewriteAofAsync(System.Threading.CancellationToken token) => throw null;
            public void BgSave() => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.BgSaveAsync(System.Threading.CancellationToken token) => throw null;
            public System.Int64 BitCount(string key) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.BitCountAsync(string key, System.Threading.CancellationToken token) => throw null;
            protected System.IO.BufferedStream Bstream;
            public string CalculateSha1(string luaBody) => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisNativeClientAsync.CalculateSha1Async(string luaBody, System.Threading.CancellationToken token) => throw null;
            public void ChangeDb(System.Int64 db) => throw null;
            public string Client { get => throw null; set => throw null; }
            public string ClientGetName() => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisNativeClientAsync.ClientGetNameAsync(System.Threading.CancellationToken token) => throw null;
            public System.Int64 ClientId { get => throw null; }
            public void ClientKill(string clientAddr) => throw null;
            public System.Int64 ClientKill(string addr = default(string), string id = default(string), string type = default(string), string skipMe = default(string)) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.ClientKillAsync(string addr, string id, string type, string skipMe, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.ClientKillAsync(string clientAddr, System.Threading.CancellationToken token) => throw null;
            public System.Byte[] ClientList() => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[]> ServiceStack.Redis.IRedisNativeClientAsync.ClientListAsync(System.Threading.CancellationToken token) => throw null;
            public void ClientPause(int timeOutMs) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.ClientPauseAsync(int timeOutMs, System.Threading.CancellationToken token) => throw null;
            public void ClientSetName(string name) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.ClientSetNameAsync(string name, System.Threading.CancellationToken token) => throw null;
            protected void CmdLog(System.Byte[][] args) => throw null;
            public System.Byte[][] ConfigGet(string pattern) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.ConfigGetAsync(string pattern, System.Threading.CancellationToken token) => throw null;
            public void ConfigResetStat() => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.ConfigResetStatAsync(System.Threading.CancellationToken token) => throw null;
            public void ConfigRewrite() => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.ConfigRewriteAsync(System.Threading.CancellationToken token) => throw null;
            public void ConfigSet(string item, System.Byte[] value) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.ConfigSetAsync(string item, System.Byte[] value, System.Threading.CancellationToken token) => throw null;
            public int ConnectTimeout { get => throw null; set => throw null; }
            public System.Action<ServiceStack.Redis.IRedisNativeClient> ConnectionFilter { get => throw null; set => throw null; }
            protected System.Byte[][] ConvertToBytes(string[] keys) => throw null;
            public ServiceStack.Redis.Pipeline.RedisPipelineCommand CreatePipelineCommand() => throw null;
            public virtual ServiceStack.Redis.IRedisSubscription CreateSubscription() => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.IRedisSubscriptionAsync> ServiceStack.Redis.IRedisNativeClientAsync.CreateSubscriptionAsync(System.Threading.CancellationToken token) => throw null;
            public System.Int64 Db { get => throw null; set => throw null; }
            public System.Int64 DbSize { get => throw null; }
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.DbSizeAsync(System.Threading.CancellationToken token) => throw null;
            public System.DateTime? DeactivatedAt { get => throw null; set => throw null; }
            public void DebugSegfault() => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.DebugSegfaultAsync(System.Threading.CancellationToken token) => throw null;
            public void DebugSleep(double durationSecs) => throw null;
            public System.Int64 Decr(string key) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.DecrAsync(string key, System.Threading.CancellationToken token) => throw null;
            public System.Int64 DecrBy(string key, int count) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.DecrByAsync(string key, System.Int64 count, System.Threading.CancellationToken token) => throw null;
            public System.Int64 Del(string key) => throw null;
            public System.Int64 Del(params string[] keys) => throw null;
            public System.Int64 Del(System.Byte[] key) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.DelAsync(string[] keys, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.DelAsync(string key, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.DelAsync(params string[] keys) => throw null;
            public virtual void Dispose() => throw null;
            protected virtual void Dispose(bool disposing) => throw null;
            System.Threading.Tasks.ValueTask System.IAsyncDisposable.DisposeAsync() => throw null;
            public static void DisposeTimers() => throw null;
            public System.Byte[] Dump(string key) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[]> ServiceStack.Redis.IRedisNativeClientAsync.DumpAsync(string key, System.Threading.CancellationToken token) => throw null;
            public string Echo(string text) => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisNativeClientAsync.EchoAsync(string text, System.Threading.CancellationToken token) => throw null;
            public static string ErrorConnect;
            public System.Byte[][] Eval(string luaBody, int numberKeysInArgs, params System.Byte[][] keys) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.EvalAsync(string luaBody, int numberOfKeys, params System.Byte[][] keysAndArgs) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.EvalAsync(string luaBody, int numberOfKeys, System.Byte[][] keysAndArgs, System.Threading.CancellationToken token) => throw null;
            public ServiceStack.Redis.RedisData EvalCommand(string luaBody, int numberKeysInArgs, params System.Byte[][] keys) => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisData> ServiceStack.Redis.IRedisNativeClientAsync.EvalCommandAsync(string luaBody, int numberKeysInArgs, params System.Byte[][] keys) => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisData> ServiceStack.Redis.IRedisNativeClientAsync.EvalCommandAsync(string luaBody, int numberKeysInArgs, System.Byte[][] keys, System.Threading.CancellationToken token) => throw null;
            public System.Int64 EvalInt(string luaBody, int numberKeysInArgs, params System.Byte[][] keys) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.EvalIntAsync(string luaBody, int numberOfKeys, params System.Byte[][] keysAndArgs) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.EvalIntAsync(string luaBody, int numberOfKeys, System.Byte[][] keysAndArgs, System.Threading.CancellationToken token) => throw null;
            public System.Byte[][] EvalSha(string sha1, int numberKeysInArgs, params System.Byte[][] keys) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.EvalShaAsync(string sha1, int numberOfKeys, params System.Byte[][] keysAndArgs) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.EvalShaAsync(string sha1, int numberOfKeys, System.Byte[][] keysAndArgs, System.Threading.CancellationToken token) => throw null;
            public ServiceStack.Redis.RedisData EvalShaCommand(string sha1, int numberKeysInArgs, params System.Byte[][] keys) => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisData> ServiceStack.Redis.IRedisNativeClientAsync.EvalShaCommandAsync(string sha1, int numberKeysInArgs, params System.Byte[][] keys) => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisData> ServiceStack.Redis.IRedisNativeClientAsync.EvalShaCommandAsync(string sha1, int numberKeysInArgs, System.Byte[][] keys, System.Threading.CancellationToken token) => throw null;
            public System.Int64 EvalShaInt(string sha1, int numberKeysInArgs, params System.Byte[][] keys) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.EvalShaIntAsync(string sha1, int numberOfKeys, params System.Byte[][] keysAndArgs) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.EvalShaIntAsync(string sha1, int numberOfKeys, System.Byte[][] keysAndArgs, System.Threading.CancellationToken token) => throw null;
            public string EvalShaStr(string sha1, int numberKeysInArgs, params System.Byte[][] keys) => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisNativeClientAsync.EvalShaStrAsync(string sha1, int numberOfKeys, params System.Byte[][] keysAndArgs) => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisNativeClientAsync.EvalShaStrAsync(string sha1, int numberOfKeys, System.Byte[][] keysAndArgs, System.Threading.CancellationToken token) => throw null;
            public string EvalStr(string luaBody, int numberKeysInArgs, params System.Byte[][] keys) => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisNativeClientAsync.EvalStrAsync(string luaBody, int numberOfKeys, params System.Byte[][] keysAndArgs) => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisNativeClientAsync.EvalStrAsync(string luaBody, int numberOfKeys, System.Byte[][] keysAndArgs, System.Threading.CancellationToken token) => throw null;
            public System.Int64 Exists(string key) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.ExistsAsync(string key, System.Threading.CancellationToken token) => throw null;
            protected void ExpectSuccess() => throw null;
            protected System.Int64 ExpectSuccessFn() => throw null;
            public bool Expire(string key, int seconds) => throw null;
            public bool Expire(System.Byte[] key, int seconds) => throw null;
            System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.IRedisNativeClientAsync.ExpireAsync(string key, int seconds, System.Threading.CancellationToken token) => throw null;
            public bool ExpireAt(string key, System.Int64 unixTime) => throw null;
            System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.IRedisNativeClientAsync.ExpireAtAsync(string key, System.Int64 unixTime, System.Threading.CancellationToken token) => throw null;
            public void FlushAll() => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.FlushAllAsync(System.Threading.CancellationToken token) => throw null;
            public void FlushDb() => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.FlushDbAsync(System.Threading.CancellationToken token) => throw null;
            public System.Int64 GeoAdd(string key, params ServiceStack.Redis.RedisGeo[] geoPoints) => throw null;
            public System.Int64 GeoAdd(string key, double longitude, double latitude, string member) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.GeoAddAsync(string key, params ServiceStack.Redis.RedisGeo[] geoPoints) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.GeoAddAsync(string key, double longitude, double latitude, string member, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.GeoAddAsync(string key, ServiceStack.Redis.RedisGeo[] geoPoints, System.Threading.CancellationToken token) => throw null;
            public double GeoDist(string key, string fromMember, string toMember, string unit = default(string)) => throw null;
            System.Threading.Tasks.ValueTask<double> ServiceStack.Redis.IRedisNativeClientAsync.GeoDistAsync(string key, string fromMember, string toMember, string unit, System.Threading.CancellationToken token) => throw null;
            public string[] GeoHash(string key, params string[] members) => throw null;
            System.Threading.Tasks.ValueTask<string[]> ServiceStack.Redis.IRedisNativeClientAsync.GeoHashAsync(string key, string[] members, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<string[]> ServiceStack.Redis.IRedisNativeClientAsync.GeoHashAsync(string key, params string[] members) => throw null;
            public System.Collections.Generic.List<ServiceStack.Redis.RedisGeo> GeoPos(string key, params string[] members) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<ServiceStack.Redis.RedisGeo>> ServiceStack.Redis.IRedisNativeClientAsync.GeoPosAsync(string key, string[] members, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<ServiceStack.Redis.RedisGeo>> ServiceStack.Redis.IRedisNativeClientAsync.GeoPosAsync(string key, params string[] members) => throw null;
            public System.Collections.Generic.List<ServiceStack.Redis.RedisGeoResult> GeoRadius(string key, double longitude, double latitude, double radius, string unit, bool withCoords = default(bool), bool withDist = default(bool), bool withHash = default(bool), int? count = default(int?), bool? asc = default(bool?)) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<ServiceStack.Redis.RedisGeoResult>> ServiceStack.Redis.IRedisNativeClientAsync.GeoRadiusAsync(string key, double longitude, double latitude, double radius, string unit, bool withCoords, bool withDist, bool withHash, int? count, bool? asc, System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.List<ServiceStack.Redis.RedisGeoResult> GeoRadiusByMember(string key, string member, double radius, string unit, bool withCoords = default(bool), bool withDist = default(bool), bool withHash = default(bool), int? count = default(int?), bool? asc = default(bool?)) => throw null;
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<ServiceStack.Redis.RedisGeoResult>> ServiceStack.Redis.IRedisNativeClientAsync.GeoRadiusByMemberAsync(string key, string member, double radius, string unit, bool withCoords, bool withDist, bool withHash, int? count, bool? asc, System.Threading.CancellationToken token) => throw null;
            public System.Byte[] Get(string key) => throw null;
            public System.Byte[] Get(System.Byte[] key) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[]> ServiceStack.Redis.IRedisNativeClientAsync.GetAsync(string key, System.Threading.CancellationToken token) => throw null;
            public System.Int64 GetBit(string key, int offset) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.GetBitAsync(string key, int offset, System.Threading.CancellationToken token) => throw null;
            public System.Byte[] GetBytes(string key) => throw null;
            public ServiceStack.Redis.RedisKeyType GetEntryType(string key) => throw null;
            public System.Byte[] GetRange(string key, int fromIndex, int toIndex) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[]> ServiceStack.Redis.IRedisNativeClientAsync.GetRangeAsync(string key, int fromIndex, int toIndex, System.Threading.CancellationToken token) => throw null;
            public System.Byte[] GetSet(string key, System.Byte[] value) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[]> ServiceStack.Redis.IRedisNativeClientAsync.GetSetAsync(string key, System.Byte[] value, System.Threading.CancellationToken token) => throw null;
            public System.Int64 HDel(string hashId, System.Byte[][] keys) => throw null;
            public System.Int64 HDel(string hashId, System.Byte[] key) => throw null;
            public System.Int64 HDel(System.Byte[] hashId, System.Byte[] key) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.HDelAsync(string hashId, System.Byte[] key, System.Threading.CancellationToken token) => throw null;
            public System.Int64 HExists(string hashId, System.Byte[] key) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.HExistsAsync(string hashId, System.Byte[] key, System.Threading.CancellationToken token) => throw null;
            public System.Byte[] HGet(string hashId, System.Byte[] key) => throw null;
            public System.Byte[] HGet(System.Byte[] hashId, System.Byte[] key) => throw null;
            public System.Byte[][] HGetAll(string hashId) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.HGetAllAsync(string hashId, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[]> ServiceStack.Redis.IRedisNativeClientAsync.HGetAsync(string hashId, System.Byte[] key, System.Threading.CancellationToken token) => throw null;
            public System.Int64 HIncrby(string hashId, System.Byte[] key, int incrementBy) => throw null;
            public System.Int64 HIncrby(string hashId, System.Byte[] key, System.Int64 incrementBy) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.HIncrbyAsync(string hashId, System.Byte[] key, int incrementBy, System.Threading.CancellationToken token) => throw null;
            public double HIncrbyFloat(string hashId, System.Byte[] key, double incrementBy) => throw null;
            System.Threading.Tasks.ValueTask<double> ServiceStack.Redis.IRedisNativeClientAsync.HIncrbyFloatAsync(string hashId, System.Byte[] key, double incrementBy, System.Threading.CancellationToken token) => throw null;
            public System.Byte[][] HKeys(string hashId) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.HKeysAsync(string hashId, System.Threading.CancellationToken token) => throw null;
            public System.Int64 HLen(string hashId) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.HLenAsync(string hashId, System.Threading.CancellationToken token) => throw null;
            public System.Byte[][] HMGet(string hashId, params System.Byte[][] keys) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.HMGetAsync(string hashId, params System.Byte[][] keysAndArgs) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.HMGetAsync(string hashId, System.Byte[][] keys, System.Threading.CancellationToken token) => throw null;
            public void HMSet(string hashId, System.Byte[][] keys, System.Byte[][] values) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.HMSetAsync(string hashId, System.Byte[][] keys, System.Byte[][] values, System.Threading.CancellationToken token) => throw null;
            public ServiceStack.Redis.ScanResult HScan(string hashId, System.UInt64 cursor, int count = default(int), string match = default(string)) => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.ScanResult> ServiceStack.Redis.IRedisNativeClientAsync.HScanAsync(string hashId, System.UInt64 cursor, int count, string match, System.Threading.CancellationToken token) => throw null;
            public System.Int64 HSet(string hashId, System.Byte[] key, System.Byte[] value) => throw null;
            public System.Int64 HSet(System.Byte[] hashId, System.Byte[] key, System.Byte[] value) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.HSetAsync(string hashId, System.Byte[] key, System.Byte[] value, System.Threading.CancellationToken token) => throw null;
            public System.Int64 HSetNX(string hashId, System.Byte[] key, System.Byte[] value) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.HSetNXAsync(string hashId, System.Byte[] key, System.Byte[] value, System.Threading.CancellationToken token) => throw null;
            public System.Byte[][] HVals(string hashId) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.HValsAsync(string hashId, System.Threading.CancellationToken token) => throw null;
            public bool HadExceptions { get => throw null; }
            public bool HasConnected { get => throw null; }
            public string Host { get => throw null; set => throw null; }
            public System.Int64 Id { get => throw null; set => throw null; }
            public int IdleTimeOutSecs { get => throw null; set => throw null; }
            public System.Int64 Incr(string key) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.IncrAsync(string key, System.Threading.CancellationToken token) => throw null;
            public System.Int64 IncrBy(string key, int count) => throw null;
            public System.Int64 IncrBy(string key, System.Int64 count) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.IncrByAsync(string key, System.Int64 count, System.Threading.CancellationToken token) => throw null;
            public double IncrByFloat(string key, double incrBy) => throw null;
            System.Threading.Tasks.ValueTask<double> ServiceStack.Redis.IRedisNativeClientAsync.IncrByFloatAsync(string key, double incrBy, System.Threading.CancellationToken token) => throw null;
            public System.Collections.Generic.Dictionary<string, string> Info { get => throw null; }
            System.Threading.Tasks.ValueTask<System.Collections.Generic.Dictionary<string, string>> ServiceStack.Redis.IRedisNativeClientAsync.InfoAsync(System.Threading.CancellationToken token) => throw null;
            public bool IsManagedClient { get => throw null; }
            public bool IsSocketConnected() => throw null;
            public System.Byte[][] Keys(string pattern) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.KeysAsync(string pattern, System.Threading.CancellationToken token) => throw null;
            public System.Byte[] LIndex(string listId, int listIndex) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[]> ServiceStack.Redis.IRedisNativeClientAsync.LIndexAsync(string listId, int listIndex, System.Threading.CancellationToken token) => throw null;
            public void LInsert(string listId, bool insertBefore, System.Byte[] pivot, System.Byte[] value) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.LInsertAsync(string listId, bool insertBefore, System.Byte[] pivot, System.Byte[] value, System.Threading.CancellationToken token) => throw null;
            public System.Int64 LLen(string listId) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.LLenAsync(string listId, System.Threading.CancellationToken token) => throw null;
            public System.Byte[] LPop(string listId) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[]> ServiceStack.Redis.IRedisNativeClientAsync.LPopAsync(string listId, System.Threading.CancellationToken token) => throw null;
            public System.Int64 LPush(string listId, System.Byte[][] values) => throw null;
            public System.Int64 LPush(string listId, System.Byte[] value) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.LPushAsync(string listId, System.Byte[] value, System.Threading.CancellationToken token) => throw null;
            public System.Int64 LPushX(string listId, System.Byte[] value) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.LPushXAsync(string listId, System.Byte[] value, System.Threading.CancellationToken token) => throw null;
            public System.Byte[][] LRange(string listId, int startingFrom, int endingAt) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.LRangeAsync(string listId, int startingFrom, int endingAt, System.Threading.CancellationToken token) => throw null;
            public System.Int64 LRem(string listId, int removeNoOfMatches, System.Byte[] value) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.LRemAsync(string listId, int removeNoOfMatches, System.Byte[] value, System.Threading.CancellationToken token) => throw null;
            public void LSet(string listId, int listIndex, System.Byte[] value) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.LSetAsync(string listId, int listIndex, System.Byte[] value, System.Threading.CancellationToken token) => throw null;
            public void LTrim(string listId, int keepStartingFrom, int keepEndingAt) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.LTrimAsync(string listId, int keepStartingFrom, int keepEndingAt, System.Threading.CancellationToken token) => throw null;
            public System.DateTime LastSave { get => throw null; }
            System.Threading.Tasks.ValueTask<System.DateTime> ServiceStack.Redis.IRedisNativeClientAsync.LastSaveAsync(System.Threading.CancellationToken token) => throw null;
            protected void Log(string fmt, params object[] args) => throw null;
            public System.Byte[][] MGet(params string[] keys) => throw null;
            public System.Byte[][] MGet(params System.Byte[][] keys) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.MGetAsync(string[] keys, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.MGetAsync(params string[] keys) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.MGetAsync(params System.Byte[][] keysAndArgs) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.MGetAsync(System.Byte[][] keys, System.Threading.CancellationToken token) => throw null;
            public void MSet(string[] keys, System.Byte[][] values) => throw null;
            public void MSet(System.Byte[][] keys, System.Byte[][] values) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.MSetAsync(string[] keys, System.Byte[][] values, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.MSetAsync(System.Byte[][] keys, System.Byte[][] values, System.Threading.CancellationToken token) => throw null;
            public bool MSetNx(string[] keys, System.Byte[][] values) => throw null;
            public bool MSetNx(System.Byte[][] keys, System.Byte[][] values) => throw null;
            System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.IRedisNativeClientAsync.MSetNxAsync(string[] keys, System.Byte[][] values, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.IRedisNativeClientAsync.MSetNxAsync(System.Byte[][] keys, System.Byte[][] values, System.Threading.CancellationToken token) => throw null;
            protected System.Byte[][] MergeAndConvertToBytes(string[] keys, string[] args) => throw null;
            public void Migrate(string host, int port, string key, int destinationDb, System.Int64 timeoutMs) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.MigrateAsync(string host, int port, string key, int destinationDb, System.Int64 timeoutMs, System.Threading.CancellationToken token) => throw null;
            public bool Move(string key, int db) => throw null;
            System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.IRedisNativeClientAsync.MoveAsync(string key, int db, System.Threading.CancellationToken token) => throw null;
            public string NamespacePrefix { get => throw null; set => throw null; }
            public System.Int64 ObjectIdleTime(string key) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.ObjectIdleTimeAsync(string key, System.Threading.CancellationToken token) => throw null;
            public System.Action OnBeforeFlush { get => throw null; set => throw null; }
            public virtual void OnConnected() => throw null;
            public bool PExpire(string key, System.Int64 ttlMs) => throw null;
            public bool PExpire(System.Byte[] key, System.Int64 ttlMs) => throw null;
            System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.IRedisNativeClientAsync.PExpireAsync(string key, System.Int64 ttlMs, System.Threading.CancellationToken token) => throw null;
            public bool PExpireAt(string key, System.Int64 unixTimeMs) => throw null;
            System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.IRedisNativeClientAsync.PExpireAtAsync(string key, System.Int64 unixTimeMs, System.Threading.CancellationToken token) => throw null;
            public void PSetEx(string key, System.Int64 expireInMs, System.Byte[] value) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.PSetExAsync(string key, System.Int64 expireInMs, System.Byte[] value, System.Threading.CancellationToken token) => throw null;
            public System.Byte[][] PSubscribe(params string[] toChannelsMatchingPatterns) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.PSubscribeAsync(string[] toChannelsMatchingPatterns, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.PSubscribeAsync(params string[] toChannelsMatchingPatterns) => throw null;
            public System.Int64 PTtl(string key) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.PTtlAsync(string key, System.Threading.CancellationToken token) => throw null;
            public System.Byte[][] PUnSubscribe(params string[] fromChannelsMatchingPatterns) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.PUnSubscribeAsync(string[] fromChannelsMatchingPatterns, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.PUnSubscribeAsync(params string[] toChannelsMatchingPatterns) => throw null;
            public static double ParseDouble(System.Byte[] doubleBytes) => throw null;
            public string Password { get => throw null; set => throw null; }
            public bool Persist(string key) => throw null;
            System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.IRedisNativeClientAsync.PersistAsync(string key, System.Threading.CancellationToken token) => throw null;
            public bool PfAdd(string key, params System.Byte[][] elements) => throw null;
            System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.IRedisNativeClientAsync.PfAddAsync(string key, params System.Byte[][] elements) => throw null;
            System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.IRedisNativeClientAsync.PfAddAsync(string key, System.Byte[][] elements, System.Threading.CancellationToken token) => throw null;
            public System.Int64 PfCount(string key) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.PfCountAsync(string key, System.Threading.CancellationToken token) => throw null;
            public void PfMerge(string toKeyId, params string[] fromKeys) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.PfMergeAsync(string toKeyId, string[] fromKeys, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.PfMergeAsync(string toKeyId, params string[] fromKeys) => throw null;
            public bool Ping() => throw null;
            System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.IRedisNativeClientAsync.PingAsync(System.Threading.CancellationToken token) => throw null;
            public int Port { get => throw null; set => throw null; }
            public System.Int64 Publish(string toChannel, System.Byte[] message) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.PublishAsync(string toChannel, System.Byte[] message, System.Threading.CancellationToken token) => throw null;
            public void Quit() => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.QuitAsync(System.Threading.CancellationToken token) => throw null;
            public System.Byte[] RPop(string listId) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[]> ServiceStack.Redis.IRedisNativeClientAsync.RPopAsync(string listId, System.Threading.CancellationToken token) => throw null;
            public System.Byte[] RPopLPush(string fromListId, string toListId) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[]> ServiceStack.Redis.IRedisNativeClientAsync.RPopLPushAsync(string fromListId, string toListId, System.Threading.CancellationToken token) => throw null;
            public System.Int64 RPush(string listId, System.Byte[][] values) => throw null;
            public System.Int64 RPush(string listId, System.Byte[] value) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.RPushAsync(string listId, System.Byte[] value, System.Threading.CancellationToken token) => throw null;
            public System.Int64 RPushX(string listId, System.Byte[] value) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.RPushXAsync(string listId, System.Byte[] value, System.Threading.CancellationToken token) => throw null;
            public string RandomKey() => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisNativeClientAsync.RandomKeyAsync(System.Threading.CancellationToken token) => throw null;
            public ServiceStack.Redis.RedisData RawCommand(params object[] cmdWithArgs) => throw null;
            public ServiceStack.Redis.RedisData RawCommand(params System.Byte[][] cmdWithBinaryArgs) => throw null;
            protected System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisData> RawCommandAsync(System.Threading.CancellationToken token, params object[] cmdWithArgs) => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisData> ServiceStack.Redis.IRedisNativeClientAsync.RawCommandAsync(params object[] cmdWithArgs) => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisData> ServiceStack.Redis.IRedisNativeClientAsync.RawCommandAsync(params System.Byte[][] cmdWithBinaryArgs) => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisData> ServiceStack.Redis.IRedisNativeClientAsync.RawCommandAsync(object[] cmdWithArgs, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisData> ServiceStack.Redis.IRedisNativeClientAsync.RawCommandAsync(System.Byte[][] cmdWithBinaryArgs, System.Threading.CancellationToken token) => throw null;
            public double ReadDouble() => throw null;
            protected string ReadLine() => throw null;
            public System.Int64 ReadLong() => throw null;
            public System.Byte[][] ReceiveMessages() => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.ReceiveMessagesAsync(System.Threading.CancellationToken token) => throw null;
            public int ReceiveTimeout { get => throw null; set => throw null; }
            public RedisNativeClient(string host, int port, string password = default(string), System.Int64 db = default(System.Int64)) => throw null;
            public RedisNativeClient(string host, int port) => throw null;
            public RedisNativeClient(string connectionString) => throw null;
            public RedisNativeClient(ServiceStack.Redis.RedisEndpoint config) => throw null;
            public RedisNativeClient() => throw null;
            public void Rename(string oldKeyname, string newKeyname) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.RenameAsync(string oldKeyName, string newKeyName, System.Threading.CancellationToken token) => throw null;
            public bool RenameNx(string oldKeyname, string newKeyname) => throw null;
            System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.IRedisNativeClientAsync.RenameNxAsync(string oldKeyName, string newKeyName, System.Threading.CancellationToken token) => throw null;
            public static int RequestsPerHour { get => throw null; }
            public void ResetSendBuffer() => throw null;
            public System.Byte[] Restore(string key, System.Int64 expireMs, System.Byte[] dumpValue) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[]> ServiceStack.Redis.IRedisNativeClientAsync.RestoreAsync(string key, System.Int64 expireMs, System.Byte[] dumpValue, System.Threading.CancellationToken token) => throw null;
            public int RetryCount { get => throw null; set => throw null; }
            public int RetryTimeout { get => throw null; set => throw null; }
            public ServiceStack.Redis.RedisText Role() => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisText> ServiceStack.Redis.IRedisNativeClientAsync.RoleAsync(System.Threading.CancellationToken token) => throw null;
            public System.Int64 SAdd(string setId, System.Byte[][] values) => throw null;
            public System.Int64 SAdd(string setId, System.Byte[] value) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.SAddAsync(string setId, System.Byte[][] values, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.SAddAsync(string setId, System.Byte[] value, System.Threading.CancellationToken token) => throw null;
            public System.Int64 SCard(string setId) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.SCardAsync(string setId, System.Threading.CancellationToken token) => throw null;
            public System.Byte[][] SDiff(string fromSetId, params string[] withSetIds) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.SDiffAsync(string fromSetId, string[] withSetIds, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.SDiffAsync(string fromSetId, params string[] withSetIds) => throw null;
            public void SDiffStore(string intoSetId, string fromSetId, params string[] withSetIds) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.SDiffStoreAsync(string intoSetId, string fromSetId, string[] withSetIds, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.SDiffStoreAsync(string intoSetId, string fromSetId, params string[] withSetIds) => throw null;
            public System.Byte[][] SInter(params string[] setIds) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.SInterAsync(string[] setIds, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.SInterAsync(params string[] setIds) => throw null;
            public void SInterStore(string intoSetId, params string[] setIds) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.SInterStoreAsync(string intoSetId, string[] setIds, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.SInterStoreAsync(string intoSetId, params string[] setIds) => throw null;
            public System.Int64 SIsMember(string setId, System.Byte[] value) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.SIsMemberAsync(string setId, System.Byte[] value, System.Threading.CancellationToken token) => throw null;
            public System.Byte[][] SMembers(string setId) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.SMembersAsync(string setId, System.Threading.CancellationToken token) => throw null;
            public void SMove(string fromSetId, string toSetId, System.Byte[] value) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.SMoveAsync(string fromSetId, string toSetId, System.Byte[] value, System.Threading.CancellationToken token) => throw null;
            public System.Byte[][] SPop(string setId, int count) => throw null;
            public System.Byte[] SPop(string setId) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.SPopAsync(string setId, int count, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[]> ServiceStack.Redis.IRedisNativeClientAsync.SPopAsync(string setId, System.Threading.CancellationToken token) => throw null;
            public System.Byte[][] SRandMember(string setId, int count) => throw null;
            public System.Byte[] SRandMember(string setId) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[]> ServiceStack.Redis.IRedisNativeClientAsync.SRandMemberAsync(string setId, System.Threading.CancellationToken token) => throw null;
            public System.Int64 SRem(string setId, System.Byte[][] values) => throw null;
            public System.Int64 SRem(string setId, System.Byte[] value) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.SRemAsync(string setId, System.Byte[] value, System.Threading.CancellationToken token) => throw null;
            public ServiceStack.Redis.ScanResult SScan(string setId, System.UInt64 cursor, int count = default(int), string match = default(string)) => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.ScanResult> ServiceStack.Redis.IRedisNativeClientAsync.SScanAsync(string setId, System.UInt64 cursor, int count, string match, System.Threading.CancellationToken token) => throw null;
            public System.Byte[][] SUnion(params string[] setIds) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.SUnionAsync(string[] setIds, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.SUnionAsync(params string[] setIds) => throw null;
            public void SUnionStore(string intoSetId, params string[] setIds) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.SUnionStoreAsync(string intoSetId, string[] setIds, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.SUnionStoreAsync(string intoSetId, params string[] setIds) => throw null;
            public void Save() => throw null;
            public void SaveAsync() => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.SaveAsync(System.Threading.CancellationToken token) => throw null;
            public ServiceStack.Redis.ScanResult Scan(System.UInt64 cursor, int count = default(int), string match = default(string)) => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.ScanResult> ServiceStack.Redis.IRedisNativeClientAsync.ScanAsync(System.UInt64 cursor, int count, string match, System.Threading.CancellationToken token) => throw null;
            public System.Byte[][] ScriptExists(params System.Byte[][] sha1Refs) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.ScriptExistsAsync(params System.Byte[][] sha1Refs) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.ScriptExistsAsync(System.Byte[][] sha1Refs, System.Threading.CancellationToken token) => throw null;
            public void ScriptFlush() => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.ScriptFlushAsync(System.Threading.CancellationToken token) => throw null;
            public void ScriptKill() => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.ScriptKillAsync(System.Threading.CancellationToken token) => throw null;
            public System.Byte[] ScriptLoad(string luaBody) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[]> ServiceStack.Redis.IRedisNativeClientAsync.ScriptLoadAsync(string body, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.SelectAsync(System.Int64 db, System.Threading.CancellationToken token) => throw null;
            protected string SendExpectCode(params System.Byte[][] cmdWithBinaryArgs) => throw null;
            protected ServiceStack.Redis.RedisData SendExpectComplexResponse(params System.Byte[][] cmdWithBinaryArgs) => throw null;
            protected System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisData> SendExpectComplexResponseAsync(System.Threading.CancellationToken token, params System.Byte[][] cmdWithBinaryArgs) => throw null;
            protected System.Byte[] SendExpectData(params System.Byte[][] cmdWithBinaryArgs) => throw null;
            protected object[] SendExpectDeeplyNestedMultiData(params System.Byte[][] cmdWithBinaryArgs) => throw null;
            protected double SendExpectDouble(params System.Byte[][] cmdWithBinaryArgs) => throw null;
            protected System.Int64 SendExpectLong(params System.Byte[][] cmdWithBinaryArgs) => throw null;
            protected System.Byte[][] SendExpectMultiData(params System.Byte[][] cmdWithBinaryArgs) => throw null;
            protected string SendExpectString(params System.Byte[][] cmdWithBinaryArgs) => throw null;
            protected System.Threading.Tasks.ValueTask<string> SendExpectStringAsync(System.Threading.CancellationToken token, params System.Byte[][] cmdWithBinaryArgs) => throw null;
            protected System.Collections.Generic.List<System.Collections.Generic.Dictionary<string, string>> SendExpectStringDictionaryList(params System.Byte[][] cmdWithBinaryArgs) => throw null;
            protected void SendExpectSuccess(params System.Byte[][] cmdWithBinaryArgs) => throw null;
            protected T SendReceive<T>(System.Byte[][] cmdWithBinaryArgs, System.Func<T> fn, System.Action<System.Func<T>> completePipelineFn = default(System.Action<System.Func<T>>), bool sendWithoutRead = default(bool)) => throw null;
            public int SendTimeout { get => throw null; set => throw null; }
            protected void SendUnmanagedExpectSuccess(params System.Byte[][] cmdWithBinaryArgs) => throw null;
            protected void SendWithoutRead(params System.Byte[][] cmdWithBinaryArgs) => throw null;
            protected System.Threading.Tasks.ValueTask SendWithoutReadAsync(System.Threading.CancellationToken token, params System.Byte[][] cmdWithBinaryArgs) => throw null;
            public void SentinelFailover(string masterName) => throw null;
            public System.Collections.Generic.List<string> SentinelGetMasterAddrByName(string masterName) => throw null;
            public System.Collections.Generic.Dictionary<string, string> SentinelMaster(string masterName) => throw null;
            public System.Collections.Generic.List<System.Collections.Generic.Dictionary<string, string>> SentinelMasters() => throw null;
            public System.Collections.Generic.List<System.Collections.Generic.Dictionary<string, string>> SentinelSentinels(string masterName) => throw null;
            public System.Collections.Generic.List<System.Collections.Generic.Dictionary<string, string>> SentinelSlaves(string masterName) => throw null;
            public string ServerVersion { get => throw null; }
            public static int ServerVersionNumber { get => throw null; set => throw null; }
            public void Set(string key, System.Byte[] value, int expirySeconds, System.Int64 expiryMs = default(System.Int64)) => throw null;
            public void Set(string key, System.Byte[] value) => throw null;
            public void Set(System.Byte[] key, System.Byte[] value, int expirySeconds, System.Int64 expiryMs = default(System.Int64)) => throw null;
            public bool Set(string key, System.Byte[] value, bool exists, int expirySeconds = default(int), System.Int64 expiryMs = default(System.Int64)) => throw null;
            System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.IRedisNativeClientAsync.SetAsync(string key, System.Byte[] value, bool exists, System.Int64 expirySeconds, System.Int64 expiryMilliseconds, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.SetAsync(string key, System.Byte[] value, System.Int64 expirySeconds, System.Int64 expiryMilliseconds, System.Threading.CancellationToken token) => throw null;
            public System.Int64 SetBit(string key, int offset, int value) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.SetBitAsync(string key, int offset, int value, System.Threading.CancellationToken token) => throw null;
            public void SetEx(string key, int expireInSeconds, System.Byte[] value) => throw null;
            public void SetEx(System.Byte[] key, int expireInSeconds, System.Byte[] value) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.SetExAsync(string key, int expireInSeconds, System.Byte[] value, System.Threading.CancellationToken token) => throw null;
            public System.Int64 SetNX(string key, System.Byte[] value) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.SetNXAsync(string key, System.Byte[] value, System.Threading.CancellationToken token) => throw null;
            public System.Int64 SetRange(string key, int offset, System.Byte[] value) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.SetRangeAsync(string key, int offset, System.Byte[] value, System.Threading.CancellationToken token) => throw null;
            public void Shutdown() => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.ShutdownAsync(bool noSave, System.Threading.CancellationToken token) => throw null;
            public void ShutdownNoSave() => throw null;
            public void SlaveOf(string hostname, int port) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.SlaveOfAsync(string hostname, int port, System.Threading.CancellationToken token) => throw null;
            public void SlaveOfNoOne() => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.SlaveOfNoOneAsync(System.Threading.CancellationToken token) => throw null;
            public object[] Slowlog(int? top) => throw null;
            System.Threading.Tasks.ValueTask<object[]> ServiceStack.Redis.IRedisNativeClientAsync.SlowlogGetAsync(int? top, System.Threading.CancellationToken token) => throw null;
            public void SlowlogReset() => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.SlowlogResetAsync(System.Threading.CancellationToken token) => throw null;
            public System.Byte[][] Sort(string listOrSetId, ServiceStack.Redis.SortOptions sortOptions) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.SortAsync(string listOrSetId, ServiceStack.Redis.SortOptions sortOptions, System.Threading.CancellationToken token) => throw null;
            public bool Ssl { get => throw null; set => throw null; }
            public System.Security.Authentication.SslProtocols? SslProtocols { get => throw null; set => throw null; }
            public System.Int64 StrLen(string key) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.StrLenAsync(string key, System.Threading.CancellationToken token) => throw null;
            public System.Byte[][] Subscribe(params string[] toChannels) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.SubscribeAsync(string[] toChannels, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.SubscribeAsync(params string[] toChannels) => throw null;
            public System.Byte[][] Time() => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.TimeAsync(System.Threading.CancellationToken token) => throw null;
            public System.Int64 Ttl(string key) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.TtlAsync(string key, System.Threading.CancellationToken token) => throw null;
            public string Type(string key) => throw null;
            System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.IRedisNativeClientAsync.TypeAsync(string key, System.Threading.CancellationToken token) => throw null;
            public System.Byte[][] UnSubscribe(params string[] fromChannels) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.UnSubscribeAsync(string[] fromChannels, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.UnSubscribeAsync(params string[] toChannels) => throw null;
            public void UnWatch() => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.UnWatchAsync(System.Threading.CancellationToken token) => throw null;
            public void Watch(params string[] keys) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.WatchAsync(string[] keys, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisNativeClientAsync.WatchAsync(params string[] keys) => throw null;
            public void WriteAllToSendBuffer(params System.Byte[][] cmdWithBinaryArgs) => throw null;
            protected void WriteCommandToSendBuffer(params System.Byte[][] cmdWithBinaryArgs) => throw null;
            public void WriteToSendBuffer(System.Byte[] cmdBytes) => throw null;
            public System.Int64 ZAdd(string setId, double score, System.Byte[] value) => throw null;
            public System.Int64 ZAdd(string setId, System.Int64 score, System.Byte[] value) => throw null;
            public System.Int64 ZAdd(string setId, System.Collections.Generic.List<System.Collections.Generic.KeyValuePair<System.Byte[], double>> pairs) => throw null;
            public System.Int64 ZAdd(string setId, System.Collections.Generic.List<System.Collections.Generic.KeyValuePair<System.Byte[], System.Int64>> pairs) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.ZAddAsync(string setId, double score, System.Byte[] value, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.ZAddAsync(string setId, System.Int64 score, System.Byte[] value, System.Threading.CancellationToken token) => throw null;
            public System.Int64 ZCard(string setId) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.ZCardAsync(string setId, System.Threading.CancellationToken token) => throw null;
            public System.Int64 ZCount(string setId, double min, double max) => throw null;
            public System.Int64 ZCount(string setId, System.Int64 min, System.Int64 max) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.ZCountAsync(string setId, double min, double max, System.Threading.CancellationToken token) => throw null;
            public double ZIncrBy(string setId, double incrBy, System.Byte[] value) => throw null;
            public double ZIncrBy(string setId, System.Int64 incrBy, System.Byte[] value) => throw null;
            System.Threading.Tasks.ValueTask<double> ServiceStack.Redis.IRedisNativeClientAsync.ZIncrByAsync(string setId, double incrBy, System.Byte[] value, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<double> ServiceStack.Redis.IRedisNativeClientAsync.ZIncrByAsync(string setId, System.Int64 incrBy, System.Byte[] value, System.Threading.CancellationToken token) => throw null;
            public System.Int64 ZInterStore(string intoSetId, string[] setIds, string[] args) => throw null;
            public System.Int64 ZInterStore(string intoSetId, params string[] setIds) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.ZInterStoreAsync(string intoSetId, string[] setIds, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.ZInterStoreAsync(string intoSetId, params string[] setIds) => throw null;
            public System.Int64 ZLexCount(string setId, string min, string max) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.ZLexCountAsync(string setId, string min, string max, System.Threading.CancellationToken token) => throw null;
            public System.Byte[][] ZRange(string setId, int min, int max) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.ZRangeAsync(string setId, int min, int max, System.Threading.CancellationToken token) => throw null;
            public System.Byte[][] ZRangeByLex(string setId, string min, string max, int? skip = default(int?), int? take = default(int?)) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.ZRangeByLexAsync(string setId, string min, string max, int? skip, int? take, System.Threading.CancellationToken token) => throw null;
            public System.Byte[][] ZRangeByScore(string setId, double min, double max, int? skip, int? take) => throw null;
            public System.Byte[][] ZRangeByScore(string setId, System.Int64 min, System.Int64 max, int? skip, int? take) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.ZRangeByScoreAsync(string setId, double min, double max, int? skip, int? take, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.ZRangeByScoreAsync(string setId, System.Int64 min, System.Int64 max, int? skip, int? take, System.Threading.CancellationToken token) => throw null;
            public System.Byte[][] ZRangeByScoreWithScores(string setId, double min, double max, int? skip, int? take) => throw null;
            public System.Byte[][] ZRangeByScoreWithScores(string setId, System.Int64 min, System.Int64 max, int? skip, int? take) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.ZRangeByScoreWithScoresAsync(string setId, double min, double max, int? skip, int? take, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.ZRangeByScoreWithScoresAsync(string setId, System.Int64 min, System.Int64 max, int? skip, int? take, System.Threading.CancellationToken token) => throw null;
            public System.Byte[][] ZRangeWithScores(string setId, int min, int max) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.ZRangeWithScoresAsync(string setId, int min, int max, System.Threading.CancellationToken token) => throw null;
            public System.Int64 ZRank(string setId, System.Byte[] value) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.ZRankAsync(string setId, System.Byte[] value, System.Threading.CancellationToken token) => throw null;
            public System.Int64 ZRem(string setId, System.Byte[][] values) => throw null;
            public System.Int64 ZRem(string setId, System.Byte[] value) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.ZRemAsync(string setId, System.Byte[][] values, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.ZRemAsync(string setId, System.Byte[] value, System.Threading.CancellationToken token) => throw null;
            public System.Int64 ZRemRangeByLex(string setId, string min, string max) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.ZRemRangeByLexAsync(string setId, string min, string max, System.Threading.CancellationToken token) => throw null;
            public System.Int64 ZRemRangeByRank(string setId, int min, int max) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.ZRemRangeByRankAsync(string setId, int min, int max, System.Threading.CancellationToken token) => throw null;
            public System.Int64 ZRemRangeByScore(string setId, double fromScore, double toScore) => throw null;
            public System.Int64 ZRemRangeByScore(string setId, System.Int64 fromScore, System.Int64 toScore) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.ZRemRangeByScoreAsync(string setId, double fromScore, double toScore, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.ZRemRangeByScoreAsync(string setId, System.Int64 fromScore, System.Int64 toScore, System.Threading.CancellationToken token) => throw null;
            public System.Byte[][] ZRevRange(string setId, int min, int max) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.ZRevRangeAsync(string setId, int min, int max, System.Threading.CancellationToken token) => throw null;
            public System.Byte[][] ZRevRangeByScore(string setId, double min, double max, int? skip, int? take) => throw null;
            public System.Byte[][] ZRevRangeByScore(string setId, System.Int64 min, System.Int64 max, int? skip, int? take) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.ZRevRangeByScoreAsync(string setId, double min, double max, int? skip, int? take, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.ZRevRangeByScoreAsync(string setId, System.Int64 min, System.Int64 max, int? skip, int? take, System.Threading.CancellationToken token) => throw null;
            public System.Byte[][] ZRevRangeByScoreWithScores(string setId, double min, double max, int? skip, int? take) => throw null;
            public System.Byte[][] ZRevRangeByScoreWithScores(string setId, System.Int64 min, System.Int64 max, int? skip, int? take) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.ZRevRangeByScoreWithScoresAsync(string setId, double min, double max, int? skip, int? take, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.ZRevRangeByScoreWithScoresAsync(string setId, System.Int64 min, System.Int64 max, int? skip, int? take, System.Threading.CancellationToken token) => throw null;
            public System.Byte[][] ZRevRangeWithScores(string setId, int min, int max) => throw null;
            System.Threading.Tasks.ValueTask<System.Byte[][]> ServiceStack.Redis.IRedisNativeClientAsync.ZRevRangeWithScoresAsync(string setId, int min, int max, System.Threading.CancellationToken token) => throw null;
            public System.Int64 ZRevRank(string setId, System.Byte[] value) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.ZRevRankAsync(string setId, System.Byte[] value, System.Threading.CancellationToken token) => throw null;
            public ServiceStack.Redis.ScanResult ZScan(string setId, System.UInt64 cursor, int count = default(int), string match = default(string)) => throw null;
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.ScanResult> ServiceStack.Redis.IRedisNativeClientAsync.ZScanAsync(string setId, System.UInt64 cursor, int count, string match, System.Threading.CancellationToken token) => throw null;
            public double ZScore(string setId, System.Byte[] value) => throw null;
            System.Threading.Tasks.ValueTask<double> ServiceStack.Redis.IRedisNativeClientAsync.ZScoreAsync(string setId, System.Byte[] value, System.Threading.CancellationToken token) => throw null;
            public System.Int64 ZUnionStore(string intoSetId, string[] setIds, string[] args) => throw null;
            public System.Int64 ZUnionStore(string intoSetId, params string[] setIds) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.ZUnionStoreAsync(string intoSetId, string[] setIds, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.IRedisNativeClientAsync.ZUnionStoreAsync(string intoSetId, params string[] setIds) => throw null;
            protected System.Net.Sockets.Socket socket;
            protected System.Net.Security.SslStream sslStream;
            // ERR: Stub generator didn't handle member: ~RedisNativeClient
        }

        // Generated from `ServiceStack.Redis.RedisPoolConfig` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class RedisPoolConfig
        {
            public static int DefaultMaxPoolSize;
            public int MaxPoolSize { get => throw null; set => throw null; }
            public RedisPoolConfig() => throw null;
        }

        // Generated from `ServiceStack.Redis.RedisPubSubServer` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class RedisPubSubServer : System.IDisposable, ServiceStack.Redis.IRedisPubSubServer
        {
            public const string AllChannelsWildCard = default;
            public bool AutoRestart { get => throw null; set => throw null; }
            public System.Int64 BgThreadCount { get => throw null; }
            public string[] Channels { get => throw null; set => throw null; }
            public string[] ChannelsMatching { get => throw null; set => throw null; }
            public ServiceStack.Redis.IRedisClientsManager ClientsManager { get => throw null; set => throw null; }
            // Generated from `ServiceStack.Redis.RedisPubSubServer+ControlCommand` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public static class ControlCommand
            {
                public const string Control = default;
                public const string Pulse = default;
            }


            public System.DateTime CurrentServerTime { get => throw null; }
            public virtual void Dispose() => throw null;
            public string GetStatsDescription() => throw null;
            public string GetStatus() => throw null;
            public System.TimeSpan? HeartbeatInterval;
            public System.TimeSpan HeartbeatTimeout;
            public bool IsSentinelSubscription { get => throw null; set => throw null; }
            public System.Action<string> OnControlCommand { get => throw null; set => throw null; }
            public System.Action OnDispose { get => throw null; set => throw null; }
            public System.Action<System.Exception> OnError { get => throw null; set => throw null; }
            public System.Action<ServiceStack.Redis.IRedisPubSubServer> OnFailover { get => throw null; set => throw null; }
            public System.Action OnHeartbeatReceived { get => throw null; set => throw null; }
            public System.Action OnHeartbeatSent { get => throw null; set => throw null; }
            public System.Action OnInit { get => throw null; set => throw null; }
            public System.Action<string, string> OnMessage { get => throw null; set => throw null; }
            public System.Action<string, System.Byte[]> OnMessageBytes { get => throw null; set => throw null; }
            public System.Action OnStart { get => throw null; set => throw null; }
            public System.Action OnStop { get => throw null; set => throw null; }
            public System.Action<string> OnUnSubscribe { get => throw null; set => throw null; }
            // Generated from `ServiceStack.Redis.RedisPubSubServer+Operation` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public static class Operation
            {
                public static string GetName(int op) => throw null;
                public const int NoOp = default;
                public const int Reset = default;
                public const int Restart = default;
                public const int Stop = default;
            }


            public RedisPubSubServer(ServiceStack.Redis.IRedisClientsManager clientsManager, params string[] channels) => throw null;
            public void Restart() => throw null;
            public ServiceStack.Redis.IRedisPubSubServer Start() => throw null;
            public void Stop() => throw null;
            public System.TimeSpan? WaitBeforeNextRestart { get => throw null; set => throw null; }
        }

        // Generated from `ServiceStack.Redis.RedisQueueCompletableOperation` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class RedisQueueCompletableOperation
        {
            protected virtual void AddCurrentQueuedOperation() => throw null;
            public virtual void CompleteBytesQueuedCommand(System.Func<System.Byte[]> bytesReadCommand) => throw null;
            public virtual void CompleteDoubleQueuedCommand(System.Func<double> doubleReadCommand) => throw null;
            public virtual void CompleteIntQueuedCommand(System.Func<int> intReadCommand) => throw null;
            public virtual void CompleteLongQueuedCommand(System.Func<System.Int64> longReadCommand) => throw null;
            public virtual void CompleteMultiBytesQueuedCommand(System.Func<System.Byte[][]> multiBytesReadCommand) => throw null;
            public virtual void CompleteMultiStringQueuedCommand(System.Func<System.Collections.Generic.List<string>> multiStringReadCommand) => throw null;
            public virtual void CompleteRedisDataQueuedCommand(System.Func<ServiceStack.Redis.RedisData> redisDataReadCommand) => throw null;
            public virtual void CompleteStringQueuedCommand(System.Func<string> stringReadCommand) => throw null;
            public virtual void CompleteVoidQueuedCommand(System.Action voidReadCommand) => throw null;
            public RedisQueueCompletableOperation() => throw null;
        }

        // Generated from `ServiceStack.Redis.RedisResolver` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class RedisResolver : ServiceStack.Redis.IRedisResolverExtended, ServiceStack.Redis.IRedisResolver
        {
            public System.Func<ServiceStack.Redis.RedisEndpoint, ServiceStack.Redis.RedisClient> ClientFactory { get => throw null; set => throw null; }
            public ServiceStack.Redis.RedisClient CreateMasterClient(int desiredIndex) => throw null;
            public virtual ServiceStack.Redis.RedisClient CreateRedisClient(ServiceStack.Redis.RedisEndpoint config, bool master) => throw null;
            public ServiceStack.Redis.RedisClient CreateSlaveClient(int desiredIndex) => throw null;
            public ServiceStack.Redis.RedisEndpoint GetReadOnlyHost(int desiredIndex) => throw null;
            public ServiceStack.Redis.RedisEndpoint GetReadWriteHost(int desiredIndex) => throw null;
            protected ServiceStack.Redis.RedisClient GetValidMaster(ServiceStack.Redis.RedisClient client, ServiceStack.Redis.RedisEndpoint config) => throw null;
            public ServiceStack.Redis.RedisEndpoint[] Masters { get => throw null; }
            public int ReadOnlyHostsCount { get => throw null; set => throw null; }
            public int ReadWriteHostsCount { get => throw null; set => throw null; }
            public RedisResolver(System.Collections.Generic.IEnumerable<string> masters, System.Collections.Generic.IEnumerable<string> replicas) => throw null;
            public RedisResolver(System.Collections.Generic.IEnumerable<ServiceStack.Redis.RedisEndpoint> masters, System.Collections.Generic.IEnumerable<ServiceStack.Redis.RedisEndpoint> replicas) => throw null;
            public RedisResolver() => throw null;
            public virtual void ResetMasters(System.Collections.Generic.List<ServiceStack.Redis.RedisEndpoint> newMasters) => throw null;
            public virtual void ResetMasters(System.Collections.Generic.IEnumerable<string> hosts) => throw null;
            public virtual void ResetSlaves(System.Collections.Generic.List<ServiceStack.Redis.RedisEndpoint> newReplicas) => throw null;
            public virtual void ResetSlaves(System.Collections.Generic.IEnumerable<string> hosts) => throw null;
            public ServiceStack.Redis.RedisEndpoint[] Slaves { get => throw null; }
        }

        // Generated from `ServiceStack.Redis.RedisResolverExtensions` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class RedisResolverExtensions
        {
            public static ServiceStack.Redis.RedisClient CreateRedisClient(this ServiceStack.Redis.IRedisResolver resolver, ServiceStack.Redis.RedisEndpoint config, bool master) => throw null;
            public static ServiceStack.Redis.RedisEndpoint GetReadOnlyHost(this ServiceStack.Redis.IRedisResolver resolver, int desiredIndex) => throw null;
            public static ServiceStack.Redis.RedisEndpoint GetReadWriteHost(this ServiceStack.Redis.IRedisResolver resolver, int desiredIndex) => throw null;
        }

        // Generated from `ServiceStack.Redis.RedisResponseException` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class RedisResponseException : ServiceStack.Redis.RedisException
        {
            public string Code { get => throw null; set => throw null; }
            public RedisResponseException(string message, string code) : base(default(string)) => throw null;
            public RedisResponseException(string message) : base(default(string)) => throw null;
        }

        // Generated from `ServiceStack.Redis.RedisRetryableException` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class RedisRetryableException : ServiceStack.Redis.RedisException
        {
            public string Code { get => throw null; set => throw null; }
            public RedisRetryableException(string message, string code) : base(default(string)) => throw null;
            public RedisRetryableException(string message) : base(default(string)) => throw null;
        }

        // Generated from `ServiceStack.Redis.RedisScripts` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class RedisScripts : ServiceStack.Script.ScriptMethods
        {
            public ServiceStack.Redis.IRedisClientsManager RedisManager { get => throw null; set => throw null; }
            public RedisScripts() => throw null;
            public object redisCall(ServiceStack.Script.ScriptScopeContext scope, object redisCommand, object options) => throw null;
            public object redisCall(ServiceStack.Script.ScriptScopeContext scope, object redisCommand) => throw null;
            public string redisChangeConnection(ServiceStack.Script.ScriptScopeContext scope, object newConnection, object options) => throw null;
            public string redisChangeConnection(ServiceStack.Script.ScriptScopeContext scope, object newConnection) => throw null;
            public System.Collections.Generic.Dictionary<string, object> redisConnection(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public string redisConnectionString(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public System.Collections.Generic.Dictionary<string, string> redisInfo(ServiceStack.Script.ScriptScopeContext scope, object options) => throw null;
            public System.Collections.Generic.Dictionary<string, string> redisInfo(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public System.Collections.Generic.List<ServiceStack.Redis.RedisSearchResult> redisSearchKeys(ServiceStack.Script.ScriptScopeContext scope, string query, object options) => throw null;
            public System.Collections.Generic.List<ServiceStack.Redis.RedisSearchResult> redisSearchKeys(ServiceStack.Script.ScriptScopeContext scope, string query) => throw null;
            public string redisSearchKeysAsJson(ServiceStack.Script.ScriptScopeContext scope, string query, object options) => throw null;
            public string redisToConnectionString(ServiceStack.Script.ScriptScopeContext scope, object connectionInfo, object options) => throw null;
            public string redisToConnectionString(ServiceStack.Script.ScriptScopeContext scope, object connectionInfo) => throw null;
            public ServiceStack.Script.IgnoreResult useRedis(ServiceStack.Script.ScriptScopeContext scope, string redisConnection) => throw null;
        }

        // Generated from `ServiceStack.Redis.RedisSearchCursorResult` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class RedisSearchCursorResult
        {
            public int Cursor { get => throw null; set => throw null; }
            public RedisSearchCursorResult() => throw null;
            public System.Collections.Generic.List<ServiceStack.Redis.RedisSearchResult> Results { get => throw null; set => throw null; }
        }

        // Generated from `ServiceStack.Redis.RedisSearchResult` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class RedisSearchResult
        {
            public string Id { get => throw null; set => throw null; }
            public RedisSearchResult() => throw null;
            public System.Int64 Size { get => throw null; set => throw null; }
            public System.Int64 Ttl { get => throw null; set => throw null; }
            public string Type { get => throw null; set => throw null; }
        }

        // Generated from `ServiceStack.Redis.RedisSentinel` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class RedisSentinel : System.IDisposable, ServiceStack.Redis.IRedisSentinel
        {
            public static string DefaultAddress;
            public static string DefaultMasterName;
            public void Dispose() => throw null;
            public void ForceMasterFailover() => throw null;
            public System.Collections.Generic.List<string> GetActiveSentinelHosts(System.Collections.Generic.IEnumerable<string> sentinelHosts) => throw null;
            public ServiceStack.Redis.RedisEndpoint GetMaster() => throw null;
            public ServiceStack.Redis.IRedisClientsManager GetRedisManager() => throw null;
            public SentinelInfo GetSentinelInfo() => throw null;
            public System.Collections.Generic.List<ServiceStack.Redis.RedisEndpoint> GetSlaves() => throw null;
            public System.Func<string, string> HostFilter { get => throw null; set => throw null; }
            public System.Collections.Generic.Dictionary<string, string> IpAddressMap { get => throw null; set => throw null; }
            protected static ServiceStack.Logging.ILog Log;
            public string MasterName { get => throw null; }
            public System.TimeSpan MaxWaitBetweenFailedHosts { get => throw null; set => throw null; }
            public System.Action<ServiceStack.Redis.IRedisClientsManager> OnFailover { get => throw null; set => throw null; }
            public System.Action<string, string> OnSentinelMessageReceived { get => throw null; set => throw null; }
            public System.Action<System.Exception> OnWorkerError { get => throw null; set => throw null; }
            public ServiceStack.Redis.IRedisClientsManager RedisManager { get => throw null; set => throw null; }
            public System.Func<string[], string[], ServiceStack.Redis.IRedisClientsManager> RedisManagerFactory { get => throw null; set => throw null; }
            public RedisSentinel(string sentinelHost = default(string), string masterName = default(string)) => throw null;
            public RedisSentinel(System.Collections.Generic.IEnumerable<string> sentinelHosts, string masterName = default(string)) => throw null;
            public void RefreshActiveSentinels() => throw null;
            public System.TimeSpan RefreshSentinelHostsAfter { get => throw null; set => throw null; }
            public SentinelInfo ResetClients() => throw null;
            public bool ResetWhenObjectivelyDown { get => throw null; set => throw null; }
            public bool ResetWhenSubjectivelyDown { get => throw null; set => throw null; }
            public bool ScanForOtherSentinels { get => throw null; set => throw null; }
            public System.Func<string, string> SentinelHostFilter { get => throw null; set => throw null; }
            public System.Collections.Generic.List<string> SentinelHosts { get => throw null; set => throw null; }
            public int SentinelWorkerConnectTimeoutMs { get => throw null; set => throw null; }
            public int SentinelWorkerReceiveTimeoutMs { get => throw null; set => throw null; }
            public int SentinelWorkerSendTimeoutMs { get => throw null; set => throw null; }
            public ServiceStack.Redis.IRedisClientsManager Start() => throw null;
            public System.TimeSpan WaitBeforeForcingMasterFailover { get => throw null; set => throw null; }
            public System.TimeSpan WaitBetweenFailedHosts { get => throw null; set => throw null; }
        }

        // Generated from `ServiceStack.Redis.RedisSentinelResolver` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class RedisSentinelResolver : ServiceStack.Redis.IRedisResolverExtended, ServiceStack.Redis.IRedisResolver
        {
            public System.Func<ServiceStack.Redis.RedisEndpoint, ServiceStack.Redis.RedisClient> ClientFactory { get => throw null; set => throw null; }
            public ServiceStack.Redis.RedisClient CreateMasterClient(int desiredIndex) => throw null;
            public virtual ServiceStack.Redis.RedisClient CreateRedisClient(ServiceStack.Redis.RedisEndpoint config, bool master) => throw null;
            public ServiceStack.Redis.RedisClient CreateSlaveClient(int desiredIndex) => throw null;
            public ServiceStack.Redis.RedisEndpoint GetReadOnlyHost(int desiredIndex) => throw null;
            public ServiceStack.Redis.RedisEndpoint GetReadWriteHost(int desiredIndex) => throw null;
            public ServiceStack.Redis.RedisEndpoint[] Masters { get => throw null; }
            public int ReadOnlyHostsCount { get => throw null; set => throw null; }
            public int ReadWriteHostsCount { get => throw null; set => throw null; }
            public RedisSentinelResolver(ServiceStack.Redis.RedisSentinel sentinel, System.Collections.Generic.IEnumerable<string> masters, System.Collections.Generic.IEnumerable<string> replicas) => throw null;
            public RedisSentinelResolver(ServiceStack.Redis.RedisSentinel sentinel, System.Collections.Generic.IEnumerable<ServiceStack.Redis.RedisEndpoint> masters, System.Collections.Generic.IEnumerable<ServiceStack.Redis.RedisEndpoint> replicas) => throw null;
            public RedisSentinelResolver(ServiceStack.Redis.RedisSentinel sentinel) => throw null;
            public virtual void ResetMasters(System.Collections.Generic.List<ServiceStack.Redis.RedisEndpoint> newMasters) => throw null;
            public virtual void ResetMasters(System.Collections.Generic.IEnumerable<string> hosts) => throw null;
            public virtual void ResetSlaves(System.Collections.Generic.List<ServiceStack.Redis.RedisEndpoint> newReplicas) => throw null;
            public virtual void ResetSlaves(System.Collections.Generic.IEnumerable<string> hosts) => throw null;
            public ServiceStack.Redis.RedisEndpoint[] Slaves { get => throw null; }
        }

        // Generated from `ServiceStack.Redis.RedisStats` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class RedisStats
        {
            public static void Reset() => throw null;
            public static System.Collections.Generic.Dictionary<string, System.Int64> ToDictionary() => throw null;
            public static System.Int64 TotalClientsCreated { get => throw null; }
            public static System.Int64 TotalClientsCreatedOutsidePool { get => throw null; }
            public static System.Int64 TotalCommandsSent { get => throw null; }
            public static System.Int64 TotalDeactivatedClients { get => throw null; }
            public static System.Int64 TotalFailedSentinelWorkers { get => throw null; }
            public static System.Int64 TotalFailovers { get => throw null; }
            public static System.Int64 TotalForcedMasterFailovers { get => throw null; }
            public static System.Int64 TotalInvalidMasters { get => throw null; }
            public static System.Int64 TotalNoMastersFound { get => throw null; }
            public static System.Int64 TotalObjectiveServersDown { get => throw null; }
            public static System.Int64 TotalPendingDeactivatedClients { get => throw null; }
            public static System.Int64 TotalRetryCount { get => throw null; }
            public static System.Int64 TotalRetrySuccess { get => throw null; }
            public static System.Int64 TotalRetryTimedout { get => throw null; }
            public static System.Int64 TotalSubjectiveServersDown { get => throw null; }
        }

        // Generated from `ServiceStack.Redis.RedisSubscription` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class RedisSubscription : System.IDisposable, System.IAsyncDisposable, ServiceStack.Redis.IRedisSubscriptionAsync, ServiceStack.Redis.IRedisSubscription
        {
            public void Dispose() => throw null;
            System.Threading.Tasks.ValueTask System.IAsyncDisposable.DisposeAsync() => throw null;
            public bool IsPSubscription { get => throw null; set => throw null; }
            public System.Action<string, string> OnMessage { get => throw null; set => throw null; }
            event System.Func<string, string, System.Threading.Tasks.ValueTask> ServiceStack.Redis.IRedisSubscriptionAsync.OnMessageAsync { add => throw null; remove => throw null; }
            public System.Action<string, System.Byte[]> OnMessageBytes { get => throw null; set => throw null; }
            event System.Func<string, System.Byte[], System.Threading.Tasks.ValueTask> ServiceStack.Redis.IRedisSubscriptionAsync.OnMessageBytesAsync { add => throw null; remove => throw null; }
            public System.Action<string> OnSubscribe { get => throw null; set => throw null; }
            event System.Func<string, System.Threading.Tasks.ValueTask> ServiceStack.Redis.IRedisSubscriptionAsync.OnSubscribeAsync { add => throw null; remove => throw null; }
            public System.Action<string> OnUnSubscribe { get => throw null; set => throw null; }
            event System.Func<string, System.Threading.Tasks.ValueTask> ServiceStack.Redis.IRedisSubscriptionAsync.OnUnSubscribeAsync { add => throw null; remove => throw null; }
            public RedisSubscription(ServiceStack.Redis.IRedisNativeClient redisClient) => throw null;
            public void SubscribeToChannels(params string[] channels) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisSubscriptionAsync.SubscribeToChannelsAsync(string[] channels, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisSubscriptionAsync.SubscribeToChannelsAsync(params string[] channels) => throw null;
            public void SubscribeToChannelsMatching(params string[] patterns) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisSubscriptionAsync.SubscribeToChannelsMatchingAsync(string[] patterns, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisSubscriptionAsync.SubscribeToChannelsMatchingAsync(params string[] patterns) => throw null;
            public System.Int64 SubscriptionCount { get => throw null; set => throw null; }
            public void UnSubscribeFromAllChannels() => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisSubscriptionAsync.UnSubscribeFromAllChannelsAsync(System.Threading.CancellationToken token) => throw null;
            public void UnSubscribeFromAllChannelsMatchingAnyPatterns() => throw null;
            public void UnSubscribeFromChannels(params string[] channels) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisSubscriptionAsync.UnSubscribeFromChannelsAsync(string[] channels, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisSubscriptionAsync.UnSubscribeFromChannelsAsync(params string[] channels) => throw null;
            public void UnSubscribeFromChannelsMatching(params string[] patterns) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisSubscriptionAsync.UnSubscribeFromChannelsMatchingAsync(string[] patterns, System.Threading.CancellationToken token) => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisSubscriptionAsync.UnSubscribeFromChannelsMatchingAsync(params string[] patterns) => throw null;
        }

        // Generated from `ServiceStack.Redis.RedisTransaction` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class RedisTransaction : ServiceStack.Redis.RedisAllPurposePipeline, System.IDisposable, System.IAsyncDisposable, ServiceStack.Redis.Pipeline.IRedisQueueableOperationAsync, ServiceStack.Redis.Pipeline.IRedisQueueableOperation, ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperationAsync, ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperation, ServiceStack.Redis.Pipeline.IRedisPipelineSharedAsync, ServiceStack.Redis.Pipeline.IRedisPipelineShared, ServiceStack.Redis.IRedisTransactionBaseAsync, ServiceStack.Redis.IRedisTransactionBase, ServiceStack.Redis.IRedisTransactionAsync, ServiceStack.Redis.IRedisTransaction
        {
            protected override void AddCurrentQueuedOperation() => throw null;
            public bool Commit() => throw null;
            System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.IRedisTransactionAsync.CommitAsync(System.Threading.CancellationToken token) => throw null;
            public override void Dispose() => throw null;
            protected override void Init() => throw null;
            public RedisTransaction(ServiceStack.Redis.RedisClient redisClient) : base(default(ServiceStack.Redis.RedisClient)) => throw null;
            internal RedisTransaction(ServiceStack.Redis.RedisClient redisClient, bool isAsync) : base(default(ServiceStack.Redis.RedisClient)) => throw null;
            public override bool Replay() => throw null;
            public void Rollback() => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.IRedisTransactionAsync.RollbackAsync(System.Threading.CancellationToken token) => throw null;
        }

        // Generated from `ServiceStack.Redis.RedisTransactionFailedException` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class RedisTransactionFailedException : System.Exception
        {
            public RedisTransactionFailedException() => throw null;
        }

        // Generated from `ServiceStack.Redis.RedisTypedPipeline<>` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class RedisTypedPipeline<T> : ServiceStack.Redis.Generic.RedisTypedCommandQueue<T>, System.IDisposable, System.IAsyncDisposable, ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperationAsync, ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperation, ServiceStack.Redis.Pipeline.IRedisPipelineSharedAsync, ServiceStack.Redis.Pipeline.IRedisPipelineShared, ServiceStack.Redis.Generic.IRedisTypedQueueableOperationAsync<T>, ServiceStack.Redis.Generic.IRedisTypedQueueableOperation<T>, ServiceStack.Redis.Generic.IRedisTypedPipelineAsync<T>, ServiceStack.Redis.Generic.IRedisTypedPipeline<T>
        {
            protected void ClosePipeline() => throw null;
            void ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperationAsync.CompleteBytesQueuedCommandAsync(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<System.Byte[]>> bytesReadCommand) => throw null;
            void ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperationAsync.CompleteDoubleQueuedCommandAsync(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<double>> doubleReadCommand) => throw null;
            void ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperationAsync.CompleteIntQueuedCommandAsync(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<int>> intReadCommand) => throw null;
            void ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperationAsync.CompleteLongQueuedCommandAsync(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<System.Int64>> longReadCommand) => throw null;
            void ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperationAsync.CompleteMultiBytesQueuedCommandAsync(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<System.Byte[][]>> multiBytesReadCommand) => throw null;
            void ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperationAsync.CompleteMultiStringQueuedCommandAsync(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>>> multiStringReadCommand) => throw null;
            void ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperationAsync.CompleteRedisDataQueuedCommandAsync(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisData>> redisDataReadCommand) => throw null;
            void ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperationAsync.CompleteStringQueuedCommandAsync(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<string>> stringReadCommand) => throw null;
            void ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperationAsync.CompleteVoidQueuedCommandAsync(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.ValueTask> voidReadCommand) => throw null;
            public virtual void Dispose() => throw null;
            System.Threading.Tasks.ValueTask System.IAsyncDisposable.DisposeAsync() => throw null;
            protected void Execute() => throw null;
            public void Flush() => throw null;
            System.Threading.Tasks.ValueTask ServiceStack.Redis.Pipeline.IRedisPipelineSharedAsync.FlushAsync(System.Threading.CancellationToken token) => throw null;
            protected virtual void Init() => throw null;
            void ServiceStack.Redis.Generic.IRedisTypedQueueableOperationAsync<T>.QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>, System.Threading.Tasks.ValueTask> command, System.Action onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
            void ServiceStack.Redis.Generic.IRedisTypedQueueableOperationAsync<T>.QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>, System.Threading.Tasks.ValueTask<string>> command, System.Action<string> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
            void ServiceStack.Redis.Generic.IRedisTypedQueueableOperationAsync<T>.QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>, System.Threading.Tasks.ValueTask<int>> command, System.Action<int> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
            void ServiceStack.Redis.Generic.IRedisTypedQueueableOperationAsync<T>.QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>, System.Threading.Tasks.ValueTask<double>> command, System.Action<double> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
            void ServiceStack.Redis.Generic.IRedisTypedQueueableOperationAsync<T>.QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>, System.Threading.Tasks.ValueTask<bool>> command, System.Action<bool> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
            void ServiceStack.Redis.Generic.IRedisTypedQueueableOperationAsync<T>.QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>, System.Threading.Tasks.ValueTask<T>> command, System.Action<T> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
            void ServiceStack.Redis.Generic.IRedisTypedQueueableOperationAsync<T>.QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>, System.Threading.Tasks.ValueTask<System.Int64>> command, System.Action<System.Int64> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
            void ServiceStack.Redis.Generic.IRedisTypedQueueableOperationAsync<T>.QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>, System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>>> command, System.Action<System.Collections.Generic.List<string>> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
            void ServiceStack.Redis.Generic.IRedisTypedQueueableOperationAsync<T>.QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>, System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>>> command, System.Action<System.Collections.Generic.List<T>> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
            void ServiceStack.Redis.Generic.IRedisTypedQueueableOperationAsync<T>.QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>, System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<string>>> command, System.Action<System.Collections.Generic.HashSet<string>> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
            void ServiceStack.Redis.Generic.IRedisTypedQueueableOperationAsync<T>.QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>, System.Threading.Tasks.ValueTask<System.Byte[]>> command, System.Action<System.Byte[]> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
            internal RedisTypedPipeline(ServiceStack.Redis.Generic.RedisTypedClient<T> redisClient) : base(default(ServiceStack.Redis.Generic.RedisTypedClient<T>)) => throw null;
            public virtual bool Replay() => throw null;
            System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.Pipeline.IRedisPipelineSharedAsync.ReplayAsync(System.Threading.CancellationToken token) => throw null;
        }

        // Generated from `ServiceStack.Redis.ScanResultExtensions` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class ScanResultExtensions
        {
            public static System.Collections.Generic.Dictionary<string, double> AsItemsWithScores(this ServiceStack.Redis.ScanResult result) => throw null;
            public static System.Collections.Generic.Dictionary<string, string> AsKeyValues(this ServiceStack.Redis.ScanResult result) => throw null;
            public static System.Collections.Generic.List<string> AsStrings(this ServiceStack.Redis.ScanResult result) => throw null;
        }

        // Generated from `ServiceStack.Redis.ShardedConnectionPool` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class ShardedConnectionPool : ServiceStack.Redis.PooledRedisClientManager
        {
            public override int GetHashCode() => throw null;
            public ShardedConnectionPool(string name, int weight, params string[] readWriteHosts) => throw null;
            public string name;
            public int weight;
        }

        // Generated from `ServiceStack.Redis.ShardedRedisClientManager` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class ShardedRedisClientManager
        {
            public ServiceStack.Redis.ShardedConnectionPool GetConnectionPool(string key) => throw null;
            public ShardedRedisClientManager(params ServiceStack.Redis.ShardedConnectionPool[] connectionPools) => throw null;
        }

        // Generated from `ServiceStack.Redis.TemplateRedisFilters` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class TemplateRedisFilters : ServiceStack.Redis.RedisScripts
        {
            public TemplateRedisFilters() => throw null;
        }

        namespace Generic
        {
            // Generated from `ServiceStack.Redis.Generic.ManagedList<>` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public class ManagedList<T> : System.Collections.IEnumerable, System.Collections.Generic.IList<T>, System.Collections.Generic.IEnumerable<T>, System.Collections.Generic.ICollection<T>
            {
                public void Add(T item) => throw null;
                public void Clear() => throw null;
                public bool Contains(T item) => throw null;
                public void CopyTo(T[] array, int arrayIndex) => throw null;
                public int Count { get => throw null; }
                public System.Collections.Generic.IEnumerator<T> GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public int IndexOf(T item) => throw null;
                public void Insert(int index, T item) => throw null;
                public bool IsReadOnly { get => throw null; }
                public T this[int index] { get => throw null; set => throw null; }
                public ManagedList(ServiceStack.Redis.IRedisClientsManager manager, string key) => throw null;
                public bool Remove(T item) => throw null;
                public void RemoveAt(int index) => throw null;
            }

            // Generated from `ServiceStack.Redis.Generic.RedisClientsManagerExtensionsGeneric` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public static class RedisClientsManagerExtensionsGeneric
            {
                public static ServiceStack.Redis.Generic.ManagedList<T> GetManagedList<T>(this ServiceStack.Redis.IRedisClientsManager manager, string key) => throw null;
            }

            // Generated from `ServiceStack.Redis.Generic.RedisTypedClient<>` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public class RedisTypedClient<T> : ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>, ServiceStack.Redis.Generic.IRedisTypedClient<T>, ServiceStack.Data.IEntityStoreAsync<T>, ServiceStack.Data.IEntityStore<T>
            {
                public System.IDisposable AcquireLock(System.TimeSpan timeOut) => throw null;
                public System.IDisposable AcquireLock() => throw null;
                System.Threading.Tasks.ValueTask<System.IAsyncDisposable> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.AcquireLockAsync(System.TimeSpan? timeOut, System.Threading.CancellationToken token) => throw null;
                public void AddItemToList(ServiceStack.Redis.Generic.IRedisList<T> fromList, T value) => throw null;
                System.Threading.Tasks.ValueTask ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.AddItemToListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, T value, System.Threading.CancellationToken token) => throw null;
                public void AddItemToSet(ServiceStack.Redis.Generic.IRedisSet<T> toSet, T item) => throw null;
                System.Threading.Tasks.ValueTask ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.AddItemToSetAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> toSet, T item, System.Threading.CancellationToken token) => throw null;
                public void AddItemToSortedSet(ServiceStack.Redis.Generic.IRedisSortedSet<T> toSet, T value, double score) => throw null;
                public void AddItemToSortedSet(ServiceStack.Redis.Generic.IRedisSortedSet<T> toSet, T value) => throw null;
                System.Threading.Tasks.ValueTask ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.AddItemToSortedSetAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> toSet, T value, double score, System.Threading.CancellationToken token) => throw null;
                System.Threading.Tasks.ValueTask ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.AddItemToSortedSetAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> toSet, T value, System.Threading.CancellationToken token) => throw null;
                public void AddRangeToList(ServiceStack.Redis.Generic.IRedisList<T> fromList, System.Collections.Generic.IEnumerable<T> values) => throw null;
                public void AddToRecentsList(T value) => throw null;
                System.Threading.Tasks.ValueTask ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.AddToRecentsListAsync(T value, System.Threading.CancellationToken token) => throw null;
                public ServiceStack.Redis.Generic.IRedisTypedClientAsync<T> AsAsync() => throw null;
                System.Threading.Tasks.ValueTask ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.BackgroundSaveAsync(System.Threading.CancellationToken token) => throw null;
                public T BlockingDequeueItemFromList(ServiceStack.Redis.Generic.IRedisList<T> fromList, System.TimeSpan? timeOut) => throw null;
                System.Threading.Tasks.ValueTask<T> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.BlockingDequeueItemFromListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, System.TimeSpan? timeOut, System.Threading.CancellationToken token) => throw null;
                public T BlockingPopAndPushItemBetweenLists(ServiceStack.Redis.Generic.IRedisList<T> fromList, ServiceStack.Redis.Generic.IRedisList<T> toList, System.TimeSpan? timeOut) => throw null;
                System.Threading.Tasks.ValueTask<T> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.BlockingPopAndPushItemBetweenListsAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, ServiceStack.Redis.Generic.IRedisListAsync<T> toList, System.TimeSpan? timeOut, System.Threading.CancellationToken token) => throw null;
                public T BlockingPopItemFromList(ServiceStack.Redis.Generic.IRedisList<T> fromList, System.TimeSpan? timeOut) => throw null;
                System.Threading.Tasks.ValueTask<T> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.BlockingPopItemFromListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, System.TimeSpan? timeOut, System.Threading.CancellationToken token) => throw null;
                public T BlockingRemoveStartFromList(ServiceStack.Redis.Generic.IRedisList<T> fromList, System.TimeSpan? timeOut) => throw null;
                System.Threading.Tasks.ValueTask<T> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.BlockingRemoveStartFromListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, System.TimeSpan? timeOut, System.Threading.CancellationToken token) => throw null;
                public bool ContainsKey(string key) => throw null;
                System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.ContainsKeyAsync(string key, System.Threading.CancellationToken token) => throw null;
                public static System.Collections.Generic.Dictionary<TKey, TValue> ConvertEachTo<TKey, TValue>(System.Collections.Generic.IDictionary<string, string> map) => throw null;
                public ServiceStack.Redis.Generic.IRedisTypedPipeline<T> CreatePipeline() => throw null;
                ServiceStack.Redis.Generic.IRedisTypedPipelineAsync<T> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.CreatePipeline() => throw null;
                public ServiceStack.Redis.Generic.IRedisTypedTransaction<T> CreateTransaction() => throw null;
                System.Threading.Tasks.ValueTask<ServiceStack.Redis.Generic.IRedisTypedTransactionAsync<T>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.CreateTransactionAsync(System.Threading.CancellationToken token) => throw null;
                public System.Int64 Db { get => throw null; set => throw null; }
                System.Int64 ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.Db { get => throw null; }
                public System.Int64 DecrementValue(string key) => throw null;
                System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.DecrementValueAsync(string key, System.Threading.CancellationToken token) => throw null;
                public System.Int64 DecrementValueBy(string key, int count) => throw null;
                System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.DecrementValueByAsync(string key, int count, System.Threading.CancellationToken token) => throw null;
                public void Delete(T entity) => throw null;
                public void DeleteAll() => throw null;
                System.Threading.Tasks.Task ServiceStack.Data.IEntityStoreAsync<T>.DeleteAllAsync(System.Threading.CancellationToken token) => throw null;
                System.Threading.Tasks.Task ServiceStack.Data.IEntityStoreAsync<T>.DeleteAsync(T entity, System.Threading.CancellationToken token) => throw null;
                public void DeleteById(object id) => throw null;
                System.Threading.Tasks.Task ServiceStack.Data.IEntityStoreAsync<T>.DeleteByIdAsync(object id, System.Threading.CancellationToken token) => throw null;
                public void DeleteByIds(System.Collections.IEnumerable ids) => throw null;
                System.Threading.Tasks.Task ServiceStack.Data.IEntityStoreAsync<T>.DeleteByIdsAsync(System.Collections.IEnumerable ids, System.Threading.CancellationToken token) => throw null;
                public void DeleteRelatedEntities<TChild>(object parentId) => throw null;
                System.Threading.Tasks.ValueTask ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.DeleteRelatedEntitiesAsync<TChild>(object parentId, System.Threading.CancellationToken token) => throw null;
                public void DeleteRelatedEntity<TChild>(object parentId, object childId) => throw null;
                System.Threading.Tasks.ValueTask ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.DeleteRelatedEntityAsync<TChild>(object parentId, object childId, System.Threading.CancellationToken token) => throw null;
                public T DequeueItemFromList(ServiceStack.Redis.Generic.IRedisList<T> fromList) => throw null;
                System.Threading.Tasks.ValueTask<T> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.DequeueItemFromListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, System.Threading.CancellationToken token) => throw null;
                public static T DeserializeFromString(string serializedObj) => throw null;
                public T DeserializeValue(System.Byte[] value) => throw null;
                public void Discard() => throw null;
                public void EnqueueItemOnList(ServiceStack.Redis.Generic.IRedisList<T> fromList, T item) => throw null;
                System.Threading.Tasks.ValueTask ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.EnqueueItemOnListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, T item, System.Threading.CancellationToken token) => throw null;
                public void Exec() => throw null;
                public bool ExpireAt(object id, System.DateTime expireAt) => throw null;
                System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.ExpireAtAsync(object id, System.DateTime expireAt, System.Threading.CancellationToken token) => throw null;
                public bool ExpireEntryAt(string key, System.DateTime expireAt) => throw null;
                System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.ExpireEntryAtAsync(string key, System.DateTime expireAt, System.Threading.CancellationToken token) => throw null;
                public bool ExpireEntryIn(string key, System.TimeSpan expireIn) => throw null;
                System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.ExpireEntryInAsync(string key, System.TimeSpan expireIn, System.Threading.CancellationToken token) => throw null;
                public bool ExpireIn(object id, System.TimeSpan expireIn) => throw null;
                System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.ExpireInAsync(object id, System.TimeSpan expiresIn, System.Threading.CancellationToken token) => throw null;
                public void FlushAll() => throw null;
                System.Threading.Tasks.ValueTask ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.FlushAllAsync(System.Threading.CancellationToken token) => throw null;
                public void FlushDb() => throw null;
                System.Threading.Tasks.ValueTask ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.FlushDbAsync(System.Threading.CancellationToken token) => throw null;
                public void FlushSendBuffer() => throw null;
                System.Threading.Tasks.ValueTask ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.ForegroundSaveAsync(System.Threading.CancellationToken token) => throw null;
                public System.Collections.Generic.IList<T> GetAll() => throw null;
                System.Threading.Tasks.Task<System.Collections.Generic.IList<T>> ServiceStack.Data.IEntityStoreAsync<T>.GetAllAsync(System.Threading.CancellationToken token) => throw null;
                public System.Collections.Generic.Dictionary<TKey, T> GetAllEntriesFromHash<TKey>(ServiceStack.Redis.Generic.IRedisHash<TKey, T> hash) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.Dictionary<TKey, T>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetAllEntriesFromHashAsync<TKey>(ServiceStack.Redis.Generic.IRedisHashAsync<TKey, T> hash, System.Threading.CancellationToken token) => throw null;
                public System.Collections.Generic.List<T> GetAllItemsFromList(ServiceStack.Redis.Generic.IRedisList<T> fromList) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetAllItemsFromListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, System.Threading.CancellationToken token) => throw null;
                public System.Collections.Generic.HashSet<T> GetAllItemsFromSet(ServiceStack.Redis.Generic.IRedisSet<T> fromSet) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<T>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetAllItemsFromSetAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> fromSet, System.Threading.CancellationToken token) => throw null;
                public System.Collections.Generic.List<T> GetAllItemsFromSortedSet(ServiceStack.Redis.Generic.IRedisSortedSet<T> set) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetAllItemsFromSortedSetAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, System.Threading.CancellationToken token) => throw null;
                public System.Collections.Generic.List<T> GetAllItemsFromSortedSetDesc(ServiceStack.Redis.Generic.IRedisSortedSet<T> set) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetAllItemsFromSortedSetDescAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, System.Threading.CancellationToken token) => throw null;
                public System.Collections.Generic.List<string> GetAllKeys() => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetAllKeysAsync(System.Threading.CancellationToken token) => throw null;
                public System.Collections.Generic.IDictionary<T, double> GetAllWithScoresFromSortedSet(ServiceStack.Redis.Generic.IRedisSortedSet<T> set) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<T, double>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetAllWithScoresFromSortedSetAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, System.Threading.CancellationToken token) => throw null;
                public T GetAndSetValue(string key, T value) => throw null;
                System.Threading.Tasks.ValueTask<T> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetAndSetValueAsync(string key, T value, System.Threading.CancellationToken token) => throw null;
                public T GetById(object id) => throw null;
                System.Threading.Tasks.Task<T> ServiceStack.Data.IEntityStoreAsync<T>.GetByIdAsync(object id, System.Threading.CancellationToken token) => throw null;
                public System.Collections.Generic.IList<T> GetByIds(System.Collections.IEnumerable ids) => throw null;
                System.Threading.Tasks.Task<System.Collections.Generic.IList<T>> ServiceStack.Data.IEntityStoreAsync<T>.GetByIdsAsync(System.Collections.IEnumerable ids, System.Threading.CancellationToken token) => throw null;
                public System.Collections.Generic.HashSet<T> GetDifferencesFromSet(ServiceStack.Redis.Generic.IRedisSet<T> fromSet, params ServiceStack.Redis.Generic.IRedisSet<T>[] withSets) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<T>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetDifferencesFromSetAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> fromSet, params ServiceStack.Redis.Generic.IRedisSetAsync<T>[] withSets) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<T>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetDifferencesFromSetAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> fromSet, ServiceStack.Redis.Generic.IRedisSetAsync<T>[] withSets, System.Threading.CancellationToken token) => throw null;
                public System.Collections.Generic.List<T> GetEarliestFromRecentsList(int skip, int take) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetEarliestFromRecentsListAsync(int skip, int take, System.Threading.CancellationToken token) => throw null;
                public ServiceStack.Redis.RedisKeyType GetEntryType(string key) => throw null;
                System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisKeyType> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetEntryTypeAsync(string key, System.Threading.CancellationToken token) => throw null;
                public T GetFromHash(object id) => throw null;
                System.Threading.Tasks.ValueTask<T> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetFromHashAsync(object id, System.Threading.CancellationToken token) => throw null;
                public ServiceStack.Redis.Generic.IRedisHash<TKey, T> GetHash<TKey>(string hashId) => throw null;
                ServiceStack.Redis.Generic.IRedisHashAsync<TKey, T> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetHash<TKey>(string hashId) => throw null;
                public System.Int64 GetHashCount<TKey>(ServiceStack.Redis.Generic.IRedisHash<TKey, T> hash) => throw null;
                System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetHashCountAsync<TKey>(ServiceStack.Redis.Generic.IRedisHashAsync<TKey, T> hash, System.Threading.CancellationToken token) => throw null;
                public System.Collections.Generic.List<TKey> GetHashKeys<TKey>(ServiceStack.Redis.Generic.IRedisHash<TKey, T> hash) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<TKey>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetHashKeysAsync<TKey>(ServiceStack.Redis.Generic.IRedisHashAsync<TKey, T> hash, System.Threading.CancellationToken token) => throw null;
                public System.Collections.Generic.List<T> GetHashValues<TKey>(ServiceStack.Redis.Generic.IRedisHash<TKey, T> hash) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetHashValuesAsync<TKey>(ServiceStack.Redis.Generic.IRedisHashAsync<TKey, T> hash, System.Threading.CancellationToken token) => throw null;
                public System.Collections.Generic.HashSet<T> GetIntersectFromSets(params ServiceStack.Redis.Generic.IRedisSet<T>[] sets) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<T>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetIntersectFromSetsAsync(params ServiceStack.Redis.Generic.IRedisSetAsync<T>[] sets) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<T>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetIntersectFromSetsAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T>[] sets, System.Threading.CancellationToken token) => throw null;
                public T GetItemFromList(ServiceStack.Redis.Generic.IRedisList<T> fromList, int listIndex) => throw null;
                System.Threading.Tasks.ValueTask<T> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetItemFromListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, int listIndex, System.Threading.CancellationToken token) => throw null;
                public System.Int64 GetItemIndexInSortedSet(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, T value) => throw null;
                System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetItemIndexInSortedSetAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, T value, System.Threading.CancellationToken token) => throw null;
                public System.Int64 GetItemIndexInSortedSetDesc(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, T value) => throw null;
                System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetItemIndexInSortedSetDescAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, T value, System.Threading.CancellationToken token) => throw null;
                public double GetItemScoreInSortedSet(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, T value) => throw null;
                System.Threading.Tasks.ValueTask<double> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetItemScoreInSortedSetAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, T value, System.Threading.CancellationToken token) => throw null;
                public System.Collections.Generic.List<T> GetLatestFromRecentsList(int skip, int take) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetLatestFromRecentsListAsync(int skip, int take, System.Threading.CancellationToken token) => throw null;
                public System.Int64 GetListCount(ServiceStack.Redis.Generic.IRedisList<T> fromList) => throw null;
                System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetListCountAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, System.Threading.CancellationToken token) => throw null;
                public System.Int64 GetNextSequence(int incrBy) => throw null;
                public System.Int64 GetNextSequence() => throw null;
                System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetNextSequenceAsync(int incrBy, System.Threading.CancellationToken token) => throw null;
                System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetNextSequenceAsync(System.Threading.CancellationToken token) => throw null;
                public T GetRandomItemFromSet(ServiceStack.Redis.Generic.IRedisSet<T> fromSet) => throw null;
                System.Threading.Tasks.ValueTask<T> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetRandomItemFromSetAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> fromSet, System.Threading.CancellationToken token) => throw null;
                public string GetRandomKey() => throw null;
                System.Threading.Tasks.ValueTask<string> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetRandomKeyAsync(System.Threading.CancellationToken token) => throw null;
                public System.Collections.Generic.List<T> GetRangeFromList(ServiceStack.Redis.Generic.IRedisList<T> fromList, int startingFrom, int endingAt) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetRangeFromListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, int startingFrom, int endingAt, System.Threading.CancellationToken token) => throw null;
                public System.Collections.Generic.List<T> GetRangeFromSortedSet(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, int fromRank, int toRank) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetRangeFromSortedSetAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, int fromRank, int toRank, System.Threading.CancellationToken token) => throw null;
                public System.Collections.Generic.List<T> GetRangeFromSortedSetByHighestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, string fromStringScore, string toStringScore, int? skip, int? take) => throw null;
                public System.Collections.Generic.List<T> GetRangeFromSortedSetByHighestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, string fromStringScore, string toStringScore) => throw null;
                public System.Collections.Generic.List<T> GetRangeFromSortedSetByHighestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, double fromScore, double toScore, int? skip, int? take) => throw null;
                public System.Collections.Generic.List<T> GetRangeFromSortedSetByHighestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, double fromScore, double toScore) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetRangeFromSortedSetByHighestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, string fromStringScore, string toStringScore, int? skip, int? take, System.Threading.CancellationToken token) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetRangeFromSortedSetByHighestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, string fromStringScore, string toStringScore, System.Threading.CancellationToken token) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetRangeFromSortedSetByHighestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, double fromScore, double toScore, int? skip, int? take, System.Threading.CancellationToken token) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetRangeFromSortedSetByHighestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, double fromScore, double toScore, System.Threading.CancellationToken token) => throw null;
                public System.Collections.Generic.List<T> GetRangeFromSortedSetByLowestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, string fromStringScore, string toStringScore, int? skip, int? take) => throw null;
                public System.Collections.Generic.List<T> GetRangeFromSortedSetByLowestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, string fromStringScore, string toStringScore) => throw null;
                public System.Collections.Generic.List<T> GetRangeFromSortedSetByLowestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, double fromScore, double toScore, int? skip, int? take) => throw null;
                public System.Collections.Generic.List<T> GetRangeFromSortedSetByLowestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, double fromScore, double toScore) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetRangeFromSortedSetByLowestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, string fromStringScore, string toStringScore, int? skip, int? take, System.Threading.CancellationToken token) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetRangeFromSortedSetByLowestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, string fromStringScore, string toStringScore, System.Threading.CancellationToken token) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetRangeFromSortedSetByLowestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, double fromScore, double toScore, int? skip, int? take, System.Threading.CancellationToken token) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetRangeFromSortedSetByLowestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, double fromScore, double toScore, System.Threading.CancellationToken token) => throw null;
                public System.Collections.Generic.List<T> GetRangeFromSortedSetDesc(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, int fromRank, int toRank) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetRangeFromSortedSetDescAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, int fromRank, int toRank, System.Threading.CancellationToken token) => throw null;
                public System.Collections.Generic.IDictionary<T, double> GetRangeWithScoresFromSortedSet(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, int fromRank, int toRank) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<T, double>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetRangeWithScoresFromSortedSetAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, int fromRank, int toRank, System.Threading.CancellationToken token) => throw null;
                public System.Collections.Generic.IDictionary<T, double> GetRangeWithScoresFromSortedSetByHighestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, string fromStringScore, string toStringScore, int? skip, int? take) => throw null;
                public System.Collections.Generic.IDictionary<T, double> GetRangeWithScoresFromSortedSetByHighestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, string fromStringScore, string toStringScore) => throw null;
                public System.Collections.Generic.IDictionary<T, double> GetRangeWithScoresFromSortedSetByHighestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, double fromScore, double toScore, int? skip, int? take) => throw null;
                public System.Collections.Generic.IDictionary<T, double> GetRangeWithScoresFromSortedSetByHighestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, double fromScore, double toScore) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<T, double>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetRangeWithScoresFromSortedSetByHighestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, string fromStringScore, string toStringScore, int? skip, int? take, System.Threading.CancellationToken token) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<T, double>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetRangeWithScoresFromSortedSetByHighestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, string fromStringScore, string toStringScore, System.Threading.CancellationToken token) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<T, double>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetRangeWithScoresFromSortedSetByHighestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, double fromScore, double toScore, int? skip, int? take, System.Threading.CancellationToken token) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<T, double>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetRangeWithScoresFromSortedSetByHighestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, double fromScore, double toScore, System.Threading.CancellationToken token) => throw null;
                public System.Collections.Generic.IDictionary<T, double> GetRangeWithScoresFromSortedSetByLowestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, string fromStringScore, string toStringScore, int? skip, int? take) => throw null;
                public System.Collections.Generic.IDictionary<T, double> GetRangeWithScoresFromSortedSetByLowestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, string fromStringScore, string toStringScore) => throw null;
                public System.Collections.Generic.IDictionary<T, double> GetRangeWithScoresFromSortedSetByLowestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, double fromScore, double toScore, int? skip, int? take) => throw null;
                public System.Collections.Generic.IDictionary<T, double> GetRangeWithScoresFromSortedSetByLowestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, double fromScore, double toScore) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<T, double>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetRangeWithScoresFromSortedSetByLowestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, string fromStringScore, string toStringScore, int? skip, int? take, System.Threading.CancellationToken token) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<T, double>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetRangeWithScoresFromSortedSetByLowestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, string fromStringScore, string toStringScore, System.Threading.CancellationToken token) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<T, double>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetRangeWithScoresFromSortedSetByLowestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, double fromScore, double toScore, int? skip, int? take, System.Threading.CancellationToken token) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<T, double>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetRangeWithScoresFromSortedSetByLowestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, double fromScore, double toScore, System.Threading.CancellationToken token) => throw null;
                public System.Collections.Generic.IDictionary<T, double> GetRangeWithScoresFromSortedSetDesc(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, int fromRank, int toRank) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<T, double>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetRangeWithScoresFromSortedSetDescAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, int fromRank, int toRank, System.Threading.CancellationToken token) => throw null;
                public System.Collections.Generic.List<TChild> GetRelatedEntities<TChild>(object parentId) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<TChild>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetRelatedEntitiesAsync<TChild>(object parentId, System.Threading.CancellationToken token) => throw null;
                public System.Int64 GetRelatedEntitiesCount<TChild>(object parentId) => throw null;
                System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetRelatedEntitiesCountAsync<TChild>(object parentId, System.Threading.CancellationToken token) => throw null;
                public System.Int64 GetSetCount(ServiceStack.Redis.Generic.IRedisSet<T> set) => throw null;
                System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetSetCountAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> set, System.Threading.CancellationToken token) => throw null;
                public System.Collections.Generic.List<T> GetSortedEntryValues(ServiceStack.Redis.Generic.IRedisSet<T> fromSet, int startingFrom, int endingAt) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetSortedEntryValuesAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> fromSet, int startingFrom, int endingAt, System.Threading.CancellationToken token) => throw null;
                public System.Int64 GetSortedSetCount(ServiceStack.Redis.Generic.IRedisSortedSet<T> set) => throw null;
                System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetSortedSetCountAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, System.Threading.CancellationToken token) => throw null;
                public System.TimeSpan GetTimeToLive(string key) => throw null;
                System.Threading.Tasks.ValueTask<System.TimeSpan> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetTimeToLiveAsync(string key, System.Threading.CancellationToken token) => throw null;
                public System.Collections.Generic.HashSet<T> GetUnionFromSets(params ServiceStack.Redis.Generic.IRedisSet<T>[] sets) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<T>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetUnionFromSetsAsync(params ServiceStack.Redis.Generic.IRedisSetAsync<T>[] sets) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<T>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetUnionFromSetsAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T>[] sets, System.Threading.CancellationToken token) => throw null;
                public T GetValue(string key) => throw null;
                System.Threading.Tasks.ValueTask<T> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetValueAsync(string key, System.Threading.CancellationToken token) => throw null;
                public T GetValueFromHash<TKey>(ServiceStack.Redis.Generic.IRedisHash<TKey, T> hash, TKey key) => throw null;
                System.Threading.Tasks.ValueTask<T> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetValueFromHashAsync<TKey>(ServiceStack.Redis.Generic.IRedisHashAsync<TKey, T> hash, TKey key, System.Threading.CancellationToken token) => throw null;
                public System.Collections.Generic.List<T> GetValues(System.Collections.Generic.List<string> keys) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.GetValuesAsync(System.Collections.Generic.List<string> keys, System.Threading.CancellationToken token) => throw null;
                public bool HashContainsEntry<TKey>(ServiceStack.Redis.Generic.IRedisHash<TKey, T> hash, TKey key) => throw null;
                System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.HashContainsEntryAsync<TKey>(ServiceStack.Redis.Generic.IRedisHashAsync<TKey, T> hash, TKey key, System.Threading.CancellationToken token) => throw null;
                public double IncrementItemInSortedSet(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, T value, double incrementBy) => throw null;
                System.Threading.Tasks.ValueTask<double> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.IncrementItemInSortedSetAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, T value, double incrementBy, System.Threading.CancellationToken token) => throw null;
                public System.Int64 IncrementValue(string key) => throw null;
                System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.IncrementValueAsync(string key, System.Threading.CancellationToken token) => throw null;
                public System.Int64 IncrementValueBy(string key, int count) => throw null;
                System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.IncrementValueByAsync(string key, int count, System.Threading.CancellationToken token) => throw null;
                public void InsertAfterItemInList(ServiceStack.Redis.Generic.IRedisList<T> toList, T pivot, T value) => throw null;
                System.Threading.Tasks.ValueTask ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.InsertAfterItemInListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> toList, T pivot, T value, System.Threading.CancellationToken token) => throw null;
                public void InsertBeforeItemInList(ServiceStack.Redis.Generic.IRedisList<T> toList, T pivot, T value) => throw null;
                System.Threading.Tasks.ValueTask ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.InsertBeforeItemInListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> toList, T pivot, T value, System.Threading.CancellationToken token) => throw null;
                public T this[string key] { get => throw null; set => throw null; }
                public ServiceStack.Model.IHasNamed<ServiceStack.Redis.Generic.IRedisList<T>> Lists { get => throw null; set => throw null; }
                ServiceStack.Model.IHasNamed<ServiceStack.Redis.Generic.IRedisListAsync<T>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.Lists { get => throw null; }
                public void MoveBetweenSets(ServiceStack.Redis.Generic.IRedisSet<T> fromSet, ServiceStack.Redis.Generic.IRedisSet<T> toSet, T item) => throw null;
                System.Threading.Tasks.ValueTask ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.MoveBetweenSetsAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> fromSet, ServiceStack.Redis.Generic.IRedisSetAsync<T> toSet, T item, System.Threading.CancellationToken token) => throw null;
                public void Multi() => throw null;
                public ServiceStack.Redis.IRedisNativeClient NativeClient { get => throw null; }
                public ServiceStack.Redis.Pipeline.IRedisPipelineShared Pipeline { get => throw null; set => throw null; }
                public T PopAndPushItemBetweenLists(ServiceStack.Redis.Generic.IRedisList<T> fromList, ServiceStack.Redis.Generic.IRedisList<T> toList) => throw null;
                System.Threading.Tasks.ValueTask<T> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.PopAndPushItemBetweenListsAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, ServiceStack.Redis.Generic.IRedisListAsync<T> toList, System.Threading.CancellationToken token) => throw null;
                public T PopItemFromList(ServiceStack.Redis.Generic.IRedisList<T> fromList) => throw null;
                System.Threading.Tasks.ValueTask<T> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.PopItemFromListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, System.Threading.CancellationToken token) => throw null;
                public T PopItemFromSet(ServiceStack.Redis.Generic.IRedisSet<T> fromSet) => throw null;
                System.Threading.Tasks.ValueTask<T> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.PopItemFromSetAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> fromSet, System.Threading.CancellationToken token) => throw null;
                public T PopItemWithHighestScoreFromSortedSet(ServiceStack.Redis.Generic.IRedisSortedSet<T> fromSet) => throw null;
                System.Threading.Tasks.ValueTask<T> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.PopItemWithHighestScoreFromSortedSetAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> fromSet, System.Threading.CancellationToken token) => throw null;
                public T PopItemWithLowestScoreFromSortedSet(ServiceStack.Redis.Generic.IRedisSortedSet<T> fromSet) => throw null;
                System.Threading.Tasks.ValueTask<T> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.PopItemWithLowestScoreFromSortedSetAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> fromSet, System.Threading.CancellationToken token) => throw null;
                public void PrependItemToList(ServiceStack.Redis.Generic.IRedisList<T> fromList, T value) => throw null;
                System.Threading.Tasks.ValueTask ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.PrependItemToListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, T value, System.Threading.CancellationToken token) => throw null;
                public void PushItemToList(ServiceStack.Redis.Generic.IRedisList<T> fromList, T item) => throw null;
                System.Threading.Tasks.ValueTask ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.PushItemToListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, T item, System.Threading.CancellationToken token) => throw null;
                public ServiceStack.Redis.IRedisClient RedisClient { get => throw null; }
                ServiceStack.Redis.IRedisClientAsync ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.RedisClient { get => throw null; }
                public RedisTypedClient(ServiceStack.Redis.RedisClient client) => throw null;
                public void RemoveAllFromList(ServiceStack.Redis.Generic.IRedisList<T> fromList) => throw null;
                System.Threading.Tasks.ValueTask ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.RemoveAllFromListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, System.Threading.CancellationToken token) => throw null;
                public T RemoveEndFromList(ServiceStack.Redis.Generic.IRedisList<T> fromList) => throw null;
                System.Threading.Tasks.ValueTask<T> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.RemoveEndFromListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, System.Threading.CancellationToken token) => throw null;
                public bool RemoveEntry(string key) => throw null;
                public bool RemoveEntry(params string[] keys) => throw null;
                public bool RemoveEntry(params ServiceStack.Model.IHasStringId[] entities) => throw null;
                System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.RemoveEntryAsync(string[] keys, System.Threading.CancellationToken token) => throw null;
                System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.RemoveEntryAsync(string key, System.Threading.CancellationToken token) => throw null;
                System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.RemoveEntryAsync(params string[] args) => throw null;
                System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.RemoveEntryAsync(params ServiceStack.Model.IHasStringId[] entities) => throw null;
                System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.RemoveEntryAsync(ServiceStack.Model.IHasStringId[] entities, System.Threading.CancellationToken token) => throw null;
                public bool RemoveEntryFromHash<TKey>(ServiceStack.Redis.Generic.IRedisHash<TKey, T> hash, TKey key) => throw null;
                System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.RemoveEntryFromHashAsync<TKey>(ServiceStack.Redis.Generic.IRedisHashAsync<TKey, T> hash, TKey key, System.Threading.CancellationToken token) => throw null;
                public System.Int64 RemoveItemFromList(ServiceStack.Redis.Generic.IRedisList<T> fromList, T value, int noOfMatches) => throw null;
                public System.Int64 RemoveItemFromList(ServiceStack.Redis.Generic.IRedisList<T> fromList, T value) => throw null;
                System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.RemoveItemFromListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, T value, int noOfMatches, System.Threading.CancellationToken token) => throw null;
                System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.RemoveItemFromListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, T value, System.Threading.CancellationToken token) => throw null;
                public void RemoveItemFromSet(ServiceStack.Redis.Generic.IRedisSet<T> fromSet, T item) => throw null;
                System.Threading.Tasks.ValueTask ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.RemoveItemFromSetAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> fromSet, T item, System.Threading.CancellationToken token) => throw null;
                public bool RemoveItemFromSortedSet(ServiceStack.Redis.Generic.IRedisSortedSet<T> fromSet, T value) => throw null;
                System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.RemoveItemFromSortedSetAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> fromSet, T value, System.Threading.CancellationToken token) => throw null;
                public System.Int64 RemoveRangeFromSortedSet(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, int minRank, int maxRank) => throw null;
                System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.RemoveRangeFromSortedSetAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, int minRank, int maxRank, System.Threading.CancellationToken token) => throw null;
                public System.Int64 RemoveRangeFromSortedSetByScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, double fromScore, double toScore) => throw null;
                System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.RemoveRangeFromSortedSetByScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, double fromScore, double toScore, System.Threading.CancellationToken token) => throw null;
                public T RemoveStartFromList(ServiceStack.Redis.Generic.IRedisList<T> fromList) => throw null;
                System.Threading.Tasks.ValueTask<T> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.RemoveStartFromListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, System.Threading.CancellationToken token) => throw null;
                public void ResetSendBuffer() => throw null;
                public void Save() => throw null;
                public void SaveAsync() => throw null;
                public T[] SearchKeys(string pattern) => throw null;
                System.Threading.Tasks.ValueTask<T[]> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.SearchKeysAsync(string pattern, System.Threading.CancellationToken token) => throw null;
                System.Threading.Tasks.ValueTask ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.SelectAsync(System.Int64 db, System.Threading.CancellationToken token) => throw null;
                public string SequenceKey { get => throw null; set => throw null; }
                public System.Byte[] SerializeValue(T value) => throw null;
                public bool SetContainsItem(ServiceStack.Redis.Generic.IRedisSet<T> set, T item) => throw null;
                System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.SetContainsItemAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> set, T item, System.Threading.CancellationToken token) => throw null;
                public bool SetEntryInHash<TKey>(ServiceStack.Redis.Generic.IRedisHash<TKey, T> hash, TKey key, T value) => throw null;
                System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.SetEntryInHashAsync<TKey>(ServiceStack.Redis.Generic.IRedisHashAsync<TKey, T> hash, TKey key, T value, System.Threading.CancellationToken token) => throw null;
                public bool SetEntryInHashIfNotExists<TKey>(ServiceStack.Redis.Generic.IRedisHash<TKey, T> hash, TKey key, T value) => throw null;
                System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.SetEntryInHashIfNotExistsAsync<TKey>(ServiceStack.Redis.Generic.IRedisHashAsync<TKey, T> hash, TKey key, T value, System.Threading.CancellationToken token) => throw null;
                public void SetItemInList(ServiceStack.Redis.Generic.IRedisList<T> toList, int listIndex, T value) => throw null;
                System.Threading.Tasks.ValueTask ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.SetItemInListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> toList, int listIndex, T value, System.Threading.CancellationToken token) => throw null;
                public void SetRangeInHash<TKey>(ServiceStack.Redis.Generic.IRedisHash<TKey, T> hash, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey, T>> keyValuePairs) => throw null;
                System.Threading.Tasks.ValueTask ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.SetRangeInHashAsync<TKey>(ServiceStack.Redis.Generic.IRedisHashAsync<TKey, T> hash, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey, T>> keyValuePairs, System.Threading.CancellationToken token) => throw null;
                public void SetSequence(int value) => throw null;
                System.Threading.Tasks.ValueTask ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.SetSequenceAsync(int value, System.Threading.CancellationToken token) => throw null;
                public void SetValue(string key, T entity, System.TimeSpan expireIn) => throw null;
                public void SetValue(string key, T entity) => throw null;
                System.Threading.Tasks.ValueTask ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.SetValueAsync(string key, T entity, System.TimeSpan expireIn, System.Threading.CancellationToken token) => throw null;
                System.Threading.Tasks.ValueTask ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.SetValueAsync(string key, T entity, System.Threading.CancellationToken token) => throw null;
                public bool SetValueIfExists(string key, T entity) => throw null;
                System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.SetValueIfExistsAsync(string key, T entity, System.Threading.CancellationToken token) => throw null;
                public bool SetValueIfNotExists(string key, T entity) => throw null;
                System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.SetValueIfNotExistsAsync(string key, T entity, System.Threading.CancellationToken token) => throw null;
                public ServiceStack.Model.IHasNamed<ServiceStack.Redis.Generic.IRedisSet<T>> Sets { get => throw null; set => throw null; }
                ServiceStack.Model.IHasNamed<ServiceStack.Redis.Generic.IRedisSetAsync<T>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.Sets { get => throw null; }
                public System.Collections.Generic.List<T> SortList(ServiceStack.Redis.Generic.IRedisList<T> fromList, int startingFrom, int endingAt) => throw null;
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.SortListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, int startingFrom, int endingAt, System.Threading.CancellationToken token) => throw null;
                public bool SortedSetContainsItem(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, T value) => throw null;
                System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.SortedSetContainsItemAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, T value, System.Threading.CancellationToken token) => throw null;
                public ServiceStack.Model.IHasNamed<ServiceStack.Redis.Generic.IRedisSortedSet<T>> SortedSets { get => throw null; set => throw null; }
                ServiceStack.Model.IHasNamed<ServiceStack.Redis.Generic.IRedisSortedSetAsync<T>> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.SortedSets { get => throw null; }
                public T Store(T entity, System.TimeSpan expireIn) => throw null;
                public T Store(T entity) => throw null;
                public void StoreAll(System.Collections.Generic.IEnumerable<T> entities) => throw null;
                System.Threading.Tasks.Task ServiceStack.Data.IEntityStoreAsync<T>.StoreAllAsync(System.Collections.Generic.IEnumerable<T> entities, System.Threading.CancellationToken token) => throw null;
                public void StoreAsHash(T entity) => throw null;
                System.Threading.Tasks.ValueTask ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.StoreAsHashAsync(T entity, System.Threading.CancellationToken token) => throw null;
                System.Threading.Tasks.ValueTask<T> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.StoreAsync(T entity, System.TimeSpan expireIn, System.Threading.CancellationToken token) => throw null;
                System.Threading.Tasks.Task<T> ServiceStack.Data.IEntityStoreAsync<T>.StoreAsync(T entity, System.Threading.CancellationToken token) => throw null;
                public void StoreDifferencesFromSet(ServiceStack.Redis.Generic.IRedisSet<T> intoSet, ServiceStack.Redis.Generic.IRedisSet<T> fromSet, params ServiceStack.Redis.Generic.IRedisSet<T>[] withSets) => throw null;
                System.Threading.Tasks.ValueTask ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.StoreDifferencesFromSetAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> intoSet, ServiceStack.Redis.Generic.IRedisSetAsync<T> fromSet, params ServiceStack.Redis.Generic.IRedisSetAsync<T>[] withSets) => throw null;
                System.Threading.Tasks.ValueTask ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.StoreDifferencesFromSetAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> intoSet, ServiceStack.Redis.Generic.IRedisSetAsync<T> fromSet, ServiceStack.Redis.Generic.IRedisSetAsync<T>[] withSets, System.Threading.CancellationToken token) => throw null;
                public void StoreIntersectFromSets(ServiceStack.Redis.Generic.IRedisSet<T> intoSet, params ServiceStack.Redis.Generic.IRedisSet<T>[] sets) => throw null;
                System.Threading.Tasks.ValueTask ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.StoreIntersectFromSetsAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> intoSet, params ServiceStack.Redis.Generic.IRedisSetAsync<T>[] sets) => throw null;
                System.Threading.Tasks.ValueTask ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.StoreIntersectFromSetsAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> intoSet, ServiceStack.Redis.Generic.IRedisSetAsync<T>[] sets, System.Threading.CancellationToken token) => throw null;
                public System.Int64 StoreIntersectFromSortedSets(ServiceStack.Redis.Generic.IRedisSortedSet<T> intoSetId, params ServiceStack.Redis.Generic.IRedisSortedSet<T>[] setIds) => throw null;
                public System.Int64 StoreIntersectFromSortedSets(ServiceStack.Redis.Generic.IRedisSortedSet<T> intoSetId, ServiceStack.Redis.Generic.IRedisSortedSet<T>[] setIds, string[] args) => throw null;
                System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.StoreIntersectFromSortedSetsAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> intoSetId, params ServiceStack.Redis.Generic.IRedisSortedSetAsync<T>[] setIds) => throw null;
                System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.StoreIntersectFromSortedSetsAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> intoSetId, ServiceStack.Redis.Generic.IRedisSortedSetAsync<T>[] setIds, string[] args, System.Threading.CancellationToken token) => throw null;
                System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.StoreIntersectFromSortedSetsAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> intoSetId, ServiceStack.Redis.Generic.IRedisSortedSetAsync<T>[] setIds, System.Threading.CancellationToken token) => throw null;
                public void StoreRelatedEntities<TChild>(object parentId, params TChild[] children) => throw null;
                public void StoreRelatedEntities<TChild>(object parentId, System.Collections.Generic.List<TChild> children) => throw null;
                System.Threading.Tasks.ValueTask ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.StoreRelatedEntitiesAsync<TChild>(object parentId, params TChild[] children) => throw null;
                System.Threading.Tasks.ValueTask ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.StoreRelatedEntitiesAsync<TChild>(object parentId, TChild[] children, System.Threading.CancellationToken token) => throw null;
                System.Threading.Tasks.ValueTask ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.StoreRelatedEntitiesAsync<TChild>(object parentId, System.Collections.Generic.List<TChild> children, System.Threading.CancellationToken token) => throw null;
                public void StoreUnionFromSets(ServiceStack.Redis.Generic.IRedisSet<T> intoSet, params ServiceStack.Redis.Generic.IRedisSet<T>[] sets) => throw null;
                System.Threading.Tasks.ValueTask ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.StoreUnionFromSetsAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> intoSet, params ServiceStack.Redis.Generic.IRedisSetAsync<T>[] sets) => throw null;
                System.Threading.Tasks.ValueTask ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.StoreUnionFromSetsAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> intoSet, ServiceStack.Redis.Generic.IRedisSetAsync<T>[] sets, System.Threading.CancellationToken token) => throw null;
                public System.Int64 StoreUnionFromSortedSets(ServiceStack.Redis.Generic.IRedisSortedSet<T> intoSetId, params ServiceStack.Redis.Generic.IRedisSortedSet<T>[] setIds) => throw null;
                public System.Int64 StoreUnionFromSortedSets(ServiceStack.Redis.Generic.IRedisSortedSet<T> intoSetId, ServiceStack.Redis.Generic.IRedisSortedSet<T>[] setIds, string[] args) => throw null;
                System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.StoreUnionFromSortedSetsAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> intoSetId, params ServiceStack.Redis.Generic.IRedisSortedSetAsync<T>[] setIds) => throw null;
                System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.StoreUnionFromSortedSetsAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> intoSetId, ServiceStack.Redis.Generic.IRedisSortedSetAsync<T>[] setIds, string[] args, System.Threading.CancellationToken token) => throw null;
                System.Threading.Tasks.ValueTask<System.Int64> ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.StoreUnionFromSortedSetsAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> intoSetId, ServiceStack.Redis.Generic.IRedisSortedSetAsync<T>[] setIds, System.Threading.CancellationToken token) => throw null;
                public ServiceStack.Redis.IRedisTransactionBase Transaction { get => throw null; set => throw null; }
                public void TrimList(ServiceStack.Redis.Generic.IRedisList<T> fromList, int keepStartingFrom, int keepEndingAt) => throw null;
                System.Threading.Tasks.ValueTask ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.TrimListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, int keepStartingFrom, int keepEndingAt, System.Threading.CancellationToken token) => throw null;
                public ServiceStack.Redis.IRedisSet TypeIdsSet { get => throw null; }
                ServiceStack.Redis.IRedisSetAsync ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>.TypeIdsSet { get => throw null; }
                public string TypeIdsSetKey { get => throw null; set => throw null; }
                public string TypeLockKey { get => throw null; set => throw null; }
                public void UnWatch() => throw null;
                public string UrnKey(T entity) => throw null;
                public void Watch(params string[] keys) => throw null;
            }

            // Generated from `ServiceStack.Redis.Generic.RedisTypedCommandQueue<>` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public class RedisTypedCommandQueue<T> : ServiceStack.Redis.RedisQueueCompletableOperation
            {
                public void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, string> command, System.Action<string> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
                public void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, string> command, System.Action<string> onSuccessCallback) => throw null;
                public void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, string> command) => throw null;
                public void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, int> command, System.Action<int> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
                public void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, int> command, System.Action<int> onSuccessCallback) => throw null;
                public void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, int> command) => throw null;
                public void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, double> command, System.Action<double> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
                public void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, double> command, System.Action<double> onSuccessCallback) => throw null;
                public void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, double> command) => throw null;
                public void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, bool> command, System.Action<bool> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
                public void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, bool> command, System.Action<bool> onSuccessCallback) => throw null;
                public void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, bool> command) => throw null;
                public void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, T> command, System.Action<T> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
                public void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, T> command, System.Action<T> onSuccessCallback) => throw null;
                public void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, T> command) => throw null;
                public void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Int64> command, System.Action<System.Int64> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
                public void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Int64> command, System.Action<System.Int64> onSuccessCallback) => throw null;
                public void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Int64> command) => throw null;
                public void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Collections.Generic.List<string>> command, System.Action<System.Collections.Generic.List<string>> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
                public void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Collections.Generic.List<string>> command, System.Action<System.Collections.Generic.List<string>> onSuccessCallback) => throw null;
                public void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Collections.Generic.List<string>> command) => throw null;
                public void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Collections.Generic.List<T>> command, System.Action<System.Collections.Generic.List<T>> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
                public void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Collections.Generic.List<T>> command, System.Action<System.Collections.Generic.List<T>> onSuccessCallback) => throw null;
                public void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Collections.Generic.List<T>> command) => throw null;
                public void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Collections.Generic.HashSet<string>> command, System.Action<System.Collections.Generic.HashSet<string>> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
                public void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Collections.Generic.HashSet<string>> command, System.Action<System.Collections.Generic.HashSet<string>> onSuccessCallback) => throw null;
                public void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Collections.Generic.HashSet<string>> command) => throw null;
                public void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Collections.Generic.HashSet<T>> command, System.Action<System.Collections.Generic.HashSet<T>> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
                public void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Collections.Generic.HashSet<T>> command, System.Action<System.Collections.Generic.HashSet<T>> onSuccessCallback) => throw null;
                public void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Collections.Generic.HashSet<T>> command) => throw null;
                public void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Byte[][]> command, System.Action<System.Byte[][]> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
                public void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Byte[][]> command, System.Action<System.Byte[][]> onSuccessCallback) => throw null;
                public void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Byte[][]> command) => throw null;
                public void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Byte[]> command, System.Action<System.Byte[]> onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
                public void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Byte[]> command, System.Action<System.Byte[]> onSuccessCallback) => throw null;
                public void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Byte[]> command) => throw null;
                public void QueueCommand(System.Action<ServiceStack.Redis.Generic.IRedisTypedClient<T>> command, System.Action onSuccessCallback, System.Action<System.Exception> onErrorCallback) => throw null;
                public void QueueCommand(System.Action<ServiceStack.Redis.Generic.IRedisTypedClient<T>> command, System.Action onSuccessCallback) => throw null;
                public void QueueCommand(System.Action<ServiceStack.Redis.Generic.IRedisTypedClient<T>> command) => throw null;
                internal RedisTypedCommandQueue(ServiceStack.Redis.Generic.RedisTypedClient<T> redisClient) => throw null;
            }

        }
        namespace Pipeline
        {
            // Generated from `ServiceStack.Redis.Pipeline.RedisPipelineCommand` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public class RedisPipelineCommand
            {
                public void Flush() => throw null;
                public System.Collections.Generic.List<System.Int64> ReadAllAsInts() => throw null;
                public bool ReadAllAsIntsHaveSuccess() => throw null;
                public RedisPipelineCommand(ServiceStack.Redis.RedisNativeClient client) => throw null;
                public void WriteCommand(params System.Byte[][] cmdWithBinaryArgs) => throw null;
            }

        }
        namespace Support
        {
            // Generated from `ServiceStack.Redis.Support.ConsistentHash<>` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public class ConsistentHash<T>
            {
                public void AddTarget(T node, int weight) => throw null;
                public ConsistentHash(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<T, int>> nodes, System.Func<string, System.UInt64> hashFunction) => throw null;
                public ConsistentHash(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<T, int>> nodes) => throw null;
                public ConsistentHash() => throw null;
                public T GetTarget(string key) => throw null;
                public static System.UInt64 Md5Hash(string key) => throw null;
                public static System.UInt64 ModifiedBinarySearch(System.UInt64[] sortedArray, System.UInt64 val) => throw null;
            }

            // Generated from `ServiceStack.Redis.Support.IOrderedDictionary<,>` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public interface IOrderedDictionary<TKey, TValue> : System.Collections.Specialized.IOrderedDictionary, System.Collections.IEnumerable, System.Collections.IDictionary, System.Collections.ICollection, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey, TValue>>, System.Collections.Generic.IDictionary<TKey, TValue>, System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>
            {
                int Add(TKey key, TValue value);
                void Insert(int index, TKey key, TValue value);
                TValue this[int index] { get; set; }
            }

            // Generated from `ServiceStack.Redis.Support.ISerializer` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public interface ISerializer
            {
                object Deserialize(System.Byte[] someBytes);
                System.Byte[] Serialize(object value);
            }

            // Generated from `ServiceStack.Redis.Support.ObjectSerializer` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public class ObjectSerializer : ServiceStack.Redis.Support.ISerializer
            {
                public virtual object Deserialize(System.Byte[] someBytes) => throw null;
                public ObjectSerializer() => throw null;
                public virtual System.Byte[] Serialize(object value) => throw null;
                protected System.Runtime.Serialization.Formatters.Binary.BinaryFormatter bf;
            }

            // Generated from `ServiceStack.Redis.Support.OptimizedObjectSerializer` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public class OptimizedObjectSerializer : ServiceStack.Redis.Support.ObjectSerializer
            {
                public override object Deserialize(System.Byte[] someBytes) => throw null;
                public OptimizedObjectSerializer() => throw null;
                public override System.Byte[] Serialize(object value) => throw null;
            }

            // Generated from `ServiceStack.Redis.Support.OrderedDictionary<,>` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public class OrderedDictionary<TKey, TValue> : System.Collections.Specialized.IOrderedDictionary, System.Collections.IEnumerable, System.Collections.IDictionary, System.Collections.ICollection, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey, TValue>>, System.Collections.Generic.IDictionary<TKey, TValue>, System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>, ServiceStack.Redis.Support.IOrderedDictionary<TKey, TValue>
            {
                void System.Collections.IDictionary.Add(object key, object value) => throw null;
                void System.Collections.Generic.IDictionary<TKey, TValue>.Add(TKey key, TValue value) => throw null;
                void System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>.Add(System.Collections.Generic.KeyValuePair<TKey, TValue> item) => throw null;
                public int Add(TKey key, TValue value) => throw null;
                public void Clear() => throw null;
                bool System.Collections.IDictionary.Contains(object key) => throw null;
                bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>.Contains(System.Collections.Generic.KeyValuePair<TKey, TValue> item) => throw null;
                public bool ContainsKey(TKey key) => throw null;
                void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                void System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>.CopyTo(System.Collections.Generic.KeyValuePair<TKey, TValue>[] array, int arrayIndex) => throw null;
                public int Count { get => throw null; }
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                System.Collections.IDictionaryEnumerator System.Collections.Specialized.IOrderedDictionary.GetEnumerator() => throw null;
                System.Collections.IDictionaryEnumerator System.Collections.IDictionary.GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<TKey, TValue>> System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey, TValue>>.GetEnumerator() => throw null;
                public int IndexOfKey(TKey key) => throw null;
                void System.Collections.Specialized.IOrderedDictionary.Insert(int index, object key, object value) => throw null;
                public void Insert(int index, TKey key, TValue value) => throw null;
                bool System.Collections.IDictionary.IsFixedSize { get => throw null; }
                public bool IsReadOnly { get => throw null; }
                bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                public TValue this[int index] { get => throw null; set => throw null; }
                public TValue this[TKey key] { get => throw null; set => throw null; }
                object System.Collections.Specialized.IOrderedDictionary.this[int index] { get => throw null; set => throw null; }
                object System.Collections.IDictionary.this[object key] { get => throw null; set => throw null; }
                public System.Collections.Generic.ICollection<TKey> Keys { get => throw null; }
                System.Collections.ICollection System.Collections.IDictionary.Keys { get => throw null; }
                public OrderedDictionary(int capacity, System.Collections.Generic.IEqualityComparer<TKey> comparer) => throw null;
                public OrderedDictionary(int capacity) => throw null;
                public OrderedDictionary(System.Collections.Generic.IEqualityComparer<TKey> comparer) => throw null;
                public OrderedDictionary() => throw null;
                void System.Collections.IDictionary.Remove(object key) => throw null;
                public bool Remove(TKey key) => throw null;
                bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>.Remove(System.Collections.Generic.KeyValuePair<TKey, TValue> item) => throw null;
                public void RemoveAt(int index) => throw null;
                object System.Collections.ICollection.SyncRoot { get => throw null; }
                public bool TryGetValue(TKey key, out TValue value) => throw null;
                public System.Collections.Generic.ICollection<TValue> Values { get => throw null; }
                System.Collections.ICollection System.Collections.IDictionary.Values { get => throw null; }
            }

            // Generated from `ServiceStack.Redis.Support.RedisNamespace` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public class RedisNamespace
            {
                public System.Int64 GetGeneration() => throw null;
                public string GetGenerationKey() => throw null;
                public string GetGlobalKeysKey() => throw null;
                public string GlobalCacheKey(object key) => throw null;
                public string GlobalKey(object key, int numUniquePrefixes) => throw null;
                public string GlobalLockKey(object key) => throw null;
                public const string KeyTag = default;
                public ServiceStack.Redis.Support.Locking.ILockingStrategy LockingStrategy { get => throw null; set => throw null; }
                public const string NamespaceTag = default;
                public const string NamespacesGarbageKey = default;
                public const int NumTagsForKey = default;
                public const int NumTagsForLockKey = default;
                public RedisNamespace(string name) => throw null;
                public void SetGeneration(System.Int64 generation) => throw null;
            }

            // Generated from `ServiceStack.Redis.Support.SerializedObjectWrapper` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public struct SerializedObjectWrapper
            {
                public System.ArraySegment<System.Byte> Data { get => throw null; set => throw null; }
                public System.UInt16 Flags { get => throw null; set => throw null; }
                public SerializedObjectWrapper(System.UInt16 flags, System.ArraySegment<System.Byte> data) => throw null;
                // Stub generator skipped constructor 
            }

            namespace Diagnostic
            {
                // Generated from `ServiceStack.Redis.Support.Diagnostic.InvokeEventArgs` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                public class InvokeEventArgs : System.EventArgs
                {
                    public InvokeEventArgs(System.Reflection.MethodInfo methodInfo) => throw null;
                    public System.Reflection.MethodInfo MethodInfo { get => throw null; set => throw null; }
                }

                // Generated from `ServiceStack.Redis.Support.Diagnostic.TrackingFrame` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                public class TrackingFrame : System.IEquatable<ServiceStack.Redis.Support.Diagnostic.TrackingFrame>
                {
                    public override bool Equals(object obj) => throw null;
                    public bool Equals(ServiceStack.Redis.Support.Diagnostic.TrackingFrame other) => throw null;
                    public override int GetHashCode() => throw null;
                    public System.Guid Id { get => throw null; set => throw null; }
                    public System.DateTime Initialised { get => throw null; set => throw null; }
                    public System.Type ProvidedToInstanceOfType { get => throw null; set => throw null; }
                    public TrackingFrame() => throw null;
                }

            }
            namespace Locking
            {
                // Generated from `ServiceStack.Redis.Support.Locking.DisposableDistributedLock` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                public class DisposableDistributedLock : System.IDisposable
                {
                    public DisposableDistributedLock(ServiceStack.Redis.IRedisClient client, string globalLockKey, int acquisitionTimeout, int lockTimeout) => throw null;
                    public void Dispose() => throw null;
                    public System.Int64 LockExpire { get => throw null; }
                    public System.Int64 LockState { get => throw null; }
                }

                // Generated from `ServiceStack.Redis.Support.Locking.DistributedLock` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                public class DistributedLock : ServiceStack.Redis.Support.Locking.IDistributedLockAsync, ServiceStack.Redis.Support.Locking.IDistributedLock
                {
                    public ServiceStack.Redis.Support.Locking.IDistributedLockAsync AsAsync() => throw null;
                    public DistributedLock() => throw null;
                    public const int LOCK_ACQUIRED = default;
                    public const int LOCK_NOT_ACQUIRED = default;
                    public const int LOCK_RECOVERED = default;
                    public virtual System.Int64 Lock(string key, int acquisitionTimeout, int lockTimeout, out System.Int64 lockExpire, ServiceStack.Redis.IRedisClient client) => throw null;
                    System.Threading.Tasks.ValueTask<ServiceStack.Redis.Support.Locking.LockState> ServiceStack.Redis.Support.Locking.IDistributedLockAsync.LockAsync(string key, int acquisitionTimeout, int lockTimeout, ServiceStack.Redis.IRedisClientAsync client, System.Threading.CancellationToken token) => throw null;
                    public virtual bool Unlock(string key, System.Int64 lockExpire, ServiceStack.Redis.IRedisClient client) => throw null;
                    System.Threading.Tasks.ValueTask<bool> ServiceStack.Redis.Support.Locking.IDistributedLockAsync.UnlockAsync(string key, System.Int64 lockExpire, ServiceStack.Redis.IRedisClientAsync client, System.Threading.CancellationToken token) => throw null;
                }

                // Generated from `ServiceStack.Redis.Support.Locking.IDistributedLock` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                public interface IDistributedLock
                {
                    System.Int64 Lock(string key, int acquisitionTimeout, int lockTimeout, out System.Int64 lockExpire, ServiceStack.Redis.IRedisClient client);
                    bool Unlock(string key, System.Int64 lockExpire, ServiceStack.Redis.IRedisClient client);
                }

                // Generated from `ServiceStack.Redis.Support.Locking.IDistributedLockAsync` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                public interface IDistributedLockAsync
                {
                    System.Threading.Tasks.ValueTask<ServiceStack.Redis.Support.Locking.LockState> LockAsync(string key, int acquisitionTimeout, int lockTimeout, ServiceStack.Redis.IRedisClientAsync client, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                    System.Threading.Tasks.ValueTask<bool> UnlockAsync(string key, System.Int64 lockExpire, ServiceStack.Redis.IRedisClientAsync client, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                }

                // Generated from `ServiceStack.Redis.Support.Locking.ILockingStrategy` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                public interface ILockingStrategy
                {
                    System.IDisposable ReadLock();
                    System.IDisposable WriteLock();
                }

                // Generated from `ServiceStack.Redis.Support.Locking.LockState` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                public struct LockState
                {
                    public void Deconstruct(out System.Int64 result, out System.Int64 expiration) => throw null;
                    public override bool Equals(object obj) => throw null;
                    public System.Int64 Expiration { get => throw null; }
                    public override int GetHashCode() => throw null;
                    public LockState(System.Int64 result, System.Int64 expiration) => throw null;
                    // Stub generator skipped constructor 
                    public System.Int64 Result { get => throw null; }
                    public override string ToString() => throw null;
                }

                // Generated from `ServiceStack.Redis.Support.Locking.NoLockingStrategy` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                public class NoLockingStrategy : ServiceStack.Redis.Support.Locking.ILockingStrategy
                {
                    public NoLockingStrategy() => throw null;
                    public System.IDisposable ReadLock() => throw null;
                    public System.IDisposable WriteLock() => throw null;
                }

                // Generated from `ServiceStack.Redis.Support.Locking.ReadLock` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                public class ReadLock : System.IDisposable
                {
                    public void Dispose() => throw null;
                    public ReadLock(System.Threading.ReaderWriterLockSlim lockObject) => throw null;
                }

                // Generated from `ServiceStack.Redis.Support.Locking.ReaderWriterLockingStrategy` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                public class ReaderWriterLockingStrategy : ServiceStack.Redis.Support.Locking.ILockingStrategy
                {
                    public System.IDisposable ReadLock() => throw null;
                    public ReaderWriterLockingStrategy() => throw null;
                    public System.IDisposable WriteLock() => throw null;
                }

                // Generated from `ServiceStack.Redis.Support.Locking.WriteLock` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                public class WriteLock : System.IDisposable
                {
                    public void Dispose() => throw null;
                    public WriteLock(System.Threading.ReaderWriterLockSlim lockObject) => throw null;
                }

            }
            namespace Queue
            {
                // Generated from `ServiceStack.Redis.Support.Queue.IChronologicalWorkQueue<>` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                public interface IChronologicalWorkQueue<T> : System.IDisposable where T : class
                {
                    System.Collections.Generic.IList<System.Collections.Generic.KeyValuePair<string, T>> Dequeue(double minTime, double maxTime, int maxBatchSize);
                    void Enqueue(string workItemId, T workItem, double time);
                }

                // Generated from `ServiceStack.Redis.Support.Queue.ISequentialData<>` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                public interface ISequentialData<T>
                {
                    string DequeueId { get; }
                    System.Collections.Generic.IList<T> DequeueItems { get; }
                    void DoneProcessedWorkItem();
                    void PopAndUnlock();
                    void UpdateNextUnprocessed(T newWorkItem);
                }

                // Generated from `ServiceStack.Redis.Support.Queue.ISequentialWorkQueue<>` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                public interface ISequentialWorkQueue<T> : System.IDisposable where T : class
                {
                    ServiceStack.Redis.Support.Queue.ISequentialData<T> Dequeue(int maxBatchSize);
                    void Enqueue(string workItemId, T workItem);
                    bool HarvestZombies();
                    bool PrepareNextWorkItem();
                    void Update(string workItemId, int index, T newWorkItem);
                }

                // Generated from `ServiceStack.Redis.Support.Queue.ISimpleWorkQueue<>` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                public interface ISimpleWorkQueue<T> : System.IDisposable where T : class
                {
                    System.Collections.Generic.IList<T> Dequeue(int maxBatchSize);
                    void Enqueue(T workItem);
                }

                namespace Implementation
                {
                    // Generated from `ServiceStack.Redis.Support.Queue.Implementation.RedisChronologicalWorkQueue<>` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                    public class RedisChronologicalWorkQueue<T> : ServiceStack.Redis.Support.Queue.Implementation.RedisWorkQueue<T>, System.IDisposable, ServiceStack.Redis.Support.Queue.IChronologicalWorkQueue<T> where T : class
                    {
                        public System.Collections.Generic.IList<System.Collections.Generic.KeyValuePair<string, T>> Dequeue(double minTime, double maxTime, int maxBatchSize) => throw null;
                        public void Enqueue(string workItemId, T workItem, double time) => throw null;
                        public RedisChronologicalWorkQueue(int maxReadPoolSize, int maxWritePoolSize, string host, int port, string queueName) : base(default(int), default(int), default(string), default(int)) => throw null;
                        public RedisChronologicalWorkQueue(int maxReadPoolSize, int maxWritePoolSize, string host, int port) : base(default(int), default(int), default(string), default(int)) => throw null;
                    }

                    // Generated from `ServiceStack.Redis.Support.Queue.Implementation.RedisSequentialWorkQueue<>` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                    public class RedisSequentialWorkQueue<T> : ServiceStack.Redis.Support.Queue.Implementation.RedisWorkQueue<T>, System.IDisposable, ServiceStack.Redis.Support.Queue.ISequentialWorkQueue<T> where T : class
                    {
                        protected const double CONVENIENTLY_SIZED_FLOAT = default;
                        public ServiceStack.Redis.Support.Queue.ISequentialData<T> Dequeue(int maxBatchSize) => throw null;
                        // Generated from `ServiceStack.Redis.Support.Queue.Implementation.RedisSequentialWorkQueue<>+DequeueManager` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                        public class DequeueManager
                        {
                            public DequeueManager(ServiceStack.Redis.PooledRedisClientManager clientManager, ServiceStack.Redis.Support.Queue.Implementation.RedisSequentialWorkQueue<T> workQueue, string workItemId, string dequeueLockKey, int numberOfDequeuedItems, int dequeueLockTimeout) => throw null;
                            public void DoneProcessedWorkItem() => throw null;
                            public System.Int64 Lock(int acquisitionTimeout, ServiceStack.Redis.IRedisClient client) => throw null;
                            public bool PopAndUnlock(int numProcessed, ServiceStack.Redis.IRedisClient client) => throw null;
                            public bool PopAndUnlock(int numProcessed) => throw null;
                            public bool Unlock(ServiceStack.Redis.IRedisClient client) => throw null;
                            public void UpdateNextUnprocessed(T newWorkItem) => throw null;
                            protected ServiceStack.Redis.PooledRedisClientManager clientManager;
                            protected int numberOfDequeuedItems;
                            protected int numberOfProcessedItems;
                            protected string workItemId;
                            protected ServiceStack.Redis.Support.Queue.Implementation.RedisSequentialWorkQueue<T> workQueue;
                        }


                        public void Enqueue(string workItemId, T workItem) => throw null;
                        public bool HarvestZombies() => throw null;
                        public bool PrepareNextWorkItem() => throw null;
                        public RedisSequentialWorkQueue(int maxReadPoolSize, int maxWritePoolSize, string host, int port, string queueName, int dequeueLockTimeout) : base(default(int), default(int), default(string), default(int)) => throw null;
                        public RedisSequentialWorkQueue(int maxReadPoolSize, int maxWritePoolSize, string host, int port, int dequeueLockTimeout) : base(default(int), default(int), default(string), default(int)) => throw null;
                        public bool TryForceReleaseLock(ServiceStack.Redis.Support.Queue.Implementation.SerializingRedisClient client, string workItemId) => throw null;
                        public void Update(string workItemId, int index, T newWorkItem) => throw null;
                    }

                    // Generated from `ServiceStack.Redis.Support.Queue.Implementation.RedisSimpleWorkQueue<>` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                    public class RedisSimpleWorkQueue<T> : ServiceStack.Redis.Support.Queue.Implementation.RedisWorkQueue<T>, System.IDisposable, ServiceStack.Redis.Support.Queue.ISimpleWorkQueue<T> where T : class
                    {
                        public System.Collections.Generic.IList<T> Dequeue(int maxBatchSize) => throw null;
                        public void Enqueue(T msg) => throw null;
                        public RedisSimpleWorkQueue(int maxReadPoolSize, int maxWritePoolSize, string host, int port, string queueName) : base(default(int), default(int), default(string), default(int)) => throw null;
                        public RedisSimpleWorkQueue(int maxReadPoolSize, int maxWritePoolSize, string host, int port) : base(default(int), default(int), default(string), default(int)) => throw null;
                    }

                    // Generated from `ServiceStack.Redis.Support.Queue.Implementation.RedisWorkQueue<>` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                    public class RedisWorkQueue<T>
                    {
                        public void Dispose() => throw null;
                        public RedisWorkQueue(int maxReadPoolSize, int maxWritePoolSize, string host, int port, string queueName) => throw null;
                        public RedisWorkQueue(int maxReadPoolSize, int maxWritePoolSize, string host, int port) => throw null;
                        protected ServiceStack.Redis.PooledRedisClientManager clientManager;
                        protected string pendingWorkItemIdQueue;
                        protected ServiceStack.Redis.Support.RedisNamespace queueNamespace;
                        protected string workQueue;
                    }

                    // Generated from `ServiceStack.Redis.Support.Queue.Implementation.SequentialData<>` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                    public class SequentialData<T> : ServiceStack.Redis.Support.Queue.ISequentialData<T> where T : class
                    {
                        public string DequeueId { get => throw null; }
                        public System.Collections.Generic.IList<T> DequeueItems { get => throw null; }
                        public void DoneProcessedWorkItem() => throw null;
                        public void PopAndUnlock() => throw null;
                        public SequentialData(string dequeueId, System.Collections.Generic.IList<T> _dequeueItems, ServiceStack.Redis.Support.Queue.Implementation.RedisSequentialWorkQueue<T>.DequeueManager _dequeueManager) => throw null;
                        public void UpdateNextUnprocessed(T newWorkItem) => throw null;
                    }

                    // Generated from `ServiceStack.Redis.Support.Queue.Implementation.SerializingRedisClient` in `ServiceStack.Redis, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                    public class SerializingRedisClient : ServiceStack.Redis.RedisClient
                    {
                        public object Deserialize(System.Byte[] someBytes) => throw null;
                        public System.Collections.IList Deserialize(System.Byte[][] byteArray) => throw null;
                        public System.Collections.Generic.List<System.Byte[]> Serialize(object[] values) => throw null;
                        public System.Byte[] Serialize(object value) => throw null;
                        public ServiceStack.Redis.Support.ISerializer Serializer { set => throw null; }
                        public SerializingRedisClient(string host, int port) => throw null;
                        public SerializingRedisClient(string host) => throw null;
                        public SerializingRedisClient(ServiceStack.Redis.RedisEndpoint config) => throw null;
                    }

                }
            }
        }
    }
}
