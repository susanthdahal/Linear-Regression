function missing_values(train_data,train_label,test_data,test_label)
    length=size(train_data,1);
    breadth=size(train_data,2);
    x={length,breadth};
    arr=[3 1 8 10 6 5 4];
    b={'' '' 32.995 'S' '' '' NaN};
    train_label=cell2mat(train_label);
    test_label=cell2mat(test_label);
    for i=1:size(arr,2)
        temp=train_data(:,arr(i));
        temp1=test_data(:,arr(i));
        for j=1:length
            if strcmp(temp{j},'')
                x{j,i}=b{i};
            else
                x{j,i}=temp{j};
            end
            if j<=size(test_data,1)
                if strcmp(temp1{j},'')   
                    x_te{j,i}=b{i};
                else
                    x_te{j,i}=temp1{j};
                end
            end
        end
    end
    [x]=encoding(x);
    [x_te]=encoding(x_te);
    x=cell2mat(x);
    x_te=cell2mat(x_te);
    logistic(x,x_te,train_label,test_label);
    parte(x,x_te,train_label,test_label);
    
end    
    
function [x]=encoding(x)
   temp1=x(:,1);
   temp2=x(:,4);
   for i=1:size(x,1)
       if strcmp(temp1(i),'male')
           x{i,1}=1;
       else
           x{i,1}=0;
       end
       if strcmp(temp2(i),'C')
           new_matrix{i,1}=0;
           new_matrix{i,2}=0;
       elseif strcmp(temp2(i),'Q')
           new_matrix{i,1}=1;
           new_matrix{i,2}=0;
       else
           new_matrix{i,1}=0;
           new_matrix{i,2}=1;
       end
   end
   temp=[];
   for i=1:size(x,2)
       if i==4
           temp=[temp new_matrix];
       else
           temp=[temp x(:,i)];
       end
   end
   x=temp;
end

function logistic(x,x_te,train_label,test_label)
    
    for i=1:size(x,2)
        tmean=nanmean(x(:,i));
        sd=nanstd(x(:,i));
        x(:,i)=(x(:,i)-tmean)/sd;
        x_te(:,i)=(x_te(:,i)-tmean)/sd;
    end
    
    model1 = glmfit(x,train_label);
    y_tr = glmval(model1,x,'identity');
    y = glmval(model1,x_te,'identity');
    tempx=x;
    tempx(:,8)=[];
    tempx_te=x_te;
    tempx_te(:,8)=[];
    [model2] = glmfit(tempx,train_label);
    [y_tr2] = glmval(model2,tempx,'identity');
    [y2] = glmval(model2,tempx_te,'identity');
    arr=find((isnan(y)));
    for i=1:size(arr,1)
        y(arr(i))=y2(arr(i));
    end
    arr=find((isnan(y_tr)));
    for i=1:size(arr,1)
        y_tr(arr(i))=y_tr2(arr(i));
    end
    acc=zeros(size(y,1),1);
    arr=find(y>=0.5);
    for i=1:size(arr,1)
       acc(arr(i))=1;
    end
    tacc=zeros(size(y_tr,1),1);
    arr=find(y_tr>=0.5);
    for i=1:size(arr,1)
       tacc(arr(i))=1;
    end
    fprintf('\n\nMultiple model\n');
    fprintf('Train Accuracy =%f \t Test accuracy=%f',sum(tacc==train_label)/size(train_label,1),sum(acc==test_label)/size(test_label,1));
    m=nanmean(x(:,8));
    arr=find(isnan(x(:,8)));
    for i=1:size(arr,1)
        x(arr(i),8)=m;
    end
    m=nanmean(x_te(:,8));
    arr=find(isnan(x_te(:,8)));
    for i=1:size(arr,1)
        x_te(arr(i),8)=m;
    end
    tmean=nanmean(x(:,8));
    sd=nanstd(x(:,8));
    x(:,8)=(x(:,8)-tmean)/sd;
    x_te(:,8)=(x_te(:,8)-tmean)/sd; 
    [model1] = glmfit(x,train_label);
    [y_tr] = glmval(model1,x,'identity');
    [y] = glmval(model1,x_te,'identity');
     acc=zeros(size(y,1),1);
    arr=find(y>=0.5);
    for i=1:size(arr,1)
       acc(arr(i))=1;
    end
    tacc=zeros(size(y_tr,1),1);
    arr=find(y_tr>=0.5);
    for i=1:size(arr,1)
       tacc(arr(i))=1;
    end
    fprintf('\n\nReplacing Values');
    fprintf('\nTrain Accuracy =%f \t Test accuracy=%f',sum(tacc==train_label)/size(train_label,1),sum(acc==test_label)/size(test_label,1));
end

