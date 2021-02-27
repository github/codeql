import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.remoting.httpinvoker.HttpInvokerServiceExporter;
import org.springframework.remoting.rmi.RemoteInvocationSerializingExporter;

@Configuration
public class SpringHttpInvokerUnsafeDeserialization {
    
    @Bean(name = "/unsafeHttpInvokerServiceExporter")
    HttpInvokerServiceExporter unsafeHttpInvokerServiceExporter() {
        HttpInvokerServiceExporter exporter = new HttpInvokerServiceExporter();
        exporter.setService(new AccountServiceImpl());
        exporter.setServiceInterface(AccountService.class);
        return exporter;
    }

    @Bean(name = "/unsafeCustomeRemoteInvocationSerializingExporter")
    RemoteInvocationSerializingExporter unsafeCustomeRemoteInvocationSerializingExporter() {
        return new CustomeRemoteInvocationSerializingExporter();
    }

    HttpInvokerServiceExporter notABean() {
        HttpInvokerServiceExporter exporter = new HttpInvokerServiceExporter();
        exporter.setService(new AccountServiceImpl());
        exporter.setServiceInterface(AccountService.class);
        return exporter;
    }
}

class CustomeRemoteInvocationSerializingExporter extends RemoteInvocationSerializingExporter {}

class NotAConfiguration {

    @Bean(name = "/notAnEndpoint")
    HttpInvokerServiceExporter notAnEndpoint() {
        HttpInvokerServiceExporter exporter = new HttpInvokerServiceExporter();
        exporter.setService(new AccountServiceImpl());
        exporter.setServiceInterface(AccountService.class);
        return exporter;
    }
}

class AccountServiceImpl implements AccountService {

    @Override
    public String echo(String data) {
        return data;
    }
}

interface AccountService {
    String echo(String data);
}
