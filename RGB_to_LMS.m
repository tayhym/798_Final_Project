% convert from RGB to LMS space using linear transformation
% Amabis, J.M., Martho, G.R. (2004), Biologia dos Organismos: A 
% diversidade dos seres vivos, São Paulo: Moderna.

function [L,M,S] = RGB_to_LMS(R,G,B)
    mtx = [17.8824, 43.5161, 4.11935;
           3.45565, 27.1554, 3.86714;
           0.0299566, 0.184309, 1.46709];
       
    lms = mtx*[R;G;B];
    L = lms(1); M=lms(2); S=lms(3);
end 
