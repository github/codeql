class UncheckedCastInEquals
{
    private int i = 23;

    public override bool Equals(object obj)
    {
        UncheckedCastInEquals rhs = (UncheckedCastInEquals)obj;

        return i == rhs.i;
    }
}
