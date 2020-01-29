package org.apache.directory.ldap.client.api;

import org.apache.directory.api.ldap.model.exception.LdapException;
import org.apache.directory.api.ldap.model.cursor.EntryCursor;
import org.apache.directory.api.ldap.model.message.SearchScope;

public class LdapNetworkConnection /*implements LdapConnection*/ {
  public EntryCursor search(String baseDn, String filter, SearchScope scope, String... attributes) throws LdapException { return null; }
}
