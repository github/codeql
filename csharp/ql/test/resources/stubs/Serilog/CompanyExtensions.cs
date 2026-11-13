// Fictional application extensions used to test the model's documented
// assumption about ordinary external business-service helpers.
using Microsoft.Extensions.DependencyInjection;

namespace Company
{
    public static class DependencyExtensions
    {
        public static IServiceCollection AddBusinessServices(this IServiceCollection services) => throw null;
        public static Microsoft.AspNetCore.Builder.WebApplicationBuilder AddCompanyDefaults(
            this Microsoft.AspNetCore.Builder.WebApplicationBuilder builder) => throw null;
    }
}
