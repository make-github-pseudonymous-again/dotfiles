#!/usr/bin/env -S bun run

import fs from 'fs/promises';
import path from 'path';
import ICAL from 'ical.js';

import {
	calendars,
	cacheRead,
	FRESH,
	CACHE,
	urlHash,
	log
} from '../lib/events';

await fs.mkdir(path.dirname(FRESH.replace('{}', '')), { recursive: true });

const now = new Date();

for (const _calendar of await calendars()) {
	const url = _calendar.url;
	const h = urlHash(url);
	const text = await cacheRead(CACHE, url);

	const jcalData = ICAL.parse(text);
	const calendar = new ICAL.Component(jcalData);

	const components = calendar.getAllSubcomponents().filter(
		(component) => {
			if (component.name !== 'vevent') return true;
			const event = new ICAL.Event(component);
			const end = event.endDate.toJSDate();
			return end >= now;
		}
	);
	calendar.removeAllSubcomponents();

	for (const component of components) {
		calendar.addSubcomponent(component);
	}

	const freshfilename = FRESH.replace('{}', h);

	log(`writing ${url} to ${freshfilename}`);

	await fs.writeFile(freshfilename, calendar.toString());
}
