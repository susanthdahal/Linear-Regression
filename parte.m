function parte(x,x_te,train_label,test_label)
    age=containers.Map('KeyType','int32','ValueType','any');
    fare=containers.Map('KeyType','int32','ValueType','any');
    sorted=sort(x(:,8));
    length=size(x,1);
    breadth=size(x,2);
    binsize=floor(length/10);
    breakpoints=1:binsize:length;
    for i=1:size(breakpoints,2)
         age(i)=sorted(breakpoints(i));       
    end
    sorted=sort(x(:,3));
    for i=1:size(breakpoints,2)
         fare(i)=sorted(breakpoints(i));       
    end
    arr=[2 8 6 7 3];
    for i=1:size(arr,2)
        lab=unique(x(:,arr(i)));
        s=size(lab,1);
        if s>10
            columns(i)=9;
        else
            columns(i)=s-1;
        end
    end
    x=discretize(x,age,fare,arr,columns);
    x_te=discretize(x_te,age,fare,arr,columns);
    x=multiply(x);
    x_te=multiply(x_te);
    temp=[];
    temp1=[];
    for i=1:size(x,2)
        labels=unique(x(:,i));
        total=sum(~isnan(labels));
        if total<2
            temp=temp;
            temp1=temp1;
        else
            temp=[temp x(:,i)];
            temp1=[temp1 x_te(:,i)];
        end
    end
    x=temp;
    x_te=temp1;
    for i=1:size(x,2)
        tmean=nanmean(x(:,i));
        sd=nanstd(x(:,i));
        x(:,i)=(x(:,i)-tmean)/sd;
        x_te(:,i)=(x_te(:,i)-tmean)/sd;
    end 
   fprintf('\n\nThe number of columns in X are %d',size(x,2));
   sequential(x,train_label,x_te,test_label);
   
end

function [x]= discretize(x,age,fare,arr,columns)
    x=[x sqrt(x(:,2)) sqrt(x(:,8)) sqrt(x(:,7)) sqrt(x(:,6)) sqrt(x(:,3))];
    length=size(x,1);
    for j=1:5
        labels=unique(x(:,arr(j)));
        if arr(j)==3
            dict=fare;
        else
            dict=age;
        end
        if size(labels,1)>=10
           new_matrix=zeros(length,columns(j));
           for i=1:length
               bin=findbin(x(i,arr(j)),dict);
               if bin ~=10
                   new_matrix(i,bin)=1;
               end
           end
        else
            new_matrix=zeros(length,columns(j));
            for i=1:length
                bin=find(labels==x(i,arr(j)));
                if bin~=size(labels,1)
                    new_matrix(i,bin)=1;
                end
            end
        end
        x=[x new_matrix];
    end

end
function [bin]=findbin(val,dict)
    v=cell2mat(values(dict));
    v=sort(v);
    l=size(v,2);
    for i=1:l
        if i+1==l
            bin= i-1;
            break;
        elseif val<v(i+1) && val>=v(i)
            bin=i;
            break;
        end
    end
end
function [x]=multiply(x)
    breadth=size(x,2);
    for i=1:breadth
        for j=1:i-1
            x=[x x(:,i).*x(:,j)];
        end 
    end
end