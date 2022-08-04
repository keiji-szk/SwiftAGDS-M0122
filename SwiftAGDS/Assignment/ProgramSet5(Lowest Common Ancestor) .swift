import Foundation

// copy-paste all your classes/structs used in the program.
class LCANode {
	var val : Int
	var children : [LCANode]
	init(val:Int) {
		self.val = val
		children = []
	}
}


func consoleSolutionLCA() {
	print("Paste input data")
	let count = Int (readLine()!)!
	var edges: [[Int]] = []
	for _ in 1..<count {
		let line = readLine()!.split(separator: " ")
		edges.append([Int (line[0])!, Int (line[1])!])
	}
	
	let mNumber = Int(readLine()!)!
	var requireTwoNodes = [(Int, Int)]()
	for _ in 0..<mNumber {
		let line = readLine()!.split(separator: " ")
		requireTwoNodes.append((Int (line[0])!, Int (line[1])!))		
	}
	
	var visited = Array<Bool>.init(repeating: false, count: count - 1 )
	let rootNode = convertDataToNode(root: 1, data: edges, visited: &visited)
	for nodePair in requireTwoNodes{
		let result = getLCA(rootNode: rootNode, p: nodePair.0, q: nodePair.1)
		assert(result != nil)
		print(result!.val)
	}
}

func testSolutionLCA() {
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
			let nodeCount = Int(inputData[0])!
			
			var edges: [[Int]] = []
			for i in 1..<nodeCount {
				let line = inputData[i].split(separator: " ")
				edges.append([Int(line[0])!, Int(line[1])!])				
			}
			
			var inputResult:[Int] = []
			let mNumber = Int(inputData[nodeCount])!
			var visited = Array<Bool>.init(repeating: false, count: nodeCount - 1 )
			let rootNode = convertDataToNode(root: 1, data: edges, visited: &visited)
			for i in nodeCount+1 ..< nodeCount+mNumber+1 {
				let line = inputData[i].split(separator: " ")
				let result = getLCA(rootNode: rootNode, p: Int(line[0])!, q: Int(line[1])!)
				inputResult.append(result!.val)
			}
			
			// read output file
			let outputResult = outputText.split(separator: "\n")
			
			// check Result
			for i in 0..<mNumber {
				let inVal = inputResult[i]
				let outVal = Int(outputResult[i])
				assert(inVal == outVal)
			}
			print("Succeeded! test:\(fileName)")
			
		}catch {
			print("Failure to read: \(fileName)")
		}

	}
}

func convertDataToNode(root: Int, data: [[Int]], visited: inout [Bool] ) -> LCANode {
	let resultNode = LCANode(val: root)
	var childData: [[Int]] = []
	for (index, datum) in data.enumerated() {
		if visited[index] {
			continue
		}
		
		if datum[0] == root || datum[1] == root {
			visited[index] = true
			childData.append(datum)
		}
	}
	
	
	for childDatum in childData {
		let childValue = childDatum[0] == root ? childDatum[1] : childDatum[0] 
		let childNode = convertDataToNode(root: childValue, data: data, visited: &visited)
		resultNode.children.append(childNode)
	}
	
	return resultNode
}


//func convertDataToNode(root: Int, data: inout [[Int]]) -> LCANode {
//	let resultNode = LCANode(val: root)
//	var childIndex: [Int] = []
//	var childData: [[Int]] = []
//	for (index, datum) in data.enumerated() {
//		if datum[0] == root || datum[1] == root {
//			childIndex.append(index)
//			childData.append(datum)
//		}
//	}
//	
//	for i in childIndex.reversed() {
//		data.remove(at: i)
//	}
//	
//	for childDatum in childData {
//		let childValue = childDatum[0] == root ? childDatum[1] : childDatum[0] 
//		let childNode = convertDataToNode(root: childValue, data: &data)
//		resultNode.children.append(childNode)
//	}
//	
//	return resultNode
//}

// This time complexity is O(N), not O(logN). 
// I don't think it's possible to make it O(logN) 
func getLCA(rootNode: LCANode, p: Int, q: Int) -> LCANode? {
	if rootNode.val == p || rootNode.val == q {
		return rootNode
	}
	
	if rootNode.children.isEmpty {
		return nil
	}
	
	var findedChildLCANode: [LCANode] = []
	for childNode in rootNode.children {
		let childLCA = getLCA(rootNode: childNode, p: p, q: q)
		if childLCA == nil {
			continue
		}
		
		findedChildLCANode.append(childLCA!)
 	}
	
	if findedChildLCANode.isEmpty {
		return nil
	}
	
	if 2 < findedChildLCANode.count {
		assert(false)
		return nil
	}
	
	if 2 == findedChildLCANode.count {
		return rootNode
	}
	
	return findedChildLCANode[0]
}
