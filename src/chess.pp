/*
Chess.
 A chess game implemented on/for the
 HP Prime Graphing Calculator using its
 api and programming language (HP PPL)
 Version 0.98.91.20201128P.
 Copyright © Rafael Pérez 2020.
 rperezrosario@outlook.com.

 The program is structured around the con-
 cept of processing user or intelligent a-
 gent (i.a.) input affecting the game's
 state, and updating the user interface ba-
 sed on said state as the user or i.a. in-
 put loop is consumed by the program. This
 concept is commonly known as the model,
 view, controller (MVC) software design pa-
 ttern.

 The main four (4) program functions are:

 a_chess: Main program/entry point. Calls
          the other main functions, and
          implements and executes the pla-
          yer's and/or i.a.'s input loop.
 a_igst:  Initializes and stores the game's
          current state (model.)
 a_pui:   Prints the game's user interface
          based on the game's current sta-
          te (view.)
 a_ppi:   Processes user or i.a. input and
          affects the game's current state
          accordingly (controller.)

 This program was designed, implemented and
 tested during  the  2020  global  COVID-19
 pandemic in  Brooklyn and  Manhattan, NYC,
 U.S.A. Please remember to  wear your mask!

 Thanks to my  blood and legal family, fri-
 ends, *Tiger Team Alpha*  PR, UK, and  NYC
 (you   know  who   you   are),  workmates,
 bosses/mentors,    recruiters,   teachers,
 professors, and  fellow  students   at Co-
 legio San Antonio,  Colegio San José, Uni-
 versidad   de  Puerto   Rico,  Universidad
 Politécnica, Universidad del  Sagrado  Co-
 razón, and  the University of  Sussex. Big
 thanks to my medical  doctors   and every-
 one  else  who  has  ever believed  in me,
 thus  making this humble piece of work po-
 ssible.  To  the  awe  inspiring  authors,
 scientists, mathematicians, musicians, and
 other thinkers: G. Leibniz, C. Babbage, A.
 Lovelace,  A. Turing,   S. Russell, P.Nor-
 vig,   M. Minsky,  D. Knuth,  the GoF,  T.
 Holland,     I. Asimov,    W. Gibson,   C.
 Alexander, K. Popper,  R. Wagner,   R. Wa-
 ters, L. Saidier,  J. Mercer,  G. Rhys, E.
 Vedder,  G. Cerati,  F. Mercury,  P. Town-
 shend, B. Eno, K. Goodman,  C. Ramone,  D.
 Bowie, P. Macartney,  J. Christ, T.H. Spi-
 rit, and F.W. Nietzsche.

 Thank you Mrs. Larson  and  Mr. Maldonado!
 
 In loving memory of  Mr. Aníbal Rodríguez,
 my  biological  parents  Rafael Pérez  and
 Evelyn Rosario,   and    my   grandparents
 Anselmo Rosario,  Luz Ortiz,  María Pérez,
 and  Herminio Pérez.  May they have  found
 peace   wherever,  whenever  and  whatever
 they've  become  in  this,  or  any  other
 universe(s).

 Disclaimer:   This   software was  written
 using 100%  recycled  electrons, and   not
 that   many   bugs   were  harmed   during
 its  design,  implementation  or  testing.

 a_gst: Game state.
 Copyright © Rafael Pérez 2020.
 rperezrosario@outlook.com.
*/

#define self Chess
#define property var auto:self

// Screen.
EXPORT szf=1.0;           /// Size factor.
EXPORT w=GROBW_P(G0)*szf; /// Screen width.
EXPORT h=GROBH_P(G0)*szf; /// Screen height.
EXPORT wlim=w-1;          /// Screen w. lim.
EXPORT hlim=h-1;          /// Screen h. lim.
/*
 N.b. "1" is subtracted from "wlim" and
 "hlim" due to api Cartesian coordinate in-
 dexes beginning at zero ("0"); Naturally,
 the rightmost pixel x-index is "319" and
 the bottom pixel y-index "239." Also ple-
 ase n.b. that the calculator's api list/
 array indexes begin at one ("1"), *not*
 zero ("0"), as opposed to many contempora-
 ry machine programming languages and apis
 whose array and other iterable data struc-
 ture indexes begin at zero ("0").
*/
EXPORT wmid=(w/2),hmid=(h/2); /// Midpts.
// Game table.
EXPORT sqsz=hlim/8; /// Position square size.
EXPORT psz=sqsz*0.535564853556; /// Pc. size.
EXPORT xorg=wmid-(sqsz*4); /// Table x-origin.
EXPORT xlim=wmid+(sqsz*4); /// Table x-limit.
EXPORT yorg=0; /// Table y-origin.
EXPORT ylim=hlim; /// Table y-limit.
// Colors.
EXPORT tgl=RGB(0,255,0,255); /// T. green l.
EXPORT tgbg=RGB(0,255,0,150); /// T. green b.
EXPORT trl=RGB(255,0,0); /// T. red l.
EXPORT trbg=RGB(255,0,0,150); /// T. red bg.
EXPORT tbl=RGB(0,0,0,225); /// T. black.
EXPORT tybg=RGB(255,255,200); /// T. yellow.
EXPORT wht=RGB(255,255,255); /// White.
EXPORT bla=RGB(0,0,0); /// Black.
// Cursor.
EXPORT selx1=0; /// Selected position x1.
EXPORT sely1=0; /// Selected position y1.
EXPORT prcx1=0; /// Current cursor x1.
EXPORT prcy1=0; /// Current cursor y1.
EXPORT prclc; /// Cursor line color.
EXPORT prcbgc; /// Cursor background.
EXPORT selmod=0; /// Selection mode.
///EXPORT ck=-1; /// Last captured key.
EXPORT hlsx1=0; /// Last move source x1.
EXPORT hlsy1=0; /// Last move source y1.
EXPORT hltx1=0; /// Last move target x1.
EXPORT hlty1=0; /// Last move target y1.
// En passant.
EXPORT aepli=-1; /// Active e.p. left idx.
EXPORT aepri=-1; /// Active e.p. right idx.
EXPORT aepmv=-1; /// Active en passant move.
EXPORT epcx1=-1; /// En passant capture x1.
EXPORT epcy1=-1; /// En passant capture y1.
// Game state.
EXPORT tstate; /// Game table state.
EXPORT tdstate; /// Game table display state.
EXPORT tshcnt=0; /// Game table state h. cnt.
EXPORT tstateh; /// Game table state history.
EXPORT mvcnt=0; /// Move count.
EXPORT mv; /// Moves list.
EXPORT tpscnt=0; /// Test pos. state count.
// Features.
EXPORT ftrset=0; /// Selected feature set.
EXPORT ftrsm=0; /// Feature: Stalemate dtct.
EXPORT ftr75=0; /// Feature: 75 moves dtct.
EXPORT ftr5=0; /// Feature: 5 ocurr. dtct.
EXPORT ftrvm=0; /// Feature: Chk. val. moves.
EXPORT ftrkic=0; /// Feature: Ann. ki. in chk.
// Game type.


property.gameType=0; /// Game type.

def 1 `Human vs Human`;
def 2 `Human vs Black`;
def 3 `Human vs White`;
def 4 `White vs Black`;
def 5 `Quit`;

// AI.
EXPORT aitw=0; /// AI type White.
EXPORT aitb=0; /// AI type Black.
 /// (1) Valid move random.
 /// (2) Step-value search.
EXPORT aisvdw=0; /// SVS depth White.
EXPORT aisvdb=0; /// SVS depth Black.


Chess::SelectGameType()
begin
  CHOOSE(self.gameType,"Select a Game Type",
    "Human vs. Human",
    "Human vs. Black",
    "Human vs. White",
    "White vs. Black",
    "Quit.");

    switch self.gameType
        case `Human vs Black` do
            CHOOSE(aitb,"Select Black AI Type","Valid Move Random","Step-Value Search");
            if aitb==2 do
                CHOOSE(aisvdb,"Select Black SVS Depth","1","2","3","4","5","6","7");
            endif
        end

        case `Human vs White` do
            CHOOSE(aitw,"Select White AI Type","Valid Move Random","Step-Value Search");
            if aitw==2 do
                CHOOSE(aisvdw,"Select White SVS Depth","1","2","3","4","5","6","7");
            endif
        end

        case `White vs Black` do
            CHOOSE(aitw,"Select White AI Type","Valid Move Random","Step-Value Search");
            IF aitw==2 THEN
                CHOOSE(aisvdw,"Select White SVS Depth","1","2","3","4","5","6","7");
            END;
            CHOOSE(aitb,"Select Black AI Type","Valid Move Random","Step-Value Search");
            IF aitb==2 THEN
                CHOOSE(aisvdb,"Select Black SVS Depth","1","2","3","4","5","6","7");
            END;
        end
        default
    end
end
/*
 a_sf: Select features.
 Copyright © Rafael Pérez 2020.
 rperezrosario@outlook.com.
*/
EXPORT a_sf()
BEGIN
  CHOOSE(ftrset,"Feature Selection",
    "All Features","Better Performance",
    "Best Performance","Custom");
  CASE
    IF ftrset==1 THEN /// All features.
      ftrsm:=1; /// On.
      ftr75:=1; /// On.
      ftr5:=1; /// On.
      ftrvm:=1; /// On.
      ftrkic:=1; /// On.
    END;
    IF ftrset==2 THEN /// Better performance.
      ftrsm:=2; /// Off.
      ftr75:=2; /// Off.
      ftr5:=2; /// Off.
      ftrvm:=1; /// On.
      ftrkic:=1; /// On.
    END;
    IF ftrset==3 THEN /// Best performance.
      ftrsm:=2; /// Off.
      ftr75:=2; /// Off.
      ftr5:=2; /// Off.
      ftrvm:=2; /// Off.
      ftrkic:=2; /// Off.
    END;
    IF ftrset==4 THEN /// Custom.
      CHOOSE(ftrsm, "Stalemate Detection",
        "On", "Off");
      CHOOSE(ftr75,"75 Move Detection",
        "On", "Off");
      CHOOSE(ftr5,
        "5 Repeated Occurrence Detection",
        "On", "Off");
      CHOOSE(ftrvm,
        "Require Valid Moves",
        "On", "Off");
      CHOOSE(ftrkic,
        "Annce. Kng. is in Chk. or Mate",
        "On","Off")
    END;
    DEFAULT
  END;
END;
/*
 a_pr: Print rectangle, wrapper for
 RECT_P.
 Copyright © Rafael Pérez 2020.
 rperezrosario@outlook.com.

 X1, y1, x2, y2, line color, fill color.
 */
EXPORT a_pr(X1,Y1,X2,Y2,LC,BGC)
BEGIN
  RECT_P(X1,Y1,X2,Y2,LC,BGC);
END;
/*
 a_pki: Print king.
 Copyright © Rafael Pérez 2020.
 rperezrosario@outlook.com.

 Coordinates, line color, fill color,
 zoom factor.
 */
EXPORT a_pki(X1,Y1,LCOL,BGCOL,Z)
BEGIN
  LOCAL sz=psz*Z; /// Piece size.
  LOCAL dx=(sqsz-sz)/2; /// Left margin.
  LOCAL dy=dx; /// Top margin.
 /// Background square.
  a_pr(X1+dx,Y1+dy,X1+dx+sz,Y1+dy+sz,
    LCOL,BGCOL);
 /// Thin Greek cross.
  a_pr(X1+dx+(sz/2),Y1+dy,
    X1+dx+(sz/2),Y1+dy+sz,LCOL,BGCOL);
  a_pr(X1+dx,Y1+dy+(sz/2),
    X1+dx+sz,Y1+dy+(sz/2),LCOL,BGCOL);
END;
/*
 a_pqn: Print queen.
 Copyright © Rafael Pérez 2020.
 rperezrosario@outlook.com.

 Coordinates, line color, fill color, zoom
 factor.
 */
EXPORT a_pqn(X1,Y1,LCOL,BGCOL,Z)
BEGIN
  LOCAL sz=psz*Z; /// Piece size.
  LOCAL hsz=sz/2; /// Half size.
  LOCAL qsz=sz/4; /// Quarter size.
  LOCAL dx=(sqsz-sz)/2; /// Left margin.
  LOCAL dy=dx; /// Top margin.
 /// Background square.
  a_pr(X1+dx,Y1+dy,X1+sz+dx,Y1+sz+dy,
    LCOL,BGCOL);
 /// Thin Greek cross.
  a_pr(X1+dx+hsz,Y1+dy,X1+dx+hsz,Y1+dy+sz,
    LCOL,BGCOL);
  a_pr(X1+dx,Y1+dy+hsz,X1+dx+sz,Y1+dy+hsz,
    LCOL,BGCOL);
 /// Square top ornament.
  a_pr(X1+dx+qsz,Y1+dy+qsz,
    X1+dx+hsz+qsz,Y1+dy+hsz+qsz,
    LCOL,BGCOL);
END;
/*
 a_pro: Print rook.
 Copyright © Rafael Pérez 2020.
 rperezrosario@outlook.com.

 Coordinates, line color, fill color, zoom
 factor.
 */
EXPORT a_pro(X1,Y1,LCOL,BGCOL,Z)
BEGIN
  LOCAL sz=psz*Z; /// Piece size.
  LOCAL hsz=sz/2; /// Half size.
  LOCAL qsz=sz/4; /// Quarter size.
  LOCAL dx=(sqsz-sz)/2; /// Left margin.
  LOCAL dy=dx; /// Top margin.
 /// Background square.
  a_pr(X1+dx,Y1+dy,X1+sz+dx,Y1+sz+dy,
    LCOL,BGCOL);
 /// Four small corner squares.
  a_pr(X1+dx+1,Y1+dy+1,
    X1+dx+qsz+1,Y1+dy+qsz+1,
    BGCOL,LCOL);
  a_pr(X1+dx+sz-qsz-1,Y1+dy+1,
    X1+dx+sz-1,Y1+dy+qsz+1,
    BGCOL,LCOL);
  a_pr(X1+dx+1,Y1+dy+sz-qsz-1,
    X1+dx+qsz+1,Y1+dy+sz-1,
    BGCOL,LCOL);
  a_pr(X1+dx+sz-qsz-1,Y1+dy+sz-qsz-1,
    X1+dx+sz-1,Y1+dy+sz-1,
    BGCOL,LCOL);
END;
/*
 a_pbs: Print bishop.
 Copyright © Rafael Pérez 2020.
 rperezrosario@outlook.com.

 Coordinates, line color, fill color,
 zoom factor.
 */
EXPORT a_pbs(X1,Y1,LCOL,BGCOL,Z)
BEGIN
  LOCAL sz=psz*Z; /// Piece size.
  LOCAL dx=(sqsz-sz)/2; /// left margin.
  LOCAL dy=dx; /// Top margin.
  LOCAL f=sz/16; /// Size factor.
 /// Background square.
  a_pr(X1+dx,Y1+dy,X1+dx+sz,Y1+dy+sz,
    LCOL,BGCOL);
 /// Christian cross.
  a_pr(X1+dx+(7*f),Y1+dy+(3*f),
    X1+dx+(9*f),Y1+dy+(13*f),
    LCOL,LCOL); /// Post.
  a_pr(X1+dx+(4*f),Y1+dy+(6*f),
    X1+dx+(12*f),Y1+dy+(8*f),
    LCOL,LCOL); /// Crossbar.
END;
/*
 a_pkn: Print knight.
 Copyright © Rafael Pérez 2020.
 rperezrosario@outlook.com.

 Coordinates, line color, fill color,
 zoom factor.
 */
EXPORT a_pkn(X1,Y1,LCOL,BGCOL,Z)
BEGIN
  LOCAL sz=psz*Z; /// Piece size.
  LOCAL hsz=sz/2; /// Half size.
  LOCAL qsz=sz/4; /// Quarter size.
  LOCAL dx=(sqsz-sz)/2; /// Left margin.
  LOCAL dy=dx; /// Top margin.
 /// Background square.
  a_pr(X1+dx,Y1+dy,X1+dx+sz,Y1+dy+sz,
    LCOL,BGCOL);
 /// Square ruler.
  a_pr(X1+dx+1,Y1+dy+1,
    X1+dx+sz-1,Y1+dy+1+qsz,
    BGCOL,LCOL);
  a_pr(X1+dx+sz-qsz-1,Y1+dy+1,
    X1+dx+sz-1,Y1+dy+sz-1,
    BGCOL,LCOL);
END;
/*
 a_ppw: Print pawn.
 Copyright © Rafael Pérez 2020.
 rperezrosario@outlook.com.

 Coordinates, line color, fill color,
 zoom factor.
 */
EXPORT a_ppw(CX,CY,LCOL,BGCOL,Z)
BEGIN
  LOCAL sz=psz*Z; /// Piece size.
  LOCAL hsz=sz/2; /// Half size.
  LOCAL dx=(sqsz-sz)/2; /// Left margin.
  LOCAL dy=dx; /// Top margin.
  LOCAL r1x=sz*0.4375; /// Rad-1 x.
  LOCAL r1y=sz*0.5000; /// Rad-1 y.
  LOCAL r2x=sz*0.2500; /// Rad-2 x.
  LOCAL r2y=sz*0.3125; /// Rad-2 y.
 /// Two concentric ellipses of different di-
 /// ameter. Printing ellipses because the
 /// screen represents them more attractive-
 /// ly than the product of the circle
 /// function overload provided by the api.
  ARC_P(CX+dx+hsz,CY+dy+hsz,{r1x,r1y},0,2*π,
    {LCOL,BGCOL});
  ARC_P(CX+dx+hsz,CY+dy+hsz,{r2x,r2y},0,2*π,
    {LCOL,BGCOL});
END;
/*
 a_gpc: Get piece color from piece name.
 Copyright © Rafael Pérez 2020.
 rperezrosario@outlook.com.

 Piece name.
 */
EXPORT a_gpc(PN)
BEGIN
 /// No piece name, no color.
  IF PN=="" THEN
    RETURN "";
  ELSE
 /// Returns "w" or "b", unless piece name
 /// is corrupt.
    RETURN LEFT(PN,1);
  END;
END;

/*
 a_gctc: Gets the current turn's color.
 Copyright © Rafael Pérez 2020.
 rperezrosario@outlook.com.
*/
EXPORT a_gctc()
BEGIN
  IF mvcnt==0 THEN
 /// First turn.
    RETURN "w"; /// White.
  ELSE /// Posterior turns.
    IF a_gpc(mv(mvcnt,1))=="w" THEN
 /// White moved last.
      RETURN "b"; /// Black.
    ELSE
 /// Black moved last.
      RETURN "w"; /// White.
    END;
  END;
 /// Move list is corrupt.
  RETURN "";
END;

/*
 a_pc: Print cursor.
 Copyright © Rafael Pérez 2020.
 rperezrosario@outlook.com.
*/
EXPORT a_pc()
BEGIN
 /// Print rotated cursor.
  IF ((self.gameType==2 OR self.gameType==4) AND a_gctc()=="b")
    OR (self.gameType==3 AND a_gctc()=="w") THEN
    a_pr(wmid-((prcx1+sqsz)-wmid),
    hmid-((prcy1+sqsz)-hmid)-1,
    wmid-((prcx1+sqsz)-wmid)+sqsz,
    hmid-((prcy1+sqsz)-hmid)-1+sqsz,
    prclc,prcbgc);
  ELSE
 /// Print cursor.
    a_pr(prcx1,prcy1,prcx1+sqsz,prcy1+sqsz,
      prclc,prcbgc);
  END;
 /// If piece-selected mode.
  IF selmod==1 THEN
 /// Print rotated selected mode overlay.
    IF ((self.gameType==2 OR self.gameType==4) AND a_gctc()=="b")
      OR (self.gameType==3 AND a_gctc()=="w") THEN
      a_pr(wmid-((selx1+sqsz)-wmid),
        hmid-((sely1+sqsz)-hmid)-1,
        wmid-((selx1+sqsz)-wmid)+sqsz,
        hmid-((sely1+sqsz)-hmid)-1+sqsz,
        prclc,prcbgc);
    ELSE
 /// Print selected mode overlay.
      a_pr(selx1,sely1,selx1+sqsz,sely1+sqsz,
        prclc,prcbgc);
    END;
  END;
END;
/*
 a_pgp: Print game pieces.
 Copyright © Rafael Pérez 2020.
 rperezrosario@outlook.com.
*/
EXPORT a_pgp()
BEGIN
 /// Black piece colors.
  LOCAL bcl=RGB(215,215,215),
    bcbg=RGB(40,40,40);
 /// White piece colors.
  LOCAL wcl=RGB(40,40,40),
    wcbg=RGB(215,215,215);
 /// Print game pieces using game state
 /// display information.
  FOR I FROM 1 TO 64 DO
    CASE
 /// Black pawns.
      IF LEFT(tdstate(I,3),3)=="bpw" THEN
        a_ppw(tdstate(I,1),tdstate(I,2),
          bcl,bcbg,1.0);
      END;
 /// White pawns.
      IF LEFT(tdstate(I,3),3)=="wpw" THEN
        a_ppw(tdstate(I,1),tdstate(I,2),
          wcl,wcbg,1.0);
      END;
 /// Black king.
      IF tdstate(I,3)=="bki" THEN
        a_pki(tdstate(I,1),tdstate(I,2),
          bcl,bcbg,1.0);
      END;
 /// White king.
      IF tdstate(I,3)=="wki" THEN
        a_pki(tdstate(I,1),tdstate(I,2),
          wcl,wcbg,1.0);
      END;
 /// Black queen.
      IF tdstate(I,3)=="bqn" THEN
        a_pqn(tdstate(I,1),tdstate(I,2),
          bcl,bcbg,1.0);
      END;
 /// White queen.
      IF tdstate(I,3)=="wqn" THEN
        a_pqn(tdstate(I,1),tdstate(I,2),
          wcl,wcbg,1.0);
      END;
 /// Black rooks.
      IF LEFT(tdstate(I,3),3)=="bro" THEN
        a_pro(tdstate(I,1),tdstate(I,2),
          bcl,bcbg,1.0);
      END;
 /// White rooks.
      IF LEFT(tdstate(I,3),3)=="wro" THEN
        a_pro(tdstate(I,1),tdstate(I,2),
          wcl,wcbg,1.0);
      END;
 /// Black bishops.
      IF LEFT(tdstate(I,3),3)=="bbs" THEN
        a_pbs(tdstate(I,1),tdstate(I,2),
          bcl,bcbg,1.0);
      END;
 /// White bishops.
      IF LEFT(tdstate(I,3),3)=="wbs" THEN
        a_pbs(tdstate(I,1),tdstate(I,2),
          wcl,wcbg,1.0);
      END;
 /// Black knights.
      IF LEFT(tdstate(I,3),3)=="bkn" THEN
        a_pkn(tdstate(I,1),tdstate(I,2),
          bcl,bcbg,1.0);
      END;
 /// White knights.
      IF LEFT(tdstate(I,3),3)=="wkn" THEN
        a_pkn(tdstate(I,1),tdstate(I,2),
          wcl,wcbg,1.0);
      END;
      DEFAULT
    END;
  END;
END;
/*
 a_pcp: Print captured pieces.
 Copyright © Rafael Pérez 2020.
 rperezrosario@outlook.com.
*/
EXPORT a_pcp()
BEGIN
  LOCAL cp={""}; /// Captured pieces.
  LOCAL cpcnt=0; /// Captured piece count.
  LOCAL z=0.50; /// Miniature zoom factor.
  LOCAL ccol=1; /// Current column.
  LOCAL crow=1; /// Current row.
  LOCAL cx=0; /// Current x.
  LOCAL cy=0; /// Current y.
  LOCAL bcl=RGB(215,215,215); /// Black line.
  LOCAL bcbg=RGB(40,40,40); /// Black bg.
  LOCAL wcl=RGB(40,40,40); /// White line.
  LOCAL wcbg=RGB(215,215,215); /// White bg.
 /// Add captured pieces to a list.
  FOR I FROM 1 TO mvcnt DO /// Moves list.
    IF mv(I,4)≠"" THEN /// Move is a capture.
      cpcnt:=cpcnt+1; /// Increment counter.
      cp(cpcnt):=mv(I,4); /// Captured piece.
    END;
  END;
 /// Print captured black piece miniatures.
  FOR I FROM 1 TO cpcnt DO /// Captures lst.
    IF LEFT(cp(I),1)=="b" THEN /// Black pc.
      cy:=yorg+(crow*sqsz)-sqsz; /// Set y.
      IF ccol==1 THEN /// First column.
        cx:=xorg-((sqsz*z)*3); /// Set x.
        ccol:=2; /// Move to second column.
      ELSE /// Second column.
        cx:=xorg-((sqsz*z)*2); /// Set x.
        ccol:=1; /// Move back to first col.
        crow:=crow+1; /// Move to next row.
      END;
      CASE
        IF INSTRING(cp(I),"pw")>0 THEN
          a_ppw(cx,cy,bcl,bcbg,z);
        END; /// Print pawn miniature.
        IF INSTRING(cp(I),"ro")>0 THEN
          a_pro(cx,cy,bcl,bcbg,z);
        END; /// Print rook miniature.
        IF INSTRING(cp(I),"kn")>0 THEN
          a_pkn(cx,cy,bcl,bcbg,z);
        END; /// Print knight miniature.
        IF INSTRING(cp(I),"bs")>0 THEN
          a_pbs(cx,cy,bcl,bcbg,z);
        END; /// Print bishop miniature.
        IF cp(I)=="bqn" THEN
          a_pqn(cx,cy,bcl,bcbg,z);
        END; /// Print queen miniature.
        IF cp(I)=="bki" THEN
          a_pki(cx,cy,bcl,bcbg,z);
        END; /// Print king miniature.
        DEFAULT
      END;
    END;
  END;
 /// Print captured white piece miniatures
  crow:=1; /// Reinitialize current row.
  ccol:=1; /// Reinitialize current column.
  FOR I FROM 1 TO cpcnt DO /// Captures lst.
    IF LEFT(cp(I),1)=="w" THEN /// White pc.
      cy:=yorg+(crow*sqsz)-sqsz; /// Set y.
      IF ccol==1 THEN /// First column.
        cx:=xlim; /// Set x.
        ccol:=2; /// Move to second column.
      ELSE /// Second column.
        cx:=xlim+(sqsz*z); /// Set x.
        ccol:=1; /// Move back to first col.
        crow:=crow+1; /// Move to next row.
      END;
      CASE
        IF INSTRING(cp(I),"pw")>0 THEN
          a_ppw(cx,cy,wcl,wcbg,z);
        END; /// Print pawn miniature.
        IF INSTRING(cp(I),"ro")>0 THEN
          a_pro(cx,cy,wcl,wcbg,z);
        END; /// Print rook miniature.
        IF INSTRING(cp(I),"kn")>0 THEN
          a_pkn(cx,cy,wcl,wcbg,z);
        END; /// Print knight miniature.
        IF INSTRING(cp(I),"bs")>0 THEN
          a_pbs(cx,cy,wcl,wcbg,z);
        END; /// Print bishop miniature.
        IF cp(I)=="wqn" THEN
          a_pqn(cx,cy,wcl,wcbg,z);
        END; /// Print queen miniature.
        IF cp(I)=="wki" THEN
          a_pki(cx,cy,wcl,wcbg,z);
        END; /// Print king miniature.
        DEFAULT
      END;
    END;
  END;
END;

/*
 a_pvpm: Print valid piece moves.
 Copyright © Rafael Pérez 2020.
 rperezrosario@outlook.com.
*/
EXPORT a_pvpm()
BEGIN
 /// If piece-selected mode.
  IF selmod==1 THEN
 /// Iterate over current game table state.
    FOR I FROM 1 TO 64 DO
 /// If it is a currently valid move.
      IF tstate(I,5) THEN
        IF ((self.gameType==2 OR self.gameType==4) AND
          a_gctc()=="b") OR
          (self.gameType==3 AND a_gctc()=="w") THEN
 /// Print rotated valid piece move
 /// marker.
          a_pr(wmid-
            ((tstate(I,1)+sqsz)-wmid),
            hmid-((tstate(I,2)+sqsz)-hmid)-1,
            wmid-((tstate(I,1)+sqsz)-wmid)
            +sqsz,hmid-((tstate(I,2)+sqsz)-
            hmid)-1+sqsz,tgl,tgbg);
        ELSE
 /// Print valid piece move marker.
          a_pr(tstate(I,1),tstate(I,2),
            tstate(I,1)+sqsz,
            tstate(I,2)+sqsz,tgl,tgbg);
        END;
      END;
    END;
  END;
END;
/*
 a_plmhl: Print last move highlight.
 Copyright © Rafael Pérez 2020.
 rperezrosario@outlook.com.
*/
EXPORT a_plmhl()
BEGIN
 /// If there's at least one move.
  IF mvcnt>0 THEN
 /// Print last move source highlight.
    a_pr(hlsx1,hlsy1,hlsx1+sqsz,hlsy1+sqsz,
      tbl,tybg);
 /// Print last move target highlight.
    a_pr(hltx1,hlty1,hltx1+sqsz,hlty1+sqsz,
      tbl,tybg);
  END;
END;
/*
 a_pgt: Print game table.
 Copyright © Rafael Pérez 2020.
 rperezrosario@outlook.com.
*/
EXPORT a_pgt()
BEGIN
 /// Temporary color holder.
  LOCAL tlcol;
  LOCAL tbgcol;
 /// Iterate over the game table state.
  FOR I FROM 1 TO 64 DO
    IF tstate(I,4)=="w" THEN /// White.
      tlcol:=wht;
      tbgcol:=wht;
    ELSE /// Black.
      tlcol:=wht;
      tbgcol:=bla;
    END;
 /// Print the position square.
    a_pr(tstate(I,1),tstate(I,2),
      tstate(I,1)+sqsz,tstate(I,2)+sqsz,
      tlcol,tbgcol);
  END;
END;
/*
 a_pui: Print user interface based on
 current game state.
 Copyright © Rafael Pérez 2020.
 rperezrosario@outlook.com.
*/
EXPORT a_pui()
BEGIN
  RECT_P(); /// Clear screen.

  a_pgt(); /// Print game table.
  a_plmhl(); /// Print last move highlight.
  a_pgp(); /// Print game pieces.
  a_pc(); /// Print cursor.
  a_pvpm(); /// Print valid piece moves.
  a_pcp(); /// Print captured pieces.
END;
/*
 a_gitsth: Get initial table state history.
 Copyright © Rafael Pérez 2020.
 rperezrosario@outlook.com.
*/
EXPORT a_gitsth(TSTATE)
BEGIN
  tshcnt:=1;
  RETURN {TSTATE};
END;
/*
 a_gitst: Get initial table state.
 Copyright © Rafael Pérez 2020.
 rperezrosario@outlook.com.
*/
EXPORT a_gitst()
BEGIN
 /// Position x1, position y1, piece name,
 /// position color, move to position is
 /// currently allowed.
  RETURN {
  {xorg,yorg,"bro1","w",false},
    {xorg+sqsz,yorg,"bkn1","b",false},
    {xorg+(sqsz*2),yorg,"bbs1","w",false},
    {xorg+(sqsz*3),yorg,"bqn","b",false},
    {xorg+(sqsz*4),yorg,"bki","w",false},
    {xorg+(sqsz*5),yorg,"bbs2","b",false},
    {xorg+(sqsz*6),yorg,"bkn2","w",false},
    {xorg+(sqsz*7),yorg,"bro2","b",false},
  {xorg,yorg+sqsz,"bpw1","b",false},
    {xorg+sqsz,yorg+sqsz,"bpw2","w",false},
    {xorg+(sqsz*2),yorg+sqsz,"bpw3","b",
      false},
    {xorg+(sqsz*3),yorg+sqsz,"bpw4","w",
      false},
    {xorg+(sqsz*4),yorg+sqsz,"bpw5","b",
      false},
    {xorg+(sqsz*5),yorg+sqsz,"bpw6","w",
      false},
    {xorg+(sqsz*6),yorg+sqsz,"bpw7","b",
      false},
    {xorg+(sqsz*7),yorg+sqsz,"bpw8","w",
      false},
  {xorg,yorg+(sqsz*2),"","w",false},
    {xorg+sqsz,yorg+(sqsz*2),"","b",false},
    {xorg+(sqsz*2),yorg+(sqsz*2),"","w",
      false},
    {xorg+(sqsz*3),yorg+(sqsz*2),"","b",
      false},
    {xorg+(sqsz*4),yorg+(sqsz*2),"","w",
      false},
    {xorg+(sqsz*5),yorg+(sqsz*2),"","b",
      false},
    {xorg+(sqsz*6),yorg+(sqsz*2),"","w",
      false},
    {xorg+(sqsz*7),yorg+(sqsz*2),"","b",
      false},
  {xorg,yorg+(sqsz*3),"","b",false},
    {xorg+sqsz,yorg+(sqsz*3),"","w",false},
    {xorg+(sqsz*2),yorg+(sqsz*3),"","b",
      false},
    {xorg+(sqsz*3),yorg+(sqsz*3),"","w",
      false},
    {xorg+(sqsz*4),yorg+(sqsz*3),"","b",
      false},
    {xorg+(sqsz*5),yorg+(sqsz*3),"","w",
      false},
    {xorg+(sqsz*6),yorg+(sqsz*3),"","b",
      false},
    {xorg+(sqsz*7),yorg+(sqsz*3),"","w",
      false},
  {xorg,yorg+(sqsz*4),"","w",false},
    {xorg+sqsz,yorg+(sqsz*4),"","b",false},
    {xorg+(sqsz*2),yorg+(sqsz*4),"","w",
      false},
    {xorg+(sqsz*3),yorg+(sqsz*4),"","b",
      false},
    {xorg+(sqsz*4),yorg+(sqsz*4),"","w",
      false},
    {xorg+(sqsz*5),yorg+(sqsz*4),"","b",
      false},
    {xorg+(sqsz*6),yorg+(sqsz*4),"","w",
      false},
    {xorg+(sqsz*7),yorg+(sqsz*4),"","b",
      false},
  {xorg,yorg+(sqsz*5),"","b",false},
    {xorg+sqsz,yorg+(sqsz*5),"","w",false},
    {xorg+(sqsz*2),yorg+(sqsz*5),"","b",
      false},
    {xorg+(sqsz*3),yorg+(sqsz*5),"","w",
      false},
    {xorg+(sqsz*4),yorg+(sqsz*5),"","b",
      false},
    {xorg+(sqsz*5),yorg+(sqsz*5),"","w",
      false},
    {xorg+(sqsz*6),yorg+(sqsz*5),"","b",
      false},
    {xorg+(sqsz*7),yorg+(sqsz*5),"","w",
      false},
  {xorg,yorg+(sqsz*6),"wpw1","w",false},
    {xorg+sqsz,yorg+(sqsz*6),"wpw2","b",
      false},
    {xorg+(sqsz*2),yorg+(sqsz*6),"wpw3","w",
      false},
    {xorg+(sqsz*3),yorg+(sqsz*6),"wpw4","b",
      false},
    {xorg+(sqsz*4),yorg+(sqsz*6),"wpw5","w",
      false},
    {xorg+(sqsz*5),yorg+(sqsz*6),"wpw6","b",
      false},
    {xorg+(sqsz*6),yorg+(sqsz*6),"wpw7","w",
      false},
    {xorg+(sqsz*7),yorg+(sqsz*6),"wpw8","b",
      false},
  {xorg,yorg+(sqsz*7),"wro1","b",false},
    {xorg+sqsz,yorg+(sqsz*7),"wkn1","w",
      false},
    {xorg+(sqsz*2),yorg+(sqsz*7),"wbs1","b",
      false},
    {xorg+(sqsz*3),yorg+(sqsz*7),"wqn","w",
      false},
    {xorg+(sqsz*4),yorg+(sqsz*7),"wki","b",
      false},
    {xorg+(sqsz*5),yorg+(sqsz*7),"wbs2","w",
      false},
    {xorg+(sqsz*6),yorg+(sqsz*7),"wkn2","b",
      false},
    {xorg+(sqsz*7),yorg+(sqsz*7),"wro2","w",
      false}
  };
END;

// a_gimv: Get initialized move list.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

EXPORT a_gimv()
BEGIN
  mvcnt:=0; /// Set counter to zero.
 /// Piece name, source position index, tar-
 /// get position index, captured piece name
 /// (if any, else "".)
  RETURN {{"",0,0,""}}; /// Empty move list.
END;

// a_gtstr: Get table state, rotated.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

EXPORT a_gtstr(ST)
BEGIN
 /// Upper piece trade index.
  LOCAL tidx=64;
 /// Temporary piece name.
  LOCAL tpn;
 /// Rotate.
  FOR I FROM 1 TO 32 DO
 /// Store temporary low-piece name.
    tpn:=ST(I,3);
 /// Rotate piece names.
 /// High to low.
    ST(I,3):=ST(tidx,3);
 /// Low to high.
    ST(tidx,3):=tpn;
 /// Decrease upper trade index.
    tidx:=tidx-1;
  END;
 /// Return rotated table state.
  RETURN ST;
END;

// a_igst: Initialize game state.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

EXPORT a_igst()
BEGIN
  AAngle:=1; /// Set ∡ to π-rad.
  mv:=a_gimv(); /// Init. moves list.
  tstate:=a_gitst(); /// Init. table state.
  tdstate:=a_gitst(); /// Init. t. disp. st.
  IF self.gameType==3 THEN /// Human vs. White.
    tdstate:=a_gtstr(tdstate);
  END;
  tstateh:=
    a_gitsth(tstate); /// Init. t. state h.
  selmod:=0; /// Selection mode.
  prcx1:=wmid; /// Init. cursor x1.
  prcy1:=hlim-(sqsz*2); /// Init. cursor y1.
  prclc:=tgl; /// Cursor line color.
  prcbgc:=tgbg; /// Cursor background.
END;

// a_gsi: Get state index from coordinates.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Position coordinates.
EXPORT a_gsi(X1,Y1)
BEGIN
 /// Iterate over game table state.
  FOR I FROM 1 TO 64 DO
 /// If coordinates found.
    IF tstate(I,1)==X1 AND
      tstate(I,2)==Y1 THEN
 /// Return corresponding state index.
      RETURN I;
    END;
  END;
 /// Coordinates do not correspond to a
 /// game table state index.
  RETURN 0;
END;

// a_gpn: Get piece name from coordinates.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Piece coordinates.
EXPORT a_gpn(X1,Y1)
BEGIN
 /// Piece position index.
  LOCAL idx=a_gsi(X1,Y1);
  IF idx>0 THEN
 /// Piece name.
    RETURN tstate(idx,3);
  ELSE
 /// Position index not found.
    RETURN "";
  END;
END;

// a_gps: Get piece position state from
// piece name.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Piece name.
EXPORT a_gps(PN)
BEGIN
 /// Iterate over game table state.
  FOR I FROM 1 TO 64 DO
 /// If name found.
    IF tstate(I,3)==PN THEN
 /// Return corresponding position state.
      RETURN tstate(I);
    END;
  END;
 /// Piece not found, return empty position
 /// state.
  RETURN {0,0,"","",false};
END;

// a_ispw: Is piece in position a pawn.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Position coordinates.
EXPORT a_ispw(PX1,PY1)
BEGIN
 /// Is piece in position a pawn?
  RETURN INSTRING(
    tstate(a_gsi(PX1,PY1),3),"pw")>0;
END;

// a_iskn: Is piece in position a knight.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Position coordinates.
EXPORT a_iskn(PX1,PY1)
BEGIN
 /// Is piece in the specfied position a
 /// knight?
  RETURN INSTRING(
    tstate(a_gsi(PX1,PY1),3),"kn")>0;
END;

// a_isbs: Is piece in position a bishop.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Position coordinates.
EXPORT a_isbs(PX1,PY1)
BEGIN
 /// Is it a bishop?
  RETURN INSTRING(
    tstate(a_gsi(PX1,PY1),3),"bs")>0;
END;

// a_isbro: Is a black rook.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Piece coordinates.
EXPORT a_isbro(X1,Y1)
BEGIN
 /// Piece name.
  LOCAL pn=a_gpn(X1,Y1);
  IF pn=="" THEN
 /// It is not a black rook.
    RETURN false;
  ELSE
    IF LEFT(pn,3)=="bro" THEN
 /// It's a black rook.
      RETURN true;
    END;
 /// It's not a black rook.
    RETURN false;
  END;
END;

// a_iswro: Is a white rook.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Coordinates.
EXPORT a_iswro(X1,Y1)
BEGIN
 /// Piece name.
  LOCAL pn=a_gpn(X1,Y1);
 /// If piece name is blank.
  IF pn=="" THEN
 /// It's not a white rook.
    RETURN false;
  ELSE
    IF LEFT(pn,3)=="wro" THEN
 /// It's a white rook.
      RETURN true;
    END;
 /// It's not a white rook.
    RETURN false;
  END;
END;

// a_isoro: Is own rook.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Own color, test position coordinates.
EXPORT a_isoro(COL,PX1,PY1)
BEGIN
  IF COL≠"" THEN
 /// Is own color black?
    IF COL=="b" THEN
 /// Is piece in test position a black
 /// rook?
      RETURN a_isbro(PX1,PY1);
    ELSE
 /// Is own color white?
      IF COL=="w" THEN
 /// Is piece in test position a white
 /// rook?
        RETURN a_iswro(PX1,PY1);
      END;
    END;
  END;
 /// It's not one of the player's own rooks.
  RETURN false;
END;

// a_isbqn: Is the black queen.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Piece coordinates.
EXPORT a_isbqn(X1,Y1)
BEGIN
 /// Piece name.
  LOCAL pn=a_gpn(X1,Y1);
  IF pn=="" THEN
 /// Not the black queen.
    RETURN false;
  ELSE
    IF pn=="bqn" THEN
 /// It's the black queen.
      RETURN true;
    END;
 /// It's not the black queen.
    RETURN false;
  END;
END;

// a_iswqn: Is the white queen.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Coordinates.
EXPORT a_iswqn(X1,Y1)
BEGIN
 /// Piece name.
  LOCAL pn=a_gpn(X1,Y1);
 /// If piece name is blank.
  IF pn=="" THEN
 /// It's not the white queen.
    RETURN false;
  ELSE
    IF pn=="wqn" THEN
 /// It's the white queen.
      RETURN true;
    END;
 /// It's not the white queen.
    RETURN false;
  END;
END;

// a_isoqn: Is own queen.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Own color, test position coordinates.
EXPORT a_isoqn(COL,PX1,PY1)
BEGIN
  IF COL≠"" THEN
 /// Is own color black?
    IF COL=="b" THEN
 /// Is piece in test position the black
 /// queen?
      RETURN a_isbqn(PX1,PY1);
    ELSE
 /// Is own color white?
      IF COL=="w" THEN
 /// Is piece in test position the whi-
 /// te queen?
        RETURN a_iswqn(PX1,PY1);
      END;
    END;
  END;
 /// Piece in test position is not own co-
 /// lor's queen.
  RETURN false;
END;

// a_iswki: Is the white king.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Piece name.
EXPORT a_iswki(PN)
BEGIN
 /// Is it the white king?
  RETURN PN=="wki";
END;

// a_isbki: Is the black king.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Piece name.
EXPORT a_isbki(PN)
BEGIN
 /// Is it the black king?
  RETURN PN=="bki";
END;

// a_isoki: Is own king.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Own color, test position coordinates.
EXPORT a_isoki(COL,PX1,PY1)
BEGIN
  IF COL≠"" THEN
 /// Is own color black?
    IF COL=="b" THEN
 /// Is piece in test position the black
 /// king?
      RETURN a_isbki(a_gpn(PX1,PY1));
    ELSE
 /// Is own color white?
      IF COL=="w" THEN
 /// Is piece in test position the whi-
 /// te king?
        RETURN a_iswki(a_gpn(PX1,PY1));
      END;
    END;
  END;
 /// Piece in test position is not own co-
 /// lor's king.
  RETURN false;
END;

// a_isopki: Is opposing king.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Own color, test piece coordinates.
EXPORT a_isopki(COL,PX1,PY1)
BEGIN
  IF COL≠"" THEN
 /// Is own color black?
    IF COL=="b" THEN
 /// Is the white king in test position?
      RETURN a_iswki(a_gpn(PX1,PY1));
    ELSE
 /// Is own color white?
      IF COL=="w" THEN
 /// Is the black king in test positi-
 /// on?
        RETURN a_isbki(a_gpn(PX1,PY1));
      END;
    END;
  END;
 /// It's not the opposing king.
  RETURN false;
END;

// a_isw: Is a white piece.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Position coordinates.
EXPORT a_isw(X1,Y1)
BEGIN
 /// Piece name.
  LOCAL pn=a_gpn(X1,Y1);
 /// If position is empty, return false.
  IF pn=="" THEN RETURN false; END;
 /// Is piece white?
  RETURN a_gpc(pn)=="w";
END;

// a_isb: Is a black piece.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Piece coordinates.
EXPORT a_isb(X1,Y1)
BEGIN
 /// Piece name.
  LOCAL pn=a_gpn(X1,Y1);
  IF pn=="" THEN
 /// It's not a black piece.
    RETURN false;
  END;
 /// Is it a black piece?
  RETURN a_gpc(pn)=="b";
END;

// a_isop: Is opponent player piece.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Own color, test position coordinates.
EXPORT a_isop(COL,TX1,TY1)
BEGIN
 /// Is own color (provided) the opposite of
 /// provided test position piece's color?
  RETURN (COL=="w" AND a_isb(TX1,TY1)) OR
    (COL=="b" AND a_isw(TX1,TY1));
END;

// a_isro: Is piece in position a rook.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Position coordinates.
EXPORT a_isro(PX1,PY1)
BEGIN
 /// Is it a rook?
  RETURN INSTRING(
    tstate(a_gsi(PX1,PY1),3),"ro")>0;
END;

// a_ise: Is an empty position.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Position coordinates.
EXPORT a_ise(X1,Y1)
BEGIN
  LOCAL si=a_gsi(X1,Y1); /// State index.
  IF si>0 THEN /// Valid index.
 /// Is position empty?
    RETURN tstate(si,3)=="";
  END;
 /// Invalid index, default to true.
  RETURN true;
END;

// a_isbpw: Is a black pawn.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Piece coordinates.
EXPORT a_isbpw(X1,Y1)
BEGIN
 /// Piece name.
  LOCAL pn=a_gpn(X1,Y1);
  IF pn=="" THEN
 /// It's not a black pawn.
    RETURN false;
  ELSE
    IF LEFT(pn,3)=="bpw" THEN
 /// It's a black pawn.
      RETURN true;
    END;
 /// It's not a black pawn.
    RETURN false;
  END;
END;

// a_iswpw: Is a white pawn.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Position coordinates.
EXPORT a_iswpw(X1,Y1)
BEGIN
 /// Piece name.
  LOCAL pn=a_gpn(X1,Y1);
 /// If piece name is blank.
  IF pn=="" THEN
 /// It's not a white pawn.
    RETURN false;
  ELSE
    IF LEFT(pn,3)=="wpw" THEN
 /// It's a white pawn.
      RETURN true;
    END;
 /// It's not a white pawn.
    RETURN false;
  END;
END;

// a_isoppw: Is an opposing pawn.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Own color, piece coordinates.
EXPORT a_isoppw(COL,PX1,PY1)
BEGIN
  IF COL≠"" THEN
    IF COL=="b" THEN /// Black.
 /// Is the specified piece a white pawn?
      RETURN a_iswpw(PX1,PY1);
    ELSE
      IF COL=="w" THEN /// White.
 /// Is the specified piece a black
 /// pawn?
        RETURN a_isbpw(PX1,PY1);
      END;
    END;
  END;
 /// It's not an opposing pawn.
  RETURN false;
END;

// a_isopkn: Is opposing knight.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Own color, test position coordinates.
EXPORT a_isopkn(COL,PX1,PY1)
BEGIN
  IF COL≠"" THEN
 /// Is piece in test position an opposing
 /// knight?
    RETURN a_iskn(PX1,PY1) AND
      a_isop(COL,PX1,PY1);
  END;
 /// It's not an opposing knight.
  RETURN false;
END;

// a_isukna: Is position under opposing
// knight attack.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Own color, position coordinates.
EXPORT a_isukna(COL,X1,Y1)
BEGIN
 /// Top, left.
 /// Is opposing knight in position?
  IF a_isopkn(COL,X1-sqsz,Y1-(sqsz*2)) THEN
    RETURN true; /// Position is under attack.
  END;
 /// Top, right.
 /// Is opposing knight in position?
  IF a_isopkn(COL,X1+sqsz,Y1-(sqsz*2)) THEN
    RETURN true; /// Position is under attack.
  END;
 /// Right, top.
 /// Is opposing knight in position?
  IF a_isopkn(COL,X1+(sqsz*2),Y1-sqsz) THEN
    RETURN true; /// Position is under attack.
  END;
 /// Right, bottom.
 /// Is opposing knight in position?
  IF a_isopkn(COL,X1+(sqsz*2),Y1+sqsz) THEN
    RETURN true; /// Position is under attack.
  END;
 /// Bottom, left.
 /// Is opposing knight in position?
  IF a_isopkn(COL,X1-sqsz,Y1+(sqsz*2)) THEN
    RETURN true; /// Position is under attack.
  END;
 /// Bottom, right.
 /// Is opposing knight in position?
  IF a_isopkn(COL,X1+sqsz,Y1+(sqsz*2)) THEN
    RETURN true; /// Position is under attack.
  END;
 /// Left, top.
 /// Is opposing knight in position?
  IF a_isopkn(COL,X1-(sqsz*2),Y1-sqsz) THEN
    RETURN true; /// Position is under attack.
  END;
 /// Left, bottom.
 /// Is opposing knight in position?
  IF a_isopkn(COL,X1-(sqsz*2),Y1+sqsz) THEN
    RETURN true; /// Position is under attack.
  END;
 /// Position is not under knight attack.
  RETURN false;
END;

// a_isqn: Is piece in position a queen.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Position coordinates.
EXPORT a_isqn(PX1,PY1)
BEGIN
 /// Is it a queen?
  RETURN INSTRING(
    tstate(a_gsi(PX1,PY1),3),"qn")>0;
END;

// a_iskicoord: Is piece in position a king.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Position coordinates.
EXPORT a_iskicoord(PX1,PY1)
BEGIN
 /// Is it a king?
  RETURN INSTRING(
    tstate(a_gsi(PX1,PY1),3),"ki")>0;
END;

// a_isotlos: Is opponent threat in "line of
// sight."
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Own color, own x1, own y1, direction,
// valid move evaluation.
EXPORT a_isotlos(COL,OX1,OY1,DIR,VME)
BEGIN
 /// Initialize y1.
  LOCAL y1=0;
  CASE
    IF DIR=="u" THEN /// Check  Up.
 /// From origin to table top.
      FOR Y1 FROM OY1-sqsz DOWNTO yorg
        STEP sqsz DO
 /// If a pawn, knight, bishop, own
 /// rook, own queen, own king, or non-
 /// adjacent opponent king is found.
        IF a_ispw(OX1,Y1) OR a_iskn(OX1,Y1)
          OR a_isbs(OX1,Y1)
          OR a_isoro(COL,OX1,Y1)
          OR a_isoqn(COL,OX1,Y1)
          OR a_isoki(COL,OX1,Y1)
          OR (Y1<OY1-sqsz AND
          a_isopki(COL,OX1,Y1)) THEN
 /// No threat in "line of sight"
 /// found.
          BREAK;
        ELSE
 /// If any other type of opponent is
 /// found.
          IF a_isop(COL,OX1,Y1) THEN
 /// Threat found in "line of
 /// sight."
            RETURN true;
          END;
        END;
      END;
 /// No threat in "line of sight" found.
      RETURN false;
    END;
    IF DIR=="ur" THEN /// Check up, right.
      y1:=OY1-sqsz; /// Reset y1.
 /// From origin to table right/top.
      FOR X1 FROM OX1+sqsz TO xlim-sqsz
        STEP sqsz DO
        IF y1<yorg THEN BREAK; END;
 /// If the position is adjacent to the
 /// origin, contains an opponent pie-
 /// ce, and is a pawn, bishop, queen
 /// or king.
        IF X1==OX1+sqsz AND
          a_isop(COL,X1,y1) AND
          (a_ispw(X1,y1) OR
          a_isbs(X1,y1) OR
          a_isqn(X1,y1) OR
          a_iskicoord(X1,y1)) THEN
 /// Threat in "line of sight" found.
          RETURN true;
        END;
 /// If a knight, rook, non-adjacent
 /// pawn, a king, or own piece is fo-
 /// und, and the position is not emp-
 /// ty.
        IF a_iskn(X1,y1) OR a_isro(X1,y1)
          OR (a_ispw(X1,y1) AND X1>OX1+sqsz)
          OR a_isopki("b",X1,y1)
          OR a_isopki("w",X1,y1)
          OR (NOT(a_isop(COL,X1,y1)) AND
          NOT(a_ise(X1,y1))) THEN
          BREAK;
        END;
 /// If the position is not adjacent,
 /// contains an opponent piece, is not
 /// an opposing pawn, and is not an o-
 /// pposing king.
        IF X1>OX1+sqsz AND
          a_isop(COL,X1,y1) AND
          NOT(a_isoppw(COL,X1,y1)) AND
          NOT(a_isopki(COL,X1,y1)) THEN
 /// Threat in "line of sight" found.
          RETURN true;
        END;
 /// Decrease y1.
        y1:=y1-sqsz;
      END;
 /// No threat in "line of sight" found.
      RETURN false;
    END;
    IF DIR=="r" THEN /// Check right.
 /// From origin to table right.
      FOR X1 FROM OX1+sqsz TO xlim-sqsz
        STEP sqsz DO
 /// If a pawn, knight, bishop, own
 /// rook, own queen, own king, or non-
 /// adjacent opponent king is found.
        IF a_ispw(X1,OY1) OR a_iskn(X1,OY1)
          OR a_isbs(X1,OY1)
          OR a_isoro(COL,X1,OY1)
          OR a_isoqn(COL,X1,OY1)
          OR a_isoki(COL,X1,OY1)
          OR (X1>OX1+sqsz AND
          a_isopki(COL,X1,OY1)) THEN
 /// No threat in "line of sight"
 /// found.
          BREAK;
        ELSE
 /// If any other type of opponent is
 /// found.
          IF a_isop(COL,X1,OY1) THEN
 /// Threat in "line of sight"
 /// found.
            RETURN true;
          END;
        END;
      END;
 /// No threat in "line of sight" found.
      RETURN false;
    END;
    IF DIR=="dr" THEN /// Check down, right.
      y1:=OY1+sqsz; /// Reset y1.
 /// From origin to table right/bottom.
      FOR X1 FROM OX1+sqsz TO xlim-sqsz
        STEP sqsz DO
        IF y1≥hlim THEN BREAK; END;
 /// If a knight, rook, non-adjacent
 /// pawn, a king, or own piece is fo-
 /// und and the position is not emp-
 /// ty.
        IF a_iskn(X1,y1) OR a_isro(X1,y1)
          OR (a_ispw(X1,y1) AND X1>OX1+sqsz)
          OR a_isopki("b",X1,y1)
          OR a_isopki("w",X1,y1)
          OR (NOT(a_isop(COL,X1,y1)) AND
          NOT(a_ise(X1,y1))) THEN
 /// No threat in "line of sight"
 /// found.
          BREAK;
        END;
 /// If adjacent space is occupied by
 /// an opponent and it's not a pawn
 /// or is an opposing pawn and the
 /// conditions are met (opposing
 /// evaluated piece and current turn
 /// colors when evaluating for valid
 /// moves, or same colors when evalua-
 /// ting all other situations.)
        IF (X1==OX1+sqsz AND
          a_isop(COL,X1,y1) AND
          NOT(a_ispw(X1,y1))) OR
          ((a_isoppw(COL,X1,y1) AND VME) AND
          ((COL=="w" AND a_gctc()=="b") OR
          (COL=="b" AND a_gctc()=="w")))
          OR
          ((a_isoppw(COL,X1,y1) AND
          VME==false) AND
          ((COL=="w" AND a_gctc()=="w") OR
          (COL=="b" AND a_gctc()=="b")))
        THEN
          RETURN true;
        END;
 /// If the position is not adjacent,
 /// contains an opponent piece, is not
 /// an opposing pawn, and is not an o-
 /// pposing king.
        IF X1>OX1+sqsz AND
          a_isop(COL,X1,y1) AND
          NOT(a_isoppw(COL,X1,y1)) AND
          NOT(a_isopki(COL,X1,y1)) THEN
 /// Threat in "line of sight" found.
          RETURN true;
        END;
 /// Increment y1.
        y1:=y1+sqsz;
      END;
 /// No threat in "line of sight" found.
      RETURN false;
    END;
    IF DIR=="d" THEN /// Check down.
 /// From origin to table bottom.
      FOR Y1 FROM OY1+sqsz TO hlim-sqsz
        STEP sqsz DO
 /// If a pawn, knight, bishop, own
 /// rook, own queen, own king, or non-
 /// adjacent opponent king is found.
        IF a_ispw(OX1,Y1) OR a_iskn(OX1,Y1)
          OR a_isbs(OX1,Y1)
          OR a_isoro(COL,OX1,Y1)
          OR a_isoqn(COL,OX1,Y1)
          OR a_isoki(COL,OX1,Y1)
          OR (Y1>OY1+sqsz AND
          a_isopki(COL,OX1,Y1)) THEN
 /// No threat in "line of sight"
 /// found.
          BREAK;
        ELSE
 /// If any other type of opponent is
 /// found.
          IF a_isop(COL,OX1,Y1) THEN
 /// Threat in "line of sight"
 /// found.
            RETURN true;
          END;
        END;
      END;
 /// No threat in "line of sight" found.
      RETURN false;
    END;
    IF DIR=="dl" THEN /// Check down, left.
 /// Reset y1.
      y1:=OY1+sqsz;
 /// From origin to table left/bottom.
      FOR X1 FROM OX1-sqsz DOWNTO xorg
        STEP sqsz DO
        IF y1≥hlim THEN BREAK; END;
 /// If a knight, rook, non-adjacent
 /// pawn, a king, or own piece is fo-
 /// und and the position is not empty.
        IF a_iskn(X1,y1) OR a_isro(X1,y1)
          OR (a_ispw(X1,y1) AND X1<OX1-sqsz)
          OR a_isopki("b",X1,y1)
          OR a_isopki("w",X1,y1)
          OR (NOT(a_isop(COL,X1,y1)) AND
          NOT(a_ise(X1,y1))) THEN
 /// No threat in "line of sight" fo-
 /// und.
          BREAK;
        END;
 /// If adjacent space is occupied by
 /// an opponent and it's not a pawn
 /// or is an opposing pawn and the
 /// conditions are met (opposing
 /// evaluated piece and current turn
 /// colors when evaluating for valid
 /// moves, or same colors when evalua-
 /// ting all other situations.)
        IF (X1==OX1-sqsz AND
          a_isop(COL,X1,y1) AND
          NOT(a_ispw(X1,y1))) OR
          ((a_isoppw(COL,X1,y1) AND VME) AND
          ((COL=="w" AND a_gctc()=="b") OR
          (COL=="b" AND a_gctc()=="w")))
          OR
          ((a_isoppw(COL,X1,y1) AND
          VME==false) AND
          ((COL=="w" AND a_gctc()=="w") OR
          (COL=="b" AND a_gctc()=="b")))
        THEN
          RETURN true;
        END;
 /// If the position is not adjacent,
 /// contains an opponent piece, is not
 /// an opposing pawn, and is not an o-
 /// pposing king.
        IF X1<OX1-sqsz AND
          a_isop(COL,X1,y1) AND
          NOT(a_isoppw(COL,X1,y1)) AND
          NOT(a_isopki(COL,X1,y1)) THEN
 /// Threat in "line of sight" found.
          RETURN true;
        END;
 /// Increment y1.
        y1:=y1+sqsz;
      END;
 /// No threat in "line of sight" found.
      RETURN false;
    END;
    IF DIR=="l" THEN /// Check left.
 /// From origin to table bottom.
      FOR X1 FROM OX1-sqsz DOWNTO xorg
        STEP sqsz DO
 /// If a pawn, knight, bishop, own
 /// rook, own queen, own king, or non-
 /// adjacent opponent king is found.
        IF a_ispw(X1,OY1) OR a_iskn(X1,OY1)
          OR a_isbs(X1,OY1)
          OR a_isoro(COL,X1,OY1)
          OR a_isoqn(COL,X1,OY1)
          OR a_isoki(COL,X1,OY1)
          OR (X1<OX1-sqsz AND
          a_isopki(COL,X1,OY1)) THEN
 /// No threat in "line of sight"
 /// found.
            BREAK;
        ELSE
 /// If any other type of opponent is
 /// found.
          IF a_isop(COL,X1,OY1)==true THEN
 /// Threat in "line of sight"
 /// found.
            RETURN true;
          END;
        END;
      END;
 /// No threat in "line of sight" found.
      RETURN false;
    END;
    IF DIR=="ul" THEN /// Check up, left.
      y1:=OY1-sqsz; /// Reset y1.
 /// From origin to table left/top.
      FOR X1 FROM OX1-sqsz DOWNTO xorg
        STEP sqsz DO
        IF y1<yorg THEN BREAK; END;
 /// If the position is adjacent to the
 /// origin, contains an opponent pie-
 /// ce, and is a pawn, bishop, queen
 /// or king.
        IF X1==OX1-sqsz AND
          a_isop(COL,X1,y1) AND
          (a_ispw(X1,y1) OR
          a_isbs(X1,y1) OR
          a_isqn(X1,y1) OR
          a_iskicoord(X1,y1)) THEN
 /// Threat in "line of sight" found.
          RETURN true;
        END;
 /// If a knight, rook, non-adjacent
 /// pawn, a king, or own piece is fo-
 /// und and the position is not emp-
 /// ty.
        IF a_iskn(X1,y1) OR a_isro(X1,y1)
          OR (a_ispw(X1,y1) AND X1<OX1-sqsz)
          OR a_isopki("b",X1,y1)
          OR a_isopki("w",X1,y1)
          OR (NOT(a_isop(COL,X1,y1)) AND
          NOT(a_ise(X1,y1))) THEN
 /// No threat in "line of sight"
 /// found.
          BREAK;
        END;
 /// If the position is not adjacent,
 /// contains an opponent piece, is not
 /// an opposing pawn, and is not an o-
 /// pposing king.
        IF X1<OX1-sqsz AND
          a_isop(COL,X1,y1) AND
          NOT(a_isoppw(COL,X1,y1)) AND
          NOT(a_isopki(COL,X1,y1)) THEN
 /// Threat in "line of sight" found.
          RETURN true;
        END;
 /// Decrease y1.
        y1:=y1-sqsz;
      END;
 /// No threat in "line of sight" found.
      RETURN false;
    END;
    DEFAULT
 /// No valid direction provided, assume
 /// there's a threat ("Better safe than
 /// sorry.")
      RETURN true;
  END;
END;

// a_iskic: Is king of said color in check.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// King's color, valid move evaluation.
EXPORT a_iskic(COL,VME)
BEGIN
 /// Position state.
  LOCAL ps;
  IF COL≠"" THEN
 /// Get king's position state information.
    IF COL=="b" THEN
 /// Black king.
      ps:=a_gps("bki");
    ELSE
      IF COL=="w" THEN
 /// White king.
        ps:=a_gps("wki");
      END;
    END;
 /// Is king under threat of attack? Check
 /// all directions and the opposing
 /// knights.
    IF a_isotlos(COL,ps(1),ps(2),"u",VME)
    OR a_isotlos(COL,ps(1),ps(2),"ur",VME)
    OR a_isotlos(COL,ps(1),ps(2),"r",VME)
    OR a_isotlos(COL,ps(1),ps(2),"dr",VME)
    OR a_isotlos(COL,ps(1),ps(2),"d",VME)
    OR a_isotlos(COL,ps(1),ps(2),"dl",VME)
    OR a_isotlos(COL,ps(1),ps(2),"l",VME)
    OR a_isotlos(COL,ps(1),ps(2),"ul",VME)
    OR a_isukna(COL,ps(1),ps(2))
    THEN
 /// King is under threat of attack.
      RETURN true;
    ELSE
 /// King is not under threat of attack.
      RETURN false;
    END;
  END;
 /// No color provided, assume king is under
 /// threat of attack ("better safe than so-
 /// rry.")
  RETURN true;
END;

// a_isvm: Is a valid move.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Selection coordinates, move-to coordina-
// tes.
EXPORT a_isvm(SELX1,SELY1,PRCX1,PRCY1)
BEGIN
 /// Piece name, source index, target index,
 /// captured piece name.
  LOCAL pn,sidx,tidx,cpn;
 /// If move would be otherwise valid.
  IF tstate(a_gsi(PRCX1,PRCY1),5) THEN
 /// Setup test state.
    pn:=a_gpn(SELX1,SELY1);
    sidx:=a_gsi(SELX1,SELY1);
    tidx:=a_gsi(PRCX1,PRCY1);
    cpn:=a_gpn(PRCX1,PRCY1);
 /// Add move information to game state,
 /// temporarily.
    tstate(sidx,3):="";
    tstate(tidx,3):=pn;
    IF a_iskic(a_gctc(),true) THEN
 /// If player's king would be in check,
 /// rollback state and return false.
      tstate(sidx,3):=pn;
      tstate(tidx,3):=cpn;
      RETURN false;
    ELSE
 /// If check state would be removed or
 /// nonexistent, rollback state and re-
 /// turn true.
      tstate(sidx,3):=pn;
      tstate(tidx,3):=cpn;
      RETURN true;
    END;
  ELSE
 /// Move is not valid to start with.
    RETURN false;
  END;
END;

// a_am: Add move information to list.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Piece name, source position index, target
// position index, captured piece name (if
// any, else "".)
EXPORT a_am(PN,SPIDX,TPIDX,CPN)
BEGIN
 /// Increment counter.
  mvcnt:=mvcnt+1;
 /// Add move.
  mv(mvcnt):={PN,SPIDX,TPIDX,CPN};
END;

// a_isepc: Is an en passant capture. Deter-
// mine if move is an en passant, if so, set
// capture coordinates and return true.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Selected piece coordinates, target coordi-
// nates.
EXPORT a_isepc()
BEGIN
  LOCAL isbpw;
  LOCAL iswpw;
 /// If a right or left en passant is active
 /// and corresponds to selected piece coor-
 /// dinates.
  IF aepli==a_gsi(selx1,sely1) OR
    aepri==a_gsi(selx1,sely1) THEN
    isbpw:=a_isbpw(selx1,sely1);
    iswpw:=a_iswpw(selx1,sely1);
 /// If it's a pawn.
    IF isbpw OR iswpw THEN
      IF isbpw THEN
 /// It's a black pawn move. And the
 /// black pawn is moving forward and
 /// diagonally to the left, and the
 /// position immediately to its left
 /// is a white pawn.
        IF prcx1==selx1-sqsz AND
          a_iswpw(selx1-sqsz,sely1) THEN
 /// Capture white pawn to the left.
          epcx1:=selx1-sqsz;
          epcy1:=sely1;
 /// It's an en passant move.
          RETURN true;
        ELSE
 /// And the black pawn is moving
 /// forward and diagonally to the
 /// right, and the position imme-
 /// diately to its right is a white
 /// pawn.
          IF prcx1==selx1+sqsz AND
            a_iswpw(selx1+sqsz,sely1) THEN
 /// Capture black pawn to the
 /// right.
            epcx1:=selx1+sqsz;
            epcy1:=sely1;
 /// It's an en passant move.
            RETURN true;
          END;
        END;
      ELSE
 /// Is a white pawn move. And the whi-
 /// te pawn is moving forward and dia-
 /// gonally to the left, and the posi-
 /// tion immediately to its left is a
 /// black pawn.
        IF prcx1==selx1-sqsz AND
          a_isbpw(selx1-sqsz,sely1) THEN
 /// Capture black pawn to the left.
          epcx1:=selx1-sqsz;
          epcy1:=sely1;
 /// It's an en passant move.
          RETURN true;
        ELSE
 /// And the white pawn is moving
 /// forward and diagonally to the
 /// right, and the position imme-
 /// diately to its right is a black
 /// pawn.
          IF prcx1==selx1+sqsz AND
            a_isbpw(selx1+sqsz,sely1) THEN
 /// Capture black pawn to the
 /// right.
            epcx1:=selx1+sqsz;
            epcy1:=sely1;
 /// It's an en passant move.
            RETURN true;
          END;
        END;
      END;
    END;
  END;
 /// It's not an en passant move.
  RETURN false;
END;

// a_ceppc: Clear en passant capture coor-
// dinates.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

EXPORT a_cepcc()
BEGIN
 /// Captured en passant x1.
  epcx1:=-1;
 /// Captured en passant y1.
  epcy1:=-1;
END;

// a_iski: Is a king.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Piece name.
EXPORT a_iski(PN)
BEGIN
 /// Is the piece a king?
  RETURN a_iswki(PN) OR a_isbki(PN);
END;

// a_iscm: Is a castle move.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Selected position coordinates, target po-
// sition x1.
EXPORT a_iscm(SELX1,SELY1,PRCX1)
BEGIN
 /// If it's a king.
  IF a_iski(a_gpn(SELX1,SELY1)) THEN
 /// And it has moved two spaces to the
 /// left or right.
    IF ABS(SELX1-PRCX1)==sqsz*2 THEN
 /// It's a castle move.
      RETURN true;
    END;
  END;
 /// It's not a castle move.
  RETURN false;
END;

// a_islcm: Is left castle move.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Selected position coordinates, target x1.
EXPORT a_islcm(SELX1,SELY1,PRCX1)
BEGIN
 /// If it's a castle move.
  IF a_iscm(SELX1,SELY1,PRCX1) THEN
 /// And target x1 is to the left.
    IF PRCX1<SELX1 THEN
 /// It's a left castle move.
      RETURN true;
    END;
  END;
 /// It's not a left castle move.
  RETURN false;
END;

// a_isrcm: Is right castle move.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Selected coordinates, target x1.
EXPORT a_isrcm(SELX1,SELY1,PRCX1)
BEGIN
 /// If it's a castle move.
  IF a_iscm(SELX1,SELY1,PRCX1) THEN
 /// And target x1 is to the right.
    IF PRCX1>SELX1 THEN
      RETURN true;
    END;
  END;
 /// It's not a castle move.
  RETURN false;
END;

// a_cam: Clear allowed moves.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

EXPORT a_cam()
BEGIN
 /// Iterate over game table state.
  FOR I FROM 1 TO 64 DO
 /// Allowed move, set to false.
    tstate(I,5):=false;
  END;
END;

// a_atsthi: Add state history item to list.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

EXPORT a_atsthi(TSTATE)
BEGIN
 /// Increment counter.
  tshcnt:=tshcnt+1;
 /// Add history item.
  tstateh(tshcnt):=TSTATE;
END;

// a_fosp: Five ocurrences of the same posi-
// tion.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

EXPORT a_fosp()
BEGIN
  LOCAL omax=5; /// Max. allowed ocurrences.
  LOCAL ocnt; /// Ocurrence count.
  LOCAL ctstate; /// State A.
  LOCAL ctstateb; /// State B.
  LOCAL diff; /// Difference flag.
 /// Five (5) ocurrences of the same position
 /// automatically yield a draw (2014 Inter-
 /// national Chess Federation rule amend-
 /// ment.) Three (3) ocurrences, previously.
 /// Iterate over game table state history.
  FOR S FROM 1 TO tshcnt DO
 /// State A.
    ctstate:=tstateh(S);
 /// Initialize ocurrence count.
    ocnt:=1;
    FOR T FROM S+1 TO tshcnt DO
 /// State B.
      ctstateb:=tstateh(T);
 /// Reinitialize difference flag.
      diff:=false;
      FOR U FROM 1 TO 64 DO
 /// A position in state A is different
 /// from the corresponding position in
 /// state B.
        IF ctstate(U,3)≠ctstateb(U,3) THEN
 /// Set difference flag.
          diff:=true;
 /// Exit loop.
          BREAK;
        END;
      END;
 /// If there are no differences.
      IF diff==false THEN
 /// Increment ocurrence count.
        ocnt:=ocnt+1;
 /// If ocurrence count equals maxi-
 /// mum value.
        IF ocnt==omax THEN
          RETURN true;
        END;
      END;
    END;
  END;
 /// No five (5) ocurrences of any game table
 /// state.
  RETURN false;
END;

// a_sfmwpmoc: Seventy-five moves without
// pawn move or capture.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

EXPORT a_sfmwpmoc()
BEGIN
  LOCAL mmax=75;
 /// Seventy-five (75) moves without pawn mo-
 /// ve or capture automatically yield a draw
 /// (2014 International Chess Federation ru-
 /// le amendment.) Fifty (50) moves, previ-
 /// ously.
  IF mvcnt>mmax THEN
    FOR M FROM mvcnt DOWNTO mvcnt-mmax DO
       IF INSTRING(mv(M,1),"pw")>0 OR
         mv(M,4)≠"" THEN
         RETURN false;
       END;
    END;
    RETURN true;
  END;
  RETURN false;
END;

// a_lrp: Return a list of all remaining pie-
// ces of the specified color.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Test color.
EXPORT a_lrp(TCOL)
BEGIN
 /// Initialize test position state list.
  LOCAL tps={{0,0,"","",false,0}};
 /// Initialize test position state count.
  tpscnt:=0;
 /// Iterate over the table state and make a
 /// list of all remaining pieces of the spe-
 /// cified color.
  FOR M FROM 1 TO 64 DO
    IF tstate(M,3)≠"" THEN
 /// Position not empty.
      IF TCOL=="b" THEN
 /// Get black pieces.
        IF LEFT(tstate(M,3),1)=="b" THEN
 /// Increment piece count.
          tpscnt:=tpscnt+1;
          tps(tpscnt,1):=tstate(M,1); /// Pox.
          tps(tpscnt,2):=tstate(M,2); /// Poy.
          tps(tpscnt,3):=tstate(M,3); /// Pcn.
          tps(tpscnt,4):=tstate(M,4); /// Poc.
          tps(tpscnt,5):=tstate(M,5); /// Pmo.
          tps(tpscnt,6):=M; /// Index.
        END;
      ELSE
 /// Get white pieces.
        IF LEFT(tstate(M,3),1)=="w" THEN
 /// Increment piece count.
          tpscnt:=tpscnt+1;
          tps(tpscnt,1):=tstate(M,1); /// Pox.
          tps(tpscnt,2):=tstate(M,2); /// Poy.
          tps(tpscnt,3):=tstate(M,3); /// Pcn.
          tps(tpscnt,4):=tstate(M,4); /// Poc.
          tps(tpscnt,5):=tstate(M,5); /// Pmo.
          tps(tpscnt,6):=M; /// Index.
        END;
      END;
    END;
  END;
 /// Return a list of all remaining pieces of
 /// the specified color.
  RETURN tps;
END;

// a_aam: Add allowed move.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Position index.
EXPORT a_aam(PIDX)
BEGIN
 /// Mark position as allowed.
  tstate(PIDX,5):=true;
END;

// a_svpmbpw: Set valid piece moves, black
// pawn.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

EXPORT a_svpmbpw()
BEGIN
  IF sely1==ylim-(sqsz*2) AND
    a_ise(selx1,sely1-sqsz) AND
    a_ise(selx1,sely1-(sqsz*2)) THEN
 /// Pawn at starting position, spaces
 /// are empty, allow double-forward move.
    a_aam(a_gsi(selx1,sqsz*4));
    a_aam(a_gsi(selx1,sqsz*5));
  ELSE
 /// If space empty, allow single-forward
 /// move.
    IF a_ise(selx1,sely1-sqsz) THEN
      a_aam(a_gsi(selx1,sely1-sqsz));
    END;
  END;
 /// Capture moves (diagonal.)
  IF a_isw(selx1-sqsz,sely1-sqsz) THEN
    a_aam(a_gsi(selx1-sqsz,sely1-sqsz));
  END;
  IF a_isw(selx1+sqsz,sely1-sqsz) THEN
    a_aam(a_gsi(selx1+sqsz,sely1-sqsz));
  END;
 /// En Passant: If corresponding en passant
 /// index is active and there's a white pawn
 /// to the right, then allow for down-right
 /// movement, if said space is empty, and
 /// also foresaid pawn's capture. If corres-
 /// ponding en passant index is active and
 /// there's a white pawn to the left, then
 /// allow for down-left movement, if said
 /// space is empty, and also foresaid pawn's
 /// capture.
  IF aepli==a_gsi(selx1,sely1) THEN
    a_aam(a_gsi(selx1-sqsz,sely1-sqsz));
  END;
  IF aepri==a_gsi(selx1,sely1) THEN
    a_aam(a_gsi(selx1+sqsz,sely1-sqsz));
  END;
END;

// a_svpmwpw: Set valid piece moves, white
// pawn.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

EXPORT a_svpmwpw()
BEGIN
  IF sely1==ylim-(sqsz*2) AND
    a_ise(selx1,sely1-sqsz) AND
    a_ise(selx1,sely1-(sqsz*2)) THEN
 /// Pawn at starting position, spaces
 /// are empty, allow double-forward move.
    a_aam(a_gsi(selx1,sqsz*4));
    a_aam(a_gsi(selx1,sqsz*5));
  ELSE
 /// If space empty, allow single-forward
 /// move.
    IF a_ise(selx1,sely1-sqsz) THEN
      a_aam(a_gsi(selx1,sely1-sqsz));
    END;
  END;
 /// Capture moves (diagonal.)
  IF a_isb(selx1-sqsz,sely1-sqsz) THEN
    a_aam(a_gsi(selx1-sqsz,sely1-sqsz));
  END;
  IF a_isb(selx1+sqsz,sely1-sqsz) THEN
    a_aam(a_gsi(selx1+sqsz,sely1-sqsz));
  END;
 /// En Passant: If corresponding en passant
 /// index is active and there's a black pawn
 /// to the right, then allow for down-right
 /// movement, if said space is empty, and
 /// also foresaid pawn's capture. If co-
 /// rresponding en passant index is active
 /// and there's a black pawn to the left,
 /// then allow for down-left movement, if
 /// said space is empty, and also foresaid
 /// pawn's capture.
  IF aepli==a_gsi(selx1,sely1) THEN
    a_aam(a_gsi(selx1-sqsz,sely1-sqsz));
  END;
  IF aepri==a_gsi(selx1,sely1) THEN
    a_aam(a_gsi(selx1+sqsz,sely1-sqsz));
  END;
END;

// a_iseorop: Is empty or contains opposing
// player's piece.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Color to be tested against, coordinates
// to be tested.
EXPORT a_iseorop(COL,TX1,TY1)
BEGIN
 /// Is it empty or does it contain an
 /// opposing player's piece?
  RETURN a_ise(TX1,TY1) OR
    a_isop(COL,TX1,TY1);
END;

// a_hkim: Has the king of said color moved.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// King color.
EXPORT a_hkim(COL)
BEGIN
  IF COL≠"" THEN
 /// Iterate over move list.
    FOR I FROM 1 TO mvcnt DO
      IF COL=="w" AND a_iswki(mv(I,1)) THEN
 /// White king has moved.
        RETURN true;
      ELSE
        IF COL=="b" AND a_isbki(mv(I,1)) THEN
 /// Black king has moved.
          RETURN true;
        END;
      END;
    END;
  END;
 /// Specified king has not moved.
  RETURN false;
END;

// a_hpm: Has the piece moved.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Piece name.
EXPORT a_hpm(PN)
BEGIN
  IF PN≠"" THEN
 /// Iterate over move list.
    FOR I FROM 1 TO mvcnt DO
      IF mv(I,1)==PN THEN /// Piece found.
 /// Piece has moved.
        RETURN true;
      END;
    END;
  END;
 /// Piece has not moved.
  RETURN false;
END;

// a_issbhpe: Is space between horizontal
// positions empty (left to right, exclu-
// sive.)
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Left position x1, right position x1, row
// y1.
EXPORT a_issbhpe(PLX1,PRX1,PY)
BEGIN
 /// From left position to right position,
 /// exclusive.
  FOR P FROM PLX1+sqsz TO PRX1-sqsz
    STEP sqsz DO
 /// Is the position occupied?
    IF a_ise(P,PY)==false THEN
 /// The space is not empty.
      RETURN false;
    END;
  END;
 /// The space is empty.
  RETURN true;
END;

// a_isclv: Is castle left valid.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Castle color.
EXPORT a_isclv(COL)
BEGIN
 /// If king nor left rook have moved.
  IF a_hkim(COL)==false THEN
    IF (COL=="b" AND a_hpm("bro2")==false)
      OR (COL=="w" AND a_hpm("wro1")==false)
      THEN
 /// And space between pieces is empty.
      IF (COL=="b" AND a_issbhpe(xorg,
        wmid-sqsz,ylim-sqsz)) OR
        (COL=="w" AND a_issbhpe(xorg,
        wmid,ylim-sqsz)) THEN
 /// And king is not in check.
        IF a_iskic(COL,true)==false THEN
 /// Castle left is valid.
          RETURN true;
        END;
      END;
    END;
  END;
 /// Castle left is not valid.
  RETURN false;
END;

// a_iscrv: Is castle right valid.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Color.
EXPORT a_iscrv(COL)
BEGIN
 /// If king nor right rook have moved.
  IF a_hkim(COL)==false THEN
    IF (COL=="b" AND a_hpm("bro1")==false)
      OR (COL=="w" AND a_hpm("wro2")==false)
      THEN
 /// And space between pieces is empty.
      IF (COL=="b" AND a_issbhpe(wmid-sqsz,
        xlim-sqsz,ylim-sqsz)) OR
        (COL=="w" AND a_issbhpe(wmid,
        xlim-sqsz,ylim-sqsz)) THEN
 /// And king is not in check.
        IF a_iskic(COL,true)==false THEN
 /// Castle right is valid.
          RETURN true;
        END;
      END;
    END;
  END;
 /// Castle right is not valid.
  RETURN false;
END;

// a_svpmki: Set valid piece moves, king.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// King color.
EXPORT a_svpmki(COL)
BEGIN
 /// Set up.
  IF sely1-sqsz≥yorg THEN
    IF a_iseorop(COL,selx1,sely1-sqsz)
      THEN
      a_aam(a_gsi(selx1,sely1-sqsz));
    END;
  END;
 /// Set up, right.
  IF selx1+sqsz<xlim AND sely1-sqsz≥yorg THEN
    IF a_iseorop(COL,selx1+sqsz,sely1-sqsz)
      THEN
      a_aam(a_gsi(selx1+sqsz,sely1-sqsz));
    END;
  END;
 /// Set right.
  IF selx1+(sqsz*2)≤xlim THEN
    IF a_iseorop(COL,selx1+sqsz,sely1)
      THEN
      a_aam(a_gsi(selx1+sqsz,sely1));
    END;
  END;
 /// Set down, right.
  IF selx1+sqsz≤xlim AND
    sely1+sqsz<hlim THEN
    IF a_iseorop(COL,selx1+sqsz,sely1+sqsz)
      THEN
      a_aam(a_gsi(selx1+sqsz,sely1+sqsz));
    END;
  END;
 /// Set down.
  IF sely1+(sqsz*2)≤hlim THEN
    IF a_iseorop(COL,selx1,sely1+sqsz)
      THEN
      a_aam(a_gsi(selx1,sely1+sqsz));
    END;
  END;
 /// Set down, left.
  IF selx1-sqsz≥xorg AND
    sely1+(sqsz*2)≤hlim THEN
    IF a_iseorop(COL,selx1-sqsz,sely1+sqsz)
      THEN
      a_aam(a_gsi(selx1-sqsz,sely1+sqsz));
    END;
  END;
 /// Set left.
  IF selx1-sqsz≥xorg THEN
    IF a_iseorop(COL,selx1-sqsz,sely1)
      THEN
      a_aam(a_gsi(selx1-sqsz,sely1));
    END;
  END;
 /// Set up, left.
  IF selx1-sqsz≥xorg AND
    sely1-sqsz≥yorg THEN
    IF a_iseorop(COL,selx1-sqsz,sely1-sqsz)
      THEN
      a_aam(a_gsi(selx1-sqsz,sely1-sqsz));
    END;
  END;
 /// Castle left, right:
 /// If king and intended rook have not mo-
 /// ved, and the space between them is emp-
 /// ty, then the king may move in the inten-
 /// ded rook's direction two spaces and the
 /// rook immediately to the king's side, o-
 /// pposite to the rook's original position.
 /// The king cannot be in check.
 /// If castle left valid.
  IF a_isclv(COL) THEN
 /// Set left castle as valid.
    IF COL=="b" THEN /// Black left castle.
      a_aam(a_gsi(wmid-(sqsz*3),
          ylim-sqsz));
    ELSE
      IF COL=="w" THEN /// White left castle.
        a_aam(a_gsi(wmid-(sqsz*2),
          ylim-sqsz));
      END;
    END;
  END;
 /// If castle right valid.
  IF a_iscrv(COL) THEN
 /// Set right castle as valid.
    IF COL=="b" THEN /// Black right castle.
      a_aam(a_gsi(wmid+sqsz,
          ylim-sqsz));
    ELSE
      IF COL=="w" THEN /// White right castle.
        a_aam(a_gsi(wmid+(sqsz*2),
          ylim-sqsz));
      END;
    END;
  END;
 /// DESIDERATA
  //
 /// "Go  placidly  amid the noise  and haste
 /// and remember what  peace there may be in
 /// silence. As far as  possible without su-
 /// rrender be on  good  terms with all per-
 /// sons.  Speak  your   truth   quietly and
 /// clearly; and  listen to others, even the
 /// dull and  ignorant; they  too have their
 /// story. *Avoid  loud and  aggresive  per-
 /// sons, they are  vexations to the spirit.
 /// If you  compare yourself with others you
 /// will become vain and bitter; for  always
 /// there will be  greater and   lesser per-
 /// sons than yourself. Enjoy  your achieve-
 /// ments as well as  your  plans. *Keep in-
 /// terested in   your  own  career, however
 /// humble; it is a   real  possesion in the
 /// changing fortunes of time. Exercise cau-
 /// ion in  your  business  affairs; for the
 /// world  is full of trickery. But let this
 /// not  blind  you to what virtue there is;
 /// many persons strive for high ideals; and
 /// everywhere life is full of  heroism. *Be
 /// yourself.  Especially  do  not  feign a-
 /// ffection. Neither be cynical about love;
 /// for in the face of  all aridity and dis-
 /// enchantment it  is  as  perennial as the
 /// grass. *Take kindly the  counsel  of the
 /// years,   gracefully   surrendering   the
 /// things  of   youth. Nurture  strength of
 /// spirit  to  shield  you in  sudden  mis-
 /// fortune. But do  not  distress  yourself
 /// with  imaginings. Many  fears  are  born
 /// of  fatigue  and   loneliness.  Beyond a
 /// wholesome   discipline,  be  gentle with
 /// yourself. *You are  a  child of the uni-
 /// verse, no  less than the  trees  and the
 /// stars; you have the  right  to be  here.
 /// And whether  or not it is  clear to you,
 /// no doubt the universe is unfolding as it
 /// should. *Therefore be at peace with God,
 /// what  ever you  conceive  him to be, and
 /// whatever your labors and  aspirations in
 /// the noisy  confusion of life, keep peace
 /// with  your  soul. *With  all  its  sham,
 /// drudgery and  broken  dreams it is still
 /// a  beautiful  world. Be  careful. Strive
 /// to be happy."
END;

// a_svpmro: Set valid piece moves, rook.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Rook color.
EXPORT a_svpmro(COL)
BEGIN
 /// Set up.
  FOR Y1 FROM sely1-sqsz DOWNTO yorg
    STEP sqsz DO
    IF a_ise(selx1,Y1) OR
      a_isop(COL,selx1,Y1) THEN
      a_aam(a_gsi(selx1,Y1));
      IF a_ise(selx1,Y1)==false AND
        a_isop(COL,selx1,Y1) THEN BREAK; END;
    ELSE BREAK; END;
  END;
 /// Set right.
  FOR X1 FROM selx1+sqsz TO xlim-sqsz
    STEP sqsz DO
    IF a_ise(X1,sely1) OR
      a_isop(COL,X1,sely1) THEN
      a_aam(a_gsi(X1,sely1));
      IF a_ise(X1,sely1)==false AND
        a_isop(COL,X1,sely1)
        THEN BREAK; END;
    ELSE BREAK; END;
  END;
 /// Set down.
  FOR Y1 FROM sely1+sqsz TO hlim-sqsz
    STEP sqsz DO
    IF a_ise(selx1,Y1) OR
      a_isop(COL,selx1,Y1) THEN
      a_aam(a_gsi(selx1,Y1));
      IF a_ise(selx1,Y1)==false AND
        a_isop(COL,selx1,Y1) THEN BREAK; END;
    ELSE BREAK; END;
  END;
 /// Set left.
  FOR X1 FROM selx1-sqsz DOWNTO xorg
    STEP sqsz DO
    IF a_ise(X1,sely1) OR
      a_isop(COL,X1,sely1) THEN
      a_aam(a_gsi(X1,sely1));
      IF a_ise(X1,sely1)==false AND
        a_isop(COL,X1,sely1)
        THEN BREAK; END;
    ELSE BREAK; END;
  END;
END;

// a_svpmbs: Set valid piece moves, bishop.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Bishop color.
EXPORT a_svpmbs(COL)
BEGIN
  LOCAL y1=sely1;
 /// Set right, up.
  FOR X1 FROM selx1+sqsz TO xlim-sqsz
    STEP sqsz DO
    y1:=y1-sqsz;
    IF y1<0 OR (a_ise(X1,y1)==false AND
      a_isop(COL,X1,y1)==false) THEN
      BREAK; END;
    a_aam(a_gsi(X1,y1));
    IF a_isop(COL,X1,y1) THEN BREAK; END;
  END;
 /// Set right, down.
  y1:=sely1;
  FOR X1 FROM selx1+sqsz TO xlim-sqsz
    STEP sqsz DO
    y1:=y1+sqsz;
    IF y1==hlim OR (a_ise(X1,y1)==false AND
      a_isop(COL,X1,y1)==false) THEN
      BREAK; END;
    a_aam(a_gsi(X1,y1));
    IF a_isop(COL,X1,y1) THEN BREAK; END;
  END;
 /// Set left, down.
  y1:=sely1;
  FOR X1 FROM selx1-sqsz DOWNTO xorg
    STEP sqsz DO
    y1:=y1+sqsz;
    IF y1==hlim OR (a_ise(X1,y1)==false AND
      a_isop(COL,X1,y1)==false) THEN
      BREAK; END;
    a_aam(a_gsi(X1,y1));
    IF a_isop(COL,X1,y1) THEN BREAK; END;
  END;
 /// Set left, up.
  y1:=sely1;
  FOR X1 FROM selx1-sqsz DOWNTO xorg
    STEP sqsz DO
    y1:=y1-sqsz;
    IF y1<0 OR (a_ise(X1,y1)==false AND
      a_isop(COL,X1,y1)==false) THEN
      BREAK; END;
    a_aam(a_gsi(X1,y1));
    IF a_isop(COL,X1,y1) THEN BREAK; END;
  END;
END;

// a_svpmqn: Set valid piece moves, queen.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Queen color.
EXPORT a_svpmqn(COL)
BEGIN
 /// Set the combination of bishop and
 /// rook's possible moves.
  a_svpmbs(COL);
  a_svpmro(COL);
END;

// a_svpmkn: Set valid piece moves, knight.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Knight color.
EXPORT a_svpmkn(COL)
BEGIN
 /// Set 2 up, 1 left.
  IF sely1-(sqsz*2)≥yorg AND selx1-sqsz≥xorg
    THEN
    IF a_iseorop(COL,
      selx1-sqsz,sely1-(sqsz*2)) THEN
      a_aam(a_gsi(selx1-sqsz,
        sely1-(sqsz*2)));
    END;
  END;
 /// Set 2 up, 1 right.
  IF sely1-(sqsz*2)≥yorg AND selx1+sqsz<xlim
    THEN
    IF a_iseorop(COL,selx1+sqsz,
      sely1-(sqsz*2)) THEN
      a_aam(a_gsi(selx1+sqsz,
        sely1-(sqsz*2)));
    END;
  END;
 /// Set 2 right, 1 up.
  IF sely1-sqsz≥yorg AND selx1+(sqsz*2)<xlim
    THEN
    IF a_iseorop(COL,selx1+(sqsz*2),
      sely1-sqsz) THEN
      a_aam(a_gsi(selx1+(sqsz*2),
        sely1-sqsz));
    END;
  END;
 /// Set 2 right, 1 down.
  IF sely1+sqsz<hlim AND selx1+(sqsz*2)<xlim
    THEN
    IF a_iseorop(COL,selx1+(sqsz*2),
      sely1+sqsz) THEN
      a_aam(a_gsi(selx1+(sqsz*2),
        sely1+sqsz));
    END;
  END;
 /// Set 2 down, 1 left.
  IF sely1+(sqsz*2)<hlim AND
    selx1-sqsz≥xorg THEN
    IF a_iseorop(COL,selx1-sqsz,
      sely1+(sqsz*2)) THEN
      a_aam(a_gsi(selx1-sqsz,
        sely1+(sqsz*2)));
    END;
  END;
 /// Set 2 down, 1 right.
  IF sely1+(sqsz*2)<hlim AND selx1+sqsz<xlim
    THEN
    IF a_iseorop(COL,selx1+sqsz,
      sely1+(sqsz*2)) THEN
      a_aam(a_gsi(selx1+sqsz,
        sely1+(sqsz*2)));
    END;
  END;
 /// Set 2 left, 1 up.
  IF sely1-sqsz≥yorg AND selx1-(sqsz*2)≥xorg
    THEN
    IF a_iseorop(COL,selx1-(sqsz*2),
      sely1-sqsz) THEN
      a_aam(a_gsi(selx1-(sqsz*2),
        sely1-sqsz));
    END;
  END;
 /// Set 2 left, 1 down.
  IF sely1+sqsz<hlim AND
    selx1-(sqsz*2)≥xorg THEN
    IF a_iseorop(COL,selx1-(sqsz*2),
      sely1+sqsz) THEN
      a_aam(a_gsi(selx1-(sqsz*2),
        sely1+sqsz));
    END;
  END;
END;

// a_svpm: Set valid piece moves.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Selected piece name.
EXPORT a_svpm(SELPN)
BEGIN
  CASE
 /// If piece is a black pawn.
    IF LEFT(SELPN,3)=="bpw" THEN
      a_svpmbpw();
    END;
 /// If piece is a white pawn.
    IF LEFT(SELPN,3)=="wpw" THEN
      a_svpmwpw();
    END;
 /// If piece is a king.
    IF INSTRING(SELPN,"ki")>0 THEN
      a_svpmki(a_gpc(SELPN));
    END;
 /// If piece is a queen.
    IF INSTRING(SELPN,"qn")>0 THEN
      a_svpmqn(a_gpc(SELPN));
    END;
 /// If piece is a rook.
    IF INSTRING(SELPN,"ro")>0 THEN
      a_svpmro(a_gpc(SELPN));
    END;
 /// If piece is a bishop.
    IF INSTRING(SELPN,"bs")>0 THEN
      a_svpmbs(a_gpc(SELPN));
    END;
 /// If piece is a knight.
    IF INSTRING(SELPN,"kn")>0 THEN
      a_svpmkn(a_gpc(SELPN));
    END;
    DEFAULT
  END;
END;

// a_tpm: Test all position moves for a king
// check break.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Table position state, test color.
EXPORT a_tpm(CTPS,TCOL)
BEGIN
 /// Temporary captured piece name.
  LOCAL tcpn="";
 /// Set piece's valid moves.
  selx1:=CTPS(1);
  sely1:=CTPS(2);
  a_svpm(CTPS(3));
 /// Test piece's valid moves for any king
 /// check breaks.
  FOR N FROM 1 TO 64 DO
    IF tstate(N,5) THEN /// Valid move.
 /// Temporarily set move.
      tstate(CTPS(6),3):="";
      tcpn:=tstate(N,3);
      tstate(N,3):=CTPS(3);
 /// Test for check.
      IF a_iskic(TCOL,false)==false THEN
 /// Rollback move.
        tstate(CTPS(6),3):=CTPS(3);
        tstate(N,3):=tcpn;
 /// Rollback piece's valid moves.
        a_cam();
 /// Move found.
        RETURN true;
      ELSE
 /// Rollback move.
        tstate(CTPS(6),3):=CTPS(3);
        tstate(N,3):=tcpn;
      END;
    END;
  END;
 /// Rollback piece's valid moves.
  a_cam();
 /// No move found, checkmate.
  RETURN false;
END;

// a_tapmfkcb: Test all possible moves for a
// king check break.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

// Test color.
EXPORT a_tapmfkcb(TCOL)
BEGIN
 /// Test position state.
  LOCAL tps={{0,0,"","",false,0}};
 /// Current test position state.
  LOCAL ctps={0,0,"","",false,0};
 /// Test result.
  LOCAL tr=false;
  
  IF TCOL≠"" AND (TCOL=="w" OR TCOL=="b")
    THEN
 /// Get all pieces remaining on board with
 /// the specified test color.

 /// Re the inconsistent index variable na-
 /// mes (i.e., not "I" like in other parts
 /// of the program), this is due to a
 /// technical limitation of the language/
 /// api. Iterator index variable names are
 /// shared across function calls, meaning
 /// that if the program is iterating over
 /// an array/list with a given index va-
 /// riable name and calls a separate func-
 /// tion that implements a loop that uses
 /// the same variable name, the calling
 /// function's variable's value gets over-
 /// written with the last value it assumed
 /// in the called function before retur-
 /// ning control to the caller.

 /// Make a list of all remaining pieces of
 /// the specified color, set tpscnt.
    tps:=a_lrp(TCOL);
 /// Iterate over all remaining pieces and
 /// their valid moves, if any yield a king
 /// check break, return true, else return
 /// false (checkmate.) Begin with the king
 /// piece.
 /// Get the king's position state.
    FOR M FROM 1 TO tpscnt DO
      IF INSTRING(tps(M,3),"ki")>0 THEN
 /// King's position state.
        ctps:=tps(M);
        BREAK;
      END;
    END;
 /// Test king piece's moves.
    tr:=a_tpm(ctps,TCOL);
 /// If true, return.
    IF tr THEN RETURN true; END;
 /// Test all other remaining pieces.
    FOR M FROM 1 TO tpscnt DO
      IF INSTRING(tps(M,3),"ki")==0 THEN
        tr:=a_tpm(tps(M),TCOL);
 /// If true, return.
        IF tr THEN RETURN true;
        ELSE CONTINUE; END;
      END;
    END;
  END;
 /// Checkmate.
  RETURN false;
END;

// a_sm: Stalemate.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

EXPORT a_sm()
BEGIN
 /// The player whose turn it is to move has
 /// no legal moves left and is not in check.
 /// Get remaining pieces of current color
 /// and set tpscnt.
  LOCAL rp=a_lrp(a_gctc());
 /// Iterate over remaining pieces of current
 /// turn's color.
  FOR P FROM 1 TO tpscnt DO
 /// Set selection to current piece coor-
 /// dinates.
    selx1:=rp(P,1);
    sely1:=rp(P,2);
 /// Set piece's allowed moves in game ta-
 /// ble state.
    a_svpm(rp(P,3));
 /// Iterate over game table state.
    FOR I FROM 1 TO 64 DO
 /// If allowed move found, and move is
 /// valid.
      IF tstate(I,5) AND
        a_isvm(selx1,sely1,
        tstate(I,1),tstate(I,2)) THEN
 /// Clear allowed moves.
        a_cam();
 /// Legal move available.
        RETURN false;
      END;
    END;
 /// Clear allowed moves.
    a_cam();
  END;
 /// No legal moves available.
  RETURN true;
END;

// a_sp: Select piece.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

EXPORT a_sp()
BEGIN
 /// If it's not an empty position and
 /// it's the color's turn.
  IF a_gpn(prcx1,prcy1)≠"" AND
    a_gpc(a_gpn(prcx1,prcy1))==a_gctc()
    THEN
 /// Update selection.
    selmod:=1;
    prclc:=trl;
    prcbgc:=trbg;
    selx1:=prcx1;
    sely1:=prcy1;
    IF ftrvm==1 THEN
 /// Set valid piece moves.
      a_svpm(a_gpn(selx1,sely1));
    END;
  END;
END;

// a_tdegm: Test and display end game messa-
// ges.
// Copyright © Rafael Pérez.
// rperezrosario@outlook.com.

EXPORT a_tdegm()
BEGIN
 /// Five (5) ocurrences of the same position
 /// automatically yield a draw (2014 Inter-
 /// national Chess Federation rule amend-
 /// ment.) Three (3) ocurrences, previously.
  IF ftr5==1 AND a_fosp() THEN
    MSGBOX("Draw. (Five (5) ocurrences "+
      "of the same position rule.)");
    //a_Chess_Dev();
    KILL;
  ELSE
 /// Seventy-five (75) moves without pawn
 /// move or capture automatically yield a
 /// draw (2014 International Chess Federa-
 /// tion rule amendment.) Fifty (50) mo-
 /// ves, previously.
    IF ftr75==1 AND a_sfmwpmoc() THEN
      MSGBOX("Draw. (Seventy-five (75) "+
        "moves without pawn move or "+
        "capture rule.)");
      //a_Chess_Dev();
      KILL;
    ELSE
 /// If either king is put in check, no-
 /// tify player(s). Chess rules impli-
 /// citly only allow either king to be
 /// in check in a given turn. I.e., if
 /// the black king is in check, then the
 /// white king cannot be, and vice-
 /// versa.
      IF ftrkic==1 AND
        a_iskic("b",false) THEN
        IF a_tapmfkcb("b") THEN
          MSGBOX("Check Black.");
        ELSE
          MSGBOX("Checkmate, White wins!");
          //a_Chess_Dev();
          KILL;
        END;
      ELSE
        IF ftrkic==1 AND
          a_iskic("w",false) THEN
          IF a_tapmfkcb("w") THEN
            MSGBOX("Check White.");
          ELSE
            MSGBOX("Checkmate, Black wins!");
            //a_Chess_Dev();
            KILL;
          END;
        ELSE
 /// Check for stalemate. The player
 /// whose turn it is to move has no
 /// legal moves left and is not in
 /// check.
          IF ftrsm==1 AND a_sm() THEN
            MSGBOX("Draw. (Stalemate, not "+
              "in check, and no legal "+
              "moves available.)");
            //a_Chess_Dev();
            KILL;
          END;
 /// Check for no pieces left of a
 /// color for Black vs. White no
 /// valid move or king check or
 /// mate features ("Free for all.")
          IF ftrvm==2 AND ftrkic==2 THEN
            a_lrp("w");
            IF tpscnt==0 THEN
              MSGBOX("Black wins. "+
                "No more white pieces");
              //a_Chess_Dev();
              KILL;
            END;
            a_lrp("b");
            IF tpscnt==0 THEN
              MSGBOX("White wins. "+
                "No more black pieces");
              //a_Chess_Dev();
              KILL;
            END;
          END;
        END;
      END;
    END;
  END;
END;

// a_ugs: Update game state.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

EXPORT a_ugs()
BEGIN
 /// Selected position state index.
  LOCAL ssi=a_gsi(selx1,sely1);
 /// Move types.
  CASE
 /// If it's a pawn double-forward move,
 /// and the target is between one or two
 /// opposing pawns, then set active possi-
 /// ble en passant information.
    IF a_ispw(tstate(ssi,1),tstate(ssi,2))
      AND ABS(prcy1-sely1)==sqsz*2 THEN
      IF a_isoppw(a_gpc(tstate(ssi,3)),
        prcx1-sqsz,prcy1) THEN
 /// Opposing pawn on the left.
        aepli:=a_gsi(wmid-(prcx1-wmid),
          hmid-((prcy1+sqsz)-hmid)-1);
        aepmv:=mvcnt+1;
      END;
      IF a_isoppw(a_gpc(tstate(ssi,3)),
        prcx1+sqsz,prcy1) THEN
 /// Opposing pawn on the right.
        aepri:=a_gsi(
          wmid-((prcx1+(sqsz*2))-wmid),
          hmid-((prcy1+sqsz)-hmid)-1);
        aepmv:=mvcnt+1;
      END;
 /// Add move to moves list.
      a_am(a_gpn(selx1,sely1),
      a_gsi(selx1,sely1),
      a_gsi(prcx1,prcy1),
      a_gpn(prcx1,prcy1));
 /// Update table state.
      tstate(a_gsi(prcx1,prcy1),3):=
        tstate(ssi,3);
      tstate(ssi,3):="";
    END;
 /// En passant capture,
    IF a_isepc() THEN
 /// Coordinates registered.
 /// Add move to moves list.
      a_am(a_gpn(selx1,sely1),
        a_gsi(selx1,sely1),
        a_gsi(prcx1,prcy1),
        a_gpn(epcx1,epcy1));
 /// Update table state.
 /// Capturing pawn.
      tstate(a_gsi(prcx1,prcy1),3):=
        tstate(ssi,3);
      tstate(a_gsi(selx1,sely1),3):="";
 /// Captured pawn.
      tstate(a_gsi(epcx1,epcy1),3):="";
 /// Clear en passant capture
 /// coordinates.
      a_cepcc();
    END;
 /// Castle moves.
    IF a_iscm(selx1,sely1,prcx1) THEN
      IF a_islcm(selx1,sely1,prcx1) THEN
 /// Left castle move.
 /// Add move to moves list.
        a_am(a_gpn(selx1,sely1),
          a_gsi(selx1,sely1),
          a_gsi(prcx1,prcy1),
          a_gpn(prcx1,prcy1));
 /// Update table state.
 /// King two posisions to the left.
        tstate(a_gsi(prcx1,prcy1),3):=
          tstate(ssi,3);
        tstate(ssi,3):="";
 /// Rook to the king's right.
        tstate(a_gsi(prcx1+sqsz,prcy1),3):=
          tstate(a_gsi(wmid-(sqsz*4),
          prcy1),3);
        tstate(a_gsi(wmid-(sqsz*4),
          prcy1),3):="";
      ELSE
 /// Right castle move.
        IF a_isrcm(selx1,sely1,prcx1) THEN
 /// Add move to moves list.
          a_am(a_gpn(selx1,sely1),
            a_gsi(selx1,sely1),
            a_gsi(prcx1,prcy1),
            a_gpn(prcx1,prcy1));
 /// Update table state.
 /// King two positions to the right.
          tstate(a_gsi(prcx1,prcy1),3):=
            tstate(ssi,3);
          tstate(ssi,3):="";
 /// Rook to the king's left.
          tstate(a_gsi(prcx1-sqsz,prcy1),3):=
            tstate(a_gsi(wmid+(sqsz*3),
            prcy1),3);
          tstate(a_gsi(wmid+(sqsz*3),
            prcy1),3):="";
        END;
      END;
    END;
 /// Black pawn promotion to queen.
    IF a_isbpw(selx1,sely1) AND prcy1==yorg
      THEN
 /// Add move to moves list.
      a_am(a_gpn(selx1,sely1),
        a_gsi(selx1,sely1),
        a_gsi(prcx1,prcy1),
        a_gpn(prcx1,prcy1));
 /// Update table state.
      tstate(a_gsi(prcx1,prcy1),3):="bqn";
      tstate(ssi,3):="";
    END;
 /// White pawn promotion to queen.
    IF a_iswpw(selx1,sely1) AND prcy1==yorg
      THEN
 /// Add move to moves list.
      a_am(a_gpn(selx1,sely1),
        a_gsi(selx1,sely1),
        a_gsi(prcx1,prcy1),
        a_gpn(prcx1,prcy1));
 /// Update table state.
      tstate(a_gsi(prcx1,prcy1),3):="wqn";
      tstate(ssi,3):="";
    END;
    DEFAULT
 /// Regular move or capture.
 /// Add move to moves list.
    a_am(a_gpn(selx1,sely1),
      a_gsi(selx1,sely1),
      a_gsi(prcx1,prcy1),
      a_gpn(prcx1,prcy1));
 /// Update table state.
    tstate(a_gsi(prcx1,prcy1),3):=
      tstate(ssi,3);
    tstate(ssi,3):="";
  END;
 /// Clear allowed moves.
  a_cam();
 /// If expired, clear active possible en
 /// passant move information.
  IF mvcnt>aepmv THEN
    aepli:=-1;
    aepri:=-1;
    aepmv:=-1;
  END;
 /// Add updated state to history.
  IF ftr5==1 THEN
    a_atsthi(tstate);
  END;
 /// Test and display end game messages.
  a_tdegm();
 /// Handle game-type cases.
  CASE
    IF self.gameType==1 THEN /// H. vs. H.
      tdstate:=a_gtstr(tstate);
    END;
    IF self.gameType==2 THEN /// H. vs. B.
      IF a_gctc()=="w" THEN
        tdstate:=a_gtstr(tstate);
      ELSE
        tdstate:=tstate;
      END;
    END;
    IF self.gameType==3 THEN /// H. vs. W.
      IF a_gctc()=="b" THEN
        tdstate:=a_gtstr(tstate);
      ELSE
        tdstate:=tstate;
      END;
    END;
    IF self.gameType==4 THEN /// B. vs. W.
      IF a_gctc()=="w" THEN
        tdstate:=a_gtstr(tstate);
      ELSE
        tdstate:=tstate;
      END;
    END;
    DEFAULT
  END;
 /// Rotate table state.
  tstate:=a_gtstr(tstate);
 /// Reinitialize cursor position.
  IF a_gctc()=="b" THEN
    prcx1:=wmid-sqsz;
  ELSE
    prcx1:=wmid;
  END;
  prcy1:=hlim-(sqsz*2);
END;

// a_mp: Move piece.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

EXPORT a_mp()
BEGIN
  IF ftrvm==1 THEN
 /// If it's a valid move.
    IF a_isvm(selx1,sely1,prcx1,prcy1)
      THEN
 /// Reset cursor.
      selmod:=0;
      prclc:=tgl;
      prcbgc:=tgbg;
 /// Set last move highlight info.
      hlsx1:=selx1;
      hlsy1:=sely1;
      hltx1:=prcx1;
      hlty1:=prcy1;
 /// Rotate last move highlight.
      IF self.gameType==1 OR
        ((self.gameType==2 OR self.gameType==4) AND a_gctc()=="b")
        OR (self.gameType==3 AND a_gctc()=="w") THEN
        hlsx1:=wmid-((hlsx1+sqsz)-wmid);
        hlsy1:=hmid-((hlsy1+sqsz)-hmid)-1;
        hltx1:=wmid-((hltx1+sqsz)-wmid);
        hlty1:=hmid-((hlty1+sqsz)-hmid)-1;
      END;
 /// Update game state.
      a_ugs();
    END;
  ELSE
 /// Reset cursor.
    selmod:=0;
    prclc:=tgl;
    prcbgc:=tgbg;
 /// Set last move highlight info.
    hlsx1:=selx1;
    hlsy1:=sely1;
    hltx1:=prcx1;
    hlty1:=prcy1;
    IF self.gameType==1 OR
      ((self.gameType==2 OR self.gameType==4) AND a_gctc()=="b")
      OR (self.gameType==3 AND a_gctc()=="w") THEN
 /// Rotate last move highlight.
      hlsx1:=wmid-((hlsx1+sqsz)-wmid);
      hlsy1:=hmid-((hlsy1+sqsz)-hmid)-1;
      hltx1:=wmid-((hltx1+sqsz)-wmid);
      hlty1:=hmid-((hlty1+sqsz)-hmid)-1;
    END;
 /// Update game state.
    a_ugs();
  END;
END;

// a_rvap: Random valid action play.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

EXPORT a_rvap()
BEGIN
 /// Remaining piece position states.
  LOCAL rpl=a_lrp(a_gctc());
 /// Selected remaining piece position state.
  LOCAL sps={0,0,"","",false};
 /// Allowed move-to position states.
  LOCAL amps={{0,0,"","",false}};
 /// Allowed move-to position state count.
  LOCAL ampscnt;
 /// Selected move-to state.
  LOCAL smts={0,0,"","",false};

  FOR S FROM 1 TO 1000000 DO
    ampscnt:=0;
 /// Select a remaining piece.
    sps:=rpl(RANDINT(1,tpscnt));
 /// Set valid piece moves.
    selx1:=sps(1);
    sely1:=sps(2);
    a_svpm(sps(3));
 /// Iterate over table state.
    FOR P FROM 1 TO 64 DO
 /// If position state is valid.
      IF tstate(P,5)==true THEN
 /// Increment counter.
        ampscnt:=ampscnt+1;
 /// Add valid position state to list.
        amps(ampscnt):=tstate(P);
      END;
    END;
 /// If there are valid moves for the
 /// selected piece, break loop. Else,
 /// select another random piece.
    IF ampscnt>0 THEN
      BREAK;
    END;
  END;
 /// Select a random move-to position state.
  smts:=amps(RANDINT(1,ampscnt));
 /// Select piece.
  prcx1:=sps(1);
  prcy1:=sps(2);
  a_sp();
 /// Print updated user interface.
  a_pui();
 /// Move piece.
  prcx1:=smts(1);
  prcy1:=smts(2);
  a_mp();
 /// Clear allowed moves.
  a_cam();
END;

// a_svp: Step-value play.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

EXPORT a_svp()
BEGIN
 /// Get remaining pieces.
  LOCAL rp=a_lrp(a_gctc());

 /// For each piece, get valid moves.
  FOR P FROM 1 TO tpscnt DO
 /// For each valid move measure.
 /// 1. (-) By how many opponent pieces
 /// it could be attacked taking into
 /// account the piece's value.
 /// 2. (+) How many and of what value
 /// opponent pieces it could attack
 /// from this position?
 /// 3. (+) If there's an opponent piece
 /// in the position, what is its
 /// value?
 /// 4. (+) How many pieces and of what
 /// value it would be defending from
 /// this position?
 /// 5. (+) In the case of pawns, factor
 /// in the value of reaching the
 /// opponent's start row and making a
 /// queen conversion.
 /// 6. (+) In the case of kings and
 /// rooks, factor-in the value of
 /// castles.
 /// 7. (+) By how many pieces is the
 /// position guarded against attack?
 /// Calculate total for piece-position
 /// keeping the one with the highest num-
 /// ber.
  END;
 /// Perform move.

 /// N.b. This implementation is for search
 /// with depth of one (1) Higher depths will
 /// require running this algorithm to obtain
 /// the opposing player's estimated move and
 /// measuring; repeating for the specified
 /// depth. Biases applied to each measure-
 /// ment could be the basis for a deep ma-
 /// chine learning algorithm that optimizes
 /// them by simulating a number of games or
 /// by playing against a human opponent.
 /// Testing the feasibility of carrying such
 /// calculations on the current hardware
 /// will commence with a depth-1 implementa-
 /// tion.
END;

// a_ap: Agent play.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

EXPORT a_ap()
BEGIN
  IF a_gctc()=="w" THEN
    CASE
      IF aitw==1 THEN a_rvap(); END;
      IF aitw==2 THEN a_svp();  END;
      DEFAULT
    END;
  ELSE
    CASE
      IF aitb==1 THEN a_rvap(); END;
      IF aitb==2 THEN a_svp();  END;
      DEFAULT
    END;
  END;
END;

// a_ppi: Process player input.
// Copyright © Rafael Pérez 2020.
// rperezrosario@outlook.com.

a_ppi:Chess::ProcessPlayerInput(k:key)
BEGIN
 /// Captured keys.
  CASE
    IF key==2 THEN /// Cursor up pressed.
 /// If cursor movement would not exceed
 /// top table limit threshold.
      IF prcy1-sqsz>=yorg THEN
 /// Decrease y1 by one unit.
        prcy1:=prcy1-sqsz;
      END;
    END;
    IF key==8 THEN /// Cursor right pressed.
 /// If cursor movement would not exceed
 /// right table limit threshold.
      IF prcx1+sqsz<xlim THEN
 /// Increase x1 by one unit.
        prcx1:=prcx1+sqsz;
      END;
    END;
    IF key==12 THEN /// Cursor down pressed.
 /// If cursor movement would not exceed
 /// bottom table limit threshold.
      IF prcy1+sqsz<hlim THEN
 /// Increase y1 by one unit.
        prcy1:=prcy1+sqsz;
      END;
    END;
    IF key==7 THEN /// Cursor left pressed.
 /// If cursor movement would not exceed
 /// left table limit threshold.
      IF prcx1-sqsz≥xorg THEN
 /// Decrease x1 by one unit.
        prcx1:=prcx1-sqsz;
      END;
    END;
    IF key==30 THEN /// Enter key pressed.
      IF selmod==1 THEN /// Move piece.
        a_mp();
      ELSE /// Select piece.
        a_sp();
      END;
    END;
    IF key==4 THEN /// Esc key pressed.
 /// Undo selection.
      selmod:=0;
      prclc:=tgl;
      prcbgc:=tgbg;
 /// Clear allowed piece moves.
      a_cam();
    END;
    IF key==0 THEN /// Apps key pressed.
 /// Reset game?
      IF MSGBOX("Reset game?",true)==1 THEN
 /// Re-initialize game state.
        a_igst();
      END;
    END;
    IF key==5 THEN /// Home key pressed.
 /// Quit game?
      IF MSGBOX("Quit game?",true)==1 THEN
 /// Set ∡  mode back to system
 /// settings default.
        AAngle:=0;
 /// Stop program execution.
        KILL;
      END;
    END;
    IF key==1 THEN /// Symb key pressed.
 /// Display feature selection in-game.
      a_sf();
    END;
    DEFAULT
 /// All other keystrokes.
 /// MSGBOX(ck);
  END;
END;

/*
 a_chess: Main program/entry point.
 A chess game implemented on/for the
 HP Prime Graphing Calculator using its
 api and programming language (PGCPL.)
 Copyright © Rafael Pérez 2020.
 rperezrosario@outlook.com.

 The program is structured around the con-
 cept of processing user or intelligent a-
 gent (i.a.) input affecting the game's
 state, and updating the user interface ba-
 sed on said state as the user or i.a. in-
 put loop is consumed by the program. This
 concept is commonly known as the model,
 view, controller (MVC) software design pa-
 ttern.

 The main four (4) program functions are:

 a_chess: Main program/entry point. Calls
          the other main functions, and
          implements and executes the pla-
          yer's and/or i.a.'s input loop.
 a_igst:  Initializes and stores the game's
          current state (model.)
 a_pui:   Prints the game's user interface
          based on the game's current sta-
          te (view.)
 a_ppi:   Processes user or i.a. input and
          affects the game's current state
          accordingly (controller.)
*/

#undef self
#undef property


// Main program.

EXPORT Chess()
begin
    [Chess SelectGameType];

    if Chess.gameType==`Quit` do
        KILL;
    endif

    /// Collect feature information from user.
    a_sf();
    /// Initialize game state.
    a_igst();
    /// Print ui using initial game state.
    a_pui();

    var k:key;
    for I = 1; I <= 1000000; I+=1 do
        switch Chess.gameType
            case `Human vs Human` do
                /// Capture key input.
                key:=WAIT(0);
                [Chess ProcessPlayerInputWithKey: key];
            end
            case `Human vs Black` do
                if a_gctc()=="b" do
                    a_ap(); /// Agent play.
                else
                    key:=WAIT(0);
                    [Chess ProcessPlayerInputWithKey: key];
                endif
            end
            case `Human vs White` do
                if a_gctc()=="w" do
                    a_ap(); /// Agent play.
                else
                    key:=WAIT(0);
                    [Chess ProcessPlayerInputWithKey: key];
                endif
            end
            case `White vs Black` do
                a_ap(); /// Agent play.
            end
            default
        end
        
        /// Print ui using game state updated du-
        /// ring input processing.
        a_pui();
    next
end
