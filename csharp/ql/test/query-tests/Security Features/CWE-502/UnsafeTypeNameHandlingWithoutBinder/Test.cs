using System; 
using System.Collections; 
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using Microsoft.AspNetCore.Http;

namespace TypeHandlingSample
{
    public class Student{
        public string Name {get; set;}
        public int ID {get; set;}
        public object someObject{get; set;}
    }

    public class CustomSerializationBinder : DefaultSerializationBinder
    {
        public override Type BindToType(string assemblyName, string typeName)
        {
            return base.BindToType(assemblyName, typeName);
        }
    }

    public class Test
    {
        JsonSerializerSettings SettingsOkay11 = new JsonSerializerSettings()
        {
            TypeNameHandling = TypeNameHandling.Auto,
            SerializationBinder = new CustomSerializationBinder()
        };

        public Test(HttpRequest req, ISerializationBinder someBinder)
        {
            JsonSerializerSettings SettingsBad1 = new JsonSerializerSettings();
            //BAD
            SettingsBad1.TypeNameHandling = TypeNameHandling.All; 

            //BAD
            JsonSerializerSettings SettingsBad2 = new JsonSerializerSettings()
            {
                TypeNameHandling = TypeNameHandling.All
            };

            //OKAY, set custom binder in initializer
            JsonSerializerSettings SettingsOkay = new JsonSerializerSettings()
            {
                SerializationBinder = someBinder,
                TypeNameHandling = TypeNameHandling.All
            };

            //OKAY, set custom binder in initializer
            JsonSerializerSettings SettingsOkay1 = new JsonSerializerSettings()
            {
                TypeNameHandling = TypeNameHandling.All,
                SerializationBinder = someBinder,
            };

            JsonSerializerSettings SettingsOkay2 = new JsonSerializerSettings();
            SettingsOkay2.SerializationBinder = someBinder;
            // OKAY, because SerializationBinder set to custom ISerializationBinder before typenamehandling set
            SettingsOkay2.TypeNameHandling = TypeNameHandling.All; 


            //OKAY, SerializationBinder set to custom binder
            JsonSerializerSettings SettingsOkay3 = new JsonSerializerSettings{
                TypeNameHandling = TypeNameHandling.All,
                SerializationBinder = someBinder
            };

            JsonSerializerSettings SettingsOkay4= new JsonSerializerSettings{
                SerializationBinder = someBinder
            }; 
            SettingsOkay4.TypeNameHandling = TypeNameHandling.All;

            //OKAY, SerializationBinder set to custom binder
            JsonSerializerSettings SettingsOkay5 = new JsonSerializerSettings();
            SettingsOkay5.SerializationBinder = someBinder;
            SettingsOkay5.TypeNameHandling = TypeNameHandling.All;

            //OKAY, SerializationBinder set to custom binder in initializer
            JsonSerializerSettings SettingsOkay6 = new JsonSerializerSettings{
                SerializationBinder = someBinder
            };
            SettingsOkay6.TypeNameHandling = TypeNameHandling.All;
            
            //OKAY, default constructor safe by default
            JsonSerializerSettings SettingsOkay7 = new JsonSerializerSettings();

            //OKAY, TypeNameHandling set to None
            JsonSerializerSettings SettingsOkay8 = new JsonSerializerSettings()
            {
                TypeNameHandling = TypeNameHandling.None
            };

            //OKAY, SerializationBinder set to custom binder in in following line
            JsonSerializerSettings SettingsOkay9 = new JsonSerializerSettings{
                TypeNameHandling = TypeNameHandling.All
            };
            SettingsOkay9.SerializationBinder = someBinder;

            var badValue = TypeNameHandling.Objects;

            //BAD, TypeNameHandling set to All
            JsonSerializerSettings SettingsBad3 = new JsonSerializerSettings()
            {
                TypeNameHandling = badValue
            };

            var goodValue = TypeNameHandling.None;

            //OKAY, TypeNameHandling set to None
            JsonSerializerSettings SettingsOkay10 = new JsonSerializerSettings()
            {
                TypeNameHandling = goodValue
            };

            string userInput = req.Body.ToString(); // $ Source

            var deserializedBad1 = JsonConvert.DeserializeObject<Student>(userInput, SettingsBad1); // $ Alert
            var deserializedBad2 = JsonConvert.DeserializeObject<Student>(userInput, SettingsBad2); // $ Alert
            var deserializedBad3 = JsonConvert.DeserializeObject<Student>(userInput, SettingsBad3); // $ Alert
            
            var deserializedOkay1 = JsonConvert.DeserializeObject<Student>(userInput, SettingsOkay1);
            var deserializedOkay2 = JsonConvert.DeserializeObject<Student>(userInput, SettingsOkay2);
            var deserializedOkay3 = JsonConvert.DeserializeObject<Student>(userInput, SettingsOkay3);
            var deserializedOkay4 = JsonConvert.DeserializeObject<Student>(userInput, SettingsOkay4);
            var deserializedOkay5 = JsonConvert.DeserializeObject<Student>(userInput, SettingsOkay5);
            var deserializedOkay6 = JsonConvert.DeserializeObject<Student>(userInput, SettingsOkay6);
            var deserializedOkay7 = JsonConvert.DeserializeObject<Student>(userInput, SettingsOkay7);
            var deserializedOkay8 = JsonConvert.DeserializeObject<Student>(userInput, SettingsOkay8);
            var deserializedOkay9 = JsonConvert.DeserializeObject<Student>(userInput, SettingsOkay9);
            var deserializedOkay10 = JsonConvert.DeserializeObject<Student>(userInput, SettingsOkay10);
            var deserializedOkay11 = JsonConvert.DeserializeObject<Student>(userInput, SettingsOkay11);
            
        }

        public void NotUserInput(string input){
            JsonSerializerSettings SettingsBad = new JsonSerializerSettings();
            //BAD
            SettingsBad.TypeNameHandling = TypeNameHandling.All; 
            var deserializedOkay = JsonConvert.DeserializeObject<Student>(input, SettingsBad); //not from user input
        }
    }
}
