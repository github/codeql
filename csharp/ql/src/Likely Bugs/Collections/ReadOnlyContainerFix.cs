class CalendarFix
{
    IList<string> daysOfWeek = new List<string>
    {
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
        "Sunday"
    };

    public string dayName(int day)
    {
        return daysOfWeek[day - 1];
    }
}
