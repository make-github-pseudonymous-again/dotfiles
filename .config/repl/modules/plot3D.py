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

def lam3D (f, x, y):
    tmp1 = Symbol('tmp1')
    tmp2 = Symbol('tmp2')
    return lambdify((tmp1,tmp2), f.subs({x: tmp1, y:tmp2}), modules=['numpy'])

def plot3D ( fns , rangex , rangey , points = 100, layout = None, block =
        False, **kwargs ):

    if not isinstance(fns, (list, tuple)): fns = (fns,)
    if layout is None: layout = (1,len(fns))
    x, xmin, xmax = rangex
    y, ymin, ymax = rangey

    X = np.arange(xmin, xmax, (xmax-xmin)/points)
    Y = np.arange(ymin, ymax, (ymax-ymin)/points)
    domain = np.meshgrid(X, Y)

    fig = plt.figure()

    for j, f in enumerate(fns,1):

        ax = fig.add_subplot(*layout, j, projection='3d')

        ax.set_xlim(xmin, xmax)
        ax.set_ylim(ymin, ymax)

        ax.set_xlabel(latex(x, mode='inline'))
        ax.set_ylabel(latex(y, mode='inline'))

        l = lam3D(f,x,y)
        z = l(*domain)
        z = np.ma.array(z, mask=np.isnan(z))

        zmin = np.amin(z)
        zmax = np.amax(z)
        print(zmin,zmax)
        ax.set_zlim(zmin, zmax)
        ax.set_zlabel(latex(f, mode='inline'))

        bounds = np.linspace(zmin,zmax,points)
        idx=np.searchsorted(bounds,0)
        bounds=np.insert(bounds,idx,0)
        _bounds = tuple(filter(lambda x: x >= 0, bounds.tolist()))
        if zmin < 0:
            _bounds = (zmin,) +_bounds
        ncolors = len(_bounds)
        bounds = np.array(_bounds)

        viridis = cm.get_cmap('viridis', ncolors)
        newcolors = viridis(np.linspace(0, 1, ncolors))
        pink = np.array([248/256, 24/256, 148/256, 1])
        newcolors[0] = pink
        cmap = ListedColormap(newcolors)

        norm = BoundaryNorm(bounds, ncolors)

        surf = ax.plot_surface(*domain, z, cmap=cmap,
            norm=norm,
            linewidth=0, antialiased=False, label=latex(f, mode='inline'))

        fig.colorbar(surf, shrink=0.5, aspect=5)

    plt.show(block=block, **kwargs)
