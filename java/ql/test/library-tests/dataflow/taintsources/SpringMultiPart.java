import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartRequest;

public class SpringMultiPart {
	MultipartFile file;

	private static void sink(Object o) {}

	public void test() throws Exception {
		sink(file.getBytes()); // $hasRemoteValueFlow
		sink(file.isEmpty()); // Safe
		sink(file.getInputStream()); // $hasRemoteValueFlow
		sink(file.getResource()); // $hasRemoteValueFlow
		sink(file.getName()); // $hasRemoteValueFlow
		sink(file.getContentType()); // $hasRemoteValueFlow
		sink(file.getOriginalFilename()); // $hasRemoteValueFlow
	}

	public void test(MultipartRequest request) {
		sink(request.getFile("name"));// $hasRemoteValueFlow
		sink(request.getFileMap());// $hasRemoteValueFlow
		sink(request.getFileNames());// $hasRemoteValueFlow
		sink(request.getFiles("name"));// $hasRemoteValueFlow
		sink(request.getMultiFileMap());// $hasRemoteValueFlow
		sink(request.getMultipartContentType("name")); // $hasRemoteValueFlow
	}
}
