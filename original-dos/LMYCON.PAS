program link_mycon;
uses graph;
type buffer=array[1..512] of byte;
     sb=^buffer;
var gd,gm,rd:integer;
    f,d:file;
    pass:sb;
begin
gd:=detect;
initgraph(gd,gm,'c:\tp\bgi');
new(pass);
assign(d,'c:\tp\defender\mycon.def');
rewrite(d,512);
assign(f,'c:\tp\defender\mycon.zpx');
reset(f,512);
blockread(f,pass^,1,rd);
putimage(0,0,pass^,0);
readln;
blockwrite(d,pass^,1,rd);
close(f);
assign(f,'c:\tp\defender\mycon1.zpx');
reset(f,512);
blockread(f,pass^,1,rd);
putimage(0,0,pass^,0);
readln;
blockwrite(d,pass^,1,rd);
close(f);
close(d);
end.