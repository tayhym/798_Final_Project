% convert to color space that person can see
% based on type: 1 :protanopia (red blind) 
%                2 :deuteranopia (green blind)
%                3 :tri
function [L,M,S] = color_blind_sight(type,l,m,s)
    if (type==1)
        mtx = [0,  2.02344, -2.52581;
               0,   1,      0;
               0,   0,      1];
    elseif (type==2) 
        mtx = [1, 0, 0;
               0.494207, 0, 1.24827;
               0, 0, 1];
    elseif (type==3)
         mtx = [1, 0, 0;
                0, 1 ,0;
               -0.395913, 0.801109, 0];
    end    
    out = mtx*[l;m;s];
    L = out(1); M = out(2); S = out(3);
end 


    