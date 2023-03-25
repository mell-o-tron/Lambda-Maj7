#use "./source/interpreter.ml";;

let a = Apply(FunExpr(LetIn(Decl(Var("reverse"), Atom(AnonFun(Var ("lis"), IfThenElse(Apply(Uop(Empty), [Sym(Var("lis"))]), Atom(MyList([])), Unpack([Var("a")], Some(Var("rest")), Sym(Var("lis")), Apply(Nop(ListConcat), [Apply(FunExpr(Sym(Var("reverse"))), [Sym(Var("rest"))]) ; Atom(MyList([Sym(Var("a"))]))])))))), Sym(Var("reverse")))), [Atom(MyList([Atom(Int(1)) ; Atom(Int(3)) ; Atom(Int(5)) ; Atom(Int(7))]))]);;

let result = (eval emptyenv) a;;

print_simple_type result;;