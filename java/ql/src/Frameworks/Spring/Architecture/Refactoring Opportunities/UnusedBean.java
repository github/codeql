class Start {
	public static void main(String[] args) {
		// Create a context from the XML file, constructing beans
		ApplicationContext context =
		    new ClassPathXmlApplicationContext(new String[] {"services.xml"});

		// Retrieve the petStore from the context bean factory.
		PetStoreService service = context.getBean("petStore", PetStoreService.class);
		// Use the value
		List<String> userList = service.getUsernameList();
	}
}