function v = VarianzaMuestral(Realizaciones,s)
    for j = 1:length(s)  
        g = [s(1,j) s(2,j) s(3,j) s(4,j) s(5,j) s(6,j) s(7,j) s(8,j) s(9,j) s(10,j) s(11,j) s(12,j) ];
        v(j) = var(g);    
    end
end
% function v = VarianzaMuestral(Realizaciones,s)
% k = 0;
% g1=0;
% for j = 1:length(s)  
%     if k < 12
%         for i =1:Realizaciones
%             if k<= Realizaciones-1            
%                 g1 = [g1 s(k+1,j)];
%                  k = k+1;
%             end
%         end
%     end
% end
% v(j) = var(g1); 
% end