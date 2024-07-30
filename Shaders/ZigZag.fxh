/*-----------------------------------------------------------------------------------------------------*/
/* ZigZag Shader - by Radegast Stravinsky of Ultros.                                                   */
/* There are plenty of shaders that make your game look amazing. This isn't one of them.               */
/* License: MIT                                                                                        */
/*                                                                                                     */
/* MIT License                                                                                         */
/*                                                                                                     */
/* Copyright (c) 2021 Radegast-FFXIV                                                                   */
/*                                                                                                     */
/* Permission is hereby granted, free of charge, to any person obtaining a copy                        */
/* of this software and associated documentation files (the "Software"), to deal                       */
/* in the Software without restriction, including without limitation the rights                        */
/* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell                           */
/* copies of the Software, and to permit persons to whom the Software is                               */
/* furnished to do so, subject to the following conditions:                                            */
/*                                                                                                     */
/* The above copyright notice and this permission notice shall be included in all                      */
/* copies or substantial portions of the Software.                                                     */
/*                                                                                                     */
/* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR                          */
/* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,                            */
/* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE                         */
/* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER                              */
/* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,                       */
/* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE                       */
/* SOFTWARE.                                                                                           */
/*-----------------------------------------------------------------------------------------------------*/
#include "RadegastShaders.Depth.fxh"
#include "RadegastShaders.Positional.fxh"
#include "RadegastShaders.Radial.fxh"
#include "RadegastShaders.AspectRatio.fxh"
#include "RadegastShaders.Offsets.fxh"
#include "RadegastShaders.Transforms.fxh"
#include "RadegastShaders.BlendingModes.fxh"

uniform int mode <
    ui_type = "combo";
    ui_label = "Mode";
    ui_items = "Around center\0Out from center\0";
    ui_tooltip = "Selects the mode the distortion should be processed through.";
    ui_category = "Properties";
> = 0;

uniform float angle <
    ui_type = "slider";
    ui_label = "Angle";
    ui_tooltip = "Serves as a multiplier for the phase and amplitude. Also affects the motion of the animation by phase based on whether the value is negative or positive.";
    ui_category = "Properties";
    ui_min = -999.0; 
    ui_max = 999.0; 
    ui_step = 1.0;
> = 180.0;

uniform float period <
    ui_type = "slider";
    ui_type = "Phase";
    ui_label = "Period";
    ui_tooltip = "Adjusts the rate of distortion.";
    ui_category = "Properties";
    ui_min = 0.1; 
    ui_max = 10.0;
> = 0.25;

uniform float amplitude <
    ui_type = "slider";
    ui_label = "Amplitude";
    ui_tooltip = "Increases how extreme the picture twists back and forth.";
    ui_category = "Properties";
    ui_min = -10.0; 
    ui_max = 10.0;
> = 1.0;

uniform float phase <
    ui_type = "slider";
    ui_label = "Phase";
    ui_tooltip = "The offset at which the pixels twist back and forth from the center.";
    ui_category = "Properties";
    ui_min = -5.0; 
    ui_max = 5.0;
> = 0.0;

uniform int animate <
    ui_type = "combo";
    ui_label = "Animate";
    ui_items = "No\0Amplitude\0Phase\0";
    ui_tooltip = "Enable or disable the animation. Animates the zigzag effect by phase or by amplitude.";
    ui_category = "Properties";
> = 0;

uniform float anim_rate <
    source = "timer";
>;
