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
    for i=1:size(train_data,2)
        count=sum(strcmp(train_data(:,i),''))+sum(strcmp(test_data(:,i),''));
        name=train_data(1,i);
        fprintf('\n The number of missing values for %s is %d',cell2mat(name),count);
    end
    fprintf('\n');
    
    train_data(1,:)=[];
    train_label(1,:)=[];
    test_data(1,:)=[];
    test_label(1,:)=[];
    monotonic_relationship(train_data,train_label);
    missing_values(train_data,train_label,test_data,test_label);
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
    
    pclass=train_data(:,1);
    [pclass,temp_label]=stand(pclass,train_label);
    discretize(pclass,temp_label,'pclass');
    mutual_Inform(pclass',temp_label','pclass');
    age=train_data(:,4);
    [age,temp_label]=stand(age,train_label);
    discretize(age,temp_label,'age');
    mutual_Inform(age',temp_label','age');
    sibsp=train_data(:,5);
    [sibsp,temp_label]=stand(sibsp,train_label);
    discretize(sibsp,temp_label,'sibsp');
    mutual_Inform(sibsp',temp_label','sibsp');
    fare=train_data(:,8);
    [fare,temp_label]=stand(fare,train_label);
    discretize(fare,temp_label,'fare');
    mutual_Inform(fare',temp_label','fare');
    parch=train_data(:,6);
    [parch,temp_label]=stand(parch,train_label);
    discretize(parch,temp_label,'parch');
    mutual_Inform(parch',temp_label','parch');
    train_label=cell2mat(train_label);
    sex=train_data(:,3);
    mutual_Info(sex,train_label,'sex');
    name=train_data(:,2);
    mutual_Info(name,train_label,'name');
    embark=train_data(:,10);
    mutual_Info(embark,train_label,'embarked');
end
function discretize(data,label,name)
    new_data=data';
    new_label=label';
    un=unique(new_data);
    if size(un,1)<=10
        total=size(new_data,1);
        arr=zeros(size(un,1),1);
         for j=1:size(un,1)
                 arr(j)=sum(new_data== un(j) & new_label==1)/sum(new_data== un(j));
         end
      
        name=strcat('Bar plot for---',name);
        figure('Name',name,'NumberTitle','off');
        bar(un,arr);
    else
        temp1=max(un);
        temp2=min(un);
        width=(temp1-temp2)/10;
        bin=temp2:width:temp1;
        total=size(new_data,1);
        prob=zeros(size(bin',1),1);
        tot=zeros(size(bin',1),1);
        for i=1:total
            ind=ceil(new_data(i)/width);
            if ind==0
                    ind=1;
            end
            if new_label(i)==1
                
                prob(ind)=prob(ind)+1;
                
            end 
            tot(ind)=tot(ind)+1;
        end
        for i=1:size(tot,1)
            prob(i)=prob(i)/tot(i);
        end
        name=strcat('Bar plot for---',name);
        figure('Name',name,'NumberTitle','off');
        bar(bin,prob);
    end
end




