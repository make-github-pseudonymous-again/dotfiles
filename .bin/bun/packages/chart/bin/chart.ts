#!/usr/bin/env -S bun run

import fs from 'node:fs';
import process from 'node:process';

import blessed from 'blessed';
import contrib from 'blessed-contrib';

const chart = process.argv[2];
const source = process.argv[3];

const blob = fs.readFileSync(source).toString();

const json = JSON.parse(blob);
const data = json.data;
const options = json.options;

console.error(chart, data, options);

const screen = blessed.screen();

const widget = contrib[chart](options);

screen.append(widget) //must append before setting data

widget.setData(data);

screen.key(['C-c'], function(ch, key) {
 return process.exit(0);
});

screen.render();
