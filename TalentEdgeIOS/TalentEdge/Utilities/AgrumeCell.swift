//
//  Copyright © 2016 Schnaub. All rights reserved.
//

import UIKit

protocol AgrumeCellDelegate: class {
  
  func dismissAfterFlick()
  func dismissAfterTap()
  
}

final class AgrumeCell: UICollectionViewCell {

  private static let targetZoomForDoubleTap: CGFloat = 3
  private static let minFlickDismissalVelocity: CGFloat = 800
  private static let highScrollVelocity: CGFloat = 1600

  private lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView(frame: self.contentView.bounds)
    scrollView.delegate = self
    scrollView.zoomScale = 1
    scrollView.maximumZoomScale = 8
    scrollView.scrollEnabled = false
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.showsVerticalScrollIndicator = false
    return scrollView
  }()
  private lazy var imageView: UIImageView = {
    let imageView = UIImageView(frame: self.contentView.bounds)
    imageView.contentMode = .ScaleAspectFit
    imageView.userInteractionEnabled = true
    imageView.clipsToBounds = true
    imageView.layer.allowsEdgeAntialiasing = true
    return imageView
  }()
  private var animator: UIDynamicAnimator!

  var image: UIImage? {
    didSet {
      imageView.image = image
      updateScrollViewAndImageViewForCurrentMetrics()
    }
  }
  weak var delegate: AgrumeCellDelegate?

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = UIColor.clearColor()
    contentView.addSubview(scrollView)
    scrollView.addSubview(imageView)
    setupGestureRecognizers()
    animator = UIDynamicAnimator(referenceView: scrollView)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func prepareForReuse() {
    imageView.image = nil
    scrollView.zoomScale = 1
    updateScrollViewAndImageViewForCurrentMetrics()
  }

  private lazy var singleTapGesture: UITapGestureRecognizer = {
    let singleTapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(singleTap))
    singleTapGesture.requireGestureRecognizerToFail(self.doubleTapGesture)
    singleTapGesture.delegate = self
    return singleTapGesture
  }()
  private lazy var doubleTapGesture: UITapGestureRecognizer = {
    let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
    doubleTapGesture.numberOfTapsRequired = 2
    return doubleTapGesture
  }()
  private lazy var panGesture: UIPanGestureRecognizer = {
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dismissPan))
    panGesture.maximumNumberOfTouches = 1
    panGesture.delegate = self
    return panGesture
  }()
  lazy var swipeGesture: UISwipeGestureRecognizer = {
    let swipeGesture = UISwipeGestureRecognizer(target: self, action: nil)
    swipeGesture.direction = [.Left, .Right]
    swipeGesture.delegate = self
    return swipeGesture
  }()

  private var flickedToDismiss = false
  private var isDraggingImage = false
  private var imageDragStartingPoint: CGPoint!
  private var imageDragOffsetFromActualTranslation: UIOffset!
  private var imageDragOffsetFromImageCenter: UIOffset!
  private var attachmentBehavior: UIAttachmentBehavior?

  private func setupGestureRecognizers() {
    contentView.addGestureRecognizer(singleTapGesture)
    contentView.addGestureRecognizer(doubleTapGesture)
    scrollView.addGestureRecognizer(panGesture)
    contentView.addGestureRecognizer(swipeGesture)
  }

}

extension AgrumeCell: UIGestureRecognizerDelegate {

  func notZoomed() -> Bool {
    return scrollView.zoomScale == 1
  }

  override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
    if let pan = gestureRecognizer as? UIPanGestureRecognizer where notZoomed() {
      let velocity = pan.velocityInView(scrollView)
      return abs(velocity.y) > abs(velocity.x)
    } else if let gest = gestureRecognizer as? UISwipeGestureRecognizer where notZoomed() {
      return false
    } else if let tap = gestureRecognizer as? UITapGestureRecognizer where tap == singleTapGesture && !notZoomed() {
      return false
    }
    return true
  }

  func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    if let gest = gestureRecognizer as? UIPanGestureRecognizer {
      return notZoomed()
    }
    return true
  }

  @objc private func doubleTap(sender: UITapGestureRecognizer) {
    let point = scrollView.convertRect(sender.locationInView(sender.view), fromView: sender.view)
    
    if notZoomed() {
      zoom(to: point, scale: AgrumeCell.targetZoomForDoubleTap)
    } else {
      zoom(to: .zero, scale: 1)
    }
  }
  
  private func zoom(to point: CGPoint, scale: CGFloat) {
    let factor = 1 / scrollView.zoomScale
    let translatedZoom = CGPoint(x: (point.x + scrollView.contentOffset.x) * factor,
                                 y: (point.y + scrollView.contentOffset.y) * factor)

    let width = scrollView.frame.width / scale
    let height = scrollView.frame.height / scale
    let destination = CGRect(x: translatedZoom.x - width  / 2, y: translatedZoom.y - height / 2, width: width, height: height)

    contentView.userInteractionEnabled = false
    
    CATransaction.begin()
    CATransaction.setCompletionBlock { [unowned self] in
      self.contentView.userInteractionEnabled = true
    }
    scrollView.zoomToRect(destination, animated: true)
    CATransaction.commit()
  }

  private func contentInsetForScrollView(atScale: CGFloat) -> UIEdgeInsets {
    let boundsWidth = scrollView.bounds.width
    let boundsHeight = scrollView.bounds.height
    let contentWidth = max(image?.size.width ?? 0, boundsWidth)
    let contentHeight = max(image?.size.height ?? 0, boundsHeight)

    var minContentWidth: CGFloat
    var minContentHeight: CGFloat

    if contentHeight > contentWidth {
      if boundsHeight / boundsWidth < contentHeight / contentWidth {
        minContentHeight = boundsHeight
        minContentWidth = contentWidth * (minContentHeight / contentHeight)
      } else {
        minContentWidth = boundsWidth
        minContentHeight = contentHeight * (minContentWidth / contentWidth)
      }
    } else {
      if boundsWidth / boundsHeight < contentWidth / contentHeight {
        minContentWidth = boundsWidth
        minContentHeight = contentHeight * (minContentWidth / contentWidth)
      } else {
        minContentHeight = boundsHeight
        minContentWidth = contentWidth * (minContentHeight / contentHeight)
      }
    }
    minContentWidth *= atScale
    minContentHeight *= atScale

    if minContentWidth > contentView.bounds.width && minContentHeight > contentView.bounds.height {
      return UIEdgeInsetsZero
    } else {
      let verticalDiff = max(boundsHeight - minContentHeight, 0) / 2
      let horizontalDiff = max(boundsWidth - minContentWidth, 0) / 2
      return UIEdgeInsets(top: verticalDiff, left: horizontalDiff, bottom: verticalDiff, right: horizontalDiff)
    }
  }

  @objc private func singleTap(gesture: UITapGestureRecognizer) {
    dismiss()
  }

  private func dismiss() {
    if flickedToDismiss {
      delegate?.dismissAfterFlick()
    } else {
      delegate?.dismissAfterTap()
    }
  }

  @objc private func dismissPan(gesture: UIPanGestureRecognizer) {
    let translation = gesture.translationInView(gesture.view!)
    let locationInView = gesture.locationInView(gesture.view)
    let velocity = gesture.velocityInView(gesture.view)
    let vectorDistance = sqrt(pow(velocity.x, 2) + pow(velocity.y, 2))

    if gesture.state == .Began {
      isDraggingImage = imageView.frame.contains(locationInView)
      if isDraggingImage {
        startImageDragging(locationInView, translationOffset: UIOffsetZero)
      }
    } else if gesture.state == .Changed {
      if isDraggingImage {
        var newAnchor = imageDragStartingPoint
        newAnchor?.x += translation.x + imageDragOffsetFromActualTranslation.horizontal
        newAnchor?.y += translation.y + imageDragOffsetFromActualTranslation.vertical
        attachmentBehavior?.anchorPoint = newAnchor!
      } else {
        isDraggingImage = imageView.frame.contains(locationInView)
        if isDraggingImage {
          let translationOffset = UIOffset(horizontal: -1 * translation.x, vertical: -1 * translation.y)
          startImageDragging(locationInView, translationOffset: translationOffset)
        }
      }
    } else {
      if vectorDistance > AgrumeCell.minFlickDismissalVelocity {
        if isDraggingImage {
          dismissWithFlick(velocity)
        } else {
          dismiss()
        }
      } else {
        cancelCurrentImageDrag(true)
      }
    }
  }

  private func dismissWithFlick(velocity: CGPoint) {
    flickedToDismiss = true

    let push = UIPushBehavior(items: [imageView], mode: .Instantaneous)
    push.pushDirection = CGVector(dx: velocity.x * 0.1, dy: velocity.y * 0.1)
    push.setTargetOffsetFromCenter(imageDragOffsetFromImageCenter, forItem: imageView)
    push.action = pushAction
    animator.removeBehavior(attachmentBehavior!)
    animator.addBehavior(push)
  }
  
  private func pushAction() {
    if isImageViewOffscreen() {
      animator.removeAllBehaviors()
      attachmentBehavior = nil
      imageView.removeFromSuperview()
      dismiss()
    }
  }

  private func isImageViewOffscreen() -> Bool {
    let visibleRect = scrollView.convertRect(contentView.bounds, fromView: contentView)
    return animator.itemsInRect(visibleRect).count == 0
  }

  private func cancelCurrentImageDrag(animated: Bool) {
    animator.removeAllBehaviors()
    attachmentBehavior = nil
    isDraggingImage = false

    if !animated {
      imageView.transform = CGAffineTransformIdentity
      imageView.center = CGPoint(x: scrollView.contentSize.width / 2, y: scrollView.contentSize.height / 2)
    } else {
      UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [.AllowUserInteraction, .BeginFromCurrentState], animations: { 
        [unowned self] in
        guard !self.isDraggingImage else { return }
        
        self.imageView.transform = CGAffineTransformIdentity
        if !self.scrollView.dragging && !self.scrollView.decelerating {
            self.imageView.center = CGPoint(x: self.scrollView.contentSize.width / 2,
                y: self.scrollView.contentSize.height / 2)
            self.updateScrollViewAndImageViewForCurrentMetrics()
        }

        }, completion: { (true) in
            
      })
    }
  }

  func updateScrollViewAndImageViewForCurrentMetrics() {
    scrollView.frame = contentView.bounds
    if let image = imageView.image {
      imageView.frame = resizedFrameForSize(image.size)
    }
    scrollView.contentSize = imageView.frame.size
    scrollView.contentInset = contentInsetForScrollView(scrollView.zoomScale)
  }

  private func resizedFrameForSize(imageSize: CGSize) -> CGRect {
    var frame = contentView.bounds
    let screenWidth = frame.width * scrollView.zoomScale
    let screenHeight = frame.height * scrollView.zoomScale
    var targetWidth = screenWidth
    var targetHeight = screenHeight
    let nativeWidth = max(imageSize.width, screenWidth)
    let nativeHeight = max(imageSize.height, screenHeight)

    if nativeHeight > nativeWidth {
      if screenHeight / screenWidth < nativeHeight / nativeWidth {
        targetWidth = screenHeight / (nativeHeight / nativeWidth)
      } else {
        targetHeight = screenWidth / (nativeWidth / nativeHeight)
      }
    } else {
      if screenWidth / screenHeight < nativeWidth / nativeHeight {
        targetHeight = screenWidth / (nativeWidth / nativeHeight)
      } else {
        targetWidth = screenHeight / (nativeHeight / nativeWidth)
      }
    }

    frame.size = CGSize(width: targetWidth, height: targetHeight)
    frame.origin = .zero
    return frame
  }

  private func startImageDragging(locationInView: CGPoint, translationOffset: UIOffset) {
    imageDragStartingPoint = locationInView
    imageDragOffsetFromActualTranslation = translationOffset

    let anchor = imageDragStartingPoint
    let imageCenter = imageView.center
    let offset = UIOffset(horizontal: locationInView.x - imageCenter.x, vertical: locationInView.y - imageCenter.y)
    imageDragOffsetFromImageCenter = offset
    attachmentBehavior = UIAttachmentBehavior(item: imageView, offsetFromCenter: offset, attachedToAnchor: anchor!)
    animator.addBehavior(attachmentBehavior!)

    let modifier = UIDynamicItemBehavior(items: [imageView])
    modifier.angularResistance = angularResistance(imageView)
    modifier.density = density(imageView)
    animator.addBehavior(modifier)
  }

  private func angularResistance(view: UIView) -> CGFloat {
    let defaultResistance: CGFloat = 4
    return appropriateValue(defaultResistance) * factor(forView: view)
  }

  private func density(view: UIView) -> CGFloat {
    let defaultDensity: CGFloat = 0.5
    return appropriateValue(defaultDensity) * factor(forView: view)
  }

  private func appropriateValue(defaultValue: CGFloat) -> CGFloat {
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    // Default value that works well for the screenSize adjusted for the actual size of the device
    return defaultValue * ((320 * 480) / (screenWidth * screenHeight))
  }

  private func factor(forView view: UIView) -> CGFloat {
    let actualArea = contentView.bounds.height * view.bounds.height
    let referenceArea = contentView.bounds.height * contentView.bounds.width
    return referenceArea / actualArea
  }

}

extension AgrumeCell: UIScrollViewDelegate {

  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }

  func scrollViewDidZoom(scrollView: UIScrollView) {
    scrollView.contentInset = contentInsetForScrollView(scrollView.zoomScale)

    if !scrollView.scrollEnabled {
      scrollView.scrollEnabled = true
    }
  }

  func scrollViewDidEndZooming(scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
    scrollView.scrollEnabled = scale > 1
    scrollView.contentInset = contentInsetForScrollView(scale)
  }

  func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    let highVelocity = AgrumeCell.highScrollVelocity
    let velocity = scrollView.panGestureRecognizer.velocityInView(scrollView.panGestureRecognizer.view)
    if notZoomed() && (fabs(velocity.x) > highVelocity || fabs(velocity.y) > highVelocity) {
      dismiss()
    }
  }

}
