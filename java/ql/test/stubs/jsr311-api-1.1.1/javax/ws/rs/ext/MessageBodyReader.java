/*
 * The contents of this file are subject to the terms
 * of the Common Development and Distribution License
 * (the "License").  You may not use this file except
 * in compliance with the License.
 *
 * You can obtain a copy of the license at
 * http://www.opensource.org/licenses/cddl1.php
 * See the License for the specific language governing
 * permissions and limitations under the License.
 */

/*
 * MessageBodyReader.java
 *
 * Created on November 8, 2007, 3:57 PM
 *
 */

/*
 * Adapted from JAX-RS version 1.1.1 as available at
 *   https://search.maven.org/remotecontent?filepath=javax/ws/rs/jsr311-api/1.1.1/jsr311-api-1.1.1-sources.jar
 * Only relevant stubs of this file have been retained for test purposes.
 */

package javax.ws.rs.ext;

import java.io.IOException;
import java.io.InputStream;
import java.lang.annotation.Annotation;
import java.lang.reflect.Type;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.MultivaluedMap;

public interface MessageBodyReader<T> {
    
    boolean isReadable(Class<?> type, Type genericType, 
            Annotation annotations[], MediaType mediaType);

    T readFrom(Class<T> type, Type genericType,  
            Annotation annotations[], MediaType mediaType,
            MultivaluedMap<String, String> httpHeaders, 
            InputStream entityStream) throws IOException;
    
}