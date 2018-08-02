try
{
  Run();
status = Status.Success;
}
catch
{
  status = Status.UnexpectedException;
  throw;    // GOOD
}
