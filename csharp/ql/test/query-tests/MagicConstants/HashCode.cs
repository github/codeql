
class MyHashCode
{
    public override int GetHashCode()
    {
        // GOOD: Constants in GetHashCode() are permitted.
        return
          397 +
          397 + 397 + 397 + 397 + 397 + 397 + 397 + 397 + 397 + 397 +
          397 + 397 + 397 + 397 + 397 + 397 + 397 + 397 + 397 + 397;
    }

    int NotHashCode()
    {
        // BAD: Number 391 is repeated.
        return
          391 +
          391 + 391 + 391 + 391 + 391 + 391 + 391 + 391 + 391 + 391 +
          391 + 391 + 391 + 391 + 391 + 391 + 391 + 391 + 391 + 391 + 397;
    }
}
