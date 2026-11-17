let quote = #"""#
let quotes = #""""#
let embedded = #"""key":"value"""#
let doubled = ##"""key"##
let nested = """
  interpolating \(##"""
    delimited \##("string")\#n\##n
    """##)
  """
#"unused literal"#
