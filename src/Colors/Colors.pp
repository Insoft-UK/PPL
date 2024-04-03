/*
 Copyright © 2024 Insoft. All rights reserved.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */
 
#pragma ( minify -1 )

#include <prime>
#include <hp>
#include <cspace>

#include "Defines.pp"
#include "Common.pp"

#define self Colors
var self.channel = 0;

var self.h = 0, self.s = 100, self.v = 100;
var self.r = 255, self.g = 0, self.b = 0;
var self.unitType = UT_Decimal;
var self.colorSpace = CS_HSV;

Colors::Setup()
begin
    var n, d:data;
    DIMGROB_P(G9, 320, 240, 0);
    
    hp::clearScreen(Color.Black);
    blit(G9, __SCREEN);
    
    data = {0};
    for n = 0; n < 360; n += 2 do
        data[n / 2 + 1] = R→B(HSV(n, 100, 100), 64, Base.Hex) + BITSL(R→B(HSV(n + 1, 100, 100), 64, Base.Hex), 32);
    next
    px::defineGROB(HUE, 360, 1, data);
    
    data = {0};
    for n = 0; n < 256; n += 2 do
        data[n / 2 + 1] = R→B(RGB(0, 0, 0, 255 - n), 64, Base.Hex) + BITSL(R→B(RGB(0, 0, 0, 255 - (n + 1)), 64, Base.Hex), 32);
    next
    px::defineGROB(BLACK_TO_TRANSPARENT_OVERLAY, 1, 256, data);
    
    data := {0};
    for n = 0; n < 256; n += 2 do
        var rgb = {RGB(255, 255, 255, n), RGB(255, 255, 255, n + 1)};
        data[n / 2 + 1] = R→B(RGB(255, 255, 255, n), 64, Base.Hex) + BITSL(R→B(RGB(255, 255, 255, n + 1), 64, Base.Hex), 32);
    next
    px::defineGROB(TRANSPARENT_TO_WHITE_OVERLAY, 256, 1, data);
end

Colors::DrawMenu()
begin
    /// 0-51, 53-104, (106-157, 159-210), 212-263, 265-319
    rect(G9, 0, 220, 51, 239, #666666:32h);
    rect(G9, 53, 220, 104, 239, #666666:32h);
    rect(G9, 106, 220, 210, 239, #666666:32h);
    rect(G9, 212, 220, 263, 239, #666666:32h);
    rect(G9, 265, 220, 319, 239, #666666:32h);
   
    drawTextCentered("%",25,225,2);
    drawTextCentered("d",78,225,2);
    drawTextCentered("-         HUE         +",158,225,2);
    drawTextCentered("HSV",237,225,2);
    drawTextCentered("HSL",290,225,2);
    
    if self.unitType == UT_Percentage do
        textout("•", G9, 4, 225, 2, C_White);
    else
        textout("•", G9, 57, 225, 2, C_White);
    endif
    
    if self.colorSpace == CS_HSV do
        textout("•", G9, 216, 225, 2, C_White);
    else
        textout("•", G9, 269, 225, 2, C_White);
    endif
end

Colors::DrawHue(h)
begin
    blit(G9, 10, 148, 310, 168, HUE);
    
    X = IP(h / 360 * 300) + 10;
    Y = 148;
    rect(G9, X-3, Y-3, X+2, Y+22, C_Black, C_Clear);
    rect(G9, X-2, Y-2, X+2, Y+21, C_White, C_Clear);
end

Colors::DrawSV(h,s,v)
begin
    rect(G9, 10, 10, 137, 137, HSV(h, 100, 100));
    blit(G9, 10, 10, 138, 138, G4);
    blit(G9, 10, 10, 138, 138, G3);

    X := s / 100 * 127 + 10;
    Y := (1 - v / 100) * 127 + 10;
    rect(G9, X-3, Y-3, X+2, Y+2, C_Black, C_Clear);
    rect(G9, X-2, Y-2, X+1, Y+1, C_White, C_Clear);
end

Colors::Update()
begin
    RECT(G9,#222222:32h);

    [self DrawMenu];
    [self DrawHue:self.h];
    [self DrawSVWithHueOf:self.h saturationOf:self.s brightnesOf:self.v];
    
    /// Color Picked
    ///rect(G9, 154, 10, 309, 41, HSV(self.h, self.s, self.v));
    [px rect: G9 atX: 154 ofY: 10 toX: 309 Y: 42 withColor:HSV(self.h, self.s, self.v)];
    
    var auto:hsl, auto:rgb, auto:cmyk, auto:hex;
    
    rgb = {self.r, self.g, self.b};
    hsl = HSVtoHSL(self.h, self.s, self.v);
    cmyk = RGBtoCMYK(self.r, self.g, self.b);
    hex = "#" + HEX(self.r) + HEX(self.g) + HEX(self.b);
    
    L0 := TEXTSIZE(hex,7);
    TEXTOUT_P(hex,G9,160-L0(1)/2,180,7,C_White);
    
    
    var n, ts, info;
    
    /// RGB Info
    info = {"R:","G:","B:"};
    X = 138;
    Y = 51;
    for n=1; n<=3; n+=1 do
        ts = TEXTSIZE(info[n],3);
        textout(info[n],G9,X+15-ts[1],Y+3,3,C_White);
        rect(G9,X+16,Y,X+55,Y+20,#333333:32h);
        if self.channel == 1 && n == 1 do
            rect(G9,X+54,Y,X+55,Y+20,RGB(255,0,0));
        endif
        if self.channel == 2 && n == 2 do
            rect(G9,X+54,Y,X+55,Y+20,RGB(0,255,0));
        endif
        if self.channel == 3 && n == 3 do
            rect(G9,X+54,Y,X+55,Y+20,RGB(0,0,255));
        endif
        if self.unitType == UT_Decimal do
            textout(rgb[n],G9,X+22,Y+5,2,C_White);
        else
            textout(Int(rgb[n] / 255 * 100)+"%",G9,X+20,Y+5,2,C_White);
        endif
        Y += 24;
    next
    
    /// HSV or HSL Info
    if self.colorSpace == CS_HSV then info = {"H:","S:","V:"}; endif
    if self.colorSpace == CS_HSL then info = {"H:","S:","L:"}; endif
    X += 58;
    Y = 51;
    for n=1; n<=3; n+=1 do
        ts = TEXTSIZE(info[n],3);
        textout(info[n],G9,X+15-ts[1],Y+3,3,C_White);
        rect(G9,X+16,Y,X+55,Y+20,#333333:32h);
        switch self.colorSpace
            case CS_HSV do
                if n == 1 do
                    textout(Int(self.h)+"°",G9,X+20,Y+5,2,C_White);
                endif
                if n == 2 do
                    textout(Int(self.s)+"%",G9,X+20,Y+5,2,C_White);
                endif
                if n == 3 do
                    textout(Int(self.v)+"%",G9,X+20,Y+5,2,C_White);
                endif
            end
            case CS_HSL do
                if n == 1 do
                    textout(Int(hsl[n])+"°",G9,X+20,Y+5,2,C_White);
                else
                    textout(Int(hsl[n])+"%",G9,X+20,Y+5,2,C_White);
                endif
            end
        end
        Y += 24;
    next
    
    /// CMYK Info
    info = {"C:","M:","Y:","K:"};
    X += 58;
    Y = 51;
    for n=1; n<=4; n+=1 do
        ts = TEXTSIZE(info[n],3);
        textout(info[n],G9,X+15-ts[1],Y+3,3,C_White);
        rect(G9,X+16,Y,X+55,Y+20,#333333:32h);
        textout(Int(cmyk[n])+"%",G9,X+20,Y+5,2,C_White);
        Y += 24;
    next
    
   
    blit(__SCREEN, G9);
end

Colors::UpdateRGB()
begin
    var auto:rgb;
    rgb = HSVtoRGB(self.h, self.s, self.v);
    self.r = rgb[1];
    self.g = rgb[2];
    self.b = rgb[3];
end

Colors::DoMenu()
begin
    def eval:(y<220? 0: Int(x / (320/6)+0.025) + 1) menu(x,y);
    
    switch menu(X,Y)
        case 1 do
            self.unitType = UT_Percentage;
        end
            
        case 2 do
            self.unitType = UT_Decimal;
        end
            
        case 3 do
            self.h = floor((self.h - 29) / 30) * 30;
            self::UpdateRGB;
            HP.MouseClr;
        end
            
        case 4 do
            self.h = floor(self.h / 30) * 30 + 30;
            self::UpdateRGB;
            HP.MouseClr;
        end
            
        case 5 do
            self.colorSpace = CS_HSV;
        end
            
        case 6 do
            self.colorSpace = CS_HSL;
        end
    end
end

Colors::AdjRGB(d:delta)
begin
    def eval:Int(MIN(MAX(_c, 0), 255)) ClampChannelValue(_c);
    
    switch self.channel
        case 1 do
            self.r += delta;
            self.r = ClampChannelValue(self.r);
        end
        
        case 2 do
            self.g += delta;
            self.g = ClampChannelValue(self.g);
        end
        
        case 3 do
            self.b += delta;
            self.b = ClampChannelValue(self.b);
        end
    end
    
    // Update HSV values.
    var auto:hsv;
    hsv = RGBtoHSV(self.r, self.g, self.b);
    self.h = hsv[1];
    self.s = hsv[2];
    self.v = hsv[3];
end

Colors::AdjHue(d:delta)
begin
    def eval:Int(MIN(MAX(_v, 0), 360)) ClampHueValue(_v);
    self.h += delta;
    self.h = ClampHueValue(self.h);
    
    self::UpdateRGB;
end

Colors::AdjSaturation(d:delta)
begin
    def eval:Int(MIN(MAX(_v, 0), 100)) ClampValue(_v);
    self.s += delta;
    self.s = ClampValue(self.s);
    
    self::UpdateRGB;
end

Colors::AdjBrightness(d:delta)
begin
    def eval:Int(MIN(MAX(_v, 0), 100)) ClampValue(_v);
    self.v += delta;
    self.v = ClampValue(self.v);
    
    self::UpdateRGB;
end

Colors::Loop()
begin
    def eval:Int(MIN(MAX(_v, 0), 100)) ClampValue(_v);
    def eval:Int(MIN(MAX(_v, 0), 360)) ClampHueValue(_v);
    
    var auto:focus = "";

    do
        self::Update();
        
        struct Event auto:event;
        event = WAIT(-1);
    
        if hp::isKeyPressed(event) do
            focus = "";
            try
                if event.key == KeyCode.Esc do
                    return;
                endif
                
                if event.key == KeyCode.Enter do
                    return HSV(self.h, self.s, self.v);
                endif
                
                if event.key == KeyCode.Minus do
                    if self.channel == 0 do
                        self::AdjHue(-1);
                    else
                        self::AdjRGB(-1);
                    endif
                endif
                
                if event.key == KeyCode.Plus do
                    if self.channel == 0 do
                        self::AdjHue(1);
                    else
                        self::AdjRGB(1);
                    endif
                endif
                
                if event.key == KeyCode.Up do
                    if self.channel == 0 do
                        self::AdjBrightness(1);
                    else
                        self.channel += (self.channel == 1 ? 2 : -1);
                    endif
                endif
                
                if event.key == KeyCode.Down do
                    if self.channel == 0 do
                        self::AdjBrightness(-1);
                    else
                        self.channel += (self.channel == 3 ? -2 : 1);
                    endif
                endif
                
                if event.key == KeyCode.Left && self.channel == 0 do
                    self::AdjSaturation(-1);
                endif
                
                if event.key == KeyCode.Right && self.channel == 0 do
                    self::AdjSaturation(1);
                endif
            catch
            end
            
        endif
        
        if hp::isMouseEvent(event) do
            X = event.x;
            Y = event.y;
            
            self::DoMenu();
            
            switch event.type
                case EventType.MouseDown do
                    if X>=5 && X<315 && Y>=148 && Y<188 do
                        self.h := (X - 5) / 310 * 360;
                        self::UpdateRGB();
                        self.channel = 0;
                        focus = "Hue";
                    endif
                    
                    if X>=5 && X<143 && Y≥5 && Y<143 do
                        self.s := IP((X - 5) / 137 * 100);
                        self.v := IP((1 - (Y - 5) / 137) * 100);
                        self::UpdateRGB();
                        self.channel = 0;
                        focus = "Saturation & Brightness";
                    endif;
                    
                    if X>=138 && X <=193 && Y>=51 && Y<=71 do
                        self.channel = 1;
                    endif
                    
                    if X>=138 && X <=193 && Y>=75 && Y<=95 do
                        self.channel = 2;
                    endif
                    
                    if X>=138 && X <=193 && Y>=99 && Y<=119 do
                        self.channel = 3;
                    endif
                end
                
                case EventType.MouseMove do
                    if focus == "Hue" do
                        self.h = (X - 5) / 310 * 360;
                        self::UpdateRGB();
                    endif
                    
                    if focus == "Saturation & Brightness" do
                        self.s = Int((X - 5) / 137 * 100);
                        self.v = Int((1 - (Y - 5) / 137) * 100);
                        self::UpdateRGB();
                    endif
                end
                
                case EventType.MouseUp do
                    focus = "";
                end
            end
            
            self.h = ClampHueValue(self.h);
            self.s = ClampValue(self.s);
            self.v = ClampValue(self.v);
        endif
    
    loop
end
#undef self

export Colors()
begin
    [Colors Setup];
    [Colors Loop];
end
