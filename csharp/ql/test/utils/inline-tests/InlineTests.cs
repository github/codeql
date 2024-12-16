class C
{
    void Problems()
    {
        // correct expectation comment, but only for `problem-query`
        var x = "Alert"; // $ Alert

        // irrelevant expectation comment, will be ignored
        x = "Not an alert"; // $ IrrelevantTag

        // incorrect expectation comment
        x = "Also not an alert"; // $ Alert

        // missing expectation comment, but only for `problem-query`
        x = "Alert";

        // correct expectation comment
        x = "Alert"; // $ Alert[problem-query]
    }

    void PathProblems()
    {
        // correct expectation comments, but only for `path-problem-query`
        var source = "Source"; // $ Source
        var sink = "Sink"; // $ Sink
        var x = "Alert:2:1"; // $ Alert

        // incorrect expectation comments
        source = "Source"; // $ Source
        sink = "Sink"; // $ Sink
        x = "Not an alert:2:1"; // $ Alert

        // missing expectation comments, but only for `path-problem-query`
        source = "Source";
        sink = "Sink";
        x = "Alert:2:1";

        // correct expectation comments
        source = "Source"; // $ Source[path-problem-query]
        sink = "Sink"; // $ Sink[path-problem-query]
        x = "Alert:2:1"; // $ Alert[path-problem-query]

        // correct expectation comments; the alert location coincides with the sink location
        source = "Source"; // $ Source[path-problem-query]
        x = "Alert:1:0"; // $ Alert[path-problem-query]

        // correct expectation comments; the alert location coincides with the source location
        sink = "Sink"; // $ Sink[path-problem-query]
        x = "Alert:0:1"; // $ Alert[path-problem-query]

        // correct expectation comments, using an identifier tag
        source = "Source"; // $ Source[path-problem-query]=source1
        sink = "Sink"; // $ Sink[path-problem-query]=source1
        x = "Alert:2:1"; // $ Alert[path-problem-query]=source1

        // incorrect expectation comment, using wrong identifier tag at the sink
        source = "Source"; // $ Source[path-problem-query]=source2
        sink = "Sink"; // $ Sink[path-problem-query]=source1
        x = "Alert:2:1"; // $ Alert[path-problem-query]=source2

        // incorrect expectation comment, using wrong identifier tag at the alert
        source = "Source"; // $ Source[path-problem-query]=source3
        sink = "Sink"; // $ Sink[path-problem-query]=source3
        x = "Alert:2:1"; // $ Alert[path-problem-query]=source2

        // correct expectation comments, using an identifier tag; the alert location coincides with the sink location
        source = "Source"; // $ Source[path-problem-query]=source4
        x = "Alert:1:0"; // $ Alert[path-problem-query]=source4

        // incorrect expectation comments, using an identifier tag; the alert location coincides with the sink location
        source = "Source"; // $ Source[path-problem-query]=source5
        x = "Alert:1:0"; // $ Alert[path-problem-query]=source4

        // correct expectation comments, using an identifier tag; the alert location coincides with the source location
        sink = "Sink"; // $ Sink[path-problem-query]=sink1
        x = "Alert:0:1"; // $ Alert[path-problem-query]=sink1

        // incorrect expectation comments, using an identifier tag; the alert location coincides with the source location
        sink = "Sink"; // $ Sink[path-problem-query]=sink2
        x = "Alert:0:1"; // $ Alert[path-problem-query]=sink1
    }
}