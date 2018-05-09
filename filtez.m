
%**************************************************************
%filtez: compute predictor output signal (zero section)
%input: bpl1-6 and dlt1-6, output: szl
%**************************************************************%
function y=filtez(bpl,dlt)
zl=0;
       for i=1:6
		zl=zl+bpl(i)*dlt(i);
      end;
y=floor(zl*(2^-14));
