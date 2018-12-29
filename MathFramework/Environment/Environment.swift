import Foundation

public var environment: Environment = .init()

public struct Environment {
  public init() { }
  public var date: () -> Date = Date.init
  public var flow: Flow = .init()
}
