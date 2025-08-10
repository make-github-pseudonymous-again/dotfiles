#!/usr/bin/env -S bun run

const puppeteer = require('puppeteer');
const fs = require('fs');

const HOME = process.env['HOME'] ;
const CACHE = HOME + '/.cache/voo' ;
const CACHE_INFO = CACHE + '/info.json' ;

console.log('HOME', HOME);
console.log('CACHE', CACHE);
console.log('CACHE_INFO', CACHE_INFO);

const URL_ROOT = 'https://newmy.voo.be' ;
const URL_CONSUMPTION = `${URL_ROOT}/internet/consumption` ;

const TYPE_UNKNOWN = 'unknown page' ;
const TYPE_LOGIN = 'login page' ;
const TYPE_LOGIN_ERROR = 'login error' ;
const TYPE_CONSUMPTION = 'consumption page' ;
const TYPE_CONSUMPTION_UNLIMITED = 'unlimited consumption page' ;
const TYPE_TIMEOUT = 'timeout error' ;

const TIME_SECOND = 1000 ;
const TIME_MINUTE = TIME_SECOND * 60 ;
const TIME_HOUR = TIME_MINUTE * 60 ;
const TIME_HALF_HOUR = TIME_HOUR / 2 | 0 ;

//currently non polling, single fetch is done, polling is handled by shell script
//const POLL_RATE = TIME_HALF_HOUR ;
//const POLL_RATE = TIME_MINUTE ;
const READ_RATE = TIME_SECOND * 3 ;
const LOGIN_WAIT = TIME_MINUTE ;
const TIMEOUT = TIME_MINUTE ;

let lastlogin = 0 ;
let lastevent = 0 ;

const sleep = ms => {
	console.log(`sleeping for ${ms} ms`)
	return new Promise(resolve => setTimeout(resolve, ms));
} ;

function main ( browser ) {

	try {
		fs.mkdirSync(CACHE);
	}
	catch ( e ) {
		if (e && e.code !== 'EEXIST') {
			console.error(e);
			process.exit(67);
		}
	}

	// parse username and password
	const input = fs.readFileSync('/dev/stdin').toString().split('\n');

	switch (input.length) {
		case 0:
			console.log('Could not find username or password');
			process.exit(1);
			break;
		case 1:
			console.log('Could not find password');
			process.exit(2);
			break;
	}

	const username = input[0];
	const password = input[1];

	const options = {
		executablePath: '/usr/bin/chromium' ,
		//headless: false, // debug
		//slowMo: 250,     // debug
	} ;

	puppeteer
		.launch(options)
		.then(async browser => {
			await poll(browser, username, password);
			await browser.close();
		})
		.catch( err => {
			console.log(err) ;
			process.exit(100) ;
		}) ;

}

async function poll ( browser , username , password ) {

	console.log( 'credentials' , username , password.replace(/./g, '*'));

	const page = await browser.newPage();

	//page.onError = function (msg, trace) {
		//console.log(msg);
		//trace.forEach(function(item) {
			//console.log('  ', item.file, ':', item.line);
		//});
	//};

	//while ( true ) { // NOT POLLING ATM
		//await load(page , username, password);
		//await sleep(POLL_RATE);
	//}
	return await load( page , username , password );

}

async function load ( page , username , password ) {

	await page.goto(URL_CONSUMPTION);

	while ( true ) {

		const _type = await type(page);
		console.log(_type);

		if (_type === TYPE_TIMEOUT || _type === TYPE_LOGIN_ERROR) return 32;

		else if (_type === TYPE_UNKNOWN) await sleep(READ_RATE);

		else if (_type === TYPE_LOGIN) {
			await login(page, username, password);
			await sleep(READ_RATE);
		}

		else {
			const data = await getinfo(_type, page);
			write(data);
			return 0;
		}

	}

}

async function type ( page ) {

	const now = Date.now();
	if (lastevent > 0 && now - lastevent >= TIMEOUT) return TYPE_TIMEOUT;

	const value = await page.evaluate((lastlogin, LOGIN_WAIT, TYPE_LOGIN, TYPE_LOGIN_ERROR, TYPE_CONSUMPTION, TYPE_CONSUMPTION_UNLIMITED , TYPE_UNKNOWN) => {
		const now = Date.now();
		if ( now - lastlogin >= LOGIN_WAIT && document.getElementById('email') !== null ) return TYPE_LOGIN ;
		else if ( document.querySelector('.validation-summary-errors') !== null ) return TYPE_LOGIN_ERROR ;
		else if ( document.querySelector('.month-consumption-value') !== null ) return TYPE_CONSUMPTION_UNLIMITED ;
		else return TYPE_UNKNOWN ;
	}, lastlogin, LOGIN_WAIT, TYPE_LOGIN, TYPE_LOGIN_ERROR, TYPE_CONSUMPTION, TYPE_CONSUMPTION_UNLIMITED , TYPE_UNKNOWN);

	if ( value !== TYPE_UNKNOWN ) lastevent = Date.now() ;

	return value ;

}

async function login (page, username, password) {

	lastlogin = Date.now();

	console.log( 'login' , username , password.replace(/./g, '*'));

	return await page.evaluate( (username, password) => {
		document.getElementById('email').value = username;
		document.getElementById('incognito').value = password;
		document.getElementsByTagName('form')[0].submit();
	}, username, password);

}

async function getinfo ( _type , page ) {

	const current = await page.evaluate(
		() => document.querySelector('.month-consumption-value').innerText
	);

	const current_float = parseFloat(current.match(/^[0-9]*(,[0-9]*)?/)[0].replace(',', '.')) ;
	const current_unit = current.match(/[a-zA-Z]*$/)[0];

	const max = 'unlimited' ;
	const max_float = null ;
	const max_unit = null ;

	const data = {
		'consumption' : {
			'current' : {
				'raw' : current ,
				'amount' : current_float ,
				'unit' : current_unit
			} ,
			'max' : {
				'raw' : max ,
				'amount' : max_float ,
				'unit' : max_unit
			}
		}
	} ;

	return data ;

}

function write ( data ) {

	const cache = JSON.stringify(data);

	console.log(cache) ;

	fs.writeFileSync(CACHE_INFO, cache);

}

main();
