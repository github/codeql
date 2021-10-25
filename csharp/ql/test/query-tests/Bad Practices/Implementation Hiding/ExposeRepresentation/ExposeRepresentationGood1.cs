using System.Collections.ObjectModel;

class Good1
{
    class Range
    {
        private ReadOnlyCollection<int> rarray = new ReadOnlyCollection<int>(new int[2]);

        public Range(int min, int max)
        {
            if (min <= max)
            {
                int[] rarray = new int[2];
                rarray[0] = min;
                rarray[1] = max;
                this.rarray = new ReadOnlyCollection<int>(rarray);
            }
        }

        public ReadOnlyCollection<int> Get() => rarray;
    }
}
