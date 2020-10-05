
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
