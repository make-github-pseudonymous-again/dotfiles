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
x, y, z, t = symbols('x y z t')
k, m, n = symbols('k m n', integer=True)
f, g, h = symbols('f g h', cls=Function)
init_printing()
