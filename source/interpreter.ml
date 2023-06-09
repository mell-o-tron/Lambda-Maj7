type noper = Add | Mul | Div | And | Or | Equals | Greater | GreaterEq | Less | LessEq | ListConcat | Elem
type uoper = Neg | Not | Empty


type identifier = Var of string 

type env = identifier -> simple_type
and  simple_type = Int of int | Unbound of string | Closure of identifier * expr * env | AnonFun of identifier * expr | RecClosure of identifier * identifier * expr * env | Bool of bool | MyList of (expr list) | Tuple of (expr list) | Float of float
and  func = Nop of noper | Uop of uoper | Lambda of identifier * expr | FunExpr of expr
and  expr = Atom of simple_type | Apply of func * (expr list) | Sym of identifier | LetIn of decl * expr | IfThenElse of expr * expr * expr | Unpack of (identifier list * (identifier option) * expr * expr)
and  decl = Decl of identifier * expr



(* Conversions, printing *)

let rec string_of_simple_type x = (match x with
    | Int n   -> (string_of_int n)
    | Unbound s -> "unbound '" ^ s ^ "'"
    | AnonFun _ -> "function"
    | Closure _ -> "closure"
    | RecClosure _ -> "recursive closure"
    | Bool b    -> if b then ("true") else ("false")
    | MyList lis  -> "[" ^ string_of_list lis ^ "]"
    | Tuple  lis  -> "(" ^ string_of_list lis ^ ")"
    | Float f   -> (string_of_float f)
)

and string_of_list lis = (match lis with 
    | [] -> ""
    | a :: [] -> ( match a with Atom (a) -> (string_of_simple_type a)
                    | _ -> "list is not fully evalued"
      )
    | a :: lis1 -> ( match a with Atom (a) -> (string_of_simple_type a) ^ ", " ^ string_of_list lis1
                    | _ -> "list is not fully evalued"
    )
)

let print_simple_type x = print_string ((string_of_simple_type x) ^ "\n")

let rec expr_list_of_simple_type_list (lis : simple_type list) = match lis with
    | [] -> []
    | a :: lis1-> [Atom (a)] @ expr_list_of_simple_type_list lis1




(* FLOAT OPERATIONS *)

let rec add_floats lis = match lis with
    | [] -> Float(0.)
    | Float(n) :: lis1 -> (match add_floats lis1 with Float(n1) -> Float(n +. n1)
                            | _ -> failwith ("error in add_floats") )
    | Unbound s :: _  -> failwith("type error in add_floats; unbound variable '" ^ s ^ "' found")
    | _ -> failwith("type error in add_floats")


let rec multiply_floats lis = match lis with
    | [] -> Float(1.)
    | Float(n) :: lis1 -> (match multiply_floats lis1 with Float(n1) -> Float(n *. n1)
                            | _ -> failwith ("error in multiply_floats"))
    | Unbound s :: _  -> failwith("type error in multiply_floats; unbound variable '" ^ s ^ "' found")
    | _ -> failwith("type error in multiply_floats")

let rec divide_floats lis = match lis with
    | [] -> Float(1.0)
    | Float(a) :: lis1 -> (match lis1 with
                            | [] ->  failwith("type error in divide_floats; two args expected")
                            | Float(b) :: [] -> if b = 0.0 then failwith("division by zero")
                                              else Float (a /. b)

                            | Float(_) :: _  -> failwith("type error in divide_floats; two args expected")
                            | _ -> failwith("type error in divide_floats"))

    | Unbound s :: _  -> failwith("type error in divide_floats; unbound variable '" ^ s ^ "' found")
    | _ -> failwith("type error in divide_floats")

let negate_float lis = match lis with
    | [] -> failwith("error in negate_float; no arguments were given")
    | Float(n) :: lis1 -> (match lis1 with
                        | [] -> Float(-.n)
                        | _ -> failwith ("error in negate_float; too many arguments were given")
                        )
    | Unbound s :: _  -> failwith("type error in negate_float; unbound variable '" ^ s ^ "' found")
    | _ -> failwith("type error in negate_float")

(* INTEGER OPERATIONS *)

let rec add_integers lis = match lis with
    | [] -> Int(0)
    | Int(n) :: lis1 -> (match add_integers lis1 with Int(n1) -> Int(n + n1)
                            | _ -> failwith ("error in add_integers") )
    | Unbound s :: _  -> failwith("type error in add_integers; unbound variable '" ^ s ^ "' found")
    | _ -> failwith("type error in add_integers")
    
    
let rec multiply_integers lis = match lis with
    | [] -> Int(1)
    | Int(n) :: lis1 -> (match multiply_integers lis1 with Int(n1) -> Int(n * n1)
                            | _ -> failwith ("error in multiply_integers"))
    | Unbound s :: _  -> failwith("type error in multiply_integers; unbound variable '" ^ s ^ "' found")
    | _ -> failwith("type error in multiply_integers")
    
let rec divide_integers lis = match lis with
    | [] -> Int(1)
    | Int(a) :: lis1 -> (match lis1 with 
                            | [] ->  failwith("type error in divide_integers; two args expected")
                            | Int(b) :: [] -> if b = 0 then failwith("division by zero") 
                                              else Int (a / b)
                                              
                            | Int(_) :: _  -> failwith("type error in divide_integers; two args expected")
                            | _ -> failwith("type error in divide_integers"))
                            
    | Unbound s :: _  -> failwith("type error in divide_integers; unbound variable '" ^ s ^ "' found")
    | _ -> failwith("type error in divide_integers")
    
    
    
let negate_int lis = match lis with
    | [] -> failwith("error in negate_int; no arguments were given")
    | Int(n) :: lis1 -> (match lis1 with
                        | [] -> Int(-n)
                        | _ -> failwith ("error in negate_int; too many arguments were given")
                        )
    | Unbound s :: _  -> failwith("type error in negate_int; unbound variable '" ^ s ^ "' found")
    | _ -> failwith("type error in negate_int")
    
    



(* BOOLEAN OPERATIONS *)
    
    
let rec or_bool lis = match lis with
    | [] -> Bool(false)
    | Bool(b) :: lis1 -> if b then Bool(true) else (or_bool lis1)
   | Unbound s :: _  -> failwith("type error in or_bool; unbound variable '" ^ s ^ "' found")
    | _ -> failwith("type error in or_bool")
    
    
let rec and_bool lis = match lis with
    | [] -> Bool(true)
    | Bool(b) :: lis1 -> if b then (and_bool lis1) else Bool(false) 
    | Unbound s :: _  -> failwith("type error in and_bool; unbound variable '" ^ s ^ "' found")
    | _ -> failwith("type error in and_bool")
    
let negate_bool lis = match lis with
    | [] -> failwith("error in negate_bool; no arguments were given")
    | Bool(b) :: lis1 -> (match lis1 with
                        | [] -> Bool(not b)
                        | _ -> failwith ("error in negate_bool; too many arguments were given")
                        )
    | Unbound s :: _  -> failwith("type error in negate_bool; unbound variable '" ^ s ^ "' found")
    | _ -> failwith("type error in negate_bool")
    
    
    
(* LIST OPERATIONS *)
    
let rec list_concat lis = match lis with
    | [] -> MyList([])
    | MyList(l) :: lis1 -> (match (list_concat lis1) with
                            | MyList(l1) ->  MyList (l @ l1)
                            | _ -> failwith("type error in list_concat"))

    | Unbound s :: _  -> failwith("type error in list_concat; unbound variable '" ^ s ^ "' found")
    | _ -> failwith("type error in list_concat")

let rec is_empty lis = (match lis with
    | MyList ([])::[]   -> Bool(true)
    | MyList (_)::[]    -> Bool(false)
    | x :: _            -> failwith("type error in is_empty: " ^ string_of_simple_type x)
    | []                -> failwith("type error in is_empty: no arguments provided")
)

(* TUPLE OPERATIONS *)

let get_tuple_element lis = 
    let rec aux tup i orig_tuple = (match tup with
        | [] -> failwith ("Tuple '" ^ (string_of_simple_type orig_tuple) ^ "' has no " ^ (string_of_int i) ^ "th element" )
        | e :: tup1 -> if i = 0 then (match e with 
                                        | Atom(e1) -> e1 
                                        | _ -> failwith ("type error in get_tuple_element"))
                                else (aux tup1 (i - 1) orig_tuple))
    in match lis with
        | a::(b::[]) -> (match a, b with
                        | Tuple(t), Int(n)  -> if n >= 0 then (aux t n a) else failwith ("elem index should be positive")
                        |  _ -> failwith ("type error in get_tuple_element")
                      ) 
        | _ -> failwith ("type error in get_tuple_element")


(* GENERIC OPERATIONS *)

let rec equals_generic lis = (match lis with
    | [] -> Bool(true)
    | Int(a) :: lis1 -> (match lis1 with
                            | [] -> Bool(true)
                            | Int(b) :: [] -> Bool (a = b)
                            | Int(_) :: _  -> failwith("type error in equals_generic; two args max expected")
                            | _ -> failwith("type error in equals_generic"))

    | Bool(a) :: lis1 -> (match lis1 with
                            | [] -> Bool(true)
                            | Bool(b) :: [] -> Bool (a = b)
                            | Bool(_) :: _  -> failwith("type error in equals_generic; two args max expected")
                            | _ -> failwith("type error in equals_generic"))

    | Unbound s :: _  -> failwith("type error in equals_generic; unbound variable '" ^ s ^ "' found")
    | _ -> failwith("type error in equals_generic"))


let add_generic lis = match lis with
    | [] -> Int(0)
    | Float(n) :: _ -> add_floats lis
    | Int(n) :: _ -> add_integers lis
    | Unbound s :: _  -> failwith("type error in add_generic; unbound variable '" ^ s ^ "' found")
    | _ -> failwith("type error in add_generic")


let multiply_generic lis = match lis with
    | [] -> Int(1)
    | Float(n) :: _ -> multiply_floats lis
    | Int(n) :: _ -> multiply_integers lis
    | Unbound s :: _  -> failwith("type error in multiply_generic; unbound variable '" ^ s ^ "' found")
    | _ -> failwith("type error in multiply_generic")

let divide_generic lis = match lis with
    | [] -> Int(1)
    | Float(n) :: _ -> divide_floats lis
    | Int(n) :: _ -> divide_integers lis
    | Unbound s :: _  -> failwith("type error in divide_floats; unbound variable '" ^ s ^ "' found")
    | _ -> failwith("type error in divide_floats")

let negate_generic lis = match lis with
    | [] -> failwith("no arguments found in negate_generic")
    | Float(n) :: _ -> negate_float lis
    | Int(n) :: _ -> negate_int lis
    | Unbound s :: _  -> failwith("type error in negate_generic; unbound variable '" ^ s ^ "' found")
    | _ -> failwith("type error in negate_generic")

let rec greater_generic lis = (match lis with
    | [] -> Bool(true)
    | Int(a) :: lis1 -> (match lis1 with
                            | [] -> Bool(true)
                            | Int(b) :: [] -> Bool (a > b)
                            | Int(_) :: _  -> failwith("type error in greater_generic; two args max expected")
                            | _ -> failwith("type error in greater_generic"))
    | Float(a) :: lis1 -> (match lis1 with
                            | [] -> Bool(true)
                            | Float(b) :: [] -> Bool (a > b)
                            | Float(_) :: _  -> failwith("type error in greater_generic; two args max expected")
                            | _ -> failwith("type error in greater_generic"))


    | Unbound s :: _  -> failwith("type error in greater_generic; unbound variable '" ^ s ^ "' found")
    | _ -> failwith("type error in greater_generic"))


let rec less_generic lis = (match lis with
    | [] -> Bool(true)
    | Int(a) :: lis1 -> (match lis1 with
                            | [] -> Bool(true)
                            | Int(b) :: [] -> Bool (a < b)
                            | Int(_) :: _  -> failwith("type error in less_generic; two args max expected")
                            | _ -> failwith("type error in less_generic"))

    | Float(a) :: lis1 -> (match lis1 with
                            | [] -> Bool(true)
                            | Float(b) :: [] -> Bool (a < b)
                            | Float(_) :: _  -> failwith("type error in less_generic; two args max expected")
                            | _ -> failwith("type error in less_generic"))


    | Unbound s :: _  -> failwith("type error in less_generic; unbound variable '" ^ s ^ "' found")
    | _ -> failwith("type error in less_generic"))

let rec greater_eq_generic lis = (match lis with
    | [] -> Bool(true)
    | Int(a) :: lis1 -> (match lis1 with
                            | [] -> Bool(true)
                            | Int(b) :: [] -> Bool (a >= b)
                            | Int(_) :: _  -> failwith("type error in greater_eq_generic; two args max expected")
                            | _ -> failwith("type error in greater_eq_generic"))

    | Float(a) :: lis1 -> (match lis1 with
                            | [] -> Bool(true)
                            | Float(b) :: [] -> Bool (a >= b)
                            | Float(_) :: _  -> failwith("type error in greater_eq_generic; two args max expected")
                            | _ -> failwith("type error in greater_eq_generic"))


    | Unbound s :: _  -> failwith("type error in greater_eq_generic; unbound variable '" ^ s ^ "' found")
    | _ -> failwith("type error in greater_eq_generic"))


let rec less_eq_generic lis = (match lis with
    | [] -> Bool(true)
    | Int(a) :: lis1 -> (match lis1 with
                            | [] -> Bool(true)
                            | Int(b) :: [] -> Bool (a <= b)
                            | Int(_) :: _  -> failwith("type error in less_eq_generic; two args max expected")
                            | _ -> failwith("type error in less_eq_generic"))

    | Float(a) :: lis1 -> (match lis1 with
                            | [] -> Bool(true)
                            | Float(b) :: [] -> Bool (a <= b)
                            | Float(_) :: _  -> failwith("type error in less_eq_generic; two args max expected")
                            | _ -> failwith("type error in less_eq_generic"))


    | Unbound s :: _  -> failwith("type error in less_eq_generic; unbound variable '" ^ s ^ "' found")
    | _ -> failwith("type error in less_eq_generic"))
    
(* Environment *)
let emptyenv = fun x -> (match x with Var (name) -> Unbound name)

let bind (iden, value, old_env) = fun x -> if (x = iden) then value else old_env(x)



(* Expression evalutaion *)

let rec eval env x = 
(*
print_simple_type (env (Var("x")));*)

match x with
    | Atom (a) -> (match a with
                    | AnonFun (id, x) -> Closure (id, x, env)
                    | MyList l -> MyList (expr_list_of_simple_type_list (List.map (eval env) l))
                    | Tuple t  -> Tuple(expr_list_of_simple_type_list (List.map (eval env) t))
                    | _ -> a )
                    
    | Apply (func, lis)  ->
    (match func with
        | Nop (op)       -> (match op with
            | Add        -> add_generic(List.map (eval env) lis )
            | Mul        -> multiply_generic(List.map (eval env) lis)
            | Div        -> divide_generic(List.map (eval env) lis)
            | Or         -> or_bool (List.map (eval env) lis)
            | And        -> and_bool (List.map (eval env) lis)
            | Equals     -> equals_generic (List.map (eval env) lis)
            | Greater    -> greater_generic   (List.map (eval env) lis)
            | Less       -> less_generic      (List.map (eval env) lis)
            | GreaterEq  -> greater_eq_generic(List.map (eval env) lis)
            | LessEq     -> less_eq_generic   (List.map (eval env) lis)
            | ListConcat -> list_concat   (List.map (eval env) lis)
            | Elem       -> get_tuple_element (List.map (eval env) lis)
            
            )
        | Uop (op)  -> (match op with
            | Neg   -> negate_generic (List.map (eval env) lis)
            | Not   -> negate_bool (List.map (eval env) lis)
            | Empty -> is_empty (List.map (eval env) lis)
            )
            
        | Lambda (x, e) ->  (*print_string "Applying lambda...\n";*)
                            (if List.length(lis) = 1 then
                                let arg_value = (eval env)(List.hd(lis)) in
                                (*(match x with Var (name) -> print_string (name ^ " = "));*)           (* DEBUG *)
                                (*print_simple_type (arg_value);*)                                          (* DEBUG *)
                                let new_env = (bind (x, arg_value, env)) in 
                                ((eval new_env) e)
                            else failwith ("non-unary function found"))

        | FunExpr (e)   -> let e_evald = ((eval env) e) in
                            let arg_value = (eval env)(List.hd(lis)) in
                            (match e_evald with

                            | Closure (x, e1, env1) -> ((eval env1) (Apply((Lambda (x, e1)) , [Atom(arg_value)]))) (* eager evaluation of the argument *)
                                                   (* might extend this to recclosures *)
                            | RecClosure (n, x, e1, env1) -> 

                                    (*(match n with Var (name) -> print_string (name ^ "("));*)        (* DEBUG *)
                                    (*(match x with Var (name) -> print_string (name ^ ")\n"));*)
                                    (*
                                        SCOPING NOTE
                                            Since i'm currently using lazy evaluation of identifiers, and since I'm lazy myself and can't be bothered to manage each and every case for recursive closures, I decided that, at least for now, recursive closures shall have dynamic scoping.
                                    
                                            The following two lines enable static scoping, uncomment them and comment the following at your own risk.
                                    *)
                                    (*let env1_with_arg = bind (x, env(x), env1) in*)
                                    (*let env_rec = bind( n, e_evald, env1_with_arg ) in*)
                                    let env_rec = bind( n, e_evald, env ) in
                                    ((eval env_rec) (Apply((Lambda (x, e1)) , lis)))
                                    
                            | Unbound s -> failwith ("type error, closure expected and unbound variable '" ^ s ^ "' found")
                            | _ -> failwith ("type error, closure expected"))
        
        
(*         | _ -> failwith ("error in eval") *)
        
        )
    | Sym x -> (match x with Var(v) -> eval env (Atom (env (x))))
    | LetIn (d, e)  -> (match d with
                        | Decl(x, e1) ->    let e1_evald = (eval env) e1 in
                                            (match e1_evald with
                                            | Closure (xc, ec, envc) ->
                                                let new_env = bind(x, RecClosure (x, xc, ec, envc), env) in
                                                (eval new_env) e
                                                   
                                            | _ -> let new_env = bind(x, e1_evald, env)
                                                   in (eval new_env) e
                                            )
                                            
                        )
    | IfThenElse (e1, e2, e3) -> (match ((eval env) e1) with 
                        
                        | Bool(b) -> if b then ((eval env) e2) else ((eval env) e3)
                        | _ -> failwith ("type error, boolean expected")
                        )
    
    | Unpack (lis, rest, e1, e) -> ( match eval env e1 with 
                                        | MyList(expr_list) -> (match List.length(lis), List.length(expr_list), rest with
                                                | m, n, None -> if m = n then
                                                    let rec bindAll ides values old_env = (match ides, values with
                                                        | [], []           -> old_env
                                                        | a :: l1, b :: l2 -> bindAll l1 l2 (bind (a, b, old_env) )
                                                        | _ -> failwith ("somwthing went wrong while unpacking")
                                                    
                                                    ) in let values = (List.map (eval env) expr_list)
                                                    in eval (bindAll lis values env) e
                                                    else failwith("Number of elements not matching in unpacking")
                                                    
                                                | m, n, Some l -> if m <= n then 
                                                    let rec bindSome ides values old_env = (match ides, values with
                                                        | [], rest           -> old_env, rest
                                                        | a :: l1, b :: l2 -> bindSome l1 l2 (bind (a, b, old_env) )
                                                        | _ -> failwith ("somwthing went wrong while unpacking")
                                                    
                                                    ) in let values = (List.map (eval env) expr_list)
                                                    in (match (bindSome lis values env) with
                                                        | env1, rest -> let expr_rest = expr_list_of_simple_type_list rest in
                                                                        let env_with_rest = bind (l, MyList(expr_rest), env1)
                                                                        in eval env_with_rest e
                                                       )
                                                    else failwith ("Too many variables (" ^ (string_of_int m) ^ ") for " ^ (string_of_int n) ^ " elements")
                                                    
                                             )
                                        | _ -> failwith ("Type error: can only unpack list")
    
                                    )
    



(*let x = Apply(Uop(Empty), [Atom(MyList([]))]);;

 print_simple_type ( eval emptyenv x );; *)
(* eval emptyenv x ;; *)

