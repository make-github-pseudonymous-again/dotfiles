# from concurrent.futures import ThreadPoolExecutor
# import importlib
# import sys

# modules_to_load = ['sympy']


# def do_import(module_name):
    # thismodule = sys.modules[__name__]

    # module = importlib.import_module(module_name)
    # setattr(thismodule, module_name, module)
    # print(module_name, 'imported')


# executor = ThreadPoolExecutor()
# for module_name in modules_to_load:
    # executor.submit(do_import, module_name)

from __future__ import division
from sympy import *
from numpy import linspace
import matplotlib.pyplot as mpl

def derivatives ( f , x ) :
    while True:
        yield f
        f = f.diff(x)

taylor = lambda f, x, a, N : sum(
    map(
        lambda args: args[0].subs(x,a)*(x-a)**args[1]/factorial(args[1]),
        zip(derivatives(f, x), range(0,N+1))
    )
)

def lam (f, x):
    tmp = Symbol('t')
    return lambdify(tmp, f.subs(x,tmp), modules=['numpy'])

def plot2D ( fns , x , xmin , xmax , ymin = None , ymax = None , points = 1000 , figure = None , block = False , **kwargs ) :

    if type(fns) is Expr: fns = [fns]
    lmbds = list(map(lambda f: lam(f,x), fns))
    domain = linspace(xmin, xmax, points)

    mpl.figure(figure)

    mpl.xlim(xmin, xmax)
    if ymin is not None: mpl.ylim(ymin, ymax)

    for f,l in zip(fns,lmbds):
        mpl.plot(domain, l(domain), label=latex(f, mode='inline'))

    lx = latex(x)

    mpl.legend(loc='best', shadow=True, fontsize='x-large')
    mpl.xlabel("${}$".format(lx))
    mpl.ylabel("$f({})$".format(lx))

    def format_coord(x1, x2):
        result = '{}={:.4f}, f({})={:.4f}'.format(x,x1,lx,x2)
        for i, l in enumerate(lmbds, 1):
            result += ', f{}({})={:.4f}'.format(i, lx, l(x1))
        return result

    mpl.gca().format_coord = format_coord
    mpl.show(block=block, **kwargs)


x, y, z, t = symbols('x y z t')
k, m, n = symbols('k m n', integer=True)
f, g, h = symbols('f g h', cls=Function)
init_printing()
