#use "interpreter.ml";;

let a = Apply(FunExpr(LetIn(Decl(Var("f"), Atom(AnonFun(Var ("x"), Apply(FunExpr(Sym(Var("f"))), [Apply(Nop(Mul), [Sym(Var("x")) ; Apply(Nop(Add), [Atom(Int(1)) ; Sym(Var("x"))])])])))), Sym(Var("f")))), [Atom(Int(1))]);;

let result = (eval emptyenv) a;;

print_simple_type result;;