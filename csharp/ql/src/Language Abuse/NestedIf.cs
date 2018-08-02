if(connection.Status == Connected)
{
  if(!connection.Authenticated)
  {
    connection.SendAuthRequest();
  }
}
