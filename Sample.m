clear all


% Fs=48000;
% bits=8;
% num_channels=1;
% numofmicrophone=1;
% t_record=2;
% play_audio=0;% ���� 0 - ����������
path = 'C:\Users\���������\Downloads\export.wav';
% path = 'C:\Users\���������\Desktop\������\����� ��������� �����\�_�.wav';

% [y]=recordaudio(Fs,bits,num_channels,numofmicrophone, t_record, play_audio, path);
% plot(y(1:end))

% Ts=1/Fs;
% t = Ts*length(y) %����� ������������ �����������

[signal,fs] = audioread(path);
