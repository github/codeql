//BAD: no path validation in Spring resource loading
@GetMapping("/file")
public String getFileContent(@RequestParam(name="fileName") String fileName) {
	ClassPathResource clr = new ClassPathResource(fileName);

	File file = ResourceUtils.getFile(fileName);

	Resource resource = resourceLoader.getResource(fileName);
}

//GOOD: check for a trusted prefix, ensuring path traversal is not used to erase that prefix in Spring resource loading:
@GetMapping("/file")
public String getFileContent(@RequestParam(name="fileName") String fileName) {
	if (!fileName.contains("..") && fileName.hasPrefix("/public-content")) {
		ClassPathResource clr = new ClassPathResource(fileName);

		File file = ResourceUtils.getFile(fileName);

		Resource resource = resourceLoader.getResource(fileName);
	}
}
