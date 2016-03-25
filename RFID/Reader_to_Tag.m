%This is the code that is used for calculating the bitstream from the
%signal from the reader to the tag.
% The variables 'bitstream' and 'bitstream1' 
%contains the bitstream of the two reader to tag signals. -1 value in the
%bitstream marks the start of delimiter. Any value before it can be
%ignored.


clear all;
A=dlmread('signal');
T1=0; %initialization of variables used for calculation%
TARI=0;
T2=0;
i=1; %loop variables%
j=1;
k=1;
m=1;

delim=0;
threshold=0.3;%threshold for catching signal movement%
thresholdcount=0;

W = pulsewidth(A)
while(i<=2700) %First 2700 elements for the first set of signals%
    B(i)=A(i);
    i=i+1;
end
y=1:2700;

while(k<=2700)
    if(B(k)<threshold & delim==0) %during this condition TARI and 0.5(A+B) is calculated%
        thresholdcount=thresholdcount+1;
        delim=delim+1;
        while(B(k)>threshold) %this while loop runs till end of first preamble%
        k=i+1;
        end
        while(B(k)<=threshold) %this while loop runs till end of first preamble%
        k=k+1;
        end
        n1=k; %marks the end of first preamble based on threshold
        while(B(k)>threshold)
        k=k+1;
        end
        n2=k; % marks the start of first signal %
        for j=n1:n2
            C(j)=B(j);
        end
        [maxv,ind]=max(C);
        display(maxv);
        while(B(k)<=threshold) %marks the start and end of lower pulse%
            k=k+1;
        end
        n3=k;
        for j=n2:n3 %the first zero is captured between n2 and n3%
            C(j)=B(j);
        end
        [minv,ind2]=min(C(n2:n3));
        display(minv);
        ind2=ind2+n2;
        avg=(maxv+minv)/2; %calculation of average of max an min so that it can be used for calculation of TARI%
        k=1;
    else
       k=k+1;
    end    
end  
l=n1;
        if(l < n3) %Capturing of pulse for calculation of TARI%
          while(C(l)<avg)
                l=l+1;
           end
            
            T1=l;
             while(C(l)>avg)
                 l=l+1;
                 end
            T2=l;
            TARI=T2-T1;%Calculation of TARI%
            l=l+1;
            end
for(k=1:numel(B)) %Calculation of average signal that can be used fot the bitstream calculation%
           if(B(k)<=avg)
               pul(k)=0; %This stream of pulses is used for calculation of bitstream%
           elseif(B(k)>avg)
               pul(k)=1;
           end
end
i2=1;
plot(B); hold on;
plot(pul);%plot of avg. pulse versus the main signal%
p1=pulseperiod(pul,'polarity','positive');%internal matlab fn for calculation of positive Pulse period using which the bitstream can be found out%
TARI=p1(1);
for i1=1:numel(p1) %calculation of bitstream based on TARI%
    if(p1(i1)>(2*TARI))
        bitstream(i1)=-1; %-1 indicates the delimiter. So data before the delimiter can be ignored%
        elseif(p1(i1)<=(1.1*TARI))
                bitstream(i1)=0;
            elseif((p1(i1)>(1.2*TARI)) & (p1(i1)<(2*TARI)))
                bitstream(i1)=1; 
            end
    end
D=A(5000:9700); %second set of elements%
for(k=1:numel(D))%Calculation of average data signal based on avg%
           if(D(k)<=avg)
               pul2(k)=0;
           elseif(D(k)>avg) %This stream of pulses is used for calculation of bitstream%
               pul2(k)=1;
           end
end
i4=1;
p4=pulseperiod(pul2,'polarity','positive');
TARI=p1(1);
for i4=1:numel(p4) %Calculation of bitstream based on TARI%
    if(p4(i4)>(2*TARI)) 
        bitstream1(i4)=-1;%-1 marks the delimiter. Any data before it can be ignored%
      
    elseif(p4(i4)<=(1.1*TARI))
                bitstream1(i4)=0;
            elseif((p4(i4)>(1.2*TARI)) & (p4(i4)<(2*TARI)))
                bitstream1(i4)=1;
            end
    end




        
        
        
