program intro_to_defender;
uses defender,crt,graph,dos,variable,init,vga256;
const       pal:array[1..16,1..4] of integer=(
                                         {black}      (0,0,0,0),
                                         {blue}       (1,0,0,31),
                                         {green}      (2,0,31,0),
                                         {cyan}       (3,0,31,31),
                                         {red}        (4,31,0,0),
                                         {magenta}    (5,31,0,31),
                                         {brown}      (6,31,15,0),
                                         {lightgray}  (7,31,31,31),
                                         {darkgray}   (56,15,15,15),
                                         {lightblue}  (57,0,0,63),
                                         {lightgreen} (58,0,63,0),
                                         {lightcyan}  (59,0,63,63),
                                         {lightred}   (60,63,0,0),
                                         {lightmagenta}(61,63,0,63),
                                         {yellow}      (62,63,63,0),
                           		 {white}       (63,63,63,63));
var gd,gm,rd,i,j,k:integer;
    fil:file;
    
procedure ENTER;
begin
repeat
until readkey=#13;
end;
procedure FONDU;
var wp:array[1..16,1..4] of integer;
begin
for i:=1 to 16 do begin
wp[i,1]:=pal[i,1];
wp[i,2]:=pal[i,2];
wp[i,3]:=pal[i,3];
wp[i,4]:=pal[i,4];
end;
for j:=0 to 13 do begin
for i:=2 to 16 do begin
if wp[i,2]>5 then dec(wp[i,2],6);
if wp[i,3]>5 then dec(wp[i,3],6);
if wp[i,4]>5 then dec(wp[i,4],6);
setrgbpalette(wp[i,1],wp[i,2],wp[i,3],wp[i,4]);
end;
end;
cleardevice;
end;
procedure PALREC;
begin
for i:=1 to 16 do begin
setpalette(i-1,pal[i,1]);
setrgbpalette(pal[i,1],pal[i,2],pal[i,3],pal[i,4]);
end;
end;
procedure BFWSHOW;
type vvlbuffer=array[1..17920] of byte;
     vvlb=^vvlbuffer;
var bfw:vvlb;
begin
assign(fil,path+'bfw.def');
new(bfw);
reset(fil,17920);
blockread(fil,bfw^,1,rd);
putimage(getmaxx div 2-150,getmaxy div 2-30,bfw^,0);
enter;
fondu;
palrec;
end;
procedure CHOSE;
{const msg:array[1..2] of string=('DEFENDER','Our Saviour');
      nrmount=3;
var mount:array[1..nrmount,1..5] of integer;
    key:char;
label 1;        }
begin
scrshow('defender');
enter;
{for i:=1 to nrmount do mount[i,1]:=0;
cleardevice;
setlinestyle(0,0,1);
repeat
for i:=1 to nrmount do begin
if mount[i,1]=0 then begin
                     mount[i,2]:=random(getmaxx);
                     mount[i,3]:=random(25)+getmaxy div 2-20;
                     if mount[i,2]<getmaxx div 2 then mount[i,4]:=-(4+random(6));
                     if mount[i,2]>getmaxx div 2 then mount[i,4]:=4+random(6);
                     mount[i,5]:=25;
                     mount[i,1]:=1;
                     end;
if mount[i,1]=1 then begin
                     setcolor(black);
                     moveto(mount[i,2],mount[i,3]);
                     linerel(mount[i,5]+20,mount[i,5]);
                     moveto(mount[i,2],mount[i,3]);
                     linerel(0,mount[i,5]);
                     moveto(mount[i,2],mount[i,3]);
                     linerel(-mount[i,5],mount[i,5]);
                     inc(mount[i,2],mount[i,4]);
                     dec(mount[i,3],3);
                     if mount[i,3] div 10=round(mount[i,3] div 10) then inc(mount[i,5],10);
                     if (mount[i,3]<0) or (mount[i,2]<0) or
                        (mount[i,3]+mount[i,5]>getmaxy)
                                                              then begin
                                                              mount[i,1]:=0;
                                                              goto 1;
                                                              end;
                     setcolor(green);
                     moveto(mount[i,2],mount[i,3]);
                     linerel(mount[i,5]+20,mount[i,5]);
                     moveto(mount[i,2],mount[i,3]);
                     linerel(0,mount[i,5]);
                     moveto(mount[i,2],mount[i,3]);
                     linerel(-mount[i,5],mount[i,5]);
                     1:end;
end;
settextstyle(3,0,0);
setusercharsize(3,1,3,1);
setcolor(white);
outtextxy(100,100,msg[1]);
settextstyle(1,0,0);
setusercharsize(1,1,1,1);
setcolor(yellow);
outtextxy(350,200,msg[2]);
setcolor(lightblue);
moveto(0,getmaxy div 2);
linerel(getmaxx,0);
if keypressed then key:=readkey;
until key='1';}
cls;
{fondu;
palrec;}
end;
label 1;

procedure INITSPRITES;

begin
new(rty1);new(rty2);new(rty3);new(dread);new(space);
new(syr1);new(syr2);new(syr3);new(rpt1);new(rpt2);new(rpt3);
new(flame1);new(flame2);new(flame3);new(flame4);new(flame5);new(flame6);
new(flame7);new(flame8);new(flame9);new(flame10);
new(rok1);new(rok2);new(rok3);new(rok4);new(photon);
new(mis1);new(mis2);new(mis3);new(mis4);
new(mis5);new(mis6);new(mis7);new(mis8);
new(boom1);new(boom2);new(boom3);new(boom4);
new(boom5);new(boom6);new(boom7);
new(bub1);new(bub2);new(bub3);
new(mycon1);new(mycon2);
new(sat1);new(sat2);new(sat3);
new(sold1);new(sold2);new(sold3);
cleardevice;
getimage(0,0,39,19,space^);
assign(fil,path+'vessels.def');
reset(fil,512);
blockread(fil,rty1^,1,rd);
blockread(fil,rty2^,1,rd);
blockread(fil,rty3^,1,rd);
blockread(fil,dread^,1,rd);
blockread(fil,syr1^,1,rd);
blockread(fil,syr2^,1,rd);
blockread(fil,syr3^,1,rd);
blockread(fil,rpt1^,1,rd);
blockread(fil,rpt2^,1,rd);
blockread(fil,rpt3^,1,rd);
close(fil);
assign(fil,path+'flames.def');
reset(fil,128);
blockread(fil,flame1^,1,rd);
blockread(fil,flame2^,2,rd);
blockread(fil,flame3^,2,rd);
blockread(fil,flame4^,3,rd);
blockread(fil,flame5^,3,rd);
blockread(fil,flame6^,3,rd);
blockread(fil,flame7^,4,rd);
blockread(fil,flame8^,4,rd);
blockread(fil,flame9^,4,rd);
blockread(fil,flame10^,4,rd);
close(fil);
assign(fil,path+'rockets.def');
reset(fil,128);
blockread(fil,rok1^,1,rd);
blockread(fil,rok2^,1,rd);
blockread(fil,rok3^,1,rd);
blockread(fil,rok4^,1,rd);
close(fil);
assign(fil,path+'photon.def');
reset(fil,128);
blockread(fil,photon^,1,rd);
close(fil);
assign(fil,path+'missile.def');
reset(fil,256);
blockread(fil,mis1^,1,rd);
blockread(fil,mis2^,1,rd);
blockread(fil,mis3^,1,rd);
blockread(fil,mis4^,1,rd);
blockread(fil,mis5^,1,rd);
blockread(fil,mis6^,1,rd);
blockread(fil,mis7^,1,rd);
blockread(fil,mis8^,1,rd);
close(fil);
assign(fil,path+'boom.def');
reset(fil,512);
blockread(fil,boom1^,1,rd);
blockread(fil,boom2^,1,rd);
blockread(fil,boom3^,1,rd);
blockread(fil,boom4^,1,rd);
blockread(fil,boom5^,1,rd);
blockread(fil,boom6^,1,rd);
blockread(fil,boom7^,1,rd);
close(fil);
assign(fil,path+'bubbles.def');
reset(fil,512);
blockread(fil,bub1^,1,rd);
blockread(fil,bub2^,1,rd);
blockread(fil,bub3^,1,rd);
close(fil);
assign(fil,path+'mycon.def');
reset(fil,512);
blockread(fil,mycon1^,1,rd);
blockread(fil,mycon2^,1,rd);
close(fil);
assign(fil,path+'saturn.def');
reset(fil,512);
blockread(fil,sat1^,1,rd);
blockread(fil,sat2^,1,rd);
blockread(fil,sat3^,1,rd);
close(fil);
assign(fil,path+'soldier.def');
reset(fil,512);
blockread(fil,sold1^,1,rd);
blockread(fil,sold2^,1,rd);
blockread(fil,sold3^,1,rd);
close(fil);
end;

BEGIN

gd:=detect;
initgraph(gd,gm,'c:\bin\bp\bgi');
bfwshow;
initsprites;

initvga;
scrshow('pilot');
enter;
cls;
chose;
closevga;
gd:=detect;
initgraph(gd,gm,'c:\bin\bp\bgi');
1:playgame;
goto 1;

END.

