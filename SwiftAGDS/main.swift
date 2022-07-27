//
//  main.swift
//  SwiftAGDS
//
//  Created by Derrick Park on 2022-07-12.
//

import Foundation

let result1 = solveCyclicPermutation(num: 8, arr: [3,2,7,8,1,4,5,6])
assert(result1 == 3)

let result2 = solveCyclicPermutation(num: 10, arr: [2,1,3,4,5,6,7,9,10,8])
assert(result2 == 7)

let result3 = repeatingSequence(number: 57, p:2)
assert(result3 == 4)

let result4 = repeatingSequence(number: 62, p:3)
assert(result4 == 8)



//print("Enter something")
//let str = readLine(strippingNewline: true)!
//
//print("How many M number?:")
//let m = Int(readLine(strippingNewline: true)!)!
//
//print("Small elements: ")
//print(getSmallest(elements: Array(str), count: m))
//
//print("Large elements: ")
//print(getLargest(elements: Array(str), count: m))


// ------- 
//
//var numsStack = Stack<Int>()
//numsStack.push(1)
//numsStack.push(2)
//numsStack.push(6)
//numsStack.push(3)
//numsStack.push(2)
//numsStack.push(1)
//numsStack.pop()
//numsStack.pop()
//
//for num in numsStack {
//	print(num)
//}
//
//var numsQueue = Queue<Int>()
//numsQueue.dequeue()
//numsQueue.peak()
//
//numsQueue.enqueue(item: 3)
//numsQueue.enqueue(item: 4)
//numsQueue.enqueue(item: 2)
//
//print(numsQueue.dequeue())
//
//numsQueue.enqueue(item: 5)
//numsQueue.enqueue(item: 7)
//
//for num in numsQueue {
//	print(num)
//}
//
