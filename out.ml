#use "./source/interpreter.ml";;

let a = LetIn(Decl(Var("x_banana"), Atom(Bool(false))), IfThenElse(Apply(Nop(Equals), [Sym(Var("x_banana")) ; Atom(Bool(false))]), Apply(Nop(Add), [Atom(Int(1)) ; Apply(Nop(Mul), [Atom(Int(3)) ; Atom(Int(5))])]), Atom(Int(2))));;

let result = (eval emptyenv) a;;

print_simple_type result;;