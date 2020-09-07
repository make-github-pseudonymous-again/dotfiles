from sympy import Symbol
from sympy import lambdify
from sympy import log
from sympy import E
from sympy import factorial
from sympy import latex
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import cm
from matplotlib.ticker import LinearLocator, FormatStrFormatter
from matplotlib.colors import ListedColormap, BoundaryNorm
from operator import __gt__
from operator import __lt__

def lam3D(f, x, y):
    tmp1 = Symbol('tmp1')
    tmp2 = Symbol('tmp2')
    return lambdify((tmp1, tmp2), f.subs({x: tmp1, y: tmp2}), modules=['numpy'])

def plot3D(fns, rangex, rangey, points=100, colors=None, layout=None, block=False, **kwargs):

    if not isinstance(fns, (list, tuple)):
        fns = (fns,)
    if layout is None:
        layout = (1, len(fns))
    x, xmin, xmax = rangex
    y, ymin, ymax = rangey

    xmin, xmax, ymin, ymax = map(float, (xmin, xmax, ymin, ymax))

    X = np.arange(xmin, xmax, (xmax-xmin)/points)
    Y = np.arange(ymin, ymax, (ymax-ymin)/points)
    domain = np.meshgrid(X, Y)

    fig = plt.figure()

    for j, f in enumerate(fns, 1):

        ax = fig.add_subplot(*layout, j, projection='3d')

        ax.set_xlim(xmin, xmax)
        ax.set_ylim(ymin, ymax)

        ax.set_xlabel(latex(x, mode='inline'))
        ax.set_ylabel(latex(y, mode='inline'))

        l = lam3D(f, x, y)
        z = l(*domain)
        z = np.ma.array(z, mask=np.isnan(z))

        zmin = np.amin(z)
        zmax = np.amax(z)
        ax.set_zlim(zmin, zmax)
        ax.set_zlabel(latex(f, mode='inline'))

        if colors is None:
            cmap, norm = None, None
        else:
            cmap, norm = colors(zmin, zmax, points)

        surf = ax.plot_surface(*domain, z, cmap=cmap,
                               norm=norm,
                               linewidth=0, antialiased=False, label=latex(f, mode='inline'))

        if cmap is not None:
            fig.colorbar(surf, shrink=0.5, aspect=5)

    plt.show(block=block, **kwargs)


gt = lambda t: threshold(__gt__, t)
lt = lambda t: threshold(__lt__, t)

def threshold (op , t) :

    assert op is __gt__ or op is __lt__

    def colors(zmin, zmax, points):

        bounds = np.linspace(zmin, zmax, points)
        _bounds = tuple(filter(lambda x: not op(x,t), bounds.tolist()))

        if zmin <= t <= zmax:
            if op is __gt__:
                if _bounds[-1] != t and t != zmax:
                    _bounds = _bounds + (t,)
            else:
                if _bounds[0] != t and t != zmin:
                    _bounds = (t,) + _bounds

            if op(zmin,t): _bounds = (zmin,) + _bounds
            if op(zmax,t): _bounds = _bounds + (zmax,)

        elif t < zmin <= zmax:
            if op is __gt__:
                _bounds = (t,zmin,zmax)
            else:
                _bounds = (zmin,) + _bounds + (zmax,)

        elif zmin <= zmax < t:
            if op is __lt__:
                _bounds = (zmin,zmax,t)
            else:
                _bounds = (zmin,) + _bounds + (zmax,)

        ncolors = len(_bounds)

        bounds = np.array(_bounds)

        viridis = cm.get_cmap('viridis', ncolors)
        newcolors = viridis(np.linspace(0, 1, ncolors))
        pink = np.array([248/256, 24/256, 148/256, 1])
        cmap = ListedColormap(newcolors)

        if zmin <= t <= zmax:
            newcolors[0 if op is __lt__ else -1] = pink
        elif t < zmin <= zmax and op is __gt__:
            newcolors[-1] = pink
        elif zmin <= zmax < t and op is __lt__:
            newcolors[0] = pink

        norm = BoundaryNorm(bounds, ncolors)

        return cmap, norm

    return colors

