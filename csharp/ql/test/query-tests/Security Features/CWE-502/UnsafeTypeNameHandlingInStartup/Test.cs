using System; 
using Microsoft.Extensions.DependencyInjection;
using Microsoft.AspNetCore.Http;
using Newtonsoft.Json;

namespace TypeHandlingSample
{

    public class Startup
    {
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddControllers().AddJsonOptions(options =>
            {
                options.SerializerSettings.TypeNameHandling = Newtonsoft.Json.TypeNameHandling.Auto; // $ Alert
            });
            services.AddControllers()
             .AddNewtonsoftJson(options =>
             {
                 options.SerializerSettings.TypeNameHandling = TypeNameHandling.Objects; // $ Alert
             });
        }
    }   

    public class Record
    {
        public int Id { get; set; }
        public string Name { get; set; }
    }

    public class SomeClass
    {
        public void DoDeserialize(HttpRequest req){
            string userInput = req.Body.ToString(); 
            Record json = JsonConvert.DeserializeObject<Record>(userInput); 
        }
    }
}
