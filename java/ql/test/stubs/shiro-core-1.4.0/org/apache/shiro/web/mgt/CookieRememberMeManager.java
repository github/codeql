package org.apache.shiro.web.mgt;

import org.apache.shiro.mgt.AbstractRememberMeManager;
public class CookieRememberMeManager extends AbstractRememberMeManager {

    public CookieRememberMeManager() {
    }


    public void setCookie() {
    }

    protected void rememberSerializedIdentity() {
    }

    private boolean isIdentityRemoved() {
        return false;
    }

    protected byte[] getRememberedSerializedIdentity() {
        return null;
    }

    private String ensurePadding(String base64) {
        return null;
    }

 

}
