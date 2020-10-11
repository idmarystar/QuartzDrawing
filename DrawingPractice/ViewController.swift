//
//  ViewController.swift
//  DrawingPractice
//
//  Created by Bora YI on 2020/10/11.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let canvas = Canvas(frame: view.bounds, image: UIImage(named: "swift")?.cgImage)
    let image = canvas.cgImage()
    let rotatedImage = canvas.rotatedImage(degrees: 30)
    let scaledImage = canvas.scaledImage(scale: 2)
    let transformImage = canvas.transformImage(degrees: 0, scale: 1)
    view.layer.contents = transformImage
  }
  
}


