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
import os
import sys
PATH_MODULES = os.path.expanduser('~/.config/repl/modules')
print('Loading modules from', PATH_MODULES)
sys.path.insert(1, PATH_MODULES)

from sympy import *
from symbols import *
from calculus import *
from plot2D import *
from plot3D import *

init_printing()
