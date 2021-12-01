function RunSoundAnalysis(pn1,fn1,pn2,fn2,hTxt3,hTxt4,Captions,SelLang,YesCR)
% �������� ��������� � ������ ���� �������� ������,
% ����������� � ������ [pn1 fn1] � [pn2 fn2], ������ ����������
% �� ���� hAxes � � ��������� ������ hTxt3, hTxt4 
% � ����������� Captions �� ��������� ����� SelLang;
% YesCR=1 - ����� �������� ����������� ����������, YesCR=0 - ���.

CRcrit = 0.75; % ����������� �������� ������������ ����������

%�������� �� ������� ���� ������
if ((~ischar(fn1))|(~ischar(fn2))) % ���� ���� �� ������, �� �������
  return
end
%=================================

%�������� ������������� ����������
signal=0;
[signal,fs2] = audioread([pn2 fn2]); % ����� 2-� ���� (�����������)

%������ ��������� ������������ ����������
subplot(4,4,1);
plot(signal);
xlim([1 length(signal)]);
title(fn2);
grid on;
%============================

d=length(signal); %�������� ����� ������������ ����������
tim=1;
i=1;

% ���� ���������; ��������� - ������������ ������
while i<d-408
  y=signal(i:i+408);  %�������� �������� �������
  x(1)=0.0;
  for j=2:409
    x(j)=y(j)-y(j-1); %������������� �������� ������� (���������������� ������ ������� �������)
  end 
  for j=1:408
    z(j)=(0.54-0.46*cos(2*pi*(j-1)/408))*x(j); %���� ��������
  end    
  C=fft(z,512);
  C=abs(C);   % ���
  S=C(1:256); % 256 ����������� ��������
  % binning of 255 spectral values amplitudes, j=2,3,...,256
  f=[0; 74.24; 156.4; 247.2; 347.6; 458.7; 581.6; 717.5; 867.9;...
    1034; 1218; 1422; 1647; 1895; 2171; 2475; 2812; 3184; 3596;...
    4052; 4556; 5113; 5730; 6412; 7166; 8000];
  krok=16000/512;           % krok=31,25
  a(1:26)=0;
  j=2;
  k=1;
  n(1:26)=0;
  h=krok*(j-1); 
  while k<26 
   while and(f(k)<h,h<f(k+1))
     alfa=(h-f(k))/(f(k+1)-f(k));  % interval [f(k),f(k+1)];
     a(k+1)=a(k+1)+S(j)*alfa;
     n(k+1)=n(k+1)+1;
     a(k)=a(k)+S(j)*(1-alfa);
     n(k)=n(k)+1;
     j=j+1;
     h=krok*(j-1);
   end  
   a(k)=a(k)/n(k);
   k=k+1;
  end 
  O(tim,1:24)=a(2:25);
  norma(tim)=norm(O(tim,1:24));
  i=i+160;
  tim=tim+1; % next block 
end % end of block proccesing

time=tim-1;  % ����� ���������� ����� ��� ����� ���������� ������
normamax=max(norma(1:time));
O(1:time,1:24)= O(1:time,1:24)/normamax; % normalization
% end of signal acoustic preprocessing

% �������, ����� ��������� ������������ ����������
subplot(4,4,2);
plot(y);
xlim([1 length(y)]);
title(Captions{5,SelLang});
grid on;

subplot(4,4,3);
plot(x);
xlim([1 length(x)]);
title(Captions{6,SelLang});
grid on;

subplot(4,4,5);
plot(z);
xlim([1 length(z)]);
title(Captions{7,SelLang}); 
grid on;

subplot(4,4,6);
plot(C);
xlim([1 length(C)]);
title(Captions{8,SelLang}); 
grid on;

subplot(4,4,7);
plot(S);
xlim([1 length(S)]);
title(Captions{9,SelLang}); 
grid on;

subplot(4,4,9);
plot(O(time-5,1:24),'--*');
xlim([1 length(O(time-5,1:24))]);
title(Captions{10,SelLang});
grid on;
%===============================

Nmin = time/2 - 7;
Nmax = time/2 + 7;
o1(:,1:24) = O(Nmin:Nmax,1:24);
o_mean = mean(o1);
 
% ��������� ����� �� ��������� � ��� ���������� �������
signal=0;
%�������� ������������� ����������
[signal,fs1] = audioread([pn1 fn1]); % ����� 1-� ���� (�������)

d=length(signal); %�������� ����� ���������� �������
tim=1;
i=1;
x=0;
z=0;
% ���� ���������; ��������� - ������������ ������
while i<d-408
  y=signal(i:i+408); %�������� �������� �������
  x(1)=0.0;
  for j=2:409
    x(j)=y(j)-y(j-1); %������������� �������� ������� (���������������� ������ ������� �������)
  end 
  for j=1:409
    z(j)=(0.54-0.46*cos(2*pi*(j-1)/408))*x(j); %���� ��������  
  end  
  C=fft(z,512);
  C=abs(C);   % ���
  S=C(1:256); % ���������
  % binning of 255 spectral values amplitudes, j=2,3,...,256
  f=[0; 74.24; 156.4; 247.2; 347.6; 458.7; 581.6; 717.5; 867.9;...
    1034; 1218; 1422; 1647; 1895; 2171; 2475; 2812; 3184; 3596;...
    4052; 4556; 5113; 5730; 6412; 7166; 8000];
  krok=16000/512;           % krok=31,25
  a(1:26)=0;
  j=2;
  k=1;
  n(1:26)=0;
  h=krok*(j-1); 
  while k<26 
   while and(f(k)<h,h<f(k+1))
     alfa=(h-f(k))/(f(k+1)-f(k));  % interval [f(k),f(k+1)];
     a(k+1)=a(k+1)+S(j)*alfa;
     n(k+1)=n(k+1)+1;
     a(k)=a(k)+S(j)*(1-alfa);
     n(k)=n(k)+1;
     j=j+1;
     h=krok*(j-1);
   end  
   a(k)=a(k)/n(k);
   k=k+1;
  end 
  O(tim,1:24)=a(2:25);
  norma(tim)=norm(O(tim,1:24));
  i=i+160;
  tim=tim+1; % next block 
end % end of block proccesing

time=tim-1;  % ����� ���������� ����� ��� ����� ���������� ������
normamax=max(norma(1:time));
O(1:time,1:24)= O(1:time,1:24)/normamax; % normalization
% end of signal acoustic preprocessing

%������� ��� ���������� �������
subplot(4,4,10);
plot(y);
xlim([1 length(y)]);
title(Captions{16,SelLang});
grid on;

subplot(4,4,11);
plot(S);
xlim([1 length(S)]);
title(Captions{17,SelLang}); 
grid on;

subplot(4,4,13);
plot(O(time-5,1:24),'--*');
xlim([1 length(O(time-5,1:24))]);
title(Captions{18,SelLang});
grid on;
%==============================

Nmin = time/2 - 7;
Nmax = time/2 + 7;
o1(:,1:24) = O(Nmin:Nmax,1:24);
o_mean_1 = mean(o1);

%������ ��������������
subplot(4,4,14);
sz = 15; %������ �������
scatter(o_mean,o_mean_1,sz,'filled');
title("��������� ���������");
grid on;


CR=corr2(o_mean,o_mean_1); %���������� ����� �������
if (CR<CRcrit)
  s = ['CR < ' sprintf('%4.2f',CRcrit) '. ����������� ����� '...
    '����������� ����, ��������� � ��������� ������ ����� '...
    '� �������� �������� ������� �����.'];
else
  s = ['CR >= ' sprintf('%4.2f',CRcrit) '. ���� ���������� ���������.'];
end
if (YesCR>0.5) % ����� �������� ����������� ����������
  set(hTxt3,'String',Captions{11,SelLang});
  set(hTxt4,'String',sprintf('CR=%8.5f;\n%s',CR,s));
else % �� �����
  set(hTxt3,'String','');
  set(hTxt4,'String','');
end
return
