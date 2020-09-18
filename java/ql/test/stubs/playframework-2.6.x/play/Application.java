/*
 * Copyright (C) 2009-2016 Lightbend Inc. <https://www.lightbend.com>
 */
package play;

import java.io.File;
import java.io.InputStream;
import java.net.URL;

//import play.inject.Injector; -> Scala stuff
//import play.libs.Scala;

/**
 * A Play application.
 *
 * Application creation is handled by the framework engine.
 */
public interface Application {

    /**
     * Get the underlying Scala application.
     *
     * @
     */
    //play.api.Application getWrappedApplication();

    /**
     * Get the application configuration.
     *
     * @
     */
    //Configuration configuration();

    /**
     * Get the injector for this application.
     *
     * @
     */
    //Injector injector();

    /**
     * Get the application path.
     *
     * @
     */
    default File path() {
    }

    /**
     * Get the application classloader.
     *
     * @
     */
    default ClassLoader classloader() {

    }

    /**
     * Get a file relative to the application root path.
     *
     * @param relativePath relative path of the file to fetch
     * @
     */
    default File getFile(String relativePath) {

    }

    /**
     * Get a resource from the classpath.
     *
     * @param relativePath relative path of the resource to fetch
     * @
     */
    default URL resource(String relativePath) {

    }

    /**
     * Get a resource stream from the classpath.
     *
     * @param relativePath relative path of the resource to fetch
     * @
     */
    default InputStream resourceAsStream(String relativePath) {

    }

}