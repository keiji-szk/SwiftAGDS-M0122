//
//  SushiReviews.swift
//  SwiftAGDS
//
//  Created by 鈴木啓司 on 2022-08-04.
//

import Foundation

class SushiGraph {
	private(set) var adjList : [Set<Int>]
	private(set) var edgeNumber: Int = 0 
	
	init(n: Int){
		adjList = Array<Set<Int>>.init(repeating: [], count: n)
	}
	
	func addEdge(from: Int, to: Int) {
		adjList[from].insert(to)
		adjList[to].insert(from)
		edgeNumber += 1
	}
	
	func degree(of: Int)->Int{
		return adjList[of].count
	}
	
	func removeAllEdges(from: Int) {
		let neighbors = adjList[from]
		adjList[from].removeAll()
		for n in neighbors {
			edgeNumber -= 1
			adjList[n].remove(from)
		}
	}
}


func sushi(graph: SushiGraph, realSushi: Set<Int>) -> Int {
	func bfs(graph: SushiGraph, start: Int, visited: inout [Bool], depth: inout [Int]) {
		let q = Queue<Int>()
		visited[start] = true
		
		q.enqueue(item: start)
		while !q.isEmpty() {
			let x = q.dequeue()!
			let neighbors = graph.adjList[x]
			for n in neighbors {
				if visited[n]{
					continue
				}
				
				depth[n] = depth[x] + 1
				q.enqueue(item: n)
				visited[n] = true
			}
		}		
	}
	
	func removeLeaves(from graph: SushiGraph, v: Int, sushi: Set<Int>, visited: inout [Bool]){
		visited[v] = true
		
		for u in graph.adjList[v] {
			if visited[u] {
				continue
			} 
			removeLeaves(from: graph, v: u, sushi: sushi, visited: &visited)
		}
		
		if graph.degree(of: v) == 1 && !sushi.contains(v) {
			graph.removeAllEdges(from: v)
		}
	}
	
	let n = graph.adjList.count
	let start = realSushi.first!
	var visited = Array<Bool>.init(repeating: false, count: n)
	
	removeLeaves(from: graph, v: start, sushi: realSushi, visited: &visited)
	
	var visited1 = Array<Bool>.init(repeating: false, count: n)
	var depth1 = Array<Int>.init(repeating: 0, count: n)
	var maxV = realSushi.first!
	var maxD = depth1[maxV]
	bfs(graph: graph, start: realSushi.first!, visited: &visited1, depth: &depth1)
	for i in 0..<n {
		if maxD < depth1[i] {
			maxD = depth1[i]
			maxV = i
		}
	}
	
	var visited2 = Array<Bool>.init(repeating: false, count: n)
	var depth2 = Array<Int>.init(repeating: 0, count: n)
	bfs(graph: graph, start: maxV, visited: &visited2, depth: &depth2)
	
	return graph.edgeNumber * 2 - depth2.max()!
}


func sushiConsole() {
	
	let firstLine = readLine()!.split(separator: " ").map{Int($0)!}
	let n = firstLine[0]
	
	let nextLine = readLine()!.split(separator: " ").map{Int($0)!}
	let realSushi = Set<Int>(nextLine)
	
	let graph = SushiGraph(n: n)
	for _ in 0..<n-1 {
		let edge = readLine()!.split(separator: " ").map{Int($0)!}
		graph.addEdge(from: edge[0], to: edge[1])
	}
	
	print(sushi(graph: graph, realSushi: realSushi))
}


func sushiAutoTest() {
	print("Input the path of the test folder")
	var path = readLine()!
	
	if path.last != "/" {
		path += "/"
	}
	
	for fileName in getFileInfoListInDir(path){		
		if fileName.pathExtension != "in" {
			continue
		}
		
		do {
			let inputText = try String(contentsOfFile: path + (fileName as String) )	
			let outputText = try String(contentsOfFile: path + ( fileName.deletingPathExtension as String) + ".out")	
			
			// read input file
			let inputData = inputText.split(separator: "\n")
			let firstLine = inputData[0].split(separator: " ")
			let nodeCount = Int(firstLine.first!)!
			let secondLine = inputData[1].split(separator: " ")
			var realSushi: Set<Int> = []
			for tr in secondLine {
				realSushi.insert(Int(tr)!)
			}
			
			var graph = SushiGraph(n: nodeCount)
			for i in 2..<nodeCount+1 {
				let line = inputData[i].split(separator: " ")		
				graph.addEdge(from: Int(line[0])!, to: Int(line[1])!)
			}
			
			let cost = sushi(graph: graph, realSushi: realSushi)
			
			// read output file
			let outputResult = outputText.split(separator: "\n")
			let rightValue = Int(outputResult.first!)
			
			// check Result
			if rightValue == cost {
				print("Succeeded! test:\(fileName)")				
			}else {
				print("Failured! test:\(fileName)")
			}
			
			
		}catch {
			print("Failure to read: \(fileName)")
		}
	}
	
	print("Test completed!")
}

//
// Aug 5. 
//

//
//func consoleSolutionSushiReview() {
//	print("Paste input data")
//	let firstLine = readLine()!.split(separator: " ")
//	let nodeCount = Int(firstLine.first!)!
//	let secondLine = readLine()!.split(separator: " ")
//	var trueRestaurant: Set<Int> = []
//	for tr in secondLine {
//		trueRestaurant.insert(Int(tr)!)
//	}
//	
//	var dataset: Array<(Int, Int)> = []
//	for _ in 0..<nodeCount-1 {
//		let line = readLine()!.split(separator: " ")		
//		dataset.append((Int(line[0])!, Int(line[1])!))
//	}
//	
//	var visited = Array<Bool>.init(repeating: false, count: nodeCount)
//	visited[trueRestaurant.first!] = true
//	let aList = makeAdjescencyList(n: nodeCount, dataset: dataset)
//	let cost = getMinimumPath(rootIndex: trueRestaurant.first!, 
//							  fromIndex: trueRestaurant.first!, 
//							  aList: aList, 
//							  trueRestaurant: trueRestaurant, 
//							  visited: &visited)
//	print(cost)
//}
//
//func makeAdjescencyList(n: Int, dataset: Array<(Int, Int)>) -> Array<Array<Int>>{
//	var result = Array<Array<Int>>.init(repeating: [], count: n)
//	for data in dataset {
//		result[data.0].append(data.1)
//		result[data.1].append(data.0)
//	}	
//	return result
//}
//
//func getMinimumPath(rootIndex: Int, fromIndex: Int, aList: Array<Array<Int>>, trueRestaurant: Set<Int>, visited: inout Array<Bool> ) -> Int{
//	
//	let childArray = aList[fromIndex]
//	
//	// If this is the end leaf
//	if rootIndex != fromIndex && childArray.count == 1 {
//		if trueRestaurant.contains(childArray[0]){
//			return 1
//		}else {
//			return 0
//		}
//	}
//	
//	var childCost: Array<Int> = []
//	for child in childArray {
//		if visited[child] {
//			continue
//		}
//		
//		visited[child] = true
//		let val = getMinimumPath(rootIndex: rootIndex, 
//								 fromIndex: child, 
//								 aList: aList, 
//								 trueRestaurant: trueRestaurant, 
//								 visited: &visited)
//		if val != 0 {
//			childCost.append(val)
//		}
//	}
//	
//	if childCost.isEmpty {
//		return trueRestaurant.contains(fromIndex) ? 1 : 0 
//	}
//	
//	if childCost.count == 1{
//		return rootIndex == fromIndex ? childCost[0] : childCost[0] + 1
//	}
//	
//	var totalCost = 0
//	childCost = childCost.sorted()
//	
//	let deductCount = (rootIndex == fromIndex) ? 2 : 1
//	for i in 0..<childCost.count - deductCount {
//		// Add the round-trip cost.
//		totalCost += childCost[i] * 2
//	}
//	
//	for _ in 0..<deductCount {
//		totalCost += childCost.popLast()!
//	}
//	
//	return totalCost
//}
