//
//  Stack.swift
//  SwiftAGDS
//
//  Created by Derrick Park on 2022-07-21.
//

import Foundation

/// The Stack class represents a last-in-first-out (LIFO) stack of generic items.
/// It supports the usual *push* and *pop* operations, along with methods for peeking at the top item, testing if the stack is empty, and iterating through the items in LIFO order.
/// This implementation uses a singly linked list with an inner class for linked list nodes.
public final class Stack<E> : Sequence {

	/// beginning of bag
	private var last: Node<E>? = nil
	
	/// number of elements in bag
	private(set) var count: Int = 0
	
	/// helper linked list node class
	fileprivate class Node<E> {
	  fileprivate var item: E
	  fileprivate var previous: Node<E>?
	  fileprivate init(item: E, previous: Node<E>?) {
		self.item = item
		self.previous = previous
	  }
	}
	
	/// Initializes an empty bag.
	public init() {}
	
	/// Returns true if this bag is empty.
	/// - Returns: true if this bag is empty, otherwise false.
	public func isEmpty() -> Bool {
	  return last == nil
	}
	
	public func push(_ element: E) {
		let oldLast = last
		last = Node(item: element, previous: oldLast)
		count += 1
	}
	
	public func pop() -> E? {
		guard let lastNode = last else {
			return nil
		}
		count -= 1
		last = last?.previous
		return lastNode.item
	}
	
	public func peek() -> E? {
		return last?.item
	}
	
	/// BagIterator that iterates over the items in this bag in arbitrary order. (reverse order)
	public struct StackIterator<E> : IteratorProtocol {
	  private var current: Node<E>?
	  
	  fileprivate init(_ first: Node<E>?) {
		self.current = first
	  }
	  
	  public mutating func next() -> E? {
		if let item = current?.item {
			current = current?.previous
		  return item
		}
		return nil
	  }
	}
	
	/// Returns an iterator that iterates over the items in this bag in reverse order.
	public func makeIterator() -> StackIterator<E> {
	  return StackIterator(last)
	}
}
