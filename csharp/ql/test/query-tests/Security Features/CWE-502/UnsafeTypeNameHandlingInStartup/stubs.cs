using System;
using Newtonsoft.Json; 

namespace Microsoft.AspNetCore.Http{
    public class HttpRequest{
        public string Body; 
    }
}

namespace Microsoft.Extensions.DependencyInjection
{
    public interface IServiceCollection
    {
        
    }

    public interface IMvcBuilder
    {

    }

    public class MvcBuilder : IMvcBuilder
    {
    }

    public static class ServiceCollectionExtensions
    {
        public static IMvcBuilder AddControllers(this IServiceCollection services)
        {
            return new MvcBuilder();
        }
    }

    public static class MvcJsonMvcBuilderExtensions
    {
        public static IMvcBuilder AddJsonOptions(this IMvcBuilder builder, Action<JsonOptions> setupAction)
        {
            setupAction?.Invoke(new JsonOptions());
            return builder;
        }
    }

    public static class NewtonsoftJsonMvcBuilderExtensions
    {
        public static IMvcBuilder AddNewtonsoftJson(this IMvcBuilder builder, Action<NewtonsoftJsonOptions> setupAction)
        {
            setupAction?.Invoke(new NewtonsoftJsonOptions());
            return builder;
        }
    }

    public class JsonOptions
    {
        public JsonSerializerSettings SerializerSettings { get; set; } = new JsonSerializerSettings();
    }

    public class NewtonsoftJsonOptions
    {
        public JsonSerializerSettings SerializerSettings { get; set; } = new JsonSerializerSettings();
    }
}
