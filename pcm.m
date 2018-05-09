%
function pcmcode=pcm(filename,count)


% Opening the file in the read access mode.
fid = fopen (filename,'r');


% Generating the input signal 'm(t)' by reading the binary data in 16 bit
% integer format from the specified file and writing it into a matrix
% 'm(t)'.
m = fread (fid,'int16');

% if the points are more than what read form the file,it would be set to be
% the length of the file.
count=min(max(size(m)),count);

m=m(1:count);

% Calculating maximum value of the input signal 'm(t)'.
Mp = max (m);


% Setting number of bits in a symbol.
bits = 16;


% Defining the number of levels of uniform quantization.
levels = 2^bits;


% Calculating the step size of the quantization.
step_size = (2*Mp)/levels;

% Quantizing the input signal 'm(t)'.
quant_in = m/step_size;

% Indicating the sign of the input signal 'm(t)' and calculating the
% quantized signal 'quant_out'.
signS = sign (m);
S = abs(quant_in)+0.5;
quant_out = signS.*round(S)*step_size;

pcmcode=quant_out;




