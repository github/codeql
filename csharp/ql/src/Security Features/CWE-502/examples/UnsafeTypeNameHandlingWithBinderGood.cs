using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TypeHandlingSample
{
    public class KnownTypesBinder : ISerializationBinder
    {
        public IList<Type> KnownTypes { get; set; }

        public Type BindToType(string assemblyName, string typeName)
        {
            return KnownTypes.SingleOrDefault(t => t.Name == typeName);
        }

        public void BindToName(Type serializedType, out string assemblyName, out string typeName)
        {
            assemblyName = null;
            typeName = serializedType.Name;
        }
    }
    public class SomeClass
    {
        public string Name { get; set; }
    }

    internal class Okay
    {
        public JsonSerializerSettings Settings { get; }
        public KnownTypesBinder Binder { get; }
        public Okay()
        {
            Settings = new JsonSerializerSettings();
            Binder = new KnownTypesBinder { KnownTypes = new List<Type> { typeof(SomeClass) } };
            Settings.SerializationBinder = Binder; 
            Settings.TypeNameHandling = TypeNameHandling.All; // Okay, because SerializationBinder set to custom ISerializationBinder
        }
    }
}
