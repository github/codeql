// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Hosting
        {
            namespace Server
            {
                // Generated from `Microsoft.AspNetCore.Hosting.Server.IHttpApplication<>` in `Microsoft.AspNetCore.Hosting.Server.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IHttpApplication<TContext>
                {
                    TContext CreateContext(Microsoft.AspNetCore.Http.Features.IFeatureCollection contextFeatures);
                    void DisposeContext(TContext context, System.Exception exception);
                    System.Threading.Tasks.Task ProcessRequestAsync(TContext context);
                }

                // Generated from `Microsoft.AspNetCore.Hosting.Server.IServer` in `Microsoft.AspNetCore.Hosting.Server.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IServer : System.IDisposable
                {
                    Microsoft.AspNetCore.Http.Features.IFeatureCollection Features { get; }
                    System.Threading.Tasks.Task StartAsync<TContext>(Microsoft.AspNetCore.Hosting.Server.IHttpApplication<TContext> application, System.Threading.CancellationToken cancellationToken);
                    System.Threading.Tasks.Task StopAsync(System.Threading.CancellationToken cancellationToken);
                }

                // Generated from `Microsoft.AspNetCore.Hosting.Server.IServerIntegratedAuth` in `Microsoft.AspNetCore.Hosting.Server.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IServerIntegratedAuth
                {
                    string AuthenticationScheme { get; }
                    bool IsEnabled { get; }
                }

                // Generated from `Microsoft.AspNetCore.Hosting.Server.ServerIntegratedAuth` in `Microsoft.AspNetCore.Hosting.Server.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ServerIntegratedAuth : Microsoft.AspNetCore.Hosting.Server.IServerIntegratedAuth
                {
                    public string AuthenticationScheme { get => throw null; set => throw null; }
                    public bool IsEnabled { get => throw null; set => throw null; }
                    public ServerIntegratedAuth() => throw null;
                }

                namespace Abstractions
                {
                    // Generated from `Microsoft.AspNetCore.Hosting.Server.Abstractions.IHostContextContainer<>` in `Microsoft.AspNetCore.Hosting.Server.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public interface IHostContextContainer<TContext>
                    {
                        TContext HostContext { get; set; }
                    }

                }
                namespace Features
                {
                    // Generated from `Microsoft.AspNetCore.Hosting.Server.Features.IServerAddressesFeature` in `Microsoft.AspNetCore.Hosting.Server.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public interface IServerAddressesFeature
                    {
                        System.Collections.Generic.ICollection<string> Addresses { get; }
                        bool PreferHostingUrls { get; set; }
                    }

                }
            }
        }
    }
}
