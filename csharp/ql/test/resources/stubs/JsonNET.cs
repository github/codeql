using System;
using System.Collections;
using System.Collections.Generic;

namespace Newtonsoft.Json
{
    public static class JsonConvert
    {
        public static string ToString(int x) => null;
        public static T DeserializeObject<T>(string s) => default(T);
        public static string SerializeObject(object obj) => null;
        public static void PopulateObject(string s, object obj) { }
    }

    public class JsonIgnoreAttribute : Attribute
    {
    }

    public class JsonRequiredAttribute : Attribute
    {
    }

    public class JsonLoadSettings { }

    public enum MemberSerialization { OptOut, OptIn, Fields }

    public class JsonObjectAttribute : Attribute
    {
      public JsonObjectAttribute() { }
      public JsonObjectAttribute(MemberSerialization ms) { }
    }
}

namespace Newtonsoft.Json.Linq
{
    public class JToken : IEnumerable<JToken>, IEnumerable
    {
        public virtual JToken this[object key] => null;
        public virtual JToken this[string key] => null;

        public IEnumerator<JToken> GetEnumerator() => null;
        IEnumerator IEnumerable.GetEnumerator() => null;

        public static explicit operator string(JToken t) => null;

        public IEnumerable<JToken> SelectToken(string s) => null;
    }

    public class JObject : JToken
    {
        public static JObject Parse(string str) => null;
        public static JObject Parse(string str, JsonLoadSettings settings) => null;
        public JToken this[object key] => null;
        public JToken this[string key] => null;
    }
}
