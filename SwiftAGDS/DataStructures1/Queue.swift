//
//  Queue.swift
//  SwiftAGDS
//
//  Created by Derrick Park on 2022-07-21.
//

import Foundation

/// The Queue class represents a first-in-first-out (FIFO) queue of generic items.
/// It supports the usual *eunque* and *dequeue* operations, along with methods for peeking at the first item, testing if the queue is empty, and iterating through the items in FIFO order.
/// This implementation uses a singly linked list with an inner class for linked list nodes.

public final class Queue<E> : Sequence {
	private var head: Node<E>? = nil
	
	/// number of elements in queue
	private(set) var count: Int = 0
	
	/// helper linked list node class
	fileprivate class Node<E> {
		fileprivate var item: E
		fileprivate var next: Node<E>?
		fileprivate init(item: E, next: Node<E>?) {
			self.item = item
			self.next = next
		}
	}
	
	/// Initializes an empty queue.
	public init() {}

	public func enqueue(item: E) {				
		if head == nil{
			head = Node(item: item, next: nil)
			return
		}
		
		var next = head
		while next?.next != nil {
			next = next?.next
		}
		next?.next = Node(item: item, next: nil)
	}
	
	public func dequeue() -> E? {
		guard let oldHead = head else{
			return nil
		} 
		head = head?.next
		return oldHead.item
	}
	
	public func peak() -> E? {
		return head?.item
	}
	
	public func isEmpty() -> Bool {
		return head == nil
	}
	
	/// BagIterator that iterates over the items in this bag in arbitrary order. (reverse order)
	public struct QueueIterator<E> : IteratorProtocol {
		private var current: Node<E>?
		
		fileprivate init(_ first: Node<E>?) {
			self.current = first
		}
		
		public mutating func next() -> E? {
			if let item = current?.item {
				current = current?.next
				return item
			}
			return nil
		}
	}
	
	/// Returns an iterator that iterates over the items in this bag in reverse order.
	public func makeIterator() -> QueueIterator<E> {
		return QueueIterator(head)
	}
}
