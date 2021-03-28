import java.io.IOException;
import java.util.Properties;

public class PropertiesUtils {
	/* Properties declaration. */ 
	private static Properties properties;  

    /** Static block to initializing the properties. */
	static {
		properties = new Properties();
		try {
			properties.load(PropertiesUtils.class.getClassLoader().getResourceAsStream("configuration.properties"));
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/** Returns the LDAP DN property value. */
	public static String getLdapDN() {
		return properties.getProperty("ldap.loginDN");
	}
    
	/** Returns the LDAP password property value. */
	public static String getLdapPassword() {
		return properties.getProperty("ldap.password");
	}

	/** Returns the SQL Server username property value. */
	public static String getMSDataSourceUserName() {
		return properties.getProperty("datasource1.username");
	}

	/** Returns the SQL Server password property value. */
	public static String getMSDataSourcePassword() {
		return properties.getProperty("datasource1.password");
	}
    
	/** Returns the mail account property value. */
	public static String getMailUserName() {
		return properties.getProperty("mail.username");
	}

 	/** Returns the mail password property value. */
	public static String getMailPassword() {
		return properties.getProperty("mail.password");
	}

	/** Returns the AWS Access Key property value. */
	public static String getAWSAccessKey() {
		return properties.getProperty("com.example.aws.s3.access_key");
	}

	/** Returns the AWS Secret Key property value. */
	public static String getAWSSecretKey() {
		return properties.getProperty("com.example.aws.s3.secret_key");
	}
}
