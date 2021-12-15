class Calendar
{
    IList<string> daysOfWeek = new List<string>();

    public string dayName(int day)
    {
        return daysOfWeek[day - 1];
    }
}
