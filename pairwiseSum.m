function [ output ] = pairwiseSum( vector )


    output = zeros(1,length(vector)-1);
    for i = 1:length(vector)-1
       output(i) = vector(i)+vector(i+1);
    end

end

