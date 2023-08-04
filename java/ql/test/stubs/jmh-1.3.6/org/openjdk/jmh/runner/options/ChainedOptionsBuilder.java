// Generated automatically from org.openjdk.jmh.runner.options.ChainedOptionsBuilder for testing purposes

package org.openjdk.jmh.runner.options;

import java.util.concurrent.TimeUnit;
import org.openjdk.jmh.annotations.Mode;
import org.openjdk.jmh.profile.Profiler;
import org.openjdk.jmh.results.format.ResultFormatType;
import org.openjdk.jmh.runner.options.Options;
import org.openjdk.jmh.runner.options.TimeValue;
import org.openjdk.jmh.runner.options.VerboseMode;
import org.openjdk.jmh.runner.options.WarmupMode;

public interface ChainedOptionsBuilder
{
    ChainedOptionsBuilder addProfiler(Class<? extends Profiler> p0);
    ChainedOptionsBuilder addProfiler(Class<? extends Profiler> p0, String p1);
    ChainedOptionsBuilder addProfiler(String p0);
    ChainedOptionsBuilder addProfiler(String p0, String p1);
    ChainedOptionsBuilder detectJvmArgs();
    ChainedOptionsBuilder exclude(String p0);
    ChainedOptionsBuilder forks(int p0);
    ChainedOptionsBuilder include(String p0);
    ChainedOptionsBuilder includeWarmup(String p0);
    ChainedOptionsBuilder jvm(String p0);
    ChainedOptionsBuilder jvmArgs(String... p0);
    ChainedOptionsBuilder jvmArgsAppend(String... p0);
    ChainedOptionsBuilder jvmArgsPrepend(String... p0);
    ChainedOptionsBuilder measurementBatchSize(int p0);
    ChainedOptionsBuilder measurementIterations(int p0);
    ChainedOptionsBuilder measurementTime(TimeValue p0);
    ChainedOptionsBuilder mode(Mode p0);
    ChainedOptionsBuilder operationsPerInvocation(int p0);
    ChainedOptionsBuilder output(String p0);
    ChainedOptionsBuilder param(String p0, String... p1);
    ChainedOptionsBuilder parent(Options p0);
    ChainedOptionsBuilder result(String p0);
    ChainedOptionsBuilder resultFormat(ResultFormatType p0);
    ChainedOptionsBuilder shouldDoGC(boolean p0);
    ChainedOptionsBuilder shouldFailOnError(boolean p0);
    ChainedOptionsBuilder syncIterations(boolean p0);
    ChainedOptionsBuilder threadGroups(int... p0);
    ChainedOptionsBuilder threads(int p0);
    ChainedOptionsBuilder timeUnit(TimeUnit p0);
    ChainedOptionsBuilder timeout(TimeValue p0);
    ChainedOptionsBuilder verbosity(VerboseMode p0);
    ChainedOptionsBuilder warmupBatchSize(int p0);
    ChainedOptionsBuilder warmupForks(int p0);
    ChainedOptionsBuilder warmupIterations(int p0);
    ChainedOptionsBuilder warmupMode(WarmupMode p0);
    ChainedOptionsBuilder warmupTime(TimeValue p0);
    Options build();
}
