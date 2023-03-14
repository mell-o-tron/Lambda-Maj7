type noper = Add | Mul
type uoper = Neg


type identifier = Var of string 

type env = identifier -> simple_type
and  simple_type = Int of int | Unbound | Closure of identifier * expr * env | AnonFun of identifier * expr | RecClosure of identifier * identifier * expr * env
and  func = Nop of noper | Uop of uoper | Lambda of identifier * expr | FunExpr of expr
and  expr = Atom of simple_type | Apply of func * (expr list) | Sym of identifier | LetIn of decl * expr
and  decl = Decl of identifier * expr





let rec add_integers lis = match lis with
    | [] -> Int(0)
    | Int(n) :: lis1 -> (match add_integers lis1 with Int(n1) -> Int(n + n1)
                            | _ -> failwith ("error in add_integers") )
    | Unbound :: _  -> failwith("type error in add_integers; unbound variable found")
    | _ -> failwith("type error in add_integers")
    
    
let rec multiply_integers lis = match lis with
    | [] -> Int(0)
    | Int(n) :: lis1 -> (match add_integers lis1 with Int(n1) -> Int(n * n1)
                            | _ -> failwith ("error in multiply_integers"))
    | Unbound :: _  -> failwith("type error in multiply_integers; unbound variable found")
    | _ -> failwith("type error in multiply_integers")
    
let negate_int lis = match lis with
    | [] -> failwith("error in negate_int; no arguments were given")
    | Int(n) :: lis1 -> (match lis1 with
                        | [] -> Int(-n)
                        | _ -> failwith ("error in negate_int; too many arguments were given")
                        )
    | Unbound :: _  -> failwith("type error in negate_int; unbound variable found")
    | _ -> failwith("type error in negate_int")
    

(* Environment *)
let emptyenv = fun x -> (match x with Var (name) -> print_string (name ^ " is unbound\n"));
                        Unbound

let bind (iden, value, old_env) = fun x -> if (x = iden) then value else old_env(x)



let print_simple_type x = match x with
    | Int n   -> print_string ((string_of_int n) ^ "\n" )
    | Unbound -> print_string ("unbound\n" )
    | AnonFun _ -> print_string("function\n")
    | Closure _ -> print_string ("closure\n" )
    | RecClosure _ -> print_string ("recursive closure\n" )



(* Expression evalutaion *)

let rec eval env x = 
(*
print_simple_type (env (Var("x")));*)

match x with
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
            
        | Lambda (x, e) ->  (*print_string "Applying lambda...\n";*)
                            (if List.length(lis) = 1 then
                                let arg_value = (eval env)(List.hd(lis)) in
                                (*(match x with Var (name) -> print_string (name ^ " = "));*)           (* DEBUG *)
                                print_simple_type (arg_value);                                          (* DEBUG *)
                                let new_env = (bind (x, arg_value, env)) in 
                                ((eval new_env) e)
                            else failwith ("non-unary function found"))

        | FunExpr (e)   -> let e_evald = ((eval env) e) in
                            (match e_evald with
                            | Closure (x, e1, env1) -> ((eval env1) (Apply((Lambda (x, e1)) , lis)))
                            | RecClosure (n, x, e1, env1) -> 
                                    
                                    (*(match n with Var (name) -> print_string (name ^ "("));*)        (* DEBUG *)
                                    (*(match x with Var (name) -> print_string (name ^ ")\n"));*)
                                    let env1_with_arg = bind (x, env(x), env1) in
                                    let env_rec = bind( n, e_evald, env1_with_arg ) in
                                    ((eval env_rec) (Apply((Lambda (x, e1)) , lis)))
                                    
                            | Unbound -> failwith ("type error, closure expected and unbound found")
                            | _ -> failwith ("type error, closure expected"))
        
        
(*         | _ -> failwith ("error in eval") *)
        
        )
    | Sym x -> (match x with Var(v) -> eval env (Atom (env (x))))
    | LetIn (d, e)  -> (match d with
                        | Decl(x, e1) ->    let e1_evald = (eval env) e1 in
                                            (match e1_evald with
                                            | Closure (xc, ec, envc) ->
                                            
                                                let new_env = bind(x, RecClosure (x, xc, ec, envc), env)
                                                   in (eval new_env) e
                                                   
                                            | _ -> let new_env = bind(x, e1_evald, env)
                                                   in (eval new_env) e
                                            )
                                            
                        )
    
    

(* (lam (x) . (+ (x, x)))(5) *)

let x = LetIn(Decl(Var("x"), Atom(Int(5))), Sym(Var("x")))


(* eval emptyenv x ;; *)

