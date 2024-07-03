UNIT VARIABLE;

INTERFACE

uses graph,dos,crt;

type  normbuffer=array[1..512] of byte;
      shortbuffer=array[1..384] of byte;
      vshortbuffer=array[1..128] of byte;
      buffer=array[1..256] of byte;
      nb=^normbuffer;
      sb=^shortbuffer;
      vsb=^vshortbuffer;
      buf=^buffer;
const nr=44;
      dimx=40;
      dimy=20;
      nrrok=3;
      nrlas=3;
      nrpho=6;
      nrenm=10;
      nrexp=16;
      way:array[1..2,1..nr] of integer=( (1,200,300,400,500,600,800,900,903,1000,1200,1300,1500,1600,2000,2200,2400,
                                          2800,3200,3350,3400,3500,3600,3700,3900,4100,4150,4230,4300,4320,4400,4500,
                                          4570,4600,4730,4780,4950,5010,5100,5232,5300,5387,5450,5600),
                                         (30,55,20,100,35,20,155,50,70,0,235,100,20,60,155,40,100,110,12,150,50,0,50,
                                         160,50,215,200,250,170,150,10,20,89,32,131,43,13,94,169,164,32,100,132,170));
      path='';
var gd,gm,rd,shipx,shipy,endcol,begcol,col,i,j,k,ox:integer;
    rty1,rty2,rty3,syr1,syr2,syr3,space,dread,rpt1,rpt2,rpt3:nb;
    boom1,boom2,boom3,boom4,boom5,boom6,boom7:nb;
    bub1,bub2,bub3,mycon1,mycon2,sat1,sat2,sat3:nb;
    sold1,sold2,sold3:nb;
    flame1,flame2,flame3,flame4,flame5,flame6:sb;
    flame7,flame8,flame9,flame10:nb;
    rok1,rok2,rok3,rok4,photon:vsb;
    mis1,mis2,mis3,mis4,mis5,mis6,mis7,mis8:buf;
    fil:file;
    speed,energy,energycnt:integer;
    key:char;
    shipm:byte;
    shiptype,maxspeed,maxenergy,steer:integer;
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
{enemy variable}
    enemy:array[1..nrenm,1..7] of integer;
    oxant:integer;
    expl:array[1..nrexp,1..6] of integer;
IMPLEMENTATION
END.