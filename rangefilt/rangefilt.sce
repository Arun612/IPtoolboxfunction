// Load your function
exec('rangefilt.sci', -1);

disp("---- Test 1: Random Image ----");
img1 = grand(100,100,'uin',0,255);
out1 = rangefilt(img1);
disp(max(out1));

disp("---- Test 2: Black Image ----");
img2 = zeros(100,100);
out2 = rangefilt(img2);
disp(max(out2));  // should be 0

disp("---- Test 3: White Image ----");
img3 = ones(100,100)*255;
out3 = rangefilt(img3);
disp(max(out3));  // should be 0

disp("---- Test 4: Gradient ----");
img4 = repmat(0:99,100,1);
out4 = rangefilt(img4);
disp([min(out4), max(out4)]);
Matplot(out4);