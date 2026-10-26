import codeql.ruby.frameworks.stdlib.Open3::Open3
import codeql.ruby.DataFlow

query predicate open3CallExecutions(Open3Call c) { any() }

query predicate open3PipelineCallExecutions(Open3PipelineCall c) { any() }

query predicate open4CallExecutions(Open4Call c) { any() }
