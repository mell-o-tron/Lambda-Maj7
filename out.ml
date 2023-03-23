#use "./source/interpreter.ml";;

let a = LetIn(Decl(Var("tuple_test"), Atom(Tuple([Atom(Int(1)) ; Atom(Int(2)) ; Atom(Int(3))]))), Apply(Nop(Add), [Apply(Nop(Elem), [Sym(Var("tuple_test")) ; Atom(Int(1))]) ; Atom(Int(5))]));;

let result = (eval emptyenv) a;;

print_simple_type result;;