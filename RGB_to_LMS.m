% convert from RGB to LMS space using linear transformation
% Amabis, J.M., Martho, G.R. (2004), Biologia dos Organismos: A 
% diversidade dos seres vivos, São Paulo: Moderna.

function [L,M,S] = RGB_to_LMS(R,G,B)
    mtx = [178824, 435161, 411935;
           345565, 271554, 386714;
           00299566, 0184309, 146709];
       
    lms = mtx*[R;G;B];
    L = lms(1); M=lms(2); S=lms(3);
end 
