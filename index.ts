import { splitEvery, range } from 'ramda'

console.time('time')
console.log('Starting join...')

const timeout = <T>(num: T) => new Promise<T>(res => setTimeout(() => res(num), 200))

const promJoin = <T>(j: Monoid<T>) => (a: T) => (b: T) => timeout(j.join(a, b))

const sequentialJoin = <T>(j: Monoid<T>) => ([h, ...t]: T[]) => {
  return t
    .reduce((acc, item) => acc.then(promJoin(j)(item)), Promise.resolve(h))
}

const parallelJoin = <T>(j: Monoid<T>) => (nums: T[]): Promise<T> => {
  if (nums.length === 1) {
    return Promise.resolve(nums[0])
  }
  return Promise.all(splitEvery(2, nums)
    .map(([a, b]) => promJoin(j)(a)(b)))
    .then(parallelJoin(j))
}

interface Monoid<T> {
  join: (a: T, b: T) => T
  nil: T
}

const divide: Monoid<number> = {
  join: (a, b) => a / b,
  nil: 1,
}

parallelJoin(divide)(range(1, 17))
  .then(x => {
    console.log('result:', x)
    console.timeEnd('time')
  })

// sequentialJoin(concat)(range(0, 26).map(x => String.fromCharCode(97 + x)))
//   .then(x => {
//     console.log('result:', x)
//     console.timeEnd('timer')
//   })

const add: Monoid<number> = {
  join: (a, b) => a + b,
  nil: 0,
}

const concat: Monoid<string> = {
  join: (a, b) => (a === 'b' ? 'j' : 'n') + b,
  // join: (a, b) => a + b,
  nil: '',
}
