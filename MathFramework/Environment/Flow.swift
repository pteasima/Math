public struct Flow {
  public init() { }
  public var play: (UIStoryboard) -> () = { storyboard in
    print("playing a storyboard does nothing by default. \(storyboard)")
  }
}
