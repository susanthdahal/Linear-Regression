function sequential(x,train_label,x_te,test_label)
    model=[];
    test_model=[];
    xrr=[];
    yrr=[];
    testxrr=[];
    testyrr=[];
    warning('off','all');
    for i=1:10
        max=0;
        for j=1:size(x,2)
            temp=[];
            temp=[model x(:,j)];
            model1 = glmfit(temp,train_label);
            y_tr = glmval(model1,temp,'identity');
            arr=find(y_tr>=0.5);
            tacc=zeros(size(y_tr));
            for k=1:size(arr,1)
               tacc(arr(k))=1;
            end
            acc=sum(tacc==train_label)/size(tacc,1);
            if acc>max
                max=acc;
                best=temp;
                col=j;
                xrr(i)=i;
                yrr(i)=acc;
                temp_test=[];
                temp_test=[test_model x_te(:,j)];
                model1 = glmfit(temp_test,test_label);
                y_te = glmval(model1,temp_test,'identity');
                arr=find(y_te>=0.5);
                tacc=zeros(size(test_label));
                for k=1:size(arr,1)
                  tacc(arr(k))=1;
                end
                acc=sum(tacc==test_label)/size(tacc,1);
                testxrr(i)=i;
                testyrr(i)=acc;
            end
        end
        x(:,col)=[];
        x_te(:,col)=[];
        model=best;
        test_model=temp_test;
    end
    figure('Name','Accuracy against Selected features of Training data','NumberTitle','off');
    plot(xrr,yrr);
    figure('Name','Accuracy against same Selected features of Testing data','NumberTitle','off');
    plot(testxrr,testyrr);
    gradient(model,train_label);
   newton_method(model,train_label)
end