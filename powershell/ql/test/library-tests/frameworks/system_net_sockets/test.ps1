param($server) # $ type="command line argument"

$tcpClient = [System.Net.Sockets.TcpClient]::new($server, 8080)
$networkStream = $tcpClient.GetStream() # $ type="remote flow source"


$localEndpoint = [System.Net.IPEndPoint]::new([System.Net.IPAddress]::Any, 8080)
$udpClient = [System.Net.Sockets.UdpClient]::new($localEndpoint)
$asyncResult = $udpClient.BeginReceive($null, $null)
$asyncResult.AsyncWaitHandle.WaitOne()
$remoteEndpoint = $null
$data = $udpClient.EndReceive($asyncResult, [ref]$remoteEndpoint) # $ type="remote flow source"

$remoteEndpoint2 = $null
$data2 = $udpClient.Receive([ref]$remoteEndpoint2) # $ type="remote flow source"

$receiveTask = $udpClient.ReceiveAsync() # $ type="remote flow source"
