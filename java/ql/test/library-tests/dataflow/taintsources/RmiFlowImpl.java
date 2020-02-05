package security.library.dataflow;

public class RmiFlowImpl implements RmiFlow {
	public String listDirectory(String path) {
		String command = "ls " + path;
		Runtime.getRuntime().exec(command);
		return "pretend there are some results here";
	}

	public String notRemotable(String path) {
		String command = "ls " + path;
		Runtime.getRuntime().exec(command);
		return "pretend there are some results here";
	}
}
