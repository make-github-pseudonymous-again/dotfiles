#!/usr/bin/env -S bun run

import readline from 'node:readline';

import zxcvbn from 'zxcvbn';

var rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false
});

rl.on('line', function(password){
	var result = zxcvbn(password);
	console.log(result.crack_times_display.offline_fast_hashing_1e10_per_second);
});
