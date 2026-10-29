package org.springframework.web.servlet;

import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.lang.Nullable;

public interface View {
    String RESPONSE_STATUS_ATTRIBUTE = View.class.getName() + ".responseStatus";
    String PATH_VARIABLES = View.class.getName() + ".pathVariables";
    String SELECTED_CONTENT_TYPE = View.class.getName() + ".selectedContentType";

    @Nullable
    default String getContentType() {
        return null;
    }

    void render(@Nullable Map<String, ?> var1, HttpServletRequest var2, HttpServletResponse var3) throws Exception;
}

