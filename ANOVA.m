%ANOVA N-way analysis of variance (ANOVA).
%Batch que sirve para calcular ANOVAS de diferentes caracteristicas de las lesiones de 
%cada uno de los sujetos
%estas caracteristicas ha sido obtenidas por otras funciones y escritas en
%archivos de texto los cuales son guardados dentro de la carpeta ACL
%__________________________________________________________________________
% ESPOL     FIEC & FIMCP    NBL"Neuroimaging & Bioengineering Laboratory"

% Orlando Chancay
% $Id: seg_lesTESIS.m  25-Nov-2013  9:48:13z$
%% region 1

Y1 = [1.16
0.865
1.60
0.632
0.802
0.534
1.38
1.65
0.617
1.48
0.88
0.758
0.797
0.92
1.05
0.647
1.66
0.917
0.933
0.892
0.431
0.634
1.86
0.656
2.14
1.17
0.918
1.2
1.30
0.772
1.31
0.878
1.02
1.30
0.392
0.891
1.71
1.27
1.12
1.09
0.927
1.48
1.67];
%% region 2
Y2 = [0.165
0.201
0.418
0.262
0.1
0.149
0.279
0.348
0.143
0.374
0.125
0.025
0.258
0.147
0.16
0.212
0.193
0.244
0.192
0.23
0.056
0.074
0.176
0.226
0.269
0.141
0.282
0.228
0.239
0.19
0.274
0.302
0.225
0.113
0.052
0.167
0.051
0.311
0.223
0.24
0.282
0.34
0.245];

%% region 3
 Y3 = [0.04
0.021
0.528
0.119
0.034
0.06
0.143
0.112
0.079
0.131
0.097
0.091
0.061
0.236
0.069
0.064
0.42
0.377
0.106
0.078
0.096
0.058
0.307
0.028
0.449
0.199
0.113
0.18
0.158
0.203
0.254
0.33
0.069
0.219
0.128
0.114
0.083
0.223
0.15
0.192
0.064
0.145
0.26];

%% region 4

Y4 = [0.645
0.663
1.87
0.484
0.605
0.595
0.982
1.45
0.343
1.38
0.863
0.244
0.57
0.699
0.718
0.676
1.39
0.788
0.462
0.582
0.354
0.394
1.44
0.653
1.58
1.67
0.608
0.95
0.911
1.03
0.686
0.927
0.662
1.58
0.497
0.725
1.33
1.11
0.764
0.988
0.957
0.668
0.687];



%% region 5

Y5 = [0.093
0.118
0.064
0.026
0.03
0.162
0.116
0.107
0.171
0.101
0.045
0.128
0.055
0.035
0.04
0.039
0.051
0.033
0.13
0.156
0.034
0.021
0.154
0.071
0.063
0.223
0.12
0.053
0.113
0.146
0.045
0.234
0.063
0.241
0.152
0.041
0.229
0.082
0.091
0.122
0.101
0.034
0.042];

%%  grupos

GROUP = [1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
2
2
2
2
2
2
2
2
2
2
2
2
2
3
3
3
3
3
3
3
3
3];

%% fractalidad

Yf = [4.716
5.031
4.769
9.206
5.240
5.157
6.938
4.762
9.019
5.895
7.951
6.370
6.301
6.995
8.528
5.391
5.345
8.207
9.486
6.719
12.791
8.213
4.898
8.381
8.331
5.504
7.853
7.334
4.799
4.760
7.004
10.448
6.522
11.936
8.350
6.963
10.130
7.444
6.844
10.597
7.046
8.029
6.622];

%% VOLUMEN MNI

Yvol_MNI= [9.423
6.183
13.5473
4.617
6.1526
4.8836
8.4679
12.2884
3.537
11.3805
6.6285
4.8195
6.1054
7.1145
6.7399
6.2134
11.6674
7.074
6.1425
6.5711
3.3952
5.022
12.879
4.8971
14.0434
15.147
6.7061
8.2215
8.8931
8.0392
8.3835
7.128
6.5137
10.3241
3.3919
6.8411
12.2108
9.558
8.6096
7.965
7.2832
7.6478
7.8502];

%% cantidad de lesiones

Ycant_NE = [56
51
61
37
51
60
47
68
43
56
34
57
40
50
39
75
70
48
45
64
33
36
77
45
38
58
43
60
71
82
57
37
66
32
64
51
45
66
77
47
53
47
69];

%% cantidad de lesiones MNI

Ycant_MNI = [41
39
48
25
44
45
33
53
28
43
32
40
40
36
30
47
48
31
27
38
20
31
51
30
30
45
32
34
57
57
39
26
42
23
33
39
27
37
40
26
39
34
41];

%% %% fractalidad

Yf_boxcount = [ 2.4793
2.5023
2.5545
2.4603
2.5213
2.5574
2.5552
2.5739
2.5667
2.4745
2.5155
2.5205
2.5619
2.559
2.5092
2.4912
2.5441
2.5505
2.5511
2.4806
2.6496
2.5896
2.5693
2.5016
2.5695
2.5652
2.5492
2.4567
2.5244
2.561
2.4684
2.5649
2.4812
2.4787
2.5012
2.5176
2.5204
2.4425
2.5006
2.5665
2.4833
2.5186
2.5193];

%% intensidad

Y_int = [26.127
29.1081
27.956
28.1505
28.4202
29.0029
29.3243
31.5363
30.4575
28.242
26.6451
32.2233
27.9442
29.7958
30.1988
29.5529
29.157
29.9634
28.0779
31.4869
31.435
26.9049
30.8869
30.9672
28.6973
25.6018
26.9628
30.0267
31.1711
31.2731
30.7284
28.4771
28.788
26.3114
28.4994
29.5926
29.8712
32.7869
32.6715
32.4198
29.6323
28.9688
28.7475];

%%  ANOVAN

[P,T,STATS1,TERMS] = anovan(Y1,GROUP);
figure;
[c,m,h,nms] = multcompare(STATS1,'display','on');
       [nms num2cell(m)]  
%%  ANOVAN

[P,T,STATS2,TERMS] = anovan(Y2,GROUP);
figure;
[c,m,h,nms] = multcompare(STATS2,'display','on');
       [nms num2cell(m)]  
       %%  ANOVAN

[P,T,STATS3,TERMS] = anovan(Y3,GROUP);
figure;
[c,m,h,nms] = multcompare(STATS3,'display','on');
       [nms num2cell(m)]  
       %%  ANOVAN

[P,T,STATS4,TERMS] = anovan(Y4,GROUP);
figure;
[c,m,h,nms] = multcompare(STATS4,'display','on');
       [nms num2cell(m)]  
       %%  ANOVAN

[P,T,STATS5,TERMS] = anovan(Y5,GROUP);
figure;
[c,m,h,nms] = multcompare(STATS5,'display','on');
       [nms num2cell(m)]  
       %% ANOVAN fractal por lesiones
       
       [P,T,STATS5,TERMS] = anovan(Yf,GROUP);
figure;
[c,m,h,nms] = multcompare(STATS5,'display','on');
       [nms num2cell(m)]  

 %% ANOVAN volumen en MNI
 
 [P,T,STATS5,TERMS] = anovan(Yvol_MNI,GROUP);
figure;
[c,m,h,nms] = multcompare(STATS5,'display','on');
       [nms num2cell(m)]  

 %% ANOVAN cantidad en NE
 
 [P,T,STATS5,TERMS] = anovan(Ycant_NE,GROUP);
figure;
[c,m,h,nms] = multcompare(STATS5,'display','on');
       [nms num2cell(m)]  
%% ANOVAN cantidad en MNI
 
 [P,T,STATS5,TERMS] = anovan(Ycant_MNI,GROUP);
figure;
[c,m,h,nms] = multcompare(STATS5,'display','on');
       [nms num2cell(m)]  
  
%% ANOVAN fractalidad boxcount NE
 
 [P,T,STATSfbc,TERMS] = anovan(Yf_boxcount,GROUP);
figure;
[c,m,h,nms] = multcompare(STATSfbc,'display','on');
       [nms num2cell(m)]        

%% ANOVAN fractalidad boxcount NE
 
 [P,T,STATSfbx,TERMS] = anovan(Y_int,GROUP);
figure;
[c,m,h,nms] = multcompare(STATSfbx,'display','on');
       [nms num2cell(m)]               
       
