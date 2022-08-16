//
//  ProblemSet7(GreedyAlgorithm).swift
//  SwiftAGDS
//
//  Created by 鈴木啓司 on 2022-08-15.
//

import Foundation

// problem 1. Two City Scheduling 
func twoCitySchedCost(_ costs: [[Int]]) -> Int {
	var pairIndexDiff: [(Int, Int)] = []
	for (i,cost) in costs.enumerated() {
		pairIndexDiff.append((i, cost[0] - cost[1]))
	}
	
	pairIndexDiff = pairIndexDiff.sorted(by: { (left, right) in
		left.1 < right.1
	})
		
	var cost = 0
	let n = costs.count / 2
	for i in 0..<n {
		cost += costs[pairIndexDiff[i].0][0]
	}
	for j in n..<costs.count {
		cost += costs[pairIndexDiff[j].0][1]
	}
	
	return cost
}

// problem 2. Meeting Rooms 
func canAttendMeetings(_ intervals: [[Int]]) -> Bool {
	let sortedIntervals = intervals.sorted(by: { (left, right) in
		left[0] < right[0]
	} )
	
	for i in 0..<sortedIntervals.count - 1 {
		if sortedIntervals[i][1] > sortedIntervals[i+1][0] {
			return false
		}
	}
	
	return true
}

// problem 3. Gas Station
func canCompleteCircuit(_ gas: [Int], _ cost: [Int]) -> Int {
	
	if gas.reduce(0, +) < cost.reduce(0, +) {
		return -1 
	}
	var total = 0, startIndex = 0

	for index in 0..<gas.count {
		total += gas[index] - cost[index]
		if total < 0 {
			total = 0
			startIndex = index+1
		}
	}

	return startIndex
}

// problem 4. Partition Labels
func partitionLabels(_ s: String) -> [Int] {
	var mapCharEnd = [Character:Int]()
	let sChars = Array(s)
	for (i, c) in sChars.enumerated() {
		mapCharEnd[c] = i 
	}
	
	var ans = [Int]()
	var curStart = 0
	var curEnd = 0
	while curStart < sChars.count {
		let charStart = sChars[curStart]
		curEnd = mapCharEnd[charStart]!
		var j = curStart
		while(j < curEnd) {
			let newEnd = mapCharEnd[sChars[j]]!
			if curEnd < newEnd {
				curEnd = newEnd
			}			
			j += 1
		}
		
		ans.append(curEnd - curStart + 1)
		curStart = curEnd + 1
	}
	
	return ans
}

// problem 5. Task Scheduler
// I couldn't solve it

//func leastInterval(_ tasks: [Character], _ n: Int) -> Int {
//	var mapCharCount = [Character:Int]()
//	for c in tasks {
//		if mapCharCount.keys.contains(c) {
//			mapCharCount[c]! += 1
//		} else {
//			mapCharCount[c] = 1
//		}
//	}
//	
//	var ans = 0
//	while !mapCharCount.isEmpty {
//		var minCommonVal = mapCharCount.first!.value
//		for v in mapCharCount.values {
//			if v < minCommonVal {
//				minCommonVal = v
//			}
//		}
//		
//		var reducedCharCount = 0
//		mapCharCount = mapCharCount.mapValues{ value in
//			let ret = value - minCommonVal
//			if ret <= 0 {
//				reducedCharCount += 1
//			}
//			return ret
//		}
//		
//		let interVal = min(reducedCharCount, minCommonVal) - 1
//		ans += minCommonVal * mapCharCount.count + interVal * n
//		
//		mapCharCount = mapCharCount.filter(){
//			return 0 < $0.value 
//		}
//	}
//	return ans
//}
