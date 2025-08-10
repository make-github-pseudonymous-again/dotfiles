#!/usr/bin/env -S bun run

const fs = require("fs");
const jsdom = require('jsdom') ;
const { JSDOM } = jsdom ;

const SELECTOR_TITLE = ".article-inside h3" ;
const SELECTOR_DATETIME_AND_LOCATION = ".article-inside > table > tbody > tr:nth-child(1) > td:nth-child(1) > p";
const SELECTOR_RUNTIME = ".article-inside > table > tbody > tr:nth-child(1) > td:nth-child(2) > p";
const SELECTOR_IMG = [
	'.article-inside img[title*="poster"]',
	'.article-inside img[title*="cover"]',
	'.article-inside img[title*="image"]',
	'.article-inside img[alt*="poster"]',
	'.article-inside img[alt*="cover"]',
	'.article-inside img[alt*="image"]',
	'.article-inside img[src*="poster"]',
	'.article-inside img[src*="cover"]',
	'.article-inside img[src*="image"]',
].join(', ');
const SELECTOR_TRAILER = "div.nice:nth-child(1) > div:nth-child(1) > div:nth-child(1) > div:nth-child(1) > div:nth-child(1) > p:nth-child(2) > iframe:nth-child(1)";
const SELECTOR_IMDB = '.article-inside a[href^="https://www.imdb.com"]';
const SELECTOR_FACEBOOK = '.article-inside a[href^="https://www.facebook.com"]';
const SELECTOR_EVENTBRITE = '.article-inside a[href^="https://www.eventbrite.com"]';
const SELECTOR_BOZAR = '.article-inside a[href^="https://brussel.iticketsro.com/Bozar"]';
const SELECTOR_DESCRIPTION = ".article-inside > table:nth-child(3) > tbody:nth-child(1) > tr:nth-child(2) > td:nth-child(1)";

function main ( ) {

	const text = fs.readFileSync("/dev/stdin", "utf-8");
	const json = parse(text);
	const output = JSON.stringify(json) ;
	console.log(output) ;

}

function parse ( text ) {

	const dom = new JSDOM(text);
	const document = dom.window.document;

	const get = selector => document.querySelector(selector) || {} ;

	const url = document.baseURI;
	const year = url.split('/')[4];
	const title = get(SELECTOR_TITLE).textContent;
	const datetimeAndLocation = get(SELECTOR_DATETIME_AND_LOCATION).textContent;
	const runtime = (get(SELECTOR_RUNTIME).textContent || '').split(' ')[1];
	const img = get(SELECTOR_IMG).src;
	const trailer = get(SELECTOR_TRAILER).src;
	const imdb = get(SELECTOR_IMDB).href;
	const facebook = get(SELECTOR_FACEBOOK).href;
	const eventbrite = get(SELECTOR_EVENTBRITE).href;
	const bozar = get(SELECTOR_BOZAR).href;
	const description = (get(SELECTOR_DESCRIPTION).textContent || '').trim();

	const [date, timeAndlocation] = datetimeAndLocation.split(', ');
	const [time, location] = timeAndlocation.slice(0,timeAndlocation.length-1).split(' (');

	const json = {
		url ,
		year ,
		title ,
		date ,
		time ,
		location ,
		runtime ,
		img ,
		trailer ,
		imdb ,
		facebook ,
		eventbrite ,
		bozar ,
		description ,
	} ;

	return json;
}

main();
