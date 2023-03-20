#use "./source/interpreter.ml";;

let a = LetIn(Decl(Var("x_banana"), Atom(Bool(false))), LetIn(Decl(Var("x_super_banana"), IfThenElse(Apply(Nop(Equals), [Sym(Var("x_banana")) ; Sym(Var("fale"))]), Apply(Nop(Add), [Atom(Int(1)) ; Apply(Nop(Mul), [Atom(Int(3)) ; Atom(Int(5))])]), Atom(Int(2)))), Apply(Nop(ListConcat), [Atom(MyList([Atom(Int(1))])) ; Atom(MyList([Sym(Var("x_super_banana"))]))])));;

let result = (eval emptyenv) a;;

print_simple_type result;;