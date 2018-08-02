public override int GetHashCode()
{
    return unchecked(row * 16777619 + col);
}
