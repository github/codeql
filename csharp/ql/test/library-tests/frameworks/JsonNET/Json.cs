using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Collections.Generic;
using System.Linq;

namespace JsonTest
{
    class Dataflow
    {
        void Sink(object o)
        {
        }

        void F()
        {
            string t = "tainted";
            string u = "untainted";

            Sink(JsonConvert.ToString(int.Parse(t)));

            var taintedObject = JsonConvert.DeserializeObject<Object>(t);
            Sink(taintedObject);
            Sink(taintedObject.tainted);
            Sink(taintedObject.untainted);
            Sink(JsonConvert.SerializeObject(taintedObject));
            Sink(taintedObject.taintedValues["1"]);
            Sink(taintedObject.taintedArray[0]);

            var taintedObject2 = JsonConvert.DeserializeObject<Object2>(t);
            Sink(taintedObject2.tainted);
            Sink(taintedObject2.untainted);

            Object taintedPopulatedObject = new Object();
            JsonConvert.PopulateObject(t, taintedPopulatedObject);
            Sink(taintedPopulatedObject.tainted);

            Object untaintedObject = JsonConvert.DeserializeObject<Object>(u);
            Sink(untaintedObject);

            // JObject tests
            var jobject = JObject.Parse(t);
            Sink(jobject);
            Sink(jobject["1"]);
            Sink(jobject["1"]["2"]);
            Sink((string)jobject["1"]["2"]);
            Sink(jobject.ToString());

            // Linq JToken tests
            Sink(jobject.First((JToken i) => true));
            Sink(jobject["2"].First(i => true));
            Sink(jobject["2"]["3"].First(i => true));
            Sink(jobject.SelectToken("Manufacturers[0].Name"));

            JObject untaintedJObject = JObject.Parse(u);
            Sink(untaintedJObject);
            Sink(untaintedJObject.First((JToken i) => true));
        }

        public class Object
        {
            public int tainted;

            [JsonIgnore]
            public int untainted;

            public Dictionary<string, string> taintedValues;

            public string[] taintedArray;
        }

        [JsonObject(MemberSerialization.OptIn)]
        public class Object2
        {
            public int untainted;

            [JsonRequired]
            public int tainted;
        }
    }
}
