#use "interpreter.ml";;

let a = Apply(FunExpr(Sym(Var("f"))), [Atom(Int(8))]);;

let result = (eval emptyenv) a;;

print_simple_type result;;