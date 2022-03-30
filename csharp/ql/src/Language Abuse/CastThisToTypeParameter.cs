class CastThisToTypeParameter
{
    abstract class BaseNode<T> where T : BaseNode<T>
    {
        public abstract T Parent { get; }

        public T Root
        {
            get
            {
                T cur = (T)this;
                while (cur.Parent != null)
                {
                    cur = cur.Parent;
                }
                return cur;
            }
        }
    }

    class Derived1 : BaseNode<Derived1>
    {
        private string name;
        private Derived1 parent;

        public Derived1(string name, Derived1 parent)
        {
            this.name = name;
            this.parent = parent;
        }

        public override Derived1 Parent { get { return parent; } }
    }

    class Derived2 : BaseNode<Derived1>
    {
        private string name;
        private Derived1 parent;

        public Derived2(string name, Derived1 parent)
        {
            this.name = name;
            this.parent = parent;
        }

        public override Derived1 Parent { get { return parent; } }
    }
}
