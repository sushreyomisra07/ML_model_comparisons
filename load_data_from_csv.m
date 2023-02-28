function [data] = load_data_from_csv(file_location, sheet_name)

[~, txt, ~] = xlsread(file_location, sheet_name)

keyset = {'D0', 'D1', 'D2-D3', 'D4-D5', 'None', 'Damage', 'Usable', 'Long Term Unusable', 'Short Term Unusable', 'Parzialmente inagibile'};
valueset = [0, 1, 2, 3, 0, 1, 1, 2, 3, 4];

M = containers.Map(keyset,valueset);

data = zeros(size(txt,1)-1, size(txt,2))

for i = 1:size(data,1)
   ch = cell2mat(txt(i+1,2));
   data(i,1) = M(string(ch(1:end)));
   
   ch = cell2mat(txt(i+1,3));
   data(i,2) = M(string(ch(1:end)));

   ch = cell2mat(txt(i+1,4));
   data(i,3) = M(string(ch(1:end)));

   ch = cell2mat(txt(i+1,5));
   data(i,4) = M(string(ch(1:end)));

   ch = cell2mat(txt(i+1,6));
   data(i,5) = M(string(ch(1:end)));

   ch = cell2mat(txt(i+1,7));
   data(i,6) = M(string(ch(1:end)));
   
   ch = cell2mat(txt(i+1,8));
   data(i,7) = M(string(ch(1:end)));
   
end