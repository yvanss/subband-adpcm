

%**************************************************************
%logscl: update the logarithmic quantizer scale factor in lower
%sub-band note that nbl is passed and returned
%**************************************************************%
        function y=logscl(il,nbl)
      table_set;
    wd = floor(nbl * 127*(2^-7));   % leak factor 127/128 %
    nbl = wd + wl_code_table(floor(il*0.25)+1);
    
    if(nbl < 0) 
        nbl = 0;
    else if(nbl > 18432)
            nbl = 18432;
        end;
    end;

       y=floor(nbl);
       
