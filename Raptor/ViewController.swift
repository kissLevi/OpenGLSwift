//
//  ViewController.swift
//  Raptor
//
//  Created by Kiss Levente on 2018. 02. 19..
//  Copyright © 2018. Kiss Levente. All rights reserved.
//

import GLKit

class ViewController: GLKViewController {
    private let _sprite = Sprite()
    private let _sprite2 = Sprite()
    private var _floverTexture: GLKTextureInfo? = nil
    private var _blueDogEyeTexture: GLKTextureInfo? = nil
    private var _animation = 0.0
    private var _lastUpdate: NSDate = NSDate()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let glkView : GLKView = view as! GLKView
        glkView.context = EAGLContext(api: .openGLES2)! // opengl es 2
        glkView.drawableColorFormat = .RGBA8888 // 32bit colour
        EAGLContext.setCurrent(glkView.context) // setting up context
        
        //gestures
//        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(stopAnimation))
//        glkView.addGestureRecognizer(tapRecognizer)
//        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(changeDirection))
//        swipeRecognizer.direction = .up
//        glkView.addGestureRecognizer(swipeRecognizer)
        
        setup()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setup(){
        glClearColor(0.0, 1.0, 0.0, 1.0)
        _blueDogEyeTexture = try! GLKTextureLoader.texture(with: UIImage(named: "bluedogeye")!.cgImage!, options: nil)
        _floverTexture = try! GLKTextureLoader.texture(with: UIImage(named: "flover2")!.cgImage!, options: nil)
        _sprite.texture = _blueDogEyeTexture!.name
        _sprite2.texture = _floverTexture!.name
        _sprite2.width = 0.5
        _sprite2.height = 0.5
        _sprite.width = 0.5
        _sprite.height = 0.5
        
    }
    

    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        let now = NSDate()
        let elapsed = now.timeIntervalSince(_lastUpdate as Date)
        _lastUpdate = now
        _sprite.position.x += Float(elapsed * 0.25)
        _animation += elapsed * 0.25
        
        _sprite.position.x = Float(cos(_animation))
        _sprite.position.y = Float(sin(_animation))
        
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        //should be not here(performance drop) because it has to count it each frame

        let height: GLsizei = GLsizei(view.bounds.height * view.contentScaleFactor)
        let offset: GLsizei = GLsizei((view.bounds.height - view.bounds.width) * -0.5 * view.contentScaleFactor)
        glViewport(offset, 0, height, height)
        
        //print(view.bounds)
        _sprite.draw()
        _sprite2.draw()
        
        
        // Draw a triangle

        
//        glUniform2f(glGetUniformLocation(_program, "translate"), -_translateX, _translateY)
//        glUniform4f(glGetUniformLocation(_program, "color"), 0.0, 0.0, 0.0, 1.0)
//
//        glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, 4)
    }


}

