class DubiousTypeTestOfThis
{
    class BaseClass
    {
        public int add(int x)
        {
            if (this is FiveAdder)
                return x + 5;

            if (this is TenAdder)
                return x + 10;

            return 0;
        }
    }

    class FiveAdder : BaseClass
    {
        // ...
    }

    class TenAdder : BaseClass
    {
        // ...
    }
}
