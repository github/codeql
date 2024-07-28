package trap

import (
	"fmt"
	"go/types"

	"github.com/github/codeql-go/extractor/util"
)

// Label represents a label
type Label struct {
	id string
}

// InvalidLabel represents an uninitialized or otherwise invalid label
var InvalidLabel Label

func (lbl *Label) String() string {
	return lbl.id
}

// Labeler is used to represent labels for a file. It is used to write
// associate objects with labels.
type Labeler struct {
	tw *Writer

	nextid       int
	fileLabel    Label
	nodeLabels   map[interface{}]Label  // labels associated with AST nodes
	scopeLabels  map[*types.Scope]Label // labels associated with scopes
	objectLabels map[types.Object]Label // labels associated with objects (that is, declared entities)
	TypeLabels   map[types.Type]Label   // labels associated with types
	keyLabels    map[string]Label
}

func newLabeler(tw *Writer) *Labeler {
	return &Labeler{
		tw,
		10000,
		InvalidLabel,
		make(map[interface{}]Label),
		make(map[*types.Scope]Label),
		make(map[types.Object]Label),
		make(map[types.Type]Label),
		make(map[string]Label),
	}
}

func (l *Labeler) nextID() string {
	var id = l.nextid
	l.nextid++
	return fmt.Sprintf("#%d", id)
}

// GlobalID associates a label with the given `key` and returns it
func (l *Labeler) GlobalID(key string) Label {
	label, exists := l.keyLabels[key]
	if !exists {
		id := l.nextID()
		fmt.Fprintf(l.tw.wzip, "%s=@\"%s\"\n", id, escapeString(key))
		label = Label{id}
		l.keyLabels[key] = label
	}
	return label
}

// FileLabel returns the label for a file with path `path`.
func (l *Labeler) FileLabel() Label {
	if l.fileLabel == InvalidLabel {
		l.fileLabel = l.FileLabelFor(l.tw.path)
	}
	return l.fileLabel
}

// FileLabelFor returns the label for the file for which the trap writer `tw` is associated
func (l *Labeler) FileLabelFor(path string) Label {
	return l.GlobalID(util.EscapeTrapSpecialChars(path) + ";sourcefile")
}

// LocalID associates a label with the given AST node `nd` and returns it
func (l *Labeler) LocalID(nd interface{}) Label {
	label, exists := l.nodeLabels[nd]
	if !exists {
		label = l.FreshID()
		l.nodeLabels[nd] = label
	}
	return label
}

// FreshID creates a fresh label and returns it
func (l *Labeler) FreshID() Label {
	id := l.nextID()
	fmt.Fprintf(l.tw.wzip, "%s=*\n", id)
	return Label{id}
}

// ScopeID associates a label with the given scope and returns it
func (l *Labeler) ScopeID(scope *types.Scope, pkg *types.Package) Label {
	label, exists := l.scopeLabels[scope]
	if !exists {
		if scope == types.Universe {
			label = l.GlobalID("universe;scope")
		} else {
			if pkg != nil && pkg.Scope() == scope {
				// if this scope is the package scope
				pkgLabel := l.GlobalID(util.EscapeTrapSpecialChars(pkg.Path()) + ";package")
				label = l.GlobalID("{" + pkgLabel.String() + "};scope")
			} else {
				label = l.FreshID()
			}
		}
		l.scopeLabels[scope] = label
	}
	return label
}

// LookupObjectID looks up the label associated with the given object and returns it; if the object does not have
// a label yet, it tries to construct one based on its scope and/or name, and otherwise returns InvalidLabel
func (l *Labeler) LookupObjectID(object types.Object, typelbl Label) (Label, bool) {
	label, exists := l.objectLabels[object]
	if !exists {
		if object.Parent() == nil {
			// blank identifiers and the pseudo-package `.` (from `import . "..."` imports) can only be referenced
			// once, so we can use a fresh label for them
			if object.Name() == "_" || object.Name() == "." {
				label = l.FreshID()
				l.objectLabels[object] = label
				return label, false
			}
			label = InvalidLabel
		} else {
			label, exists = l.ScopedObjectID(object, func() Label { return typelbl })
		}
	}
	return label, exists
}

// ScopedObjectID associates a label with the given object and returns it,
// together with a flag indicating whether the object already had a label
// associated with it; the object must have a scope, since the scope's label is
// used to construct the label of the object.
//
// There is a special case for variables that are method receivers. When this is
// detected, we must construct a special label, as the variable can be reached
// from several files via the method. As the type label is required to construct
// the receiver object id, it is also required here.
func (l *Labeler) ScopedObjectID(object types.Object, getTypeLabel func() Label) (Label, bool) {
	label, exists := l.objectLabels[object]
	if !exists {
		scope := object.Parent()
		if scope == nil {
			panic(fmt.Sprintf("Object has no scope: %v :: %v.\n", object,
				l.tw.Package.Fset.Position(object.Pos())))
		} else {
			if meth := findMethodWithGivenReceiver(object); meth != nil {
				// associate method receiver objects to special keys, because those can be
				// referenced from other files via their method
				methlbl, _ := l.MethodID(meth, getTypeLabel())
				label, _ = l.ReceiverObjectID(object, methlbl)
			} else {
				scopeLbl := l.ScopeID(scope, object.Pkg())
				label = l.GlobalID(fmt.Sprintf("{%v},%s;object", scopeLbl, object.Name()))
			}
		}
		l.objectLabels[object] = label
	}
	return label, exists
}

// findMethodWithGivenReceiver finds a method with `object` as its receiver, if one exists
func findMethodWithGivenReceiver(object types.Object) *types.Func {
	meth := findMethodOnTypeWithGivenReceiver(object.Type(), object)
	if meth != nil {
		return meth
	}
	if pointerType, ok := object.Type().(*types.Pointer); ok {
		meth = findMethodOnTypeWithGivenReceiver(pointerType.Elem(), object)
	}
	return meth
}

// findMethodWithGivenReceiver finds a method on type `tp` with `object` as its receiver, if one exists
func findMethodOnTypeWithGivenReceiver(tp types.Type, object types.Object) *types.Func {
	if namedType, ok := tp.(*types.Named); ok {
		for i := 0; i < namedType.NumMethods(); i++ {
			meth := namedType.Method(i)
			if object == meth.Type().(*types.Signature).Recv() {
				return meth
			}
		}
	}
	return nil
}

// ReceiverObjectID associates a label with the given object and returns it, together with a flag indicating whether
// the object already had a label associated with it; the object must be the receiver of `methlbl`, since that label
// is used to construct the label of the object
func (l *Labeler) ReceiverObjectID(object types.Object, methlbl Label) (Label, bool) {
	label, exists := l.objectLabels[object]
	if !exists {
		// if we can't, construct a special label
		label = l.GlobalID(fmt.Sprintf("{%v},%s;receiver", methlbl, object.Name()))
		l.objectLabels[object] = label
	}
	return label, exists
}

// FieldID associates a label with the given field and returns it, together with
// a flag indicating whether the field already had a label associated with it;
// the field must belong to `structlbl`, since that label is used to construct
// the label of the field. When the field name is the blank identifier `_`,
// `idx` is used to generate a unique name.
func (l *Labeler) FieldID(field *types.Var, idx int, structlbl Label) (Label, bool) {
	label, exists := l.objectLabels[field]
	if !exists {
		name := field.Name()
		// there can be multiple fields with the blank identifier, so use index to
		// distinguish them
		if field.Name() == "_" {
			name = fmt.Sprintf("_%d", idx)
		}
		label = l.GlobalID(fmt.Sprintf("{%v},%s;field", structlbl, name))
		l.objectLabels[field] = label
	}
	return label, exists
}

// MethodID associates a label with the given method and returns it, together with a flag indicating whether
// the method already had a label associated with it; the method must belong to `recvtyplbl`, since that label
// is used to construct the label of the method
func (l *Labeler) MethodID(method types.Object, recvtyplbl Label) (Label, bool) {
	label, exists := l.objectLabels[method]
	if !exists {
		label = l.GlobalID(fmt.Sprintf("{%v},%s;method", recvtyplbl, method.Name()))
		l.objectLabels[method] = label
	}
	return label, exists
}
