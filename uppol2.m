%**************************************************************
%uppol2: update second predictor coefficient (pole section)
%inputs: al1, al2, plt, plt1, plt2. outputs: apl2
%**************************************************************%
    function y=uppol2( al1,al2,plt,plt1,plt2)
    wd2 = 4*al1;
    if(plt*plt1 >= 0)
        wd2 = -wd2;
    end;% check same sign %
    wd2 = floor(wd2*(2^-7));                  % gain of 1/128 %
    if( plt*plt2 >= 0) 
        
        wd2 = wd2 + 128;             % same sign case %
    
    else 
        wd2 = wd2 - 128;
    end;
    apl2 = floor(wd2 + (127*al2*(2^-7)));  % leak factor of 127/128 %
	% apl2 is limited to +-.75 %
    if(apl2 > 12288) 
        apl2 = 12288;
    else if(apl2 < -12288) 
            apl2 = -12288;
 
        end;
    end;
    y=apl2;

