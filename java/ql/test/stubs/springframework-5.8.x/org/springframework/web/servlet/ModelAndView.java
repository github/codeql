package org.springframework.web.servlet;

import java.util.Map;
import org.springframework.http.HttpStatus;
import org.springframework.lang.Nullable;

public class ModelAndView {
    @Nullable
    private Object view;
    @Nullable
    private HttpStatus status;
    private boolean cleared = false;

    public ModelAndView() {
    }

    public ModelAndView(String viewName) {
        this.view = viewName;
    }

    public ModelAndView(View view) {
        this.view = view;
    }

    public ModelAndView(String viewName, @Nullable Map<String, ?> model) { }

    public ModelAndView(View view, @Nullable Map<String, ?> model) { }

    public ModelAndView(String viewName, HttpStatus status) { }

    public ModelAndView(@Nullable String viewName, @Nullable Map<String, ?> model, @Nullable HttpStatus status) { }

    public ModelAndView(String viewName, String modelName, Object modelObject) { }

    public ModelAndView(View view, String modelName, Object modelObject) { }

    public void setViewName(@Nullable String viewName) {
        this.view = viewName;
    }

    @Nullable
    public String getViewName() {
        return "";
    }

    public void setView(@Nullable View view) { }

    @Nullable
    public View getView() {
        return null;
    }

    public boolean hasView() {
        return true;
    }

    public boolean isReference() {
        return true;
    }

    @Nullable
    protected Map<String, Object> getModelInternal() {
        return null;
    }

    public Map<String, Object> getModel() {
        return null;
    }

    public void setStatus(@Nullable HttpStatus status) { }

    @Nullable
    public HttpStatus getStatus() {
        return this.status;
    }

    public ModelAndView addObject(String attributeName, @Nullable Object attributeValue) {
        return null;
    }

    public ModelAndView addObject(Object attributeValue) {
        return null;
    }

    public ModelAndView addAllObjects(@Nullable Map<String, ?> modelMap) {
        return null;
    }

    public void clear() { }

    public boolean isEmpty() {
        return true;
    }

    public boolean wasCleared() {
        return true;
    }

    public String toString() {
        return "";
    }

    private String formatView() {
        return "";
    }
}

