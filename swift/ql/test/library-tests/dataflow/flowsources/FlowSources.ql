import swift
import codeql.swift.dataflow.FlowSources
import codeql.swift.dataflow.ExternalFlow
import FlowConfig

from FlowSource source
select source, concat(source.getSourceType(), ", ")
