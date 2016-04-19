function [new_data,new_label,y]=stand(data,label)
    count=1;
    ycount=0;
    new_data=0;
    new_label=0;
    for i=1:size(label,1)
        temp=cell2mat(data(i));
        lab=cell2mat(label(i));
        if lab==1
            ycount=ycount+1;
        end
        if isnumeric(temp)
            new_data(count)=temp;
            new_label(count)=lab;
            count=count+1;
        end
    end
    y=ycount;
end