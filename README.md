# λ-maj7

## Language specs
λ-maj7 is a (very much WIP) functional programming language. Its interpreter is written in OCaml, while the parsing is done with Lark, and the syntax tree is converted to OCaml through a Python script.

## Features
- The currently available data types are integers, floats, booleans, lists, tuples and lambdas.
- The operations are represented in pre-fix notation, and most of them are n-ary (this might change in the future).
- The functions are all unary, and there is no built-in syntactic sugar for functions of the type `t1->t2->t3`. You just have to use explicit currying (or use tuples if you wish).
- List unpacking: the following code outputs `[4, 5, 6]`

```
lis := [1,2,3,4,5,6];
[a, b, c, ...rest] <- lis;
rest
```

- Preprocessor: You can include other files with the `#include` directive, and define lexical macros, using regular expressions. Let's say, for example, you wanted to make a macro to use in-fix notation in place of the built-in pre-fix one. You could write the following, and have every instance of `{x #+ y}` be converted to `+(x, y)`:
```
#macro "{([^{|}]+)\s*#\+\s*([^{|}]+)}" ~ "+($1, $2)"

{banana #+ {11 #+ 3}}     // becomes +(banana, +(11, 3))
```
- If you're using Kate by KDE, I'm also including a simple syntax highlighting file.

## Planned features
- Parsing error messages, better runtime error messages
- Static checks
- Pattern matching
- Strings
- I/O
