#use "interpreter.ml";;

let a = Apply(FunExpr(LetIn(Decl(Var("f"), Atom(AnonFun(Var ("x"), Apply(FunExpr(Sym(Var("f"))), [Apply(Uop(Neg), [Sym(Var("x"))])])))), Sym(Var("f")))), [Atom(Int(1))]);;

let result = (eval emptyenv) a;;

print_simple_type result;;