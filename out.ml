#use "interpreter.ml";;

let a = Apply(FunExpr(Apply(Lambda(Var("x"), Atom(AnonFun(Var ("y"), Apply(Nop(Add), [Sym(Var("x")) ; Sym(Var("y"))])))), [Atom(Int(4))])), [Atom(Int(1))]);;

let result = (eval emptyenv) a;;

print_simple_type result;;