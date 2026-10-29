if(connection.Status == Connected && !connection.Authenticated)
{
  connection.SendAuthRequest();
}
