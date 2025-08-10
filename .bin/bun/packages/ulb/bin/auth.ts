#!/usr/bin/env -S bun run

const puppeteer = require('puppeteer');
const fs = require('fs');

const URL_ROOT = 'https://172.19.78.1/web_auth' ;
const URL_LOGIN = `${URL_ROOT}/index.html` ;

const TYPE_UNKNOWN = 'unknown page' ;
const TYPE_LOGIN = 'login page' ;

const TIME_SECOND = 1000 ;
const TIME_MINUTE = TIME_SECOND * 60 ;
const TIME_HOUR = TIME_MINUTE * 60 ;
const TIME_HALF_HOUR = TIME_HOUR / 2 | 0 ;

const READ_RATE = TIME_SECOND * 3 ;

const SELECTOR_USERNAME = 'input[name="admin_id"]' ;
const SELECTOR_PASSWORD = 'input[name="admin_pw"]' ;

const sleep = ms => {
	console.log(`sleeping for ${ms} ms`)
	return new Promise(resolve => setTimeout(resolve, ms));
} ;

function main ( browser ) {

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
		ignoreHTTPSErrors: true ,
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

	await load( page , username , password );

}

async function load ( page , username , password ) {

	await page.goto(URL_LOGIN);

	while ( true ) {

		const _type = await type(page);
		console.log(_type);

		if (_type === TYPE_UNKNOWN) await sleep(READ_RATE);
		else if (_type === TYPE_LOGIN) break ;

	}

	await login(page, username, password);

}

async function type ( page ) {

	const value = await page.evaluate((TYPE_LOGIN , TYPE_UNKNOWN, SELECTOR_USERNAME) => {
		if ( document.querySelector(SELECTOR_USERNAME) !== null ) return TYPE_LOGIN ;
		else return TYPE_UNKNOWN ;
	}, TYPE_LOGIN, TYPE_UNKNOWN, SELECTOR_USERNAME);

	return value ;

}

async function login (page, username, password) {

	lastlogin = Date.now();

	console.log( 'login' , username , password.replace(/./g, '*'));

	await page.evaluate( (username, password, SELECTOR_USERNAME, SELECTOR_PASSWORD) => {
		document.querySelector(SELECTOR_USERNAME).value = username;
		document.querySelector(SELECTOR_PASSWORD).value = password;
		document.forms[0].submit();
	}, username, password, SELECTOR_USERNAME, SELECTOR_PASSWORD);

	await page.waitForNavigation();

}

main();
