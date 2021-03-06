//
//  MainViewController.swift
//  Recipes
//
//  Created by Benjamin Hakes on 12/3/18.
//  Copyright © 2018 Lambda Inc. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - Properties
    let networkClient = RecipesNetworkClient()
    var recipesTableViewController: RecipesTableViewController?{
        didSet {
            recipesTableViewController?.recipes = filteredRecipes
        }
    }
    var filteredRecipes: [Recipe] = [] {
        didSet {
            recipesTableViewController?.recipes = filteredRecipes
        }
    }
    var allRecipes: [Recipe] = [] {
        didSet {
            filterRecipes()
        }
    }
    
    @IBOutlet weak var textField: UITextField!
    
    // MARK: - Functions
    @IBAction func editingDidEnd(_ sender: Any) {
        resignFirstResponder()
        filterRecipes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkClient.fetchRecipes { (allRecipes, error) in
            if let error = error {
                NSLog("Error getting recipes: \(error)")
                return
            }
            DispatchQueue.main.async {
                self.allRecipes = allRecipes ?? []
            }
        }

        // Do any additional setup after loading the view.
    }
   
    func filterRecipes(){
        
        DispatchQueue.main.async {
            guard let searchTerm = self.textField.text else { return }
            
            if searchTerm == "" {
                self.filteredRecipes = self.allRecipes
            } else {
                self.filteredRecipes = self.allRecipes.filter{ $0.name.lowercased().contains(searchTerm.lowercased()) || $0.instructions.lowercased().contains(searchTerm.lowercased()) }
            }
            
        }
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "embededTableViewSegue"{
            let recipesTableVC = segue.destination as? RecipesTableViewController
            recipesTableViewController = recipesTableVC
        }
        
        
    }
    

}
