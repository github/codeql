var actions = new List<Fn>();
foreach (int i in Enumerable.Range(1, 10))
{
  int i2 = i; // GOOD: i is not captured
actions.Add(() => Console.Out.WriteLine(i2));
}
actions.ForEach(fn => fn());
