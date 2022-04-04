//
//  SegmentedControlBuilder.swift
//  SegmentedControl
//
//  Created by Suha Baobaid on 4/4/22.
//

import Foundation
import UIKit


// =======================================
// MARK: - Segmented Control Factory
// To get all the images we need for all
// the background and dividers for various
// states
// =======================================
protocol SegmentedControlImageFactory {
    func background(color: UIColor) -> UIImage?
    func divider(leftColor: UIColor, rightColor: UIColor) -> UIImage?
}

extension SegmentedControlImageFactory {
    func background(color: UIColor) -> UIImage? { return nil }
    func divider(leftColor: UIColor, rightColor: UIColor) -> UIImage? { return nil }
}

struct DefaultSegmentedControlImageFactory: SegmentedControlImageFactory { }

//===========================================
// MARK: Underline
//===========================================
struct UnderlinedSegmentedControlImageFactory: SegmentedControlImageFactory {
    var size = CGSize(width: 2, height: 29)
    var lineWidth: CGFloat = 2
    
    func background(color: UIColor) -> UIImage? {
        return UIImage.render(size: size) {
            color.setFill()
            UIRectFill(CGRect(x: 0, y: size.height-lineWidth, width: size.width, height: lineWidth))
        }
    }
    
    func divider(leftColor: UIColor, rightColor: UIColor) -> UIImage? {
        return UIImage.render(size: size) {
            UIColor.clear.setFill()
        }
    }
}

// =======================================
// MARK: - Segmented Control Builder
// =======================================
struct SegmentedControlBuilder {
    var boldStates: [UIControl.State] = [.selected, .highlighted]
    var boldFont = UIFont.boldSystemFont(ofSize: 14)
    var tintColor: UIColor
    var apportionsSegmentWidthsByContent = false
    
    private let imageFactory: SegmentedControlImageFactory
    
    init(imageFactory: SegmentedControlImageFactory = DefaultSegmentedControlImageFactory(), tintColor: UIColor = .red) {
        self.imageFactory = imageFactory
        self.tintColor = tintColor
    }
    
    func makeSegmentedControl(items: [UIImage]) -> UISegmentedControl {
        let segmentedControl = UISegmentedControl(items: items)
        build(segmentedControl: segmentedControl)
        return segmentedControl
    }

    func makeSegmentedControl(items: [String]) -> UISegmentedControl {
        let segmentedControl = UISegmentedControl(items: items)
        build(segmentedControl: segmentedControl)
        return segmentedControl
    }

    // this is the bulder function that we use to create it
    func build(segmentedControl: UISegmentedControl) {
        segmentedControl.apportionsSegmentWidthsByContent = apportionsSegmentWidthsByContent
        segmentedControl.tintColor = tintColor
        segmentedControl.selectedSegmentIndex = 0

        boldStates
            .forEach { (state: UIControl.State) in
                let attributes = [NSAttributedString.Key.font: boldFont, NSAttributedString.Key.foregroundColor: tintColor]
                segmentedControl.setTitleTextAttributes(attributes, for: state)
        }
        
        let controlStates: [UIControl.State] = [
            .normal,
            .selected,
            .highlighted,
            [.highlighted, .selected]
        ]
        
        controlStates.forEach { state in
            let image = background(for: state)
            segmentedControl.setBackgroundImage(image, for: state, barMetrics: .default)
            
            controlStates.forEach { innerState in
                let image = divider(letState: state, rightState: innerState)
                segmentedControl.setDividerImage(image, forLeftSegmentState: state, rightSegmentState: innerState, barMetrics: .default)
            }
        }
    }
    
    private func color(for state: UIControl.State) -> UIColor {
        switch state {
            case .selected, [.selected, .highlighted]:
                return .white
            case .highlighted:
                return UIColor.white.withAlphaComponent(0.5)
            default:
                return .clear
        }
    }
    
    private func background(for state: UIControl.State) -> UIImage? {
        return imageFactory.background(color: color(for: state))
    }
    
    private func divider(letState: UIControl.State, rightState: UIControl.State) -> UIImage? {
        return imageFactory.divider(leftColor: color(for: letState), rightColor: color(for: rightState))
    }
    
}

//===========================================
// MARK: UIImage extension
//===========================================
extension UIImage {
    // takes the desired canvas size and a function to draw onto the canvas.
    // The function initializes the graphics context, calls the draw function and returns the
    // resulting image in template rendering mode while cleaning everything up.
    static func render(size: CGSize, _ draw: () -> Void) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        defer { UIGraphicsEndImageContext() }
        
        draw()
        
        return UIGraphicsGetImageFromCurrentImageContext()?
            .withRenderingMode(.alwaysTemplate)
    }
    
    // takes merely size and color then uses the render function to create a solid color image.
    static func make(size: CGSize, color: UIColor = .white) -> UIImage? {
        return render(size: size) {
            color.setFill()
            UIRectFill(CGRect(origin: .zero, size: size))
        }
    }
}
