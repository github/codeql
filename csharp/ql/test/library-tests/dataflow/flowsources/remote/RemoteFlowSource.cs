using System;
using System.Collections.Specialized;

namespace System.ServiceModel
{
    public sealed class ServiceContractAttribute : Attribute { }
    public sealed class OperationContractAttribute : Attribute { }
}

namespace System.Runtime.Serialization
{
    public sealed class DataContractAttribute : Attribute { }
    public sealed class DataMemberAttribute : Attribute { }
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
    }
}
