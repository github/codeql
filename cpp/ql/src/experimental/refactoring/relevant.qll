import cpp

predicate is_relevant_result(File file)
{
    not file.getRelativePath().matches("c/extractor/edg%")
}
