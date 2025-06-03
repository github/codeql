import { RunnablePassthrough, RunnableSequence } from "@langchain/core/runnables";

const fakeRetriever = RunnablePassthrough.from((_q: string) =>
  Promise.resolve([{ pageContent: "Hello world." }])
);

const formatDocumentsAsString = (documents: { pageContent: string }[]) =>documents.map((d) => d.pageContent).join("\n\n");

const chain = RunnableSequence.from([
  {
    context: fakeRetriever.pipe(formatDocumentsAsString),
    question: new RunnablePassthrough(),
  },
  "",
]);
