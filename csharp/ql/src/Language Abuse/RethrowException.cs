try
{
  Run();
status = Status.Success;
}
catch (Exception ex)
{
  status = Status.UnexpectedException;
  throw ex;    // BAD
}
