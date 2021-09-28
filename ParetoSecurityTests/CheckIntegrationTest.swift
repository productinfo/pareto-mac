//
//  CheckIntegrationTest.swift
//  CheckIntegrationTest
//
//  Created by Janez Troha on 12/08/2021.
//

@testable import Pareto_Security
import XCTest

class CheckIntegrationTest: XCTestCase {
    override class func setUp() {
        super.setUp()
        UserDefaults.standard.removeAll()
        UserDefaults.standard.synchronize()
    }

    func testInit() throws {
        let check = IntegrationCheck()
        XCTAssertEqual(check.UUID, "aaaaaaaa-bbbb-cccc-dddd-abcdef123456")
        XCTAssertEqual(check.Title, "Unit test mock OFF")

        // Ensure keys are not changed without migration
        XCTAssertEqual(check.PassesKey, "ParetoCheck-aaaaaaaa-bbbb-cccc-dddd-abcdef123456-Passes")
        XCTAssertEqual(check.EnabledKey, "ParetoCheck-aaaaaaaa-bbbb-cccc-dddd-abcdef123456-Enabled")
        XCTAssertEqual(check.TimestampKey, "ParetoCheck-aaaaaaaa-bbbb-cccc-dddd-abcdef123456-TS")
    }

    func testCheckPasses() throws {
        let check = IntegrationCheck()
        XCTAssertTrue(check.checkPasses())
    }

    func testClaimLogic() throws {
        let claim = Claim(withTitle: "Test", withChecks: [IntegrationCheck(), IntegrationCheckFails()])
        claim.configure()
        claim.run()
        XCTAssertEqual(claim.checks.count, 2)
        XCTAssertFalse(claim.checkPassed)
        XCTAssertTrue(claim.isActive)
        XCTAssertFalse(claim.isDisabled)
        XCTAssertNotEqual(claim.menu(), nil)
    }
}
