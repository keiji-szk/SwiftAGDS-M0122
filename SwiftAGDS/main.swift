//
//  main.swift
//  SwiftAGDS
//
//  Created by Derrick Park on 2022-07-12.
//

import Foundation


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

var numsStack = Stack<Int>()
numsStack.push(1)
numsStack.push(2)
numsStack.push(6)
numsStack.push(3)
numsStack.push(2)
numsStack.push(1)
numsStack.pop()
numsStack.pop()

for num in numsStack {
	print(num)
}

var numsQueue = Queue<Int>()
numsQueue.dequeue()
numsQueue.peak()

numsQueue.enqueue(item: 3)
numsQueue.enqueue(item: 4)
numsQueue.enqueue(item: 2)

print(numsQueue.dequeue())

numsQueue.enqueue(item: 5)
numsQueue.enqueue(item: 7)

for num in numsQueue {
	print(num)
}

