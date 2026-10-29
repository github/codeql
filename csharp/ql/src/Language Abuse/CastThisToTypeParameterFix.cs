class CastThisToTypeParameterFix
{
    abstract class BaseNode<T> where T : BaseNode<T>
    {
        public abstract T Self { get; }
        public abstract T Parent { get; }

        public T Root
        {
            get
            {
                T cur = Self;
                while (cur.Parent != null)
                {
                    cur = cur.Parent;
                }
                return cur;
            }
        }
    }

    class ConcreteNode : BaseNode<ConcreteNode>
    {
        private string name;
        private ConcreteNode parent;

        public ConcreteNode(string name, ConcreteNode parent)
        {
            this.name = name;
            this.parent = parent;
        }

        public override ConcreteNode Self { get { return this; } }
        public override ConcreteNode Parent { get { return parent; } }
    }
}
