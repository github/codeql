// Generated automatically from org.openjdk.jmh.runner.options.Options for testing purposes

package org.openjdk.jmh.runner.options;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;
import java.util.concurrent.TimeUnit;
import org.openjdk.jmh.annotations.Mode;
import org.openjdk.jmh.results.format.ResultFormatType;
import org.openjdk.jmh.runner.options.ProfilerConfig;
import org.openjdk.jmh.runner.options.TimeValue;
import org.openjdk.jmh.runner.options.VerboseMode;
import org.openjdk.jmh.runner.options.WarmupMode;
import org.openjdk.jmh.util.Optional;

public interface Options extends Serializable
{
    Collection<Mode> getBenchModes();
    List<ProfilerConfig> getProfilers();
    List<String> getExcludes();
    List<String> getIncludes();
    List<String> getWarmupIncludes();
    Optional<Boolean> shouldDoGC();
    Optional<Boolean> shouldFailOnError();
    Optional<Boolean> shouldSyncIterations();
    Optional<Collection<String>> getJvmArgs();
    Optional<Collection<String>> getJvmArgsAppend();
    Optional<Collection<String>> getJvmArgsPrepend();
    Optional<Collection<String>> getParameter(String p0);
    Optional<Integer> getForkCount();
    Optional<Integer> getMeasurementBatchSize();
    Optional<Integer> getMeasurementIterations();
    Optional<Integer> getOperationsPerInvocation();
    Optional<Integer> getThreads();
    Optional<Integer> getWarmupBatchSize();
    Optional<Integer> getWarmupForkCount();
    Optional<Integer> getWarmupIterations();
    Optional<ResultFormatType> getResultFormat();
    Optional<String> getJvm();
    Optional<String> getOutput();
    Optional<String> getResult();
    Optional<TimeUnit> getTimeUnit();
    Optional<TimeValue> getMeasurementTime();
    Optional<TimeValue> getTimeout();
    Optional<TimeValue> getWarmupTime();
    Optional<VerboseMode> verbosity();
    Optional<WarmupMode> getWarmupMode();
    Optional<int[]> getThreadGroups();
}
