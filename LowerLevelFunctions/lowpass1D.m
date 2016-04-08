%%%% Function: lowpass1D
%  This function performs a 1 dimension low pass filtering on a 1
%  dimensional vector using a Gaussian kernel specified by sigma.
%
%  params {data} 1D vector, vector of points to be filtered. 
%  params {sigma} double, used to specify the Gaussian kernel for the
%  filtering. 
%  returns {lpdata} 1D vector containing the filtered data.
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%  This was adapted from the methods orginally written by M. Gershow, C. Fang-Yen and
%  modified by A. Leifer.
%
%%%%%


function lpdata = lowpass1D (data, sigma)
%function lpdata = lowpass1D (data, sigma, varargin)
%lowpasses data with a gaussian filter of width sigma
%
%optional parameter/value pairs
%'padType', pt
%pt is one of 'zeros', 'ends', 'linear', 'mirror'
%
%if padType is zeros, pad ends with zeros
%if padType is 'ends', pad with the values at the end points
%if padType is 'linear' (default), pad(1:kw) = data(1:kw) -
%data(kw) + data(1)
%if padType is 'mirror', pad(1:kw) = 2*data(1) - data(kw:1)
%where kw is kernel width
%
% Written by Marc Gershow
padType = 'linear';
% varargin = assignApplicable(varargin);
g = gaussKernel(sigma);
kw = floor(length(g)/2);
if (size(data,1) < size(data,2))
    data = data';
    transpose = 1;
else
    transpose = 0;
end
lpdata = zeros(size(data));
for k = 1:size(data,2)
    paddeddata = zeros([size(data,1)+2*kw,1]);
    paddeddata((kw+1):end-kw) = data(:,k);
%     switch (padType)
%         case ('ends')
%             paddeddata(1:kw)=data(1, k);
%             paddeddata(end-kw+1:end) = data(end,k);
%         case ('linear')
            paddeddata(1:kw)=data(1:kw, k) + data(1,k) - data(kw,k);
            paddeddata(end - kw + 1:end) = data(end - kw + 1:end,k) + data(end,k) - data(end - kw + 1, k);
%         case ('mirror')
%             paddeddata(1:kw)=2*data(1,k) - data(kw:-1:1, k);
%             paddeddata(end - kw + 1:end) = 2*data(end,k) - data(end:-1:(end - kw + 1),k);
%     end
    lpdata(:,k) = conv2(paddeddata,g','valid');
end
if (transpose)
    lpdata = lpdata';
end