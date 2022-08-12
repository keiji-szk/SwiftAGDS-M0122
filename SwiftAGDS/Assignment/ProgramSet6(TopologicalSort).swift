//
//  ProgramSet6(TopologicalSort).swift
//  SwiftAGDS
//
//  Created by 鈴木啓司 on 2022-08-11.
//

import Foundation

// problem 1
class Solution {
	func canFinish(_ numCourses: Int, _ prerequisites: [[Int]]) -> Bool {
		var adj = [[Int]](repeating: [], count: numCourses)
		var indegree = [Int](repeating: 0, count: numCourses)
		for pq in prerequisites {
			indegree[pq[0]] += 1
			adj[pq[1]].append(pq[0])
		}
		
		var stack:[Int] = []
		for i in 0..<numCourses {
			if indegree[i] == 0 {
				stack.append(i)
			}
		}
		
		var visitCount = 0
		while(!stack.isEmpty) {
			let elm = stack.popLast()!
			visitCount += 1
			let nextAdj = adj[elm]
			for n in nextAdj {
				indegree[n] -= 1
				if indegree[n] == 0 {
					stack.append(n)
				}
			}
		}
		
		return visitCount == numCourses
	}
	
	func findOrder(_ numCourses: Int, _ prerequisites: [[Int]]) -> [Int] {
		var adj = [[Int]](repeating: [], count: numCourses)
		var indegree = [Int](repeating: 0, count: numCourses)
		for pq in prerequisites {
			indegree[pq[0]] += 1
			adj[pq[1]].append(pq[0])
		}
		
		var queue:[Int] = []
		for i in 0..<numCourses {
			if indegree[i] == 0 {
				queue.append(i)
			}
		}
		
		var visitCount = 0
		var result: [Int] = []
		while(!queue.isEmpty) {
			let elm = queue.removeFirst()
			result.append(elm)
			visitCount += 1
			let nextAdj = adj[elm]
			for n in nextAdj {
				indegree[n] -= 1
				if indegree[n] == 0 {
					queue.append(n)
				}
			}
		}
		
		if (visitCount != numCourses) {
			return []
		}
		
		return result
	}
}
