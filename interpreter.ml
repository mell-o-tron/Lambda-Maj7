type noper = Add | Mul
type uoper = Neg


type identifier = Var of string 

type func = Nop of noper | Uop of uoper | Lambda of identifier * expr
and  expr  = Atom of simple_type | Apply of func * (expr list) | Sym of identifier
and simple_type = Int of int | Unbound
type env = identifier -> simple_type


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
let emptyenv = fun x -> Atom(Unbound)

let bind (iden, value, old_env) = fun x -> if (x = iden) then value else old_env(x)

(* Expression evalutaion *)

let rec eval env x = match x with
    | Atom (a) -> a
    | Apply (func, lis) -> (match func with 
        | Nop (op) -> (match op with
            | Add -> add_integers(List.map (eval env) lis )
            | Mul -> multiply_integers(List.map (eval env) lis)
            )
        | Uop (op) -> (match op with
            | Neg -> negate_int (List.map (eval env) lis)
            )
            
        | Lambda (x, e) -> (if List.length(lis) = 1 then
                                let new_env = (bind (x, List.hd(lis), env)) in (eval new_env e)
                            else failwith ("non-unary function found"))
        
            
(*         | _ -> failwith ("error in eval") *)
        
        )
    | Sym x -> match x with Var(v) -> eval env (env (x))

    
    
let print_simple_type x = match x with
    | Int n   -> print_string ((string_of_int n) ^ "\n" )
    | Unbound ->print_string ("unbound\n" )

(* (lam (x) . (+ (x, x)))(5) *)

let x = Apply (Lambda (Var ("x"), Apply(Nop(Add), [Sym(Var("x")); Sym(Var("x"))])), [Atom(Int(5))])

(* eval emptyenv x ;; *)

