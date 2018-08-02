//
//  Sprite.swift
//  Raptor
//
//  Created by Kiss Levente on 2018. 02. 20..
//  Copyright © 2018. Kiss Levente. All rights reserved.
//

import GLKit

class Sprite {
    private static var _program:GLuint = 0
    private static let _quad: [Float] = [
        -0.5, -0.5,
        0.5, -0.5,
        -0.5, 0.5,
        0.5, 0.5,
    ]
    private static let _quadTextureCoordinates: [Float] = [
        0.0, 1.0,
        1.0, 1.0,
        0.0, 0.0,
        1.0, 0.0,
    ]
    
    
    private static func setup(){
        let vertexShaderSourceString = "" +
            "attribute vec2 position; \n" +
            "attribute vec2 textureCoordinate; \n" +
            "uniform vec2 translate;\n" +
            "uniform vec2 scale;\n" +
            "varying vec2 textureCoordinateInterpolated; \n" +
            "void main() \n" +
            "{ \n" +
            "   gl_Position = vec4(position.x * scale.x + translate.x, position.y * scale.y + translate.y, 0.0, 1.0); \n" +
            "   textureCoordinateInterpolated = textureCoordinate; \n" +
            "} \n"
        
        let fragmentShaderSourceString = "" +
            "uniform highp vec4 color; \n" +
            "uniform sampler2D textureUnit; \n" +
            "varying highp vec2 textureCoordinateInterpolated; \n" +
            "void main() \n" +
            "{ \n" +
            "   gl_FragColor = texture2D(textureUnit, textureCoordinateInterpolated); \n" +
        "} \n"
        
        let vertexShaderSource : NSString = vertexShaderSourceString as NSString
        let fragmentShaderSource : NSString = fragmentShaderSourceString as NSString
        
        //Create and compile vertex shader
        let vertexShader: GLuint  = glCreateShader(GLenum(GL_VERTEX_SHADER))
        var vertexShaderSourceUTF8 = vertexShaderSource.utf8String
        glShaderSource(vertexShader, 1, &vertexShaderSourceUTF8, nil)
        glCompileShader(vertexShader)
        var vertexShaderCompileStatus: GLint = GL_FALSE
        glGetShaderiv(vertexShader, GLenum(GL_COMPILE_STATUS), &vertexShaderCompileStatus)
        if vertexShaderCompileStatus == GL_FALSE {
            var vertexShaderLogLength: GLint = 0
            glGetShaderiv(vertexShader, GLenum(GL_INFO_LOG_LENGTH), &vertexShaderLogLength)
            let vertexShaderLog = UnsafeMutablePointer<GLchar>.allocate(capacity: Int(vertexShaderLogLength))
            glGetShaderInfoLog(vertexShader, vertexShaderLogLength, nil, vertexShaderLog)
            let vertexShaderLogString: NSString? = NSString(utf8String: vertexShaderLog)
            print("Vertex Shader Compile Failed! Error: \(vertexShaderLogString!)")
            // TODO: Prevent drawing
        }
        
        //Create and compile fragment shader
        let fragmentShader: GLuint  = glCreateShader(GLenum(GL_FRAGMENT_SHADER))
        var fragmentShaderSourceUTF8 = fragmentShaderSource.utf8String
        glShaderSource(fragmentShader, 1, &fragmentShaderSourceUTF8, nil)
        glCompileShader(fragmentShader)
        var fragmentShaderCompileStatus: GLint = GL_FALSE
        glGetShaderiv(fragmentShader, GLenum(GL_COMPILE_STATUS), &fragmentShaderCompileStatus)
        if fragmentShaderCompileStatus == GL_FALSE {
            var fragmentShaderLogLength: GLint = 0
            glGetShaderiv(fragmentShader, GLenum(GL_INFO_LOG_LENGTH), &fragmentShaderLogLength)
            let fragmentShaderLog = UnsafeMutablePointer<GLchar>.allocate(capacity: Int(fragmentShaderLogLength))
            glGetShaderInfoLog(fragmentShader, fragmentShaderLogLength, nil, fragmentShaderLog)
            let fragmentShaderLogString: NSString? = NSString(utf8String: fragmentShaderLog)
            print("Fragment Shader Compile Failed! Error: \(fragmentShaderLogString!)")
            // TODO: Prevent drawing
        }
        
        // Link shaders into a program
        _program = glCreateProgram()
        glAttachShader(_program, vertexShader)
        glAttachShader(_program, fragmentShader)
        glBindAttribLocation(_program, 0, "position")
        glBindAttribLocation(_program, 1, "textureCoordinate")
        glLinkProgram(_program)
        var programLinkStatus: GLint = GL_FALSE
        glGetProgramiv(_program, GLenum(GL_LINK_STATUS), &programLinkStatus)
        if programLinkStatus == GL_FALSE{
            var programLogLength: GLint = 0
            glGetProgramiv(_program, GLenum(GL_INFO_LOG_LENGTH), &programLogLength)
            let linkLog = UnsafeMutablePointer<GLchar>.allocate(capacity: Int(programLogLength))
            glGetProgramInfoLog(_program, programLogLength, nil, linkLog)
            let linkLogString: NSString? = NSString(utf8String: linkLog)
            print("Fragment Shader Compile Failed! Error: \(linkLogString!)")
        }
        
        // Redefine OpenGL defaults
        // what changes will other OpenGl users in the program make?
        glEnable(GLenum(GL_BLEND))
        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA))
        glUseProgram(_program)
        glEnableVertexAttribArray(0)
        glVertexAttribPointer(0, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, _quad)// second param is dimensions
        glEnableVertexAttribArray(1)
        glVertexAttribPointer(1, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, _quadTextureCoordinates)// second param is dimensions
    }
    
    var position: Vector = Vector()
    var width: Float = 1.0
    var height: Float = 1.0
    //var rotation: Float
    var texture: GLuint = 0
    
    func draw(){
        if Sprite._program == 0 {
            Sprite.setup()
        }
        glUniform2f(glGetUniformLocation(Sprite._program, "translate"), position.x, position.y)
        glUniform2f(glGetUniformLocation(Sprite._program, "scale"), width, height)
        //glUniform4f(glGetUniformLocation(Sprite._program, "color"), 1.0, 0.0, 0.0, 1.0)
        glUniform1i(glGetUniformLocation(Sprite._program,"textureUnit"), 0)
        glBindTexture(GLenum(GL_TEXTURE_2D), texture)
        glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, 4)
    }
}


