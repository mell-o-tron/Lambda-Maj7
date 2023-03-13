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
        elif type(lis[0]) == str:
            return lis[0]
        
    if tok[1] == "anonfun":
        return f"Atom(AnonFun(Var (\"{lis[0][1]}\"), {lis[1]}))"
    
    
    if tok[1] == "op":
        if lis[0][1] == "+" or lis[0][1] == "*":        # n-ary operations
            operation = ""
            
            if lis[0][1] == "+":
                operation = "Add"
            elif lis[0][1] == "*":
                operation = "Mul"
            
            
            operands = ""
            for i in range(1, len(lis)):
                operands += lis[i]
                if i < len(lis) - 1:
                    operands += " ; "
            return f"Apply(Nop({operation}), [{operands}])"
        
        if lis[0][1] == "-":                            # 1-ary operations
            operation = "Neg"
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
    
    return "idk"



program = "x := 5; x"
f = open("pg.lark", "r")
l = Lark(f.read())

b = str(l.parse(program))

print(b)
a = eval(b)
print(a)

