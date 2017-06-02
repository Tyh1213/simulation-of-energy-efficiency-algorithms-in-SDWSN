clc;
clear;
%�涨�ڵ�1Ϊsink�ڵ�
N=150;      %�ڵ�����
R=150;      %��Чͨ�Ű뾶
D=800;      %������С
global E0;    %�ڵ��ʼ����
E0=5;      %�ڵ��ʼ����
K=7;       %�����ȼ�
T=100;      %����������
simutime=100000;        %����ʱ��
Mode=2;     %��ʾ����ģʽ��0��ʾWRP��1��ʾMES��2��ʾE-TORA��3��ʾEnergy Awared��4��ʾLEACH_C

%Leach��ز���
Round=50;%leach_c��һ��ʱ��
Pac=10;%ÿ10�����ݰ������ں�һ��

State_change=0;%��ʾ�нڵ������ľ�

%ͳ����
R_E=zeros(floor(simutime/1000),2);%����������
R_T=0;                      %ͳ��������ʱ��
death_node=zeros(N,1);      %ͳ�������ڵ�
isolate_node=zeros(N,1);    %ͳ�ƹ����ڵ�

global Node;    %�ڵ�����
global A;    %��ͨ����
global P;    %�ڵ�λ��

%%%��ʼ���ڵ�λ�ú���ͨ����Ϊ��ͳһ���泡�����ڵ�ֲ�����ͬһ�ֲ�
%[A,P]=init(N,R,D);
[A]=xlsread('A',1);
[P]=xlsread('P',1);
%%%��ʼ���ڵ�λ�ú���ͨ����Ϊ��ͳһ���泡�����ڵ�ֲ�����ͬһ�ֲ�

%%%��ʼ���ڵ���Ϣ
Node=zeros(11,N); %1��ʾ�ڵ㵽sink�ڵ��·����2��ʾ�ڵ��sink�ڵ�ľ��룬3��ʾ�ڵ㷢�����ݰ���ʱ�̣�4��ʾ�ڵ㻺��ռ�İ�������
%5��ʾ�ڵ��ʣ��������6��ʾ�ڵ������ȼ���7��ʾ�ڵ������ռ䣬8��ʾ�ڵ��Ƿ�Ϊ��ͷ��1Ϊ��ͷ��0Ϊ��ͨ�ڵ㣩��9��ʾ�ۺϰ��ĸ���,10��ʾ�ڵ�ĸ߶�
%11��ʾ�ڵ�ľ���Σ��ֱ�Ϊ1��2��3

%��ʼ�����ķ���ʱ�̺����������Ϣ
for i=1:1:N
    Node(3,i)=ceil(T*rand(1));
    Node(5,i)=E0;
    Node(6,i)=K;
    Node(7,i)=K;
end

if Mode==2 %E-TORA Э��
    for i=1:1:N
        Node(10,i)=Distance(1,i)/(D/2*sqrt(2));
    end
end

if Mode==4
    for i=2:1:N
        if Distance(1,i)<150
            Node(11,i)=1;
        elseif Distance(1,i)>300
            Node(11,i)=3;
        else
            Node(11,i)=2;
        end
    end
end


%��ʼ��·�ɺͽڵ���sink���룬����Ƿִص�·������·�ɹ�������ɷִص��㷨
Routing(Mode);
%%%��ʼ���ڵ���Ϣ


%%%��ʼ����
for t=1:1:simutime
    
    %%�ж��Ƿ��а�Ҫ����
    for i=2:1:N
        if Node(5,i)>0        %�ڵ�ʣ��������Ϊ0���ҽڵ���·�ɵ�sink�ڵ�
            
            if Node(3,i)==mod(t,T)+1        %�ڵ��а�����
                Node(4,i)=Node(4,i)+1;
            end
            
            if Node(8,i)==1&&Node(4,i)>Pac %�����ں�
                Node(4,i)=Node(4,i)-Pac;
                Node(9,i)=Node(9,i)+1;
            end
                
            %%��ʼ����
            if (Node(4,i)>0&&Node(8,i)~=1&&Node(1,i)~=0)||(Node(9,i)>0&&Node(8,i)==1&&Node(1,i)~=0)
                Dead_node=LeachSend(i,Node(1,i));
                
                %ĳ���нڵ������ľ��ͱ�ʾ���η�����ɺ���Ҫ��Ѱ·
                if Dead_node 
                    State_change=1;
                    
                    %�нڵ������ľ�����ʼͳ�������ڵ�͹����ڵ�,��Ҫ·��֮����ܹ�ͳ�ƹ����ڵ㣬������ʱ�����ǹ����ڵ��ͳ��
                    death_node(N)=0;
                    isolate_node(N)=0;        
                    for j=2:1:N
                        if Node(1,j)==0
                            isolate_node(N)=isolate_node(N)+1;
                        end
                        if Node(5,j)<=0
                            death_node(N)=death_node(N)+1;
                        end            
                    end
                    isolate_node(isolate_node(N)+1)=t;
                    death_node(death_node(N)+1)=t; %ͳ��nʱ�������ڵ������ 
                    %ͳ�������ڵ�͹����ڵ�
                    
                    %�޸����Ӿ���
                    switch Dead_node
                        case 1      %���ͽڵ������ľ�
                            A(:,i)=A(:,i)*0;
                            A(i,:)=A(i,:)*0;
                            A(i,i)=1;      
                        case 2      %���սڵ������ľ�
                            A(:,Node(1,i))=A(:,Node(1,i))*0;
                            A(Node(1,i),:)=A(Node(1,i),:)*0;
                            A(Node(1,i),Node(1,i))=1;
                        case 3      %���ͺͽ��սڵ������ľ�
                            A(:,i)=A(:,i)*0;
                            A(i,:)=A(i,:)*0;
                            A(i,i)=1;
                            A(:,Node(1,i))=A(:,Node(1,i))*0;
                            A(Node(1,i),:)=A(Node(1,i),:)*0;
                            A(Node(1,i),Node(1,i))=1;
                    end
                    %�޸����Ӿ���
                end 
                
                %����������ȼ���·�ɣ���Ҫ�ж��ܼ��仯
                if Mode==1                    
                    %�жϽ��սڵ���ܼ��仯
                    if Node(1,i)~=1
                        Node(6,Node(1,i))=ceil(K*Node(5,Node(1,i))/E0);
                        if Node(6,Node(1,i))<Node(7,Node(1,i))
                            State_change=1;
                            Node(7,Node(1,i))=Node(6,Node(1,i));
                        end
                    end
                    %�жϷ��ͽڵ���ܼ��仯
                    Node(6,i)=ceil(K*Node(5,i)/E0);
                    if Node(6,i)<Node(7,i)
                        State_change=1;
                        Node(7,i)=Node(6,i);
                    end                    
                end
                %����������ȼ���·�ɣ���Ҫ�ж��ܼ��仯
                
            end            
            %%��ɷ���
        end
    end    

    if Mode==3&&mod(t,2000)==0
        State_change=1;
    end
    
    if Mode==4&&mod(t,Round)==0
        State_change=1;
    end   
    
    if State_change==1;
        State_change=0;
        Routing(Mode); 
    end

    %ͳ������������
    if mod(t,1000)==0
        R_T=R_T+1;
        R_E(R_T,1)=t;
        R_E(R_T,2)=(N-1)*E0-sum(Node(5,2:N));
    end
        %��ȡt=20000ʱ�̵Ľڵ���Ϣ
    if t==20000
        Node2=Node;
    end

end
