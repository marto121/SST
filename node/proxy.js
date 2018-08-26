/**
 * @module proxy
 * @license MIT
 * @version 2017/11/09
 */

'use strict';

// Import lib
const fs = require('fs');
const arch = require('arch');
const path = require('path');
const spawn = require('child_process').spawn;
const spawnSync = require('child_process').spawnSync;

// Variable declaration
const x64 = arch() === 'x64';
const sysroot = process.env['systemroot'] || process.env['windir'];
const cscript = path.join(sysroot, x64 ? 'SysWOW64' : 'System32', 'cscript.exe');

/**
 * @function exec
 * @param {string} command
 * @param {Object} params
 * @returns {Promise}
 */
exports.execSync = function (script, command, params) {
  const scriptPath = path.join(__dirname, script);
  try {
    const stdio = spawnSync(cscript, [scriptPath, '//E:JScript', '//Nologo', '//U', '//B', command], { windowsHide: true, input: JSON.stringify(params) })
    if (stdio.status) {
      return new Error("Error executing script " + script + ". Message: " + JSON.parse(stdio.stderr.toString('utf16le')).Error)
    } else {
      return JSON.parse(stdio.stdout.toString('utf16le'))
    }
  } catch (e) {
    return new Error("Error executing spawnSync: " + e.toString());
  }
}
exports.exec = function(script, command, params) {
  const scriptPath = path.join(__dirname, script);
  return new Promise((resolve, reject) => {
    // Exec commond
    const stdio = spawn(cscript, [scriptPath, '//E:JScript', '//Nologo', '//U', '//B', command], { windowsHide: true });

    // Stdout
    stdio.stdout.on('data', data => {
      // Decode data use utf16le
      data = data.toString('utf16le');

      try {
        // Parse json data
        data = JSON.parse(data);
      } catch (error) {
        return reject(data);
      }

      // Is valid json
      resolve(data);
    });

    // Stderr
    stdio.stderr.on('data', data => {
      reject(new Error(data.toString('utf16le')));
    });

    // Exec error
    stdio.on('error', error => {
      reject(error);
    });

    // Send params
    stdio.stdin.end(JSON.stringify(params), 'utf16le');
  });
};
