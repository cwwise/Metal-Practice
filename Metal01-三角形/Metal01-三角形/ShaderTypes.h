//
//  ShaderTypes.h
//  Metal01-三角形
//
//  Created by chenwei on 2021/3/31.
//

#ifndef ShaderTypes_h
#define ShaderTypes_h

#include <simd/simd.h>

typedef struct
{
    vector_float2 position;
    vector_float4 color;
} Vertex;

typedef enum VertexInputIndex
{
    VertexInputIndexVertices = 0,
    VertexInputIndexCount    = 1,
} VertexInputIndex;

#endif /* ShaderTypes_h */
