// Generated automatically from org.springframework.jdbc.support.SQLExceptionTranslator for testing purposes

package org.springframework.jdbc.support;

import java.sql.SQLException;
import org.springframework.dao.DataAccessException;

public interface SQLExceptionTranslator
{
    DataAccessException translate(String p0, String p1, SQLException p2);
}
