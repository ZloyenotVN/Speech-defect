function RunSoundAnalysis(pn1,fn1,pn2,fn2,hTxt3,hTxt4,Captions,SelLang,YesCR)
% Проводит сравнение и анализ двух звуковых файлов,
% находящихся в файлах [pn1 fn1] и [pn2 fn2], рисует результаты
% на осях hAxes и в текстовых метках hTxt3, hTxt4 
% с заголовками Captions на выбранном языке SelLang;
% YesCR=1 - нужно печатать коэффициент корреляции, YesCR=0 - нет.

CRcrit = 0.75; % критическое значение коэффициента корреляции

%проверка на наличие двух файлов
if ((~ischar(fn1))|(~ischar(fn2))) % если файл не выбран, то выходим
  return
end
%=================================

%загрузка исследуемоего аудиофайла
signal=0;
[signal,fs2] = audioread([pn2 fn2]); % ввели 2-й файл (исследуемый)

%строим диаграмму исследуемого аудиофайла
subplot(4,4,1);
plot(signal);
xlim([1 length(signal)]);
title(fn2);
grid on;
%============================

d=length(signal); %цифровая длина исследуемого аудиофайла
tim=1;
i=1;

% Блок обработки; Результат - акустический вектор
while i<d-408
  y=signal(i:i+408);  %интервал речевого сигнала
  x(1)=0.0;
  for j=2:409
    x(j)=y(j)-y(j-1); %корректировка текущего сигнала (дифференциальный фильтр первого порядка)
  end 
  for j=1:408
    z(j)=(0.54-0.46*cos(2*pi*(j-1)/408))*x(j); %Окно Хемминга
  end    
  C=fft(z,512);
  C=abs(C);   % БПФ
  S=C(1:256); % 256 амплитудных значений
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

time=tim-1;  % номер последнего блока или общее количество блоков
normamax=max(norma(1:time));
O(1:time,1:24)= O(1:time,1:24)/normamax; % normalization
% end of signal acoustic preprocessing

% Графики, кроме диаграммы исследуемого аудиофайла
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
 
% повторяем такую же обработку и для эталонного сигнала
signal=0;
%загрузка исследуемоего аудиофайла
[signal,fs1] = audioread([pn1 fn1]); % ввели 1-й файл (образец)

d=length(signal); %цифровая длина эталонного сигнала
tim=1;
i=1;
x=0;
z=0;
% Блок обработки; Результат - акустический вектор
while i<d-408
  y=signal(i:i+408); %интервал речевого сигнала
  x(1)=0.0;
  for j=2:409
    x(j)=y(j)-y(j-1); %корректировка текущего сигнала (дифференциальный фильтр первого порядка)
  end 
  for j=1:409
    z(j)=(0.54-0.46*cos(2*pi*(j-1)/408))*x(j); %Окно Хемминга  
  end  
  C=fft(z,512);
  C=abs(C);   % БПФ
  S=C(1:256); % амплитуда
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

time=tim-1;  % номер последнего блока или общее количество блоков
normamax=max(norma(1:time));
O(1:time,1:24)= O(1:time,1:24)/normamax; % normalization
% end of signal acoustic preprocessing

%Графики для эталонного сигнала
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

%график скаттерограммы
subplot(4,4,14);
sz = 15; %размер кружков
scatter(o_mean,o_mean_1,sz,'filled');
title("Диаграмма рассеяния");
grid on;


CR=corr2(o_mean,o_mean_1); %корреляция между звуками
if (CR<CRcrit)
  s = ['CR < ' sprintf('%4.2f',CRcrit) '. Прослушайте снова '...
    'исследуемый звук, вернитесь в программу записи звука '...
    'и повторно запишите образец звука.'];
else
  s = ['CR >= ' sprintf('%4.2f',CRcrit) '. Звук произнесен правильно.'];
end
if (YesCR>0.5) % нужно печатать коэффициент корреляции
  set(hTxt3,'String',Captions{11,SelLang});
  set(hTxt4,'String',sprintf('CR=%8.5f;\n%s',CR,s));
else % не нужно
  set(hTxt3,'String','');
  set(hTxt4,'String','');
end
return
