using System;
using System.Collections.Specialized;

namespace System.ServiceModel
{
    public sealed class ServiceContractAttribute : Attribute { }
    public sealed class OperationContractAttribute : Attribute { }
}

namespace RemoteFlowSource
{
    using System.ServiceModel;
    using System.Runtime.Serialization;
    using System.Collections.Generic;

    [DataContract]
    public class SampleData { }

    [ServiceContract]
    public interface ISampleService
    {
        [OperationContract]
        string Operation(SampleData sampleData, string taint);
    }

    public class RemoteFlowSource : ISampleService
    {
        public static void M(System.Web.HttpRequest request, System.Web.UI.WebControls.TextBox textBox)
        {
            Use(request);
            Use(textBox);
        }

        public string Operation(SampleData sampleData, string taint) => sampleData + taint;

        public static void Use(Object o) { }

        public static void M2(System.Net.HttpListenerRequest request)
        {
            Use(request);
        }

        public static void M2(System.Web.HttpRequestBase request)
        {
            Use(request.Unvalidated.RawUrl);
        }

        public static async void M3(System.Net.WebSockets.WebSocket webSocket)
        {
            var buffer = new byte[1024];
            var segment = new ArraySegment<byte>(buffer);
            var result = await webSocket.ReceiveAsync(segment, System.Threading.CancellationToken.None);
            Use(segment);
        }
    }
}

namespace AspRemoteFlowSource
{
    using System.Web.Services;
    using System.Collections.Generic;

    public class MySubData
    {
        public string SubDataProp { get; set; }
    }

    public class ArrayElementData
    {
        public string ArrayElementDataProp { get; set; }
    }

    public class ListElementData
    {
        public string ListElementDataProp { get; set; }
    }

    public class MyData
    {
        public string DataField;
        public string DataProp { get; set; }
        public MySubData SubData { get; set; }
        public ArrayElementData[] Elements { get; set; }
        public List<ListElementData> List;
    }

    public class MyDataElement
    {
        public string Prop { get; set; }
    }


    public class BaseData
    {
        public string BaseProp { get; set; }
    }

    public class DerivedData : BaseData { }

    public class PlainData
    {
        private string backing;
        private List<string> items = new List<string>();

        public string Backed
        {
            get { if (backing == null) backing = ""; return backing; }
            set { backing = value ?? throw new ArgumentNullException(); }
        }

        public List<string> ItemsOnlyGet => items;
        public string BackedOnlyGet => backing;
        public List<string> ItemsCopy => new List<string>(items);
        public string Computed
        {
            get { return backing + "x"; }
            set { backing = value; }
        }
        public const string Constant = "x";
        public short Number { get; set; }
    }

    public class FlowProps
    {
        private string f;
        public string Discard { get { return ""; } set { } } // Not considered tainted. Ignores the value.
        public string Coalesce { get { return f ?? ""; } set { f = value; } } // Considered tainted.
        public string Cast { get { return f; } set { f = (string)(object)value; } } // Considered tainted.
        public string Ignore { get { return f; } set { f = "x"; } } // Not considered tainted. Setter ignores the value.
    }

    public class MyService
    {
        [WebMethod]
        public void MyMethod3(PlainData plain, DerivedData derived, FlowProps fp) { }

        [WebMethod]
        public void MyMethod(MyData data)
        {
            Use(data.DataProp);
            Use(data.SubData.SubDataProp);
            Use(data.Elements[0].ArrayElementDataProp);
            Use(data.List[0].ListElementDataProp);
        }

        [WebMethod]
        public void MyMethod2(MyDataElement[] data)
        {
            Use(data[0].Prop);
        }

        public static void Use(object o) { }
    }
}
