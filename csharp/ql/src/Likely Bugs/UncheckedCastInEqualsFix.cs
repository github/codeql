class UncheckedCastInEqualsFix
{
    private int i = 23;

    public override bool Equals(object obj)
    {
        if (obj.GetType() != this.GetType())
            return false;

        UncheckedCastInEqualsFix rhs = (UncheckedCastInEqualsFix)obj;

        return i == rhs.i;
    }
}
