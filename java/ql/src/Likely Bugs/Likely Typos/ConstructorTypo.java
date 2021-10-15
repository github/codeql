class MasterSingleton
{
	// ...

	private static MasterSingleton singleton = new MasterSingleton();
	public static MasterSingleton getInstance() { return singleton; }

	// Make the constructor 'protected' to prevent this class from being instantiated.
	protected void MasterSingleton() { }
}
