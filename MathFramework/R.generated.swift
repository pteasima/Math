//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
public struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap(Locale.init) ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)
  
  public static func validate() throws {
    try intern.validate()
  }
  
  /// This `R.storyboard` struct is generated, and contains static references to 1 storyboards.
  public struct storyboard {
    /// Storyboard `Reals`.
    public static let reals = _R.storyboard.reals()
    
    /// `UIStoryboard(name: "Reals", bundle: ...)`
    public static func reals(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.reals)
    }
    
    fileprivate init() {}
  }
  
  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }
    
    fileprivate init() {}
  }
  
  fileprivate class Class {}
  
  fileprivate init() {}
}

public struct _R: Rswift.Validatable {
  public static func validate() throws {
    try storyboard.validate()
  }
  
  public struct storyboard: Rswift.Validatable {
    public static func validate() throws {
      try reals.validate()
    }
    
    public struct reals: Rswift.StoryboardResourceType, Rswift.Validatable {
      public let bundle = R.hostingBundle
      public let name = "Reals"
      
      public static func validate() throws {
        if #available(iOS 11.0, *) {
        }
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate init() {}
}