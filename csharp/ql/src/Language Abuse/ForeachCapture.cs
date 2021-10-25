var actions = new List<Fn>();
foreach (int i in Enumerable.Range(1, 10))
{
  // BAD: i is captured
  actions.Add(() => Console.Out.WriteLine(i));
}
actions.ForEach(fn => fn());
