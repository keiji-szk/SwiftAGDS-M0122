//
//  Excercises_UnionFind.swift
//  SwiftAGDS
//
//  Created by 鈴木啓司 on 2022-08-17.
//

import Foundation

class SolutionUnionFind {
	func findCircleNum(_ isConnected: [[Int]]) -> Int {
		let cityNum = isConnected.count
		var uf = UF(cityNum)
		for (i, arr) in isConnected.enumerated(){
			for j in 0..<cityNum {
				if j == i {
					continue
				}
				
				if arr[j] == 1 {
					uf.union(i, j)
				}
			}
		}
		
		var provinces = Set<Int>()
		for i in 0..<cityNum {
			provinces.insert(uf.find(i))
		}
		
		return provinces.count
	}
	
	func findRedundantConnection(_ edges: [[Int]]) -> [Int] {
		var dict = [Int:Int]()
		let n = edges.count
		for i in 1...n {
			dict[i] = i
		}
		
		func union(_ p:Int, _ q: Int) -> Bool{
			let pId = dict[p]
			let qId = dict[q]
			if pId == qId {
				return false
			}
			
			for d in dict {
				if d.value == pId {
					dict[d.key] = qId
				}
			}
			return true
		}
		
		
		for edge in edges {
			if !union(edge[0], edge[1]) {
				return edge
			}
		}
		return []
	}
	
	func longestConsecutive(_ nums: [Int]) -> Int {
		if nums.isEmpty {
			return 0
		}
		
		var sortedNums = nums.sorted(by: <)
		var curMax = 1
		var maxVal = curMax
		var prevNum = sortedNums.first!
		for num in sortedNums {
			if num == prevNum {
				continue
			} 
			
			if num == prevNum + 1 {
				curMax += 1
			} else {
				curMax = 1
			}
			
			maxVal = max(maxVal, curMax)
			prevNum = num
		}
		
		return maxVal
	}
}
