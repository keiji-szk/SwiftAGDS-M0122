//
//  ProblemSet3(FloodFill).swift
//  SwiftAGDS
//
//  Created by 鈴木啓司 on 2022-08-09.
//

import Foundation

func tomatoFarm() -> Int {
	struct Square {
		let x: Int
		let y: Int
	}
	let adjPair = [(0,1), (0, -1), (1, 0), (-1, 0)]
	
	print("Tomato farm")
	let firstLine = readLine()!.split(separator: " ").map { Int($0)! }
	let width = firstLine[0]
	let height = firstLine[1]
	
	var grid = [[Int]]()	
	let q = Queue<Square>()
	for row in 0..<height {
		let line = readLine()!.split(separator: " ")
		var lineNum: [Int] = []
		for (col, str) in line.enumerated() {
			let num = Int(str)!
			lineNum.append(num)
			if num == 1 {
				q.enqueue(item: Square(x: col, y: row) )
			}
		}
		grid.append(lineNum)
	}
	
	var countDays = 1
	while !q.isEmpty() {
		let next = q.dequeue()!
		for adj in adjPair {
			let nx = next.x + adj.0
			let ny = next.y + adj.1
			if nx < 0 || width <= nx || ny < 0 || height <= ny {
				continue
			}
			
			if grid[ny][nx] != 0 {
				continue
			}
			
			let nextVal = grid[next.y][next.x] + 1
			grid[ny][nx] = nextVal
			countDays = max(nextVal, countDays)
			q.enqueue(item: Square(x: nx, y: ny))
		}
	}
	
	for h in 0..<height {
		if (grid[h].contains(0)) {
			print("-1")
			return -1
		}
	}
	
	print("\(countDays-1)")
	return countDays-1
}



func bridges() -> Int{
	struct Square {
		let x: Int
		let y: Int
	}
	let adjPair = [(0,1), (0, -1), (1, 0), (-1, 0)]
	
	print("Bridges")
	let numGrid = Int(readLine()!)!
	var islandMap: [[Int]] = []
	for _ in 0..<numGrid {
		let row = readLine()!.split(separator: " ").map { Int($0)! }
		islandMap.append(row)
	}
	
	func bfs(numGrid: Int, x: Int, y: Int, id: Int, groupMap: inout [[Int]] ) {
		let q = Queue<Square>()
		q.enqueue(item: Square(x: x, y: y))
		groupMap[y][x] = id
		
		while !q.isEmpty() {
			let next = q.dequeue()!			
			for adj in adjPair {
				let nx = next.x + adj.0
				let ny = next.y + adj.1
				if nx < 0 || numGrid <= nx || ny < 0 || numGrid <= ny {
					continue
				}
				
				if groupMap[ny][nx] != 1 {
					continue
				}
				
				groupMap[ny][nx] = id				
				q.enqueue(item: Square(x: nx, y: ny))
			}
		}
	}
	
	var id = 1
	var uncheckSquare:[Square] = []
	for x in 0..<numGrid {
		for y in 0..<numGrid {
			if islandMap[y][x] == 1 {
				id += 1
				bfs(numGrid: numGrid, x: x, y: y, id: id, groupMap: &islandMap)
			} else if islandMap[y][x] == 0 {
				uncheckSquare.append(Square(x: x, y: y))
			}
		}
	}
	
	var countCosts = 1
	printIsland(islandMap: islandMap)
	while !uncheckSquare.isEmpty {
		var isLandMarks : [(Square, Int)] = []
		uncheckSquare = uncheckSquare.filter{ 
			for adj in adjPair {
				let nx = $0.x + adj.0
				let ny = $0.y + adj.1
				if nx < 0 || numGrid <= nx || ny < 0 || numGrid <= ny {
					continue
				}
				
				if islandMap[ny][nx] == 0 {
					continue
				}
				
				let islandID = islandMap[ny][nx]
				isLandMarks.append((Square(x: $0.x, y: $0.y), islandID))
				return false				
			}
			return true
		}
		
		for elm in isLandMarks {
			let isLandID = elm.1
			islandMap[elm.0.y][elm.0.x] = isLandID
			for adj2 in adjPair {
				let nx2 = elm.0.x + adj2.0
				let ny2 = elm.0.y + adj2.1
				if nx2 < 0 || numGrid <= nx2 || ny2 < 0 || numGrid <= ny2 {
					continue
				}
				let nextIsLandID = islandMap[ny2][nx2]
				if nextIsLandID != 0 && nextIsLandID != isLandID {
					let isSameDistance = isLandMarks.contains(where: {
						$0.0.x == nx2 && $0.0.y == ny2
					}) 
					
					printIsland(islandMap: islandMap)
					let shortestDistance = isSameDistance ? countCosts * 2 : countCosts * 2 - 1
					print(shortestDistance)
					return shortestDistance
				}
			}
		}
		printIsland(islandMap: islandMap)
		countCosts += 1
	}
	
	return -1
}

func printIsland(islandMap: [[Int]]) {
	for arr in islandMap {
		print(arr)
	}
	print("")
}
