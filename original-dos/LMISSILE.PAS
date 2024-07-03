program link_missiles;
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
assign(d,'c:\tp60\defender\missile.def');
rewrite(d,256);
assign(f,'c:\tp60\defender\rk1.zpx');
reset(f,256);
blockread(f,pass^,1,rd);
putimage(0,0,pass^,0);
readln;
blockwrite(d,pass^,1,rd);
close(f);
assign(f,'c:\tp60\defender\rk2.zpx');
reset(f,256);
blockread(f,pass^,1,rd);
putimage(0,0,pass^,0);
readln;
blockwrite(d,pass^,1,rd);
close(f);

assign(f,'c:\tp60\defender\rk3.zpx');
reset(f,256);
blockread(f,pass^,1,rd);
putimage(0,0,pass^,0);
readln;
blockwrite(d,pass^,1,rd);
close(f);

assign(f,'c:\tp60\defender\rk4.zpx');
reset(f,256);
blockread(f,pass^,1,rd);
putimage(0,0,pass^,0);
readln;
blockwrite(d,pass^,1,rd);
close(f);

assign(f,'c:\tp60\defender\rk5.zpx');
reset(f,256);
blockread(f,pass^,1,rd);
putimage(0,0,pass^,0);
readln;
blockwrite(d,pass^,1,rd);
close(f);

assign(f,'c:\tp60\defender\rk6.zpx');
reset(f,256);
blockread(f,pass^,1,rd);
putimage(0,0,pass^,0);
readln;
blockwrite(d,pass^,1,rd);
close(f);

assign(f,'c:\tp60\defender\rk7.zpx');
reset(f,256);
blockread(f,pass^,1,rd);
putimage(0,0,pass^,0);
readln;
blockwrite(d,pass^,1,rd);
close(f);

assign(f,'c:\tp60\defender\rk8.zpx');
reset(f,256);
blockread(f,pass^,1,rd);
putimage(0,0,pass^,0);
readln;
blockwrite(d,pass^,1,rd);
close(f);


close(d);
end.