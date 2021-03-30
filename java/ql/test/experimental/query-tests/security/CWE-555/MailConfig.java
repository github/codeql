import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

@Configuration
public class MailConfig {
    @Value("${mail.password}")
    private String mailPassword;

    @Value("${mail.username}")
    private String mailUserName;
}
