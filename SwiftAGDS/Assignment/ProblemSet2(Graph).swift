//
//  ProblemSet2(Graph).swift
//  SwiftAGDS
//
//  Created by 鈴木啓司 on 2022-07-27.
//

import Foundation

func solveCyclicPermutation( num: Int, arr: [Int] ) -> Int {
	if num != arr.count {
		return -1
	}
	
	var count = 1
	var index: Int? = 1
	var dictionary = Dictionary<Int, Int>()
	for (i, value) in arr.enumerated() {
		dictionary[i+1] = value
	}
	
	repeat {
		if let next = dictionary[index!] {
			dictionary.removeValue(forKey: index!)
			index = next
		}else{
			count += 1
			index = dictionary.first?.key
		}
	}while(!dictionary.isEmpty)
	
	return count
}

func repeatingSequence(number: Int, p: Int) -> Int {
	if p < 1 || 5 < p {
		return -1
	}
	
	var arr: [Int] = []
	var value = number
	
	while(!arr.contains(value)){
		arr.append(value)
		var nextValue = 0
		while value != 0 {
			nextValue += power(base: (value % 10), exponent: p )
			value = value/10
		}
		value = nextValue
	}
	print(arr)
	return arr.firstIndex(where: {$0 == value})!
}
