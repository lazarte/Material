//
// Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program located at the root of the software package
// in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
//

import UIKit

public class MaterialPulseView: MaterialView {
	//
	//	:name:	touchesLayer
	//
	internal lazy var touchesLayer: CAShapeLayer = CAShapeLayer()
	
	//
	//	:name:	pulseLayer
	//
	internal lazy var pulseLayer: CAShapeLayer = CAShapeLayer()
	
	/**
		:name:	pulseColorOpacity
	*/
	public var pulseColorOpacity: CGFloat! {
		didSet {
			pulseColorOpacity = nil == pulseColorOpacity ? 0.5 : pulseColorOpacity!
		}
	}
	
	/**
		:name:	pulseColor
	*/
	public var pulseColor: UIColor? {
		didSet {
			pulseLayer.backgroundColor = pulseColor?.colorWithAlphaComponent(pulseColorOpacity!).CGColor
		}
	}
	
	/**
		:name:	init
	*/
	public convenience init() {
		self.init(frame: CGRectMake(MaterialTheme.pulseView.x, MaterialTheme.pulseView.y, MaterialTheme.pulseView.width, MaterialTheme.pulseView.height))
	}
	
	/**
		:name:	layoutSubviews
	*/
	public override func layoutSubviews() {
		super.layoutSubviews()
		touchesLayer.frame = bounds
		touchesLayer.cornerRadius = layer.cornerRadius
	}
	
	/**
		:name:	touchesBegan
	*/
	public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesBegan(touches, withEvent: event)
		let point: CGPoint = touches.first!.locationInView(self)
		
		// set start position
		CATransaction.begin()
		CATransaction.setAnimationDuration(0)
		let w: CGFloat = width / 2
		pulseLayer.hidden = false
		pulseLayer.position = point
		pulseLayer.bounds = CGRectMake(0, 0, w, w)
		pulseLayer.cornerRadius = CGFloat(w / 2)
		CATransaction.commit()
		
		// expand
		CATransaction.begin()
		CATransaction.setAnimationDuration(0.3)
		pulseLayer.transform = CATransform3DMakeScale(2.5, 2.5, 2.5)
		layer.transform = CATransform3DMakeScale(1.05, 1.05, 1.05)
		CATransaction.commit()
	}
	
	/**
		:name:	touchesEnded
	*/
	public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesEnded(touches, withEvent: event)
		shrink()
	}
	
	/**
		:name:	touchesCancelled
	*/
	public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
		super.touchesCancelled(touches, withEvent: event)
		shrink()
	}
	
	/**
		:name:	actionForLayer
	*/
	public override func actionForLayer(layer: CALayer, forKey event: String) -> CAAction? {
		return nil // returning nil enables the animations for the layer property that are normally disabled.
	}
	
	//
	//	:name:	prepareView
	//
	internal override func prepareView() {
		super.prepareView()
		userInteractionEnabled = MaterialTheme.pulseView.userInteractionEnabled
		backgroundColor = MaterialTheme.pulseView.backgroudColor
		pulseColorOpacity = MaterialTheme.pulseView.pulseColorOpacity
		pulseColor = MaterialTheme.pulseView.pulseColor
		
		contentsRect = MaterialTheme.pulseView.contentsRect
		contentsCenter = MaterialTheme.pulseView.contentsCenter
		contentsScale = MaterialTheme.pulseView.contentsScale
		contentsGravity = MaterialTheme.pulseView.contentsGravity
		shadowDepth = MaterialTheme.pulseView.shadowDepth
		shadowColor = MaterialTheme.pulseView.shadowColor
		zPosition = MaterialTheme.pulseView.zPosition
		masksToBounds = MaterialTheme.pulseView.masksToBounds
		cornerRadius = MaterialTheme.pulseView.cornerRadius
		borderWidth = MaterialTheme.pulseView.borderWidth
		borderColor = MaterialTheme.pulseView.bordercolor
		
		// touchesLayer
		touchesLayer.zPosition = 1000
		touchesLayer.masksToBounds = true
		layer.addSublayer(touchesLayer)
		
		// pulseLayer
		pulseLayer.hidden = true
		touchesLayer.addSublayer(pulseLayer)
	}
	
	//
	//	:name:	shrink
	//
	internal func shrink() {
		CATransaction.begin()
		CATransaction.setAnimationDuration(0.3)
		pulseLayer.hidden = true
		pulseLayer.transform = CATransform3DIdentity
		layer.transform = CATransform3DIdentity
		CATransaction.commit()
	}
}