namespace Test
{
    using Microsoft.AspNet.OData;
    using System.Collections.Generic;

    public class EntityMetadata
    {
        public string Owner { get; set; }
    }

    public class BoundEntity
    {
        public string Name { get; set; }

        public string Content { get; set; }

        public EntityMetadata Metadata { get; set; }

        public List<EntityMetadata> Revisions { get; set; }
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
            var entity = (BoundEntity)parameters["Entity"];
            Sink(entity);
            Sink(entity.Name);
            Sink(entity.Content);
            Sink(entity.Metadata.Owner);
            foreach (var m in entity.Revisions)
            {
                Sink(m.Owner);
            }
        }

        void IsAsFromDictionary(ODataActionParameters parameters)
        {
            if (parameters["Items"] is IEnumerable<RelatedItem> items1)
            {
                foreach (var item in items1)
                {
                    Sink(item.Label);
                }
            }

            var items2 = parameters["Items"] as IEnumerable<RelatedItem>;
            foreach (var item in items2)
            {
                Sink(item.Category);
            }
        }

        void UpcastThenIndex(ODataActionParameters parameters)
        {
            IDictionary<string, object> dict = parameters;
            var entity = (BoundEntity)dict["Entity"];
            Sink(entity.Name);
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

        void LegacyDeltaPatch(System.Web.Http.OData.Delta<Widget> delta, Widget original)
        {
            delta.Patch(original);
            Sink(original.Name);
        }

        void LegacyDeltaGetEntity(System.Web.Http.OData.Delta<Widget> delta)
        {
            var w = delta.GetEntity();
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
