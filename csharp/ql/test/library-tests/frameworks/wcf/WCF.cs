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

namespace Test
{
    using System.ServiceModel;
    using System.Runtime.Serialization;
    using System.Collections.Generic;

    [DataContract]
    public class SampleData
    {
        [DataMember]
        public string AString { get; set; }

        int anInt;
        [DataMember]
        public int AnInt { get { return anInt; } set { anInt = value; } }

        [DataMember]
        public List<SampleData> AList { get; set; }
    }

    [ServiceContract]
    public interface ISampleService
    {
        [OperationContract]
        void Operation(SampleData sampleData);

        void NonOperation(SampleData sampleData);
    }

    public class SampleService : ISampleService
    {
        public void Operation(SampleData sampleData) { }

        public void NonOperation(SampleData sampleData) { }

        public void NonOperation2(SampleData sampleData) { }
    }
}
