class Adder
{
    dynamic total = 0;

    public void AddItem(int item)
    {
        lock (total)     // Wrong
        {
            total = total + item;
        }
    }
}
