%**************************************************************
%quantl: quantize the difference signal in the lower sub-band
%**************************************************************%
    function y = quantl(el,detl)
    table_set;
    % abs of difference signal %
    wd = abs(el);
	% determine mil based on decision levels and detl gain %
    for mil=1:30
        decis = floor(decis_levl(mil)*detl*(2^-15));
        if(wd < decis)
        break;
        end;
    end;
	% if mil=30 then wd is less than all decision levels %

    if(el >= 0) ril = quant26bt_pos(mil);
    else ril = quant26bt_neg(mil);
    end;
    y =ril;
