import swift
import codeql.swift.dataflow.FlowSources

from RemoteFlowSource source
select source, concat(source.getSourceType(), ", ")
