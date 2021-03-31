//
//  Shaders.metal
//  Metal01-三角形
//
//  Created by chenwei on 2021/3/31.
//

#include <metal_stdlib>
using namespace metal;
#import "ShaderTypes.h"

typedef struct
{
    float4 position [[position]];
    float4 color;
} RasterizerData;

vertex RasterizerData vertexShader(constant Vertex *vertices [[buffer(VertexInputIndexVertices)]],
                                   uint vid [[vertex_id]]) {
    RasterizerData outVertex;

    outVertex.position = vector_float4(vertices[vid].position, 0.0, 1.0);
    outVertex.color = vertices[vid].color;

    return outVertex;
}

fragment float4 fragmentShader(RasterizerData inVertex [[stage_in]]) {
    return inVertex.color;
}
