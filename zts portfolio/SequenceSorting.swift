//
//  SequenceSorting.swift
//  zts portfolio
//
//  Created by Hubert Leszkiewicz on 17/06/2021.
//

import Foundation

extension Sequence {
    func sorted<Value>(
        by keyPath: KeyPath<Element, Value>,
        using areInIncreasingOrder: (Value, Value) throws -> Bool
    ) rethrows -> [Element] {
            try self.sorted {
                try areInIncreasingOrder($0[keyPath: keyPath], $1[keyPath: keyPath])
            }
        }

    func sorted<Value: Comparable>(by keypath: KeyPath<Element, Value>) -> [Element] {
        self.sorted(by: keypath, using: <)
    }

    func sorted(by sortDescriptor: NSSortDescriptor) -> [Element] {
        self.sorted {
            sortDescriptor.compare($0, to: $1) == .orderedAscending
        }
    }

    func sortef(by sortDescriptors: [NSSortDescriptor]) -> [Element] {
        self.sorted {
            for descriptor in sortDescriptors {
                switch descriptor.compare($0, to: $1) {
                case .orderedAscending:
                    return true
                case .orderedDescending:
                    return false
                case .orderedSame:
                    continue
                }
            }
            return false
        }
    }
}
