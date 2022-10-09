import * as fs from 'fs';
import * as readline from 'readline';
import { insertNSort } from './topX_helper';

// Change the parameter below
const inputFile = 'test.txt'; // input file
const topXCount = 10; // top X largest number


var topXArray = new Array(topXCount).fill(0);

async function topX() {
  try {
    const rl = readline.createInterface({
      input: fs.createReadStream(inputFile, {
        highWaterMark: 32 * 1024, // read file in chunks of 32 kb in this case, so not reading everything at once into memory
      }),
      crlfDelay: Infinity,
    });

    for await (const ln of rl) {
      insertNSort(topXArray, Number(ln));
    }
    console.log(`Top ${topXCount} number(s) - ${topXArray}`);
  } catch (errMsg) {
    console.log(`Error - Message ${errMsg}` );
  }
}

topX();
