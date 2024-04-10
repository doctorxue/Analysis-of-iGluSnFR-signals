function MouseButtonEvents
    hFig = figure;
    set(hFig,'WindowButtonDownFcn',   @mouseDownCallback, ...
             'WindowButtonUpFcn',     @mouseUpCallback); 
    function mouseDownCallback(~,~)
        fprintf('mouse button is down!\n');
    end
    function mouseUpCallback(~,~)
        fprintf('mouse button is up!\n');
    end
 end