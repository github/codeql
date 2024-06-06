// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Hosting.Server.Abstractions, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Hosting
        {
            namespace Server
            {
                namespace Abstractions
                {
                    public interface IHostContextContainer<TContext>
                    {
                        TContext HostContext { get; set; }
                    }
                }
                namespace Features
                {
                    public interface IServerAddressesFeature
                    {
                        System.Collections.Generic.ICollection<string> Addresses { get; }
                        bool PreferHostingUrls { get; set; }
                    }
                }
                public interface IHttpApplication<TContext>
                {
                    TContext CreateContext(Microsoft.AspNetCore.Http.Features.IFeatureCollection contextFeatures);
                    void DisposeContext(TContext context, System.Exception exception);
                    System.Threading.Tasks.Task ProcessRequestAsync(TContext context);
                }
                public interface IServer : System.IDisposable
                {
                    Microsoft.AspNetCore.Http.Features.IFeatureCollection Features { get; }
                    System.Threading.Tasks.Task StartAsync<TContext>(Microsoft.AspNetCore.Hosting.Server.IHttpApplication<TContext> application, System.Threading.CancellationToken cancellationToken);
                    System.Threading.Tasks.Task StopAsync(System.Threading.CancellationToken cancellationToken);
                }
                public interface IServerIntegratedAuth
                {
                    string AuthenticationScheme { get; }
                    bool IsEnabled { get; }
                }
                public class ServerIntegratedAuth : Microsoft.AspNetCore.Hosting.Server.IServerIntegratedAuth
                {
                    public string AuthenticationScheme { get => throw null; set { } }
                    public ServerIntegratedAuth() => throw null;
                    public bool IsEnabled { get => throw null; set { } }
                }
            }
        }
    }
}
