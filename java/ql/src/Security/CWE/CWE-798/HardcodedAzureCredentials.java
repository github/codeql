public class HardcodedAzureCredentials {
	private final String clientId = "81734019-15a3-50t8-3253-5abe78abc3a1";
	private final String username = "username@example.onmicrosoft.com";
	private final String clientSecret = "1n1.qAc~3Q-1t38aF79Xzv5AUEfR5-ct3_";
	private final String tenantId = "22f367ce-535x-357w-2179-a33517mn166h";

	//BAD: hard-coded username/password credentials
	public void testHardcodedUsernamePassword(String input) {
		UsernamePasswordCredential usernamePasswordCredential = new UsernamePasswordCredentialBuilder()
		.clientId(clientId)
		.username(username)
		.password(clientSecret)
		.build();

		SecretClient client = new SecretClientBuilder()
		.vaultUrl("https://myKeyVault.vault.azure.net")
		.credential(usernamePasswordCredential)
		.buildClient();
	}

	//GOOD: username/password credentials stored as environment variables
	public void testEnvironmentUsernamePassword(String input) {
		UsernamePasswordCredential usernamePasswordCredential = new UsernamePasswordCredentialBuilder()
		.clientId(clientId)
		.username(System.getenv("myUsername"))
		.password(System.getenv("mySuperSecurePass"))
		.build();

		SecretClient client = new SecretClientBuilder()
		.vaultUrl("https://myKeyVault.vault.azure.net")
		.credential(usernamePasswordCredential)
		.buildClient();
	}

	//BAD: hard-coded client secret
	public void testHardcodedClientSecret(String input) {
		ClientSecretCredential defaultCredential = new ClientSecretCredentialBuilder()
		.clientId(clientId)
		.clientSecret(clientSecret)
		.tenantId(tenantId)
		.build();
	}

	//GOOD: client secret stored as environment variables
	public void testEnvironmentClientSecret(String input) {
		ClientSecretCredential defaultCredential = new ClientSecretCredentialBuilder()
		.clientId(clientId)
		.clientSecret(System.getenv("myClientSecret"))
		.tenantId(tenantId)
		.build();
	}
}