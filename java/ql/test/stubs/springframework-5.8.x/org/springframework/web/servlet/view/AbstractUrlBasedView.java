package org.springframework.web.servlet.view;

import java.util.Locale;
import org.springframework.lang.Nullable;

public abstract class AbstractUrlBasedView {
    @Nullable
    private String url;

    protected AbstractUrlBasedView() { }

    protected AbstractUrlBasedView(String url) {
        this.url = url;
    }

    public void setUrl(@Nullable String url) {
        this.url = url;
    }

    @Nullable
    public String getUrl() {
        return "";
    }

    public void afterPropertiesSet() throws Exception { }

    protected boolean isUrlRequired() {
        return true;
    }

    public boolean checkResource(Locale locale) throws Exception {
        return true;
    }

    public String toString() {
        return "";
    }
}

