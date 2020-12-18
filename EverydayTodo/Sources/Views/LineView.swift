//
//  LineView.swift
//  EverydayTodo
//
//  Created by Tony Jung on 2020/12/17.
//

import UIKit

@IBDesignable class LineView: UIView {
    
}

class SliderView: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var result = super.trackRect(forBounds: bounds)
        result.origin.x = 0
        result.size.width = bounds.size.width
        result.size.height = 10 //added height for desired effect
    
        return result
    }
}
