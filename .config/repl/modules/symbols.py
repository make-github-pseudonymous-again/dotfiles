from sympy import symbols
from sympy import Symbol
from sympy import Function
from sympy import beta, gamma

x, y, z, t = symbols('x y z t')
k, m, n = symbols('k m n', integer=True)
f, g, h = symbols('f g h', cls=Function)
Beta = beta
Gamma = gamma
alpha = Symbol('alpha')
beta = Symbol('beta')
gamma = Symbol('gamma')
K = Symbol('K')
