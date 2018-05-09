
%**************************************************************
%scalel: compute the quantizer scale factor in the lower or upper
%sub-band
%**************************************************************%
            function y= scalel( nbl,shift_constant)
            table_set;
            b=fi(nbl);
            wd1=bitand(uint16(bitshift(b,-6)),uint16(31));
            wd2 = bitshift(b,-11);
           wd3 = bitshift(uint16(ilb_table(wd1+1)),uint16((shift_constant + 1 - wd2)));
           wd3=bitshift(wd3,3);
           y=double(wd3);
