class MissedWhereOpportunityGood
{
    public int? FindFirstEven(System.Collections.Generic.IEnumerable<int> values)
    {
        foreach (int value in values)
        {
            if (value % 2 == 0)
                return value;
        }

        return null;
    }
}
