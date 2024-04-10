% mouse press loop test
pause(1);
for i=1:30
    pause(0.5);
    disp(num2str(ismousedpressed));
end
disp('mouse is now unpressed')
