import org.springframework.boot.SpringBootConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.remoting.caucho.HessianServiceExporter;
import org.springframework.remoting.httpinvoker.HttpInvokerServiceExporter;
import org.springframework.remoting.rmi.RemoteInvocationSerializingExporter;
import org.springframework.remoting.rmi.RmiServiceExporter;

@Configuration
public class SpringExporterUnsafeDeserialization {

    @Bean(name = "/unsafeRmiServiceExporter")
    RmiServiceExporter unsafeRmiServiceExporter() { // $ Alert[java/unsafe-deserialization-spring-exporter-in-configuration-class]
        RmiServiceExporter exporter = new RmiServiceExporter();
        exporter.setServiceInterface(AccountService.class);
        exporter.setService(new AccountServiceImpl());
        exporter.setServiceName(AccountService.class.getSimpleName());
        exporter.setRegistryPort(1099); 
        return exporter;
    }

    @Bean(name = "/unsafeHessianServiceExporter")
    HessianServiceExporter unsafeHessianServiceExporter() { // $ Alert[java/unsafe-deserialization-spring-exporter-in-configuration-class]
        HessianServiceExporter exporter = new HessianServiceExporter();
        exporter.setService(new AccountServiceImpl());
        exporter.setServiceInterface(AccountService.class);
        return exporter;
    }

    @Bean(name = "/unsafeHttpInvokerServiceExporter")
    HttpInvokerServiceExporter unsafeHttpInvokerServiceExporter() { // $ Alert[java/unsafe-deserialization-spring-exporter-in-configuration-class]
        HttpInvokerServiceExporter exporter = new HttpInvokerServiceExporter();
        exporter.setService(new AccountServiceImpl());
        exporter.setServiceInterface(AccountService.class);
        return exporter;
    }

    @Bean(name = "/unsafeCustomeRemoteInvocationSerializingExporter")
    RemoteInvocationSerializingExporter unsafeCustomeRemoteInvocationSerializingExporter() { // $ Alert[java/unsafe-deserialization-spring-exporter-in-configuration-class]
        return new CustomeRemoteInvocationSerializingExporter();
    }

    HttpInvokerServiceExporter notABean() {
        HttpInvokerServiceExporter exporter = new HttpInvokerServiceExporter();
        exporter.setService(new AccountServiceImpl());
        exporter.setServiceInterface(AccountService.class);
        return exporter;
    }
}

@SpringBootApplication
class SpringBootTestApplication {

    @Bean(name = "/unsafeHttpInvokerServiceExporter")
    HttpInvokerServiceExporter unsafeHttpInvokerServiceExporter() { // $ Alert[java/unsafe-deserialization-spring-exporter-in-configuration-class]
        HttpInvokerServiceExporter exporter = new HttpInvokerServiceExporter();
        exporter.setService(new AccountServiceImpl());
        exporter.setServiceInterface(AccountService.class);
        return exporter;
    }
}

@SpringBootConfiguration
class SpringBootTestConfiguration {

    @Bean(name = "/unsafeHttpInvokerServiceExporter")
    HttpInvokerServiceExporter unsafeHttpInvokerServiceExporter() { // $ Alert[java/unsafe-deserialization-spring-exporter-in-configuration-class]
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
