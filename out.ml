#use "./source/interpreter.ml";;

let a = LetIn(Decl(Var("lis"), Atom(MyList([Atom(Int(1)) ; Atom(Int(2)) ; Atom(Int(3)) ; Atom(Int(4)) ; Atom(Int(5)) ; Atom(Int(6))]))), Unpack([Var("a") ; Var("b") ; Var("c")], Some(Var("rest")), Sym(Var("lis")), Sym(Var("rest"))));;

let result = (eval emptyenv) a;;

print_simple_type result;;