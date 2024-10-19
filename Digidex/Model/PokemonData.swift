//
//  DigimonData.swift
//  Digidex
//
//  Created by riswan ardiansah on 16/10/24.
//

import Foundation

struct Response: Codable {
  var results: [Pokemon]
}

struct Pokemon: Codable {
  let name: String
  let url: String
}

struct Sprites: Codable {
  let other: OtherSprites
}

struct OtherSprites: Codable {
  let home: HomeSprites
}

struct HomeSprites: Codable {
  let front_default: String
}

struct PokemonDetailResponse: Codable {
  let id: Int
  let name: String
  let sprites: Sprites
}
