% Matthew Tay
% gui emulator wrapper for color-blind/video 

function simple_gui2()
    % SIMPLE_GUI2 Select a data set from the pop-up menu, then
    % click one of the plot-type push buttons. Clicking the button
    % plots the selected data in the axes.

    %  Create and then hide the GUI as it is being constructed.
    f = figure('Visible','off','Position',[360,500,450,285]);

    % Add pushbuttons
    protan    = uicontrol('Style','pushbutton',...
                 'String','Protanopia','Position',[315,220,70,25]);
    deuter    = uicontrol('Style','pushbutton',...
                 'String','Deuteranopia','Position',[315,180,70,25]);
    tritan = uicontrol('Style','pushbutton',...
                 'String','Tritanopia','Position',[315,135,70,25]);

    % Add popup 
    htext  = uicontrol('Style','text','String','Action',...
               'Position',[325,90,60,15]);
    hpopup = uicontrol('Style','popupmenu',...
               'String',{'Normal Vision','Emulation','Extract Information'},...
               'Position',[300,50,100,25]);        
    % Add axes 
    ha = axes('Units','pixels','Position',[50,60,200,185]);

    % Align components
    align([protan,deuter,tritan,htext,hpopup],'Center','None');

    %Make the GUI visible.
    set(f,'Visible','on');       
end
