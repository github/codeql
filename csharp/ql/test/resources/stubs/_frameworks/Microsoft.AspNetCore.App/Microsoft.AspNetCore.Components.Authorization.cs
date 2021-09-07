// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Components
        {
            namespace Authorization
            {
                // Generated from `Microsoft.AspNetCore.Components.Authorization.AuthenticationState` in `Microsoft.AspNetCore.Components.Authorization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class AuthenticationState
                {
                    public AuthenticationState(System.Security.Claims.ClaimsPrincipal user) => throw null;
                    public System.Security.Claims.ClaimsPrincipal User { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Components.Authorization.AuthenticationStateChangedHandler` in `Microsoft.AspNetCore.Components.Authorization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public delegate void AuthenticationStateChangedHandler(System.Threading.Tasks.Task<Microsoft.AspNetCore.Components.Authorization.AuthenticationState> task);

                // Generated from `Microsoft.AspNetCore.Components.Authorization.AuthenticationStateProvider` in `Microsoft.AspNetCore.Components.Authorization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class AuthenticationStateProvider
                {
                    public event Microsoft.AspNetCore.Components.Authorization.AuthenticationStateChangedHandler AuthenticationStateChanged;
                    protected AuthenticationStateProvider() => throw null;
                    public abstract System.Threading.Tasks.Task<Microsoft.AspNetCore.Components.Authorization.AuthenticationState> GetAuthenticationStateAsync();
                    protected void NotifyAuthenticationStateChanged(System.Threading.Tasks.Task<Microsoft.AspNetCore.Components.Authorization.AuthenticationState> task) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Components.Authorization.AuthorizeRouteView` in `Microsoft.AspNetCore.Components.Authorization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class AuthorizeRouteView : Microsoft.AspNetCore.Components.RouteView
                {
                    public AuthorizeRouteView() => throw null;
                    public Microsoft.AspNetCore.Components.RenderFragment Authorizing { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Components.RenderFragment<Microsoft.AspNetCore.Components.Authorization.AuthenticationState> NotAuthorized { get => throw null; set => throw null; }
                    protected override void Render(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public object Resource { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Components.Authorization.AuthorizeView` in `Microsoft.AspNetCore.Components.Authorization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class AuthorizeView : Microsoft.AspNetCore.Components.Authorization.AuthorizeViewCore
                {
                    public AuthorizeView() => throw null;
                    protected override Microsoft.AspNetCore.Authorization.IAuthorizeData[] GetAuthorizeData() => throw null;
                    public string Policy { get => throw null; set => throw null; }
                    public string Roles { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Components.Authorization.AuthorizeViewCore` in `Microsoft.AspNetCore.Components.Authorization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class AuthorizeViewCore : Microsoft.AspNetCore.Components.ComponentBase
                {
                    protected AuthorizeViewCore() => throw null;
                    public Microsoft.AspNetCore.Components.RenderFragment<Microsoft.AspNetCore.Components.Authorization.AuthenticationState> Authorized { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Components.RenderFragment Authorizing { get => throw null; set => throw null; }
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public Microsoft.AspNetCore.Components.RenderFragment<Microsoft.AspNetCore.Components.Authorization.AuthenticationState> ChildContent { get => throw null; set => throw null; }
                    protected abstract Microsoft.AspNetCore.Authorization.IAuthorizeData[] GetAuthorizeData();
                    public Microsoft.AspNetCore.Components.RenderFragment<Microsoft.AspNetCore.Components.Authorization.AuthenticationState> NotAuthorized { get => throw null; set => throw null; }
                    protected override System.Threading.Tasks.Task OnParametersSetAsync() => throw null;
                    public object Resource { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Components.Authorization.CascadingAuthenticationState` in `Microsoft.AspNetCore.Components.Authorization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class CascadingAuthenticationState : Microsoft.AspNetCore.Components.ComponentBase, System.IDisposable
                {
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder __builder) => throw null;
                    public CascadingAuthenticationState() => throw null;
                    public Microsoft.AspNetCore.Components.RenderFragment ChildContent { get => throw null; set => throw null; }
                    void System.IDisposable.Dispose() => throw null;
                    protected override void OnInitialized() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Components.Authorization.IHostEnvironmentAuthenticationStateProvider` in `Microsoft.AspNetCore.Components.Authorization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IHostEnvironmentAuthenticationStateProvider
                {
                    void SetAuthenticationState(System.Threading.Tasks.Task<Microsoft.AspNetCore.Components.Authorization.AuthenticationState> authenticationStateTask);
                }

            }
        }
    }
}
