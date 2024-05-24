
signature module BuildlessASTSig
{
    class Node;

    predicate isFunction(Node node);
    predicate isStatement(Node node);

    string getName(Node node);

    Node getBody(Node node);
}
