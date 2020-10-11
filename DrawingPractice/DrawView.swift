//
//  DrawView.swift
//  DrawingPractice
//
//  Created by Bora YI on 2020/10/11.
//

import UIKit

class Canvas {
  
  private var image: CGImage?
  private var frame: CGRect = .zero
  
  init(frame: CGRect, image: CGImage?) {
    
    self.frame = frame
    self.image = image
  }
  
  private func getContext(size: CGSize) -> CGContext? {
    let context = CGContext(data: nil,
                            width: Int(size.width),
                            height: Int(size.height),
                            bitsPerComponent: Int(8),
                            bytesPerRow: Int(size.width * 4),
                            space: CGColorSpaceCreateDeviceRGB(),
                            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
    
    if context == nil {
      fatalError("Could not create context")
    }
    
    // clean memory
    context!.setFillColor(UIColor.yellow.cgColor)
    context!.fill(CGRect(origin: .zero, size: size))
    
    return context
  }
  
  func cgImage() -> CGImage? {
    guard
      let context = getContext(size: frame.size),
      let image = image else { return nil }
    
    let drawRect = CGRect(x: 0, y: frame.height - 100, width: 100, height: 100)
    context.draw(image, in: drawRect)
    return context.makeImage()
  }
  
  func rotatedImage(degrees: CGFloat) -> CGImage? {
    guard
      let context = getContext(size: frame.size),
      let image = image else { return nil }
    
    let drawRect = CGRect(x: 100, y: 100, width: 100, height: 100)
    
    let radians: CGFloat = (degrees + 0) * .pi / 180
    let cx = drawRect.width / 2.0 + drawRect.origin.x
    let cy = drawRect.height / 2.0 + drawRect.origin.y
    
    let offsetX: CGFloat = (cx - (cx * cos(radians) - cy * sin(radians)))
    let offsetY: CGFloat = (cy - (cx * sin(radians) + cy * cos(radians))) * -1
    let tx = frame.origin.x + offsetX + context.ctm.tx
    let ty = frame.origin.y + offsetY + context.ctm.ty + frame.height
    
    // Save the current context
    context.saveGState()
    
    // Apply the affine transforms
    var transform = CGAffineTransform.identity
    transform = transform.concatenating(CGAffineTransform(rotationAngle: radians))
    transform = transform.concatenating(CGAffineTransform(scaleX: 1, y: -1))
    transform = transform.concatenating(CGAffineTransform(translationX: tx, y: ty))
    context.concatenate(transform)
    
    // Drawa a image
    context.draw(image, in: drawRect)
    
    // Restore the current context
    context.restoreGState()
    context.resetClip()
    
    return context.makeImage()
  }
  
  func rotatedImage2(degrees: CGFloat) -> CGImage? {
    guard
      let context = getContext(size: frame.size),
      let image = image else { return nil }
    
    let drawRect = CGRect(x: 0, y: 0, width: 100, height: 100)
    let radians: CGFloat = degrees * .pi / 180
    
    // Save the current context
    context.saveGState()
    
    // Draw
    var transform = CGAffineTransform.identity
    transform = transform.concatenating(CGAffineTransform(rotationAngle: radians))
    context.draw(image, in: drawRect.applying(transform)) // 회전 안됨
    
    // Restore the current context
    context.restoreGState()
    context.resetClip()
    
    return context.makeImage()
  }
  
  func scaledImage(scale: CGFloat) -> CGImage? {
    guard
      let context = getContext(size: frame.size),
      let image = image else { return nil }
    
    let drawRect = CGRect(x: 100, y: 100, width: 100, height: 100)
    
    let cx = drawRect.width / 2.0 + drawRect.origin.x
    let cy = drawRect.height / 2.0 + drawRect.origin.y
    let radians: CGFloat = 0
    
    let offsetX: CGFloat = (frame.width - frame.width * scale) / 2 + (cx - (cx * cos(radians) - cy * sin(radians))) * scale
    let offsetY: CGFloat = (frame.height - frame.height * scale) / 2 + (cy - (cx * sin(radians) + cy * cos(radians))) * scale * -1
    let tx = frame.origin.x + offsetX + context.ctm.tx * scale
    let ty = frame.origin.y + offsetY + context.ctm.ty + frame.height * scale
    
    // Save the current context
    context.saveGState()
    
    // Apply the affine transforms
    var transform = CGAffineTransform.identity
    transform = transform.concatenating(CGAffineTransform(rotationAngle: radians))
    transform = transform.concatenating(CGAffineTransform(scaleX: scale, y: -scale))
    transform = transform.concatenating(CGAffineTransform(translationX: tx, y: ty))
    context.concatenate(transform)
    
    // Drawa a image
    context.draw(image, in: drawRect)
    
    // Restore the current context
    context.restoreGState()
    context.resetClip()
    
    return context.makeImage()
  }
  
  func transformImage(degrees: CGFloat, scale: CGFloat) -> CGImage? {
    guard
      let context = getContext(size: frame.size),
      let image = image else { return nil }
    
    // TODO: Drawa a image
    let drawRect = CGRect(x: 100, y: 100, width: 100, height: 100)
    let cx = drawRect.width / 2.0 + drawRect.origin.x
    let cy = drawRect.height / 2.0 + drawRect.origin.y
    
    let DIR: CGFloat = -1
    let radians: CGFloat = degrees * .pi / 180
    let scaleX = scale
    let scaleY = scale
    
    let offsetX: CGFloat = (frame.width - frame.width * scaleX) / 2 + (cx - (cx * cos(radians) - cy * sin(radians))) * scaleX
    let offsetY: CGFloat = (frame.height - frame.height * scaleY) / 2 + (cy - (cx * sin(radians) + cy * cos(radians))) * scaleY * DIR
    let tx = frame.origin.x + offsetX + context.ctm.tx
    let ty = frame.origin.y + offsetY + context.ctm.ty + frame.height * scaleY
    
    // Save the current context
    context.saveGState()
    
    // Apply the affine transforms
    var transform = CGAffineTransform.identity
    transform = transform.concatenating(CGAffineTransform(rotationAngle: radians))
    transform = transform.concatenating(CGAffineTransform(scaleX: scaleX, y: scaleY * DIR))
    transform = transform.concatenating(CGAffineTransform(translationX: tx, y: ty))
    context.concatenate(transform)
    
    // Drawa a image
    context.draw(image, in: drawRect)
    
    // Restore the current context
    context.restoreGState()
    context.resetClip()
    
    return context.makeImage()
  }
}



