public static void main(String[] args) {

	{
		SSLContext sslContext = SSLContext.getInstance("TLS");
		SSLEngine sslEngine = sslContext.createSSLEngine();
		SSLParameters sslParameters = sslEngine.getSSLParameters();
		sslParameters.setEndpointIdentificationAlgorithm("HTTPS"); //GOOD: Set a valid endpointIdentificationAlgorithm for SSL engine to trigger hostname verification
		sslEngine.setSSLParameters(sslParameters);
	}

	{
		SSLContext sslContext = SSLContext.getInstance("TLS");
		SSLEngine sslEngine = sslContext.createSSLEngine();  //BAD: No endpointIdentificationAlgorithm set
	}

	{
		SSLContext sslContext = SSLContext.getInstance("TLS");
		final SSLSocketFactory socketFactory = sslContext.getSocketFactory();
		SSLSocket socket = (SSLSocket) socketFactory.createSocket("www.example.com", 443); 
		SSLParameters sslParameters = sslEngine.getSSLParameters();
		sslParameters.setEndpointIdentificationAlgorithm("HTTPS"); //GOOD: Set a valid endpointIdentificationAlgorithm for SSL socket to trigger hostname verification
		socket.setSSLParameters(sslParameters);
	}

	{
		com.rabbitmq.client.ConnectionFactory connectionFactory = new com.rabbitmq.client.ConnectionFactory();
		connectionFactory.useSslProtocol();
		connectionFactory.enableHostnameVerification();  //GOOD: Enable hostname verification for rabbitmq ConnectionFactory
	}

	{
		com.rabbitmq.client.ConnectionFactory connectionFactory = new com.rabbitmq.client.ConnectionFactory();
		connectionFactory.useSslProtocol(); //BAD: Hostname verification for rabbitmq ConnectionFactory is not enabled
	}
}