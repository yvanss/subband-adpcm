
%**************************************************************
%logsch: update the logarithmic quantizer scale factor in higher
%sub-band note that nbh is passed and returned
%**************************************************************
function y=logsch(ih,nbh)
table_set;
    wd = floor(nbh*127/128);       % leak factor 127/128 %
    nbh = wd + wh_code_table(ih+1);
    if(nbh < 0) 
        nbh = 0;
    else if(nbh > 22528) 
            nbh = 22528;
        end;
    end;
        y=floor(nbh);
    
