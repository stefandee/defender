UNIT DEFENDER;

INTERFACE

uses graph,crt,dos;
type  normbuffer=array[1..512] of byte;
      shortbuffer=array[1..384] of byte;
      vshortbuffer=array[1..128] of byte;
      buffer=array[1..256] of byte;
      nb=^normbuffer;
      sb=^shortbuffer;
      vsb=^vshortbuffer;
      buf=^buffer;
const nr=29;
      dimx=40;
      dimy=20;
      nrrok=3;
      nrlas=3;
      nrpho=6;
      way:array[1..2,1..nr] of integer=( (1,200,300,400,500,600,800,900,903,1000,1200,1300,1500,1600,2000,2200,2400,
                                          2800,3200,3350,3400,3500,3600,3700,3900,4100,4150,4230,4280),
                                         (30,55,20,100,35,20,155,50,70,0,235,100,20,60,155,40,100,110,12,150,50,0,50,
                                         160,50,215,200,250,170));
var gd,gm,rd,shipx,shipy,endcol,begcol,col,i,j,ox:integer;
    rty1,rty2,rty3,syr1,syr2,syr3,space,dread,rpt1,rpt2,rpt3:nb;
    boom1,boom2,boom3,boom4,boom5,boom6,boom7:nb;
    flame1,flame2,flame3,flame4,flame5,flame6:sb;
    flame7,flame8,flame9,flame10:nb;
    rok1,rok2,rok3,rok4,photon:vsb;
    mis1,mis2,mis3,mis4,mis5,mis6,mis7,mis8:buf;
    fil:file;
    speed:integer;
    key:char;
    shipm:byte;
    shiptype,maxspeed:byte;
    regs:registers;
    exitcode:integer;
    {0-nothin happened,1-esc exit,2-hit ship exit}
    left,right:boolean;
{fire variables}
    specialfire,normalfire,secretfire:byte;
    controls:boolean;
    flamespr:byte;
    rok:array[1..nrrok,1..4] of integer;
    rokcnt:byte;{numara cite rok se afla in rok:array}
    las:array[1..nrlas,1..3] of integer;{coordonatele laserelor pt syreen}
    lascnt:byte;{numara cite las se afla in las:array}
    pho:array[1..nrpho,1..3] of integer;
    phocnt:byte;
    miss8:array[1..8,1..3] of integer;
    miss8cnt:byte;
    allowspecial:boolean;
    beamtime,one:byte;

procedure PLAYGAME;

IMPLEMENTATION

procedure INITVARS;

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
cleardevice;
getimage(0,0,39,19,space^);
assign(fil,'c:\tp60\defender\vessels.def');
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
assign(fil,'c:\tp60\defender\flames.def');
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
assign(fil,'c:\tp60\defender\rockets.def');
reset(fil,128);
blockread(fil,rok1^,1,rd);
blockread(fil,rok2^,1,rd);
blockread(fil,rok3^,1,rd);
blockread(fil,rok4^,1,rd);
close(fil);
assign(fil,'c:\tp60\defender\photon.def');
reset(fil,128);
blockread(fil,photon^,1,rd);
close(fil);
assign(fil,'c:\tp60\defender\missile.def');
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
assign(fil,'c:\tp60\defender\boom.def');
reset(fil,512);
blockread(fil,boom1^,1,rd);
blockread(fil,boom2^,2,rd);
blockread(fil,boom3^,2,rd);
blockread(fil,boom4^,3,rd);
blockread(fil,boom5^,3,rd);
blockread(fil,boom6^,3,rd);
blockread(fil,boom7^,4,rd);
close(fil);
for i:=1 to nrrok do rok[i,1]:=0;
for i:=1 to nrlas do las[i,1]:=0;
for i:=1 to nrpho do pho[i,1]:=0;
allowspecial:=true;
col:=9;
ox:=way[1,col];
begcol:=col;
shipm:=1;
shipx:=20;
shipy:=20;
speed:=7;
exitcode:=0;
left:=false;
right:=true;
controls:=true;
specialfire:=0;{nici un tip};
normalfire:=0;{nici un tip};
end;
procedure INITSHEET;

begin

{setviewport(0,0,getmaxx,getmaxy,clipon);}
settextstyle(0,0,0);
setcolor(white);
outtextxy(0,361,'SPEED:');
setfillstyle(1,lightblue);
bar(49,360,58+4*abs(speed),370);
end;
procedure putint(ox,oy,nr:integer);
var s:string;
    col:integer;
begin
col:=getcolor;
setfillstyle(1,black);
bar(ox,oy,ox+100,oy+50);
str(nr,s);
setcolor(white);
outtextxy(ox,oy,s);
setcolor(col);
end;
procedure SELECTSHIP;

var x,y:integer;
    info:boolean;
begin
x:=getmaxx div 2-20;
y:=getmaxy div 2-20;
info:=false;
shiptype:=1;
maxspeed:=7;
putimage(x,y,rty1^,0);
settextstyle(1,0,0);
setcolor(red);
outtextxy(280,350,'N');
setcolor(white);
outtextxy(300,350,'ext');
setcolor(red);
outtextxy(280,380,'I');
setcolor(white);
outtextxy(290,380,'nfo');
repeat
if keypressed then begin
                   key:=readkey;
                   if upcase(key)='N' then begin
                                           info:=false;
                                           inc(shiptype);
                                           if shiptype>4 then shiptype:=1;
                                           setfillstyle(1,black);
                                           bar(0,0,getmaxx,y+100);
                                           case shiptype of
                                           1:putimage(x,y,rty1^,0);
                                           3:putimage(x,y,syr1^,0);
                                           2:putimage(x,y,dread^,0);
                                           4:putimage(x,y,rpt1^,0);
                                           end;
                                           case shiptype of
                                           1:maxspeed:=7;
                                           3:maxspeed:=11;
                                           2:maxspeed:=23;
                                           4:maxspeed:=17;
                                           end;
                                           end;
                  if upcase(key)='I' then begin
                                          info:=not info;
                           if info=true then case shiptype of
                                          1: begin
                                             setcolor(lightblue);
                                             settextstyle(1,0,0);
                                             outtextxy(250,0,'R-TYPE 2');
                                             settextstyle(0,0,0);
                                             rectangle(500,y+70,510,y+100);
                                             setfillstyle(1,lightblue);
                                             bar(500,y+100-maxspeed,510,y+100);
                                             setcolor(white);
                                             outtextxy(480,y+60,'thrust');
                                             setcolor(yellow);
                                             line(x+10,y-1,x+20,y-20);
                                             outtextxy(x+21,y-21,'twin non guided rocket');
                                             line(x+5,y+10,x-20,y-3);
                                             outtextxy(x-200,y-10,'liquid propellant reactor');
                                             line(x+20,y+15,x-30,y-30);
                                             outtextxy(x-30,y-31,'electric dischargers');
                                             line(x+40,y+10,x+50,y+12);
                                             outtextxy(x+50,y+12,'flame thrower');
                                             line(x+30,y+7,x+50,y+50);
                                             outtextxy(x+50,y+50,'pilot lg');
                                             end; {end case chose}
                                          2: begin
                                             setcolor(lightblue);
                                             settextstyle(1,0,0);
                                             outtextxy(170,0,'Yehat Terminator');
                                             settextstyle(0,0,0);
                                             rectangle(500,y+70,510,y+100);
                                             setfillstyle(1,lightblue);
                                             bar(500,y+100-maxspeed,510,y+100);
                                             setcolor(white);
                                             outtextxy(480,y+60,'thrust');
                                             setcolor(yellow);
                                             line(x+40,y+10,x+50,y+12);
                                             outtextxy(x+50,y+13,'photon cannon');
                                             line(x+25,y+20,x+30,y+50);
                                             outtextxy(x+30,y+50,'antimatter container');
                                             outtextxy(x+30,y+60,'(energy source)');
                                             line(x+35,y+17,x+40,y+30);
                                             outtextxy(x+40,y+30,'long range laser beam');
                                             line(x,y+10,x-40,y+30);
                                             outtextxy(x-150,y+31,'inertialess drive');
                                             outtextxy(x-150,y+41,'(thrust mechanism)');
                                             line(x+30,y+5,x+50,y-30);
                                             outtextxy(x+50,y-40,'pilot lg');
                                             end; {end case chose}
                                          3: begin
                                             setcolor(lightblue);
                                             settextstyle(1,0,0);
                                             outtextxy(160,0,'Syreen Penetrator');
                                             settextstyle(0,0,0);
                                             rectangle(500,y+70,510,y+100);
                                             setfillstyle(1,lightblue);
                                             bar(500,y+100-maxspeed,510,y+100);
                                             setcolor(white);
                                             outtextxy(480,y+60,'thrust');
                                             setcolor(yellow);
                                             line(x+10,y+7,x-20,y-20);
                                             outtextxy(x-50,y-30,'etheric stabilizer');
                                             line(x+15,y+20,x,y+40);
                                             outtextxy(x-30,y+40,'low energy laser beams');
                                             line(x+25,y+10,x+40,y-50);
                                             outtextxy(x+40,y-60,'projection rib');
                                             line(x+40,y+10,x+60,y+30);
                                             outtextxy(x+60,y+30,'sounds amplifier');
                                             end;{end case chose}
                                          4: begin
                                             setcolor(lightblue);
                                             settextstyle(1,0,0);
                                             outtextxy(170,0,'Shofixtyi Raptor');
                                             settextstyle(0,0,0);
                                             rectangle(500,y+70,510,y+100);
                                             setfillstyle(1,lightblue);
                                             bar(500,y+100-maxspeed,510,y+100);
                                             setcolor(white);
                                             outtextxy(480,y+60,'thrust');
                                             setcolor(yellow);
                                             line(x+25,y+10,x+60,y-30);
                                             outtextxy(x+60,y-40,'sensor clusters');
                                             line(x+10,y+6,x-20,y-10);
                                             outtextxy(x-50,y-20,'nuclear power plant');
                                             line(x+7,y+15,x-30,y+30);
                                             outtextxy(x-50,y+30,'nuclear reactor');
                                             line(x+7,y+7,x-50,y-50);
                                             outtextxy(x-200,y-60,'guided homing missile launcher');
                                             end;{end case chose}
                                             end {end case}
                                        else begin
                                             setfillstyle(1,black);
                                             bar(0,0,getmaxx,y+100);
                                             case shiptype of
                                            1:putimage(x,y,rty1^,0);
                                            3:putimage(x,y,syr1^,0);
                                            2:putimage(x,y,dread^,0);
                                            4:putimage(x,y,rpt1^,0);
                                             end;{end case}
                                             end;{end else}
                                          end;{end begin info}
                  end; {end keys chose}
until key=#13;

cleardevice;

end; {end selectship}

procedure TOLEFT;forward;

procedure TORIGHT;

          procedure VERIFY;
          begin
          if i>nr-1 then begin
                         left:=true;
                         right:=false;
                         toleft;
                         end;
          end;
          procedure CRUSHSHIP;
          const nr=300;
          var i,px,py,oxi,oyi,oxf,oyf:integer;
          mask:array[1..nr,1..5] of integer;
          begin
          oxi:=shipx;
          oyi:=shipy;
          oxf:=oxi+70;
          oyf:=oyi+29;
          randomize;
          setfillstyle(1,black);
          bar(oxi,oyi,oxf,oyf);
          px:=10*(oxf-oxi) div 100;
          py:=10*(oyf-oyi) div 100;
          for i:=1 to nr do begin
          mask[i,1]:=random(oxf-oxi-2*px)+oxi+px;
          mask[i,2]:=random(oyf-oyi-2*py)+oyi+py;
          mask[i,5]:=1+random(15);
          if mask[i,1]>=oxi+(oxf-oxi) div 2 then mask[i,3]:=random(7);
          if mask[i,1]<oxi+(oxf-oxi) div 2 then mask[i,3]:=-random(7);
          if mask[i,2]<oyi+(oyf-oyi) div 2 then mask[i,4]:=-random(7);
          if mask[i,2]>=oyi+(oyf-oyi) div 2 then mask[i,4]:=random(7);
          putpixel(mask[i,1],mask[i,2],mask[i,5]);
          end;
          for j:=1 to 16 do begin
          for i:=1 to nr do begin
          putpixel(mask[i,1],mask[i,2],0);
          mask[i,1]:=mask[i,1]+mask[i,3];
          mask[i,2]:=mask[i,2]+mask[i,4];
          putpixel(mask[i,1],mask[i,2],mask[i,5]);
          end;
          end;
          for i:=1 to nr do putpixel(mask[i,1],mask[i,2],0);
          exitcode:=1;
          end;
label 1;{exit if hit}
begin

inc(ox,abs(speed));
if ox>way[1,col] then inc(col);
setcolor(lightgreen);
i:=col-1;
repeat
line(way[1,i]-ox,350-way[2,i],way[1,i+1]-ox,350-way[2,i+1]);
inc(i);
until (way[1,i]-ox>=getmaxx) or (i>=nr-1);
endcol:=i;
for i:=shipx-1 to shipx+dimx+1 do begin
if getpixel(i,shipy-1)=lightgreen then begin
                                  crushship;
                                  goto 1;
                                  end;
if getpixel(i,shipy+30+1)=lightgreen then begin
                                     crushship;
                                     goto 1;
                                     end;
end;
for i:=shipy-1 to shipy+dimy+1 do begin
if getpixel(shipx-1,i)=lightgreen then begin
                                  crushship;
                                  goto 1;
                                  end;
if getpixel(shipx+30-1,i)=lightgreen then begin
                                     crushship;
                                     goto 1;
                                     end;
end;
delay(10);
setcolor(0);
i:=col-1;
repeat
line(way[1,i]-ox,350-way[2,i],way[1,i+1]-ox,350-way[2,i+1]);
inc(i);
if i>nr-1 then begin
               left:=true;
               right:=false;
               col:=endcol;
               goto 1;
               end;
until way[1,i]-ox>=getmaxx;
1:end;
procedure TOLEFT;

          procedure VERIFY;
          begin
          if i<2 then begin
                         right:=true;
                         left:=false;
                         toright;
                         end;
          end;
          procedure CRUSHSHIP;
          const nr=300;
          var i,px,py,oxi,oyi,oxf,oyf:integer;
          mask:array[1..nr,1..5] of integer;
          begin
          oxi:=shipx;
          oyi:=shipy;
          oxf:=oxi+70;
          oyf:=oyi+29;
          randomize;
          setfillstyle(1,black);
          bar(oxi,oyi,oxf,oyf);
          px:=10*(oxf-oxi) div 100;
          py:=10*(oyf-oyi) div 100;
          for i:=1 to nr do begin
          mask[i,1]:=random(oxf-oxi-2*px)+oxi+px;
          mask[i,2]:=random(oyf-oyi-2*py)+oyi+py;
          mask[i,5]:=1+random(15);
          if mask[i,1]>=oxi+(oxf-oxi) div 2 then mask[i,3]:=random(7);
          if mask[i,1]<oxi+(oxf-oxi) div 2 then mask[i,3]:=-random(7);
          if mask[i,2]<oyi+(oyf-oyi) div 2 then mask[i,4]:=-random(7);
          if mask[i,2]>=oyi+(oyf-oyi) div 2 then mask[i,4]:=random(7);
          putpixel(mask[i,1],mask[i,2],mask[i,5]);
          end;
          for j:=1 to 16 do begin
          for i:=1 to nr do begin
          putpixel(mask[i,1],mask[i,2],0);
          mask[i,1]:=mask[i,1]+mask[i,3];
          mask[i,2]:=mask[i,2]+mask[i,4];
          putpixel(mask[i,1],mask[i,2],mask[i,5]);
          end;
          end;
          for i:=1 to nr do putpixel(mask[i,1],mask[i,2],0);
          exitcode:=1;
          end;
label 1;{exit if hit}
begin

dec(ox,abs(speed));
if ox+640<way[1,col] then dec(col);
setcolor(lightgreen);
i:=col+1;
repeat
line(way[1,i]-ox,350-way[2,i],way[1,i-1]-ox,350-way[2,i-1]);
dec(i);
until (abs(ox+640-way[1,i])>=getmaxx) or (i<=2);
begcol:=i;
for i:=shipx-1 to shipx+dimx+1 do begin
if getpixel(i,shipy-1)=lightgreen then begin
                                  crushship;
                                  goto 1;
                                  end;
if getpixel(i,shipy+30+1)=lightgreen then begin
                                     crushship;
                                     goto 1;
                                     end;
end;
for i:=shipy-1 to shipy+dimy+1 do begin
if getpixel(shipx-1,i)=lightgreen then begin
                                  crushship;
                                  goto 1;
                                  end;
if getpixel(shipx+30-1,i)=lightgreen then begin
                                     crushship;
                                     goto 1;
                                     end;
end;
delay(10);
setcolor(0);
i:=col+1;
repeat
line(way[1,i]-ox,350-way[2,i],way[1,i-1]-ox,350-way[2,i-1]);
dec(i);
if i<2 then begin
               left:=false;
               right:=true;
               col:=begcol;
               goto 1;
               end;
until abs(ox+640-way[1,i])>=getmaxx;
1:end;
procedure MOVESHIP;

begin

case shiptype of
1: begin
   inc(shipm);
   if shipm>3 then shipm:=1;
   case shipm of
   1:putimage(shipx,shipy,rty1^,0);
   2:putimage(shipx,shipy,rty2^,0);
   3:putimage(shipx,shipy,rty3^,0);
   end;
   end;
2: begin
   putimage(shipx,shipy,dread^,0);
   end;
3: begin
   inc(shipm);
   if shipm>3 then shipm:=1;
   case shipm of
   1:putimage(shipx,shipy,syr1^,0);
   2:putimage(shipx,shipy,syr2^,0);
   3:putimage(shipx,shipy,syr3^,0);
   end;
   end;
4: begin
   inc(shipm);
   if shipm>3 then shipm:=1;
   case shipm of
   1:putimage(shipx,shipy,rpt1^,0);
   2:putimage(shipx,shipy,rpt2^,0);
   3:putimage(shipx,shipy,rpt3^,0);
   end;
   end;


end;
end;

procedure PLAYGAME;

label endrok,endrok1,endlas,endlas1,endpho,endpho1;
begin

initvars;
selectship;
initsheet;

repeat
moveship;
if right=true then toright;
if left=true then toleft;
if keypressed then begin
                   key:=readkey;
                   if controls then begin
                   if upcase(key)='Q' then begin
                                           putimage(shipx,shipy,space^,0);
                                           dec(shipy,11);
                                           if shipy<0 then shipy:=0;
                                           regs.ah:=$0c;
                                           regs.al:=$02;
                                           intr($21,regs);
                                           end;
                   if upcase(key)='Z' then begin
                                           putimage(shipx,shipy,space^,0);
                                           inc(shipy,11);
                                           if shipy>getmaxy then shipy:=getmaxy;
                                           regs.ah:=$0c;
                                           regs.al:=$02;
                                           intr($21,regs);
                                           end;
                   if upcase(key)='O' then begin
                                           putimage(shipx,shipy,space^,0);
                                           dec(shipx,11);
                                           if shipx<0 then shipx:=0;
                                           dec(speed,2);
                                           if speed<-maxspeed then speed:=-maxspeed
                                                      else begin
                                                           setfillstyle(1,black);
                                                           bar(49,360,58+80,370);
                                                           setfillstyle(1,lightblue);
                                                           bar(49,360,58+4*abs(speed),370);
                                                           end;
                                           if speed<0 then begin
                                                           left:=true;
                                                           right:=false;
                                                           col:=endcol;
                                                           end;
                                           regs.ah:=$0c;
                                           regs.al:=$02;
                                           intr($21,regs);
                                           end;
                   if upcase(key)='P' then begin
                                           putimage(shipx,shipy,space^,0);
                                           inc(shipx,11);
                                           if shipx>getmaxx then shipx:=getmaxx;
                                           inc(speed,2);
                                           if speed>maxspeed then speed:=maxspeed
                                                      else begin
                                                           setfillstyle(1,black);
                                                           bar(49,360,58+80,370);
                                                           setfillstyle(1,lightblue);
                                                           bar(49,360,58+4*abs(speed),370);
                                                           end;
                                           if speed>0 then begin
                                                           left:=false;
                                                           right:=true;
                                                           col:=begcol;
                                                           end;
                                           regs.ah:=$0c;
                                           regs.al:=$02;
                                           intr($21,regs);
                                           end;
                   if (upcase(key)='N') and (allowspecial) then begin
                                           case shiptype of
                                           1: begin {fire pt rtype}
                                              specialfire:=1;
                                              flamespr:=1;
                                              controls:=false;
                                              end;
                                           2: begin {fire pt yehat}
                                              specialfire:=2;
                                              controls:=false;
                                              beamtime:=0;
                                              one:=0;
                                              end;
                                           4: begin
                                              specialfire:=4;
                                              miss8[1,2]:=shipx;
                                              miss8[1,3]:=shipy;
                                              miss8[2,2]:=shipx+dimx div 2;
                                              miss8[2,3]:=shipy;
                                              miss8[3,2]:=shipx+dimx;
                                              miss8[3,3]:=shipy;
                                              miss8[4,2]:=shipx;
                                              miss8[4,3]:=shipy+dimy div 2;
                                              miss8[5,2]:=shipx+dimx;
                                              miss8[5,3]:=shipy+dimy div 2;
                                              miss8[6,2]:=shipx;
                                              miss8[6,3]:=shipy+dimy;
                                              miss8[7,2]:=shipx+dimx div 2;
                                              miss8[7,3]:=shipy+dimy;
                                              miss8[8,2]:=shipx+dimx;
                                              miss8[8,3]:=shipy+dimy;
                                              for i:=1 to 8 do miss8[i,1]:=1;
                                              allowspecial:=false;
                                              miss8cnt:=0;
                                              end;
                                           end;{end case normal}
                                           end;{end if}
                  if upcase(key)='M' then begin
                                          case shiptype of
                                          1: begin
                                             for i:=1 to nrrok do
                                             if rok[i,1]=0 then begin
                                                                 normalfire:=1;
                                                                 rok[i,2]:=shipx;
                                                                 rok[i,3]:=shipy-5;
                                                                 rok[i,4]:=1;
                                                                 rok[i,1]:=1;
                                                                 goto endrok1;
                                                                 end;
                                             endrok1:end;{end case chose}
                                          3: begin
                                             for i:=1 to nrlas do
                                             if las[i,1]=0 then begin
                                                                 normalfire:=3;
                                                                 las[i,2]:=shipx+10;
                                                                 las[i,3]:=shipy;
                                                                 las[i,1]:=1;
                                                                 goto endlas1;
                                                                 end;
                                             endlas1:end;{end case chose}
                                          2: begin
                                             for i:=1 to nrpho do
                                             if pho[i,1]=0 then begin
                                                                 normalfire:=2;
                                                                 pho[i,2]:=shipx+dimx;
                                                                 pho[i,3]:=shipy+10;
                                                                 pho[i,1]:=1;
                                                                 goto endpho1;
                                                                 end;
                                             endpho1:end;{end case chose}
                                         end;{end case}
                                         regs.ah:=$0c;
                                         regs.al:=$02;
                                         intr($21,regs);
                                          end; {end begin}
                                   end;{end controls is true};
                   if key=#27 then exitcode:=2;
                   end
              else key:=#0;
case normalfire of
1: begin
   for i:=1 to nrrok do
   if rok[i,1]=1 then begin
                      setfillstyle(1,black);
                      bar(rok[i,2],rok[i,3],rok[i,2]+15,rok[i,3]+10);
                      bar(rok[i,2],rok[i,3]+dimy+5,rok[i,2]+15,rok[i,3]+10+dimy+5);
                      inc(rok[i,2],8);
                      if rok[i,2]>getmaxx then begin
                                               rok[i,1]:=0;
                                               rokcnt:=0;
                                               for j:=1 to nrrok do
                                               if rok[j,1]=1 then inc(rokcnt);
                                               if rokcnt=0 then normalfire:=0;
                                               goto endrok;
                                               end;
                      inc(rok[i,4]);
                      if rok[i,4]>8 then rok[i,4]:=1;
                      case rok[i,4] of
                      1,7: begin
                         putimage(rok[i,2],rok[i,3],rok1^,0);
                         putimage(rok[i,2],rok[i,3]+dimy+5,rok1^,0);
                         end;
                      2,6: begin
                         putimage(rok[i,2],rok[i,3],rok2^,0);
                         putimage(rok[i,2],rok[i,3]+dimy+5,rok2^,0);
                         end;
                      3,4: begin
                         putimage(rok[i,2],rok[i,3],rok3^,0);
                         putimage(rok[i,2],rok[i,3]+dimy+5,rok3^,0);
                         end;
                      5,8: begin
                         putimage(rok[i,2],rok[i,3],rok4^,0);
                         putimage(rok[i,2],rok[i,3]+dimy+5,rok4^,0);
                         end;
                      end;
                      end;
   endrok:end;
2: begin
   for i:=1 to nrpho do
   if pho[i,1]=1 then begin
                      setfillstyle(1,black);
                      bar(pho[i,2],pho[i,3],pho[i,2]+15,pho[i,3]+6);
                      inc(pho[i,2],15);
                      if pho[i,2]>getmaxx then begin
                                               pho[i,1]:=0;
                                               phocnt:=0;
                                               for j:=1 to nrpho do
                                               if pho[j,1]=1 then inc(phocnt);
                                               if phocnt=0 then normalfire:=0;
                                               goto endpho;
                                               end;
                      putimage(pho[i,2],pho[i,3],photon^,0);
                endpho:end;
      end;{case photon gun for yehat}

3: begin
   for i:=1 to nrlas do
   if las[i,1]=1 then begin
                      setlinestyle(0,0,1);
                      setcolor(black);
                      line(las[i,2],las[i,3],las[i,2]+100,las[i,3]);
                      line(las[i,2],las[i,3]+dimy,las[i,2]+100,las[i,3]+dimy);
                      inc(las[i,2],40);
                      if las[i,2]>getmaxx then begin
                                               las[i,1]:=0;
                                               lascnt:=0;
                                               for j:=1 to nrlas do
                                               if las[j,1]=1 then inc(lascnt);
                                               if lascnt=0 then normalfire:=0;
                                               goto endlas;
                                               end;
                      setcolor(yellow);
                      line(las[i,2],las[i,3],las[i,2]+100,las[i,3]);
                      line(las[i,2],las[i,3]+dimy,las[i,2]+100,las[i,3]+dimy);
                endlas:end;
      end;{case lasers for syreen}
end;{case normal fire}
case specialfire of
1: begin
   case flamespr of
   1:putimage(shipx+dimx,shipy+5,flame1^,0);
   2:putimage(shipx+dimx,shipy+5,flame2^,0);
   3:putimage(shipx+dimx,shipy+5,flame3^,0);
   4:putimage(shipx+dimx,shipy+5,flame4^,0);
   5:putimage(shipx+dimx,shipy+5,flame5^,0);
   6:putimage(shipx+dimx,shipy+5,flame6^,0);
   7:putimage(shipx+dimx,shipy+5,flame7^,0);
   8:putimage(shipx+dimx,shipy+5,flame8^,0);
   9:putimage(shipx+dimx,shipy+5,flame9^,0);
   10:putimage(shipx+dimx,shipy+5,flame10^,0);
   end;
   inc(flamespr);
   if flamespr>10 then begin
                       specialfire:=0;
                       controls:=true;
                       setfillstyle(1,black);
                       bar(shipx+dimx,shipy+5,shipx+dimx+80,shipy+5+10);
                       end;
   end;{flamethrower special fire}
2: begin
   {setcolor(lightblue);
   line(shipx+40,shipy+6,getmaxx,shipy+6);
   line(shipx+40,shipy+11,getmaxx,shipy+11);}
   inc(one);
   if one>6 then one:=0;
   if one>3 then begin
                 setfillstyle(10,cyan);
                 bar(shipx+40,shipy+6,getmaxx,shipy+11);
                 end
            else begin
                 setfillstyle(11,cyan);
                 bar(shipx+40,shipy+6,getmaxx,shipy+11);
                 end;
   inc(beamtime);
   if beamtime>30 then begin
                        specialfire:=0;
                        controls:=true;
                        setfillstyle(1,black);
                        bar(shipx+40,shipy+6,getmaxx,shipy+11);
                        end;
   end;{end case yehat special}
4: begin
   setfillstyle(1,black);
   for i:=1 to 8 do
   if miss8[i,1]=1 then bar(miss8[i,2],miss8[i,3],miss8[i,2]+15,miss8[i,3]+15);
   dec(miss8[1,2],8);dec(miss8[1,3],8);
   dec(miss8[2,3],8);
   inc(miss8[3,2],8);dec(miss8[3,3],8);
   dec(miss8[4,2],8);
   inc(miss8[5,2],8);
   dec(miss8[6,2],8);inc(miss8[6,3],8);
   inc(miss8[7,3],8);
   inc(miss8[8,2],8);inc(miss8[8,3],8);
   for i:=1 to 8 do
   if miss8[i,1]=1 then if (miss8[i,2]<0) or (miss8[i,2]+15>getmaxx) or
      (miss8[i,3]<0) or (miss8[i,3]+15>350) then begin
                                                  inc(miss8cnt);
                                                  miss8[i,1]:=0;
                                                  if miss8cnt=8 then begin
                                                                     specialfire:=0;
                                                                     allowspecial:=true;
                                                                     end;
                                                  end
                                             else case i of
                                                  1:putimage(miss8[1,2],miss8[1,3],mis4^,0);
                                                  2:putimage(miss8[2,2],miss8[2,3],mis7^,0);
                                                  3:putimage(miss8[3,2],miss8[3,3],mis3^,0);
                                                  4:putimage(miss8[4,2],miss8[4,3],mis6^,0);
                                                  5:putimage(miss8[5,2],miss8[5,3],mis5^,0);
                                                  6:putimage(miss8[6,2],miss8[6,3],mis2^,0);
                                                  7:putimage(miss8[7,2],miss8[7,3],mis8^,0);
                                                  8:putimage(miss8[8,2],miss8[8,3],mis1^,0);
                                                  end;


   end;
end;{end case special fire}
until exitcode<>0;
if exitcode=2 then begin
                   closegraph;
                   gotoxy(1,1);
                   writeln('See you in hell !');
                   halt;
                   end;
end;

END.