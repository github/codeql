package com.caucho.hessian.io;

import java.io.IOException;

public interface HessianRemoteResolver {
    Object lookup(String var1, String var2) throws IOException;
}

