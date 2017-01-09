import os
from ranger.api.commands import *
from ranger.core.loader import CommandLoader

class Voyager(Command):
    def __init__(self, *args, **kws):
        prompt = kws.pop('prompt', None)
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
        kws['prompt'] = prompt
        Voyager.__init__(self, *args, **kws)


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
        kws['prompt'] = prompt
        Voyager.__init__(self, *args, **kws)


class fzf_select_history(Voyager):
    """
    :fzf_select_history

    find a directory using fzf.
    """

    def __init__(self, *args, **kws):
        # match files and directories
        _fzfcmd='fasd -Rl 2> /dev/null'
        prompt="{} | {} +m".format(_fzfcmd , _fzf)
        kws['prompt'] = prompt
        Voyager.__init__(self, *args, **kws)

class extract(Command):
    def execute(self):
        """ Extract selection to current directory """
        cwd = self.fm.thisdir
        marked_files = cwd.get_selection()

        if not marked_files:
            return

        def refresh(_):
            cwd = self.fm.get_directory(original_path)
            cwd.load_content()

        one_file = marked_files[0]
        original_path = cwd.path
        au_flags = ['-X', cwd.path]
        au_flags += self.line.split()[1:]
        au_flags += ['-e']

        self.fm.copy_buffer.clear()
        self.fm.cut_buffer = False
        if len(marked_files) == 1:
            descr = "extracting: " + os.path.basename(one_file.path)
        else:
            descr = "extracting files from: " + os.path.basename(one_file.dirname)
        obj = CommandLoader(args=['aunpack'] + au_flags \
                + [f.path for f in marked_files], descr=descr)

        obj.signal_bind('after', refresh)
        self.fm.loader.add(obj)

class archive(Command):
    def execute(self):
        """ Compress selection to current directory """
        cwd = self.fm.thisdir
        marked_files = cwd.get_selection()

        if not marked_files:
            return

        def refresh(_):
            cwd = self.fm.get_directory(original_path)
            cwd.load_content()

        original_path = cwd.path
        parts = self.line.split()
        au_flags = parts[1:]

        self.fm.copy_buffer.clear()
        self.fm.cut_buffer = False
        descr = "compressing files in: " + os.path.basename(parts[1])
        obj = CommandLoader(args=['apack'] + au_flags + \
                [os.path.relpath(f.path, cwd.path) for f in marked_files], descr=descr)

        obj.signal_bind('after', refresh)
        self.fm.loader.add(obj)

    def tab(self):
        """ Complete with current folder name """

        extension = ['.zip', '.tar.gz', '.rar', '.7z']
        return ['archive ' + os.path.basename(self.fm.thisdir.path) + ext for ext in extension]
