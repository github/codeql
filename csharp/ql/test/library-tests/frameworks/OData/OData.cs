namespace Test
{
    using Microsoft.AspNet.OData;
    using System.Collections.Generic;

    public class EntityMetadata
    {
        public string Owner { get; set; }
    }

    public class BoundEntity1
    {
        public string Name { get; set; }

        public string Content { get; set; }

        public EntityMetadata Metadata { get; set; }

        public List<EntityMetadata> Revisions { get; set; }
    }

    public class BoundEntity2
    {
        public string Name { get; set; }
    }

    public class RelatedItem
    {
        public string Label { get; set; }

        public string Category { get; set; }
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

    public class SampleController
    {
        void Sink(object o) { }

        void CastFromDictionary(ODataActionParameters parameters)
        {
            var entity = (BoundEntity1)parameters["Entity"];
            Sink(entity); // $ hasTaintFlow=line:51
            Sink(entity.Name); // $ hasTaintFlow=line:51
            Sink(entity.Content); // $ hasTaintFlow=line:51
            Sink(entity.Metadata.Owner); // $ hasTaintFlow=line:51
            foreach (var m in entity.Revisions)
            {
                Sink(m.Owner); // $ hasTaintFlow=line:51
            }
        }

        void IsAsFromDictionary(ODataActionParameters parameters)
        {
            if (parameters["Items"] is IEnumerable<RelatedItem> items1)
            {
                foreach (var item in items1)
                {
                    Sink(item.Label); // $ hasTaintFlow=line:64
                }
            }

            var items2 = parameters["Items"] as IEnumerable<RelatedItem>;
            foreach (var item in items2)
            {
                Sink(item.Category); // $ hasTaintFlow=line:64
            }
        }

        void UpcastThenIndex(ODataActionParameters parameters)
        {
            var dict = (IDictionary<string, object>)parameters;
            var entity = (BoundEntity2)dict["Entity"];
            Sink(entity.Name); // $ hasTaintFlow=line:81
        }

        void DeltaPatch(Delta<Widget> delta, Widget original)
        {
            delta.Patch(original);
            Sink(original.Name); // $ hasTaintFlow=line:88
        }

        void DeltaGetInstance(Delta<Widget> delta)
        {
            var w = delta.GetInstance();
            Sink(w.Name); // $ hasTaintFlow=line:94
        }

        void LegacyDeltaPatch(System.Web.Http.OData.Delta<Widget> delta, Widget original)
        {
            delta.Patch(original);
            Sink(original.Name); // $ hasTaintFlow=line:100
        }

        void LegacyDeltaGetEntity(System.Web.Http.OData.Delta<Widget> delta)
        {
            var w = delta.GetEntity();
            Sink(w.Name); // $ hasTaintFlow=line:106
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
