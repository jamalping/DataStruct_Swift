import UIKit

// MARK: 输出打印
protocol Printable {
    func reversePrint()
    func printf()
}

class LinkNode<T> {
    var value: T
    var next: LinkNode? = nil // 下一个节点
    weak var previous: LinkNode? = nil // 前一个节点
    init(_ value: T) {
        self.value = value
    }
}

// MARK: LRU缓存实现（双向链表+map）
final class LRUCache<Key, Value> {
    private struct CachePaylaod {
        var key: Key
        var value: Value
    }
    
    private typealias Node = LinkNode<CachePaylaod>
    private var _head: Node?
    private var _tail: Node?
    private var _count: Int = 0
    var count: Int {
        return _count
    }
    
    private var _initCapacity: Int
    
    private var _lruMap: [Key: LinkNode<CachePaylaod>]
    
    init(_ capacity: Int) {
        self._initCapacity = max(0, capacity)
        
        _lruMap = [Key: LinkNode<CachePaylaod>].init(minimumCapacity: capacity)
    }
    
    /// 取值
    func get(_ key: Key) -> Value? {
        if let node = self._lruMap[key] {
            self.moveNodeToHead(node: node)
        }
        return self._lruMap[key]?.value.value
    }
    
    /// 设置值
    func put(_ key: Key, _ value: Value) {
        let cachePayload = CachePaylaod.init(key: key, value: value)
        /*
        1、key 存在，更新value,并将当前节点移到链表头部
        2、key不存在，创建新的节点并拼接到头部
        3、超过最大容量，移除最后一个节点
        */
        if let node = self._lruMap[key] {
            node.value = cachePayload
            moveNodeToHead(node: node)
        }else {
            let node = LinkNode.init(cachePayload)
            appenToHead(newNode: node)
            _lruMap[key] = node
        }
        
        if _count > _initCapacity {
            let nodeRemove = removeLastNode()
            if let key = nodeRemove?.value.key {
                _lruMap[key] = nil
            }
        }
    }
    
    /// 将存在的节点移到头部
    private func moveNodeToHead(node: Node) {
        if node === _head {
            return
        }
        let next = node.next
        let previous = node.previous
        if previous === _head {
            previous?.previous = node
        }
        if node === _tail {
            _tail = previous
        }
        previous?.next = next
        next?.previous = previous
        
        node.previous = nil
        node.next = _head
        _head?.previous = node
        _head = node
    }
    
    
    /// 拼接一个新的节点到头部
    private func appenToHead(newNode: Node) {
        if _head == nil {
            _head = newNode
            _tail = _head
        }else{
            let temp = newNode
            temp.next = _head
            _head?.previous = temp
            _head = temp
        }
        _count += 1

    }
    
    /// 移除最后一个节点
    @discardableResult
    private func removeLastNode() -> Node? {
        if let tail = _tail {
            let tailPre = tail.previous
            tail.previous = nil
            tailPre?.next = nil
            _tail = tailPre
            if _count == 1 {
                _head = nil
            }
            _count -= 1
            return tail
        }else {
            return nil
        }

    }
}

extension LRUCache: Printable {
    func reversePrint() {
        var node = _tail
        var ll = [Value]()
        while node != nil {
            ll.append(node!.value.value)
            node = node?.previous
        }
        print(ll)
    }
    
    func printf() {
        var node = _head
        var ll = [Value]()
        while node != nil {
            ll.append(node!.value.value)
            node = node?.next
        }
        print(ll)
    }
}

let lru = LRUCache<Int, Int>.init(3)
lru.put(1, 1)
lru.put(2, 2)
lru.printf()
lru.reversePrint()
lru.get(1)
lru.printf()
lru.reversePrint()

lru.put(3, 3)
lru.printf()
lru.reversePrint()
lru.get(2)
lru.printf()
lru.reversePrint()
lru.put(4, 4)
lru.printf()
lru.reversePrint()
lru.get(1)
lru.printf()
lru.reversePrint()
lru.get(3)
lru.printf()
lru.reversePrint()
lru.get(4)
lru.printf()
lru.reversePrint()
lru.put(3, 30)
lru.printf()
lru.reversePrint()

