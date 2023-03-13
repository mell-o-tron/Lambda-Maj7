from parser import parse_program
import os
import sys

while(True):
    program = input(">> ")
    #print(program)
    parse_program(program)

    os.system("ocaml out.ml")
    
