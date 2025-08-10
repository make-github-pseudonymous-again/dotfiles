import ICAL from 'ical.js';
import { homedir } from 'node:os';
import {
	format,
	differenceInDays,
	formatDistance,
} from 'date-fns';
import {readFile} from 'node:fs/promises';
import {join} from 'node:path';
import {createHash} from 'node:crypto';
import { z } from 'zod';

export const log = (...args: any[]) => console.error(...args);

export const CACHE = join(homedir(), '.cache/calendar/{}');
export const FRESH = join(homedir(), '.cache/calendar/fresh/{}');
export const CONFIG = join(homedir(), '.config/calendar/config');

// Zod schema for calendar configuration
const CalendarSchema = z.object({
	url: z.url(),
	description: z.string(),
	icon: z.string(),
	hide: z.boolean().optional()
});

const ConfigSchema = z.object({
	calendars: z.array(CalendarSchema)
});

export type Calendar = z.infer<typeof CalendarSchema>;
export type Config = z.infer<typeof ConfigSchema>;

export type ParsedEvent = {
	summary: string;
	description: string;
	begin: Date;
	end: Date;
	location?: string;
	url?: string;
}

export const parseICalendar = (calendarString: string): ParsedEvent[] => {
	try {
		const jcalData = ICAL.parse(calendarString);
		const comp = new ICAL.Component(jcalData);

		return comp.getAllSubcomponents('vevent').map(eventComp => {
			const event = new ICAL.Event(eventComp);

			return {
				summary: event.summary || '',
				description: event.description,
				begin: event.startDate.toJSDate(),
				end: event.endDate.toJSDate(),
				location: event.location,
				url: event._firstProp('url') as string || event._firstProp('x-url') as string || '',
			};
		});
	} catch (error) {
		log('Error parsing iCal:', error);
		return [];
	}
}

export const urlHash = (url: string): string => createHash('sha1').update(url).digest('hex');

export const cacheRead = async (cache: string, url: string): Promise<string> => {
	const h = urlHash(url);
	const filename = cache.replace('{}', h);
	log(`loading ${url} from ${filename}`);
	return readFile(filename, 'utf8');
}

export const cacheLoadUrl = async (cache: string, url: string): Promise<ParsedEvent[]> => {
	try {
		const data = await cacheRead(cache, url);
		return parseICalendar(data);
	} catch (err) {
		log(`Error loading cache for: ${url}`);
		log(err);
		return [];
	}
}

export const calendars = async (config: string = CONFIG): Promise<Calendar[]> => {
	const rawConfig = await readFile(config, 'utf8');
	const parsedConfig = JSON.parse(rawConfig);
	const validatedConfig = ConfigSchema.parse(parsedConfig);
	return validatedConfig.calendars.filter(c => !c.hide);
}

export const range = (now: Date, begin: Date, end: Date): string => {
	const daysDifference = differenceInDays(end, begin);
	let hour = false;

	if (daysDifference < 1 ||
		begin.getMinutes() !== end.getMinutes() ||
		begin.getSeconds() !== end.getSeconds() ||
		![22, 23, 0].includes(begin.getHours()) ||
		![22, 23, 0].includes(end.getHours())) {
		hour = true;
	}

	let bf = hour ? 'yyyy, MMM dd, HH:mm' : 'yyyy, MMM dd';
	let ef = hour ? 'yyyy, MMM dd, HH:mm' : 'yyyy, MMM dd';

	// Adjust format based on proximity to current date/year
	if (begin.getFullYear() === now.getFullYear()) {
		if (begin.getMonth() === now.getMonth()) {
			if (begin.getDate() === now.getDate()) {
				bf = hour ? 'HH:mm' : 'HH:mm';
			} else {
				bf = hour ? 'EEE dd, HH:mm' : 'EEE dd';
			}
		} else {
			bf = hour ? 'MMM dd, HH:mm' : 'MMM dd';
		}
	}

	if (end.getFullYear() === begin.getFullYear()) {
		if (end.getMonth() === begin.getMonth()) {
			if (end.getDate() === begin.getDate()) {
				ef = hour ? 'HH:mm' : 'dd';
			} else {
				ef = hour ? 'dd, HH:mm' : 'dd';
			}
		} else {
			ef = hour ? 'MMM dd, HH:mm' : 'MMM dd';
		}
	}

	return `${format(begin, bf)} - ${format(end, ef)}`;
}

export const cacheLoadCalendars = async (calendars: Calendar[], cache: string): Promise<ParsedEvent[]> => {
	const groups = await Promise.all(calendars.map(
		calendar => cacheLoadUrl(cache, calendar.url)
	));

	return groups.flat();
};

export const main = (now: Date, events: ParsedEvent[]): ParsedEvent | null => {
	const _fresh = events.filter(x => x.end >= now);
	const _future = _fresh.filter(x => x.begin >= now);
	const _happening = _fresh.filter(x => x.begin < now);

	const _current = _happening.length > 0
		? _happening.reduce((prev, curr) =>
			prev.end > curr.end ? prev : curr
		)
		: null;

	const _next = _future.length > 0
		? _future.reduce((prev, curr) =>
			prev.begin < curr.begin ? prev : curr
		)
		: null;

	if (_current === null) {
		if (_next === null) {
			throw new Error('no main event');
		}
		return _next;
	}

	return (_next === null || _next.begin >= _current.end) ? _current : _next;
}

export const eventToI3StatusObject = (now: Date, event: ParsedEvent) => {
	const name = event.summary;
	const location = event.location || '';
	const shortLocation = location.split(',')[0] || null;
	const begin = event.begin;
	const end = event.end;

	// event format
	let ef = '{name}';
	if (location && !name.includes(location)) {
		ef += ' ( {location})';
	}

	if (begin < now) {
		ef += ' - (started {hbegin}, ends {hend})';
	} else {
		ef += ' - {range} ({hbegin})';
	}

	const fullText = ef.replace(
		/\{(\w+)\}/g,
		(_, key) => {
			switch (key) {
				case 'name': return name;
				case 'location': return location;
				case 'range': return range(now, begin, end);
				case 'hbegin': return formatDistance(begin, now, { addSuffix: true });
				case 'hend': return formatDistance(end, now, { addSuffix: true });
				default: return _;
			}
		}
	).replace(/\r/g, '').replace(/\n/g, ' ');

	const shortText = ef.replace(
		/\{(\w+)\}/g,
		(_, key) => {
			switch (key) {
				case 'name': return name.length > 49 ? name.slice(0, 47) + '..' : name;
				case 'location': return shortLocation!;
				case 'range': return range(now, begin, end);
				case 'hbegin': return formatDistance(begin, now, { addSuffix: true });
				case 'hend': return formatDistance(end, now, { addSuffix: true });
				default: return _;
			}
		}
	).replace(/\r/g, '').replace(/\n/g, ' ');

	return {
		name: "calendar",
		color: "#A7C5BD",
		full_text: ` ${fullText}`,
		short_text: ` ${shortText}`
	};
}

export const TIMEZONE_LOCALE_MAP: Record<string, string> = {
	// North America
	'America/Anchorage': 'en-US',
	'America/Argentina/Buenos_Aires': 'es-AR',
	'America/Bahia': 'pt-BR',
	'America/Belem': 'pt-BR',
	'America/Boise': 'en-US',
	'America/Cambridge_Bay': 'en-CA',
	'America/Chicago': 'en-US',
	'America/Denver': 'en-US',
	'America/Detroit': 'en-US',
	'America/Edmonton': 'en-CA',
	'America/Halifax': 'en-CA',
	'America/Havana': 'es-CU',
	'America/Indianapolis': 'en-US',
	'America/Jamaica': 'en-JM',
	'America/Los_Angeles': 'en-US',
	'America/Mexico_City': 'es-MX',
	'America/Montreal': 'fr-CA',
	'America/New_York': 'en-US',
	'America/Phoenix': 'en-US',
	'America/Puerto_Rico': 'es-PR',
	'America/Regina': 'en-CA',
	'America/Santiago': 'es-CL',
	'America/Santo_Domingo': 'es-DO',
	'America/Sao_Paulo': 'pt-BR',
	'America/Toronto': 'en-CA',
	'America/Vancouver': 'en-CA',
	'America/Winnipeg': 'en-CA',

	// Europe
	'Europe/Amsterdam': 'nl-NL',
	'Europe/Athens': 'el-GR',
	'Europe/Belgrade': 'sr-RS',
	'Europe/Berlin': 'de-DE',
	'Europe/Brussels': 'nl-BE',
	'Europe/Bucharest': 'ro-RO',
	'Europe/Budapest': 'hu-HU',
	'Europe/Copenhagen': 'da-DK',
	'Europe/Dublin': 'en-IE',
	'Europe/Helsinki': 'fi-FI',
	'Europe/Istanbul': 'tr-TR',
	'Europe/Kaliningrad': 'ru-RU',
	'Europe/Kiev': 'uk-UA',
	'Europe/Lisbon': 'pt-PT',
	'Europe/London': 'en-GB',
	'Europe/Madrid': 'es-ES',
	'Europe/Minsk': 'be-BY',
	'Europe/Moscow': 'ru-RU',
	'Europe/Oslo': 'nb-NO',
	'Europe/Paris': 'fr-FR',
	'Europe/Prague': 'cs-CZ',
	'Europe/Riga': 'lv-LV',
	'Europe/Rome': 'it-IT',
	'Europe/Sofia': 'bg-BG',
	'Europe/Stockholm': 'sv-SE',
	'Europe/Tallinn': 'et-EE',
	'Europe/Vienna': 'de-AT',
	'Europe/Vilnius': 'lt-LT',
	'Europe/Warsaw': 'pl-PL',
	'Europe/Zurich': 'de-CH',

	// Asia
	'Asia/Almaty': 'kk-KZ',
	'Asia/Amman': 'ar-JO',
	'Asia/Anadyr': 'ru-RU',
	'Asia/Baghdad': 'ar-IQ',
	'Asia/Bahrain': 'ar-BH',
	'Asia/Baku': 'az-AZ',
	'Asia/Bangkok': 'th-TH',
	'Asia/Beirut': 'ar-LB',
	'Asia/Bishkek': 'ky-KG',
	'Asia/Brunei': 'ms-BN',
	'Asia/Chita': 'ru-RU',
	'Asia/Colombo': 'si-LK',
	'Asia/Damascus': 'ar-SY',
	'Asia/Dhaka': 'bn-BD',
	'Asia/Dubai': 'ar-AE',
	'Asia/Dushanbe': 'tg-TJ',
	'Asia/Gaza': 'ar-PS',
	'Asia/Hebron': 'ar-PS',
	'Asia/Ho_Chi_Minh': 'vi-VN',
	'Asia/Hong_Kong': 'zh-HK',
	'Asia/Hovd': 'mn-MN',
	'Asia/Irkutsk': 'ru-RU',
	'Asia/Jakarta': 'id-ID',
	'Asia/Jerusalem': 'he-IL',
	'Asia/Kabul': 'fa-AF',
	'Asia/Kamchatka': 'ru-RU',
	'Asia/Karachi': 'ur-PK',
	'Asia/Kathmandu': 'ne-NP',
	'Asia/Kolkata': 'hi-IN',
	'Asia/Krasnoyarsk': 'ru-RU',
	'Asia/Kuala_Lumpur': 'ms-MY',
	'Asia/Kuwait': 'ar-KW',
	'Asia/Macau': 'zh-MO',
	'Asia/Magadan': 'ru-RU',
	'Asia/Manila': 'fil-PH',
	'Asia/Muscat': 'ar-OM',
	'Asia/Novokuznetsk': 'ru-RU',
	'Asia/Novosibirsk': 'ru-RU',
	'Asia/Omsk': 'ru-RU',
	'Asia/Oral': 'kk-KZ',
	'Asia/Phnom_Penh': 'km-KH',
	'Asia/Pontianak': 'id-ID',
	'Asia/Pyongyang': 'ko-KP',
	'Asia/Qatar': 'ar-QA',
	'Asia/Qyzylorda': 'kk-KZ',
	'Asia/Riyadh': 'ar-SA',
	'Asia/Sakhalin': 'ru-RU',
	'Asia/Samarkand': 'uz-UZ',
	'Asia/Seoul': 'ko-KR',
	'Asia/Shanghai': 'zh-CN',
	'Asia/Singapore': 'en-SG',
	'Asia/Taipei': 'zh-TW',
	'Asia/Tashkent': 'uz-UZ',
	'Asia/Tbilisi': 'ka-GE',
	'Asia/Tehran': 'fa-IR',
	'Asia/Thimphu': 'dz-BT',
	'Asia/Tokyo': 'ja-JP',
	'Asia/Tomsk': 'ru-RU',
	'Asia/Ulaanbaatar': 'mn-MN',
	'Asia/Urumqi': 'zh-CN',
	'Asia/Ust-Nera': 'ru-RU',
	'Asia/Vladivostok': 'ru-RU',
	'Asia/Yakutsk': 'ru-RU',
	'Asia/Yekaterinburg': 'ru-RU',
	'Asia/Yerevan': 'hy-AM',

	// Africa
	'Africa/Abidjan': 'fr-CI',
	'Africa/Accra': 'en-GH',
	'Africa/Addis_Ababa': 'am-ET',
	'Africa/Algiers': 'ar-DZ',
	'Africa/Asmara': 'ti-ER',
	'Africa/Bamako': 'fr-ML',
	'Africa/Bangui': 'fr-CF',
	'Africa/Banjul': 'en-GM',
	'Africa/Bissau': 'pt-GW',
	'Africa/Blantyre': 'en-MW',
	'Africa/Brazzaville': 'fr-CG',
	'Africa/Bujumbura': 'fr-BI',
	'Africa/Cairo': 'ar-EG',
	'Africa/Casablanca': 'ar-MA',
	'Africa/Ceuta': 'es-ES',
	'Africa/Conakry': 'fr-GN',
	'Africa/Dakar': 'fr-SN',
	'Africa/Dar_es_Salaam': 'sw-TZ',
	'Africa/Djibouti': 'fr-DJ',
	'Africa/Douala': 'fr-CM',
	'Africa/El_Aaiun': 'ar-EH',
	'Africa/Freetown': 'en-SL',
	'Africa/Gaborone': 'en-BW',
	'Africa/Harare': 'en-ZW',
	'Africa/Johannesburg': 'en-ZA',
	'Africa/Juba': 'en-SS',
	'Africa/Kampala': 'en-UG',
	'Africa/Khartoum': 'ar-SD',
	'Africa/Kigali': 'rw-RW',
	'Africa/Kinshasa': 'fr-CD',
	'Africa/Lagos': 'en-NG',
	'Africa/Libreville': 'fr-GA',
	'Africa/Lome': 'fr-TG',
	'Africa/Luanda': 'pt-AO',
	'Africa/Lubumbashi': 'fr-CD',
	'Africa/Lusaka': 'en-ZM',
	'Africa/Malabo': 'es-GQ',
	'Africa/Maputo': 'pt-MZ',
	'Africa/Maseru': 'en-LS',
	'Africa/Mbabane': 'en-SZ',
	'Africa/Mogadishu': 'so-SO',
	'Africa/Monrovia': 'en-LR',
	'Africa/Nairobi': 'en-KE',
	'Africa/Ndjamena': 'fr-TD',
	'Africa/Niamey': 'fr-NE',
	'Africa/Nouakchott': 'ar-MR',
	'Africa/Ouagadougou': 'fr-BF',
	'Africa/Porto-Novo': 'fr-BJ',
	'Africa/Sao_Tome': 'pt-ST',
	'Africa/Tripoli': 'ar-LY',
	'Africa/Tunis': 'ar-TN',
	'Africa/Windhoek': 'en-NA',

	// Oceania
	'Australia/Adelaide': 'en-AU',
	'Australia/Brisbane': 'en-AU',
	'Australia/Broken_Hill': 'en-AU',
	'Australia/Darwin': 'en-AU',
	'Australia/Eucla': 'en-AU',
	'Australia/Hobart': 'en-AU',
	'Australia/Lindeman': 'en-AU',
	'Australia/Lord_Howe': 'en-AU',
	'Australia/Melbourne': 'en-AU',
	'Australia/Perth': 'en-AU',
	'Australia/Sydney': 'en-AU',

	// Pacific
	'Pacific/Apia': 'en-WS',
	'Pacific/Auckland': 'en-NZ',
	'Pacific/Bougainville': 'en-PG',
	'Pacific/Chatham': 'en-NZ',
	'Pacific/Chuuk': 'en-FM',
	'Pacific/Easter': 'es-CL',
	'Pacific/Efate': 'fr-VU',
	'Pacific/Enderbury': 'en-KI',
	'Pacific/Fakaofo': 'en-TK',
	'Pacific/Fiji': 'en-FJ',
	'Pacific/Funafuti': 'en-TV',
	'Pacific/Galapagos': 'es-EC',
	'Pacific/Gambier': 'fr-PF',
	'Pacific/Guadalcanal': 'en-SB',
	'Pacific/Guam': 'en-GU',
	'Pacific/Honolulu': 'en-US',
	'Pacific/Kiritimati': 'en-KI',
	'Pacific/Kosrae': 'en-FM',
	'Pacific/Kwajalein': 'en-MH',
	'Pacific/Majuro': 'en-MH',
	'Pacific/Marquesas': 'fr-PF',
	'Pacific/Midway': 'en-US',
	'Pacific/Nauru': 'en-NR',
	'Pacific/Niue': 'en-NU',
	'Pacific/Norfolk': 'en-NF',
	'Pacific/Noumea': 'fr-NC',
	'Pacific/Pago_Pago': 'en-AS',
	'Pacific/Palau': 'en-PW',
	'Pacific/Pitcairn': 'en-PN',
	'Pacific/Pohnpei': 'en-FM',
	'Pacific/Port_Moresby': 'en-PG',
	'Pacific/Rarotonga': 'en-CK',
	'Pacific/Tahiti': 'fr-PF',
	'Pacific/Tarawa': 'en-KI',
	'Pacific/Tongatapu': 'en-TO',
	'Pacific/Wake': 'en-US',
	'Pacific/Wallis': 'fr-WF',

	// Antarctica
	'Antarctica/Casey': 'en-AU',
	'Antarctica/Davis': 'en-AU',
	'Antarctica/DumontDUrville': 'fr-FR',
	'Antarctica/Macquarie': 'en-AU',
	'Antarctica/Mawson': 'en-AU',
	'Antarctica/McMurdo': 'en-NZ',
	'Antarctica/Palmer': 'en-US',
	'Antarctica/Rothera': 'en-GB',
	'Antarctica/Syowa': 'ja-JP',
	'Antarctica/Troll': 'nb-NO',
	'Antarctica/Vostok': 'ru-RU',
};

const _match = <T>(it: Iterator<T>, query: T) => {
	while (true) {
		const { value, done } = it.next();
		if (done || value === query) break;
	}
}

const _dropAlarms = function*(input: string) {
	const it = input.split('\n')[Symbol.iterator]();

	for (const line of it) {
		if (line === 'BEGIN:VALARM') {
			_match(it, 'END:VALARM');
		} else {
			yield line;
		}
	}
}

export const dropAlarms = (input: string) => {
	return [..._dropAlarms(input)].join('\n');
}
