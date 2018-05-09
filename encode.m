function [il,ih,tqmf,rlt1,rlt2,al1,al2,ah1,ah2,plt1,plt2,ph1,ph2,rh1,rh2,nbh,nbl,deth,detl,delay_bpl, delay_dltx,delay_bph,delay_dhx,el,sl,xl]=encode(xin1,xin2,tqmf,delay_bpl, delay_dltx,delay_bph,delay_dhx,rlt1,rlt2,rh1,rh2,al1,al2,ah1,ah2,plt1,plt2,ph1,ph2,nbh,nbl,detl,deth)

% xa,xb;				% odd and even values %
%  xl,xh;					% low and high bands %
% sh;         			% comes from adaptive predictor %
%    eh;						% hi band error %

%  il,ih;					% encoder outputs %
%   szh,sph,ph,yh;			% high band predictor outputs %
%  szl,spl,sl,el;			% low band predictor outputs %

%BEGIN: Transmit Quadrature Mirror Filter%
     

    xa=0;
    xb=0;
    table_set;
        % first multiply and accumulate %
        % odd and even values
    for i=1:12 
       xa=xa+tqmf(2*i-1)*h(2*i-1);
       xb=xb+tqmf(2*i)*h(2*i);
    end;
  
    for i=12:-1:2
    tqmf(2*i)=tqmf(2*i-2);
    tqmf(2*i-1)=tqmf(2*i-3);
    end
    
    % combine filter outputs to produce hi/lo sub-bands %
    tqmf(2)=xin1;
    tqmf(1)=xin2;
    
    xl = floor((xa + xb)*(2^-15));
    xh = floor((xa - xb)* (2^-15));
    xlout = xl;
%END: Transmit Quadrature Mirror Filter%

%BEGIN: Lo Sub-Band Encoder%
	% compute the predictor output zero section %
	szl = filtez(delay_bpl, delay_dltx);
	% compute the predictor output pole section %
    spl = filtep(rlt1,al1,rlt2,al2);
	% compute the predictor output value %
	sl = szl + spl;
	slout = sl;
	% compute the error signal el(n) %
	el = xl - sl;
	% adaptive quantizer qmplementation %
	il = quantl(el,detl);
	% inverse adaptive quantizer implementation %
	dlt = floor(detl*qq4_code4_table(floor(il*0.25)+1)*(2^-15));
	% quantizer adaptation implementation %
	% first compute the log scaling factor nbl %
	nbl = logscl(il, nbl);
	% then compute the linear scaling factor detl %
	% 8 is a scale factor so that scalel can be used %
	% for the hi-band encoder %
	detl = scalel(nbl,8);
	% adaptive prediction implementation %
	% compute the partial reconstructed signal %
    plt = dlt + szl;
	% update the zero section predictor coefficients %
    [delay_dltx,delay_bpl]=upzero(dlt,delay_dltx,delay_bpl);
	% update second pole section predictor coefficient %
    al2 = uppol2(al1,al2,plt,plt1,plt2);
	% update first pole section predictor coefficient %    
    al1 = uppol1(al1,al2,plt,plt1);
	% compute the quantized recontructed signal for adaptive predic %
    rlt = sl + dlt;
	% implement delays for next time %
    rlt2 = rlt1;
    rlt1 = rlt;
    plt2 = plt1;
    plt1 = plt;
%END: Lo Sub-Band Encoder%
           
%BEGIN: Hi Sub-Band Encoder% 
	% compute the predictor output zero section %
    szh = filtez(delay_bph,delay_dhx);
    % compute the predictor output pole section %
    sph = filtep(rh1,ah1,rh2,ah2);
    % compute the predictor output value %
    sh = sph + szh;
	% compute the error signal eh(n) %
    eh = xh - sh;
	% adaptive quantizer qmplementation %
    if(eh >= 0) 
        ih = 3;     % 2,3 are pos codes %
    
    else 
        ih = 1;     % 0,1 are neg codes %
    end;
 
    decis=floor(564*deth*(2^-15));
    if(abs(eh) > decis) 
        ih=ih-1;
    end;% mih = 2 case %
	% inverse adaptive quantizer implementation %
	;
    dh=floor(deth*qq2_code2_table(ih+1)*(2^-15));
    
 
    
    
    % quantizer adaptation implementation %
	% first compute the log scaling factor nbh %
    nbh = logsch(ih,nbh);
    % then compute the linear scaling factor deth % 
    deth = scalel(nbh,10);
	% adaptive prediction implementation %
	% compute the partial reconstructed signal %
    ph = dh + szh;
     % update the zero section predictor coefficients %
    [delay_dhx,delay_bph]=upzero(dh,delay_dhx,delay_bph);
     % update second pole section predictor coefficient %
    ah2 = uppol2(ah1,ah2,ph,ph1,ph2);
	% update first pole section predictor coefficient %
    ah1 = uppol1(ah1,ah2,ph,ph1);
    % compute the quantized recontructed signal for adaptive predic %
    yh = sh + dh;
	% implement delays for next time %
    rh2 = rh1;
    rh1 = yh;
    ph2 = ph1;
    ph1 = ph;
    
  
%END: Hi Sub-Band Encoder%

   