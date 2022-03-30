@Configuration
public class Server {

    @Bean(name = "/account")
    HttpInvokerServiceExporter accountService() {
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