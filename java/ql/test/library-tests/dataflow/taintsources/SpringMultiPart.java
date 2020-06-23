import org.springframework.web.multipart.MultipartFile;

public class SpringMultiPart {
	MultipartFile file;

	public void test() throws Exception {
		file.getBytes();
		file.isEmpty();
		file.getInputStream();
		file.getResource();
		file.getName();
		file.getContentType();
		file.getOriginalFilename();
	}
}
