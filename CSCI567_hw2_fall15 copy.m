function main()
[num,str]=xlsread('titanic3.xls');
    for i =1:size(num,1)
        for j=1:size(num,2)
            if isnan(num(i,j))
                data{i,j}=cell2mat(str(i,j));
            else
                data{i,j}=num(i,j);
            end
        end
    end
    for i =1:size(num,1)
        for j=size(str,2):size(str,2)
         data{i,j}=cell2mat(str(i,j));
        end
    end
    [train_data,train_label,test_data,test_label]=process_data(data);
    monotonic_relationship(train_data,train_label);
end
function [train_data,train_label,test_data,test_label]=process_data(data)
    ran=randperm(size(data,1));
    length=size(ran,2);
    half=length/2;
    breadth=size(data,2)-1;
    labels=data(:,2);
    data(:,2)=[];
    count=1;
    for i=1:length
        for j=1:breadth
            if ran(i)==1 
                break;
            end
            if count<=half
                train_data{count,j}=cell2mat(data(ran(i),j));

            else
                test_data{count-half,j}=cell2mat(data(ran(i),j));

            end
        end
        if count<=half
            train_label{count}=cell2mat(labels(ran(i)));
        else
            test_label{count-half}=cell2mat(labels(ran(i)));
        end
        if ~(ran(i)==1)
        count=count+1;
        end
    end
    test_label=[labels(1);test_label'];
    train_label=[labels(1);train_label'];
    train_data=[data(1,:);train_data];
    test_data=[data(1,:);test_data];
end

function monotonic_relationship(train_data,train_label)
    train_label(1,:)=[];
    pclass=train_data(:,1);
    age=train_data(:,4);
    discretize(age,train_label);
    sibsp=train_data(:,5);
    discretize(sibsp,train_label);
    fare=train_data(:,6);
    discretize(fare,train_label);
    parch=train_data(:,8);
    discretize(parch,train_label);
end
function discretize(data,label)
    name=cell2mat(data(1,1));
    data(1)=[];
    count=1;
    for i=1:size(data,1)
        temp=cell2mat(data(i));
        lab=cell2mat(label(i));
        if isnumeric(temp)
            new_data(count)=temp;
            new_label(count)=lab;
            count=count+1;
        end
    end
    new_data=new_data';
    new_label=new_label';
    un=unique(new_data);
    if size(un,1)<=10
        total=size(new_data,1);
        arr=zeros(size(un,1),1);
        for i=1:total
            for j=1:size(un,1)
                if new_data(i)== un(j) && new_label(i)==1
                    arr(j)=arr(j)+1;
                end
            end
        end
        arr=arr/total;
        name=strcat('Bar plot for---',name);
        figure('Name',name,'NumberTitle','off');
        bar(un,arr);
    else
        temp1=max(un);
        temp2=min(un);
        width=(temp1-temp2)/10;
        bin=temp2:width:temp1;
%         count=1;
%         for i=1:size(bin,2)-1
%             new_bin(count)=(bin(i)+bin(i+1))/2;
%             count=count+1;
%         end
%         new_bin=new_bin';
        total=size(new_data,1);
        prob=zeros(size(bin',1),1);
        for i=1:total
            if new_label(i)==1
                ind=ceil(new_data(i)/width);
                if ind==0
                    ind=1;
                end
                prob(ind)=prob(ind)+1;
            end 
        end
        prob=prob/total;
        name=strcat('Bar plot for---',name);
        figure('Name',name,'NumberTitle','off');
        bar(bin,prob);
    end
end
