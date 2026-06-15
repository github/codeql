namespace VulnerableBlazorApp.Components
{
    using Microsoft.AspNetCore.Components;

    public partial class Name : Microsoft.AspNetCore.Components.ComponentBase
    {
        protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder)
        {
            if (TheName is not null)
            {
                builder.OpenElement(0, "div");
                builder.OpenElement(1, "p");
                builder.AddContent(2, (MarkupString)TheName);
                builder.CloseElement();
                builder.CloseElement();
            }
        }

        [Parameter]
        public string TheName { get; set; }
    }
}