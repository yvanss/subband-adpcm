%**************************************************************
%decode: Input is the output of the encoder
%performs the decoder processing.
%result in xout1 and xout2
%**************************************************************%
function [xout1,xout2,accumc,accumd,dec_del_dltx,dec_del_bpl,dec_del_dhx,dec_del_bph,dec_al1,dec_al2,dec_ah1,dec_ah2,dec_plt1,dec_plt2,dec_ph1,dec_ph2,dec_rlt1,dec_rlt2,dec_detl,dec_nbl,dec_nbh,dec_deth]=decode(il,ih,accumc,accumd,dec_del_bpl,dec_del_dltx,dec_del_bph,dec_del_dhx,dec_rh1,dec_rh2,dec_rlt1,dec_rlt2,dec_al1,dec_al2,dec_ah1,dec_ah2,dec_plt1,dec_plt2,dec_ph1,dec_ph2,dec_detl,dec_nbl,dec_nbh,dec_deth)
table_set;


%Split Received Word into Lo-Band and Hi-Band %
    ilr = il;
    ih = ih;

%BEGIN: Lo Sub-Band Decoder%
	% compute predictor output for zero section %
    dec_szl = filtez(dec_del_bpl,dec_del_dltx);
	% compute predictor output signal for pole section %
    dec_spl = filtep(dec_rlt1,dec_al1,dec_rlt2,dec_al2);
    % compute the predictor output value %
    dec_sl = dec_spl + dec_szl;
	% compute quantized difference signal for adaptive predic %
    dec_dlt = floor(dec_detl*qq4_code4_table(floor(ilr*0.25)+1)*(2^-15));;
	% compute quantized difference signal for decoder output %
    dl = floor(dec_detl*qq6_code6_table(ilr+1)*(2^-15));
    % compute the quantized recontructed signal for adaptive predic %
    rl = dl + dec_sl;
	% quantizer adaptation implementation %
	% first compute the log scaling factor dec_nbl %
    dec_nbl = logscl(ilr,dec_nbl);
	% then compute the linear scaling factor dec_detl %
    dec_detl = scalel(dec_nbl,8);
	% adaptive prediction implementation %
	% compute the partial reconstructed signal %
    dec_plt = dec_dlt + dec_szl;
    % update the zero section predictor coefficients %
    [dec_del_dltx,dec_del_bpl]=upzero(dec_dlt,dec_del_dltx,dec_del_bpl);
    % update second pole section predictor coefficient %
    dec_al2 = uppol2(dec_al1,dec_al2,dec_plt,dec_plt1,dec_plt2);
	% update first pole section predictor coefficient %
    dec_al1 = uppol1(dec_al1,dec_al2,dec_plt,dec_plt1);
    % compute the quantized recontructed signal for adaptive predic %
    dec_rlt = dec_sl + dec_dlt;
	% implement delays for next time %
    dec_rlt2 = dec_rlt1;
    dec_rlt1 = dec_rlt;
    dec_plt2 = dec_plt1;
    dec_plt1 = dec_plt;
%END: Lo Sub-Band Decoder%

%BEGIN: Hi Sub-Band Decoder%
	% compute predictor output for zero section %
    dec_szh = filtez(dec_del_bph,dec_del_dhx);
	% compute predictor output signal for pole section %
    dec_sph = filtep(dec_rh1,dec_ah1,dec_rh2,dec_ah2);
    % compute the predictor output value %
    dec_sh = dec_sph + dec_szh;
	% compute quantized difference signal for adaptive predic %
    dec_dh = floor(dec_deth*qq2_code2_table(ih+1)*(2^-15)) ;
	% quantizer adaptation implementation %
	% first compute the log scaling factor dec_nbh %
    dec_nbh = logsch(ih,dec_nbh);
	% then compute the linear scaling factor dec_deth %
    dec_deth = scalel(dec_nbh,10);
    % adaptive prediction implementation %
	% compute the partial reconstructed signal %
    dec_ph = dec_dh + dec_szh;
    % update the zero section predictor coefficients %
    [dec_del_dhx,dec_del_bph]=upzero(dec_dh,dec_del_dhx,dec_del_bph);
    % update second pole section predictor coefficient %
    dec_ah2 = uppol2(dec_ah1,dec_ah2,dec_ph,dec_ph1,dec_ph2);
 	% update first pole section predictor coefficient %
    dec_ah1 = uppol1(dec_ah1,dec_ah2,dec_ph,dec_ph1);
    % compute the quantized recontructed signal for adaptive predic %
    rh = dec_sh + dec_dh;
 	% implement delays for next time %
    dec_rh2 = dec_rh1;
    dec_rh1 = rh;
    dec_ph2 = dec_ph1;
    dec_ph1 = dec_ph;
%END: Hi Sub-Band Decoder%

%BEGIN: Receive Quadrature Mirror Filter%
    xd = rl - rh;
    xs = rl + rh;

   
    xa1 = floor(xd * h(1));
    xa2 = floor(xs * h(2));
	% main multiply accumulate %
    
    
    for i = 1:11
        xa1=xa1+floor(accumc(i)*h(2*i+1));
        xa2=xa2+floor(accumd(i)*h(2*i+2));
    end;

    xout1 = floor(xa1*(2^-14));
    xout2 = floor(xa2*(2^-14));
	% update delay lines %
       for i=11:-1:2
    accumc(i)=accumc(i-1);
    accumd(i)=accumd(i-1);
       end;
accumc(1)=xd;
accumd(1)=xs;






