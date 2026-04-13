funcprot(0);
exec('stretchlim.sci', -1);

disp("---- Test 1: Random ----");
img1 = grand(100,100,'uin',0,255);
disp(stretchlim(img1));

disp("---- Test 2: Black ----");
img2 = zeros(100,100);
disp(stretchlim(img2));

disp("---- Test 3: White ----");
img3 = ones(100,100)*255;
disp(stretchlim(img3));

disp("---- Test 4: Gradient ----");
img4 = repmat(0:99,100,1);
disp(stretchlim(img4));