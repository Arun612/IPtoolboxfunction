funcprot(0);
exec('bwmorph.sci', -1);

disp("---- Test 1: Basic Shape ----");
BW = zeros(10,10);
BW(4:6,4:6) = 1;

dil = bwmorph(BW, "dilate");
ero = bwmorph(BW, "erode");

Matplot(BW*255);
Matplot(dil*255);
Matplot(ero*255);

disp("---- Test 2: Single Pixel ----");
BW2 = zeros(10,10);
BW2(5,5) = 1;

disp("Dilate sum:");
disp(sum(bwmorph(BW2,"dilate"))); 
disp("Erode sum:");
disp(sum(bwmorph(BW2,"erode"))); 
disp("---- Test 3: Open (remove noise) ----");
BW3 = zeros(10,10);
BW3(4:6,4:6) = 1;
BW3(2,2) = 1;

open_img = bwmorph(BW3, "open");
Matplot(open_img*255);

disp("---- Test 4: Close (fill hole) ----");
BW4 = zeros(10,10);
BW4(4:6,4:6) = 1;
BW4(5,5) = 0;

close_img = bwmorph(BW4, "close");
Matplot(close_img*255);