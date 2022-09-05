import java

query predicate comments(KtComment c, string s) { c.getText() = s }

query predicate commentOwners(KtComment c, Top t) { c.getOwner() = t }

query predicate commentNoOwners(KtComment c) { not exists(c.getOwner()) }

query predicate commentSections(KtComment c, KtCommentSection s) { c.getSections() = s }

query predicate commentSectionContents(KtCommentSection s, string c) { s.getContent() = c }

query predicate commentSectionNames(KtCommentSection s, string c) { s.getName() = c }

query predicate commentSectionSubjectNames(KtCommentSection s, string c) { s.getSubjectName() = c }
