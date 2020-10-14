import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartRequest;

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
	
	public void test(MultipartRequest request) {
		request.getFile("name");
		request.getFileMap();
		request.getFileNames();
		request.getFiles("name");
		request.getMultiFileMap();
		request.getMultipartContentType("name");
	}
}
