using System;
using Microsoft.AspNetCore.Http;
using Newtonsoft.Json;

namespace TypeHandlingSample
{
    public class Record
    {
        public int Id { get; set; }
        public string Name { get; set; }
    }
    public class Class1
    {
        public void SetDefaultSettings(){
            var settings = new JsonSerializerSettings
            {
                TypeNameHandling = TypeNameHandling.Objects
            }; // $ Alert

            JsonConvert.DefaultSettings = () => settings;
        }

        public void SetDefaultSettings2()
        {
            JsonConvert.DefaultSettings = () => new JsonSerializerSettings
            {
                TypeNameHandling = TypeNameHandling.Objects
            }; // $ Alert
        }
    }

    public class Class2
    {
        public void DeserializeUserInput(HttpRequest req){
            string untrustedInput = req.Body.ToString();
            var deserializedRecord = JsonConvert.DeserializeObject<Record>(untrustedInput);
        }
    }   
}
