import datetime as dt
from typing import Optional

def bytes(size):

	B = "B"
	KB = "KB"
	MB = "MB"
	GB = "GB"
	TB = "TB"
	UNITS = [B, KB, MB, GB, TB]
	HUMANFMT = "{:.2f} {}"
	HUMANRADIX = 1024.

	for u in UNITS[:-1]:
		if size < HUMANRADIX : return HUMANFMT.format(size, u)
		size /= HUMANRADIX

	return HUMANFMT.format(size, UNITS[-1])

def _seconds(s: float):
	seconds = int(s)
	yield 'seconds', seconds

	minutes = seconds // 60
	yield 'minutes', minutes

	hours   = minutes // 60
	yield 'hours', hours

	days	= hours // 24
	yield 'days', days

	weeks   = days // 7
	yield 'weeks', weeks

	months  = days // 30
	yield 'months', months

	years   = days // 365
	yield 'years', years


def _duration(unit: str, count: int):
	return '{count} {unit}'.format(
		count=count,
		unit=unit if abs(count) > 1 else unit[:-1]
	)

def seconds(value: float):
	for unit, count in list(_seconds(value))[::-1]:
		if count == 0: continue
		return _duration(unit, count)

	return 'now'

def timedelta(delta: dt.timedelta):
	return seconds(delta.total_seconds())

def datetime(x: dt.datetime, relative_to: Optional[dt.datetime]=None):
	if relative_to is None:
		relative_to = dt.datetime.now(x.tzinfo)

	delta = x - relative_to
	s = delta.total_seconds()

	fmt = '{}' if s == 0 else '{} ago' if s < 0 else 'in {}'
	return fmt.format(seconds(abs(s)))
