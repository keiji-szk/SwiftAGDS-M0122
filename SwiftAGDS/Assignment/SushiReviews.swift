//
//  SushiReviews.swift
//  SwiftAGDS
//
//  Created by 鈴木啓司 on 2022-08-04.
//

import Foundation

func testSolutionSushiReview() {
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
			var trueRestaurant: Set<Int> = []
			for tr in secondLine {
				trueRestaurant.insert(Int(tr)!)
			}
			
			var dataset: Array<(Int, Int)> = []
			for i in 2..<nodeCount+1 {
				let line = inputData[i].split(separator: " ")		
				dataset.append((Int(line[0])!, Int(line[1])!))
			}
			
			var visited = Array<Bool>.init(repeating: false, count: nodeCount)
			let aList = makeAdjescencyList(n: nodeCount, dataset: dataset)
			let cost = getMinimumPath(rootIndex: trueRestaurant.first!, 
									  fromIndex: trueRestaurant.first!, 
									  aList: aList, 
									  trueRestaurant: trueRestaurant, 
									  visited: &visited)
			
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
}

func consoleSolutionSushiReview() {
	print("Paste input data")
	let firstLine = readLine()!.split(separator: " ")
	let nodeCount = Int(firstLine.first!)!
	let secondLine = readLine()!.split(separator: " ")
	var trueRestaurant: Set<Int> = []
	for tr in secondLine {
		trueRestaurant.insert(Int(tr)!)
	}
	
	var dataset: Array<(Int, Int)> = []
	for _ in 0..<nodeCount-1 {
		let line = readLine()!.split(separator: " ")		
		dataset.append((Int(line[0])!, Int(line[1])!))
	}
	
	var visited = Array<Bool>.init(repeating: false, count: nodeCount)
	visited[trueRestaurant.first!] = true
	let aList = makeAdjescencyList(n: nodeCount, dataset: dataset)
	let cost = getMinimumPath(rootIndex: trueRestaurant.first!, 
							  fromIndex: trueRestaurant.first!, 
							  aList: aList, 
							  trueRestaurant: trueRestaurant, 
							  visited: &visited)
	print(cost)
}

func makeAdjescencyList(n: Int, dataset: Array<(Int, Int)>) -> Array<Array<Int>>{
	var result = Array<Array<Int>>.init(repeating: [], count: n)
	for data in dataset {
		result[data.0].append(data.1)
		result[data.1].append(data.0)
	}	
	return result
}

func getMinimumPath(rootIndex: Int, fromIndex: Int, aList: Array<Array<Int>>, trueRestaurant: Set<Int>, visited: inout Array<Bool> ) -> Int{
	
	let childArray = aList[fromIndex]
	
	// If this is the end leaf
	if rootIndex != fromIndex && childArray.count == 1 {
		if trueRestaurant.contains(childArray[0]){
			return 1
		}else {
			return 0
		}
	}
	
	var childCost: Array<Int> = []
	for child in childArray {
		if visited[child] {
			continue
		}
		
		visited[child] = true
		let val = getMinimumPath(rootIndex: rootIndex, 
								 fromIndex: child, 
								 aList: aList, 
								 trueRestaurant: trueRestaurant, 
								 visited: &visited)
		if val != 0 {
			childCost.append(val)
		}
	}
	
	if childCost.isEmpty {
		return trueRestaurant.contains(fromIndex) ? 1 : 0 
	}
	
	if childCost.count == 1{
		return rootIndex == fromIndex ? childCost[0] : childCost[0] + 1
	}
	
	var totalCost = 0
	childCost = childCost.sorted()
	
	let deductCount = (rootIndex == fromIndex) ? 2 : 1
	for i in 0..<childCost.count - deductCount {
		// Add the round-trip cost.
		totalCost += childCost[i] * 2
	}
	
	for _ in 0..<deductCount {
		totalCost += childCost.popLast()!
	}
	
	return totalCost
}
