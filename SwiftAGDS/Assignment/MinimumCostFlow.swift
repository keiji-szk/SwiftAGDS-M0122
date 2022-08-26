//
//  MinimumCostFlow.swift
//  SwiftAGDS
//
//  Created by 鈴木啓司 on 2022-08-20.
//

// sample 1 : not applied enhancer
//7 8 1
//1 2 3
//1 3 3
//3 6 2
//6 4 3
//6 5 8
//5 7 3
//6 7 6
//3 5 4
//
// output:2

// sample 2 : applied enhancer
//7 8 3
//1 2 3
//1 3 3
//3 6 2
//6 4 3
//6 5 8
//5 7 3
//6 7 6
//3 5 4
//
// output:1

import Foundation

func minCostFlowConsole() {
	print("MCF")
	
	let firstLine = readLine()!.split(separator: " ").map { Int($0)! }
	let n = firstLine[0]
	let m = firstLine[1]
	let d = firstLine[2]
	
	var input = [[Int]]()
	for _ in 1...m {
		let line = readLine()!.split(separator: " ").map { Int($0)! }
		input.append([line[0], line[1], line[2]])
	}
	
	let ret = minCostFlow(n: n, m: m, d: d, data: input)
	print(ret)
}

func minCostFlow(n: Int, m: Int, d: Int, data: [[Int]]) -> Int {
	
	func dfs(start: Int, target:Int, adjList: [[(v:Int, c:Int)]], res: inout [(p:Int, q:Int, c:Int)], visited: inout [Bool]) {
		visited[start] = true
		for vc in adjList[start] {
			if visited[vc.v] {
				continue
			}
			
			res.append((start, vc.v, vc.c))
			if vc.v == target {
				return
			}			
			dfs(start: vc.v, target: target, adjList: adjList, res: &res, visited: &visited)
			if res.last!.q == target || res.last!.p == target {
				return
			}			
			_ = res.popLast()
		}
	}
	
	func disconnectEdge(p: Int, q: Int, adjList: inout [[(v:Int, c:Int)]]) {
		for (i, pEdge) in adjList[p].enumerated() {
			if pEdge.v == q {
				adjList[p].remove(at: i)
				break
			}
		}
		
		for (j, qEdge) in adjList[q].enumerated() {
			if qEdge.v == p {
				adjList[q].remove(at: j)
				break
			}
		}
	}
	
	func connectEdge(p: Int, q: Int, c: Int, adjList: inout [[(v:Int, c:Int)]]) {
		adjList[p].append((q, c))
		adjList[q].append((p, c))
	}
	
	// -----------	
	//  main logic
	// -----------
	var adjList = [[(v:Int, c:Int)]].init(repeating: [], count: n + 1)
	var addEdges = [(p:Int, q:Int, c:Int)]()
	for i in 0..<m {
		let p = data[i][0]
		let q = data[i][1]
		let c = data[i][2]
		if i < n - 1 {
			adjList[p].append((q, c))
			adjList[q].append((p, c))			
		}else {
			addEdges.append((p, q, c))
		}
	}
	
	addEdges = addEdges.sorted(by: {
		$0.c < $1.c
	})
	
	var countDays = 0
	var isUsedEnhancer = false
	for addEdge in addEdges {
		var visited = [Bool].init(repeating: false, count: n + 1)
		var route = [(p:Int, q:Int, c:Int)]()
		dfs(start: addEdge.p, target: addEdge.q, adjList: adjList, res: &route, visited: &visited)
		
		var maxCostEdge = route.first!
		for vc in route {
			if maxCostEdge.c < vc.c {
				maxCostEdge = vc
			}			
		}
		
		if maxCostEdge.c < addEdge.c {
			continue
		}
		
		// Should enhancer be applied?
		if !isUsedEnhancer {
			let deduction = maxCostEdge.c < d ? maxCostEdge.c : d 
			if maxCostEdge.c - deduction <= addEdge.c {
				isUsedEnhancer = true
				continue
			}
		}
		
		disconnectEdge(p: maxCostEdge.p, q: maxCostEdge.q, adjList: &adjList)
		connectEdge(p: addEdge.p, q: addEdge.q, c: addEdge.c, adjList: &adjList)
		countDays += 1
	}
	
	return countDays
}


func mcfAutoTest() {
	print("Input the path of the test folder")
//	var path = readLine()!
	var path = "/Users/suzukikeiji/Desktop/SwiftAGDS-M0122/SwiftAGDS/Assignment/mcfTestCases"
	
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
			
			let n = Int(firstLine[0])!
			let m = Int(firstLine[1])!
			let d = Int(firstLine[2])!
			
			var data = [[Int]]()
			for i in 1...m {
				let lineData = inputData[i].split(separator: " ").map{Int($0)!}
				data.append(lineData)
			}
			
			let res = minCostFlow(n: n, m: m, d: d, data: data)
			let ans = Int(outputText.split(separator: "\n").first!)!
			
			if res == ans {
				print("Succeeded! test:\(fileName), answer is \(ans)")				
			}else {
				print("Failured! test:\(fileName), answer is \(ans) but yours is \(res)")
			}			
		}catch {
			print("Failure to read: \(fileName)")
		}
	}
	
	print("Test completed!")
}
