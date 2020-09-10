import numpy as np
import matplotlib.pyplot as plt

from sympy import Symbol
from sympy import lambdify
from sympy import latex

def lam2D (f, x):
    tmp = Symbol('tmp')
    return lambdify(tmp, f.subs(x,tmp), modules=['numpy'])

def plot2D ( fns , rangex , ymin = None , ymax = None , hints = (),
        points = 1000 , figure = None , block = False ,
        yfmt = '{:.4f}', label=lambda f: latex(f, mode='inline'), **kwargs ) :

    if not isinstance(fns, (list, tuple)): fns = (fns,)
    x, xmin, xmax = rangex
    xmin, xmax = float(xmin), float(xmax)
    domain = np.linspace(xmin, xmax, points)
    lmbds = list(map(lambda f: lam2D(f,x), fns))

    plt.figure(figure)

    plt.xlim(xmin, xmax)
    if ymin is not None: plt.ylim(ymin, ymax)

    for f,l in zip(fns,lmbds):
        plt.plot(domain, l(domain), label=label(f), zorder=2)

    for xval in hints:
        plt.axvline(xval, color='grey', dashes=(2,2), zorder=1)
    for l in lmbds:
        yvals = tuple(map(l,hints))
        plt.scatter(hints,yvals,s=50, zorder=3)
        for pos in zip(hints,yvals):
            plt.annotate(
                yfmt.format(pos[1]),
                pos,
                xytext=(7,-7),
                textcoords='offset points', ha='left',va='top',
                bbox = dict(boxstyle = 'round,pad=0.4', fc = 'yellow', alpha = 0.6)
            )

    ticks, labels = plt.xticks()
    ticks = tuple(ticks) + tuple(hints)
    labels = map(lambda t: '{:.2f}'.format(t), ticks)
    plt.xticks(ticks, labels)


    lx = latex(x)

    plt.legend(loc='best', shadow=True, fontsize='x-large')
    plt.xlabel("${}$".format(lx))
    plt.ylabel("$f({})$".format(lx))

    def format_coord(x1, x2):
        result = ('{}='+yfmt+', f({})='+yfmt).format(x,x1,lx,x2)
        for i, l in enumerate(lmbds, 1):
            result += (', f{}({})='+yfmt).format(i, lx, l(x1))
        return result

    plt.gca().format_coord = format_coord
    plt.show(block=block, **kwargs)


