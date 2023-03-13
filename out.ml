#use "interpreter.ml";;

let a = LetIn(Decl(Var("x"), Atom(Int(5))), LetIn(Decl(Var("y"), Atom(AnonFun(Var ("x"), Apply(Nop(Mul), [Sym(Var("x")) ; Sym(Var("x"))])))), Apply(Nop(Add), [Apply(FunExpr(Sym(Var("y"))), [Atom(Int(2))]) ; Sym(Var("x"))])));;

let result = (eval emptyenv) a;;

print_simple_type result;;