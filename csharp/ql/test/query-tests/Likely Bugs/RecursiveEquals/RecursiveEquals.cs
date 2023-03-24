class RecursiveEquals
{
    class Bad
    {
        private int i = 0;
        public override bool Equals(object rhs)
        {
            if (rhs.GetType() != this.GetType()) return false;
            return Equals(rhs);
        }

        public bool Equals(Bad rhs)
        {
            return (rhs != null && this.i == rhs.i);
        }
    }

    class Good
    {
        private int i = 0;
        public override bool Equals(object rhs)
        {
            if (rhs.GetType() != this.GetType()) return false;
            return Equals((Good)rhs);
        }

        public bool Equals(Good rhs)
        {
            return (rhs != null && this.i == rhs.i);
        }
    }
}
