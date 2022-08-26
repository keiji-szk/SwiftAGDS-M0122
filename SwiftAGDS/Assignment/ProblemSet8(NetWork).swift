//
//  ProblemSet8(NetWork).swift
//  SwiftAGDS
//
//  Created by 鈴木啓司 on 2022-08-22.
//

import Foundation

// ---------------
// No.1
// ---------------
func networkDelayTime(_ times: [[Int]], _ n: Int, _ k: Int) -> Int {
	var visited = [Bool].init(repeating: false, count: n + 1)
	var d = [Int].init(repeating: Int.max, count: n + 1)
	
	var adj = [[(v: Int, w: Int)]].init(repeating:[], count: n+1)
	for t in times {
		adj[t[0]].append((t[1], t[2]))
	}
	
	d[0] = 0
	d[k] = 0
	
	for _ in 0..<n-1 {
		var minWeight = Int.max
		var minVertex = 1
		for v in 1...n {
			if !visited[v] && d[v] < minWeight {
				minWeight = d[v]
				minVertex = v
			} 
		}
		
		visited[minVertex] = true
		for edge in adj[minVertex] {
			if d[edge.v] > d[minVertex] + edge.w {
				d[edge.v] = d[minVertex] + edge.w
			}
		}
	}
	
	if d.max() == Int.max {
		return -1
	}
	return d.max()!
}


// ---------------
// No.2
// ---------------
struct FCPNode : Comparable, Hashable {
	static func < (lhs: FCPNode, rhs: FCPNode) -> Bool {
		return lhs.price < rhs.price
	}
	
	var src : Int
	var price : Int
	var stops : Int
}
func findCheapestPrice(_ n: Int, _ flights: [[Int]], _ src: Int, _ dst: Int, _ k: Int) -> Int {
   
	var graph = Array(repeating: [FCPNode](), count: n)
	var que = IndexPriorityQueue<FCPNode>(>)
	var shortDistances = Array(repeating: Int.max, count: n)
	
	shortDistances[src] = 0
	
	for flight in flights {
		let source = flight[0]
		let dest = flight[1]
		let price = flight[2]
		graph[source].append(FCPNode(src: dest, price: price, stops: 0))
	}

	que.enqueue(FCPNode(src: src, price: 0, stops: 0))

	var minPrice = Int.max
	while !que.isEmpty {
		
		let node = que.dequeue()!
		if node.src == dst {
			minPrice = min(minPrice, node.price)
			continue
		}
		if k < node.stops {
			continue
		}
		
		for next in graph[node.src] {
			let distNext = node.price + next.price
			if distNext < shortDistances[next.src] {
				shortDistances[next.src] = distNext
				que.enqueue(FCPNode(src: next.src, price: distNext, stops: node.stops + 1))
			}
		}		
	}
	
	return minPrice == Int.max ? -1 : minPrice
}


// ---------------
// No.3
// ---------------
struct FTCNode: Comparable, Hashable {
	static func < (lhs: FTCNode, rhs: FTCNode) -> Bool {
		lhs.d < rhs.d
	}
	var n: Int
	var d: Int
}
func findTheCity(_ n: Int, _ edges: [[Int]], _ distanceThreshold: Int) -> Int {
	var adjList = [[(n:Int, w:Int)]].init(repeating: [], count: n)
	
	for edge in edges {
		let p = edge[0]
		let q = edge[1]
		let d = edge[2]
		adjList[p].append((q, d))
		adjList[q].append((p, d))
	}
	
	func getNumberOfNeighbors(city: Int) -> Int{
		var que = IndexPriorityQueue<FTCNode>(<)
		var visited = [Bool].init(repeating: false, count: n)
		que.enqueue(FTCNode(n:city, d: 0))
		
		while !que.isEmpty {
			let node = que.dequeue()!
			if visited[node.n] {
				continue
			}
			visited[node.n] = true
			
			for next in adjList[node.n] {
				let nextVal = node.d + next.w
				if distanceThreshold < nextVal {
					continue
				}
				que.enqueue(FTCNode(n: next.n, d: nextVal))
			}
		}
		return visited.filter({$0 == true}).count - 1
	}
	
	var res:(i:Int, num:Int) = (0, Int.max)
	for i in 0..<n {
		let cityNum = getNumberOfNeighbors(city: i)
		if cityNum <= res.num {
			res = (i, cityNum)
		} 
	}
	return res.i
}

// ---------------
// No.4
// ---------------
struct MPNode: Comparable, Hashable {
	static func < (lhs: MPNode, rhs: MPNode) -> Bool {
		return lhs.probability < rhs.probability
	}
	
	var index: Int
	var probability : Double
}
func maxProbability(_ n: Int, _ edges: [[Int]], _ succProb: [Double], _ start: Int, _ end: Int) -> Double {
	
	var adjList = [[(Int, Double)]].init(repeating: [], count: n)
	
	for i in 0..<edges.count {
		let p = edges[i][0]
		let q = edges[i][1]
		let sp = succProb[i]
		
		adjList[p].append((q, sp))
		adjList[q].append((p, sp))	
	}	
	
	var mp = [Double].init(repeating: 0.0, count: n)
	var que = IndexPriorityQueue<MPNode>(>) // Max heap
	que.enqueue(MPNode(index: start, probability: 1))
	
	while(!que.isEmpty) {
		let node = que.dequeue()!
		mp[node.index] = node.probability
		if node.index == end {
			break
		}
		
		for neighbor in adjList[node.index] {
			if 0.0 < mp[neighbor.0] {
				continue
			}
			que.enqueue(MPNode(index: neighbor.0, probability: node.probability * neighbor.1))
		}
	}
	
	return mp[end]
}


// ---------------
// No.5
// ---------------
struct MEPNode: Comparable, Hashable {
	static func < (lhs: MEPNode, rhs: MEPNode) -> Bool {
		lhs.diff < rhs.diff
	}
	
	var row: Int
	var col: Int
	var diff: Int
	
	var prevRow: Int = -1
	var prevCol: Int = -1
}

func minimumEffortPath(_ heights: [[Int]]) -> Int {
	let n = heights.count
	var prevNode = [[MEPNode]].init(repeating: [MEPNode].init(repeating: MEPNode(row: -1, col: -1, diff: -1), count: n), count: n)
	
	var que = IndexPriorityQueue<MEPNode>(<)
	que.enqueue(MEPNode(row: 0, col: 0, diff: 0))
	while(!que.isEmpty) {
		let node = que.dequeue()!
		prevNode[node.row][node.col] = MEPNode(row: node.row, 
											   col: node.col, 
											   diff: node.diff, 
											   prevRow: node.prevRow, 
											   prevCol: node.prevCol)
		
		if node.row == n - 1 && node.col == n - 1{
			break
		}
		
		var neighbors = [(row:Int, col:Int)]()
		if node.row != 0 {
			neighbors.append((node.row - 1, node.col))
		}
		if node.row != n - 1 {
			neighbors.append((node.row + 1, node.col))
		}
		if node.col != 0 {
			neighbors.append((node.row, node.col - 1))
		}
		if node.col != n-1 {
			neighbors.append((node.row, node.col + 1))
		}
		
		for neighbor in neighbors {
			if 0 <= prevNode[neighbor.row][neighbor.col].diff {
				continue
			}
			
			let diff = abs(heights[node.row][node.col] - heights[neighbor.row][neighbor.col])
			que.enqueue(MEPNode(row: neighbor.row, col: neighbor.col, diff: diff, prevRow: node.row, prevCol: node.col))
		}
	}
	
	var maxEffort = 0
	var startIndex = (n - 1, n - 1)
	while startIndex.0 != 0 && startIndex.1 != 0 {
		var prev = prevNode[startIndex.0][startIndex.1]
		maxEffort = max(prev.diff, maxEffort)
		startIndex = (prev.prevRow, prev.prevCol)
	}
	
	return maxEffort
}
