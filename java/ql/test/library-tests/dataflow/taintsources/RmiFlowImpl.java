package security.library.dataflow;

public class RmiFlowImpl implements RmiFlow {

	private static void sink(Object o) {}

	public String listDirectory(String path) throws java.io.IOException {
		String command = "ls " + path;
		sink(command); // $hasRemoteTaintFlow
		return "pretend there are some results here";
	}

	public String notRemotable(String path) throws java.io.IOException {
		String command = "ls " + path;
		sink(command); // Safe
		return "pretend there are some results here";
	}
}
