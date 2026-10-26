/*
 * Copyright (C) 2013, 2014 Brett Wooldridge
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.zaxxer.hikari;


public class HikariConfig implements HikariConfigMXBean {

    private String jdbcUrl;

    public HikariConfig() {
    }

    public HikariConfig(java.util.Properties properties) {

    }

    public HikariConfig(String propertyFileName) {
    }

    public String getJdbcUrl() {
       return jdbcUrl;
    }
 
    public void setJdbcUrl(String jdbcUrl) {
       this.jdbcUrl = jdbcUrl;
    }

    public long getConnectionTimeout() { return 0; }

    public void setConnectionTimeout(long connectionTimeoutMs) {}

    public long getValidationTimeout() { return 0; }

    public void setValidationTimeout(long validationTimeoutMs) {}

    public long getIdleTimeout() { return 0; }

    public void setIdleTimeout(long idleTimeoutMs) {}
 
    public long getLeakDetectionThreshold() { return 0; }

    public void setLeakDetectionThreshold(long leakDetectionThresholdMs) {}

    public long getMaxLifetime() { return 0; }

    public void setMaxLifetime(long maxLifetimeMs) {}

    public int getMinimumIdle() { return 0; }

    public void setMinimumIdle(int minIdle) {}

    public int getMaximumPoolSize() { return 0; }
 
    public void setMaximumPoolSize(int maxPoolSize) {}
 
    public void setPassword(String password) {}
 
    public void setUsername(String username) {}
 
    public String getPoolName() {return "";}
 
    public String getCatalog() {return "";}
 
    public void setCatalog(String catalog) {}
}