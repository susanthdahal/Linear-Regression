function mutual_Inform(train_data, train_label,name )

H = containers.Map(); 
H('s') = find_Entropy(train_label);
for i = 1:size(train_data,2)
    vect = train_data(:,i);
    tmp = isfinite(vect);
    vect= vect(tmp , :);
    new_train_label = train_label(tmp , :);
   
    key = strcat('s#',name);
    H(key) = condEntropy(vect, new_train_label);
    fprintf('Mutual Information for (survival , %s) = %f\n',name, (H('s') - H(key)));
end   


function [ E ] = condEntropy( vect , train_label)

    [labels, ~, ~] = unique(vect);
    E = 0;
    newvect = zeros(size(vect));
    
    if (size(labels,1) > 10)
        [~, I] = sort(vect);
        width = floor(size(vect,1)/10);
        for i = 1:10
            for j = 1 : width
                newvect(I(width*(i - 1) + j)) = i;
                
            end    
        end    
        
        vect = newvect;
        labels = (1:10)';
    end
    for i=1:size(labels,1)
        match = (vect == labels(i));
        Px = sum(match) / size(vect,1);
        Hy_given_x = find_Entropy(train_label(match, : ));
        E = E + Px*Hy_given_x;
    end    
    

end
function [ E ] = find_Entropy( vect )
    prob = find_Prob(vect);
    E = -sum(prob .* log2(prob));
end


function [ outdata ] = isEmpty( indata )

    outdata = zeros(size(indata));
    for i = 1: size(indata,1)
        
        for k = 1: size(indata,2)
            cell = indata{i,k};
            if ~isstr(cell)
                if isnan(cell)
                    outdata(i,k) = 1;
                end
            end    
        end
    end    
end
function [ prob ] = find_Prob( vect )
    vect= vect(isfinite(vect(:, 1)), :);
    [labels, ~, ~] = unique(vect);
    prob = zeros(size(labels));
    
    for i=1:size(labels,1)
        prob(i) = sum(vect == labels(i));
    end    
    prob = prob ./ size(vect,1);

end
end

    