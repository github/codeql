public class EJBMain implements SessionBean {
    /**
     * Create the session bean (empty implementation)
     */
    public void ejbCreate() throws javax.ejb.CreateException {
        System.out.println("EJBMain:ejbCreate()");
    }

    public void ejbActivate() throws javax.ejb.EJBException, java.rmi.RemoteException {
    }

    public void ejbPassivate() throws javax.ejb.EJBException, java.rmi.RemoteException {
    }

    public void ejbRemove() throws javax.ejb.EJBException, java.rmi.RemoteException {
    }

    public void setSessionContext(SessionContext parm1) throws javax.ejb.EJBException, java.rmi.RemoteException {
    }

    public String doService() {
        return null;
    }

    // BAD - Implement a main method in session bean.
    public static void main(String[] args) throws Exception {
        EJBMain b = new EJBMain();
        b.doService();
    }

    // GOOD - Not to have a main method in session bean.
}
