%%%% Function: gaussian Kernel
%  This function generates a 1 dimensional gaussian kernel for use in
%  filtering. 
%
%  params {sigma} double, used to specify the Gaussian kernel for the
%  filtering. 
%  returns {g} 1D vector, normalized gaussian 6 sigma in total width, with
%  standard deviation sigma
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%  This was adapted from the methods orginally written by M. Gershow, C. Fang-Yen and
%  modified by A. Leifer.
%
%%%%%

function g = gaussKernel (sigma)

    x = floor(-3*sigma):ceil(3*sigma);
    g = exp(-x.^2/(2 * sigma.^2));
    g = g./sum(g);

end