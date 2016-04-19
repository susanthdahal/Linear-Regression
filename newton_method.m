function newton_method(x,train_label)
    sigmoid = inline('1.0 ./ (1.0 + exp(-z))');
    theta=zeros(size(x,2)+1,1);
    temp=ones(size(x,1),1);
    tempx=[temp x];
    model=glmfit(x,train_label);
    pred1=glmval(model,x,'identity');
    y=(pred1>=0.5);
    acc=sum(y==train_label)/size(train_label,1);
    for k=1:5
        h = sigmoid(tempx*theta);
        err = h - train_label;
        grad = tempx' * err / size(x,1);
        hess = (repmat(1-h, 1, 11) .* tempx)' * (repmat(h,1, 11) .* tempx) / size(x,1);
        theta = theta - hess\grad;
        y=(h>=0.5);
        acc1=sum(y==train_label)/size(train_label,1);
        converge(k)=acc1;
        if acc1>=acc
            fprintf('\nIterations for newtons method = %d\t Accuracy=%f',k,acc1);
            break;
        end
    end
   
end