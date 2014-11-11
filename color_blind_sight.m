% Matthew Tay
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
%     out = mtx*[l;m;s];
    L = mtx(1,1)*l + mtx(1,2)*m + mtx(1,3)*s;
    M = mtx(2,1)*l + mtx(2,2)*m + mtx(2,3)*s;
    S = mtx(3,1)*l + mtx(3,2)*m + mtx(3,3)*s;

end 


    