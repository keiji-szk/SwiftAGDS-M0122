//
//  ProblemSet2(Graph).swift
//  SwiftAGDS
//
//  Created by 鈴木啓司 on 2022-07-27.
//

import Foundation

// problem 1
// 
// * main.swift
// let result1 = solveCyclicPermutation(arr: [3,2,7,8,1,4,5,6])
// assert(result1 == 3)
// let result2 = solveCyclicPermutation(arr: [2,1,3,4,5,6,7,9,10,8])
// assert(result2 == 7)
func solveCyclicPermutation( arr: [Int] ) -> Int {
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

// problem 2
//
// * main.swift
// let result3 = repeatingSequence(number: 57, pow:2)
// assert(result3 == 4)
// let result4 = repeatingSequence(number: 62, pow:3)
// assert(result4 == 8)
func repeatingSequence(number: Int, pow: Int) -> Int {
	if pow < 1 || 5 < pow {
		return -1
	}
	
	var arr: [Int] = []
	var value = number
	
	while(!arr.contains(value)){
		arr.append(value)
		var nextValue = 0
		while value != 0 {
			nextValue += power( base: (value % 10), exponent: pow )
			value = value/10
		}
		value = nextValue
	}
	print(arr)
	return arr.firstIndex(where: {$0 == value})!
}

// problem 3
func findJudge(_ n: Int, _ trust: [[Int]]) -> Int {	
	if n == 1 && trust.isEmpty{
		return 1
	}
	
	var score = Array<Int>.init(repeating: 0, count: n + 1)
	
	for elm in trust {
		score[elm[0]] = score[elm[0]] - 1
		score[elm[1]] = score[elm[1]] + 1
	}
	
	for (index, candidate) in score.enumerated() {
		if candidate == n-1 {
			return index
		}
	}
	
	return -1
}

// problem 4
func findCircleNum(_ isConnected: [[Int]]) -> Int {
	func dfs(_ isConnected: [[Int]], _ isVisited: inout [Bool], _ i: Int){
		for j in 0..<isVisited.count {
			if isConnected[i][j] == 1 && !isVisited[j] {
				isVisited[j] = true
				dfs(isConnected, &isVisited, j)
			}
		}
	}
	
	var isVisited = Array<Bool>.init(repeating: false, count: isConnected.count)
	var count = 0
	for i in 0..<isConnected.count {
		if isVisited[i] {
			continue
		}
		
		count += 1
		dfs(isConnected, &isVisited, i)			
	}
	return count
}


// problem 5
func findCenter(_ edges: [[Int]]) -> Int {
	let candidate1 = edges.first![0]
	let candidate2 = edges.first![1]
	
	for i in edges.last! {
		if i == candidate1{
			return candidate1
		}
		
		if i == candidate2 {
			return candidate2
		}
	}
	return -1
}
