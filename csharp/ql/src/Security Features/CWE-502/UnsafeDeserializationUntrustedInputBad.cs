using System.IO;
using System.Web.Script.Serialization;

namespace DeserializersDotNet
{
    class JavascriptSerializer
    {
        public static object DeserializeWithTypeResolver(string text)
        {
            // BAD: use of JavaScriptSerializer with custom type resolver
            JavaScriptSerializer sr = new JavaScriptSerializer(new SimpleTypeResolver());
            return sr.DeserializeObject(text);
        }

        public static void Main()
        {
            var text = File.ReadAllText(@"\\testpath\testdir\file.txt");
            DeserializeWithTypeResolver(text);
        }

    }
}
