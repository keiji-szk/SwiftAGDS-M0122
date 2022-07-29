//
//  TreeTraversal.swift
//  SwiftAGDS
//
//  Created by 鈴木啓司 on 2022-07-28.
//

import Foundation


func preOrder(_ node: Int){
	if node == -1 {
		return
	}
	
	print(Character(UnicodeScalar(node + 65)!), terminator: "")
	preOrder(tree[node][0])
	preOrder(tree[node][1])	
}


var tree = [[Int]](repeating: [Int](repeating: 0, count: 2), count: 26)

func treeTraversal(){
	let n = Int(readLine()!)!
	for _ in 0..<n
	{
		let nodeInfo = readLine()!.split(separator: " ").map{String($0)}
		let x = Int(Character(nodeInfo[0]).asciiValue! - 65)
		let l = Int(Character(nodeInfo[0]).asciiValue!)
		let r = Int(Character(nodeInfo[0]).asciiValue!)
		
		// ascii . == 46 -> -1
		tree[x][0] = l == 46 ? -1 : l - 65
		tree[x][1] = r == 46 ? -1 : l - 65
	}
	preOrder(0)
}
