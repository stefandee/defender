program link_flame;
uses graph;
type buffer=array[1..128] of byte;
     sb=^buffer;
var gd,gm,rd:integer;
    f,d:file;
    pass:sb;
begin
gd:=detect;
initgraph(gd,gm,'c:\tp60\bgi');
new(pass);
assign(d,'c:\tp60\defender\rockets.def');
rewrite(d,128);
assign(f,'c:\tp60\defender\rok1.zpx');
reset(f,128);
blockread(f,pass^,1,rd);
putimage(0,0,pass^,0);
readln;
blockwrite(d,pass^,1,rd);
close(f);
assign(f,'c:\tp60\defender\rok2.zpx');
reset(f,128);
blockread(f,pass^,1,rd);
putimage(0,0,pass^,0);
readln;
blockwrite(d,pass^,1,rd);
close(f);
assign(f,'c:\tp60\defender\rok3.zpx');
reset(f,128);
blockread(f,pass^,1,rd);
putimage(0,0,pass^,0);
readln;
blockwrite(d,pass^,1,rd);
close(f);
assign(f,'c:\tp60\defender\rok4.zpx');
reset(f,128);
blockread(f,pass^,1,rd);
putimage(0,0,pass^,0);
readln;
blockwrite(d,pass^,1,rd);
close(f);


close(d);
end.