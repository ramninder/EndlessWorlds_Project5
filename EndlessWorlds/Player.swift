//
//  Player.swift
//  EndlessWorlds
//
//  Created by ramninder singh on 2/20/2019.
//  Copyright (c) 2019 ramnindersaini. All rights reserved.

import Foundation
import SpriteKit



class Player: SKSpriteNode {
    
   
    @objc var jumpAction:SKAction?
    @objc var runAction:SKAction?
    @objc var glideAction:SKAction?

    
    @objc var isJumping:Bool = false
    @objc var isGliding:Bool = false
    @objc var isRunning:Bool = true
    @objc var isAttacking:Bool = false
    
    
    @objc var jumpAmount:CGFloat = 0
    @objc var maxJump:CGFloat = 20
    
    @objc var minSpeed:CGFloat = 6
    
    @objc var glideTime:TimeInterval = 2
    @objc var slideTime:TimeInterval = 0.5
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init (imageNamed:String) {
        
        let imageTexture = SKTexture(imageNamed: imageNamed)
        super.init(texture: imageTexture, color:SKColor.clear, size: imageTexture.size() )
        
        let body:SKPhysicsBody = SKPhysicsBody(circleOfRadius: imageTexture.size().width / 2, center:CGPoint(x: 0, y: 0))
        body.isDynamic = true
        body.affectedByGravity = true
        body.allowsRotation = false
        body.restitution = 0.0
        body.categoryBitMask = BodyType.player.rawValue
        body.contactTestBitMask = BodyType.deathObject.rawValue | BodyType.wheelObject.rawValue | BodyType.platformObject.rawValue | BodyType.ground.rawValue  | BodyType.water.rawValue | BodyType.moneyObject.rawValue
        body.collisionBitMask = BodyType.platformObject.rawValue | BodyType.ground.rawValue
        body.friction = 0.9 //0 is like glass, 1 is like sandpaper to walk on
        self.physicsBody = body
        
        
        setUpRun()
        setUpJump()
        setUpGlide()
        
        startRun()
        
        
    }
    
    @objc func update() {
        
        if (isGliding == true) {
            
            self.position = CGPoint(x: self.position.x + minSpeed, y: self.position.y - 0.4)
            
        } else {
            
            
            self.position = CGPoint(x: self.position.x + minSpeed, y: self.position.y + jumpAmount)
            
        }
        
        
        
        
        
    }
    
    @objc func setUpRun() {
        
        let atlas = SKTextureAtlas (named: "Ogre")
        
        var array = [String]()
        
        //or setup an array with exactly the sequential frames start from 1
        
        
        //was
        //  for var i=1; i <= 20; i++ {
        
        for i in 1 ... 20 {
        
       
            
            let nameString = String(format: "ogre_run%i", i)
            array.append(nameString)
            
        }
        
        //create another array this time with SKTexture as the type (textures being the .png images)
        var atlasTextures:[SKTexture] = []
        
        
        //was
        //for (var i = 0; i < array.count; i++ ) {
        
        for i in 0 ..< array.count{
            
            let texture:SKTexture = atlas.textureNamed( array[i] )
            atlasTextures.insert(texture, at:i)
            
        }
        
        let atlasAnimation = SKAction.animate(with: atlasTextures, timePerFrame: 1.0/60, resize: true , restore:false )
        runAction =  SKAction.repeatForever(atlasAnimation)
        
        
        
    }
    
    
    @objc func setUpJump() {
        
        let atlas = SKTextureAtlas (named: "Ogre")
        
        var array = [String]()
        
        //or setup an array with exactly the sequential frames start from 1
        
        //was
        //  for var i=1; i <= 9; i++ {
        
        for i in 1 ... 9 {
      
            let nameString = String(format: "ogre_jump%i", i)
            array.append(nameString)
            
        }
        
        //create another array this time with SKTexture as the type (textures being the .png images)
        var atlasTextures:[SKTexture] = []
        
        //was...
        //for (var i = 0; i < array.count; i++ ) {
        
        for i in 0 ..< array.count {
            
            let texture:SKTexture = atlas.textureNamed( array[i] )
            atlasTextures.insert(texture, at:i)
            
        }
        
        let atlasAnimation = SKAction.animate(with: atlasTextures, timePerFrame: 2.0/20, resize: true , restore:false )
        jumpAction =  SKAction.repeatForever(atlasAnimation)
        
        
        
    }
    
    @objc func setUpGlide() {
        
        let atlas = SKTextureAtlas (named: "Ogre")
        
        var array = [String]()
        
        //or setup an array with exactly the sequential frames start from 1
        //was
        //  for var i=1; i <= 12; i++ {
        
        for i in 1 ... 12 {
            
            let nameString = String(format: "ogre_slide%i", i)
            array.append(nameString)
            
        }
        
        //create another array this time with SKTexture as the type (textures being the .png images)
        var atlasTextures:[SKTexture] = []
        
        //was...
        //for (var i = 0; i < array.count; i++ ) {
        
        for i in 0 ..< array.count {
            
            let texture:SKTexture = atlas.textureNamed( array[i] )
            atlasTextures.insert(texture, at:i)
            
        }
        
        let atlasAnimation = SKAction.animate(with: atlasTextures, timePerFrame: 1.0/20, resize: true , restore:false )
        glideAction =  SKAction.repeatForever(atlasAnimation)
        
        
        
    }
    
    
    
    
    
    
    @objc func startRun(){
        
        isGliding = false
        isRunning = true
        isJumping = false
        
        self.removeAction(forKey: "jumpKey")
        self.removeAction(forKey: "glideKey")
        self.run(runAction! , withKey:"runKey")
        
    }
    @objc func startJump(){
        
        self.removeAction(forKey: "runKey")
        self.run(jumpAction!, withKey:"jumpKey" )
        
        isGliding = false
        isRunning = false
        isJumping = true
        
        
    }
    
    @objc func jump() {
        
        if ( isJumping == false && isGliding == false) {
            
                startJump()
            
                jumpAmount = maxJump
            
            let callAgain:SKAction = SKAction.run(taperJump)
            let wait:SKAction = SKAction.wait(forDuration: 1/60)
            let seq:SKAction = SKAction.sequence([wait, callAgain])
            let `repeat`:SKAction = SKAction.repeat(seq, count: 20)
            let stop:SKAction = SKAction.run(stopJump)
            let seq2:SKAction = SKAction.sequence([`repeat`, stop])
            
            self.run(seq2)
            
            
            
        }
        
    }
    
    
    @objc func taperJump() {
        
        
        jumpAmount = jumpAmount * 0.9
        
    }
    
    
    @objc func stopJump() {
        
        isJumping = false
        jumpAmount = 0
        
        if (isGliding == false) {
            
            startRun()
            
        }
        
        
    }
    
    
    
    
    @objc func startGlide(){
        
        isJumping = false
        isRunning = false
        isGliding = true
        
        self.removeAction(forKey: "runKey")
        self.removeAction(forKey: "jumpKey")
        self.run(glideAction!, withKey:"glideKey")
        
    }
    
    
    @objc func glide() {
        
        
        if (isGliding == false && isJumping == true) {
            
            startGlide()
            
            self.physicsBody?.isDynamic = false
            
            let wait:SKAction = SKAction.wait(forDuration: glideTime)
            let block:SKAction = SKAction.run(stopGlide)
            let seq:SKAction = SKAction.sequence([wait, block])
            
            self.run(seq)
        
            
        } else {
            
            slide()
        }
        
        
    }
    
    
    @objc func stopGlide() {
        
        self.physicsBody?.isDynamic = true
        
        self.startRun()
        
    }
    
    
    @objc func slide() {
        
        
        if (isRunning == true && isAttacking == false) {
            
            startGlide()
            
            isAttacking = true
            
            let wait:SKAction = SKAction.wait( forDuration: slideTime)
            let block:SKAction = SKAction.run(stopSlide)
            let seq:SKAction = SKAction.sequence([wait, block])
            
            self.run(seq)
            
            
        }
        
    }
    
    
    @objc func stopSlide() {
        
        
        
        isAttacking = false
        
        startRun()
        
    }
    
    
}















