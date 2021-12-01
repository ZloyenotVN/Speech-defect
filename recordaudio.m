
function [y]=recordaudio(Fs,bits,num_channels,numofmicrophone, t_record, play_audio, path)

%записываем звук на комп

%Fs=48000; %частота дискретизации звука при переводе в цифру
recorder = audiorecorder(Fs,bits,num_channels,numofmicrophone); % 24 бита - это мы квантуем сигнал в цифру
% 1 - это сколько каналов (если стерео сигнал, то 2 канала). Еще 1 - это
% номер микрофона
disp('Start speaking...');

recordblocking(recorder,t_record); %функция записи, t сек записывает

disp('End of recording.');
%     if play_audio==0
%         play(recorder); %можно прослушать
%     end
    
y = getaudiodata(recorder); % переводим созданный объект в массив, где значение это амплитуда сигнала, а число знасчений это число samples, получившихся в результате квантования
    if play_audio==0
        sound(y,Fs,bits); %можно прослушать
    end

%записываем звук в файл
audiowrite(path, y, Fs); % сохраняет в wav файл твой цифровой массив звука с заданной частотой дискретизации



end
