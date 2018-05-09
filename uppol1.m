
%**************************************************************
%uppol1: update first predictor coefficient (pole section)
%inputs: al1, apl2, plt, plt1. outputs: apl1
%**************************************************************%
      function y=uppol1(al1,apl2,plt,plt1)
     wd2 = floor(al1*255*(2^-8));   % leak factor of 255/256 %
    if(plt*plt1 >= 0) 
        apl1 = floor(wd2 + 192);      % same sign case %
      else 
        apl1 = floor(wd2 - 192);
    end;
	% note: wd3= .9375-.75 is always positive %
    wd3 = 15360 - apl2;             % limit value %
    if(apl1 > wd3)
        apl1 = wd3;
    else if(apl1 < -wd3)
            apl1 = -wd3;
        end;
    end;

    y=floor(apl1);
