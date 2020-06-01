import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.SSLSession;

public class EverythingAcceptingHostnameVerifier {
	HostnameVerifier hostnameVerifier = new HostnameVerifier() {
		@Override
		public boolean verify(String hostname, SSLSession session) {
			return true; // BAD, always returns true, accepts everything
		}
	};

	HostnameVerifier hostnameVerifier2 = new HostnameVerifier() {
		@Override
		public boolean verify(String hostname, SSLSession session) {
			if (hostname.equals("localhost")) {
				return true; // BAD [Should not be detected by `EverythingAcceptingHostnameVerifier.ql`]
			}
			return false;
		}
	};
}
