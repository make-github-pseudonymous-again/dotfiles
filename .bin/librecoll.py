from datetime import datetime
from human import bytes as humanbytes, datetime as humandatetime

def formatdoc(doc):

	formatarray = ['{htime}', '>']

	if doc.title:
		formatarray.append('{title}')
		formatarray.append('--')

	formatarray.append('{hint}/{filename}')
	formatarray.append('({hbytes}, {mtype})')
	formatarray.append('--')

	if doc.abstract:
		formatarray.append('{abstract}')
		formatarray.append('--')

	formatarray.append('{url}')
	formatarray.append('--')
	formatarray.append('d@te:{hdate}')

	keys = formatkeys(doc)
	return ' '.join(formatarray).format(**keys)


def formatkeys(doc):

	path = doc.url[7:]
	hint = '/'.join(map(lambda x : x[:2], path.split('/')[3:-1]))

	try:
		timestamp = datetime.fromtimestamp(int(doc.mtime))
		htime = humandatetime(timestamp)
		hdate = timestamp.isoformat()
	except Exception:
		htime = 'unknown'
		hdate = 'unknown'

	try:
		hbytes = humanbytes(int(doc.fbytes))
	except Exception:
		hbytes = 'unknown'

	return {
		'hbytes': hbytes,
		'htime': htime,
		'hdate': hdate,
		'hint': hint,
		'filename': 'unknown',
		**doc.items()
	}
