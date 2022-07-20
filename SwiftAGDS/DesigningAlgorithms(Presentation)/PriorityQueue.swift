//
//  PriorityQueue.swift
//  SwiftAGDS
//
//  Created by 鈴木啓司 on 2022-07-20.
//

import Foundation

func getSmallest<E:Comparable>(elements: Array<E>, count:Int ) -> Array<E> {
	// O(N)
	let que = PriorityQueue(inputElm: elements, isAscending:true )
	var ret:Array<E> = []
	
	// O(M*logN)
	// Because M < N, M*logN < N*logM  
	for _ in 0..<count {
		ret.append(que.pop())
	}
	return ret
}

func getLargest<E:Comparable>(elements: Array<E>, count:Int ) -> Array<E> {
	// O(N)
	let que = PriorityQueue(inputElm: elements, isAscending:false )
	var ret:Array<E> = []
	
	// O(M*logN)
	// Because M < N, M*logN < N*logM  
	for _ in 0..<count {
		ret.append(que.pop())
	}
	return ret
}

class PriorityQueue<E:Comparable> {
	var elements: Array<E>
	var isAscending: Bool
	
	init (inputElm: Array<E>, isAscending: Bool ) {
		self.elements = inputElm
		self.isAscending = isAscending
		buildHeap()
	}
	
	// O(N)
	private func buildHeap(){
		// Index of last non-leaf node
		let startIdx = (elements.count / 2) - 1;
		for i in (0...startIdx).reversed() {
			heapify(i)
		}
	}
	
	// Time complexity: O(N)
	private func heapify( _ index: Int) {
		
		var parent = index
		let left = 2*index + 1
		let right = 2*index + 2
		let size = elements.count
		
		if left < size && priorityToRight(left: elements[parent], right: elements[left]) {
			parent = left
		}
		
		if right < size && priorityToRight(left: elements[parent], right: elements[right]) {
			parent = right
		}
				
		if parent != index {
			elements.swapAt(parent, index)
			heapify(parent)
		}
		
	}
	
	private func priorityToRight(left: E, right: E) -> Bool {
		if isAscending {
			return right < left
		}else{
			return left < right
		}
	}
		
	// Time complexity: O(logN)
	func pop() -> E {
		let ret = elements[0]
		elements.swapAt(0, elements.count - 1)
		elements.removeLast()
		heapify(0)
		return ret
	}
}
