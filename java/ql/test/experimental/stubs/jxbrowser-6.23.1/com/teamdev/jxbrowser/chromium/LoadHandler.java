package com.teamdev.jxbrowser.chromium;

public interface LoadHandler {
    boolean onCertificateError(CertificateErrorParams params);

    boolean onLoad(LoadParams params);
}