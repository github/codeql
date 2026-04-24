using System;
using System.Web;
using System.Text;
using System.Collections.Generic;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using System.Threading.Tasks;

namespace TypeHandlingSample
{
    public class BadBinder : ISerializationBinder
    {
        public void BindToName(Type serializedType, out string assemblyName, out string typeName)
        {
            assemblyName = serializedType.Assembly.FullName;
            typeName = serializedType.Name;
        }

        public Type BindToType(string assemblyName, string typeName) // $ Alert
        {
            return Type.GetType(typeName);
        }
    }

    public class OkayBinder : DefaultSerializationBinder
    {
        public List<string> okayTypes;
        public override Type BindToType(string? assemblyName, string typeName) // $ Alert
        {
            if (okayTypes.Contains(typeName))
            {
                return Type.GetType(typeName);

            }
            else
            {
                throw new Exception("unexpected type");
            }
        }
    }

    public class OkayBinder2 : ISerializationBinder
    {
        private readonly ISerializationBinder innerBinder;

        public void BindToName(Type serializedType, out string? assemblyName, out string? typeName)
        {
            this.innerBinder.BindToName(serializedType, out assemblyName, out typeName);
        }
        public Type BindToType(string? assemblyName, string typeName) // $ Alert
        {
            return this.innerBinder.BindToType(assemblyName, typeName);
        }
    }

    public class Test
    {
        public JsonSerializerSettings SettingsBad { get; }

        public JsonSerializerSettings SettingsOkay { get; }

        public JsonSerializerSettings SettingsOkay2 { get; }

        public BadBinder badBinder { get; }

        public OkayBinder okayBinder { get; }

        public OkayBinder2 okayBinder2 { get; }
        public Test()
        {
            //Bad, custom binder that does not check type
            SettingsBad = new JsonSerializerSettings()
            {
                SerializationBinder = badBinder,
                TypeNameHandling = TypeNameHandling.All
            };

            //OKAY, custom binder that checks type
            SettingsOkay = new JsonSerializerSettings()
            {
                SerializationBinder = okayBinder,
                TypeNameHandling = TypeNameHandling.All
            };

             //OKAY, custom binder that returns BindToType() from a member binder
            SettingsOkay2 = new JsonSerializerSettings()
            {
                SerializationBinder = okayBinder2,
                TypeNameHandling = TypeNameHandling.All
            };
        }
    }

}