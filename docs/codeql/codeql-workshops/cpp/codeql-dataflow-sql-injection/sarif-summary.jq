# -*- sh -*-
.runs | .[] | .results | .[] |
    ( (.ruleId, ": ", 
       (.message.text | split("\n") | ( .[0], " [", length-1 , " more]")),
       "\n")
      , 
      (if (.codeFlows != null) then
          (.codeFlows | .[] | 
               ("    Path\n"
                ,
                ( .threadFlows | .[] | .locations | .[] | .location | "        "
                  ,
                  ( .physicalLocation | ( .artifactLocation.uri, ":", .region.startLine, ":"))
                  ,
                  (.message.text, " ")
                  , 
                  "\n"
                )))
          else 
              (.locations | .[] |
                   ( "        "
                     ,
                     (.physicalLocation | ( .artifactLocation.uri, ":", .region.startLine, ":"))
                   ))
              ,
              # .message.text, 
              "\n"
              end)
    )  | tostring 

# This script extracts the following parts of the sarif output:
# 
# # problem
# "runs" : [ {
#   "results" : [ {
#     "ruleId" : "cpp/UncheckedErrorCode",

# # path problem
# "runs" : [ {
#   "tool" : {
#     "driver" : {
#       "rules" : [ {
#         "properties" : {
#           "kind" : "path-problem",

# "runs" : [ {
#   "results" : [ {
#     "ruleId" : "cpp/DangerousArithmetic",
#     "ruleIndex" : 6,
#     "message" : {
#       "text" : "Potential overflow (conversion: int -> unsigned int)\nPotential overflow (con

# "runs" : [ {
#   "results" : [ {
#     "codeFlows" : [ {
#       "threadFlows" : [ {
#         "locations" : [ {
#           "location" : {
#             "message" : {
#               "text" : "buff"
