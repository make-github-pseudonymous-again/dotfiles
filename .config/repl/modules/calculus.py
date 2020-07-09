from sympy import factorial

def derivatives ( f , x ) :
    while True:
        yield f
        f = f.diff(x)

def taylor (f, x, a, N) :
    return sum(
        map(
            lambda args: args[0].subs(x,a)*(x-a)**args[1]/factorial(args[1]),
            zip(derivatives(f, x), range(0,N+1))
        )
    )
