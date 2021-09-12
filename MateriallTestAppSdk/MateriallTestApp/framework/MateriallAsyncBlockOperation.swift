//
//  MateriallAsyncBlockOperation.swift
//  Materiall
//
//  Created by Prasenjit Das on 15/03/21.
//

import Foundation

private let NSOperationIsExecutingKey = "isExecuting"
private let NSOperationIsFinishedKey = "isFinished"

public typealias OperationBlock = () -> Void


/// Simple block operation that blocks the operationQueue until complete() is called
internal class MateriallAsyncBlockOperation: Operation {
    
    typealias CompleteBlock = ()->()
    public var operationBlock: ((@escaping CompleteBlock)->())
    public var identifier: String? = nil
    
    private var _isFinished = false {
        willSet {
            self.willChangeValue(forKey: NSOperationIsFinishedKey)
        }
        didSet {
            self.didChangeValue(forKey: NSOperationIsFinishedKey)
        }
    }
    
    private var _isExecuting = false {
        willSet {
            self.willChangeValue(forKey: NSOperationIsExecutingKey)
        }
        didSet {
            self.didChangeValue(forKey: NSOperationIsExecutingKey)
        }
    }
    
    init(_ operationBlock: @escaping (@escaping CompleteBlock)->()) {
        self.operationBlock = operationBlock
    }
    
    override internal func start() {
        if self.isCancelled {
            self._isFinished = true
        }
        else if !self.isFinished && !self.isExecuting {
            self._isExecuting = true
            self.main()
        }
    }
    
    override internal func main() {
        operationBlock(complete)
    }
    
    override internal var isExecuting: Bool {
        return self._isExecuting
    }
    
    override internal var isFinished: Bool {
        return self._isFinished
    }
    
    internal func complete() {
        self._isExecuting = false
        self._isFinished = true
    }
}



