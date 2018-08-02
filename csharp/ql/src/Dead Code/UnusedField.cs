class UnusedField1
{
    string name;  // BAD
    string email;

    public string GetName()
    {
        return email;
    }
    public string GetEmail()
    {
        return email;
    }
}

class UnusedField2
{
    string name; // BAD

    private string GetName()
    {
        return name;
    }
}
