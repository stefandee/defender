unit VGA256;

INTERFACE

procedure INITVGA;
procedure SCRSHOW(filename:string);
procedure CEL22(filename:string);
procedure CLOSEVGA;
procedure CLS;
IMPLEMENTATION

type buffer=array[1..800] of byte;
     buf=^buffer;

var screen:array[1..200,1..320] of byte absolute $a000:$0;
    rd,i,j:integer;
    color:array[0..255,1..3] of byte;
    fils,fild:file;
    pass:buf;
procedure xsetcolor(cul:byte;re,gr,blu:byte);
var igr,iblu,ire:byte;

begin
igr:=gr;
ire:=re;
iblu:=blu;
asm
mov ah,$10
mov al,$10
mov bh,0
mov bl,cul
mov ch,igr
mov cl,iblu
mov dh,ire
int 10h
end;
end;

procedure INITVGA;

begin
asm
mov ax,13h
int 10h
mov ax,0a000h
mov es,ax
end;
end;

procedure SCRSHOW;


begin
assign(fils,filename+'.1');
reset(fils,768);
blockread(fils,color,1,rd);
close(fils);
for i:=0 to 255 do xsetcolor(i,color[i,1],color[i,2],color[i,3]);

assign(fils,filename+'.2');
reset(fils,64000);
blockread(fils,screen,1,rd);
close(fils);

end;

procedure CLOSEVGA;

begin
asm
mov ax,3
int 10h
end;
end;

procedure CEL22;

begin
assign(fild,filename+'.2');
assign(fils,filename+'.cel');
rewrite(fild,800);
reset(fils,800);
blockread(fils,pass^,1,rd);
for i:=1 to 80 do begin
blockread(fils,pass^,1,rd);
blockwrite(fild,pass^,1,rd);
end;
close(fils);
close(fild);
assign(fils,filename+'.col');
rename(fils,filename+'.1');
end;

procedure CLS;

begin
xsetcolor(0,0,0,0);
for i:=1 to 200 do
for j:=1 to 320 do
screen[i,j]:=0;
for i:=0 to 255 do xsetcolor(i,0,0,0);
end;
end.
