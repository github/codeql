lgtm,codescanning
* Taint is now propagated across protocol buffer ("protobuf")  marshalling and unmarshalling operations. This may result in more results from existing queries where the protocol buffer format is used.
