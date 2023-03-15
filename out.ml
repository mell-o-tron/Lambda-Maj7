#use "interpreter.ml";;

let a = LetIn(Decl(Var("x_banana"), Atom(Bool(false))), IfThenElse(Apply(Nop(Equals), [Sym(Var("x_banana")) ; Atom(Bool(false))]), Atom(Int(1)), Atom(Int(2))));;

let result = (eval emptyenv) a;;

print_simple_type result;;