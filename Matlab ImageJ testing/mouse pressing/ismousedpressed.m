function keypressed = ismousedpressed()
% keypressed = ismousedpressed()
% returns
%   0 no button is pressed
%   1 is left button
%   2 is right button
%   3 is scroll button push (not scrolling)
% Restriction: Windows only
% TIP: call ismousedpressed() once when your app start
%      so that when really needed; ismousedpressed() returns result faster.
%
% Author: Mbvalentin
% https://www.mathworks.com/matlabcentral/fileexchange/61976-check-if-mouse-button-is-pressed
% Modified by Bruno Luong
if ~libisloaded('user32')
                try
                loadlibrary('C:\WINDOWS\system32\user32.dll', 'user32.h');
                catch
            % user.h is removed on certain recent version of Windows
            % We replace with a simple customized header file 
                here = fileparts(mfilename('fullpath'));
                loadlibrary('C:\WINDOWS\system32\user32.dll', [here '\WinMouse.h']);
                end
            end

keypressed = calllib('user32','GetAsyncKeyState',int32(1));
end % ismousedpressed