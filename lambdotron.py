from parser import parse_program
import os
import sys

f = open(sys.argv[1], "r")
program = f.read().strip()
#print(program)
parse_program(program)

os.system("ocaml out.ml")
