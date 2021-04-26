import ranger.api
import ranger.core.linemode

import os.path

extensions_multi = (
    (('.txt','.md','.mmark'), ''),
    (('.pdf','.djvu','.eps','.ps'), ''),
    (('.json','.yaml','.toml','.atom','.xml','.html'), ''),
    (('.sh','.bash','.fish','.bat'), ''),
    (('.js',), ''),
    (('.py',), ''),
    (('.webm','.aac','.flac','.mp3','.m4a','.wma'), ''),
    (('.png','.gif','.jpg','.jpeg','.pgm','.svg'), ''),
    (('.mkv','.mp4'), ''),
    (('.gpg',), ''),
    (('.pub',), ''),
    (('.db','.sqlite'), ''),
    (('.ics',), ''),
    (('.xz','.gz','.zip','.tar'), ''),
    (('.xoj','.xopp','.ipe'), ''),
    (('.csv'), ''),
    (('.conf','.ini'), ''),
    (('.bak',), ''),
    (('.srt',), ''),
    (('.part'), ''),
)


special = {
    'LICENSE': '',
}

extensions = { ext: icon for exts, icon in extensions_multi for ext in exts }

@ranger.api.register_linemode
class MyLinemode(ranger.core.linemode.LinemodeBase):
    name = "my_default"

    def filetitle(self, file, metadata):
        prefix = ''

        if file.is_directory:
            prefix = ''
            if os.path.exists(os.path.join(file.path, '.stfolder')):
                prefix = ''
            elif os.path.exists(os.path.join(file.path, '.git')):
                prefix = ''

        else:
            if file.relative_path in special:
                prefix = special.get(file.relative_path)
            else:
                if file.relative_path[-1] == '~':
                    ext = '.bak'
                elif file.relative_path[-2:] == 'rc':
                    ext = '.conf'
                else:
                    ext = os.path.splitext(file.relative_path)[1]
                prefix = extensions.get(ext, '')

        return prefix + ' ' + file.relative_path
