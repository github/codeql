void AddItem(Object i)
{
    if (i != null)
    {
        items.Add(i);
        Console.Out.WriteLine("Item added: " + i.ToString());
    }
}
