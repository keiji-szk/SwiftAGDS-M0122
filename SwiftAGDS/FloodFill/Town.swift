//
//  Town.swift
//  SwiftAGDS
//
//  Created by Derrick Park on 2022-08-09.
//

import Foundation



func town() {
	
	struct Square {
		let x: Int
		let y: Int
	}
	let dx = [0, 0, 1, -1]
	let dy = [1, -1, 0, 0]
	
	var townMap = [[Int]]()
	
	let n = Int(readLine()!)!
	
	
	var groupMap = [[Int]](repeating: [Int](repeating: 0, count: n), count: n)
	var answer = [Int]()
	
	for _ in 0..<n {
		let row = readLine()!.map { Int(String($0))! }
		townMap.append(row)
	}
	
	func bfs(x: Int, y: Int, id: Int) {
		let q = Queue<Square>()
		q.enqueue(item: Square(x: x, y: y))
		groupMap[x][y] = id
		answer[id] += 1
		
		var count = 0
		while !q.isEmpty() {
			let sq = q.dequeue()!
			let x = sq.x
			let y = sq.y
			for i in 0..<4 {
				let nx = x + dx[i]
				let ny = y + dy[i]
				if nx >= 0 && nx < n && ny >= 0 && ny < n {
					if townMap[nx][ny] == 1 && groupMap[nx][ny] == 0 {
						q.enqueue(item: Square(x: nx, y: ny))
						groupMap[nx][ny] = id
						count += 1
					}
				}
			}
		}
		
		answer.append(count)
	}
	
	var id = 0
	for x in 0..<n {
		for y in 0..<n {
			if townMap[x][y] == 1 && groupMap[x][y] == 0 {
				id += 1
				bfs(x: x, y: y, id: id)
			}
		}
	}
	print(id)
	answer = Array(answer[1...id])
	answer.sort()
	for i in 0..<id {
		print(answer[i])
	}
}
