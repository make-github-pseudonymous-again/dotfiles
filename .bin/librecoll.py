import arrow
import human
humanbytes = human.bytes

def formatdoc(doc):

	path = doc.url[7:]
	hint = '/'.join(map(lambda x : x[:2], path.split('/')[3:-1]))

	try:
		timestamp = arrow.get(doc.mtime)
		htime = timestamp.humanize()
		hdate = timestamp.format('YYYY-MM-DDTHH:mm:ssZZ')
	except Exception as e:
		htime = 'unknown'
		hdate = 'unknown'

	try:
		hbytes = humanbytes(int(doc.fbytes))
	except Exception as e:
		hbytes = 'unknown'

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

	keys = {
		'hbytes': hbytes,
		'htime': htime,
		'hdate': hdate,
		'hint': hint,
		'filename': 'unknown',
		**doc.items()
	}

	return ' '.join(formatarray).format(**keys)
