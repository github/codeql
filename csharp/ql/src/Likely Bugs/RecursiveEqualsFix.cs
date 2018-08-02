class RecursiveEqualsFix
{
    class C
    {
        private int i = 0;
        public override bool Equals(object rhs)
        {
            if (rhs.GetType() != this.GetType()) return false;
            return Equals((C)rhs);
        }

        public bool Equals(C rhs)
        {
            return (rhs != null && this.i == rhs.i);
        }
    }
}
