function Routing(Mode)
global Node;
global A;
global E0;
N=length(A);
switch Mode
    case 0 %���·������
        for i=2:1:N
            path=Dijkstra(A,1,i);
            Node(1,i)=path(2);
            if path(2)~=0
                Node(2,i)=Distance(path(2),i);
            end
        end
    case 1 %�����ռ�MES
        for i=2:1:N
            found=0;
            if Node(7,i)==0 %�ڵ������ľ�����Ҫ��Ѱ·
                Node(1,i)=0;
                continue;
            end
            for k=Node(7,1):-1:1 %���ν���������ռ�Ľڵ���ӵ������в�����·��
                As=A;
                for j=2:1:N %�ҵ����е�k�����ռ�һ�µĽڵ㣬������ISL��Ϊ��Ч���õ���ǰ��As
                    if Node(7,j)<k&&j~=i
                        As(:,j)=As(:,j)*0;
                        As(j,:)=As(j,:)*0;
                        As(j,j)=1;
                    end
                end
                path=Dijkstra(As,1,i);
                if path(2)~=0
                    Node(1,i)=path(2);
                    Node(2,i)=Distance(path(2),i);
                    found=1;
                    if k<Node(7,i)
                        Node(7,i)=k;
                    end
                    break;
                end
            end
            if found==0 %�����ڵ�
                Node(7,i)=0;
                Node(1,i)=0;
            end
        end                
    case 2 %E-TORA
        for i=2:1:N
            if Node(5,i)<=0 %�ڵ������ľ�
                Node(1,i)=0;
                continue;
            end
            temp=Node(10,i);
            found=0;
            for j=1:1:N
                if Distance(i,j)<150&&Node(10,j)<temp&&i~=j&&Node(5,j)>0%�ڵ�֮�����С�ڰ뾶150,�Ҿ��и�С�ĸ߶�
                    temp=Node(10,j);
                    Node(1,i)=j;
                    Node(2,i)=Distance(i,j);
                    found=1;%��ʾ�ҵ���·��
                end
            end
            if found==0
                Node(1,i)=0;
            end
        end
     case 3 %������֪
%          Ac=A;
%          E0=5;
%          for i=2:1:N
%              for j=1:1:N
%                  if Ac(i,j)>=1
%                      Ac(i,j)=Ac(i,j)+1-Node(5,i)/E0;
%                  end
%              end
%          end
%          for i=2:1:N
%             path=Dijkstra(Ac,1,i);
%             Node(1,i)=path(2);
%             if path(2)~=0
%                 Node(2,i)=Distance(path(2),i);
%             end
%          end            
         Ac=A;
         for i=2:1:N
             if Node(5,i)/E0<0.5
                 Ac(:,i)=Ac(:,i)*0;
                 Ac(i,:)=Ac(i,:)*0;
                 Ac(i,i)=1;
             end
         end
         for i=2:1:N
            path=Dijkstra(Ac,1,i);
            Node(1,i)=path(2);
            if path(2)==0
                path=Dijkstra(A,1,i);
                Node(1,i)=path(2);
                if path(2)~=0
                    Node(2,i)=Distance(path(2),i);
                end
            else
                Node(2,i)=Distance(path(2),i);
            end
         end
        
        
end


