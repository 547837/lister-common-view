import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(lister_common_viewTests.allTests),
    ]
}
#endif
