#use "interpreter.ml";;

let a = Apply(Lambda(Var("x"), Apply(Nop(Mul), [Apply(Uop(Neg), [Apply(Nop(Add), [Sym(Var("x")) ; Sym(Var("x")) ; Apply(Uop(Neg), [Atom(Int(2))])])]) ; Apply(Nop(Add), [Sym(Var("x")) ; Sym(Var("x"))])])), [Atom(Int(5))]);;

let result = (eval emptyenv) a;;

print_simple_type result;;