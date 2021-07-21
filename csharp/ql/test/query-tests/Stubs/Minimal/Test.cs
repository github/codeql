using System;
using System.IO;
using System.Text;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Runtime.Serialization;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;

public class RegexHandler
{
    private static readonly string JAVA_CLASS_REGEX = "^(([a-z])+.)+[A-Z]([a-z])+$";

    public void ProcessRequest()
    {
        string userInput = "";

        // BAD:
        // Artificial regexes
        new Regex("^([a-z]+)+$").Match(userInput);
        new Regex("^([a-z]*)*$").Replace(userInput, "");
        // Known exponential blowup regex for e-mail address validation
        // Problematic part is: ([a-zA-Z0-9]+))*
        new Regex("^([a-zA-Z0-9])(([\\-.]|[_]+)?([a-zA-Z0-9]+))*(@){1}[a-z0-9]+[.]{1}(([a-z]{2,3})|([a-z]{2,3}[.]{1}[a-z]{2,3}))$").Match(userInput);
        // Known exponential blowup regex for Java class name validation
        // Problematic part is: (([a-z])+.)+
        new Regex(JAVA_CLASS_REGEX).Match(userInput);
        // Static use
        Regex.Match(userInput, JAVA_CLASS_REGEX);
        // GOOD:
        new Regex("^(([a-b]+[c-z]+)+$").Match(userInput);
        new Regex("^([a-z]+)+$", RegexOptions.IgnoreCase, TimeSpan.FromSeconds(1)).Match(userInput);
        Regex.Match(userInput, JAVA_CLASS_REGEX, RegexOptions.IgnoreCase, TimeSpan.FromSeconds(1));
        // Known possible FP.
        new Regex("^[a-z0-9]+([_.-][a-z0-9]+)*$").Match(userInput);
    }
}

// The only purpose of this class is to make sure the extractor extracts the
// relevant library methods
public class LibraryTypeDataFlow
{
    void M()
    {
        int i;
        int.Parse("");
        int.TryParse("", out i);

        bool b;
        bool.Parse("");
        bool.TryParse("", out b);

        Uri uri = null;
        uri.ToString();

        StringReader sr = new StringReader("");

        string s = new string(new[] { 'a' });
        string.Join("", "", "", "");

        StringBuilder sb = new StringBuilder("");

        Lazy<int> l = new Lazy<int>(() => 42);

        IEnumerable ie = null;
        ie.GetEnumerator();
        ie.AsParallel();
        ie.AsQueryable();
        IEnumerable<int> ieint = null;
        ieint.Select(x => x);
        List<int> list = null;
        list.Find(x => x > 0);
        Stack<int> stack = null;
        stack.Peek();
        ArrayList al = null;
        ArrayList.FixedSize(al);
        SortedList sl = null;
        sl.GetByIndex(0);

        Convert.ToInt32("0");

        DataContract dc = null;
        s = dc.AString;

        KeyValuePair<int, string> kvp = new KeyValuePair<int, string>(0, "");

        IEnumerator ienum = null;
        object o = ienum.Current;

        IEnumerator<int> ienumint = null;
        i = ienumint.Current;

        var task = new Task(() => { });
        Task.WhenAll<int>(null, null);
        Task.WhenAny<int>(null, null);
        Task.Factory.ContinueWhenAll((Task[])null, (Func<Task[], int>)null);

        var task2 = new Task<int>(() => 42);
        Task<string>.Factory.ContinueWhenAny<int>(new Task<int>[] { task2 }, t => t.Result.ToString());

        Encoding.Unicode.GetString(Encoding.Unicode.GetBytes(""));

        Path.Combine("", "");
        Path.GetDirectoryName("");
        Path.GetExtension("");
        Path.GetFileName("");
        Path.GetFileNameWithoutExtension("");
        Path.GetPathRoot("");
        HttpContextBase context = null;
        string name = context.Request.QueryString["name"];
    }

    [DataContract]
    public class DataContract
    {
        [DataMember]
        public string AString { get; set; }
    }
}
