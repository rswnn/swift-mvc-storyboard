//
//  ViewController.swift
//  Digidex
//
//  Created by riswan ardiansah on 13/10/24.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var searchTextField: UITextField!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var buttonSearch: UIButton!
  @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
  
  var pokemonManager = PokemonManager()
  var pokemons = [PokemonModel]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    searchTextField.delegate = self
    collectionView.dataSource = self
    collectionView.delegate = self
    pokemonManager.delegate = self
    loadingIndicatorView.hidesWhenStopped = true
    collectionView.register(UINib(nibName: "CardViewCell", bundle: nil), forCellWithReuseIdentifier: "identCardViewCell")
    collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    
    loadingIndicatorView.startAnimating()
    pokemonManager.fetchAllPokemon()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    searchTextField.layer.borderWidth = 0.5
    searchTextField.layer.borderColor = #colorLiteral(red: 0.5568622351, green: 0.5568631887, blue: 0.5783511996, alpha: 1)
    searchTextField.layer.cornerRadius = 5
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "navigateToDetail" {
      let DetailPokemonVC = segue.destination as! DetailDigimonContoller
      let object = sender as! [String: Any?]
      
      DetailPokemonVC.id = object["id"] as? Int
      DetailPokemonVC.name = object["name"] as? String
    }
  }
}

extension ViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return pokemons.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identCardViewCell", for: indexPath) as! CardViewCell
    
    cell.labelCardView.text = pokemons[indexPath.row].name
    cell.setImage(from: String(pokemons[indexPath.row].image))
    
    return cell
  }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    
    return 20
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    
    return 20
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let collectionViewWidth = collectionView.frame.width
    let collectionViewHeight = 250.0
    let cellWidth = (collectionViewWidth - 20 ) / 2
    
    return CGSize(width: cellWidth , height: collectionViewHeight)
  }
}

extension ViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let data = [
      "id": pokemons[indexPath.row].id,
      "name": pokemons[indexPath.row].name
    ] as [String : Any]
    performSegue(withIdentifier: "navigateToDetail", sender: data)
  }
}

extension ViewController: PokemonManagerDelegate {
  func didUpdatePokemon(pokemon: [PokemonModel]) {
    
    self.pokemons = []
    DispatchQueue.main.async {
      self.pokemons = pokemon
    
      self.collectionView.reloadData()
      self.loadingIndicatorView.stopAnimating()
    }
  }
  
  
  func didFailWithError(error: Error) {
    print("Error")
  }
}

extension ViewController: UITextFieldDelegate {
  
  @IBAction func onPressSearch(_ sender: Any) {
    dismissKeyboard()
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    dismissKeyboard()
    
    return true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if let search = textField.text {
      pokemonManager.fetchPokemon(params: search, type: .search)
    }
  }
  
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    if textField.text != "" {
      return true
    } else {
      return false
    }
  }
  
  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    pokemonManager.fetchAllPokemon()
    return true
  }
  
  func dismissKeyboard() -> Void {
    searchTextField.endEditing(true)
  }
}

