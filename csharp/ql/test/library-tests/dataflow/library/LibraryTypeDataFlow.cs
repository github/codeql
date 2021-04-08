// semmle-extractor-options: /r:System.Net.dll /r:System.Web.dll /r:System.Net.HttpListener.dll /r:System.Collections.Specialized.dll /r:System.Private.Uri.dll /r:System.Runtime.Extensions.dll /r:System.Linq.Parallel.dll /r:System.Collections.Concurrent.dll /r:System.Linq.Expressions.dll /r:System.Collections.dll /r:System.Linq.Queryable.dll /r:System.Linq.dll /r:System.Collections.NonGeneric.dll /r:System.ObjectModel.dll /r:System.ComponentModel.TypeConverter.dll /r:System.IO.Compression.dll /r:System.IO.Pipes.dll /r:System.Net.Primitives.dll /r:System.Net.Security.dll /r:System.Security.Cryptography.Primitives.dll /r:System.Text.RegularExpressions.dll ${testdir}/../../../resources/stubs/System.Web.cs /r:System.Runtime.Serialization.Primitives.dll
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
        list.Insert(0, 0);
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

        var dict = new Dictionary<string, int>() { { "abc", 0 } };
    }

    [DataContract]
    public class DataContract
    {
        [DataMember]
        public string AString { get; set; }
    }
}

