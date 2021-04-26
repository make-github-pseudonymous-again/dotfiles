#!/usr/bin/env python3

NO = "no"
DIRECTIVE_ARG = "--"

def parse(argv, args, kwargs):
    """
        Found in https://github.com/make-github-pseudonymous-again/sak/blob/91f86622a9e588d10b40c411ecf549b6fa21618b/lib/args.py#L85
    """

    key = ""
    isflag = False
    isvalue = False
    islist = False
    isarg = False

    for p in argv:

        if isarg:
            args.append(p)

        elif p == DIRECTIVE_ARG:
            isarg = True

        elif len(p) > 1 and p[0] == '-' and not p[1].isdigit():
            isvalue = False
            isflag = False
            islist = False
            if p[1] == '-':
                p = p[2:]

                if len(p) == 0:
                    continue

                v = True
                if len(p) > 1 and p[:2] == NO:
                    v = False
                    p = p[2:]

                kwargs[p] = v
                key = p
                isflag = True

            elif len(p) == 2:

                p = p[1]

                kwargs[p] = True
                key = p
                isflag = True

            else:
                for c in p[1:]:
                    kwargs[c] = True

        else:
            if isflag:
                isflag = False
                isvalue = True
                kwargs[key] = p
            elif isvalue:
                isvalue = False
                islist = True
                kwargs[key] = [kwargs[key], p]
            elif islist:
                kwargs[key].append(p)
            else:
                args.append(p)

    return args, kwargs



if __name__ == '__main__' :

    import sys
    import json

    args, kwargs = parse(sys.argv[1:], [], {})

    obj = dict(
        args = args,
        kwargs = kwargs,
    )

    json.dump(obj, sys.stdout)
