QQFF=cell(1,length(posdebhfo));
for jj=1:1:length(posdebhfo)
    if(sum(matt1(posdebhfo(jj):posfinhfo(jj)))>0)
        qqaa=1;
    else
        qqaa=0;
    end
     if(sum(matt2(posdebhfo(jj):posfinhfo(jj)))>0) 
         qqbb=1;
     else
         qqbb=0;
     end
     
     if((qqaa==0)& (qqbb==0))
       QQFF{jj}=' ';  
     end
     if((qqaa==1)&(qqbb==0))
         QQFF{jj}='R';  
     end
     if((qqaa==0)& (qqbb==1))
         QQFF{jj}='FR';  
     end
     if((qqaa==1)&(qqbb==1))
         QQFF{jj}='FR/R';  
     end
     
end
         
        
        
    
    
    