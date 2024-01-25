// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Components.Authorization, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Components
        {
            namespace Authorization
            {
                public class AuthenticationState
                {
                    public AuthenticationState(System.Security.Claims.ClaimsPrincipal user) => throw null;
                    public System.Security.Claims.ClaimsPrincipal User { get => throw null; }
                }
                public delegate void AuthenticationStateChangedHandler(System.Threading.Tasks.Task<Microsoft.AspNetCore.Components.Authorization.AuthenticationState> task);
                public abstract class AuthenticationStateProvider
                {
                    public event Microsoft.AspNetCore.Components.Authorization.AuthenticationStateChangedHandler AuthenticationStateChanged;
                    protected AuthenticationStateProvider() => throw null;
                    public abstract System.Threading.Tasks.Task<Microsoft.AspNetCore.Components.Authorization.AuthenticationState> GetAuthenticationStateAsync();
                    protected void NotifyAuthenticationStateChanged(System.Threading.Tasks.Task<Microsoft.AspNetCore.Components.Authorization.AuthenticationState> task) => throw null;
                }
                public sealed class AuthorizeRouteView : Microsoft.AspNetCore.Components.RouteView
                {
                    public Microsoft.AspNetCore.Components.RenderFragment Authorizing { get => throw null; set { } }
                    public AuthorizeRouteView() => throw null;
                    public Microsoft.AspNetCore.Components.RenderFragment<Microsoft.AspNetCore.Components.Authorization.AuthenticationState> NotAuthorized { get => throw null; set { } }
                    protected override void Render(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public object Resource { get => throw null; set { } }
                }
                public class AuthorizeView : Microsoft.AspNetCore.Components.Authorization.AuthorizeViewCore
                {
                    public AuthorizeView() => throw null;
                    protected override Microsoft.AspNetCore.Authorization.IAuthorizeData[] GetAuthorizeData() => throw null;
                    public string Policy { get => throw null; set { } }
                    public string Roles { get => throw null; set { } }
                }
                public abstract class AuthorizeViewCore : Microsoft.AspNetCore.Components.ComponentBase
                {
                    public Microsoft.AspNetCore.Components.RenderFragment<Microsoft.AspNetCore.Components.Authorization.AuthenticationState> Authorized { get => throw null; set { } }
                    public Microsoft.AspNetCore.Components.RenderFragment Authorizing { get => throw null; set { } }
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public Microsoft.AspNetCore.Components.RenderFragment<Microsoft.AspNetCore.Components.Authorization.AuthenticationState> ChildContent { get => throw null; set { } }
                    protected AuthorizeViewCore() => throw null;
                    protected abstract Microsoft.AspNetCore.Authorization.IAuthorizeData[] GetAuthorizeData();
                    public Microsoft.AspNetCore.Components.RenderFragment<Microsoft.AspNetCore.Components.Authorization.AuthenticationState> NotAuthorized { get => throw null; set { } }
                    protected override System.Threading.Tasks.Task OnParametersSetAsync() => throw null;
                    public object Resource { get => throw null; set { } }
                }
                public class CascadingAuthenticationState : Microsoft.AspNetCore.Components.ComponentBase, System.IDisposable
                {
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder __builder) => throw null;
                    public Microsoft.AspNetCore.Components.RenderFragment ChildContent { get => throw null; set { } }
                    public CascadingAuthenticationState() => throw null;
                    void System.IDisposable.Dispose() => throw null;
                    protected override void OnInitialized() => throw null;
                }
                public interface IHostEnvironmentAuthenticationStateProvider
                {
                    void SetAuthenticationState(System.Threading.Tasks.Task<Microsoft.AspNetCore.Components.Authorization.AuthenticationState> authenticationStateTask);
                }
            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class CascadingAuthenticationStateServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddCascadingAuthenticationState(this Microsoft.Extensions.DependencyInjection.IServiceCollection serviceCollection) => throw null;
            }
        }
    }
}
