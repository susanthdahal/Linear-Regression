function mutual_information(train_data,train_label)
    length=size(train_data,1);
    breadth=size(train_data,2);
    for j=1:breadth
        name='pclass';
        new_data=train_data;
        new_label=train_label;
        if size(unique(new_data),1)>10
            [sorted,indices]=sort(new_data);
            label=zeros(size(indices));
            for i=1:size(indices,1)
                label(i)=cell2mat(train_label(indices(i)));
            end
            new_data=sorted;
            new_label=label;
            length=size(new_data,1);
            width=ceil(length/10);
            total=0;
            ind=1;

            for count=1:length
                 lab(ind)=new_label(count);
                 ind=ind+1;
                 if mod(count,width)==0 || count==length
                     p11=histc(lab,1)/(ind-1);
                     p22=histc(lab,0)/(ind-1);
                     if p11~=0 && p22~=0
                        hyx=-(p11*log2(p11)+p22*log2(p22))*((ind-1)/length);
                     end
                     total=total+(hyx);
                     if count==length
                         total=hy-(total);
                         break;
                     end
                     lab=[];
                     ind=1;
                 end
                 
            end
        else
            lab=unique(new_data);
            total=0;
            length=size(new_data,2);
            if isnumeric(lab)
                p1=sum(new_label==1)/length;
                p2=sum(new_label==0)/length;
                hy=-(p1*log2(p1)+p2*log2(p2));
                for i=1:size(lab,2)
                    match = new_data==lab(i);
                    matchSize = sum(match);
                    p11=sum( match & new_label==1)/matchSize;
                    p22=sum( match & new_label==0)/matchSize;
                    p3=sum(new_data==lab(i))/length;
                    if p11~=0 && p22~=0 
                        hyx=-(p11*log2(p11)+p22*log2(p22));
                    end
                    total=total+(hyx)*p3;
                end
                info=hy-total;
            end
            
        end
    end
    fprintf('\n%s',name);
    fprintf('\t%4f',info);
end