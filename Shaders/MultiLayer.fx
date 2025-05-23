/*------------------.
| :: Description :: |
'-------------------/

    MultiLayer (version 1.0)

    Authors: CeeJay.dk, seri14, Marot Satil, Uchu Suzume, prod80, originalnicodr
    License: MIT

    About:
    Blends an image with the game.
    The idea is to give users with graphics skills the ability to create effects using a layer just like in an image editor.
    Maybe they could use this to create custom CRT effects, custom vignettes, logos, custom hud elements, toggable help screens and crafting tables or something I haven't thought of.

    History:
    (*) Feature (+) Improvement (x) Bugfix (-) Information (!) Compatibility
    
    Version 0.2 by seri14 & Marot Satil
    * Added the ability to scale and move the layer around on an x, y axis.

    Version 0.3 by seri14
    * Reduced the problem of layer color is blending with border color

    Version 0.4 by seri14 & Marot Satil
    * Added support for the additional seri14 DLL preprocessor options to minimize loaded textures.

    Version 0.5 by Uchu Suzume & Marot Satil
    * Rotation added.

    Version 0.6 by Uchu Suzume & Marot Satil
    * Added multiple blending modes thanks to the work of Uchu Suzume, prod80, and originalnicodr.

    Version 0.7 by Uchu Suzume & Marot Satil
    * Added Addition, Subtract, Divide blending modes.

    Version 0.8 by Uchu Suzume & Marot Satil
    * Sorted blending modes in a more logical fashion, grouping by type.

    Version 0.9 by Uchu Suzume & Marot Satil
    + Implemented new Blending.fxh preprocessor macros.

    Version 1.0 by Marot Satil
    + Forked Layer.fx into a texture loader for the included common GShade textures to match MultiStageDepth.fx expectations.


	The MIT License (MIT)

	Copyright (c) 2014 CeeJayDK

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
*/

#include "ReShade.fxh"
#include "Blending.fxh"

#define MultiLayerTex "LayerA.png"
#define MULTILAYER_SIZE_X BUFFER_WIDTH
#define MULTILAYER_SIZE_Y BUFFER_HEIGHT
#define MULTILAYER_TEXFORMAT RGBA8

uniform int Layer_Select <
    ui_label = "Layer Selection";
    ui_tooltip = "The image/texture you'd like to use.";
    ui_type = "combo";
    ui_items= "Angelite Layer.png | ReShade 3/4\0LensDB.png (Angelite)\0LensDB.png\0Dirt.png (Angelite)\0Dirt.png (ReShade 4)\0Dirt.jpg (ReShade 3)\0";
    ui_bind = "MultiLayerTexture_Source";
> = 0;

// Set default value(see above) by source code if the preset has not modified yet this variable/definition
#ifndef MultiLayerTexture_Source
#define MultiLayerTexture_Source 0
#endif

uniform float Layer_Saturation <
	ui_type = "slider";
	ui_label = "Saturation";
	ui_tooltip = "The amount of saturation applied to the layer.";
	ui_min = 0.0;
	ui_max = 2.0;
> = 1.0;

uniform float Layer_Brightness <
	ui_type = "slider";
	ui_label = "Brightness";
	ui_tooltip = "The amount of brightness applied to the layer.";
	ui_min = -2.0;
	ui_max = 2.0;
> = 0.0;

BLENDING_COMBO(Layer_BlendMode, "Blending Mode", "Select the blending mode applied to the layer.", "", false, 0, 0)

uniform float Layer_Blend <
    ui_label = "Blending Amount";
    ui_tooltip = "The amount of blending applied to the layer.";
    ui_type = "slider";
    ui_min = 0.0;
    ui_max = 1.0;
    ui_step = 0.001;
> = 1.0;

uniform float Layer_Scale <
  ui_type = "slider";
    ui_label = "Scale X & Y";
    ui_min = 0.001; ui_max = 5.0;
    ui_step = 0.001;
> = 1.001;

uniform float Layer_ScaleX <
  ui_type = "slider";
    ui_label = "Scale X";
    ui_min = 0.001; ui_max = 5.0;
    ui_step = 0.001;
> = 1.0;

uniform float Layer_ScaleY <
  ui_type = "slider";
    ui_label = "Scale Y";
    ui_min = 0.001; ui_max = 5.0;
    ui_step = 0.001;
> = 1.0;

uniform float Layer_PosX <
  ui_type = "slider";
    ui_label = "Position X";
    ui_min = -2.0; ui_max = 2.0;
    ui_step = 0.001;
> = 0.5;

uniform float Layer_PosY <
  ui_type = "slider";
    ui_label = "Position Y";
    ui_min = -2.0; ui_max = 2.0;
    ui_step = 0.001;
> = 0.5;

uniform int Layer_SnapRotate <
    ui_type = "combo";
    ui_label = "Snap Rotation";
    ui_items = "None\0"
               "90 Degrees\0"
               "-90 Degrees\0"
               "180 Degrees\0"
               "-180 Degrees\0";
    ui_tooltip = "Snap rotation to a specific angle.";
> = false;

uniform float Layer_Rotate <
    ui_label = "Rotate";
    ui_type = "slider";
    ui_min = -180.0;
    ui_max = 180.0;
    ui_step = 0.01;
> = 0;

#if   MultiLayerTexture_Source == 0 // Angelite Layer.png | ReShade 3/4
#define _SOURCE_MULTILAYER_FILE MultiLayerTex
#elif MultiLayerTexture_Source == 1 // LensDB.png (Angelite)
#define _SOURCE_MULTILAYER_FILE "LensDBA.png"
#elif MultiLayerTexture_Source == 2 // LensDB.png
#define _SOURCE_MULTILAYER_FILE "LensDB2.png"
#elif MultiLayerTexture_Source == 3 // Dirt.png (Angelite)
#define _SOURCE_MULTILAYER_FILE "DirtA.png"
#elif MultiLayerTexture_Source == 4 // Dirt.png (ReShade 4)
#define _SOURCE_MULTILAYER_FILE "Dirt4.png"
#elif MultiLayerTexture_Source == 5 // Dirt.jpg (ReShade 3)
#define _SOURCE_MULTILAYER_FILE "Dirt3.jpg"
#endif

texture MultiLayer_Tex <source = _SOURCE_MULTILAYER_FILE;> { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format=MULTILAYER_TEXFORMAT; };
sampler MultiLayer_Sampler {
    Texture = MultiLayer_Tex;
    AddressU = CLAMP;
    AddressV = CLAMP;
};

// -------------------------------------
// Entrypoints
// -------------------------------------

void PS_Layer(in float4 pos : SV_Position, float2 texCoord : TEXCOORD, out float4 passColor : SV_Target) {
    const float4 backColor = tex2D(ReShade::BackBuffer, texCoord);
    const float3 pivot = float3(0.5, 0.5, 0.0);
    const float3 mulUV = float3(texCoord.x, texCoord.y, 1);
	const float2 ScaleSize = (float2(MULTILAYER_SIZE_X, MULTILAYER_SIZE_Y) * Layer_Scale);
	const float ScaleX =  ScaleSize.x * Layer_ScaleX;
	const float ScaleY =  ScaleSize.y * Layer_ScaleY;
    float Rotate = Layer_Rotate * (3.1415926 / 180.0);

    switch(Layer_SnapRotate)
    {
        default:
            break;
        case 1:
            Rotate = -90.0 * (3.1415926 / 180.0);
            break;
        case 2:
            Rotate = 90.0 * (3.1415926 / 180.0);
            break;
        case 3:
            Rotate = 0.0;
            break;
        case 4:
            Rotate = 180.0 * (3.1415926 / 180.0);
            break;
    }

    const float3x3 positionMatrix = float3x3 (
        1, 0, 0,
        0, 1, 0,
        -Layer_PosX, -Layer_PosY, 1
    );
    const float3x3 scaleMatrix = float3x3 (
        1/ScaleX, 0, 0,
        0,  1/ScaleY, 0,
        0, 0, 1
    );
    const float3x3 rotateMatrix = float3x3 (
        cos (Rotate), -sin(Rotate), 0,
        sin(Rotate), cos(Rotate), 0,
        0, 0, 1
    );

    const float3 SumUV = mul (mul (mul (mulUV, positionMatrix) * float3(MULTILAYER_SIZE_X, MULTILAYER_SIZE_Y, 1.0), rotateMatrix), scaleMatrix);
    passColor = tex2D(MultiLayer_Sampler, SumUV.rg + pivot.rg) * all(SumUV + pivot == saturate(SumUV + pivot));

	passColor.rgb = (passColor.rgb - dot(passColor.rgb, 0.333)) * Layer_Saturation + dot(passColor.rgb, 0.333);

	passColor.rgb = passColor.rgb + Layer_Brightness;

    passColor = float4(ComHeaders::Blending::Blend(Layer_BlendMode, backColor.rgb, passColor.rgb, passColor.a * Layer_Blend), backColor.a);
}

// -------------------------------------
// Techniques
// -------------------------------------

technique MultiLayer {
    pass
    {
        VertexShader = PostProcessVS;
        PixelShader  = PS_Layer;
    }
}
