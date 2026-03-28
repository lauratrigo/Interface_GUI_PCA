function [LonG, LatG, Z, lat_pts, lon_pts] = calcularPCAApp(matrix_list, names_master, estacoes_ativas, nEOF)
% calcularPCAApp - calcula PCA e retorna EOF1 simetrizado pronto para plot
%
% Inputs:
%   matrix_list   - matriz de dados (linhas=tempo, colunas=estações)
%   nomes_totais  - célula com todos os nomes das estações
%   estações_ativas - célula com estações selecionadas
%
% Outputs:
%   lat_all, lon_all - coordenadas simetrizadas
%   eof_all          - EOF1 simetrizado

    % -------------------------
    % Coordenadas originais
    % -------------------------
    coords = [
       -9.749  -36.653;   % ALAR
      -11.306  -41.859;   % BAIR
      -17.555  -39.743;   % BATF
      -14.888  -40.803;   % BAVC
       -1.409  -48.463;   % BELE
        2.845  -60.701;   % BOAV
      -15.947  -47.878;   % BRAZ
       -3.877  -38.426;   % BRFT
       -3.878  -38.426;   % CEEU
      -20.311  -40.319;   % CEFE
       -3.711  -38.473;   % CEFT
      -22.687  -44.985;   % CHPI
      -15.555  -56.070;   % CUIB
      -17.883  -51.726;   % GOJA
      -20.428  -51.343;   % ILHA
      -28.235  -48.656;   % IMBT
       -5.492  -47.497;   % IMPZ
       -5.362  -49.122;   % MABA
      -19.942  -43.925;   % MGBH
      -22.319  -46.328;   % MGIN
      -16.716  -43.858;   % MGMC
      -19.210  -46.133;   % MGRP
      -18.919  -48.256;   % MGUB
      -20.441  -54.541;   % MSCG
      -13.556  -52.271;   % MTCN
      -10.804  -55.456;   % MTCO
      -11.619  -50.664;   % MTSF
      -12.545  -55.727;   % MTSR
       -3.023  -60.055;   % NAUS
      -25.020  -47.925;   % NEIA
      -22.896  -43.224;   % ONRJ
       -4.288  -56.036;   % PAIT
       -7.214  -35.907;   % PBCG
       -9.384  -40.506;   % PEPE
       -9.031  -42.703;   % PISR
       -5.102  -42.793;   % PITN
      -30.074  -51.120;   % POAL
      -22.318  -44.327;   % POLI
       -8.709  -63.896;   % POVE
      -22.120  -51.409;   % PPTE
      -25.384  -51.488;   % PRGU
      -23.410  -51.938;   % PRMA
       -9.965  -67.803;   % RIOB
      -22.818  -43.306;   % RIOD
      -21.765  -41.326;   % RJCG
       -5.204  -37.325;   % RNMO
       -5.836  -35.208;   % RNNA
      -13.122  -60.544;   % ROCD
      -10.784  -65.331;   % ROGM
      -10.864  -61.960;   % ROJI
      -22.523  -52.952;   % ROSA
       -0.144  -67.058;   % SAGA
      -12.975  -38.516;   % SALU
      -12.939  -38.432;   % SAVO
      -27.138  -52.600;   % SCCH
      -27.793  -50.304;   % SCLA
      -20.786  -49.360;   % SJRP
      -29.719  -53.717;   % SMAR
      -21.185  -50.440;   % SPAR
      -12.975  -38.516;   % SSA1
      -11.747  -49.049;   % TOGU
      -10.171  -48.331;   % TOPL
      -25.448  -49.231;   % UFPR
      -20.762  -42.870;   % VICO
    ];

    lat = coords(:,1);
    lon = coords(:,2);

    % -------------------------
    % Remover estações inativas
    % -------------------------
    idx_remove = ~ismember(names_master, estacoes_ativas);
    lat(idx_remove) = [];
    lon(idx_remove) = [];
    matrix_list(:, idx_remove) = [];

    % Substituir NaN por 0
    matrix_list(isnan(matrix_list)) = 0; %alterar para substituir por als

    % -------------------------
    % PCA
    % -------------------------
    [coeff, score, latent, tsquared, explained] = pca(matrix_list, 'Algorithm','als', 'Centered', true);
    if nargin < 4 || nEOF < 1 || nEOF > size(coeff,2)
        nEOF = 1; % default EOF1
    end
    eof_val = coeff(:, nEOF);

    % -------------------------
    % Simetrização
    % -------------------------
    lat_all = [lat; lat; abs(lat); abs(lat); lat; abs(lat)+2*min(lat); abs(lat)+2*min(lat); abs(lat); abs(lat)+2*min(lat)];
    lon_all = [lon; abs(lon)+2*max(lon); lon; abs(lon)+2*max(lon); abs(lon)+2*min(lon); lon; abs(lon)+2*max(lon); abs(lon)+2*min(lon); abs(lon)+2*min(lon)];
    eof_all = repmat(eof_val, 9, 1);

    % -------------------------
    % Criar grade de interpolação
    % -------------------------
    lon_vec = linspace(min(lon_all)-1, max(lon_all)+1, 400);
    lat_vec = linspace(min(lat_all)-1, max(lat_all)+1, 400);
    [LonG, LatG] = meshgrid(lon_vec, lat_vec);
    Z = griddata(lon_all, lat_all, eof_all, LonG, LatG, 'natural');
    
    lat_pts = lat;
    lon_pts = lon;

end