import PlaygroundSupport
import MathFramework
import Overture

public extension Environment {
  public static let playground: Environment = with(Environment(), mut(\.flow, .playground))
}

public extension Flow {
  public static let playground: Flow = with(Flow(),
                                     mut(\.play, { storyboard in
                                      PlaygroundPage.current.liveView = storyboard.instantiateInitialViewController()
                                     })
                                     )
}
