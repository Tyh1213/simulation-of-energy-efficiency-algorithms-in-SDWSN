function [d]=Distance(Src,Dest)

global P;    %�ڵ�λ��

d=sqrt((P(Src,1)-P(Dest,1))^2+(P(Src,2)-P(Dest,2))^2);
