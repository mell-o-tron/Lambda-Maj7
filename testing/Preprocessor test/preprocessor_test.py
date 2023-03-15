import re
import sys

def expand_macros (orig_program, macros):
    program = orig_program
    for m in macros:
        while (x := re.search(m[0], program)) != None:
            group = m[1]
            
            i = 1
            while (y := re.search(f"\\${i}", m[1])) != None:
                try:
                    group = group.replace(y[0], x.group(i))
                except: 
                    print("Preprocessor Error:")
                    print(f"Non matching group ${i} in macro {m[0]}")
                    exit(1)
                i += 1
            
                    
            program = program.replace(x[0],group)
    return program

def replace_includes (orig_program):
    program = orig_program
    
    while (x := re.search("#include \"(.*)\"", program)) != None:
        try:
            f = open(x.group(1), "r")
        except:
            print("Preprocessor Error:")
            print(f"Source file \"{x.group(1)}\" not found.")
            exit(1)
            
        to_be_included = f.read().strip()
        program = program.replace (x[0], to_be_included)
    return program

def replace_macros (orig_program):
    program = orig_program
    macros = []

    while (x := re.search("#macro\s+\"(.*)\"\s*~\s*\"(.*)\"", program)) != None:
        program = program.replace(x[0], "")
        macros += [(x.group(1), x.group(2))]

    
    program = expand_macros (program, macros)
    
    while True:
        program1 = expand_macros (program, macros)
        program  = expand_macros (program1, macros)
        if program == program1:
            break 
    
    
    return program

try:
    f = open(sys.argv[1], "r")
except:
    print("Preprocessor Tester Error: argument error")
    exit(1)
    
program = f.read().strip()
program_includes = replace_includes(program)
program_macro = replace_macros(program_includes)
print (program_macro)
