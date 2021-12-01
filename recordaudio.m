
function [y]=recordaudio(Fs,bits,num_channels,numofmicrophone, t_record, play_audio, path)

%���������� ���� �� ����

%Fs=48000; %������� ������������� ����� ��� �������� � �����
recorder = audiorecorder(Fs,bits,num_channels,numofmicrophone); % 24 ���� - ��� �� �������� ������ � �����
% 1 - ��� ������� ������� (���� ������ ������, �� 2 ������). ��� 1 - ���
% ����� ���������
disp('Start speaking...');

recordblocking(recorder,t_record); %������� ������, t ��� ����������

disp('End of recording.');
%     if play_audio==0
%         play(recorder); %����� ����������
%     end
    
y = getaudiodata(recorder); % ��������� ��������� ������ � ������, ��� �������� ��� ��������� �������, � ����� ��������� ��� ����� samples, ������������ � ���������� �����������
    if play_audio==0
        sound(y,Fs,bits); %����� ����������
    end

%���������� ���� � ����
audiowrite(path, y, Fs); % ��������� � wav ���� ���� �������� ������ ����� � �������� �������� �������������



end
