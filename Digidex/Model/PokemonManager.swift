//
//  PokemonManager.swift
//  Digidex
//
//  Created by riswan ardiansah on 17/10/24.
//

import Foundation

protocol PokemonManagerDelegate {
  func didFailWithError(error: Error) -> Void
  func didUpdatePokemon(pokemon: [PokemonModel])
  func didUpdatePokemonDetail(pokemon: PokemonModel)
}

extension PokemonManagerDelegate {
  func didUpdatePokemon(pokemon: [PokemonModel]) -> Void {}
  func didUpdatePokemonDetail(pokemon: PokemonModel) -> Void {}
}

enum PokemonParamsType {
  case detail
  case search
}

struct PokemonManager {
  
  var delegate: PokemonManagerDelegate?
  var requestHandler = RequestHandler()
  
  func fetchAllPokemon() {
    let urlString = "\(K.BaseUrl.api)?limit=100"
    
    requestHandler.fetchData(modelType: Response.self, parameters: urlString) { result in
      switch result {
        case .success(let data):
          var resultsPokemon: [PokemonModel] = []
          
          data.results.forEach { pokemon in
            let pokemonName = pokemon.name
            let splitPokemonID = pokemon.url.components(separatedBy: "/")
            if let pokemonID = Int(splitPokemonID[splitPokemonID.count - 2]) {
              let pokemonImage = "\(K.BaseUrl.image)\(pokemonID).png"
              let newPokemon = PokemonModel(id: pokemonID, name: pokemonName, image: pokemonImage)
              
              resultsPokemon.append(newPokemon)
            }
          }
          
          delegate?.didUpdatePokemon(pokemon: resultsPokemon)
        case .failure(let error):
          delegate?.didFailWithError(error: error)
      }
    }
  }
  
  func fetchPokemon(params: String, type: PokemonParamsType = .detail) {
    let urlString = "\(K.BaseUrl.api)/\(params)"
    
    requestHandler.fetchData(modelType: PokemonDetailResponse.self, parameters: urlString) { result in
      switch result {
        case .success(let data):
          let id = data.id
          let pokemonName = data.name
          let image = data.sprites.other.home.front_default
          
          if type == .detail {
            delegate?.didUpdatePokemonDetail(pokemon: PokemonModel(id: id, name: pokemonName, image: image))
          } else {
            delegate?.didUpdatePokemon(pokemon: [PokemonModel(id: id, name: pokemonName, image: image)])
          }
        case .failure(let error):
          delegate?.didFailWithError(error: error)
      }
    }
  }
}
