using System.IO;
using System.Web.Script.Serialization;

namespace DeserializersDotNet
{
    class JavascriptSerializer
    {

        public static object Deserialize(string text)
        {
            // GOOD - no resolver
            JavaScriptSerializer sr = new JavaScriptSerializer();
            return sr.DeserializeObject(text);
        }

        public static void Main()
        {
            var text = File.ReadAllText(@"\\testpath\testdir\file.txt");
            Deserialize(text);
         }
    }
}