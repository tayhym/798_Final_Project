% convert from RGB to LMS space using linear transformation
% numerical ratios of color transforms taken from
% Amabis, J.M., Martho, G.R. (2004), Biologia dos Organismos: A 
% diversidade dos seres vivos, São Paulo: Moderna.

function [L,M,S] = RGB_to_LMS(R,G,B)
    R = double(R);
    G = double(G);
    B = double(B);
    mtx = [17.8824, 43.5161, 4.11935;
           3.45565, 27.1554, 3.86714;
           0.0299566, 0.184309, 1.46709];
    L = mtx(1,1)*R + mtx(1,2)*G + mtx(1,3)*B;
    M = mtx(2,1)*R + mtx(2,2)*G + mtx(2,3)*B;
    S = mtx(3,1)*R + mtx(3,2)*G + mtx(3,3)*B;
end   