
% function velKalman(y, u, time)
    Ts = 0.1;

    %set up system for Kalman Filter:
    %x_k+1 = A*x_k + Bw
    %y_k = C*x_k + model measurement noise?
    A = [1 Ts; 0 1];
    B = [Ts; 1];
    C = [1 0];
    
    %acceleration noise:
    sigma_a = 200; %,<-measured based on runs
    w =  sigma_a.*randn(length(y),1);
    
   
    
    Plant = ss(A,B,C,0,-1,'inputname',{'u' 'w'},'outputname','y');
    Q = 1;
    R = 1;
    
    [kalmf,L,P,M] = kalman(Plant,Q,R);
% end

