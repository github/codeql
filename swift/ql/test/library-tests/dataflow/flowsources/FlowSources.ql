import swift
import codeql.swift.dataflow.FlowSources
import codeql.swift.dataflow.ExternalFlow
import FlowConfig

from RemoteFlowSource source
select source, concat(source.getSourceType(), ", ")
