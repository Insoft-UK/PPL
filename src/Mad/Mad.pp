#pragma ( minify -1 )

#include <prime>
#define COPYRIGHT   "COPYRIGHT 1985 E.C. PUBLICATIONS"
#define END_OF_DATA 999

#define self MAD

#include "data.txt"
def DATA MAD.data;
var LnD:self.line = {0,0,0,0};
var Scl:self.scale = 1.0;

Setup:self::init()
begin
    px::rect(Color.White);
    #include "mad.txt";
    px::blit(SCREEN_CENTRE - 32, SCREEN_MIDDLE - 32, G1);
    px::text::out("PRESS ANY KEY",108,208);
    px::text::out(COPYRIGHT,76,224,1);
end

Read:self::read()
begin
    self.line[1] = self.data[I];
    self.line[2] = self.data[I+1];
    self.line[3] = self.data[I+2];
    self.line[4] = self.data[I+3];
    I+=4;
end

Draw:self::draw()
begin
    px::rect(#00FF00h);
    var C:color = Color.White;
    var FX:x1, FY:y1, LX:x2, LY:y2;

    for I:=1; self.data[I]!=END_OF_DATA; do
        if I==1561 do
            color := #006600h;
        endif;
        self::read();
    
        x1 = SCREEN_CENTRE + self.scale * self.line[1];
        y1 = SCREEN_MIDDLE - self.scale * self.line[2];
        x2 = SCREEN_CENTRE + self.scale * self.line[3];
        y2 = SCREEN_MIDDLE - self.scale * self.line[4];
    
        px::line(x1, y1, x2, y2, color);
        px::line(x1+1, y1, x2+1, y2, color);
    next
    px::text::out("WHAT, ME WORRY?",100,208);
    px::text::out(COPYRIGHT,76,224,1);
end
#undef self

export RUN()
begin
    MAD::init;
    WAIT;
    MAD::draw;
    WAIT;
end
