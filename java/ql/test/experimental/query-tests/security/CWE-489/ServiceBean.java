import javax.ejb.SessionBean;
import javax.ejb.EJBException;
import java.rmi.RemoteException;
import javax.ejb.SessionContext;
import javax.naming.Context;
import javax.naming.InitialContext;

public class ServiceBean implements SessionBean {

    protected SessionContext ctx;

    private String _serviceName;

    /**
     * Create the session bean (empty implementation)
     */
    public void ejbCreate() throws javax.ejb.CreateException {
        System.out.println("ServiceBean:ejbCreate()");
    }

    public void ejbActivate() throws javax.ejb.EJBException, java.rmi.RemoteException {
    }

    public void ejbPassivate() throws javax.ejb.EJBException, java.rmi.RemoteException {
    }

    public void ejbRemove() throws javax.ejb.EJBException, java.rmi.RemoteException {
    }

    public void setSessionContext(SessionContext parm1) throws javax.ejb.EJBException, java.rmi.RemoteException {
    }

    /**
     * Get service name
     * @return service name
     */
    public String getServiceName() {
        return _serviceName;
    }

    /**
     * Set service name
     * @param serviceName the service name
     */
    public void setServiceName(String serviceName) {
        _serviceName = serviceName;
    }

    /** Do service (no implementation) */
    public String doService() {
        return null;
    }

    /** Local unit testing code */
    public static void main(String[] args) throws Exception {
        ServiceBean b = new ServiceBean();
        b.doService();
    }
}
