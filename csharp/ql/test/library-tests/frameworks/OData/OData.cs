using System.Collections.Generic;

namespace Microsoft.AspNet.OData
{
    public class ODataActionParameters : Dictionary<string, object>
    {
    }

    public class Delta<TStructuralType> where TStructuralType : class
    {
        private TStructuralType instance;

        public Delta() { instance = default(TStructuralType); }

        public TStructuralType GetInstance() => instance;

        public void Patch(TStructuralType original) { }

        public void Put(TStructuralType original) { }

        public void CopyChangedValues(TStructuralType original) { }

        public void CopyUnchangedValues(TStructuralType original) { }
    }
}

namespace Test
{
    using Microsoft.AspNet.OData;
    using System.Collections.Generic;

    public class FileMetadata
    {
        public string Author { get; set; }
    }

    public class UploadedFile
    {
        public string FileName { get; set; }

        public string FileContent { get; set; }

        public FileMetadata Metadata { get; set; }

        public List<FileMetadata> History { get; set; }
    }

    public class SubscriptionRelation
    {
        public string EventName { get; set; }

        public string EventType { get; set; }
    }

    public class Widget
    {
        public string Name { get; set; }
    }

    public class UnrelatedType
    {
        // Never reached via an ODataActionParameters/Delta<T> cast, so this
        // member must stay untainted even though `UnrelatedType` itself is
        // used elsewhere in the file.
        public string Name { get; set; }
    }

    public class OrderController
    {
        void Sink(object o) { }

        void CastFromDictionary(ODataActionParameters parameters)
        {
            var file = (UploadedFile)parameters["CabFile"];
            Sink(file);
            Sink(file.FileName);
            Sink(file.FileContent);
            Sink(file.Metadata.Author);
            foreach (var m in file.History)
            {
                Sink(m.Author);
            }
        }

        void IsAsFromDictionary(ODataActionParameters parameters)
        {
            if (parameters["NewEvents"] is IEnumerable<SubscriptionRelation> relations1)
            {
                foreach (var item in relations1)
                {
                    Sink(item.EventName);
                }
            }

            var relations2 = parameters["NewEvents"] as IEnumerable<SubscriptionRelation>;
            foreach (var item in relations2)
            {
                Sink(item.EventType);
            }
        }

        void DeltaPatch(Delta<Widget> delta, Widget original)
        {
            delta.Patch(original);
            Sink(original.Name);
        }

        void DeltaGetInstance(Delta<Widget> delta)
        {
            var w = delta.GetInstance();
            Sink(w.Name);
        }

        void Untainted()
        {
            var w = new Widget();
            w.Name = "safe";
            Sink(w.Name);

            var u = new UnrelatedType();
            u.Name = "also safe";
            Sink(u.Name);
        }
    }
}
