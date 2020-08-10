import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.BasicAWSCredentials;

public class HardcodedAWSCredentials {
	public static void main(String[] args) {
		//BAD: Hardcoded credentials for connecting to AWS services
		//To fix the problem, use other approaches including AWS credentials file, environment variables, or instance/container credentials instead 
		AWSCredentials creds = new BasicAWSCredentials("ACCESS_KEY", "SECRET_KEY");
	}
}