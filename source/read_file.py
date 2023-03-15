from parser import parse_program
from preprocessor import *
import os
import sys

try:
    f = open(sys.argv[1], "r")
except:
    print("Argument error")
    
program = f.read().strip()
#print(program)

program_includes = replace_includes(program)
program_macro = replace_macros(program_includes)



parse_program(program_macro)

os.system("ocaml out.ml")
