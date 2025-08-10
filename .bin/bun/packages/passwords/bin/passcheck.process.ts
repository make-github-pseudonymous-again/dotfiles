#!/usr/bin/env -S bun run

import readline from 'node:readline';

import zxcvbn from 'zxcvbn';

import ora from 'ora';

const progress = ora({
  text: 'Analyzing passwords ...',
}).start();

function Passwords ( ) {
  this.map = new Map();
}

Passwords.prototype.add = function (key, password) {
  if (!this.map.has(password)) {
    const meta = zxcvbn(password);
    this.map.set(password, {keys: [key], password, meta});
  }
  else {
    this.map.get(password).keys.push(key);
  }
};

Passwords.prototype[Symbol.iterator] = function () {
  return this.map.values();
};

const passwords = new Passwords();

let count = 0;
let done = 0;

function update ( ) {
  progress.text = `Analyzing passwords (${done}/${count}) ...`;
}

function output ( ) {
  return {
    passwords: [...passwords],
  };
}

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false
});

rl.on('line', function(line){
  ++count; update();
  const [key, ...parts] = line.split(' ');
  const password = parts.join(' ');
  passwords.add(key, password);
  ++done; update();
});

rl.on('close', function(){

  progress.succeed(`Analyzed ${count} passwords`);

  console.log(JSON.stringify(output()));

});
