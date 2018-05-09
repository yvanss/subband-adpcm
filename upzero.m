
%**************************************************************
%upzero: inputs: dlt, dlti[0-5], bli[0-5], outputs: updated bli[0-5]
%also implements delay of bli and update of dlti from dlt
%**************************************************************%
  function [dlti,bli]=upzero(dlt,dlti,bli)
    %if dlt is zero, then no sum into bli %
    if  dlt == 0
           for i=1:6
            bli(i) = floor(255*bli(i)*(2^-8)); % leak factor of 255/256 %
           end
    else 
      for i=1:6 
       if(dlt*dlti(i) >= 0)
           wd2 = 128;
       else wd2 = -128;
       end;
       wd3 = floor((255*bli(i)*(2^-8)));    % leak factor of 255/256 %
       bli(i) = wd2 + wd3;
      end;
    end;
	% implement delay line for dlt %
    dlti(6) = dlti(5);
    dlti(5) = dlti(4);
    dlti(4) = dlti(3);
    dlti(3) = dlti(2);
    dlti(2) = dlti(1);
    dlti(1) = dlt;
  