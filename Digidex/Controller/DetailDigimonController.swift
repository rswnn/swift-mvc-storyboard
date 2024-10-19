//
//  DetailDigimonController.swift
//  Digidex
//
//  Created by riswan ardiansah on 13/10/24.
//

import UIKit

class DetailDigimonContoller: UIViewController {
  
  @IBOutlet weak var imageBackward: UIImageView!
  @IBOutlet weak var imageForward: UIImageView!
  
  var id: Int?
  var name: String?
  var pokemonManager = PokemonManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    pokemonManager.delegate = self
    imageBackward.isHidden = true
    imageForward.isHidden = true
    
    if let resultID = id {
      pokemonManager.fetchPokemon(params: name ?? String(resultID))
      if let pokemonName = name {
        title = pokemonName
      }
    }
  }
}

extension DetailDigimonContoller: PokemonManagerDelegate {
  func didUpdatePokemonDetail(pokemon: PokemonModel) {
    DispatchQueue.main.async {
      self.imageForward.loadImage(from: URL(string: pokemon.image)!)
      self.imageBackward.loadImage(from: URL(string: pokemon.image)!)
      
      self.imageBackward.isHidden = false
      self.imageForward.isHidden = false
    }
  }
  
  func didFailWithError(error: Error) {
      
  }
}
