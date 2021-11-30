import XCTest
import DifferenceKit

final class AlgorithmTestCase: XCTestCase {}

/// Test algorithm for linear collection.
extension AlgorithmTestCase {
    func testEmptyChangesets() {
        let source = [Int]()
        let target = [Int]()

        XCTAssertExactDifferences(
            source: source,
            target: target,
            section: 0,
            expected: []
        )
    }

    func testDeleted() {
        let section = 1

        let source1 = [0, 1, 2]
        let target1 = [0, 2]

        XCTAssertExactDifferences(
            source: source1,
            target: target1,
            section: section,
            expected: [
                Changeset(
                    data: target1,
                    elementDeleted: [ElementPath(element: 1, section: section)]
                )
            ]
        )

        let source2 = [0, 1, 2]
        let target2 = [Int]()

        XCTAssertExactDifferences(
            source: source2,
            target: target2,
            section: section,
            expected: [
                Changeset(
                    data: target2,
                    elementDeleted: [
                        ElementPath(element: 0, section: section),
                        ElementPath(element: 1, section: section),
                        ElementPath(element: 2, section: section)
                    ]
                )
            ]
        )
    }

    func testInserted() {
        let section = 1

        let source1 = [0, 1, 2]
        let target1 = [0, 1, 2, 3]

        XCTAssertExactDifferences(
            source: source1,
            target: target1,
            section: section,
            expected: [
                Changeset(
                    data: target1,
                    elementInserted: [ElementPath(element: 3, section: section)]
                )
            ]
        )

        let source2 = [Int]()
        let target2 = [0, 1, 2]

        XCTAssertExactDifferences(
            source: source2,
            target: target2,
            section: section,
            expected: [
                Changeset(
                    data: target2,
                    elementInserted: [
                        ElementPath(element: 0, section: section),
                        ElementPath(element: 1, section: section),
                        ElementPath(element: 2, section: section)
                    ]
                )
            ]
        )
    }

    func testUpdated() {
        let section = 1

        let source = [
            M(0, false),
            M(1, false),
            M(2, false)
        ]
        let target = [
            M(0, true),
            M(1, false),
            M(2, false)
        ]

        XCTAssertExactDifferences(
            source: source,
            target: target,
            section: section,
            expected: [
                Changeset(
                    data: target,
                    elementUpdated: [ElementPath(element: 0, section: section)]
                )
            ]
        )
                
        struct EM: Hashable, Differentiable {
            var id: Int
            var val: Bool
            
            func hash(into hasher: inout Hasher) {
                // Test with only the ID as its hash
                hasher.combine(id)
            }
        }
        
        let source2 = [
            EM(id: 0, val: false),
            EM(id: 1, val: false),
            EM(id: 2, val: false)
        ]
        let target2 = [
            EM(id: 0, val: true),
            EM(id: 1, val: false),
            EM(id: 2, val: false)
        ]
        
        XCTAssertExactDifferences(
            source: source2,
            target: target2,
            section: section,
            expected: [
                Changeset(
                    data: target2,
                    elementUpdated: [ElementPath(element: 0, section: section)]
                )
            ]
        )
    }

    func testMoved() {
        let section = 1

        let source1 = [0, 1, 2]
        let target1 = [1, 2, 0]

        XCTAssertExactDifferences(
            source: source1,
            target: target1,
            section: section,
            expected: [
                Changeset(
                    data: target1,
                    elementMoved: [
                        (source: ElementPath(element: 1, section: section), target: ElementPath(element: 0, section: section)),
                        (source: ElementPath(element: 2, section: section), target: ElementPath(element: 1, section: section))
                    ]
                )
            ]
        )

        let source2 = [0, 1, 2]
        let target2 = [2, 0, 1]

        XCTAssertExactDifferences(
            source: source2,
            target: target2,
            section: section,
            expected: [
                Changeset(
                    data: target2,
                    elementMoved: [(source: ElementPath(element: 2, section: section), target: ElementPath(element: 0, section: section))]
                )
            ]
        )

        let source3 = [0, 1, 2, 3]
        let target3 = [3, 2, 1, 0]

        XCTAssertExactDifferences(
            source: source3,
            target: target3,
            section: section,
            expected: [
                Changeset(
                    data: target3,
                    elementMoved: [
                        (source: ElementPath(element: 3, section: section), target: ElementPath(element: 0, section: section)),
                        (source: ElementPath(element: 2, section: section), target: ElementPath(element: 1, section: section)),
                        (source: ElementPath(element: 1, section: section), target: ElementPath(element: 2, section: section)),
                    ]
                )
            ]
        )
    }

    func testMixedChanges() {
        let section = 1

        let source = [
            M(0, false),
            M(1, false),
            M(2, false)
        ]
        let target = [
            M(2, false),
            M(4, false),
            M(0, true),
            M(3, false)
        ]

        XCTAssertExactDifferences(
            source: source,
            target: target,
            section: section,
            expected: [
                Changeset(
                    data: [
                        M(0, true),
                        M(1, false),
                        M(2, false)
                    ],
                    elementUpdated: [ElementPath(element: 0, section: section)]
                ),
                Changeset(
                    data: [
                        M(0, true),
                        M(2, false)
                    ],
                    elementDeleted: [ElementPath(element: 1, section: section)]
                ),
                Changeset(
                    data: target,
                    elementInserted: [
                        ElementPath(element: 1, section: section),
                        ElementPath(element: 3, section: section)
                    ],
                    elementMoved: [(source: ElementPath(element: 1, section: section), target: ElementPath(element: 0, section: section))]
                )
            ]
        )
    }

    func testDuplicated() {
        let section = 1

        let source = [0, 1, 2, 0]
        let target = [0, 4, 0, 1, 2]

        XCTAssertExactDifferences(
            source: source,
            target: target,
            section: section,
            expected: [
                Changeset(
                    data: target,
                    elementInserted: [ElementPath(element: 1, section: section)],
                    elementMoved: [(source: ElementPath(element: 3, section: section), target: ElementPath(element: 2, section: section))]
                )
            ]
        )
    }

    func testSameHashValue() {
        struct A: Hashable, Differentiable {
            let id: Int
            let actualValue: String

            init(_ id: Int, _ actualValue: String) {
                self.id = id
                self.actualValue = actualValue
            }

            func hash(into hasher: inout Hasher) {
                hasher.combine(id)
            }

            func isContentEqual(to source: A) -> Bool {
                return actualValue == source.actualValue
            }
        }

        let section = 0

        let source = [A(0, "a"), A(1, "b"), A(2, "c")]
        let target = [A(0, "a"), A(1, "c"), A(3, "c")]

        XCTAssertExactDifferences(
            source: source,
            target: target,
            section: section,
            expected: [
                Changeset(
                    data: [A(0, "a"), A(1, "c"), A(2, "c")],
                    elementUpdated: [ElementPath(element: 1, section: 0)]
                ),
                Changeset(
                    data: [A(0, "a"), A(1, "c")],
                    elementDeleted: [ElementPath(element: 2, section: 0)]
                ),
                Changeset(
                    data: target,
                    elementInserted: [ElementPath(element: 2, section: 0)]
                )
            ]
        )
    }
}

/// Test algorithm for sectioned collection.
extension AlgorithmTestCase {
    func testSectionedEmptyChangesets() {
        let source = [ArraySection<Int, Int>]()
        let target = [ArraySection<Int, Int>]()

        XCTAssertExactDifferences(
            source: source,
            target: target,
            expected: []
        )
    }

    func testSectionInserted() {
        let source1 = [
            ArraySection(model: D.a, elements: [0])
        ]

        let target1 = [
            ArraySection(model: D.a, elements: [0]),
            ArraySection(model: D.b, elements: [1])
        ]

        XCTAssertExactDifferences(
            source: source1,
            target: target1,
            expected: [
                Changeset(
                    data: target1,
                    sectionInserted: [1]
                )
            ]
        )

        let source2 = [ArraySection<D, Int>]()

        let target2 = [
            ArraySection(model: D.a, elements: [0])
        ]

        XCTAssertExactDifferences(
            source: source2,
            target: target2,
            expected: [
                Changeset(
                    data: target2,
                    sectionInserted: [0]
                )
            ]
        )
    }

    func testSectionDeleted() {
        let source1 = [
            ArraySection(model: D.a, elements: [0]),
            ArraySection(model: D.b, elements: [1])
        ]

        let target1 = [
            ArraySection(model: D.b, elements: [1])
        ]

        XCTAssertExactDifferences(
            source: source1,
            target: target1,
            expected: [
                Changeset(
                    data: target1,
                    sectionDeleted: [0]
                )
            ]
        )

        let source2 = [
            ArraySection(model: D.a, elements: [0])
        ]

        let target2 = [ArraySection<D, Int>]()

        XCTAssertExactDifferences(
            source: source2,
            target: target2,
            expected: [
                Changeset(
                    data: target2,
                    sectionDeleted: [0]
                )
            ]
        )
    }

    func testSectionUpdated() {
        let source = [
            ArraySection(model: M(0, false), elements: [0])
        ]

        let target = [
            ArraySection(model: M(0, true), elements: [0])
        ]

        XCTAssertExactDifferences(
            source: source,
            target: target,
            expected: [
                Changeset(
                    data: target,
                    sectionUpdated: [0]
                )
            ]
        )
    }

    func testSectionMoved() {
        let section0 = ArraySection(model: 0, elements: [0])
        let section1 = ArraySection(model: 1, elements: [1])
        let section2 = ArraySection(model: 2, elements: [2])
        
        let source1 = [
            section0,
            section1,
            section2
        ]

        let target1 = [
            section1,
            section2,
            section0
        ]

        XCTAssertExactDifferences(
            source: source1,
            target: target1,
            expected: [
                Changeset(
                    data: target1,
                    sectionMoved: [
                        (source: 1, target: 0),
                        (source: 2, target: 1)
                    ]
                )
            ]
        )

        let source2 = [
            section0,
            section1,
            section2
        ]

        let target2 = [
            section2,
            section0,
            section1
        ]

        XCTAssertExactDifferences(
            source: source2,
            target: target2,
            expected: [
                Changeset(
                    data: target2,
                    sectionMoved: [(source: 2, target: 0)]
                )
            ]
        )
    }

    func testMixedSectionChanges() {
        let section0 = ArraySection(model: M(0, false), elements: [0])
        let section1 = ArraySection(model: M(1, false), elements: [1])
        let section2 = ArraySection(model: M(2, false), elements: [2])
        let section3 = ArraySection(model: M(3, false), elements: [3])
        let section4 = ArraySection(model: M(4, false), elements: [4])
        
        let source = [
            section0,
            section1,
            section2,
            section3
        ]

        let target = [
            section3,
            section4,
            section0,
            ArraySection(model: M(2, true), elements: [2]) // section2 updated
        ]

        XCTAssertExactDifferences(
            source: source,
            target: target,
            expected: [
                // section1 deleted
                Changeset(
                    data: [
                        section0,
                        section2,
                        section3
                    ],
                    sectionDeleted: [1]
                ),
                // section3 moved to 0
                // section4 inserted
                Changeset(
                    data: [
                        section3,
                        section4,
                        section0,
                        section2
                    ],
                    sectionInserted: [1],
                    sectionMoved: [(source: 2, target: 0)]
                ),
                // section2 updated
                Changeset(
                    data: target,
                    sectionUpdated: [3]
                )
            ]
        )
    }

    func testDuplicatedSection() {
        let source = [
            ArraySection(model: 0, elements: [1]),
            ArraySection(model: 0, elements: [1]),
            ArraySection(model: 1, elements: [2])
        ]

        let target = [
            ArraySection(model: 1, elements: [2]),
            ArraySection(model: 0, elements: [1]),
            ArraySection(model: 0, elements: [1])
        ]

        XCTAssertExactDifferences(
            source: source,
            target: target,
            expected: [
                Changeset(
                    data: target,
                    sectionMoved: [(source: 2, target: 0)]
                )
            ]
        )
    }

    func testDuplicatedElement() {
        let source = [
            ArraySection(model: 0, elements: [0, 1, 2, 0])
        ]

        let target = [
            ArraySection(model: 0, elements: [0, 4, 0, 1, 2])
        ]

        XCTAssertExactDifferences(
            source: source,
            target: target,
            expected: [
                Changeset(
                    data: target,
                    elementInserted: [ElementPath(element: 1, section: 0)],
                    elementMoved: [(source: ElementPath(element: 3, section: 0), target: ElementPath(element: 2, section: 0))]
                )
            ]
        )
    }
}

/// Repeatability test with sectioned collection differences
extension AlgorithmTestCase {
    func testDuplicatedSectionAndElement() {
        let source = [
            ArraySection(model: 0, elements: [0, 1]),
            ArraySection(model: 0, elements: [2, 3]),
            ArraySection(model: 1, elements: [1, 2])
        ]

        let target = [
            ArraySection(model: 0, elements: [3, 1]),
            ArraySection(model: 1, elements: [2, 2, 2]),
            ArraySection(model: 0, elements: [1, 0])
        ]

        XCTAssertReproducible(source: source, target: target)
    }

    func testComplicated1() {
        let source = [
            ArraySection(model: 0, elements: [0, 1]),
            ArraySection(model: 1, elements: [2, 3]),
            ArraySection(model: 2, elements: [4, 5])
        ]

        let target = [
            ArraySection(model: 0, elements: [0, 1]),
            ArraySection(model: 2, elements: [4, 6, 5]),
            ArraySection(model: 3, elements: [7, 8]),
            ArraySection(model: 3, elements: [9, 10])
        ]

        XCTAssertReproducible(source: source, target: target)
    }

    func testComplicated2() {
        let source = [
            ArraySection(model: 0, elements: [0, 1]),
            ArraySection(model: 1, elements: [2, 3]),
            ArraySection(model: 2, elements: [4, 5])
        ]

        let target = [
            ArraySection(model: 1, elements: [3, 5]),
            ArraySection(model: 3, elements: [6, 7, 8, 9]),
            ArraySection(model: 2, elements: [10, 4, 2]),
            ArraySection(model: 0, elements: [1])
        ]

        XCTAssertReproducible(source: source, target: target)
    }

    func testComplicated3() {
        let source = [
            ArraySection(model: M(0, false), elements: [0, 1]),
            ArraySection(model: M(1, false), elements: [2, 3]),
            ArraySection(model: M(2, false), elements: [4, 5])
        ]

        let target = [
            ArraySection(model: M(0, false), elements: []),
            ArraySection(model: M(4, false), elements: [8, 9]),
            ArraySection(model: M(0, true), elements: [10, 11]),
            ArraySection(model: M(2, false), elements: [4, 5, 12]),
            ArraySection(model: M(3, false), elements: [6, 7]),
            ArraySection(model: M(1, true), elements: [2, 13, 3])
        ]

        XCTAssertReproducible(source: source, target: target)
    }

    func testComplicated4() {
        let source = [
            ArraySection(model: M(0, false), elements: [Int]())
        ]

        let target = [
            ArraySection(model: M(0, true), elements: [0, 0, 0]),
            ArraySection(model: M(1, false), elements: [0, 0, 0])
        ]

        XCTAssertReproducible(source: source, target: target)
    }

    func testComplicated5() {
        let source = [
            ArraySection(model: M(0, false), elements: [0, 0, 0]),
            ArraySection(model: M(1, false), elements: [2, 3]),
            ArraySection(model: M(2, false), elements: [4, 5])
        ]

        let target = [
            ArraySection(model: M(0, true), elements: [0, 4, 2]),
            ArraySection(model: M(1, false), elements: [0, 3, 5]),
            ArraySection(model: M(3, false), elements: []),
            ArraySection(model: M(2, true), elements: [0, 1, 6, 0, 0])

        ]

        XCTAssertReproducible(source: source, target: target)
    }

    func testComplicated6() {
        let source = [
            ArraySection(model: M(0, false), elements: [M(0, false)]),
            ArraySection(model: M(1, false), elements: [M(1, false)])
        ]

        let target = [
            ArraySection(model: M(1, true), elements: [M(2, false), M(1, true)]),
            ArraySection(model: M(0, false), elements: [M(0, true)])
        ]

        XCTAssertReproducible(source: source, target: target)
    }

    func testComplicated7() {
        let source = [
            ArraySection(model: M(0, false), elements: [M(0, false), M(1, false)]),
            ArraySection(model: M(1, false), elements: [M(2, false), M(3, false)]),
            ArraySection(model: M(2, false), elements: [M(1, false), M(2, false)])
        ]

        let target = [
            ArraySection(model: M(0, false), elements: [M(1, true), M(3, false)]),
            ArraySection(model: M(1, true), elements: [M(2, false), M(0, true)]),
            ArraySection(model: M(3, false), elements: [M(4, false), M(5, false)])
        ]

        XCTAssertReproducible(source: source, target: target)
    }

    func testComplicated8() {
        let source = [
            ArraySection(model: M(0, false), elements: [M(0, false), M(1, false)]),
            ArraySection(model: M(1, false), elements: [M(2, false), M(3, false)])
        ]

        let target = [
            ArraySection(model: M(0, false), elements: []),
            ArraySection(model: M(1, false), elements: [M(1, true), M(3, false)])
        ]

        XCTAssertReproducible(source: source, target: target)
    }

    func testComplicated9() {
        let source = [
            ArraySection(model: M(0, false), elements: [M(0, false), M(1, false)]),
            ArraySection(model: M(1, false), elements: [M(2, false), M(3, false)]),
            ArraySection(model: M(2, false), elements: [M(4, false), M(5, false)])
            ]

        let target = [
            ArraySection(model: M(4, false), elements: [M(8, false), M(9, false)]),
            ArraySection(model: M(0, false), elements: [M(0, false), M(1, false), M(2, false)]),
            ArraySection(model: M(3, false), elements: [M(6, false), M(7, false)]),
            ArraySection(model: M(1, true), elements: [M(3, false)]),
            ArraySection(model: M(2, false), elements: [M(5, true)])
            ]

        XCTAssertReproducible(source: source, target: target)
    }

    func testComplicated10() {
        let source = [
            ArraySection(model: 0, elements: [M(0, false), M(1, false)]),
            ArraySection(model: 1, elements: [M(2, false), M(3, false)])
        ]

        let target = [
            ArraySection(model: 1, elements: [M(3, true), M(2, false)]),
            ArraySection(model: 0, elements: [M(1, false), M(0, true)])
        ]

        XCTAssertReproducible(source: source, target: target)
    }

    func testComplicated11() {
        let source = [
            ArraySection(model: 1, elements: ["A", "B", "C", "D"]),
            ArraySection(model: 2, elements: ["E", "F", "G", "H", "I"]),
            ArraySection(model: 3, elements: ["J", "K", "L", "M"]),
            ArraySection(model: 4, elements: ["N", "O", "P", "Q"])
        ]

        let target = [
            ArraySection(model: 1, elements: ["A", "B", "C", "D"]),
            ArraySection(model: 2, elements: ["G"]),
            ArraySection(model: 3, elements: ["E", "F", "H", "I"]),
            ArraySection(model: 3, elements: ["J", "K", "L", "M"]),
            ArraySection(model: 4, elements: ["N", "O", "P", "Q"])
        ]

        XCTAssertReproducible(source: source, target: target)
    }
}
//
///// Nested Sections
//extension AlgorithmTestCase {
//    func testNestedSections() {
//        let diff = ["s"].difference(from: ["a","b","s"]) { a, b in
//            a == b
//        }
//        
//        
//        struct ListSection: Equatable, DifferentiableSection {
//            public var title: String
//            public var elements: [Task]
//            
//            public var differenceIdentifier: String {
//                return title
//            }
//            
//            public init<C: Collection>(title: String, elements: C) where C.Element == Task {
//                self.title = title
//                self.elements = Array(elements)
//            }
//            
//            init<C: Collection>(source: ListSection, elements: C) where C.Element == Task {
//                self.init(title: source.title, elements: elements)
//            }
//            
//            static func == (lhs: ListSection, rhs: ListSection) -> Bool {
//                return lhs.title == rhs.title
//            }
//            
//            func isContentEqual(to source: ListSection) -> Bool {
//                return title == source.title
//            }
//        }
//        
//        struct Task: Equatable, DifferentiableSection {
//            public var title: String
//            public var isDone: Bool
//            public var elements: [Task]
//            
//            public var differenceIdentifier: String {
//                return title
//            }
//            
//            public init<C: Collection>(title: String, isDone: Bool, elements: C) where C.Element == Task {
//                self.title = title
//                self.isDone = isDone
//                self.elements = Array(elements)
//            }
//            
//            init<C: Collection>(source: Task, elements: C) where C.Element == Task {
//                self.init(title: source.title, isDone: source.isDone, elements: elements)
//            }
//            
//            func isContentEqual(to source: Task) -> Bool {
//                return self.title == source.title && self.isDone == source.isDone
//            }
//            
//            static func == (lhs: Task, rhs: Task) -> Bool {
//                return lhs.title == rhs.title
//            }
//        }
//        
//        let source = [
//            ListSection(title: "Yesterday",
//                        elements: [
//                            Task(title: "Haircut", isDone: false, elements: []),
//                            Task(title: "Call Mom", isDone: false, elements: []),
//                            Task(title: "Submit Project",
//                                 isDone: false,
//                                 elements: [
//                                    Task(title: "Finish draft", isDone: false, elements: []),
//                                    Task(title: "Complete citation", isDone: false, elements: []),
//                                    Task(title: "Email professor", isDone: false, elements: []),
//                                 ])
//                        ]),
////            ListSection(title: "Today",
////                        elements: [
////                            Task(title: "Call John", isDone: false, elements: []),
////                            Task(title: "Return book to library", isDone: false, elements: []),
////                        ])
//        ]
//        
//        let target = [
//            ListSection(title: "Yesterday",
//                        elements: [
//                            Task(title: "Call Mom", isDone: true, elements: []),
//                            Task(title: "Submit Project",
//                                 isDone: false,
//                                 elements: [
//                                    Task(title: "Finish draft", isDone: true, elements: []),
//                                    Task(title: "Complete citation", isDone: false, elements: []),
//                                    Task(title: "Email professor", isDone: false, elements: []),
//                                 ])
//                        ]),
////            ListSection(title: "Today",
////                        elements: [
////                            Task(title: "Return book to library", isDone: false, elements: []),
////                            Task(title: "Call John", isDone: false, elements: []),
////                        ])
//        ]
//        
//
//        XCTAssertExactDifferences(
//            source: source,
//            target: target,
//            expected: [
//                Changeset(
//                    data: [
//                        ListSection(title: "Yesterday",
//                                    elements: [
//                                        Task(title: "Haircut", isDone: false, elements: []),
//                                        Task(title: "Call Mom", isDone: true, elements: []),
//                                        Task(title: "Submit Project",
//                                             isDone: false,
//                                             elements: [
//                                                Task(title: "Finish draft", isDone: true, elements: []),
//                                                Task(title: "Complete citation", isDone: false, elements: []),
//                                                Task(title: "Email professor", isDone: false, elements: []),
//                                             ])
//                                    ])
//                    ],
//                    elementUpdated: [
//                        ElementPath(element: 1, section: 0),
//                    ]
//                ),
//                Changeset(
//                    data: [
//                        ListSection(title: "Yesterday",
//                                    elements: [
//                                        Task(title: "Call Mom", isDone: true, elements: []),
//                                        Task(title: "Submit Project",
//                                             isDone: false,
//                                             elements: [
//                                                Task(title: "Finish draft", isDone: true, elements: []),
//                                                Task(title: "Complete citation", isDone: false, elements: []),
//                                                Task(title: "Email professor", isDone: false, elements: []),
//                                             ])
//                                    ])
//                    ],
//                    elementDeleted: [
//                        ElementPath(element: 0, section: 0),
//                    ]
//                )
//            ]
//        )
//    }
//}
