//
//  Global.swift
//  Wordle
//
//  Created by Seyoung on 2022/07/30.
//

import UIKit

enum Global {
    static var screenWidth: CGFloat {
        UIScreen.main.bounds.size.width
    }
    
    static var screenHeight: CGFloat {
        UIScreen.main.bounds.size.height
    }
    
    static var minDimension: CGFloat {
        min(screenWidth, screenHeight)
    }
    
    static var boardWidth: CGFloat {
        switch minDimension {
        case 0...320: // ipod touch
            return screenWidth - 55
        case 321...430: // iphone touch
            return screenWidth - 50
        case 431...1000: // ipad touch
            return 350
        default:
            return 500
        }
    }
    
    static var keyboardScale: CGFloat {
        switch minDimension {
        case 0...430:
            return screenWidth / 390
        case 431...1000:
            return CGFloat(1.2)
        default:
            return CGFloat(1.6)
        }
    }
    
    static let commonWords =
    ["APPLE", "BRAIN", "GROUP", "BREAD", "GREEN", "MONEY", "CLEAN", "DANCE", "DRINK", "HOUSE"]
    
}
