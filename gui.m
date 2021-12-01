function gui

figure('Menubar', 'None',...
    'Name', 'Gui',...
    'NumberTitle', 'Off')

Button1 = uicontrol('Style', 'Toggle',...
    'String', 'Off', 'Position', [20, 60 , 60, 20],...
    'Callback', @Togglepressed);




function Togglepressed(h, eventdata)
    
    if get(h,'Value')==0
        set(h, 'String', 'Off');
    else
        set(h, 'String', 'On');
    
    end
end
end