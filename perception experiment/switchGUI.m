function switchGUI(~,~,oldGUI,newGUI)
% hide old GUI
    uistack(oldGUI,'bottom');
    set(oldGUI,'visible','off');
% show new GUI
    uistack(newGUI,'top');
    set(newGUI,'visible','on');

