%%%% Function: pairwise sum
%  calculates the pairwise sum of values in a vector
%  out(i) = in(i) + in(i+1)
%
%  params {vector} vector<int,double>, input vector with values to be
%  calculated in pairwise sum
%
%  returns {output} vector<int,double>, output vector containing the
%  pairwise sum.
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%%%%%

function [ output ] = pairwiseSum( vector )


    output = zeros(1,length(vector)-1);
    for i = 1:length(vector)-1
       output(i) = vector(i)+vector(i+1);
    end

end

