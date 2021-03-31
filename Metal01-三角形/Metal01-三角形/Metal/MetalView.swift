//
//  MetalView.swift
//  Metal01-三角形
//
//  Created by chenwei on 2021/3/31.
//

import UIKit
import MetalKit

class MetalView: UIView {
    
    var device: MTLDevice!
    var pipelineState: MTLRenderPipelineState!
    var commonQueue: MTLCommandQueue!

    var metalLayer: CAMetalLayer {
        return layer as! CAMetalLayer
    }

    override class var layerClass : AnyClass {
        return CAMetalLayer.self
    }
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: - Private
    func commonInit() {
        device = MTLCreateSystemDefaultDevice()
        commonQueue = device?.makeCommandQueue()
        setupPipeline()
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        render()
    }

    func setupPipeline() {
        let library = device.makeDefaultLibrary()!
        let vertexFunction = library.makeFunction(name: "vertexShader")
        let fragmentFunction = library.makeFunction(name: "fragmentShader")

        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat

        pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    func render() {
        guard let drawable = metalLayer.nextDrawable() else {
          return
        }
        
        let renderPassDescripor = MTLRenderPassDescriptor()
        renderPassDescripor.colorAttachments[0].clearColor = MTLClearColorMake(0.48, 0.74, 0.92, 1)
        renderPassDescripor.colorAttachments[0].texture = drawable.texture
        renderPassDescripor.colorAttachments[0].loadAction = .clear
        renderPassDescripor.colorAttachments[0].storeAction = .store
        
        let commandBuffer = commonQueue.makeCommandBuffer()!
        let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescripor)!
        
        ///
        commandEncoder.setRenderPipelineState(pipelineState)
        let vertices = [Vertex(position: [ 0.5, -0.5], color: [1, 0, 0, 1]),
                        Vertex(position: [-0.5, -0.5], color: [0, 1, 0, 1]),
                        Vertex(position: [ 0.0,  0.5], color: [0, 0, 1, 1])]
        commandEncoder.setVertexBytes(vertices, length: MemoryLayout<Vertex>.size * 3, index: Int(VertexInputIndexVertices.rawValue))
        commandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        ///
        
        commandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
}
