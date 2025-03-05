namespace VulnerableBlazorApp.Components
{
    using System.Collections.Generic;
    using Microsoft.AspNetCore.Components;

    [RouteAttribute("/names/{name?}")]
    public partial class NameList : Microsoft.AspNetCore.Components.ComponentBase
    {
        protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder)
        {
            if (Names is not null)
            {
                builder.OpenElement(0, "div");
                builder.OpenElement(1, "ul");
                foreach (var name in Names)
                {
                    builder.OpenElement(2, "li");
                    builder.OpenComponent<VulnerableBlazorApp.Components.Name>(3);
                    builder.AddComponentParameter(4, nameof(VulnerableBlazorApp.Components.Name.TheName), name);
                    builder.CloseComponent();
                    builder.CloseElement();
                }
                builder.CloseElement();
                builder.CloseElement();
            }

            builder.OpenElement(5, "div");
            builder.OpenElement(6, "p");
            builder.AddContent(7, "Name: ");
            builder.OpenComponent<VulnerableBlazorApp.Components.Name>(8);
            builder.AddComponentParameter(9, nameof(VulnerableBlazorApp.Components.Name.TheName), Name);
            builder.CloseComponent();
            builder.CloseElement();
        }

        [Parameter]
        public string Name { get; set; }

        protected override void OnParametersSet()
        {
            if (Name is not null)
            {
                Names.Add(Name);
            }
        }


        public List<string> Names { get; set; } = new List<string>();
    }
}