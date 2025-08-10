#!/usr/bin/env -S bun run

import {
	FRESH,
	calendars,
	cacheLoadCalendars,
	main,
	eventToI3StatusObject,
} from '../lib/events';

const now = new Date();
const calendarConfigs = await calendars();
const events = await cacheLoadCalendars(calendarConfigs, FRESH);
const event = main(now, events);

if (event) {
	const statusObject = eventToI3StatusObject(now, event);
	console.log(JSON.stringify(statusObject));
}
