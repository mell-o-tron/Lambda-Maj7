# λ-maj7

## Language specs
λ-maj7 is a (very much WIP) functional programming language. Its interpreter is written in OCaml, while the parsing is done with Lark, and the syntax tree is converted to OCaml through a python script.

## Features
- The currently available data types are integers, booleans and lambdas. I'll very soon add lists and floating point numbers.
- The operations are represented in pre-fix notation, and most of them are n-ary. When I will add lists I'll probably make them binary.
- The functions are all unary, and there is no syntactic sugar for functions of the type `t1->t2->t3`. You just have to write:

```
f := lam(x1) => {
    g := lam(x2) => {
        ...
    }
};
(f g) input;
```


## Feature ideas
- I'm thinking of adding macros, and use them to add some layers of syntactic sugar (n-ary functions, infix operators...). I'd like to make them very flexible, and allow the user to customize the language as much as possible.
