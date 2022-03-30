// Copyright (c) 2007-2020 VMware, Inc. or its affiliates. All rights reserved.
//
// This software, the RabbitMQ Java client library, is triple-licensed under the
// Mozilla Public License 2.0 ("MPL"), the GNU General Public License version 2
// ("GPL") and the Apache License version 2 ("ASL"). For the MPL, please see
// LICENSE-MPL-RabbitMQ. For the GPL, please see LICENSE-GPL2. For the ASL,
// please see LICENSE-APACHE2.
//
// This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND,
// either express or implied. See the LICENSE file for specific language governing
// rights and limitations of this software.
//
// If you have any questions regarding licensing, please contact us at
// info@rabbitmq.com.

package com.rabbitmq.client;

import javax.net.SocketFactory;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.security.KeyManagementException;
import java.security.NoSuchAlgorithmException;
import java.util.*;
import java.util.concurrent.*;
import java.util.function.Predicate;
import static java.util.concurrent.TimeUnit.MINUTES;

public class ConnectionFactory implements Cloneable {
  public static final int DEFAULT_CHANNEL_RPC_TIMEOUT = (int) MINUTES.toMillis(10);

  public String getHost() {
    return null;
  }

  public void setHost(String host) {}

  public static int portOrDefault(int port, boolean ssl) {
    return 0;
  }

  public int getPort() {
    return 0;
  }

  public void setPort(int port) {}

  public String getUsername() {
    return null;
  }

  public void setUsername(String username) {}

  public String getPassword() {
    return null;
  }

  public void setPassword(String password) {}

  public String getVirtualHost() {
    return null;
  }

  public void setVirtualHost(String virtualHost) {}

  public void setUri(URI uri)
      throws URISyntaxException, NoSuchAlgorithmException, KeyManagementException {}

  public void setUri(String uriString)
      throws URISyntaxException, NoSuchAlgorithmException, KeyManagementException {}

  public int getRequestedChannelMax() {
    return 0;
  }

  public void setRequestedChannelMax(int requestedChannelMax) {}

  public int getRequestedFrameMax() {
    return 0;
  }

  public void setRequestedFrameMax(int requestedFrameMax) {}

  public int getRequestedHeartbeat() {
    return 0;
  }

  public void setConnectionTimeout(int timeout) {}

  public int getConnectionTimeout() {
    return 0;
  }

  public int getHandshakeTimeout() {
    return 0;
  }

  public void setHandshakeTimeout(int timeout) {}

  public void setShutdownTimeout(int shutdownTimeout) {}

  public int getShutdownTimeout() {
    return 0;
  }

  public void setRequestedHeartbeat(int requestedHeartbeat) {}

  public Map<String, Object> getClientProperties() {
    return null;
  }

  public void setClientProperties(Map<String, Object> clientProperties) {}

  public SocketFactory getSocketFactory() {
    return null;
  }

  public void setSocketFactory(SocketFactory factory) {}

  public void setSharedExecutor(ExecutorService executor) {}

  public void setShutdownExecutor(ExecutorService executor) {}

  public void setHeartbeatExecutor(ScheduledExecutorService executor) {}

  public ThreadFactory getThreadFactory() {
    return null;
  }

  public void setThreadFactory(ThreadFactory threadFactory) {}

  public boolean isSSL() {
    return false;
  }

  public void useSslProtocol() throws NoSuchAlgorithmException, KeyManagementException {}

  public void useSslProtocol(String protocol)
      throws NoSuchAlgorithmException, KeyManagementException {}

  public void useSslProtocol(String protocol, TrustManager trustManager)
      throws NoSuchAlgorithmException, KeyManagementException {}

  public void useSslProtocol(SSLContext context) {}

  public void enableHostnameVerification() {}

  public static String computeDefaultTlsProtocol(String[] supportedProtocols) {
    return null;
  }

  public boolean isAutomaticRecoveryEnabled() {
    return false;
  }

  public void setAutomaticRecoveryEnabled(boolean automaticRecovery) {}

  public boolean isTopologyRecoveryEnabled() {
    return false;
  }

  public void setTopologyRecoveryEnabled(boolean topologyRecovery) {}

  public ExecutorService getTopologyRecoveryExecutor() {
    return null;
  }

  public void setTopologyRecoveryExecutor(final ExecutorService topologyRecoveryExecutor) {}

  public ConnectionFactory load(String propertyFileLocation) throws IOException {
    return null;
  }

  public ConnectionFactory load(String propertyFileLocation, String prefix) throws IOException {
    return null;
  }

  public ConnectionFactory load(Properties properties) {
    return null;
  }

  public ConnectionFactory load(Properties properties, String prefix) {
    return null;
  }

  public ConnectionFactory load(Map<String, String> properties) {
    return null;
  }

  public ConnectionFactory load(Map<String, String> properties, String prefix) {
    return null;
  }

  public long getNetworkRecoveryInterval() {
    return 0;
  }

  public void setNetworkRecoveryInterval(int networkRecoveryInterval) {}

  public void setNetworkRecoveryInterval(long networkRecoveryInterval) {}

  public void useNio() {}

  public void useBlockingIo() {}

  public void setChannelRpcTimeout(int channelRpcTimeout) {}

  public int getChannelRpcTimeout() {
    return 0;
  }

  public void setSslContextFactory(SslContextFactory sslContextFactory) {}

  public void setChannelShouldCheckRpcResponseType(boolean channelShouldCheckRpcResponseType) {}

  public boolean isChannelShouldCheckRpcResponseType() {
    return false;
  }

  public void setWorkPoolTimeout(int workPoolTimeout) {}

  public int getWorkPoolTimeout() {
    return 0;
  }

  public static int ensureUnsignedShort(int value) {
    return 0;
  }

}
