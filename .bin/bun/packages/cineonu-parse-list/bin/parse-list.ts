#!/usr/bin/env -S bun run

const fs = require("fs");
const jsdom = require('jsdom') ;
const { JSDOM } = jsdom ;

const SELECTOR_EVENTS = "#current > ul > li > a"

function main ( ) {

	const text = fs.readFileSync("/dev/stdin", "utf-8");
	const json = parse(text);
	const output = JSON.stringify(json) ;
	console.log(output) ;

}

function parse ( text ) {

	const dom = new JSDOM(text);
	const document = dom.window.document;

	const transformEvent = node => ({
		url: node.href,
		title: node.children[0].textContent,
	}) ;

	const url = document.baseURI;
	const events = [ ...document.querySelectorAll(SELECTOR_EVENTS).values()].map(transformEvent);

	const json = {
		url ,
		events ,
	} ;

	return json;
}

main();
