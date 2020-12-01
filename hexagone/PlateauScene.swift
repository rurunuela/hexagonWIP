//
//  GameScene.swift
//  hexagone
//
//  Created by Richard Urunuela on 05/10/2017.
//  Copyright © 2017 Richard Urunuela. All rights reserved.
//

import SpriteKit
import GameplayKit


//GRid

class Hexagone:SKSpriteNode {
    var edgeSize = 0
    
    convenience init?(edgeSize:CGFloat) {
        
        guard let texture = Hexagone.hexagoneTexture(edgeSize:CGFloat(edgeSize)) else {
            return nil
        }
        self.init(texture: texture, color:SKColor.clear, size: texture.size())
        self.edgeSize = Int(edgeSize)
        
        self.isUserInteractionEnabled = true
        
        var scoreLabel = SKLabelNode(fontNamed: "Arial")
        scoreLabel.text = "0,0"
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.fontSize = CGFloat(12)
        scoreLabel.position = CGPoint(x:0, y: edgeSize/4)
        addChild(scoreLabel)
        
    }
    class func hexagoneTexture(edgeSize:CGFloat) -> SKTexture? {
        let size = CGSize(width: CGFloat(edgeSize)  + 1.0, height: CGFloat(edgeSize) + 1.0)
        UIGraphicsBeginImageContext(size)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        let rect = CGRect(x: edgeSize/2-3, y: edgeSize/2-3, width: 6, height: 6)
        
        
        SKColor.lightGray.setFill()
        context.fillEllipse(in: rect)
        
        
        
        let bezierPath = UIBezierPath()
        
        let ypos = [0.5,1,1,0.5,0,0,0.5]
        let xpos = [0,0.25,0.75,1,0.75,0.25,0]
        
        var xp = Int(xpos[0]*Double(edgeSize))
        var yp = Int(ypos[0]*Double(edgeSize))
        
        
        for i in 1...6 {
            
            bezierPath.move(to: CGPoint(x: xp, y:yp))
            
            xp = Int(xpos[i]*Double(edgeSize))
            yp = Int(ypos[i]*Double(edgeSize))
            bezierPath.addLine(to: CGPoint(x: CGFloat(xp), y: CGFloat(yp)))
            
        }
        
        bezierPath.fill()
        
        SKColor.red.setStroke()
        bezierPath.lineWidth = 2.0
        bezierPath.stroke()
        
        
        context.addPath(bezierPath.cgPath)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let res  = SKTexture(image: image!)
        
        
        
        
        
        
        return res
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        debugPrint(" CLick hexagone")
        self.parent?.touchesBegan(touches, with:event)
        
    }
    
    
}
class Grid:SKSpriteNode {
    var rows:Int!
    var cols:Int!
    var blockSize:CGFloat!
    

    
    convenience init?(blockSize:CGFloat,rows:Int,cols:Int) {
        guard let texture = Grid.gridTexture(blockSize: blockSize,rows: rows, cols:cols) else {
            return nil
        }
        self.init(texture: texture, color:SKColor.clear, size: texture.size())
        self.blockSize = blockSize
        self.rows = rows
        self.cols = cols
        self.isUserInteractionEnabled = true
        self.alpha = 0.3
        
        
      
    }
    
    class func gridTexture(blockSize:CGFloat,rows:Int,cols:Int) -> SKTexture? {
        // Add 1 to the height and width to ensure the borders are within the sprite
        let size = CGSize(width: CGFloat(cols)*blockSize+1.0, height: CGFloat(rows)*blockSize+1.0)
        UIGraphicsBeginImageContext(size)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        let bezierPath = UIBezierPath()
        let offset:CGFloat = 0.5
        // Draw vertical lines
        for i in 0...cols {
            let x = CGFloat(i)*blockSize + offset
            bezierPath.move(to: CGPoint(x: x, y: 0))
            bezierPath.addLine(to: CGPoint(x: x, y: size.height))
        }
        // Draw horizontal lines
        for i in 0...rows {
            let y = CGFloat(i)*blockSize + offset
            bezierPath.move(to: CGPoint(x: 0, y: y))
            bezierPath.addLine(to: CGPoint(x: size.width, y: y))
        }
        SKColor.white.setStroke()
        bezierPath.lineWidth = 1.0
        
        bezierPath.stroke()
        context.addPath(bezierPath.cgPath)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return SKTexture(image: image!)
    }
    
    func gridPosition(row:Int, col:Int) -> CGPoint {
        let offset = blockSize / 2.0 + 0.5
        let x = CGFloat(col) * blockSize - (blockSize * CGFloat(cols)) / 2.0 + offset
        let y = CGFloat(rows - row - 1) * blockSize - (blockSize * CGFloat(rows)) / 2.0 + offset
        return CGPoint(x:x, y:y)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let position = touch.location(in:self)
            let node = atPoint(position)
            
            let x = size.width / 2 + position.x
            let y = size.height / 2 - position.y
            let row = Int(floor(x / blockSize))
            let col = Int(floor(y / blockSize))
            print("GRID \(row) \(col)")
            self.parent?.touchesBegan(touches, with:event)
            
        }
    }
}


class PlateauScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    //camera
    var predps : CGPoint!
    var newPos : CGPoint!
     var cam: SKCameraNode!
    var mx:CGFloat = 0
    var my:CGFloat = 0
    
    override func didMove(to view: SKView) {
        //GRID
        if let grid = Grid(blockSize: 20.0, rows:30, cols:30) {
            grid.position = CGPoint (x:frame.midX, y:frame.midY)
            //grid.position = CGPoint (x:frame.width / 8, y:-frame.height / 8)
            addChild(grid)
        }
        if let hex = Hexagone(edgeSize: 44.0){
            hex.position = CGPoint (x:0, y:0)
            addChild(hex)
        }
        if let hex = Hexagone(edgeSize: 44.0){
            hex.position = CGPoint (x:33, y:22)
            addChild(hex)
        }
        if let hex = Hexagone(edgeSize: (57.105/2)){
            hex.position = CGPoint (x:-545.311, y:399.814)
            addChild(hex)
        }
        
        
        //camera
        //Camera
        cam = SKCameraNode()
        //self.camera = cam
        addChild(cam)
        cam.position = CGPoint(x: size.width/2, y: size.height/2)
        //predps = cam.position
        newPos = cam.position
        
        
        self.isUserInteractionEnabled = true
        
    }
    func setCamera(pos:CGPoint){
        newPos.x =  (newPos.x) - (pos.x - predps.x)
        newPos.y =  (newPos.y) - (pos.y - predps.y)
        mx = mx - (pos.x - predps.x)
        my = my - (pos.y - predps.y)
        predps = pos
        
    }
    
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
   
        let touch = touches.first! as UITouch
        
        let ps = touch.location(in: self)
          debugPrint(" PING \(ps) ")
        predps = ps
       
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        
        let touch = touches.first! as UITouch
        
        let ps = touch.location(in: self)
        
        setCamera(pos: ps)
        guard let touch = touches.first else {
            return
        }
        debugPrint(" TOUCH ");
        let location = touch.location(in: self)
        let previousLocation = touch.previousLocation(in: self)
        
        camera?.position.x += location.x - previousLocation.x
        camera?.position.y += location.y - previousLocation.y
    
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        
        let ps = touch.location(in: self)
        predps = ps
        setCamera(pos: ps)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
    }
}
