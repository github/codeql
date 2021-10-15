class Bad
{
    class Super
    {
        public virtual void Foo() { }
    }

    class Sub : Super
    {
        public void Foo() { }
    }
}
