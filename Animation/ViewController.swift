//
//  ViewController.swift
//  Animation
//
//  Created by Admin on 11/22/19.
//  Copyright © 2019 Eratos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: -- Attributes
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    
    var animator = Animator()
    
    // MARK: -- Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    // MARK: -- Action
    
    @IBAction func tapDetailButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        animator.cellImageViews = [productImageView, navigationView, descriptionView]
        
        vc.transitioningDelegate = animator
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
}

