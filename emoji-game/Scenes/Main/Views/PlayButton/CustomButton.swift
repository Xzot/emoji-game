//
//  CustomButton.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 02.01.2022.
//

import UIKit



// MARK: - CustomButton class
class CustomButton: UIView {
    // MARK: Properties
    private var completion: VoidCompletion?
    
    // MARK: Life Cycle
    init(completion: @escaping VoidCompletion) {
        self.completion = completion
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Highlighting when in touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        alpha = 0.7
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        alpha = 1
        handleTap()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        alpha = 1
    }
}

// MARK: - PlayButton extension
private extension CustomButton {
    @objc
    func handleTap() {
        completion?()
    }
}
