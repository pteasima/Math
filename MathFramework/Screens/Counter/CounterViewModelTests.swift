//
//  CounterViewModelTests.swift
//  MathFrameworkTests
//
//  Created by Petr Šíma on 10/01/2019.
//  Copyright © 2019 Petr Šíma. All rights reserved.
//

import XCTest
@testable import MathFramework
import ReactiveSwift
import Result
import SnapshotTesting
import Overture

class CounterViewModelTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTwoIncrements() {


      let plus = Signal<(), NoError>.pipe()
      let viewDidLoad = Signal<(), NoError>.pipe()
      let inputs = with(CoproductOfSignals<CounterInputs>(), concat(
        mut(\CoproductOfSignals<CounterInputs>.[\.viewDidLoad], viewDidLoad.output),
        mut(\CoproductOfSignals<CounterInputs>.[\.plus], plus.output)
      ))
      let outputs = counterViewModel(inputs)

      let startDate = Date()
      let duration = 3.0

      let expectation = self.expectation(description: "testExpectation")
      Snapshotting<Signal<String, NoError>, String>.events(timeout: duration).snapshot(Signal.merge(
        //TODO: inputs are displayed after outputs because vm receives inputs signal before Snapshotting
        inputs.raw.output.map { (arg) -> String in
          let (kp, values) = arg
          return "input @ \(String(format:"%.0f", Date().timeIntervalSince(startDate))): \(kp)(\(values.value(forKeyPath: kp) ?? "noValue"))"
      },
        outputs.raw.output.map { (arg) -> String in
        let (kp, values) = arg
          return "output @ \(String(format:"%.0f", Date().timeIntervalSince(startDate))): \(kp)(\(values.value(forKeyPath: kp) ?? "noValue"))"
      })).run {
        print($0)
        assertSnapshot(
          matching: $0,
          as: .lines
//          ,record: true
        )
          expectation.fulfill()
      }

      viewDidLoad.input.send(value: ())
      plus.input.send(value: ())
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        plus.input.send(value: ())
      }


      waitForExpectations(timeout: 5) { _ in
        XCTAssert(true)
      }





    }

}
