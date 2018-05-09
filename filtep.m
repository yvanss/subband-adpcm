%**************************************************************
%filtep: compute predictor output signal (pole section)
%input rlt1-2 and al1-2, output spl
%**************************************************************%
function y= filtep(rlt1,al1,rlt2,al2)
  
    pl = al1*rlt1;
    pl =pl+al2*rlt2;
  y=floor(pl*(2^-14));  


