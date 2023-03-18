import sys

from lark import Lark


def Token (t, n):
    return (t, n)

def Tree (tok, lis):
    #print(lis)
    if tok [1] == "start":                  # returns next string
        return lis[0]
    
    if tok[1] == "expr":
        if type(lis[0]) == str:             # returns next string if non-terminal
            return lis[0]
        elif type(lis[0]) == tuple:         # handles TERMINALS
            if lis[0][0] == "IDE":
                return f"Var(\"{lis[0][1]}\")"
            if lis[0][0] == "SYM":
                return f"Sym(Var(\"{lis[0][1]}\"))"
    
    if tok[1] == "atom":                    # same deal with terminals and non-terminals
        
        if type(lis[0]) == tuple and lis[0][0] == "INTEGER":
            return f"Atom(Int({lis[0][1]}))"
        if type(lis[0]) == tuple and lis[0][0] == "BOOL":
            return f"Atom(Bool({lis[0][1]}))"
        elif type(lis[0]) == str:
            return lis[0]
        
    if tok[1] == "anonfun":
        return f"Atom(AnonFun(Var (\"{lis[0][1]}\"), {lis[1]}))"
    
    if tok[1] == "list":
        elements = ""
        for i in range(len(lis)):
            if i == 0:
                elements += lis[i]
            else:
                elements += " ; " + lis[i]
            
        return f"Atom(MyList([{elements}]))"
    
    
    if tok[1] == "op":
        if lis[0][1] in ["+", "*", "/", "^", "&", "=", ">", ">=", "<", "<=", "@"]:        # n-ary operations
            operation = ""
            
            #type noper = Add | Mul | And | Or | Equals | Greater | GreaterEq | Less | LessEq
            #type uoper = Neg | Not

            
            if lis[0][1] == "+":
                operation = "Add"
            elif lis[0][1] == "*":
                operation = "Mul"
            elif lis[0][1] == "/":
                operation = "Div"
            elif lis[0][1] == "^":
                operation = "Or"
            elif lis[0][1] == "&":
                operation = "And"
            elif lis[0][1] == "=":
                operation = "Equals"
            elif lis[0][1] == ">":
                operation = "Greater"            
            elif lis[0][1] == ">=":
                operation = "GreaterEq"
            elif lis[0][1] == "<":
                operation = "Less"            
            elif lis[0][1] == ">=":
                operation = "LessEq"
            elif lis[0][1] == "@":
                operation = "ListConcat"   

            operands = ""
            for i in range(1, len(lis)):
                operands += lis[i]
                if i < len(lis) - 1:
                    operands += " ; "
            return f"Apply(Nop({operation}), [{operands}])"
        
        if lis[0][1] in ["-", "!"]: # 1-ary operations
            operation = ""
            if lis[0][1] == "-":                            
                operation = "Neg"
            if lis[0][1] == "!":                            
                operation = "Not"
            operand = lis[1]
        return f"Apply(Uop({operation}), [{operand}])"
    
    if tok[1] == "lambda_app":
        return f"Apply({lis[0]}, [{lis[1]}])"
    if tok[1] == "lambda":
        return f"Lambda(Var(\"{lis[0][1]}\"), {lis[1]})"
    
    if tok[1] == "expr_app":
        return f"Apply(FunExpr({lis[0]}), [{lis[1]}])"
    
    if tok[1] == "letin":
        return f"LetIn({lis[0]}, {lis[2]})"             # 2 because for some reason I added IN 
                                                        # as an explicit terminal
    if tok[1] == "decl":
        return f"Decl(Var(\"{lis[0][1]}\"), {lis[1]})"
    
    if tok[1] == "conditional":
        return f"IfThenElse({lis[0]}, {lis[1]}, {lis[2]})"
    
    
    return "idk"



def parse_program (program):
    #print(program)
    f = open("./source/pg.lark", "r")

    l = Lark(f.read())

    a = eval(str(l.parse(program)))


    f = open("out.ml", "w")
    f.write(f"#use \"./source/interpreter.ml\";;\n\nlet a = {a};;\n\nlet result = (eval emptyenv) a;;\n\nprint_simple_type result;;")
    f.close()
        
    #print(a)

