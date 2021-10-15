class WeakEncryption
{
    public static byte[] encryptString()
    {
        SymmetricAlgorithm serviceProvider = new DESCryptoServiceProvider();
        byte[] key = { 16, 22, 240, 11, 18, 150, 192, 21 };
        serviceProvider.Key = key;
        ICryptoTransform encryptor = serviceProvider.CreateEncryptor();

        String message = "Hello World";
        byte[] messageB = System.Text.Encoding.ASCII.GetBytes(message);
        return encryptor.TransformFinalBlock(messageB, 0, messageB.Length);
    }
}
