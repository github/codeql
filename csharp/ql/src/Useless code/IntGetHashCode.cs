public override int GetHashCode()
{
    return row.GetHashCode() ^ col.GetHashCode();
}
