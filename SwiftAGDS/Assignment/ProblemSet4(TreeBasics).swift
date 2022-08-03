//
//  ProblemSet4(TreeBasics).swift
//  SwiftAGDS
//
//  Created by 鈴木啓司 on 2022-07-30.
//

import Foundation


// problem 1
func whoIsMyParentConsole() {
	let count = Int (readLine()!)!
	var edges: [[Int]] = []
	for _ in 1..<count {
		let line = readLine()!.split(separator: " ")
		edges.append([Int (line[0])!, Int (line[1])!])
	}
	
	for result in whoIsMyParent(count: count, edges: &edges){
		print(result)
	}
}

func whoIsMyParent(count: Int, edges: inout [[Int]]) -> [Int]{
	if count - 1 != edges.count || count < 2 {
		assert(false)
		return []
	}
	
	func searchParent(parentNode: Int, parent: inout [Int], edge: inout [[Int]]){
		if edge.isEmpty {
			return
		}
		
		var newParentNodes: [Int] = []
		edge = edge.filter{
			var childNode = -1
			if $0[0] == parentNode {
				childNode = $0[1]
			}else if $0[1] == parentNode {
				childNode = $0[0]				
			}
			
			if childNode < 0 {
				return true
			}
			newParentNodes.append(childNode)
			parent[childNode] = parentNode
			return false
		}
		
		for nPn in newParentNodes {
			searchParent(parentNode: nPn, parent: &parent, edge: &edge)
		}
	}
	
	var parent = Array<Int>.init(repeating: 0, count: count + 1)
	searchParent(parentNode: 1, parent: &parent, edge: &edges)
	
	parent.removeFirst(2)
	return parent
}

//func whoIsMyParent(count: Int, edges: inout [[Int]]) -> [Int]{
//	class Node {
//		var childIndex: [Int] = []
//	}
//	
//	var relationNodes: [Node] = Array<Node>.init(repeating: Node(), count: count + 1)
//	for edge in edges {
//		relationNodes[edge[0]].childIndex.append(edge[1])
//	}
//	
//	
//	func setParent(parentIndex: Int, relationNodes: inout [Node], result: inout [Int]){
//		for childIndex in relationNodes[parentIndex].childIndex {
//			result[childIndex] = parentIndex
//			setParent(parentIndex: childIndex, relationNodes: &relationNodes, result: &result)
//		}
//	}
//	
//	var result: [Int] = Array<Int>.init(repeating: 0, count: count + 1)
//	setParent(parentIndex: 1, relationNodes: &relationNodes, result: &result)
//	result.removeFirst(2)
//	return result
//}

// Bonus Question
func testWhoIsParent(){	
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
			var inputData = inputText.split(separator: "\n")
			let nodeCount = Int(inputData[0])!
			inputData.removeFirst()
			
			var edges: [[Int]] = []
			for line in inputData {
				let edge = line.split(separator: " ")
				edges.append([Int(edge[0])!, Int(edge[1])!])
			}
			let inputResult = whoIsMyParent(count: nodeCount, edges: &edges)
			
			// read output file
			let outputResult = outputText.split(separator: "\n")
			
			// check Result
			for i in 0..<nodeCount {
				let inVal = inputResult[i]
				let outVal = Int(outputResult[i])
				assert(inVal == outVal)
			}
			
		}catch {
			print("Failure to read: \(fileName)")
		}

	}
}

func getFileInfoListInDir(_ dirName: String) -> [NSString] {
	let fileManager = FileManager.default
	var files: [NSString] = []
	do {
		files = try fileManager.contentsOfDirectory(atPath: dirName) as [NSString]
	} catch {
		return files
	}
	return files
}


// problem 2
func treeDiameter() {
	
	func getMaxDistance(nodeCount: Int , from: Int , start: Int , weightedGraph: [[Int]]) -> Int {
		let edgeWeight = weightedGraph[start]
		var maxResult = 0
		for i in 0..<nodeCount {
			if edgeWeight[i] == 0 || i == from {
				continue
			}
			
			let candidateResult = getMaxDistance(nodeCount: nodeCount, from: start, start: i, weightedGraph: weightedGraph)
			maxResult = max(maxResult, candidateResult)
		}
		
		return edgeWeight[from] + maxResult
	}
	
	// make weight graph
	let nodeCount = Int(readLine()!)!
	var weighGraph = Array<Array<Int>>.init(repeating: Array<Int>.init(repeating: 0, count: nodeCount), count: nodeCount)
	for i in 0..<nodeCount {
		let line = readLine()!.split(separator: " ")
		for x in stride(from: 1, to: line.count - 1, by: 2){
			let nodeIndex = Int(line[x])! - 1
			let weight = Int(line[x+1])!
			weighGraph[i][nodeIndex] = weight
		}
	}
	
	// calculate all weight of paths
	var maxResult = 0
	for i in 0..<nodeCount {
		let nodeWeight = weighGraph[i]
		for j in 0..<nodeCount {
			if nodeWeight[j] == 0 {
				continue
			}
			let candidateWeight = getMaxDistance(nodeCount: nodeCount, 
												 from: i, 
												 start: j, 
												 weightedGraph: weighGraph)
			maxResult = max(maxResult, candidateWeight)
		}
	}
	
	print(maxResult)
}

