%This is the code that is used for calculating the bitstream from the
%signal from the tag to the reader.
%The variables 'streamm' 
%contains the bitstream of the tag signal. -5 value in the
%'bitstreamm' marks 'v' in the signal. Any value before it can be
%ignored. This tag is same as 'Tag_To_Reader_1.m' except that the start
%and end point of the tag signal is changed

clear all;
A=dlmread('signal');
E=A(9640:10280); %start of Tag Signal 2. The only line that is different from 'Tag_To_Reader_1.m'%
i3=1;
threshold1=0.62;%threshold was chosen based on noise. This threshold is used for the detection of signal movement%
start=0;%initialization of variables used in loop and for calculation.%
maxv1=0;
minv1=0;
ind3=0;
ind4=0;
k1=1;
k2=1;
k3=1;
k4=1;

while(i3<numel(E))
    if(start==0)
        start=start+1;%Calculation of average value of signal is performed below. This avg value is used for calculating the pulse stream which in turn is used for calculating the bitstream%
        while(E(i3)> threshold1)%used to detect the movement of signal%
        i3=i3+1;
        end
        k1=i3;
        while(E(i3)<= threshold1)
        i3=i3+1;
        end
        k2=i3; %marks the start of next wave%
        while(E(i3)> threshold1)%used to capture the sample signal that can be used for avg calculation%
        i3=i3+1;
        end
        k3=i3;
        while(E(i3)<= threshold1)
        i3=i3+1;
        end
    k4=i3;
    [maxv1,ind3]=max(E(k2:k4));%max. value of pulse%
    [minv1,ind4]=min(E(k2:k4));%minimum of value of the starting pulse%
    i3=1;
    ind3=ind3+k2;%undex of min and max used for debugging purpose%
    ind4=ind4+k2;
    avg1=(minv1+maxv1)/2 ;%calculation of average based on max and min of signal. This avg is used to generate a pulse that can be used to generate a bitstream %
    else
    i3=i3+1;    
    end
end
avg3=0.627;%This average was reduced from the actually calculated average to reduce unnecessary fluctuation in the avg. pulse%
for(k=1:numel(E))%generation of pulse that can be used to generate the bitstream%
           if(E(k)<=avg3)
               pul3(k)=0;
           elseif(E(k)>avg3)
               pul3(k)=1;
           end
end
pul4=pul3;%used for debugging purposes. ignore%
F=E;%used for debugging purposes, ignore%
plot(F); hold on;
plot(pul4);%plot of avg pulse versus the main signal%
p9=pulsewidth(pul4,'polarity','negative');%Used to calculate the negative pulse widths. The bitstream can be decoded from this%
per=p9(1);
flag=0;
idxArray = [];%used for debugging purposes,ignore%
flagArray = [];%used for debugging purposes,ignore%
streamm=[]%Signal used to store the bitstream%
for(y=1:numel(p9))
    if(y==6)%v is at 6%
        streamm = [streamm -5];%-5 is used to mark v%
    else
    if(p9(y)>=per-2 && p9(y)<=per+2)%If pulse width is between a certain range, it is 1%
        streamm = [streamm 1];
    elseif(p9(y)>=per/2-2 && p9(y)<=per/2+2)%If pulse width is between a certain range, it is 0%
        if(flag==0)
           streamm = [streamm 0];
            flag=1;%flag used for ignoring consequtive lows which can cause two zeroes%
        elseif(flag==1)
            flag=0;
        end
    end
    end
    idxArray = [idxArray y];%used for debugging purposes,ignore%
    flagArray = [flagArray flag];%used for debugging purposes,ignore%
    
end

idxArray
flagArray     





    
    
