import { insertNSort } from './topX_helper';


describe('Top 1 number', () => {
  const topXCount = 1;
  var array = new Array(topXCount).fill(0);

  test('', () => {
    insertNSort(array, 1);
    expect(array).toEqual([1]);
  });

  test('', () => {
    insertNSort(array, 2);
    expect(array).toEqual([2]);
  });

  test('', () => {
    insertNSort(array, 2);
    expect(array).toEqual([2]);
  });

  test('', () => {
    insertNSort(array, 1);
    expect(array).toEqual([2]);
  });

  test('', () => {
    insertNSort(array, 0);
    expect(array).toEqual([2]);
  });

  test('', () => {
    insertNSort(array, 5);
    expect(array).toEqual([5]);
  });

  test('', () => {
    insertNSort(array, 5);
    expect(array).toEqual([5]);
  });

  test('', () => {
    insertNSort(array, 1);
    expect(array).toEqual([5]);
  });
});

describe('Top 2 numbers', () => {
  const topXCount = 2;
  var array = new Array(topXCount).fill(0);

  test('', () => {
    insertNSort(array, 1);
    expect(array).toEqual([1, 0]);
  });

  test('', () => {
    insertNSort(array, 2);
    expect(array).toEqual([2, 1]);
  });

  test('', () => {
    insertNSort(array, 0);
    expect(array).toEqual([2, 1]);
  });

  test('', () => {
    insertNSort(array, 3);
    expect(array).toEqual([3, 2]);
  });

  test('', () => {
    insertNSort(array, 5);
    expect(array).toEqual([5, 3]);
  });

  test('', () => {
    insertNSort(array, 4);
    expect(array).toEqual([5, 4]);
  });

  test('', () => {
    insertNSort(array, 3);
    expect(array).toEqual([5, 4]);
  });
});

describe('Top odd numbers', () => {
  const topXCount = 3;
  var array = new Array(topXCount).fill(0);

  test('', () => {
    insertNSort(array, 1);
    expect(array).toEqual([1, 0, 0]);
  });

  test('', () => {
    insertNSort(array, 2);
    expect(array).toEqual([2, 1, 0]);
  });

  test('', () => {
    insertNSort(array, 0);
    expect(array).toEqual([2, 1, 0]);
  });

  test('', () => {
    insertNSort(array, 3);
    expect(array).toEqual([3, 2, 1]);
  });

  test('', () => {
    insertNSort(array, 5);
    expect(array).toEqual([5, 3, 2]);
  });

  test('', () => {
    insertNSort(array, 4);
    expect(array).toEqual([5, 4, 3]);
  });

  test('', () => {
    insertNSort(array, 3);
    expect(array).toEqual([5, 4, 3]);
  });

  test('', () => {
    insertNSort(array, 2);
    expect(array).toEqual([5, 4, 3]);
  });

  test('', () => {
    insertNSort(array, 6);
    expect(array).toEqual([6, 5, 4]);
  });

  test('', () => {
    insertNSort(array, 2);
    expect(array).toEqual([6, 5, 4]);
  });

  test('', () => {
    insertNSort(array, 5);
    expect(array).toEqual([6, 5, 4]);
  });

  test('', () => {
    insertNSort(array, 6);
    expect(array).toEqual([6, 5, 4]);
  });

  test('', () => {
    insertNSort(array, 3);
    expect(array).toEqual([6, 5, 4]);
  });
});

describe('Top even numbers', () => {
  const topXCount = 4;
  var array = new Array(topXCount).fill(0);

  test('', () => {
    insertNSort(array, 1);
    expect(array).toEqual([1, 0, 0, 0]);
  });

  test('', () => {
    insertNSort(array, 1);
    expect(array).toEqual([1, 0, 0, 0]);
  });

  test('', () => {
    insertNSort(array, 2);
    expect(array).toEqual([2, 1, 0, 0]);
  });

  test('', () => {
    insertNSort(array, 3);
    expect(array).toEqual([3, 2, 1, 0]);
  });

  test('', () => {
    insertNSort(array, 2);
    expect(array).toEqual([3, 2, 1, 0]);
  });

  test('', () => {
    insertNSort(array, 1);
    expect(array).toEqual([3, 2, 1, 0]);
  });

  test('', () => {
    insertNSort(array, 6);
    expect(array).toEqual([6, 3, 2, 1]);
  });

  test('', () => {
    insertNSort(array, 6);
    expect(array).toEqual([6, 3, 2, 1]);
  });

  test('', () => {
    insertNSort(array, 5);
    expect(array).toEqual([6, 5, 3, 2]);
  });

  test('', () => {
    insertNSort(array, 1);
    expect(array).toEqual([6, 5, 3, 2]);
  });

  test('', () => {
    insertNSort(array, 3);
    expect(array).toEqual([6, 5, 3, 2]);
  });

  test('', () => {
    insertNSort(array, 8);
    expect(array).toEqual([8, 6, 5, 3]);
  });

  test('', () => {
    insertNSort(array, 2);
    expect(array).toEqual([8, 6, 5, 3]);
  });

  test('', () => {
    insertNSort(array, 3);
    expect(array).toEqual([8, 6, 5, 3]);
  });

  test('', () => {
    insertNSort(array, 4);
    expect(array).toEqual([8, 6, 5, 4]);
  });

  test('', () => {
    insertNSort(array, 4);
    expect(array).toEqual([8, 6, 5, 4]);
  });

  test('', () => {
    insertNSort(array, 8);
    expect(array).toEqual([8, 6, 5, 4]);
  });

  test('', () => {
    insertNSort(array, 9);
    expect(array).toEqual([9, 8, 6, 5]);
  });

  test('', () => {
    insertNSort(array, 9);
    expect(array).toEqual([9, 8, 6, 5]);
  });

  test('', () => {
    insertNSort(array, 6);
    expect(array).toEqual([9, 8, 6, 5]);
  });

  test('', () => {
    insertNSort(array, 5);
    expect(array).toEqual([9, 8, 6, 5]);
  });

  test('', () => {
    insertNSort(array, 3);
    expect(array).toEqual([9, 8, 6, 5]);
  });

  test('', () => {
    insertNSort(array, 10);
    expect(array).toEqual([10, 9, 8, 6]);
  });

  test('', () => {
    insertNSort(array, 7);
    expect(array).toEqual([10, 9, 8, 7]);
  });

  test('', () => {
    insertNSort(array, 4);
    expect(array).toEqual([10, 9, 8, 7]);
  });

});
