function mutual_Info(vect, training_label,name )

    H = containers.Map();
    H('s') = find_Entropy(training_label);
    check = isEmpty(vect);
    check = ~check;
    vect = vect(check,:); 
    [~,~, vect] = unique(vect);
    result = training_label(check,:);
   
    key = strcat('s#',name);
    H(key) = condEntropy(vect, result);
    fprintf('Mutual Information for (survival , %s) = %f\n',name, (H('s') - H(key)));
end  

function [ E ] = condEntropy( vect , training_label)
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
        Hy_given_x = find_Entropy(training_label(match, : ));
        E = E + Px*Hy_given_x;
    end    
    

end
function [ E ] = find_Entropy( vect )

    prob = find_prob(vect);
    E = -sum(prob .* log2(prob));
end


function [ output ] = isEmpty( input )

    output = zeros(size(input));
    for i = 1: size(input,1)
        for j = 1: size(input,2)
            cell = input{i,j};
            if ~isstr(cell)
                if isnan(cell)
                    output(i,j) = 1;
                end
            end    
        end
    end    
end
function [ prob ] = find_prob( vect )
    vect= vect(isfinite(vect(:, 1)), :);
    [labels, ~, ~] = unique(vect);
    prob = zeros(size(labels));
    
    for i=1:size(labels,1)
        prob(i) = sum(vect == labels(i));
    end    
    prob = prob ./ size(vect,1);

end
