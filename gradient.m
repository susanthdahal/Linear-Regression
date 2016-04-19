function gradient(x,train_label)  
    model=glmfit(x,train_label);
    pred1=glmval(model,x,'identity');
    y=(pred1>=0.5);
    acc=sum(y==train_label)/size(train_label,1);
    acc1=0;
    k=1;
    eta=[0.1 0.02 0.5];
    for j=1:size(eta,2)
        theta=zeros(size(x,2)+1,1);
        temp=ones(size(x,1),1);
        tempx=[temp x];    
        max=0;
        fprintf('\nFor eta = %f\n',eta(j));
        
        for i=1:10000
            temp= tempx*theta;
            h=1./ (1 + exp(-temp));
            g=1/size(tempx,1) .* (tempx' * (h - train_label));
            theta = theta - eta(j) .* g;
            temp= tempx*theta;
            y=(temp>=0.5);
            acc1=sum(y==train_label)/size(train_label,1);
            if i==10 || i==100 || i==500 || i==1000
                fprintf('\n\tIterations=%d Accuracy=%f' ,i,acc1);
            end
        end
       
    end
   
end