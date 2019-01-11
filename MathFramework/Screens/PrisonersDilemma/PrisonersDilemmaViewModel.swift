//import ReactiveSwift
//import Result
//import Tagged
//
//public struct Game: Codable {
//  typealias Player = [Strategy]
//    typealias Strategy = Int
//    let strategies: [Strategy]
//  }
//  let players: [Player]
//}
//
//
//
//public enum PrisonersDilemma {
//  public typealias Payoff = Int
//
//  public enum Player: CaseIterable {
//    case a
//    case b
//  }
//
//  public enum Strategy {
//    case cooperate
//    case defect
//  }
//
//  public typealias Turn = (Player, Strategy?)
////  public struct Game {
////    var turns: [Turn] = Player.allCases.map { ($0, nil) }
////
////
////  }
//
//  public func viewModel(
//    turn: Signal<Turn, NoError>
//    ) -> (
//    payoffs: Signal<(), NoError>,
//    result: Signal<()?, NoError>
//    ) {
//      return (
//        payoffs: .never,
//        result: .never
//      )
//  }
//
//}
//
