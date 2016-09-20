from ranger.api.commands import *

class Voyager(Command):
    def __init__(self, *args, prompt=None, **kws):
        Command.__init__(self, *args, **kws)
        self.prompt = prompt

    def execute(self):
        import subprocess
        p = self.fm.execute_command(self.prompt, stdout=subprocess.PIPE)
        stdout, stderr = p.communicate()
        if p.returncode == 0:
            target = os.path.abspath(stdout.decode('utf-8').rstrip('\n'))
            if os.path.isdir(target):
                self.fm.cd(target)
            else:
                self.fm.select_file(target)

_fzf = '"$HOME/.fzf/bin/fzf"' # still ain't workin' yo

class fzf_select_file(Voyager):
    """
    :fzf_select_file

    Find a file using fzf.
    """

    def __init__(self, *args, **kws):
        # match files and directories

        _fzfcmd='( \
        bfs . \
        -name .git -prune -o \
        -name node_modules -prune -o \
        -type f -print \
        | sed 1d | cut -b3- \
        ) 2> /dev/null'
        prompt="{} | {} +m".format(_fzfcmd , _fzf)
        Voyager.__init__(self, *args, **kws, prompt=prompt)


class fzf_select_dir(Voyager):
    """
    :fzf_select_dir

    find a directory using fzf.
    """

    def __init__(self, *args, **kws):
        # match files and directories
        _fzfcmd='( \
        bfs . \
        -name .git -prune -o \
        -name node_modules -prune -o \
        -type d -print \
        | sed 1d | cut -b3- \
        ) 2> /dev/null'
        prompt="{} | {} +m".format(_fzfcmd , _fzf)
        Voyager.__init__(self, *args, **kws, prompt=prompt)


class fzf_select_history(Voyager):
    """
    :fzf_select_history

    find a directory using fzf.
    """

    def __init__(self, *args, **kws):
        # match files and directories
        _fzfcmd='fasd -Rl 2> /dev/null'
        prompt="{} | {} +m".format(_fzfcmd , _fzf)
        Voyager.__init__(self, *args, **kws, prompt=prompt)
