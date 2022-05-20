class Person
{
    private string _firstName;
    private string _middleName;
    private string _lastName;

    public string firstName
    {
        get
        {
            return _firstName;
        }
        set
        {
            value = value.ToLower();
            char firstUC = char.ToUpper(value[0]);
            _firstName = firstUC + value.Substring(1);
        }
    }
    public string middleName
    {
        get
        {
            return _middleName;
        }
        set
        {
            value = value.ToLower();
            char firstUC = char.ToUpper(value[0]);
            _firstName = firstUC + value.Substring(1);
        }
    }
    public string lastName
    {
        get
        {
            return _lastName;
        }
        set
        {
            value = value.ToLower();
            char firstUC = char.ToUpper(value[0]);
            _firstName = firstUC + value.Substring(1);
        }
    }
    // more properties...
}
