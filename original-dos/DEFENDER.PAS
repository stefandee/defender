UNIT DEFENDER;

INTERFACE

uses graph,crt,dos,variable,init;

procedure PLAYGAME;

IMPLEMENTATION

procedure CRUSHSHIP(oxi,oyi:integer);
const nr=300;
var i,px,py,oxf,oyf:integer;
mask:array[1..nr,1..5] of integer;

begin
oxi:=shipx;
oyi:=shipy;
oxf:=oxi+dimx;
oyf:=oyi+dimy;
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

procedure HITSHIP;

begin
for i:=1 to nrenm do
if enemy[i,1]=1 then if (((enemy[i,2]-ox<shipx) and (shipx<enemy[i,2]-ox+30)) or
                        ((enemy[i,2]-ox<shipx+dimx) and (shipx+dimx<enemy[i,2]-ox+30))) and
                        (((enemy[i,3]<shipy) and (shipy<enemy[i,3]+30)) or
                        ((enemy[i,3]<shipy+dimy) and (shipy+dimy<enemy[i,3]+30)))
                        then crushship(shipx,shipy);
end;

procedure MOVEENERGY;

begin
if energy<=maxenergy then begin
                          setfillstyle(1,black);
                          bar(49,370,59+maxenergy+1,380);
                          inc(energycnt);
                          if energycnt>5 then begin
                                              inc(energy,2);
                                              energycnt:=0;
                                              end;
                          setfillstyle(1,lightblue);
                          bar(49,370,58+energy,380);
                          end;
if energy<=0 then crushship(shipx,shipy);
end;

procedure TOLEFT;forward;

procedure TORIGHT;

label 1;{exit if hit}
begin
oxant:=ox;
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
                                  crushship(shipx,shipy);
                                  goto 1;
                                  end;
if getpixel(i,shipy+30+1)=lightgreen then begin
                                     crushship(shipx,shipy);
                                     goto 1;
                                     end;
end;
for i:=shipy-1 to shipy+dimy+1 do begin
if getpixel(shipx-1,i)=lightgreen then begin
                                  crushship(shipx,shipy);
                                  goto 1;
                                  end;
if getpixel(shipx+30-1,i)=lightgreen then begin
                                     crushship(shipx,shipy);
                                     goto 1;
                                     end;
end;
moveenergy;
hitship;
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
               speed:=-speed;
               goto 1;
               end;
until way[1,i]-ox>=getmaxx;
1:end;

procedure TOLEFT;

label 1;{exit if hit}
begin
oxant:=ox;
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
                                  crushship(shipx,shipy);
                                  goto 1;
                                  end;
if getpixel(i,shipy+30+1)=lightgreen then begin
                                     crushship(shipx,shipy);
                                     goto 1;
                                     end;
end;
for i:=shipy-1 to shipy+dimy+1 do begin
if getpixel(shipx-1,i)=lightgreen then begin
                                  crushship(shipx,shipy);
                                  goto 1;
                                  end;
if getpixel(shipx+30-1,i)=lightgreen then begin
                                     crushship(shipx,shipy);
                                     goto 1;
                                     end;
end;
hitship;
moveenergy;
delay(10);
setcolor(black);
i:=col+1;
repeat
line(way[1,i]-ox,350-way[2,i],way[1,i-1]-ox,350-way[2,i-1]);
dec(i);
if i<2 then begin
               left:=false;
               right:=true;
               col:=begcol;
               speed:=-speed;
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

function HITENEMY(oxi,oyi,oxf,oyf:longint):boolean;

label hitfound;
begin
hitenemy:=false;
for j:=1 to nrenm do
if (enemy[j,1]=1) and (enemy[j,2]>ox) and (enemy[j,2]<ox+getmaxx)
                        then if (((enemy[j,2]-ox<oxi) and (oxi<enemy[j,2]-ox+30)) or
                                ((enemy[j,2]-ox<oxf) and (oxf<enemy[j,2]-ox+30))) and
                                (((enemy[j,3]<oyi) and (oyi<enemy[j,3]+30)) or
                                ((enemy[j,3]<oyf) and (oyf<enemy[j,3]+30)))
                                then begin
                                     enemy[j,1]:=0;
                                     setfillstyle(1,black);
                                     bar(enemy[j,2]-oxant,enemy[j,3],enemy[j,2]-oxant+31,enemy[j,3]+31);
                                     for k:=1 to nrexp do
                                     if expl[k,1]=0 then begin
                                                 expl[k,1]:=1;{ocupat}
                                                 expl[k,2]:=enemy[j,2];
                                                 expl[k,3]:=enemy[j,3];
                                                 expl[k,4]:=0;
                                                 expl[k,5]:=21;
                                                 expl[k,6]:=enemy[j,7];
                                                 hitenemy:=true;
                                                 goto hitfound;
                                                 end;
                                     end;{end if}
hitfound:end;

procedure MOVEEXPL;

label endexpl;
begin
for i:=1 to nrexp do
if expl[i,1]=1 then begin
                    setfillstyle(1,black);
                    bar(expl[i,2]-oxant,expl[i,3],expl[i,2]-oxant+31,expl[i,3]+31);
                    inc(expl[i,2],expl[i,6]);
                    inc(expl[i,4]);
                    if expl[i,4]>expl[i,5] then begin
                                                expl[i,1]:=0;
                                                goto endexpl;
                                                end;
                    case expl[i,4] of
                    1,2,3:putimage(expl[i,2]-ox,expl[i,3],boom1^,0);
                    4,5,6:putimage(expl[i,2]-ox,expl[i,3],boom2^,0);
                    7,8,9:putimage(expl[i,2]-ox,expl[i,3],boom3^,0);
                    10,11,12:putimage(expl[i,2]-ox,expl[i,3],boom4^,0);
                    13,14,15:putimage(expl[i,2]-ox,expl[i,3],boom5^,0);
                    16,17,18:putimage(expl[i,2]-ox,expl[i,3],boom6^,0);
                    19,20,21:putimage(expl[i,2]-ox,expl[i,3],boom7^,0);
                    end;
            endexpl:end;
end;

procedure MOVEENEMY;

var manv:integer;
label endenemy;
begin
for i:=1 to nrenm do begin
if enemy[i,1]=0 then begin
                     enemy[i,6]:=random(4); {tipul inamicului}
                     enemy[i,1]:=1; {ocupat}
                     enemy[i,2]:=random(way[1,nr-1]);{ox}
                     enemy[i,3]:=random(300);    {oy}
                     enemy[i,4]:=0;  {sprite-ul curent}
                     enemy[i,5]:=8;
                     manv:=random(2);
                     if manv=0 then enemy[i,7]:=-random(5)+1  {directia}
                               else enemy[i,7]:=random(5)+1;
                     end;
if enemy[i,1]=1 then begin
                     if (enemy[i,2]<ox+getmaxx) and (ox-40<enemy[i,2]) then begin
                                                                         setfillstyle(1,black);
                                                                         bar(enemy[i,2]-oxant,enemy[i,3],enemy[i,2]+
                                                                         -oxant+31,enemy[i,3]+31);
                                                                         inc(enemy[i,4]);
                                                                         if enemy[i,4]>enemy[i,5] then enemy[i,4]:=1;
                                                                         inc(enemy[i,2],enemy[i,7]);
                                                                         if enemy[i,2]>way[1,nr-1] then begin
                                                                                                        enemy[i,1]:=0;
                                                                                                        goto endenemy;
                                                                                                        end;
                                                                         if enemy[i,2]<way[1,1] then begin
                                                                                                     enemy[i,1]:=0;
                                                                                                     goto endenemy;
                                                                                                     end;
                                                                         case enemy[i,6] of
                                                                         0: case enemy[i,4] of
                                                                            1,2,3:putimage(enemy[i,2]-ox,enemy[i,3],bub1^,0);
                                                                            4,5,6:putimage(enemy[i,2]-ox,enemy[i,3],bub2^,0);
                                                                            7,8:putimage(enemy[i,2]-ox,enemy[i,3],bub3^,0);
                                                                            end; {case bubble type}
                                                                         1: putimage(enemy[i,2]-ox,enemy[i,3],mycon1^,0);
                                                                         2: case enemy[i,4] of
                                                                            1,2,8:putimage(enemy[i,2]-ox,enemy[i,3],sat1^,0);
                                                                            3,4,7:putimage(enemy[i,2]-ox,enemy[i,3],sat2^,0);
                                                                            5,6:putimage(enemy[i,2]-ox,enemy[i,3],sat3^,0);
                                                                            end; {case saturn type}
                                                                         3: case enemy[i,4] of
                                                                            1,2,3:putimage(enemy[i,2]-ox,enemy[i,3],sold1^,0);
                                                                            4,5,6:putimage(enemy[i,2]-ox,enemy[i,3],sold2^,0);
                                                                            7,8:putimage(enemy[i,2]-ox,enemy[i,3],sold3^,0);
                                                                            end; {case soldier type}

                                                                         end;{case enemy type}
                                                                 endenemy:end
                                                                    else begin
                                                                         inc(enemy[i,2],enemy[i,7]);
                                                                         if enemy[i,2]>way[1,nr-1] then begin
                                                                                                        enemy[i,1]:=0;
                                                                                                        goto endenemy;
                                                                                                        end;
                                                                         if enemy[i,2]<way[1,1] then begin
                                                                                                     enemy[i,1]:=0;
                                                                                                     goto endenemy;
                                                                                                     end;
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
moveenemy;
moveexpl;
if right=true then toright;
if left=true then toleft;
if keypressed then begin
                   key:=readkey;
                   if controls then begin
                   if upcase(key)='Q' then begin
                                           putimage(shipx,shipy,space^,0);
                                           dec(shipy,steer);
                                           if shipy<0 then shipy:=0;
                                           regs.ah:=$0c;
                                           regs.al:=$02;
                                           intr($21,regs);
                                           end;
                   if upcase(key)='Z' then begin
                                           putimage(shipx,shipy,space^,0);
                                           inc(shipy,steer);
                                           if shipy>getmaxy then shipy:=getmaxy;
                                           regs.ah:=$0c;
                                           regs.al:=$02;
                                           intr($21,regs);
                                           end;
                   if upcase(key)='O' then begin
                                           putimage(shipx,shipy,space^,0);
                                           dec(shipx,steer);
                                           if shipx<0 then shipx:=0;
                                           dec(speed,2);
                                           if speed<=-maxspeed then speed:=-maxspeed
                                                      else begin
                                                           setfillstyle(1,black);
                                                           bar(49,360,58+maxspeed*4,370);
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
                                           inc(shipx,steer);
                                           if shipx+dimx>getmaxx then shipx:=getmaxx-dimx;
                                           inc(speed,2);
                                           if speed>=maxspeed then speed:=maxspeed
                                                      else begin
                                                           setfillstyle(1,black);
                                                           bar(49,360,58+maxspeed*4,370);
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
                                              dec(energy,15);
                                              end;
                                           2: begin {fire pt yehat}
                                              specialfire:=2;
                                              controls:=false;
                                              beamtime:=0;
                                              one:=0;
                                              dec(energy,20);
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
                                              dec(energy,10);
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
                                          if rokcnt=0 then begin
                                                           normalfire:=0;
                                                           end;
                                          goto endrok;
                                          end;
                      if hitenemy(rok[i,2],rok[i,3],rok[i,2]+15,rok[i,3]+10) then begin
                                                                                   rok[i,1]:=0;
                                                                                   rokcnt:=0;
                                                                                   for j:=1 to nrrok do
                                                                                   if rok[j,1]=1 then inc(rokcnt);
                                                                                   if rokcnt=0 then normalfire:=0;
                                                                                   goto endrok;
                                                                                   end;
                       if hitenemy(rok[i,2],rok[i,3]+dimy+5,rok[i,2]+15,rok[i,3]+10+dimy+5) then
                                                                                            begin
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
                      if hitenemy(pho[i,2],pho[i,3],pho[i,2]+15,pho[i,3]+6)
                                               then begin
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
                      inc(las[i,2],35);
                      if las[i,2]>getmaxx then begin
                                               las[i,1]:=0;
                                               lascnt:=0;
                                               for j:=1 to nrlas do
                                               if las[j,1]=1 then inc(lascnt);
                                               if lascnt=0 then normalfire:=0;
                                               goto endlas;
                                               end;
                      if hitenemy(las[i,2],las[i,3]+dimy,las[i,2]+100,las[i,3]+dimy)
                                               then begin
                                               las[i,1]:=0;
                                               lascnt:=0;
                                               for j:=1 to nrlas do
                                               if las[j,1]=1 then inc(lascnt);
                                               if lascnt=0 then normalfire:=0;
                                               goto endlas;
                                               end;
                      if hitenemy(las[i,2],las[i,3],las[i,2]+100,las[i,3])
                                               then begin
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
   1: begin
      putimage(shipx+dimx,shipy+5,flame1^,0);
      if hitenemy(shipx+dimx,shipy+5,shipx+dimx+10,shipy+5+10) then begin
                                                                    end;
      end;
   2: begin
      putimage(shipx+dimx,shipy+5,flame2^,0);
      if hitenemy(shipx+dimx,shipy+5,shipx+dimx+20,shipy+5+10) then begin
                                                                    end;
      end;
   3: begin
      putimage(shipx+dimx,shipy+5,flame3^,0);
      if hitenemy(shipx+dimx,shipy+5,shipx+dimx+30,shipy+5+10) then begin
                                                                    end;
      end;
   4: begin
      putimage(shipx+dimx,shipy+5,flame4^,0);
      if hitenemy(shipx+dimx,shipy+5,shipx+dimx+40,shipy+5+10) then begin
                                                                    end;
      end;
   5: begin
      putimage(shipx+dimx,shipy+5,flame5^,0);
      if hitenemy(shipx+dimx,shipy+5,shipx+dimx+50,shipy+5+10) then begin
                                                                    end;
      end;
   6: begin
      putimage(shipx+dimx,shipy+5,flame6^,0);
      if hitenemy(shipx+dimx,shipy+5,shipx+dimx+60,shipy+5+10) then begin
                                                                    end;
      end;
   7: begin
      putimage(shipx+dimx,shipy+5,flame7^,0);
      if hitenemy(shipx+dimx,shipy+5,shipx+dimx+70,shipy+5+10) then begin
                                                                    end;
      end;
   8: begin
      putimage(shipx+dimx,shipy+5,flame8^,0);
      if hitenemy(shipx+dimx,shipy+5,shipx+dimx+80,shipy+5+10) then begin
                                                                    end;
      end;
   9: begin
      putimage(shipx+dimx,shipy+5,flame9^,0);
      if hitenemy(shipx+dimx,shipy+5,shipx+dimx+80,shipy+5+10) then begin
                                                                    end;
      end;
   10: begin
       putimage(shipx+dimx,shipy+5,flame10^,0);
       if hitenemy(shipx+dimx,shipy+5,shipx+dimx+80,shipy+5+10) then begin
                                                                    end;
       end;
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
   i:=shipx+40;
   repeat
   if hitenemy(i,shipy+6,i+40,shipy+11) then begin
                                             end;
   inc(i,40);
   until i>getmaxx+40;
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
      (miss8[i,3]<0) or (miss8[i,3]+15>350) or hitenemy(miss8[i,2],miss8[i,3],miss8[i,2]+15,miss8[i,3]+15)
                                               then begin
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