#use "interpreter.ml";;

let a = LetIn(Decl(Var("negOneToThe"), Atom(AnonFun(Var ("x"), IfThenElse(Apply(Nop(Equals), [Sym(Var("x")) ; Atom(Int(0))]), Atom(Int(1)), Apply(Nop(Mul), [Apply(Uop(Neg), [Atom(Int(1))]) ; Apply(FunExpr(Sym(Var("negOneToThe"))), [Apply(Nop(Add), [Sym(Var("x")) ; Apply(Uop(Neg), [Atom(Int(1))])])])]))))), LetIn(Decl(Var("pi"), Atom(AnonFun(Var ("x"), IfThenElse(Apply(Nop(Less), [Sym(Var("x")) ; Atom(Int(1000))]), Apply(Nop(Add), [Apply(FunExpr(Sym(Var("pi"))), [Apply(Nop(Add), [Atom(Int(1)) ; Sym(Var("x"))])]) ; Apply(Nop(Mul), [Apply(Uop(Neg), [Apply(FunExpr(Sym(Var("negOneToThe"))), [Sym(Var("x"))])]) ; Apply(Nop(Div), [Atom(Int(10000000)) ; Apply(Nop(Add), [Apply(Nop(Mul), [Atom(Int(2)) ; Sym(Var("x"))]) ; Apply(Uop(Neg), [Atom(Int(1))])])])])]), Atom(Int(0)))))), Apply(Nop(Mul), [Apply(FunExpr(Sym(Var("pi"))), [Atom(Int(1))]) ; Atom(Int(4))])));;

let result = (eval emptyenv) a;;

print_simple_type result;;