type noper = Add | Mul
type uoper = Neg


type identifier = Var of string 

type env = identifier -> simple_type
and  simple_type = Int of int | Unbound | Closure of identifier * expr * env | AnonFun of identifier * expr
and  func = Nop of noper | Uop of uoper | Lambda of identifier * expr | FunExpr of expr
and  expr  = Atom of simple_type | Apply of func * (expr list) | Sym of identifier




let rec add_integers lis = match lis with
    | [] -> Int(0)
    | Int(n) :: lis1 -> (match add_integers lis1 with Int(n1) -> Int(n + n1)
                            | _ -> failwith ("error in add_integers") )
    | _ -> failwith("type error in add_integers")
    
    
let rec multiply_integers lis = match lis with
    | [] -> Int(0)
    | Int(n) :: lis1 -> (match add_integers lis1 with Int(n1) -> Int(n * n1)
                            | _ -> failwith ("error in multiply_integers"))
    | _ -> failwith("type error in multiply_integers")
    
let negate_int lis = match lis with
    | [] -> failwith("error in negate_int; no arguments were given")
    | Int(n) :: lis1 -> (match lis1 with
                        | [] -> Int(-n)
                        | _ -> failwith ("error in negate_int; too many arguments were given")
                        )
    | _ -> failwith("type error in negate_int")
    

(* Environment *)
let emptyenv = fun x -> Unbound

let bind (iden, value, old_env) = fun x -> if (x = iden) then value else old_env(x)

(* Expression evalutaion *)

let rec eval env x = match x with
    | Atom (a) -> (match a with
                    | AnonFun (id, x) -> Closure (id, x, env)
                    | _ -> a )
    | Apply (func, lis) -> (match func with 
        | Nop (op)  -> (match op with
            | Add   -> add_integers(List.map (eval env) lis )
            | Mul   -> multiply_integers(List.map (eval env) lis)
            )
        | Uop (op)  -> (match op with
            | Neg   -> negate_int (List.map (eval env) lis)
            )
            
        | Lambda (x, e) -> (if List.length(lis) = 1 then
                                let new_env = (bind (x, (eval env)(List.hd(lis)), env)) in (eval new_env e)
                            else failwith ("non-unary function found"))

        | FunExpr (e)   -> (match ((eval env) e) with
                            | Closure (x, e1, env1) -> ((eval env1) (Apply((Lambda (x, e1)) , lis)))
                            | _ -> failwith ("type error, closure expected"))
        
(*         | _ -> failwith ("error in eval") *)
        
        )
    | Sym x -> match x with Var(v) -> eval env (Atom (env (x)))

    
    
let print_simple_type x = match x with
    | Int n   -> print_string ((string_of_int n) ^ "\n" )
    | Unbound -> print_string ("unbound\n" )
    | AnonFun _ -> print_string("function\n")
    | Closure _ -> print_string ("closure\n" )

(* (lam (x) . (+ (x, x)))(5) *)

let x = Apply(FunExpr(Sym(Var("f"))), [Atom(AnonFun(Var ("x"), Atom(Int(1))))])


(* eval emptyenv x ;; *)

