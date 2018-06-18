



folder = '001';
files = dir(strcat(folder, '/*.dcm'));
for file = files'    
    [X, map, alpha, overlays] = dicomread(strcat(folder,'/',file.name));
end

rs = load('sdk/Data/rs.mat');


m1 = rs.rs.mask{1};

%volume = mask1.full();



%last =  mask1(1,1,1)
%r =  mask1(1,1,1)

%for i=1:length(mask1)
 %   %mask1(i,:,:)   
 %   for j=1:length(mask1(i,:,:))
 %       for k=1:length(mask1(i,j,:))
 %           r = mask1(i,j,k);
 %           if (r ~= last)
 %               cell2mat(r)
 %           end
%            last = r;                
 %       end
%    end
%end
