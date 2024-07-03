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
steer:=10;
maxenergy:=50;
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
                                           1: begin
                                              putimage(x,y,rty1^,0);
                                              maxspeed:=7;
                                              steer:=10;
                                              maxenergy:=50;
                                              end;
                                           3: begin
                                              putimage(x,y,syr1^,0);
                                              maxspeed:=11;
                                              steer:=5;
                                              maxenergy:=45;
                                              end;
                                           2: begin
                                              putimage(x,y,dread^,0);
                                              maxspeed:=23;
                                              steer:=8;
                                              maxenergy:=60;
                                              end;
                                           4: begin
                                              putimage(x,y,rpt1^,0);
                                              maxspeed:=17;
                                              steer:=12;
                                              maxenergy:=30;
                                              end;
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
                                             rectangle(110,60,140,70);
                                             rectangle(110,75,125,85);
                                             rectangle(110,90,180,100);
                                             setfillstyle(1,lightblue);
                                             bar(110,60,110+maxspeed,70);
                                             bar(110,75,110+steer,85);
                                             bar(110,90,110+maxenergy,100);
                                             setcolor(white);
                                             outtextxy(0,60,'thrust  :');
                                             outtextxy(0,75,'steering:');
                                             outtextxy(0,90,'shield  :');
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
                                             rectangle(110,60,140,70);
                                             rectangle(110,75,125,85);
                                             rectangle(110,90,180,100);
                                             setfillstyle(1,lightblue);
                                             bar(110,60,110+maxspeed,70);
                                             bar(110,75,110+steer,85);
                                             bar(110,90,110+maxenergy,100);
                                             setcolor(white);
                                             outtextxy(0,60,'thrust  :');
                                             outtextxy(0,75,'steering:');
                                             outtextxy(0,90,'shield  :');
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
                                             rectangle(110,60,140,70);
                                             rectangle(110,75,125,85);
                                             rectangle(110,90,180,100);
                                             setfillstyle(1,lightblue);
                                             bar(110,60,110+maxspeed,70);
                                             bar(110,75,110+steer,85);
                                             bar(110,90,110+maxenergy,100);
                                             setcolor(white);
                                             outtextxy(0,60,'thrust  :');
                                             outtextxy(0,75,'steering:');
                                             outtextxy(0,90,'shield  :');
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
                                             rectangle(110,60,140,70);
                                             rectangle(110,75,125,85);
                                             rectangle(110,90,180,100);
                                             setfillstyle(1,lightblue);
                                             bar(110,60,110+maxspeed,70);
                                             bar(110,75,110+steer,85);
                                             bar(110,90,110+maxenergy,100);
                                             setcolor(white);
                                             outtextxy(0,60,'thrust  :');
                                             outtextxy(0,75,'steering:');
                                             outtextxy(0,90,'shield  :');
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
