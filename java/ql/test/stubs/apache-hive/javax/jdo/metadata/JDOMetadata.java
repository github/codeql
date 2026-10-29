// Generated automatically from javax.jdo.metadata.JDOMetadata for testing purposes

package javax.jdo.metadata;

import javax.jdo.metadata.ClassMetadata;
import javax.jdo.metadata.FetchPlanMetadata;
import javax.jdo.metadata.InterfaceMetadata;
import javax.jdo.metadata.Metadata;
import javax.jdo.metadata.PackageMetadata;
import javax.jdo.metadata.QueryMetadata;

public interface JDOMetadata extends Metadata
{
    ClassMetadata newClassMetadata(Class p0);
    FetchPlanMetadata newFetchPlanMetadata(String p0);
    FetchPlanMetadata[] getFetchPlans();
    InterfaceMetadata newInterfaceMetadata(Class p0);
    JDOMetadata setCatalog(String p0);
    JDOMetadata setSchema(String p0);
    PackageMetadata newPackageMetadata(Package p0);
    PackageMetadata newPackageMetadata(String p0);
    PackageMetadata[] getPackages();
    QueryMetadata newQueryMetadata(String p0);
    QueryMetadata[] getQueries();
    String getCatalog();
    String getSchema();
    int getNumberOfFetchPlans();
    int getNumberOfPackages();
    int getNumberOfQueries();
}
